USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnproblemdetail]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[sp_pcnproblemdetail](@pcnid int)
as begin
select  items.drawingid as problemitem ,items.revision as revs  from items
   join  pcnitem_report pcnitem  on pcnitem.problemitem_iid=items.iid
   join pcn_report pcn on pcn.pid=pcnitem.pid  and pcn.pid=@pcnid
  
end
GO
