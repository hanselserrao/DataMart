USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[User_Data_Insert]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[User_Data_Insert] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET IDENTITY_INSERT [usertype] on
insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (1, 'RegularUser', 'Premissions Restricted', 1, Getdate(), 1, Getdate(), 1)

insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (2,'Admin', 'Full Premissions', 1, Getdate(), 1, Getdate(), 1)

insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (3,'AMRUser', 'Create Problem Report', 1, Getdate(), 1, Getdate(), 1)

SET IDENTITY_INSERT [usertype] off

update [dbo].[users] set utype=2, status=1 where email = 'admin@admin.com';


---------- insert data in role table ------------
TRUNCATE TABLE [dbo].[userrole] 
insert into [dbo].[userrole] (uid, utid, enabled, createdon, createdby) 
select uid, isnull(utype,1), 'Y', GETDATE(), 1 from [dbo].[users]
update [dbo].[userrole] set utid=2 where uid = (select uid from [dbo].[users]  where email = 'admin@admin.com');


SET IDENTITY_INSERT category on
TRUNCATE TABLE [dbo].[category]
-------------------- insert record in category table --------------------------------
insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (8, 'AMRType', 'AMR Type', 1, 1,getdate(), 1, getdate());

insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (9, 'AMRStatus', 'AMR Status', 1, 1,getdate(), 1, getdate());

insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (10, 'site', 'site', 1, 1,getdate(), 1, getdate());

insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (11, 'priority', 'priority', 1, 1,getdate(), 1, getdate());

insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (12, 'dco', 'dco', 1, 1,getdate(), 1, getdate());

SET IDENTITY_INSERT category off
DELETE FROM [dbo].[options] where categoryid = 8;
select * from [dbo].[options] where categoryid = 8;
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('AMR Request', 'AMR Request', 1, 1, getdate(), 1, getdate(), 8)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Data Issue', 'Data Issue', 1, 1, getdate(), 1, getdate(), 8)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Request For Basic Data', 'Request For Basic Data', 1, 1, getdate(), 1, getdate(), 8)

DELETE FROM [dbo].[options] where categoryid = 9;
select * from [dbo].[options] where categoryid = 9;
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('New', 'New', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Processing', 'Processing', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Submitted', 'Submitted', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Cancelled', 'Cancelled', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Completed', 'Completed', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Error', 'Error', 1, 1, getdate(), 1, getdate(), 9)

DELETE FROM [dbo].[options] where categoryid = 10;
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
select distinct site, site, 1,1,getdate(), 1, getdate(), 10 from [dbo].[items]

DELETE FROM [dbo].[options] where categoryid = 11;
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Low', 'Low', 1, 1, getdate(), 1, getdate(), 11)

insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Medium', 'Medium', 1, 1, getdate(), 1, getdate(), 11)

insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('High', 'High', 1, 1, getdate(), 1, getdate(), 11)


	
END
GO
