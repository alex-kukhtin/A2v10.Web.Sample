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

