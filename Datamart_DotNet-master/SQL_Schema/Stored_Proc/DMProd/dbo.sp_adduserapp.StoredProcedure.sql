USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_adduserapp]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_adduserapp](@userEmail nvarchar(max), @usrRole nvarchar(max), @firstName nvarchar(max), @lastName nvarchar(max), @userId nvarchar(max), @appPwd varchar(max), @userTitle nvarchar(max), @companyName nvarchar(max), @userPhone nvarchar(max), @userFax nvarchar(max))
AS
BEGIN
	BEGIN TRY
		DECLARE @uid int;
		if exists(select email from [dbo].[users] where email = @userEmail) 
		begin
			SELECT 1 AS ErrorNumber, 'Email Id already exists. Please choose new Email ID' AS ErrorMessage;
		end
		else
		begin
			insert into [dbo].[users] (email,utype,first_name,last_name,username,password,title,companyname,phone,fax,status)
			values (@userEmail,null,@firstName,@lastName,@userId,
			null, --CONVERT(varbinary(max), ISNULL(@appPwd, '')),
			@userTitle,@companyName,@userPhone,@userFax,1);
			set @uid = @@IDENTITY;
			insert into [dbo].[userrole] (uid, utid, enabled, createdon, createdby) 
				SELECT @uid, number, 'Y', GETDATE(), 1 FROM intlist_to_tbl(@usrRole)

			SELECT 0 AS ErrorNumber, 'User Added Successfully' AS ErrorMessage;
		end
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
