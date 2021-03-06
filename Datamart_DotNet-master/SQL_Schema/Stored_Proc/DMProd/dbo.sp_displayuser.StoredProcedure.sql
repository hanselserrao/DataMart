USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_displayuser]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_displayuser] (@userID nvarchar(max), @email nvarchar(max), @userName nvarchar(max), @userRole nvarchar(max))
AS
BEGIN
	select (first_name + ' ' + last_name) username , email, userRole,
	case when [users].status = 1 then 'active' else 'Inactive' end as status, 
	isnull(username,'') as userId 
	from [dbo].[users]
	--inner join [dbo].[usertype] on [users].utype = [usertype].utid
	left join 
	(
		select uid, stuff((
						select ',' + [usertype].name 
						from [dbo].[userrole] 
						inner join [dbo].[usertype] on userrole.utid = [usertype].utid 
						where mainrole.uid = [userrole].uid and  enabled='Y'
						order by [usertype].name 
						for xml path('')
					),1,1,'') as userRole
		from [dbo].[userrole] mainrole
		where ((mainrole.utid in (SELECT number FROM intlist_to_tbl(@userRole)))  or (isnull(@userRole,'0')  = '0')) 
		group by mainrole.uid
	) user_role on [users].uid = user_role.uid

	where ((username like replace(@userID,'*','%'))  or (isnull(@userID,'')  = '')) and
	((email like replace(@email,'*','%'))  or (isnull(@email,'')  = '')) and
	(((first_name + ' ' + last_name) like replace(@userName,'*','%'))  or (isnull(@userName,'')  = ''))
	

END
GO
