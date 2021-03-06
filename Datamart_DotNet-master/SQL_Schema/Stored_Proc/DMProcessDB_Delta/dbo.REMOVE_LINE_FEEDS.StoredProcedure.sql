USE [DMProcessDB_Delta]
GO
/****** Object:  StoredProcedure [dbo].[REMOVE_LINE_FEEDS]    Script Date: 06/24/2019 17:34:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lokesh Podigiri
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[REMOVE_LINE_FEEDS] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
		UPDATE DMProcessDB_Delta.dbo.LOAD_PCN SET PCN_NUMBER = replace(PCN_NUMBER, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_PCN_REL SET PCN_NUMBER = replace(PCN_NUMBER, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_ALT_ALIAS_ID SET ITEM_ID = replace(ITEM_ID, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_DATASETS SET PART_NUMBER = replace(PART_NUMBER, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_DATASETS_FILESPATH SET PART_NUMBER = replace(PART_NUMBER, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_DOCUMENT_SUBTYPE SET ITEM_ID = replace(ITEM_ID, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_PARTDRAWING SET DRAWING_ID = replace(DRAWING_ID, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_ETO_REV SET ETO_NUMBER = replace(ETO_NUMBER, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_DOCITEM_REFERENCES SET ITEM_ID = replace(ITEM_ID, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_PARTREVISION SET PART_NUMBER = replace(PART_NUMBER, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_LED_IR SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '');
		--UPDATE DMProcessDB_Delta.dbo.LOAD_LED_ALT_ALIAS_ID SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_LED_CERTIFICATE SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_LED_IOM SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_LED_SUPPORTPARTS SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_LED_SUPPORTPRODUCT SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '');
		--UPDATE DMProcessDB_Delta.dbo.LOAD_MATERIALCODE SET PART_NUMBER = replace(PART_NUMBER, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_DOCUMENTNUMBER SET PART_NUMBER = replace(LTRIM(RTRIM(PART_NUMBER)), char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_DATASETS_TRANS SET PART_NUMBER = replace(PART_NUMBER, char(10), '');
		UPDATE DMProcessDB_Delta.dbo.LOAD_DOCUMENTNUMBER SET DRAWING_NUMBER = replace(DRAWING_NUMBER, char(10), '');
	
END
GO
