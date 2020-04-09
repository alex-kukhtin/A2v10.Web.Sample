------------------------------------------------
create or alter procedure a2v10sample.[Document.Index]
@UserId bigint,
@Kind nvarchar(32)
as
begin
	set nocount on;
	select [Documents!TDocument!Array] = null, [Id!!Id] = Id, [Date], [No], [Sum], [Memo], DateCreated
	from a2v10sample.Documents 
	where [Kind] = @Kind
end
go
------------------------------------------------
create or alter procedure a2v10sample.[Document.Load]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;

	select [Document!TDocument!Object] = null, [Id!!Id] = Id, [Date], [No], [Sum], [Memo], DateCreated,
	[Agent!TAgent!RefId] = Agent, [Rows!TRow!Array] = null
	from a2v10sample.Documents 
	where @Id = Id;

	select [!TRow!Array] = null, [Id!!Id] = dd.Id, [!TDocument.Rows!ParentId] = [Document], [Qty], Price, [Sum]
	from a2v10sample.DocDetails dd
	where Document = @Id
	order by [RowNo];

	select [!TAgent!Map] = null, [Id!!Id] = a.Id, [Name], a.Memo, a.Phone, a.EMail
	from a2v10sample.Agents a inner join a2v10sample.Documents d on d.Agent = a.Id
	where d.Id = @Id;

end
go


