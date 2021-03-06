USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_getrequest]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_getrequest] (@status varchar(1))
AS
BEGIN
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

	-- [sp_displayamrrequest] 0, null,0, null, null, null,null
	select amr_id as SystemId, op1.name as RequestType, requestor_email as RequestedBy, op2.name as Status, item_no as PartNo, request_no as RequestNo, 
	new_material_code as NewMaterialCode, REPLACE(CONVERT(CHAR(11), date_requested, 106),' ','-') as DateRequested, 
	existing_material_code as ExistingMaterialCode, drawing_no as DrawingNo, part_description as PartDescription, 
	op3.name as Site, op4.name as Priority,	op5.name as DCO,  REPLACE(CONVERT(CHAR(11), due_date, 106),' ','-') as DueDate, 
	drawing_rev_no as DrawingRevNo, case when casting_requested = 1 then 'Yes' else 'No' end as CastingRequested,
	productcode, remarks, file_path

	from [dbo].[amr_request]
	--inner join [dbo].[users] usr on usr.uid = requested_by
	inner join [dbo].[options] op1 on op1.oid = amr_type_id
	inner join [dbo].[options] op6 on op6.oid = amr_request.request_status
	left outer join [dbo].[options] op2 on op2.oid = amr_request.status
	left outer join [dbo].[options] op3 on op3.oid = amr_request.site
	left outer join [dbo].[options] op4 on op4.oid = amr_request.priority
	left outer join [dbo].[options] op5 on op5.oid = amr_request.dco
	left outer join [dbo].[product] on product.productid = [amr_request].productid
	where amr_request.request_status = @requeststatus
END
GO
