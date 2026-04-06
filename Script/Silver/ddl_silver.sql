/*
==========================
Silver Table Creation
==========================

Purpose: This Script Creates the 6 tables that will be used in this project 

Warning: Running the script will look for any similar table in the table base drops them and create a new one
		 All previous datas in the table will be lost


*/

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id	INT,
	prd_key	NVARCHAR(50),
	prd_nm	NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME,
	dwh_create_date DATETIME DEFAULT GETDATE()
)
IF OBJECT_ID ('silver.crm_customer_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_customer_info;
CREATE TABLE silver.crm_customer_info (
	cst	INT,
	cst_key	NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATETIME,
	dwh_create_date DATETIME DEFAULT GETDATE()
)
IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key	NVARCHAR(50),
	sls_cust_id	INT,
	sls_order_dt DATETIME,
	sls_ship_dt	DATETIME,
	sls_due_dt DATETIME,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME DEFAULT GETDATE()
)
IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
	CID	NVARCHAR(50),
	BDATE DATETIME,
	GEN NVARCHAR(50),
	dwh_create_date DATETIME DEFAULT GETDATE()
)
IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
	CID	NVARCHAR(50),
	CNTRY NVARCHAR(50),
	dwh_create_date DATETIME DEFAULT GETDATE()
)
IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
	ID NVARCHAR(50),
	CAT	NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date DATETIME DEFAULT GETDATE()
)
