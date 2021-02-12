DROP PROCEDURE IF EXISTS application.PROCEDURE_InsertTreeNode(INT,BIGINT,BIGINT);
CREATE OR REPLACE PROCEDURE application.PROCEDURE_InsertTreeNode(
   iTable INT,       -- Table number, each table has a number found in table "table_number"
   iKey BIGINT,      -- Key to added none (key for record)
   iSuper BIGINT     -- Parent key
)
LANGUAGE plpgsql
AS $$
DECLARE
   iThread BIGINT;   -- Thread number, each thread will have a common number 
   iNextId INT;      -- Sequence number for next item in thread
   iDepth INT;       -- Where in three based on root. How many branches away from root
   sPath VARCHAR(1024); -- Path for each thread item, used to order thread

BEGIN

   IF iSuper > 0 THEN

      -- Make sure entry for Super exists in thread, this is required if super isn't null or 0
      IF (SELECT COUNT(*) FROM application.thread WHERE FKey = iSuper AND table_number = iTable ) = 0 THEN
         iThread := iSuper;
         sPath := '0000';
         INSERT INTO application.thread_header ( FThreadId, table_number ) VALUES( iThread, iTable ); -- Each thread has one entry in thread_header
         INSERT INTO application.thread ( FThreadId, table_number, FKey, FNext, FDepth, FPath ) VALUES( iThread, iTable, iSuper, 0, 0, sPath );
         iDepth := 1;
      ELSE
         -- Seth thread id and path for super (parent)
         SELECT iThread = FThreadId, sPath = FPath, iDepth = FDepth + 1
         FROM application.thread WHERE FKey =@iSuper AND table_number = iTable;
      END IF;

      -- Add to thread
      UPDATE _TH SET _TH.FNextId = _TH.FNextId + 1 FROM application.thread_header _TH WHERE _TH.FThreadId = iThread AND table_number = iTable;
      SELECT iNextId = FNextId FROM application.thread_header WHERE FThreadId = iThread AND table_number = iTable;
      sPath := sPath || '/' || FORMAT(@iNextId,'000#');  -- Fix path
      INSERT INTO application.thread(table_number,FThreadId,FKey,FNext,FDepth,FPath) VALUES( iTable,iThread,iKey,iNextId,iDepth,sPath); -- Add thread entry
   
   ELSE
      RAISE 'Error in Super, should be above 0' HINT 'Super parameter hold parent to to node or if root it holds it self.'
   END IF;

END 
$$;

-- format numbers
-- https://stackoverflow.com/questions/26379446/padding-zeros-to-the-left-in-postgresql

DO $$
<<outer_block>>
DECLARE
  iCounter integer := 0;
BEGIN
   iCounter := iCounter + 1;
   RAISE NOTICE 'The current value of iCounter is %', iCounter;
 
   DECLARE
       iCounter integer := 0;
   BEGIN
       iCounter := iCounter + 10;
       RAISE NOTICE 'The current value of iCounter in the subblock is %', iCounter;
       RAISE NOTICE 'The current value of iCounter in the outer block is %', outer_block.iCounter;
   END;
 
   RAISE NOTICE 'The current value of iCounter in the outer block is %', iCounter;
  
END outer_block $$;