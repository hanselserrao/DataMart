USE [DMProd]
GO
/****** Object:  UserDefinedFunction [dbo].[strlist_to_tbl]    Script Date: 06/24/2019 17:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[strlist_to_tbl] (@list nvarchar(MAX))

   RETURNS @tbl TABLE (value varchar(max) NOT NULL) AS

BEGIN

   DECLARE @pos        int,

           @nextpos    int,

           @valuelen   int

 

   SELECT @pos = 0, @nextpos = 1

 

   WHILE @nextpos > 0

   BEGIN

      SELECT @nextpos = charindex(',', @list, @pos + 1)

      SELECT @valuelen = CASE WHEN @nextpos > 0

                              THEN @nextpos

                              ELSE len(@list) + 1

                         END - @pos - 1

      INSERT @tbl (value)

         VALUES (rtrim(ltrim(convert(varchar, substring(@list, @pos + 1, @valuelen)))))

      SELECT @pos = @nextpos

   END

   RETURN

END
GO
