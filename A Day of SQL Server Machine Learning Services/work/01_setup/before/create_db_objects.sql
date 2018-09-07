SET ANSI_PADDING            ON
SET ANSI_WARNINGS           ON
SET ARITHABORT              ON
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS              ON
SET QUOTED_IDENTIFIER       ON
SET NUMERIC_ROUNDABORT      OFF 
GO

USE master;
GO

SET NOCOUNT ON;
GO

DROP DATABASE IF EXISTS SqlSatPreCon;
GO

IF EXISTS(SELECT 1 FROM sys.server_principals WHERE name = 'sqlsat1')
BEGIN
  DROP LOGIN sqlsat1;
END
GO

CREATE LOGIN sqlsat1
WITH PASSWORD = 'password1234$';
GO

CREATE DATABASE SqlSatPreCon;
GO

USE SqlSatPreCon;
GO

CREATE USER sqlsat1
FROM LOGIN sqlsat1;
GO

DROP TABLE IF EXISTS dbo.tb_NYCityTaxiRaw;

CREATE TABLE dbo.tb_NYCityTaxiRaw
(
  vendor_id varchar(10),
  pickup_datetime datetime,
  dropoff_datetime datetime,
  passenger_count int,
  trip_distance float,
  pickup_longitude varchar(30),
  pickup_latitude varchar(30),
  rate_code int,
  store_and_fwd_flag varchar(3),
  dropoff_longitude varchar(30),
  dropoff_latitude varchar(30),
  payment_type varchar(5),
  fare_amount float,
  surcharge float,
  mta_tax float,
  tip_amount float,
  tolls_amount float,
  total_amount float
)
GO

CREATE TABLE dbo.tb_NYCityTaxi
(
  vendor_id char(3) NOT NULL,
  pickup_datetime datetime  not null,
  dropoff_datetime datetime, 
  passenger_count int NOT NULL,
  trip_distance float NOT NULL,
  pickup_longitude varchar(30) NOT NULL,
  pickup_latitude varchar(30) NOT NULL,
  rate_code char(3) NOT NULL,
  store_and_fwd_flag char(3),
  dropoff_longitude varchar(30),
  dropoff_latitude varchar(30),
  payment_type char(3),
  fare_amount float,
  surcharge float,
  mta_tax float,
  tip_amount float,
  tolls_amount float,
  total_amount float,
  trip_time_in_secs bigint,
  tipped int
)
CREATE CLUSTERED COLUMNSTORE INDEX [cci_NYCityTaxi] ON dbo.tb_NYCityTaxi WITH (DROP_EXISTING = OFF);
GO

DROP TABLE IF EXISTS dbo.tb_Rand_10M
GO
CREATE TABLE dbo.tb_Rand_10M
(
  RowID bigint identity PRIMARY KEY, 
  y int NOT NULL, rand1 int NOT NULL, 
  rand2 int NOT NULL, rand3 int NOT NULL, 
  rand4 int NOT NULL, rand5 int NOT NULL,
);
GO

DROP TABLE IF EXISTS dbo.tb_Model;
CREATE TABLE dbo.tb_Model
(
  RowID int identity primary key,
  ModelName nvarchar(50) NOT NULL,
	ModelBin varbinary(max) NOT NULL
);
GO

DROP TABLE IF EXISTS dbo.tb_Model2;
CREATE TABLE dbo.tb_Model2
(
  RowID int identity primary key,
  ModelName nvarchar(50) NOT NULL,
	ModelBin varbinary(max) NOT NULL
);
GO

DROP TABLE IF EXISTS dbo.tb_irisdata_full;
CREATE TABLE dbo.tb_irisdata_full 
(
  RowID int identity primary key, SepalLength float not null, 
  SepalWidth float not null, PetalLength float not null, 
  PetalWidth float not null, Species varchar(100) null
);
GO

DROP TABLE IF EXISTS dbo.tb_irisdata_even;
CREATE TABLE dbo.tb_irisdata_even 
(
  RowID int identity primary key, SepalLength float not null, 
  SepalWidth float not null, PetalLength float not null, 
  PetalWidth float not null, Species varchar(100) null
);
GO

DROP TABLE IF EXISTS dbo.tb_irisdata_uneven;
CREATE TABLE dbo.tb_irisdata_uneven 
(
  RowID int identity primary key, SepalLength float not null, 
  SepalWidth float not null, PetalLength float not null, 
  PetalWidth float not null, Species varchar(100) null
);
GO

DROP FUNCTION IF EXISTS dbo.fn_CalculateDistance;
GO
CREATE FUNCTION dbo.fn_CalculateDistance (@Lat1 float, @Long1 float, @Lat2 float, @Long2 float)
-- User-defined function calculate the direct distance between two geographical coordinates.
RETURNS float
AS
BEGIN
  DECLARE @distance decimal(28, 10)
  -- Convert to radians
  SET @Lat1 = @Lat1 / 57.2958;
  SET @Long1 = @Long1 / 57.2958;
  SET @Lat2 = @Lat2 / 57.2958;
  SET @Long2 = @Long2 / 57.2958;
  -- Calculate distance
  SET @distance = (SIN(@Lat1) * SIN(@Lat2)) + (COS(@Lat1) * COS(@Lat2) * COS(@Long2 - @Long1));
  --Convert to miles
  IF @distance <> 0
  BEGIN
    SET @distance = 3958.75 * ATAN(SQRT(1 - POWER(@distance, 2)) / @distance);
  END
  RETURN @distance
END
GO


CREATE PROCEDURE dbo.pr_UpsertModel @ModelName nvarchar(50),
                                    @Model varbinary(max)
AS
SET NOCOUNT ON;

MERGE dbo.tb_Model AS tgt
USING(SELECT @Model AS ModelBin, @ModelName
 AS ModelName) AS src
ON (tgt.ModelName = src.ModelName)
WHEN NOT MATCHED THEN
  INSERT(ModelName, ModelBin)
  VALUES(src.ModelName, src.ModelBin)
WHEN MATCHED AND tgt.ModelName <> src.ModelName THEN
  UPDATE 
    SET tgt.ModelBin = src.ModelBin;
GO


