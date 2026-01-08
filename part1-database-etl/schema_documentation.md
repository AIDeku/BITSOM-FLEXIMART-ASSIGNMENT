# Schema Documentation: FlexiMart Database

## Entity-Relationship Description

### ENTITY: customers
**Purpose**: Stores unique customer profile information.
**Attributes**:
- `customer_id`: Unique identifier (Primary Key, Auto-increment).
- `first_name`: Customer's given name.
- `last_name`: Customer's family name.
- `email`: Unique email address (Used for login/communication).
- `phone`: Standardized contact number.
- `city`: Current primary residence city.
- `registration_date`: Date the account was created.
**Relationships**: One customer can place multiple orders (1:M).

### ENTITY: products
**Purpose**: Catalog of items available for sale.
**Attributes**:
- `product_id`: Unique identifier (Primary Key, Auto-increment).
- `product_name`: Title of the product.
- `category`: Grouping (Electronics, Fashion, Groceries).
- `price`: Standard unit cost.
- `stock_quantity`: Current inventory level.
**Relationships**: Integrated into multiple order items (1:M).

### ENTITY: orders
**Purpose**: Transaction headers for customer purchases.
**Attributes**:
- `order_id`: Unique identifier (Primary Key, Auto-increment).
- `customer_id`: Link to the customer entity (Foreign Key).
- `order_date`: Date of the transaction.
- `total_amount`: Total value of the entire order.
- `status`: Lifecycle stage (Pending, Completed, Cancelled).
**Relationships**: Contains multiple line items (1:M).

### ENTITY: order_items
**Purpose**: Line-item details of specific product quantities in an order.
**Attributes**:
- `order_item_id`: Unique identifier (Primary Key, Auto-increment).
- `order_id`: Link to the order header (Foreign Key).
- `product_id`: Link to the product sold (Foreign Key).
- `quantity`: Number of items purchased.
- `unit_price`: Price per unit at the time of sale.
- `subtotal`: Derived value (quantity * unit_price).

---

## Normalization Explanation (3rd Normal Form)

The FlexiMart database design strictly adheres to the principles of the **Third Normal Form (3NF)** to ensure data integrity and eliminate redundancy. To reach 3NF, a schema must first satisfy 1NF (atomic values) and 2NF (no partial dependencies).

In our design, every table has a primary key (`customer_id`, `product_id`, etc.), ensuring all values are atomic and uniqueness is maintained. In the `orders` table, the `total_amount` depends entirely on the `order_id` (the whole key), satisfying 2NF. 

The move to 3NF specifically requires that there are no **transitive dependencies**—meaning non-key attributes must only depend on the primary key, not on other non-key attributes. For example, in the `customers` table, the `phone` and `city` depend directly on the `customer_id`. We haven't stored city-state mappings in this table because `state` would depend on `city`, which is a transitive dependency that would violate 3NF.

**Functional Dependencies Identified:**
1. `customer_id` -> `first_name`, `last_name`, `email`, `phone`, `city`
2. `product_id` -> `product_name`, `category`, `price`
3. `order_id` -> `customer_id`, `order_date`, `total_amount`, `status`
4. `order_item_id` -> `order_id`, `product_id`, `quantity`, `unit_price`

This design avoids **Update Anomalies** (e.g., if a product price changes, we update one row in `products`, not every historical order), **Insert Anomalies** (we can add a product without needing an order), and **Delete Anomalies** (deleting an order doesn't accidentally erase a product's existence from the catalog).

---

## Sample Data Representation

### Table: customers
| customer_id | first_name | last_name | email | phone | city |
|---|---|---|---|---|---|
| 1 | Rahul | Sharma | rahul.sharma@gmail.com | +91-9876543210 | Bangalore |
| 2 | Priya | Patel | priya.patel@yahoo.com | +91-9988776655 | Mumbai |

### Table: products
| product_id | product_name | category | price | stock_quantity |
|---|---|---|---|---|
| 1 | Samsung Galaxy S21 | Electronics | 45999.00 | 150 |
| 2 | Nike Running Shoes | Fashion | 3499.00 | 80 |

### Table: orders
| order_id | customer_id | order_date | total_amount | status |
|---|---|---|---|---|
| 1 | 1 | 2024-01-15 | 45999.00 | Completed |
| 2 | 2 | 2024-01-16 | 2999.00 | Completed |
