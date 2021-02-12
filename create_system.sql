IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'system' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "system";';
END

IF OBJECT_ID('system."TGroup"', 'U') IS NOT NULL  DROP TABLE system."TGroup";
PRINT('CREATE TABLE TGroup, group system values'); CREATE TABLE system."TGroup" (
   "GroupK" INT NOT NULL
   ,"FName" NVARCHAR(200) NOT NULL 
   ,"FDescription" NVARCHAR(1000) NOT NULL
   ,CONSTRAINT "PK_TGroup_GroupK" PRIMARY KEY ("GroupK")
);


IF OBJECT_ID('system."TKeyValue"', 'U') IS NOT NULL  DROP TABLE system."TKeyValue";
PRINT('CREATE TABLE TKeyValue, system values placed in this key value table'); CREATE TABLE system."TKeyValue" (
    "KeyValueK" INT IDENTITY(1,1) NOT NULL
   ,"GroupK" INT NOT NULL
   ,"CreatedD" DATETIME
   ,"UpdateD" DATETIME
   ,"FKey" INT 
   ,"FTextValue" NVARCHAR(200)
   ,"FIntValue" BIGINT
   ,"FDecimalValue" FLOAT
   ,"FDescription" NVARCHAR(250) 
   ,"FIdle" BIT
   ,"FDeleted" BIT

   ,CONSTRAINT "PK_TKeyValue_KeyValueK" PRIMARY KEY NONCLUSTERED ("KeyValueK")
);

CREATE CLUSTERED INDEX "IC_TKeyValue_GroupK"  ON system."TKeyValue" ("GroupK");
