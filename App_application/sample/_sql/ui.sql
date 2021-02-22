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
