

-- 1. Execute following code to see whether external scripts are enabled.
EXEC sp_configure 'external scripts enabled';

-- 2. If external scripts are not enabled uncomment the following and execute:
/*
EXEC sp_configure 'external scripts enabled', 1;
RECONFIGURE WITH OVERRIDE;
*/

-- 3. Write some code to make sure external engine is working.

EXECUTE sp_execute_external_script
                   @language = N'R',
                   @script = N'OutputDataSet <- InputDataSet',
                   @input_data_1 = N'SELECT ''Hello from R'''
WITH RESULT SETS (([Hello] varchar(50)))

EXECUTE sp_execute_external_script
                   @language = N'Python',
                   @script = N'OutputDataSet = InputDataSet',
                   @input_data_1 = N'SELECT ''Hello from Python'''
WITH RESULT SETS (([Hello] varchar(50)))