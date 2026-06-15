/*
==============================
Silver erp_cust_az12 Loading 
==============================
This script cleans the bronze.erp_cust_az12 table and loads it into silver.erp_cust_az12
*/
INSERT INTO silver.erp_cust_az12(
	cid,
	Bdate,
	gen
	)
SELECT 
	-- removes 'NAS' prefix from customer ID if present to standardize the format
	CASE 
		WHEN cid LIKE 'NAS%' 
		THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END AS cid,
	-- nulls out future birth dates as they are invalid
	CASE 
		WHEN Bdate > GETDATE() 
		THEN NULL
		ELSE Bdate
	END AS Bdate,
	-- maps various gender representations to a standard Male/Female/N/A format
	CASE 
		WHEN TRIM(UPPER(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN TRIM(UPPER(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'N/A'
	END AS gen
FROM (
		-- deduplicates by customer ID, keeping the record with the earliest birth date
		SELECT 
			*,
			ROW_NUMBER() OVER(PARTITION BY cid ORDER BY Bdate) AS dupcheck
		FROM bronze.erp_cust_az12
	)DUPS
-- filters out duplicates, keeping only the first occurrence per customer
WHERE dupcheck = 1
