drop procedure if exists a2v10sample.[Product.Import.Update];
go
drop type if exists a2v10sample.[Product.Import.TableType]
go
------------------------------------------------
create type a2v10sample.[Product.Import.TableType] as table
(
	RowNumber int,
	[���] nvarchar(255),
	[������������] nvarchar(255),
	[�������] nvarchar(255),
	[�����-���] nvarchar(255),
	[����������] nvarchar(255)
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

	merge a2v10sample.Products as t
	using @Rows as s
	on t.ExternalCode = s.[���]
	when matched then update set
		[Name] = s.[������������],
		[Article] = s.[�������]
	when not matched by target then insert
		(ExternalCode, [Name], [Article], [BarCode], [Memo]) values
		(s.[���], s.[������������], [�����-���], [����������])
	output inserted.[ACTION] into @out


	select [Result!TResult!Object] = null
end
go
