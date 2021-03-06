USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnsolutiondetail]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_pcnsolutiondetail](@pcnid int)
as begin
select  items.drawingid as solutionitem ,items.revision as revs  from items
   join  pcnitem_report pcnitem  on pcnitem.solutionitem_iid=items.iid
   join pcn_report pcn on pcn.pid=pcnitem.pid  and pcn.pid=@pcnid
end
GO
