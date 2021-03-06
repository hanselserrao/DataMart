USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_etodetail]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_etodetail]
      @etoid INT
      ,@document NVARCHAR(max) OUTPUT
	  ,@gadrawing NVARCHAR(max) OUTPUT
	  ,@routing NVARCHAR(max) OUTPUT
	  ,@order NVARCHAR(max) OUTPUT
	  ,@reference NVARCHAR(max) OUTPUT
	 

AS
BEGIN
      SET NOCOUNT ON;
	  select @gadrawing=  COALESCE(@gadrawing + ',', '') + CAST((gadrawings.itemid +'/'+gadrawings.revision) AS NVARCHAR(200)) 
	  from eto_report e 
		LEFT JOIN eto_hasgadrawing i on e.eid=i.etoeid 
		left join items gadrawings on i.hasga_iid = gadrawings.iid
		where e.eid=@etoid
		

	  select @document=  COALESCE(@document + ',', '') + CAST((hasdocuments.itemid +'/'+hasdocuments.revision) AS NVARCHAR(200)) 
	  from eto_report e 
		LEFT JOIN eto_hasdocument i on e.eid=i.etoeid 
		left join items hasdocuments on i.hasdocument_iid = hasdocuments.iid
		where e.eid=@etoid


	  select @routing=  COALESCE(@routing + ',', '') + CAST((routing.itemid +'/'+routing.revision) AS NVARCHAR(200)) 
	  from eto_report e 
		LEFT JOIN eto_hasrouting i on e.eid=i.etoeid 
		left join items routing on i.hasrouting_iid = routing.iid
		where e.eid=@etoid


	  select @order=  COALESCE(@order + ',', '') + CAST((orderpart.itemid +'/'+orderpart.revision) AS NVARCHAR(200)) 
	  from eto_report e 
		LEFT JOIN eto_orderparts i on e.eid=i.etoeid 
		left join items orderpart on i.orderparts_iid = orderpart.iid
		where e.eid=@etoid


	  select @reference=  COALESCE(@reference + ',', '') + CAST((reference.itemid +'/'+reference.revision) AS NVARCHAR(200)) 
	  from eto_report e 
		LEFT JOIN eto_references i on e.eid=i.etoeid 
		left join items reference on i.references_iid = reference.iid
		where e.eid=@etoid

END
GO
