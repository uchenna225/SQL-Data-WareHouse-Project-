/* 
==========================
Create Database and Schema 
==========================

*/

/*

Purpose: This script checks if the database exists, drops it, and creates a new one.

It implements the Bronze, Silver, and Gold architecture:

Bronze: Raw ingested data
Silver: Cleaned and transformed data
Gold: Business-ready, aggregated data

WARNING: All existing data will be lost. 


*/

Use master;
Go

-- Drops and recreate the Datewarehouse Database -- 

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN
    ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Datawarehouse;
END;
GO

--create the Datewarehouse Database --

CREATE DATABASE Datawarehouse;
Go

Use Datawarehouse;
GO

-- Creates Schema--

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold ;
