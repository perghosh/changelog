/*
   ### Table tree
   
   TRepository
      TExample ( RepositoryK - ParentK  )
      TObject (object, module, package, file etc)
         TExample ( ObjectK - ParentK  )
         TFunction
            TExample ( FunctionK - ParentK  )
            TParameter
               TExample ( ParameterK - ParentK  )

 
 */

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'api' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "api";';
END


IF OBJECT_ID('api.TrFunctionXExample', 'U') IS NOT NULL  DROP TABLE api.TrFunctionXExample;
IF OBJECT_ID('api.TrObjectXParameterType', 'U') IS NOT NULL  DROP TABLE api.TrObjectXParameterType;

IF OBJECT_ID('api.TExampleRemark', 'U') IS NOT NULL  DROP TABLE api.TExampleRemark;
IF OBJECT_ID('api.TExample', 'U') IS NOT NULL  DROP TABLE api.TExample;
IF OBJECT_ID('api.TParameter', 'U') IS NOT NULL  DROP TABLE api.TParameter;
IF OBJECT_ID('api.TParameterType', 'U') IS NOT NULL  DROP TABLE api.TParameterType;
IF OBJECT_ID('api.TFunction', 'U') IS NOT NULL  DROP TABLE api.TFunction;
IF OBJECT_ID('api.TObjectChapter', 'U') IS NOT NULL  DROP TABLE api.TObjectChapter;
IF OBJECT_ID('api.TObject', 'U') IS NOT NULL  DROP TABLE api.TObject;
IF OBJECT_ID('api.TRepository', 'U') IS NOT NULL  DROP TABLE api.TRepository;

CREATE TABLE api.TRepository (
   RepositoryK INT IDENTITY(1,1) PRIMARY KEY NOT NULL
   ,LanguageC INT
   ,FName NVARCHAR(300)
);

CREATE TABLE api.TObject (
   ObjectK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,RepositoryK INT 
   ,SuperK BIGINT                                           -- owner TObject
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,EnvironmentC INT                   -- type of environment like javascript, c++, xml, and more
                                       -- Other codes depends on this code
   ,StateC INT                         -- Object state like idea, alpha, beta
   ,TypeC INT                          -- Type of object, can be a file, class, globals etc.
   ,NamespaceC INT                     -- namespace for object (could be many namespaces, try tree functionality for code)
   ,LanguageC INT                      -- code language function is in
   ,ReturnC INT                        -- return type as code, this should be the parent to returns for connected functions
   ,FName NVARCHAR(300)                -- object name
   ,FInternalName NVARCHAR(100)        -- name for object internally
   ,FDeclaration NVARCHAR(1000)        -- object declaration
   ,FDescription NVARCHAR(1000)        -- short object description, may be used for hashtags
   ,FVersionBegin BIGINT               -- version when parameter works
   ,FVersionEnd BIGINT                 -- version when parameter don't work
   ,FBeta SMALLINT DEFAULT 0           -- object is beta
   ,FDepreciated SMALLINT DEFAULT 0    -- old, do not use
   ,FDeleted SMALLINT DEFAULT 0        -- deleted
);

CREATE CLUSTERED INDEX IC_TObject_RepositoryK ON api.TObject (RepositoryK)
CREATE INDEX I_TObject_FName ON api.TObject (FName)

/*
   Used to group functions based on object functions belongs to. Chapters can be used to divide methods
   and it is probably best to connect chapters to the root object.
 */
CREATE TABLE api.TObjectChapter (
   ObjectChapterK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ObjectK BIGINT
   ,ParentObjectK BIGINT      -- Used for inheritance, like when functions are categorized. It should be possible to extend another chapters (from object)
   ,SuperK BIGINT             -- owner TObjectChapter when used in hierarchical structure
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                 -- Root type, C++ has types, JS has types, SQL has types. C++, JS, SQL are roots
   ,StateC INT                -- Chapter state
   ,LanguageC INT             -- Language article is in
   ,FName NVARCHAR(500)       -- Chapter name
   ,FHeader NVARCHAR(200)
   ,FText NVARCHAR(MAX)       -- Chapter text
   ,FHelp NVARCHAR(1000)      -- Text field that may be used for specific UI and informing on how control the navigation
   ,FIndex INT                -- Used if chapters are ordered
   ,FReleased DATETIME
   ,FReady SMALLINT DEFAULT 0      -- book is ready (can be used to get valid book connecting articles)
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0    -- If book i deleted, like old
   ,CONSTRAINT FK_TObjectChapter_ObjectK FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TObjectChapter_ObjectChapterK  ON api.TObjectChapter (ObjectK);



/*
 */
CREATE TABLE api.TFunction (
   FunctionK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,RepositoryK INT
   ,ObjectK BIGINT 
   ,ObjectChapterK BIGINT              -- Use this to create navigation trees
   ,SuperK BIGINT                      -- owner TFunction
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                          -- TypeC should be a child type to main Type found in Object or root Object this function is connected to
   ,StateC INT                         -- in what state this object is in, alpha, beta, released, depreciated, removed
   ,EnvironmentC INT                   -- Type (like context, constructor, destructor, get, set etc) of function that is a sub type in code. Subtypes is dependent on parent type found in owning Object
   ,NamespaceC INT                     -- name space for function (could be many name spaces, try tree functionality for code)
   ,LanguageC INT                      -- code language function is in
   ,PriorityC INT                      -- If functions are prioritized
   ,AccessC INT                        -- Describe access control
   ,ReturnC INT                        -- return type as code, filter this for parent code in object owner
   ,FName NVARCHAR(500)                -- name of function
   ,FDeclaration NVARCHAR(2000)        -- function declaration
   ,FReturn NVARCHAR(100)              -- return value for function (complicated returns should be handled by other columns)
   ,FDescription NVARCHAR(MAX)         -- describe function
   ,FVersionBegin BIGINT               -- version when parameter works
   ,FVersionEnd BIGINT                 -- version when parameter don't work
   ,FBeta SMALLINT DEFAULT 0           -- function is beta
   ,FDepreciated SMALLINT DEFAULT 0    -- old, don't use
   ,FDeleted SMALLINT DEFAULT 0        -- deleted
   ,CONSTRAINT FK_TFunction_ObjectK FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
   ,CONSTRAINT FK_TFunction_ObjectChapterK FOREIGN KEY (ObjectChapterK) REFERENCES api.TObjectChapter(ObjectChapterK) 
);

CREATE CLUSTERED INDEX IC_TFunction_ObjectK ON api.TFunction (ObjectK)
CREATE INDEX I_TFunction_FName ON api.TFunction (FName)

/*
   #### Store overloaded functions. This is to list functions with different parameters but with same name.

 */
CREATE TABLE api.TFunctionOverload (
   FunctionOverloadK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,FunctionK BIGINT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                          -- TypeC should be a child type to main Type found in Object or root Object this function is connected to
   ,AccessC INT                        -- Describe access control
   ,ReturnC INT                        -- return type as code, filter this for parent code in object owner
   ,FDeclaration NVARCHAR(2000)        -- function declaration
   ,FReturn NVARCHAR(100)              -- return value for function (complicated returns should be handled by other columns)
   ,FDescription NVARCHAR(1000)        -- function description
   ,FVersionBegin BIGINT               -- version when parameter works
   ,FVersionEnd BIGINT                 -- version when parameter don't work
   ,FIndex INT                         -- If overloads is to be ordered
   ,FBeta SMALLINT DEFAULT 0           -- function is beta
   ,FDepreciated SMALLINT DEFAULT 0    -- old, don't use
   ,FDeleted SMALLINT DEFAULT 0        -- deleted
);

CREATE CLUSTERED INDEX IC_TFunctionOverload_FunctionK ON api.TFunctionOverload (FunctionK)


/*
   #### How does parameter type work.

   Adding parameters could be used as text and then the type is in `FType` column. Or it could be added
   to TParameterType. What is advantageous with that is that it can be changed for complete object tree.
   It will then use a key to `TParameterType` and these are connected to one root `TObject` or many if
   a relation table is used to connect.

 */
CREATE TABLE api.TParameter (
   ParameterK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,FunctionK BIGINT                   -- If parameter is for function, e.g. arguments sent to function
   ,ObjectK BIGINT                     -- If parameter is connected to object, e.g. class members
   ,ParameterTypeK BIGINT
   ,SuperK BIGINT                      -- owner TParameter
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                          -- TypeC what type, like constant, parameter, return
   ,ReturnC INT                        -- Return type is same code as code used int TFunction, TObject etc. It is a simple type describing what it is
   ,ContextC INT                       -- In what context parameter is in
   ,AccessC INT                        -- Describe access control
   ,FName NVARCHAR(250)                -- Parameter name
   ,FDeclaration NVARCHAR(500)         -- Parameter declaration
   ,FType NVARCHAR(250)                -- Type as free text, use this or ParameterTypeK
   ,FDescription NVARCHAR(2000)        -- Parameter described
   ,FVersionBegin BIGINT               -- version when parameter works
   ,FVersionEnd BIGINT                 -- version when parameter don't work
   ,FDepreciated SMALLINT DEFAULT 0    -- old, do not use
   ,FDeleted SMALLINT DEFAULT 0        -- deleted

   ,CONSTRAINT FK_TParameter_FunctionK FOREIGN KEY (FunctionK) REFERENCES api.TFunction(FunctionK) ON DELETE CASCADE
   ,CONSTRAINT FK_TParameter_ObjectK FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX IC_TParameter_FunctionK ON api.TParameter (FunctionK)

CREATE TABLE api.TParameterType (
   ParameterTypeK BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY NONCLUSTERED
   ,ObjectK BIGINT
   ,RepositoryK INT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,FName NVARCHAR(500)
   ,FDescription NVARCHAR(1000)
   ,CONSTRAINT FK_TParameterType_ObjectK FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX IC_TParameterType_ObjectK ON api.TParameterType (ObjectK)
CREATE INDEX I_TParameterType_RepositoryK ON api.TParameterType (RepositoryK)


CREATE TABLE api.item_name (
   ParameterTypeK BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY NONCLUSTERED
   ,ObjectK BIGINT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,FName NVARCHAR(500)
   ,FDescription NVARCHAR(1000)
   ,CONSTRAINT FK_TParameter_ObjectK FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
);


CREATE TABLE api.TExample (
   ExampleK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,RepositoryK INT
   ,SuperK BIGINT                      -- owner TExample
   ,RecordK BIGINT
   ,ParentK INT
   ,table_number INT                   -- Table number for describing what table note belongs to
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                          -- Type of example text
   ,LevelC INT                         -- Example or text level, this to sort out easy, difficult or something in between
   ,FBrief NVARCHAR(500)               -- Brief description about whats in text
   ,FBrief NVARCHAR(500)               -- Brief description about whats in text
   ,FText NVARCHAR(MAX)                -- Sample text
   ,FIndex INT                         -- Used if chapters are ordered
   ,FKey BIGINT                        -- Custom connection to external table
   ,FKey2 BIGINT                       -- Custom connection to external table
);

CREATE CLUSTERED INDEX IC_TExample_ParentK  ON api.TExample (ParentK);
CREATE INDEX I_TExample_RepositoryK  ON api.TExample (RepositoryK);

CREATE TABLE api.TExampleRemark (
   ExampleRemarkK BIGINT IDENTITY(1,1) NOT NULL
   ,ExampleK BIGINT NOT NULL
   ,UpdateD DATETIME NOT NULL
   ,TypeC INT                          -- Type of activity remark
   ,FRemark NVARCHAR(2000)             -- remark text
   ,FList INT                          -- Custom field, may be used to set specific filters
   ,FRank INT                          -- Custom field, may be used to set specific filters
   ,CONSTRAINT "FK_TExampleRemark_ExampleK" FOREIGN KEY ("ExampleK") REFERENCES api.TExample(ExampleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "api.IC_TExampleRemark_ExampleK"  ON api.TExampleRemark (ExampleK);



CREATE TABLE api.TrObjectXParameterType (
   rObjectXParameterTypeK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ObjectK BIGINT NOT NULL                                 -- Tip: This should point at root object
   ,ParameterTypeK BIGINT NOT NULL
   ,CONSTRAINT FK_TrObjectXParameterType_ObjectK FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrObjectXParameterType_ParameterTypeK FOREIGN KEY (ParameterTypeK) REFERENCES api.TParameterType(ParameterTypeK) ON DELETE NO ACTION
);
CREATE CLUSTERED INDEX IC_TrSystemXApiObject_ObjectK  ON api.TrObjectXParameterType (ObjectK);

CREATE TABLE api.TrExampleXParameterType (
   rObjectXParameterTypeK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ObjectK BIGINT NOT NULL                                 -- Tip: This should point at root object
   ,ParameterTypeK BIGINT NOT NULL
   ,CONSTRAINT FK_TrObjectXParameterType_ObjectK FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrObjectXParameterType_ParameterTypeK FOREIGN KEY (ParameterTypeK) REFERENCES api.TParameterType(ParameterTypeK) ON DELETE NO ACTION
);
CREATE CLUSTERED INDEX IC_TrSystemXApiObject_ObjectK  ON api.TrObjectXParameterType (ObjectK);


CREATE TABLE api.TrFunctionXExample (
   rFunctionXExampleK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,FunctionK BIGINT NOT NULL
   ,ExampleK BIGINT NOT NULL
   ,TypeC INT                          -- Type relation for function and example
   ,RoleC INT                          -- Role for function in example
   ,FDescription NVARCHAR(1000)        -- Describe relation
   ,CONSTRAINT FK_TrFunctionXExample_FunctionK FOREIGN KEY (FunctionK) REFERENCES api.TFunction(FunctionK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrFunctionXExample_ExampleK FOREIGN KEY (ExampleK) REFERENCES api.TExample(ExampleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrSystemXApiFunction_FunctionK  ON api.TrFunctionXExample (FunctionK);



CREATE TABLE api.table_number (
   number INT NOT NULL
   ,name NVARCHAR(100)
);

INSERT INTO api.table_number
VALUES (10000,'TRepository'),(10010,'TObject'),(10020,'TObjectChapter'),(10030,'TFunction'),(10040,'TParameter'),(10050,'TParameterType'),(10060,'TExample'),
(10065,'TExampleRemark'),(10100,'TrFunctionXExample'),(10110,'TrExampleXParameterType'),(10120,'TrObjectXParameterType')



DROP TRIGGER IF EXISTS api.TRIGGER_TObject_DELETE; 
GO
CREATE TRIGGER api.TRIGGER_TObject_DELETE ON api.TObject FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TObject' AND "schema" = 'api'); 
   DECLARE @iKey INT = (SELECT TOP 1 ObjectK FROM DELETED) -- Get key value

   DELETE FROM api.TExample WHERE table_number = @iTable AND RecordK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TArticleChapter WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TrXBadge WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
END
GO


DROP TRIGGER IF EXISTS api.TRIGGER_TFunction_DELETE; 
GO
CREATE TRIGGER api.TRIGGER_TFunction_DELETE ON api.TFunction FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TFunction' AND "schema" = 'api'); 
   DECLARE @iKey INT = (SELECT TOP 1 FunctionK FROM DELETED) -- Get key value

   DELETE FROM api.TExample WHERE table_number = @iTable AND RecordK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TArticleChapter WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TrXBadge WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
END
GO
