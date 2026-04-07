
/*
===========================
silver.crm_customer_info
===========================

This script cleans the bronze.crm_customer_info table and loads it into silver.crm_customer_info
*/

INSERT INTO silver.crm_customer_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
	)

SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		ELSE 'N/A'
	END cst_marital_status,
	CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'f' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'm' THEN 'Male'
		ELSE 'N/A'
	END cst_gndr,
	cst_create_date
FROM(
-- This assigns each row a unique number, partitions it by the id and gives us the earliest creation date to look for the duplicates
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY  cst_id ORDER BY cst_create_date DESC) as dup_check
	FROM bronze.crm_customer_info
	WHERE cst_id IS NOT NULL
) WORK 
WHERE dup_check = 1


