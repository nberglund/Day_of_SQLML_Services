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


-- execute to get a feel for the dbo.tb_Rand_10M table. 
SELECT COUNT(*) FROM dbo.tb_Rand_10M;

SELECT TOP(100) * FROM dbo.tb_Rand_10M;

DECLARE @mod varbinary(max);
EXEC sp_execute_external_script
      @language = N'R'
    , @script = N'
          myModel <- glm(y ~ rand1 + rand2 + rand3 + rand4 + rand5, 
                       data=InputDataSet)
           model <- serialize(myModel, NULL);'
   , @input_data_1 = N'
          SELECT  TOP(750000) y, rand1, rand2, rand3, 
                  rand4, rand5 
          FROM dbo.tb_Rand_10M TABLESAMPLE(75 PERCENT) 
                              REPEATABLE(98074)',
     @params = N'@model varbinary(max) OUT',
     @model = @mod OUT

INSERT INTO dbo.tb_Model2(ModelName, ModelBin)
VALUES ('GLM_75Pct', @mod);
GO

DECLARE @mod varbinary(max);
EXEC sp_execute_external_script
      @language = N'R'
    , @script = N'
          myModel <- rxLinMod(y ~ rand1 + rand2 + rand3 + rand4 + rand5, 
                       data=InputDataSet)
          
          model <- serialize(myModel, NULL);'
   
   , @input_data_1 = N'SELECT y, rand1, rand2, rand3, 
                  rand4, rand5 
          FROM dbo.tb_Rand_10M TABLESAMPLE(75 PERCENT) 
                              REPEATABLE(98074)',
     @params = N'@model varbinary(max) OUT',
     @model = @mod OUT;

INSERT INTO dbo.tb_Model2(ModelName, ModelBin)
VALUES ('RxLM_75Pct', @mod);
GO 



/*
SELECT * FROM dbo.tb_Model2
*/
