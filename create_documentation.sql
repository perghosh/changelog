/*
   ### Table tree
   TDatabase
      TSchema
         TTable
            TColumn
      TStatement
      TFunction
      TView
      TTrigger

   #### Special  tables
   table_number      
 */
IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'documentation' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "documentation";';
END

IF OBJECT_ID('documentation."TNote"', 'U') IS NOT NULL  DROP TABLE documentation."TNote";
IF OBJECT_ID('documentation."TFunction"', 'U') IS NOT NULL  DROP TABLE documentation."TFunction";
IF OBJECT_ID('documentation."TStatement"', 'U') IS NOT NULL  DROP TABLE documentation."TStatement";
IF OBJECT_ID('documentation."TTable"', 'U') IS NOT NULL  DROP TABLE documentation."TTable";
IF OBJECT_ID('documentation."TColumn"', 'U') IS NOT NULL  DROP TABLE documentation."TColumn";
IF OBJECT_ID('documentation."TDatabase"', 'U') IS NOT NULL  DROP TABLE documentation."TDatabase";

PRINT('CREATE TABLE TDatabase, describes database'); CREATE TABLE documentation."TDatabase" (
   "DatabaseK" INT IDENTITY(1,1) NOT NULL
   ,"Index" INT
   ,"FName" NVARCHAR(200) NOT NULL
   ,CONSTRAINT "PK_TDatabase_DatabaseK" PRIMARY KEY ("DatabaseK")
);

PRINT('CREATE TABLE TSchema, describing schemas in database'); CREATE TABLE documentation."TSchema" (
   "SchemaK" INT IDENTITY(1,1) NOT NULL
   ,"DatabaseK" INT NOT NULL
   ,"Index" INT                                             -- Index number used to customize a integer to represent schema
   ,"FName" NVARCHAR(200) NOT NULL
   ,"FDescription" NVARCHAR(2000) 
   ,CONSTRAINT "PK_TSchema_SchemaK" PRIMARY KEY CLUSTERED ("SchemaK")
   ,CONSTRAINT "FK_TSchema_DatabaseK" FOREIGN KEY ("DatabaseK") REFERENCES documentation."TDatabase"("DatabaseK") ON DELETE CASCADE 
);

PRINT('CREATE TABLE TTable, describes tables in database'); CREATE TABLE documentation."TTable" (
    "TableK" INT IDENTITY(1,1)  NOT NULL
   ,"SchemaK" INT NOT NULL
   ,"Index" INT                                             -- Index number used to customize a integer to represent table
   ,"FName" NVARCHAR(200) NOT NULL
   ,"FType" NVARCHAR(100)
   ,"FNullable" BIT
   ,"FLength" INT                                           -- field length, depends on type
   ,"FDescription" NVARCHAR(2000) 
   --,"Name" NVARCHAR(100) INT DATE FLOAT BINARY(16) UNIQUEIDENTIFIER NOT NULL
   ,CONSTRAINT "PK_TTable_TableK" PRIMARY KEY CLUSTERED ("TableK")
   ,CONSTRAINT "FK_TTable_SchemaK" FOREIGN KEY ("SchemaK") REFERENCES documentation."TSchema"("SchemaK") ON DELETE CASCADE 
);


PRINT('CREATE TABLE TColumn, describes columns in tables'); CREATE TABLE documentation."TColumn" (
   "ColumnK" INT IDENTITY(1,1)  NOT NULL
   ,"TableK" INT NOT NULL
   ,"Index" INT                                             -- Index number used to customize a integer to represent column
   ,"GroupTypeS" INT                                        -- group type like boolean, integer, decimal, string, date, binary
   ,"FName" NVARCHAR(200) NOT NULL
   ,"FValueType" NVARCHAR(100) 
   ,"FSize" INT 
   ,"FType" NVARCHAR(100) 
   ,"FDescription" NVARCHAR(2000) 
   ,"FLabel" NVARCHAR(200) NOT NULL
   ,CONSTRAINT "PK_TColumn_ColumnK" PRIMARY KEY NONCLUSTERED ("ColumnK")
   ,CONSTRAINT "FK_TTable_TableK" FOREIGN KEY ("TableK") REFERENCES documentation."TTable"("TableK") ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX "IC_TColumn_TableK"  ON documentation."TColumn" ("TableK");


PRINT('CREATE TABLE TStatement'); CREATE TABLE documentation."TStatement" (
   "StatementK" INT IDENTITY(1,1) NOT NULL
   ,"DatabaseK" INT 
   ,"TableK" INT 
   ,"FDescription" NVARCHAR(1000) 
   ,FSql NTEXT
   ,CONSTRAINT "PK_TStatement_StatementK" PRIMARY KEY ("StatementK")
   ,CONSTRAINT "FK_TStatement_TableK" FOREIGN KEY ("TableK") REFERENCES documentation."TTable"("TableK") ON DELETE CASCADE ON UPDATE CASCADE
   ,CONSTRAINT "FK_TStatement_DatabaseK" FOREIGN KEY ("DatabaseK") REFERENCES documentation."TDatabase"("DatabaseK") ON DELETE CASCADE 
);


PRINT('CREATE TABLE TFunction'); CREATE TABLE documentation."TFunction" (
   "FunctionK" INT NOT NULL
   ,"DatabaseK" INT NOT NULL
   ,"FName" NVARCHAR(200) NOT NULL
   ,"FSyntax" NVARCHAR(1000) NOT NULL
   ,"FDescription" NTEXT
   ,CONSTRAINT "PK_TFunction_FunctionK" PRIMARY KEY NONCLUSTERED ("FunctionK")
   ,CONSTRAINT "FK_TFunction_DatabaseK" FOREIGN KEY ("DatabaseK") REFERENCES documentation."TDatabase"("DatabaseK") ON DELETE CASCADE ON UPDATE CASCADE
);

IF OBJECT_ID('documentation."TTrigger"', 'U') IS NOT NULL  DROP TABLE documentation."TTrigger";
PRINT('CREATE TABLE TTrigger'); CREATE TABLE documentation."TTrigger" (
   "TriggerK" INT NOT NULL
   ,"DatabaseK" INT NOT NULL
   ,"FEvent" NVARCHAR(200) NOT NULL                         -- event that triggers
   ,"FName" NVARCHAR(200) NOT NULL
   ,"FDescription" NTEXT
   ,CONSTRAINT "PK_TTrigger_TriggerK" PRIMARY KEY NONCLUSTERED ("TriggerK")
   ,CONSTRAINT "FK_TTrigger_DatabaseK" FOREIGN KEY ("DatabaseK") REFERENCES documentation."TDatabase"("DatabaseK") ON DELETE CASCADE ON UPDATE CASCADE
);

PRINT('CREATE TABLE TView, describe views'); CREATE TABLE documentation."TView" (
   "ViewK" INT NOT NULL
   ,"DatabaseK" INT NOT NULL
   ,"FName" NVARCHAR(200) NOT NULL
   ,"FSyntax" NVARCHAR(1000) NOT NULL
   ,"FBrief" NVARCHAR(500) NOT NULL
   ,"FDescription" NTEXT
   ,CONSTRAINT "PK_TView_ViewK" PRIMARY KEY NONCLUSTERED ("ViewK")
   ,CONSTRAINT "FK_TView_DatabaseK" FOREIGN KEY ("DatabaseK") REFERENCES documentation."TDatabase"("DatabaseK") ON DELETE CASCADE ON UPDATE CASCADE
);


PRINT('CREATE TABLE TNote, notes added to table or statement for information'); CREATE TABLE application."TNote" (
   "NoteK" INT IDENTITY(1,1) NOT NULL
   ,table_number INT                                        -- parent 
   ,"ParentK" INT NOT NULL                                  -- Table number for describing what table note belongs to
   ,"StatementK" INT NOT NULL
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,FTimeD DATETIME
   ,FNote NTEXT
   ,CONSTRAINT "PK_TNote_NoteK" PRIMARY KEY NONCLUSTERED ("NoteK")
);


IF OBJECT_ID('documentation."table_number"', 'U') IS NOT NULL  DROP TABLE documentation."table_number";
PRINT('CREATE TABLE table_number, small table with number for each table within schema called documentation'); CREATE TABLE documentation."table_number" (
   "number" INT NOT NULL
   ,"name" NVARCHAR(100)
);

INSERT INTO documentation."table_number"
VALUES
(10,'TDatabase'),(20,'TTable'),(30,'TTable'),(40,'TColumn'),(50,'TStatement'),(60,'TFunction'),(70,'TTrigger'),(80,"TView"),(200,'TNote')

IF OBJECT_ID('documentation."list"', 'U') IS NOT NULL  DROP TABLE documentation."list";
PRINT('CREATE TABLE list, lists for for typing data in documentation tables'); CREATE TABLE documentation."list" (
   "number" INT NOT NULL
   ,"name" NVARCHAR(100)
   ,"description" NVARCHAR(500)
);

INSERT INTO documentation."list" VALUES
(10,'table number','each table in documentation schema gets its own number, used for database logic and other type of operations needed to get the database to work as wanted'),
(20,'group type','simplified type for columns');


IF OBJECT_ID('documentation."list_values"', 'U') IS NOT NULL  DROP TABLE documentation."list_values";
PRINT('CREATE TABLE group_type, list with simplified type for'); CREATE TABLE documentation."table_number" (
   "list" INT NOT NULL
   ,"number" INT NOT NULL
   ,"name" NVARCHAR(100)
);

-- Table numbers
INSERT INTO documentation."list_values" VALUES
(10,10,'TDatabase'),(10,20,'TTable'),(10,30,'TTable'),(10,40,'TColumn'),(10,50,'TStatement'),(10,60,'TFunction'),(10,70,'TTrigger'),(10,80,"TView"),(10,200,'TNote');
      
-- simple type for columns
INSERT INTO documentation."list_values" VALUES
(20,1,'boolean'),(20,2,'integer'),(20,3,'decimal'),(20,4,'string'),(20,5,'date'),(20,6,'binary');
