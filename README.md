# SQL-Data-WareHouse-Project

## 📖 Overview

A comprehensive end-to-end data warehousing solution, following the Medallion Architecture (Bronze → Silver → Gold). This project demonstrates industry best practices in data engineering and analytics — from ingesting raw source data all the way through to a business-ready star schema model.
## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL Server | Core database engine for the data warehouse |
| T-SQL | Writing DDL, ETL logic, and transformation scripts |
| draw.io | Designing architecture and data model diagrams |
| Git & GitHub | Version control and project hosting |

## 📂 Repository Structure

```
SQL-Data-WareHouse-Project-
│
├── Diagrams/                          # Architecture and data model diagrams
│
├── Script/
│   ├── bronze/                         # Raw data load scripts
│   │   ├── creates database and schema.sql
│   │   ├── ddl_bronze_table_creation.sql
│   │   └── load_bronze.sql
│   │
│   ├── Silver/                         # Cleansing and transformation scripts
│   │   ├── Load/
│   │   ├── Store_p_load_silver.sql
│   │   └── ddl_silver.sql
│   │
│   └── Gold/                           # Star schema views
│       ├── load scripts/
│       └── gold_veiw_load.sql
│
├── datasets/
│   ├── source_crm/                     # CRM source CSVs
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── source_erp/                     # ERP source CSVs
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── LICENSE
└── README.md
```

## 🏛️ Data Architecture

![Data Architecture](Diagrams/Higher%20Architecture%20diagram.jpg)

This project follows the **Medallion Architecture** with three structured layers:

### Bronze Layer
Stores raw data exactly as it comes from the source systems with no transformations applied. Loaded via `BULK INSERT` from CSV files into SQL Server tables.

### Silver Layer
This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.

### Gold Layer
This layers contains Business-ready views modelled as a Star Schema

![Data Model](Diagrams/Data%20model.jpg)

## 📜 License
This project is licensed under the MIT License.

## 👤 About Me

My name Uchenna, a data professional based in Nigeria, 
building expertise across Data Engineering and Data Analytics.

I work across the full data stack — from writing ETL pipelines and 
transformations in SQL and Python, to analysing and visualising 
data in Excel and Power BI.

I focus on writing clean, well-structured code and designing data systems 
that are easy to understand, maintain, and extend.

