import pandas as pd
import mysql.connector
from mysql.connector import Error
from dateutil import parser
import re
from pathlib import Path

# --- CONFIGURATION ---
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "password",
    "database": "fleximart"
}
DATA_DIR = Path("data")
REPORT_PATH = Path("part1-database-etl/data_quality_report.txt")

# --- TOOLS ---
def clean_phone(phone):
    if pd.isna(phone): return None
    digits = ''.join(filter(str.isdigit, str(phone)))
    return f"+91-{digits[-10:]}" if len(digits) >= 10 else None

def clean_date(val):
    try: return parser.parse(str(val)).date().isoformat()
    except: return None

def run_etl():
    print("Starting simplified ETL...")
    stats = {"cust": 0, "prod": 0, "sales": 0}

    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()

        # 1. Extract
        df_c = pd.read_csv(DATA_DIR / "customers_raw.csv")
        df_p = pd.read_csv(DATA_DIR / "products_raw.csv")
        df_s = pd.read_csv(DATA_DIR / "sales_raw.csv")

        # 2. Cleanup & Sync Tables
        cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")
        for t in ["order_items", "orders", "products", "customers"]:
            cursor.execute(f"TRUNCATE TABLE {t};")
        cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")

        # 3. Process Customers
        df_c.drop_duplicates(inplace=True)
        cust_map = {}
        for _, r in df_c.iterrows():
            email = r['email'] if pd.notna(r['email']) else f"{r['first_name'].lower()}@fleximart.com"
            cursor.execute("""
                INSERT INTO customers (first_name, last_name, email, phone, city, registration_date)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (r['first_name'], r['last_name'], email, clean_phone(r['phone']), r['city'], clean_date(r['registration_date'])))
            cust_map[r['customer_id']] = cursor.lastrowid
        stats["cust"] = len(df_c)

        # 4. Process Products
        df_p.drop_duplicates(inplace=True)
        prod_map = {}
        for _, r in df_p.iterrows():
            price = r['price'] if pd.notna(r['price']) else 999.0 # Default price
            cursor.execute("""
                INSERT INTO products (product_name, category, price, stock_quantity)
                VALUES (%s, %s, %s, %s)
            """, (r['product_name'], r['category'].title(), float(price), int(pd.NA if pd.isna(r['stock_quantity']) else r['stock_quantity']) or 0))
            prod_map[r['product_id']] = cursor.lastrowid
        stats["prod"] = len(df_p)

        # 5. Process Sales (Orders & Items)
        df_s.drop_duplicates(inplace=True)
        df_s.dropna(subset=['customer_id', 'product_id'], inplace=True)
        
        # Group by transaction to create a single order
        for tid, group in df_s.groupby('transaction_id'):
            c_id = cust_map.get(group.iloc[0]['customer_id'])
            if not c_id: continue

            # Insert Order Header
            order_total = (group['quantity'] * group['unit_price']).sum()
            cursor.execute("""
                INSERT INTO orders (customer_id, order_date, total_amount, status)
                VALUES (%s, %s, %s, %s)
            """, (c_id, clean_date(group.iloc[0]['transaction_date']), float(order_total), group.iloc[0]['status']))
            new_order_id = cursor.lastrowid

            # Insert Order Items
            for _, sr in group.iterrows():
                p_id = prod_map.get(sr['product_id'])
                if p_id:
                    cursor.execute("""
                        INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (new_order_id, p_id, int(sr['quantity']), float(sr['unit_price']), float(sr['quantity'] * sr['unit_price'])))
            stats["sales"] += 1

        conn.commit()
        
        # Generate Report
        with open(REPORT_PATH, "w") as f:
            f.write(f"ETL SUMMARY\n-----------\n")
            f.write(f"Customers Loaded: {stats['cust']}\n")
            f.write(f"Products Loaded: {stats['prod']}\n")
            f.write(f"Orders Created: {stats['sales']}\n")

        print(f"ETL Complete. Loaded {stats['sales']} orders.")

    except Error as e:
        print(f"Error: {e}")
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    run_etl()
