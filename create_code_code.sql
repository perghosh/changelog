/*
###Insert trigger for code to generate tree
If Parent(Super) isn't found among threads or closure's then this is the start for a new thread  
- No SuperK found, add to closure, create thread header and thread
- If SuperK is found then get  thread and path
- Insert to closure and insert
*/
CREATE TRIGGER code.TRIGGER_TCode_INSERT ON code.TCode FOR INSERT AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey INT, @iSuper INT, @iThread INT, @iNextId INT, @iDepth INT
   DECLARE @iTable INT = 301; -- 301 = TCode
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = CodeK, @iSuper = ISNULL(SuperK,0) FROM INSERTED;
   
   IF @iSuper > 0
   BEGIN
      -- Make sure there entry for Super exists in thread, this is required if super isn't null or 0
      IF (SELECT COUNT(*) FROM code.thread WHERE FKey = @iSuper AND table_number = @iTable ) = 0
      BEGIN
         -- No super found, then this is a new thread and that means we need to create data for the thread
         SET @iThread = @iSuper
         SET @sPath = '0000'
         INSERT INTO code.thread_header ( FThreadId, table_number ) VALUES( @iThread, @iTable )
         INSERT INTO code.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iThread, @iTable, @iSuper, 0, 0, @sPath )
         SET @iDepth = 1
      END
      ELSE
      BEGIN
         -- Seth thread id and path for super (parent)
         SELECT @iThread = FThreadId, @sPath = FPath, @iDepth = FDepth + 1
         FROM code.thread WHERE FKey = @iSuper AND table_number = @iTable
      END

      -- Add to thread
      UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM code.thread_header _TH WHERE _TH.FThreadId = @iThread AND table_number = @iTable;
      SELECT @iNextId = FNextId FROM code.thread_header WHERE FThreadId = @iThread AND table_number = @iTable;
      SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
      INSERT INTO code.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThread,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
   END
END

GO

/**
 * UPDATE trigger for **TCode**
 */
CREATE TRIGGER code.TRIGGER_TCode_UPDATE ON code.TCode FOR UPDATE AS
BEGIN
   IF OBJECT_ID('tempdb..#DisableTrigger') IS NOT NULL RETURN;

   SET NOCOUNT ON;
   DECLARE @iTable INT = 301; -- 301 = TCode
   DECLARE @iKey INT, @iSuperNew INT, @iSuperOld INT, @iNextId INT, @iDepth INT
   DECLARE @sPath VARCHAR(1024)
   SELECT @iKey = CodeK, @iSuperNew = ISNULL(SuperK,0) FROM INSERTED;
   SELECT @iSuperOld = ISNULL(SuperK,0) FROM DELETED;
   DECLARE @iThreadOld INT = (SELECT TOP 1 FThreadId  FROM code.thread WHERE FKey = @iKey AND table_number = @iTable);


   -- Check if there is an entry for node in tree. Look for Ancestor equal to SuperK and Descendant equal to CodeK

   IF @iSuperNew = @iSuperOld -- No thread change?
      RETURN;

   -- If Super is 0, then old position in thread means that this was the root. Delete the complete thread
   IF @iSuperOld = 0 AND @iThreadOld IS NOT NULL
   BEGIN
      DELETE FROM code.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      DELETE FROM code.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;

      -- clear thread in TCode for @iThreadOld
      UPDATE _system 
      SET SuperK = NULL
      FROM code.TCode _system
      JOIN code.thread _thread ON _system.CodeK = _thread.FKey AND _thread.table_number = @iTable
      WHERE FThreadId = @iThreadOld;
   END
   ELSE IF @iSuperOld > 0 
   BEGIN
      -- remove system record from tree and render new system tree
      DECLARE @iSuper INT = (SELECT SuperK FROM code.TCode WHERE CodeK = @iKey);
      UPDATE _system
      SET SuperK = @iSuper
      FROM code.TCode _system
      WHERE _system.SuperK = @iKey;

      -- Delete thread entry
      DELETE FROM code.thread WHERE FKey = @iKey AND table_number = @iTable

      -- If only one root item in thread, then delete complete thread
      IF (SELECT COUNT(*) FROM code.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable) = 1
      BEGIN
         DELETE FROM code.thread WHERE FThreadId = @iThreadOld AND table_number = @iTable;
         DELETE FROM code.thread_header WHERE FThreadId = @iThreadOld AND table_number = @iTable;
      END
      ELSE
         -- Render complete thread
         EXEC code.PROCEDURE_RenderTree @iSuperOld, 'TCode'
   END

   -- Old thread is now ok, time to investigate the new thread

   IF @iSuperNew = 0 -- No Super means that we haven't placed this in a new thread and we can return
      RETURN;

   DECLARE @iThreadNew INT = (SELECT TOP 1 FThreadId FROM code.thread WHERE FKey = @iSuperNew AND table_number = @iTable);

   IF @iThreadNew IS NULL -- If new super is null then we need to create a new thread with this as the root
   BEGIN
      SET @sPath = '0000'
      INSERT INTO code.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
      INSERT INTO code.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( @iSuperNew, @iTable, @iSuperNew, 0, 0, @sPath )
      SET @iThreadNew = @iSuperNew
      SET @iDepth = 1
   END
   ELSE
   BEGIN

      -- There should be a thread_header for this post but if it is not found then generate it
      IF (SELECT COUNT(*) FROM code.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable) = 0
      BEGIN
         DELETE FROM code.thread WHERE FThreadId = @iThreadNew AND table_number = @iTable;
         INSERT INTO code.thread_header ( FThreadId, table_number ) VALUES( @iSuperNew, @iTable )
         EXEC code.PROCEDURE_RenderTree @iSuperNew, 'TCode'
         RETURN
      END

      -- Seth thread id and path for super (parent)
      SELECT @sPath = FPath, @iDepth = FDepth + 1
      FROM code.thread WHERE FKey = @iSuperNew AND table_number = @iTable
   END

   UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM code.thread_header _TH WHERE _TH.FThreadId = @iThreadNew AND table_number = @iTable;
   SELECT @iNextId = FNextId FROM code.thread_header WHERE FThreadId = @iThreadNew AND table_number = @iTable;
   SET @sPath = @sPath + '/' + FORMAT(@iNextId,'000#')  -- Fix path
   INSERT INTO code.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( @iTable,@iThreadNew,@iKey,@iNextId,@iDepth,@sPath)   -- Add thread entry
END

GO

/**
 * code.PROCEDURE_RenderTree
 * Renders complete code tree for specified thread key, thread key is same key as root code id.
 * @param {int} @iThread key to thread that is rendered
 * @param {string} @sTableName name of table that thread is rendered for
 */
CREATE PROCEDURE code.PROCEDURE_RenderTree 
   @iThread INT,
   @sTableName VARCHAR(100)
AS
   SET NOCOUNT ON;
   DECLARE @iTable INT = (SELECT number FROM code.table_number WHERE "name" = @sTableName)
   DECLARE @sThread VARCHAR( 20 ) = CAST( @iThread AS VARCHAR(20) )
   DECLARE @sError VARCHAR( 200 )
   DECLARE @sFieldName VARCHAR( 32 ) = SUBSTRING( @sTableName, 2, 30 ) + 'K'
   DECLARE @sSql VARCHAR( 1000 )

   IF @iTable IS NULL 
   BEGIN
      SET @sError = 'Table "' + @sTableName + '" do not have threads!'
      RAISERROR( @sError, 11, 0 )
   END

   DELETE FROM code.thread WHERE FThreadId = @iThread AND table_number = @iTable; -- delete the thread
   SET @sSql = ';WITH cte_paths AS (' +
               'SELECT ' + @sThread + ' Thread, ' + @sFieldName + ', 0 AS Depth FROM code.' + @sTableName + ' WHERE ' + @sFieldName + ' = ' + @sThread + ' AND SuperK IS NULL' +
               ' UNION ALL ' +
               'SELECT ' + @sThread + ' Thread, s.' + @sFieldName + ', _cte.Depth + 1 FROM code.' + @sTableName + ' s JOIN cte_paths _cte ON s.SuperK = _cte.' + @sFieldName + 
               ') INSERT INTO code.thread( FThreadId, FKey, FDepth, FNext, table_number ) SELECT *, ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) - 1, ' + CAST( @iTable AS VARCHAR(20) ) + ' FROM cte_paths'

   EXEC( @sSql )

   SET @sSql = ';WITH cte_paths AS (' +
               'SELECT ' + @sFieldName + ', CAST(''0000'' AS VARCHAR(1024)) Path FROM code.' + @sTableName + ' WHERE ' + @sFieldName + ' = ' + @sThread + ' AND SuperK IS NULL' +
               ' UNION ALL ' +
               'SELECT s.' + @sFieldName + ', CAST( _cte.Path + ''/'' + FORMAT( t.FNext, ''000#'') AS VARCHAR(1024))' +
               'FROM code.' + @sTableName + ' s  JOIN cte_paths _cte ON s.SuperK = _cte.' + @sFieldName + ' JOIN code.thread t ON s.' + @sFieldName + ' = t.FKey AND t.table_number = ' + CAST( @iTable AS VARCHAR(20) ) +
               ') UPDATE _thread SET _thread.FPath = _cte.Path FROM code.thread _thread JOIN cte_paths _cte ON _thread.FKey = _cte.' + @sFieldName + ' AND _thread.table_number = ' + CAST( @iTable AS VARCHAR(20) )

   EXEC( @sSql )

   -- Update thread_header
   DECLARE @iNext INT = (SELECT MAX(FNext) FROM code.thread WHERE FThreadId = @iThread AND table_number = @iTable)
   IF (SELECT COUNT(*) FROM code.thread_header WHERE FThreadId = @iThread AND table_number = @iTable) > 0
      UPDATE code.thread_header SET FNextId = @iNext WHERE FThreadId = @iThread AND table_number = @iTable
   ELSE 
      INSERT INTO code.thread_header ( FThreadId, table_number, FNextId ) VALUES( @iThread, @iTable, @iNext )

GO



/*
CREATE TRIGGER code.TRIGGER_TCode_UPDATE ON code.TCode FOR UPDATE AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @iKey INT, @iSuper INT
   SELECT @iKey = _I.CodeK, @iSuper = _I.SuperK FROM INSERTED _I;

   DECLARE @iKeyOld INT, @iSuperOld INT

   -- Check if there is an entry for node in tree. Look for Ancestor equal to SuperK and Descendant equal to CodeK
   SELECT TOP 1 @iKeyOld = C.Descendant, @iSuperOld = _C.Ancestor FROM code.closure _C WHERE _C.Ancestor = @iSuper AND _C.Descendant = @iKey

   IF @iKey = @iKeyOld AND @iSuper = @iSuperOld -- No change?
      RETURN;

   IF @iSuper IS NULL AND @iSuper = 0 -- Is node removed, then try to delete all with key
   BEGIN
      DELETE FROM code.closure WHERE Ancestor = @iKey OR Descendant = @iKey
      RETURN;
   END

   -- Move tree node
   INSERT INTO code.closure (Ancestor, Descendant, Depth)
      SELECT _D_MovingTo.Ancestor, _D_Moving.Descendant, _D_MovingTo.Depth + _D_Moving.Depth + 1
      FROM code.closure _D_MovingTo JOIN code.closure _D_Moving ON _D_Moving.Ancestor = @iKey AND _D_MovingTo.Descendant = @iSuper;
END
*/

/**
 * code.TRIGGER_TCode_DELETE
 * Removes connected items in thread and renders new updated thread if needed. Or deletes thread_header if tree is empty
 */
CREATE TRIGGER code.TRIGGER_TCode_DELETE ON code.TCode FOR DELETE AS
BEGIN
   SET NOCOUNT ON;

   UPDATE _Code
   SET _Code.SuperK = deleted.SuperK
   FROM code.TCode _Code JOIN deleted ON _Code.SuperK = deleted.CodeK

   DELETE FROM code.closure WHERE Descendant IN (SELECT CodeK FROM deleted);
   DELETE FROM code.closure WHERE Ancestor IN (SELECT CodeK FROM deleted);
   DELETE FROM code.thread WHERE FKey IN (SELECT CodeK FROM deleted);


   DECLARE @iThread INT
   DECLARE _threads_cursor CURSOR READ_ONLY FOR
      SELECT DISTINCT FThreadId
      FROM code.TCode JOIN code.thread ON CodeK=FKey
      WHERE CodeK IN( SELECT CodeK FROM deleted WHERE deleted.SuperK IS NOT NULL )

   OPEN _threads_cursor
   FETCH NEXT FROM _threads_cursor INTO @iThread
   WHILE @@FETCH_STATUS = 0  
   BEGIN 
      IF (SELECT COUNT(*) FROM code.thread WHERE FThreadId = @iThread) > 0
         EXEC code.PROCEDURE_RenderTree @iThread
      ELSE
         DELETE FROM code.thread_header WHERE FThreadId = @iThread

      FETCH NEXT FROM _threads_cursor INTO @iThread
   END

   CLOSE _threads_cursor;  
   DEALLOCATE _threads_cursor;  

END

GO

CREATE TRIGGER code.TRIGGER_thread_header_DELETE ON code.thread_header FOR DELETE AS
BEGIN
   DELETE FROM code.thread WHERE FThreadId IN(SELECT FThreadId FROM DELETED)
END

GO

/**
 * code.PROCEDURE_RenderTree
 * Renders complete code tree for specified thread key, thread key is same key as root code id.
 */
CREATE PROCEDURE code.PROCEDURE_RenderTree 
   @iThread INT
AS
   DELETE FROM code.thread WHERE FThreadId = @iThread;   -- delete the thread

   -- Render thread data without path
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

   -- Render thread path
   -- Max tree depth is 1024 / 6 = 170
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
   UPDATE _thread
   SET _thread.FPath = _cte.Path
   FROM code.thread _thread JOIN cte_paths _cte ON _thread.FKey = _cte.CodeK

/*
INSERT INTO objects_tree (parent_id, child_id, depth) SELECT x.parent_id, NEW.id, x.depth + 1 
FROM objects_tree x WHERE x.child_id = NEW.parent_id;
*/

