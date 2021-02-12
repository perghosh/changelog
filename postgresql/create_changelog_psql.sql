
CREATE SCHEMA IF NOT EXISTS application;
CREATE SCHEMA IF NOT EXISTS documentation;
CREATE SCHEMA IF NOT EXISTS code;
CREATE SCHEMA IF NOT EXISTS system;



DROP TABLE IF EXISTS application.TrActivityXBundle CASCADE;
DROP TABLE IF EXISTS application.TrActivityXCustomerContact CASCADE;
DROP TABLE IF EXISTS application.TrActivityXTodoList CASCADE;
DROP TABLE IF EXISTS application.TrActivityXUser CASCADE;
DROP TABLE IF EXISTS application.TrArticleBookXActivity CASCADE;
DROP TABLE IF EXISTS application.TrArticleBookXArticle CASCADE;
DROP TABLE IF EXISTS application.TrArticleBookXArticleBookList CASCADE;

DROP TABLE IF EXISTS application.TrArticleChapterXArticle CASCADE;

DROP TABLE IF EXISTS application.TrArticlePresentationXArticle CASCADE;
DROP TABLE IF EXISTS application.TrArticleXActivity CASCADE;
DROP TABLE IF EXISTS application.TrCustomerXActivity CASCADE;
DROP TABLE IF EXISTS application.TrLogXActivity CASCADE;
DROP TABLE IF EXISTS application.TrProjectXActivity CASCADE;
DROP TABLE IF EXISTS application.TrProjectPhaseXActivity CASCADE;
DROP TABLE IF EXISTS application.TrProjectPhaseXTodoList CASCADE;
DROP TABLE IF EXISTS application.TrSaleXActivity CASCADE;
DROP TABLE IF EXISTS application.TrSaleXCustomerContact CASCADE;
DROP TABLE IF EXISTS application.TrSaleXProject CASCADE;
DROP TABLE IF EXISTS application.TrSaleXSaleContinuation CASCADE;
DROP TABLE IF EXISTS application.TrSaleXTodoList CASCADE;
DROP TABLE IF EXISTS application.TrSystemIntentXActivity CASCADE;
DROP TABLE IF EXISTS application.TrSystemIntentXTodoList CASCADE;
DROP TABLE IF EXISTS application.TrSystemRequestXActivity CASCADE;
DROP TABLE IF EXISTS application.TrSystemRequestXTodoList CASCADE;
DROP TABLE IF EXISTS application.TrSystemVersionXActivity CASCADE;
DROP TABLE IF EXISTS application.TrSystemVersionXArticle CASCADE;
DROP TABLE IF EXISTS application.TrSystemVersionXProject CASCADE;
DROP TABLE IF EXISTS application.TrSystemXCustomer CASCADE;
DROP TABLE IF EXISTS application.TrTodoXUser CASCADE;
DROP TABLE IF EXISTS application.TrUserGroupXUser CASCADE;
DROP TABLE IF EXISTS application.TrUserXCustomer CASCADE;
DROP TABLE IF EXISTS application.TrUserXProject CASCADE;
DROP TABLE IF EXISTS application.TrXBadge CASCADE;


DROP TABLE IF EXISTS application.TProperty CASCADE;
DROP TABLE IF EXISTS application.TAddress CASCADE;
DROP TABLE IF EXISTS application.TBadge CASCADE;

DROP TABLE IF EXISTS application.TTag CASCADE;
DROP TABLE IF EXISTS application.TTagName CASCADE;
DROP TABLE IF EXISTS application.TImage CASCADE;
DROP TABLE IF EXISTS application.TDocument CASCADE;
DROP TABLE IF EXISTS application.TNumber CASCADE;
DROP TABLE IF EXISTS application.TLink CASCADE;
DROP TABLE IF EXISTS application.TNote CASCADE;


DROP TABLE IF EXISTS application.TTodo CASCADE;
DROP TABLE IF EXISTS application.TTodoList CASCADE;
DROP TABLE IF EXISTS application.TProjectPhase CASCADE;
DROP TABLE IF EXISTS application.TProject CASCADE;

DROP TABLE IF EXISTS application.TArticleBook CASCADE;
DROP TABLE IF EXISTS application.TArticleBookList CASCADE;
DROP TABLE IF EXISTS application.TArticleChapter CASCADE;
DROP TABLE IF EXISTS application.TArticlePresentation CASCADE;
DROP TABLE IF EXISTS application.TArticle CASCADE;
DROP TABLE IF EXISTS application.TActivityParticipant CASCADE;
DROP TABLE IF EXISTS application.TActivityRemark CASCADE;
DROP TABLE IF EXISTS application.TActivity CASCADE;
DROP TABLE IF EXISTS application.TBundle CASCADE;
DROP TABLE IF EXISTS application.TCost CASCADE;
DROP TABLE IF EXISTS application.TSale CASCADE;
DROP TABLE IF EXISTS application.TSaleService CASCADE;
DROP TABLE IF EXISTS application.TSaleContinuation CASCADE;

DROP TABLE IF EXISTS application.TLog CASCADE;
DROP TABLE IF EXISTS application.TCustomerSubscription CASCADE;
DROP TABLE IF EXISTS application.TCustomerContact CASCADE;
DROP TABLE IF EXISTS application.TCustomer CASCADE;

DROP TABLE IF EXISTS application.TSystemField CASCADE;
DROP TABLE IF EXISTS application.TSystemIntent CASCADE;
DROP TABLE IF EXISTS application.TSystemRequest CASCADE;
DROP TABLE IF EXISTS application.TSystemVersion CASCADE;
DROP TABLE IF EXISTS application.TSystem CASCADE;

DROP TABLE IF EXISTS application.TPropertyName CASCADE;
DROP TABLE IF EXISTS application.TPropert CASCADE;

DROP TABLE IF EXISTS application.TUser CASCADE;
DROP TABLE IF EXISTS application.TUserGroup CASCADE;
DROP TABLE IF EXISTS application.TUserPinned CASCADE;

DROP TABLE IF EXISTS application.TGlobal CASCADE;

DROP TABLE IF EXISTS application.database CASCADE;
DROP TABLE IF EXISTS application.thread CASCADE;
DROP TABLE IF EXISTS application.thread_header CASCADE;
DROP TABLE IF EXISTS application.table_number CASCADE;
DROP TABLE IF EXISTS application.row_state CASCADE;
DROP TABLE IF EXISTS application.date_span CASCADE;
DROP TABLE IF EXISTS application.version CASCADE;


CREATE TABLE application.TGlobal (
   GlobalK INT PRIMARY KEY
   ,TypeC INT                                               -- Type of global owner
   ,FName VARCHAR(100)
   ,FSimpleName VARCHAR(100)
   ,FDatabase VARCHAR(100)                                  -- Database name (mssql,postgresql,oracle,mysql)
);


CREATE TABLE application.TUser (
   UserK INT PRIMARY KEY
   ,UserGroupK INT
   ,GlobalK INT NOT NULL
   ,CustomerK INT
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,AuthorityS INT            -- rights for this user
   ,RoleC INT
   ,FId INT
   ,FAlias VARCHAR(100)
   ,FLoginName VARCHAR(100)
   ,FDisplayName VARCHAR(100)
   ,FFirstName VARCHAR(100)
   ,FLastName VARCHAR(100)
   ,FDescription VARCHAR(1000)
   ,FMail VARCHAR(200)
   ,FMobile VARCHAR(100)
   ,FLoginD TIMESTAMP
   ,FLoginCount INT
   ,FProfile VARCHAR(100)
   ,FIdle INT DEFAULT 0
   ,FDeleted INT DEFAULT 0
   ,FPassword VARCHAR(256)
   ,FLastLoginD TIMESTAMP
   ,CONSTRAINT FK_TUser_GlobalK FOREIGN KEY (GlobalK) REFERENCES application.TGlobal(GlobalK) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX I_TUser_GlobalK  ON application.TUser (GlobalK);
CREATE INDEX I_TUser_FAlias ON application.TUser (FAlias);
CREATE INDEX I_TUser_FDisplayName ON application.TUser (FDisplayName);

CREATE TABLE application.TUserGroup (
   UserGroupK INT PRIMARY KEY
   ,AuthorityS INT                                          -- rights for this group
   ,TypeC INT
   ,FName VARCHAR(100) NOT NULL
   ,FDescription VARCHAR(200) 
   ,FValidFromD TIMESTAMP
   ,FValidToD TIMESTAMP
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE TABLE application.TUserPinned (
   UserPinnedK BIGSERIAL PRIMARY KEY
   ,UserK INT NOT NULL
   ,table_number INT          -- Table number for describing what table note belongs to
   ,RecordK BIGINT NOT NULL
   ,CreateD TIMESTAMP DEFAULT NOW()
   ,TypeC INT DEFAULT 0
   ,FDescription VARCHAR(1000)
   ,FValidFromD TIMESTAMP
   ,FValidToD TIMESTAMP
);
CREATE INDEX I_TUserPinned_UserK ON application.TUserPinned (UserK);
CREATE INDEX I_TUserPinned_RecordK ON application.TUserPinned (RecordK);


CREATE TABLE application.TBadge (
    BadgeK BIGSERIAL PRIMARY KEY
   ,CreatedD TIMESTAMP DEFAULT NOW()
   ,FName VARCHAR(200)
   ,FDescription VARCHAR(500)
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,FInteger0 BIGINT
);
CREATE INDEX I_TBadge_FName ON application.TBadge (FName);

CREATE TABLE application.TAddress (
   AddressK BIGSERIAL PRIMARY KEY
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT
   ,CountryC INT
   ,FZip VARCHAR(100)
   ,FState VARCHAR(100)
   ,FCity VARCHAR(100)
   ,FCounty VARCHAR(100)
   ,FAddress VARCHAR(100)
   ,FAddress2 VARCHAR(100)
   ,FAddress3 VARCHAR(100)
   ,FDescription VARCHAR(1000)
   ,FDeleted SMALLINT DEFAULT 0
);
CREATE INDEX C_TAddress_ParentK  ON application.TAddress (ParentK);

CREATE TABLE application.TNumber (
   NumberK BIGSERIAL PRIMARY KEY
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT
   ,CountryC INT
   ,PriorityC INT
   ,FHead VARCHAR(100)
   ,FNumber VARCHAR(1000)
   ,FTail VARCHAR(100)
   ,FDescription VARCHAR(1000)
   ,FDeleted SMALLINT DEFAULT 0
);
CREATE INDEX I_TNumber_ParentK ON application.TNumber (ParentK);

CREATE TABLE application.TLink (
   LinkK BIGSERIAL PRIMARY KEY
   ,SuperK BIGINT                                           -- owner TLink when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT DEFAULT 0
   ,DomainC INT DEFAULT 0
   ,FUrl VARCHAR(1000)
   ,FName VARCHAR(1000)
   ,FDescription VARCHAR(1000)
   ,FDeleted SMALLINT DEFAULT 0
);
CREATE INDEX I_TLink_ParentK ON application.TLink (ParentK);


CREATE TABLE application.TNote (
   NoteK BIGSERIAL PRIMARY KEY
   ,SuperK BIGINT                                           -- owner TNote when used in hierarchical structure
   ,RecordK BIGINT                                          -- If note is used as one single text for another record
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,FormatS INT                                             -- format for note
   ,TypeC INT
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,FTimeD TIMESTAMP
   ,FNote TEXT
);
CREATE INDEX I_TNote_ParentK  ON application.TNote (ParentK);
CREATE INDEX I_TNote_RecordK ON application.TNote (RecordK);


CREATE TABLE application.TDocument (
   DocumentK BIGSERIAL PRIMARY KEY
   ,SuperK BIGINT                                           -- owner TDocument when used in hierarchical structure
   ,RecordK BIGINT                                          -- If document is used as one single text for another record
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,MimeTypeS INT                                           -- Mime type for document
   ,MimeName VARCHAR(250)
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,FTimeD TIMESTAMP
   ,FName VARCHAR(250)
   ,FFolder VARCHAR(250)
   ,FDescription VARCHAR(1000)
   ,FData BYTEA
);
CREATE INDEX I_TDocument_ParentK ON application.TDocument (ParentK);
CREATE INDEX I_TDocument_UpdateD ON application.TDocument (UpdateD);
CREATE INDEX I_TDocument_RecordK ON application.TDocument (RecordK);

CREATE TABLE application.TImage (
   ImageK BIGSERIAL PRIMARY KEY
   ,SuperK BIGINT                                           -- owner TImage when used in hierarchical structure
   ,RecordK BIGINT                                          -- If image is used as one single text for another record
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,MimeTypeS INT                                           -- Mime type for document
   ,MimeName VARCHAR(250)
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT
   ,FTimeD TIMESTAMP
   ,FName VARCHAR(250)
   ,FFolder VARCHAR(250)
   ,FDescription VARCHAR(1000)
   ,FData BYTEA
   ,FHide SMALLINT DEFAULT 0
);
CREATE INDEX I_TImage_ParentK ON application.TImage (ParentK);
CREATE INDEX I_TImage_UpdateD ON application.TImage (UpdateD);
CREATE INDEX I_TImage_RecordK ON application.TImage (RecordK);


CREATE TABLE application.TPropertyName (
   PropertyNameK SERIAL PRIMARY KEY
   ,table_number INT          -- Table number for describing what table note belongs to
   ,FName VARCHAR(100)
   ,FDescription VARCHAR(1000)
   ,FTag VARCHAR(100)        -- free text field to do logic if properties should be grouped or some other type of separations
   ,FValid INT                -- Flags marking valid values, default is string, 0x01 = string, 0x02 integer, 0x04 = date, 0x08 = decimal
   ,FMultiple SMALLINT DEFAULT 0
);


CREATE TABLE application.TProperty (
   PropertyK BIGSERIAL PRIMARY KEY
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table property belongs to
   ,PropertyNameK INT
   ,FKey VARCHAR(100)
   ,FValue VARCHAR(1000)
   ,FValueText VARCHAR(1000)
   ,FValueInteger BIGINT
   ,FValueDate TIMESTAMP
   ,FValueDecimal FLOAT
   ,FIndex INT
   ,FValid INT                                              -- Flags marking valid values, default is string, 0x01 = string, 0x02 integer, 0x04 = date, 0x08 = decimal
   ,FSystem SMALLINT DEFAULT 0                              -- System property, used to create system logic
   ,CONSTRAINT FK_TProperty_PropertyNameK FOREIGN KEY (PropertyNameK) REFERENCES application.TPropertyName(PropertyNameK) ON DELETE CASCADE
);

CREATE INDEX I_TProperty_ParentK  ON application.TProperty (ParentK);



CREATE TABLE application.TSystem (
   SystemK SERIAL PRIMARY KEY
   ,GlobalK INT
   ,SuperK INT                                              -- owner TSystem when used in hierarchical structure
   ,UserK INT                                               -- responsible user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                                               -- Type of system, application dependent
   ,StateC INT                                              -- State system is in, application dependent
   ,PriorityC INT                                           -- Priority for system
   ,AreaC INT                                               -- area system  belongs to, could be areas in the organization
   ,FName VARCHAR(100)
   ,FAbbreviation VARCHAR(100)                              -- abbreviation for system, sometimes a short name is needed
   ,FDescription VARCHAR(1000) 
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TSystem_GlobalK FOREIGN KEY (GlobalK) REFERENCES application.TGlobal (GlobalK) ON DELETE CASCADE
);

CREATE INDEX I_TSystem_GlobalK  ON application.TSystem (GlobalK);


CREATE TABLE application.TSystemIntent (  
   SystemIntentK BIGSERIAL PRIMARY KEY
   ,SystemK INT NOT NULL
   ,UserK INT                                               -- responsible user
   ,SuperK INT                                              -- owner TSystemIntent when used in hierarchical structure
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT DEFAULT 0                                     -- Type of request, e.g. feature, issue 
   ,StateC INT DEFAULT 0                                    -- Request status, e.g. open, closed, pending, active ...
   ,DifficultyC INT DEFAULT 0
   ,PriorityC INT DEFAULT 0
   ,FBrief VARCHAR(200)
   ,FWriter VARCHAR(200)                                    -- free text description for person that is author to request
   ,FText TEXT                                              -- description of what is requested
   ,FComment VARCHAR(1000)                                  -- If there is some quick comment that is needed to remember or explain what this is about
   ,FBegin TIMESTAMP
   ,FEnd TIMESTAMP
   ,FDone SMALLINT DEFAULT 0                                -- Intent is ready
   ,FDeleted SMALLINT DEFAULT 0
   ,FLength FLOAT
   ,CONSTRAINT FK_TSystemIntent_SystemK FOREIGN KEY (SystemK) REFERENCES application.TSystem (SystemK) ON DELETE CASCADE 
);

CREATE INDEX I_TSystemIntent_SystemK ON application.TSystemIntent (SystemK);


CREATE TABLE application.TSystemRequest (
   SystemRequestK BIGSERIAL PRIMARY KEY
   ,SystemK INT NOT NULL
   ,UserK INT                                               -- responsible user
   ,CheckedByK INT                                          -- user that has checked response
   ,ContactK INT                                            -- contact this request is sent from
   ,SuperK INT                                              -- owner TSystemRequest when used in hierarchical structure
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                                               -- Type of request, e.g. feature, issue 
   ,StateC INT DEFAULT 0                                    -- Request status, e.g. open, closed, pending, active ...
   ,SourceC INT                                             -- Where request is coming from
   ,DifficultyC INT
   ,PriorityC INT
   ,ContextC INT                                            -- In what context request is for
   ,FBrief VARCHAR(200)
   ,FWriter VARCHAR(200)                                    -- free text description for person that is author to request
   ,FWriterAddress VARCHAR(260)                             -- free text where writer that isn't a user in database can write how to be contacted
   ,FText TEXT                                              -- description of what is requested
   ,FComment VARCHAR(1000)                                  -- If there is some quick comment that is needed to remember or explain what this is about
   ,FBegin TIMESTAMP
   ,FEnd TIMESTAMP
   ,FChecked TIMESTAMP                                      -- Date when request was checked
   ,FDoneD TIMESTAMP                                       -- Date when request was set as done
   ,FWaiting SMALLINT  DEFAULT 0                            -- Request is waiting
   ,FDone SMALLINT  DEFAULT 0                               -- Request is ready
   ,FDeleted SMALLINT DEFAULT 0                             -- Request is deleted
   ,CONSTRAINT FK_TSystemRequest_SystemK FOREIGN KEY (SystemK) REFERENCES application.TSystem(SystemK) ON DELETE CASCADE 
);

CREATE INDEX I_TSystemRequest_SystemK ON application.TSystemRequest (SystemK);
CREATE INDEX I_TSystemRequest_TypeC  ON application.TSystemRequest (TypeC);
CREATE INDEX I_TSystemRequest_CreateD  ON application.TSystemRequest (CreateD);

PRINT('CREATE TABLE TSystemField. Divide system in parts, can be used to group version information'); CREATE TABLE application.TSystemField (
   SystemFieldK BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,SystemK INT NOT NULL
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,PriorityC INT  DEFAULT 0                                -- Field priority
   ,FName VARCHAR(200)                                     -- Name for field
   ,FDescription VARCHAR(1000)                              -- Describe field
   ,FDeleted SMALLINT DEFAULT 0 
   ,CONSTRAINT FK_TSystemField_SystemK FOREIGN KEY (SystemK) REFERENCES application.TSystem(SystemK) ON DELETE CASCADE
);

CREATE CLUSTERED INDEX I_TSystemField_SystemK  ON application.TSystemField (SystemK);


CREATE TABLE application.TSystemVersion (
   SystemVersionK BIGSERIAL PRIMARY KEY
   ,SystemK INT NOT NULL
   ,UserK INT                                               -- responsible user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,OverallCounter BIGINT,                                  -- internal counter for all versions, could be used for sorting
   ,SystemCounter BIGINT,                                   -- internal counter for system versions, may be used for sorting
   ,TypeC INT                                               -- Type of system version
   ,StateC INT                                              -- Version state
   ,TargetC INT                                             -- If version is for a aimed at target group
   ,FormC INT                                               -- In what form this version is, like developer version, customer version or something else
   ,FReleaseDate TIMESTAMP                                  -- Planed release date
   ,FReleasedDate TIMESTAMP                                 -- Actual release date
   ,FVersion1 INT                                           -- Major
   ,FVersion2 INT                                           -- Minor
   ,FVersion3 INT                                           -- Patch
   ,FBuild INT                                              -- Build number if used as version
   ,FIndex INT                                              -- Index if some sort of custom ordering is needed
   ,FName VARCHAR(200)                                      -- Simple version name
   ,FSearchName VARCHAR(200)                                -- Name to simplify searches for this version
   ,FNameInternal VARCHAR(200)                              -- Internal name
   ,FDescription VARCHAR(1000)
   ,FTested SMALLINT DEFAULT 0
   ,FReleased SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TSystemVersion_SystemK FOREIGN KEY (SystemK) REFERENCES application.TSystem(SystemK) ON DELETE CASCADE
);

CREATE INDEX I_TSystemVersion_SystemK ON application.TSystemVersion (SystemK);
CREATE INDEX I_TSystemVersion_UserK ON application.TSystemVersion (UserK);
CREATE INDEX I_TSystemVersion_FReleaseDate ON application.TSystemVersion (FReleaseDate);
CREATE INDEX I_TSystemVersion_OverallCounter ON application.TSystemVersion (OverallCounter);
CREATE INDEX I_TSystemVersion_SystemCounter ON application.TSystemVersion (SystemCounter);

CREATE TABLE application.TTagName (
   TagNameK SERIAL PRIMARY KEY
   ,table_number INT          -- Table number for describing what table note belongs to
   ,FName NVARCHAR(200)
   ,FDescription NVARCHAR(1000)
);

CREATE TABLE application.TTag (
   TagK BIGSERIAL PRIMARY KEY
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table Tag belongs to
   ,TagNameK INT
   ,FDate TIMESTAMP
   ,CONSTRAINT FK_TTag_TagNameK FOREIGN KEY (TagNameK) REFERENCES application.TTagName(TagNameK) ON DELETE CASCADE
);

CREATE INDEX I_TTag_ParentK  ON application.TTag (ParentK);


CREATE TABLE application.TCustomer (
   CustomerK SERIAL PRIMARY KEY
   ,GlobalK INT
   ,SuperK INT                                              -- owner TCustomer when used in hierarchical structure
   ,UserK INT
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT
   ,CategoryC INT
   ,BusinessC INT 
   ,CountryC INT                                            -- country
   ,SourceC INT                                             -- from where customer was collected
   ,PriorityC INT                                           -- priority for customer
   ,FName VARCHAR(100)
   ,FSimple VARCHAR(100)                                    -- simple name for customer
   ,FDepartment VARCHAR(100)
   ,FOrganisation VARCHAR(100)                              -- organization number ?
   ,FText0 VARCHAR(100)
   ,FText1 VARCHAR(100)
   ,FText2 VARCHAR(100)
   ,FInteger0 BIGINT
   ,FInteger1 BIGINT
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE INDEX I_TCustomer_GlobalK  ON application.TCustomer (GlobalK);

CREATE TABLE application.TCustomerContact (
   CustomerContactK BIGSERIAL PRIMARY KEY
   ,CustomerK INT
   ,UserK INT                                               -- If contact is also user in changelog system
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT
   ,CategoryC INT
   ,BusinessC INT
   ,CountryC INT
   ,FName VARCHAR(100)
   ,FFirstName VARCHAR(100)
   ,FLastName VARCHAR(100)
   ,FTitle VARCHAR(100)
   ,FDepartment VARCHAR(100)
   ,FPhone VARCHAR(100)
   ,FMobile VARCHAR(100)
   ,FMail VARCHAR(100)
   ,FGender INT
   ,FBirthYear INT
   ,FBirthMonth INT
   ,FBirthDay INT
   ,FText0 VARCHAR(100)
   ,FText1 VARCHAR(100)
   ,FInteger0 BIGINT
   ,FInteger1 BIGINT
   ,FRetired SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TCustomerContact_CustomerK FOREIGN KEY (CustomerK) REFERENCES application.TCustomer(CustomerK) ON DELETE CASCADE
);

CREATE INDEX I_TCustomerContact_CustomerK ON application.TCustomerContact (CustomerK);
CREATE INDEX I_TCustomerContact_FName  ON application.TCustomerContact (FName);


CREATE TABLE application.TCustomerSubscription (
   TCustomerSubscriptionK INT NOT NULL
   ,CustomerK INT
   ,CustomerContactK BIGINT
   ,UserK INT                                               -- If contact is also user in changelog system
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT
   ,FStartD TIMESTAMP
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE INDEX I_TCustomerSubscription_CustomerK ON application.TCustomerSubscription (CustomerK);



CREATE TABLE application.TLog (
   LogK BIGSERIAL PRIMARY KEY
   ,CustomerK INT                                           -- connection to customer
   ,SystemVersionK INT                                      -- connection to version
   ,UserK INT
   ,CreateD TIMESTAMP
   ,FormatS INT                                             -- description format
   ,ColorS INT                                              -- for color coding
   ,TypeC INT                                               -- type of log
   ,TargetC INT                                             -- If change is for some specific target group
   ,ImpactC INT                                             -- Type of impact change has on system
   ,FTimeD TIMESTAMP
   ,FBrief VARCHAR(200)
   ,FDescription VARCHAR(2000)
   ,CONSTRAINT FK_TLog_SystemVersionK FOREIGN KEY (SystemVersionK) REFERENCES application.TSystemVersion(SystemVersionK) ON DELETE CASCADE
);
CREATE INDEX I_TLog_SystemVersionK  ON application.TLog (SystemVersionK);
CREATE INDEX I_TLog_CustomerK ON application.TLog (CustomerK);




CREATE TABLE application.TActivity (
   ActivityK BIGSERIAL PRIMARY KEY
   ,SuperK BIGINT                                           -- owner TActivity when used in hierarchical structure
   ,ParentK BIGINT NOT NULL
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,UserK INT                                               -- responsible user
   ,User2K INT                                              -- owner user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,ColorS INT                                              -- for color coding
   ,AliveS INT                                              -- active, closed, deleted
   ,TypeC INT                                               -- type code
   ,PriorityC INT                                           -- priority code
   ,StateC INT                                              -- activity state code
   ,ServiceC INT                                            -- used for mark if activity is some sort of service, like consultation and can be used to calculate price
   ,AreaC INT                                               -- area where activity belongs to, could be e.g. sales, development, administration
   ,FormC INT                                               -- form (format) could be code language if programming task
   ,LevelC INT                                              -- level (difficulty) for activity, useful when activity has a lot of text. 
   ,ContextC INT                                            -- In what context this activity is for
   ,ReportC INT                                             -- if activity is used in some type of reporting, could be used as who gets the report
   ,FDescription VARCHAR(1000)
   ,FBeginD TIMESTAMP                                       -- activity start
   ,FEndD TIMESTAMP                                         -- activity end
   ,FAlertD TIMESTAMP                                       -- alert time
   ,FDeadlineD TIMESTAMP                                    -- deadline time
   ,FDoneD TIMESTAMP
   ,FTimeSpent FLOAT                                        -- time spent on activity
   ,FTimeEstimated FLOAT                                    -- estimated time
   ,FTimeActual FLOAT                                       -- actual time spent
   ,FAmount FLOAT
   ,FFromUser INT                                           -- if user sent activity to another user
   ,FToUser INT                                             -- to user if activity was sent (like mail)
   ,FSort INT                                               -- Helper field that could be use for custom sorting
   ,FDone SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE INDEX I_TActivity_ParentK  ON application.TActivity (ParentK);
CREATE INDEX I_TActivity_UserK  ON application.TActivity (UserK);
CREATE INDEX I_TActivity_TypeC  ON application.TActivity (TypeC);
CREATE INDEX I_TActivity_StateC  ON application.TActivity (StateC);
CREATE INDEX I_TActivity_FBeginD  ON application.TActivity (FBeginD);


CREATE TABLE application.TActivityRemark (
   ActivityRemarkK BIGSERIAL PRIMARY KEY
   ,ActivityK BIGINT NOT NULL
   ,UserK INT                                               -- user writing remark
   ,UpdateD TIMESTAMP NOT NULL
   ,TypeC INT                                               -- Type of activity remark
   ,FRemark VARCHAR(2000)
   ,CONSTRAINT FK_TActivityRemark_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TActivityRemark_ActivityK ON application.TActivityRemark (ActivityK);

CREATE TABLE application.TActivityParticipant (
   ActivityParticipantK BIGSERIAL PRIMARY KEY
   ,ActivityK BIGINT NOT NULL
   ,table_number INT NOT NULL                               -- Table number describing the key to participant 
   ,ParticipantK INT NOT NULL                               -- Key to record in table for the participant (TUser or TCustomerContact)
   ,CreateD TIMESTAMP NOT NULL
   ,TypeC INT
   ,CONSTRAINT FK_TActivityParticipant_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TActivityParticipant_ActivityK ON application.TActivityParticipant (ActivityK);


CREATE TABLE application.TArticleBook (
   ArticleBookK BIGSERIAL PRIMARY KEY
   ,UserK INT
   ,SuperK INT                -- owner TArticleBook when used in hierarchical structure
   ,ParentK INT 
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                 -- Book type
   ,StateC INT                -- Book state
   ,LanguageC INT             -- Language article is in
   ,LevelC INT                -- Language article is in
   ,FName VARCHAR(500)        -- Book name
   ,FSearchName VARCHAR(200)
   ,FHeader VARCHAR(200)
   ,FReleased TIMESTAMP
   ,FReady SMALLINT DEFAULT 0      -- book is ready (can be used to get valid book connecting articles)
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0    -- If book i deleted, like old
   ,FCount1 BIGINT            -- General count field
   ,FCount2 BIGINT            -- General count field
);
CREATE INDEX I_TArticleBook_ParentK  ON application.TArticleBook (ParentK);

CREATE TABLE application.TArticleBookList (
   ArticleBookListK INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
   ,UserK INT
   ,SuperK INT                -- owner TArticleBook when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                 -- List type
   ,StateC INT                -- List state
   ,FName VARCHAR(500)        -- List name
   ,FSearchName VARCHAR(200)
   ,FDescription VARCHAR(1000)
   ,FReleased TIMESTAMP
   ,FReady SMALLINT DEFAULT 0 -- book list is ready 
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0    -- If book list i deleted, like old
);

CREATE INDEX I_TArticleBookList_ParentK  ON application.TArticleBookList (ParentK);



CREATE TABLE application.TArticleChapter (
   ArticleChapterK BIGSERIAL PRIMARY KEY
   ,ArticleBookK INT
   ,UserK INT
   ,SuperK INT                -- owner TArticleBook when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                 -- Book type
   ,StateC INT                -- Book state
   ,LanguageC INT             -- Language article is in
   ,FName VARCHAR(500)       -- Book name
   ,FHeader VARCHAR(200)
   ,FText TEXT               -- Chapter text
   ,FHelp VARCHAR(1000)      -- Text field that may be used for specific UI and informing on how control the navigation
   ,FReleased TIMESTAMP
   ,FReady BIT DEFAULT 0      -- book is ready (can be used to get valid book connecting articles)
   ,FDepreciated BIT DEFAULT 0
   ,FDeleted BIT DEFAULT 0    -- If book i deleted, like old
   ,CONSTRAINT FK_TArticleChapter_ArticleBookK FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
);

CREATE INDEX I_TArticleChapter_ArticleBookK  ON application.TArticleChapter (ArticleBookK);





CREATE TABLE application.TArticlePresentation (
   ArticlePresentationK SERIAL PRIMARY KEY
   ,UserK INT
   ,SuperK INT                -- owner TArticleBook when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                 -- Presentation type
   ,StateC INT                -- Presentation state
   ,FName VARCHAR(500)        -- Presentation name
   ,FSearchName VARCHAR(200)
   ,FDescription VARCHAR(1000)
   ,FReleasedD TIMESTAMP
   ,FReady SMALLINT DEFAULT 0 -- Presentation is ready
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0 -- If book i deleted, like old
);

CREATE INDEX I_TArticlePresentation_ParentK  ON application.TArticlePresentation (ParentK);


CREATE TABLE application.TArticle (
   ArticleK BIGSERIAL PRIMARY KEY
   ,ArticleBookK INT
   ,UserK INT
   ,SuperK INT                -- owner TArticle when used in hierarchical structure
   ,ParentK INT
   ,table_number INT          -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,Thread INT                -- used to group articles in one single thread, ArticleK for first article in thread will be the thread id
   ,ScopeS INT                -- Scope is like a level indicator for whom this article is for. Could be technical, for tutorial or some other type of level
   ,LevelC INT
   ,TypeC INT
   ,StateC INT
   ,LanguageC INT             -- Language article is in
   ,TargetC INT               -- to whom the article is target at
   ,ConnectionC INT NOT NULL DEFAULT 0-- How article connects/relates to book it  belongs to
   ,FBrief VARCHAR(500)       -- Short explanation what is in the article
   ,FHeader VARCHAR(500)      -- Header
   ,FSearchText VARCHAR(200)  -- Text for making it simpler to search article
   ,FText TEXT                -- bulk text for article
   ,FChapterName VARCHAR(200)
   ,FChapter INT              -- divide in chapters, may be used for ordering
   ,FPage INT                 -- If article is like a book or series this can be used to set the page for ordering
   ,FValidFrom TIMESTAMP
   ,FValidTo TIMESTAMP
   ,FSticky SMALLINT DEFAULT 0-- If article should be "lifted" for the reader based in context article has.
   ,FExtra SMALLINT DEFAULT 0 -- Extra stuff, not that important to the context  article has information about
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TArticle_ArticleBookK FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
);

CREATE INDEX IC_TArticle_ParentK  ON application.TArticle (ParentK);
CREATE INDEX I_TArticle_ArticleBookK  ON application.TArticle (ArticleBookK);


CREATE TABLE application.TProject (
   ProjectK BIGSERIAL PRIMARY KEY
   ,GlobalK INT
   ,SuperK BIGINT                                           -- owner TProject when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,UserK INT                                               -- responsible user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                                               -- Type of project
   ,StateC INT                                              -- Some sort of project status
   ,AreaC INT                                               -- area where project belongs to, could be e.g. sales, development, administration
   ,FName VARCHAR(500)
   ,FDescription VARCHAR(1000)
   ,FText0 VARCHAR(100)
   ,FText1 VARCHAR(100)
   ,FBeginD TIMESTAMP                                        -- project start
   ,FEndD TIMESTAMP                                          -- project end
   ,FDeadlineD TIMESTAMP                                     -- deadline time
   ,FTodo SMALLINT  DEFAULT 0
   ,FDone SMALLINT  DEFAULT 0                                    -- Project is ready
   ,FPrivate SMALLINT DEFAULT 0                                  -- Mark project as private, only those related can  view it
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE INDEX I_TProject_ParentK ON application.TProject (ParentK);
CREATE INDEX I_TProject_GlobalK ON application.TProject (GlobalK);
CREATE INDEX I_TProject_FStartD ON application.TProject (FBeginD);
CREATE INDEX I_TProject_StateC ON application.TProject (StateC);

CREATE TABLE application.TProjectPhase (
   ProjectPhaseK BIGSERIAL PRIMARY KEY
   ,ProjectK BIGINT
   ,UserK INT                                               -- responsible user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,FName VARCHAR(500)
   ,FDescription VARCHAR(1000)
   ,TypeC INT                                               -- Type of project
   ,StateC INT                                              -- Some sort of project status
   ,PriorityC INT                                           -- Some sort of project status
   ,FBeginD TIMESTAMP                                       -- Phase start
   ,FEndD TIMESTAMP                                         -- Phase end
   ,FExactBeginD TIMESTAMP                                  -- phase real start
   ,FExactEndD TIMESTAMP                                    -- phase real end
   ,FDone SMALLINT  DEFAULT 0                               -- phase is ready
   ,FActive SMALLINT DEFAULT 0
   ,FDepreciated SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TProjectPhase_ProjectK FOREIGN KEY (ProjectK) REFERENCES application.TProject (ProjectK) ON DELETE CASCADE 
);

CREATE INDEX I_TProjectPhase_ProjectK ON application.TProjectPhase (ProjectK);
CREATE INDEX I_TProjectPhase_FBeginD ON application.TProjectPhase (FBeginD);

 CREATE TABLE application.TBundle (
   BundleK BIGSERIAL PRIMARY KEY
   ,SuperK BIGINT                                           -- owner Bundle when used in hierarchical structure
   ,RecordK BIGINT                                          -- If Bundle is used as one single item for another record
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,FId VARCHAR(50)
   ,FName VARCHAR(500)
   ,FBegin TIMESTAMP
   ,FEnd TIMESTAMP
   ,FLength BIGINT
   ,FValue FLOAT
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE INDEX I_TBundle_RecordK ON application.TBundle (RecordK);
CREATE INDEX I_TBundle_ParentK ON application.TBundle (ParentK);


 CREATE TABLE application.TCost (
   CostK BIGSERIAL PRIMARY KEY
   ,GlobalK INT
   ,CustomerK INT                                           -- connection to customer
   ,SystemK INT                                             -- connection to system
   ,SuperK BIGINT                                           -- owner Cost when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,UserK INT                                               -- responsible user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeK INT                                               -- Type of Cost
   ,StatusK INT                                             -- Some sort of Cost status
   ,AreaC INT                                               -- area where Cost belongs to, could be e.g. Costs, development, administration
   ,ProbabilityC INT                                        --
   ,ReasonC INT
   ,CurrencyC INT
   ,FName VARCHAR(500)
   ,FInvoice VARCHAR(100)
   ,FAmount FLOAT
   ,FAmountPaid FLOAT
   ,FTax FLOAT
   ,FBegin TIMESTAMP
   ,FEnd TIMESTAMP
   ,FDone SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE INDEX I_TCost_CustomerK  ON application.TCost (CustomerK);
CREATE INDEX I_TCost_FBegin  ON application.TCost (FBegin);
CREATE INDEX I_TCost_GlobalK  ON application.TCost (GlobalK);
CREATE INDEX I_TCost_SystemK  ON application.TCost (SystemK);
CREATE INDEX I_TCost_UserK  ON application.TCost (UserK);



CREATE TABLE application.TSale (
   SaleK BIGSERIAL PRIMARY KEY
   ,GlobalK INT
   ,CustomerK INT                                           -- connection to customer
   ,SystemK INT                                             -- connection to system
   ,SuperK BIGINT                                           -- owner Sale when used in hierarchical structure
   ,ParentK BIGINT 
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,UserK INT                                               -- responsible user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,StateS INT                                              -- system state settings for sale
   ,TypeK INT                                               -- Type of sale
   ,StatusK INT                                             -- Some sort of sale status
   ,AreaC INT                                               -- area where sale belongs to, could be e.g. sales, development, administration
   ,ProbabilityC INT                                        -- probability type, could be used with code number to calculate estimated earnings
   ,SourceC INT
   ,ReasonC INT
   ,StalledC INT
   ,CurrencyC INT
   ,FName VARCHAR(500)
   ,FInvoice VARCHAR(100)
   ,FAmount FLOAT
   ,FAmountPaid FLOAT
   ,FTax FLOAT
   ,FEarning FLOAT
   ,FQuantity INT 
   ,FBegin TIMESTAMP
   ,FEnd TIMESTAMP
   ,FOrderDate TIMESTAMP
   ,FDeliverDate TIMESTAMP
   ,FPayDate TIMESTAMP
   ,FDone SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
);

CREATE INDEX I_TSale_CustomerK  ON application.TSale (CustomerK);
CREATE INDEX I_TSale_GlobalK  ON application.TSale (GlobalK);
CREATE INDEX I_TSale_SystemK  ON application.TSale (SystemK);
CREATE INDEX I_TSale_UserK  ON application.TSale (UserK);
CREATE INDEX I_TSale_FBegin  ON application.TSale (FBegin);


-- DROP TABLE IF EXISTS application.TSaleService CASCADE;
CREATE TABLE application.TSaleService (
    SaleServiceK BIGSERIAL PRIMARY KEY
   ,SaleK BIGINT 
   ,CustomerK INT                                           -- connection to customer
   ,ActivityK BIGINT                                        -- if based on activity
   ,UserK INT                                               -- responsible user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                                               -- Type of sale
   ,RateC INT                                               -- rate for price like 100 / hour, fixed, free
   ,FUnitPrice FLOAT                                        -- price per unit (hour ?)
   ,FAmount FLOAT
   ,FTimeSpent FLOAT
   ,FTimeCharge FLOAT                                       -- Time that is chargeable
   ,FBeginD TIMESTAMP                                       -- activity start
   ,FEndD TIMESTAMP                                         -- activity end
   ,FDescription VARCHAR(1000)
   ,CONSTRAINT FK_TSaleService_SaleK FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE 
);

CREATE INDEX I_TSaleService_SaleK  ON application.TSaleService (SaleK);
CREATE INDEX I_TSaleService_CustomerK  ON application.TSaleService (CustomerK);
CREATE INDEX I_TSaleService_ActivityK  ON application.TSaleService (ActivityK);
CREATE INDEX I_TSaleService_UserK  ON application.TSaleService (UserK);
CREATE INDEX I_TSaleService_TypeC  ON application.TSaleService (TypeC);
CREATE INDEX I_TSaleService_FBeginD  ON application.TSaleService (FBeginD);

CREATE TABLE application.TSaleContinuation (
    SaleContinuationK BIGSERIAL PRIMARY KEY
   ,SaleK BIGINT 
   ,SuperK BIGINT                                           -- owner continuation if there is a newer
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,date_span SMALLINT                                      -- length type
   ,TypeC INT                                               -- Type of continuation
   ,LengthC INT                                             -- Type of length that continuation has
   ,FAmount FLOAT
   ,FRebate FLOAT
   ,FLength INT
   ,FCancelLength INT
   ,FBeginD TIMESTAMP                                       -- continuation start
   ,FEndD TIMESTAMP                                         -- continuation end
   ,FCount INT                                              -- if there license is for multiple 
   ,FUsedCount INT                                          -- used licenses if there is some sort of count down
   ,FLicenseKey VARCHAR(1000)                               -- if continuation has some sort of license key
   ,FDescription VARCHAR(1000)
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TSaleContinuation_SaleK FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
);

CREATE INDEX I_TSaleContinuation_SaleK  ON application.TSaleContinuation (SaleK);


CREATE TABLE application.TTodoList (
   TodoListK BIGSERIAL PRIMARY KEY
   ,UserK INT                                               -- responsible user
   ,ParentK INT
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                                               -- Type of project
   ,ContextC INT                                            -- In what context this todo list is for
   ,FName VARCHAR(1000)
   ,FDescription VARCHAR(2000)
   ,FDeadline TIMESTAMP
   ,FReadyD TIMESTAMP
   ,FClosedD TIMESTAMP
   ,FAlertD TIMESTAMP
   ,FReady SMALLINT DEFAULT 0
   ,FClosed SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
);
CREATE INDEX I_TTodoList_ParentK ON application.TTodoList (ParentK);
CREATE INDEX I_TTodoList_FReady ON application.TTodoList (FReady);


CREATE TABLE application.TTodo (
   TodoK BIGSERIAL PRIMARY KEY
   ,TodoListK BIGINT 
   ,UserK INT                                               -- responsible user
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,TypeC INT                                               -- Type of project
   ,StateC INT                                              -- Some sort of todo status
   ,FDescription VARCHAR(2000)
   ,FDeadline TIMESTAMP
   ,FReadyD TIMESTAMP
   ,FClosedD TIMESTAMP
   ,FAlertD TIMESTAMP
   ,FIdle SMALLINT DEFAULT 0
   ,FReady SMALLINT DEFAULT 0
   ,FClosed SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TTodo_TodoListK FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE 
);
CREATE INDEX I_TTodo_TTodoListK ON application.TTodo (TodoListK);

CREATE TABLE application.TrXBadge (
   rXBadgeK BIGSERIAL PRIMARY KEY
   ,ParentK BIGINT
   ,table_number INT                                        -- Table number for table hashtags relation belongs to
   ,BadgeK BIGINT
   ,CreateD TIMESTAMP DEFAULT NOW()
   ,CONSTRAINT FK_TrXBadge_BadgeK FOREIGN KEY (BadgeK) REFERENCES application.TBadge(BadgeK) ON DELETE CASCADE
);
CREATE INDEX I_TrXBadge_ParentK ON application.TrXBadge (ParentK);
CREATE INDEX I_TrXBadge_BadgeK ON application.TrXBadge (BadgeK);


CREATE TABLE application.TrTodoXUser (
   rTodoXUserK BIGSERIAL PRIMARY KEY
   ,TodoK BIGINT NOT NULL
   ,UserK INT NOT NULL
   ,CONSTRAINT FK_TrTodoXUser_TodoK FOREIGN KEY (TodoK) REFERENCES application.TTodo(TodoK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrTodoXUser_UserK FOREIGN KEY (UserK) REFERENCES application.TUser(UserK) ON DELETE CASCADE
);

CREATE INDEX I_TrTodoXUser_TodoK ON application.TrTodoXUser (TodoK);

CREATE TABLE application.TrLogXActivity (
   rLogXActivityK BIGSERIAL PRIMARY KEY
   ,LogK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,FSticky SMALLINT DEFAULT 0
   ,FMember SMALLINT DEFAULT 1
   ,CONSTRAINT FK_TrLogXActivity_LogK FOREIGN KEY (LogK) REFERENCES  application.TLog(LogK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrLogXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES  application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrLogXActivity_ActivityK ON  application.TrLogXActivity (ActivityK);


CREATE TABLE application.TrUserXCustomer (
   rUserXCustomerK SERIAL PRIMARY KEY
   ,UserK INT NOT NULL
   ,CustomerK INT NOT NULL
   ,RoleC INT
   ,CONSTRAINT FK_TrUserXCustomer_UserK FOREIGN KEY (UserK) REFERENCES  application.TUser(UserK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrUserXCustomer_CustomerK FOREIGN KEY (CustomerK) REFERENCES  application.TCustomer(CustomerK) ON DELETE CASCADE
);
CREATE INDEX I_TrUserXCustomer_CustomerK ON application.TrUserXCustomer (CustomerK);


CREATE TABLE application.TrUserXProject (
   rUserXProjectK BIGSERIAL PRIMARY KEY
   ,UserK INT NOT NULL
   ,ProjectK INT NOT NULL
   ,AuthorityS INT            -- rights for this user
   ,RoleC INT
   ,FSticky SMALLINT DEFAULT 0
   ,FMember SMALLINT DEFAULT 1
   ,CONSTRAINT FK_TrUserXProject_UserK FOREIGN KEY (UserK) REFERENCES  application.TUser(UserK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrUserXProject_ProjectK FOREIGN KEY (ProjectK) REFERENCES  application.TProject(ProjectK) ON DELETE CASCADE
);
CREATE INDEX I_TrUserXProject_ProjectK ON application.TrUserXProject (ProjectK);


CREATE TABLE application.TrSystemIntentXActivity (
   rSystemIntentXActivityK BIGSERIAL PRIMARY KEY
   ,SystemIntentK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT FK_TrSystemIntentXActivity_SystemIntentK FOREIGN KEY (SystemIntentK) REFERENCES application.TSystemIntent(SystemIntentK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSystemIntentXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrSystemIntentXActivity_SystemIntentK  ON application.TrSystemIntentXActivity (SystemIntentK);


CREATE TABLE application.TrSystemIntentXTodoList (
   rSystemIntentXTodoListK BIGSERIAL PRIMARY KEY
   ,SystemIntentK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT FK_TrSystemIntentXTodoList_SystemIntentK FOREIGN KEY (SystemIntentK) REFERENCES application.TSystemIntent(SystemIntentK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSystemIntentXTodoList_TodoListK FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE INDEX I_TrSystemIntentXTodoList_SystemIntentK  ON application.TrSystemIntentXTodoList (SystemIntentK);


CREATE TABLE application.TrSystemRequestXActivity (
   rSystemRequestXActivityK BIGSERIAL PRIMARY KEY
   ,SystemRequestK INT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT FK_TrSystemRequestXActivity_SystemRequestK FOREIGN KEY (SystemRequestK) REFERENCES application.TSystemRequest(SystemRequestK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSystemRequestXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrSystemRequestXActivity_SystemRequestK ON application.TrSystemRequestXActivity (SystemRequestK);


CREATE TABLE application.TrSystemRequestXTodoList (
   rSystemRequestXTodoListK BIGSERIAL PRIMARY KEY
   ,SystemRequestK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT FK_TrSystemRequestXTodoList_SystemRequestK FOREIGN KEY (SystemRequestK) REFERENCES application.TSystemRequest(SystemRequestK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSystemRequestXTodoList_TodoListK FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE INDEX I_TrSystemRequestXTodoList_SystemRequestK  ON application.TrSystemRequestXTodoList (SystemRequestK);


CREATE TABLE application.TrSystemVersionXArticle (
   rSystemVersionXArticleK BIGSERIAL PRIMARY KEY
   ,SystemVersionK INT NOT NULL
   ,ArticleK BIGINT NOT NULL
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,BondC INT DEFAULT 0                                     -- Describe the bond to between version and article
   ,FDescription VARCHAR(1000)
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TrSystemVersionXArticle_SystemVersionK FOREIGN KEY (SystemVersionK) REFERENCES application.TSystemVersion(SystemVersionK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSystemVersionXArticle_ArticleK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
);
CREATE INDEX I_TrSystemVersionXArticle_SystemVersionK ON application.TrSystemVersionXArticle (SystemVersionK);
CREATE INDEX I_TrSystemVersionXArticle_ArticleK ON application.TrSystemVersionXArticle (ArticleK);

CREATE TABLE application.TrSystemVersionXActivity (
   rSystemVersionXActivityK BIGSERIAL PRIMARY KEY
   ,SystemVersionK INT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,TargetC INT                                             -- If change is for some specific target group (same code as in TLog)
   ,ImpactC INT                                             -- Type of impact change has on system
   ,CONSTRAINT FK_TrSystemVersionXActivity_SystemVersionK FOREIGN KEY (SystemVersionK) REFERENCES application.TSystemVersion(SystemVersionK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSystemVersionXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrSystemVersionXActivity_SystemVersionK ON application.TrSystemVersionXActivity (SystemVersionK);

CREATE TABLE application.TrSystemVersionXProject (
   rSystemVersionXProjectK BIGSERIAL PRIMARY KEY
   ,SystemVersionK INT NOT NULL
   ,ProjectK BIGINT NOT NULL
   ,TargetC INT                                             -- If change is for some specific target group (same code as in TLog)
   ,ImpactC INT                                             -- Type of impact change has on system
   ,CONSTRAINT FK_TrSystemVersionXProject_SystemVersionK FOREIGN KEY (SystemVersionK) REFERENCES application.TSystemVersion(SystemVersionK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSystemVersionXProject_ProjectK FOREIGN KEY (ProjectK) REFERENCES application.TProject(ProjectK) ON DELETE CASCADE
);
CREATE INDEX I_TrSystemVersionXProject_SystemVersionK ON application.TrSystemVersionXProject (SystemVersionK);


CREATE TABLE application.TrProjectXActivity (
   rProjectXActivityK BIGSERIAL PRIMARY KEY
   ,ProjectK INT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT FK_TrProjectXActivity_ProjectK FOREIGN KEY (ProjectK) REFERENCES application.TProject(ProjectK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrProjectXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrProjectXActivity_ProjectK ON application.TrProjectXActivity (ProjectK);


CREATE TABLE application.TrProjectPhaseXActivity (
   rProjectPhaseXActivityK BIGSERIAL PRIMARY KEY
   ,ProjectPhaseK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,StateC INT                                              -- state settings for project manager about the activity
   ,ColorC INT                                              -- color code, can be used for anything
   ,FAlertD TIMESTAMP
   ,FDescription VARCHAR(1000)
   ,FOrder INT
   ,CONSTRAINT FK_TrProjectPhaseXActivity_ProjectPhaseK FOREIGN KEY (ProjectPhaseK) REFERENCES application.TProjectPhase(ProjectPhaseK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrProjectPhaseXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrProjectPhaseXActivity_ProjectPhaseK ON application.TrProjectPhaseXActivity (ProjectPhaseK);

CREATE TABLE application.TrProjectPhaseXTodoList (
   rProjectPhaseXTodoListK BIGSERIAL PRIMARY KEY
   ,ProjectPhaseK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT FK_TrProjectPhaseXTodoList_ProjectPhaseK FOREIGN KEY (ProjectPhaseK) REFERENCES application.TProjectPhase(ProjectPhaseK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrProjectPhaseXTodoList_TodoListK FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE INDEX I_TrProjectPhaseXTodoList_ProjectPhaseK ON application.TrProjectPhaseXTodoList (ProjectPhaseK);

TrActivityXBundle

CREATE TABLE application.TrActivityXBundle (
   rActivityXBundleK BIGSERIAL PRIMARY KEY
   ,ActivityK BIGINT NOT NULL
   ,BundleK BIGINT NOT NULL
   ,FDescription VARCHAR(1000)
   ,CONSTRAINT FK_TrActivityXBundle_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrActivityXBundle_BundleK FOREIGN KEY (BundleK) REFERENCES application.TBundle(BundleK) ON DELETE CASCADE
);
CREATE INDEX I_TrActivityXBundle_ActivityK  ON application.TrActivityXBundle (ActivityK);


CREATE TABLE application.TrActivityXCustomerContact (
   rActivityXCustomerContactK BIGSERIAL PRIMARY KEY
   ,ActivityK BIGINT NOT NULL
   ,CustomerContactK BIGINT NOT NULL
   ,RoleC INT                                               -- What type of role CustomerContact has for activity
   ,FDescription VARCHAR(1000)
   ,CONSTRAINT FK_TrActivityXCustomerContact_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrActivityXCustomerContact_CustomerContactK FOREIGN KEY (CustomerContactK) REFERENCES application.TCustomerContact(CustomerContactK) ON DELETE CASCADE
);
CREATE INDEX I_TrActivityXCustomerContact_ActivityK  ON application.TrActivityXCustomerContact (ActivityK);


CREATE TABLE application.TrActivityXTodoList (
   rActivityXTodoListK BIGSERIAL PRIMARY KEY
   ,ActivityK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT FK_TrActivityXTodoList_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrActivityXTodoList_TodoListK FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE INDEX I_TrActivityXTodoList_ActivityK  ON application.TrActivityXTodoList (ActivityK);


CREATE TABLE application.TrActivityXUser (
   rActivityXUserK BIGSERIAL PRIMARY KEY
   ,ActivityK BIGINT NOT NULL
   ,UserK INT NOT NULL
   ,RoleC INT                                               -- What type of role user has for activity
   ,FDescription VARCHAR(1000)
   ,CONSTRAINT FK_TrActivityXUser_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrActivityXUser_UserK FOREIGN KEY (UserK) REFERENCES application.TUser(UserK) ON DELETE CASCADE
);
CREATE INDEX I_TrActivityXUser_ActivityK  ON application.TrActivityXUser (ActivityK);


CREATE TABLE application.TrArticleXActivity (
   rArticleXActivityK BIGSERIAL PRIMARY KEY
   ,ArticleK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT FK_TrArticleXActivity_ArticleK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrArticleXActivity_ArticleK ON application.TrArticleXActivity (ArticleK);


CREATE TABLE application.TrArticleBookXArticle (
   rArticleBookXArticleK BIGSERIAL PRIMARY KEY
   ,ArticleBookK INT NOT NULL
   ,ArticleK BIGINT NOT NULL
   ,TypeC INT                                               -- Type of connection between article and book
   ,FPage INT
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleBookXArticle_ArticleBookK FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleBookXArticle_ActivityK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
);
CREATE INDEX I_TrArticleBookXArticle_ArticleBookK ON application.TrArticleBookXArticle (ArticleBookK);

CREATE TABLE application.TrArticleBookXArticleBookList (
   rArticleBookXArticleBookList BIGSERIAL PRIMARY KEY
   ,ArticleBookK BIGINT NOT NULL
   ,ArticleBookListK BIGINT NOT NULL
   ,TypeC INT                                               -- Type of connection between article and book
   ,FPage INT
   ,FOrder INT
   ,FDescription VARCHAR(1000)
   ,FHelp VARCHAR(1000)
   ,CONSTRAINT FK_TrArticleBookXArticleBookList_ArticleBookK FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleBookXArticleBookList_ArticleBookListK FOREIGN KEY (ArticleBookListK) REFERENCES application.TArticleBookList(ArticleBookListK) ON DELETE CASCADE
);
CREATE INDEX IC_rArticleBookXArticleBookList_ArticleBookK  ON application.TrArticleBookXArticleBookList (ArticleBookK);
CREATE INDEX I_rArticleBookXArticleBookList_ArticleBookListK  ON application.TrArticleBookXArticleBookList (ArticleBookListK);

CREATE TABLE application.TrArticleChapterXArticle (
   rArticleChapterXArticle BIGSERIAL PRIMARY KEY
   ,ArticleChapterK BIGINT NOT NULL
   ,ArticleK BIGINT NOT NULL
   ,TypeC INT                                               -- Type of connection between article and book
   ,FPage INT
   ,FOrder INT
   ,CONSTRAINT FK_TrArticleChapterXArticle_ArticleChapterK FOREIGN KEY (ArticleChapterK) REFERENCES application.TArticleChapter(ArticleChapterK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleChapterXArticle_ArticleK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
);
CREATE INDEX I_TrArticleChapterXArticle_ArticleChapterK  ON application.TrArticleChapterXArticle (ArticleChapterK);


CREATE TABLE application.TrArticleBookXActivity (
   rArticleBookXActivityK BIGSERIAL PRIMARY KEY
   ,ArticleBookK INT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT FK_TrArticleBookXActivity_ArticleBookK FOREIGN KEY (ArticleBookK) REFERENCES application.TArticleBook(ArticleBookK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticleBookXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrArticleBookXActivity_ArticleBookK ON application.TrArticleBookXActivity (ArticleBookK);

CREATE TABLE application.TrArticlePresentationXArticle (
   rArticlePresentationXArticleK BIGSERIAL PRIMARY KEY
   ,ArticlePresentationK INT NOT NULL
   ,ArticleK BIGINT
   ,UserK INT
   ,SuperK BIGINT                                           -- owner TrArticlePresentationXArticle when used in hierarchical structure
   ,TypeC INT                                               -- Type of connection between article and book
   ,TransitionC INT                                         -- If there are some effect when article is presented
   ,StyleC INT                                              -- Type of display style for article
   ,NameStyleC INT                                          -- Style for name if displayed in some form of presentation
   ,LevelC INT
   ,TargetC INT
   ,FName VARCHAR(500)                                      -- Name for "slide"
   ,FDevelop VARCHAR(100)                                   -- Text to use when creating slides, could be used to filter and configure. When ready it may be emptied
   ,FPage INT
   ,FOrder INT
   ,CONSTRAINT FK_TrArticlePresentationXArticle_ArticlePresentationK FOREIGN KEY (ArticlePresentationK) REFERENCES application.TArticlePresentation(ArticlePresentationK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrArticlePresentationXArticle_ArticleK FOREIGN KEY (ArticleK) REFERENCES application.TArticle(ArticleK) ON DELETE CASCADE
);
CREATE CLUSTERED INDEX I_TrArticlePresentationXArticle_ArticlePresentationK  ON application.TrArticlePresentationXArticle (ArticlePresentationK);



CREATE TABLE application.TrCustomerXActivity (
   rCustomerXActivityK BIGSERIAL PRIMARY KEY
   ,CustomerK INT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT FK_TrCustomerXActivity_CustomerK FOREIGN KEY (CustomerK) REFERENCES application.TCustomer(CustomerK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrCustomerXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrCustomerXActivity_CustomerK ON application.TrCustomerXActivity (CustomerK);


CREATE TABLE application.TrSaleXActivity (
   rSaleXActivityK BIGSERIAL PRIMARY KEY
   ,SaleK BIGINT NOT NULL
   ,ActivityK BIGINT NOT NULL
   ,CONSTRAINT FK_TrSaleXActivity_SaleK FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSaleXActivity_ActivityK FOREIGN KEY (ActivityK) REFERENCES application.TActivity(ActivityK) ON DELETE CASCADE
);
CREATE INDEX I_TrSaleXActivity_SaleK ON application.TrSaleXActivity (SaleK);

CREATE TABLE application.TrSaleXCustomerContact (
   rSaleXCustomerContactK BIGSERIAL PRIMARY KEY
   ,SaleK BIGINT NOT NULL
   ,CustomerContactK INT NOT NULL
   ,CreateD TIMESTAMP
   ,UpdateD TIMESTAMP
   ,RoleC INT                                               -- Type of connection between sale and customer contact
   ,FDescription VARCHAR(1000)                              -- Describe contact and how ot relates to sale
   ,CONSTRAINT FK_TrSaleXCustomerContact_SaleK FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSaleXCustomerContact_CustomerContactK FOREIGN KEY (CustomerContactK) REFERENCES application.TCustomerContact(CustomerContactK) ON DELETE CASCADE
);
CREATE INDEX I_TrSaleXCustomerContact_SaleK ON application.TrSaleXCustomerContact (SaleK);

CREATE TABLE application.TrSaleXProject (
   rSaleXProjectK BIGSERIAL PRIMARY KEY
   ,SaleK BIGINT NOT NULL
   ,ProjectK BIGINT NOT NULL
   ,CONSTRAINT FK_TrSaleXProject_SaleK FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSaleXProject_ProjectK FOREIGN KEY (ProjectK) REFERENCES application.TProject(ProjectK) ON DELETE CASCADE
);
CREATE INDEX I_TrSaleXProject_SaleK  ON application.TrSaleXProject (SaleK);
CREATE INDEX I_TrSaleXProject_ProjectK  ON application.TrSaleXProject (ProjectK);

CREATE TABLE application.TrSaleXSaleContinuation (
   rSaleXSaleContinuationK BIGSERIAL PRIMARY KEY
   ,SaleK BIGINT NOT NULL
   ,SaleContinuationK BIGINT NOT NULL
   ,CreateD TIMESTAMP
   ,FBeginD TIMESTAMP                                        -- continuation start
   ,FDescription VARCHAR(1000)                             -- Describe Continuation
   ,CONSTRAINT FK_TrSaleXSaleContinuation_SaleK FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSaleXSaleContinuation_SaleContinuationK FOREIGN KEY (SaleContinuationK) REFERENCES application.TSaleContinuation(SaleContinuationK) ON DELETE NO ACTION
);
CREATE INDEX I_TrSaleXSaleContinuation_SaleK  ON application.TrSaleXSaleContinuation (SaleK);


CREATE TABLE application.TrSaleXTodoList (
   rSaleXTodoListK BIGSERIAL PRIMARY KEY
   ,SaleK BIGINT NOT NULL
   ,TodoListK BIGINT NOT NULL
   ,CONSTRAINT FK_TrSaleXTodoList_SaleK FOREIGN KEY (SaleK) REFERENCES application.TSale(SaleK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSaleXTodoList_TodoListK FOREIGN KEY (TodoListK) REFERENCES application.TTodoList(TodoListK) ON DELETE CASCADE
);
CREATE INDEX I_TrSaleXTodoList_SaleK  ON application.TrSaleXTodoList (SaleK);


CREATE TABLE application.TrSystemXCustomer (
   rSystemXCustomerK BIGSERIAL PRIMARY KEY
   ,SystemK INT NOT NULL
   ,CustomerK INT NOT NULL
   ,CreateD TIMESTAMP
   ,TypeC INT                                               -- Type of connection between system and customer
   ,FDescription VARCHAR(1000)
   ,FBeginD TIMESTAMP                                       -- start
   ,FEndD TIMESTAMP                                         -- end
   ,CONSTRAINT FK_TrSystemXCustomer_SystemK FOREIGN KEY (SystemK) REFERENCES application.TSystem(SystemK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrSystemXCustomer_CustomerK FOREIGN KEY (CustomerK) REFERENCES application.TCustomer(CustomerK) ON DELETE CASCADE
);
CREATE INDEX I_TrSystemXCustomer_SystemK  ON application.TrSystemXCustomer (SystemK);
CREATE INDEX I_TrSystemXCustomer_CustomerK  ON application.TrSystemXCustomer (CustomerK);


CREATE TABLE application.TrUserGroupXUser (
   rUserGroupXUserK BIGSERIAL PRIMARY KEY
   ,UserGroupK INT NOT NULL
   ,UserK INT NOT NULL
   ,FIdle SMALLINT DEFAULT 0
   ,FDeleted SMALLINT DEFAULT 0
   ,CONSTRAINT FK_TrUserGroupXUser_UserGroupK FOREIGN KEY (UserGroupK) REFERENCES application.TUserGroup(UserGroupK) ON DELETE CASCADE
   ,CONSTRAINT FK_TrUserGroupXUser_UserK FOREIGN KEY (UserK) REFERENCES application.TUser(UserK) ON DELETE CASCADE
);
CREATE INDEX I_TrUserGroupXUser_UserGroupK ON application.TrUserGroupXUser (UserGroupK);

CREATE TABLE application.database (
   database_name VARCHAR(100)
   ,database_type VARCHAR(100)
);


CREATE TABLE application.version (
   major INT NOT NULL
   ,minor INT NOT NULL
   ,name VARCHAR(100)
);

CREATE TABLE application.row_state (
   state INT NOT NULL
   ,description VARCHAR(20)
);


CREATE TABLE application.table_number (
   number INT NOT NULL
   ,name VARCHAR(100)
);

CREATE TABLE application.thread_header (
   FThreadId BIGINT NOT NULL
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,FNextId INT NOT NULL DEFAULT 0
);
CREATE INDEX I_thread_header_FThreadId ON application.thread_header (FThreadId);


CREATE TABLE application.thread (
   FThreadId BIGINT NOT NULL
   ,table_number INT                                        -- Table number for describing what table note belongs to
   ,FKey BIGINT NOT NULL
   ,FDepth INT 
   ,FNext INT
   ,FPath VARCHAR(1024)
);




INSERT INTO  application.database VALUES ('PostgreSQL','psql');


INSERT INTO application.table_number
VALUES (1000,'TGlobal'),(1010,'TSystem'),(1020,'TUser'),(1030,'TCustomer'),(1040,'TContact'),
       (1050,'TProject'),(1060,'TSale'),(1061,'TSaleService'),(1062,'TSaleContinuation'),(1070,'TLog'),(1090,'TSystemVersion'),
       (1100,'TLink'),(1110,'TActivity'),(1120,'TDocument'),(1130,'TDetail'),(1140,'TNote'),
       (1150,'TSystemRequest'),(1160,'TArticle'),(1170,'TArticleBook'),(1180,'TActivityRemark'),
       (1190,'TActivityParticipant'), (1200,'TCustomerContact'),(1210,'TTodo'),(1220,'TTodoList'),
       (1230,'TArticlePresentation'),(1240,'TCost'),(1250,'TArticleChapter'),(1300,'TAddress'),(1310,'TNumber')
       (2000,'TrArticlePresentationXArticle');


/*
0x01 = something is turned on (true)
0x02 = something is turned off (false)
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
   ,(3 + 256 * 6,'dead');

CREATE TABLE application.date_span (
   ,span INT NOT NULL
   ,description VARCHAR(20)
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
CREATE TABLE application.click_counter (
   table_number INT NOT NULL
   ,FKey BIGINT NOT NULL
   ,FCounter BIGINT NOT NULL
   ,click_type SMALLINT
   ,set_id INT                                              -- id to query set used
);

CREATE INDEX IC_click_counter_FKey ON application.click_counter (FKey)

-- table used for calculating activity
CREATE TABLE application.click_history (
   table_number INT NOT NULL
   ,FKey BIGINT NOT NULL
   ,FWhen TIMESTAMP NOT NULL
   ,FFrom VARCHAR(100)
   ,click_type SMALLINT
   ,set_id INT                                              -- id to query set used
);

CREATE INDEX I_click_history_FKey ON application.click_history (FKey)

CREATE TABLE application.click_type (
   type SMALLINT NOT NULL
   ,description VARCHAR(32)
);

INSERT INTO application.click_type
VALUES 
   (1,'logon')
   ,(2,'result row')
   ,(3,'menu')
   ,(4,'text')
   ,(5,'url')

-- List of query set's used to work with changelog
CREATE TABLE application.query_set (
   id PRIMARY KEY
   ,name VARCHAR(100)
   ,description VARCHAR(200)
);


CREATE TABLE application.event_user (
   TypeNumber SMALLINT NOT NULL
   ,CreateD DATETIME DEFAULT DEFAULT NOW()
   ,FDescription VARCHAR(100)
   ,FIp VARCHAR(32)

);
CREATE CLUSTERED INDEX "application.IC_event_user" ON application.event_user (CreateD)



INSERT INTO application.version VALUES (1,0,'Create database');

INSERT INTO application.TGlobal VALUES(1,0,'Owner name','');

INSERT INTO application.TUser (UserK,GlobalK,CreateD,UpdateD,FLoginName,FDisplayName) VALUES(1,1,now(),now(),'user','user');
