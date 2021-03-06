USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[GENERATE_OPTIONS]    Script Date: 06/24/2019 17:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GENERATE_OPTIONS]
	
AS
BEGIN


INSERT INTO [dbo].[options](name,description,status,categoryid) SELECT distinct PR1.PART_TYPE,PR1.PART_TYPE,'1','1'  FROM [DMProcessDB].[dbo].[LOAD_PARTREVISION] AS "PR1" where STATUS='0';
INSERT INTO [dbo].[options](name,description,status,categoryid) SELECT distinct RELEASE_STATUS,RELEASE_STATUS,'1','2'  FROM [DMProcessDB].[dbo].[LOAD_PARTREVISION] where STATUS='0'; 
INSERT INTO [dbo].[options] (name,description,status,categoryid) SELECT distinct DATASET_TYPE,DATASET_TYPE,'1','3'  FROM [DMProcessDB].[dbo].LOAD_DATASETS_TRANS where STATUS='0';   
INSERT INTO [dbo].[options](name,description,status,categoryid) SELECT distinct DATASET_REL_STATUS,DATASET_REL_STATUS,'1','4'  FROM [DMProcessDB].[dbo].LOAD_DATASETS_TRANS where STATUS='0';
INSERT INTO [dbo].[options] (name,description,status,categoryid) SELECT distinct DCO,DCO,'1','5'  FROM [DMProcessDB].[dbo].[LOAD_PARTREVISION] where STATUS='0' and DCO <> '';
     
     
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('Assembly/Master Drawing','DetailedPDF','1','6');
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('Material Specification','MaterialSpecSheet','1','6');
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('Other Drawings and Documents','PDF','1','6');
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('IOM Manual','DocumentRevision','1','6');
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('General Arrangement','Non DetailedPDF','1','6');


UPDATE [dbo].[options] SET "options".[name] = "dis".display_name FROM [dbo].[options] AS "options"
INNER JOIN [dbo].real_displaynames AS "dis"
ON "dis".real_name="options".description
WHERE  "options".categoryid='1';

END
GO
