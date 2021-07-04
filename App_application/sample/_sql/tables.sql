------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA=N'a2v10sample' and SEQUENCE_NAME=N'SQ_Images')
	create sequence a2v10sample.SQ_Images as bigint start with 100 increment by 1;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2v10sample' and TABLE_NAME=N'Images')
begin
	create table a2v10sample.Images
	(
		Id	bigint not null constraint PK_Images primary key
			constraint DF_Images_PK default(next value for a2v10sample.SQ_Images),
		[Name] nvarchar(255) null,
		[Mime] nvarchar(255) null,
		[Data] varbinary(max),
		[AccessKey] uniqueidentifier not null
			constraint DF_AccessKey default(newid()),
		BlobName nvarchar(255) null
	);
end
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA=N'a2v10sample' and SEQUENCE_NAME=N'SQ_Agents')
	create sequence a2v10sample.SQ_Agents as bigint start with 100 increment by 1;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2v10sample' and TABLE_NAME=N'Agents')
begin
	create table a2v10sample.Agents
	(
		Id	bigint not null constraint PK_Agents primary key
			constraint DF_Agents_PK default(next value for a2v10sample.SQ_Agents),
		Void bit not null
			constraint DF_Agents_Void default(0),
		Folder bit not null
			constraint DF_Agents_Folder default(0),
		Parent bigint null
			constraint FK_Agents_Parent_Agents foreign key references a2v10sample.Agents(Id),
		[Code] nvarchar(32) null,
		[Name] nvarchar(255) null,
		[Memo] nvarchar(255) null,
		DateCreated datetime not null constraint DF_Agents_DateCreated default(getdate()),
		UserCreated bigint not null
			constraint FK_Agents_UserCreated_Users foreign key references a2security.Users(Id),
		DateModified datetime not null constraint DF_Agents_DateModified default(getdate()),
		UserModified bigint not null
			constraint FK_Agents_UserModified_Users foreign key references a2security.Users(Id)
	);
end
go
------------------------------------------------
if not exists (select * from sys.indexes where object_id = object_id(N'a2v10sample.Agents') and name = N'IX_Agents_Parent')
	create index IX_Agents_Parent on a2v10sample.Agents ([Parent]) include (Id, Void, Folder);
go

------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA=N'a2v10sample' and SEQUENCE_NAME=N'SQ_Products')
	create sequence a2v10sample.SQ_Products as bigint start with 100 increment by 1;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2v10sample' and TABLE_NAME=N'Products')
begin
create table a2v10sample.Products
(
	Id bigint not null constraint DF_Products_Id default(next value for a2v10sample.SQ_Products)
		constraint PK_Products primary key,
	[Name] nvarchar(255),
	Article nvarchar(255),
	BarCode nvarchar(32),
	Memo nvarchar(255) null,
	Picture bigint null
		constraint FK_Products_Picture_Images foreign key references a2v10sample.Images(Id),
	DateCreated datetime not null constraint DF_Products_DateCreated default(getdate())
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
	[Date] date,
	[No] nvarchar(255),
	[Done] bit not null constraint DF_Document_Done default(0),
	[Sum] money not null constraint DF_Document_Sum default(0),
	[Agent] bigint
		constraint FK_Documents_Agent references a2v10sample.Agents(Id),
	Memo nvarchar(255),
	DateCreated datetime not null constraint DF_Document_DateCreated default(getdate()),
	DateModified datetime not null constraint DF_Document_DateModified default(getdate())
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
	Product bigint
		constraint FK_DocDetails_Product references a2v10sample.Products(Id),
	Memo nvarchar(255)
);
end
go
