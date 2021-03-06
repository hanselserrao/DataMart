USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[searchdocdetail]    Script Date: 06/24/2019 17:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[searchdocdetail](@partid bigint)
as begin


select distinct(it.iid),it.itemid,it.itemname,it.description,it.revision,it.drawingid,it.site,dcoid=(op2.description),it.length,it.width,it.height,it.weight,it.datereleased,it.legacy_part_number,it.legacy_document_number,op.name as itemtype,op1.name,
doc.document_itemid,doc.status as docstatus,docitem.subtype as doctype, doc.document_itemid,
 pcn.pcnid,pcn.revision as pcnrevision,pcn.synopsis,pcn.description as pcndescription,pcitre.problemitem_iid, pcitre.solutionitem_iid, pcitre.impacteditem_iid from items it  left join options op on op.oid=it.itemtype  join options op1 on op1.oid=it.itemstatus
 left join   options op2 on op2.oid=it.dcoid and op2.categoryid='6'
left join items_doc_references doc on doc.iid=it.iid left join documentitems_subtype docitem on docitem.itemid=it.itemid 
left join pcnitem_report pcitre on pcitre.pid=it.iid left join pcn_report pcn on pcn.pid= pcitre.pid
--left join etoitem_report etoitre on etoitre.eid=it.iid join eto_report eto on eto.eid= etoitre.eid  
--join  [dbo].[eto_hasgadrawing] etohas on etohas.hasga_drawingid=etoitre.hasgadrwng_iid 
--join  [dbo].[eto_hasrouting] etohasroute on etohasroute.hasrouting_itemid=etoitre.hasrouting
--join  [dbo].[eto_orderparts] etoorder on etoorder.orderparts_itemid=etoitre.orderparts_iid

where it.iid=@partid

end
GO
