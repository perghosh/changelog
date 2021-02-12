CREATE SCHEMA IF NOT EXISTS code;

DROP TABLE IF EXISTS code.table_number CASCADE;
DROP TABLE IF EXISTS code.TProperty CASCADE;
DROP TABLE IF EXISTS code.TPropertyKey CASCADE;
DROP TABLE IF EXISTS code.TCode CASCADE;
DROP TABLE IF EXISTS code.TBaseCode CASCADE;
DROP TABLE IF EXISTS code.TGroup CASCADE;

DROP TABLE IF EXISTS code.thread_header;
DROP TABLE IF EXISTS code.thread;
DROP TABLE IF EXISTS code.table_number;

CREATE TABLE code.TGroup (
   GroupK INT PRIMARY KEY
   ,FName VARCHAR(200) NOT NULL
   ,FDescription VARCHAR(250)
   ,FLabel VARCHAR(100)
   ,FTable VARCHAR(200)
);

CREATE TABLE code.TBaseCode (
   BaseCodeK INT PRIMARY KEY
   ,GroupK INT NOT NULL                                   -- fk to group
   ,CreatedD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,FId INT                                               -- Id used if there is a need to control numbers
   ,FName VARCHAR(200) NOT NULL
   ,FAbbreviation VARCHAR(100)                           -- Short name for code, could be used when codes are displayed in a breadcrumb trail
   ,FDescription VARCHAR(1000) 
   ,FRank INT                                             -- Ranking is for making system easier to work with, maybe you need parents in a tree but just some items are suitable for parents. Select those with codes that has some sort of ranking
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TBaseCode_GroupK FOREIGN KEY (GroupK) REFERENCES code.TGroup (GroupK) ON DELETE CASCADE
);

CREATE INDEX I_TBaseCode_GroupK ON code.TBaseCode (GroupK);

CREATE TABLE code.TCode (
    CodeK SERIAL PRIMARY KEY
   ,GroupK INT NOT NULL                                   -- fk to group
   ,BaseCodeK INT                                         -- if connected to a common base code
   ,SuperK INT                                            -- parent code
   ,CreatedD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,FId INT                                                 -- Id used if there is a need to control numbers
   ,FName VARCHAR(200) NOT NULL
   ,FAbbreviation VARCHAR(100)                             -- Short name for code, could be used when codes are displayed in a breadcrumb trail
   ,FDescription VARCHAR(250) 
   ,FRank INT                                               -- Ranking is for making system easier to work with, maybe you need parents in a tree but just some items are suitable for parents. Select those with codes that has some sort of ranking
   ,FNotCompleted SMALLINT DEFAULT 0                        -- Record needs more work
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,FInteger0 BIGINT
   ,FInteger1 BIGINT
   ,FNumber0 FLOAT
   ,FText0 VARCHAR(100)
   ,CONSTRAINT FK_TCode_GroupK FOREIGN KEY (GroupK) REFERENCES code.TGroup(GroupK) ON DELETE CASCADE 
);

-- This table can be used to define a fixed number of properties for code
CREATE TABLE code.TPropertyKey (
   PropertyKeyK INT PRIMARY KEY
   ,GroupK INT NOT NULL                                   -- fk to group
   ,FKey VARCHAR(100)
   ,FDescription VARCHAR(1000)
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TPropertyKey_GroupK FOREIGN KEY (GroupK) REFERENCES code.TGroup(GroupK) ON DELETE CASCADE 
);

CREATE INDEX I_TPropertyKey_GroupK  ON code.TPropertyKey (GroupK);


CREATE TABLE code.TProperty (
   PropertyK INT PRIMARY KEY
   ,CodeK INT NOT NULL
   ,PropertyKeyK INT                                      -- key name found in TPropertyKey
   ,FKey VARCHAR(100)                                    -- any key name for code property
   ,FValue VARCHAR(1000)
   ,FValueBoolean SMALLINT
   ,FValueInteger BIGINT
   ,FValueDecimal FLOAT
   ,FDescription VARCHAR(1000)
   ,CONSTRAINT FK_TProperty_CodeK FOREIGN KEY (CodeK) REFERENCES code.TCode(CodeK) ON DELETE CASCADE 
);

CREATE INDEX I_TProperty_CodeK ON code.TProperty (CodeK);


CREATE TABLE code.thread_header (
   FThreadId INT PRIMARY KEY
   ,FNextId INT NOT NULL DEFAULT 0
);

 CREATE TABLE code.thread (
   FThreadId INT 
   ,FKey INT NOT NULL
   ,FDepth INT 
   ,FNext INT
   ,FPath VARCHAR(1024)
);

CREATE INDEX IC_thread_FThreadId ON code.thread (FThreadId);


CREATE TABLE code.table_number (
   number INT PRIMARY KEY
   ,name VARCHAR(100)
);

INSERT INTO code.table_number
VALUES (300,'TGroup'),(301,'TCode'),(302,'TBaseCode'),(303,'TProperty'),(305,'TPropertyKey');
