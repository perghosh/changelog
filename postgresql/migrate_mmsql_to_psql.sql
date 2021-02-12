/*
   CODE
*/


-- code.TGroup
INSERT INTO changelog_psql.changelog_test.code.tgroup
(GroupK ,FName ,FDescription ,FLabel ,FTable)
SELECT GroupK ,FName ,FDescription ,FLabel ,FTable FROM changelog.code.TGroup

-- code.TBaseCode
INSERT INTO changelog_psql.changelog_test.code.tbasecode
(BaseCodeK,GroupK,CreatedD,UpdateD,FId,FName,FAbbreviation,FDescription,FRank,FIdle,FDeleted)
SELECT BaseCodeK,GroupK,CreatedD,UpdateD,FId,FName,FAbbreviation,FDescription,FRank,FIdle,FDeleted
FROM changelog.code.TBaseCode

-- code.TCode
INSERT INTO changelog_psql.changelog_test.code.tcode
(CodeK,GroupK,BaseCodeK,SuperK,CreatedD,UpdateD,FId,FName,FAbbreviation,FDescription,FRank,FIdle,FDeleted,FInteger0,FInteger1,FNumber0,FText0,FNotCompleted)
SELECT  CodeK,GroupK,BaseCodeK,SuperK,CreatedD,UpdateD,FId,FName,FAbbreviation,FDescription,FRank,FIdle,FDeleted,FInteger0,FInteger1,FNumber0,FText0,FNotCompleted
FROM changelog.code.TCode

-- code.thread_header
INSERT INTO changelog_psql.changelog_test.code.thread_header (FThreadId,FNextId)
SELECT FThreadId,FNextId FROM changelog.code.thread_header

-- code.thread_header
INSERT INTO changelog_psql.changelog_test.code.thread (FThreadId,FKey,FDepth,FNext,FPath)
SELECT FThreadId,FKey,FDepth,FNext,FPath FROM changelog.code.thread



/*
   APPLICATION
*/


-- TUserGroup
INSERT INTO changelog_psql.changelog_test.application.tusergroup (UserGroupK, AuthorityS, TypeC, FName, FDescription, FValidFromD, FValidToD, FIdle, FDeleted)
SELECT UserGroupK, AuthorityS, TypeC, FName, FDescription, FValidFromD, FValidToD, FIdle, FDeleted FROM application.TUserGroup;

-- TUser
INSERT INTO changelog_psql.changelog_test.application.tuser (UserK, GlobalK, CustomerK, CreateD, UpdateD, AuthorityS, RoleC, FAlias, FLoginName, FDisplayName, FFirstName, FLastName, FDescription, FMail, FMobile, FLoginD, FLoginCount, FIdle, FDeleted, FPassword, FProfile, FLastLoginD)
SELECT UserK, GlobalK, CustomerK, CreateD, UpdateD, AuthorityS, RoleC, FAlias, FLoginName, FDisplayName, FFirstName, FLastName, FDescription, FMail, FMobile, FLoginD, FLoginCount, FIdle, FDeleted, FPassword, FProfile, FLastLoginD FROM application.TUser;

-- TUserPinned
INSERT INTO changelog_psql.changelog_test.application.tuserpinned (UserPinnedK, UserK, table_number, RecordK, CreateD, TypeC, FDescription)
SELECT UserPinnedK, UserK, table_number, RecordK, CreateD, TypeC, FDescription FROM application.TUserPinned;


-- TSystem
INSERT INTO changelog_psql.changelog_test.application.tsystem (SystemK, GlobalK, SuperK, UserK, CreateD, UpdateD, TypeC, StateC, PriorityC, FName, FDescription, FIdle, FDeleted, AreaC, FAbbreviation)
SELECT SystemK, GlobalK, SuperK, UserK, CreateD, UpdateD, TypeC, StateC, PriorityC, FName, FDescription, FIdle, FDeleted, AreaC, FAbbreviation FROM application.TSystem;

-- TSystemRequest
INSERT INTO changelog_psql.changelog_test.application.tsystemrequest (SystemRequestK, SystemK, UserK, CheckedByK, ContactK, SuperK, CreateD, UpdateD, TypeC, StateC, SourceC, DifficultyC, PriorityC, FBrief, FWriter, FText, FComment, FBegin, FEnd, FChecked, FWaiting, FDone, FDeleted, FWriterAddress, FDoneD)
SELECT SystemRequestK, SystemK, UserK, CheckedByK, ContactK, SuperK, CreateD, UpdateD, TypeC, StateC, SourceC, DifficultyC, PriorityC, FBrief, FWriter, FText, FComment, FBegin, FEnd, FChecked, FWaiting, FDone, FDeleted, FWriterAddress, FDoneD FROM application.TSystemRequest;

INSERT INTO changelog_psql.changelog_test.application.tsystemversion (SystemVersionK, SystemK, UserK, CreateD, UpdateD, TypeC, StateC, FReleaseDate, FReleasedDate, FVersion1, FVersion2, FVersion3, FName, FSearchName, FNameInternal, FDescription, FTested, FReleased, FDeleted, FBuild, TargetC, FormC)
SELECT SystemVersionK, SystemK, UserK, CreateD, UpdateD, TypeC, StateC, FReleaseDate, FReleasedDate, FVersion1, FVersion2, FVersion3, FName, FSearchName, FNameInternal, FDescription, FTested, FReleased, FDeleted, FBuild, TargetC, FormC FROM application.TSystemVersion;


-- TCustomer
INSERT INTO changelog_psql.changelog_test.application.tcustomer (CustomerK, GlobalK, UserK, CreateD, UpdateD, TypeC, CategoryC, BusinessC, CountryC, FName, FDepartment, FDeleted)
SELECT CustomerK, GlobalK, UserK, CreateD, UpdateD, TypeC, CategoryC, BusinessC, CountryC, FName, FDepartment, FDeleted FROM application.TCustomer;

-- TCustomerContact
INSERT INTO changelog_psql.changelog_test.application.tcustomercontact (CustomerContactK, CustomerK, UserK, CreateD, UpdateD, TypeC, CategoryC, BusinessC, CountryC, FName, FFirstName, FLastName, FTitle, FDepartment, FPhone, FMobile, FMail, FGender, FBirthYear, FBirthMonth, FBirthDay, FText0, FText1, FInteger0, FInteger1, FRetired, FDeleted)
SELECT CustomerContactK, CustomerK, UserK, CreateD, UpdateD, TypeC, CategoryC, BusinessC, CountryC, FName, FFirstName, FLastName, FTitle, FDepartment, FPhone, FMobile, FMail, FGender, FBirthYear, FBirthMonth, FBirthDay, FText0, FText1, FInteger0, FInteger1, FRetired, FDeleted FROM application.TCustomerContact;



-- TActivity
INSERT INTO changelog_psql.changelog_test.application.tactivity (ActivityK, SuperK, ParentK, table_number, UserK, CreateD, UpdateD, ColorS, AliveS, TypeC, PriorityC, StateC, ServiceC, AreaC, FDescription, FBeginD, FEndD, FAlertD, FDeadlineD, FDoneD, FTimeSpent, FTimeEstimated, FTimeActual, FAmount, FDone, FDeleted, FormC, FFromUser, FToUser, LevelC, FSort)
SELECT ActivityK, SuperK, ParentK, table_number, UserK, CreateD, UpdateD, ColorS, AliveS, TypeC, PriorityC, StateC, ServiceC, AreaC, FDescription, FBeginD, FEndD, FAlertD, FDeadlineD, FDoneD, FTimeSpent, FTimeEstimated, FTimeActual, FAmount, FDone, FDeleted, FormC, FFromUser, FToUser, LevelC, FSort FROM application.TActivity;

-- TActivityPart
INSERT INTO changelog_psql.changelog_test.application.tactivityparticipant (ActivityParticipantK, ActivityK, table_number, ParticipantK, CreateD, TypeC)
SELECT ActivityParticipantK, ActivityK, table_number, ParticipantK, CreateD, TypeC FROM application.TActivityParticipant;

-- TActivityRemark
INSERT INTO changelog_psql.changelog_test.application.tactivityremark (ActivityRemarkK, ActivityK, UserK, UpdateD, TypeC, FRemark)
SELECT ActivityRemarkK, ActivityK, UserK, UpdateD, TypeC, FRemark FROM application.TActivityRemark;



-- TSale
INSERT INTO changelog_psql.changelog_test.application.tsale (SaleK, GlobalK, CustomerK, SystemK, SuperK, ParentK, table_number, UserK, CreateD, UpdateD, StateS, TypeC, StateC, AreaC, ProbabilityC, SourceC, ReasonC, StalledC, CurrencyC, FName, FAmount, FAmountPaid, FTax, FEarning, FQuantity, FBeginD, FEndD, FOrderD, FDeliverD, FPayD, FDone, FDeleted, FInvoice)
SELECT SaleK, GlobalK, CustomerK, SystemK, SuperK, ParentK, table_number, UserK, CreateD, UpdateD, StateS, TypeC, StateC, AreaC, ProbabilityC, SourceC, ReasonC, StalledC, CurrencyC, FName, FAmount, FAmountPaid, FTax, FEarning, FQuantity, FBeginD, FEndD, FOrderD, FDeliverD, FPayD, FDone, FDeleted, FInvoice FROM application.TSale

-- TSaleService
INSERT INTO changelog_psql.changelog_test.application.tsaleservice (SaleServiceK, SaleK, CustomerK, ActivityK, UserK, CreateD, UpdateD, TypeC, RateC, FUnitPrice, FAmount, FTimeSpent, FTimeCharge, FBeginD, FEndD, FDescription)
SELECT SaleServiceK, SaleK, CustomerK, ActivityK, UserK, CreateD, UpdateD, TypeC, RateC, FUnitPrice, FAmount, FTimeSpent, FTimeCharge, FBeginD, FEndD, FDescription FROM application.TSaleService;


-- TProject
INSERT INTO changelog_psql.changelog_test.application.tproject (ProjectK, GlobalK, SuperK, ParentK, table_number, UserK, CreateD, UpdateD, TypeC, StateC, AreaC, FName, FDescription, FText0, FText1, FBeginD, FEndD, FDeadlineD, FTodo, FDone, FPrivate, FDeleted)
SELECT ProjectK, GlobalK, SuperK, ParentK, table_number, UserK, CreateD, UpdateD, TypeC, StateC, AreaC, FName, FDescription, FText0, FText1, FBeginD, FEndD, FDeadlineD, FTodo, FDone, FPrivate, FDeleted FROM application.TProject;


-- TArticleBook
INSERT INTO changelog_psql.changelog_test.application.tarticlebook (ArticleBookK, UserK, SuperK, ParentK, table_number, CreateD, UpdateD, TypeC, StateC, LanguageC, FName, FSearchName, FHeader, FReleased, FReady, FDepreciated, FDeleted)
SELECT ArticleBookK, UserK, SuperK, ParentK, table_number, CreateD, UpdateD, TypeC, StateC, LanguageC, FName, FSearchName, FHeader, FReleased, FReady, FDepreciated, FDeleted FROM application.TArticleBook;

-- TArticle
INSERT INTO changelog_psql.changelog_test.application.tarticle (ArticleK, ArticleBookK, UserK, SuperK, ParentK, table_number, CreateD, UpdateD, Thread, ScopeS, LevelC, TypeC, StateC, LanguageC, FBrief, FHeader, FSearchText, FText, FChapter, FPage, FSticky, FDepreciated, FDeleted, TargetC, FValidFrom, FValidTo)
SELECT ArticleK, ArticleBookK, UserK, SuperK, ParentK, table_number, CreateD, UpdateD, Thread, ScopeS, LevelC, TypeC, StateC, LanguageC, FBrief, FHeader, FSearchText, CAST(FText AS NVARCHAR(4000)), FChapter, FPage, FSticky, FDepreciated, FDeleted, TargetC, FValidFrom, FValidTo FROM application.TArticle

/* Select records that needs manual fixing
SELECT ArticleK, ArticleBookK, UserK, SuperK, ParentK, table_number, CreateD, UpdateD, Thread, ScopeS, LevelC, TypeC, StateC, LanguageC, FBrief, FHeader, FSearchText, FText, FChapter, FPage, FCreate, FUpdate, FSticky, FDepreciated, FDeleted, TargetC, FValidFrom, FValidTo FROM application.TArticle
WHERE LEN( FText ) > 4000
 */

-- TProperty
INSERT INTO changelog_psql.changelog_test.application.tproperty (PropertyK, ParentK, table_number, PropertyNameK, FKey, FValue, FValueText, FValueInteger, FValueDate, FValueDecimal, FIndex, FValid, FSystem)
SELECT PropertyK, ParentK, table_number, PropertyNameK, FKey, FValue, FValueText, FValueInteger, FValueDate, FValueDecimal, FIndex, FValid, FSystem FROM application.TProperty

-- TPropertyName
INSERT INTO changelog_psql.changelog_test.application.tpropertyname (PropertyNameK, table_number, FName, FDescription, FTag, FValid, FMultiple)
SELECT PropertyNameK, table_number, FName, FDescription, FTag, FValid, FMultiple FROM application.TPropertyName


-- TTodoList
INSERT INTO changelog_psql.changelog_test.application.ttodolist (TodoListK, UserK, ParentK, table_number, CreateD, UpdateD, TypeC, FName, FDescription, FDeadline, FReadyD, FClosedD, FReady, FClosed, FDeleted)
SELECT TodoListK, UserK, ParentK, table_number, CreateD, UpdateD, TypeC, FName, FDescription, FDeadline, FReadyD, FClosedD, FReady, FClosed, FDeleted FROM application.TTodoList;

-- TTodo
INSERT INTO changelog_psql.changelog_test.application.ttodo (TodoK, TodoListK, UserK, CreateD, UpdateD, TypeC, StateC, FDescription, FDeadline, FReadyD, FClosedD, FReady, FClosed)
SELECT TodoK, TodoListK, UserK, CreateD, UpdateD, TypeC, StateC, FDescription, FDeadline, FReadyD, FClosedD, FReady, FClosed FROM application.TTodo;


-- TNote
INSERT INTO changelog_psql.changelog_test.application.tnote (NoteK, SuperK, RecordK, ParentK, table_number, FormatS, TypeC, CreateD, UpdateD, FTimeD, FNote)
SELECT NoteK, SuperK, RecordK, ParentK, table_number, FormatS, TypeC, CreateD, UpdateD, FTimeD, FNote FROM application.TNote;


-- TAddress
INSERT INTO changelog_psql.changelog_test.application.taddress (AddressK, ParentK, table_number, CreateD, UpdateD, TypeC, CountryC, FZip, FState, FCity, FCounty, FAddress, FAddress2, FAddress3, FDescription, FDeleted)
SELECT AddressK, ParentK, table_number, CreateD, UpdateD, TypeC, CountryC, FZip, FState, FCity, FCounty, FAddress, FAddress2, FAddress3, FDescription, FDeleted FROM application.TAddress

-- TNumber
INSERT INTO changelog_psql.changelog_test.application.tnumber (NumberK, ParentK, table_number, CreateD, UpdateD, TypeC, CountryC, FHead, FNumber, FTail, FDescription, FDeleted)
SELECT NumberK, ParentK, table_number, CreateD, UpdateD, TypeC, CountryC, FHead, FNumber, FTail, FDescription, FDeleted FROM application.TNumber

-- TBadge
INSERT INTO changelog_psql.changelog_test.application.tbadge (BadgeK, CreatedD, FName, FIdle, FDeleted, FInteger0)
SELECT BadgeK, CreatedD, FName, FIdle, FDeleted, FInteger0 FROM application.TBadge


-- Relations

INSERT INTO changelog_psql.changelog_test.application.trarticlebookxactivity (rArticleBookXActivityK, ArticleBookK, ActivityK)
SELECT rArticleBookXActivityK, ArticleBookK, ActivityK FROM application.TrArticleBookXActivity;

INSERT INTO changelog_psql.changelog_test.application.trarticlebookxarticle (rArticleBookXArticleK, ArticleBookK, ArticleK, TypeC, FPage, FOrder)
SELECT rArticleBookXArticleK, ArticleBookK, ArticleK, TypeC, FPage, FOrder FROM application.TrArticleBookXArticle;

INSERT INTO changelog_psql.changelog_test.application.trarticlexactivity (rArticleXActivityK, ArticleK, ActivityK)
SELECT rArticleXActivityK, ArticleK, ActivityK FROM application.TrArticleXActivity;

INSERT INTO changelog_psql.changelog_test.application.trprojectxactivity (rProjectXActivityK, ProjectK, ActivityK)
SELECT rProjectXActivityK, ProjectK, ActivityK FROM application.TrProjectXActivity;

INSERT INTO changelog_psql.changelog_test.application.trsalexactivity (rSaleXActivityK, SaleK, ActivityK)
SELECT rSaleXActivityK, SaleK, ActivityK FROM application.TrSaleXActivity;

INSERT INTO changelog_psql.changelog_test.application.trsalexcustomercontact (rSaleXCustomerContactK, SaleK, CustomerContactK, CreateD, UpdateD, RoleC)
SELECT rSaleXCustomerContactK, SaleK, CustomerContactK, CreateD, UpdateD, RoleC FROM application.TrSaleXCustomerContact;

INSERT INTO changelog_psql.changelog_test.application.trsystemrequestxactivity (rSystemRequestXActivityK, SystemRequestK, ActivityK)
SELECT rSystemRequestXActivityK, SystemRequestK, ActivityK FROM application.TrSystemRequestXActivity;

INSERT INTO changelog_psql.changelog_test.application.trsystemversionxactivity (rSystemVersionXActivityK, SystemVersionK, ActivityK, TargetC, ImpactC)
SELECT rSystemVersionXActivityK, SystemVersionK, ActivityK, TargetC, ImpactC FROM application.TrSystemVersionXActivity;

INSERT INTO changelog_psql.changelog_test.application.trsystemversionxarticle (rSystemVersionXArticleK, SystemVersionK, ArticleK, CreateD, UpdateD, BondC, FDescription, FDeleted)
SELECT rSystemVersionXArticleK, SystemVersionK, ArticleK, CreateD, UpdateD, BondC, FDescription, FDeleted FROM application.TrSystemVersionXArticle;

INSERT INTO changelog_psql.changelog_test.application.trsystemversionxproject (rSystemVersionXProjectK, SystemVersionK, ProjectK, TargetC, ImpactC)
SELECT rSystemVersionXProjectK, SystemVersionK, ProjectK, TargetC, ImpactC FROM application.TrSystemVersionXProject;

INSERT INTO changelog_psql.changelog_test.application.trsystemxcustomer (rSystemXCustomerK, SystemK, CustomerK, CreateD, TypeC, FDescription, FBeginD, FEndD)
SELECT rSystemXCustomerK, SystemK, CustomerK, CreateD, TypeC, FDescription, FBeginD, FEndD FROM application.TrSystemXCustomer;

INSERT INTO changelog_psql.changelog_test.application.trtodoxuser (rTodoXUserK, TodoK, UserK)
SELECT rTodoXUserK, TodoK, UserK FROM application.TrTodoXUser;

INSERT INTO changelog_psql.changelog_test.application.trusergroupxuser (rUserGroupXUserK, UserGroupK, UserK, FIdle, FDeleted)
SELECT rUserGroupXUserK, UserGroupK, UserK, FIdle, FDeleted FROM application.TrUserGroupXUser;

INSERT INTO changelog_psql.changelog_test.application.trxbadge (rXBadgeK, ParentK, table_number, BadgeK, CreateD)
SELECT rXBadgeK, ParentK, table_number, BadgeK, CreateD FROM application.TrXBadge;


-- thread

INSERT INTO changelog_psql.changelog_test.application.thread (FThreadId, table_number, FKey, FDepth, FNext, FPath)
SELECT FThreadId, table_number, FKey, FDepth, FNext, FPath FROM application.thread;

INSERT INTO changelog_psql.changelog_test.application.thread_header (FThreadId, table_number, FNextId)
SELECT FThreadId, table_number, FNextId FROM application.thread_header;