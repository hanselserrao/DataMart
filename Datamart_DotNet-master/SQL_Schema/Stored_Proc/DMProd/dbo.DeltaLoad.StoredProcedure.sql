USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[DeltaLoad]    Script Date: 06/24/2019 17:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lokesh Podigiri
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[DeltaLoad] 
	
	
AS
BEGIN
SET NOCOUNT ON
 BEGIN TRY

    BEGIN TRANSACTION;
-- ETO NULL is being compared. Check for all the tables.

	--[dbo].[items]
	MERGE [dbo].[items] as Target
	USING (SELECT DISTINCT t1.[PART_NUMBER] AS part_num,t1.[PART_NUMBER],t1.[PART_DESCRIPTION],t1.[PART_REVISION],t2.DRAWING_NUMBER,t1.SITE,t6.oid AS dco_id,t1.WLENGTH,t1.WIDTH  ,t1.HEIGHT,t1.ENCUMBRANCE,t1.WEIGHT,t1.ERP_PART_NAME,t1.ERP_PART_DESC,t1.DATE_RELEASED  ,t2.DRAWING_REVISION,t3.LEGACY_PART_NUMBER,t3.LEGACY_DRAWING_NUMBER,t4.oid AS part_type,t5.oid AS part_status,t1.STATUS,t1.PUID,t1.T4S_MM_STATUS,t1.T4S_DIR_STATUS 
	FROM [DMProcessDB_Delta].[dbo].[LOAD_PARTREVISION] as t1 	
	LEFT OUTER JOIN [DMProcessDB_Delta].[dbo].LOAD_DOCUMENTNUMBER as t2 ON t1.PART_NUMBER=t2.PART_NUMBER and t1.PART_REVISION=t2.PART_REVISION and t1.SITE=t2.SITE 
	LEFT OUTER JOIN [DMProcessDB_Delta].[dbo].LOAD_ALT_ALIAS_ID as t3 ON t1.PART_NUMBER=t3.ITEM_ID AND  t1.SITE=t3.SITE 
	LEFT OUTER JOIN dbo.[options] as t6 ON t6.name=t1.DCO AND t6.status='1' and t6.categoryid='5' 
	LEFT OUTER JOIN  dbo.[options]  as t4 ON t4.description=t1.PART_TYPE AND t4.status='1' and t4.categoryid='1' 
	LEFT OUTER JOIN  dbo.[options]  as t5 ON t5.name=t1.RELEASE_STATUS AND t5.status='1' and t5.categoryid='2'
	WHERE t1.STATUS in (0,1)) AS Source	
	ON Source.[PART_NUMBER]=Target.itemid AND Source.[PART_REVISION]=Target.revision AND Source.PUID=Target.PUID
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([itemid],[itemname],[description],[revision],[drawingid],[site],[updatedrefid],[status],[dcoid],[length],[width],
			[height],[encumbrance],[weight],[erp_part_name],[erp_part_description],[datereleased],[drawing_revision],[legacy_part_number],
			[legacy_document_number],[itemtype],[itemstatus],createduser,lastmoduser,lastmoddtm,puid,t4s_mm_status,t4s_dir_status) 
	VALUES (Source.[PART_NUMBER],Source.[PART_NUMBER],Source.[PART_DESCRIPTION],Source.[PART_REVISION],Source.DRAWING_NUMBER,Source.SITE,'1',Source.STATUS,ISNULL(Source.dco_id,0),Source.WLENGTH,Source.WIDTH  
			,Source.HEIGHT,Source.ENCUMBRANCE,Source.WEIGHT,Source.ERP_PART_NAME,Source.ERP_PART_DESC,Source.DATE_RELEASED  ,	Source.DRAWING_REVISION,Source.LEGACY_PART_NUMBER,
			Source.LEGACY_DRAWING_NUMBER,Source.part_type,Source.part_status ,'2','2',GETDATE(),Source.puid,Source.T4S_MM_STATUS,Source.T4S_DIR_STATUS)
	WHEN MATCHED
	THEN
	UPDATE SET Target.[description]=Source.[PART_DESCRIPTION],Target.[drawingid]=Source.DRAWING_NUMBER,Target.[site]=Source.SITE,Target.[updatedrefid]='1',Target.[status]=Source.STATUS,Target.[dcoid]=ISNULL(Source.dco_id,0),Target.[length]=Source.WLENGTH,Target.[width]=Source.WIDTH ,
	Target.[height]=Source.HEIGHT,Target.[encumbrance]=Source.ENCUMBRANCE,Target.[weight]=Source.WEIGHT,Target.[erp_part_name]=Source.ERP_PART_NAME,Target.[erp_part_description]=Source.ERP_PART_DESC,Target.[datereleased]=Source.DATE_RELEASED,Target.[drawing_revision]=Source.DRAWING_REVISION,Target.[legacy_part_number]=Source.LEGACY_PART_NUMBER
	,Target.[legacy_document_number]=Source.LEGACY_DRAWING_NUMBER,Target.[itemtype]=Source.part_type,Target.[itemstatus]=Source.part_status,Target.lastmoduser='2',Target.lastmoddtm=GETDATE(),Target.T4S_MM_STATUS=Source.t4s_mm_status,Target.T4S_DIR_STATUS=Source.t4s_dir_status
	OUTPUT $action,deleted.*,inserted.*;
	
	-- [dbo].documentitems_subtype
	MERGE [dbo].documentitems_subtype AS Target
	USING (SELECT DISTINCT t2.ITEM_ID,t2.NAME,t2.SUB_TYPE,t2.SITE,t2.PUID FROM DMProcessDB_Delta.dbo.LOAD_DOCUMENT_SUBTYPE t2 WHERE STATUS='0') AS Source
	ON  Source.ITEM_ID=Target.itemid AND Source.PUID=Target.PUID
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([itemid],[name],[subtype],[status],puid,createduser,createddtm,lastmoduser,lastmoddtm,[site]) 
	VALUES (Source.ITEM_ID,Source.NAME,Source.SUB_TYPE,'1',Source.PUID,'2',GETDATE(),'2',GETDATE(),Source.SITE)
	WHEN MATCHED
	THEN
	UPDATE SET Target.site=Source.SITE  , Target.[subtype] = Source.SUB_TYPE
	OUTPUT $action,deleted.*,inserted.*;
	
	--[dbo].[items_doc_references]
	MERGE [dbo].[items_doc_references] AS Target
	USING (SELECT DISTINCT	t1.iid,t2.DOCUMENT_ITEM_ID,t2.DOCUMENT_NAME,t2.SITE,t2.PUID 
	FROM [DMProcessDB_Delta].[dbo].LOAD_DOCITEM_REFERENCES  t2	
	LEFT OUTER JOIN [dbo].items t1 on t2.ITEM_ID=t1.itemid and t2.PART_REVISION=t1.revision and t2.SITE=t1.site and LEN(t1.iid) > 0 WHERE t2.STATUS='0') AS Source
	ON Target.[document_itemid]=Source.DOCUMENT_ITEM_ID AND Target.[iid]=Source.iid AND Target.puid=Source.PUID
	WHEN NOT MATCHED BY TARGET THEN
	INSERT([iid],[document_itemid],[document_name],[site],createduser,lastmoduser,lastmoddtm,puid)
	VALUES (Source.iid,Source.DOCUMENT_ITEM_ID,Source.DOCUMENT_NAME,Source.SITE,'2','2',GETDATE(),Source.PUID)
	WHEN MATCHED THEN
	UPDATE SET Target.[document_name]=Source.DOCUMENT_NAME ,Target.site=Source.SITE
	OUTPUT $action,deleted.*,inserted.*;
	
	--[dbo].[itemreport_dataset]
	MERGE [dbo].[itemreport_dataset] as Target
	USING (SELECT DISTINCT Items.iid as item_iid,Dataset.DATASET_NAME ,Dataset.DATASET_DESCRIPTION ,Options_DatsetType.oid  as DsetType_oid ,Options_DatsetRelStatus.oid as DsetStatus,
	CASE Dataset.PART_TYPE 
	WHEN 'DocumentRevision' THEN Options_DocumentPartType.oid 
	WHEN 'Document' THEN Options_DocumentPartType.oid 
	ELSE Options_DocumentDSType.oid END as part_type ,
	'E:\Datamart\Volume1\'+DESTFILE_PATH.FILE_PATH as file_path ,Dataset.SITE,Dataset.STATUS,Dataset.PUID as Dset_puid_sr
	FROM [DMProcessDB_Delta].[dbo].LOAD_DATASETS_TRANS AS Dataset 
	LEFT OUTER JOIN [dbo].items Items ON Items.itemid=Dataset.PART_NUMBER and Items.revision=Dataset.PART_REVISION and Items.site=Dataset.SITE 
	LEFT OUTER JOIN [dbo].options as Options_DatsetType ON Options_DatsetType.description=Dataset.DATASET_TYPE AND Options_DatsetType.status='1' and Options_DatsetType.categoryid='3' 
	LEFT OUTER JOIN [dbo].options as Options_DatsetRelStatus ON Options_DatsetRelStatus.description=Dataset.DATASET_REL_STATUS AND Options_DatsetRelStatus.status='1' and Options_DatsetRelStatus.categoryid='4' 
	LEFT OUTER JOIN [dbo].options as Options_DocumentPartType ON Options_DocumentPartType.name='IOM Manual' AND Options_DocumentPartType.status='1' and Options_DocumentPartType.categoryid='6' 
	LEFT OUTER JOIN [dbo].options as Options_DocumentDSType ON Options_DocumentDSType.description=Dataset.DATASET_TYPE AND Options_DocumentDSType.status='1' and Options_DocumentDSType.categoryid='6' 
	LEFT OUTER JOIN [DMProcessDB_Delta].[dbo].LOAD_DATASETS_FILESPATH as DESTFILE_PATH ON Dataset.DATASET_NAME=DESTFILE_PATH.DATASET_NAME and Dataset.PUID=DESTFILE_PATH.[DATASET_PUID] and Dataset.DATASET_TYPE=DESTFILE_PATH.DATASET_TYPE  
	left outer join [dbo].[itemreport_dataset] ir_dset ON ir_dset.[iid]=items.iid AND ir_dset.datasetname=Dataset.DATASET_NAME AND ir_dset.[datasettype]=Options_DatsetType.oid
	 WHERE Dataset.STATUS=0) AS Source
	ON Source.item_iid=Target.iid AND Source.DATASET_NAME=Target.[datasetname] AND Source.DsetType_oid=Target.[datasettype] AND Source.Dset_puid_sr=Target.puid
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([iid] ,[datasetname] ,[datasetdesc] ,[datasettype] ,[datasetstatus] ,[documenttype] ,[pfile_name] ,site,createduser,lastmoduser,lastmoddtm,status,puid) 
	VALUES (Source.item_iid,Source.DATASET_NAME,Source.DATASET_DESCRIPTION,Source.DsetType_oid,Source.DsetStatus,Source.part_type,Source.file_path,Source.SITE,'2','2',GETDATE(),Source.status,Source.Dset_puid_sr)
	WHEN MATCHED
	THEN
	UPDATE SET   Target.[datasetdesc]=Source.DATASET_DESCRIPTION , Target.[datasetstatus] =Source.DsetStatus ,  Target.[pfile_name] = Source.file_path , Target.site =Source.SITE , Target.status =Source.STATUS 
	OUTPUT $action,deleted.*,inserted.*;
	
	UPDATE [dbo].[itemreport_dataset] set [documenttype] = (SELECT oid from [dbo].[options] opt where opt.name='Other Drawings and Documents' and opt.[categoryid]='6') where [documenttype] is NULL or [documenttype] = '';
	
	--dbo.eto_report
	MERGE dbo.eto_report AS Target
	USING (SELECT distinct t1.ETO_NUMBER, t1.PROJECT_NAME, t1.ORDER_NUMBER, t1.CUSTOMER ,t1.ETO_REVISION, t1.SITE ,t1.STATUS 
	FROM DMProcessDB_Delta.dbo.LOAD_ETO_REV t1 WHERE t1.STATUS !='3') AS Source
	ON Target.etoid=Source.ETO_NUMBER AND Target.revision=Source.ETO_REVISION
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoid,projectname,weirorderno,customer,status,createduser,lastmoduser,revision,site)
	VALUES (Source.ETO_NUMBER,Source.PROJECT_NAME, Source.ORDER_NUMBER, Source.CUSTOMER ,Source.STATUS,'2','2',Source.ETO_REVISION, Source.SITE )
	WHEN MATCHED 
	THEN
	UPDATE SET Target.projectname=Source.PROJECT_NAME,Target.weirorderno=Source.ORDER_NUMBER,Target.customer=Source.CUSTOMER,Target.status=Source.STATUS,Target.lastmoduser=2,Target.site=Source.SITE
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.eto_hasgadrawing
	MERGE dbo.eto_hasgadrawing AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_has_ga'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='WGP4_has_ga'  AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.hasga_itemid=Source.related_item AND (Target.[hasga_iid]=Source.iid OR (Target.[hasga_iid] IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,hasga_itemid,hasga_drawingid,site,status,hasga_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED
	THEN
	UPDATE set Target.hasga_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.hasga_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.eto_hasdocument
	MERGE dbo.eto_hasdocument AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_has_doc'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='WGP4_has_doc' AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.hasdocument_itemid=Source.related_item AND (Target.hasdocument_iid=Source.iid OR (Target.hasdocument_iid IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,hasdocument_itemid,hasdocument_drawingid,site,status,hasdocument_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED
	THEN
	UPDATE SET Target.hasdocument_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.hasdocument_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.eto_hasrouting
	MERGE dbo.eto_hasrouting AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_has_routing'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='WGP4_has_routing' AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.hasrouting_itemid=Source.related_item  AND (Target.hasrouting_iid=Source.iid OR (Target.hasrouting_iid IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,hasrouting_itemid,hasrouting_drawingid,site,status,hasrouting_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED 
	THEN
	UPDATE SET Target.hasrouting_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.hasrouting_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.eto_references
	MERGE dbo.eto_references AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_eto_references'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='WGP4_eto_references'  AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.references_itemid=Source.related_item  AND (Target.references_iid=Source.iid OR (Target.references_iid IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,references_itemid,references_drawingid,site,status,references_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED
	 THEN
	UPDATE SET Target.references_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.references_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
		
	--dbo.eto_orderparts
	MERGE dbo.eto_orderparts AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='order-parts'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='order-parts' AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.orderparts_itemid=Source.related_item AND (Target.orderparts_iid=Source.iid OR (Target.orderparts_iid IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,orderparts_itemid,orderparts_drawingid,site,status,orderparts_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED
	THEN
	UPDATE SET Target.orderparts_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.orderparts_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.pcn_report
	MERGE dbo.pcn_report AS Target
	USING (SELECT distinct [PCN_NUMBER],[PCN_REVISION],[PCN_DESCRIPTION],PCN.[SYNOPSIS],PCN.[SITE],PCN.STATUS 
	FROM [DMProcessDB_Delta].[dbo].[LOAD_PCN] AS PCN WHERE PCN.STATUS != '3') AS Source
	ON Target.pcnid=Source.[PCN_NUMBER] AND Target.revision=Source.[PCN_REVISION] 
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([pcnid],[revision],[pcnname] ,[description],[synopsis],[createduser] ,[lastmoduser],[status],[site])
	VALUES (Source.[PCN_NUMBER],Source.[PCN_REVISION],Source.[PCN_NUMBER],Source.[PCN_DESCRIPTION],Source.[SYNOPSIS],'2','2',Source.STATUS,Source.[SITE])
	WHEN MATCHED
	THEN
	UPDATE SET Target.[pcnname]=Source.[PCN_NUMBER] ,Target.[description]=Source.[PCN_DESCRIPTION],Target.[synopsis]=Source.[SYNOPSIS],Target.[site]=Source.[SITE],Target.STATUS=Source.STATUS
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.pcn_impacteditem
	MERGE dbo.pcn_impacteditem AS Target
	USING (SELECT distinct PCN_REPORT.[pid],IMPACTED_ITEM.iid ,PCN_REPORT.status FROM [dbo].[pcn_report] AS PCN_REPORT  
	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision  
	LEFT OUTER JOIN [dbo].items AS IMPACTED_ITEM ON IMPACTED_ITEM.itemid = PCN.RELATED_ITEM AND IMPACTED_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasImpactedItem' 	
	WHERE IMPACTED_ITEM.iid IS NOT NULL AND PCN.STATUS !='3') AS Source
	ON Target.pid=Source.pid AND Target.impacteditem_iid=Source.iid 
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (pid,impacteditem_iid,createduser,lastmoduser,status)
	VALUES (Source.pid,Source.iid,'2','2',Source.STATUS )
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.pcn_problemitem
	MERGE dbo.pcn_problemitem AS Target
	USING (SELECT distinct PCN_REPORT.[pid],PROBLEM_ITEM.iid ,PCN_REPORT.status FROM [dbo].[pcn_report] AS PCN_REPORT  
	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision  
	LEFT OUTER JOIN [dbo].items AS PROBLEM_ITEM ON PROBLEM_ITEM.itemid = PCN.RELATED_ITEM AND PROBLEM_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasProblemItem' 	
	WHERE PROBLEM_ITEM.iid IS NOT NULL AND PCN.STATUS !='3') AS Source
	ON Target.pid=Source.pid AND Target.[problemitem_iid]=Source.iid 
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (pid,[problemitem_iid],createduser,lastmoduser,status)
	VALUES (Source.pid,Source.iid,'2','2',Source.STATUS )
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.[pcn_solutionitem]
	MERGE dbo.[pcn_solutionitem] AS Target
	USING (SELECT distinct PCN_REPORT.[pid],SOLUTION_ITEM.iid ,PCN_REPORT.status FROM [dbo].[pcn_report] AS PCN_REPORT  
	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision  
	LEFT OUTER JOIN [dbo].items AS SOLUTION_ITEM ON SOLUTION_ITEM.itemid = PCN.RELATED_ITEM AND SOLUTION_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasSolutionItem' 	
	WHERE SOLUTION_ITEM.iid IS NOT NULL AND PCN.STATUS !='3') AS Source
	ON Target.pid=Source.pid AND Target.[solutionitem_iid]=Source.iid 
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (pid,[solutionitem_iid],createduser,lastmoduser,status)
	VALUES (Source.pid,Source.iid,'2','2',Source.STATUS)
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.led_ir
	MERGE dbo.led_ir AS Target
	USING (SELECT DISTINCT LED_IR.LED_ITEM_ID,LED_IR.LED_REVISION,LED_IR.DESCRIPTION,LED_IR.WLL,LED_IR.TARE,Options_ItemType.oid as Item_Type,Options_ItemRelStat.oid as Rel_Status,LED_IR.WLENGTH,LED_IR.WIDTH,LED_IR.HEIGHT,LED_IR.DCO,DOC_NUM.DRAWING_NUMBER,LED_IR.SITE
 	FROM DMProcessDB_Delta.dbo.LOAD_LED_IR AS LED_IR 
 	LEFT OUTER JOIN dbo.options as Options_ItemType ON Options_ItemType.description=LED_IR.LED_ITEMTYPE AND Options_ItemType.status='1' and Options_ItemType.categoryid='1' 
 	LEFT OUTER JOIN dbo.options as Options_ItemRelStat ON Options_ItemRelStat.name=LED_IR.RELEASE_STATUS AND Options_ItemRelStat.status='1' and Options_ItemRelStat.categoryid='2' 
 	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_DOCUMENTNUMBER as DOC_NUM ON LED_IR.LED_ITEM_ID=DOC_NUM.PART_NUMBER and LED_IR.LED_REVISION=DOC_NUM.PART_REVISION and LED_IR.SITE=DOC_NUM.SITE
 	where LED_IR.STATUS='0') AS Source
 	ON Target.[LEDItemID]=Source.LED_ITEM_ID AND Target.[revision]=Source.LED_REVISION
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (LEDItemID,revision,toolname,description,wll,tare,status,createduser,lastmoduser,tooltype,toolstatus,length,width,height,dco,drawingid,site)
	VALUES (Source.LED_ITEM_ID,Source.LED_REVISION,Source.LED_ITEM_ID,Source.DESCRIPTION,Source.WLL,Source.TARE,0,2,2,Source.Item_Type,Source.Rel_Status,Source.WLENGTH,Source.WIDTH,Source.HEIGHT,Source.DCO,Source.DRAWING_NUMBER,Source.SITE)
	WHEN MATCHED
	THEN
	UPDATE SET toolname=Source.LED_ITEM_ID,description=Source.DESCRIPTION,wll=Source.WLL,tare=Source.TARE,lastmoduser=2,tooltype=Source.Item_Type,toolstatus=Source.Rel_Status,length=Source.WLENGTH,width=Source.WIDTH,height=Source.HEIGHT,dco=Source.DCO,drawingid=Source.DRAWING_NUMBER,site=Source.SITE
	OUTPUT $action,deleted.*,inserted.*;
	
	MERGE dbo.led_support_products AS Target
	USING (SELECT DISTINCT PRODUCTS.SUPPORT_PRODUCT_ITEM_ID,PRODUCTS.DATE_IMPORTED,LED_ITEMREV.iid,PRODUCTS.SITE 
	FROM DMProcessDB_Delta.dbo.LOAD_LED_SUPPORTPRODUCT AS PRODUCTS 
	LEFT OUTER JOIN dbo.led_ir AS LED_ITEMREV ON LED_ITEMREV.LEDItemID=PRODUCTS.LED_ITEM_ID AND LED_ITEMREV.revision=PRODUCTS.LED_ITEM_REVISION 
	WHERE LEN(PRODUCTS.SUPPORT_PRODUCT_ITEM_ID) >1 and LED_ITEMREV.status='0') AS Source
	ON Source.iid=Target.toolid AND Source.SUPPORT_PRODUCT_ITEM_ID=Target.productname
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (productname,status,createduser,createddtm,lastmoduser,toolid,site)
	VALUES(Source.SUPPORT_PRODUCT_ITEM_ID,0,2,GETDATE(),2,Source.iid,Source.site)
	OUTPUT $action,deleted.*,inserted.*;
	
	MERGE dbo.led_support_part AS Target
	USING (SELECT DISTINCT PARTS.SUPPORT_PART_ITEM_ID,PARTS.DATE_IMPORTED,LED_ITEMREV.iid,PARTS.SITE FROM DMProcessDB_Delta.dbo.LOAD_LED_SUPPORTPARTS AS PARTS 
	LEFT OUTER JOIN dbo.led_ir AS LED_ITEMREV ON LED_ITEMREV.LEDItemID=PARTS.LED_ITEM_ID AND LED_ITEMREV.revision=PARTS.LED_ITEM_REVISION  
	WHERE LEN(PARTS.SUPPORT_PART_ITEM_ID) >1 and LED_ITEMREV.status='0') AS Source
	ON Source.iid=Target.toolid AND Source.SUPPORT_PART_ITEM_ID=Target.partname
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (partname,status,createduser,createddtm,lastmoduser,toolid,site)
	VALUES(Source.SUPPORT_PART_ITEM_ID,0,2,GETDATE(),2,Source.iid,Source.site)
	OUTPUT $action,deleted.*,inserted.*;
	
	MERGE dbo.led_iom_certificate AS Target
	USING (SELECT DISTINCT LED_ITEMREV.iid,IOM.IOM_ITEM_ID,LED_ITEMREV.site 
	FROM dbo.led_ir AS LED_ITEMREV 
	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_LED_IOM as IOM ON LED_ITEMREV.LEDItemID=IOM.LED_ITEM_ID AND LED_ITEMREV.revision=IOM.LED_ITEM_REVISION  
	where LEN(IOM.IOM_ITEM_ID)>0 and LED_ITEMREV.status='0') AS Source
	ON Source.iid=Target.toolid AND Source.IOM_ITEM_ID=Target.docname
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (docname,docrefid,createduser,createddtm,lastmoduser,toolid,site)
	VALUES(Source.IOM_ITEM_ID,1,2,GETDATE(),2,Source.iid,Source.site)
	OUTPUT $action,deleted.*,inserted.*;
	
	MERGE dbo.led_iom_certificate AS Target
	USING (SELECT DISTINCT LED_ITEMREV.iid,CERTIFICATE.CERTIFICATE_ITEM_ID,LED_ITEMREV.site FROM DMProd.dbo.led_ir AS LED_ITEMREV 
	LEFT OUTER JOIN DMProcessDB.dbo.LOAD_LED_CERTIFICATE as CERTIFICATE ON LED_ITEMREV.LEDItemID=CERTIFICATE.LED_ITEM_ID AND LED_ITEMREV.revision=CERTIFICATE.LED_ITEM_REVISION  
	where LEN(CERTIFICATE.CERTIFICATE_ITEM_ID)>0 and LED_ITEMREV.status='0') AS Source
	ON Source.iid=Target.toolid AND Source.CERTIFICATE_ITEM_ID=Target.docname
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (docname,docrefid,createduser,createddtm,lastmoduser,toolid,site)
	VALUES(Source.CERTIFICATE_ITEM_ID,2,2,GETDATE(),2,Source.iid,Source.site)
	OUTPUT $action,deleted.*,inserted.*;
	
	--COMMIT TRANSACTION;

  END TRY

  BEGIN CATCH
IF @@TRANCOUNT > 0

    ROLLBACK TRANSACTION;
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorLine INT = ERROR_LINE();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE(); 

    PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
    PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10)); 

    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

  END CATCH;
  IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;
	
END
GO
