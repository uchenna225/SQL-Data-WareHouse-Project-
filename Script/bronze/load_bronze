/* 
==========================
Bronze Load 
==========================

Purpose :

This script Truncates the tales and loads new data from the source systems and saves it as store procedure
Calculates the time it takes to load the data 
It uses the full load, bulk insert 
NO Data transformation is done at this level

Warning : All previous Transformation done will be lost 

Usage Example : EXEC bronze.load_bronze

*/

--STORE PROCEDURE 
CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN 
	--DECLARES VARIABLES FOR LOAD TIME
	DECLARE @start_time Datetime, @end_time Datetime, @batch_start_time Datetime, @batch_end_time Datetime;
	BEGIN TRY
	
	SET @batch_start_time = Getdate(); 

		PRINT'====================================='
		PRINT 'Loading Bronze'
		PRINT'====================================='

		print(' ')
		Print'Loadin bronze.crm'
		PRINT'--------------------------'

			SET @start_time = GETDATE(); 

			--TRUNCATES TABLE bronze.crm_customer_info
			PRINT'TRUNCATING TABLE: bronze.crm_customer_info'
			TRUNCATE TABLE bronze.crm_customer_info

			-- BULK INSERTS THE SOURCE TABLE INTO THE BRONZE TABLE 
			PRINT'BULK INSERTING: bronze.crm_customer_info'
			BULK INSERT bronze.crm_customer_info
			-- The location of the source document, can be a database, csv, or in any other form
			-- always remember to add the file extension 
			FROM 'C:\Users\UCHE\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			WITH (
				fIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
			)
				SET @end_time = GETDATE(); 
			print'>>>>>>>>> ' + cast(DATEDIFF(second, @start_time, @end_time) as nvarchar) + 'seconds';

			PRINT' '

			SET @start_time = GETDATE()

			PRINT'TRUNCATING TABLE: bronze.crm_production_info'
			TRUNCATE TABLE bronze.crm_production_info

			PRINT'BULK INSERTING: bronze.crm_production_info'
			BULK INSERT bronze.crm_production_info
			FROM 'C:\Users\UCHE\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			WITH (
				fIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
			)
			SET @end_time = GETDATE(); 
			print'>>>>>>>>> ' + cast(DATEDIFF(second, @start_time, @end_time) as nvarchar) + 'seconds';
			print(' ')

			SET @start_time = GETDATE();
			PRINT'TRUNCATING TABLE: bronze.crm_sales_details'
			TRUNCATE TABLE bronze.crm_sales_details

			PRINT'BULK INSERTING: bronze.crm_sales_details'
			BULK INSERT bronze.crm_sales_details
			FROM 'C:\Users\UCHE\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH (
				fIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
			)
			SET @end_time = GETDATE(); 
			print'>>>>>>>>> ' + cast(DATEDIFF(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print(' ')


		PRINT'--------------------------'
		Print'Loadin bronze.erp'
		PRINT'--------------------------'
		print(' ')

			SET @start_time = GETDATE();
			PRINT'TRUNCATING TABLE: bronze.erp_cust_az12'
			TRUNCATE TABLE bronze.erp_cust_az12

			PRINT'BULK INSERTING: bronze.erp_cust_az12'
			BULK INSERT bronze.erp_cust_az12
			FROM 'C:\Users\UCHE\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
			WITH (
				fIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
			)
			SET @end_time = GETDATE(); 
			print'>>>>>>>>> ' + cast(DATEDIFF(second, @start_time, @end_time) as nvarchar) + 'seconds';
			print(' ')

			SET @start_time = GETDATE();
			PRINT'TRUNCATING TABLE: bronze.erp_loc_a101'
			TRUNCATE TABLE bronze.erp_loc_a101

			PRINT'BULK INSERTING: bronze.erp_loc_a101'
			BULK INSERT bronze.erp_loc_a101
			FROM 'C:\Users\UCHE\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
			WITH (
				fIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
			)
			SET @end_time = GETDATE(); 
			print'>>>>>>>>> ' + cast(DATEDIFF(second, @start_time, @end_time) as nvarchar) + 'seconds';
			print(' ')

			SET @start_time = GETDATE();
			PRINT'TRUNCATING TABLE: bronze.erp_px_cat_g1v2'
			TRUNCATE TABLE bronze.erp_px_cat_g1v2

			PRINT'BULK INSERTING bronze.erp_px_cat_g1v2'
			BULK INSERT bronze.erp_px_cat_g1v2
			FROM 'C:\Users\UCHE\Downloads\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
			WITH (
				fIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
			)
			SET @end_time = GETDATE(); 
			print'>>>>>>>>> ' + cast(DATEDIFF(second, @start_time, @end_time) as nvarchar) + 'seconds';
			END TRY
			BEGIN CATCH 
				PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
				PRINT'ERROR MESSAGE' + ERROR_MESSAGE()
				PRINT'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR)
				PRINT'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR)
			END CATCH

			print' '
			SET @batch_end_time = GETDATE(); 
			print'>>>>>>>>> ' +'Total load time is'+ ' ' + cast(DATEDIFF(second, @start_time, @end_time) as nvarchar) + 'seconds';
END 
