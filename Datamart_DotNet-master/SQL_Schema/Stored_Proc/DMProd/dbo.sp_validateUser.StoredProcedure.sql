USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_validateUser]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_validateUser](@Email nvarchar(max))
AS
BEGIN
-- [sp_validateUser] 'kamlesh@akscellenceinfo.com'
	select email, password, userRole, [users].status from [dbo].[users]
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
		group by mainrole.uid
	) user_role on [users].uid = user_role.uid
	where email = @Email;
END
GO
