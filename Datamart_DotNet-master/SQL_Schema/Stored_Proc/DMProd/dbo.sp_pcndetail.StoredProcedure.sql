USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_pcndetail]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_pcndetail]
      @pcnid INT
      ,@problem NVARCHAR(max) OUTPUT
	  ,@solution NVARCHAR(max) OUTPUT
	  ,@impacted NVARCHAR(max) OUTPUT
AS
BEGIN
      SET NOCOUNT ON;
 --+'(Rev '+prob_items.revision+')'
      SELECT @problem = COALESCE(@problem + ',', '') + CAST( (prob_items.itemid +'/'+prob_items.revision)   AS NVARCHAR(200))
      from pcn_report
inner join  pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
inner join items prob_items on pcn_problemitem.problemitem_iid=prob_items.iid
where pcn_report.pid=@pcnid --and prob_items.drawingid!=''
        --+' (Rev '+impact_items.revision+')'
SELECT @impacted = COALESCE(@impacted + ',', '') + CAST((impact_items.itemid +'/'+impact_items.revision) AS NVARCHAR(200))
       from pcn_report
 
inner join  pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
inner join items impact_items on pcn_impacteditem.impacteditem_iid=impact_items.iid where pcn_report.pid=@pcnid --and impact_items.drawingid!=''
--+' (Rev '+sol_items.revision+')'
	      SELECT @solution = COALESCE(@solution + ',', '') + CAST((sol_items.itemid +'/'+sol_items.revision)AS NVARCHAR(200))
      FROM  pcn_report
inner join  pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
inner join items sol_items on pcn_solutionitem.solutionitem_iid=sol_items.iid 
 where pcn_report.pid=@pcnid --and sol_items.drawingid!=''
	   
END
GO
