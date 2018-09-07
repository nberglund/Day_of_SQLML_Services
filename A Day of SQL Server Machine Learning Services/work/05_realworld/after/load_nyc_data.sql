SET ANSI_PADDING            ON
SET ANSI_WARNINGS           ON
SET ARITHABORT              ON
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS              ON
SET QUOTED_IDENTIFIER       ON
SET NUMERIC_ROUNDABORT      OFF 
GO

SET NOCOUNT ON;
GO

USE SqlSatPreCon;
GO

--if the path to the data is not as below, please change 
BULK INSERT SqlSatPreCon.dbo.tb_NYCityTaxiRaw
   	FROM 'c:\data\nyc_taxi_data_2014.csv'
   	WITH ( FIELDTERMINATOR =',', FIRSTROW = 2, ROWTERMINATOR = '\n' );
GO

/*
SELECT TOP(1000) * FROM dbo.tb_NYCityTaxiRaw
*/

-- transform NYC taxi table
INSERT INTO dbo.tb_NYCityTaxi (vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude,
                               rate_code, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge,
                               mta_tax, tip_amount, tolls_amount, total_amount, trip_time_in_secs,  tipped)
SELECT vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code, store_and_fwd_flag, 
       dropoff_longitude, dropoff_latitude, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount, 
       DATEDIFF(ss, pickup_datetime, dropoff_datetime), CASE WHEN tip_amount > 0 THEN 1 ELSE 0 END
FROM  dbo.tb_NYCityTaxiRaw;
GO

/*
SELECT TOP(1000) * FROM dbo.tb_NYCityTaxi
*/