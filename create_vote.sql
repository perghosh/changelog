/*
   ### Table tree
   
   TLike
   TPoll
      TPollSection
   	TPollQuestion
         TPollAnswer
 */

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'vote' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "vote";';
END



IF OBJECT_ID('vote.TVoterHistory', 'U') IS NOT NULL  DROP TABLE vote.TVoterHistory;
IF OBJECT_ID('vote.TVoter', 'U') IS NOT NULL  DROP TABLE vote.TVoter;
IF OBJECT_ID('vote.TLike', 'U') IS NOT NULL  DROP TABLE vote.TLike;
IF OBJECT_ID('vote.TPoll', 'U') IS NOT NULL  DROP TABLE vote.TPoll;
IF OBJECT_ID('vote.TPollQuestion', 'U') IS NOT NULL  DROP TABLE vote.TPollQuestion;
IF OBJECT_ID('vote.TPollAnswer', 'U') IS NOT NULL  DROP TABLE vote.TPollAnswer;
IF OBJECT_ID('vote.TPollVote', 'U') IS NOT NULL  DROP TABLE vote.TPollVote;

CREATE TABLE vote.TVoter (
	VoterK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,UserK BIGINT
   ,ContactK BIGINT
   ,SuperK BIGINT           -- owner voter when used in hierarchical structure
   ,CreateD DATETIME
   ,FIp VARCHAR(100)
   ,FUserAgent VARCHAR(100)
   ,FUserKey BINARY(16)
   ,FName NVARCHAR(100)
   ,FAlias NVARCHAR(100)
   ,FMail NVARCHAR(100)
   ,FLastVote DATETIME
   ,FDeleted SMALLINT DEFAULT 0    -- If voter is deleted, like old
);

CREATE TABLE vote.TVoterRule (
   VoterRuleK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,VoterK BIGINT
   ,rule_type SMALLINT    -- type of rule that limits vote cheating
   ,UpdateD DATETIME      -- last update
   ,FValue INT            -- rule value
   ,FDate DATETIME        -- rule date
   ,FDescription NVARCHAR(200)
   ,CONSTRAINT FK_TVoterRule_VoterK FOREIGN KEY (VoterK) REFERENCES vote.TVoter(VoterK) ON DELETE CASCADE
);

CREATE TABLE vote.TVoterHistory (
   VoterHistoryK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
	,VoterK BIGINT
   ,CreateD DATETIME
   ,FIp VARCHAR(100)
   ,FUserAgent VARCHAR(100)
   ,FName NVARCHAR(100)
   ,FLastVote DATETIME
   ,CONSTRAINT FK_TVoterHistory_VoterK FOREIGN KEY (VoterK) REFERENCES vote.TVoter(VoterK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TVoterHistory_VoterK ON vote.TVoterHistory (VoterK);



CREATE TABLE vote.TLike (
   LikeK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ParentK BIGINT
   ,table_number INT        -- Table number for describing what table TLike belongs to
   ,UpdateD DATETIME
   ,TypeC INT               -- Type of like or dislike
   ,UserK BIGINT
   ,ContactK BIGINT
   ,FCount BIGINT
);
CREATE CLUSTERED INDEX IC_TLike_ParentK ON vote.TLike (ParentK);


CREATE TABLE vote.TPoll (
   PollK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ParentK BIGINT
   ,table_number INT        -- Table number for describing what table TPoll belongs to
   ,SuperK BIGINT           -- owner Poll when used in hierarchical structure
   ,UserK BIGINT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT               -- Type of poll
   ,StateC INT              -- State of poll
   ,FName NVARCHAR(500)
   ,FDescription NVARCHAR(MAX)
   ,FBegin DATETIME         -- begin date, when poll starts
   ,FEnd DATETIME           -- end date, when poll ends
   ,FCount BIGINT           -- 
   ,FDelay INT              -- 
   ,FDelayVote FLOAT        -- Time to delay before vote is counted 
   ,FWeight INT             -- Poll weight is used for polls that are weighted.
   ,FDeleted SMALLINT DEFAULT 0 -- if poll is deleted
);
CREATE CLUSTERED INDEX IC_TPoll_ParentK ON vote.TPoll (ParentK);


CREATE TABLE vote.TPollSection (
   PollSectionK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,PollK BIGINT
   ,SuperK BIGINT           -- owner Poll section when used in hierarchical structure
   ,FDescription NVARCHAR(100)
);
CREATE CLUSTERED INDEX IC_TPoll_PollK ON vote.TPollSection (PollK);


CREATE TABLE vote.TPollQuestion (
	PollQuestionK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
	,PollK BIGINT
   ,SuperK BIGINT           -- owner question when used in hierarchical structure
   ,PollSectionK BIGINT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT               -- Type of question
   ,StateC INT              -- State of question
   ,FName NVARCHAR(500)
   ,FDescription NVARCHAR(MAX)
   ,FWeight INT             -- Poll question weight, if different answers is weighted
   ,CONSTRAINT FK_TPollQuestion_PollK FOREIGN KEY (PollK) REFERENCES vote.TPoll(PollK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TPollQuestion_PollK ON vote.TPollQuestion (PollK);

CREATE TABLE vote.TPollAnswer (
	PollAnswerK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
	,PollK BIGINT
	,PollQuestionK BIGINT
   ,SuperK BIGINT           -- owner answer when used in hierarchical structure
   ,PollSectionK BIGINT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT               -- Type of answer
   ,StateC INT              -- State of answer
   ,FName NVARCHAR(500)
   ,FDescription NVARCHAR(MAX)
   ,FCount BIGINT
   ,CONSTRAINT FK_TPollAnswer_PollQuestionK FOREIGN KEY (PollQuestionK) REFERENCES vote.TPollQuestion(PollQuestionK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TPollAnswer_PollK ON vote.TPollAnswer (PollK);
CREATE INDEX I_TPollAnswer_PollQuestionK ON vote.TPollAnswer (PollQuestionK);


CREATE TABLE vote.TPollVote (
	PollVoteK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
	,PollQuestionK BIGINT
   ,PollAnswerK BIGINT
   ,VoterK BIGINT
   ,TypeC INT               -- Type of vote
   ,StateC INT              -- State of vote
   ,FWeight INT             -- If poll is weighted, how much weight voter has set
   ,verified SMALLINT       -- Vote verification, references table vote.verify         
   ,CONSTRAINT FK_TPollVote_PollAnswerK FOREIGN KEY (PollAnswerK) REFERENCES vote.TPollAnswer(PollAnswerK) ON DELETE CASCADE
   ,CONSTRAINT FK_TPollVote_VoterK FOREIGN KEY (VoterK) REFERENCES vote.TVoter(VoterK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TPollVote_PollQuestionK ON vote.TPollVote (PollQuestionK);

CREATE TABLE vote.rule_type (
   "type" SMALLINT NOT NULL
   ,"active" SMALLINT
   ,"description" NVARCHAR(32)
   ,"simple" NVARCHAR(32)
);

INSERT INTO vote.rule_type
VALUES 
   (1,1,'day','')
   ,(2,0,'week','')
   ,(3,0,'month','')
   ,(4,0,'year','')
   ,(5,0,'delay_minutes','')
   ,(6,0,'delay_hours','')



CREATE TABLE vote.verify (
   "type" SMALLINT NOT NULL
   ,"description" NVARCHAR(32)
   ,"value" FLOAT
);

INSERT INTO vote.verify
VALUES 
   (0,'unknown',0.0)
   ,(1,'await',0.1)
   ,(2,'check',0.5)
   ,(4,'ok',0.9)
   ,(8,'verified',1.0)



DECLARE @tableTableNumber TABLE(
   "number" INT NOT NULL
   ,"name" NVARCHAR(100)
   ,"schema" VARCHAR(32)
)

INSERT INTO @tableTableNumber
VALUES 
(11000,'TLike','vote'),
(11010,'TPoll','vote'),
(11020,'TPollQuestion','vote'),
(11030,'TPollAnswer','vote'),
(11040,'TPollVote','vote'),
(11050,'TVoter','vote'),
(11060,'TVoterHistory','vote')

INSERT INTO application.table_number
SELECT * FROM @tableTableNumber
WHERE "number" NOT IN (SELECT "number" FROM application.table_number)
