------------------------------------------------
if exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA=N'a2v10sample' and ROUTINE_NAME=N'Document.Update')
	drop procedure a2v10sample.[Document.Update];
go
------------------------------------------------
if exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA=N'a2v10sample' and ROUTINE_NAME=N'Agent.Update')
	drop procedure a2v10sample.[Agent.Update];
go
------------------------------------------------
if exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA=N'a2v10sample' and ROUTINE_NAME=N'Product.Update')
	drop procedure a2v10sample.[Product.Update];
go
------------------------------------------------
if exists(select * from INFORMATION_SCHEMA.DOMAINS where DOMAIN_SCHEMA = N'a2v10sample' and DOMAIN_NAME = N'Document.TableType')
	drop type a2v10sample.[Document.TableType];
go
------------------------------------------------
create type a2v10sample.[Document.TableType] as table(
	Id bigint,
	Kind nvarchar(32),
	[Date] date,
	[No] nvarchar(255),
	[Sum] money,
	[Agent] bigint,
	Memo nvarchar(255)
)
go
------------------------------------------------
if exists(select * from INFORMATION_SCHEMA.DOMAINS where DOMAIN_SCHEMA=N'a2v10sample' and DOMAIN_NAME=N'DocDetails.TableType' and DATA_TYPE=N'table type')
	drop type a2v10sample.[DocDetails.TableType];
go
------------------------------------------------
create type a2v10sample.[DocDetails.TableType]
as table(
	Id bigint null,
	ParentId bigint null,
	RowNumber int,
	[Qty] float,
	[Price] float,
	[Sum] money,
	Product bigint,
	[Memo] nvarchar(255)
)
go
------------------------------------------------
if exists(select * from INFORMATION_SCHEMA.DOMAINS where DOMAIN_SCHEMA=N'a2v10sample' and DOMAIN_NAME=N'Agent.TableType' and DATA_TYPE=N'table type')
	drop type a2v10sample.[Agent.TableType];
go
------------------------------------------------
create type a2v10sample.[Agent.TableType]
as table(
	Id bigint null,
	[Name] nvarchar(255),
	[FullName] nvarchar(255),
	Code nvarchar(32),
	[Phone] nvarchar(32),
	[EMail] nvarchar(32),
	Memo nvarchar(255) null
)
go
------------------------------------------------
if exists(select * from INFORMATION_SCHEMA.DOMAINS where DOMAIN_SCHEMA=N'a2v10sample' and DOMAIN_NAME=N'Product.TableType' and DATA_TYPE=N'table type')
	drop type a2v10sample.[Product.TableType];
go
------------------------------------------------
create type a2v10sample.[Product.TableType]
as table(
	Id bigint null,
	[Name] nvarchar(255),
	[Article] nvarchar(255),
	BarCode nvarchar(32),
	Memo nvarchar(255) null
)
go


