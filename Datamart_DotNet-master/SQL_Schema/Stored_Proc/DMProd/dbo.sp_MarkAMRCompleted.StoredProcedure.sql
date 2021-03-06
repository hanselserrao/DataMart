USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_MarkAMRCompleted]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MarkAMRCompleted]
AS
BEGIN
	BEGIN TRY
		declare @completedstatus int
		declare @submittedstatus int
		declare @cancelledstatus int

		select 	@completedstatus = oid from dbo.options where name = 'Completed' and categoryid=9;
		select 	@submittedstatus = oid from dbo.options where name = 'Submitted' and categoryid=9;
		select 	@cancelledstatus = oid from dbo.options where name = 'Cancelled' and categoryid=9;

		update [dbo].[amr_request] set request_status = @completedstatus, date_modified = getdate(), modified_by=-1
		from [dbo].[amr_request] AMR
		inner join [dbo].[items] IT on IT.itemid = AMR.item_no
		where AMR.request_status <> @completedstatus;

		update [dbo].[amr_request] set request_status = @cancelledstatus, date_modified = getdate(), modified_by=-1
		from [dbo].[amr_request] AMR
		where AMR.request_status = @submittedstatus and date_requested <= getdate()-90;

		SELECT 0 AS ErrorNumber, 'Request updated successfully' AS ErrorMessage;
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
