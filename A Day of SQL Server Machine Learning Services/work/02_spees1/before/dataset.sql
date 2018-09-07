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

-- 2. Instead of filtering in the script, filter in the input data
EXEC sp_execute_external_script

-- 3. Return the SepalLength column as dataset.
EXEC sp_execute_external_script

-- 4. Use WITH RESULT SETS to get a column name back .
EXEC sp_execute_external_script



