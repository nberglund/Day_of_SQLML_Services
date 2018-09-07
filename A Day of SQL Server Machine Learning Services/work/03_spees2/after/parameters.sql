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
                    setosa <- InputDataSet[InputDataSet$Species == "setosa",]
                    meanSepWidth <- mean(setosa$SepalWidth)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))
                    OutputDataSet <- data.frame(setosa$SepalLength)',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full'
WITH RESULT SETS ((SepalLength float))
*/

-- 1. Change the code to use an input parameter @specie instead of the hard-coded value.
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- InputDataSet[InputDataSet$Species == specie,]
                    meanSepWidth <- mean(setosa$SepalWidth)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))
                    OutputDataSet <- data.frame(setosa$SepalLength)',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full',
                  @params = N'@specie nvarchar(50)',
                  @specie = 'setosa'
WITH RESULT SETS ((SepalLength float))


-- 2. Create a new parameter @multiplier which will be used in the script
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- InputDataSet[InputDataSet$Species == specie,]
                    meanSepWidth <- mean(setosa$SepalWidth)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))
                    OutputDataSet <- data.frame(setosa$SepalLength * multiPlier)',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full',
                  @params = N'@specie nvarchar(50), @multiPlier int',
                  @specie = 'setosa',
                  @multiPlier = 5
WITH RESULT SETS ((SepalLength float))

-- 3. Filter in the @input_data_1 instead of in the script.
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


