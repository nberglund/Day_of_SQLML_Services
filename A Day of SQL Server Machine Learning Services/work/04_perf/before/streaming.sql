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


-- 1. Execute with pushing in very few rows, to ensure all works
DECLARE @model varbinary(max) = (SELECT TOP(1) ModelBin
                                 FROM dbo.tb_Model2
                                 WHERE ModelName = 'GLM_75Pct');  
  EXEC sp_execute_external_script @language = N'R',  
     @script = N'  
       mod <- unserialize(model); 

       cat(paste0("R Process ID = ", Sys.getpid()))
       cat("\n")
       cat(paste0("Nmbr rows = ", nrow(InputDataSet)))
       cat("\n")
       cat("----------------")
       cat("\n")

        OutputDataSet <- data.frame(predict(mod, 
                                  newdata = InputDataSet, 
                                  type = "response"))',  
  @input_data_1 = N' SELECT TOP(100) y, rand1, rand2, rand3, 
                      rand4, rand5 
              FROM dbo.tb_Rand_10M',  
  @params = N'@model varbinary(max)', 
  @model = @model  
WITH RESULT SETS ((Y_predict float));
GO


-- 2. Execute and send in a lot of rows (5 million)
DECLARE @model varbinary(max) = (SELECT TOP(1) ModelBin
                                 FROM dbo.tb_Model2
                                 WHERE ModelName = 'GLM_75Pct');  
  EXEC sp_execute_external_script @language = N'R',  
     @script = N'  
       mod <- unserialize(model); 

       cat(paste0("R Process ID = ", Sys.getpid()))
       cat("\n")
       cat(paste0("Nmbr rows = ", nrow(InputDataSet)))
       cat("\n")
       cat("----------------")
       cat("\n")

        OutputDataSet <- data.frame(predict(mod, 
                                  newdata = InputDataSet, 
                                  type = "response"))',  
  @input_data_1 = N' SELECT TOP(5000000) y, rand1, rand2, rand3, 
                      rand4, rand5 
              FROM dbo.tb_Rand_10M',  
  @params = N'@model varbinary(max)', 
  @model = @model  
WITH RESULT SETS ((Y_predict float));
GO


-- 3. Change to use streaming, and stream 500,000 rows per batch
DECLARE @model varbinary(max) = (SELECT TOP(1) ModelBin
                                 FROM dbo.tb_Model2
                                 WHERE ModelName = 'GLM_75Pct');  
  EXEC sp_execute_external_script @language = N'R',  
     @script = N'  
       mod <- unserialize(model); 

       cat(paste0("R Process ID = ", Sys.getpid()))
       cat("\n")
       cat(paste0("Nmbr rows = ", nrow(InputDataSet)))
       cat("\n")
       cat("----------------")
       cat("\n")

        OutputDataSet <- data.frame(predict(mod, 
                                  newdata = InputDataSet, 
                                  type = "response"))',  
  @input_data_1 = N' SELECT TOP(5000000) y, rand1, rand2, rand3, 
                      rand4, rand5 
              FROM dbo.tb_Rand_10M',  
  @params = N'@model varbinary(max)', 
  @model = @model
WITH RESULT SETS ((Y_predict float));

