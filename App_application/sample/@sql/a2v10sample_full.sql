/*
version: 10.0.0001
generated: 09.04.2020 22:57:14
*/

set nocount on;
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'a2sys')
	exec sp_executesql N'create schema a2sys';
go
-----------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2sys' and TABLE_NAME=N'Versions')
	create table a2sys.Versions
	(
		Module sysname not null constraint PK_Versions primary key,
		[Version] int null,
		[Title] nvarchar(255),
		[File] nvarchar(255)
	);
go
----------------------------------------------
if exists(select * from a2sys.Versions where [Module]=N'script:A2v10.Sample')
	update a2sys.Versions set [Version]=1, [File]=N'@sql/a2v10sample_full.sql', Title=null where [Module]=N'script:A2v10.Sample';
else
	insert into a2sys.Versions([Module], [Version], [File], Title) values (N'script:A2v10.Sample', 1, N'@sql/a2v10sample_full.sql', null);
go



/* @sql/a2v10sample_full.sql */

------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'a2v10sample')
begin
	exec sp_executesql N'create schema a2v10sample';
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
	Id bigint not null constraint DF_Agents_Id default(next value for a2v10sample.SQ_Agents)
		constraint PK_Agents primary key,
	[Name] nvarchar(255),
	[FullName] nvarchar(255),
	Code nvarchar(32),
	[Phone] nvarchar(32),
	[EMail] nvarchar(32),
	Memo nvarchar(255) null,
	DateCreated datetime not null constraint DF_Agents_DateCreated default(getdate())
);
end
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



------------------------------------------------
begin
if not exists(select * from a2sys.SysParams where [Name] = N'AppTitle')
	insert into a2sys.SysParams ([Name], StringValue) values (N'AppTitle', N'A2v10:Sample');
end
go
-- main menu
------------------------------------------------
begin
	set nocount on
	declare @menu table(id bigint, p0 bigint, [name] nvarchar(255), [url] nvarchar(255), icon nvarchar(255), [order] int);
	insert into @menu(id, p0, [name], [url], icon, [order])
	values
		(1, null, N'Main',        null,              null,  0),
		(10,   1,  N'@[Documents]',   N'document',    null, 10),
		(20,   1,  N'@[Catalog]',     N'catalog',     null, 20),
		(101, 10,  N'@[Waybills]',    N'waybill',     N'file',  10),
		(201, 20,  N'@[Agents]',      N'agent',       N'users', 10),
		(202, 20,  N'@[Products]',    N'product',     N'package-outline', 20)
	merge a2ui.Menu as target
	using @menu as source
	on target.Id=source.id and target.Id >= 1 and target.Id < 900
	when matched then
		update set
			target.Id = source.id,
			target.Parent = source.p0,
			target.[Name] = source.[name],
			target.[Url] = source.[url],
			target.[Icon] = source.icon,
			target.[Order] = source.[order]
	when not matched by target then
		insert(Id, Parent, [Name], [Url], Icon, [Order]) values (id, p0, [name], [url], icon, [order])
	when not matched by source and target.Id >= 1 and target.Id < 900 then 
		delete;

	if not exists (select * from a2security.Acl where [Object] = 'std:menu' and [ObjectId] = 1 and GroupId = 1)
	begin
		insert into a2security.Acl ([Object], ObjectId, GroupId, CanView)
			values (N'std:menu', 1, 1, 1);
	end
	exec a2security.[Permission.UpdateAcl.Menu];
end
go

------------------------------------------------
create or alter procedure a2v10sample.[Agent.Index]
@UserId bigint,
@Id bigint = null,
@Offset int = 0,
@PageSize int = 20,
@Order nvarchar(255) = N'Id',
@Dir nvarchar(20) = N'desc',
@Fragment nvarchar(255) = null
as
begin
	set nocount on;

	declare @RawFilter nvarchar(255);
	set @RawFilter = @Fragment;

	set @Fragment = N'%' + upper(@Fragment) + N'%';	

	declare @agents table(Id bigint, _rowNo int identity(1, 1), _rows int);

	insert into @agents(Id, _rows)
	select a.Id, count(*) over ()
	from 
		a2v10sample.Agents a
	where 
		@Fragment is null or upper(a.Memo) like @Fragment or upper(a.[Name]) like @Fragment or upper(a.Code) like @Fragment 
		or upper(a.FullName) like @Fragment or upper(a.Memo) like @Fragment or upper(a.Phone) like @Fragment or a.EMail like @Fragment
	order by 
	case when @Dir = N'desc' then
		case @Order
			when N'Name' then a.[Name]
			when N'Code' then a.Code
			when N'FullName' then a.FullName
			when N'Phone' then a.Phone
			when N'EMail' then a.EMail
			when N'Memo' then a.[Memo]
		end
	end desc,
	case when @Dir = N'asc' then
		case @Order
			when N'Name' then a.[Name]
			when N'Code' then a.Code
			when N'FullName' then a.FullName
			when N'Phone' then a.Phone
			when N'EMail' then a.EMail
			when N'Memo' then a.[Memo]
		end
	end asc,
	case when @Dir = N'desc' then
		case @Order
			when N'Id' then a.Id
		end
	end desc,
	case when @Dir = N'asc' then
		case @Order
			when N'Id' then a.Id
		end
	end asc,
	a.Id desc
	offset @Offset rows fetch next @PageSize rows only
	option (recompile);
		
	select [Agents!TAgent!Array] = null, [Id!!Id] = a.Id, Code, [Name], FullName, Memo, Phone, EMail,
			[!!RowCount] = t._rows

	from @agents  t inner join 
		a2v10sample.Agents a on t.Id = a.Id
		order by t._rowNo offset (@Offset) rows fetch next (@PageSize) rows only;

	-- system data
	select [!$System!] = null, 
		[!Agents!PageSize] = @PageSize, 
		[!Agents!SortOrder] = @Order, 
		[!Agents!SortDir] = @Dir,
		[!Agents!Offset] = @Offset,
		[!Agents.Fragment!Filter] = @RawFilter;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Load]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;

	select [Agent!TAgent!Object] = null, [Id!!Id] = Id, Code, [Name], FullName, Memo, Phone, EMail
	from a2v10sample.Agents
	where @Id = Id;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Metadata]
as
begin
	set nocount on;
	declare @Agent a2v10sample.[Agent.TableType];
	select [Agent!Agent!Metadata] = null, * from @Agent;
end
go
---------------------------------------------------
create or alter procedure a2v10sample.[Agent.Update]
@TenantId int = 1,
@UserId bigint,
@Agent a2v10sample.[Agent.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level serializable;
	set xact_abort on;

	declare @RetId bigint;
	declare @output table(op sysname, id bigint);

	merge a2v10sample.Agents as target
	using @Agent as source
	on (target.Id = source.Id)
	when matched then update set 
		target.[Name] = source.[Name],
		target.FullName = source.FullName,
		target.Code = source.Code,
		target.Phone = source.Phone,
		target.Email = source.Email,
		target.Memo = source.Memo
	when not matched by target then
	insert([Name], FullName, Code, Phone, EMail, Memo) 
	values ([Name], FullName, Code, Phone, EMail, Memo)
	output 
		$action op,
		inserted.Id id
	into @output(op, id);
	select top(1) @RetId = id from @output;

	select top(1) @RetId = id from @output;

	execute a2v10sample.[Agent.Load] @UserId, @RetId;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Delete]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;

	begin try
		delete from a2v10sample.Agents where Id=@Id;
	end try
	begin catch
		throw 60000, N'UI:@[Error.Used]', 0;
	end catch


end
go


------------------------------------------------
create or alter procedure a2v10sample.[Product.Index]
@UserId bigint,
@Id bigint = null,
@Offset int = 0,
@PageSize int = 20,
@Order nvarchar(255) = N'Id',
@Dir nvarchar(20) = N'desc',
@Fragment nvarchar(255) = null
as
begin
	set nocount on;

	declare @RawFilter nvarchar(255);
	set @RawFilter = @Fragment;

	set @Fragment = N'%' + upper(@Fragment) + N'%';	

	declare @products table(Id bigint, _rowNo int identity(1, 1), _rows int);

	insert into @products(Id, _rows)
	select p.Id, count(*) over ()
	from 
		a2v10sample.Products p
	where 
		@Fragment is null or upper(p.Memo) like @Fragment or upper(p.[Name]) like @Fragment or upper(p.BarCode) like @Fragment 
		or upper(p.Article) like @Fragment
	order by 
	case when @Dir = N'desc' then
		case @Order
			when N'Name' then p.[Name]
			when N'BarCode' then p.BarCode
			when N'Article' then p.Article
			when N'Memo' then p.[Memo]
		end
	end desc,
	case when @Dir = N'asc' then
		case @Order
			when N'Name' then p.[Name]
			when N'BarCode' then p.BarCode
			when N'Article' then p.Article
			when N'Memo' then p.[Memo]
		end
	end asc,
	case when @Dir = N'desc' then
		case @Order
			when N'Id' then p.Id
		end
	end desc,
	case when @Dir = N'asc' then
		case @Order
			when N'Id' then p.Id
		end
	end asc,
	p.Id desc
	offset @Offset rows fetch next @PageSize rows only
	option (recompile);
		
	select [Products!TProduct!Array] = null, [Id!!Id] = p.Id, Article, [Name], BarCode, Memo,
			[!!RowCount] = t._rows
	from @products  t inner join 
		a2v10sample.Products p on t.Id = p.Id
		order by t._rowNo offset (@Offset) rows fetch next (@PageSize) rows only;

	-- system data
	select [!$System!] = null, 
		[!Products!PageSize] = @PageSize, 
		[!Products!SortOrder] = @Order, 
		[!Products!SortDir] = @Dir,
		[!Products!Offset] = @Offset,
		[!Products.Fragment!Filter] = @RawFilter;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Product.Load]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;

	select [Product!TProduct!Object] = null, [Id!!Id] = Id, BarCode, [Name], Article, Memo
	from a2v10sample.Products
	where @Id = Id;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Product.Metadata]
as
begin
	set nocount on;
	declare @Product a2v10sample.[Product.TableType];
	select [Product!Product!Metadata] = null, * from @Product;
end
go
---------------------------------------------------
create or alter procedure a2v10sample.[Product.Update]
@TenantId int = 1,
@UserId bigint,
@Product a2v10sample.[Product.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level serializable;
	set xact_abort on;

	declare @RetId bigint;
	declare @output table(op sysname, id bigint);

	merge a2v10sample.Products as target
	using @Product as source
	on (target.Id = source.Id)
	when matched then update set 
		target.[Name] = source.[Name],
		target.Article = source.Article,
		target.BarCode = source.BarCode,
		target.Memo = source.Memo
	when not matched by target then
	insert([Name], Article, BarCode, Memo) 
	values ([Name], Article, BarCode, Memo)
	output 
		$action op,
		inserted.Id id
	into @output(op, id);
	select top(1) @RetId = id from @output;

	select top(1) @RetId = id from @output;

	execute a2v10sample.[Product.Load] @UserId, @RetId;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Product.Delete]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;

	begin try
		delete from a2v10sample.Products where Id=@Id;
	end try
	begin catch
		throw 60000, N'UI:@[Error.Used]', 0;
	end catch


end
go



------------------------------------------------
create or alter procedure a2v10sample.[Document.Index]
@UserId bigint,
@Kind nvarchar(32)
as
begin
	set nocount on;
	select [Documents!TDocument!Array] = null, [Id!!Id] = Id, [Date], [No], [Sum], [Memo], DateCreated,
		[Agent!TAgent!RefId] = Agent
	from a2v10sample.Documents 
	where [Kind] = @Kind;

	select [!TAgent!Map] = null, [Id!!Id] = a.Id, [Name], a.Memo, a.Phone, a.EMail
	from a2v10sample.Agents a inner join a2v10sample.Documents d on d.Agent = a.Id
	where d.Id in (select Agent from a2v10sample.Documents);

end
go
------------------------------------------------
create or alter procedure a2v10sample.[Document.Load]
@UserId bigint,
@Id bigint = null,
@Kind nvarchar(32) = null
as
begin
	set nocount on;

	select [Document!TDocument!Object] = null, [Id!!Id] = Id, [Date], [No], [Sum], [Memo], 
	[Agent!TAgent!RefId] = Agent, [Rows!TRow!Array] = null,
	DateCreated, DateModified
	from a2v10sample.Documents 
	where @Id = Id;

	select [!TRow!Array] = null, [Id!!Id] = dd.Id, [!TDocument.Rows!ParentId] = [Document], [Qty], Price, [Sum],
		Memo, [Product!TProduct!RefId] = Product
	from a2v10sample.DocDetails dd
	where Document = @Id
	order by [RowNo];

	select [!TAgent!Map] = null, [Id!!Id] = a.Id, [Name], a.Memo, a.Phone, a.EMail
	from a2v10sample.Agents a inner join a2v10sample.Documents d on d.Agent = a.Id
	where d.Id = @Id;

	select [!TProduct!Map] = null, [Id!!Id] = p.Id, p.[Name], p.Memo, p.BarCode, p.Article
	from a2v10sample.Products p inner join a2v10sample.DocDetails dd on dd.Product = p.Id
	where dd.Document = @Id;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Document.Metadata]
as
begin
	set nocount on;
	declare @Document a2v10sample.[Document.TableType];
	declare @Rows a2v10sample.[DocDetails.TableType];
	select [Document!Document!Metadata] = null, * from @Document;
	select [Rows!Document.Rows!Metadata]=null, * from @Rows;
end
go
---------------------------------------------------
create or alter procedure a2v10sample.[Document.Update]
@TenantId int = 1,
@UserId bigint,
@Document a2v10sample.[Document.TableType] readonly,
@Rows a2v10sample.[DocDetails.TableType] readonly,
@Kind nvarchar(32)
as
begin
	set nocount on;
	set transaction isolation level serializable;
	set xact_abort on;

	declare @RetId bigint;
	declare @output table(op sysname, id bigint);

	merge a2v10sample.Documents as target
	using @Document as source
	on (target.Id = source.Id)
	when matched then update set 
		target.[Date] = source.[Date],
		target.[No] = source.[No],
		target.Agent = source.Agent,
		target.[Sum] = source.[Sum],
		target.Memo = source.Memo,
		target.DateModified = getdate()
	when not matched by target then
	insert(Kind, [Date], [No], Agent, [Sum], Memo) 
	values (@Kind, [Date], [No], Agent, [Sum], Memo)
	output 
		$action op,
		inserted.Id id
	into @output(op, id);
	select top(1) @RetId = id from @output;

	select top(1) @RetId = id from @output;

	merge a2v10sample.DocDetails as target
	using @Rows as source
	on (target.Id = source.Id and target.Document = @RetId)
	when matched then 
		update set
			target.RowNo = source.RowNumber,
			target.Product = source.Product,
			target.Qty = source.Qty,
			target.Price = source.Price,
			target.[Sum] = source.[Sum],
			target.Memo = source.Memo
	when not matched by target then
		insert (Document, RowNo, Qty, Price, [Sum], Product, Memo)
		values (@RetId, RowNumber, Qty, Price, [Sum], Product, Memo)
	when not matched by source and target.Document = @RetId then delete;

	execute a2v10sample.[Document.Load] @UserId, @RetId;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Document.Delete]
@UserId bigint,
@Id bigint,
@Kind nvarchar(32)
as
begin
	set nocount on;
	begin tran
	delete from a2v10sample.DocDetails where Document = @Id;
	delete from a2v10sample.Documents where Id=@Id;
	commit tran;
end
go
