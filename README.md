# FlexiMart Data Architecture Project

**Student Name:** Aditya Singh
**Student ID:** bitsom_ba_25071343
**Email:** adityasingh2005@gmail.com
**Date:** January 8, 2026

## Project Overview

I have built a complete data architecture for FlexiMart, including a MySQL relational database with a Python ETL pipeline to clean "dirty" data, a NoSQL product catalog using MongoDB for flexible data, and a Star Schema Data Warehouse for historical sales analytics.

## Repository Structure
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md

## Technologies Used

- Python 3.x, pandas, mysql-connector-python
- MySQL 8.0 / PostgreSQL 14
- MongoDB 6.0

## Setup Instructions

### Database Setup

```bash
# Create databases
mysql -u root -p -e "CREATE DATABASE fleximart;"
mysql -u root -p -e "CREATE DATABASE fleximart_dw;"

# Run Part 1 - ETL Pipeline
python part1-database-etl/etl_pipeline.py

# Run Part 1 - Business Queries
mysql -u root -p fleximart < part1-database-etl/business_queries.sql

# Run Part 3 - Data Warehouse
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_schema.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_data.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/analytics_queries.sql
```

### MongoDB Setup

```bash
mongosh < part2-nosql/mongodb_operations.js
```

## Key Learnings

Building this project taught me how to handle real-world "dirty" data and the importance of normalization in RDBMS vs. embedding in NoSQL. I learned how to design a Star Schema to optimize analytical queries and how a Python-based ETL pipeline can effectively bridge the gap between flat CSV files and structured databases.

## Challenges Faced

1. **Inconsistent Data Formats**: The raw data had mixed date and phone formats, which I solved by using the `dateutil` parser and regular expressions for standardization.
2. **Surrogate Key Mapping**: Mapping raw string IDs (like C001) to database integer keys required careful dictionary mapping within the ETL loop to maintain relational integrity.
