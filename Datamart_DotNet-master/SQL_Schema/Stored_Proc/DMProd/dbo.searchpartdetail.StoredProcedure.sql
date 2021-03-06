USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[searchpartdetail]    Script Date: 06/24/2019 17:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[searchpartdetail] 

@partid bigint = 0

as begin

	create table #mypcn 
					   (pcnid NVARCHAR(max) NULL,
						pcnrevision NVARCHAR(max) NULL,
						pcnsynopsis NVARCHAR(max) NULL,
						pcndescription NVARCHAR(max) NULL,
						problemid NVARCHAR(max) NULL,
						problemrev NVARCHAR(max) NULL,
						solutionid NVARCHAR(max) NULL,
						solutionrev NVARCHAR(max) NULL,
						impactedid NVARCHAR(max) NULL,
						impactedrev NVARCHAR(max) NULL);
					
	create table #myeto 
						(etoid NVARCHAR(max) NULL,
						etoproj NVARCHAR(max) NULL,
						etoorder NVARCHAR(max) NULL,
						etocustomer NVARCHAR(max) NULL,
						gaid NVARCHAR(max) NULL,
						docid NVARCHAR(max) NULL,
						routingid NVARCHAR(max) NULL,
						docpartid NVARCHAR(max) NULL,
						refid NVARCHAR(max) NULL);

	EXEC dbo.sp_modpcndetail @partid,null,null,null,null,null,null,null,null,null,null;

	EXEC dbo.sp_modetodetail @partid,null,null,null,null,null,null,null,null,null;


	select distinct (it.iid),it.itemid,it.itemname,ISNULL(it.erp_part_description,it.description) as description,it.revision,it.drawingid,it.site,
					dcoid=(op2.name),it.length,it.width,it.height,it.weight,it.datereleased,it.legacy_part_number,it.legacy_document_number,
					op.name as itemtype
	from items it
	left join options op on op.oid=it.itemtype  and op.categoryid = '1'
	left join  options op2 on op2.oid=it.dcoid and op2.categoryid='5'
	where it.iid=@partid;


	select it.drawingid, op1.name as docstatus,opw.name as doctype, itemdt.datasetdesc as docdesc 
	from items it  
	left join options op1 on it.itemstatus=op1.oid
	left join [dbo].[itemreport_dataset] itemdt on itemdt.iid=it.iid left join options opw on opw.oid=itemdt.documenttype and itemdt.status = 0 
	where it.iid=@partid;


	select mypcn.pcnid as pcnid, mypcn.pcnrevision as pcnrevision,mypcn.pcnsynopsis as pcnsynopsis,mypcn.pcndescription as pcndescription, mypcn.problemid as problemid,mypcn.problemrev as problemrev, mypcn.solutionid as solutionid,mypcn.solutionrev as solutionrev, mypcn.impactedid as impactedid, mypcn.impactedrev as impactedrev
	from #mypcn mypcn where mypcn.pcnid is not null;

	select myeto.etoid as etonumber,myeto.etoproj as projectName,myeto.etoorder as ordernumber, myeto.etocustomer as etocustomer,myeto.gaid as ga
	,myeto.docid  as document, myeto.docpartid as docpart, myeto.refid as ref --myeto.routingid as routing,
	from #myeto myeto where myeto.etoid is not null;
end
GO
