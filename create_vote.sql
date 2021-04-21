/*
   ### Table tree
   
   TVoter
      TVoterPassword
      TVoterHistory
      TVoterRule
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

IF OBJECT_ID('vote.TrPollGroupXPoll', 'U') IS NOT NULL  DROP TABLE vote.TrPollGroupXPoll;

IF OBJECT_ID('vote.TVoterPassword', 'U') IS NOT NULL  DROP TABLE vote.TVoterPassword;
IF OBJECT_ID('vote.TVoterHistory', 'U') IS NOT NULL  DROP TABLE vote.TVoterHistory;
IF OBJECT_ID('vote.TVoterRule', 'U') IS NOT NULL  DROP TABLE vote.TVoterRule;
IF OBJECT_ID('vote.TLike', 'U') IS NOT NULL  DROP TABLE vote.TLike;
IF OBJECT_ID('vote.TPollLimit', 'U') IS NOT NULL  DROP TABLE vote.TPollLimit;
IF OBJECT_ID('vote.TPollVote', 'U') IS NOT NULL  DROP TABLE vote.TPollVote;
IF OBJECT_ID('vote.TPollAnswer', 'U') IS NOT NULL  DROP TABLE vote.TPollAnswer;
IF OBJECT_ID('vote.TPollComment', 'U') IS NOT NULL  DROP TABLE vote.TPollComment;
IF OBJECT_ID('vote.TPollQuestion', 'U') IS NOT NULL  DROP TABLE vote.TPollQuestion;
IF OBJECT_ID('vote.TPollSection', 'U') IS NOT NULL  DROP TABLE vote.TPollSection;
IF OBJECT_ID('vote.TPoll', 'U') IS NOT NULL  DROP TABLE vote.TPoll;
IF OBJECT_ID('vote.TPollGroup', 'U') IS NOT NULL  DROP TABLE vote.TPollGroup;
IF OBJECT_ID('vote.TVoter', 'U') IS NOT NULL  DROP TABLE vote.TVoter;

/**
 * TVoter is the main table that register information about each voter. It holds information about
 * user for the user to able to function in system. 
 */
CREATE TABLE vote.TVoter (
	VoterK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,UserK BIGINT           -- Reference to system user if voter is a user
   ,SuperK BIGINT          -- owner voter when used in hierarchical structure
   ,ContactK BIGINT        -- Some type of external connection, if voter is found in other systems
   ,CreateD DATETIME       -- When voter was created
   ,UpdateD DATETIME       -- Last update
   ,FIp VARCHAR(100)       -- Last ip used
   ,FUserAgent VARCHAR(100)-- Last user agent in use (browser)
   ,FUserKey BINARY(16)    -- Universally unique identifier for user  
   ,FName NVARCHAR(100)    -- User name
   ,FAlias NVARCHAR(100)   -- Alias for user, this could be used in system when user comments or votes
   ,FMail NVARCHAR(100)    -- Mail to user, if system needs to send something
   ,FPhone NVARCHAR(100)   -- Phone number that may be used for sms or other types of feedback
   ,FLastVote DATETIME     -- Last time when voter voted
   ,FValidated INT         -- Number that marks how valid this voter is
   ,FDeleted SMALLINT DEFAULT 0 -- If voter is deleted, like old
);

/**
 * Voter password
 */
CREATE TABLE vote.TVoterPassword (
   VoterPasswordK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,VoterK BIGINT          -- Reference to voter
   ,CreateD DATETIME       -- When password was created
   ,UpdateD DATETIME       -- last update
   ,password_type SMALLINT -- type of password, like type of encryption algorithm
   ,FPassword BINARY(100)  -- encrypted password
   ,FId NVARCHAR(100)      -- associated id to password, like mail address, phone number, alias or something that is known to voter
   ,FMail NVARCHAR(100)    -- Mail to user, if system needs to send something
   ,FLastUse DATETIME      -- Last time password was used
   ,FDeleted SMALLINT DEFAULT 0 -- If voter is deleted, like old
   ,CONSTRAINT FK_TVoterPassword_VoterK FOREIGN KEY (VoterK) REFERENCES vote.TVoter(VoterK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TVoterPassword_VoterK ON vote.TVoterPassword (VoterK);

/**
 * Voter rules are rules voters can create to make it harder for someone to hack the user and abuse the system. 
 * - It can be about the voter setting up a rule where voting may only be cast within a certain time interval of the day.
 * - That voters are only allowed to vote X number of times in a week or similar.
 * - Maybe if you vote once, it will take an hour before the next vote can be cast.
 * 
 * Rules need to be simple enough that a stored procedure can implement them. This is run and verifies that the voter is allowed to vote, the database manages the rule or rules.
 */
CREATE TABLE vote.TVoterRule (
   VoterRuleK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,VoterK BIGINT          -- Reference to voter
   ,CreateD DATETIME       -- When rule was created
   ,UpdateD DATETIME       -- last update
   ,rule_type SMALLINT     -- type of rule that limits vote cheating
   ,FValue INT             -- rule value
   ,FDate DATETIME         -- rule date
   ,FDescription NVARCHAR(200)
   ,CONSTRAINT FK_TVoterRule_VoterK FOREIGN KEY (VoterK) REFERENCES vote.TVoter(VoterK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TVoterRule_VoterK ON vote.TVoterRule (VoterK);

/**
 * History of what voters have done in the system, especially login history.
 */
CREATE TABLE vote.TVoterHistory (
   VoterHistoryK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
	,VoterK BIGINT          -- Reference to voter
   ,CreateD DATETIME       -- When post was created
   ,FIp VARCHAR(100)       -- Ip used
   ,FUserAgent VARCHAR(100)-- browser used
   ,FName NVARCHAR(100)    -- History name, some type of descriptive name for history post
   ,FLastVote DATETIME     -- date from TVoter if voter voted
   ,CONSTRAINT FK_TVoterHistory_VoterK FOREIGN KEY (VoterK) REFERENCES vote.TVoter(VoterK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TVoterHistory_VoterK ON vote.TVoterHistory (VoterK);



CREATE TABLE vote.TLike (
   LikeK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,VoterK BIGINT          -- Reference to voter
   ,ParentK BIGINT
   ,table_number INT       -- Table number for describing what table TLike belongs to
   ,UpdateD DATETIME
   ,TypeC INT              -- Type of like or dislike
   ,UserK BIGINT
   ,ContactK BIGINT
   ,FCount BIGINT
);
CREATE CLUSTERED INDEX IC_TLike_ParentK ON vote.TLike (ParentK);


CREATE TABLE vote.TPollGroup (
   PollGroupK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ParentK BIGINT
   ,table_number INT          -- Table number for describing what table group belongs to
   ,SuperK INT                -- owner group when used in hierarchical structure
   ,UserK INT                 -- responsible user
   ,CreateD DATETIME          -- when group was created
   ,UpdateD DATETIME          -- when group was updated
   ,TypeC INT                 -- Type of group, application dependent
   ,StateC INT                -- State group is in, application dependent
   ,PriorityC INT             -- Priority for group
   ,AreaC INT                 -- area system belongs to, could be areas in the organization or geographical areas
   ,FName NVARCHAR(100)       -- Group name
   ,FAbbreviation NVARCHAR(100)-- abbreviation for poll group, sometimes a short name is needed
   ,FDescription NVARCHAR(1000)-- Group description if needed
   ,FIdle SMALLINT DEFAULT 0  -- group is set on idle (resting)
   ,FDeleted SMALLINT DEFAULT 0-- group is deleted
);

CREATE CLUSTERED INDEX "vote.IC_TPollGroup_SuperK" ON vote.TPollGroup (SuperK);
CREATE INDEX "vote.IC_TPollGroup_ParentK" ON vote.TPollGroup (ParentK);


CREATE TABLE vote.TPoll (
   PollK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,PollGroupK BIGINT       -- main poll group that poll is connected to if any
   ,ParentK BIGINT          -- if poll is connected to any other table compare to normal connection
   ,table_number INT        -- Table number for describing what table TPoll belongs to
   ,SuperK BIGINT           -- owner Poll when used in hierarchical structure
   ,UserK BIGINT            -- user that has created this poll
   ,CreateD DATETIME        -- when poll was created
   ,UpdateD DATETIME        -- last time poll was updated
   ,TypeC INT               -- Type of poll
   ,StateC INT              -- State of poll
   ,FName NVARCHAR(500)     -- poll name
   ,FHeader NVARCHAR(200)   -- poll header
   ,FDescription NVARCHAR(MAX)-- describe poll
   ,FBegin DATETIME         -- begin date, when poll starts
   ,FEnd DATETIME           -- end date, when poll ends
   ,FCount BIGINT           -- 
   ,FDelay INT              -- 
   ,FDelayVote FLOAT        -- Time to delay before vote is counted 
   ,FWeight INT             -- Poll weight is used for polls that are weighted.
   ,FDeleted SMALLINT DEFAULT 0 -- if poll is deleted
);
CREATE CLUSTERED INDEX "vote.IC_TPoll_ParentK" ON vote.TPoll (ParentK);
CREATE INDEX "vote.I_TPoll_PollGroupK" ON vote.TPoll (PollGroupK);



CREATE TABLE vote.TPollSection (
   PollSectionK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,PollK BIGINT
   ,SuperK BIGINT           -- owner Poll section when used in hierarchical structure
   ,FIndex INT              -- used to order sections
   ,FDescription NVARCHAR(100)
);
CREATE CLUSTERED INDEX IC_TPoll_PollK ON vote.TPollSection (PollK);

CREATE TABLE vote.TPollComment (
   PollCommentK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,PollK BIGINT
   ,VoterK BIGINT           -- Voter reference
   ,SuperK BIGINT           -- owner Poll section when used in hierarchical structure
   ,CreateD DATETIME        -- when comment was created
   ,UpdateD DATETIME        -- last time comment was modified
   ,FormatS INT             -- Comment format type
   ,TypeC INT               -- Type of comment
   ,FText NVARCHAR(1000)    -- Comment text
   ,FDeleted SMALLINT DEFAULT 0 -- if poll is deleted
);
CREATE CLUSTERED INDEX IC_TPollComment_PollK ON vote.TPollComment (PollK);
CREATE INDEX I_TPollComment_VoterK ON vote.TPollComment (VoterK);


CREATE TABLE vote.TPollLimit (
   PollLimitK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,PollK BIGINT
   ,UpdateD DATETIME
   ,limit_type SMALLINT     -- limit type
   ,FDescription NVARCHAR(200)-- Describe limit
   ,FLimitInteger INT       -- Integer number for limit
   ,FLimitDecimal FLOAT     -- Decimal value for poll limit
   ,FLimitDate DATETIME     -- Date value for limit
   ,FLimitText NVARCHAR(100)-- Text
);
CREATE CLUSTERED INDEX IC_TPollLimit_PollK ON vote.TPollLimit (PollK);

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
   ,FOrder INT              -- order question in poll
   ,CONSTRAINT FK_TPollQuestion_PollK FOREIGN KEY (PollK) REFERENCES vote.TPoll(PollK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TPollQuestion_PollK ON vote.TPollQuestion (PollK);

CREATE TABLE vote.TPollAnswer (
	PollAnswerK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
	,PollK BIGINT
	,PollQuestionK BIGINT
   ,SuperK BIGINT           -- owner answer when used in hierarchical structure
   ,PollSectionK BIGINT     -- When poll is divided in sections
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT               -- Type of answer
   ,StateC INT              -- State of answer
   ,FName NVARCHAR(500)     -- Answer name, this is used when answer is listed for voter to select
   ,FDescription NVARCHAR(MAX)-- Answer description if there is a need to describe
   ,FCount BIGINT
   ,FOrder INT              -- order answer for question
   ,CONSTRAINT FK_TPollAnswer_PollQuestionK FOREIGN KEY (PollQuestionK) REFERENCES vote.TPollQuestion(PollQuestionK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TPollAnswer_PollK ON vote.TPollAnswer (PollK);
CREATE INDEX I_TPollAnswer_PollQuestionK ON vote.TPollAnswer (PollQuestionK);



CREATE TABLE vote.TPollVote (
	PollVoteK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
	,PollQuestionK BIGINT
   ,PollAnswerK BIGINT
   ,VoterK BIGINT           -- Voter reference
   ,CreateD DATETIME        -- Date when vote is created
   ,TypeC INT               -- Type of vote
   ,StateC INT              -- State of vote
   ,FSelect INT             -- Probably 1 if voter has selected this answer
   ,FWeight INT             -- If poll is weighted, how much weight voter has set
   ,FIp NVARCHAR(100)       -- Ip number used for vote
   ,FComment NVARCHAR(500)  -- Comment for vote
   ,verified SMALLINT       -- Vote verification, references table vote.verify
   ,FTie UNIQUEIDENTIFIER
   ,CONSTRAINT FK_TPollVote_PollAnswerK FOREIGN KEY (PollAnswerK) REFERENCES vote.TPollAnswer(PollAnswerK) ON DELETE CASCADE
   ,CONSTRAINT FK_TPollVote_VoterK FOREIGN KEY (VoterK) REFERENCES vote.TVoter(VoterK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TPollVote_PollQuestionK ON vote.TPollVote (PollQuestionK);
CREATE INDEX I_TPollVote_FTie ON vote.TPollVote (FTie);


CREATE TABLE vote.TrPollGroupXPoll (
   rPollGroupXPollK BIGINT IDENTITY(1,1) NOT NULL
   ,PollGroupK BIGINT NOT NULL
   ,PollK BIGINT NOT NULL
   ,CONSTRAINT "PK_TrPollGroupXPoll_rPollGroupXPollK" PRIMARY KEY NONCLUSTERED (rPollGroupXPollK)
   ,CONSTRAINT "FK_TrPollGroupXPoll_PollGroupK" FOREIGN KEY (PollGroupK) REFERENCES vote.TPollGroup(PollGroupK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrPollGroupXPoll_PollK" FOREIGN KEY (PollK) REFERENCES vote.TPoll(PollK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "vote.IC_PollGroupXPoll_PollGroupK" ON vote.TrPollGroupXPoll (PollGroupK);


CREATE TABLE vote.tie (
   FKey BIGINT
   ,FTie UNIQUEIDENTIFIER
);
CREATE CLUSTERED INDEX IC_tie_FTie ON vote.tie (FTie);




IF OBJECT_ID('vote.rule_type', 'U') IS NOT NULL  DROP TABLE vote.rule_type;
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

IF OBJECT_ID('vote.limit_type', 'U') IS NOT NULL  DROP TABLE vote.limit_type;
/**
 * Table with type of limit rules for each poll. This is a system type
 */
CREATE TABLE vote.limit_type (
   "type" SMALLINT NOT NULL
   ,"active" SMALLINT
   ,"description" NVARCHAR(32)
   ,"simple" NVARCHAR(128)
);

INSERT INTO vote.limit_type
VALUES 
   (1,1,'min_count','Min selected')
   ,(2,1,'max_count','Max selected')
   ,(3,1,'min_value','Min value')
   ,(4,1,'max_value','Max value')
   ,(5,0,'start_date','Poll starts')
   ,(6,0,'end_date','Poll ends')
   ,(7,0,'max_change_count','Max changes')
   ,(8,0,'delay_change_days','When voter are able to change vote')


IF OBJECT_ID('vote.verify', 'U') IS NOT NULL  DROP TABLE vote.verify;
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
(11010,'TPollGroup','vote'),
(11020,'TPoll','vote'),
(11030,'TPollSection','vote'),
(11040,'TPollLimit','vote'),
(11050,'TPollQuestion','vote'),
(11060,'TPollAnswer','vote'),
(11070,'TPollVote','vote'),
(11080,'TPollComment','vote'),
(11090,'TVoter','vote'),
(11100,'TVoterRule','vote'),
(11110,'TVoterHistory','vote'),
(11120,'TVoterPassword','vote')

DELETE FROM application.table_number WHERE "number" >= 11000 AND "number" < 12000

INSERT INTO application.table_number
SELECT * FROM @tableTableNumber
WHERE "number" NOT IN (SELECT "number" FROM application.table_number)
