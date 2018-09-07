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

DECLARE @start datetime2 = SYSUTCDATETIME()
DECLARE @mod varbinary(max);
EXEC sp_execute_external_script
      @language = N'R'
    , @script = N'
          myModel <- glm(y ~ rand1 + rand2 + rand3 + rand4 + rand5, 
                       data=InputDataSet);'
   , @input_data_1 = N'
          SELECT TOP(1500000) y, rand1, rand2, rand3, 
                  rand4, rand5 
          FROM dbo.tb_Rand_10M TABLESAMPLE(75 PERCENT) 
                              REPEATABLE(98074)';
SELECT DATEDIFF(ms, @start, SYSUTCDATETIME()) AS ElapsedCranR
GO

DECLARE @start datetime2 = SYSUTCDATETIME()
DECLARE @mod varbinary(max);
EXEC sp_execute_external_script
      @language = N'R'
    , @script = N'
          myModel <- rxLinMod(y ~ rand1 + rand2 + rand3 + rand4 + rand5, 
                       data=InputDataSet);'
    , @input_data_1 = N'SELECT TOP(1500000) y, rand1, rand2, rand3, 
                                   rand4, rand5 
          FROM dbo.tb_Rand_10M TABLESAMPLE(75 PERCENT) 
                              REPEATABLE(98074)';
SELECT DATEDIFF(ms, @start, SYSUTCDATETIME()) AS ElapsedRevoScaleR
GO
