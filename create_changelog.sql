
/*
ALTER TABLE [application].[TrSystemVersionXArticle]  WITH CHECK ADD  CONSTRAINT [FK_TrSystemVersionXArticle_ArticleK] FOREIGN KEY([ArticleK])
REFERENCES [application].[TArticle] ([ArticleK])
ON DELETE CASCADE
GO

ALTER TABLE [application].[TrSystemVersionXArticle] CHECK CONSTRAINT [FK_TrSystemVersionXArticle_ArticleK]
GO
*/

/*
ALTER TABLE [application].[TrArticleBookXArticle]  WITH CHECK ADD  CONSTRAINT [FK_TrArticleBookXArticle_ActivityK] FOREIGN KEY([ArticleK])
REFERENCES [application].[TArticle] ([ArticleK])
ON DELETE CASCADE
GO

ALTER TABLE [application].[TrArticleBookXArticle] CHECK CONSTRAINT [FK_TrArticleBookXArticle_ActivityK]
GO
*/


/*
   ### Table tree
   TGlobal
      TCustomer
         TCustomerProperty
         TCustomerContact
            TAddress
            TNumber
         TAddress
         TNumber
         TArticle
         TLog
         TLink
         TActivity
            TrActivityXBundle
               TBundle
            TActivityParticipant
         TProject
            TProjectXActivity
               TActivity
         TSale
      TSystem
         TActivity
            TrActivityXBundle
               TBundle
         TArticle
         TArticleBook
            TrArticleBookXArticle
               TArticle
                  TLink
                  TImage
                  TDocument
            TArticleChapter
         TLink
         TSystemVersion
            TLog
            TrSystemVersionXActivity
               TActivity
            TrSystemVersionXProject
               TProject
         TProject
            TProjectXActivity
               TActivity
            TLink
            TArticle
         TSystemRequest
            TrSystemRequestXActivity
               TActivity
         TSale
      TUser
         TProperty

   #### Special tables
   TLink
   TNote
   TImage
   TDocument

 */



IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'application' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA application;';
END

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'documentation' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "documentation";';
END

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'code' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "code";';
END

IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'system' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA "system";';
END

IF OBJECT_ID('application.TrActivityXBundle', 'U') IS NOT NULL  DROP TABLE application.TrActivityXBundle;
IF OBJECT_ID('application.TrActivityXCustomerContact', 'U') IS NOT NULL  DROP TABLE application.TrActivityXCustomerContact;
IF OBJECT_ID('application.TrActivityXTodoList', 'U') IS NOT NULL  DROP TABLE application.TrActivityXTodoList;
IF OBJECT_ID('application.TrActivityXUser', 'U') IS NOT NULL  DROP TABLE application.TrActivityXUser;
IF OBJECT_ID('application.TrArticleXActivity', 'U') IS NOT NULL  DROP TABLE application.TrArticleXActivity;
IF OBJECT_ID('application.TrArticleBookXActivity', 'U') IS NOT NULL  DROP TABLE application.TrArticleBookXActivity;
IF OBJECT_ID('application.TrArticleBookXArticle', 'U') IS NOT NULL  DROP TABLE application.TrArticleBookXArticle;
IF OBJECT_ID('application.TrArticleChapterXArticle', 'U') IS NOT NULL  DROP TABLE application.TrArticleChapterXArticle;
IF OBJECT_ID('application.TrArticlePresentationXArticle', 'U') IS NOT NULL  DROP TABLE application.TrArticlePresentationXArticle;
IF OBJECT_ID('application.TrArticleBookXArticleBookList', 'U') IS NOT NULL  DROP TABLE application.TrArticleBookXArticleBookList;


IF OBJECT_ID('application.TrXBadge', 'U') IS NOT NULL DROP TABLE application.TrXBadge;
IF OBJECT_ID('application.TrCustomerXActivity', 'U') IS NOT NULL  DROP TABLE application.TrCustomerXActivity;
IF OBJECT_ID('application.TrLogXActivity', 'U') IS NOT NULL  DROP TABLE application.TrLogXActivity;
IF OBJECT_ID('application.TrProjectXActivity', 'U') IS NOT NULL  DROP TABLE application.TrProjectXActivity;
IF OBJECT_ID('application.TrProjectPhaseXActivity', 'U') IS NOT NULL  DROP TABLE application.TrProjectPhaseXActivity;
IF OBJECT_ID('application.TrProjectPhaseXTodoList', 'U') IS NOT NULL  DROP TABLE application.TrProjectPhaseXTodoList;
IF OBJECT_ID('application.TrSystemXCustomer', 'U') IS NOT NULL  DROP TABLE application.TrSystemXCustomer;
IF OBJECT_ID('application.TrSystemIntentXActivity', 'U') IS NOT NULL  DROP TABLE application.TrSystemIntentXActivity;
IF OBJECT_ID('application.TrSystemIntentXTodoList', 'U') IS NOT NULL  DROP TABLE application.TrSystemIntentXTodoList;
IF OBJECT_ID('application.TrSystemRequestXActivity', 'U') IS NOT NULL  DROP TABLE application.TrSystemRequestXActivity;
IF OBJECT_ID('application.TrSystemRequestXTodoList', 'U') IS NOT NULL  DROP TABLE application.TrSystemRequestXTodoList;
IF OBJECT_ID('application.TrSystemVersionXArticle', 'U') IS NOT NULL  DROP TABLE application.TrSystemVersionXArticle;
IF OBJECT_ID('application.TrSystemVersionXActivity', 'U') IS NOT NULL  DROP TABLE application.TrSystemVersionXActivity;
IF OBJECT_ID('application.TrSystemVersionXProject', 'U') IS NOT NULL  DROP TABLE application.TrSystemVersionXProject;
IF OBJECT_ID('application.TrSaleXCustomerContact', 'U') IS NOT NULL  DROP TABLE application.TrSaleXCustomerContact;
IF OBJECT_ID('application.TrSaleXActivity', 'U') IS NOT NULL  DROP TABLE application.TrSaleXActivity;
IF OBJECT_ID('application.TrSaleXProject', 'U') IS NOT NULL  DROP TABLE application.TrSaleXProject;
IF OBJECT_ID('application.TrSalePhaseXActivity', 'U') IS NOT NULL  DROP TABLE application.TrSalePhaseXActivity;
IF OBJECT_ID('application.TrSystemXSale', 'U') IS NOT NULL  DROP TABLE application.TrSystemXSale;
IF OBJECT_ID('application.TrSaleXSaleContinuation', 'U') IS NOT NULL  DROP TABLE application.TrSaleXSaleContinuation;
IF OBJECT_ID('application.TrSaleXTodoList', 'U') IS NOT NULL  DROP TABLE application.TrSaleXTodoList;
IF OBJECT_ID('application.TrTodoXUser', 'U') IS NOT NULL  DROP TABLE application.TrTodoXUser;
IF OBJECT_ID('application.TrUserGroupXUser', 'U') IS NOT NULL  DROP TABLE application.TrUserGroupXUser;
IF OBJECT_ID('application.TrUserXCustomer', 'U') IS NOT NULL  DROP TABLE application.TrUserXCustomer;
IF OBJECT_ID('application.TrUserXProject', 'U') IS NOT NULL  DROP TABLE application.TrUserXProject;


IF OBJECT_ID('application.TImage', 'U') IS NOT NULL  DROP TABLE application.TImage;
IF OBJECT_ID('application.TDocument', 'U') IS NOT NULL  DROP TABLE application.TDocument;
IF OBJECT_ID('application.TNote', 'U') IS NOT NULL  DROP TABLE application.TNote;
IF OBJECT_ID('application.TLink', 'U') IS NOT NULL  DROP TABLE application.TLink;
IF OBJECT_ID('application.TLog', 'U') IS NOT NULL  DROP TABLE application.TLog;

IF OBJECT_ID('application.TProperty', 'U') IS NOT NULL  DROP TABLE application.TProperty;
IF OBJECT_ID('application.TPropertyName', 'U') IS NOT NULL  DROP TABLE application.TPropertyName;
IF OBJECT_ID('application.TBadge', 'U') IS NOT NULL DROP TABLE application.TBadge;
IF OBJECT_ID('application.TTag', 'U') IS NOT NULL DROP TABLE application.TTag;
IF OBJECT_ID('application.TTagName', 'U') IS NOT NULL DROP TABLE application.TTagName;

IF OBJECT_ID('application.TTodo', 'U') IS NOT NULL  DROP TABLE application.TTodo;
IF OBJECT_ID('application.TTodoList', 'U') IS NOT NULL  DROP TABLE application.TTodoList;

IF OBJECT_ID('application.TState', 'U') IS NOT NULL  DROP TABLE application.TState;
IF OBJECT_ID('application.TAddress', 'U') IS NOT NULL  DROP TABLE application.TAddress;
IF OBJECT_ID('application.TNumber', 'U') IS NOT NULL  DROP TABLE application.TNumber;

IF OBJECT_ID('application.TArticle', 'U') IS NOT NULL  DROP TABLE application.TArticle;
IF OBJECT_ID('application.TArticleChapter', 'U') IS NOT NULL  DROP TABLE application.TArticleChapter;
IF OBJECT_ID('application.TArticleBook', 'U') IS NOT NULL  DROP TABLE application.TArticleBook;
IF OBJECT_ID('application.TArticleBookList', 'U') IS NOT NULL  DROP TABLE application.TArticleBookList;
IF OBJECT_ID('application.TArticlePresentation', 'U') IS NOT NULL  DROP TABLE application.TArticlePresentation;
IF OBJECT_ID('application.TActivityRemark', 'U') IS NOT NULL  DROP TABLE application.TActivityRemark;
IF OBJECT_ID('application.TActivityParticipant', 'U') IS NOT NULL  DROP TABLE application.TActivityParticipant;
IF OBJECT_ID('application.TBundle', 'U') IS NOT NULL  DROP TABLE application.TBundle;
IF OBJECT_ID('application.TCost', 'U') IS NOT NULL  DROP TABLE application.TCost;
IF OBJECT_ID('application.TActivity', 'U') IS NOT NULL  DROP TABLE application.TActivity;
IF OBJECT_ID('application.TProjectHistory', 'U') IS NOT NULL  DROP TABLE application.TProjectPhase;
IF OBJECT_ID('application.TProjectPhase', 'U') IS NOT NULL  DROP TABLE application.TProjectPhase;
IF OBJECT_ID('application.TProject', 'U') IS NOT NULL  DROP TABLE application.TProject;
IF OBJECT_ID('application.TSystemField', 'U') IS NOT NULL  DROP TABLE application.TSystemField
IF OBJECT_ID('application.TSystemIntent', 'U') IS NOT NULL  DROP TABLE application.TSystemIntent;
IF OBJECT_ID('application.TSystemRequest', 'U') IS NOT NULL  DROP TABLE application.TSystemRequest;
IF OBJECT_ID('application.TSystemVersion', 'U') IS NOT NULL  DROP TABLE application.TSystemVersion;
IF OBJECT_ID('application.TSaleHistory', 'U') IS NOT NULL  DROP TABLE application.TSalePhase;
IF OBJECT_ID('application.TSalePhase', 'U') IS NOT NULL  DROP TABLE application.TSalePhase;
IF OBJECT_ID('application.TSaleService', 'U') IS NOT NULL  DROP TABLE application.TSaleService;
IF OBJECT_ID('application.TSaleContinuation', 'U') IS NOT NULL  DROP TABLE application.TSaleContinuation;
IF OBJECT_ID('application.TSale', 'U') IS NOT NULL  DROP TABLE application.TSale;
IF OBJECT_ID('application.TCustomerProperty', 'U') IS NOT NULL  DROP TABLE application.TCustomerProperty;
IF OBJECT_ID('application.TCustomerSubscription', 'U') IS NOT NULL  DROP TABLE application.TCustomerSubscription;
IF OBJECT_ID('application.TCustomerContact', 'U') IS NOT NULL  DROP TABLE application.TCustomerContact;
IF OBJECT_ID('application.TCustomerChapter', 'U') IS NOT NULL  DROP TABLE application.TCustomerChapter;
IF OBJECT_ID('application.TCustomer', 'U') IS NOT NULL  DROP TABLE application.TCustomer;
IF OBJECT_ID('application.TSystem', 'U') IS NOT NULL  DROP TABLE application.TSystem;
IF OBJECT_ID('application.TUserPinned', 'U') IS NOT NULL  DROP TABLE application.TUserPinned;
IF OBJECT_ID('application.TUserHistory', 'U') IS NOT NULL  DROP TABLE application.TUserHistory;
IF OBJECT_ID('application.TUserGroup', 'U') IS NOT NULL  DROP TABLE application.TUserGroup;
IF OBJECT_ID('application.TUser', 'U') IS NOT NULL  DROP TABLE application.TUser;
IF OBJECT_ID('application.TGlobal', 'U') IS NOT NULL  DROP TABLE application.TGlobal;

IF OBJECT_ID('application.database', 'U') IS NOT NULL  DROP TABLE application.dataabase;
IF OBJECT_ID('application.thread', 'U') IS NOT NULL  DROP TABLE application.thread;
IF OBJECT_ID('application.thread_header', 'U') IS NOT NULL  DROP TABLE application.thread_header;
IF OBJECT_ID('application.table_number', 'U') IS NOT NULL  DROP TABLE application.table_number;
IF OBJECT_ID('application.row_state', 'U') IS NOT NULL  DROP TABLE application.row_state;
IF OBJECT_ID('application.date_span', 'U') IS NOT NULL  DROP TABLE application.date_span;
IF OBJECT_ID('application.version', 'U') IS NOT NULL  DROP TABLE application.version;

IF OBJECT_ID('application.click_counter', 'U') IS NOT NULL  DROP TABLE application.click_counter;
IF OBJECT_ID('application.click_history', 'U') IS NOT NULL  DROP TABLE application.click_history;
IF OBJECT_ID('application.click_type', 'U') IS NOT NULL  DROP TABLE application.click_type;
IF OBJECT_ID('application.query_set', 'U') IS NOT NULL  DROP TABLE application.query_set;


PRINT('CREATE TABLE TGlobal. Global is used to divide data in different sections, like using changelog for different organizations'); CREATE TABLE application.TGlobal (
   "GlobalK" INT NOT NULL
   ,TypeC INT                                               -- Type of global owner
   ,FName NVARCHAR(100)
   ,FSimpleName NVARCHAR(100)
   ,FDatabase VARCHAR(100)                                  -- Database name (mssql,postgresql,oracle,mysql)
   ,CONSTRAINT "PK_TGlobal_GlobalK" PRIMARY KEY ("GlobalK")
);

PRINT('CREATE TABLE TArticleBook'); CREATE TABLE application.TArticleBook (
   ArticleBookK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,UserK INT
   ,SuperK INT
   ,ParentK BIGINT 
   ,table_number INT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                 -- Book type
   ,StateC INT                -- Book state
   ,LanguageC INT             -- Language article is in
   ,LevelC INT                -- Level like difficult vs easy
   ,PriorityC INT             -- Set priority, may be used to simplify searches. Find books that are developed
   ,FName NVARCHAR(500)       -- Book name
   ,FSearchName NVARCHAR(200) -- Search name if suitable
   ,FHeader NVARCHAR(200)     -- Book header
   ,FReleased DATETIME        -- Released date
   ,FReady SMALLINT DEFAULT 0 -- book is ready (can be used to get valid book connecting articles)
   ,FDepreciated SMALLINT DEFAULT 0 -- don't use, going old
   ,FDeleted SMALLINT DEFAULT 0    -- If book i deleted, like old
   ,FCount1 BIGINT            -- General count field
   ,FCount2 BIGINT            -- General count field
);

CREATE CLUSTERED INDEX "application.IC_TArticleBook_ParentK"  ON application.TArticleBook (ParentK);

CREATE TABLE application.TArticleBookList (
   ArticleBookListK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,UserK INT
   ,SuperK INT                -- owner TArticleBook when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD DATETIME          
   ,UpdateD DATETIME
   ,TypeC INT                 -- List type
   ,StateC INT                -- List state
   ,FName NVARCHAR(500)       -- List name
   ,FSearchName NVARCHAR(200)
   ,FDescription NVARCHAR(1000)
   ,FReleased DATETIME        -- List released date
   ,FReady SMALLINT DEFAULT 0 -- book is ready (can be used to get valid book connecting articles)
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0    -- If book i deleted, like old
);

CREATE CLUSTERED INDEX "application.IC_TArticleBookList_ParentK"  ON application.TArticleBookList (ParentK);


PRINT('CREATE TABLE TArticleChapter'); CREATE TABLE application.TArticleChapter (
   ArticleChapterK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,ArticleBookK BIGINT
   ,UserK INT
   ,SuperK INT                -- owner TArticleChapter when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table chapter belongs to
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                 -- Chapter type
   ,StateC INT                -- Chapter state
   ,LanguageC INT             -- Language article is in
   ,FName NVARCHAR(500)       -- chapter name
   ,FHeader NVARCHAR(200)     -- Header or other short text that could be used as chapter description.
   ,FText NVARCHAR(MAX)       -- Chapter text
   ,FHelp NVARCHAR(1000)      -- Text field that may be used for specific UI and informing on how control the navigation
   ,FIndex INT                -- Used if chapters are ordered
   ,FReleased DATETIME        -- Date when chapter was released
   ,FReady SMALLINT DEFAULT 0      -- chapter is ready
   ,FDepreciated SMALLINT DEFAULT 0 -- going old, don't use
   ,FDeleted SMALLINT DEFAULT 0    -- If book i deleted, like old
   ,CONSTRAINT "FK_TArticleChapter_ArticleBookK" FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TArticleChapter_ArticleBookK"  ON application.TArticleChapter (ArticleBookK);
CREATE INDEX "application.I_TArticleChapter_ParentK" ON application.TArticleChapter (ParentK);



PRINT('CREATE TABLE TArticlePresentation'); CREATE TABLE application.TArticlePresentation (
   ArticlePresentationK INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,UserK INT
   ,SuperK INT
   ,ParentK BIGINT 
   ,table_number INT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                 -- Presentation type
   ,StateC INT                -- Presentation state
   ,FName NVARCHAR(500)       -- Presentation name
   ,FSearchName NVARCHAR(200) -- If search name is needed
   ,FDescription NVARCHAR(1000)-- Describe presentation
   ,FReleasedD DATETIME       -- Release date
   ,FReady SMALLINT DEFAULT 0 -- Presentation is ready
   ,FDepreciated SMALLINT DEFAULT 0-- going old, don't use
   ,FDeleted SMALLINT DEFAULT 0 -- If book i deleted, like old
);
CREATE CLUSTERED INDEX "application.IC_TArticlePresentation_ParentK"  ON application.TArticlePresentation (ParentK);


PRINT('CREATE TABLE TArticle, article is used to document items'); CREATE TABLE application.TArticle (
   ArticleK BIGINT IDENTITY(1,1) NOT NULL
   ,ArticleBookK BIGINT
   ,UserK INT
   ,SuperK BIGINT             -- owner TArticle when used in hierarchical structure
   ,ParentK BIGINT
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,Thread INT                -- used to group articles in one single thread, ArticleK for first article in thread will be the thread id
   ,ScopeS INT                  -- Scope is like a level indicator for whom this article is for. Could be technical, for tutorial or some other type of level
   ,LevelC INT
   ,TypeC INT
   ,StateC INT
   ,LanguageC INT             -- Language article is in
   ,TargetC INT               -- to whom the article is target at
   ,ConnectionC INT NOT NULL DEFAULT 0-- How article connects/relates to book it  belongs to
   ,FBrief NVARCHAR(500)      -- Short explanation what is in the article
   ,FHeader NVARCHAR(500)     -- Header
   ,FSearchText NVARCHAR(200) -- Text for making it simpler to search article
   ,FText NVARCHAR(MAX)       -- bulk text for article
   ,FChapterName NVARCHAR(200)
   ,FChapter INT              -- divide in chapters, may be used for ordering
   ,FPage INT                 -- If article is like a book or series this can be used to set the page for ordering
   ,FCreate DATETIME
   ,FUpdate DATETIME
   ,FValidFrom DATETIME
   ,FValidTo DATETIME
   ,FSticky SMALLINT DEFAULT 0-- If article should be "lifted" for the reader based in context article has.
   ,FExtra SMALLINT DEFAULT 0 -- Extra stuff, not that important to the context  article has information about
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TArticle_ArticleK" PRIMARY KEY NONCLUSTERED ("ArticleK")
);

CREATE CLUSTERED INDEX "application.IC_TArticle_ParentK"  ON application.TArticle ("ParentK");
CREATE INDEX "application.I_TArticle_ArticleBookK"  ON application.TArticle ("ArticleBookK");


IF OBJECT_ID('application.TState', 'U') IS NOT NULL  DROP TABLE application.TState;
PRINT('CREATE TABLE TState, state can be used to set the state for rows in table'); CREATE TABLE application.TState (
   "StateK" BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ParentK INT 
   ,table_number INT          -- Table number for describing what table note belongs to
   ,row_state INT             -- State number, hard coded numbers for marking  what state row is in
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,ExecuteAt DATETIME        -- when to set the state
   ,FDescription NVARCHAR(1000)
);   

CREATE CLUSTERED INDEX "application.IC_TState_ParentK"  ON application.TState ("ParentK");



CREATE TABLE application.TUser (
   UserK INT IDENTITY(1,1) NOT NULL
   ,UserGroupK INT
   ,GlobalK INT NOT NULL
   ,CustomerK BIGINT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,AuthorityS INT            -- rights for this user
   ,RoleC INT
   ,FId INT
   ,FAlias NVARCHAR(100)
   ,FLoginName NVARCHAR(100)
   ,FDisplayName NVARCHAR(100)
   ,FFirstName NVARCHAR(100)
   ,FLastName NVARCHAR(100)
   ,FDescription NVARCHAR(1000)
   ,FMail NVARCHAR(200)
   ,FMobile NVARCHAR(100)
   ,FLoginD DATETIME
   ,FLoginCount INT
   ,FProfile VARCHAR(100)
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,FPassword VARCHAR(256)
   ,FLastLoginD DATETIME
   ,FLastIp NVARCHAR(100)
   ,CONSTRAINT "PK_TUser_UserK" PRIMARY KEY NONCLUSTERED ("UserK")
   ,CONSTRAINT "FK_TUser_GlobalK" FOREIGN KEY ("GlobalK") REFERENCES application.TGlobal("GlobalK") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TUser_GlobalK"  ON application.TUser ("GlobalK");
CREATE INDEX "application.I_TUser_FAlias" ON application.TUser (FAlias);
CREATE INDEX "application.I_TUser_FDisplayName" ON application.TUser (FDisplayName);


PRINT('CREATE TABLE TUserGroup'); CREATE TABLE application.TUserGroup (
   UserGroupK INT NOT NULL
   ,AuthorityS INT            -- rights for this group
   ,TypeC INT
   ,FName NVARCHAR(100) NOT NULL
   ,FDescription NVARCHAR(200) 
   ,FValidFromD DATETIME
   ,FValidToD DATETIME
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TUserGroup_UserGroupK" PRIMARY KEY (UserGroupK)
);

CREATE TABLE application.TUserPinned (
   UserPinnedK BIGINT IDENTITY(1,1) NOT NULL
   ,UserK INT NOT NULL
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD DATETIME
   ,RecordK BIGINT NOT NULL
   ,TypeC INT DEFAULT 0
   ,FDescription NVARCHAR(1000)
   ,FValidFromD DATETIME
   ,FValidToD DATETIME
   ,CONSTRAINT "PK_TUserPinned_UserPinnedK" PRIMARY KEY NONCLUSTERED ("UserPinnedK")
);

CREATE CLUSTERED INDEX "application.IC_TUserPinned_UserK"  ON application.TUserPinned ("UserK");
CREATE INDEX I_TUserPinned_RecordK ON application.TUserPinned (RecordK);

CREATE TABLE application.TUserHistory (
   UserHistoryK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,UserK INT NOT NULL
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD DATETIME DEFAULT GETDATE()
   ,RecordK BIGINT
   ,TypeC INT DEFAULT 0       -- Type of history item, this is for some customization
   ,FNumber INT               -- Number related to history post
   ,FValue NVARCHAR(100)      -- Value related to history post, could ip number or something else
   ,FFind NVARCHAR(100)       -- simple word or words to search for if filtering is needed
   ,FDescription NVARCHAR(1000)-- describe history item
);

CREATE CLUSTERED INDEX "application.IC_TUserHistory_UserK"  ON application.TUserHistory ("UserK");


PRINT('CREATE TABLE TrUserGroupXUser'); CREATE TABLE application.TrUserGroupXUser (
   rUserGroupXUserK BIGINT IDENTITY(1,1) NOT NULL
   ,UserGroupK INT NOT NULL
   ,UserK INT NOT NULL
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TrUserGroupXUser_rUserGroupXUserK" PRIMARY KEY NONCLUSTERED ("rUserGroupXUserK")
   ,CONSTRAINT "FK_TrUserGroupXUser_UserGroupK" FOREIGN KEY (UserGroupK) REFERENCES application.TUserGroup(UserGroupK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrUserGroupXUser_UserK" FOREIGN KEY (UserK) REFERENCES application.TUser(UserK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TrUserGroupXUser_UserGroupK" ON application.TrUserGroupXUser (UserGroupK);


PRINT('CREATE TABLE TPropertyName'); CREATE TABLE application.TPropertyName (
   PropertyNameK INT IDENTITY(1,1) NOT NULL
   ,table_number INT          -- Table number for describing what table note belongs to
   ,FName NVARCHAR(100)
   ,FDescription NVARCHAR(1000)
   ,FTag NVARCHAR(100)        -- free text field to do logic if properties should be grouped or some other type of separations
   ,FValid INT                -- Flags marking valid values, default is string, 0x01 = string, 0x02 integer, 0x04 = date, 0x08 = decimal
   ,FMultiple SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TPropertyName_PropertyNameK" PRIMARY KEY ("PropertyNameK")
);


PRINT('CREATE TABLE TProperty, additional properties connected to various tables'); CREATE TABLE application.TProperty (
   PropertyK BIGINT IDENTITY(1,1) NOT NULL
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table property belongs to
   ,PropertyNameK INT
   ,FKey VARCHAR(100)
   ,FValue NVARCHAR(1000)
   ,FValueText NVARCHAR(1000)
   ,FValueInteger BIGINT
   ,FValueDate DATETIME
   ,FValueDecimal FLOAT
   ,FIndex INT
   ,FValid INT                                              -- Flags marking valid values, default is string, 0x01 = string, 0x02 integer, 0x04 = date, 0x08 = decimal
   ,FSystem SMALLINT DEFAULT 0                              -- System property, used to create system logic
   ,CONSTRAINT "PK_TProperty_PropertyK" PRIMARY KEY NONCLUSTERED ("PropertyK")
   ,CONSTRAINT "FK_TProperty_PropertyNameK" FOREIGN KEY ("PropertyNameK") REFERENCES application.TPropertyName(PropertyNameK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TProperty_ParentK"  ON application.TProperty ("ParentK");


PRINT('CREATE TABLE TSystem, Manage systems in changelog database. Systems is those changelog exists for'); CREATE TABLE application.TSystem (
   SystemK INT IDENTITY(1,1) NOT NULL
   ,GlobalK INT
   ,SuperK INT                                              -- owner TSystem when used in hierarchical structure
   ,UserK INT                                               -- responsible user
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                                               -- Type of system, application dependent
   ,StateC INT                                              -- State system is in, application dependent
   ,PriorityC INT                                           -- Priority for system
   ,AreaC INT                                               -- area system  belongs to, could be areas in the organization
   ,FName NVARCHAR(100)
   ,FAbbreviation NVARCHAR(100)                             -- abbreviation for system, sometimes a short name is needed
   ,FDescription NVARCHAR(1000)
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TSystem_SystemK" PRIMARY KEY NONCLUSTERED ("SystemK")
   ,CONSTRAINT "FK_TSystem_GlobalK" FOREIGN KEY ("GlobalK") REFERENCES application.TGlobal("GlobalK") ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TSystem_GlobalK"  ON application.TSystem ("GlobalK");

PRINT('CREATE TABLE TSystemField. Divide system in parts, can be used to group version information'); CREATE TABLE application.TSystemField (
   SystemFieldK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SystemK INT NOT NULL
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,PriorityC INT  DEFAULT 0                                -- Field priority
   ,FName NVARCHAR(200)                                     -- Name for field
   ,FDescription NVARCHAR(1000)                             -- Describe field
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "FK_TSystemField_SystemK" FOREIGN KEY (SystemK) REFERENCES application.TSystem(SystemK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TSystemField_SystemK"  ON application.TSystemField (SystemK);


PRINT('CREATE TABLE TSystemVersion. Manage different versions for each system'); CREATE TABLE application.TSystemVersion (
   SystemVersionK INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SystemK INT NOT NULL
   ,UserK INT                          -- responsible user
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,OverallCounter BIGINT              -- internal counter for all versions, could be used for sorting
   ,SystemCounter BIGINT               -- internal counter for system versions, may be used for sorting
   ,TypeC INT                          -- Type of system version
   ,StateC INT                         -- Version state
   ,TargetC INT                        -- If version is for a aimed at target group
   ,FormC INT                          -- In what form this version is, like developer version, customer version or something else
   ,FReleaseDate DATETIME              -- Planed release date
   ,FReleasedDate DATETIME             -- Actual release date
   ,FVersion1 INT                      -- Major
   ,FVersion2 INT                      -- Minor
   ,FVersion3 INT                      -- Patch
   ,FBuild INT                         -- Build number if used as version
   ,FIndex INT                         -- Index if some sort of custom ordering is needed
   ,FName NVARCHAR(200)                -- Simple version name
   ,FSearchName NVARCHAR(200)          -- Name to simplify searches for this version
   ,FNameInternal NVARCHAR(200)        -- Internal name
   ,FDescription NVARCHAR(1000)        -- Version description
   ,FTested SMALLINT DEFAULT 0         -- mark as tested version has been tested
   ,FReleased SMALLINT DEFAULT 0       -- mark version is released
   ,FDeleted SMALLINT DEFAULT 0        -- mark as deleted but kept in database
   ,FTrailing SMALLINT DEFAULT 0       -- mark as deleted but kept in database

   ,CONSTRAINT "FK_TSystemVersion_SystemK" FOREIGN KEY ("SystemK") REFERENCES application.TSystem("SystemK") ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TSystemVersion_SystemK"  ON application.TSystemVersion (SystemK);
CREATE INDEX "application.I_TSystemVersion_UserK"  ON application.TSystemVersion (UserK);
CREATE INDEX "application.I_TSystemVersion_FReleaseDate"  ON application.TSystemVersion (FReleaseDate);
CREATE INDEX "application.I_TSystemVersion_OverallCounter" ON application.TSystemVersion (OverallCounter);
CREATE INDEX "application.I_TSystemVersion_SystemCounter" ON application.TSystemVersion (SystemCounter);



PRINT('CREATE TABLE TTagName'); CREATE TABLE application.TTagName (
   TagNameK INT IDENTITY(1,1) NOT NULL PRIMARY KEY
   ,table_number INT          -- Table number for describing what table note belongs to
   ,FName NVARCHAR(200)
   ,FDescription NVARCHAR(1000)
);

PRINT('CREATE TABLE TTag, tags connected to different object to mark something'); CREATE TABLE application.TTag (
   TagK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table Tag belongs to
   ,TagNameK INT
   ,FDate DATETIME
   ,CONSTRAINT "FK_TTag_TagNameK" FOREIGN KEY ("TagNameK") REFERENCES application.TTagName(TagNameK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TTag_ParentK"  ON application.TTag ("ParentK");

/*
PRINT('CREATE TABLE TSystemClosure, manage Systems structured in tree'); CREATE TABLE application.TSystemClosure (
   "Ancestor" INT NOT NULL
   ,"Descendant" INT NOT NULL
   ,"Depth" INT NOT NULL
   ,CONSTRAINT "application.FK_TSystemClosure_Ancestor" FOREIGN KEY ("Ancestor") REFERENCES application.TSystem("SystemK") ON DELETE CASCADE
);
*/



PRINT('CREATE TABLE TCustomer'); CREATE TABLE application.TCustomer (
   CustomerK BIGINT IDENTITY(1,1) NOT NULL
   ,GlobalK INT
   ,SuperK BIGINT                                           -- owner TCustomer when used in hierarchical structure
   ,UserK INT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT
   ,CategoryC INT
   ,BusinessC INT 
   ,CountryC INT                                            -- country
   ,SourceC INT                                             -- from where customer was collected
   ,PriorityC INT                                           -- priority for customer
   ,FName NVARCHAR(100)
   ,FSimple NVARCHAR(100)                                   -- simple name for customer
   ,FDepartment NVARCHAR(100)
   ,FOrganisation NVARCHAR(100)                             -- organization number ?
   ,FText0 NVARCHAR(100)
   ,FText1 NVARCHAR(100)
   ,FText2 NVARCHAR(100)
   ,FInteger0 BIGINT
   ,FInteger1 BIGINT
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TCustomer_CustomerK" PRIMARY KEY NONCLUSTERED ("CustomerK")
);
CREATE CLUSTERED INDEX "application.IC_TCustomer_GlobalK"  ON application.TCustomer (GlobalK);


PRINT('CREATE TABLE TCustomerChapter'); CREATE TABLE application.TCustomerChapter (
   CustomerChapterK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,CustomerK BIGINT
   ,UserK INT
   ,SuperK INT                -- owner TCustomerChapter when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table chapter belongs to
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                 -- Chapter type
   ,StateC INT                -- Chapter state
   ,LanguageC INT             -- Language Customer is in
   ,FTypeName NVARCHAR(50)    -- Name used to group chapters
   ,FName NVARCHAR(500)       -- chapter name
   ,FHeader NVARCHAR(200)     -- Header or other short text that could be used as chapter description.
   ,FText NVARCHAR(MAX)       -- Chapter text
   ,FHelp NVARCHAR(1000)      -- Text field that may be used for specific UI and informing on how control the navigation
   ,FIndex INT                -- Used if chapters are ordered
   ,FReleased DATETIME        -- Date when chapter was released
   ,FReady SMALLINT DEFAULT 0      -- chapter is ready
   ,FDepreciated SMALLINT DEFAULT 0 -- going old, don't use
   ,FDeleted SMALLINT DEFAULT 0    -- If chapter is deleted, like old
   ,CONSTRAINT "FK_TCustomerChapter_CustomerK" FOREIGN KEY (CustomerK) REFERENCES application.TCustomer(CustomerK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TCustomerChapter_CustomerK"  ON application.TCustomerChapter (CustomerK);
CREATE INDEX "application.I_TCustomerChapter_ParentK" ON application.TCustomerChapter (ParentK);


PRINT('CREATE TABLE TCustomerContact'); CREATE TABLE application.TCustomerContact (
   CustomerContactK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,CustomerK BIGINT
   ,UserK INT                                               -- If contact is also user in changelog system
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT
   ,CategoryC INT
   ,BusinessC INT
   ,CountryC INT
   ,FName NVARCHAR(100)
   ,FFirstName NVARCHAR(100)
   ,FLastName NVARCHAR(100)
   ,FTitle NVARCHAR(100)
   ,FDepartment NVARCHAR(100)
   ,FPhone NVARCHAR(100)
   ,FMobile NVARCHAR(100)
   ,FMail NVARCHAR(100)
   ,FNickname NVARCHAR(100)
   ,FGender INT
   ,FBirthYear INT
   ,FBirthMonth INT
   ,FBirthDay INT
   ,FText0 NVARCHAR(100)
   ,FText1 NVARCHAR(100)
   ,FInteger0 BIGINT
   ,FInteger1 BIGINT
   ,FRetired SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "FK_TCustomerContact_CustomerK" FOREIGN KEY ("CustomerK") REFERENCES application.TCustomer("CustomerK") ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "IC_TCustomerContact_CustomerK"  ON application.TCustomerContact (CustomerK);
CREATE INDEX "I_TCustomerContact_FName"  ON application.TCustomerContact (FName);


PRINT('CREATE TABLE TCustomerSubscription'); CREATE TABLE application.TCustomerSubscription (
   CustomerSubscriptionK INT IDENTITY(1,1) NOT NULL
   ,CustomerK BIGINT
   ,CustomerContactK BIGINT
   ,UserK INT                                               -- If contact is also user in changelog system
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT
   ,FStartD DATETIME
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TCustomerSubscription_TCustomerSubscriptionK" PRIMARY KEY NONCLUSTERED ("CustomerSubscriptionK")
);


PRINT('CREATE TABLE TLog, used to describe important notes for version'); CREATE TABLE application.TLog (
   LogK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,CustomerK BIGINT                                           -- connection to customer
   ,SystemVersionK INT                                      -- connection to version
   ,UserK INT
   ,CreateD DATETIME
   ,FormatS INT                                             -- description format
   ,ColorS INT                                              -- for color coding
   ,TypeC INT                                               -- type of log
   ,TargetC INT                                             -- If change is for some specific target group
   ,ImpactC INT                                             -- Type of impact change has on system
   ,FTimeD DATETIME
   ,FBrief NVARCHAR(200)
   ,FDescription NVARCHAR(2000)
   ,CONSTRAINT "FK_TLog_SystemVersionK" FOREIGN KEY ("SystemVersionK") REFERENCES application.TSystemVersion("SystemVersionK") ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TLog_SystemVersionK"  ON application.TLog ("SystemVersionK");
CREATE INDEX "application.I_TLog_CustomerK"  ON application.TLog ("CustomerK");

PRINT('CREATE TABLE TTodoList'); CREATE TABLE application.TTodoList (
   TodoListK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,UserK INT                                               -- responsible user
   ,ParentK BIGINT
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                                               -- Type of project
   ,ContextC INT                                            -- In what context this todo list is for
   ,FName NVARCHAR(1000)
   ,FDescription NVARCHAR(2000)
   ,FDeadline DATETIME
   ,FReadyD DATETIME
   ,FClosedD DATETIME
   ,FAlertD DATETIME
   ,FReady SMALLINT DEFAULT 0
   ,FClosed SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
);
CREATE CLUSTERED INDEX "application.IC_TTodoList_ParentK"  ON application.TTodoList (ParentK);


PRINT('CREATE TABLE TTodo, items in todo lists'); CREATE TABLE application.TTodo (
   TodoK BIGINT IDENTITY(1,1) NOT NULL
   ,TodoListK BIGINT 
   ,UserK INT                                               -- responsible user
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                                               -- Type of project
   ,StateC INT                                              -- Some sort of todo status
   ,FDescription NVARCHAR(2000)
   ,FDeadline DATETIME
   ,FReadyD DATETIME
   ,FClosedD DATETIME
   ,FAlertD DATETIME
   ,FIdle SMALLINT DEFAULT 0
   ,FReady SMALLINT DEFAULT 0
   ,FClosed SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TTodo_TodoK" PRIMARY KEY NONCLUSTERED (TodoK)
   ,CONSTRAINT "FK_TTodo_TodoListK" FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE 
);
CREATE CLUSTERED INDEX "application.IC_TTodo_TTodoListK"  ON application.TTodo (TodoListK);

PRINT('CREATE TABLE TrTodoXUser, connect todos to users'); CREATE TABLE application.TrTodoXUser (
   rTodoXUserK BIGINT IDENTITY(1,1) NOT NULL
   ,TodoK BIGINT NOT NULL
   ,UserK INT NOT NULL
   ,CONSTRAINT "PK_TrTodoXUser_rTodoXUserK" PRIMARY KEY NONCLUSTERED (rTodoXUserK)
   ,CONSTRAINT "FK_TrTodoXUser_TodoK" FOREIGN KEY (TodoK) REFERENCES application.TTodo(TodoK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrTodoXUser_UserK" FOREIGN KEY (UserK) REFERENCES application.TUser(UserK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrTodoXUser_TodoK"  ON application.TrTodoXUser (TodoK);



PRINT('CREATE TABLE TProject'); CREATE TABLE application.TProject (
   ProjectK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,GlobalK INT
   ,CustomerChapterK BIGINT                                 -- Use this to create navigation trees
   ,SuperK INT                                              -- owner TProject when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,UserK INT                                               -- responsible user
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                                               -- Type of project
   ,StateC INT                                              -- Some sort of project status
   ,AreaC INT                                               -- area where project belongs to, could be e.g. sales, development, administration
   ,PriorityC INT DEFAULT 0                                 -- Priority for project
   ,FName NVARCHAR(500)
   ,FDescription NVARCHAR(1000)
   ,FText0 NVARCHAR(100)
   ,FText1 NVARCHAR(100)
   ,FBeginD DATETIME                                        -- project start
   ,FEndD DATETIME                                          -- project end
   ,FDeadlineD DATETIME                                     -- deadline time
   ,FTodo SMALLINT  DEFAULT 0
   ,FDone SMALLINT  DEFAULT 0                               -- Project is ready
   ,FPrivate SMALLINT DEFAULT 0                             -- Mark project as private, only those related can  view it
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE CLUSTERED INDEX "application.IC_TProject_ParentK"  ON application.TProject ("ParentK");
CREATE INDEX "application.I_TProject_GlobalK" ON application.TProject ("GlobalK");
CREATE INDEX "application.I_TProject_FStartD"  ON application.TProject ("FBeginD");
CREATE INDEX "application.I_TProject_StateC"  ON application.TProject ("StateC");

CREATE TABLE application.TProjectHistory (
   ProjectHistory BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ProjectK BIGINT NOT NULL
   ,ProjectPhaseK BIGINT
   ,UserK INT                                               -- responsible user
   ,CreateD DATETIME
   ,TypeC INT                                               -- Type of project
   ,StateC INT                                              -- Some sort of project status
   ,PriorityC INT                                           -- Some sort of project priority
   ,LevelC INT                                              -- Some sort of project level
   ,ProgressC INT                                           -- Some sort of improvement or progression.
   ,FDescription NVARCHAR(1000)
   ,FText0 NVARCHAR(100)
   ,FText1 NVARCHAR(100)
   ,FBeginD DATETIME                                        -- project or phase start
   ,FEndD DATETIME                                          -- project or phace end
   ,FMarkerD DATETIME                                       -- some sort of date marker
   ,FInt1 BIGINT                                            -- Custom number
   ,FInt2 BIGINT                                            -- Custom number
   ,FReal1 BIGINT                                           -- Custom number
   ,FReal2 BIGINT                                           -- Custom number
   ,CONSTRAINT "FK_TProjectHistory_ProjectK" FOREIGN KEY (ProjectK) REFERENCES application.TProject(ProjectK) ON DELETE CASCADE   
);

CREATE CLUSTERED INDEX "application.IC_TProjectHistory_ProjectK"  ON application.TProjectHistory ("ProjectK");
CREATE INDEX "application.I_TProjectHistory_ProjectPhaseK"  ON application.TProjectHistory ("ProjectPhaseK");




CREATE TABLE application.TProjectPhase (
   ProjectPhaseK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ProjectK BIGINT
   ,UserK INT                                               -- responsible user
   ,CustomerContactK BIGINT                                 -- Connect to customer contact in one is needed
   ,CustomerChapterK BIGINT                                 -- Use this to create navigation trees
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,FName NVARCHAR(500)
   ,FDescription NVARCHAR(1000)
   ,TypeC INT                                               -- Type of project
   ,StateC INT                                              -- Some sort of project status
   ,PriorityC INT                                           -- Some sort of project priority
   ,LevelC INT                                              -- Some sort of project level
   ,ProgressC INT                                           -- Some sort of improvement or progression.
   ,FBeginD DATETIME                                        -- Phase start
   ,FEndD DATETIME                                          -- Phase end
   ,FExactBeginD DATETIME                                   -- phase real start
   ,FExactEndD DATETIME                                     -- phase real end
   ,FInt1 BIGINT                                            -- Custom number
   ,FInt2 BIGINT                                            -- Custom number
   ,FReal1 BIGINT                                           -- Custom number
   ,FReal2 BIGINT                                           -- Custom number
   ,FDone SMALLINT  DEFAULT 0                               -- phase is ready
   ,FActive SMALLINT DEFAULT 0
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "FK_TProjectPhase_ProjectK" FOREIGN KEY (ProjectK) REFERENCES application.TProject (ProjectK) ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX IC_TProjectPhase_ProjectK ON application.TProjectPhase (ProjectK);
CREATE INDEX I_TProjectPhase_FBeginD ON application.TProjectPhase (FBeginD);


PRINT('CREATE TABLE TSystemIntent, requests regarding systems'); CREATE TABLE application.TSystemIntent (  
   SystemIntentK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SystemK INT NOT NULL
   ,UserK INT                          -- responsible user
   ,SuperK INT                         -- owner TSystemIntent when used in hierarchical structure
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT DEFAULT 0                -- Type of request, e.g. feature, issue, brainstorm 
   ,StateC INT DEFAULT 0               -- Request status, e.g. open, closed, pending, active ...
   ,DifficultyC INT DEFAULT 0          -- How hard it is to implement
   ,PriorityC INT DEFAULT 0            -- How important it is to implement
   ,LengthC INT DEFAULT 0              -- Length as code, this could be used to inform how much time it takes to implement
   ,FBrief NVARCHAR(500)               -- Brief description for intent
   ,FWriter NVARCHAR(200)              -- if there is someone outside that want the feature/intent
   ,FText NVARCHAR(MAX)                -- description about the intent
   ,FComment NVARCHAR(1000)            -- If there is some quick comment that is needed to remember or explain what this is about
   ,FBegin DATETIME                    -- begin date
   ,FEnd DATETIME                      -- end date
   ,FLength FLOAT                      -- Length in number
   ,FDone SMALLINT DEFAULT 0           -- Intent is ready
   ,FDeleted SMALLINT DEFAULT 0        -- Intent is deleted but kept in database
   ,CONSTRAINT "FK_TSystemIntent_SystemK" FOREIGN KEY (SystemK) REFERENCES application.TSystem (SystemK) ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX "application.IC_TSystemIntent_SystemK" ON application.TSystemIntent (SystemK);


PRINT('CREATE TABLE TSystemRequest, requests regarding systems'); CREATE TABLE application.TSystemRequest (  
   SystemRequestK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SystemK INT NOT NULL
   ,UserK INT                                               -- responsible user
   ,CheckedByK INT                                          -- user that has checked response
   ,ContactK INT                                            -- contact this request is sent from
   ,SuperK INT                                              -- owner TSystemRequest when used in hierarchical structure
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                                               -- Type of request, e.g. feature, issue 
   ,StateC INT DEFAULT 0                                    -- Request status, e.g. open, closed, pending, active ...
   ,SourceC INT                                             -- Where request is coming from
   ,DifficultyC INT
   ,PriorityC INT
   ,ContextC INT                                            -- In what context request is for
   ,FBrief NVARCHAR(200)
   ,FWriter NVARCHAR(200)                                   -- free text description for person that is author to request
   ,FWriterAddress NVARCHAR(260)                            -- free text where writer that isn't a user in database can write how to be contacted
   ,FText NVARCHAR(MAX)                                     -- description of what is requested
   ,FComment NVARCHAR(1000)                                 -- If there is some quick comment that is needed to remember or explain what this is about
   ,FBegin DATETIME
   ,FEnd DATETIME
   ,FChecked DATETIME                                       -- Date when request was checked
   ,FDoneD DATETIME                                         -- Date when request was set as done
   ,FWaiting SMALLINT  DEFAULT 0                            -- Request is waiting
   ,FDone SMALLINT  DEFAULT 0                               -- Request is ready
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "FK_TSystemRequest_SystemK" FOREIGN KEY ("SystemK") REFERENCES application.TSystem("SystemK") ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX "application.IC_TSystemRequest_SystemK" ON application.TSystemRequest ("SystemK");
CREATE INDEX "application.I_TSystemRequest_TypeC"  ON application.TSystemRequest ("TypeC");

CREATE TABLE application.TBundle (
   BundleK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SuperK BIGINT                                           -- owner Bundle when used in hierarchical structure
   ,RecordK BIGINT                                          -- If Bundle is used as one single item for another record
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,FId NVARCHAR(50)
   ,FName NVARCHAR(500)
   ,FBegin DATETIME
   ,FEnd DATETIME
   ,FLength BIGINT
   ,FValue FLOAT
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE CLUSTERED INDEX I_TBundle_ParentK ON application.TBundle (ParentK);
CREATE INDEX I_TBundle_RecordK ON application.TBundle (RecordK);


PRINT('CREATE TABLE TCost, manage costs data'); CREATE TABLE application.TCost (
   CostK BIGINT IDENTITY(1,1) NOT NULL
   ,GlobalK INT
   ,CustomerK BIGINT                                        -- connection to customer
   ,SystemK INT                                             -- connection to system
   ,SuperK BIGINT                                           -- owner Cost when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,UserK INT                                               -- responsible user
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeK INT                                               -- Type of Cost
   ,StatusK INT                                             -- Some sort of Cost status
   ,AreaC INT                                               -- area where Cost belongs to, could be e.g. Costs, development, administration
   ,ProbabilityC INT                                        --
   ,ReasonC INT
   ,CurrencyC INT
   ,FName NVARCHAR(500)
   ,FInvoice NVARCHAR(100)
   ,FAmount FLOAT
   ,FAmountPaid FLOAT
   ,FTax FLOAT
   ,FBegin DATETIME
   ,FEnd DATETIME
   ,FDone SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TCost_CostK" PRIMARY KEY NONCLUSTERED (CostK)
);

CREATE CLUSTERED INDEX "application.IC_TCost_CustomerK"  ON application.TCost (CustomerK);
CREATE INDEX "application.I_TCost_FBegin"  ON application.TCost (FBegin);
CREATE INDEX "application.I_TCost_GlobalK"  ON application.TCost (GlobalK);
CREATE INDEX "application.I_TCost_SystemK"  ON application.TCost (SystemK);
CREATE INDEX "application.I_TCost_UserK"  ON application.TCost (UserK);



CREATE TABLE application.TSale (
   SaleK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,GlobalK INT
   ,CustomerK BIGINT                      -- connection to customer
   ,SystemK INT                        -- connection to system
   ,SuperK BIGINT
   ,ParentK BIGINT 
   ,table_number INT
   ,UserK INT 
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,StateS INT                         -- system state settings for sale
   ,TypeC INT                          -- Type of sale
   ,StateC INT                         -- some sort of sale status
   ,AreaC INT                          -- area where sale belongs to, could be e.g. sales, development, administration
   ,ProbabilityC INT                   -- probability that sale is completed
   ,SourceC INT                        -- source for how sale was possible
   ,ReasonC INT                        -- reason for sale outcome
   ,StalledC INT                       -- if sale is stalled, code to identify reason
   ,CurrencyC INT                      -- in what currency sale is in
   ,FName NVARCHAR(500)                -- sale name
   ,FInvoice NVARCHAR(100)             -- some text to connect invoice
   ,FAmount FLOAT                      -- sale amount
   ,FAmountPaid FLOAT                  -- amount payed for sale
   ,FTax FLOAT                         -- sale tax value
   ,FEarning FLOAT                     -- sale profit
   ,FQuantity INT                      -- quantity value for sale
   ,FBegin DATETIME                    -- start date for sale
   ,FEnd DATETIME                      -- end date for sale
   ,FOrderDate DATETIME                -- date when sale was ordered
   ,FDeliverDate DATETIME              -- deliver date for sale
   ,FPayDate DATETIME                  -- date sale is payed
   ,FDone SMALLINT DEFAULT 0           -- mark sale as done
   ,FDeleted SMALLINT DEFAULT 0        -- sale is deleted but kept in database
);

CREATE CLUSTERED INDEX "application.IC_TSale_CustomerK"  ON application.TSale ("CustomerK");
CREATE INDEX "application.I_TSale_FBegin"  ON application.TSale (FBegin);
CREATE INDEX "application.I_TSale_GlobalK"  ON application.TSale ("GlobalK");
CREATE INDEX "application.I_TSale_SystemK"  ON application.TSale ("SystemK");
CREATE INDEX "application.I_TSale_UserK"  ON application.TSale ("UserK");


-- TSaleService, TSaleProduct, TSaleContinuation 


PRINT('CREATE TABLE TSaleService, used to define chargeable time'); CREATE TABLE application.TSaleService (
    SaleServiceK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SaleK BIGINT 
   ,CustomerK BIGINT
   ,ActivityK BIGINT
   ,UserK INT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                                               -- Type of sale
   ,RateC INT                                               -- rate for price like 100 / hour, fixed, free
   ,FUnitPrice FLOAT                                        -- price per unit (hour ?)
   ,FAmount FLOAT                                           -- amount for service
   ,FTimeSpent FLOAT                                        -- total spent time on service
   ,FTimeCharge FLOAT                                       -- time that is chargeable
   ,FBeginD DATETIME                                        -- service start
   ,FEndD DATETIME                                          -- service end
   ,FDescription NVARCHAR(1000)                             -- describe service
   ,CONSTRAINT FK_TSaleService_SaleK FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TSaleService_SaleK"  ON application.TSaleService ("SaleK");
CREATE INDEX "application.I_TSaleService_CustomerK"  ON application.TSaleService ("CustomerK");
CREATE INDEX "application.I_TSaleService_ActivityK"  ON application.TSaleService ("ActivityK");
CREATE INDEX "application.I_TSaleService_UserK"  ON application.TSaleService ("UserK");

PRINT('CREATE TABLE TSaleContinuation, if sale is for subscriptions, leasing or other types of '); CREATE TABLE application.TSaleContinuation (
    SaleContinuationK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SaleK BIGINT 
   ,SuperK BIGINT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,date_span SMALLINT                 -- length type, for how long the sale is valid like a subscription
   ,TypeC INT                          -- Type of continuation
   ,LengthC INT                        -- type of length that continuation has
   ,FAmount FLOAT                      -- amount used to get the continuation
   ,FRebate FLOAT                      -- rebate for continuation
   ,FLength INT                        -- length value
   ,FCancelLength INT                  -- if continuation is canceled, for how long is the cancel time (like three months before)
   ,FBeginD DATETIME                   -- continuation start
   ,FEndD DATETIME                     -- continuation end
   ,FCount INT                         -- if there license is for multiple 
   ,FUsedCount INT                     -- used licenses if there is some sort of count down
   ,FLicenseKey NVARCHAR(1000)         -- if continuation has some sort of license key
   ,FDescription NVARCHAR(1000)
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "FK_TSaleContinuation_SaleK" FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TSaleContinuation_SaleK"  ON application.TSaleContinuation (SaleK);


CREATE TABLE application.TSalePhase (
   SalePhaseK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SaleK BIGINT
   ,UserK INT                          -- responsible user
   ,CustomerContactK BIGINT            -- Connect to customer contact in one is needed
   ,CustomerChapterK BIGINT            -- Use this to create navigation trees
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,FName NVARCHAR(500)
   ,FDescription NVARCHAR(1000)
   ,TypeC INT                          -- Type of sale
   ,StateC INT                         -- Some sort of sale status
   ,AreaC INT                          -- area where sale belongs to, could be e.g. sales, development, administration
   ,ProbabilityC INT                   -- probability that sale is completed
   ,ReasonC INT                        -- reason for sale outcome
   ,ProgressC INT                      -- Some sort of improvement or progression.
   ,FBeginD DATETIME                   -- Phase start
   ,FEndD DATETIME                     -- Phase end
   ,FExactBeginD DATETIME              -- phase real start
   ,FExactEndD DATETIME                -- phase real end
   ,FDeliverDate DATETIME              -- deliver date for sale
   ,FInt1 BIGINT                       -- Custom number
   ,FInt2 BIGINT                       -- Custom number
   ,FReal1 BIGINT                      -- Custom number
   ,FReal2 BIGINT                      -- Custom number
   ,FDone SMALLINT  DEFAULT 0          -- phase is ready
   ,FActive SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "FK_TSalePhase_SaleK" FOREIGN KEY (SaleK) REFERENCES application.TSale (SaleK) ON DELETE CASCADE 
);

CREATE CLUSTERED INDEX IC_TSalePhase_SaleK ON application.TSalePhase (SaleK);
CREATE INDEX I_TSalePhase_FBeginD ON application.TSalePhase (FBeginD);


PRINT('CREATE TABLE TActivity, activities connected to different items in changelog'); CREATE TABLE application.TActivity (
   ActivityK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SuperK BIGINT                      -- owner TActivity when used in hierarchical structure
   ,ParentK BIGINT NOT NULL
   ,table_number INT                   -- Table number for describing what table note belongs to
   ,UserK INT                          -- responsible user
   ,User2K INT                         -- second user
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,ColorS INT                         -- for color coding
   ,AliveS INT                         -- active, closed, deleted
   ,TypeC INT                          -- type code
   ,PriorityC INT                      -- priority code
   ,StateC INT                         -- activity state code
   ,ServiceC INT                       -- used for mark if activity is some sort of service, like consultation and can be used to calculate price
   ,AreaC INT                          -- area where activity belongs to, could be e.g. sales, development, administration
   ,FormC INT                          -- form (format) could be code language if programming task
   ,LevelC INT                         -- level (difficulty) for activity, useful when activity has a lot of text. 
   ,ContextC INT                       -- In what context this activity is for
   ,ReportC INT                        -- if activity is used in some type of reporting, could be used as who gets the report
   ,FDescription NVARCHAR(1000)        -- Activity description, use this for hashtags
   ,FBeginD DATETIME                   -- activity start
   ,FEndD DATETIME                     -- activity end
   ,FAlertD DATETIME                   -- alert time
   ,FDeadlineD DATETIME                -- deadline time
   ,FDoneD DATETIME                    -- date when activity was done
   ,FTimeSpent FLOAT                   -- time spent on activity
   ,FTimeEstimated FLOAT               -- estimated time
   ,FTimeActual FLOAT                  -- actual time spent
   ,FAmount FLOAT                      -- amount associated with activity 
   ,FFromUser INT                      -- if user sent activity to another user
   ,FToUser INT                        -- to user if activity was sent (like mail)
   ,FSort INT                          -- Helper field that could be use for custom sorting
   ,FDone SMALLINT DEFAULT 0           -- Mark that activity is done
   ,FDeleted SMALLINT DEFAULT 0        -- Delete activity but keep it in database
);
CREATE CLUSTERED INDEX "application.IC_TActivity_ParentK"  ON application.TActivity ("ParentK");
CREATE INDEX "application.I_TActivity_UserK"  ON application.TActivity ("UserK");
CREATE INDEX "application.I_TActivity_TypeC"  ON application.TActivity ("TypeC");
CREATE INDEX "application.I_TActivity_FBeginD"  ON application.TActivity ("FBeginD");

PRINT('CREATE TABLE TActivityRemark, used to adding small comments or notes about activity but is not needed for what the activity describes' ); CREATE TABLE application.TActivityRemark (
   ActivityRemarkK BIGINT IDENTITY(1,1) PRIMARY KEY
   ,ActivityK BIGINT NOT NULL
   ,UserK INT                                               -- user writing remark
   ,UpdateD DATETIME NOT NULL
   ,TypeC INT                                               -- Type of activity remark
   ,FRemark NVARCHAR(2000)
   ,CONSTRAINT "FK_TActivityRemark_ActivityK" FOREIGN KEY ("ActivityK") REFERENCES application.TActivity("ActivityK") ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TActivityRemark_ActivityK"  ON application.TActivityRemark (ActivityK);

PRINT('CREATE TABLE TActivityParticipant, connect users and contacts to activities'); CREATE TABLE application.TActivityParticipant (
   ActivityParticipantK BIGINT IDENTITY(1,1) NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,table_number INT NOT NULL                               -- Table number describing the key to participant 
   ,ParticipantK INT NOT NULL                               -- Key to record in table for the participant (TUser or TCustomerContact)
   ,CreateD DATETIME NOT NULL
   ,TypeC INT
   ,CONSTRAINT "PK_TActivityParticipant_ActivityParticipantK" PRIMARY KEY NONCLUSTERED (ActivityParticipantK)
   ,CONSTRAINT "FK_TActivityParticipant_ActivityK" FOREIGN KEY ("ActivityK") REFERENCES application.TActivity("ActivityK") ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TActivityParticipant_ActivityK"  ON application.TActivityParticipant (ActivityK);


PRINT('CREATE TABLE TLink, url links connected to tables'); CREATE TABLE application.TLink (
   LinkK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SuperK BIGINT
   ,ParentK BIGINT 
   ,table_number INT 
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT DEFAULT 0                -- link type
   ,DomainC INT DEFAULT 0              -- domain type as code
   ,FUrl NVARCHAR(1000)                -- link address (valid url to get to linked page)
   ,FName NVARCHAR(1000)               -- link name
   ,FDescription NVARCHAR(1000)        -- link description
   ,FDeleted SMALLINT DEFAULT 0        -- if link is deleted but kept i database
);
CREATE CLUSTERED INDEX "application.IC_TLink_ParentK"  ON application.TLink ("ParentK");


IF OBJECT_ID('application.TAddress', 'U') IS NOT NULL  DROP TABLE application.TAddress;
PRINT('CREATE TABLE TAddress'); CREATE TABLE application.TAddress (
   AddressK INT NOT NULL
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT
   ,CountryC INT
   ,FZip NVARCHAR(100)
   ,FState NVARCHAR(100)
   ,FCity NVARCHAR(100)
   ,FCounty NVARCHAR(100)
   ,FAddress NVARCHAR(100)
   ,FAddress2 NVARCHAR(100)
   ,FAddress3 NVARCHAR(100)
   ,FDescription NVARCHAR(1000)
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TAddress_AddressK" PRIMARY KEY NONCLUSTERED ("AddressK")
);
CREATE CLUSTERED INDEX "application.IC_TAddress_ParentK"  ON application.TAddress ("ParentK");

IF OBJECT_ID('application.TNumber', 'U') IS NOT NULL  DROP TABLE application.TNumber;
CREATE TABLE application.TNumber (
   NumberK BIGINT PRIMARY KEY NONCLUSTERED
   ,ParentK BIGINT 
   ,table_number INT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeC INT                    -- Type of number
   ,CountryC INT                 -- Country number is for
   ,PriorityC INT                -- Number importance
   ,FHead NVARCHAR(100)          -- number head/prefix
   ,FNumber NVARCHAR(1000)       -- actual number
   ,FTail NVARCHAR(100)          -- number tail/postfix
   ,FDescription NVARCHAR(1000)  -- description
   ,FDeleted SMALLINT DEFAULT 0  -- if deleted
);
CREATE CLUSTERED INDEX "application.IC_TNumber_ParentK"  ON application.TNumber ("ParentK");

PRINT('CREATE TABLE TNote, notes for tables in changelog database. could be one to one or one to many'); CREATE TABLE application.TNote (
   NoteK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SuperK BIGINT
   ,RecordK BIGINT
   ,ParentK BIGINT 
   ,table_number INT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,FormatS INT                        -- format for note
   ,TypeC INT                          -- type of note
   ,FTimeD DATETIME                    -- note date
   ,FNote NVARCHAR(MAX)                -- note text
);
CREATE CLUSTERED INDEX "application.IC_TNote_ParentK"  ON application.TNote ("ParentK");
CREATE INDEX "application.I_TNote_RecordK" ON application.TNote ("RecordK");


PRINT('CREATE TABLE TDocument, notes added to different objects in changelog database'); CREATE TABLE application.TDocument (
   DocumentK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SuperK BIGINT                                           -- owner TDocument when used in hierarchical structure
   ,RecordK BIGINT                                          -- If document is used as one single text for another record
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,MimeTypeS INT                                           -- Mime type for document
   ,MimeName VARCHAR(250)                                   -- Mime type for document
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,FTimeD DATETIME
   ,FName NVARCHAR(250)
   ,FFolder NVARCHAR(250)
   ,FDescription NVARCHAR(1000)
   ,FData VARBINARY(MAX) 
);
CREATE CLUSTERED INDEX "IC_TDocument_ParentK"  ON application.TDocument (ParentK);
CREATE INDEX I_TDocument_RecordK ON application.TDocument (RecordK);


PRINT('CREATE TABLE TImage, images added to different objects in changelog database'); CREATE TABLE application.TImage (
   ImageK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SuperK BIGINT
   ,RecordK BIGINT
   ,ParentK BIGINT
   ,table_number INT
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,MimeTypeS INT                      -- Mime type for image
   ,MimeName VARCHAR(250)              -- Mime name
   ,TypeC INT                          -- image type
   ,FTimeD DATETIME                    -- some sort of time for image
   ,FName NVARCHAR(250)                -- image name
   ,FExtension NVARCHAR(100)           -- image extension like file extension
   ,FStyleMin VARCHAR(100)             -- minimized style for image
   ,FStyleMax VARCHAR(100)             -- maximized style for image
   ,FPosition VARCHAR(100)             -- image position
   ,FFolder NVARCHAR(250)              -- folder for image if there is one
   ,FDescription NVARCHAR(1000)        -- image description
   ,FData VARBINARY(MAX)               -- raw image data
   ,FHide SMALLINT DEFAULT 0           -- if hidden
);
CREATE CLUSTERED INDEX IC_TImage_ParentK  ON application.TImage (ParentK);
CREATE INDEX I_TImage_RecordK ON application.TImage (RecordK);

/*
IF OBJECT_ID('application.TDetail', 'U') IS NOT NULL  DROP TABLE application.TDetail;
PRINT('CREATE TABLE TDetail'); CREATE TABLE application.TDetail (
   "DetailK" BIGINT IDENTITY(1,1) NOT NULL
   ,SuperK BIGINT                                           -- owner TDetail when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,TypeS INT                                               -- application type, like tutorial, documentation, 
   ,TypeC INT
   ,FTimeD DATETIME
   ,FBrief NVARCHAR(200)
   ,FText NTEXT
   ,FHidden SMALLINT
   ,FDeleted SMALLINT
   ,CONSTRAINT "PK_TDetail_DetailK" PRIMARY KEY NONCLUSTERED ("DetailK")
);

CREATE CLUSTERED INDEX "IC_TDetail_ParentK"  ON application.TDetail ("ParentK");


PRINT('CREATE TABLE TDetailClosure, manage Details structured in tree'); CREATE TABLE application.TDetailClosure (
   "Ancestor" BIGINT NOT NULL
   ,"Descendant" BIGINT NOT NULL
   ,"Depth" INT NOT NULL
   ,CONSTRAINT "application.FK_TDetailClosure_Ancestor" FOREIGN KEY ("Ancestor") REFERENCES application.TDetail("DetailK") ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "application.IC_TClosure_Ancestor" ON application.TClosure ("Ancestor")
*/


PRINT('CREATE TABLE TrLogXActivity, connect Logs and Activities'); CREATE TABLE application.TrLogXActivity (
   rLogXActivityK INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,LogK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,FSticky SMALLINT DEFAULT 0
   ,FMember SMALLINT DEFAULT 1
   ,CONSTRAINT "FK_TrLogXActivity_LogK" FOREIGN KEY ("LogK") REFERENCES application.TLog("LogK") ON DELETE CASCADE
   ,CONSTRAINT "FK_TrLogXActivity_ActivityK" FOREIGN KEY ("ActivityK") REFERENCES application.TActivity("ActivityK") ON DELETE CASCADE
);

CREATE CLUSTERED INDEX IC_TrLogXActivity_ActivityK  ON application.TrLogXActivity (ActivityK);



PRINT('CREATE TABLE TrUserXCustomer, connect users and customers'); CREATE TABLE application.TrUserXCustomer (
   "rUserXCustomerK" INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,"UserK" INT NOT NULL
   ,"CustomerK" INT NOT NULL
   ,RoleC INT
   ,CONSTRAINT "FK_TrUserXCustomer_UserK" FOREIGN KEY ("UserK") REFERENCES application.TUser("UserK") ON DELETE CASCADE
   ,CONSTRAINT "FK_TrUserXCustomer_CustomerK" FOREIGN KEY ("CustomerK") REFERENCES application.TCustomer("CustomerK") ON DELETE CASCADE
);

CREATE CLUSTERED INDEX "IC_TrUserXCustomer_CustomerK"  ON application.TrUserXCustomer ("CustomerK");


PRINT('CREATE TABLE TrUserXProject, connect users and projects'); CREATE TABLE application.TrUserXProject (
   rUserXProjectK INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,UserK INT NOT NULL
   ,ProjectK BIGINT NOT NULL
   ,AuthorityS INT            -- rights for this user
   ,RoleC INT
   ,FSticky SMALLINT DEFAULT 0
   ,FMember SMALLINT DEFAULT 1
   ,CONSTRAINT "FK_TrUserXProject_UserK" FOREIGN KEY ("UserK") REFERENCES application.TUser("UserK") ON DELETE CASCADE
   ,CONSTRAINT "FK_TrUserXProject_ProjectK" FOREIGN KEY ("ProjectK") REFERENCES application.TProject("ProjectK") ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrUserXProject_ProjectK"  ON application.TrUserXProject ("ProjectK");


PRINT('CREATE TABLE TrSystemIntentXActivity, connect system intent and activity'); CREATE TABLE application.TrSystemIntentXActivity (
   rSystemIntentXActivityK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SystemIntentK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrSystemIntentXActivity_SystemIntentK" FOREIGN KEY (SystemIntentK) REFERENCES application.TSystemIntent(SystemIntentK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemIntentXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemIntentXActivity_SystemIntentK"  ON application.TrSystemIntentXActivity (SystemIntentK);


PRINT('CREATE TABLE TrSystemIntentXTodoList, connect system intent and todo lists'); CREATE TABLE application.TrSystemIntentXTodoList (
   rSystemIntentXTodoListK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SystemIntentK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrSystemIntentXTodoList_SystemIntentK" FOREIGN KEY (SystemIntentK) REFERENCES application.TSystemIntent(SystemIntentK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemIntentXTodoList_TodoListK" FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemIntentXTodoList_SystemIntentK"  ON application.TrSystemIntentXTodoList (SystemIntentK);


PRINT('CREATE TABLE TrSystemRequestXActivity, connect system requests and activities'); CREATE TABLE application.TrSystemRequestXActivity (
   rSystemRequestXActivityK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SystemRequestK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrSystemRequestXActivity_SystemRequestK" FOREIGN KEY (SystemRequestK) REFERENCES application.TSystemRequest(SystemRequestK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemRequestXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrSystemRequestXActivity_SystemRequestK  ON application.TrSystemRequestXActivity (SystemRequestK);


PRINT('CREATE TABLE TrSystemRequestXTodoList, connect activities to articles'); CREATE TABLE application.TrSystemRequestXTodoList (
   rSystemRequestXTodoListK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SystemRequestK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrSystemRequestXTodoList_SystemRequestK" FOREIGN KEY (SystemRequestK) REFERENCES application.TSystemRequest(SystemRequestK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemRequestXTodoList_TodoListK" FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrSystemRequestXTodoList_SystemRequestK  ON application.TrSystemRequestXTodoList (SystemRequestK);


PRINT('CREATE TABLE TrSystemVersionXArticle, connect system Versions and activities'); CREATE TABLE application.TrSystemVersionXArticle (
   rSystemVersionXArticleK BIGINT IDENTITY(1,1) NOT NULL
   ,SystemVersionK INT NOT NULL
   ,ArticleK BIGINT NOT NULL
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,BondC INT DEFAULT 0                                     -- Describe the bond to between version and article
   ,FDescription NVARCHAR(1000)
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT "PK_TrSystemVersionXArticle_rSystemVersionXArticleK" PRIMARY KEY NONCLUSTERED (rSystemVersionXArticleK)
   ,CONSTRAINT "FK_TrSystemVersionXArticle_SystemVersionK" FOREIGN KEY (SystemVersionK) REFERENCES application.TSystemVersion(SystemVersionK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemVersionXArticle_ArticleK" FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemVersionXArticle_SystemVersionK"  ON application.TrSystemVersionXArticle (SystemVersionK);
CREATE INDEX "application.I_TrSystemVersionXArticle_ArticleK"  ON application.TrSystemVersionXArticle (ArticleK);

PRINT('CREATE TABLE TrSystemVersionXActivity, connect system Versions and activities'); CREATE TABLE application.TrSystemVersionXActivity (
   rSystemVersionXActivityK BIGINT IDENTITY(1,1) NOT NULL
   ,SystemVersionK INT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,TargetC INT                                             -- If change is for some specific target group (same code as in TLog)
   ,ImpactC INT                                             -- Type of impact change has on system
   ,CONSTRAINT "PK_TrSystemVersionXActivity_rSystemVersionXActivityK" PRIMARY KEY NONCLUSTERED (rSystemVersionXActivityK)
   ,CONSTRAINT "FK_TrSystemVersionXActivity_SystemVersionK" FOREIGN KEY (SystemVersionK) REFERENCES application.TSystemVersion(SystemVersionK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemVersionXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemVersionXActivity_SystemVersionK"  ON application.TrSystemVersionXActivity (SystemVersionK);

PRINT('CREATE TABLE TrSystemVersionXProject, connect system Versions and activities'); CREATE TABLE application.TrSystemVersionXProject (
   rSystemVersionXProjectK BIGINT IDENTITY(1,1) NOT NULL
   ,SystemVersionK INT NOT NULL
   ,ProjectK BIGINT NOT NULL
   ,TargetC INT                                             -- If change is for some specific target group (same code as in TLog)
   ,ImpactC INT                                             -- Type of impact change has on system
   ,CONSTRAINT "PK_TrSystemVersionXProject_rSystemVersionXProjectK" PRIMARY KEY NONCLUSTERED (rSystemVersionXProjectK)
   ,CONSTRAINT "FK_TrSystemVersionXProject_SystemVersionK" FOREIGN KEY (SystemVersionK) REFERENCES application.TSystemVersion(SystemVersionK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemVersionXProject_ProjectK" FOREIGN KEY (ProjectK) REFERENCES application.TProject(ProjectK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemVersionXProject_SystemVersionK"  ON application.TrSystemVersionXProject (SystemVersionK);

PRINT('CREATE TABLE TrProjectXActivity, connect activities to project'); CREATE TABLE application.TrProjectXActivity (
   rProjectXActivityK BIGINT IDENTITY(1,1) NOT NULL
   ,ProjectK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT "PK_TrProjectXActivity_rProjectXActivityK" PRIMARY KEY NONCLUSTERED (rProjectXActivityK)
   ,CONSTRAINT "FK_TrProjectXActivity_ProjectK" FOREIGN KEY (ProjectK) REFERENCES application.TProject(ProjectK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrProjectXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrProjectXActivity_ProjectK"  ON application.TrProjectXActivity (ProjectK);


/*
CREATE TABLE application.TrProjectPhaseXActivity (
   rProjectPhaseXActivityK BIGINT IDENTITY(1,1) NOT NULL
   ,ProjectPhaseK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT PK_TrProjectPhaseXActivity_rProjectPhaseXActivityK PRIMARY KEY NONCLUSTERED (rProjectPhaseXActivityK)
   ,CONSTRAINT FK_TrProjectPhaseXActivity_ProjectPhaseK FOREIGN KEY (ProjectPhaseK) REFERENCES application.TProjectPhase(ProjectPhaseK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrProjectPhaseXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrProjectPhaseXActivity_ProjectPhaseK" ON application.TrProjectPhaseXActivity (ProjectPhaseK);
*/

CREATE TABLE application.TrProjectPhaseXTodoList (
   rProjectPhaseXTodoListK BIGINT IDENTITY(1,1) NOT NULL
   ,ProjectPhaseK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT PK_ProjectPhaseXTodoList_rProjectPhaseXTodoListK PRIMARY KEY NONCLUSTERED (rProjectPhaseXTodoListK)
   ,CONSTRAINT FK_TrProjectPhaseXTodoList_ProjectPhaseK FOREIGN KEY (ProjectPhaseK) REFERENCES application.TProjectPhase(ProjectPhaseK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrProjectPhaseXTodoList_TodoListK FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrProjectPhaseXTodoList_ProjectPhaseK" ON application.TrProjectPhaseXTodoList (ProjectPhaseK);


CREATE TABLE application.TrProjectPhaseXActivity (
   rProjectPhaseXActivityK BIGINT IDENTITY(1,1) NOT NULL
   ,ProjectPhaseK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,StateC INT                                              -- state settings for project manager about the activity
   ,ColorC INT                                              -- color code, can be used for anything
   ,FAlertD DATETIME
   ,FDescription VARCHAR(1000)
   ,FOrder INT
   ,CONSTRAINT "PK_TrProjectPhaseXActivity_rProjectPhaseXActivityK" PRIMARY KEY NONCLUSTERED (rProjectPhaseXActivityK)
   ,CONSTRAINT "FK_TrProjectPhaseXActivity_ProjectPhaseK" FOREIGN KEY (ProjectPhaseK) REFERENCES application.TProjectPhase(ProjectPhaseK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrProjectPhaseXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrProjectPhaseXActivity_ProjectPhaseK ON application.TrProjectPhaseXActivity (ProjectPhaseK);


PRINT('CREATE TABLE TrActivityXBundle, connect activities to Bundles'); CREATE TABLE application.TrActivityXBundle (
   rActivityXBundleK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ActivityK BIGINT NOT NULL
   ,BundleK BIGINT NOT NULL
   ,FDescription NVARCHAR(1000)
   ,CONSTRAINT "FK_TrActivityXBundle_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrActivityXBundle_BundleK" FOREIGN KEY (BundleK) REFERENCES application.TBundle(BundleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrActivityXBundle_ActivityK"  ON application.TrActivityXBundle (ActivityK);


PRINT('CREATE TABLE TrActivityXCustomerContact, connect activities to CustomerContacts'); CREATE TABLE application.TrActivityXCustomerContact (
   rActivityXCustomerContactK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ActivityK BIGINT NOT NULL
   ,CustomerContactK BIGINT NOT NULL
   ,RoleC INT                                               -- What type of role CustomerContact has for activity
   ,FDescription NVARCHAR(1000)
   ,CONSTRAINT "FK_TrActivityXCustomerContact_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrActivityXCustomerContact_CustomerContactK" FOREIGN KEY (CustomerContactK) REFERENCES application.TCustomerContact(CustomerContactK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrActivityXCustomerContact_ActivityK"  ON application.TrActivityXCustomerContact (ActivityK);


PRINT('CREATE TABLE TrActivityXTodoList, connect activities to articles'); CREATE TABLE application.TrActivityXTodoList (
   rActivityXTodoListK BIGINT IDENTITY(1,1) NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT "PK_TrActivityXTodoList_rActivityXTodoListK" PRIMARY KEY NONCLUSTERED (rActivityXTodoListK)
   ,CONSTRAINT "FK_TrActivityXTodoList_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrActivityXTodoList_TodoListK" FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrActivityXTodoList_ActivityK"  ON application.TrActivityXTodoList (ActivityK);


PRINT('CREATE TABLE TrActivityXUser, connect activities to users'); CREATE TABLE application.TrActivityXUser (
   rActivityXUserK BIGINT IDENTITY(1,1) NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,UserK INT NOT NULL
   ,RoleC INT                                               -- What type of role user has for activity
   ,FDescription NVARCHAR(1000)
   ,CONSTRAINT "PK_TrActivityXUser_rActivityXUserK" PRIMARY KEY NONCLUSTERED (rActivityXUserK)
   ,CONSTRAINT "FK_TrActivityXUser_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrActivityXUser_UserK" FOREIGN KEY (UserK) REFERENCES application.TUser(UserK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrActivityXUser_ActivityK"  ON application.TrActivityXUser (ActivityK);


PRINT('CREATE TABLE TrArticleXActivity, connect activities to articles'); CREATE TABLE application.TrArticleXActivity (
   rArticleXActivityK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ArticleK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrArticleXActivity_ArticleK" FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrArticleXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrArticleXActivity_ArticleK"  ON application.TrArticleXActivity (ArticleK);



PRINT('CREATE TABLE TrArticleBookXArticle, connect articles to books'); CREATE TABLE application.TrArticleBookXArticle (
   rArticleBookXArticleK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ArticleBookK BIGINT NOT NULL
   ,ArticleK BIGINT NOT NULL
   ,TypeC INT                                               -- Type of connection between article and book
   ,FPage INT
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleBookXArticle_ArticleBookK FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleBookXArticle_ArticleK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrArticleBookXArticle_ArticleBookK  ON application.TrArticleBookXArticle (ArticleBookK);


CREATE TABLE application.TrArticleChapterXArticle (
   rArticleChapterXArticle BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ArticleChapterK BIGINT NOT NULL
   ,ArticleK BIGINT NOT NULL
   ,TypeC INT                                               -- Type of connection between article and book
   ,FPage INT
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleChapterXArticle_ArticleChapterK FOREIGN KEY (ArticleChapterK) REFERENCES application.TArticleChapter(ArticleChapterK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleChapterXArticle_ArticleK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrArticleChapterXArticle_ArticleChapterK  ON application.TrArticleChapterXArticle (ArticleChapterK);

CREATE TABLE application.TrArticleBookXArticleBookList (
   rArticleBookXArticleBookList BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ArticleBookK BIGINT NOT NULL
   ,ArticleBookListK BIGINT NOT NULL
   ,TypeC INT                                               -- Type of connection between article and book
   ,FPage INT
   ,FOrder INT
   ,FDescription NVARCHAR(1000)
   ,FHelp NVARCHAR(1000)
   ,CONSTRAINT FK_TrArticleBookXArticleBookList_ArticleBookK FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleBookXArticleBookList_ArticleBookListK FOREIGN KEY (ArticleBookListK) REFERENCES application.TArticleBookList(ArticleBookListK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_rArticleBookXArticleBookList_ArticleBookK  ON application.TrArticleBookXArticleBookList (ArticleBookK);
CREATE INDEX I_rArticleBookXArticleBookList_ArticleBookListK  ON application.TrArticleBookXArticleBookList (ArticleBookListK);



PRINT('CREATE TABLE TrArticlePresentationXArticle, use this to add "slides to a presentation"'); CREATE TABLE application.TrArticlePresentationXArticle (
   rArticlePresentationXArticleK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ArticlePresentationK INT
   ,ArticleK BIGINT 
   ,UserK INT
   ,SuperK BIGINT                                           -- owner TrArticlePresentationXArticle when used in hierarchical structure
   ,TypeC INT                                               -- Type of connection between article and book
   ,TransitionC INT                                         -- If there are some effect when article is presented
   ,StyleC INT                                              -- Type of display style for article
   ,NameStyleC INT                                          -- Style for name if displayed in some form of presentation
   ,LevelC INT
   ,TargetC INT
   ,FName NVARCHAR(500)                                     -- Name for "slide"
   ,FDevelop NVARCHAR(100)                                  -- Text to use when creating slides, could be used to filter and configure. When ready it may be emptied
   ,FPage INT
   ,FOrder INT
   ,CONSTRAINT "FK_TrArticlePresentationXArticle_ArticlePresentationK" FOREIGN KEY (ArticlePresentationK) REFERENCES application.TArticlePresentation(ArticlePresentationK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrArticlePresentationXArticle_ArticleK" FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrArticlePresentationXArticle_ArticlePresentationK"  ON application.TrArticlePresentationXArticle (ArticlePresentationK);


PRINT('CREATE TABLE TrArticleBookXActivity, connect system requests and activities'); CREATE TABLE application.TrArticleBookXActivity (
   rArticleBookXActivityK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,ArticleBookK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrArticleBookXActivity_ArticleBookK" FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrArticleBookXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrArticleBookXActivity_ArticleBookK"  ON application.TrArticleBookXActivity (ArticleBookK);


PRINT('CREATE TABLE TrCustomerXActivity, for connecting Customers and activities'); CREATE TABLE application.TrCustomerXActivity (
   rCustomerXActivityK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,CustomerK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrCustomerXActivity_CustomerK" FOREIGN KEY (CustomerK) REFERENCES application.TCustomer(CustomerK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrCustomerXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrCustomerXActivity_CustomerK"  ON application.TrCustomerXActivity (CustomerK);


PRINT('CREATE TABLE TrSaleXActivity, for connecting sales and activities'); CREATE TABLE application.TrSaleXActivity (
   rSaleXActivityK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SaleK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT "FK_TrSaleXActivity_SaleK" FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSaleXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSaleXActivity_SaleK"  ON application.TrSaleXActivity (SaleK);

PRINT('CREATE TABLE TrSaleXCustomerContact, for connecting sales and customer contacts'); CREATE TABLE application.TrSaleXCustomerContact (
   rSaleXCustomerContactK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SaleK BIGINT NOT NULL
   ,CustomerContactK BIGINT NOT NULL
   ,CreateD DATETIME
   ,UpdateD DATETIME
   ,RoleC INT                                               -- Type of connection between sale and customer contact
   ,FDescription NVARCHAR(1000)                             -- Describe contact and how ot relates to sale
   ,CONSTRAINT "FK_TrSaleXCustomerContact_SaleK" FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSaleXCustomerContact_CustomerContactK" FOREIGN KEY (CustomerContactK) REFERENCES application.TCustomerContact(CustomerContactK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSaleXCustomerContact_SaleK"  ON application.TrSaleXCustomerContact (SaleK);


PRINT('CREATE TABLE TrSaleXProject, for connecting sales and activities'); CREATE TABLE application.TrSaleXProject (
   rSaleXProjectK BIGINT IDENTITY(1,1) NOT NULL
   ,SaleK BIGINT NOT NULL
   ,ProjectK BIGINT NOT NULL
   ,CONSTRAINT "PK_TrSaleXProject_rSaleXProjectK" PRIMARY KEY NONCLUSTERED (rSaleXProjectK)
   ,CONSTRAINT "FK_TrSaleXProject_SaleK" FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSaleXProject_ProjectK" FOREIGN KEY (ProjectK) REFERENCES application.TProject(ProjectK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSaleXProject_SaleK"  ON application.TrSaleXProject (SaleK);

PRINT('CREATE TABLE TrSaleXSaleContinuation, for connecting sales and activities'); CREATE TABLE application.TrSaleXSaleContinuation (
   rSaleXSaleContinuationK BIGINT IDENTITY(1,1) NOT NULL
   ,SaleK BIGINT NOT NULL
   ,SaleContinuationK BIGINT NOT NULL
   ,CreateD DATETIME
   ,FBeginD DATETIME                                        -- continuation start
   ,FDescription NVARCHAR(1000)                             -- Describe Continuation
   ,CONSTRAINT "PK_TrSaleXSaleContinuation_rSaleXSaleContinuationK" PRIMARY KEY NONCLUSTERED (rSaleXSaleContinuationK)
   ,CONSTRAINT "FK_TrSaleXSaleContinuation_SaleK" FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSaleXSaleContinuation_SaleContinuationK" FOREIGN KEY (SaleContinuationK) REFERENCES application.TSaleContinuation(SaleContinuationK) ON DELETE NO ACTION
);
CREATE CLUSTERED INDEX "application.IC_TrSaleXSaleContinuation_SaleK"  ON application.TrSaleXSaleContinuation (SaleK);


PRINT('CREATE TABLE TrSaleXTodoList, connect activities to articles'); CREATE TABLE application.TrSaleXTodoList (
   rSaleXTodoListK BIGINT IDENTITY(1,1) NOT NULL
   ,SaleK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT "PK_TrSaleXTodoList_rSaleXTodoListK" PRIMARY KEY NONCLUSTERED (rSaleXTodoListK)
   ,CONSTRAINT "FK_TrSaleXTodoList_SaleK" FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSaleXTodoList_TodoListK" FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSaleXTodoList_SaleK"  ON application.TrSaleXTodoList (SaleK);


PRINT('CREATE TABLE TrSystemXCustomer, connect System with customer'); CREATE TABLE application.TrSystemXCustomer (
   rSystemXCustomerK BIGINT IDENTITY(1,1) NOT NULL
   ,SystemK INT NOT NULL
   ,CustomerK BIGINT NOT NULL
   ,CreateD DATETIME
   ,TypeC INT                                               -- Type of connection between system and customer
   ,FDescription NVARCHAR(1000)
   ,FBeginD DATETIME                                        -- start
   ,FEndD DATETIME                                          -- end
   ,CONSTRAINT "PK_TrSystemXCustomer_rSystemXCustomerK" PRIMARY KEY NONCLUSTERED (rSystemXCustomerK)
   ,CONSTRAINT "FK_TrSystemXCustomer_SystemK" FOREIGN KEY (SystemK) REFERENCES application.TSystem(SystemK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemXCustomer_CustomerK" FOREIGN KEY (CustomerK) REFERENCES application.TCustomer(CustomerK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemXCustomer_SystemK"  ON application.TrSystemXCustomer (SystemK);
CREATE INDEX "application.I_TrSystemXCustomer_CustomerK"  ON application.TrSystemXCustomer (CustomerK);


CREATE TABLE application.TrSalePhaseXActivity (
   rSalePhaseXActivityK BIGINT IDENTITY(1,1) NOT NULL
   ,SalePhaseK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,StateC INT                                              -- state settings for Sale manager about the activity
   ,ColorC INT                                              -- color code, can be used for anything
   ,FAlertD DATETIME
   ,FDescription VARCHAR(1000)
   ,FOrder INT
   ,CONSTRAINT "PK_TrSalePhaseXActivity_rSalePhaseXActivityK" PRIMARY KEY NONCLUSTERED (rSalePhaseXActivityK)
   ,CONSTRAINT "FK_TrSalePhaseXActivity_SalePhaseK" FOREIGN KEY (SalePhaseK) REFERENCES application.TSalePhase(SalePhaseK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSalePhaseXActivity_ActivityK" FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX IC_TrSalePhaseXActivity_SalePhaseK ON application.TrSalePhaseXActivity (SalePhaseK);

CREATE TABLE application.TrSystemXSale (
   rSystemXSaleK BIGINT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED
   ,SystemK INT NOT NULL
   ,SaleK BIGINT NOT NULL
   ,FDescription NVARCHAR(1000)                             -- Describe relation between system and sale
   ,CONSTRAINT "FK_TrSystemXSale_SystemK" FOREIGN KEY (SystemK) REFERENCES application.TSystem(SystemK) ON DELETE CASCADE
   ,CONSTRAINT "FK_TrSystemXSale_SaleK" FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX "application.IC_TrSystemXSale_SystemK"  ON application.TrSystemXSale (SystemK);


PRINT('CREATE TABLE TBadge, tag that could be used as hashtags'); CREATE TABLE application.TBadge (
    BadgeK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,CreatedD DATETIME DEFAULT GETDATE()
   ,FName NVARCHAR(200)
   ,FDescription NVARCHAR(500)
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,FInteger0 BIGINT
);
CREATE CLUSTERED INDEX IC_TBadge_FName ON application.TBadge (FName);


PRINT('CREATE TABLE TrXBadge, could be used to relate hashtags for tables'); CREATE TABLE application.TrXBadge (
   rXBadgeK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED 
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for table hashtags relation belongs to
   ,BadgeK BIGINT
   ,CreateD DATETIME DEFAULT GETDATE()
   ,CONSTRAINT "FK_TrXBadge_BadgeK" FOREIGN KEY (BadgeK) REFERENCES application.TBadge(BadgeK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX IC_TrXBadge_ParentK  ON application.TrXBadge (ParentK);
CREATE INDEX I_TrXBadge_BadgeK  ON application.TrXBadge (BadgeK);



IF OBJECT_ID('application.version', 'U') IS NOT NULL  DROP TABLE application.version;
PRINT('CREATE TABLE version'); CREATE TABLE application.version (
   "major" INT NOT NULL
   ,"minor" INT NOT NULL
   ,"name" NVARCHAR(100)
);

IF OBJECT_ID('application.database', 'U') IS NOT NULL  DROP TABLE application."database";
CREATE TABLE application."database" (
   database_name VARCHAR(100)
   ,database_type VARCHAR(100)
);
INSERT INTO  application."database" VALUES ('SQL Server','mssql')


INSERT INTO application.version
VALUES (1,0,'Create database')

PRINT('CREATE TABLE table_number, small table with number for each table within schema called application'); 
CREATE TABLE application.table_number (
   "number" INT NOT NULL
   ,"name" NVARCHAR(100)
   ,"schema" VARCHAR(32)
);

INSERT INTO application.table_number ("number","name")
VALUES (1000,'TGlobal'),(1010,'TSystem'),(1020,'TUser'),(1030,'TCustomer'),(1040,'TContact'),
       (1050,'TProject'),(1060,'TSale'),(1061,'TSaleService'),(1062,'TSaleContinuation'),(1070,'TLog'),(1090,'TSystemVersion'),
       (1100,'TLink'),(1110,'TActivity'),(1120,'TDocument'),(1130,'TDetail'),(1140,'TNote'),
       (1150,'TSystemRequest'),(1160,'TArticle'),(1170,'TArticleBook'),(1180,'TActivityRemark'),
       (1190,'TActivityParticipant'), (1200,'TCustomerContact'),(1210,'TTodo'),(1220,'TTodoList'),
       (1230,'TArticlePresentation'),(1240,'TCost'),(1250,'TArticleChapter'),(1260,'TSystemIntent'),(1300,'TAddress'),(1310,'TNumber'),
       (1320,'TProjectPhase'),(1330,'TCustomerChapter'),(1340,'TArticleChapter'),
       (2000,'TrArticlePresentationXArticle');


PRINT('CREATE TABLE row_state'); CREATE TABLE application.row_state (
   "state" INT NOT NULL
   ,"description" NVARCHAR(20)
);

/*
0x01 = something is turned on (true)
0x02 = something is turned off (false)

select any of the pair to mark the row state
 */
INSERT INTO application.row_state
VALUES 
    (1 + 256 * 1,'create')
   ,(3 + 256 * 1,'destroy')
   ,(1 + 256 * 2,'activate')
   ,(3 + 256 * 2,'deactivate')
   ,(1 + 256 * 3,'show')
   ,(3 + 256 * 3,'hide')
   ,(1 + 256 * 4,'open')
   ,(3 + 256 * 4,'close')
   ,(1 + 256 * 5,'active')
   ,(3 + 256 * 5,'idle')
   ,(1 + 256 * 6,'alive')
   ,(3 + 256 * 6,'dead')

PRINT('CREATE TABLE date_span'); CREATE TABLE application.date_span (
   "span" INT NOT NULL
   ,"description" NVARCHAR(20)
);

INSERT INTO application.date_span
VALUES (1,'day'),(2,'week'),(3,'month'),(4,'quarter'),(5,'year')

/*
   Tables used for user interaction
   Tables involved: 
      click_counter: counts click for or to record
      click_history: register when click was done, also has text field for more information
      click_type: type of click

 */

-- table used for calculating activity
PRINT('CREATE TABLE click_counter'); CREATE TABLE application.click_counter (
   UserK INT
   ,table_number INT NOT NULL
   ,FKey BIGINT NOT NULL
   ,FCounter BIGINT NOT NULL
   ,FQuery UNIQUEIDENTIFIER
   ,click_type SMALLINT
   ,set_id INT                                              -- id to query set used
);

CREATE CLUSTERED INDEX "application.IC_click_counter_FKey" ON application.click_counter (FKey)

-- table used for calculating activity
PRINT('CREATE TABLE click_history'); CREATE TABLE application.click_history (
   UserK INT
   ,table_number INT NOT NULL
   ,FKey BIGINT NOT NULL
   ,FWhen DATETIME NOT NULL
   ,FFrom VARCHAR(100)
   ,FQuery UNIQUEIDENTIFIER
   ,click_type SMALLINT
   ,set_id INT                                              -- id to query set used
);

CREATE CLUSTERED INDEX "application.IC_click_history_FKey" ON application.click_history (FKey)

CREATE TABLE application.click_type (
   "type" SMALLINT NOT NULL
   ,"description" NVARCHAR(32)
);

INSERT INTO application.click_type
VALUES 
   (1,'logon')
   ,(2,'result row')
   ,(3,'menu')
   ,(4,'text')
   ,(5,'url')
   ,(6,'view record')
   ,(7,'edit record')


-- List of query set's used to work with changelog
CREATE TABLE application.query_set (
   id INT PRIMARY KEY
   ,"name" NVARCHAR(100)
   ,description NVARCHAR(200)
);




PRINT('CREATE TABLE thread_header, information about each code thread'); CREATE TABLE application.thread_header (
   FThreadId BIGINT NOT NULL
   ,"table_number" INT                                      -- Table number for describing what table note belongs to
   ,FNextId INT NOT NULL DEFAULT 0
);
CREATE CLUSTERED INDEX "application.IC_thread_header_FThreadId" ON application.thread_header ("FThreadId")


PRINT('CREATE TABLE thread, information about thread entries'); CREATE TABLE application.thread (
   FThreadId BIGINT NOT NULL
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,FKey BIGINT NOT NULL
   ,FDepth INT 
   ,FNext INT
   ,FPath VARCHAR(1024)
);
CREATE CLUSTERED INDEX "application.IC_thread_FThreadId" ON application.thread ("FThreadId")

CREATE TABLE application.event_user (
   TypeNumber SMALLINT NOT NULL
   ,CreateD DATETIME DEFAULT GETDATE()
   ,FDescription VARCHAR(100)
   ,FIp VARCHAR(32)

);
CREATE CLUSTERED INDEX "application.IC_event_user" ON application.event_user (CreateD)


CREATE TABLE documentation.describe_table (
   TableK INT PRIMARY KEY
   ,FName  VARCHAR(200)
   ,FSimpleName  VARCHAR(200)
   ,FDescription VARCHAR(1000)
   ,FSchema  VARCHAR(100)
   ,FTableNumber INT
);

CREATE TABLE documentation.describe_column (
   ColumnK INT PRIMARY KEY
   ,TableK INT 
   ,FName  VARCHAR(200)
   ,FSimpleName  VARCHAR(200)
   ,FApplicationType VARCHAR(200)
   ,FDescription VARCHAR(1000)
);


