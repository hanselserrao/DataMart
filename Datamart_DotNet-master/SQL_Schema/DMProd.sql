USE [master]
GO
/****** Object:  Database [DMProd]    Script Date: 06/24/2019 17:32:19 ******/
CREATE DATABASE [DMProd] ON  PRIMARY 
( NAME = N'DMProd', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\DMProd.mdf' , SIZE = 463872KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DMProd_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\DMProd_log.ldf' , SIZE = 916352KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DMProd] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DMProd].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DMProd] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [DMProd] SET ANSI_NULLS OFF
GO
ALTER DATABASE [DMProd] SET ANSI_PADDING OFF
GO
ALTER DATABASE [DMProd] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [DMProd] SET ARITHABORT OFF
GO
ALTER DATABASE [DMProd] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [DMProd] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [DMProd] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [DMProd] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [DMProd] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [DMProd] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [DMProd] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [DMProd] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [DMProd] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [DMProd] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [DMProd] SET  DISABLE_BROKER
GO
ALTER DATABASE [DMProd] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [DMProd] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [DMProd] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [DMProd] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [DMProd] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [DMProd] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [DMProd] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [DMProd] SET  READ_WRITE
GO
ALTER DATABASE [DMProd] SET RECOVERY SIMPLE
GO
ALTER DATABASE [DMProd] SET  MULTI_USER
GO
ALTER DATABASE [DMProd] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [DMProd] SET DB_CHAINING OFF
GO
USE [DMProd]
GO
/****** Object:  User [engsys]    Script Date: 06/24/2019 17:32:19 ******/
CREATE USER [engsys] FOR LOGIN [engsys] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [datamartprod]    Script Date: 06/24/2019 17:32:19 ******/
CREATE USER [datamartprod] FOR LOGIN [datamartprod] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[strlist_to_tbl]    Script Date: 06/24/2019 17:32:20 ******/
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
/****** Object:  Table [dbo].[useractivitycategory]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[useractivitycategory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NULL,
	[description] [varchar](255) NULL,
	[link] [varchar](225) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[useractivities]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[useractivities](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[refcategoryid] [varchar](45) NOT NULL,
	[refid] [varchar](45) NOT NULL,
	[action] [text] NULL,
	[actionlink] [varchar](225) NULL,
	[uid] [int] NULL,
	[ip] [varchar](45) NULL,
	[date] [datetime] NULL,
	[description1] [text] NULL,
	[description] [text] NULL,
	[browser] [varchar](225) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[usertype]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[usertype](
	[utid] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](45) NOT NULL,
	[description] [varchar](125) NULL,
	[createuser] [int] NOT NULL,
	[createdtm] [datetime] NOT NULL,
	[lastmoduser] [int] NOT NULL,
	[lastmoddtm] [datetime] NOT NULL,
	[status] [tinyint] NOT NULL,
 CONSTRAINT [PK__usertype__7C85834946E78A0C] PRIMARY KEY CLUSTERED 
(
	[utid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[users]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[users](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[username] [varchar](100) NULL,
	[password] [varbinary](100) NULL,
	[companyname] [varchar](128) NULL,
	[title] [varchar](64) NULL,
	[phone] [varchar](64) NULL,
	[fax] [varchar](64) NULL,
	[email] [varchar](100) NOT NULL,
	[lastlogin] [datetime] NOT NULL,
	[utype] [tinyint] NULL,
	[status] [tinyint] NULL,
	[manageremail] [varchar](100) NULL,
	[amr] [tinyint] NULL,
 CONSTRAINT [PK__users__DD70126466603565] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[datamart_search]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[datamart_search](
	[itemtype] [varchar](20) NOT NULL,
	[itemid] [int] NOT NULL,
	[itemdata] [nvarchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex_data] ON [dbo].[datamart_search] 
(
	[itemtype] ASC,
	[itemid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[category]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[category](
	[cid] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[description] [varchar](255) NOT NULL,
	[status] [int] NOT NULL,
	[createduser] [int] NOT NULL,
	[createdtm] [datetime] NOT NULL,
	[lastmoduser] [int] NOT NULL,
	[lastmoddtm] [datetime] NOT NULL,
 CONSTRAINT [PK_category] PRIMARY KEY CLUSTERED 
(
	[cid] ASC,
	[name] ASC,
	[description] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[attempts]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[attempts](
	[attemptid] [int] IDENTITY(1,1) NOT NULL,
	[usr] [varchar](100) NULL,
	[pwd] [varchar](100) NULL,
	[ip] [varchar](100) NULL,
	[ts] [datetime] NOT NULL,
	[browser] [varchar](45) NULL,
	[systemid] [int] NULL,
	[devicetype] [varchar](45) NULL,
	[uniqueid] [varchar](45) NULL,
	[attempts_status] [int] NOT NULL,
	[system_info] [varchar](45) NULL,
 CONSTRAINT [PK__attempts__93079C1E6A30C649] PRIMARY KEY CLUSTERED 
(
	[attemptid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[amr_request]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[amr_request](
	[amr_id] [int] IDENTITY(1,1) NOT NULL,
	[amr_type_id] [int] NOT NULL,
	[requested_by] [int] NULL,
	[status] [int] NULL,
	[item_no] [varchar](255) NULL,
	[request_no] [varchar](255) NULL,
	[new_material_code] [varchar](255) NULL,
	[date_requested] [datetime] NULL,
	[existing_material_code] [varchar](255) NULL,
	[drawing_no] [varchar](255) NULL,
	[part_description] [varchar](255) NULL,
	[site] [int] NULL,
	[priority] [int] NULL,
	[dco] [int] NULL,
	[due_date] [datetime] NULL,
	[drawing_rev_no] [varchar](255) NULL,
	[casting_requested] [int] NULL,
	[date_modified] [datetime] NULL,
	[modified_by] [int] NULL,
	[request_status] [int] NULL,
	[requestor_email] [varchar](255) NULL,
	[productid] [int] NULL,
	[remarks] [varchar](1024) NULL,
	[file_path] [varchar](100) NULL,
 CONSTRAINT [PK_amr_request] PRIMARY KEY CLUSTERED 
(
	[amr_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[real_displaynames]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[real_displaynames](
	[iid] [int] IDENTITY(1,1) NOT NULL,
	[real_name] [varchar](50) NOT NULL,
	[display_name] [varchar](50) NOT NULL,
	[status] [int] NOT NULL,
 CONSTRAINT [PK_real_displaynames] PRIMARY KEY CLUSTERED 
(
	[real_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[product]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [varchar](10) NOT NULL,
	[ProductDescription] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[ProductOwnerId] [int] NULL,
	[ProductOwnerEmail] [varchar](50) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[etoitem_report]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[etoitem_report](
	[erid] [int] NOT NULL,
	[eid] [int] NULL,
	[hasgadrwng_iid] [int] NULL,
	[hasdocument_iid] [int] NULL,
	[hasrouting] [int] NULL,
	[orderparts_iid] [int] NULL,
	[references_iid] [varchar](145) NULL,
	[status] [int] NULL,
	[createduser] [int] NULL,
	[createdtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[hasga_drawingid] [int] NULL,
	[hasrouting_drawingid] [int] NULL,
	[hasdocument_drawingid] [int] NULL,
	[orderparts_drawingid] [int] NULL,
	[references_drawingid] [int] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[eto_report]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[eto_report](
	[eid] [int] IDENTITY(1,1) NOT NULL,
	[etoid] [varchar](145) NULL,
	[projectname] [varchar](145) NULL,
	[weirorderno] [varchar](145) NULL,
	[customer] [varchar](145) NULL,
	[status] [int] NULL,
	[createduser] [int] NULL,
	[createdtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[revision] [varchar](45) NULL,
	[site] [varchar](10) NULL,
	[childid] [varchar](145) NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[eto_references]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[eto_references](
	[etorelid] [int] IDENTITY(1,1) NOT NULL,
	[etoeid] [int] NULL,
	[references_itemid] [nvarchar](126) NULL,
	[references_drawingid] [nvarchar](126) NULL,
	[site] [nvarchar](10) NULL,
	[status] [int] NULL,
	[references_iid] [int] NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[eto_orderparts]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[eto_orderparts](
	[etorelid] [int] IDENTITY(1,1) NOT NULL,
	[etoeid] [int] NULL,
	[orderparts_itemid] [nvarchar](126) NULL,
	[orderparts_drawingid] [nvarchar](126) NULL,
	[site] [nvarchar](10) NULL,
	[status] [int] NULL,
	[orderparts_iid] [int] NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[eto_hasrouting]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[eto_hasrouting](
	[etorelid] [int] IDENTITY(1,1) NOT NULL,
	[etoeid] [int] NULL,
	[hasrouting_itemid] [nvarchar](126) NULL,
	[hasrouting_drawingid] [nvarchar](126) NULL,
	[site] [nvarchar](10) NULL,
	[status] [int] NULL,
	[hasrouting_iid] [int] NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[eto_hasgadrawing]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[eto_hasgadrawing](
	[etorelid] [int] IDENTITY(1,1) NOT NULL,
	[etoeid] [int] NULL,
	[hasga_itemid] [nvarchar](126) NULL,
	[hasga_drawingid] [nvarchar](126) NULL,
	[site] [nvarchar](10) NULL,
	[status] [int] NULL,
	[hasga_iid] [int] NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[eto_hasdocument]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[eto_hasdocument](
	[etorelid] [int] IDENTITY(1,1) NOT NULL,
	[etoeid] [int] NULL,
	[hasdocument_itemid] [nvarchar](126) NULL,
	[hasdocument_drawingid] [nvarchar](126) NULL,
	[site] [nvarchar](10) NULL,
	[status] [int] NULL,
	[hasdocument_iid] [int] NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[documentitems_subtype]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[documentitems_subtype](
	[documentid] [int] IDENTITY(1,1) NOT NULL,
	[itemid] [varchar](255) NULL,
	[name] [varchar](255) NULL,
	[subtype] [varchar](20) NULL,
	[status] [int] NOT NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[site] [varchar](10) NOT NULL,
	[puid] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pcnitem_report]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pcnitem_report](
	[prid] [int] IDENTITY(1,1) NOT NULL,
	[pid] [int] NULL,
	[problemitem_iid] [int] NULL,
	[solutionitem_iid] [int] NULL,
	[impacteditem_iid] [int] NULL,
	[createduser] [int] NULL,
	[createdtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[status] [int] NULL,
	[puid] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[prid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pcn_solutionitem]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pcn_solutionitem](
	[prid] [int] IDENTITY(1,1) NOT NULL,
	[pid] [int] NULL,
	[solutionitem_iid] [int] NULL,
	[createduser] [int] NULL,
	[createdtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[status] [int] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pcn_report]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pcn_report](
	[pid] [int] IDENTITY(1,1) NOT NULL,
	[pcnid] [varchar](128) NULL,
	[revision] [varchar](50) NULL,
	[pcnname] [varchar](256) NULL,
	[description] [varchar](245) NULL,
	[synopsis] [varchar](256) NULL,
	[createduser] [int] NULL,
	[createdtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[status] [int] NULL,
	[site] [varchar](10) NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pcn_problemitem]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pcn_problemitem](
	[prid] [int] IDENTITY(1,1) NOT NULL,
	[pid] [int] NULL,
	[problemitem_iid] [int] NULL,
	[createduser] [int] NULL,
	[createdtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[status] [int] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pcn_impacteditem]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pcn_impacteditem](
	[prid] [int] IDENTITY(1,1) NOT NULL,
	[pid] [int] NULL,
	[impacteditem_iid] [int] NULL,
	[createduser] [int] NULL,
	[createdtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[status] [int] NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[options]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[options](
	[oid] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](45) NOT NULL,
	[description] [varchar](255) NOT NULL,
	[status] [int] NOT NULL,
	[createduser] [int] NOT NULL,
	[createdtm] [datetime] NOT NULL,
	[lastmoduser] [int] NOT NULL,
	[lastmoddtm] [datetime] NOT NULL,
	[categoryid] [int] NOT NULL,
 CONSTRAINT [PK_options_1] PRIMARY KEY CLUSTERED 
(
	[description] ASC,
	[categoryid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[lookup_data]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lookup_data](
	[code] [varchar](50) NOT NULL,
	[description] [varchar](255) NULL,
	[value] [varchar](255) NOT NULL,
 CONSTRAINT [PK_lookup_data] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[led_support_products]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[led_support_products](
	[productid] [int] IDENTITY(1,1) NOT NULL,
	[toolid] [int] NULL,
	[productname] [varchar](255) NULL,
	[description] [varchar](255) NULL,
	[ptype] [int] NULL,
	[status] [int] NOT NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[site] [varchar](10) NOT NULL,
	[puid] [nvarchar](20) NULL,
 CONSTRAINT [PK_products] PRIMARY KEY CLUSTERED 
(
	[productid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[led_support_part]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[led_support_part](
	[partid] [int] IDENTITY(1,1) NOT NULL,
	[partname] [varchar](255) NULL,
	[description] [varchar](255) NULL,
	[ptype] [int] NULL,
	[status] [int] NOT NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[toolid] [int] NULL,
	[site] [varchar](10) NOT NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[led_ir]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[led_ir](
	[iid] [int] IDENTITY(1,1) NOT NULL,
	[LEDItemID] [varchar](255) NULL,
	[revision] [varchar](50) NULL,
	[toolname] [varchar](255) NULL,
	[description] [varchar](255) NULL,
	[wll] [float] NULL,
	[tare] [float] NULL,
	[status] [int] NOT NULL,
	[createduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoduser] [int] NULL,
	[lastmoddtm] [datetime] NULL,
	[tooltype] [int] NULL,
	[toolstatus] [int] NULL,
	[length] [float] NULL,
	[width] [float] NULL,
	[height] [float] NULL,
	[dco] [varchar](255) NULL,
	[drawingid] [varchar](255) NULL,
	[site] [varchar](10) NOT NULL,
	[puid] [nvarchar](20) NULL,
 CONSTRAINT [PK_tools] PRIMARY KEY CLUSTERED 
(
	[iid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[led_iom_certificate]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[led_iom_certificate](
	[docid] [int] IDENTITY(1,1) NOT NULL,
	[docname] [varchar](255) NULL,
	[path] [varchar](255) NULL,
	[docrefid] [int] NULL,
	[doctype] [varchar](255) NULL,
	[description] [varchar](255) NULL,
	[createduser] [int] NULL,
	[lastmoduser] [int] NULL,
	[createddtm] [datetime] NULL,
	[lastmoddtm] [datetime] NULL,
	[toolid] [int] NULL,
	[site] [varchar](10) NULL,
	[puid] [nvarchar](20) NULL,
 CONSTRAINT [PK_documents] PRIMARY KEY CLUSTERED 
(
	[docid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[items_doc_references]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[items_doc_references](
	[idriid] [int] IDENTITY(1,1) NOT NULL,
	[iid] [int] NULL,
	[document_itemid] [varchar](128) NULL,
	[document_name] [nvarchar](256) NULL,
	[site] [varchar](10) NOT NULL,
	[createduser] [int] NOT NULL,
	[createdtm] [datetime] NOT NULL,
	[lastmoduser] [int] NOT NULL,
	[lastmoddtm] [datetime] NOT NULL,
	[status] [int] NOT NULL,
	[puid] [nvarchar](20) NULL,
 CONSTRAINT [DocRef_idriid] PRIMARY KEY CLUSTERED 
(
	[idriid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[items]    Script Date: 06/24/2019 17:32:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[items](
	[iid] [int] IDENTITY(1,1) NOT NULL,
	[itemid] [varchar](255) NOT NULL,
	[itemname] [varchar](255) NOT NULL,
	[description] [varchar](255) NULL,
	[revision] [varchar](255) NOT NULL,
	[drawingid] [varchar](255) NULL,
	[site] [varchar](255) NULL,
	[createduser] [int] NOT NULL,
	[createdtm] [datetime] NOT NULL,
	[lastmoduser] [int] NOT NULL,
	[lastmoddtm] [datetime] NOT NULL,
	[updatedrefid] [int] NULL,
	[status] [int] NOT NULL,
	[dcoid] [int] NULL,
	[designatedprefpart] [varchar](255) NULL,
	[length] [float] NULL,
	[width] [float] NULL,
	[height] [float] NULL,
	[weight] [float] NULL,
	[erp_part_name] [varchar](128) NULL,
	[erp_part_description] [varchar](256) NULL,
	[material_code] [varchar](10) NULL,
	[t4s_enabled] [int] NULL,
	[datereleased] [varchar](255) NULL,
	[aliasid] [varchar](255) NULL,
	[altid] [varchar](255) NULL,
	[drawing_revision] [varchar](255) NULL,
	[legacy_part_number] [varchar](128) NULL,
	[legacy_document_number] [varchar](128) NULL,
	[itemtype] [int] NULL,
	[itemstatus] [int] NULL,
	[encumbrance] [varchar](32) NULL,
	[puid] [nvarchar](20) NULL,
	[t4s_mm_status] [varchar](50) NULL,
	[t4s_dir_status] [varchar](50) NULL,
 CONSTRAINT [PK_items] PRIMARY KEY CLUSTERED 
(
	[iid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[DELTA_IMPORT_ALL_DATA_DEV]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[DELTA_IMPORT_ALL_DATA_DEV] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN

 TRUNCATE TABLE [DMProd_DELTA_1].[dbo].options;  
  SET IDENTITY_INSERT [DMProd_DELTA_1].[dbo].options ON;
  INSERT INTO [DMProd_DELTA_1].[dbo].[options]
           (oid
           ,[name]
           ,[description]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[categoryid])
   SELECT	oid
           ,[name]
           ,[description]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[categoryid]
           FROM [DMProd_Dev].[dbo].[options];
  SET IDENTITY_INSERT [DMProd_DELTA_1].[dbo].options OFF;  

TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[documentitems_subtype];           
INSERT INTO [DMProd_DELTA_1].[dbo].[documentitems_subtype]
           ([itemid]
           ,[name]
           ,[subtype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[site]
           ,[puid])
    SELECT [itemid]
           ,[name]
           ,[subtype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[site]
           ,[puid]
           FROM [DMProd_Dev].[dbo].[documentitems_subtype];

TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[eto_hasdocument];
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_hasdocument]
           ([etoeid]
           ,[hasdocument_itemid]
           ,[hasdocument_drawingid]
           ,[site]
           ,[status]
           ,[hasdocument_iid]
           ,[puid])
    SELECT [etoeid]
           ,[hasdocument_itemid]
           ,[hasdocument_drawingid]
           ,[site]
           ,[status]
           ,[hasdocument_iid]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[eto_hasdocument];

TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[eto_hasgadrawing];
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_hasgadrawing]
           ([etoeid]
           ,[hasga_itemid]
           ,[hasga_drawingid]
           ,[site]
           ,[status]
           ,[hasga_iid]
           ,[puid])
     SELECT [etoeid]
           ,[hasga_itemid]
           ,[hasga_drawingid]
           ,[site]
           ,[status]
           ,[hasga_iid]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[eto_hasgadrawing];
            
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[eto_hasrouting];
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_hasrouting]
           ([etoeid]
           ,[hasrouting_itemid]
           ,[hasrouting_drawingid]
           ,[site]
           ,[status]
           ,[hasrouting_iid]
           ,[puid])
     SELECT [etoeid]
           ,[hasrouting_itemid]
           ,[hasrouting_drawingid]
           ,[site]
           ,[status]
           ,[hasrouting_iid]
           ,[puid]           
           FROM [DMProd_Dev].[dbo].[eto_hasrouting];
TRUNCATE TABLE  [DMProd_DELTA_1].[dbo].[eto_orderparts];
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_orderparts]
           ([etoeid]
           ,[orderparts_itemid]
           ,[orderparts_drawingid]
           ,[site]
           ,[status]
           ,[orderparts_iid]
           ,[puid])
    SELECT  [etoeid]
           ,[orderparts_itemid]
           ,[orderparts_drawingid]
           ,[site]
           ,[status]
           ,[orderparts_iid]
           ,[puid]
           FROM [DMProd_Dev].[dbo].[eto_orderparts]
TRUNCATE TABLE  [DMProd_DELTA_1].[dbo].[eto_references];    
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_references]
           ([etoeid]
           ,[references_itemid]
           ,[references_drawingid]
           ,[site]
           ,[status]
           ,[references_iid]
           ,[puid])
     SELECT [etoeid]
           ,[references_itemid]
           ,[references_drawingid]
           ,[site]
           ,[status]
           ,[references_iid]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[eto_references]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[eto_report]
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_report]
           ([etoid]
           ,[projectname]
           ,[weirorderno]
           ,[customer]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[revision]
           ,[site]
           ,[childid]
           ,[puid])
     SELECT [etoid]
           ,[projectname]
           ,[weirorderno]
           ,[customer]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[revision]
           ,[site]
           ,[childid]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[eto_report]

TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[etoitem_report]
INSERT INTO [DMProd_DELTA_1].[dbo].[etoitem_report]
           ([erid]
           ,[eid]
           ,[hasgadrwng_iid]
           ,[hasdocument_iid]
           ,[hasrouting]
           ,[orderparts_iid]
           ,[references_iid]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[hasga_drawingid]
           ,[hasrouting_drawingid]
           ,[hasdocument_drawingid]
           ,[orderparts_drawingid]
           ,[references_drawingid]
           ,[puid])
     SELECT [erid]
           ,[eid]
           ,[hasgadrwng_iid]
           ,[hasdocument_iid]
           ,[hasrouting]
           ,[orderparts_iid]
           ,[references_iid]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[hasga_drawingid]
           ,[hasrouting_drawingid]
           ,[hasdocument_drawingid]
           ,[orderparts_drawingid]
           ,[references_drawingid]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[etoitem_report]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[itemreport_dataset]
INSERT INTO [DMProd_DELTA_1].[dbo].[itemreport_dataset]
           ([iid]
           ,[datasetname]
           ,[datasetdesc]
           ,[datasettype]
           ,[datasetstatus]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[documenttype]
           ,[pwnt_path]
           ,[psd_path]
           ,[pfile_name]
           ,[site]
           ,[puid])
     SELECT [iid]
           ,[datasetname]
           ,[datasetdesc]
           ,[datasettype]
           ,[datasetstatus]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[documenttype]
           ,[pwnt_path]
           ,[psd_path]
           ,[pfile_name]
           ,[site]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[itemreport_dataset]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[items];
INSERT INTO [DMProd_DELTA_1].[dbo].[items]  ([itemid]
           ,[itemname]
           ,[description]
           ,[revision]
           ,[drawingid]
           ,[site]
           ,[createduser]          
           ,[lastmoduser]          
           ,[updatedrefid]
           ,[status]
           ,[dcoid]
           ,[designatedprefpart]
           ,[length]
           ,[width]
           ,[height]
           ,[weight]
           ,[erp_part_name]
           ,[erp_part_description]
           ,[material_code]
           ,[t4s_enabled]
           ,[datereleased]
           ,[aliasid]
           ,[altid]
           ,[drawing_revision]
           ,[legacy_part_number]
           ,[legacy_document_number]
           ,[itemtype]
           ,[itemstatus]
           ,[encumbrance]
           ,[puid])
           SELECT [itemid]
           ,[itemname]
           ,[description]
           ,[revision]
           ,[drawingid]
           ,[site]
           ,[createduser]          
           ,[lastmoduser]          
           ,[updatedrefid]
           ,[status]
           ,[dcoid]
           ,[designatedprefpart]
           ,[length]
           ,[width]
           ,[height]
           ,[weight]
           ,[erp_part_name]
           ,[erp_part_description]
           ,[material_code]
           ,[t4s_enabled]
           ,[datereleased]
           ,[aliasid]
           ,[altid]
           ,[drawing_revision]
           ,[legacy_part_number]
           ,[legacy_document_number]
           ,[itemtype]
           ,[itemstatus]
           ,[encumbrance]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[items];
TRUNCATE TABLE   [DMProd_DELTA_1].[dbo].[items_doc_references]         
INSERT INTO [DMProd_DELTA_1].[dbo].[items_doc_references]
           ([iid]
           ,[document_itemid]
          
           ,[site]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
     SELECT [iid]
           ,[document_itemid]
          
           ,[site]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid]
           FROM [DMProd_Dev].[dbo].[items_doc_references]
TRUNCATE TABLE       [DMProd_DELTA_1].[dbo].[led_iom_certificate]  
INSERT INTO [DMProd_DELTA_1].[dbo].[led_iom_certificate]
           ([docname]
           ,[path]
           ,[docrefid]
           ,[doctype]
           ,[description]
           ,[createduser]
           ,[lastmoduser]
           ,[createddtm]
           ,[lastmoddtm]
           ,[toolid]
           ,[site]
           ,[puid])
    SELECT [docname]
           ,[path]
           ,[docrefid]
           ,[doctype]
           ,[description]
           ,[createduser]
           ,[lastmoduser]
           ,[createddtm]
           ,[lastmoddtm]
           ,[toolid]
           ,[site]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[led_iom_certificate]
TRUNCATE TABLE  [DMProd_DELTA_1].[dbo].[led_ir]   
INSERT INTO [DMProd_DELTA_1].[dbo].[led_ir]
           ([LEDItemID]
           ,[revision]
           ,[toolname]
           ,[description]
           ,[wll]
           ,[tare]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[tooltype]
           ,[toolstatus]
           ,[length]
           ,[width]
           ,[height]
           ,[dco]
           ,[drawingid]
           ,[site]
           ,[puid])
    SELECT  [LEDItemID]
           ,[revision]
           ,[toolname]
           ,[description]
           ,[wll]
           ,[tare]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[tooltype]
           ,[toolstatus]
           ,[length]
           ,[width]
           ,[height]
           ,[dco]
           ,[drawingid]
           ,[site] 
           ,[puid]
           FROM [DMProd_Dev].[dbo].[led_ir]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[led_support_part]
INSERT INTO [DMProd_DELTA_1].[dbo].[led_support_part]
           ([partname]
           ,[description]
           ,[ptype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[toolid]
           ,[site]
           ,[puid])
     SELECT [partname]
           ,[description]
           ,[ptype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[toolid]
           ,[site]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[led_support_part]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[led_support_products]
INSERT INTO [DMProd_DELTA_1].[dbo].[led_support_products]
           ([toolid]
           ,[productname]
           ,[description]
           ,[ptype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[site]
           ,[puid])
     SELECT [toolid]
           ,[productname]
           ,[description]
           ,[ptype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[site]
           ,[puid]
            FROM [DMProd_Dev].[dbo].[led_support_products]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[pcn_impacteditem]
INSERT INTO [DMProd_DELTA_1].[dbo].[pcn_impacteditem]
           ([pid]
           ,[impacteditem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
    SELECT [pid]
           ,[impacteditem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid]
           FROM [DMProd_Dev].[dbo].[pcn_impacteditem]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[pcn_problemitem]
INSERT INTO [DMProd_DELTA_1].[dbo].[pcn_problemitem]
           ([pid]
           ,[problemitem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
     SELECT [pid]
           ,[problemitem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid] FROM [DMProd_Dev].[dbo].[pcn_problemitem]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[pcn_report]
INSERT INTO [DMProd_DELTA_1].[dbo].[pcn_report]
           ([pcnid]
           ,[revision]
           ,[pcnname]
           ,[description]
           ,[synopsis]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[site]
           ,[puid])
     SELECT [pcnid]
           ,[revision]
           ,[pcnname]
           ,[description]
           ,[synopsis]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[site]
           ,[puid] FROM [DMProd_Dev].[dbo].[pcn_report]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[pcn_solutionitem]
INSERT INTO [DMProd_DELTA_1].[dbo].[pcn_solutionitem]
           ([pid]
           ,[solutionitem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
     SELECT [pid]
           ,[solutionitem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid]
           FROM [DMProd_Dev].[dbo].[pcn_solutionitem]
TRUNCATE TABLE  [DMProd_DELTA_1].[dbo].[pcnitem_report]
INSERT INTO [DMProd_DELTA_1].[dbo].[pcnitem_report]
           ([pid]
           ,[problemitem_iid]
           ,[solutionitem_iid]
           ,[impacteditem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
     SELECT [pid]
           ,[problemitem_iid]
           ,[solutionitem_iid]
           ,[impacteditem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid] FROM [DMProd_Dev].[dbo].[pcnitem_report];
	
/*TRUNCATE TABLE DMProd_DELTA_1.[dbo].[usertype];	
	SET IDENTITY_INSERT [usertype] on
insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (1, 'RegularUser', 'Premissions Restricted', 1, Getdate(), 1, Getdate(), 1)

insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (2,'Admin', 'Full Premissions', 1, Getdate(), 1, Getdate(), 1)

insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (3,'AMRUser', 'Create Problem Report', 1, Getdate(), 1, Getdate(), 1)

SET IDENTITY_INSERT [usertype] off
TRUNCATE TABLE DMProd_DELTA_1.[dbo].[users];
INSERT INTO DMProd_DELTA_1.[dbo].[users]
           ([first_name]
           ,[last_name]
           ,[username]
           ,[password]
           ,[companyname]
           ,[title]
           ,[phone]
           ,[fax]
           ,[email]
           
           ,[utype]
           ,[status]
           ,[manageremail]
           ,[amr])
     VALUES('Admin','Admin','Admin',0x70617373776F7264,NULL,NULL,NULL,NULL,'admin@admin.com',2,1,NULL,NULL);


---------- insert data in role table ------------
TRUNCATE TABLE [dbo].[userrole] 
insert into [dbo].[userrole] (uid, utid, enabled, createdon, createdby) 
select uid, isnull(utype,1), 'Y', GETDATE(), 1 from [dbo].[users]
update [dbo].[userrole] set utid=2 where uid = (select uid from [dbo].[users]  where email = 'admin@admin.com');

*/
            
            
	
END
GO
/****** Object:  Table [dbo].[itemreport_dataset]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[itemreport_dataset](
	[bid] [int] IDENTITY(1,1) NOT NULL,
	[iid] [int] NULL,
	[datasetname] [varchar](245) NULL,
	[datasetdesc] [varchar](245) NULL,
	[datasettype] [int] NULL,
	[datasetstatus] [int] NULL,
	[status] [int] NULL,
	[createduser] [int] NOT NULL,
	[createdtm] [datetime] NOT NULL,
	[lastmoduser] [int] NOT NULL,
	[lastmoddtm] [datetime] NOT NULL,
	[documenttype] [int] NULL,
	[pwnt_path] [varchar](245) NULL,
	[psd_path] [varchar](245) NULL,
	[pfile_name] [varchar](255) NULL,
	[site] [varchar](10) NULL,
	[puid] [nvarchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[intlist_to_tbl]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[intlist_to_tbl] (@list nvarchar(MAX))
   RETURNS @tbl TABLE (number int NOT NULL) AS
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
      INSERT @tbl (number)
         VALUES (convert(int, substring(@list, @pos + 1, @valuelen)))
      SELECT @pos = @nextpos
   END
   RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[GENERATE_OPTIONS]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GENERATE_OPTIONS]
	
AS
BEGIN


INSERT INTO [dbo].[options](name,description,status,categoryid) SELECT distinct PR1.PART_TYPE,PR1.PART_TYPE,'1','1'  FROM [DMProcessDB].[dbo].[LOAD_PARTREVISION] AS "PR1" where STATUS='0';
INSERT INTO [dbo].[options](name,description,status,categoryid) SELECT distinct RELEASE_STATUS,RELEASE_STATUS,'1','2'  FROM [DMProcessDB].[dbo].[LOAD_PARTREVISION] where STATUS='0'; 
INSERT INTO [dbo].[options] (name,description,status,categoryid) SELECT distinct DATASET_TYPE,DATASET_TYPE,'1','3'  FROM [DMProcessDB].[dbo].LOAD_DATASETS_TRANS where STATUS='0';   
INSERT INTO [dbo].[options](name,description,status,categoryid) SELECT distinct DATASET_REL_STATUS,DATASET_REL_STATUS,'1','4'  FROM [DMProcessDB].[dbo].LOAD_DATASETS_TRANS where STATUS='0';
INSERT INTO [dbo].[options] (name,description,status,categoryid) SELECT distinct DCO,DCO,'1','5'  FROM [DMProcessDB].[dbo].[LOAD_PARTREVISION] where STATUS='0' and DCO <> '';
     
     
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('Assembly/Master Drawing','DetailedPDF','1','6');
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('Material Specification','MaterialSpecSheet','1','6');
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('Other Drawings and Documents','PDF','1','6');
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('IOM Manual','DocumentRevision','1','6');
INSERT INTO [dbo].[options] (name,description,status,categoryid) values ('General Arrangement','Non DetailedPDF','1','6');


UPDATE [dbo].[options] SET "options".[name] = "dis".display_name FROM [dbo].[options] AS "options"
INNER JOIN [dbo].real_displaynames AS "dis"
ON "dis".real_name="options".description
WHERE  "options".categoryid='1';

END
GO
/****** Object:  StoredProcedure [dbo].[DeltaLoad]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lokesh Podigiri
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[DeltaLoad] 
	
	
AS
BEGIN
SET NOCOUNT ON
 BEGIN TRY

    BEGIN TRANSACTION;
-- ETO NULL is being compared. Check for all the tables.

	--[dbo].[items]
	MERGE [dbo].[items] as Target
	USING (SELECT DISTINCT t1.[PART_NUMBER] AS part_num,t1.[PART_NUMBER],t1.[PART_DESCRIPTION],t1.[PART_REVISION],t2.DRAWING_NUMBER,t1.SITE,t6.oid AS dco_id,t1.WLENGTH,t1.WIDTH  ,t1.HEIGHT,t1.ENCUMBRANCE,t1.WEIGHT,t1.ERP_PART_NAME,t1.ERP_PART_DESC,t1.DATE_RELEASED  ,t2.DRAWING_REVISION,t3.LEGACY_PART_NUMBER,t3.LEGACY_DRAWING_NUMBER,t4.oid AS part_type,t5.oid AS part_status,t1.STATUS,t1.PUID,t1.T4S_MM_STATUS,t1.T4S_DIR_STATUS 
	FROM [DMProcessDB_Delta].[dbo].[LOAD_PARTREVISION] as t1 	
	LEFT OUTER JOIN [DMProcessDB_Delta].[dbo].LOAD_DOCUMENTNUMBER as t2 ON t1.PART_NUMBER=t2.PART_NUMBER and t1.PART_REVISION=t2.PART_REVISION and t1.SITE=t2.SITE 
	LEFT OUTER JOIN [DMProcessDB_Delta].[dbo].LOAD_ALT_ALIAS_ID as t3 ON t1.PART_NUMBER=t3.ITEM_ID AND  t1.SITE=t3.SITE 
	LEFT OUTER JOIN dbo.[options] as t6 ON t6.name=t1.DCO AND t6.status='1' and t6.categoryid='5' 
	LEFT OUTER JOIN  dbo.[options]  as t4 ON t4.description=t1.PART_TYPE AND t4.status='1' and t4.categoryid='1' 
	LEFT OUTER JOIN  dbo.[options]  as t5 ON t5.name=t1.RELEASE_STATUS AND t5.status='1' and t5.categoryid='2'
	WHERE t1.STATUS in (0,1)) AS Source	
	ON Source.[PART_NUMBER]=Target.itemid AND Source.[PART_REVISION]=Target.revision AND Source.PUID=Target.PUID
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([itemid],[itemname],[description],[revision],[drawingid],[site],[updatedrefid],[status],[dcoid],[length],[width],
			[height],[encumbrance],[weight],[erp_part_name],[erp_part_description],[datereleased],[drawing_revision],[legacy_part_number],
			[legacy_document_number],[itemtype],[itemstatus],createduser,lastmoduser,lastmoddtm,puid,t4s_mm_status,t4s_dir_status) 
	VALUES (Source.[PART_NUMBER],Source.[PART_NUMBER],Source.[PART_DESCRIPTION],Source.[PART_REVISION],Source.DRAWING_NUMBER,Source.SITE,'1',Source.STATUS,ISNULL(Source.dco_id,0),Source.WLENGTH,Source.WIDTH  
			,Source.HEIGHT,Source.ENCUMBRANCE,Source.WEIGHT,Source.ERP_PART_NAME,Source.ERP_PART_DESC,Source.DATE_RELEASED  ,	Source.DRAWING_REVISION,Source.LEGACY_PART_NUMBER,
			Source.LEGACY_DRAWING_NUMBER,Source.part_type,Source.part_status ,'2','2',GETDATE(),Source.puid,Source.T4S_MM_STATUS,Source.T4S_DIR_STATUS)
	WHEN MATCHED
	THEN
	UPDATE SET Target.[description]=Source.[PART_DESCRIPTION],Target.[drawingid]=Source.DRAWING_NUMBER,Target.[site]=Source.SITE,Target.[updatedrefid]='1',Target.[status]=Source.STATUS,Target.[dcoid]=ISNULL(Source.dco_id,0),Target.[length]=Source.WLENGTH,Target.[width]=Source.WIDTH ,
	Target.[height]=Source.HEIGHT,Target.[encumbrance]=Source.ENCUMBRANCE,Target.[weight]=Source.WEIGHT,Target.[erp_part_name]=Source.ERP_PART_NAME,Target.[erp_part_description]=Source.ERP_PART_DESC,Target.[datereleased]=Source.DATE_RELEASED,Target.[drawing_revision]=Source.DRAWING_REVISION,Target.[legacy_part_number]=Source.LEGACY_PART_NUMBER
	,Target.[legacy_document_number]=Source.LEGACY_DRAWING_NUMBER,Target.[itemtype]=Source.part_type,Target.[itemstatus]=Source.part_status,Target.lastmoduser='2',Target.lastmoddtm=GETDATE(),Target.T4S_MM_STATUS=Source.t4s_mm_status,Target.T4S_DIR_STATUS=Source.t4s_dir_status
	OUTPUT $action,deleted.*,inserted.*;
	
	-- [dbo].documentitems_subtype
	MERGE [dbo].documentitems_subtype AS Target
	USING (SELECT DISTINCT t2.ITEM_ID,t2.NAME,t2.SUB_TYPE,t2.SITE,t2.PUID FROM DMProcessDB_Delta.dbo.LOAD_DOCUMENT_SUBTYPE t2 WHERE STATUS='0') AS Source
	ON  Source.ITEM_ID=Target.itemid AND Source.PUID=Target.PUID
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([itemid],[name],[subtype],[status],puid,createduser,createddtm,lastmoduser,lastmoddtm,[site]) 
	VALUES (Source.ITEM_ID,Source.NAME,Source.SUB_TYPE,'1',Source.PUID,'2',GETDATE(),'2',GETDATE(),Source.SITE)
	WHEN MATCHED
	THEN
	UPDATE SET Target.site=Source.SITE  , Target.[subtype] = Source.SUB_TYPE
	OUTPUT $action,deleted.*,inserted.*;
	
	--[dbo].[items_doc_references]
	MERGE [dbo].[items_doc_references] AS Target
	USING (SELECT DISTINCT	t1.iid,t2.DOCUMENT_ITEM_ID,t2.DOCUMENT_NAME,t2.SITE,t2.PUID 
	FROM [DMProcessDB_Delta].[dbo].LOAD_DOCITEM_REFERENCES  t2	
	LEFT OUTER JOIN [dbo].items t1 on t2.ITEM_ID=t1.itemid and t2.PART_REVISION=t1.revision and t2.SITE=t1.site and LEN(t1.iid) > 0 WHERE t2.STATUS='0') AS Source
	ON Target.[document_itemid]=Source.DOCUMENT_ITEM_ID AND Target.[iid]=Source.iid AND Target.puid=Source.PUID
	WHEN NOT MATCHED BY TARGET THEN
	INSERT([iid],[document_itemid],[document_name],[site],createduser,lastmoduser,lastmoddtm,puid)
	VALUES (Source.iid,Source.DOCUMENT_ITEM_ID,Source.DOCUMENT_NAME,Source.SITE,'2','2',GETDATE(),Source.PUID)
	WHEN MATCHED THEN
	UPDATE SET Target.[document_name]=Source.DOCUMENT_NAME ,Target.site=Source.SITE
	OUTPUT $action,deleted.*,inserted.*;
	
	--[dbo].[itemreport_dataset]
	MERGE [dbo].[itemreport_dataset] as Target
	USING (SELECT DISTINCT Items.iid as item_iid,Dataset.DATASET_NAME ,Dataset.DATASET_DESCRIPTION ,Options_DatsetType.oid  as DsetType_oid ,Options_DatsetRelStatus.oid as DsetStatus,
	CASE Dataset.PART_TYPE 
	WHEN 'DocumentRevision' THEN Options_DocumentPartType.oid 
	WHEN 'Document' THEN Options_DocumentPartType.oid 
	ELSE Options_DocumentDSType.oid END as part_type ,
	'E:\Datamart\Volume1\'+DESTFILE_PATH.FILE_PATH as file_path ,Dataset.SITE,Dataset.STATUS,Dataset.PUID as Dset_puid_sr
	FROM [DMProcessDB_Delta].[dbo].LOAD_DATASETS_TRANS AS Dataset 
	LEFT OUTER JOIN [dbo].items Items ON Items.itemid=Dataset.PART_NUMBER and Items.revision=Dataset.PART_REVISION and Items.site=Dataset.SITE 
	LEFT OUTER JOIN [dbo].options as Options_DatsetType ON Options_DatsetType.description=Dataset.DATASET_TYPE AND Options_DatsetType.status='1' and Options_DatsetType.categoryid='3' 
	LEFT OUTER JOIN [dbo].options as Options_DatsetRelStatus ON Options_DatsetRelStatus.description=Dataset.DATASET_REL_STATUS AND Options_DatsetRelStatus.status='1' and Options_DatsetRelStatus.categoryid='4' 
	LEFT OUTER JOIN [dbo].options as Options_DocumentPartType ON Options_DocumentPartType.name='IOM Manual' AND Options_DocumentPartType.status='1' and Options_DocumentPartType.categoryid='6' 
	LEFT OUTER JOIN [dbo].options as Options_DocumentDSType ON Options_DocumentDSType.description=Dataset.DATASET_TYPE AND Options_DocumentDSType.status='1' and Options_DocumentDSType.categoryid='6' 
	LEFT OUTER JOIN [DMProcessDB_Delta].[dbo].LOAD_DATASETS_FILESPATH as DESTFILE_PATH ON Dataset.DATASET_NAME=DESTFILE_PATH.DATASET_NAME and Dataset.PUID=DESTFILE_PATH.[DATASET_PUID] and Dataset.DATASET_TYPE=DESTFILE_PATH.DATASET_TYPE  
	left outer join [dbo].[itemreport_dataset] ir_dset ON ir_dset.[iid]=items.iid AND ir_dset.datasetname=Dataset.DATASET_NAME AND ir_dset.[datasettype]=Options_DatsetType.oid
	 WHERE Dataset.STATUS=0) AS Source
	ON Source.item_iid=Target.iid AND Source.DATASET_NAME=Target.[datasetname] AND Source.DsetType_oid=Target.[datasettype] AND Source.Dset_puid_sr=Target.puid
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([iid] ,[datasetname] ,[datasetdesc] ,[datasettype] ,[datasetstatus] ,[documenttype] ,[pfile_name] ,site,createduser,lastmoduser,lastmoddtm,status,puid) 
	VALUES (Source.item_iid,Source.DATASET_NAME,Source.DATASET_DESCRIPTION,Source.DsetType_oid,Source.DsetStatus,Source.part_type,Source.file_path,Source.SITE,'2','2',GETDATE(),Source.status,Source.Dset_puid_sr)
	WHEN MATCHED
	THEN
	UPDATE SET   Target.[datasetdesc]=Source.DATASET_DESCRIPTION , Target.[datasetstatus] =Source.DsetStatus ,  Target.[pfile_name] = Source.file_path , Target.site =Source.SITE , Target.status =Source.STATUS 
	OUTPUT $action,deleted.*,inserted.*;
	
	UPDATE [dbo].[itemreport_dataset] set [documenttype] = (SELECT oid from [dbo].[options] opt where opt.name='Other Drawings and Documents' and opt.[categoryid]='6') where [documenttype] is NULL or [documenttype] = '';
	
	--dbo.eto_report
	MERGE dbo.eto_report AS Target
	USING (SELECT distinct t1.ETO_NUMBER, t1.PROJECT_NAME, t1.ORDER_NUMBER, t1.CUSTOMER ,t1.ETO_REVISION, t1.SITE ,t1.STATUS 
	FROM DMProcessDB_Delta.dbo.LOAD_ETO_REV t1 WHERE t1.STATUS !='3') AS Source
	ON Target.etoid=Source.ETO_NUMBER AND Target.revision=Source.ETO_REVISION
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoid,projectname,weirorderno,customer,status,createduser,lastmoduser,revision,site)
	VALUES (Source.ETO_NUMBER,Source.PROJECT_NAME, Source.ORDER_NUMBER, Source.CUSTOMER ,Source.STATUS,'2','2',Source.ETO_REVISION, Source.SITE )
	WHEN MATCHED 
	THEN
	UPDATE SET Target.projectname=Source.PROJECT_NAME,Target.weirorderno=Source.ORDER_NUMBER,Target.customer=Source.CUSTOMER,Target.status=Source.STATUS,Target.lastmoduser=2,Target.site=Source.SITE
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.eto_hasgadrawing
	MERGE dbo.eto_hasgadrawing AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_has_ga'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='WGP4_has_ga'  AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.hasga_itemid=Source.related_item AND (Target.[hasga_iid]=Source.iid OR (Target.[hasga_iid] IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,hasga_itemid,hasga_drawingid,site,status,hasga_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED
	THEN
	UPDATE set Target.hasga_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.hasga_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.eto_hasdocument
	MERGE dbo.eto_hasdocument AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_has_doc'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='WGP4_has_doc' AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.hasdocument_itemid=Source.related_item AND (Target.hasdocument_iid=Source.iid OR (Target.hasdocument_iid IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,hasdocument_itemid,hasdocument_drawingid,site,status,hasdocument_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED
	THEN
	UPDATE SET Target.hasdocument_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.hasdocument_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.eto_hasrouting
	MERGE dbo.eto_hasrouting AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_has_routing'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='WGP4_has_routing' AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.hasrouting_itemid=Source.related_item  AND (Target.hasrouting_iid=Source.iid OR (Target.hasrouting_iid IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,hasrouting_itemid,hasrouting_drawingid,site,status,hasrouting_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED 
	THEN
	UPDATE SET Target.hasrouting_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.hasrouting_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.eto_references
	MERGE dbo.eto_references AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_eto_references'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='WGP4_eto_references'  AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.references_itemid=Source.related_item  AND (Target.references_iid=Source.iid OR (Target.references_iid IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,references_itemid,references_drawingid,site,status,references_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED
	 THEN
	UPDATE SET Target.references_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.references_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
		
	--dbo.eto_orderparts
	MERGE dbo.eto_orderparts AS Target
	USING (SELECT DISTINCT t2.eid,t1.related_item,t3.drawingid,t2.site,t3.iid,t1.STATUS
	FROM  DMProcessDB_Delta.dbo.LOAD_ETO_REV t1
	LEFT JOIN dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='order-parts'
	LEFT JOIN dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]	
	WHERE t1.RELATION_NAME='order-parts' AND  t1.STATUS !='3') AS Source
	ON Target.etoeid=Source.eid AND Target.orderparts_itemid=Source.related_item AND (Target.orderparts_iid=Source.iid OR (Target.orderparts_iid IS NULL and Source.iid IS NULL))
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (etoeid,orderparts_itemid,orderparts_drawingid,site,status,orderparts_iid,createduser,lastmoduser) 
	VALUES ( Source.eid,Source.related_item,Source.drawingid,Source.site,Source.STATUS,Source.iid,'2','2')
	WHEN MATCHED
	THEN
	UPDATE SET Target.orderparts_drawingid=Source.drawingid,Target.site=Source.SITE,Target.status=Source.STATUS,Target.orderparts_iid=Source.iid,lastmoduser=2,lastmoddtm=GETDATE()
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.pcn_report
	MERGE dbo.pcn_report AS Target
	USING (SELECT distinct [PCN_NUMBER],[PCN_REVISION],[PCN_DESCRIPTION],PCN.[SYNOPSIS],PCN.[SITE],PCN.STATUS 
	FROM [DMProcessDB_Delta].[dbo].[LOAD_PCN] AS PCN WHERE PCN.STATUS != '3') AS Source
	ON Target.pcnid=Source.[PCN_NUMBER] AND Target.revision=Source.[PCN_REVISION] 
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([pcnid],[revision],[pcnname] ,[description],[synopsis],[createduser] ,[lastmoduser],[status],[site])
	VALUES (Source.[PCN_NUMBER],Source.[PCN_REVISION],Source.[PCN_NUMBER],Source.[PCN_DESCRIPTION],Source.[SYNOPSIS],'2','2',Source.STATUS,Source.[SITE])
	WHEN MATCHED
	THEN
	UPDATE SET Target.[pcnname]=Source.[PCN_NUMBER] ,Target.[description]=Source.[PCN_DESCRIPTION],Target.[synopsis]=Source.[SYNOPSIS],Target.[site]=Source.[SITE],Target.STATUS=Source.STATUS
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.pcn_impacteditem
	MERGE dbo.pcn_impacteditem AS Target
	USING (SELECT distinct PCN_REPORT.[pid],IMPACTED_ITEM.iid ,PCN_REPORT.status FROM [dbo].[pcn_report] AS PCN_REPORT  
	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision  
	LEFT OUTER JOIN [dbo].items AS IMPACTED_ITEM ON IMPACTED_ITEM.itemid = PCN.RELATED_ITEM AND IMPACTED_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasImpactedItem' 	
	WHERE IMPACTED_ITEM.iid IS NOT NULL AND PCN.STATUS !='3') AS Source
	ON Target.pid=Source.pid AND Target.impacteditem_iid=Source.iid 
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (pid,impacteditem_iid,createduser,lastmoduser,status)
	VALUES (Source.pid,Source.iid,'2','2',Source.STATUS )
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.pcn_problemitem
	MERGE dbo.pcn_problemitem AS Target
	USING (SELECT distinct PCN_REPORT.[pid],PROBLEM_ITEM.iid ,PCN_REPORT.status FROM [dbo].[pcn_report] AS PCN_REPORT  
	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision  
	LEFT OUTER JOIN [dbo].items AS PROBLEM_ITEM ON PROBLEM_ITEM.itemid = PCN.RELATED_ITEM AND PROBLEM_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasProblemItem' 	
	WHERE PROBLEM_ITEM.iid IS NOT NULL AND PCN.STATUS !='3') AS Source
	ON Target.pid=Source.pid AND Target.[problemitem_iid]=Source.iid 
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (pid,[problemitem_iid],createduser,lastmoduser,status)
	VALUES (Source.pid,Source.iid,'2','2',Source.STATUS )
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.[pcn_solutionitem]
	MERGE dbo.[pcn_solutionitem] AS Target
	USING (SELECT distinct PCN_REPORT.[pid],SOLUTION_ITEM.iid ,PCN_REPORT.status FROM [dbo].[pcn_report] AS PCN_REPORT  
	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision  
	LEFT OUTER JOIN [dbo].items AS SOLUTION_ITEM ON SOLUTION_ITEM.itemid = PCN.RELATED_ITEM AND SOLUTION_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasSolutionItem' 	
	WHERE SOLUTION_ITEM.iid IS NOT NULL AND PCN.STATUS !='3') AS Source
	ON Target.pid=Source.pid AND Target.[solutionitem_iid]=Source.iid 
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (pid,[solutionitem_iid],createduser,lastmoduser,status)
	VALUES (Source.pid,Source.iid,'2','2',Source.STATUS)
	OUTPUT $action,deleted.*,inserted.*;
	
	--dbo.led_ir
	MERGE dbo.led_ir AS Target
	USING (SELECT DISTINCT LED_IR.LED_ITEM_ID,LED_IR.LED_REVISION,LED_IR.DESCRIPTION,LED_IR.WLL,LED_IR.TARE,Options_ItemType.oid as Item_Type,Options_ItemRelStat.oid as Rel_Status,LED_IR.WLENGTH,LED_IR.WIDTH,LED_IR.HEIGHT,LED_IR.DCO,DOC_NUM.DRAWING_NUMBER,LED_IR.SITE
 	FROM DMProcessDB_Delta.dbo.LOAD_LED_IR AS LED_IR 
 	LEFT OUTER JOIN dbo.options as Options_ItemType ON Options_ItemType.description=LED_IR.LED_ITEMTYPE AND Options_ItemType.status='1' and Options_ItemType.categoryid='1' 
 	LEFT OUTER JOIN dbo.options as Options_ItemRelStat ON Options_ItemRelStat.name=LED_IR.RELEASE_STATUS AND Options_ItemRelStat.status='1' and Options_ItemRelStat.categoryid='2' 
 	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_DOCUMENTNUMBER as DOC_NUM ON LED_IR.LED_ITEM_ID=DOC_NUM.PART_NUMBER and LED_IR.LED_REVISION=DOC_NUM.PART_REVISION and LED_IR.SITE=DOC_NUM.SITE
 	where LED_IR.STATUS='0') AS Source
 	ON Target.[LEDItemID]=Source.LED_ITEM_ID AND Target.[revision]=Source.LED_REVISION
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (LEDItemID,revision,toolname,description,wll,tare,status,createduser,lastmoduser,tooltype,toolstatus,length,width,height,dco,drawingid,site)
	VALUES (Source.LED_ITEM_ID,Source.LED_REVISION,Source.LED_ITEM_ID,Source.DESCRIPTION,Source.WLL,Source.TARE,0,2,2,Source.Item_Type,Source.Rel_Status,Source.WLENGTH,Source.WIDTH,Source.HEIGHT,Source.DCO,Source.DRAWING_NUMBER,Source.SITE)
	WHEN MATCHED
	THEN
	UPDATE SET toolname=Source.LED_ITEM_ID,description=Source.DESCRIPTION,wll=Source.WLL,tare=Source.TARE,lastmoduser=2,tooltype=Source.Item_Type,toolstatus=Source.Rel_Status,length=Source.WLENGTH,width=Source.WIDTH,height=Source.HEIGHT,dco=Source.DCO,drawingid=Source.DRAWING_NUMBER,site=Source.SITE
	OUTPUT $action,deleted.*,inserted.*;
	
	MERGE dbo.led_support_products AS Target
	USING (SELECT DISTINCT PRODUCTS.SUPPORT_PRODUCT_ITEM_ID,PRODUCTS.DATE_IMPORTED,LED_ITEMREV.iid,PRODUCTS.SITE 
	FROM DMProcessDB_Delta.dbo.LOAD_LED_SUPPORTPRODUCT AS PRODUCTS 
	LEFT OUTER JOIN dbo.led_ir AS LED_ITEMREV ON LED_ITEMREV.LEDItemID=PRODUCTS.LED_ITEM_ID AND LED_ITEMREV.revision=PRODUCTS.LED_ITEM_REVISION 
	WHERE LEN(PRODUCTS.SUPPORT_PRODUCT_ITEM_ID) >1 and LED_ITEMREV.status='0') AS Source
	ON Source.iid=Target.toolid AND Source.SUPPORT_PRODUCT_ITEM_ID=Target.productname
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (productname,status,createduser,createddtm,lastmoduser,toolid,site)
	VALUES(Source.SUPPORT_PRODUCT_ITEM_ID,0,2,GETDATE(),2,Source.iid,Source.site)
	OUTPUT $action,deleted.*,inserted.*;
	
	MERGE dbo.led_support_part AS Target
	USING (SELECT DISTINCT PARTS.SUPPORT_PART_ITEM_ID,PARTS.DATE_IMPORTED,LED_ITEMREV.iid,PARTS.SITE FROM DMProcessDB_Delta.dbo.LOAD_LED_SUPPORTPARTS AS PARTS 
	LEFT OUTER JOIN dbo.led_ir AS LED_ITEMREV ON LED_ITEMREV.LEDItemID=PARTS.LED_ITEM_ID AND LED_ITEMREV.revision=PARTS.LED_ITEM_REVISION  
	WHERE LEN(PARTS.SUPPORT_PART_ITEM_ID) >1 and LED_ITEMREV.status='0') AS Source
	ON Source.iid=Target.toolid AND Source.SUPPORT_PART_ITEM_ID=Target.partname
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (partname,status,createduser,createddtm,lastmoduser,toolid,site)
	VALUES(Source.SUPPORT_PART_ITEM_ID,0,2,GETDATE(),2,Source.iid,Source.site)
	OUTPUT $action,deleted.*,inserted.*;
	
	MERGE dbo.led_iom_certificate AS Target
	USING (SELECT DISTINCT LED_ITEMREV.iid,IOM.IOM_ITEM_ID,LED_ITEMREV.site 
	FROM dbo.led_ir AS LED_ITEMREV 
	LEFT OUTER JOIN DMProcessDB_Delta.dbo.LOAD_LED_IOM as IOM ON LED_ITEMREV.LEDItemID=IOM.LED_ITEM_ID AND LED_ITEMREV.revision=IOM.LED_ITEM_REVISION  
	where LEN(IOM.IOM_ITEM_ID)>0 and LED_ITEMREV.status='0') AS Source
	ON Source.iid=Target.toolid AND Source.IOM_ITEM_ID=Target.docname
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (docname,docrefid,createduser,createddtm,lastmoduser,toolid,site)
	VALUES(Source.IOM_ITEM_ID,1,2,GETDATE(),2,Source.iid,Source.site)
	OUTPUT $action,deleted.*,inserted.*;
	
	MERGE dbo.led_iom_certificate AS Target
	USING (SELECT DISTINCT LED_ITEMREV.iid,CERTIFICATE.CERTIFICATE_ITEM_ID,LED_ITEMREV.site FROM DMProd.dbo.led_ir AS LED_ITEMREV 
	LEFT OUTER JOIN DMProcessDB.dbo.LOAD_LED_CERTIFICATE as CERTIFICATE ON LED_ITEMREV.LEDItemID=CERTIFICATE.LED_ITEM_ID AND LED_ITEMREV.revision=CERTIFICATE.LED_ITEM_REVISION  
	where LEN(CERTIFICATE.CERTIFICATE_ITEM_ID)>0 and LED_ITEMREV.status='0') AS Source
	ON Source.iid=Target.toolid AND Source.CERTIFICATE_ITEM_ID=Target.docname
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (docname,docrefid,createduser,createddtm,lastmoduser,toolid,site)
	VALUES(Source.CERTIFICATE_ITEM_ID,2,2,GETDATE(),2,Source.iid,Source.site)
	OUTPUT $action,deleted.*,inserted.*;
	
	--COMMIT TRANSACTION;

  END TRY

  BEGIN CATCH
IF @@TRANCOUNT > 0

    ROLLBACK TRANSACTION;
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorLine INT = ERROR_LINE();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE(); 

    PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
    PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10)); 

    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

  END CATCH;
  IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;
	
END
GO
/****** Object:  StoredProcedure [dbo].[searchpart]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[searchleddetail]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[searchleddetail](@partid bigint)
as begin


select distinct(it.iid),it.LEDItemID as itemid,it.toolname as itemname,it.description,it.revision,it.drawingid,it.site,dcoid=(op2.name),it.length,it.width,it.height,op.name as itemtype,op1.name,
doc.document_itemid,doc.status as docstatus,opw.name as doctype, doc.document_itemid,itemdt.datasetdesc as docdesc,
 pcn.pcnid,pcn.revision as pcnrevision,pcn.synopsis,pcn.description as pcndescription,problemitem_iid=(select top 1 items.drawingid   from items
  left join  pcnitem_report pcnitem  on pcnitem.problemitem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid  and items.iid=@partid), solutionitem_iid=(select top 1 led_ir.drawingid  from led_ir
  left join  pcnitem_report pcnitem  on pcnitem.solutionitem_iid=led_ir.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid and led_ir.iid=@partid),
  impacteditem_iid=( select top 1 items.drawingid  from items
  left join  pcnitem_report pcnitem  on pcnitem.impacteditem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid  and items.iid=@partid),

  problemitem_revision=(select top 1 items.drawingid   from items
  left join  pcnitem_report pcnitem  on pcnitem.problemitem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid  and items.iid=@partid), solutionitem_revision=(select top 1 items.drawingid  from items
  left join  pcnitem_report pcnitem  on pcnitem.solutionitem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid and items.iid=@partid),
  impacteditem_revision=( select top 1 items.drawingid  from items
  left join  pcnitem_report pcnitem  on pcnitem.impacteditem_iid=items.iid
  left join pcn_report pcn on pcn.pid=pcnitem.pid  and items.iid=@partid),

  eto.etoid as etonumber,eto.projectname,eto.weirorderno as ordernumber, eto.customer,etohas.hasga_itemid as ga
  ,etohasdoc.hasdocument_itemid  as document,etohasroute.hasrouting_itemid as routing,etoorder.orderparts_itemid as docpart, etoref.references_itemid as ref
  
  
   from led_ir it  left join options op on op.oid=it.tooltype 
  left join options op1 on op1.oid=it.toolstatus
 left join  options op2 on op2.oid=it.iid and op2.categoryid='5'
 left join [dbo].[itemreport_dataset] itemdt on itemdt.bid=it.iid left join options opw on opw.oid=itemdt.documenttype
left join items_doc_references doc on doc.iid=it.iid left join documentitems_subtype docitem on docitem.itemid=it.LEDItemID 
left join pcnitem_report pcitre on pcitre.pid=it.iid left join pcn_report pcn on pcn.pid= pcitre.pid
left join etoitem_report etoitre on etoitre.eid=it.iid left join eto_report eto on eto.eid= etoitre.eid  
left join  [dbo].[eto_hasgadrawing] etohas on etohas.etoeid=etoitre.hasgadrwng_iid 
left join  [dbo].[eto_hasrouting] etohasroute on etohasroute.etoeid=etoitre.hasrouting
left join  [dbo].[eto_hasdocument] etohasdoc on etohasdoc.etoeid=etoitre.hasdocument_iid
left join  [dbo].[eto_orderparts] etoorder on etoorder.etorelid=etoitre.orderparts_iid
left join  [dbo].[eto_references] etoref on etoref.etoeid=eto.eid
where it.iid=@partid

end
GO
/****** Object:  StoredProcedure [dbo].[searchdocdetail]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[searchdocdetail](@partid bigint)
as begin


select distinct(it.iid),it.itemid,it.itemname,it.description,it.revision,it.drawingid,it.site,dcoid=(op2.description),it.length,it.width,it.height,it.weight,it.datereleased,it.legacy_part_number,it.legacy_document_number,op.name as itemtype,op1.name,
doc.document_itemid,doc.status as docstatus,docitem.subtype as doctype, doc.document_itemid,
 pcn.pcnid,pcn.revision as pcnrevision,pcn.synopsis,pcn.description as pcndescription,pcitre.problemitem_iid, pcitre.solutionitem_iid, pcitre.impacteditem_iid from items it  left join options op on op.oid=it.itemtype  join options op1 on op1.oid=it.itemstatus
 left join   options op2 on op2.oid=it.dcoid and op2.categoryid='6'
left join items_doc_references doc on doc.iid=it.iid left join documentitems_subtype docitem on docitem.itemid=it.itemid 
left join pcnitem_report pcitre on pcitre.pid=it.iid left join pcn_report pcn on pcn.pid= pcitre.pid
--left join etoitem_report etoitre on etoitre.eid=it.iid join eto_report eto on eto.eid= etoitre.eid  
--join  [dbo].[eto_hasgadrawing] etohas on etohas.hasga_drawingid=etoitre.hasgadrwng_iid 
--join  [dbo].[eto_hasrouting] etohasroute on etohasroute.hasrouting_itemid=etoitre.hasrouting
--join  [dbo].[eto_orderparts] etoorder on etoorder.orderparts_itemid=etoitre.orderparts_iid

where it.iid=@partid

end
GO
/****** Object:  StoredProcedure [dbo].[DELTA_IMPORT_ALL_DATA]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[DELTA_IMPORT_ALL_DATA] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN

 TRUNCATE TABLE [DMProd_DELTA_1].[dbo].options;  
  SET IDENTITY_INSERT [DMProd_DELTA_1].[dbo].options ON;
  INSERT INTO [DMProd_DELTA_1].[dbo].[options]
           (oid
           ,[name]
           ,[description]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[categoryid])
   SELECT	oid
           ,[name]
           ,[description]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[categoryid]
           FROM [DMProd].[dbo].[options];
  SET IDENTITY_INSERT [DMProd_DELTA_1].[dbo].options OFF;  

TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[documentitems_subtype];           
INSERT INTO [DMProd_DELTA_1].[dbo].[documentitems_subtype]
           ([itemid]
           ,[name]
           ,[subtype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[site]
           ,[puid])
    SELECT [itemid]
           ,[name]
           ,[subtype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[site]
           ,[puid]
           FROM [DMProd].[dbo].[documentitems_subtype];

TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[eto_hasdocument];
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_hasdocument]
           ([etoeid]
           ,[hasdocument_itemid]
           ,[hasdocument_drawingid]
           ,[site]
           ,[status]
           ,[hasdocument_iid]
           ,[puid])
    SELECT [etoeid]
           ,[hasdocument_itemid]
           ,[hasdocument_drawingid]
           ,[site]
           ,[status]
           ,[hasdocument_iid]
           ,[puid]
            FROM [DMProd].[dbo].[eto_hasdocument];

TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[eto_hasgadrawing];
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_hasgadrawing]
           ([etoeid]
           ,[hasga_itemid]
           ,[hasga_drawingid]
           ,[site]
           ,[status]
           ,[hasga_iid]
           ,[puid])
     SELECT [etoeid]
           ,[hasga_itemid]
           ,[hasga_drawingid]
           ,[site]
           ,[status]
           ,[hasga_iid]
           ,[puid]
            FROM [DMProd].[dbo].[eto_hasgadrawing];
            
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[eto_hasrouting];
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_hasrouting]
           ([etoeid]
           ,[hasrouting_itemid]
           ,[hasrouting_drawingid]
           ,[site]
           ,[status]
           ,[hasrouting_iid]
           ,[puid])
     SELECT [etoeid]
           ,[hasrouting_itemid]
           ,[hasrouting_drawingid]
           ,[site]
           ,[status]
           ,[hasrouting_iid]
           ,[puid]           
           FROM [DMProd].[dbo].[eto_hasrouting];
TRUNCATE TABLE  [DMProd_DELTA_1].[dbo].[eto_orderparts];
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_orderparts]
           ([etoeid]
           ,[orderparts_itemid]
           ,[orderparts_drawingid]
           ,[site]
           ,[status]
           ,[orderparts_iid]
           ,[puid])
    SELECT  [etoeid]
           ,[orderparts_itemid]
           ,[orderparts_drawingid]
           ,[site]
           ,[status]
           ,[orderparts_iid]
           ,[puid]
           FROM [DMProd].[dbo].[eto_orderparts]
TRUNCATE TABLE  [DMProd_DELTA_1].[dbo].[eto_references];    
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_references]
           ([etoeid]
           ,[references_itemid]
           ,[references_drawingid]
           ,[site]
           ,[status]
           ,[references_iid]
           ,[puid])
     SELECT [etoeid]
           ,[references_itemid]
           ,[references_drawingid]
           ,[site]
           ,[status]
           ,[references_iid]
           ,[puid]
            FROM [DMProd].[dbo].[eto_references]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[eto_report]
INSERT INTO [DMProd_DELTA_1].[dbo].[eto_report]
           ([etoid]
           ,[projectname]
           ,[weirorderno]
           ,[customer]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[revision]
           ,[site]
           ,[childid]
           ,[puid])
     SELECT [etoid]
           ,[projectname]
           ,[weirorderno]
           ,[customer]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[revision]
           ,[site]
           ,[childid]
           ,[puid]
            FROM [DMProd].[dbo].[eto_report]

TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[etoitem_report]
INSERT INTO [DMProd_DELTA_1].[dbo].[etoitem_report]
           ([erid]
           ,[eid]
           ,[hasgadrwng_iid]
           ,[hasdocument_iid]
           ,[hasrouting]
           ,[orderparts_iid]
           ,[references_iid]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[hasga_drawingid]
           ,[hasrouting_drawingid]
           ,[hasdocument_drawingid]
           ,[orderparts_drawingid]
           ,[references_drawingid]
           ,[puid])
     SELECT [erid]
           ,[eid]
           ,[hasgadrwng_iid]
           ,[hasdocument_iid]
           ,[hasrouting]
           ,[orderparts_iid]
           ,[references_iid]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[hasga_drawingid]
           ,[hasrouting_drawingid]
           ,[hasdocument_drawingid]
           ,[orderparts_drawingid]
           ,[references_drawingid]
           ,[puid]
            FROM [DMProd].[dbo].[etoitem_report]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[itemreport_dataset]
INSERT INTO [DMProd_DELTA_1].[dbo].[itemreport_dataset]
           ([iid]
           ,[datasetname]
           ,[datasetdesc]
           ,[datasettype]
           ,[datasetstatus]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[documenttype]
           ,[pwnt_path]
           ,[psd_path]
           ,[pfile_name]
           ,[site]
           ,[puid])
     SELECT [iid]
           ,[datasetname]
           ,[datasetdesc]
           ,[datasettype]
           ,[datasetstatus]
           ,[status]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[documenttype]
           ,[pwnt_path]
           ,[psd_path]
           ,[pfile_name]
           ,[site]
           ,[puid]
            FROM [DMProd].[dbo].[itemreport_dataset]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[items];
INSERT INTO [DMProd_DELTA_1].[dbo].[items]  ([itemid]
           ,[itemname]
           ,[description]
           ,[revision]
           ,[drawingid]
           ,[site]
           ,[createduser]          
           ,[lastmoduser]          
           ,[updatedrefid]
           ,[status]
           ,[dcoid]
           ,[designatedprefpart]
           ,[length]
           ,[width]
           ,[height]
           ,[weight]
           ,[erp_part_name]
           ,[erp_part_description]
           ,[material_code]
           ,[t4s_enabled]
           ,[datereleased]
           ,[aliasid]
           ,[altid]
           ,[drawing_revision]
           ,[legacy_part_number]
           ,[legacy_document_number]
           ,[itemtype]
           ,[itemstatus]
           ,[encumbrance]
           ,[puid]
           ,[t4s_mm_status]
           ,[t4s_dir_status])
           SELECT [itemid]
           ,[itemname]
           ,[description]
           ,[revision]
           ,[drawingid]
           ,[site]
           ,[createduser]          
           ,[lastmoduser]          
           ,[updatedrefid]
           ,[status]
           ,[dcoid]
           ,[designatedprefpart]
           ,[length]
           ,[width]
           ,[height]
           ,[weight]
           ,[erp_part_name]
           ,[erp_part_description]
           ,[material_code]
           ,[t4s_enabled]
           ,[datereleased]
           ,[aliasid]
           ,[altid]
           ,[drawing_revision]
           ,[legacy_part_number]
           ,[legacy_document_number]
           ,[itemtype]
           ,[itemstatus]
           ,[encumbrance]
           ,[puid]
           ,[t4s_mm_status]
           ,[t4s_dir_status]
            FROM [DMProd].[dbo].[items];
TRUNCATE TABLE   [DMProd_DELTA_1].[dbo].[items_doc_references]         
INSERT INTO [DMProd_DELTA_1].[dbo].[items_doc_references]
           ([iid]
           ,[document_itemid]
          
           ,[site]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
     SELECT [iid]
           ,[document_itemid]
          
           ,[site]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid]
           FROM [DMProd].[dbo].[items_doc_references]
TRUNCATE TABLE       [DMProd_DELTA_1].[dbo].[led_iom_certificate]  
INSERT INTO [DMProd_DELTA_1].[dbo].[led_iom_certificate]
           ([docname]
           ,[path]
           ,[docrefid]
           ,[doctype]
           ,[description]
           ,[createduser]
           ,[lastmoduser]
           ,[createddtm]
           ,[lastmoddtm]
           ,[toolid]
           ,[site]
           ,[puid])
    SELECT [docname]
           ,[path]
           ,[docrefid]
           ,[doctype]
           ,[description]
           ,[createduser]
           ,[lastmoduser]
           ,[createddtm]
           ,[lastmoddtm]
           ,[toolid]
           ,[site]
           ,[puid]
            FROM [DMProd].[dbo].[led_iom_certificate]
TRUNCATE TABLE  [DMProd_DELTA_1].[dbo].[led_ir]   
INSERT INTO [DMProd_DELTA_1].[dbo].[led_ir]
           ([LEDItemID]
           ,[revision]
           ,[toolname]
           ,[description]
           ,[wll]
           ,[tare]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[tooltype]
           ,[toolstatus]
           ,[length]
           ,[width]
           ,[height]
           ,[dco]
           ,[drawingid]
           ,[site]
           ,[puid])
    SELECT  [LEDItemID]
           ,[revision]
           ,[toolname]
           ,[description]
           ,[wll]
           ,[tare]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[tooltype]
           ,[toolstatus]
           ,[length]
           ,[width]
           ,[height]
           ,[dco]
           ,[drawingid]
           ,[site] 
           ,[puid]
           FROM [DMProd].[dbo].[led_ir]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[led_support_part]
INSERT INTO [DMProd_DELTA_1].[dbo].[led_support_part]
           ([partname]
           ,[description]
           ,[ptype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[toolid]
           ,[site]
           ,[puid])
     SELECT [partname]
           ,[description]
           ,[ptype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[toolid]
           ,[site]
           ,[puid]
            FROM [DMProd].[dbo].[led_support_part]
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[led_support_products]
INSERT INTO [DMProd_DELTA_1].[dbo].[led_support_products]
           ([toolid]
           ,[productname]
           ,[description]
           ,[ptype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[site]
           ,[puid])
     SELECT [toolid]
           ,[productname]
           ,[description]
           ,[ptype]
           ,[status]
           ,[createduser]
           ,[createddtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[site]
           ,[puid]
            FROM [DMProd].[dbo].[led_support_products]
            
            
            
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[pcn_impacteditem];
INSERT INTO [DMProd_DELTA_1].[dbo].[pcn_impacteditem]
           ([pid]
           ,[impacteditem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
    SELECT [pid]
           ,[impacteditem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid]
           FROM [DMProd].[dbo].[pcn_impacteditem];
           
           
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[pcn_problemitem];
INSERT INTO [DMProd_DELTA_1].[dbo].[pcn_problemitem]
           ([pid]
           ,[problemitem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
     SELECT [pid]
           ,[problemitem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid] FROM [DMProd].[dbo].[pcn_problemitem];
           
           
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[pcn_report];
INSERT INTO [DMProd_DELTA_1].[dbo].[pcn_report]
           ([pcnid]
           ,[revision]
           ,[pcnname]
           ,[description]
           ,[synopsis]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[site]
           ,[puid])
     SELECT [pcnid]
           ,[revision]
           ,[pcnname]
           ,[description]
           ,[synopsis]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[site]
           ,[puid] FROM [DMProd].[dbo].[pcn_report];
           
           
TRUNCATE TABLE [DMProd_DELTA_1].[dbo].[pcn_solutionitem];
INSERT INTO [DMProd_DELTA_1].[dbo].[pcn_solutionitem]
           ([pid]
           ,[solutionitem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid])
     SELECT [pid]
           ,[solutionitem_iid]
           ,[createduser]
           ,[createdtm]
           ,[lastmoduser]
           ,[lastmoddtm]
           ,[status]
           ,[puid]
           FROM [DMProd].[dbo].[pcn_solutionitem];           

	
/*TRUNCATE TABLE DMProd_DELTA_1.[dbo].[usertype];	
	SET IDENTITY_INSERT [usertype] on
insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (1, 'RegularUser', 'Premissions Restricted', 1, Getdate(), 1, Getdate(), 1)

insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (2,'Admin', 'Full Premissions', 1, Getdate(), 1, Getdate(), 1)

insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (3,'AMRUser', 'Create Problem Report', 1, Getdate(), 1, Getdate(), 1)

SET IDENTITY_INSERT [usertype] off
TRUNCATE TABLE DMProd_DELTA_1.[dbo].[users];
INSERT INTO DMProd_DELTA_1.[dbo].[users]
           ([first_name]
           ,[last_name]
           ,[username]
           ,[password]
           ,[companyname]
           ,[title]
           ,[phone]
           ,[fax]
           ,[email]
           
           ,[utype]
           ,[status]
           ,[manageremail]
           ,[amr])
     VALUES('Admin','Admin','Admin',0x70617373776F7264,NULL,NULL,NULL,NULL,'admin@admin.com',2,1,NULL,NULL);


---------- insert data in role table ------------
TRUNCATE TABLE [dbo].[userrole] 
insert into [dbo].[userrole] (uid, utid, enabled, createdon, createdby) 
select uid, isnull(utype,1), 'Y', GETDATE(), 1 from [dbo].[users]
update [dbo].[userrole] set utid=2 where uid = (select uid from [dbo].[users]  where email = 'admin@admin.com');

*/
            
            
	
END
GO
/****** Object:  StoredProcedure [dbo].[pcnkeywordsearch]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pcnkeywordsearch](@prefix nvarchar(max))
as begin
IF (RIGHT(@prefix, 1) = '*')
   set @prefix = LEFT(@prefix, LEN(@prefix) - 1)
select distinct (pcn_report.pcnid) from pcn_report where (SELECT REPLACE(REPLACE(pcnid, CHAR(13), ''), CHAR(10), ''))like ''+@prefix+'%'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_updateRequest]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_updateRequest] (@amrid int, @status varchar(1))
AS
BEGIN
	BEGIN TRY
		declare @temp_status varchar(100)
		declare @requeststatus int

		set @temp_status = case @status
			when 'N' then 'New'
			when 'P' then 'Processing'
			when 'S' then 'Submitted'
			when 'C' then 'Completed'
			when 'X' then 'Cancelled'
			when 'E' then 'Error'
			else '0'
		end
		select 	@requeststatus = oid from dbo.options where name = @temp_status and categoryid=9

		update [dbo].[amr_request] set request_status = @requeststatus, date_modified = getdate(), modified_by=-1
		where amr_id = @amrid

		SELECT 0 AS ErrorNumber, 'Request updated successfully' AS ErrorMessage;
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_search_datamart]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_search_datamart] (@searchText nvarchar(max), @count int)
AS
BEGIN
	--[dbo].[sp_search_datamart] '1 = 1 and itemdata like ''%pump%'''	
	CREATE TABLE #TempDataMart
	(itemtype VARCHAR(20),itemid int)
	CREATE CLUSTERED INDEX ix_tempCIndexAft ON #TempDataMart (itemtype,itemid);

	DECLARE @SQL NVARCHAR(MAX)   

	set @SQL = 'insert into #TempDataMart (itemtype,itemid)
	SELECT distinct itemtype, itemid from datamart_search where ' + @searchText;

	EXEC sp_executesql @SQL

	select top (@count) items.iid,items.itemid,items.itemname,ISNULL(erp_part_description, items.description) as description,
			items.revision,items.drawingid,items.site from 
	#TempDataMart
	inner join items on #TempDataMart.itemtype = 'ITEMS' AND #TempDataMart.itemid = items.iid;

	select top (@count) drawingid,items.iid, drawing_revision as docrevision,items.itemid,items.itemname,
	ISNULL(erp_part_description, items.description) as description,items.revision,items.site, items.datereleased from 
	#TempDataMart
	inner join items on #TempDataMart.itemtype = 'DOCUMENT' AND #TempDataMart.itemid = items.iid;

	select top (@count) [led_ir].iid,LEDItemID,revision,[led_ir].description, dco,drawingid,led_ir.[site]
	from #TempDataMart
	inner join led_ir on #TempDataMart.itemtype = 'LED' AND #TempDataMart.itemid = led_ir.iid;

	select top (@count)	pcn_report.pid, pcn_report.pcnid, pcn_report.description, pcn_report.synopsis,pcn_report.revision
	from #TempDataMart
	inner join pcn_report on #TempDataMart.itemtype = 'PCN' AND #TempDataMart.itemid = pcn_report.pid;

	select top (@count)	e.eid,e.etoid,e.projectname,e.weirorderno,e.customer,e.revision
	from #TempDataMart
	inner join eto_report e on #TempDataMart.itemtype = 'ETO' AND #TempDataMart.itemid = e.eid;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnsolutiondetail]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_pcnsolutiondetail](@pcnid int)
as begin
select  items.drawingid as solutionitem ,items.revision as revs  from items
   join  pcnitem_report pcnitem  on pcnitem.solutionitem_iid=items.iid
   join pcn_report pcn on pcn.pid=pcnitem.pid  and pcn.pid=@pcnid
end
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnsearch_bk]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_pcnsearch_bk](@pcnNumber nvarchar(max),@pcndesc  nvarchar(max),@problem nvarchar(max),@solution nvarchar(max),@impected  nvarchar(max),@count int)
as begin
IF (CHARINDEX('*', @pcnNumber ) > 0 or CHARINDEX('*', @pcndesc ) > 0 or CHARINDEX('*', @problem ) > 0 or CHARINDEX('*', @solution ) > 0 or CHARINDEX('*', @impected ) > 0)
begin
select  distinct top (100) pcn_report.pid, pcn_report.pcnid, pcn_report.description,pcn_report.synopsis,pcn_report.revision,prob_items.itemid AS "problemitem_iid",impact_items.itemid  AS "impacteditem_iid",sol_items.itemid  AS "solutionitem_iid" ,sol_items.designatedprefpart as pcndetail
  from pcn_report
left join  pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
left join items impact_items on pcn_impacteditem.impacteditem_iid=impact_items.iid 
left join  pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
left join items sol_items on pcn_solutionitem.solutionitem_iid=sol_items.iid 
left join  pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
left join items prob_items on pcn_problemitem.problemitem_iid=prob_items.iid

where 
((SELECT REPLACE(REPLACE(pcn_report.pcnid, CHAR(13), ''), CHAR(10), '')) like (select REPLACE(@pcnNumber,'*','%')) or @pcnNumber='' or @pcnNumber is null) and
(pcn_report.description like (select REPLACE(@pcnNumber,'*','%'))  or @pcndesc='' or @pcndesc is null)and
(prob_items.itemid like (select REPLACE(@problem,'*','%'))  or @problem='' or @problem is null)and
(sol_items.itemid like (select REPLACE(@solution,'*','%'))  or @solution='' or @solution is null)and
(impact_items.itemid like (select REPLACE(@impected,'*','%')) or @impected='' or @impected is null)
order by pcn_report.revision
end
else
begin

select  distinct top (@count) pcn_report.pid, pcn_report.pcnid, pcn_report.description,pcn_report.synopsis,pcn_report.revision,prob_items.itemid AS "problemitem_iid",impact_items.itemid  AS "impacteditem_iid",sol_items.itemid  AS "solutionitem_iid" ,sol_items.designatedprefpart as pcndetail
 from pcn_report
left join  pcn_impacteditem on pcn_impacteditem.pid=pcn_report.pid 
left join items impact_items on pcn_impacteditem.impacteditem_iid=impact_items.iid 
left join  pcn_solutionitem on pcn_solutionitem.pid=pcn_report.pid 
left join items sol_items on pcn_solutionitem.solutionitem_iid=sol_items.iid 
left join  pcn_problemitem on pcn_problemitem.pid=pcn_report.pid 
left join items prob_items on pcn_problemitem.problemitem_iid=prob_items.iid

where 
((SELECT REPLACE(REPLACE(pcn_report.pcnid, CHAR(13), ''), CHAR(10), ''))=@pcnNumber or @pcnNumber='' or @pcnNumber is null) and
(pcn_report.description=@pcndesc or @pcndesc='' or @pcndesc is null)and
(prob_items.itemid=@problem or @problem='' or @problem is null)and
(sol_items.itemid=@solution or @solution='' or @solution is null)and
(impact_items.itemid=@impected or @impected='' or @impected is null)
order by pcn_report.revision
end 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnsearch]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_pcnproblemdetail]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[sp_pcnproblemdetail](@pcnid int)
as begin
select  items.drawingid as problemitem ,items.revision as revs  from items
   join  pcnitem_report pcnitem  on pcnitem.problemitem_iid=items.iid
   join pcn_report pcn on pcn.pid=pcnitem.pid  and pcn.pid=@pcnid
  
end
GO
/****** Object:  StoredProcedure [dbo].[sp_pcnimpacteddetail]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[sp_pcnimpacteddetail](@pcnid int)
as begin
select  items.drawingid as impacteditem ,items.revision as revsi  from items
   join  pcnitem_report pcnitem  on pcnitem.impacteditem_iid=items.iid
   join pcn_report pcn on pcn.pid=pcnitem.pid  and pcn.pid=@pcnid
  
end
GO
/****** Object:  StoredProcedure [dbo].[sp_pcndetail]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_partsearch]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_partsearch](@itemnumber nvarchar(max),@legacyitemnumber nvarchar(max),@itemstatus int,@docnumber nvarchar(max),@legacydocnumber nvarchar(max),@itemtype int,@PartDescription nvarchar(max),@count int)
as begin

IF (CHARINDEX('*', @itemnumber ) > 0 OR CHARINDEX('*', @legacyitemnumber ) > 0 OR CHARINDEX('*', @itemstatus ) > 0 OR CHARINDEX('*', @docnumber ) > 0 OR CHARINDEX('*', @legacydocnumber ) > 0 OR CHARINDEX('*', @PartDescription ) > 0 OR CHARINDEX('*', @itemtype ) > 0 )
begin
select  distinct top (@count) items.iid,items.itemid,items.itemname,ISNULL(erp_part_description, items.description) as description,
items.revision,items.drawingid,items.site,dcoid=(op2.name),
items.t4s_mm_status, items.t4s_dir_status,
items.length,items.width,items.height,items.weight,items.datereleased,items.legacy_part_number,
items.legacy_document_number,op.name as itemtype,op1.name ,itemdoc.document_itemid as reference
from items left join options op on op.oid=items.itemtype and op.categoryid = '1'
 left join options op1 on op1.oid=items.itemstatus  
left join   options op2 on op2.oid=items.dcoid and op2.categoryid='5'
left join 
(
select iid, stuff((
					select ',' + ref.document_itemid + '___'+ref.document_name  from
					(select distinct iid, document_itemid,document_name from items_doc_references) ref 
					where ref.iid=mainitem.iid 
					order by ref.document_itemid 
					for xml path('')
				),1,1,'') as document_itemid
from items_doc_references mainitem
group by iid
) itemdoc on items.iid=itemdoc.iid
  where items.status=0 and  op.description not in ('DocumentRevision','Drawing Item Revision') and 
((SELECT REPLACE(REPLACE(itemid, CHAR(13), ''), CHAR(10), '')) like  (select REPLACE(@itemnumber,'*','%')) or @itemnumber=''  or @itemnumber is null) and 
([legacy_part_number] LIKE (select REPLACE(@legacyitemnumber,'*','%'))  or @legacyitemnumber='' or @legacyitemnumber is null) and 
([itemstatus] = @itemstatus or @itemstatus=''  or @itemstatus is null) and 
(drawingid LIKE (select REPLACE(@docnumber,'*','%')) or @docnumber='' or @docnumber is null) and 
([legacy_document_number] LIKE (select REPLACE(@legacydocnumber,'*','%')) OR @legacydocnumber='' or @legacydocnumber is null) and 
([erp_part_description] LIKE (select REPLACE(@PartDescription,'*','%')) OR [items].description LIKE (select REPLACE(@PartDescription,'*','%')) OR @PartDescription='' or @PartDescription is null) and
 ([itemtype] =@itemtype or @itemtype ='' or @itemtype is null)
end
else
begin
select distinct top (@count) items.iid,items.itemid,items.itemname,ISNULL(erp_part_description, items.description) as description,items.revision,items.drawingid,items.site,dcoid=(op2.name),
items.length,items.width,items.height,items.weight,items.datereleased,items.legacy_part_number,
items.t4s_mm_status, items.t4s_dir_status,
items.legacy_document_number,op.name as itemtype,op1.name ,itemdoc.document_itemid as reference
from items left join options op on op.oid=items.itemtype and op.categoryid = '1'
 left join options op1 on op1.oid=items.itemstatus  
left join   options op2 on op2.oid=items.dcoid and op2.categoryid='5'
left join 
(
select iid, stuff((
					select ',' + ref.document_itemid + '___'+ref.document_name from
					(select distinct iid, document_itemid,document_name from items_doc_references) ref 
					where ref.iid=mainitem.iid 
					order by ref.document_itemid 
					for xml path('')
				),1,1,'') as document_itemid
from items_doc_references mainitem
group by iid
) itemdoc on items.iid=itemdoc.iid
  where items.status=0  and op.description not in ('DocumentRevision','Drawing Item Revision') and 
((itemid in (SELECT value FROM strlist_to_tbl(@itemnumber)))  or @itemnumber=''  or @itemnumber is null) and 
([legacy_part_number] =@legacyitemnumber  or @legacyitemnumber='' or @legacyitemnumber is null) and 
([itemstatus] =@itemstatus or @itemstatus=''  or @itemstatus is null) and 
(drawingid =@docnumber or @docnumber='' or @docnumber is null) and 
([legacy_document_number] =@legacydocnumber or @legacydocnumber='' or @legacydocnumber is null) and 
([erp_part_description] =@PartDescription or [items].description =@PartDescription or @PartDescription='' or @PartDescription is null) and
([itemtype] =@itemtype or @itemtype ='' or @itemtype is null)
end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_modpcndetail]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_modetodetail]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_MarkAMRCompleted]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MarkAMRCompleted]
AS
BEGIN
	BEGIN TRY
		declare @completedstatus int
		declare @submittedstatus int
		declare @cancelledstatus int

		select 	@completedstatus = oid from dbo.options where name = 'Completed' and categoryid=9;
		select 	@submittedstatus = oid from dbo.options where name = 'Submitted' and categoryid=9;
		select 	@cancelledstatus = oid from dbo.options where name = 'Cancelled' and categoryid=9;

		update [dbo].[amr_request] set request_status = @completedstatus, date_modified = getdate(), modified_by=-1
		from [dbo].[amr_request] AMR
		inner join [dbo].[items] IT on IT.itemid = AMR.item_no
		where AMR.request_status <> @completedstatus;

		update [dbo].[amr_request] set request_status = @cancelledstatus, date_modified = getdate(), modified_by=-1
		from [dbo].[amr_request] AMR
		where AMR.request_status = @submittedstatus and date_requested <= getdate()-90;

		SELECT 0 AS ErrorNumber, 'Request updated successfully' AS ErrorMessage;
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ledsearchdetail]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_LEDSearch]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_getrequest]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_getrequest] (@status varchar(1))
AS
BEGIN
		declare @temp_status varchar(100)
		declare @requeststatus int

		set @temp_status = case @status
			when 'N' then 'New'
			when 'P' then 'Processing'
			when 'S' then 'Submitted'
			when 'C' then 'Completed'
			when 'X' then 'Cancelled'
			when 'E' then 'Error'
			else '0'
		end

		select 	@requeststatus = oid from dbo.options where name = @temp_status and categoryid=9

	-- [sp_displayamrrequest] 0, null,0, null, null, null,null
	select amr_id as SystemId, op1.name as RequestType, requestor_email as RequestedBy, op2.name as Status, item_no as PartNo, request_no as RequestNo, 
	new_material_code as NewMaterialCode, REPLACE(CONVERT(CHAR(11), date_requested, 106),' ','-') as DateRequested, 
	existing_material_code as ExistingMaterialCode, drawing_no as DrawingNo, part_description as PartDescription, 
	op3.name as Site, op4.name as Priority,	op5.name as DCO,  REPLACE(CONVERT(CHAR(11), due_date, 106),' ','-') as DueDate, 
	drawing_rev_no as DrawingRevNo, case when casting_requested = 1 then 'Yes' else 'No' end as CastingRequested,
	productcode, remarks, file_path

	from [dbo].[amr_request]
	--inner join [dbo].[users] usr on usr.uid = requested_by
	inner join [dbo].[options] op1 on op1.oid = amr_type_id
	inner join [dbo].[options] op6 on op6.oid = amr_request.request_status
	left outer join [dbo].[options] op2 on op2.oid = amr_request.status
	left outer join [dbo].[options] op3 on op3.oid = amr_request.site
	left outer join [dbo].[options] op4 on op4.oid = amr_request.priority
	left outer join [dbo].[options] op5 on op5.oid = amr_request.dco
	left outer join [dbo].[product] on product.productid = [amr_request].productid
	where amr_request.request_status = @requeststatus
END
GO
/****** Object:  StoredProcedure [dbo].[sp_etoSearch]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_etodetail]    Script Date: 06/24/2019 17:32:23 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_docsearch_new]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_docsearch_new](@docnumber nvarchar(max),@docname nvarchar(max),@legacyitemnumber nvarchar(max),@docstatus int,@legacydocnumber nvarchar(max),@doctype int, @PartDescription nvarchar(max), @count int)
as begin
IF (CHARINDEX('*', @docnumber ) > 0 OR CHARINDEX('*', @docname ) > 0 OR CHARINDEX('*', @legacyitemnumber ) > 0 OR CHARINDEX('*', @docstatus ) > 0 OR CHARINDEX('*', @legacydocnumber ) > 0 OR CHARINDEX('*', @doctype ) > 0 OR CHARINDEX('*', @PartDescription ) > 0)
begin
	select  distinct top (@count) drawingid,items.iid, drawing_revision as docrevision,items.itemid,items.itemname,
	ISNULL(erp_part_description, items.description) as description,items.revision,items.site,dcoid=(op2.name),
	--items.length,items.width,items.height,items.weight,
		items.datereleased,items.legacy_part_number,opw.name as doctype,itemdt.datasetdesc as docdesc,
		items.legacy_document_number,op.name as itemtype,op1.name  as status ,itemdt.datasetname as docname,itemdt.pfile_name as fileurl, opw_dsettype.name as dataset
	into #document
	from items 
	left join options op on op.oid=items.itemtype and op.[categoryid]='1'  
	left join options op1 on op1.oid=items.itemstatus  and op1.categoryid='2' 
	left join   options op2 on op2.oid=items.dcoid  and op2.categoryid='5' 
	inner join [dbo].[itemreport_dataset] itemdt on itemdt.iid=items.iid 
	left join options opw on opw.oid=itemdt.documenttype
	left join options opw_dsettype on opw_dsettype.oid=itemdt.datasettype
	where items.status=0 and itemdt.status = 0 and
	((SELECT REPLACE(REPLACE(drawingid, CHAR(13), ''), CHAR(10), '')) LIKE (select REPLACE(@docnumber,'*','%'))  or @docnumber=''  or @docnumber is null) and 
	([legacy_part_number]  LIKE (select REPLACE(@legacyitemnumber,'*','%'))   or @legacyitemnumber='' or @legacyitemnumber is null) and 
	([itemstatus]  LIKE (select REPLACE(@docstatus,'*','%'))  or @docstatus=''  or @docstatus is null) and 
	(itemdt.datasetdesc LIKE (select REPLACE(@docname,'*','%'))  or @docname='' or @docname is null) and 
	([legacy_document_number]  LIKE (select REPLACE(@legacydocnumber,'*','%'))  or @legacydocnumber='' or @legacydocnumber is null) and 
	([erp_part_description] LIKE (select REPLACE(@PartDescription,'*','%')) or items.description LIKE (select REPLACE(@PartDescription,'*','%')) or @PartDescription='' or @PartDescription is null) and
	(itemdt.documenttype LIKE (select REPLACE(@doctype,'*','%'))  or @doctype ='' or @doctype is null) order by items.drawingid , items.revision

	select distinct drawingid, iid, description, itemtype, docrevision, itemid,  datereleased, status, itemname, revision, site, legacy_part_number, legacy_document_number  --itemname,  revision, site, legacy_part_number, legacy_document_number, 
	from #document;

	select distinct drawingid, iid, docname, doctype, docdesc, dataset, isnull(fileurl,'') fileurl, status 
	,case when (dataset in ('Non DetailedPDF','ZIP','SKP','MISC') and (parsename(fileurl,1) in  ('pdf','zip','skp','stp'))) then 'N'
	 else 'Y'
	 end Secured
	from #document;
	
end
else
begin
	select  distinct top (@count) drawingid,items.iid, drawing_revision as docrevision,items.itemid,items.itemname,
	ISNULL(erp_part_description, items.description) as description,items.revision,items.site,dcoid=(op2.name),
	--items.length,items.width,items.height,items.weight,
	items.datereleased,items.legacy_part_number,opw.name as doctype,itemdt.datasetdesc as docdesc,
	items.legacy_document_number,op.name as itemtype,op1.name  as status ,itemdt.datasetname as docname,itemdt.pfile_name as fileurl, opw_dsettype.name as dataset
	into #document1
	from items 
	left join options op on op.oid=items.itemtype and op.[categoryid]='1'    
	left join options op1 on op1.oid=items.itemstatus   and op1.categoryid='2'
	left join   options op2 on op2.oid=items.dcoid  and op2.categoryid='5' 
	 --left join items_doc_references dcoref on dcoref.idriid=items.iid
	 inner join [dbo].[itemreport_dataset] itemdt on itemdt.iid=items.iid 
	  left join options opw on opw.oid=itemdt.documenttype
	  left join options opw_dsettype on opw_dsettype.oid=itemdt.datasettype
	  where items.status=0 and itemdt.status = 0 and
	((drawingid in (SELECT value FROM strlist_to_tbl(@docnumber))) or @docnumber=''  or @docnumber is null) and 
	([legacy_part_number] =@legacyitemnumber  or @legacyitemnumber='' or @legacyitemnumber is null) and 
	([itemstatus] =@docstatus or @docstatus=''  or @docstatus is null) and 
	(itemdt.datasetdesc =@docname or @docname='' or @docname is null) and 
	([legacy_document_number] =@legacydocnumber or @legacydocnumber='' or @legacydocnumber is null) and 
	([erp_part_description] =@PartDescription or [items].description =@PartDescription or @PartDescription='' or @PartDescription is null) and
	(itemdt.documenttype =@doctype or @doctype ='' or @doctype is null) order by items.drawingid , items.revision

	select distinct drawingid, iid, description, itemtype, docrevision, itemid,  datereleased, status, itemname, revision, site, legacy_part_number, legacy_document_number  --itemname,  revision, site, legacy_part_number, legacy_document_number, 
	from #document1;

	select distinct drawingid, iid, docname, doctype, docdesc, dataset, isnull(fileurl,'') fileurl, status 
	,case when (dataset in ('Non DetailedPDF','ZIP','SKP','MISC') and (parsename(fileurl,1) in  ('pdf','zip','skp','stp'))) then 'N'
	 else 'Y'
	 end Secured
	from #document1;

end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_docsearch]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_docsearch](@docnumber nvarchar(max),@docname nvarchar(max),@legacyitemnumber nvarchar(max),@docstatus int,@legacydocnumber nvarchar(max),@doctype int, @PartDescription nvarchar(max), @count int)
as begin
IF (CHARINDEX('*', @docnumber ) > 0 OR CHARINDEX('*', @docname ) > 0 OR CHARINDEX('*', @legacyitemnumber ) > 0 OR CHARINDEX('*', @docstatus ) > 0 OR CHARINDEX('*', @legacydocnumber ) > 0 OR CHARINDEX('*', @doctype ) > 0 OR CHARINDEX('*', @PartDescription ) > 0)
begin
	select  distinct top (@count) drawingid,items.iid, drawing_revision as docrevision,items.itemid,items.itemname,
	ISNULL(erp_part_description, items.description) as description,items.revision,items.site,dcoid=(op2.name),
	--items.length,items.width,items.height,items.weight,
		items.datereleased,items.legacy_part_number,opw.name as doctype,itemdt.datasetdesc as docdesc,
		items.legacy_document_number,op.name as itemtype,op1.name  as status ,itemdt.datasetname as docname,itemdt.pfile_name as fileurl, opw_dsettype.name as dataset
	into #document
	from items 
	left join options op on op.oid=items.itemtype and op.[categoryid]='1'  
	left join options op1 on op1.oid=items.itemstatus  and op1.categoryid='2' 
	left join   options op2 on op2.oid=items.dcoid  and op2.categoryid='5' 
	inner join [dbo].[itemreport_dataset] itemdt on itemdt.iid=items.iid 
	left join options opw on opw.oid=itemdt.documenttype
	left join options opw_dsettype on opw_dsettype.oid=itemdt.datasettype
	where items.status=0 and itemdt.status = 0 and
	((SELECT REPLACE(REPLACE(drawingid, CHAR(13), ''), CHAR(10), '')) LIKE (select REPLACE(@docnumber,'*','%'))  or @docnumber=''  or @docnumber is null) and 
	([legacy_part_number]  LIKE (select REPLACE(@legacyitemnumber,'*','%'))   or @legacyitemnumber='' or @legacyitemnumber is null) and 
	([itemstatus]  LIKE (select REPLACE(@docstatus,'*','%'))  or @docstatus=''  or @docstatus is null) and 
	(itemdt.datasetdesc LIKE (select REPLACE(@docname,'*','%'))  or @docname='' or @docname is null) and 
	([legacy_document_number]  LIKE (select REPLACE(@legacydocnumber,'*','%'))  or @legacydocnumber='' or @legacydocnumber is null) and 
	([erp_part_description] LIKE (select REPLACE(@PartDescription,'*','%')) or items.description LIKE (select REPLACE(@PartDescription,'*','%')) or @PartDescription='' or @PartDescription is null) and
	(itemdt.documenttype LIKE (select REPLACE(@doctype,'*','%'))  or @doctype ='' or @doctype is null) order by items.drawingid , items.revision

	select distinct drawingid, iid, description, itemtype, docrevision, itemid,  datereleased, status, itemname, revision, site, legacy_part_number, legacy_document_number  --itemname,  revision, site, legacy_part_number, legacy_document_number, 
	from #document;

	select distinct drawingid, iid, docname, doctype, docdesc, dataset, isnull(fileurl,'') fileurl, status 
	,case when (dataset in ('Non DetailedPDF','ZIP','SKP','MISC') and (parsename(fileurl,1) in  ('pdf','zip','skp','stp'))) then 'N'
	 else 'Y'
	 end Secured
	from #document;
	
end
else
begin
	select  distinct top (@count) drawingid,items.iid, drawing_revision as docrevision,items.itemid,items.itemname,
	ISNULL(erp_part_description, items.description) as description,items.revision,items.site,dcoid=(op2.name),
	--items.length,items.width,items.height,items.weight,
	items.datereleased,items.legacy_part_number,opw.name as doctype,itemdt.datasetdesc as docdesc,
	items.legacy_document_number,op.name as itemtype,op1.name  as status ,itemdt.datasetname as docname,itemdt.pfile_name as fileurl, opw_dsettype.name as dataset
	into #document1
	from items 
	left join options op on op.oid=items.itemtype and op.[categoryid]='1'    
	left join options op1 on op1.oid=items.itemstatus   and op1.categoryid='2'
	left join   options op2 on op2.oid=items.dcoid  and op2.categoryid='5' 
	 --left join items_doc_references dcoref on dcoref.idriid=items.iid
	 inner join [dbo].[itemreport_dataset] itemdt on itemdt.iid=items.iid 
	  left join options opw on opw.oid=itemdt.documenttype
	  left join options opw_dsettype on opw_dsettype.oid=itemdt.datasettype
	  where items.status=0 and itemdt.status = 0 and
	((drawingid in (SELECT value FROM strlist_to_tbl(@docnumber))) or @docnumber=''  or @docnumber is null) and 
	([legacy_part_number] =@legacyitemnumber  or @legacyitemnumber='' or @legacyitemnumber is null) and 
	([itemstatus] =@docstatus or @docstatus=''  or @docstatus is null) and 
	(itemdt.datasetdesc =@docname or @docname='' or @docname is null) and 
	([legacy_document_number] =@legacydocnumber or @legacydocnumber='' or @legacydocnumber is null) and 
	([erp_part_description] =@PartDescription or [items].description =@PartDescription or @PartDescription='' or @PartDescription is null) and
	(itemdt.documenttype =@doctype or @doctype ='' or @doctype is null) order by items.drawingid , items.revision

	select distinct drawingid, iid, description, itemtype, docrevision, itemid,  datereleased, status, itemname, revision, site, legacy_part_number, legacy_document_number  --itemname,  revision, site, legacy_part_number, legacy_document_number, 
	from #document1;

	select distinct drawingid, iid, docname, doctype, docdesc, dataset, isnull(fileurl,'') fileurl, status 
	,case when (dataset in ('Non DetailedPDF','ZIP','SKP','MISC') and (parsename(fileurl,1) in  ('pdf','zip','skp','stp'))) then 'N'
	 else 'Y'
	 end Secured
	from #document1;

end
end
GO
/****** Object:  Table [dbo].[userrole]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userrole](
	[urid] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NOT NULL,
	[utid] [int] NOT NULL,
	[enabled] [varchar](1) NULL,
	[createdon] [datetime] NULL,
	[createdby] [int] NULL,
 CONSTRAINT [PK_userrole] PRIMARY KEY CLUSTERED 
(
	[urid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_displayamrrequest]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_displayamrrequest] (@amr_type_id int, @requested_by nvarchar(max), @status int, @item_no nvarchar(max), @request_no nvarchar(max), @new_material_code nvarchar(max), @part_description nvarchar(max))
AS
BEGIN
	-- [sp_displayamrrequest] 0, null,0, null, null, null,null
	--exec [sp_displayamrrequest] '0','','0','','','',''
	--exec [sp_displayamrrequest] '0','kamlesh*','0','','','',''
	select amr_id, amr_type_id, op1.name as amr_type, requestor_email as requested_by, amr_request.status, op2.name as status_desc, 
	item_no, request_no, new_material_code, REPLACE(CONVERT(CHAR(11), date_requested, 106),' ','-') as date_requested, 
	existing_material_code, drawing_no, part_description, site, op3.name as site_desc, priority, op4.name as priority_desc ,
	dco, op5.name as dco_desc,  REPLACE(CONVERT(CHAR(11), due_date, 106),' ','-') as due_date,drawing_rev_no, 
	case when casting_requested = 1 then 'Yes' else 'No' end as casting_requested, 
	op6.name as request_status, [amr_request].productid, productcode, remarks, file_path
	from [dbo].[amr_request]
	--inner join [dbo].[users] usr on usr.uid = requested_by
	inner join [dbo].[options] op1 on op1.oid = amr_type_id
	inner join [dbo].[options] op6 on op6.oid = amr_request.request_status
	left outer join [dbo].[options] op2 on op2.oid = amr_request.status
	left outer join [dbo].[options] op3 on op3.oid = amr_request.site
	left outer join [dbo].[options] op4 on op4.oid = amr_request.priority
	left outer join [dbo].[options] op5 on op5.oid = amr_request.dco
	left outer join [dbo].[product] on product.productid = [amr_request].productid
	where ((amr_type_id = @amr_type_id)  or (isnull(@amr_type_id,0)  = 0)) and
	((requestor_email like replace(@requested_by,'*','%'))  or (isnull(@requested_by,'')  = '')) and
	((amr_request.request_status = @status)  or (isnull(@status,0)  = 0)) and
	((item_no like replace(@item_no,'*','%'))  or (isnull(@item_no,'')  = '')) and
	((request_no like replace(@request_no,'*','%'))  or (isnull(@request_no,'')  = '')) and
	((new_material_code like replace(@new_material_code,'*','%'))  or (isnull(@new_material_code,'')  = '')) and
	((part_description like replace(@part_description,'*','%'))  or (isnull(@part_description,'')  = '')) 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_createamrrequest]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_createamrrequest] (@amr_type_id int, @requested_by nvarchar(max), @status int, @item_no nvarchar(max),  @part_description nvarchar(max), @new_material_code nvarchar(max), @existing_material_code nvarchar(max), @request_no nvarchar(max), @drawing_no nvarchar(max), @drawing_rev_no nvarchar(max), @site int, @priority int, @dco int, @due_date nvarchar(max), @casting_requested int, @productid int, @file_path nvarchar(max), @remarks nvarchar(max))
AS
BEGIN
	-- [sp_displayamrrequest] 0, null,0, null, null, null,null
	Declare @amr_name nvarchar(max);

	BEGIN TRY
		select @amr_name = name from options where oid = @amr_type_id

		if exists(select amr_type_id from [dbo].[amr_request], dbo.options where [amr_request].request_status=options.oid 
					and item_no = @item_no and options.name not in ('Error','Cancelled')) 
		begin

			SELECT 1 AS ErrorNumber, @amr_name + ' for this Part Number already submitted. Please verify item no' AS ErrorMessage;
		end
		else if exists(select itemid from [dbo].[items] where itemid = @item_no) 
		begin
			SELECT 1 AS ErrorNumber, 'Part Number submitted in ('+ @amr_name +') already exist and active. Please check in Part Search' AS ErrorMessage;
		end
		else
		begin
			if @status = 0 set @status = null;
			if @site = 0 set @site = null;
			if @priority = 0 set @priority = null;
			if @dco = 0 set @dco = null;
			if @productid = 0 set @productid = null;
			--declare @userid int;
			--select 	@userid = uid from dbo.users where email = @requested_by

			declare @request_status int;
			select 	@request_status = oid from dbo.options where name = 'New' and categoryid=9

			insert into [dbo].[amr_request]
			(amr_type_id, requestor_email, status, item_no, request_no, new_material_code, existing_material_code, drawing_no, 
			part_description, site, priority, dco, due_date, drawing_rev_no, casting_requested, request_status, productid, file_path,remarks)
			values 
			(@amr_type_id, @requested_by, @status, @item_no, @request_no, @new_material_code, @existing_material_code, @drawing_no, 
			@part_description, @site, @priority, @dco, @due_date, @drawing_rev_no, @casting_requested, @request_status, @productid, @file_path,@remarks)


			SELECT 0 AS ErrorNumber, @amr_name + ' submitted successfully' AS ErrorMessage;
		end
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_changepwd]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_changepwd] (@email nvarchar(max), @newpassword varchar(max))
AS
BEGIN
	BEGIN TRY
		update [dbo].[users] set password = CONVERT(varbinary(max), ISNULL(@newpassword, ''))
		where email = @email;

		SELECT 0 AS ErrorNumber, 'Password Changed Successfully' AS ErrorMessage;
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_build_datamart]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_build_datamart]
as begin
	truncate table datamart_search;

	insert into dbo.datamart_search
	select  distinct 'ITEMS' as 'itemtype', items.iid as 'itemid', items.itemid + ISNULL(items.itemname,'') + ISNULL(erp_part_description, ISNULL(items.description,'')) + 
	ISNULL(items.revision,'') + ISNULL(items.drawingid,'') + ISNULL(items.site,'') + ISNULL(op2.name,'') + ISNULL(items.datereleased,'')  + 
	ISNULL(items.legacy_part_number,'') + ISNULL(items.legacy_document_number,'') + ISNULL(op.name,'')  + 
	ISNULL(op1.name,'') + ISNULL(itemdoc.document_itemid,'') as 'itemdata'
	from items left join options op on op.oid=items.itemtype and op.categoryid = '1'
	left join options op1 on op1.oid=items.itemstatus  
	left join   options op2 on op2.oid=items.dcoid and op2.categoryid='5'
	left join 
	(
	select iid, stuff((
						select ',' + ref.document_itemid 
						from items_doc_references ref 
						where ref.iid=mainitem.iid 
						order by ref.document_itemid 
						for xml path('')
					),1,1,'') as document_itemid
	from items_doc_references mainitem
	group by iid
	) itemdoc on items.iid=itemdoc.iid where items.status=0  and  op.description not in ('DocumentRevision','Drawing Item Revision')

	insert into dbo.datamart_search
	select  distinct 'DOCUMENT' AS 'itemtype', items.iid as 'itemid', ISNULL(drawingid,'') + ISNULL(drawing_revision,'') + 
	ISNULL(items.itemid,'') + ISNULL(items.itemname,'') + ISNULL(erp_part_description, ISNULL(items.description,'')) + 
	ISNULL(items.revision,'') + ISNULL(items.site,'') + ISNULL(op2.name,'') +
	ISNULL(items.datereleased,'') + ISNULL(items.legacy_part_number,'') + ISNULL(opw.name,'') + ISNULL(itemdt.datasetdesc,'') 
	+ ISNULL(items.legacy_document_number,'') + ISNULL(op.name,'') + ISNULL(op1.name,'') + ISNULL(itemdt.datasetname,'') + 
	ISNULL(itemdt.pfile_name,'') + ISNULL(opw.description,'') as 'itemdata'
	from items 
	left join options op on op.oid=items.itemtype  
	left join options op1 on op1.oid=items.itemstatus  
	left join   options op2 on op2.oid=items.dcoid  and  op2.categoryid='5' 
	inner join [dbo].[itemreport_dataset] itemdt on itemdt.iid=items.iid 
	left join options opw on opw.oid=itemdt.documenttype
	where  drawingid !='' and items.status=0 and itemdt.status = 0 

	insert into dbo.datamart_search
	select distinct 'LED' AS 'itemtype', [led_ir].iid as 'itemid', 
		ISNULL(LEDItemID,'')  + ISNULL(revision,'')  + ISNULL([led_ir].description,'') 
	 + CAST(ISNULL(wll,0) AS varchar)  + CAST(ISNULL(tare,0) AS varchar) + ISNULL(dco,'')  + ISNULL(drawingid,'')  + ISNULL(led_ir.[site],'') 
	 + ISNULL(op.name,'')  + ISNULL(op1.name,'')  + CAST(ISNULL(height,0) AS varchar) + CAST(ISNULL(width,0) AS varchar) + CAST(ISNULL(length,0) AS varchar) 
	 + ISNULL(led_ir.toolname,'') + ISNULL(partname,'')  + ISNULL(productname,'')  + ISNULL(ledcer1.docname,'')  + ISNULL(ledcer.docname,'')  as 'itemdata'
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


	insert into dbo.datamart_search
	select distinct 'PCN' AS 'itemtype', pcn_report.pid as 'itemid',
		ISNULL(pcn_report.pcnid, '') + ISNULL(pcn_report.description,'')
	    + ISNULL(pcn_report.synopsis,'') + ISNULL(pcn_report.revision,'') + ISNULL(impacteditem_iid,'') 
		+ ISNULL(solutionitem_iid,'') + ISNULL(problemitem_iid,'')  as 'itemdata'
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


	insert into dbo.datamart_search
	select distinct 'ETO' AS 'itemtype', e.eid as 'itemid',
		ISNULL(e.etoid,'') + ISNULL(e.projectname,'') + ISNULL(e.weirorderno,'') + ISNULL(e.customer,'') + ISNULL(e.revision,'') 
		+ ISNULL(gadrawingref,'') + ISNULL(documentref,'') + ISNULL(orderpartref,'') + ISNULL(referenceref,'')
		from eto_report e 
		left join 
		(
		select etoeid, stuff((
							select ',' + (gadrawings.itemid  + '/'+ gadrawings.revision) 
							from eto_hasgadrawing ref
							inner join items gadrawings on ref.hasga_iid = gadrawings.iid
							where ref.etoeid=mainitem.etoeid 
							order by gadrawings.itemid
							for xml path('')
						),1,1,'') as gadrawingref
		from eto_hasgadrawing mainitem
		group by etoeid
		) i on e.eid=i.etoeid 
		left join 
		(
		select etoeid, stuff((
							select ',' + (hasdocuments.itemid  + '/'+ hasdocuments.revision) 
							from eto_hasdocument ref
							inner join items hasdocuments on ref.hasdocument_iid = hasdocuments.iid
							where ref.etoeid=mainitem.etoeid 
							order by hasdocuments.itemid
							for xml path('')
						),1,1,'') as documentref
		from eto_hasdocument mainitem
		group by etoeid
		)  it on e.eid=it.etoeid 
		left join 
		(
		select etoeid, stuff((
							select ',' + (orderpart.itemid + '/'+ orderpart.revision) 
							from eto_orderparts ref
							inner join items orderpart on ref.orderparts_iid = orderpart.iid
							where ref.etoeid=mainitem.etoeid 
							order by orderpart.itemid
							for xml path('')
						),1,1,'') as orderpartref
		from eto_orderparts mainitem
		group by etoeid
		)  its on e.eid=its.etoeid 
		left join 
		(
		select etoeid, stuff((
							select ',' + (reference.itemid + '/'+ reference.revision) 
							from eto_references ref
							inner join items reference on ref.references_iid = reference.iid
							where ref.etoeid=mainitem.etoeid 
							order by reference.itemid
							for xml path('')
						),1,1,'') as referenceref
		from eto_references mainitem
		group by etoeid
		) itm on e.eid=itm.etoeid

end
GO
/****** Object:  StoredProcedure [dbo].[User_Data_Insert]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[User_Data_Insert] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET IDENTITY_INSERT [usertype] on
insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (1, 'RegularUser', 'Premissions Restricted', 1, Getdate(), 1, Getdate(), 1)

insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (2,'Admin', 'Full Premissions', 1, Getdate(), 1, Getdate(), 1)

insert into [dbo].[usertype](utid, name, description, createuser, createdtm, lastmoduser, lastmoddtm, status)  
values (3,'AMRUser', 'Create Problem Report', 1, Getdate(), 1, Getdate(), 1)

SET IDENTITY_INSERT [usertype] off

update [dbo].[users] set utype=2, status=1 where email = 'admin@admin.com';


---------- insert data in role table ------------
TRUNCATE TABLE [dbo].[userrole] 
insert into [dbo].[userrole] (uid, utid, enabled, createdon, createdby) 
select uid, isnull(utype,1), 'Y', GETDATE(), 1 from [dbo].[users]
update [dbo].[userrole] set utid=2 where uid = (select uid from [dbo].[users]  where email = 'admin@admin.com');


SET IDENTITY_INSERT category on
TRUNCATE TABLE [dbo].[category]
-------------------- insert record in category table --------------------------------
insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (8, 'AMRType', 'AMR Type', 1, 1,getdate(), 1, getdate());

insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (9, 'AMRStatus', 'AMR Status', 1, 1,getdate(), 1, getdate());

insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (10, 'site', 'site', 1, 1,getdate(), 1, getdate());

insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (11, 'priority', 'priority', 1, 1,getdate(), 1, getdate());

insert into [dbo].[category](cid, name, description, status, createduser, createdtm, lastmoduser, lastmoddtm)
values (12, 'dco', 'dco', 1, 1,getdate(), 1, getdate());

SET IDENTITY_INSERT category off
DELETE FROM [dbo].[options] where categoryid = 8;
select * from [dbo].[options] where categoryid = 8;
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('AMR Request', 'AMR Request', 1, 1, getdate(), 1, getdate(), 8)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Data Issue', 'Data Issue', 1, 1, getdate(), 1, getdate(), 8)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Request For Basic Data', 'Request For Basic Data', 1, 1, getdate(), 1, getdate(), 8)

DELETE FROM [dbo].[options] where categoryid = 9;
select * from [dbo].[options] where categoryid = 9;
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('New', 'New', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Processing', 'Processing', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Submitted', 'Submitted', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Cancelled', 'Cancelled', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Completed', 'Completed', 1, 1, getdate(), 1, getdate(), 9)
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Error', 'Error', 1, 1, getdate(), 1, getdate(), 9)

DELETE FROM [dbo].[options] where categoryid = 10;
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
select distinct site, site, 1,1,getdate(), 1, getdate(), 10 from [dbo].[items]

DELETE FROM [dbo].[options] where categoryid = 11;
insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Low', 'Low', 1, 1, getdate(), 1, getdate(), 11)

insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('Medium', 'Medium', 1, 1, getdate(), 1, getdate(), 11)

insert into [dbo].[options] (name, description, status, createduser, createdtm, lastmoduser, lastmoddtm, categoryid)
values ('High', 'High', 1, 1, getdate(), 1, getdate(), 11)


	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_adduserapp]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_adduserapp](@userEmail nvarchar(max), @usrRole nvarchar(max), @firstName nvarchar(max), @lastName nvarchar(max), @userId nvarchar(max), @appPwd varchar(max), @userTitle nvarchar(max), @companyName nvarchar(max), @userPhone nvarchar(max), @userFax nvarchar(max))
AS
BEGIN
	BEGIN TRY
		DECLARE @uid int;
		if exists(select email from [dbo].[users] where email = @userEmail) 
		begin
			SELECT 1 AS ErrorNumber, 'Email Id already exists. Please choose new Email ID' AS ErrorMessage;
		end
		else
		begin
			insert into [dbo].[users] (email,utype,first_name,last_name,username,password,title,companyname,phone,fax,status)
			values (@userEmail,null,@firstName,@lastName,@userId,
			null, --CONVERT(varbinary(max), ISNULL(@appPwd, '')),
			@userTitle,@companyName,@userPhone,@userFax,1);
			set @uid = @@IDENTITY;
			insert into [dbo].[userrole] (uid, utid, enabled, createdon, createdby) 
				SELECT @uid, number, 'Y', GETDATE(), 1 FROM intlist_to_tbl(@usrRole)

			SELECT 0 AS ErrorNumber, 'User Added Successfully' AS ErrorMessage;
		end
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[searchpartdetail]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[searchpartdetail] 

@partid bigint = 0

as begin

	create table #mypcn 
					   (pcnid NVARCHAR(max) NULL,
						pcnrevision NVARCHAR(max) NULL,
						pcnsynopsis NVARCHAR(max) NULL,
						pcndescription NVARCHAR(max) NULL,
						problemid NVARCHAR(max) NULL,
						problemrev NVARCHAR(max) NULL,
						solutionid NVARCHAR(max) NULL,
						solutionrev NVARCHAR(max) NULL,
						impactedid NVARCHAR(max) NULL,
						impactedrev NVARCHAR(max) NULL);
					
	create table #myeto 
						(etoid NVARCHAR(max) NULL,
						etoproj NVARCHAR(max) NULL,
						etoorder NVARCHAR(max) NULL,
						etocustomer NVARCHAR(max) NULL,
						gaid NVARCHAR(max) NULL,
						docid NVARCHAR(max) NULL,
						routingid NVARCHAR(max) NULL,
						docpartid NVARCHAR(max) NULL,
						refid NVARCHAR(max) NULL);

	EXEC dbo.sp_modpcndetail @partid,null,null,null,null,null,null,null,null,null,null;

	EXEC dbo.sp_modetodetail @partid,null,null,null,null,null,null,null,null,null;


	select distinct (it.iid),it.itemid,it.itemname,ISNULL(it.erp_part_description,it.description) as description,it.revision,it.drawingid,it.site,
					dcoid=(op2.name),it.length,it.width,it.height,it.weight,it.datereleased,it.legacy_part_number,it.legacy_document_number,
					op.name as itemtype
	from items it
	left join options op on op.oid=it.itemtype  and op.categoryid = '1'
	left join  options op2 on op2.oid=it.dcoid and op2.categoryid='5'
	where it.iid=@partid;


	select it.drawingid, op1.name as docstatus,opw.name as doctype, itemdt.datasetdesc as docdesc 
	from items it  
	left join options op1 on it.itemstatus=op1.oid
	left join [dbo].[itemreport_dataset] itemdt on itemdt.iid=it.iid left join options opw on opw.oid=itemdt.documenttype and itemdt.status = 0 
	where it.iid=@partid;


	select mypcn.pcnid as pcnid, mypcn.pcnrevision as pcnrevision,mypcn.pcnsynopsis as pcnsynopsis,mypcn.pcndescription as pcndescription, mypcn.problemid as problemid,mypcn.problemrev as problemrev, mypcn.solutionid as solutionid,mypcn.solutionrev as solutionrev, mypcn.impactedid as impactedid, mypcn.impactedrev as impactedrev
	from #mypcn mypcn where mypcn.pcnid is not null;

	select myeto.etoid as etonumber,myeto.etoproj as projectName,myeto.etoorder as ordernumber, myeto.etocustomer as etocustomer,myeto.gaid as ga
	,myeto.docid  as document, myeto.docpartid as docpart, myeto.refid as ref --myeto.routingid as routing,
	from #myeto myeto where myeto.etoid is not null;
end
GO
/****** Object:  StoredProcedure [dbo].[sp_validateUser]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_validateUser](@Email nvarchar(max))
AS
BEGIN
-- [sp_validateUser] 'kamlesh@akscellenceinfo.com'
	select email, password, userRole, [users].status from [dbo].[users]
	left join 
	(
		select uid, stuff((
						select ',' + [usertype].name 
						from [dbo].[userrole] 
						inner join [dbo].[usertype] on userrole.utid = [usertype].utid 
						where mainrole.uid = [userrole].uid and  enabled='Y'
						order by [usertype].name 
						for xml path('')
					),1,1,'') as userRole
		from [dbo].[userrole] mainrole
		group by mainrole.uid
	) user_role on [users].uid = user_role.uid
	where email = @Email;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_displayuser]    Script Date: 06/24/2019 17:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_displayuser] (@userID nvarchar(max), @email nvarchar(max), @userName nvarchar(max), @userRole nvarchar(max))
AS
BEGIN
	select (first_name + ' ' + last_name) username , email, userRole,
	case when [users].status = 1 then 'active' else 'Inactive' end as status, 
	isnull(username,'') as userId 
	from [dbo].[users]
	--inner join [dbo].[usertype] on [users].utype = [usertype].utid
	left join 
	(
		select uid, stuff((
						select ',' + [usertype].name 
						from [dbo].[userrole] 
						inner join [dbo].[usertype] on userrole.utid = [usertype].utid 
						where mainrole.uid = [userrole].uid and  enabled='Y'
						order by [usertype].name 
						for xml path('')
					),1,1,'') as userRole
		from [dbo].[userrole] mainrole
		where ((mainrole.utid in (SELECT number FROM intlist_to_tbl(@userRole)))  or (isnull(@userRole,'0')  = '0')) 
		group by mainrole.uid
	) user_role on [users].uid = user_role.uid

	where ((username like replace(@userID,'*','%'))  or (isnull(@userID,'')  = '')) and
	((email like replace(@email,'*','%'))  or (isnull(@email,'')  = '')) and
	(((first_name + ' ' + last_name) like replace(@userName,'*','%'))  or (isnull(@userName,'')  = ''))
	

END
GO
/****** Object:  Default [DF_usertype_createdtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[usertype] ADD  CONSTRAINT [DF_usertype_createdtm]  DEFAULT (getdate()) FOR [createdtm]
GO
/****** Object:  Default [DF_usertype_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[usertype] ADD  CONSTRAINT [DF_usertype_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_usertype_status]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[usertype] ADD  CONSTRAINT [DF_usertype_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [DF_users_lastlogin]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_lastlogin]  DEFAULT (getdate()) FOR [lastlogin]
GO
/****** Object:  Default [DF_category_status]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[category] ADD  CONSTRAINT [DF_category_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [DF_category_createdtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[category] ADD  CONSTRAINT [DF_category_createdtm]  DEFAULT (getdate()) FOR [createdtm]
GO
/****** Object:  Default [DF_category_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[category] ADD  CONSTRAINT [DF_category_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_attempts_ts]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[attempts] ADD  CONSTRAINT [DF_attempts_ts]  DEFAULT (getdate()) FOR [ts]
GO
/****** Object:  Default [DF_attempts_attempts_status]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[attempts] ADD  CONSTRAINT [DF_attempts_attempts_status]  DEFAULT ((1)) FOR [attempts_status]
GO
/****** Object:  Default [DF_amr_request_date_requested]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[amr_request] ADD  CONSTRAINT [DF_amr_request_date_requested]  DEFAULT (getdate()) FOR [date_requested]
GO
/****** Object:  Default [DF_product_CreatedDate]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
/****** Object:  Default [DF_eto_report_createdtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[eto_report] ADD  CONSTRAINT [DF_eto_report_createdtm]  DEFAULT (getdate()) FOR [createdtm]
GO
/****** Object:  Default [DF_eto_report_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[eto_report] ADD  CONSTRAINT [DF_eto_report_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_documentitems_status]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[documentitems_subtype] ADD  CONSTRAINT [DF_documentitems_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [DF_documentitems_createduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[documentitems_subtype] ADD  CONSTRAINT [DF_documentitems_createduser]  DEFAULT ((1)) FOR [createduser]
GO
/****** Object:  Default [DF_documentitems_createddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[documentitems_subtype] ADD  CONSTRAINT [DF_documentitems_createddtm]  DEFAULT (getdate()) FOR [createddtm]
GO
/****** Object:  Default [DF_documentitems_lastmoduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[documentitems_subtype] ADD  CONSTRAINT [DF_documentitems_lastmoduser]  DEFAULT ((1)) FOR [lastmoduser]
GO
/****** Object:  Default [DF_documentitems_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[documentitems_subtype] ADD  CONSTRAINT [DF_documentitems_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_pcn_report_createdtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[pcn_report] ADD  CONSTRAINT [DF_pcn_report_createdtm]  DEFAULT (getdate()) FOR [createdtm]
GO
/****** Object:  Default [DF_pcn_report_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[pcn_report] ADD  CONSTRAINT [DF_pcn_report_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_options_status]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[options] ADD  CONSTRAINT [DF_options_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [DF_options_createduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[options] ADD  CONSTRAINT [DF_options_createduser]  DEFAULT ((1)) FOR [createduser]
GO
/****** Object:  Default [DF_options_createdtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[options] ADD  CONSTRAINT [DF_options_createdtm]  DEFAULT (getdate()) FOR [createdtm]
GO
/****** Object:  Default [DF_options_lastmoduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[options] ADD  CONSTRAINT [DF_options_lastmoduser]  DEFAULT ((1)) FOR [lastmoduser]
GO
/****** Object:  Default [DF_options_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[options] ADD  CONSTRAINT [DF_options_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_products_createddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[led_support_products] ADD  CONSTRAINT [DF_products_createddtm]  DEFAULT (getdate()) FOR [createddtm]
GO
/****** Object:  Default [DF_products_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[led_support_products] ADD  CONSTRAINT [DF_products_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_tools_createddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[led_ir] ADD  CONSTRAINT [DF_tools_createddtm]  DEFAULT (getdate()) FOR [createddtm]
GO
/****** Object:  Default [DF_tools_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[led_ir] ADD  CONSTRAINT [DF_tools_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_led_iom_certificate_createduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[led_iom_certificate] ADD  CONSTRAINT [DF_led_iom_certificate_createduser]  DEFAULT ((1)) FOR [createduser]
GO
/****** Object:  Default [DF_led_iom_certificate_lastmoduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[led_iom_certificate] ADD  CONSTRAINT [DF_led_iom_certificate_lastmoduser]  DEFAULT ((1)) FOR [lastmoduser]
GO
/****** Object:  Default [DF_documents_createddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[led_iom_certificate] ADD  CONSTRAINT [DF_documents_createddtm]  DEFAULT (getdate()) FOR [createddtm]
GO
/****** Object:  Default [DF_documents_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[led_iom_certificate] ADD  CONSTRAINT [DF_documents_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_items_doc_refernces_createduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items_doc_references] ADD  CONSTRAINT [DF_items_doc_refernces_createduser]  DEFAULT ((1)) FOR [createduser]
GO
/****** Object:  Default [DF_items_doc_refernces_createdtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items_doc_references] ADD  CONSTRAINT [DF_items_doc_refernces_createdtm]  DEFAULT (getdate()) FOR [createdtm]
GO
/****** Object:  Default [DF_items_doc_refernces_lastmoduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items_doc_references] ADD  CONSTRAINT [DF_items_doc_refernces_lastmoduser]  DEFAULT ((1)) FOR [lastmoduser]
GO
/****** Object:  Default [DF_items_doc_refernces_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items_doc_references] ADD  CONSTRAINT [DF_items_doc_refernces_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_items_doc_refernces_status]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items_doc_references] ADD  CONSTRAINT [DF_items_doc_refernces_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [DF_items_createduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items] ADD  CONSTRAINT [DF_items_createduser]  DEFAULT ((1)) FOR [createduser]
GO
/****** Object:  Default [DF_items_createdtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items] ADD  CONSTRAINT [DF_items_createdtm]  DEFAULT (getdate()) FOR [createdtm]
GO
/****** Object:  Default [DF_items_lastmoduser]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items] ADD  CONSTRAINT [DF_items_lastmoduser]  DEFAULT ((1)) FOR [lastmoduser]
GO
/****** Object:  Default [DF_items_lastmoddtm]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items] ADD  CONSTRAINT [DF_items_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  Default [DF_items_status]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items] ADD  CONSTRAINT [DF_items_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [DF_items_dcoid]    Script Date: 06/24/2019 17:32:22 ******/
ALTER TABLE [dbo].[items] ADD  CONSTRAINT [DF_items_dcoid]  DEFAULT ((0)) FOR [dcoid]
GO
/****** Object:  Default [DF_itemreport_dataset_status]    Script Date: 06/24/2019 17:32:23 ******/
ALTER TABLE [dbo].[itemreport_dataset] ADD  CONSTRAINT [DF_itemreport_dataset_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [DF_itemreport_dataset_createduser]    Script Date: 06/24/2019 17:32:23 ******/
ALTER TABLE [dbo].[itemreport_dataset] ADD  CONSTRAINT [DF_itemreport_dataset_createduser]  DEFAULT ((1)) FOR [createduser]
GO
/****** Object:  Default [DF_itemreport_dataset_createdtm]    Script Date: 06/24/2019 17:32:23 ******/
ALTER TABLE [dbo].[itemreport_dataset] ADD  CONSTRAINT [DF_itemreport_dataset_createdtm]  DEFAULT (getdate()) FOR [createdtm]
GO
/****** Object:  Default [DF_itemreport_dataset_lastmoduser]    Script Date: 06/24/2019 17:32:23 ******/
ALTER TABLE [dbo].[itemreport_dataset] ADD  CONSTRAINT [DF_itemreport_dataset_lastmoduser]  DEFAULT ((1)) FOR [lastmoduser]
GO
/****** Object:  Default [DF_itemreport_dataset_lastmoddtm]    Script Date: 06/24/2019 17:32:23 ******/
ALTER TABLE [dbo].[itemreport_dataset] ADD  CONSTRAINT [DF_itemreport_dataset_lastmoddtm]  DEFAULT (getdate()) FOR [lastmoddtm]
GO
/****** Object:  ForeignKey [FK_userrole_users]    Script Date: 06/24/2019 17:32:23 ******/
ALTER TABLE [dbo].[userrole]  WITH CHECK ADD  CONSTRAINT [FK_userrole_users] FOREIGN KEY([uid])
REFERENCES [dbo].[users] ([uid])
GO
ALTER TABLE [dbo].[userrole] CHECK CONSTRAINT [FK_userrole_users]
GO
/****** Object:  ForeignKey [FK_userrole_usertype]    Script Date: 06/24/2019 17:32:23 ******/
ALTER TABLE [dbo].[userrole]  WITH CHECK ADD  CONSTRAINT [FK_userrole_usertype] FOREIGN KEY([utid])
REFERENCES [dbo].[usertype] ([utid])
GO
ALTER TABLE [dbo].[userrole] CHECK CONSTRAINT [FK_userrole_usertype]
GO
