------------------------------------------------
create or alter procedure a2v10sample.[Document.Index]
@UserId bigint,
@Kind nvarchar(32)
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Documents!TDocument!Array] = null, [Id!!Id] = Id, [Date], [No], [Sum], [Memo], DateCreated,
		[Agent!TAgent!RefId] = Agent
	from a2v10sample.Documents 
	where [Kind] = @Kind;

	select [!TAgent!Map] = null, [Id!!Id] = a.Id, [Name], a.Memo, a.Phone, a.EMail
	from a2v10sample.Agents a inner join a2v10sample.Documents d on d.Agent = a.Id
	where a.Id in (select Agent from a2v10sample.Documents);

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
	set transaction isolation level read uncommitted;

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
create or alter procedure a2v10sample.[Document.Load.Export]
@UserId bigint,
@Id bigint = null,
@Kind nvarchar(32) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	exec a2v10sample.[Document.Load] @UserId = @UserId, @Id = @Id, @Kind = @Kind;
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