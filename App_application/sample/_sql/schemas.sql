------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'a2v10sample')
begin
	exec sp_executesql N'create schema a2v10sample';
end
go
