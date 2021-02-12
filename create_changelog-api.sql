IF OBJECT_ID('application.TrSystemXApiObject', 'U') IS NOT NULL  DROP TABLE application.TrSystemXApiObject;
IF OBJECT_ID('application.IC_TrSystemVersionXApiObject_ObjectK', 'U') IS NOT NULL  DROP TABLE application.IC_TrSystemVersionXApiObject_ObjectK;
IF OBJECT_ID('application.TrArticleBookXApiObject', 'U') IS NOT NULL  DROP TABLE application.TrArticleBookXApiObject;
IF OBJECT_ID('application.TrArticleChapterXApiExample', 'U') IS NOT NULL  DROP TABLE application.TrArticleChapterXApiExample;
IF OBJECT_ID('application.TrArticleChapterXApiFunction', 'U') IS NOT NULL  DROP TABLE application.TrArticleChapterXApiFunction;
IF OBJECT_ID('application.TrArticleChapterXApiParameter', 'U') IS NOT NULL  DROP TABLE application.TrArticleChapterXApiParameter;


CREATE TABLE application.TrSystemXApiObject (
   rSystemXApiObjectK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SystemK INT NOT NULL
   ,ObjectK BIGINT NOT NULL
   ,FExtra SMALLINT DEFAULT 0 -- If multiple connections between system and object then one connection is the main, others are extra
   ,CONSTRAINT "FK_TrSystemXApiObject_SystemK" FOREIGN KEY (SystemK) REFERENCES application.TSystem(SystemK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemXApiObject_ObjectK" FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemXApiObject_ObjectK"  ON application.TrSystemXApiObject (SystemK);


CREATE TABLE application.TrSystemVersionXApiObject (
   rSystemVersionXApiObjectK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SystemVersionK INT NOT NULL
   ,ObjectK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrSystemVersionXApiObject_SystemVersionK" FOREIGN KEY (SystemVersionK) REFERENCES application.TSystemVersion(SystemVersionK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemVersionXApiObject_ObjectK" FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemVersionXApiObject_ObjectK"  ON application.TrSystemVersionXApiObject (SystemVersionK);



CREATE TABLE application.TrArticleBookXApiObject (
   rArticleBookXApiObjectK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ArticleBookK INT NOT NULL
   ,ObjectK BIGINT NOT NULL
   ,TypeC INT                                               -- Type of relation between object and book
   ,FDescription NVARCHAR(500)
   ,FExtra SMALLINT DEFAULT 0 -- If multiple connections between ArticleBook and object then one connection is the main, others are extra
   ,FHelp SMALLINT DEFAULT 0  -- Connected books not related to object but useful for help 
   ,CONSTRAINT "FK_TrArticleBookXApiObject_ArticleBookK" FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrArticleBookXApiObject_ObjectK" FOREIGN KEY (ObjectK) REFERENCES api.TObject(ObjectK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrArticleBookXApiObject_ObjectK"  ON application.TrArticleBookXApiObject (ArticleBookK);

CREATE TABLE application.TrArticleXApiFunction (
   rArticleXApiFunction BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ArticleK BIGINT NOT NULL
   ,FunctionK BIGINT NOT NULL
   ,FDescription NVARCHAR(500)
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleXApiFunction_ArticleK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleXApiFunction_FunctionK FOREIGN KEY (FunctionK) REFERENCES api.TFunction(FunctionK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrArticleXApiFunction_FunctionK  ON application.TrArticleXApiFunction (FunctionK);

CREATE TABLE application.TrArticleXApiParameter (
   rArticleXApiParameter BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ArticleK BIGINT NOT NULL
   ,ParameterK BIGINT NOT NULL
   ,FDescription NVARCHAR(500)
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleXApiParameter_ArticleK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleXApiParameter_ParameterK FOREIGN KEY (ParameterK) REFERENCES api.TParameter(ParameterK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrArticleXApiParameter_ParameterK  ON application.TrArticleXApiParameter (ParameterK);


CREATE TABLE application.TrArticleChapterXApiExample (
   rArticleChapterXApiExample BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ArticleChapterK BIGINT NOT NULL
   ,ExampleK BIGINT NOT NULL
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleChapterXApiExample_ArticleChapterK FOREIGN KEY (ArticleChapterK) REFERENCES application.TArticleChapter(ArticleChapterK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleChapterXApiExample_ExampleK FOREIGN KEY (ExampleK) REFERENCES api.TExample(ExampleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrArticleChapterXApiExample_ArticleChapterK  ON application.TrArticleChapterXApiExample (ExampleK);


CREATE TABLE application.TrArticleChapterXApiFunction (
   rArticleChapterXApiFunction BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ArticleChapterK BIGINT NOT NULL
   ,FunctionK BIGINT NOT NULL
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleChapterXApiFunction_ArticleChapterK FOREIGN KEY (ArticleChapterK) REFERENCES application.TArticleChapter(ArticleChapterK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleChapterXApiFunction_FunctionK FOREIGN KEY (FunctionK) REFERENCES api.TFunction(FunctionK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrArticleChapterXApiFunction_ArticleChapterK  ON application.TrArticleChapterXApiFunction (ArticleChapterK);

CREATE TABLE application.TrArticleChapterXApiParameter (
   rArticleChapterXApiParameter BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ArticleChapterK BIGINT NOT NULL
   ,ParameterK BIGINT NOT NULL
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleChapterXApiParameter_ArticleChapterK FOREIGN KEY (ArticleChapterK) REFERENCES application.TArticleChapter(ArticleChapterK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleChapterXApiParameter_ParameterK FOREIGN KEY (ParameterK) REFERENCES api.TParameter(ParameterK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrArticleChapterXApiParameter_ArticleChapterK  ON application.TrArticleChapterXApiParameter (ParameterK);



/**
 * INSERT trigger for **TExample**
 */
DROP TRIGGER IF EXISTS api.TRIGGER_ApiTExample_INSERT; 
GO
CREATE TRIGGER api.TRIGGER_ApiTExample_INSERT ON api.TExample FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey BIGINT, @iSuper BIGINT, @iThread BIGINT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TExample'); 
   SELECT @iKey = ExampleK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;

   EXEC application.PROCEDURE_InsertTreeNode @iTable, @iKey, @iSuper
END
GO

/**
 * DELETE trigger for **TExample**
 *
 * `@iTable` - Has table number for TExample
 * `@iKey` - Key to deleted record in TExample
 */
DROP TRIGGER IF EXISTS api.TRIGGER_ApiTExample_DELETE;
GO
CREATE TRIGGER api.TRIGGER_ApiTExample_DELETE ON api.TExample FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TExample'); 
   DECLARE @iKey INT = (SELECT TOP 1 ExampleK FROM DELETED) -- Get key value
   DECLARE @iThread INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);
   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
      EXEC application.PROCEDURE_DeleteTreeNode @iTable, @iKey
END
GO


/**
 * DELETE trigger for **TObject**
 *
 * `@iTable` - Has table number for TSystem
 * `@iKey` - Key to deleted record in TSystem
 * `@sPath` - Path to record in table if it belongs to a thread
 * `@iThread` - Thread key it it is in thread
 */
DROP TRIGGER IF EXISTS api.TRIGGER_ApiTObject_DELETE; 
GO
CREATE TRIGGER api.TRIGGER_ApiTObject_DELETE ON api.TObject FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TObject'); 
   DECLARE @iKey BIGINT = (SELECT TOP 1 ObjectK FROM DELETED) -- Get key value
   DECLARE @sPath VARCHAR(1024) = (SELECT FPath FROM application.thread WHERE FKey = @iKey AND table_number = @iTable)
   DECLARE @iThread INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);
   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
      EXEC application.PROCEDURE_DeleteTreeNode @iTable, @iKey

   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TDocument WHERE table_number = @iTable AND RecordK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TDocument WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TrXBadge WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
   DELETE FROM application.TArticleChapter WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);

   DELETE FROM api.TExample WHERE table_number = @iTable AND ParentK IN(SELECT ObjectK FROM DELETED);
END
GO



/**
 * INSERT trigger for **TFunction**
 */
DROP TRIGGER IF EXISTS api.TRIGGER_ApiTFunction_INSERT; 
GO
CREATE TRIGGER api.TRIGGER_ApiTFunction_INSERT ON api.TFunction FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey BIGINT, @iSuper BIGINT, @iThread BIGINT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TFunction'); 
   SELECT @iKey = FunctionK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;

   EXEC application.PROCEDURE_InsertTreeNode @iTable, @iKey, @iSuper
END
GO

/**
 * DELETE trigger for **TFunction**
 *
 * `@iTable` - Has table number for TSystem
 * `@iKey` - Key to deleted record in TSystem
 * `@sPath` - Path to record in table if it belongs to a thread
 * `@iThread` - Thread key it it is in thread
 */

DROP TRIGGER IF EXISTS api.TRIGGER_ApiTFunction_DELETE; 
GO
CREATE TRIGGER api.TRIGGER_ApiTFunction_DELETE ON api.TFunction FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TFunction'); 
   DECLARE @iKey BIGINT = (SELECT TOP 1 FunctionK FROM DELETED) -- Get key value
   DECLARE @sPath VARCHAR(1024) = (SELECT FPath FROM application.thread WHERE FKey = @iKey AND table_number = @iTable)
   DECLARE @iThread INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);
   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
      EXEC application.PROCEDURE_DeleteTreeNode @iTable, @iKey

   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TDocument WHERE table_number = @iTable AND RecordK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TDocument WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
   DELETE FROM application.TrXBadge WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);

   DELETE FROM api.TExample WHERE table_number = @iTable AND ParentK IN(SELECT FunctionK FROM DELETED);
END
GO



/**
 * INSERT trigger for **TParameter**
 */
DROP TRIGGER IF EXISTS api.TRIGGER_ApiTParameter_INSERT; 
GO
CREATE TRIGGER api.TRIGGER_ApiTParameter_INSERT ON api.TParameter FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey BIGINT, @iSuper BIGINT, @iThread BIGINT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TParameter'); 
   SELECT @iKey = ParameterK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;

   EXEC application.PROCEDURE_InsertTreeNode @iTable, @iKey, @iSuper
END
GO

/**
 * DELETE trigger for **TParameter**
 *
 * `@iTable` - Has table number for TSystem
 * `@iKey` - Key to deleted record in TSystem
 * `@sPath` - Path to record in table if it belongs to a thread
 * `@iThread` - Thread key it it is in thread
 */

DROP TRIGGER IF EXISTS api.TRIGGER_ApiTParameter_DELETE; 
GO
CREATE TRIGGER api.TRIGGER_ApiTParameter_DELETE ON api.TParameter FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TParameter'); 
   DECLARE @iKey BIGINT = (SELECT TOP 1 ParameterK FROM DELETED) -- Get key value
   DECLARE @sPath VARCHAR(1024) = (SELECT FPath FROM application.thread WHERE FKey = @iKey AND table_number = @iTable)
   DECLARE @iThread INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);
   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
      EXEC application.PROCEDURE_DeleteTreeNode @iTable, @iKey

   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT ParameterK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT ParameterK FROM DELETED);
   DELETE FROM application.TDocument WHERE table_number = @iTable AND RecordK IN(SELECT ParameterK FROM DELETED);
   DELETE FROM application.TDocument WHERE table_number = @iTable AND ParentK IN(SELECT ParameterK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT ParameterK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT ParameterK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT ParameterK FROM DELETED);
   DELETE FROM application.TrXBadge WHERE table_number = @iTable AND ParentK IN(SELECT ParameterK FROM DELETED);

   DELETE FROM api.TExample WHERE table_number = @iTable AND ParentK IN(SELECT ParameterK FROM DELETED);
END
GO
