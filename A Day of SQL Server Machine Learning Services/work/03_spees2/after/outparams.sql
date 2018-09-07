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


/*
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- InputDataSet
                    meanSepWidth <- mean(setosa$SepalWidth)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))
                    OutputDataSet <- data.frame(setosa$SepalLength * multiPlier)',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full WHERE Species = @specie',
                  @params = N'@specie nvarchar(50), @multiPlier int',
                  @specie = 'setosa',
                  @multiPlier = 5
WITH RESULT SETS ((SepalLength float))
*/

-- 1. Change the code to introduce on output parameter instead of the cat(paste(...))
DECLARE @meanOut float;
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- InputDataSet
                    meanSepWidth <- mean(setosa$SepalWidth)
                    OutputDataSet <- data.frame(setosa$SepalLength * multiPlier)',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full WHERE Species = @specie',
                  @params = N'@specie nvarchar(50), @multiPlier int, @meanSepWidth float OUT',
                  @specie = 'setosa',
                  @multiPlier = 5,
                  @meanSepWidth = @meanOut OUT
WITH RESULT SETS ((SepalLength float))

SELECT @meanOut AS MeanSepWidth


