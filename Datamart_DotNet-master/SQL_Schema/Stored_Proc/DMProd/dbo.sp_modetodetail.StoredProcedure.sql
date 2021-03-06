USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_modetodetail]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_modetodetail]
      @iid INT
      ,@etoid NVARCHAR(max) OUTPUT
	   ,@etoproj NVARCHAR(max) OUTPUT
	    ,@etoorder NVARCHAR(max) OUTPUT
		 ,@etocustomer NVARCHAR(max) OUTPUT
		  ,@gaid NVARCHAR(max) OUTPUT
		   ,@docid NVARCHAR(max) OUTPUT
		    ,@routingid NVARCHAR(max) OUTPUT
			 ,@docpartid NVARCHAR(max) OUTPUT
			  ,@refid NVARCHAR(max) OUTPUT

AS
BEGIN
      SET NOCOUNT ON;

      SELECT @etoid = COALESCE(@etoid + ',', '') + (CAST(eto_report.etoid  AS NVARCHAR(200))),
			@etoproj = COALESCE(@etoproj + ',', '') + (CAST(ISNULL(eto_report.projectname,'-')  AS NVARCHAR(200))),
			@etoorder = COALESCE(@etoorder + ',', '') + (CAST(ISNULL(eto_report.weirorderno,'-')  AS NVARCHAR(200))),
			@etocustomer = COALESCE(@etocustomer + ',', '') + (CAST(ISNULL(eto_report.customer,'-')  AS NVARCHAR(200))),
			@gaid = COALESCE(@gaid + ',', '') + (CAST(ISNULL(ga_items.itemid, '-')  AS NVARCHAR(200))),
			@docid = COALESCE(@docid + ',-', '-'),
			@routingid = COALESCE(@routingid + ',-', '-'),
			@docpartid = COALESCE(@docpartid + ',-', '-'),
			@refid = COALESCE(@refid + ',-', '-')

      from eto_report

		 left join  eto_hasgadrawing on eto_hasgadrawing.etoeid = eto_report.eid
		left join items ga_items on eto_hasgadrawing.hasga_iid=ga_items.iid
		where eto_hasgadrawing.hasga_iid= @iid 
		

      SELECT @etoid = COALESCE(@etoid + ',', '') + (CAST(eto_report.etoid  AS NVARCHAR(200))),
			@etoproj = COALESCE(@etoproj + ',', '') + (CAST(ISNULL(eto_report.projectname,'-')  AS NVARCHAR(200))),
			@etoorder = COALESCE(@etoorder + ',', '') + (CAST(ISNULL(eto_report.weirorderno,'-')  AS NVARCHAR(200))),
			@etocustomer = COALESCE(@etocustomer + ',', '') + (CAST(ISNULL(eto_report.customer,'-')  AS NVARCHAR(200))),
			@gaid = COALESCE(@gaid + ',-', '-'),
			@docid = COALESCE(@docid + ',', '') + (CAST(ISNULL(doc_items.itemid,'-')  AS NVARCHAR(200))),
			@routingid = COALESCE(@routingid + ',-', '-'),
			@docpartid = COALESCE(@docpartid + ',-', '-'),
			@refid = COALESCE(@refid + ',-', '-')

      from eto_report
 
		 left join  eto_hasdocument on eto_hasdocument.etoeid = eto_report.eid
		left join items doc_items on eto_hasdocument.hasdocument_iid=doc_items.iid
		where eto_hasdocument.hasdocument_iid= @iid 


      SELECT @etoid = COALESCE(@etoid + ',', '') + (CAST(eto_report.etoid  AS NVARCHAR(200))),
			@etoproj = COALESCE(@etoproj + ',', '') + (CAST(ISNULL(eto_report.projectname,'-')  AS NVARCHAR(200))),
			@etoorder = COALESCE(@etoorder + ',', '') + (CAST(ISNULL(eto_report.weirorderno,'-')  AS NVARCHAR(200))),
			@etocustomer = COALESCE(@etocustomer + ',', '') + (CAST(ISNULL(eto_report.customer,'-')  AS NVARCHAR(200))),
			@gaid = COALESCE(@gaid + ',-', '-'),
			@docid = COALESCE(@docid + ',-', '-'),
			@routingid = COALESCE(@routingid + ',', '') + (CAST(ISNULL(route_items.itemid,'-')  AS NVARCHAR(200))),
			@docpartid = COALESCE(@docpartid + ',-', '-'),
			@refid = COALESCE(@refid + ',-', '-')

      from eto_report
 
		 left join  eto_hasrouting on eto_hasrouting.etoeid = eto_report.eid
		left join items route_items on eto_hasrouting.hasrouting_iid=route_items.iid
		where eto_hasrouting.hasrouting_iid = @iid 

      SELECT @etoid = COALESCE(@etoid + ',', '') + (CAST(eto_report.etoid  AS NVARCHAR(200))),
			@etoproj = COALESCE(@etoproj + ',', '') + (CAST(ISNULL(eto_report.projectname,'-')  AS NVARCHAR(200))),
			@etoorder = COALESCE(@etoorder + ',', '') + (CAST(ISNULL(eto_report.weirorderno,'-')  AS NVARCHAR(200))),
			@etocustomer = COALESCE(@etocustomer + ',', '') + (CAST(ISNULL(eto_report.customer,'-')  AS NVARCHAR(200))),
			@gaid = COALESCE(@gaid + ',-', '-'),
			@docid = COALESCE(@docid + ',-', '-'),
			@routingid = COALESCE(@routingid + ',-', '-'),
			@docpartid = COALESCE(@docpartid + ',', '') + (CAST(ISNULL(order_items.itemid,'-')  AS NVARCHAR(200))),
			@refid = COALESCE(@refid + ',-', '-')

      from eto_report
 
		 left join  eto_orderparts on eto_orderparts.etoeid = eto_report.eid
		left join items order_items on eto_orderparts.orderparts_iid=order_items.iid
		where eto_orderparts.orderparts_iid = @iid 


      SELECT @etoid = COALESCE(@etoid + ',', '') + (CAST(eto_report.etoid  AS NVARCHAR(200))),
			@etoproj = COALESCE(@etoproj + ',', '') + (CAST(ISNULL(eto_report.projectname,'-')  AS NVARCHAR(200))),
			@etoorder = COALESCE(@etoorder + ',', '') + (CAST(ISNULL(eto_report.weirorderno,'-')  AS NVARCHAR(200))),
			@etocustomer = COALESCE(@etocustomer + ',', '') + (CAST(ISNULL(eto_report.customer,'-')  AS NVARCHAR(200))),
			@gaid = COALESCE(@gaid + ',-', '-'),
			@docid = COALESCE(@docid + ',-', '-'),
			@routingid = COALESCE(@routingid + ',-', '-'),
			@docpartid = COALESCE(@docpartid + ',-', '-'),
			@refid = COALESCE(@refid + ',', '') + (CAST(ISNULL(ref_items.itemid,'-')  AS NVARCHAR(200)))

      from eto_report
 
		 left join  eto_references on eto_references.etoeid = eto_report.eid
		left join items ref_items on eto_references.references_iid=ref_items.iid
		where eto_references.references_iid = @iid 

 
 if Object_id('tempdb..#myeto') is not null
 Begin
	insert into #myeto
		values (@etoid,
		@etoproj,
		@etoorder,
		@etocustomer,
		@gaid,
		@docid,
		@routingid,
		@docpartid,
		@refid)
	End
	   
END
GO
