USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[searchleddetail]    Script Date: 06/24/2019 17:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[searchleddetail](@partid bigint)
as begin


select distinct(it.iid),it.LEDItemID as itemid,it.toolname as itemname,it.description,it.revision,it.drawingid,it.site,dcoid=(op2.name),it.length,it.width,it.height,op.name as itemtype,op1.name,
doc.document_itemid,doc.status as docstatus,opw.name as doctype, doc.document_itemid,itemdt.datasetdesc as docdesc,
 pcn.pcnid,pcn.revision as pcnrevision,pcn.synopsis,pcn.description as pcndescription,problemitem_iid=(select top 1 items.drawingid   from items
  left join  pcnitem_report pcnitem  on pcnitem.problemitem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid  and items.iid=@partid), solutionitem_iid=(select top 1 led_ir.drawingid  from led_ir
  left join  pcnitem_report pcnitem  on pcnitem.solutionitem_iid=led_ir.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid and led_ir.iid=@partid),
  impacteditem_iid=( select top 1 items.drawingid  from items
  left join  pcnitem_report pcnitem  on pcnitem.impacteditem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid  and items.iid=@partid),

  problemitem_revision=(select top 1 items.drawingid   from items
  left join  pcnitem_report pcnitem  on pcnitem.problemitem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid  and items.iid=@partid), solutionitem_revision=(select top 1 items.drawingid  from items
  left join  pcnitem_report pcnitem  on pcnitem.solutionitem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid and items.iid=@partid),
  impacteditem_revision=( select top 1 items.drawingid  from items
  left join  pcnitem_report pcnitem  on pcnitem.impacteditem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid  and items.iid=@partid),

  eto.etoid as etonumber,eto.projectname,eto.weirorderno as ordernumber, eto.customer,etohas.hasga_itemid as ga
  ,etohasdoc.hasdocument_itemid  as document,etohasroute.hasrouting_itemid as routing,etoorder.orderparts_itemid as docpart, etoref.references_itemid as ref
  
  
   from led_ir it  left join options op on op.oid=it.tooltype 
  left join options op1 on op1.oid=it.toolstatus
 left join  options op2 on op2.oid=it.iid and op2.categoryid='5'
 left join [dbo].[itemreport_dataset] itemdt on itemdt.bid=it.iid left join options opw on opw.oid=itemdt.documenttype
left join items_doc_references doc on doc.iid=it.iid left join documentitems_subtype docitem on docitem.itemid=it.LEDItemID 
left join pcnitem_report pcitre on pcitre.pid=it.iid left join pcn_report pcn on pcn.pid= pcitre.pid
left join etoitem_report etoitre on etoitre.eid=it.iid left join eto_report eto on eto.eid= etoitre.eid  
left join  [dbo].[eto_hasgadrawing] etohas on etohas.etoeid=etoitre.hasgadrwng_iid 
left join  [dbo].[eto_hasrouting] etohasroute on etohasroute.etoeid=etoitre.hasrouting
left join  [dbo].[eto_hasdocument] etohasdoc on etohasdoc.etoeid=etoitre.hasdocument_iid
left join  [dbo].[eto_orderparts] etoorder on etoorder.etorelid=etoitre.orderparts_iid
left join  [dbo].[eto_references] etoref on etoref.etoeid=eto.eid
where it.iid=@partid

end
GO
