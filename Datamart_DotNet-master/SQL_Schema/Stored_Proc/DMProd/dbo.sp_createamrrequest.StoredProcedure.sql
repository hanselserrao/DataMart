USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_createamrrequest]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_createamrrequest] (@amr_type_id int, @requested_by nvarchar(max), @status int, @item_no nvarchar(max),  @part_description nvarchar(max), @new_material_code nvarchar(max), @existing_material_code nvarchar(max), @request_no nvarchar(max), @drawing_no nvarchar(max), @drawing_rev_no nvarchar(max), @site int, @priority int, @dco int, @due_date nvarchar(max), @casting_requested int, @productid int, @file_path nvarchar(max), @remarks nvarchar(max))
AS
BEGIN
	-- [sp_displayamrrequest] 0, null,0, null, null, null,null
	Declare @amr_name nvarchar(max);

	BEGIN TRY
		select @amr_name = name from options where oid = @amr_type_id

		if exists(select amr_type_id from [dbo].[amr_request], dbo.options where [amr_request].request_status=options.oid 
					and item_no = @item_no and options.name not in ('Error','Cancelled')) 
		begin

			SELECT 1 AS ErrorNumber, @amr_name + ' for this Part Number already submitted. Please verify item no' AS ErrorMessage;
		end
		else if exists(select itemid from [dbo].[items] where itemid = @item_no) 
		begin
			SELECT 1 AS ErrorNumber, 'Part Number submitted in ('+ @amr_name +') already exist and active. Please check in Part Search' AS ErrorMessage;
		end
		else
		begin
			if @status = 0 set @status = null;
			if @site = 0 set @site = null;
			if @priority = 0 set @priority = null;
			if @dco = 0 set @dco = null;
			if @productid = 0 set @productid = null;
			--declare @userid int;
			--select 	@userid = uid from dbo.users where email = @requested_by

			declare @request_status int;
			select 	@request_status = oid from dbo.options where name = 'New' and categoryid=9

			insert into [dbo].[amr_request]
			(amr_type_id, requestor_email, status, item_no, request_no, new_material_code, existing_material_code, drawing_no, 
			part_description, site, priority, dco, due_date, drawing_rev_no, casting_requested, request_status, productid, file_path,remarks)
			values 
			(@amr_type_id, @requested_by, @status, @item_no, @request_no, @new_material_code, @existing_material_code, @drawing_no, 
			@part_description, @site, @priority, @dco, @due_date, @drawing_rev_no, @casting_requested, @request_status, @productid, @file_path,@remarks)


			SELECT 0 AS ErrorNumber, @amr_name + ' submitted successfully' AS ErrorMessage;
		end
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
