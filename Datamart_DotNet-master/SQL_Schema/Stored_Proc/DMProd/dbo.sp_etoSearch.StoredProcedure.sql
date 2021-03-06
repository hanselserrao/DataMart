USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_etoSearch]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery2.sql|7|0|C:\Users\Malay\AppData\Local\Temp\~vs3B93.sql
CREATE PROCEDURE [dbo].[sp_etoSearch](@etoNumber nvarchar(max),@projectName nvarchar(max), @ordernumber nvarchar(max),
@customername nvarchar(max),@gagrowing nvarchar(max),@document nvarchar(max),@routing nvarchar(max),@orderparts nvarchar(max),@reference nvarchar(max) ,@count int)
as 
begin
      Declare @tempdocument NVARCHAR(max) 
	  Declare @tempgadrawing NVARCHAR(max) 
	  Declare @temporder NVARCHAR(max) 
	  Declare @tempreference NVARCHAR(max) 

	IF (CHARINDEX('*', @etoNumber ) > 0 or CHARINDEX('*', @projectName ) > 0 or CHARINDEX('*', @ordernumber ) > 0 or CHARINDEX('*', @customername ) > 0 or CHARINDEX('*', @gagrowing ) > 0 or CHARINDEX('*', @document ) > 0 or CHARINDEX('*', @routing ) > 0 OR  CHARINDEX('*', @orderparts ) > 0 OR  CHARINDEX('*', @reference ) > 0)
	begin
		--,itm.references_itemid as ref, itm.references_drawingid
		select  distinct top (@count) e.eid,e.etoid,e.projectname,e.weirorderno,e.customer,e.revision--,it.site as etodetail
		, gadrawingref, documentref, orderpartref, referenceref
		from eto_report e 
		left join 
		(
		select etoeid, stuff((
							select ',' + isnull ((gadrawings.itemid + '/'+ gadrawings.revision), ref.hasga_itemid) 
							from eto_hasgadrawing ref
							left outer join items gadrawings on ref.hasga_iid = gadrawings.iid
							where ref.etoeid=mainitem.etoeid 
							order by gadrawings.itemid
							for xml path('')
						),1,1,'') as gadrawingref
		from eto_hasgadrawing mainitem
		group by etoeid
		) i on e.eid=i.etoeid 
		--LEFT JOIN eto_hasgadrawing i on e.eid=i.etoeid 

		left join 
		(
		select etoeid, stuff((
							select ',' + isnull((hasdocuments.itemid  + '/'+ hasdocuments.revision), ref.hasdocument_itemid)
							from eto_hasdocument ref
							left outer join items hasdocuments on ref.hasdocument_iid = hasdocuments.iid
							where ref.etoeid=mainitem.etoeid 
							order by hasdocuments.itemid
							for xml path('')
						),1,1,'') as documentref
		from eto_hasdocument mainitem
		group by etoeid
		)  it on e.eid=it.etoeid 
		--LEFT JOIN eto_hasdocument it on e.eid=it.etoeid 
		--LEFT JOIN eto_hasrouting id on e.eid=id.etoeid 

		left join 
		(
		select etoeid, stuff((
							select ',' + isnull((orderpart.itemid + '/'+ orderpart.revision), ref.orderparts_itemid) 
							from eto_orderparts ref
							left outer join items orderpart on ref.orderparts_iid = orderpart.iid
							where ref.etoeid=mainitem.etoeid 
							order by orderpart.itemid
							for xml path('')
						),1,1,'') as orderpartref
		from eto_orderparts mainitem
		group by etoeid
		)  its on e.eid=its.etoeid 
		--LEFT JOIN eto_orderparts its on e.eid=its.etoeid 

		left join 
		(
		select etoeid, stuff((
							select ',' + isnull((reference.itemid + '/'+ reference.revision), ref.references_itemid) 
							from eto_references ref
							left outer join items reference on ref.references_iid = reference.iid
							where ref.etoeid=mainitem.etoeid 
							order by reference.itemid
							for xml path('')
						),1,1,'') as referenceref
		from eto_references mainitem
		group by etoeid
		) itm on e.eid=itm.etoeid
		--LEFT JOIN eto_references itm on e.eid=itm.etoeid 
		where 
			((SELECT REPLACE(REPLACE(e.etoid, CHAR(13), ''), CHAR(10), '')) LIKE (select REPLACE(@etoNumber,'*','%')) or @etoNumber ='' or @etoNumber is null) and 
			(e.projectname LIKE (select REPLACE(@projectName,'*','%')) or @projectName ='' or @projectName is null) and 
			(e.customer LIKE (select REPLACE(@customername,'*','%'))  or @customername ='' or @customername is null) and 
			(e.weirorderno LIKE (select REPLACE(@ordernumber,'*','%')) or @ordernumber ='' or @ordernumber is null) and 
			(i.gadrawingref LIKE (select REPLACE('%' + @gagrowing + '%','*',''))  or @gagrowing ='' or @gagrowing is null) and 
			(it.documentref LIKE (select REPLACE('%' + @document + '%','*','')) or @document ='' or @document is null) and 
			--(id.hasrouting_itemid LIKE (select REPLACE(@routing,'*','%'))  or @routing ='' or @routing is null) and 
			(its.orderpartref LIKE (select REPLACE('%' + @orderparts + '%','*','')) or @orderparts ='' or @orderparts is null) and 
			(itm.referenceref LIKE (select REPLACE('%' + @reference + '%','*','')) or @reference ='' or @reference is null) 
	end
	else
	begin
		select  distinct top (@count) e.eid,e.etoid,e.projectname,e.weirorderno,e.customer,e.revision--,it.site as etodetail
		, gadrawingref, documentref, orderpartref, referenceref
		from eto_report e 
		left join 
		(
		select etoeid, stuff((
							select ',' + isnull ((gadrawings.itemid + '/'+ gadrawings.revision), ref.hasga_itemid) 
							from eto_hasgadrawing ref
							left outer join items gadrawings on ref.hasga_iid = gadrawings.iid
							where ref.etoeid=mainitem.etoeid 
							order by gadrawings.itemid
							for xml path('')
						),1,1,'') as gadrawingref
		from eto_hasgadrawing mainitem
		group by etoeid
		) i on e.eid=i.etoeid 
		--LEFT JOIN eto_hasgadrawing i on e.eid=i.etoeid 

		left join 
		(
		select etoeid, stuff((
							select ',' + isnull((hasdocuments.itemid  + '/'+ hasdocuments.revision), ref.hasdocument_itemid)
							from eto_hasdocument ref
							left outer join items hasdocuments on ref.hasdocument_iid = hasdocuments.iid
							where ref.etoeid=mainitem.etoeid 
							order by hasdocuments.itemid
							for xml path('')
						),1,1,'') as documentref
		from eto_hasdocument mainitem
		group by etoeid
		)  it on e.eid=it.etoeid 
		--LEFT JOIN eto_hasdocument it on e.eid=it.etoeid 
		--LEFT JOIN eto_hasrouting id on e.eid=id.etoeid 

		left join 
		(
		select etoeid, stuff((
							select ',' + isnull((orderpart.itemid + '/'+ orderpart.revision), ref.orderparts_itemid) 
							from eto_orderparts ref
							left outer join items orderpart on ref.orderparts_iid = orderpart.iid
							where ref.etoeid=mainitem.etoeid 
							order by orderpart.itemid
							for xml path('')
						),1,1,'') as orderpartref
		from eto_orderparts mainitem
		group by etoeid
		)  its on e.eid=its.etoeid 
		--LEFT JOIN eto_orderparts its on e.eid=its.etoeid 

		left join 
		(
		select etoeid, stuff((
							select ',' + isnull((reference.itemid + '/'+ reference.revision), ref.references_itemid) 
							from eto_references ref
							left outer join items reference on ref.references_iid = reference.iid
							where ref.etoeid=mainitem.etoeid 
							order by reference.itemid
							for xml path('')
						),1,1,'') as referenceref
		from eto_references mainitem
		group by etoeid
		) itm on e.eid=itm.etoeid
		--LEFT JOIN eto_references itm on e.eid=itm.etoeid 		
		where 
			((e.etoid in (SELECT value FROM strlist_to_tbl(@etoNumber))) or @etoNumber ='' or @etoNumber is null) and 
			(e.projectname=@projectName or @projectName ='' or @projectName is null) and 
			(e.customer=@customername or @customername ='' or @customername is null) and 
			(e.weirorderno=@ordernumber or @ordernumber ='' or @ordernumber is null) and 
			(i.gadrawingref like ('%' + @gagrowing + '%') or @gagrowing ='' or @gagrowing is null) and 
			(it.documentref like ('%' + @document + '%') or @document ='' or @document is null) and 
			(its.orderpartref like ('%' + @orderparts + '%') or @orderparts ='' or @orderparts is null) and 
			(itm.referenceref like ('%' + @reference + '%') or @reference ='' or @reference is null) 
	end
end
GO
