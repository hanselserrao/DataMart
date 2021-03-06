USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_displayamrrequest]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_displayamrrequest] (@amr_type_id int, @requested_by nvarchar(max), @status int, @item_no nvarchar(max), @request_no nvarchar(max), @new_material_code nvarchar(max), @part_description nvarchar(max))
AS
BEGIN
	-- [sp_displayamrrequest] 0, null,0, null, null, null,null
	--exec [sp_displayamrrequest] '0','','0','','','',''
	--exec [sp_displayamrrequest] '0','kamlesh*','0','','','',''
	select amr_id, amr_type_id, op1.name as amr_type, requestor_email as requested_by, amr_request.status, op2.name as status_desc, 
	item_no, request_no, new_material_code, REPLACE(CONVERT(CHAR(11), date_requested, 106),' ','-') as date_requested, 
	existing_material_code, drawing_no, part_description, site, op3.name as site_desc, priority, op4.name as priority_desc ,
	dco, op5.name as dco_desc,  REPLACE(CONVERT(CHAR(11), due_date, 106),' ','-') as due_date,drawing_rev_no, 
	case when casting_requested = 1 then 'Yes' else 'No' end as casting_requested, 
	op6.name as request_status, [amr_request].productid, productcode, remarks, file_path
	from [dbo].[amr_request]
	--inner join [dbo].[users] usr on usr.uid = requested_by
	inner join [dbo].[options] op1 on op1.oid = amr_type_id
	inner join [dbo].[options] op6 on op6.oid = amr_request.request_status
	left outer join [dbo].[options] op2 on op2.oid = amr_request.status
	left outer join [dbo].[options] op3 on op3.oid = amr_request.site
	left outer join [dbo].[options] op4 on op4.oid = amr_request.priority
	left outer join [dbo].[options] op5 on op5.oid = amr_request.dco
	left outer join [dbo].[product] on product.productid = [amr_request].productid
	where ((amr_type_id = @amr_type_id)  or (isnull(@amr_type_id,0)  = 0)) and
	((requestor_email like replace(@requested_by,'*','%'))  or (isnull(@requested_by,'')  = '')) and
	((amr_request.request_status = @status)  or (isnull(@status,0)  = 0)) and
	((item_no like replace(@item_no,'*','%'))  or (isnull(@item_no,'')  = '')) and
	((request_no like replace(@request_no,'*','%'))  or (isnull(@request_no,'')  = '')) and
	((new_material_code like replace(@new_material_code,'*','%'))  or (isnull(@new_material_code,'')  = '')) and
	((part_description like replace(@part_description,'*','%'))  or (isnull(@part_description,'')  = '')) 
END
GO
