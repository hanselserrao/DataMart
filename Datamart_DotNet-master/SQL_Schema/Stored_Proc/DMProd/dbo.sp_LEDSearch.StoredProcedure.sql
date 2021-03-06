USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_LEDSearch]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LEDSearch] (@liftpartNumber nvarchar(100) ,@liftDocNumber nvarchar(100),@liftPartType int,@liftdesc nvarchar(100),@Compwhereused  nvarchar(100),@liftpartStatus int ,@Productwhere nvarchar(100),@hasCertification nvarchar(3), @hasInsDoc nvarchar(3), @tare  nvarchar(10),@wll nvarchar(10)  ,@tarevalue float ,@wllvalue float, @SearchBy int, @count int)
as
begin
	--[sp_LEDSearch] '4000000005',null,null,null,null,null,null,null,null,'null','null',null,null,1,100

	Declare @document NVARCHAR(max) 
	Declare @certification NVARCHAR(max) 
	Declare @partwhereused NVARCHAR(max) 
	Declare @productwhereused NVARCHAR(max) 

	IF (CHARINDEX('*', @liftpartNumber ) > 0 OR CHARINDEX('*', @liftDocNumber ) > 0 OR CHARINDEX('*', @liftPartType ) > 0 OR CHARINDEX('*', @liftdesc ) > 0 OR CHARINDEX('*', @Compwhereused ) > 0 OR CHARINDEX('*', @Productwhere ) > 0 OR CHARINDEX('*', @liftpartStatus ) > 0 OR CHARINDEX('*', @hasCertification ) > 0 OR CHARINDEX('*', @hasInsDoc ) > 0 OR CHARINDEX('*', @tarevalue ) > 0  OR CHARINDEX('*', @wllvalue ) > 0)
	begin
		select top (@count) [led_ir].iid,LEDItemID,revision,[led_ir].description,wll,tare,dco,drawingid,led_ir.[site],op.name as ledtype,
		op1.name as ledstatus,height,width,length,led_ir.toolname, 
		partname, productname, ledcer1.docname as instructiondoc, ledcer.docname as certificationdoc
		--ledcer.site as etodocdetail,part.partname as partwhere,product.productname as productwhere,ledcer.docname as certification,ledcer1.docname as document  
		from led_ir left join options op on led_ir.tooltype =op.oid
		left join options op1 on led_ir.toolstatus = op1.oid

		left join 
		(
		select toolid, stuff((
							select ',' + ref.partname 
							from led_support_part ref 
							where ref.toolid=mainitem.toolid 
							order by ref.toolid 
							for xml path('')
						),1,1,'') as partname
		from led_support_part mainitem
		group by toolid
		) part on led_ir.iid = part.toolid 
		--left join led_support_part part on led_ir.iid = part.toolid 

		left join 
		(
		select toolid, stuff((
							select ',' + ref.productname 
							from led_support_products ref 
							where ref.toolid=mainitem.toolid 
							order by ref.toolid 
							for xml path('')
						),1,1,'') as productname
		from led_support_products mainitem
		group by toolid
		) product on led_ir.iid =product.toolid
		--left join led_support_products product on led_ir.iid =product.toolid

		left join 
		(
		select toolid, stuff((
							select ',' + ref.docname 
							from led_iom_certificate ref 
							where ref.toolid=mainitem.toolid and ref.docrefid='2'
							order by ref.docname 
							for xml path('')
						),1,1,'') as docname
		from led_iom_certificate mainitem where mainitem.docrefid='2'
		group by toolid
		) ledcer on led_ir.iid =ledcer.toolid  
		--left join led_iom_certificate ledcer on led_ir.iid =ledcer.toolid  and ledcer.docrefid='2'

		left join 
		(
		select toolid, stuff((
							select ',' + ref.docname 
							from led_iom_certificate ref 
							where ref.toolid=mainitem.toolid and ref.docrefid='1'
							order by ref.docname 
							for xml path('')
						),1,1,'') as docname
		from led_iom_certificate mainitem where mainitem.docrefid='1'
		group by toolid
		) ledcer1 on led_ir.iid =ledcer1.toolid  
		--left join led_iom_certificate ledcer1 on led_ir.iid =ledcer1.toolid  and ledcer1.docrefid='1'
		where 1 = 1 AND led_ir.status='0'
		AND ((SELECT REPLACE(REPLACE(led_ir.LEDItemID, CHAR(13), ''), CHAR(10), '')) LIKE (select REPLACE(@liftpartNumber,'*','%')) OR @liftpartNumber ='' OR @liftpartNumber is NULL)
		and  (led_ir.drawingid LIKE (select REPLACE(@liftDocNumber,'*','%')) OR @liftDocNumber is NULL OR @liftDocNumber='')
		and  (led_ir.description LIKE (select REPLACE(@liftdesc,'*','%')) OR @liftdesc is NULL OR @liftdesc='')
		and  (led_ir.tooltype LIKE (select REPLACE(@liftPartType,'*','%')) OR @liftPartType is NULL OR @liftPartType='')
		and  (led_ir.toolstatus LIKE (select REPLACE(@liftpartStatus,'*','%'))  OR @liftpartStatus is NULL OR @liftpartStatus='')
		and ((@hasCertification is null OR  @hasCertification='') OR (ledcer.docname!='' and @hasCertification='1') OR (Isnull(ledcer.docname,'') ='' and @hasCertification='0'))
		and ((@hasInsDoc is null OR @hasInsDoc ='') OR (ledcer1.docname != '' and @hasInsDoc='1') OR (Isnull(ledcer1.docname,'') = '' and @hasInsDoc='0'))
		and  (product.productname LIKE (select REPLACE('%' + @Productwhere + '%','*',''))  OR @Productwhere is NULL OR @Productwhere='')
		and  (part.partname LIKE (select REPLACE('%' + @Compwhereused  + '%','*','%'))  OR @Compwhereused is NULL OR @Compwhereused='')
		and ((led_ir.tare  > @tarevalue AND @tare='>') OR (led_ir.tare < @tarevalue AND @tare='<') OR ( @tare = 'NULL' ))
		and ((led_ir.wll  > @wllvalue AND @wll='>') OR (led_ir.wll < @wllvalue AND @wll='<') OR ( @wll = 'NULL' ))
		Order BY
		CASE WHEN @SearchBy='0' THEN led_ir.iid END ASC,
		CASE WHEN @SearchBy='1' THEN led_ir.iid END DESC,
		CASE WHEN @SearchBy='3' THEN product.productname END DESC,
		CASE WHEN @SearchBy='2' THEN part.partname END DESC

		/*
		select @document=  COALESCE(@document + ',', '') + CAST(e.docname AS NVARCHAR(200)) from led_iom_certificate e 
		where e.toolid =@ledid  and e.docrefid='1'

		select @certification=  COALESCE(@certification + ',', '') + CAST(e.docname AS NVARCHAR(200)) from led_iom_certificate e 
		where e.toolid =@ledid  and e.docrefid='2'

		select @partwhere=  COALESCE(@partwhere + ',', '') + CAST(c.partname AS NVARCHAR(200)) from led_support_part c  
		where c.toolid =@ledid

		select @productwhere=  COALESCE(@productwhere + ',', '') + CAST(p.productname AS NVARCHAR(200)) from led_support_products p  
		where p.toolid =@ledid
		*/

	end
	else
	begin
		select  top (@count) [led_ir].iid,LEDItemID,revision,[led_ir].description,wll,tare,dco,drawingid,led_ir.[site],
		op.name as ledtype,op1.name as ledstatus,height,width,length,led_ir.toolname,
		partname, productname, ledcer1.docname as instructiondoc, ledcer.docname as certificationdoc
		from led_ir left join options op on led_ir.tooltype =op.oid
		left join options op1 on led_ir.toolstatus =op1.oid
		left join 
		(
		select toolid, stuff((
							select ',' + ref.partname 
							from led_support_part ref 
							where ref.toolid=mainitem.toolid 
							order by ref.toolid 
							for xml path('')
						),1,1,'') as partname
		from led_support_part mainitem
		group by toolid
		) part on led_ir.iid = part.toolid 
		--left join led_support_part part on led_ir.iid = part.toolid 

		left join 
		(
		select toolid, stuff((
							select ',' + ref.productname 
							from led_support_products ref 
							where ref.toolid=mainitem.toolid 
							order by ref.toolid 
							for xml path('')
						),1,1,'') as productname
		from led_support_products mainitem
		group by toolid
		) product on led_ir.iid =product.toolid
		--left join led_support_products product on led_ir.iid =product.toolid

		left join 
		(
		select toolid, stuff((
							select ',' + ref.docname 
							from led_iom_certificate ref 
							where ref.toolid=mainitem.toolid and ref.docrefid='2'
							order by ref.docname 
							for xml path('')
						),1,1,'') as docname
		from led_iom_certificate mainitem where mainitem.docrefid='2'
		group by toolid
		) ledcer on led_ir.iid =ledcer.toolid  
		--left join led_iom_certificate ledcer on led_ir.iid =ledcer.toolid  and ledcer.docrefid='2'

		left join 
		(
		select toolid, stuff((
							select ',' + ref.docname 
							from led_iom_certificate ref 
							where ref.toolid=mainitem.toolid and ref.docrefid='1'
							order by ref.docname 
							for xml path('')
						),1,1,'') as docname
		from led_iom_certificate mainitem where mainitem.docrefid='1'
		group by toolid
		) ledcer1 on led_ir.iid =ledcer1.toolid  
		--left join led_iom_certificate ledcer1 on led_ir.iid =ledcer1.toolid  and ledcer1.docrefid='1'

		where 1 = 1  AND led_ir.status='0'
		AND ((led_ir.LEDItemID in (SELECT value FROM strlist_to_tbl(@liftpartNumber))) OR @liftpartNumber ='' OR @liftpartNumber is NULL)
		and (led_ir.drawingid=@liftDocNumber OR @liftDocNumber is NULL OR @liftDocNumber='')
		and (led_ir.description =@liftdesc OR @liftdesc is NULL OR @liftdesc='')
		and (led_ir.tooltype=@liftPartType OR @liftPartType is NULL OR @liftPartType='')
		and (led_ir.toolstatus=@liftpartStatus OR @liftpartStatus is NULL OR @liftpartStatus='')
		and ((led_ir.tare  > @tarevalue AND @tare='>') OR (led_ir.tare < @tarevalue AND @tare='<') OR ( @tare = 'NULL' ))
		and ((led_ir.wll  > @wllvalue AND @wll='>') OR (led_ir.wll < @wllvalue AND @wll='<') OR ( @wll = 'NULL' ))
		and ((@hasCertification is null OR  @hasCertification='') OR (ledcer.docname!='' and @hasCertification='1') OR (Isnull(ledcer.docname,'')='' and @hasCertification='0'))
		and ((@hasInsDoc is null OR @hasInsDoc ='') OR (ledcer1.docname != '' and @hasInsDoc='1') OR (Isnull(ledcer1.docname,'') = '' and @hasInsDoc='0'))
		and (product.productname like ('%' + @Productwhere + '%') OR @Productwhere is NULL OR @Productwhere='')
		and (part.partname like  ('%' + @Compwhereused + '%') OR @Compwhereused is NULL OR @Compwhereused='')
		Order BY
		CASE WHEN @SearchBy='0' THEN led_ir.iid END ASC,
		CASE WHEN @SearchBy='1' THEN led_ir.iid END DESC,
		CASE WHEN @SearchBy='3' THEN product.productname END DESC,
		CASE WHEN @SearchBy='2' THEN part.partname END DESC
	end
end
GO
