USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_ledsearchdetail]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ledsearchdetail]
@ledid int 
,@document NVARCHAR(max) OUTPUT
,@certification NVARCHAR(max) OUTPUT
,@partwhere NVARCHAR(max) OUTPUT
,@productwhere NVARCHAR(max) OUTPUT
AS
BEGIN
      SET NOCOUNT ON;
	  select @document=  COALESCE(@document + ',', '') + CAST(e.docname AS NVARCHAR(200)) from led_iom_certificate e 
		where e.toolid =@ledid  and e.docrefid='1'
		select @certification=  COALESCE(@certification + ',', '') + CAST(e.docname AS NVARCHAR(200)) from led_iom_certificate e 
		where e.toolid =@ledid  and e.docrefid='2'

		select @partwhere=  COALESCE(@partwhere + ',', '') + CAST(c.partname AS NVARCHAR(200)) from led_support_part c  
		where c.toolid =@ledid

		select @productwhere=  COALESCE(@productwhere + ',', '') + CAST(p.productname AS NVARCHAR(200)) from led_support_products p  
		where p.toolid =@ledid

end
GO
