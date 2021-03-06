USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnsearch_bk]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_pcnsearch_bk](@pcnNumber nvarchar(max),@pcndesc  nvarchar(max),@problem nvarchar(max),@solution nvarchar(max),@impected  nvarchar(max),@count int)
as begin
IF (CHARINDEX('*', @pcnNumber ) > 0 or CHARINDEX('*', @pcndesc ) > 0 or CHARINDEX('*', @problem ) > 0 or CHARINDEX('*', @solution ) > 0 or CHARINDEX('*', @impected ) > 0)
begin
select  distinct top (100) pcn_report.pid, pcn_report.pcnid, pcn_report.description,pcn_report.synopsis,pcn_report.revision,prob_items.itemid AS "problemitem_iid",impact_items.itemid  AS "impacteditem_iid",sol_items.itemid  AS "solutionitem_iid" ,sol_items.designatedprefpart as pcndetail
  from pcn_report
left join  pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
left join items impact_items on pcn_impacteditem.impacteditem_iid=impact_items.iid 
left join  pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
left join items sol_items on pcn_solutionitem.solutionitem_iid=sol_items.iid 
left join  pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
left join items prob_items on pcn_problemitem.problemitem_iid=prob_items.iid

where 
((SELECT REPLACE(REPLACE(pcn_report.pcnid, CHAR(13), ''), CHAR(10), '')) like (select REPLACE(@pcnNumber,'*','%')) or @pcnNumber='' or @pcnNumber is null) and
(pcn_report.description like (select REPLACE(@pcnNumber,'*','%'))  or @pcndesc='' or @pcndesc is null)and
(prob_items.itemid like (select REPLACE(@problem,'*','%'))  or @problem='' or @problem is null)and
(sol_items.itemid like (select REPLACE(@solution,'*','%'))  or @solution='' or @solution is null)and
(impact_items.itemid like (select REPLACE(@impected,'*','%')) or @impected='' or @impected is null)
order by pcn_report.revision
end
else
begin

select  distinct top (@count) pcn_report.pid, pcn_report.pcnid, pcn_report.description,pcn_report.synopsis,pcn_report.revision,prob_items.itemid AS "problemitem_iid",impact_items.itemid  AS "impacteditem_iid",sol_items.itemid  AS "solutionitem_iid" ,sol_items.designatedprefpart as pcndetail
 from pcn_report
left join  pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
left join items impact_items on pcn_impacteditem.impacteditem_iid=impact_items.iid 
left join  pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
left join items sol_items on pcn_solutionitem.solutionitem_iid=sol_items.iid 
left join  pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
left join items prob_items on pcn_problemitem.problemitem_iid=prob_items.iid

where 
((SELECT REPLACE(REPLACE(pcn_report.pcnid, CHAR(13), ''), CHAR(10), ''))=@pcnNumber or @pcnNumber='' or @pcnNumber is null) and
(pcn_report.description=@pcndesc or @pcndesc='' or @pcndesc is null)and
(prob_items.itemid=@problem or @problem='' or @problem is null)and
(sol_items.itemid=@solution or @solution='' or @solution is null)and
(impact_items.itemid=@impected or @impected='' or @impected is null)
order by pcn_report.revision
end 
end
GO
