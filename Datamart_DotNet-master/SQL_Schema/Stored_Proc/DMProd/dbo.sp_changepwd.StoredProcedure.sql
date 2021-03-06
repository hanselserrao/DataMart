USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_changepwd]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_changepwd] (@email nvarchar(max), @newpassword varchar(max))
AS
BEGIN
	BEGIN TRY
		update [dbo].[users] set password = CONVERT(varbinary(max), ISNULL(@newpassword, ''))
		where email = @email;

		SELECT 0 AS ErrorNumber, 'Password Changed Successfully' AS ErrorMessage;
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
