# Star Schema Design: FlexiMart Data Warehouse

## Section 1: Schema Overview

### FACT TABLE: fact_sales
**Grain**: One row per product per order line item.
**Business Process**: Captures sales transactions for historical analysis.

**Measures (Numeric Facts)**:
- `quantity_sold`: Number of units sold in the transaction.
- `unit_price`: Price per unit set at the time of sale.
- `discount_amount`: Total discount applied to the line item.
- `total_amount`: Final revenue calculated as (quantity * unit_price - discount).

**Foreign Keys**:
- `date_key` -> `dim_date`
- `product_key` -> `dim_product`
- `customer_key` -> `dim_customer`

---

### DIMENSION TABLE: dim_date
**Purpose**: Date dimension for time-series analysis (Yearly/Monthly trends).
**Type**: Conformed dimension across the warehouse.
**Attributes**:
- `date_key` (PK): Surrogate key (integer format: YYYYMMDD).
- `full_date`: The actual date object.
- `day_of_week`: String name (Monday, Tuesday, etc.).
- `month`: Numeric month (1-12).
- `month_name`: Full month name (January, February...).
- `quarter`: Q1, Q2, Q3, or Q4.
- `year`: The calendar year.
- `is_weekend`: Boolean flag for weekend analysis.

---

### DIMENSION TABLE: dim_product
**Purpose**: Detailed attributes for all products sold.
**Attributes**:
- `product_key` (PK): Surrogate ID.
- `product_id`: The original SKU code.
- `product_name`: Full name of the product.
- `category`: Primary category (Electronics, Fashion).
- `subcategory`: More granular grouping.
- `unit_price`: Current standard unit price.

---

### DIMENSION TABLE: dim_customer
**Purpose**: Customer demographics for segmentation.
**Attributes**:
- `customer_key` (PK): Surrogate ID.
- `customer_id`: Original system ID.
- `customer_name`: Full name.
- `city`: Residence city.
- `state`: Residence state.
- `customer_segment`: Marketing tag (e.g., High Value).

---

## Section 2: Design Decisions (approx. 150 words)

Choosing the **Transaction Line-Item** as our grain was a deliberate decision to ensure maximum flexibility. By capturing data at the lowest possible level (each specific product in an order), we preserve the ability to aggregate data upwards to any level—be it by category, by city, or by quarter. If we had aggregated at the order level, we would have lost the ability to see which specific products sell best in specific regions.

We also opted for **Surrogate Keys** (integers like `product_key`) instead of using natural keys (like a string SKU `ELEC001`). Natural keys can change if the business restructures its coding system, which would break our historical warehouse records. Surrogate keys provide a stable, high-performance join mechanism that is independent of source system changes. This design perfectly supports **Drill-down** operations (e.g., starting at Year and moving into Month) and **Roll-up** operations (e.g., summing city sales to see State-level performance) because the central Fact table acts as the "glue" between these descriptive dimensions.

---

## Section 3: Sample Data Flow

**Source Transaction**:
Order #101, Customer "John Doe", Product "Laptop", Qty: 2, Price: 50000

**Becomes in Data Warehouse**:

**fact_sales**:
```json
{
  "sale_key": 1,
  "date_key": 20240115,
  "product_key": 5,
  "customer_key": 12,
  "quantity_sold": 2,
  "unit_price": 50000,
  "total_amount": 100000
}
```

**dim_date**: `{ "date_key": 20240115, "full_date": "2024-01-15", "month": 1, "quarter": "Q1", ... }`
**dim_product**: `{ "product_key": 5, "product_name": "Laptop", "category": "Electronics", ... }`
**dim_customer**: `{ "customer_key": 12, "customer_name": "John Doe", "city": "Mumbai", ... }`
