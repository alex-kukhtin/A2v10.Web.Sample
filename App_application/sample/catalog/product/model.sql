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


