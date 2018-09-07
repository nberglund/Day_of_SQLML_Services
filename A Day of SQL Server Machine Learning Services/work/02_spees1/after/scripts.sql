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

-- this is the script we work with:
/*
setosa <- iris[iris$Species == "setosa",]
meanSepWidth <- mean(setosa$Sepal.Width)
cat(paste("Seposa sepal mean width: ", meanSepWidth))
*/


-- 1. Execute using the above script assigned to the @script parameter
EXEC sp_execute_external_script
                  @language = N'R',
                  @script = N'
                    setosa <- iris[iris$Species == "setosa",]
                    meanSepWidth <- mean(setosa$Sepal.Width)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))';

-- 2. Declare a variable with the script and use that to execute
DECLARE @scriptParam nvarchar(max) =  
                    N'setosa <- iris[iris$Species == "setosa",]
                    meanSepWidth <- mean(setosa$Sepal.Width)
                    cat(paste("Seposa sepal mean width: ", meanSepWidth))';

EXEC sp_execute_external_script
                      @language = N'R',
                      @script = @scriptParam;

-- 3. Load it from file
EXEC sp_execute_external_script @language = N'R',
                      @script = N'source("c:/r-scripts/iris_r.r")';


