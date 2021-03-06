USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnsearch]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_pcnsearch](@pcnNumber nvarchar(max),@pcndesc  nvarchar(max),@problem nvarchar(max),@solution nvarchar(max),@impected  nvarchar(max),@count int)
as begin
	Declare @tempproblem NVARCHAR(max) 
	Declare @tempsolution NVARCHAR(max) 
	Declare @tempimpacted NVARCHAR(max) 
	--[sp_pcnsearch] null,null,null,null,null,100
	IF (CHARINDEX('*', @pcnNumber ) > 0 or CHARINDEX('*', @pcndesc ) > 0 or CHARINDEX('*', @problem ) > 0 or CHARINDEX('*', @solution ) > 0 or CHARINDEX('*', @impected ) > 0)
	begin
		select  distinct top (@count) pcn_report.pid, pcn_report.pcnid, pcn_report.description,
			pcn_report.synopsis,pcn_report.revision,
			impacteditem_iid, solutionitem_iid, problemitem_iid
			from pcn_report
		left join 
		(
		select pid, stuff((
							select ',' + (items.itemid  + '/'+ items.revision) 
							from pcn_impacteditem ref
							inner join items on ref.impacteditem_iid = items.iid
							where ref.pid=mainitem.pid 
							order by items.itemid
							for xml path('')
						),1,1,'') as impacteditem_iid
		from pcn_impacteditem mainitem
		group by pid
		) pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
		--left join  pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 

		left join 
		(
		select pid, stuff((
							select ',' + (items.itemid  + '/'+ items.revision) 
							from pcn_solutionitem ref
							inner join items on ref.solutionitem_iid = items.iid
							where ref.pid=mainitem.pid 
							order by items.itemid
							for xml path('')
						),1,1,'') as solutionitem_iid
		from pcn_solutionitem mainitem
		group by pid
		) pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
		--left join  pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
		left join 
		(
		select pid, stuff((
							select ',' + (items.itemid  + '/'+ items.revision) 
							from pcn_problemitem ref
							inner join items on ref.problemitem_iid = items.iid
							where ref.pid=mainitem.pid 
							order by items.itemid
							for xml path('')
						),1,1,'') as problemitem_iid
		from pcn_problemitem mainitem
		group by pid
		) pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
		--left join  pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
		where 
			((SELECT REPLACE(REPLACE(pcn_report.pcnid, CHAR(13), ''), CHAR(10), '')) like (select REPLACE(@pcnNumber,'*','%')) or @pcnNumber='' or @pcnNumber is null) and
			(pcn_report.description like (select REPLACE(@pcndesc,'*','%'))  or @pcndesc='' or @pcndesc is null)and
			(problemitem_iid like (select REPLACE('%' + @problem + '%','*',''))  or @problem='' or @problem is null)and
			(solutionitem_iid like (select REPLACE('%' + @solution + '%','*',''))  or @solution='' or @solution is null)and
			(impacteditem_iid like (select REPLACE('%' + @impected + '%','*','')) or @impected='' or @impected is null)
		order by pcn_report.revision
	end
	else
	begin
		select  distinct top (@count) pcn_report.pid, pcn_report.pcnid, pcn_report.description,
			pcn_report.synopsis,pcn_report.revision,
			impacteditem_iid, solutionitem_iid, problemitem_iid
			from pcn_report
		left join 
		(
		select pid, stuff((
							select ',' + (items.itemid  + '/'+ items.revision) 
							from pcn_impacteditem ref
							inner join items on ref.impacteditem_iid = items.iid
							where ref.pid=mainitem.pid 
							order by items.itemid
							for xml path('')
						),1,1,'') as impacteditem_iid
		from pcn_impacteditem mainitem
		group by pid
		) pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
		--left join  pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 

		left join 
		(
		select pid, stuff((
							select ',' + (items.itemid  + '/'+ items.revision) 
							from pcn_solutionitem ref
							inner join items on ref.solutionitem_iid = items.iid
							where ref.pid=mainitem.pid 
							order by items.itemid
							for xml path('')
						),1,1,'') as solutionitem_iid
		from pcn_solutionitem mainitem
		group by pid
		) pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
		--left join  pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
		left join 
		(
		select pid, stuff((
							select ',' + (items.itemid  + '/'+ items.revision) 
							from pcn_problemitem ref
							inner join items on ref.problemitem_iid = items.iid
							where ref.pid=mainitem.pid 
							order by items.itemid
							for xml path('')
						),1,1,'') as problemitem_iid
		from pcn_problemitem mainitem
		group by pid
		) pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
		--left join  pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
		where 
			((pcn_report.pcnid in (SELECT value FROM strlist_to_tbl(@pcnNumber))) or @pcnNumber='' or @pcnNumber is null) and
			(pcn_report.description=@pcndesc or @pcndesc='' or @pcndesc is null)and
			(problemitem_iid like ('%' + @problem + '%') or @problem='' or @problem is null)and
			(solutionitem_iid like ('%' + @solution + '%') or @solution='' or @solution is null)and
			(impacteditem_iid like ('%' + @impected + '%') or @impected='' or @impected is null)
		order by pcn_report.revision
	end 
end
GO
