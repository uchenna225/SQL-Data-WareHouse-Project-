# SQL-Data-WareHouse-Project-
## 📖 Overview

A comprehensive end-to-end data warehousing solution, following the Medallion Architecture (Bronze → Silver → Gold). This project demonstrates industry best practices in data engineering and analytics — from ingesting raw source data all the way through to a business-ready star schema model.

## 🏛️ Data Architecture

This project follows the **Medallion Architecture** with three structured layers:

### Bronze Layer
Stores raw data exactly as it comes from the source systems — no transformations applied. Loaded via `BULK INSERT` from CSV files into SQL Server tables.

### Silver Layer
This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.

### Gold Layer
This layers contains Business-ready views modelled as a Star Schema

## 📜 License
This project is licensed under the MIT License.

## 👤 About Me

I'm **Uchenna**, a self-taught data professional based in **Nigeria**, 
building expertise across Data Engineering and Data Analytics.

I work across the full data stack — from writing ETL pipelines and 
transformations in **SQL** and **Python**, to analysing and visualising 
data in **Excel** and **Power BI**.

I focus on writing clean, well-structured code and designing data systems 
that are easy to understand, maintain, and extend.

