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

-- 5. Assign permissions
-- execute on SPEES to public
USE master;
GO

GRANT EXECUTE ON sp_execute_external_script to public;

USE SqlSatPreCon;
GO

GRANT EXECUTE ANY EXTERNAL SCRIPT TO sqlsat1;

-- 6. Impersonate sqlsat1 and execute
EXECUTE AS USER = 'sqlsat1'

EXEC sp_execute_external_script 
                       @language = N'R',
                       @script = N'd <- 42'

-- 7. Do not forget to REVERT back
REVERT;