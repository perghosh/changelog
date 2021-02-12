/**
 * INSERT trigger for **TActivity**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TActivity_INSERT; 
GO
CREATE TRIGGER application.TRIGGER_TActivity_INSERT ON application.TActivity FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey BIGINT, @iSuper BIGINT, @iThread BIGINT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TActivity'); 
   SELECT @iKey = ActivityK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;

   EXEC application.PROCEDURE_InsertTreeNode @iTable, @iKey, @iSuper
END
GO




/**
 * DELETE trigger for **TActivity**
 *
 * `@iTable` - Has table number for TActivity
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TActivity_DELETE;
GO
CREATE TRIGGER application.TRIGGER_TActivity_DELETE ON application.TActivity FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TActivity'); 

   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT ActivityK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT ActivityK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT ActivityK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT ActivityK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT ActivityK FROM DELETED);
   DELETE FROM application.TState WHERE table_number = @iTable AND ParentK IN(SELECT ActivityK FROM DELETED);
   DELETE FROM application.TrXBadge WHERE table_number = @iTable AND ParentK IN(SELECT ActivityK FROM DELETED);
END
GO

/**
 * DELETE trigger for **TBadge**
 */
CREATE TRIGGER application.TRIGGER_TBadge_DELETE ON application.TBadge FOR DELETE AS
BEGIN
   DELETE FROM application.TrXBadge WHERE BadgeK IN(SELECT BadgeK FROM DELETED);
END
GO


/**
 * DELETE trigger for **TArticleBook**
 *
 * `@iTable` - Has table number for TActivity
 */
/*
DROP TRIGGER IF EXISTS application.TRIGGER_TArticleBook_DELETE;
CREATE TRIGGER application.TRIGGER_TArticleBook_DELETE ON application.TArticleBook FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticleBook'); 

   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TState WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TrXBadge WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);

   DELETE FROM application.TArticle WHERE ArticleBookK IN(SELECT ArticleBookK FROM DELETED);
END


GO
*/


/**
 * INSERT trigger for **TCustomer**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TCustomer_INSERT; 
GO
CREATE TRIGGER application.TRIGGER_TCustomer_INSERT ON application.TCustomer FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey BIGINT, @iSuper BIGINT, @iThread BIGINT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TCustomer'); 
   SELECT @iKey = CustomerK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;

   EXEC application.PROCEDURE_InsertTreeNode @iTable, @iKey, @iSuper
END
GO


/**
 * DELETE trigger for **TCustomer**
 *
 * `@iTable` - Has table number for TCustomer
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TCustomer_DELETE;
GO
CREATE TRIGGER application.TRIGGER_TCustomer_DELETE ON application.TCustomer FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TCustomer'); 

   DELETE FROM application.TCost WHERE CustomerK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TSale WHERE CustomerK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TCustomerContact WHERE CustomerK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TTodoList WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TProperty WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TProject WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TUserPinned WHERE table_number = @iTable AND RecordK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TAddress WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TNumber WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);
   DELETE FROM application.TTodoList WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);

   DELETE FROM application.TActivity WHERE table_number = @iTable AND ParentK IN(SELECT CustomerK FROM DELETED);
END
GO

/**
 * DELETE trigger for **TCustomerContact**
 *
 * `@iTable` - Has table number for TCustomerContact
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TCustomerContact_DELETE;
GO
CREATE TRIGGER application.TRIGGER_TCustomerContact_DELETE ON application.TCustomerContact FOR DELETE AS
BEGIN
   IF OBJECT_ID('tempdb..#DisableTrigger') IS NOT NULL RETURN;
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TCustomerContact'); 

   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT CustomerContactK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT CustomerContactK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT CustomerContactK FROM DELETED);
   DELETE FROM application.TProperty WHERE table_number = @iTable AND ParentK IN(SELECT CustomerContactK FROM DELETED);
   DELETE FROM application.TProject WHERE table_number = @iTable AND ParentK IN(SELECT CustomerContactK FROM DELETED);
   DELETE FROM application.TUserPinned WHERE table_number = @iTable AND RecordK IN(SELECT CustomerContactK FROM DELETED);
   DELETE FROM application.TAddress WHERE table_number = @iTable AND ParentK IN(SELECT CustomerContactK FROM DELETED);
   DELETE FROM application.TNumber WHERE table_number = @iTable AND ParentK IN(SELECT CustomerContactK FROM DELETED);

   DELETE FROM application.TActivity WHERE table_number = @iTable AND ParentK IN(SELECT CustomerContactK FROM DELETED);
   -- DELETE FROM extend.TField WHERE table_number = @iTable AND RecordK IN(SELECT CustomerContactK FROM DELETED);
END
GO

/**
 * INSERT trigger for **TArticle**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TArticle_INSERT;
GO
CREATE TRIGGER application.TRIGGER_TArticle_INSERT ON application.TArticle FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey INT, @iSuper INT, @iThread INT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticle'); 
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = ArticleK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;
   
   IF @iSuper > 0
   BEGIN
      -- Make sure there entry for Super exists in thread, this is required if super isn't null or 0
      IF (SELECT COUNT(*) FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable ) = 0
      BEGIN
         -- No super found, then this is a new thread and that means we need to create data for the thread
         SET @iThread = @iSuper
         SET @sPath = '0000'
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iThread, @iTable )
         INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iThread, @iTable, @iSuper, 0, 0, @sPath )
         SET @iDepth = 1
      END
      ELSE
      BEGIN
         -- Seth thread id and path for super (parent)
         SELECT @iThread = FThreadId, @sPath = FPath, @iDepth = FDepth + 1
         FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable
      END

      -- Add to thread
      UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThread AND table_number = @iTable;
      SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThread AND table_number = @iTable;
      SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
      INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThread,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
   END
END
GO

/**
 * UPDATE trigger for **TArticle**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TArticle_UPDATE;
GO
CREATE TRIGGER application.TRIGGER_TArticle_UPDATE ON application.TArticle FOR UPDATE AS
BEGIN
   IF OBJECT_ID('tempdb..#DisableTrigger') IS NOT NULL RETURN;

   SET NOCOUNT ON;
   DECLARE @iTable INT = 1160; -- 1160 = TArticle
   DECLARE @iKey BIGINT
   DECLARE @iSuperNew BIGINT
   DECLARE @iSuperOld BIGINT
   SELECT @iKey = ArticleK, @iSuperNew = ISNULL(SuperK,0) FROM INSERTED;
   SELECT @iSuperOld = ISNULL(SuperK,0) FROM DELETED;

   EXEC application.PROCEDURE_UpdateTreeNode @iTable, @iKey,  @iSuperNew, @iSuperOld

   IF @iSuperNew = @iKey
   BEGIN
      UPDATE application.TArticle SET SuperK = NULL WHERE ArticleK = @iKey;
   END
END
GO

/**
 * INSERT trigger for **TArticleChapter**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TArticleChapter_INSERT; 
GO
CREATE TRIGGER application.TRIGGER_TArticleChapter_INSERT ON application.TArticleChapter FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey BIGINT, @iSuper BIGINT, @iThread BIGINT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticleChapter'); 
   SELECT @iKey = ArticleChapterK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;

   EXEC application.PROCEDURE_InsertTreeNode @iTable, @iKey, @iSuper
END
GO


/**
 * UPDATE trigger for **TArticleChapter**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TArticleChapter_UPDATE;
GO
CREATE TRIGGER application.TRIGGER_TArticleChapter_UPDATE ON application.TArticleChapter FOR UPDATE AS
BEGIN
   IF OBJECT_ID('tempdb..#DisableTrigger') IS NOT NULL RETURN;

   SET NOCOUNT ON;
   DECLARE @iTable INT = 1250; -- 1160 = TArticle
   DECLARE @iKey BIGINT
   DECLARE @iSuperNew BIGINT
   DECLARE @iSuperOld BIGINT
   SELECT @iKey = ArticleChapterK, @iSuperNew = ISNULL(SuperK,0) FROM INSERTED;
   SELECT @iSuperOld = ISNULL(SuperK,0) FROM DELETED;

   EXEC application.PROCEDURE_UpdateTreeNode @iTable, @iKey,  @iSuperNew, @iSuperOld

   IF @iSuperNew = @iKey
   BEGIN
      UPDATE application.TArticle SET SuperK = NULL WHERE ArticleK = @iKey;
   END
END
GO

/**
 * DELETE trigger for **TArticleChapter**
 *
 * `@iTable` - Has table number for TArticleChapter
 * `@iKey` - Key to deleted record in TArticleChapter
 * `@sPath` - Path to record in table if it belongs to a thread
 * `@iThread` - Thread key it it is in thread
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TArticleChapter_DELETE;
GO
CREATE TRIGGER application.TRIGGER_TArticleChapter_DELETE ON application.TArticleChapter FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticleChapter'); 
   DECLARE @iKey INT = (SELECT TOP 1 ArticleChapterK FROM DELETED) -- Get key value

   EXEC application.PROCEDURE_DeleteTreeNode @iTable, @iKey
END
GO



/*
DROP TRIGGER IF EXISTS application.TRIGGER_TArticle_UPDATE;
GO
CREATE TRIGGER application.TRIGGER_TArticle_UPDATE ON application.TArticle FOR UPDATE AS
BEGIN
   IF OBJECT_ID('tempdb..#DisableTrigger') IS NOT NULL RETURN;

   SET NOCOUNT ON;
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticle'); 
   DECLARE @iKey INT, @iSuperNew INT, @iSuperOld INT, @iNextId INT, @iDepth INT
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = ArticleK, @iSuperNew = ISNULL(SuperK,0) FROM INSERTED;
   SELECT @iSuperOld = ISNULL(SuperK,0) FROM DELETED;
   DECLARE @iThreadOld INT = (SELECT TOP 1 FThreadId  FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);


   -- Check if there is an entry for node in tree. Look for Ancestor equal to SuperK and Descendant equal to ArticleK

   IF @iSuperNew = @iSuperOld -- No thread change?
      RETURN;

   -- If Super is 0, then old position in thread means that this was the root. Delete the complete thread
   IF @iSuperOld = 0 AND @iThreadOld IS NOT NULL
   BEGIN
      DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;

      -- clear thread in TArticle for @iThreadOld
      UPDATE _article 
      SET SuperK = NULL
      FROM application.TArticle _article
      JOIN application.thread _thread ON _article.ArticleK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThreadOld;
   END
   ELSE IF @iSuperOld > 0 
   BEGIN
      -- remove system record from tree and render new system tree
      DECLARE @iSuper BIGINT = (SELECT SuperK FROM application.TArticle WHERE ArticleK = @iKey);
      UPDATE _article
      SET SuperK = @iSuper
      FROM application.TArticle _article
      WHERE _article.SuperK = @iKey;

      -- Delete thread entry
      DELETE FROM application.thread WHERE FKey = @iKey AND table_number = @iTable

      -- If only one root item in thread, then delete complete thread
      IF (SELECT COUNT(*) FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable) = 1
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      END
      ELSE
         -- Render complete thread
         EXEC application.PROCEDURE_RenderTree @iSuperOld, 'TArticle'
   END

   -- Old thread is now ok, time to investigate the new thread

   IF @iSuperNew = 0 -- No Super means that we haven't placed this in a new thread and we can return
      RETURN;

   DECLARE @iThreadNew INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable);

   IF @iThreadNew IS NULL -- If new super is null then we need to create a new thread with this as the root
   BEGIN
      SET @sPath = '0000'
      INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
      INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iSuperNew, @iTable, @iSuperNew, 0, 0, @sPath )
      SET @iThreadNew = @iSuperNew
      SET @iDepth = 1
   END
   ELSE
   BEGIN

      -- There should be a thread_header for this post but if it is not found then generate it
      IF (SELECT COUNT(*) FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable) = 0
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadNew AND table_number = @iTable;
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
         EXEC application.PROCEDURE_RenderTree @iSuperNew, 'TArticle'
         RETURN
      END

      -- Seth thread id and path for super (parent)
      SELECT @sPath = FPath, @iDepth = FDepth + 1
      FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable
   END

   UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThreadNew AND table_number = @iTable;
   SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable;
   SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
   INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThreadNew,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
END
GO
*/

/**
 * DELETE trigger for **TArticle**
 *
 * `@iTable` - Has table number for TArticle
 * `@iKey` - Key to deleted record in TArticle
 * `@sPath` - Path to record in table if it belongs to a thread
 * `@iThread` - Thread key it it is in thread
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TArticle_DELETE;
GO
CREATE TRIGGER application.TRIGGER_TArticle_DELETE ON application.TArticle FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticle'); 
   DECLARE @iKey INT = (SELECT TOP 1 ArticleK FROM DELETED) -- Get key value
   DECLARE @sPath VARCHAR(1024) = (SELECT FPath FROM application.thread WHERE FKey = @iKey AND table_number = @iTable)
   DECLARE @iThread INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);


   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
   BEGIN
      CREATE TABLE #DisableTrigger(ID INT) 

      -- Clear all super fields for descendants
      UPDATE _article 
      SET SuperK = NULL
      FROM application.TArticle _article
      JOIN application.thread _thread ON _article.ArticleK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThread AND FPath LIKE @sPath + '%';

      DROP TABLE #DisableTrigger

      IF @iKey = @iThread
      BEGIN
         -- Delete complete thread
         DELETE FROM application.thread WHERE FThreadId = @iKey AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iKey AND table_number = @iTable;
      END
      ELSE
      BEGIN
         -- Delete part of thread
         DELETE FROM application.thread  WHERE FThreadId = @iThread AND table_number = @iTable AND FPath LIKE @sPath + '%';
      END
   END

   DELETE FROM application.TArticle WHERE table_number = @iTable AND ParentK IN(SELECT ArticleK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT ArticleK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT ArticleK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT ArticleK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT ArticleK FROM DELETED);
   DELETE FROM application.TState WHERE table_number = @iTable AND ParentK IN(SELECT ArticleK FROM DELETED);
   DELETE FROM extend.TField WHERE table_number = @iTable AND RecordK IN(SELECT ArticleK FROM DELETED);
END
GO



/**
 * INSERT trigger for **TArticleBook**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TArticleBook_INSERT;
GO
CREATE TRIGGER application.TRIGGER_TArticleBook_INSERT ON application.TArticleBook FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey INT, @iSuper INT, @iThread INT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticleBook'); 
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = ArticleBookK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;
   
   IF @iSuper > 0
   BEGIN
      IF @iKey = @iSuper RETURN;
      -- Make sure there entry for Super exists in thread, this is required if super isn't null or 0
      IF (SELECT COUNT(*) FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable ) = 0
      BEGIN
         -- No super found, then this is a new thread and that means we need to create data for the thread
         SET @iThread = @iSuper
         SET @sPath = '0000'
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iThread, @iTable )
         INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iThread, @iTable, @iSuper, 0, 0, @sPath )
         SET @iDepth = 1
      END
      ELSE
      BEGIN
         -- Seth thread id and path for super (parent)
         SELECT @iThread = FThreadId, @sPath = FPath, @iDepth = FDepth + 1
         FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable
      END

      -- Add to thread
      UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThread AND table_number = @iTable;
      SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThread AND table_number = @iTable;
      SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
      INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThread,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
   END
END
GO

/**
 * UPDATE trigger for **TArticleBook**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TArticleBook_UPDATE;
GO
CREATE TRIGGER application.TRIGGER_TArticleBook_UPDATE ON application.TArticleBook FOR UPDATE AS
BEGIN
   IF OBJECT_ID('tempdb..#DisableTrigger') IS NOT NULL RETURN;

   SET NOCOUNT ON;
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticleBook'); 
   DECLARE @iKey INT, @iSuperNew INT, @iSuperOld INT, @iNextId INT, @iDepth INT
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = ArticleBookK, @iSuperNew = ISNULL(SuperK,0) FROM INSERTED;
   SELECT @iSuperOld = ISNULL(SuperK,0) FROM DELETED;
   DECLARE @iThreadOld INT = (SELECT TOP 1 FThreadId  FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);


   -- Check if there is an entry for node in tree. Look for Ancestor equal to SuperK and Descendant equal to ArticleBookK

   IF @iSuperNew = @iSuperOld -- No thread change?
      RETURN;

   -- If Super is 0, then old position in thread means that this was the root. Delete the complete thread
   IF @iSuperOld = 0 AND @iThreadOld IS NOT NULL
   BEGIN
      DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;

      -- clear thread in TArticleBook for @iThreadOld
      UPDATE _articlebook 
      SET SuperK = NULL
      FROM application.TArticleBook _articlebook
      JOIN application.thread _thread ON _articlebook.ArticleBookK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThreadOld;
   END
   ELSE IF @iSuperOld > 0 
   BEGIN
      -- remove system record from tree and render new system tree
      DECLARE @iSuper INT = (SELECT SuperK FROM application.TArticleBook WHERE ArticleBookK = @iKey);
      UPDATE _articlebook
      SET SuperK = @iSuper
      FROM application.TArticleBook _articlebook
      WHERE _articlebook.SuperK = @iKey;

      -- Delete thread entry
      DELETE FROM application.thread WHERE FKey = @iKey AND table_number = @iTable

      -- If only one root item in thread, then delete complete thread
      IF (SELECT COUNT(*) FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable) = 1
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      END
      ELSE
         -- Render complete thread
         EXEC application.PROCEDURE_RenderTree @iSuperOld, 'TArticleBook'
   END

   -- Old thread is now ok, time to investigate the new thread

   IF @iSuperNew = 0 RETURN; -- No Super means that we haven't placed this in a new thread and we can return
   IF @iKey = @iSuperNew RETURN; -- Same super as key

   DECLARE @iThreadNew INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable);

   IF @iThreadNew IS NULL -- If new super is null then we need to create a new thread with this as the root
   BEGIN
      SET @sPath = '0000'
      INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
      INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iSuperNew, @iTable, @iSuperNew, 0, 0, @sPath )
      SET @iThreadNew = @iSuperNew
      SET @iDepth = 1
   END
   ELSE
   BEGIN

      -- There should be a thread_header for this post but if it is not found then generate it
      IF (SELECT COUNT(*) FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable) = 0
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadNew AND table_number = @iTable;
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
         EXEC application.PROCEDURE_RenderTree @iSuperNew, 'TArticleBook'
         RETURN
      END

      -- Seth thread id and path for super (parent)
      SELECT @sPath = FPath, @iDepth = FDepth + 1
      FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable
   END

   UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThreadNew AND table_number = @iTable;
   SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable;
   SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
   INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThreadNew,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
END
GO


DROP TRIGGER IF EXISTS application.TRIGGER_TArticleBook_DELETE;
GO
/**
 * DELETE trigger for **TArticleBook**
 *
 * `@iTable` - Has table number for TArticleBook
 * `@iKey` - Key to deleted record in TArticleBook
 * `@sPath` - Path to record in table if it belongs to a thread
 * `@iThread` - Thread key it it is in thread
 */
CREATE TRIGGER application.TRIGGER_TArticleBook_DELETE ON application.TArticleBook FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TArticleBook'); 
   DECLARE @iKey INT = (SELECT TOP 1 ArticleBookK FROM DELETED) -- Get key value
   DECLARE @sPath VARCHAR(1024) = (SELECT FPath FROM application.thread WHERE FKey = @iKey AND table_number = @iTable)
   DECLARE @iThread INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);


   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
   BEGIN
      EXEC application.PROCEDURE_DeleteTreeNode @iTable, @iKey
   END
   

   DELETE FROM application.TArticleBook WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TState WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TTodoList WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
   DELETE FROM application.TrXBadge WHERE table_number = @iTable AND ParentK IN(SELECT ArticleBookK FROM DELETED);
END
GO

/**
 * INSERT trigger for **TLink**
 * This is to manage hashtags for links
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TLink_INSERT;
GO
CREATE TRIGGER application.TRIGGER_TLink_INSERT ON application.TLink FOR INSERT AS
BEGIN
   DECLARE @iKey BIGINT
   DECLARE @sNewDescription NVARCHAR(1000)
   SELECT @iKey = LinkK, @sNewDescription = FDescription FROM INSERTED;
   EXEC application.PROCEDURE_UpdateBadge @sNewDescription, 'TLink', @iKey
END
GO

/**
 * UPDATE trigger for **TLink**
 * This is to manage hashtags for links
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TLink_UPDATE;
GO
CREATE TRIGGER application.TRIGGER_TLink_UPDATE ON application.TLink FOR UPDATE AS
BEGIN
   DECLARE @iKey BIGINT
   DECLARE @sNewDescription NVARCHAR(1000)

   SELECT @iKey = LinkK, @sNewDescription = FDescription FROM INSERTED;
   EXEC application.PROCEDURE_UpdateBadge @sNewDescription, 'TLink', @iKey
END
GO



/**
 * INSERT trigger for **TProject**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TProject_INSERT;
GO
CREATE TRIGGER application.TRIGGER_TProject_INSERT ON application.TProject FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey INT, @iSuper INT, @iThread INT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TProject'); 
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = ProjectK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;
   
   IF @iSuper > 0
   BEGIN
      -- Make sure there entry for Super exists in thread, this is required if super isn't null or 0
      IF (SELECT COUNT(*) FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable ) = 0
      BEGIN
         -- No super found, then this is a new thread and that means we need to create data for the thread
         SET @iThread = @iSuper
         SET @sPath = '0000'
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iThread, @iTable )
         INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iThread, @iTable, @iSuper, 0, 0, @sPath )
         SET @iDepth = 1
      END
      ELSE
      BEGIN
         -- Seth thread id and path for super (parent)
         SELECT @iThread = FThreadId, @sPath = FPath, @iDepth = FDepth + 1
         FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable
      END

      -- Add to thread
      UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThread AND table_number = @iTable;
      SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThread AND table_number = @iTable;
      SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
      INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThread,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
   END
END
GO

/**
 * UPDATE trigger for **TProject**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TProject_UPDATE;
GO
CREATE TRIGGER application.TRIGGER_TProject_UPDATE ON application.TProject FOR UPDATE AS
BEGIN
   IF OBJECT_ID('tempdb..#DisableTrigger') IS NOT NULL RETURN;

   SET NOCOUNT ON;
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TProject'); 
   DECLARE @iKey INT, @iSuperNew INT, @iSuperOld INT, @iNextId INT, @iDepth INT
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = ProjectK, @iSuperNew = ISNULL(SuperK,0) FROM INSERTED;
   SELECT @iSuperOld = ISNULL(SuperK,0) FROM DELETED;
   DECLARE @iThreadOld INT = (SELECT TOP 1 FThreadId  FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);


   -- Check if there is an entry for node in tree. Look for Ancestor equal to SuperK and Descendant equal to ProjectK

   IF @iSuperNew = @iSuperOld -- No thread change?
      RETURN;

   -- If Super is 0, then old position in thread means that this was the root. Delete the complete thread
   IF @iSuperOld = 0 AND @iThreadOld IS NOT NULL
   BEGIN
      DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;

      -- clear thread in TProject for @iThreadOld
      UPDATE _project 
      SET SuperK = NULL
      FROM application.TProject _project
      JOIN application.thread _thread ON _project.ProjectK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThreadOld;
   END
   ELSE IF @iSuperOld > 0 
   BEGIN
      -- remove project record from tree and render new project tree
      DECLARE @iSuper INT = (SELECT SuperK FROM application.TProject WHERE ProjectK = @iKey);
      UPDATE _project
      SET SuperK = @iSuper
      FROM application.TProject _project
      WHERE _project.SuperK = @iKey;

      -- Delete thread entry
      DELETE FROM application.thread WHERE FKey = @iKey AND table_number = @iTable

      -- If only one root item in thread, then delete complete thread
      IF (SELECT COUNT(*) FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable) = 1
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      END
      ELSE
         -- Render complete thread
         EXEC application.PROCEDURE_RenderTree @iSuperOld, 'TProject'
   END

   -- Old thread is now ok, time to investigate the new thread

   IF @iSuperNew = 0 -- No Super means that we haven't placed this in a new thread and we can return
      RETURN;

   DECLARE @iThreadNew INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable);

   IF @iThreadNew IS NULL -- If new super is null then we need to create a new thread with this as the root
   BEGIN
      SET @sPath = '0000'
      INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
      INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iSuperNew, @iTable, @iSuperNew, 0, 0, @sPath )
      SET @iThreadNew = @iSuperNew
      SET @iDepth = 1
   END
   ELSE
   BEGIN

      -- There should be a thread_header for this post but if it is not found then generate it
      IF (SELECT COUNT(*) FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable) = 0
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadNew AND table_number = @iTable;
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
         EXEC application.PROCEDURE_RenderTree @iSuperNew, 'TProject'
         RETURN
      END

      -- Seth thread id and path for super (parent)
      SELECT @sPath = FPath, @iDepth = FDepth + 1
      FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable
   END

   UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThreadNew AND table_number = @iTable;
   SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable;
   SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
   INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThreadNew,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
END

GO

/**
 * DELETE trigger for **TProject**
 *
 * `@iTable` - Has table number for TProject
 * `@iKey` - Key to deleted record in TProject
 * `@sPath` - Path to record in table if it belongs to a thread
 * `@iThread` - Thread key it it is in thread
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TProject_DELETE; 
GO
CREATE TRIGGER application.TRIGGER_TProject_DELETE ON application.TProject FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TProject'); 
   DECLARE @iKey INT = (SELECT TOP 1 ProjectK FROM DELETED) -- Get key value
   DECLARE @sPath VARCHAR(1024) = (SELECT FPath FROM application.thread WHERE FKey = @iKey AND table_number = @iTable)
   DECLARE @iThread INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);


   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
   BEGIN
      CREATE TABLE #DisableTrigger(ID INT) 

      -- Clear all super fields for descendants
      UPDATE _project 
      SET SuperK = NULL
      FROM application.TProject _project
      JOIN application.thread _thread ON _project.ProjectK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThread AND FPath LIKE @sPath + '%';

      DROP TABLE #DisableTrigger

      IF @iKey = @iThread
      BEGIN
         -- Delete complete thread
         DELETE FROM application.thread WHERE FThreadId = @iKey AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iKey AND table_number = @iTable;
      END
      ELSE
      BEGIN
         -- Delete part of thread
         DELETE FROM application.thread  WHERE FThreadId = @iThread AND table_number = @iTable AND FPath LIKE @sPath + '%';
      END
   END

   DELETE FROM application.TArticle WHERE table_number = @iTable AND ParentK IN(SELECT ProjectK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT ProjectK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT ProjectK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT ProjectK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT ProjectK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT ProjectK FROM DELETED);
   DELETE FROM application.TState WHERE table_number = @iTable AND ParentK IN(SELECT ProjectK FROM DELETED);
   DELETE FROM application.TTodoList WHERE table_number = @iTable AND ParentK IN(SELECT ProjectK FROM DELETED);
   DELETE FROM application.TArticleBook WHERE table_number = @iTable AND ParentK IN(SELECT ProjectK FROM DELETED);

   -- DELETE FROM extend.TField WHERE table_number = @iTable AND RecordK IN(SELECT ProjectK FROM DELETED);
END

GO

/**
 * DELETE trigger for **TSale**
 *
 * `@iTable` - Has table number for TSale
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TSale_DELETE; 
GO
CREATE TRIGGER application.TRIGGER_TSale_DELETE ON application.TSale FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TSale'); 

   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT SaleK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT SaleK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT SaleK FROM DELETED);
   DELETE FROM application.TState WHERE table_number = @iTable AND ParentK IN(SELECT SaleK FROM DELETED);
   DELETE FROM application.TTodoList WHERE table_number = @iTable AND ParentK IN(SELECT SaleK FROM DELETED);
   DELETE FROM application.TArticleBook WHERE table_number = @iTable AND ParentK IN(SELECT SaleK FROM DELETED);
END
GO



/**
 * INSERT trigger for **TSystem**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TSystem_INSERT; 
GO
CREATE TRIGGER application.TRIGGER_TSystem_INSERT ON application.TSystem FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey INT, @iSuper INT, @iThread INT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TSystem'); 
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = SystemK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;
   
   IF @iSuper > 0
   BEGIN
      -- Make sure there entry for Super exists in thread, this is required if super isn't null or 0
      IF (SELECT COUNT(*) FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable ) = 0
      BEGIN
         -- No super found, then this is a new thread and that means we need to create data for the thread
         SET @iThread = @iSuper
         SET @sPath = '0000'
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iThread, @iTable )
         INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iThread, @iTable, @iSuper, 0, 0, @sPath )
         SET @iDepth = 1
      END
      ELSE
      BEGIN
         -- Seth thread id and path for super (parent)
         SELECT @iThread = FThreadId, @sPath = FPath, @iDepth = FDepth + 1
         FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable
      END

      -- Add to thread
      UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThread AND table_number = @iTable;
      SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThread AND table_number = @iTable;
      SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
      INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThread,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
   END
END

GO

/**
 * UPDATE trigger for **TSystem**
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TSystem_UPDATE; 
GO
CREATE TRIGGER application.TRIGGER_TSystem_UPDATE ON application.TSystem FOR UPDATE AS
BEGIN
   IF OBJECT_ID('tempdb..#DisableTrigger') IS NOT NULL RETURN;

   SET NOCOUNT ON;
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TSystem'); 
   DECLARE @iKey INT, @iSuperNew INT, @iSuperOld INT, @iNextId INT, @iDepth INT
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = SystemK, @iSuperNew = ISNULL(SuperK,0) FROM INSERTED;
   SELECT @iSuperOld = ISNULL(SuperK,0) FROM DELETED;
   DECLARE @iThreadOld INT = (SELECT TOP 1 FThreadId  FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);


   -- Check if there is an entry for node in tree. Look for Ancestor equal to SuperK and Descendant equal to SystemK

   IF @iSuperNew = @iSuperOld -- No thread change?
      RETURN;

   -- If Super is 0, then old position in thread means that this was the root. Delete the complete thread
   IF @iSuperOld = 0 AND @iThreadOld IS NOT NULL
   BEGIN
      DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;

      -- clear thread in TSystem for @iThreadOld
      UPDATE _system 
      SET SuperK = NULL
      FROM application.TSystem _system
      JOIN application.thread _thread ON _system.SystemK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThreadOld;
   END
   ELSE IF @iSuperOld > 0 
   BEGIN
      -- remove system record from tree and render new system tree
      DECLARE @iSuper INT = (SELECT SuperK FROM application.TSystem WHERE SystemK = @iKey);
      UPDATE _system
      SET SuperK = @iSuper
      FROM application.TSystem _system
      WHERE _system.SuperK = @iKey;

      -- Delete thread entry
      DELETE FROM application.thread WHERE FKey = @iKey AND table_number = @iTable

      -- If only one root item in thread, then delete complete thread
      IF (SELECT COUNT(*) FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable) = 1
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      END
      ELSE
         -- Render complete thread
         EXEC application.PROCEDURE_RenderTree @iSuperOld, 'TSystem'
   END

   -- Old thread is now ok, time to investigate the new thread

   IF @iSuperNew = 0 -- No Super means that we haven't placed this in a new thread and we can return
      RETURN;

   DECLARE @iThreadNew INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable);

   IF @iThreadNew IS NULL -- If new super is null then we need to create a new thread with this as the root
   BEGIN
      SET @sPath = '0000'
      INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
      INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iSuperNew, @iTable, @iSuperNew, 0, 0, @sPath )
      SET @iThreadNew = @iSuperNew
      SET @iDepth = 1
   END
   ELSE
   BEGIN

      -- There should be a thread_header for this post but if it is not found then generate it
      IF (SELECT COUNT(*) FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable) = 0
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadNew AND table_number = @iTable;
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
         EXEC application.PROCEDURE_RenderTree @iSuperNew, 'TSystem'
         RETURN
      END

      -- Seth thread id and path for super (parent)
      SELECT @sPath = FPath, @iDepth = FDepth + 1
      FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable
   END

   UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThreadNew AND table_number = @iTable;
   SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable;
   SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
   INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThreadNew,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
END
GO

/**
 * DELETE trigger for **TSystem**
 *
 * `@iTable` - Has table number for TSystem
 * `@iKey` - Key to deleted record in TSystem
 * `@sPath` - Path to record in table if it belongs to a thread
 * `@iThread` - Thread key it it is in thread
 */
DROP TRIGGER IF EXISTS application.TRIGGER_TSystem_DELETE; 
GO
CREATE TRIGGER application.TRIGGER_TSystem_DELETE ON application.TSystem FOR DELETE AS
BEGIN
   DECLARE @iTable INT = (SELECT "number" FROM application.table_number WHERE "name" = 'TSystem'); 
   DECLARE @iKey INT = (SELECT TOP 1 SystemK FROM DELETED) -- Get key value
   DECLARE @sPath VARCHAR(1024) = (SELECT FPath FROM application.thread WHERE FKey = @iKey AND table_number = @iTable)
   DECLARE @iThread INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);


   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
   BEGIN
      CREATE TABLE #DisableTrigger(ID INT) 

      -- Clear all super fields for descendants
      UPDATE _system 
      SET SuperK = NULL
      FROM application.TSystem _system
      JOIN application.thread _thread ON _system.SystemK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThread AND FPath LIKE @sPath + '%';

      DROP TABLE #DisableTrigger

      IF @iKey = @iThread
      BEGIN
         -- Delete complete thread
         DELETE FROM application.thread WHERE FThreadId = @iKey AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iKey AND table_number = @iTable;
      END
      ELSE
      BEGIN
         -- Delete part of thread
         DELETE FROM application.thread  WHERE FThreadId = @iThread AND table_number = @iTable AND FPath LIKE @sPath + '%';
      END
   END

   DELETE FROM application.TUserPinned WHERE table_number = @iTable AND RecordK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TProperty WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TLink WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TArticle WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TArticleBook WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND RecordK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TImage WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND RecordK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TNote WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TState WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TActivity WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TCost WHERE SystemK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TSale WHERE SystemK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TProject WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   DELETE FROM application.TTodoList WHERE table_number = @iTable AND ParentK IN(SELECT SystemK FROM DELETED);
   --DELETE FROM extend.TField WHERE table_number = @iTable AND RecordK IN(SELECT SystemK FROM DELETED);
END
GO

/**
 * application.PROCEDURE_RenderSystemTree
 * Renders complete system tree for specified thread key, thread key is same key as root system id.
 */
DROP PROCEDURE IF EXISTS application.PROCEDURE_RenderSystemTree;
GO
CREATE PROCEDURE application.PROCEDURE_RenderSystemTree 
   @iThread INT
AS
   DECLARE @iTable INT = 1010; -- 1010 = TSystem
   DELETE FROM application.thread WHERE FThreadId = @iThread AND table_number = @iTable; -- delete the thread

   -- Render thread data without path
   ;WITH cte_paths 
   AS
   (
      SELECT @iThread Thread, SystemK, 0 AS Depth
      FROM application.TSystem
      WHERE SystemK = @iThread AND SuperK IS NULL

      UNION ALL

      SELECT @iThread Thread, s.SystemK, _cte.Depth + 1
      FROM application.TSystem s JOIN cte_paths _cte ON s.SuperK = _cte.SystemK
   )
   INSERT INTO application.thread( FThreadId, FKey, FDepth, FNext, table_number )
   SELECT *, ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) - 1, @iTable FROM cte_paths

   -- Render thread path
   -- Max tree depth is 1024 / 5 = 204
   ;WITH cte_paths 
   AS
   (
      SELECT SystemK, CAST('0000' AS VARCHAR(1024)) Path
      FROM application.TSystem
      WHERE SystemK = @iThread AND SuperK IS NULL

      UNION ALL

      SELECT s.SystemK, CAST( _cte.Path + '/' + FORMAT( t.FNext, '000#') AS VARCHAR(1024))
      FROM application.TSystem s 
           JOIN cte_paths _cte ON s.SuperK = _cte.SystemK
           JOIN application.thread t ON s.SystemK = t.FKey AND t.table_number = @iTable
   )
   UPDATE _thread
   SET _thread.FPath = _cte.Path
   FROM application.thread _thread JOIN cte_paths _cte ON _thread.FKey = _cte.SystemK AND _thread.table_number = @iTable

GO

/**
 * PROCEDURE used to insert new item in tree
 *
 * `@iTable` - Has table number for table tree is rendered for
 * `@iKey` - Key to new item that is to be inserted into tree
 * `@iSuper` - Key to parent node in tree if any
 */
DROP PROCEDURE IF EXISTS application.PROCEDURE_InsertTreeNode;
GO
CREATE PROCEDURE application.PROCEDURE_InsertTreeNode
   @iTable INT,
   @iKey BIGINT,
   @iSuper BIGINT
AS
   DECLARE @iThread BIGINT, @iNextId INT, @iDepth INT
   DECLARE @sPath VARCHAR(1024)

   IF @iSuper > 0
   BEGIN
      -- Make sure entry for Super exists in thread, this is required if super isn't null or 0
      IF (SELECT COUNT(*) FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable ) = 0
      BEGIN
         -- No super found, then this is a new thread and that means we need to create data for the thread
         SET @iThread = @iSuper
         SET @sPath = '0000'
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iThread, @iTable )
         INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iThread, @iTable, @iSuper, 0, 0, @sPath )
         SET @iDepth = 1
      END
      ELSE
      BEGIN
         -- Seth thread id and path for super (parent)
         SELECT @iThread = FThreadId, @sPath = FPath, @iDepth = FDepth + 1
         FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable
      END

      -- Add to thread
      UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThread AND table_number = @iTable;
      SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThread AND table_number = @iTable;
      SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
      INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThread,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
   END

GO


DROP PROCEDURE IF EXISTS [application].[PROCEDURE_UpdateTreeNode];
GO

CREATE PROCEDURE [application].[PROCEDURE_UpdateTreeNode]
   @iTable INT,         -- Id number for table, id is found in table application.table_number
   @iKey BIGINT,        -- Key record where parent has been modified
   @iSuperNew BIGINT,   -- New key to parent record
   @iSuperOld BIGINT    -- Old key to parent record

AS
   DECLARE @iNextId INT 
   DECLARE @iDepth INT
   DECLARE @sPath VARCHAR(1024)
   DECLARE @sSql VARCHAR( 1000 )
   DECLARE @iThreadOld INT = (SELECT TOP 1 FThreadId  FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);
   DECLARE @sTableName VARCHAR( 100 ) = (SELECT [name] from application.table_number WHERE [number] = @iTable)
   DECLARE @sFieldName VARCHAR( 100 ) = (SELECT SUBSTRING([name], 2, 100 ) from application.table_number WHERE [number] = @iTable) + 'K'

   IF @iSuperNew = @iSuperOld -- No thread change?
      RETURN;

   -- If olf Super is 0, then old position in thread means that this was the root. Delete the complete thread
   IF @iSuperOld = 0 AND @iThreadOld IS NOT NULL
   BEGIN
      DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;

      -- clear thread in TSystem for @iThreadOld

      SET @sSql = 'UPDATE _table SET SuperK = NULL ' +
                  'FROM  application.' + @sTableName + ' _table ' +
                  'JOIN application.thread _thread ON _table.' + @sFieldName + ' = _thread.FKey AND _thread.table_number = ' + CAST( @iTable AS VARCHAR(20) )+
                  'WHERE FThreadId = ' + CAST( @iThreadOld AS VARCHAR(20) )
      EXEC( @sSql )
      /*
      UPDATE _system 
      SET SuperK = NULL
      FROM application.TSystem _system
      JOIN application.thread _thread ON _system.SystemK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThreadOld;
      */
   END
   ELSE IF @iSuperOld > 0 
   BEGIN
      DECLARE @iSuper INT = 0
      SET @sSql = 'SET @iSuper = (SELECT SuperK FROM application.' + @sTableName + ' WHERE ' + @sFieldName + ' = ' + CAST(@iKey AS VARCHAR(20)) + ')'
      EXEC sp_executesql @sSql, N'@iSuper BIGINT OUTPUT', @iSuper OUTPUT
      -- remove system record from tree and render new system tree
      -- DECLARE @iSuper INT = (SELECT SuperK FROM application.TSystem WHERE SystemK = @iKey);

      SET @sSql = 'UPDATE _table SET ' + @sFieldName + ' = ' + CAST(@iSuper AS VARCHAR(20)) + ' FROM application.' + @sTableName + ' _table WHERE _table.SuperK = ' + CAST(@iKey AS VARCHAR(20));
      EXEC( @sSql )
/*
      UPDATE _system
      SET SuperK = @iSuper
      FROM application.TSystem _system
      WHERE _system.SuperK = @iKey;
      */

      -- Delete thread entry
      DELETE FROM application.thread WHERE FKey = @iKey AND table_number = @iTable

      -- If only one root item in thread, then delete complete thread
      IF (SELECT COUNT(*) FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable) = 1
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      END
      ELSE
         -- Render complete thread
         EXEC application.PROCEDURE_RenderTree @iSuperOld, @sTableName
   END

   -- Old thread is now ok, time to investigate the new thread

   IF @iSuperNew = 0 -- No Super means that we haven't placed this in a new thread and we can return
      RETURN;

   DECLARE @iThreadNew INT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable);

   IF @iThreadNew IS NULL -- If new super is null then we need to create a new thread with this as the root
   BEGIN
      SET @sPath = '0000'
      INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
      INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iSuperNew, @iTable, @iSuperNew, 0, 0, @sPath )
      SET @iThreadNew = @iSuperNew
      SET @iDepth = 1
   END
   ELSE
   BEGIN

      -- There should be a thread_header for this post but if it is not found then generate it
      IF (SELECT COUNT(*) FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable) = 0
      BEGIN
         DELETE FROM application.thread WHERE FThreadId = @iThreadNew AND table_number = @iTable;
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
         EXEC application.PROCEDURE_RenderTree @iSuperNew, @sTableName
         RETURN
      END

      -- Seth thread id and path for super (parent)
      SELECT @sPath = FPath, @iDepth = FDepth + 1
      FROM application.thread WHERE FKey = @iSuperNew AND table_number = @iTable
   END

   UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = @iThreadNew AND table_number = @iTable;
   SELECT @iNextId = FNextId FROM application.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable;
   SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
   INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThreadNew,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry

GO


/**
 * application.PROCEDURE_RenderTree
 * Renders complete tree for specified thread key, thread key is same key as root id.
 * @param {int} @iThread key to thread that is rendered
 * @param {string} @sTableName name of table that thread is rendered for
 */
DROP PROCEDURE IF EXISTS application.PROCEDURE_RenderTree;
GO
CREATE PROCEDURE application.PROCEDURE_RenderTree 
   @iThread INT,
   @table SQL_VARIANT
AS
   SET NOCOUNT ON;
   DECLARE @iTable INT;

   IF SQL_VARIANT_PROPERTY( @table, 'BaseType' ) = 'varchar'
      SET @iTable = (SELECT number FROM application.table_number WHERE "name" = CAST(@table AS VARCHAR) );
   ELSE
      SET @iTable = CAST(@table AS INT);

   DECLARE @sTableName VARCHAR(100) = (SELECT "name" FROM application.table_number WHERE "number" =  @iTable)
   DECLARE @sThread VARCHAR( 20 ) = CAST( @iThread AS VARCHAR(20) )
   DECLARE @sError VARCHAR( 200 )
   DECLARE @sFieldName VARCHAR( 32 ) = SUBSTRING( @sTableName, 2, 30 ) + 'K'
   DECLARE @sSql VARCHAR( 1000 )

   IF @iTable IS NULL 
   BEGIN
      SET @sError = 'Table "' + @sTableName + '" do not have threads!'
      RAISERROR( @sError, 11, 0 )
   END

   DELETE FROM application.thread WHERE FThreadId = @iThread AND table_number = @iTable; -- delete the thread
   SET @sSql = ';WITH cte_paths AS (' +
               'SELECT ' + @sThread + ' Thread, ' + @sFieldName + ', 0 AS Depth FROM application.' + @sTableName + ' WHERE ' + @sFieldName + ' = ' + @sThread + ' AND SuperK IS NULL' +
               ' UNION ALL ' +
               'SELECT ' + @sThread + ' Thread, s.' + @sFieldName + ', _cte.Depth + 1 FROM application.' + @sTableName + ' s JOIN cte_paths _cte ON s.SuperK = _cte.' + @sFieldName + 
               ') INSERT INTO application.thread( FThreadId, FKey, FDepth, FNext, table_number ) SELECT *, ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) - 1, ' + CAST( @iTable AS VARCHAR(20) ) + ' FROM cte_paths'

   EXEC( @sSql )

   SET @sSql = ';WITH cte_paths AS (' +
               'SELECT ' + @sFieldName + ', CAST(''0000'' AS VARCHAR(1024)) Path FROM application.' + @sTableName + ' WHERE ' + @sFieldName + ' = ' + @sThread + ' AND SuperK IS NULL' +
               ' UNION ALL ' +
               'SELECT s.' + @sFieldName + ', CAST( _cte.Path + ''/'' + FORMAT( t.FNext, ''000#'') AS VARCHAR(1024))' +
               'FROM application.' + @sTableName + ' s  JOIN cte_paths _cte ON s.SuperK = _cte.' + @sFieldName + ' JOIN application.thread t ON s.' + @sFieldName + ' = t.FKey AND t.table_number = ' + CAST( @iTable AS VARCHAR(20) ) +
               ') UPDATE _thread SET _thread.FPath = _cte.Path FROM application.thread _thread JOIN cte_paths _cte ON _thread.FKey = _cte.' + @sFieldName + ' AND _thread.table_number = ' + CAST( @iTable AS VARCHAR(20) )

   EXEC( @sSql )

   -- Update thread_header
   DECLARE @iNext INT = (SELECT MAX(FNext) FROM application.thread WHERE FThreadId = @iThread AND table_number = @iTable)
   IF (SELECT COUNT(*) FROM application.thread_header WHERE FThreadId = @iThread AND table_number = @iTable) > 0
      UPDATE application.thread_header SET FNextId = @iNext WHERE FThreadId = @iThread AND table_number = @iTable
   ELSE 
      INSERT INTO application.thread_header ( FThreadId, table_number, FNextId ) VALUES( @iThread, @iTable, @iNext )

GO

-- =========================================================

DROP PROCEDURE IF EXISTS application.PROCEDURE_ClearTree;
GO
/**
 * application.PROCEDURE_ClearTree
 * Clear complete tree for specified table
 */
CREATE PROCEDURE application.PROCEDURE_ClearTree 
   @iTable INT
AS   
   CREATE TABLE #DisableTrigger(ID INT) 

   DECLARE @sTableName VARCHAR(100) = (SELECT "name" FROM application.table_number WHERE "number" = @iTable);
   DECLARE @sSqlUpdate VARCHAR(1000)

   DELETE FROM application.thread_header WHERE table_number = @iTable
   DELETE FROM application.thread WHERE table_number = @iTable

   SET @sSqlUpdate = 'UPDATE _t SET SuperK = NULL FROM application.' + @sTableName + ' _t'
   EXEC ( @sSqlUpdate )

   DROP TABLE #DisableTrigger
GO   

-- =========================================================

DROP PROCEDURE IF EXISTS application.PROCEDURE_DeleteTreeNode;
GO
/**
 * application.PROCEDURE_DeleteTreeNode
 * Remove node from tree and fix
 */
 CREATE PROCEDURE application.PROCEDURE_DeleteTreeNode
   @iTable INT,         -- Id number for table, id is found in table application.table_number
   @iKey BIGINT,        -- Key record where parent has been modified
   @iSetSuperToNull SMALLINT = 1 -- If SuperK that holds the parent key should be cleared
AS
   DECLARE @sSql NVARCHAR( 1000 )
   DECLARE @sTableName VARCHAR( 100 ) = (SELECT [name] from application.table_number WHERE [number] = @iTable)
   DECLARE @sFieldName VARCHAR( 100 ) = (SELECT SUBSTRING([name], 2, 100 ) from application.table_number WHERE [number] = @iTable) + 'K'
   DECLARE @sPath VARCHAR(1024) = (SELECT TOP 1 FPath FROM application.thread WHERE FKey = @iKey AND table_number = @iTable)
   DECLARE @iThread BIGINT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);

   IF @sPath IS NOT NULL AND @iThread IS NOT NULL
   BEGIN
      IF @iSetSuperToNull = 1
      BEGIN
         CREATE TABLE #DisableTrigger(ID INT) 
         DECLARE @sSchema VARCHAR( 32 ) = (SELECT ISNULL("schema",'application') FROM application.table_number WHERE "number" = @iTable)
         SET @sSql = 'UPDATE _table SET SuperK = NULL FROM ' + @sSchema + '.' + @sTableName + ' _table JOIN application.thread _thread ON _table.' + @sFieldName + ' = _thread.FKey AND _thread.table_number = ' + CAST( @iTable AS VARCHAR(10) ) + ' WHERE FThreadId = ' + CAST( @iThread AS VARCHAR(20) ) + ' AND FPath LIKE ''' + @sPath + '%''';
         EXEC( @sSql )
         DROP TABLE #DisableTrigger
      END         

      IF @iKey = @iThread
      BEGIN
         -- Delete complete thread
         DELETE FROM application.thread WHERE FThreadId = @iKey AND table_number = @iTable;
         DELETE FROM application.thread_header WHERE FThreadId = @iKey AND table_number = @iTable;
      END
      ELSE
      BEGIN
         -- Delete part of thread
         DELETE FROM application.thread  WHERE FThreadId = @iThread AND table_number = @iTable AND FPath LIKE @sPath + '%';
      END
   END
GO

-- =========================================================

DROP PROCEDURE IF EXISTS application.PROCEDURE_ChangeParentTreeNode;
GO
/**
 * Change parent key for record in thread
 * Call this method after change has been done in SuperK field where the new parent is set
 * @param {SQL_VARIANT} @table Name or number for table that thread is modified for
 * @param {bigint} @iKey key to record that will change its position in tree
 * @param {bigint} @iSuper parent to key if new or null if record isn't inserted to new node
 */
CREATE PROCEDURE application.PROCEDURE_ChangeParentTreeNode
   @table SQL_VARIANT,
   @iKey BIGINT,
   @iSuper BIGINT
AS
   DECLARE @iTable INT;

   IF SQL_VARIANT_PROPERTY( @table, 'BaseType' ) = 'varchar'
      SET @iTable = (SELECT number FROM application.table_number WHERE "name" = CAST(@table AS VARCHAR) );
   ELSE
      SET @iTable = CAST(@table AS INT);

   DECLARE @iThreadForKey BIGINT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iKey AND table_number = @iTable);
   DECLARE @iThreadForSuper BIGINT = (SELECT TOP 1 FThreadId FROM application.thread WHERE FKey = @iSuper AND table_number = @iTable);

   IF (SELECT COUNT(*) FROM application.thread WHERE FKey = @iKey AND table_number = @iTable) > 1
   BEGIN
      -- key cant be in thread more than once, clean up
      EXEC application.PROCEDURE_RenderTree @iThreadForKey, @iTable
   END

   -- If key for record that is moved in tree if found in some thread, that node is deleted
   IF @iThreadForKey IS NOT NULL 
   BEGIN
      EXEC application.PROCEDURE_DeleteTreeNode @iTable, @iKey, 0
   END

   IF @iSuper > 0
   BEGIN
      IF @iThreadForSuper IS NULL
         EXEC application.PROCEDURE_RenderTree @iSuper, @iTable
      ELSE
         EXEC application.PROCEDURE_InsertTreeNode @iTable, @iKey, @iSuper 
   END

GO

-- =========================================================

CREATE FUNCTION application.PullTagsFromText( @sText NVARCHAR(MAX) )
RETURNS @tTag TABLE
(
  tag NVARCHAR(256)
)
AS
BEGIN

   DECLARE @iPosition INT     -- Current position in string
   DECLARE @iFront INT        -- Char code before current position
   DECLARE @iBack INT         -- Char code after current position
   DECLARE @iEnd INT          -- Find string end
   DECLARE @i INT             -- Loop variable
   DECLARE @iTest INT         -- Test character

   DECLARE @sTag NVARCHAR(256)-- tag's found in text

   SET @iPosition = CHARINDEX('#',@sText)

-- Replace tab(9), new line(10), carriage return(13)
   IF @iPosition > 0
      SET @sText = REPLACE(REPLACE(REPLACE( @sText, CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' ')

   WHILE @iPosition > 0 
   BEGIN

-- Get character code before #
      IF @iPosition = 1
         SET @iFront = 32
      ELSE
         SET @iFront = UNICODE( SUBSTRING( @sText, @iPosition - 1, 1 ) ) -- ASCII code before current position

      SET @iBack = UNICODE( SUBSTRING( @sText, @iPosition + 1, 1 ) ) -- ASCII code after current position

-- Check for non character and not # before '#' and character after
      IF ((@iFront < 48 AND @iFront <> 35) OR (@iFront > 57 AND @iFront < 65)) AND( @iBack >= 36 AND @iBack <>  44)
      BEGIN
-- Find last character
         SET @iEnd = CHARINDEX( CHAR(32), @sText, @iPosition ) 

-- If no space then get end of complete string
         IF @iEnd = 0
            SET @iEnd = LEN( @sText )

-- More than one character then we have a hashtag
         IF (@iEnd - @iPosition) > 0
         BEGIN
            SET @sTag = SUBSTRING( @sText, @iPosition, @iEnd - @iPosition + 1 )
            --SET @iSavePosition = @iPosition
            --SET @iPosition = @iPosition + LEN( @sTag ) -- Set position to back of hashtag

-- Check for non valid character in hashtag
            SET @i = 1  -- Skip #
            WHILE @i < LEN( @sTag )
            BEGIN
               SET @i = @i + 1
               SET @iTest = UNICODE( SUBSTRING( @sTag, @i, 1 ) )
               IF @iTest < 36 @iTest = 44 -- if less than ascii code for '$'
                  SET @sTag = SUBSTRING( @sTag, 1, @i - 1 )
            END

-- If more than one character # + character
            IF LEN( @sTag ) > 1
               SET @sTag = SUBSTRING( @sTag, 2, 255 )
            ELSE
               SET @sTag = NULL

            IF @sTag IS NOT NULL
            BEGIN
               IF (SELECT COUNT(*) FROM @tTag WHERE tag = @sTag) = 0
               BEGIN
                  INSERT INTO @tTag VALUES( @sTag )
               END
            END
         END
      END

      SET @iPosition = CHARINDEX('#',@sText, @iPosition + 1)
   END

   RETURN
END

GO


DROP PROCEDURE IF EXISTS application.PROCEDURE_ConnectHashtags;
GO
/**
 * Update hashtag connections for table TrXBadge and TBadge
 * Adds missing hashtags from text into TBadge table and then connects those to record with key sent and table number
 * @param {NVARCHAR} @sText Text to scan for hashtags
 * @param {NVARCHAR} @sTable table name hashtag is connected to
 * @param {BIGINT} @iRecord key to record hashtags are connected to
 */
CREATE PROCEDURE application.PROCEDURE_UpdateBadge
   @sText NVARCHAR(MAX),
   @sTable VARCHAR(200),
   @iRecord BIGINT
AS
   DECLARE @iTable INT = (SELECT number FROM application.table_number WHERE "name" = @sTable); -- Get table id

   -- Remove old connections to hashtag
   DELETE FROM application.TrXBadge WHERE ParentK = @iRecord AND table_number = @iTable

IF LEN( @sText ) > 2 -- Net to be at least three characters with the hashtag symbol
BEGIN
   -- Add missing hashtags to Badge table
   INSERT INTO application.TBadge (FName)
   SELECT tag FROM application.PullTagsFromText( @sText ) LEFT JOIN application.TBadge _b ON tag = _b.FName WHERE _b.FName IS NULL
   
   -- Connect hashtags to  record
   INSERT INTO application.TrXBadge (ParentK,table_number,BadgeK)
   SELECT @iRecord, @iTable, _b.BadgeK
   FROM application.TBadge _b JOIN application.PullTagsFromText( @sText ) ON _b.FName = tag
END

GO


DROP PROCEDURE IF EXISTS application.PROCEDURE_UpdateImage;
GO
CREATE PROCEDURE application.PROCEDURE_UpdateImage
   @table SQL_VARIANT,
   @iKey BIGINT,
   @sName NVARCHAR(250),
   @sExtension NVARCHAR(100),
   @sMimeName VARCHAR(250),
   @iSize INT,
   @sData VARCHAR(MAX)
AS
   SET NOCOUNT ON;
   DECLARE @iTable INT;

   IF SQL_VARIANT_PROPERTY( @table, 'BaseType' ) = 'varchar'
      SET @iTable = (SELECT number FROM application.table_number WHERE "name" = CAST(@table AS VARCHAR) );
   ELSE
      SET @iTable = CAST(@table AS INT);

   IF IF @sName IS NOT NULL AND LEN( @sName ) > 0      
   BEGIN
      IF (SELECT COUNT(*) FROM application.TImage WHERE RecordK=@iKey AND table_number=@iTable) = 0
         INSERT INTO application.TImage (RecordK, table_number) VALUES(@iKey,@iTable)

      UPDATE application.TImage SET FName=@sName, FExtension=@sExtension, FData=CONVERT(VARBINARY(MAX), @sData, 2), FSize=@iSize, MimeName=@sMimeName WHERE RecordK=@iKey AND table_number=@iTable   
   END
   ELSE
      DELETE FROM application.TImage WHERE RecordK=@iKey AND table_number=@iTable

GO


