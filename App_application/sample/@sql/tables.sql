------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA=N'a2v10sample' and SEQUENCE_NAME=N'SQ_Agents')
	create sequence a2v10sample.SQ_Agents as bigint start with 100 increment by 1;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2v10sample' and TABLE_NAME=N'Agents')
begin
create table a2v10sample.Agents
(
	Id bigint not null constraint DF_Agent_Id default(next value for a2v10sample.SQ_Agents)
		constraint PK_Agents primary key,
	[Name] nvarchar(255) not null,
	[FullName] nvarchar(255) not null,
	Code nvarchar(32) not null,
	[Phone] nvarchar(32),
	[EMail] nvarchar(32),
	Memo nvarchar(255) null,
	DateCreated datetime not null constraint DF_Agent_DateCreated default(getdate())
);
end
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA=N'a2v10sample' and SEQUENCE_NAME=N'SQ_Documents')
	create sequence a2v10sample.SQ_Documents as bigint start with 100 increment by 1;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2v10sample' and TABLE_NAME=N'Documents')
begin
create table a2v10sample.Documents
(
	Id bigint not null constraint DF_Document_Id default(next value for a2v10sample.SQ_Documents)
		constraint PK_Documents primary key,
	[Kind] nvarchar(32),
	[Date] datetime,
	[No] nvarchar(255),
	[Done] bit not null constraint DF_Document_Done default(0),
	[Sum] money not null constraint DF_Document_Sum default(0),
	[Agent] bigint
		constraint FK_Documents_Agent references a2v10sample.Agents(Id),
	Memo nvarchar(255),
	DateCreated datetime not null constraint DF_Document_DateCreated default(getdate())
);
end
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA=N'a2v10sample' and SEQUENCE_NAME=N'SQ_DocDetails')
	create sequence a2v10sample.SQ_DocDetails as bigint start with 100 increment by 1;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2v10sample' and TABLE_NAME=N'DocDetails')
begin
create table a2v10sample.DocDetails
(
	Id bigint not null constraint DF_DocDetails_Id default(next value for a2v10sample.SQ_DocDetails)
		constraint PK_DocDetails primary key,
	[Document] bigint
		constraint FK_DocDetails_Document references a2v10sample.Documents(Id),
	[RowNo] int null,
	[Qty] float not null constraint DF_DocDetails_Qty default(0),
	[Price] float not null constraint DF_DocDetails_Price default(0),
	[Sum] money not null constraint DF_DocDetails_Sum default(0),
	Memo nvarchar(255)
);
end
go
