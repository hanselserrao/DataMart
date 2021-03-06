USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_search_datamart]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_search_datamart] (@searchText nvarchar(max), @count int)
AS
BEGIN
	--[dbo].[sp_search_datamart] '1 = 1 and itemdata like ''%pump%'''	
	CREATE TABLE #TempDataMart
	(itemtype VARCHAR(20),itemid int)
	CREATE CLUSTERED INDEX ix_tempCIndexAft ON #TempDataMart (itemtype,itemid);

	DECLARE @SQL NVARCHAR(MAX)   

	set @SQL = 'insert into #TempDataMart (itemtype,itemid)
	SELECT distinct itemtype, itemid from datamart_search where ' + @searchText;

	EXEC sp_executesql @SQL

	select top (@count) items.iid,items.itemid,items.itemname,ISNULL(erp_part_description, items.description) as description,
			items.revision,items.drawingid,items.site from 
	#TempDataMart
	inner join items on #TempDataMart.itemtype = 'ITEMS' AND #TempDataMart.itemid = items.iid;

	select top (@count) drawingid,items.iid, drawing_revision as docrevision,items.itemid,items.itemname,
	ISNULL(erp_part_description, items.description) as description,items.revision,items.site, items.datereleased from 
	#TempDataMart
	inner join items on #TempDataMart.itemtype = 'DOCUMENT' AND #TempDataMart.itemid = items.iid;

	select top (@count) [led_ir].iid,LEDItemID,revision,[led_ir].description, dco,drawingid,led_ir.[site]
	from #TempDataMart
	inner join led_ir on #TempDataMart.itemtype = 'LED' AND #TempDataMart.itemid = led_ir.iid;

	select top (@count)	pcn_report.pid, pcn_report.pcnid, pcn_report.description, pcn_report.synopsis,pcn_report.revision
	from #TempDataMart
	inner join pcn_report on #TempDataMart.itemtype = 'PCN' AND #TempDataMart.itemid = pcn_report.pid;

	select top (@count)	e.eid,e.etoid,e.projectname,e.weirorderno,e.customer,e.revision
	from #TempDataMart
	inner join eto_report e on #TempDataMart.itemtype = 'ETO' AND #TempDataMart.itemid = e.eid;
END;
GO
