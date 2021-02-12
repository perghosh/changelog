/*
   ### Table tree
   TGroup
      TCode
         TProperty
         closure
      TPropertyKey
         TProperty

   ### Lookup values
   Using code as lookup by adding field that holds code key

   ### Tags
   Using code values as tags by creating relation tables to code and the 
   table that tags are attached to.

   deprecated

 */


IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'code' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "code";';
END

IF OBJECT_ID('code."thread"', 'U') IS NOT NULL  DROP TABLE code."thread";
IF OBJECT_ID('code."thread_header"', 'U') IS NOT NULL  DROP TABLE code."thread_header";
IF OBJECT_ID('code."closure"', 'U') IS NOT NULL  DROP TABLE code."closure";
IF OBJECT_ID('code."TProperty"', 'U') IS NOT NULL  DROP TABLE code."TProperty";
IF OBJECT_ID('code."TPropertyKey"', 'U') IS NOT NULL  DROP TABLE code."TPropertyKey";
IF OBJECT_ID('code."TCode"', 'U') IS NOT NULL  DROP TABLE code."TCode";
IF OBJECT_ID('code."TBaseCode"', 'U') IS NOT NULL  DROP TABLE code."TBaseCode";
IF OBJECT_ID('code."TGroup"', 'U') IS NOT NULL  DROP TABLE code."TGroup";
IF OBJECT_ID('code."TTag"', 'U') IS NOT NULL  DROP TABLE code."TTag";

/*

*/
PRINT('CREATE TABLE TGroup, group codes'); CREATE TABLE code."TGroup" (
   "GroupK" INT NOT NULL
   ,"FName" NVARCHAR(200) NOT NULL 
   ,"FDescription" NVARCHAR(250) 
   ,"FLabel" NVARCHAR(100) 
   ,"FTable" VARCHAR(200)
   ,"FMainTable" VARCHAR(200) 
   ,"FSchema" VARCHAR(50)
   ,CONSTRAINT "code.PK_TGroup_GroupK" PRIMARY KEY ("GroupK")
);

PRINT('CREATE TABLE TBaseCode, base code is used to connect codes that has a common meaning.'); CREATE TABLE code."TBaseCode" (
   "BaseCodeK" INT IDENTITY(1,1) NOT NULL
   ,"GroupK" INT NOT NULL                                   -- fk to group
   ,"CreatedD" DATETIME
   ,"UpdateD" DATETIME
   ,"FId" INT                                               -- Id used if there is a need to control numbers
   ,"FName" NVARCHAR(200) NOT NULL
   ,"FAbbreviation" NVARCHAR(100)                           -- Short name for code, could be used when codes are displayed in a breadcrumb trail
   ,"FDescription" NVARCHAR(1000) 
   ,"FRank" INT                                             -- Ranking is for making system easier to work with, maybe you need parents in a tree but just some items are suitable for parents. Select those with codes that has some sort of ranking
   ,"FIdle" SMALLINT DEFAULT 0
   ,"FDeleted" SMALLINT DEFAULT 0
   --,"Name" NVARCHAR(100) INT DATE FLOAT BINARY(16) UNIQUEIDENTIFIER NOT NULL
   ,CONSTRAINT "PK_TBaseCode_BaseCodeK" PRIMARY KEY NONCLUSTERED ("BaseCodeK")
   ,CONSTRAINT "code.FK_TBaseCode_GroupK" FOREIGN KEY ("GroupK") REFERENCES code."TGroup"("GroupK") ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX "code.IC_TBaseCode_GroupK" ON code."TBaseCode" ("GroupK");

PRINT('CREATE TABLE TCode, code is used as a lookup table for fields in other tables'); 
CREATE TABLE code.TCode (
    CodeK INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,GroupK INT NOT NULL                -- fk to group
   ,BaseCodeK INT                      -- if connected to a common base code
   ,SuperK INT                         -- parent code
   ,CreatedD DATETIME
   ,UpdateD DATETIME
   ,FId INT                            -- Id used if there is a need to control numbers
   ,FName NVARCHAR(200) NOT NULL       -- Name for code
   ,FSystemName VARCHAR(50)            -- Internal system name if needed
   ,FAbbreviation NVARCHAR(100)        -- Short name for code, could be used when codes are displayed in a breadcrumb trail
   ,FDescription NVARCHAR(250)         -- Describe the code, what is is suppose to be used for
   ,FRank INT                          -- Ranking is for making system easier to work with, maybe you need parents in a tree but just some items are suitable for parents. Select those with codes that has some sort of ranking
   ,FNotCompleted SMALLINT DEFAULT 0   -- Record needs more work
   ,FIdle SMALLINT DEFAULT 0           -- Code is temporarily suspended
   ,FDefault SMALLINT DEFAULT 0        -- Mark code as default, could be us to set this i no other code is selected
   ,FDeleted SMALLINT DEFAULT 0        -- deleted but kept in database
   ,FInteger0 BIGINT                   -- Custom integer
   ,FInteger1 BIGINT                   -- Custom integer
   ,FNumber0 FLOAT                     -- Custom number, could be used for anything that system is used for
   ,FText0 NVARCHAR(100)               -- Custom text, used for anything thats appropriate to system 
   ,CONSTRAINT "code.FK_TCode_GroupK" FOREIGN KEY ("GroupK") REFERENCES code."TGroup"("GroupK") ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX "code.IC_TCode_GroupK" ON code."TCode" ("GroupK");

-- This table can be used to define a fixed number of properties for code
PRINT('CREATE TABLE TPropertyKey, if properties are restricted to specified key names to code group'); CREATE TABLE code."TPropertyKey" (
   "PropertyKeyK" INT IDENTITY(1,1) NOT NULL
   ,"GroupK" INT NOT NULL                                   -- fk to group
   ,"FKey" NVARCHAR(100)
   ,"FDescription" NVARCHAR(1000)
   ,"FIdle" SMALLINT DEFAULT 0
   ,"FDeleted" SMALLINT DEFAULT 0
   ,CONSTRAINT "code.PK_TPropertyKey_PropertyKeyK" PRIMARY KEY NONCLUSTERED ("PropertyKeyK")
   ,CONSTRAINT "code.FK_TPropertyKey_GroupK" FOREIGN KEY ("GroupK") REFERENCES code."TGroup"("GroupK") ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX "code.IC_TPropertyKey_GroupK"  ON code."TPropertyKey" ("GroupK");


PRINT('CREATE TABLE TProperty, extend code with values'); CREATE TABLE code."TProperty" (
   "PropertyK" INT IDENTITY(1,1) NOT NULL
   ,"CodeK" INT NOT NULL
   ,"PropertyKeyK" INT                                      -- key name found in TPropertyKey
   ,"FKey" NVARCHAR(100)                                    -- any key name for code property
   ,"FValue" NVARCHAR(1000)
   ,"FValueBoolean" SMALLINT
   ,"FValueInteger" BIGINT
   ,"FValueDecimal" FLOAT
   ,"FDescription" NVARCHAR(1000)
   ,CONSTRAINT "code.PK_TProperty_PropertyK" PRIMARY KEY NONCLUSTERED ("PropertyK")
   ,CONSTRAINT "code.FK_TProperty_CodeK" FOREIGN KEY ("CodeK") REFERENCES code.TCode(CodeK) ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX "code.IC_TProperty_CodeK" ON code."TProperty" ("CodeK")

PRINT('CREATE TABLE table_number, small table with number for each table within schema called application'); CREATE TABLE code."table_number" (
   "number" INT NOT NULL
   ,"name" NVARCHAR(100)
);

INSERT INTO code."table_number"
VALUES (300,'TGroup'),(301,'TCode'),(302,'TBaseCode'),(303,'TProperty'),(305,'TPropertyKey')




/*
##CLOSURE TABLE FOR CODES
https://www.youtube.com/watch?v=wuH5OoPC3hA§

ancestor | descendant | Depth

Sample of one branch with four nodes, each branch has the complete child tree in table

01 - 02 - 03 - 04

01 | 01 | 00
01 | 02 | 01
01 | 03 | 02
01 | 04 | 01
02 | 02 | 00
02 | 03 | 01
02 | 04 | 02
03 | 03 | 00
03 | 04 | 01
04 | 04 | 00

**Add node to 01**

01 - 02 - 03 - 04
   - 05
append to tree
01 | 05 | 01
05 | 05 | 00

**Add node to 05**

01 - 02 - 03 - 04
   - 05 - 06
append to tree
01 | 06 | 02
05 | 06 | 01
06 | 06 | 00


### Select all children's for all levels  
Every node has it's complete tree stored in the closure table
SELECT _code.* FROM TCode _code
JOIN closure _closure ON _code.CodeK = _closure.Descendant
WHERE _code.Ancestor = ?

### Insert new child
INSERT INTO TCode VALUES(...)

PRINT IDENT_CURRENT('code.TCode')
DECLARE @@iParent INT -- parent key
DECLARE @iKey INT
DECLARE @iDepth INT
SET @iKey = SELECT IDENT_CURRENT(‘code.TCode’) -- generated key

-- Update tree
SET = SELECT MAX( Depth ) + 1 WHERE Descendant = @iParent
INSERT INTO closure( Ancestor, Descendant, Depth )
SELECT Ancestor, @iKey, @iDepth FROM closure
WHERE Descendant = @iParent
UNION ALL
SELECT @iKey, @iKey, 0

-- (1,1,0),(1,2,1),(1,3,2),(1,4,3)
---------- (2,2,0),(2,3,1),(2,4,2)
------------------ (3,3,0),(3,4,1)
-------------------------- (4,4,0)

-- Add (parent = 4, key = 5)
-- (1,1,0),(1,2,1),(1,3,2),(1,4,3),(1,5,4)
---------- (2,2,0),(2,3,1),(2,4,2),(2,5,3)
------------------ (3,3,0),(3,4,1),(3,5,2)
-------------------------- (4,4,0),(4,5,1)
---------------------------------- (5,5,0)

-- Add (parent = 1, key = 6)
-- (1,1,0),(1,2,1),(1,3,2),(1,4,3),(1,5,4)
-- (2,2,0),(2,3,1),(2,4,2),(2,5,3)
-- (3,3,0),(3,4,1),(3,5,2)
-- (4,4,0),(4,5,1)
-- (5,5,0)
-- (1,1,0),(1,6,1)
-- (6,6,0)

DECLARE @iParent INT = 2
DECLARE @iKey INT = 6
DECLARE @iDepth INT
SET @iDepth = (SELECT MAX( Depth ) + 1 FROM code.closure WHERE Descendant = @iParent)

INSERT INTO code.closure( Ancestor, Descendant, Depth )
SELECT Ancestor, @iKey Descendant, Depth + 1 FROM code.closure
WHERE Descendant = @iParent
UNION ALL
SELECT @iKey, @iKey, 0

links:
https://www.depesz.com/2008/04/11/my-take-on-trees-in-sql/
https://www.percona.com/blog/2011/02/14/moving-_D_Movings-in-closure-table/
http://goodfast.info/post/transitive-closures/
http://journal.ethanshub.com/post/category/mysql/transitive-closure



-- Move node
      First delete

@iKey = key to node that is removed and moved
@iNewAncestor = new Ancestor where tree is inserted
DELETE FROM code.closure
WHERE 
   Descendant IN( SELECT C.Descendant FROM code.closure C WHERE C.Ancestor = @iKey ) 
   AND Ancestor NOT IN ( SELECT C.Descendant FROM code.closure C WHERE C.Ancestor = @iKey )

INSERT INTO code.closure (Ancestor, Descendant, length)
SELECT _D_MovingTo.Ancestor, _D_Moving.Descendant,
_D_MovingTo.length+_D_Moving.length+1
FROM code.closure AS _D_MovingTo JOIN code.closure AS _D_Moving
WHERE _D_Moving.Ancestor = @iKey
AND _D_MovingTo.Descendant = @iNewAncestor;


;WITH cte_paths 
AS
(
   SELECT CodeK Id, FName Name, SuperK Parent, 0 AS Depth, CAST('' AS VARCHAR(MAX)) TreePath, ROW_NUMBER() OVER( ORDER BY (SELECT 1)) - 1 AS Row
   FROM code.TCode 
   WHERE SuperK IS NULL

   UNION ALL

   SELECT c.CodeK, c.FName, c.SuperK, Depth + 1, CAST( TreePath + '.' + CAST(c.CodeK AS VARCHAR(MAX)) AS VARCHAR(MAX)) AS TreePath, ROW_NUMBER() OVER( ORDER BY (SELECT 1)) AS Row
   FROM code.TCode c JOIN cte_paths tt ON c.SuperK = tt."Id"

)

SELECT * FROM cte_paths



DECLARE @iThread INT = 15

;WITH cte_paths 
AS
(
   SELECT @iThread Thread, CodeK, 0 AS Depth
   FROM code.TCode
   WHERE CodeK = @iThread AND SuperK IS NULL

   UNION ALL

   SELECT @iThread Thread, c.CodeK, _cte.Depth + 1
   FROM code.TCode c JOIN cte_paths _cte ON c.SuperK = _cte.CodeK
)
INSERT INTO code.thread( FThreadId, FKey, FDepth, FNext )
SELECT *, ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) - 1 FROM cte_paths


;WITH cte_paths 
AS
(
   SELECT CodeK, CAST('00000' AS VARCHAR(1024)) Path
   FROM code.TCode
   WHERE CodeK = @iThread AND SuperK IS NULL

   UNION ALL

   SELECT c.CodeK, CAST( _cte.Path + '/' + FORMAT( t.FNext, '0000#') AS VARCHAR(1024))
   FROM code.TCode c 
        JOIN cte_paths _cte ON c.SuperK = _cte.CodeK
        JOIN code.thread t ON c.CodeK = t.FKey
)
UPDATE t
SET t.FPath = cte.Path
FROM code.thread t JOIN cte_paths cte ON t.FKey = cte.CodeK


select * from code.thread


 */

PRINT('CREATE TABLE closure'); CREATE TABLE code."closure" (
   "Ancestor" INT NOT NULL
   ,"Descendant" INT NOT NULL
   ,"Depth" INT NOT NULL
   ,CONSTRAINT "code.FK_closure_Ancestor" FOREIGN KEY ("Ancestor") REFERENCES code."TCode"("CodeK") ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "code.IC_closure_Ancestor" ON code."closure" ("Ancestor")

PRINT('CREATE TABLE thread_header, information about each code thread'); CREATE TABLE code."thread_header" (
   FThreadId INT NOT NULL
   ,FNextId INT NOT NULL DEFAULT 0
   ,CONSTRAINT "PK_thread_header_FThreadId" PRIMARY KEY ("FThreadId")
);

PRINT('CREATE TABLE thread, information about thread entries'); CREATE TABLE code."thread" (
   FThreadId INT NOT NULL
   ,FKey INT NOT NULL
   ,FDepth INT 
   ,FNext INT
   ,FPath VARCHAR(1024)
);
CREATE CLUSTERED INDEX "code.IC_thread_FThreadId" ON code."thread" ("FThreadId")


PRINT('CREATE TABLE TTag, tag that could be used for hashtags'); CREATE TABLE code."TTag" (
    TagK BIGINT IDENTITY(1,1) NOT NULL
   ,CreatedD DATETIME
   ,FName NVARCHAR(100)
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,FInteger0 BIGINT
   ,CONSTRAINT "code.PK_TTag_TagK" PRIMARY KEY NONCLUSTERED ("TagK")
);

CREATE CLUSTERED INDEX "code.IC_TTag_FName" ON code."TTag" ("FName");

CREATE TABLE code.type (
   "group" INT NOT NULL
   ,"number" INT NOT NULL
   ,"name" VARCHAR(100)
   ,"description" VARCHAR(200)
);

DELETE FROM code.type;
INSERT INTO code.type
VALUES 
-- code types
   ( 3020, 1, 'time', 'code is time related, time is important, information may have a start and end' )
   ,( 3020, 2, 'value', 'code is value related, it presents some sort of value' )
   ,( 3020, 3, 'location', 'area or location is related to this code' )
   ,( 3020, 4, 'documentation', 'code is used to present some sort of documentation' )
   ,( 3020, 5, 'task', 'code is task related, some sort of assignment')
   ,( 3020, 6, 'ended', 'not active, marks that this has ended')      
   ,( 3020, 7, 'product', 'product or asset related item')
   ,( 3020, 8, 'order', 'it is possible to order items based on code value') 
   ,( 3020, 9, 'message', 'some sort of message, like in discussion or other type of communication') 
;


CREATE TABLE code.table_number (
   "number" INT NOT NULL
   ,"name" NVARCHAR(100)
);

DELETE FROM code.table_number;
INSERT INTO code.table_number
VALUES (300,'TGroup'),(301,'TBaseCode'),(302,'TCode'),(303,'TProperty'),(304,'TPropertyKey'),
       (305,'TTag');

DROP TABLE documentation.describe_schema;
CREATE TABLE documentation.describe_schema (
   SchemaK INT PRIMARY KEY
   ,FName  VARCHAR(200)
);

DROP TABLE documentation.describe_table;
CREATE TABLE documentation.describe_table (
   TableK INT PRIMARY KEY
   ,SchemaK INT
   ,FName  VARCHAR(200)
   ,FSimpleName  VARCHAR(200)
   ,FBrief VARCHAR(500)
   ,FDescription VARCHAR(MAX)
   ,FSchema  VARCHAR(100)
   ,FTableNumber INT
);

DROP TABLE documentation.describe_column;
CREATE TABLE documentation.describe_column (
   ColumnK INT PRIMARY KEY
   ,TableK INT
   ,FName  VARCHAR(200)
   ,FSimpleName  VARCHAR(200)
   ,FApplicationType VARCHAR(200)
   ,FEdit SMALLINT
   ,FBrief VARCHAR(500)
   ,FDescription VARCHAR(MAX)
);
       

