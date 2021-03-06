USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_partsearch]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_partsearch](@itemnumber nvarchar(max),@legacyitemnumber nvarchar(max),@itemstatus int,@docnumber nvarchar(max),@legacydocnumber nvarchar(max),@itemtype int,@PartDescription nvarchar(max),@count int)
as begin

IF (CHARINDEX('*', @itemnumber ) > 0 OR CHARINDEX('*', @legacyitemnumber ) > 0 OR CHARINDEX('*', @itemstatus ) > 0 OR CHARINDEX('*', @docnumber ) > 0 OR CHARINDEX('*', @legacydocnumber ) > 0 OR CHARINDEX('*', @PartDescription ) > 0 OR CHARINDEX('*', @itemtype ) > 0 )
begin
select  distinct top (@count) items.iid,items.itemid,items.itemname,ISNULL(erp_part_description, items.description) as description,
items.revision,items.drawingid,items.site,dcoid=(op2.name),
items.t4s_mm_status, items.t4s_dir_status,
items.length,items.width,items.height,items.weight,items.datereleased,items.legacy_part_number,
items.legacy_document_number,op.name as itemtype,op1.name ,itemdoc.document_itemid as reference
from items left join options op on op.oid=items.itemtype and op.categoryid = '1'
 left join options op1 on op1.oid=items.itemstatus  
left join   options op2 on op2.oid=items.dcoid and op2.categoryid='5'
left join 
(
select iid, stuff((
					select ',' + ref.document_itemid + '___'+ref.document_name  from
					(select distinct iid, document_itemid,document_name from items_doc_references) ref 
					where ref.iid=mainitem.iid 
					order by ref.document_itemid 
					for xml path('')
				),1,1,'') as document_itemid
from items_doc_references mainitem
group by iid
) itemdoc on items.iid=itemdoc.iid
  where items.status=0 and  op.description not in ('DocumentRevision','Drawing Item Revision') and 
((SELECT REPLACE(REPLACE(itemid, CHAR(13), ''), CHAR(10), '')) like  (select REPLACE(@itemnumber,'*','%')) or @itemnumber=''  or @itemnumber is null) and 
([legacy_part_number] LIKE (select REPLACE(@legacyitemnumber,'*','%'))  or @legacyitemnumber='' or @legacyitemnumber is null) and 
([itemstatus] = @itemstatus or @itemstatus=''  or @itemstatus is null) and 
(drawingid LIKE (select REPLACE(@docnumber,'*','%')) or @docnumber='' or @docnumber is null) and 
([legacy_document_number] LIKE (select REPLACE(@legacydocnumber,'*','%')) OR @legacydocnumber='' or @legacydocnumber is null) and 
([erp_part_description] LIKE (select REPLACE(@PartDescription,'*','%')) OR [items].description LIKE (select REPLACE(@PartDescription,'*','%')) OR @PartDescription='' or @PartDescription is null) and
 ([itemtype] =@itemtype or @itemtype ='' or @itemtype is null)
end
else
begin
select distinct top (@count) items.iid,items.itemid,items.itemname,ISNULL(erp_part_description, items.description) as description,items.revision,items.drawingid,items.site,dcoid=(op2.name),
items.length,items.width,items.height,items.weight,items.datereleased,items.legacy_part_number,
items.t4s_mm_status, items.t4s_dir_status,
items.legacy_document_number,op.name as itemtype,op1.name ,itemdoc.document_itemid as reference
from items left join options op on op.oid=items.itemtype and op.categoryid = '1'
 left join options op1 on op1.oid=items.itemstatus  
left join   options op2 on op2.oid=items.dcoid and op2.categoryid='5'
left join 
(
select iid, stuff((
					select ',' + ref.document_itemid + '___'+ref.document_name from
					(select distinct iid, document_itemid,document_name from items_doc_references) ref 
					where ref.iid=mainitem.iid 
					order by ref.document_itemid 
					for xml path('')
				),1,1,'') as document_itemid
from items_doc_references mainitem
group by iid
) itemdoc on items.iid=itemdoc.iid
  where items.status=0  and op.description not in ('DocumentRevision','Drawing Item Revision') and 
((itemid in (SELECT value FROM strlist_to_tbl(@itemnumber)))  or @itemnumber=''  or @itemnumber is null) and 
([legacy_part_number] =@legacyitemnumber  or @legacyitemnumber='' or @legacyitemnumber is null) and 
([itemstatus] =@itemstatus or @itemstatus=''  or @itemstatus is null) and 
(drawingid =@docnumber or @docnumber='' or @docnumber is null) and 
([legacy_document_number] =@legacydocnumber or @legacydocnumber='' or @legacydocnumber is null) and 
([erp_part_description] =@PartDescription or [items].description =@PartDescription or @PartDescription='' or @PartDescription is null) and
([itemtype] =@itemtype or @itemtype ='' or @itemtype is null)
end
end
GO
