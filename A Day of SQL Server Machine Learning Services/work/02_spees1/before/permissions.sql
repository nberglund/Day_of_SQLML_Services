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

-- 1. As sa execute the below code to make sure all works
EXEC sp_execute_external_script 
                       @language = N'R',
                       @script = N'd <- 42'

-- 2. Impersonate sqlsat1 and execute
EXECUTE AS USER = 'sqlsat1'

EXEC sp_execute_external_script 
                       @language = N'R',
                       @script = N'd <- 42'

-- 3. Revert back to sa
REVERT

-- 4. Check all works
EXEC sp_execute_external_script 
                       @language = N'R',
                       @script = N'd <- 42'

-- 5. Assign permissions - write your code here


-- 6. Impersonate sqlsat1 and execute
EXECUTE AS USER = 'sqlsat1'

EXEC sp_execute_external_script 
                       @language = N'R',
                       @script = N'd <- 42'

-- 7. Do not forget to REVERT back
REVERT;