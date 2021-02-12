IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'extend' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "extend";';
END


IF OBJECT_ID('extend."TFieldLayout"', 'U') IS NOT NULL  DROP TABLE extend."TFieldLayout";
IF OBJECT_ID('extend."TField"', 'U') IS NOT NULL  DROP TABLE extend."TField";


PRINT('CREATE TABLE TField, extra fields for '); CREATE TABLE extend."TField" (
   FieldK BIGINT IDENTITY(1,1) NOT NULL
   ,RecordK BIGINT NOT NULL
   ,table_number INT NOT NULL                               -- Table number describing the key to participant 
   ,CreateD DATETIME NOT NULL
   ,FSection INT DEFAULT 0
   ,F0 BIGINT
   ,F1 BIGINT
   ,F2 BIGINT
   ,F3 BIGINT
   ,F4 BIGINT
   ,F5 BIGINT
   ,F6 BIGINT
   ,F7 BIGINT
   ,F8 BIGINT
   ,F9 BIGINT
   ,F10 BIGINT
   ,F11 BIGINT
   ,F12 BIGINT
   ,F13 BIGINT
   ,F14 BIGINT
   ,F15 BIGINT
   ,F16 BIGINT
   ,F17 BIGINT
   ,F18 BIGINT
   ,F19 BIGINT
   ,F20 FLOAT
   ,F21 FLOAT
   ,F22 FLOAT
   ,F23 FLOAT
   ,F24 FLOAT
   ,F25 FLOAT
   ,F26 FLOAT
   ,F27 FLOAT
   ,F28 FLOAT
   ,F29 FLOAT
   ,F30 DATETIME
   ,F31 DATETIME
   ,F32 DATETIME
   ,F33 DATETIME
   ,F34 DATETIME
   ,F35 DATETIME
   ,F36 DATETIME
   ,F37 DATETIME
   ,F38 DATETIME
   ,F39 DATETIME
   ,F40 NVARCHAR(200)
   ,F41 NVARCHAR(200)
   ,F42 NVARCHAR(200)
   ,F43 NVARCHAR(200)
   ,F44 NVARCHAR(200)
   ,F45 NVARCHAR(200)
   ,F46 NVARCHAR(200)
   ,F47 NVARCHAR(200)
   ,F48 NVARCHAR(200)
   ,F49 NVARCHAR(200)
   ,CONSTRAINT "extend.PK_TField_FieldK" PRIMARY KEY NONCLUSTERED (FieldK)
);

CREATE CLUSTERED INDEX "extend.IC_TField_RecordK" ON extend."TField" (RecordK);

PRINT('CREATE TABLE TFieldLayout, layout for extended fields'); CREATE TABLE extend."TFieldLayout" (
    FieldLayoutK BIGINT IDENTITY(1,1) NOT NULL
   ,table_number INT NOT NULL                            -- Table number for describing what table note belongs to
   ,CreateD DATETIME NOT NULL
   ,FSection INT DEFAULT 0
   ,FLabel NVARCHAR(100) NOT NULL
   ,FDescription NVARCHAR(200)
   ,FType VARCHAR(20)
   ,FDisplayType VARCHAR(20)
   ,FIndex INT NOT NULL 
   ,FGroupList INT DEFAULT 0
   ,FDeleted BIT DEFAULT 0
   ,CONSTRAINT "extend.PK_TFieldLayout_FieldLayoutK" PRIMARY KEY NONCLUSTERED (FieldLayoutK)
);

SELECT table_number, FLabel, FDescription, FType, FDisplayType, FGroupList 
FROM extend."TFieldLayout"
WHERE FDeleted = 0

PRINT('CREATE TABLE system_type, Table used to manage system values'); CREATE TABLE extend."system_type" (
   "number" INT NOT NULL
   ,"type" VARCHAR(20)
   ,"display" VARCHAR(20)
);

-- system type is using flags for base type b0001 = integer, b0010 = decimal, b0100 = date, b1000 = text
INSERT INTO extend."system_type"
VALUES (1,'integer','integer'),(2,'decimal','decimal'),(4,'date','date'),(8,'text','text'),
		 (17,'integer','boolean'),(33,'integer','list'),




/*
### Count values
SELECT COUNT(*) FROM extend.TFieldLayout WHERE FDeleted = 0

### Find holes in TFieldLayout for number field

SELECT DISTINCT _fl.FIndex + 1 _begin, MIN( _fl_3.FIndex ) - 1 _end
FROM 
(
	(
		extend.TFieldLayout _fl
		LEFT JOIN extend.TFieldLayout _fl_2 ON _fl.FIndex = _fl_2.FIndex - 1 AND _fl.FDeleted = 0 AND _fl_2.FDeleted = 0
	)
	LEFT JOIN extend.TFieldLayout _fl_3 ON _fl.FIndex < _fl_3.FIndex AND _fl.FDeleted = 0 AND _fl_3.FDeleted = 0
)
GROUP BY _fl.FIndex, _fl_2.FIndex


SELECT (ID+1) FROM table AS t1
LEFT JOIN table as t2
ON t1.ID+1 = t2.ID
WHERE t2.ID IS NULL
*/

