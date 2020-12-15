USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnimpacteddetail]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[sp_pcnimpacteddetail](@pcnid int)
as begin
select  items.drawingid as impacteditem ,items.revision as revsi  from items
   join  pcnitem_report pcnitem  on pcnitem.impacteditem_iid=items.iid
   join pcn_report pcn on pcn.pid=pcnitem.pid  and pcn.pid=@pcnid
  
end
GO
