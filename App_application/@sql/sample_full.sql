/*
version: 10.0.0021
generated: 23.03.2022 13:19:45
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
if exists(select * from a2sys.Versions where [Module]=N'script:full')
	update a2sys.Versions set [Version]=21, [File]=N'@sql/sample_full.sql', Title=null where [Module]=N'script:full';
else
	insert into a2sys.Versions([Module], [Version], [File], Title) values (N'script:full', 21, N'@sql/sample_full.sql', null);
go



/* @sql/sample_full.sql */

------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'a2v10sample')
begin
	exec sp_executesql N'create schema a2v10sample';
end
go

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
		[EMail] nvarchar(32) null,
		[Phone] nvarchar(32) null,
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
	DateCreated datetime not null constraint DF_Products_DateCreated default(getdate()),
	ExternalCode nvarchar(255)
);
end
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA=N'a2v10sample' and TABLE_NAME=N'Products' and COLUMN_NAME=N'ExternalCode')
	alter table a2v10sample.Products add ExternalCode nvarchar(255) null
go
------------------------------------------------
if not exists (select * from sys.indexes where object_id = object_id(N'a2v10sample.Products') and name = N'IX_Products_ExternalCode')
	create index IX_Products_ExternalCode on a2v10sample.Products ([ExternalCode]) include (Id);
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

drop procedure if exists a2v10sample.[Document.Update];
drop procedure if exists a2v10sample.[Agent.Update];
drop procedure if exists a2v10sample.[Product.Update];
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
	Memo nvarchar(255) null,
	Picture bigint null
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

/*
------------------------------------------------
Copyright © 2012-2021 Alex Kukhtin

Last updated : 31 jan 2021
*/
------------------------------------------------
/* основна процедура - повертає вернхій рівень дерева, та структури даних*/
create or alter procedure a2v10sample.[Agent.Index]
@UserId bigint,
@Id bigint = null,
@HideSearch bit = 0
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	with T(Id, [Name], Icon, HasChildren, IsSpec)
	as (
		select Id = cast(-1 as bigint), [Name] = N'[Результат пошуку]', Icon='search',
			HasChildren = cast(0 as bit), IsSpec=1
		where @HideSearch = 0
		union all
		select Id, [Name], Icon = N'folder-outline',
			HasChildren= case when exists(select 1 from a2v10sample.Agents c where c.Void = 0 and c.Parent = a.Id and c.Folder = 1) then 1 else 0 end,
			IsSpec = 0
		from a2v10sample.Agents a
			where a.Folder = 1 and a.Void = 0 and a.Parent is null
	)
	select [Folders!TFolder!Tree] = null, [Id!!Id] = Id, [Name!!Name] = [Name], Icon,
		/*вкладені папки - lazy*/
		[SubItems!TFolder!Items] = null, 
		/*ознака того, що є вкладені - щоб показати позначку для розгортування */
		[HasSubItems!!HasChildren] = HasChildren,
		/*вкладені контрагенти (не папки!) */
		[Children!TAgent!LazyArray] = null
	from T
	order by [IsSpec], [Name];

	-- описание набора TAgent - пустой набор, чтобы создать правильную структуру данных
	-- родительская папка - вложенный объект, чтобы не плодить лишние наборы
	select [!TAgent!Array] = null, [Id!!Id] = a.Id, [Name!!Name] = a.[Name], a.Code, a.Memo,
		[ParentFolder.Id!TParentFolder!Id] = a.Parent, [ParentFolder.Name!TParentFolder!Name] = p.[Name]
		from a2v10sample.Agents a left join a2v10sample.Agents p on a.Parent = p.Id where 0 <> 0;
end
go
------------------------------------------------
/* разворачивание одного узла дерева */
create or alter procedure a2v10sample.[Agent.Expand]
	@UserId bigint,
	@Id bigint,
	@HideSearch bit = 0
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [SubItems!TFolder!Tree] = null, [Id!!Id] = Id, [Name!!Name] = [Name], Icon = N'folder-outline',
		[SubItems!TFolder!Items] = null,
		[HasSubItems!!HasChildren] = case when exists(select 1 from a2v10sample.Agents c where c.Void=0 and c.Parent=a.Id and c.Folder = 1) then 1 else 0 end,
		[Children!TAgent!LazyArray] = null
	from a2v10sample.Agents a where Folder=1 and Parent = @Id and Void=0;
end
go
-- вложенные контрагенты, не папки
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Children]
	@UserId bigint,
	@Fragment nvarchar(255) = null,
	@Id bigint,
	@Offset int = 0,
	@PageSize int = 10,
	@Order nvarchar(255) = N'name',
	@Dir nvarchar(20) = N'asc'
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Asc nvarchar(10), @Desc nvarchar(10), @RowCount int;
	declare @fr nvarchar(255);

	set @Asc = N'asc'; set @Desc = N'desc';
	set @Dir = lower(isnull(@Dir, @Asc));
	set @Order = lower(@Order);
	set @fr = N'%' + upper(@Fragment) + N'%';

	-- структура recordset повторяет то, что мы описывали в основном (Agent.Index).
	with T(Id, [Name], Parent, Code, Memo, RowNumber)
	as (
		select Id, [Name], Parent, Code, Memo,
			[RowNumber] = row_number() over (
				order by 
					case when @Order=N'id'   and @Dir=@Asc  then a.Id end asc,
					case when @Order=N'id'   and @Dir=@Desc then a.Id end desc,
					case when @Order=N'name' and @Dir=@Asc  then a.[Name] end asc,
					case when @Order=N'name' and @Dir=@Desc then a.[Name] end desc,
					case when @Order=N'code' and @Dir=@Asc  then a.Code end asc,
					case when @Order=N'code' and @Dir=@Desc then a.Code end desc,
					case when @Order=N'memo' and @Dir=@Asc  then a.Memo end asc,
					case when @Order=N'memo' and @Dir=@Desc then a.Memo end desc
			)
			from a2v10sample.Agents a
		where Folder=0 and Void=0 and (
			Parent = @Id or
				(@Id = -1 and (upper([Name]) like @fr or upper([Code]) like @fr or upper(Memo) like @fr))
			)
	) select [Children!TAgent!Array] = null, [Id!!Id] = a.Id, [Name!!Name] = a.[Name], a.Code, a.Memo,
		[ParentFolder.Id!TParentFolder!Id] = a.Parent, [ParentFolder.Name!TParentFolder!Name] = p.[Name],
		[!!RowCount]  = (select count(1) from T)
	from T a left join a2v10sample.Agents p on a.Parent = p.Id
	order by RowNumber offset (@Offset) rows fetch next (@PageSize) rows only;

	-- system data
	select [!$System!] = null,
		[!Children!PageSize] = @PageSize, 
		[!Children!SortOrder] = @Order, 
		[!Children!SortDir] = @Dir,
		[!Children!Offset] = @Offset,
		[!Children.Fragment!Filter] = @Fragment
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Browse.Index]
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
	where a.Folder = 0 and
		(@Fragment is null or upper(a.Memo) like @Fragment or upper(a.[Name]) like @Fragment or upper(a.Code) like @Fragment 
		or upper(a.Memo) like @Fragment or upper(a.Phone) like @Fragment or a.EMail like @Fragment)
	order by 
	case when @Dir = N'desc' then
		case @Order
			when N'Name' then a.[Name]
			when N'Code' then a.Code
			when N'Phone' then a.Phone
			when N'EMail' then a.EMail
			when N'Memo' then a.[Memo]
		end
	end desc,
	case when @Dir = N'asc' then
		case @Order
			when N'Name' then a.[Name]
			when N'Code' then a.Code
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
		
	select [Agents!TAgent!Array] = null, [Id!!Id] = a.Id, Code, [Name], Memo, Phone, EMail,
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
create or alter procedure a2v10sample.[Agent.Folder.Load]
	@UserId bigint,
	@Id bigint = null,
	@Parent bigint = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	if @Parent is null
		select @Parent = Parent from a2v10sample.Agents where Id=@Id;

	select [Folder!TFolder!Object] = null, [Id!!Id] = Id, [Name!!Name] = [Name], Icon=N'folder-outline',
		ParentFolder = Parent
	from a2v10sample.Agents 
	where Id=@Id and Folder = 1;
	
	select [ParentFolder!TParentFolder!Object] = null,  [Id!!Id] = Id, [Name!!Name] = [Name]
	from a2v10sample.Agents 
	where Id=@Parent;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Item.Load]
@UserId bigint,
@Id bigint = null,
@Parent bigint = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	if @Parent is null
		select @Parent = Parent from a2v10sample.Agents where Id=@Id;
	-- родительский объект вернем в виде, как в списке, чтобы меньше возиться с присваиванием
	select [Agent!TAgent!Object] = null, [Id!!Id] = a.Id, [Name!!Name] = a.[Name], a.Code, a.Memo,
		[ParentFolder.Id!TParentFolder!Id] = a.Parent, [ParentFolder.Name!TParentFolder!Name] = p.[Name]
	from a2v10sample.Agents a left join a2v10sample.Agents p on a.Parent = p.Id
	where a.Id=@Id and a.Folder = 0;
	
	select [ParentFolder!TParentFolder!Object] = null,  [Id!!Id] = Id, [Name!!Name] = [Name]
	from a2v10sample.Agents 
	where Id=@Parent;
end
go
------------------------------------------------
drop procedure if exists a2v10sample.[Agent.Folder.Metadata];
drop procedure if exists a2v10sample.[Agent.Folder.Update];
drop procedure if exists a2v10sample.[Agent.Item.Metadata];
drop procedure if exists a2v10sample.[Agent.Item.Update];
go
------------------------------------------------
if exists(select 1 from INFORMATION_SCHEMA.DOMAINS where DOMAIN_SCHEMA=N'a2v10sample' and DOMAIN_NAME=N'Agent.Folder.TableType' and DATA_TYPE=N'table type')
	drop type a2v10sample.[Agent.Folder.TableType];
go
------------------------------------------------
create type a2v10sample.[Agent.Folder.TableType]
as table(
	Id bigint null,
	ParentFolder bigint,
	[Name] nvarchar(255)
)
go
------------------------------------------------
if exists(select 1 from INFORMATION_SCHEMA.DOMAINS where DOMAIN_SCHEMA=N'a2v10sample' and DOMAIN_NAME=N'Agent.Item.TableType' and DATA_TYPE=N'table type')
	drop type a2v10sample.[Agent.Item.TableType];
go
------------------------------------------------
create type a2v10sample.[Agent.Item.TableType]
as table(
	Id bigint null,
	ParentFolder bigint,
	[Name] nvarchar(255),
	Code nvarchar(32),
	Memo nvarchar(255)
)
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Folder.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Folder a2v10sample.[Agent.Folder.TableType];
	select [Folder!Folder!Metadata] = null, * from @Folder;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Folder.Update]
@UserId bigint,
@Folder a2v10sample.[Agent.Folder.TableType] readonly,
@RetId bigint = null output
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;

	declare @output table(op sysname, id bigint);

	merge a2v10sample.Agents as t
	using @Folder as s
	on (t.Id = s.Id)
	when matched then
		update set 
			t.[Name] = s.[Name],
			t.[DateModified] = getdate(),
			t.[UserModified] = @UserId
	when not matched by target then 
		insert (Folder, Parent, [Name], UserCreated, UserModified)
		values (1, nullif(s.ParentFolder, 0), s.[Name], @UserId, @UserId)
	output 
		$action op, inserted.Id id
	into @output(op, id);

	select top(1) @RetId = id from @output;

	select [Folder!TFolder!Object] = null, [Id!!Id] = Id, [Name!!Name] = [Name], Icon=N'folder-outline',
		ParentFolder = Parent
	from a2v10sample.Agents 
	where Id=@RetId;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Item.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Agent a2v10sample.[Agent.Item.TableType];
	select [Agent!Agent!Metadata] = null, * from @Agent;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Item.Update]
@UserId bigint,
@Agent a2v10sample.[Agent.Item.TableType] readonly,
@RetId bigint = null output
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;

	/* этот фрагмент позволяет удобно отлаживать входящие рекордсеты
	declare @xml nvarchar(max);
	set @xml = (select * from @Agent for xml auto);
	throw 60000, @xml, 0;
	*/

	declare @output table(op sysname, id bigint);

	merge a2v10sample.Agents as t
	using @Agent as s
	on (t.Id = s.Id)
	when matched then
		update set 
			t.[Name] = s.[Name],
			t.[Code] = s.[Code],
			t.[Memo] = s.[Memo],
			t.Parent = s.ParentFolder,
			t.[DateModified] = getdate(),
			t.[UserModified] = @UserId
	when not matched by target then 
		insert (Folder, Parent, [Name], Code, Memo, UserCreated, UserModified)
		values (0, case when s.ParentFolder = 0 then null else s.ParentFolder end, 
			s.[Name], Code, Memo, @UserId, @UserId)
	output 
		$action op,
		inserted.Id id
	into @output(op, id);

	select top(1) @RetId = id from @output;

	select [Agent!TAgent!Object] = null, [Id!!Id] = a.Id, [Name!!Name] = a.[Name], a.Code, a.Memo,
		[ParentFolder.Id!TParentFolder!Id] = a.Parent, [ParentFolder.Name!TParentFolder!Name] = p.[Name]
	from a2v10sample.Agents a left join a2v10sample.Agents p on a.Parent = p.Id
	where a.Id=@RetId and a.Folder = 0;
end
go
------------------------------------------------
create or alter procedure [a2v10sample].[Agent.Folder.Delete]
@UserId bigint,
@Id bigint
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;

	if exists(select 1 from a2v10sample.Agents where Parent=@Id and Void=0)
		throw 60000, N'UI:Неможливо видалити папку', 0;
	update a2v10sample.Agents set Void=1 where Id=@Id and Folder = 1;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Agent.Item.Delete]
@UserId bigint,
@Id bigint
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;
	-- TODO: check if there are any references
	update a2v10sample.Agents set Void=1 where Id=@Id and Folder=0;
end
go
------------------------------------------------
-- возвращает путь в дереве элементов начиная с корня
create or alter procedure a2v10sample.[Agent.Folder.GetPath]
@UserId bigint,
@Id bigint
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	with T(Id, Parent, [Level]) as (
		select cast(null as bigint), @Id, 0
		union all
		select a.Id, a.Parent, [Level] + 1 
			from a2v10sample.Agents a inner join T on a.Id = T.Parent
		)
	select [Result!TResult!Array] = null, [Id] = Id from T where Id is not null order by [Level] desc;
end
go
------------------------------------------------
-- возвращает индекс в списке дочерних в зависимости от сортировки
create or alter procedure a2v10sample.[Agent.Item.FindIndex]
@UserId bigint,
@Id bigint,
@Parent bigint,
@Order nvarchar(255) = N'name',
@Dir nvarchar(20) = N'asc'
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Asc nvarchar(10), @Desc nvarchar(10), @RowCount int;

	set @Asc = N'asc'; set @Desc = N'desc';
	set @Dir = lower(isnull(@Dir, @Asc));
	set @Order = lower(@Order);

	with T(Id, RowNumber)
	as (
		select Id, [RowNumber] = row_number() over (
				order by 
					case when @Order=N'id'   and @Dir=@Asc  then a.Id end asc,
					case when @Order=N'id'   and @Dir=@Desc then a.Id end desc,
					case when @Order=N'name' and @Dir=@Asc  then a.[Name] end asc,
					case when @Order=N'name' and @Dir=@Desc then a.[Name] end desc,
					case when @Order=N'code' and @Dir=@Asc  then a.Code end asc,
					case when @Order=N'code' and @Dir=@Desc then a.Code end desc,
					case when @Order=N'memo' and @Dir=@Asc  then a.Memo end asc,
					case when @Order=N'memo' and @Dir=@Desc then a.Memo end desc
			)
			from a2v10sample.Agents a where Folder=0 and Parent=@Parent
	)
	select [Result!TResult!Object] = null, T.Id, RowNo = T.RowNumber - 1 /*row_number is 1-based*/
	from T
	where T.Id = @Id;
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

	select [Product!TProduct!Object] = null, [Id!!Id] = p.Id, BarCode, p.[Name], Article, Memo,
		[Picture.Id!TPicture!Id] = p.Picture, [Picture.Token!TPicture!Token] = i.AccessKey
	from a2v10sample.Products p
		left join a2v10sample.Images i on p.Picture = i.Id
	where p.Id = @Id;
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

	merge a2v10sample.Products as t
	using @Product as s
	on (t.Id = s.Id)
	when matched then update set 
		t.[Name] = s.[Name],
		t.Article = s.Article,
		t.BarCode = s.BarCode,
		t.Memo = s.Memo,
		t.Picture = s.[Picture]
	when not matched by target then
	insert([Name], Article, BarCode, Memo, Picture)
	values ([Name], Article, BarCode, Memo, s.Picture)
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
create or alter procedure a2v10sample.[Product.Picture.Load]
@UserId bigint,
@Id bigint,
@Key nvarchar(255) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	select Mime, Stream = [Data], [Name], BlobName, Token=AccessKey from a2v10sample.Images where Id=@Id;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Product.Picture.Update]
@UserId bigint,
@Id bigint,
@Mime nvarchar(255),
@Name nvarchar(255),
@Stream varbinary(max),
@RetId bigint output
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @rtable table (Id bigint);
	
	insert into a2v10sample.Images([Name], Mime, [Data])
		output inserted.Id into @rtable
	values(@Name, @Mime, @Stream);

	select @RetId = Id from @rtable;
	select [Id], Token=AccessKey from a2v10sample.[Images] where Id=@RetId;
end
go



drop procedure if exists a2v10sample.[Product.Import.Update];
go
drop type if exists a2v10sample.[Product.Import.TableType]
go
------------------------------------------------
create type a2v10sample.[Product.Import.TableType] as table
(
	RowNumber int,
	[Код] nvarchar(255),
	[Наименование] nvarchar(255),
	[Артикул] nvarchar(255),
	[Штрих-код] nvarchar(255),
	[Примечание] nvarchar(255)
);
go
------------------------------------------------
create or alter procedure a2v10sample.[Product.Import.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Rows a2v10sample.[Product.Import.TableType];
	select [Rows!Rows!Metadata] = null, * from @Rows;
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Product.Import.Update]
@UserId bigint,
@Rows a2v10sample.[Product.Import.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	declare @outtable table([action] nvarchar(10));
	merge a2v10sample.Products as t
	using @Rows as s
	on t.ExternalCode = s.[Код]
	when matched then update set
		[Name] = s.[Наименование],
		[Article] = s.[Артикул],
		[BarCode] = s.[Штрих-код],
		[Memo] = s.[Примечание]
	when not matched by target then insert
		(ExternalCode, [Name], [Article], [BarCode], [Memo]) values
		(s.[Код], s.[Наименование], [Артикул], [Штрих-код], [Примечание])
	output $action into @outtable([action]);

	select [Result!TResult!Object] = null,
		Inserted = (select count(*) from @outtable where [action] = N'INSERT'),
		Updated = (select count(*) from @outtable where [action] = N'UPDATE');
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
	set transaction isolation level read committed;
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

	exec a2v10sample.[Document.Load] @UserId, @RetId;
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
	set transaction isolation level read committed;

	begin tran
	delete from a2v10sample.DocDetails where Document = @Id;
	delete from a2v10sample.Documents where Id=@Id;
	commit tran;
end
go
