USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_modpcndetail]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_modpcndetail]
      @iid INT
      ,@pcnid NVARCHAR(max) OUTPUT
	   ,@pcnrevision NVARCHAR(max) OUTPUT
	    ,@pcnsynopsis NVARCHAR(max) OUTPUT
		 ,@pcndescription NVARCHAR(max) OUTPUT
		  ,@problemid NVARCHAR(max) OUTPUT
		   ,@problemrev NVARCHAR(max) OUTPUT
		    ,@solutionid NVARCHAR(max) OUTPUT
			 ,@solutionrev NVARCHAR(max) OUTPUT
			  ,@impactedid NVARCHAR(max) OUTPUT
			   ,@impactedrev NVARCHAR(max) OUTPUT

-- pcn.pcnid,pcn.revision as pcnrevision,pcn.synopsis,pcn.description as pcndescription,itm.revision as problemitem_revision,itm1.revision as solutionitem_revision,itm2.revision as impacteditem_revision,
 --itm.itemid as problemitem_iid,itm1.itemid as solutionitem_iid,itm2.itemid as impacteditem_iid

AS
BEGIN
      SET NOCOUNT ON;
 --+'(Rev '+prob_items.revision+')'
      SELECT @pcnid = COALESCE(@pcnid + ',', '') + (CAST(pcn_report.pcnid  AS NVARCHAR(30))),
			@pcnrevision = COALESCE(@pcnrevision + ',', '') + (CAST(pcn_report.revision  AS NVARCHAR(30))),
			@pcnsynopsis = COALESCE(@pcnsynopsis + ',', '') + (CAST(ISNULL(pcn_report.synopsis,'-')  AS NVARCHAR(200))),
			@pcndescription = COALESCE(@pcndescription + ',', '') + (CAST(ISNULL(pcn_report.description,'-')  AS NVARCHAR(200))),
			@problemid = COALESCE(@problemid + ',', '') + (CAST(prob_items.itemid  AS NVARCHAR(30))),
			@problemrev = COALESCE(@problemrev + ',', '') + (CAST(prob_items.revision  AS NVARCHAR(30))),
			@impactedid = COALESCE(@impactedid + ',-', '-'),
			@impactedrev = COALESCE(@impactedrev + ',', '-'),
			@solutionid = COALESCE(@solutionid + ',-', '-'),
			@solutionrev = COALESCE(@solutionrev + ',', '-')

      from pcn_report
 left join  pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
left join items prob_items on pcn_problemitem.problemitem_iid=prob_items.iid
where pcn_problemitem.problemitem_iid=@iid --and prob_items.drawingid!=''
        --+' (Rev '+impact_items.revision+')'
		

      SELECT @pcnid = COALESCE(@pcnid + ',', '') + (CAST(pcn_report.pcnid  AS NVARCHAR(30))),
			@pcnrevision = COALESCE(@pcnrevision + ',', '') + (CAST(pcn_report.revision  AS NVARCHAR(30))),
			@pcnsynopsis = COALESCE(@pcnsynopsis + ',', '') + (CAST(ISNULL(pcn_report.synopsis,'-')  AS NVARCHAR(200))),
			@pcndescription = COALESCE(@pcndescription + ',', '') + (CAST(ISNULL(pcn_report.description,'-')  AS NVARCHAR(200))),
			@problemid = COALESCE(@problemid + ',-', '-'),
			@problemrev = COALESCE(@problemrev + ',-', '-'),
			@impactedid = COALESCE(@impactedid + ',', '') + (CAST(impact_items.itemid  AS NVARCHAR(30))),
			@impactedrev = COALESCE(@impactedrev + ',', '') + (CAST(impact_items.revision  AS NVARCHAR(30))),
			@solutionid = COALESCE(@solutionid + ',-', '-'),
			@solutionrev = COALESCE(@solutionrev + ',-', '-')
      from pcn_report
 
left join  pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
left join items impact_items on pcn_impacteditem.impacteditem_iid=impact_items.iid where pcn_impacteditem.impacteditem_iid=@iid --and impact_items.drawingid!=''
--+' (Rev '+sol_items.revision+')'
     SELECT @pcnid = COALESCE(@pcnid + ',', '') + (CAST(pcn_report.pcnid  AS NVARCHAR(30))),
			@pcnrevision = COALESCE(@pcnrevision + ',', '') + (CAST(pcn_report.revision  AS NVARCHAR(30))),
			@pcnsynopsis = COALESCE(@pcnsynopsis + ',', '') + (CAST(ISNULL(pcn_report.synopsis,'-')  AS NVARCHAR(200))),
			@pcndescription = COALESCE(@pcndescription + ',', '') + (CAST(ISNULL(pcn_report.description,'-')  AS NVARCHAR(200))),
			@problemid = COALESCE(@problemid + ',-', '-') ,
			@problemrev = COALESCE(@problemrev + ',-', '-') ,
			@impactedid = COALESCE(@impactedid + ',-', '') ,
			@impactedrev = COALESCE(@impactedrev + ',-', '-') ,
			@solutionid = COALESCE(@solutionid + ',', '') + (CAST(sol_items.itemid  AS NVARCHAR(30))),
			@solutionrev = COALESCE(@solutionrev + ',', '') + (CAST(sol_items.revision  AS NVARCHAR(30)))
      from pcn_report
  left join  pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
left join items sol_items on pcn_solutionitem.solutionitem_iid=sol_items.iid 
 where pcn_solutionitem.solutionitem_iid=@iid --and sol_items.drawingid!=''

 
 if Object_id('tempdb..#mypcn') is not null
 Begin
	insert into #mypcn
		values (@pcnid,
		@pcnrevision,
		@pcnsynopsis,
		@pcndescription,
		@problemid,
		@problemrev,
		@solutionid,
		@solutionrev,
		@impactedid,
		@impactedrev)
	End
	   
END
GO
