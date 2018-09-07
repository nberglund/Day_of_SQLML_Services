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

-- 1. see that parallelism works, switch on actual execution plan Ctrl + M
SELECT TOP(2500000) y, rand1, rand2, rand3, 
                    rand4, rand5 
FROM dbo.tb_Rand_10M 
WHERE  rand5 >= 10           
OPTION(querytraceon 8649, MAXDOP 4)


-- 2. Switch off actual execution plan. Execute with the statement above 
--    Notice in Messages tab that we execute in the same process 
DECLARE @model varbinary(max) = (SELECT TOP(1) ModelBin
                                 FROM dbo.tb_Model2 
                                 WHERE ModelName = 'RxLM_75Pct');  
  EXEC sp_execute_external_script @language = N'R',  
     @script = N'
       mod <- unserialize(model); 
       cat(paste0("R Process ID = ", Sys.getpid()))
       cat("\n")
       cat(paste0("Nmbr rows = ", nrow(InputDataSet)))
       cat("\n")
       cat("----------------")
       cat("\n")      
       OutputDataSet <- data.frame(rxPredict(modelObject = mod, 
           data = InputDataSet, 
           outData = NULL, 
           type = "response", 
           writeModelVars = FALSE, overwrite = TRUE));',  
  @input_data_1 = N'SELECT TOP(2500000) y, rand1, rand2, rand3, 
                      rand4, rand5 
              FROM dbo.tb_Rand_10M 
WHERE  rand5 >= 10           
OPTION(querytraceon 8649, MAXDOP 4)', 
  @params = N'@model varbinary(max), @r_rowsPerRead int',  
  @model = @model,
  @r_rowsPerRead = 500000
WITH RESULT SETS ((Y_predict float)); 
GO

-- 3. Change this statement to use parallelism.
DECLARE @model varbinary(max) = (SELECT TOP(1) ModelBin
                                 FROM dbo.tb_Model2 
                                 WHERE ModelName = 'RxLM_75Pct');  
  EXEC sp_execute_external_script @language = N'R',  
     @script = N'
       mod <- unserialize(model); 
       cat(paste0("R Process ID = ", Sys.getpid()))
       cat("\n")
       cat(paste0("Nmbr rows = ", nrow(InputDataSet)))
       cat("\n")
       cat("----------------")
       cat("\n")      
       OutputDataSet <- data.frame(rxPredict(modelObject = mod, 
           data = InputDataSet, 
           outData = NULL, 
           type = "response", 
           writeModelVars = FALSE, overwrite = TRUE));',  
  @input_data_1 = N'SELECT TOP(2500000) y, rand1, rand2, rand3, 
                      rand4, rand5 
              FROM dbo.tb_Rand_10M 
WHERE  rand5 >= 10           
OPTION(querytraceon 8649, MAXDOP 4)', 
  @parallel = 1,                                   
  @params = N'@model varbinary(max), @r_rowsPerRead int',  
  @model = @model,
  @r_rowsPerRead = 500000
WITH RESULT SETS ((Y_predict float)); 
GO

