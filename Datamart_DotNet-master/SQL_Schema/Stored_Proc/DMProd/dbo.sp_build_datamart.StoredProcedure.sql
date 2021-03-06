USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_build_datamart]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_build_datamart]
as begin
	truncate table datamart_search;

	insert into dbo.datamart_search
	select  distinct 'ITEMS' as 'itemtype', items.iid as 'itemid', items.itemid + ISNULL(items.itemname,'') + ISNULL(erp_part_description, ISNULL(items.description,'')) + 
	ISNULL(items.revision,'') + ISNULL(items.drawingid,'') + ISNULL(items.site,'') + ISNULL(op2.name,'') + ISNULL(items.datereleased,'')  + 
	ISNULL(items.legacy_part_number,'') + ISNULL(items.legacy_document_number,'') + ISNULL(op.name,'')  + 
	ISNULL(op1.name,'') + ISNULL(itemdoc.document_itemid,'') as 'itemdata'
	from items left join options op on op.oid=items.itemtype and op.categoryid = '1'
	left join options op1 on op1.oid=items.itemstatus  
	left join   options op2 on op2.oid=items.dcoid and op2.categoryid='5'
	left join 
	(
	select iid, stuff((
						select ',' + ref.document_itemid 
						from items_doc_references ref 
						where ref.iid=mainitem.iid 
						order by ref.document_itemid 
						for xml path('')
					),1,1,'') as document_itemid
	from items_doc_references mainitem
	group by iid
	) itemdoc on items.iid=itemdoc.iid where items.status=0  and  op.description not in ('DocumentRevision','Drawing Item Revision')

	insert into dbo.datamart_search
	select  distinct 'DOCUMENT' AS 'itemtype', items.iid as 'itemid', ISNULL(drawingid,'') + ISNULL(drawing_revision,'') + 
	ISNULL(items.itemid,'') + ISNULL(items.itemname,'') + ISNULL(erp_part_description, ISNULL(items.description,'')) + 
	ISNULL(items.revision,'') + ISNULL(items.site,'') + ISNULL(op2.name,'') +
	ISNULL(items.datereleased,'') + ISNULL(items.legacy_part_number,'') + ISNULL(opw.name,'') + ISNULL(itemdt.datasetdesc,'') 
	+ ISNULL(items.legacy_document_number,'') + ISNULL(op.name,'') + ISNULL(op1.name,'') + ISNULL(itemdt.datasetname,'') + 
	ISNULL(itemdt.pfile_name,'') + ISNULL(opw.description,'') as 'itemdata'
	from items 
	left join options op on op.oid=items.itemtype  
	left join options op1 on op1.oid=items.itemstatus  
	left join   options op2 on op2.oid=items.dcoid  and  op2.categoryid='5' 
	inner join [dbo].[itemreport_dataset] itemdt on itemdt.iid=items.iid 
	left join options opw on opw.oid=itemdt.documenttype
	where  drawingid !='' and items.status=0 and itemdt.status = 0 

	insert into dbo.datamart_search
	select distinct 'LED' AS 'itemtype', [led_ir].iid as 'itemid', 
		ISNULL(LEDItemID,'')  + ISNULL(revision,'')  + ISNULL([led_ir].description,'') 
	 + CAST(ISNULL(wll,0) AS varchar)  + CAST(ISNULL(tare,0) AS varchar) + ISNULL(dco,'')  + ISNULL(drawingid,'')  + ISNULL(led_ir.[site],'') 
	 + ISNULL(op.name,'')  + ISNULL(op1.name,'')  + CAST(ISNULL(height,0) AS varchar) + CAST(ISNULL(width,0) AS varchar) + CAST(ISNULL(length,0) AS varchar) 
	 + ISNULL(led_ir.toolname,'') + ISNULL(partname,'')  + ISNULL(productname,'')  + ISNULL(ledcer1.docname,'')  + ISNULL(ledcer.docname,'')  as 'itemdata'
	from led_ir left join options op on led_ir.tooltype =op.oid
	left join options op1 on led_ir.toolstatus =op1.oid
	left join 
	(
	select toolid, stuff((
						select ',' + ref.partname 
						from led_support_part ref 
						where ref.toolid=mainitem.toolid 
						order by ref.toolid 
						for xml path('')
					),1,1,'') as partname
	from led_support_part mainitem
	group by toolid
	) part on led_ir.iid = part.toolid 
	left join 
	(
	select toolid, stuff((
						select ',' + ref.productname 
						from led_support_products ref 
						where ref.toolid=mainitem.toolid 
						order by ref.toolid 
						for xml path('')
					),1,1,'') as productname
	from led_support_products mainitem
	group by toolid
	) product on led_ir.iid =product.toolid
	left join 
	(
	select toolid, stuff((
						select ',' + ref.docname 
						from led_iom_certificate ref 
						where ref.toolid=mainitem.toolid and ref.docrefid='2'
						order by ref.docname 
						for xml path('')
					),1,1,'') as docname
	from led_iom_certificate mainitem where mainitem.docrefid='2'
	group by toolid
	) ledcer on led_ir.iid =ledcer.toolid  
	left join 
	(
	select toolid, stuff((
						select ',' + ref.docname 
						from led_iom_certificate ref 
						where ref.toolid=mainitem.toolid and ref.docrefid='1'
						order by ref.docname 
						for xml path('')
					),1,1,'') as docname
	from led_iom_certificate mainitem where mainitem.docrefid='1'
	group by toolid
	) ledcer1 on led_ir.iid =ledcer1.toolid  


	insert into dbo.datamart_search
	select distinct 'PCN' AS 'itemtype', pcn_report.pid as 'itemid',
		ISNULL(pcn_report.pcnid, '') + ISNULL(pcn_report.description,'')
	    + ISNULL(pcn_report.synopsis,'') + ISNULL(pcn_report.revision,'') + ISNULL(impacteditem_iid,'') 
		+ ISNULL(solutionitem_iid,'') + ISNULL(problemitem_iid,'')  as 'itemdata'
	from pcn_report
	left join 
	(
	select pid, stuff((
						select ',' + (items.itemid  + '/'+ items.revision) 
						from pcn_impacteditem ref
						inner join items on ref.impacteditem_iid = items.iid
						where ref.pid=mainitem.pid 
						order by items.itemid
						for xml path('')
					),1,1,'') as impacteditem_iid
	from pcn_impacteditem mainitem
	group by pid
	) pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
	left join 
	(
	select pid, stuff((
						select ',' + (items.itemid  + '/'+ items.revision) 
						from pcn_solutionitem ref
						inner join items on ref.solutionitem_iid = items.iid
						where ref.pid=mainitem.pid 
						order by items.itemid
						for xml path('')
					),1,1,'') as solutionitem_iid
	from pcn_solutionitem mainitem
	group by pid
	) pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
	left join 
	(
	select pid, stuff((
						select ',' + (items.itemid  + '/'+ items.revision) 
						from pcn_problemitem ref
						inner join items on ref.problemitem_iid = items.iid
						where ref.pid=mainitem.pid 
						order by items.itemid
						for xml path('')
					),1,1,'') as problemitem_iid
	from pcn_problemitem mainitem
	group by pid
	) pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 


	insert into dbo.datamart_search
	select distinct 'ETO' AS 'itemtype', e.eid as 'itemid',
		ISNULL(e.etoid,'') + ISNULL(e.projectname,'') + ISNULL(e.weirorderno,'') + ISNULL(e.customer,'') + ISNULL(e.revision,'') 
		+ ISNULL(gadrawingref,'') + ISNULL(documentref,'') + ISNULL(orderpartref,'') + ISNULL(referenceref,'')
		from eto_report e 
		left join 
		(
		select etoeid, stuff((
							select ',' + (gadrawings.itemid  + '/'+ gadrawings.revision) 
							from eto_hasgadrawing ref
							inner join items gadrawings on ref.hasga_iid = gadrawings.iid
							where ref.etoeid=mainitem.etoeid 
							order by gadrawings.itemid
							for xml path('')
						),1,1,'') as gadrawingref
		from eto_hasgadrawing mainitem
		group by etoeid
		) i on e.eid=i.etoeid 
		left join 
		(
		select etoeid, stuff((
							select ',' + (hasdocuments.itemid  + '/'+ hasdocuments.revision) 
							from eto_hasdocument ref
							inner join items hasdocuments on ref.hasdocument_iid = hasdocuments.iid
							where ref.etoeid=mainitem.etoeid 
							order by hasdocuments.itemid
							for xml path('')
						),1,1,'') as documentref
		from eto_hasdocument mainitem
		group by etoeid
		)  it on e.eid=it.etoeid 
		left join 
		(
		select etoeid, stuff((
							select ',' + (orderpart.itemid + '/'+ orderpart.revision) 
							from eto_orderparts ref
							inner join items orderpart on ref.orderparts_iid = orderpart.iid
							where ref.etoeid=mainitem.etoeid 
							order by orderpart.itemid
							for xml path('')
						),1,1,'') as orderpartref
		from eto_orderparts mainitem
		group by etoeid
		)  its on e.eid=its.etoeid 
		left join 
		(
		select etoeid, stuff((
							select ',' + (reference.itemid + '/'+ reference.revision) 
							from eto_references ref
							inner join items reference on ref.references_iid = reference.iid
							where ref.etoeid=mainitem.etoeid 
							order by reference.itemid
							for xml path('')
						),1,1,'') as referenceref
		from eto_references mainitem
		group by etoeid
		) itm on e.eid=itm.etoeid

end
GO
