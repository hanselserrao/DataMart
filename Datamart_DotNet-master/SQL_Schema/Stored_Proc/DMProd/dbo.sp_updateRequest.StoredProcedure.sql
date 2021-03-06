USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_updateRequest]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_updateRequest] (@amrid int, @status varchar(1))
AS
BEGIN
	BEGIN TRY
		declare @temp_status varchar(100)
		declare @requeststatus int

		set @temp_status = case @status
			when 'N' then 'New'
			when 'P' then 'Processing'
			when 'S' then 'Submitted'
			when 'C' then 'Completed'
			when 'X' then 'Cancelled'
			when 'E' then 'Error'
			else '0'
		end
		select 	@requeststatus = oid from dbo.options where name = @temp_status and categoryid=9

		update [dbo].[amr_request] set request_status = @requeststatus, date_modified = getdate(), modified_by=-1
		where amr_id = @amrid

		SELECT 0 AS ErrorNumber, 'Request updated successfully' AS ErrorMessage;
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
