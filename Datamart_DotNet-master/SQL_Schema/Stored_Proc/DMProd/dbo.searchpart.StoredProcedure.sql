USE [DMProd]
GO
/****** Object:  StoredProcedure [dbo].[searchpart]    Script Date: 06/24/2019 17:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[searchpart](@prefix nvarchar(max))
as begin
IF (RIGHT(@prefix, 1) = '*')
   set @prefix = LEFT(@prefix, LEN(@prefix) - 1)
select distinct (itemid) from items where (SELECT REPLACE(REPLACE(itemid, CHAR(13), ''), CHAR(10), ''))like ''+@prefix+'%'
end
GO
