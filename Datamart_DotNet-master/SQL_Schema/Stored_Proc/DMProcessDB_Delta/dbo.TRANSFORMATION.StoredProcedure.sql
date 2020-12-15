USE [DMProcessDB_Delta]
GO
/****** Object:  StoredProcedure [dbo].[TRANSFORMATION]    Script Date: 06/24/2019 17:34:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LOKESH PODIGIRI
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[TRANSFORMATION] 
		
AS
BEGIN

UPDATE dbo.LOAD_PARTREVISION SET COMMENTS='NOT PROCESSED', STATUS='9';

UPDATE dbo.LOAD_DATASETS SET COMMENTS='NOT PROCESSED',STATUS='9';

UPDATE dbo.LOAD_PARTREVISION SET STATUS = '2', COMMENTS='SYS DOC' WHERE PART_NUMBER LIKE 'SysDoc%';

UPDATE dbo.LOAD_DATASETS  SET STATUS = '2', COMMENTS='SYS DOC' WHERE PART_NUMBER LIKE 'SysDoc%';

UPDATE dbo.LOAD_ETO SET STATUS = '0', COMMENTS='ALL STATUS IS ALLOWED';

UPDATE dbo.LOAD_PCN SET STATUS = '0', COMMENTS='ALL STATUS IS ALLOWED';

UPDATE dbo.LOAD_PARTREVISION SET STATUS = '2', COMMENTS='PART TYPE' 
WHERE PART_TYPE 
NOT IN ('WGP4_ConeCrusherRevision','WGP4_ConveyorsRevision','WGP4_ElastomerRevision','WGP4_FeederRevision','WGP4_HPGRRevision','WGP4_HoseRevision',
'WGP4_MechSealRevision','WGP4_MechatronicRevision','WGP4_Mill_LinerRevision','WGP4_PartResorceRevision','WGP4_PlantRevision','WGP4_SpoolRevision',
'WGP4_WasherRevision','WGP7CycClustRevision','Warman Cyclone Revision','Warman Equipment Revision','Warman Part Tool Revision','Warman Pump Revision',
'Warman Tool Aid Revision','Weir Minerals Revision','Weir Screen Revision','Weir Valve Revision','ItemRevision','Drawing Item Revision','DocumentRevision',
'WGP4_MatSpecRevision','WGP4_Ball_FeederRevision','WGP4_BargeRevision','WGP4_BladeMillRevision','WGP4_CentrifugeRevision','WGP4_LiftingERevision','WGP4_TransportCRevision','WGP4_SkidRevision','WGP4_WeirMagnetRevision','WGP4_WeirProductRevision');

UPDATE dbo.LOAD_DATASETS  SET STATUS ='2', COMMENTS='PART TYPE' WHERE PART_TYPE
 NOT IN ('WGP4_ConeCrusherRevision','WGP4_ConveyorsRevision','WGP4_ElastomerRevision','WGP4_FeederRevision','WGP4_HPGRRevision','WGP4_HoseRevision',
 'WGP4_MechSealRevision','WGP4_MechatronicRevision','WGP4_Mill_LinerRevision','WGP4_PartResorceRevision','WGP4_PlantRevision','WGP4_SpoolRevision',
 'WGP4_WasherRevision','WGP7CycClustRevision','Warman Cyclone Revision','Warman Equipment Revision','Warman Part Tool Revision','Warman Pump Revision',
 'Warman Tool Aid Revision','Weir Minerals Revision','Weir Screen Revision','Weir Valve Revision','ItemRevision','Drawing Item Revision','DocumentRevision',
 'WGP4_MatSpecRevision','WGP4_Ball_FeederRevision','WGP4_BargeRevision','WGP4_BladeMillRevision','WGP4_CentrifugeRevision','WGP4_LiftingERevision','WGP4_TransportCRevision','WGP4_SkidRevision','WGP4_WeirMagnetRevision','WGP4_WeirProductRevision');

UPDATE dbo.LOAD_PARTREVISION 
SET STATUS = 
CASE WHEN LOAD_PARTREVISION.STATUS = '1' THEN LOAD_PARTREVISION.STATUS 
WHEN LOAD_PARTREVISION.RELEASE_STATUS NOT IN ( 'Production', 'Superseded','Obsolete' ) THEN '1' 
WHEN (LOAD_PARTREVISION.RELEASE_STATUS IS NULL) THEN '1' 
WHEN (LOAD_PARTREVISION.RELEASE_STATUS='') THEN '1' 
WHEN LOAD_PARTREVISION.RELEASE_STATUS IN ( 'Production', 'Superseded','Obsolete' ) THEN '0' 
ELSE '9' END, 

COMMENTS = 
CASE WHEN LOAD_PARTREVISION.STATUS = '1' THEN LOAD_PARTREVISION.COMMENTS 
WHEN LOAD_PARTREVISION.RELEASE_STATUS NOT IN ( 'Production', 'Superseded' ,'Obsolete') THEN 'STATUS NOT IN SUPERSEED / PROD / OBS'  
WHEN (LOAD_PARTREVISION.RELEASE_STATUS IS NULL) THEN 'STATUS IS NULL'  
WHEN (LOAD_PARTREVISION.RELEASE_STATUS ='') THEN 'STATUS IS NULL'  
WHEN LOAD_PARTREVISION.RELEASE_STATUS IN ( 'Production', 'Superseded','Obsolete' ) THEN 'STATUS IN SUPERSEED / PROD / OBS'  
ELSE 'NOT PROCESSED' END;

UPDATE dbo.LOAD_DATASETS 
SET  STATUS =  
CASE   WHEN LOAD_DATASETS.STATUS = '1' THEN LOAD_DATASETS.STATUS 
WHEN LOAD_DATASETS.DATASET_REL_STATUS NOT IN ( 'Production', 'Superseded','Obsolete') THEN '1' 
WHEN LOAD_DATASETS.DATASET_REL_STATUS IS NULL THEN '1' 
WHEN LOAD_DATASETS.DATASET_REL_STATUS ='' THEN '1' 
WHEN LOAD_DATASETS.DATASET_REL_STATUS IN ( 'Production', 'Superseded','Obsolete') THEN '0' ELSE '9' END, 
 
COMMENTS =  CASE   WHEN LOAD_DATASETS.STATUS = '1' THEN LOAD_DATASETS.COMMENTS  
WHEN LOAD_DATASETS.DATASET_REL_STATUS NOT IN ( 'Production', 'Superseded','Obsolete') THEN 'STATUS NOT IN SUPERSEED / PROD / OBS'  
WHEN LOAD_DATASETS.DATASET_REL_STATUS IS NULL THEN 'STATUS IS NULL'  
WHEN LOAD_DATASETS.DATASET_REL_STATUS ='' THEN 'STATUS IS NULL' 
WHEN LOAD_DATASETS.DATASET_REL_STATUS IN ( 'Production', 'Superseded','Obsolete') THEN 'STATUS IN SUPERSEED / PROD / OBS'  
 ELSE 'NOT PROCESSED' END; 
 
WITH CTE(PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE,STATUS,COMMENTS,DuplicateCount) 
AS ( SELECT PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE,STATUS,COMMENTS,ROW_NUMBER() 
 OVER(PARTITION BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE ORDER BY PART_NUMBER )  as DuplicateCount 
 FROM dbo.LOAD_PARTREVISION ) UPDATE CTE SET STATUS='2',COMMENTS='DUPLICATE STATUS' WHERE DuplicateCount>1; 
 
WITH CTE(PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE,STATUS,COMMENTS,DuplicateCount) 
AS ( SELECT PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE,STATUS,COMMENTS,ROW_NUMBER() 
OVER(PARTITION BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE ORDER BY PART_NUMBER )  as DuplicateCount 
FROM dbo.LOAD_DATASETS)UPDATE CTE SET STATUS='2',COMMENTS='DUPLICATE STATUS' WHERE DuplicateCount>1;

UPDATE dbo.LOAD_PARTREVISION SET STATUS = '2', COMMENTS='EMPTY PART_NUMBER' WHERE PART_NUMBER ='';
UPDATE dbo.LOAD_DATASETS  SET STATUS = '2', COMMENTS='EMPTY PART_NUMBER' WHERE PART_NUMBER ='';
UPDATE dbo.LOAD_ALT_ALIAS_ID SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (ITEM_ID='' or LEN(ITEM_ID)<1);
UPDATE dbo.LOAD_DATASETS SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1);
UPDATE dbo.LOAD_DATASETS_FILESPATH SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1);
UPDATE dbo.LOAD_DATASETS_TRANS SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) ;
UPDATE dbo.LOAD_ETO SET STATUS='2' , COMMENTS='EMPTY ETO NUMBER' WHERE  (ETO_NUMBER='' or LEN(ETO_NUMBER)<1);
UPDATE dbo.LOAD_PARTDRAWING SET STATUS='2' , COMMENTS='EMPTY DRAWING ITEM ID' WHERE  (DRAWING_ID='' or LEN(DRAWING_ID)<1);
UPDATE dbo.LOAD_PARTREVISION SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) ;
UPDATE dbo.LOAD_PARTREVISION SET STATUS='2' , COMMENTS='PART NUMBER LENGTH > 18' WHERE LEN(PART_NUMBER)>18 ;
UPDATE dbo.LOAD_PCN SET STATUS='2' , COMMENTS='EMPTY PCN NUMBER' WHERE (PCN_NUMBER='' or LEN(PCN_NUMBER)<1) ;
UPDATE dbo.LOAD_LED_IR 
SET STATUS= 
CASE WHEN LOAD_LED_IR.[RELEASE_STATUS] in ( 'Production', 'Superseded', 'Obsolete' ) THEN '0'
WHEN LOAD_LED_IR.[RELEASE_STATUS] NOT in ( 'Production', 'Superseded', 'Obsolete' ) THEN '1' END; 


UPDATE dbo.LOAD_PARTREVISION SET STATUS ='2', COMMENTS='MULTIPLE STATUS' 
WHERE PUID IN (SELECT PUID FROM dbo.LOAD_PARTREVISION WHERE STATUS ='0' GROUP BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,SITE HAVING COUNT(RELEASE_STATUS) = 2) AND RELEASE_STATUS='Production';
UPDATE dbo.LOAD_DATASETS SET STATUS ='2', COMMENTS='MULTIPLE STATUS' 
WHERE PUID IN (SELECT PUID FROM dbo.LOAD_DATASETS WHERE STATUS ='0' GROUP BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,SITE  HAVING COUNT(DATASET_REL_STATUS) = 2 ) AND DATASET_REL_STATUS='Production';

delete from [dbo].[LOAD_ETO_REV] where RELATION_NAME is null and [ETO_NUMBER] in (SELECT distinct [ETO_NUMBER] FROM [dbo].[LOAD_ETO_REV] where RELATION_NAME is not null);

WITH LOAD_PARTREVISION_CTE AS(SELECT *,ROW_NUMBER() OVER (PARTITION BY [PART_NUMBER],[PART_REVISION],[PUID] ORDER BY [PART_NUMBER],[PART_REVISION],[PUID],DATE_IMPORTED) AS RowNumber
from [dbo].[LOAD_PARTREVISION] where STATUS in (0,1)) UPDATE LOAD_PARTREVISION_CTE set STATUS=3,COMMENTS='DUPLICATE ROWS' where RowNumber>1;


WITH LOAD_DOCUMENT_SUBTYPE_CTE AS (SELECT *,ROW_NUMBER() OVER (PARTITION BY [ITEM_ID],[PUID] ORDER BY [ITEM_ID],[PUID],DATE_IMPORTED)  AS RowNumber
	FROM  [dbo].LOAD_DOCUMENT_SUBTYPE where STATUS=0) UPDATE LOAD_DOCUMENT_SUBTYPE_CTE set STATUS=3,COMMENTS='DUPLICATE ROWS' WHERE RowNumber>1;
  
WITH LOAD_DOCITEM_REFERENCES_CTE AS (SELECT *,ROW_NUMBER() OVER (PARTITION BY ITEM_ID,PART_REVISION,DOCUMENT_ITEM_ID,PUID ORDER BY ITEM_ID,PART_REVISION,DOCUMENT_ITEM_ID,PUID,DATE_IMPORTED) AS RowNumber
	FROM [dbo].LOAD_DOCITEM_REFERENCES WHERE STATUS=0) UPDATE  LOAD_DOCITEM_REFERENCES_CTE set STATUS=3,COMMENTS='DUPLICATE ROWS' WHERE RowNumber>1;
  
  
WITH LOAD_DATASETS_TRANS_CTE AS (SELECT *,ROW_NUMBER() OVER (PARTITION BY PART_NUMBER,PART_REVISION,DATASET_NAME,DATASET_TYPE,PUID ORDER BY PART_NUMBER,PART_REVISION,DATASET_NAME,DATASET_TYPE,PUID,DATE_IMPORTED) AS RowNumber
	FROM [dbo].LOAD_DATASETS_TRANS  WHERE STATUS=0) UPDATE LOAD_DATASETS_TRANS_CTE set STATUS=3,COMMENTS='DUPLICATE ROWS' WHERE RowNumber>1;
	
	
	
WITH LOAD_ETO_REV_CTE AS (SELECT *,ROW_NUMBER() OVER (PARTITION BY [ETO_NUMBER],[ETO_REVISION],[RELATION_NAME],[RELATED_ITEM],[PUID] ORDER BY [ETO_NUMBER],[ETO_REVISION],[RELATION_NAME],[RELATED_ITEM],[PUID],DATE_IMPORTED) AS RowNumber
  FROM [dbo].LOAD_ETO_REV) UPDATE LOAD_ETO_REV_CTE set STATUS=3,COMMENTS='DUPLICATE ROWS' WHERE RowNumber>1;
  
  WITH LOAD_PCN_CTE AS (SELECT *,ROW_NUMBER() OVER (PARTITION BY PCN_NUMBER,PCN_REVISION,PUID ORDER BY PCN_NUMBER,PCN_REVISION,PUID,DATE_IMPORTED) AS RowNumber
  FROM [dbo].LOAD_PCN) update LOAD_PCN_CTE set STATUS=3,COMMENTS='DUPLICATE ROWS' WHERE RowNumber>1;
   
  
  WITH LOAD_LED_IR_CTE AS
  (SELECT *,ROW_NUMBER() OVER (PARTITION BY LED_ITEM_ID,LED_REVISION,PUID ORDER BY LED_ITEM_ID,LED_REVISION,PUID) AS RowNumber
  FROM [dbo].LOAD_LED_IR) UPDATE LOAD_LED_IR_CTE set STATUS=3,COMMENTS='DUPLICATE ROWS' WHERE  RowNumber>1;
  
END
GO
