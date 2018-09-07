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


-- insert data into the iris table
INSERT INTO dbo.tb_irisdata_full( SepalLength, SepalWidth, 
                                  PetalLength, PetalWidth, Species)
EXECUTE sp_execute_external_script
  @language = N'R'
  , @script = N'iris_data <- iris;'
  , @input_data_1 = N''
  , @output_data_1_name = N'iris_data';

--split up the Iris data
INSERT INTO dbo.tb_irisdata_even( SepalLength, SepalWidth, 
                                  PetalLength, PetalWidth, Species)
SELECT SepalLength, SepalWidth, PetalLength, PetalWidth, Species 
FROM dbo.tb_irisdata_full
WHERE RowID % 2 = 0

INSERT INTO dbo.tb_irisdata_uneven( SepalLength, SepalWidth, 
                                    PetalLength, PetalWidth, Species)
SELECT SepalLength, SepalWidth, PetalLength, PetalWidth, Species 
FROM dbo.tb_irisdata_full
WHERE RowID % 2 = 1

-- insert into dbo.tb_Rand_10M
INSERT INTO dbo.tb_Rand_10M(y, rand1, rand2, rand3, rand4, rand5)
SELECT TOP(10000000) CAST(ABS(CHECKSUM(NEWID())) % 14 AS INT) 
  , CAST(ABS(CHECKSUM(NEWID())) % 20 AS INT)
  , CAST(ABS(CHECKSUM(NEWID())) % 25 AS INT)
  , CAST(ABS(CHECKSUM(NEWID())) % 14 AS INT)
  , CAST(ABS(CHECKSUM(NEWID())) % 50 AS INT)
  , CAST(ABS(CHECKSUM(NEWID())) % 100 AS INT)
FROM sys.objects o1
CROSS JOIN sys.objects o2
CROSS JOIN sys.objects o3
CROSS JOIN sys.objects o4;
GO

/*


SELECT * FROM dbo.tb_irisdata_full
SELECT * FROM dbo.tb_irisdata_even
SELECT * FROM dbo.tb_irisdata_uneven

SELECT TOP(1000) * FROM dbo.tb_Rand_10M

*/