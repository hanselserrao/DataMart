USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_docsearch]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_docsearch](@docnumber nvarchar(max),@docname nvarchar(max),@legacyitemnumber nvarchar(max),@docstatus int,@legacydocnumber nvarchar(max),@doctype int, @PartDescription nvarchar(max), @count int)
as begin
IF (CHARINDEX('*', @docnumber ) > 0 OR CHARINDEX('*', @docname ) > 0 OR CHARINDEX('*', @legacyitemnumber ) > 0 OR CHARINDEX('*', @docstatus ) > 0 OR CHARINDEX('*', @legacydocnumber ) > 0 OR CHARINDEX('*', @doctype ) > 0 OR CHARINDEX('*', @PartDescription ) > 0)
begin
	select  distinct top (@count) drawingid,items.iid, drawing_revision as docrevision,items.itemid,items.itemname,
	ISNULL(erp_part_description, items.description) as description,items.revision,items.site,dcoid=(op2.name),
	--items.length,items.width,items.height,items.weight,
		items.datereleased,items.legacy_part_number,opw.name as doctype,itemdt.datasetdesc as docdesc,
		items.legacy_document_number,op.name as itemtype,op1.name  as status ,itemdt.datasetname as docname,itemdt.pfile_name as fileurl, opw_dsettype.name as dataset
	into #document
	from items 
	left join options op on op.oid=items.itemtype and op.[categoryid]='1'  
	left join options op1 on op1.oid=items.itemstatus  and op1.categoryid='2' 
	left join   options op2 on op2.oid=items.dcoid  and op2.categoryid='5' 
	inner join [dbo].[itemreport_dataset] itemdt on itemdt.iid=items.iid 
	left join options opw on opw.oid=itemdt.documenttype
	left join options opw_dsettype on opw_dsettype.oid=itemdt.datasettype
	where items.status=0 and itemdt.status = 0 and
	((SELECT REPLACE(REPLACE(drawingid, CHAR(13), ''), CHAR(10), '')) LIKE (select REPLACE(@docnumber,'*','%'))  or @docnumber=''  or @docnumber is null) and 
	([legacy_part_number]  LIKE (select REPLACE(@legacyitemnumber,'*','%'))   or @legacyitemnumber='' or @legacyitemnumber is null) and 
	([itemstatus]  LIKE (select REPLACE(@docstatus,'*','%'))  or @docstatus=''  or @docstatus is null) and 
	(itemdt.datasetdesc LIKE (select REPLACE(@docname,'*','%'))  or @docname='' or @docname is null) and 
	([legacy_document_number]  LIKE (select REPLACE(@legacydocnumber,'*','%'))  or @legacydocnumber='' or @legacydocnumber is null) and 
	([erp_part_description] LIKE (select REPLACE(@PartDescription,'*','%')) or items.description LIKE (select REPLACE(@PartDescription,'*','%')) or @PartDescription='' or @PartDescription is null) and
	(itemdt.documenttype LIKE (select REPLACE(@doctype,'*','%'))  or @doctype ='' or @doctype is null) order by items.drawingid , items.revision

	select distinct drawingid, iid, description, itemtype, docrevision, itemid,  datereleased, status, itemname, revision, site, legacy_part_number, legacy_document_number  --itemname,  revision, site, legacy_part_number, legacy_document_number, 
	from #document;

	select distinct drawingid, iid, docname, doctype, docdesc, dataset, isnull(fileurl,'') fileurl, status 
	,case when (dataset in ('Non DetailedPDF','ZIP','SKP','MISC') and (parsename(fileurl,1) in  ('pdf','zip','skp','stp'))) then 'N'
	 else 'Y'
	 end Secured
	from #document;
	
end
else
begin
	select  distinct top (@count) drawingid,items.iid, drawing_revision as docrevision,items.itemid,items.itemname,
	ISNULL(erp_part_description, items.description) as description,items.revision,items.site,dcoid=(op2.name),
	--items.length,items.width,items.height,items.weight,
	items.datereleased,items.legacy_part_number,opw.name as doctype,itemdt.datasetdesc as docdesc,
	items.legacy_document_number,op.name as itemtype,op1.name  as status ,itemdt.datasetname as docname,itemdt.pfile_name as fileurl, opw_dsettype.name as dataset
	into #document1
	from items 
	left join options op on op.oid=items.itemtype and op.[categoryid]='1'    
	left join options op1 on op1.oid=items.itemstatus   and op1.categoryid='2'
	left join   options op2 on op2.oid=items.dcoid  and op2.categoryid='5' 
	 --left join items_doc_references dcoref on dcoref.idriid=items.iid
	 inner join [dbo].[itemreport_dataset] itemdt on itemdt.iid=items.iid 
	  left join options opw on opw.oid=itemdt.documenttype
	  left join options opw_dsettype on opw_dsettype.oid=itemdt.datasettype
	  where items.status=0 and itemdt.status = 0 and
	((drawingid in (SELECT value FROM strlist_to_tbl(@docnumber))) or @docnumber=''  or @docnumber is null) and 
	([legacy_part_number] =@legacyitemnumber  or @legacyitemnumber='' or @legacyitemnumber is null) and 
	([itemstatus] =@docstatus or @docstatus=''  or @docstatus is null) and 
	(itemdt.datasetdesc =@docname or @docname='' or @docname is null) and 
	([legacy_document_number] =@legacydocnumber or @legacydocnumber='' or @legacydocnumber is null) and 
	([erp_part_description] =@PartDescription or [items].description =@PartDescription or @PartDescription='' or @PartDescription is null) and
	(itemdt.documenttype =@doctype or @doctype ='' or @doctype is null) order by items.drawingid , items.revision

	select distinct drawingid, iid, description, itemtype, docrevision, itemid,  datereleased, status, itemname, revision, site, legacy_part_number, legacy_document_number  --itemname,  revision, site, legacy_part_number, legacy_document_number, 
	from #document1;

	select distinct drawingid, iid, docname, doctype, docdesc, dataset, isnull(fileurl,'') fileurl, status 
	,case when (dataset in ('Non DetailedPDF','ZIP','SKP','MISC') and (parsename(fileurl,1) in  ('pdf','zip','skp','stp'))) then 'N'
	 else 'Y'
	 end Secured
	from #document1;

end
end
GO
