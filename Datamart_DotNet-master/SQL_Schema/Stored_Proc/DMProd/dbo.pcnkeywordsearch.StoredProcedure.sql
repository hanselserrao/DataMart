USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[pcnkeywordsearch]    Script Date: 06/24/2019 17:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pcnkeywordsearch](@prefix nvarchar(max))
as begin
IF (RIGHT(@prefix, 1) = '*')
   set @prefix = LEFT(@prefix, LEN(@prefix) - 1)
select distinct (pcn_report.pcnid) from pcn_report where (SELECT REPLACE(REPLACE(pcnid, CHAR(13), ''), CHAR(10), ''))like ''+@prefix+'%'
end
GO
