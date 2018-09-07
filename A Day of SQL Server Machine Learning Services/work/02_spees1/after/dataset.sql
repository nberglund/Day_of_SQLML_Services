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
setosa <- iris[iris$Species == "setosa",]
meanSepWidth <- mean(setosa$SepalWidth)
cat(paste("Seposa sepal mean width: ", meanSepWidth))
*/

SELECT * FROM dbo.tb_irisdata_full;


-- 1. Change the above script to use InputDataSet instead of iris
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- InputDataSet[InputDataSet$Species == "setosa",]
                    meanSepWidth <- mean(setosa$SepalWidth)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full';

-- 2. Instead of filtering in the script, filter in the input data
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- InputDataSet
                    meanSepWidth <- mean(setosa$SepalWidth)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full WHERE Species = ''Setosa''';

-- 3. Return the SepalLength column as dataset.
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- InputDataSet
                    meanSepWidth <- mean(setosa$SepalWidth)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))
                    OutputDataSet <- data.frame(InputDataSet$SepalLength)',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full WHERE Species = ''Setosa''';

-- 4. Use WITH RESULT SETS to get a column name back .
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- InputDataSet
                    meanSepWidth <- mean(setosa$SepalWidth)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))
                    OutputDataSet <- data.frame(InputDataSet$SepalLength)',
                  @input_data_1 = N'SELECT * FROM dbo.tb_irisdata_full WHERE Species = ''Setosa'''
WITH RESULT SETS ((SepalLength float))


