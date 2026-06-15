*/
CREATE OR ALTER VIEW gold.dim_customers AS
	SELECT 
		-- generates a surrogate key for the dimension table
		ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name,
		ci.cst_lastname AS last_name,
		-- resolves gender conflict between CRM and ERP: CRM is the master source,
		-- ERP gender is only used as a fallback when CRM has no valid value
		CASE 
			WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
			ELSE COALESCE(ca.gen, 'N/A')
		END AS gender,
		ca.Bdate AS birthdate,
		ci.cst_marital_status AS marital_status,
		ea.CNTRY AS country,
		ci.cst_create_date AS create_date
	FROM silver.crm_customer_info ci
	-- joins ERP customer data to enrich with birthdate and gender
	LEFT JOIN silver.erp_cust_az12 ca
		ON ci.cst_key = ca.cid
	-- joins ERP location data to enrich with country
	LEFT JOIN silver.erp_loc_a101 ea
		ON ci.cst_key = ea.CID
