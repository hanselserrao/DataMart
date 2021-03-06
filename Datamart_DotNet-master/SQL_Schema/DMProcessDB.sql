USE [master]
GO
/****** Object:  Database [DMProcessDB]    Script Date: 06/24/2019 17:31:10 ******/
CREATE DATABASE [DMProcessDB] ON  PRIMARY 
( NAME = N'DMProcessDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\DMProcessDB.mdf' , SIZE = 765952KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DMProcessDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\DMProcessDB_log.ldf' , SIZE = 1461184KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DMProcessDB] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DMProcessDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DMProcessDB] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [DMProcessDB] SET ANSI_NULLS OFF
GO
ALTER DATABASE [DMProcessDB] SET ANSI_PADDING OFF
GO
ALTER DATABASE [DMProcessDB] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [DMProcessDB] SET ARITHABORT OFF
GO
ALTER DATABASE [DMProcessDB] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [DMProcessDB] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [DMProcessDB] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [DMProcessDB] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [DMProcessDB] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [DMProcessDB] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [DMProcessDB] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [DMProcessDB] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [DMProcessDB] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [DMProcessDB] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [DMProcessDB] SET  DISABLE_BROKER
GO
ALTER DATABASE [DMProcessDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [DMProcessDB] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [DMProcessDB] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [DMProcessDB] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [DMProcessDB] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [DMProcessDB] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [DMProcessDB] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [DMProcessDB] SET  READ_WRITE
GO
ALTER DATABASE [DMProcessDB] SET RECOVERY SIMPLE
GO
ALTER DATABASE [DMProcessDB] SET  MULTI_USER
GO
ALTER DATABASE [DMProcessDB] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [DMProcessDB] SET DB_CHAINING OFF
GO
USE [DMProcessDB]
GO
/****** Object:  User [engsys]    Script Date: 06/24/2019 17:31:10 ******/
CREATE USER [engsys] FOR LOGIN [engsys] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [datamartprod]    Script Date: 06/24/2019 17:31:10 ******/
CREATE USER [datamartprod] FOR LOGIN [datamartprod] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Destination for PACARTDMRT01 SQLDATAMART DMProcessDB infodba]    Script Date: 06/24/2019 17:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Destination for PACARTDMRT01 SQLDATAMART DMProcessDB infodba](
	[row_Id] [numeric](20, 0) NULL,
	[rows_Id] [numeric](20, 0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XMLwithOpenXML]    Script Date: 06/24/2019 17:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XMLwithOpenXML](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[XMLData] [xml] NULL,
	[LoadedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAD_XMLTABLE]    Script Date: 06/24/2019 17:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAD_XMLTABLE](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[XMLData] [xml] NULL,
	[LoadedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAD_PCN_REL]    Script Date: 06/24/2019 17:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_PCN_REL](
	[PCN_NUMBER] [varchar](128) NULL,
	[PCN_REVISION] [varchar](20) NULL,
	[RELATION_NAME] [varchar](30) NULL,
	[RELATED_ITEM] [varchar](128) NULL,
	[RELATED_ITEM_REVISION] [varchar](128) NULL,
	[STATUS] [char](1) NULL,
	[PUID] [varchar](20) NULL,
	[DATE_IMPORTED] [datetime2](7) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_PCN]    Script Date: 06/24/2019 17:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_PCN](
	[PCN_NUMBER] [varchar](128) NULL,
	[PCN_REVISION] [varchar](20) NULL,
	[SYNOPSIS] [varchar](256) NULL,
	[PCN_DESCRIPTION] [varchar](256) NULL,
	[STATUS] [nchar](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[SITE] [varchar](20) NULL,
	[PUID] [varchar](20) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_PARTREVISION]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_PARTREVISION](
	[PART_NUMBER] [varchar](128) NULL,
	[PART_REVISION] [varchar](32) NULL,
	[PART_TYPE] [varchar](32) NULL,
	[PART_DESCRIPTION] [varchar](252) NULL,
	[ERP_PART_NAME] [varchar](128) NULL,
	[ERP_PART_DESC] [varchar](256) NULL,
	[DCO] [varchar](256) NULL,
	[DATE_CREATED] [datetime2](0) NULL,
	[DATE_RELEASED] [datetime2](0) NULL,
	[RELEASE_STATUS] [varchar](20) NULL,
	[WLENGTH] [varchar](20) NULL,
	[WIDTH] [varchar](20) NULL,
	[HEIGHT] [varchar](20) NULL,
	[WEIGHT] [varchar](20) NULL,
	[ENCUMBRANCE] [varchar](32) NULL,
	[MATERIAL_CODE] [varchar](10) NULL,
	[T4S_ENABLED] [varchar](5) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL,
	[T4S_MM_STATUS] [varchar](50) NULL,
	[T4S_DIR_STATUS] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_PARTDRAWING]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_PARTDRAWING](
	[DRAWING_ID] [varchar](128) NULL,
	[DRAWING_REV] [varchar](32) NULL,
	[ITEM_ID] [varchar](128) NULL,
	[ITEM_REV] [varchar](32) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_LED_SUPPORTPRODUCT]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_LED_SUPPORTPRODUCT](
	[LED_ITEM_ID] [varchar](128) NULL,
	[LED_ITEM_REVISION] [varchar](32) NULL,
	[SUPPORT_PRODUCT_ITEM_ID] [varchar](128) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_LED_SUPPORTPARTS]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_LED_SUPPORTPARTS](
	[LED_ITEM_ID] [varchar](128) NULL,
	[LED_ITEM_REVISION] [varchar](32) NULL,
	[SUPPORT_PART_ITEM_ID] [varchar](128) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_LED_IR]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_LED_IR](
	[LED_ITEM_ID] [varchar](max) NULL,
	[LED_REVISION] [varchar](32) NULL,
	[LED_ITEMTYPE] [nvarchar](32) NULL,
	[DESCRIPTION] [varchar](max) NULL,
	[WLL] [nvarchar](20) NULL,
	[TARE] [nvarchar](20) NULL,
	[WLENGTH] [nvarchar](20) NULL,
	[WIDTH] [nvarchar](20) NULL,
	[HEIGHT] [nvarchar](20) NULL,
	[DCO] [varchar](256) NULL,
	[RELEASE_STATUS] [varchar](20) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [nvarchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL,
	[COMMENTS] [varchar](50) NULL,
	[STATUS] [char](1) NULL,
	[DATE_CREATED] [datetime2](0) NULL,
	[DATE_RELEASED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_LED_IOM]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_LED_IOM](
	[LED_ITEM_ID] [varchar](128) NULL,
	[LED_ITEM_REVISION] [varchar](32) NULL,
	[IOM_ITEM_ID] [varchar](128) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_LED_CERTIFICATE]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_LED_CERTIFICATE](
	[LED_ITEM_ID] [varchar](128) NULL,
	[LED_ITEM_REVISION] [varchar](32) NULL,
	[CERTIFICATE_ITEM_ID] [varchar](128) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_LED_ALT_ALIAS_ID]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_LED_ALT_ALIAS_ID](
	[LED_ITEM_ID] [varchar](128) NULL,
	[ALIAS_ID] [varchar](128) NULL,
	[ALTERNATE_ID] [varchar](128) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_ETO_REV]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_ETO_REV](
	[ETO_NUMBER] [varchar](128) NULL,
	[ETO_REVISION] [varchar](20) NULL,
	[PROJECT_NAME] [varchar](128) NULL,
	[ORDER_NUMBER] [varchar](128) NULL,
	[CUSTOMER] [varchar](128) NULL,
	[RELATION_NAME] [varchar](128) NULL,
	[RELATED_ITEM] [varchar](128) NULL,
	[RELATED_ITEM_REVISION] [varchar](20) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[SITE] [varchar](20) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_ETO]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_ETO](
	[ETO_NUMBER] [varchar](128) NULL,
	[ETO_REVISION] [varchar](20) NULL,
	[PROJECT_NAME] [varchar](128) NULL,
	[ORDER_NUMBER] [varchar](128) NULL,
	[CUSTOMER] [varchar](128) NULL,
	[GA_DRAWING] [varchar](128) NULL,
	[GA_DRAWING_REVISION] [varchar](20) NULL,
	[DOCUMENT] [varchar](128) NULL,
	[DOCUMENT_REVISION] [varchar](20) NULL,
	[ROUTING] [varchar](128) NULL,
	[REFERENCE_ITEM] [varchar](128) NULL,
	[REFERENCES_REVISION] [varchar](20) NULL,
	[ORDER_PARTS] [varchar](128) NULL,
	[ORDER_PARTS_REVISION] [varchar](20) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[SITE] [varchar](20) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_DOCUMENTNUMBER1]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_DOCUMENTNUMBER1](
	[PART_NUMBER] [varchar](128) NOT NULL,
	[PART_REVISION] [varchar](20) NOT NULL,
	[PART_TYPE] [varchar](32) NULL,
	[DRAWING_NUMBER] [varchar](128) NULL,
	[DRAWING_REVISION] [varchar](20) NULL,
	[DRAWING_TYPE] [varchar](32) NULL,
	[SITE] [varchar](20) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_DOCUMENTNUMBER]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_DOCUMENTNUMBER](
	[PART_NUMBER] [varchar](128) NOT NULL,
	[PART_REVISION] [varchar](128) NOT NULL,
	[PART_TYPE] [varchar](32) NULL,
	[DRAWING_NUMBER] [varchar](128) NULL,
	[DRAWING_REVISION] [varchar](128) NULL,
	[DRAWING_TYPE] [varchar](32) NULL,
	[SITE] [varchar](20) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL,
 CONSTRAINT [PK_LOAD_DOCUMENTNUMBER] PRIMARY KEY CLUSTERED 
(
	[PART_NUMBER] ASC,
	[PART_REVISION] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_DOCUMENT_SUBTYPE]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_DOCUMENT_SUBTYPE](
	[ITEM_ID] [varchar](128) NOT NULL,
	[NAME] [varchar](128) NULL,
	[SUB_TYPE] [varchar](20) NULL,
	[SITE] [varchar](10) NOT NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_DOCITEM_REFERENCES]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_DOCITEM_REFERENCES](
	[ITEM_ID] [varchar](128) NULL,
	[PART_REVISION] [varchar](32) NULL,
	[PART_TYPE] [varchar](32) NULL,
	[DOCUMENT_ITEM_ID] [varchar](128) NULL,
	[DOCUMENT_ITEM_REV] [varchar](32) NULL,
	[DOCUMENT_NAME] [nvarchar](256) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_DATASETS_TRANS_old2]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[LOAD_DATASETS_TRANS_old2](
	[PART_NUMBER] [varchar](128) NULL,
	[PART_REVISION] [varchar](32) NULL,
	[PART_TYPE] [varchar](32) NULL,
	[DATASET_NAME] [varchar](128) NULL,
	[DATASET_TYPE] [varchar](32) NULL,
	[DATASET_DESCRIPTION] [varchar](256) NULL,
	[DATASET_CREATED_DATE] [datetime2](0) NULL,
	[DATASET_REL_STATUS] [varchar](32) NULL,
	[DATASET_REL_DATE] [datetime2](0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[IS_DOCNUMBER] [varchar](1) NULL,
	[IS_PRT_UNDER_DRW] [varchar](1) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_DATASETS_TRANS]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_DATASETS_TRANS](
	[PART_NUMBER] [varchar](128) NULL,
	[PART_REVISION] [varchar](32) NULL,
	[PART_TYPE] [varchar](32) NULL,
	[DATASET_NAME] [varchar](128) NULL,
	[DATASET_TYPE] [varchar](32) NULL,
	[DATASET_DESCRIPTION] [varchar](256) NULL,
	[DATASET_CREATED_DATE] [datetime2](0) NULL,
	[DATASET_REL_STATUS] [varchar](32) NULL,
	[DATASET_REL_DATE] [datetime2](0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[IS_DOCNUMBER] [varchar](1) NULL,
	[IS_PRT_UNDER_DRW] [varchar](1) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_DATASETS_FILESPATH]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_DATASETS_FILESPATH](
	[PART_NUMBER] [varchar](128) NULL,
	[PART_REVISION] [varchar](32) NULL,
	[PART_TYPE] [varchar](32) NULL,
	[DATASET_NAME] [varchar](128) NULL,
	[DATASET_TYPE] [varchar](32) NULL,
	[FILE_PATH] [varchar](max) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[SITE] [varchar](10) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL,
	[PARTREV_PUID] [varchar](20) NULL,
	[DATASET_PUID] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_DATASETS]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_DATASETS](
	[PART_NUMBER] [varchar](128) NULL,
	[PART_REVISION] [varchar](32) NULL,
	[PART_TYPE] [varchar](32) NULL,
	[DATASET_NAME] [varchar](128) NULL,
	[DATASET_TYPE] [varchar](32) NULL,
	[DATASET_DESCRIPTION] [varchar](256) NULL,
	[DATASET_CREATED_DATE] [datetime2](0) NULL,
	[DATASET_REL_STATUS] [varchar](32) NULL,
	[DATASET_REL_DATE] [datetime2](0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [varchar](50) NULL,
	[IS_DOCNUMBER] [varchar](1) NULL,
	[IS_PRT_UNDER_DRW] [varchar](1) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOAD_ALT_ALIAS_ID]    Script Date: 06/24/2019 17:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOAD_ALT_ALIAS_ID](
	[ITEM_ID] [varchar](128) NULL,
	[ALTERNATE_ID] [varchar](128) NULL,
	[ALIAS_ID] [varchar](128) NULL,
	[LEGACY_PART_NUMBER] [varchar](128) NULL,
	[LEGACY_DRAWING_NUMBER] [varchar](128) NULL,
	[SITE] [varchar](10) NULL,
	[PUID] [varchar](20) NULL,
	[OBJ_TAG] [numeric](20, 0) NULL,
	[STATUS] [char](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DATE_IMPORTED] [datetime2](0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[INACTIVE_BAD_DATA]    Script Date: 06/24/2019 17:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lokesh Podigiri
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[INACTIVE_BAD_DATA] 
		@SITE_ID NVARCHAR (MAX)=NULL
AS
BEGIN
	UPDATE dbo.LOAD_ALT_ALIAS_ID SET STATUS='1' , COMMENTS='EMPTY PART NUMBER' WHERE  (ITEM_ID='' or LEN(ITEM_ID)<1) AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_DATASETS SET STATUS='1' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_DATASETS_FILESPATH SET STATUS='1' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1)  AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_DATASETS_TRANS SET STATUS='1' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1)  AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_ETO SET STATUS='1' , COMMENTS='EMPTY ETO NUMBER' WHERE  (ETO_NUMBER='' or LEN(ETO_NUMBER)<1) AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_MATERIALCODE SET STATUS='1' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_PARTDRAWING SET STATUS='1' , COMMENTS='EMPTY DRAWING ITEM ID' WHERE  (DRAWING_ID='' or LEN(DRAWING_ID)<1) AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_PARTREVISION SET STATUS='1' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_PARTREVISION SET STATUS='2' , COMMENTS='PART NUMBER LENGTH > 18' WHERE LEN(PART_NUMBER)>18 AND SITE=@SITE_ID;
	UPDATE dbo.LOAD_PCN SET STATUS='1' , COMMENTS='EMPTY PCN NUMBER' WHERE (PCN_NUMBER='' or LEN(PCN_NUMBER)<1) AND SITE=@SITE_ID;;

END
GO
/****** Object:  StoredProcedure [dbo].[Truncate_DMProcessDB]    Script Date: 06/24/2019 17:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lokesh Podigiri
-- Create date: 04-Jan-2017
-- Description:	Truncate All Tables in DMProcessDB
-- =============================================
CREATE PROCEDURE [dbo].[Truncate_DMProcessDB] 
	
AS
BEGIN
	
	TRUNCATE TABLE dbo.LOAD_ALT_ALIAS_ID;
	TRUNCATE TABLE dbo.LOAD_DATASETS;
	TRUNCATE TABLE dbo.LOAD_DATASETS_FILESPATH;
	TRUNCATE TABLE dbo.LOAD_DATASETS_TRANS;
	TRUNCATE TABLE dbo.LOAD_DOCITEM_REFERENCES;
	TRUNCATE TABLE dbo.LOAD_DOCUMENT_SUBTYPE;
	TRUNCATE TABLE dbo.LOAD_DOCUMENTNUMBER;
	TRUNCATE TABLE dbo.LOAD_ETO;
	TRUNCATE TABLE dbo.LOAD_LED_ALT_ALIAS_ID;
	TRUNCATE TABLE dbo.LOAD_LED_CERTIFICATE;
	TRUNCATE TABLE dbo.LOAD_LED_IOM;
	TRUNCATE TABLE dbo.LOAD_LED_IR;
	TRUNCATE TABLE dbo.LOAD_LED_SUPPORTPARTS;
	TRUNCATE TABLE dbo.LOAD_LED_SUPPORTPRODUCT;
	TRUNCATE TABLE dbo.LOAD_MATERIALCODE;
	TRUNCATE TABLE dbo.LOAD_PARTDRAWING;
	TRUNCATE TABLE dbo.LOAD_PARTREVISION;
	TRUNCATE TABLE dbo.LOAD_PCN;
END
GO
/****** Object:  StoredProcedure [dbo].[TRASNFROMATION_DATASET_SITE]    Script Date: 06/24/2019 17:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TRASNFROMATION_DATASET_SITE]  
	-- Add the parameters for the stored procedure here
	@SITE_ID NVARCHAR (MAX)=NULL
	
AS
BEGIN

      UPDATE dbo.LOAD_DATASETS SET IS_DOCNUMBER = '0' FROM dbo.LOAD_DATASETS WHERE SITE=@SITE_ID;;
      UPDATE dbo.LOAD_DATASETS SET IS_PRT_UNDER_DRW = '0' FROM dbo.LOAD_DATASETS WHERE SITE=@SITE_ID;;
	  DELETE FROM LOAD_DATASETS_TRANS WHERE SITE=@SITE_ID;
      UPDATE dbo.LOAD_DATASETS
         SET 
            IS_DOCNUMBER = 'Y'
      FROM dbo.LOAD_DATASETS  AS DS
      WHERE EXISTS 
         (
            SELECT 1
            FROM dbo.LOAD_PARTDRAWING  AS PD
            WHERE 
               DS.PART_NUMBER = PD.DRAWING_ID AND 
               DS.PART_REVISION = PD.DRAWING_REV AND 
               PD.ITEM_ID <>'' AND 
               PD.ITEM_REV <>'' AND 
               PD.PUID = DS.PUID AND 
               PD.SITE = @SITE_ID AND
               DS.SITE = @SITE_ID
         );

      UPDATE dbo.LOAD_DATASETS
         SET 
            IS_PRT_UNDER_DRW = 'Y'
      FROM dbo.LOAD_DATASETS  AS DS
      WHERE EXISTS 
         (
            SELECT 1 
            FROM dbo.LOAD_PARTDRAWING  AS PD
            WHERE 
               DS.PART_NUMBER = PD.ITEM_ID AND 
               DS.PART_REVISION = PD.ITEM_REV AND 
               PD.DRAWING_ID <>'' AND 
               PD.DRAWING_REV <>'' AND 
               PD.SITE = @SITE_ID AND
               DS.SITE = @SITE_ID
         );

      INSERT dbo.LOAD_DATASETS_TRANS(
         PART_NUMBER, 
         PART_REVISION, 
         PART_TYPE, 
         DATASET_NAME, 
         DATASET_TYPE, 
         DATASET_DESCRIPTION, 
         DATASET_CREATED_DATE, 
         DATASET_REL_STATUS, 
         DATASET_REL_DATE, 
         STATUS, 
         COMMENTS, 
         IS_DOCNUMBER, 
         IS_PRT_UNDER_DRW, 
         SITE, 
         PUID, 
         OBJ_TAG, 
         DATE_IMPORTED)
         SELECT 
            DS.PART_NUMBER, 
            DS.PART_REVISION, 
            DS.PART_TYPE, 
            DS.DATASET_NAME, 
            DS.DATASET_TYPE, 
            DS.DATASET_DESCRIPTION, 
            DS.DATASET_CREATED_DATE, 
            DS.DATASET_REL_STATUS, 
            DS.DATASET_REL_DATE, 
            DS.STATUS, 
            --DS.COMMENTS, 
            'Part Centric',
            DS.IS_DOCNUMBER, 
            DS.IS_PRT_UNDER_DRW, 
            DS.SITE, 
            DS.PUID, 
            DS.OBJ_TAG, 
            DS.DATE_IMPORTED
         FROM dbo.LOAD_DATASETS  AS DS
         WHERE 
            (DS.IS_DOCNUMBER = '0' AND DS.IS_PRT_UNDER_DRW = '0') AND 
            DS.STATUS = '0' AND DS.DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','Technical EngineeringPDF','Zip' ) AND DS.PART_TYPE <> 'DocumentRevision' AND DS.SITE = @SITE_ID;

      INSERT dbo.LOAD_DATASETS_TRANS(
         PART_NUMBER, 
         PART_REVISION, 
         PART_TYPE, 
         DATASET_NAME, 
         DATASET_TYPE, 
         DATASET_DESCRIPTION, 
         DATASET_CREATED_DATE, 
         DATASET_REL_STATUS, 
         DATASET_REL_DATE, 
         STATUS, 
         COMMENTS, 
         IS_DOCNUMBER, 
         IS_PRT_UNDER_DRW, 
         SITE, 
         PUID, 
         OBJ_TAG, 
         DATE_IMPORTED)
         SELECT DISTINCT 
            DN.PART_NUMBER, 
            DN.PART_REVISION, 
            DN.PART_TYPE, 
            DS.DATASET_NAME, 
            DS.DATASET_TYPE, 
            DS.DATASET_DESCRIPTION, 
            DS.DATASET_CREATED_DATE, 
            DS.DATASET_REL_STATUS, 
            DS.DATASET_REL_DATE, 
            DS.STATUS, 
            --DS.COMMENTS, 
            'Drawing Centric',
            DS.IS_DOCNUMBER, 
            DS.IS_PRT_UNDER_DRW, 
            DS.SITE, 
            DS.PUID, 
            DS.OBJ_TAG, 
            DS.DATE_IMPORTED
         FROM 
            dbo.LOAD_DATASETS  AS DS 
               LEFT OUTER JOIN dbo.LOAD_DOCUMENTNUMBER  AS DN 
               ON 
                  DS.PART_NUMBER = DN.DRAWING_NUMBER AND 
                  DS.PART_REVISION = DN.DRAWING_REVISION AND 
                  DS.SITE = DN.SITE
         WHERE 
            DN.PART_TYPE <> 'Drawing Item Revision' AND 
            (DS.IS_DOCNUMBER = 'Y' OR DS.IS_PRT_UNDER_DRW = 'Y') AND
            DS.STATUS = '0' AND DS.DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','Technical EngineeringPDF') AND DS.PART_TYPE <> 'DocumentRevision' AND DS.SITE = @SITE_ID;
            
            INSERT dbo.LOAD_DATASETS_TRANS(
         PART_NUMBER, 
         PART_REVISION, 
         PART_TYPE, 
         DATASET_NAME, 
         DATASET_TYPE, 
         DATASET_DESCRIPTION, 
         DATASET_CREATED_DATE, 
         DATASET_REL_STATUS, 
         DATASET_REL_DATE, 
         STATUS, 
         COMMENTS, 
         IS_DOCNUMBER, 
         IS_PRT_UNDER_DRW, 
         SITE, 
         PUID, 
         OBJ_TAG, 
         DATE_IMPORTED)
         SELECT DISTINCT 
            DN.PART_NUMBER, 
            DN.PART_REVISION, 
            DN.PART_TYPE, 
            DS.DATASET_NAME, 
            DS.DATASET_TYPE, 
            DS.DATASET_DESCRIPTION, 
            DS.DATASET_CREATED_DATE, 
            DS.DATASET_REL_STATUS, 
            DS.DATASET_REL_DATE, 
            DS.STATUS, 
            DS.COMMENTS, 
            DS.IS_DOCNUMBER, 
            DS.IS_PRT_UNDER_DRW, 
            DS.SITE, 
            DS.PUID, 
            DS.OBJ_TAG, 
            DS.DATE_IMPORTED
         FROM 
            dbo.LOAD_DATASETS  AS DS 
               LEFT OUTER JOIN dbo.LOAD_DOCUMENTNUMBER  AS DN 
               ON 
                  DS.PART_NUMBER = DN.DRAWING_NUMBER AND 
                  DS.PART_REVISION = DN.DRAWING_REVISION AND 
                  DS.SITE = DN.SITE
         WHERE 
            DS.STATUS = '0' AND DS.PART_TYPE = 'DocumentRevision' AND DS.SITE = @SITE_ID;
            
            

   END
GO
/****** Object:  StoredProcedure [dbo].[TRANSFORMATION_SITE]    Script Date: 06/24/2019 17:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LOKESH PODIGIRI
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[TRANSFORMATION_SITE] 
	-- Add the parameters for the stored procedure here
	@SITE_ID NVARCHAR (MAX)=NULL
	
AS
BEGIN

UPDATE [dbo].[LOAD_PARTREVISION] SET COMMENTS='NOT PROCESSED',STATUS='9'; 
UPDATE [dbo].[LOAD_DATASETS] SET COMMENTS='NOT PROCESSED',STATUS='9';

	 UPDATE [dbo].[LOAD_PARTREVISION] SET STATUS = '1', COMMENTS='PART TYPE' WHERE PART_TYPE NOT IN ('WGP4_ConeCrusherRevision',
'WGP4_ConveyorsRevision','WGP4_ElastomerRevision','WGP4_FeederRevision','WGP4_HPGRRevision',
'WGP4_HoseRevision','WGP4_MechSealRevision','WGP4_MechatronicRevision','WGP4_Mill_LinerRevision',
'WGP4_PartResorceRevision','WGP4_PlantRevision','WGP4_SpoolRevision','WGP4_WasherRevision',
'WGP7CycClustRevision','Warman Cyclone Revision','Warman Equipment Revision','Warman Part Tool Revision',
'Warman Pump Revision','Warman Tool Aid Revision','Weir Minerals Revision','Weir Screen Revision',
'Weir Valve Revision','ItemRevision','Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision','WGP4_Ball_FeederRevision',
'WGP4_BargeRevision','WGP4_BladeMillRevision','WGP4_CentrifugeRevision','WGP4_LiftingERevision','WGP4_TransportCRevision'
);

UPDATE [dbo].[LOAD_DATASETS]  SET STATUS = '1', COMMENTS='PART TYPE' WHERE PART_TYPE NOT IN ('WGP4_ConeCrusherRevision',
'WGP4_ConveyorsRevision','WGP4_ElastomerRevision','WGP4_FeederRevision','WGP4_HPGRRevision',
'WGP4_HoseRevision','WGP4_MechSealRevision','WGP4_MechatronicRevision','WGP4_Mill_LinerRevision',
'WGP4_PartResorceRevision','WGP4_PlantRevision','WGP4_SpoolRevision','WGP4_WasherRevision',
'WGP7CycClustRevision','Warman Cyclone Revision','Warman Equipment Revision','Warman Part Tool Revision',
'Warman Pump Revision','Warman Tool Aid Revision','Weir Minerals Revision','Weir Screen Revision',
'Weir Valve Revision','ItemRevision','Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision','WGP4_Ball_FeederRevision',
'WGP4_BargeRevision','WGP4_BladeMillRevision','WGP4_CentrifugeRevision','WGP4_LiftingERevision','WGP4_TransportCRevision'
);


UPDATE [dbo].[LOAD_PARTREVISION] SET STATUS = '1', COMMENTS='SYS DOC' WHERE PART_NUMBER LIKE 'SysDoc%';
UPDATE [dbo].[LOAD_DATASETS]  SET STATUS = '1', COMMENTS='SYS DOC' WHERE PART_NUMBER LIKE 'SysDoc%';

UPDATE [dbo].LOAD_ETO SET STATUS = '0', COMMENTS='ALL STATUS IS ALLOWED';
UPDATE [dbo].LOAD_PCN SET STATUS = '0', COMMENTS='ALL STATUS IS ALLOWED';


 UPDATE dbo.LOAD_PARTREVISION
         SET 
            STATUS = 
               CASE 
                  WHEN LOAD_PARTREVISION.STATUS = '1' THEN LOAD_PARTREVISION.STATUS
                  WHEN LOAD_PARTREVISION.RELEASE_STATUS NOT IN ( 'Production', 'Superseded' ) THEN '1'
                  WHEN (LOAD_PARTREVISION.RELEASE_STATUS IS NULL) THEN '1'
                  WHEN (LOAD_PARTREVISION.RELEASE_STATUS='') THEN '1'
                  WHEN LOAD_PARTREVISION.RELEASE_STATUS IN ( 'Production', 'Superseded' ) THEN '0'
                  ELSE '9'
               END, 
            COMMENTS = 
               CASE 
                  WHEN LOAD_PARTREVISION.STATUS = '1' THEN LOAD_PARTREVISION.COMMENTS
                  WHEN LOAD_PARTREVISION.RELEASE_STATUS NOT IN ( 'Production', 'Superseded' ) THEN 'STATUS NOT IN SUPERSEED / PROD'
                  WHEN (LOAD_PARTREVISION.RELEASE_STATUS IS NULL) THEN 'STATUS IS NULL'
                  WHEN (LOAD_PARTREVISION.RELEASE_STATUS ='') THEN 'STATUS IS NULL'
                  WHEN LOAD_PARTREVISION.RELEASE_STATUS IN ( 'Production', 'Superseded' ) THEN 'STATUS IN SUPERSEED / PROD'
                  ELSE 'NOT PROCESSED'
               END;

      UPDATE dbo.LOAD_DATASETS
         SET 
            STATUS = 
               CASE 
                  WHEN LOAD_DATASETS.STATUS = '1' THEN LOAD_DATASETS.STATUS
                  WHEN LOAD_DATASETS.DATASET_REL_STATUS NOT IN ( 'Production', 'Superseded' ) THEN '1'
                  WHEN LOAD_DATASETS.DATASET_REL_STATUS IS NULL THEN '1'
                  WHEN LOAD_DATASETS.DATASET_REL_STATUS ='' THEN '1'
                  WHEN LOAD_DATASETS.DATASET_REL_STATUS IN ( 'Production', 'Superseded' ) THEN '0'
                  ELSE '9'
               END, 
            COMMENTS = 
               CASE 
                  WHEN LOAD_DATASETS.STATUS = '1' THEN LOAD_DATASETS.COMMENTS
                  WHEN LOAD_DATASETS.DATASET_REL_STATUS NOT IN ( 'Production', 'Superseded' ) THEN 'STATUS NOT IN SUPERSEED / PROD'
                  WHEN LOAD_DATASETS.DATASET_REL_STATUS IS NULL THEN 'STATUS IS NULL'
                  WHEN LOAD_DATASETS.DATASET_REL_STATUS ='' THEN 'STATUS IS NULL'
                  WHEN LOAD_DATASETS.DATASET_REL_STATUS IN ( 'Production', 'Superseded' ) THEN 'STATUS IN SUPERSEED / PROD'
                  ELSE 'NOT PROCESSED'
               END;
  
WITH CTE(PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE,STATUS,COMMENTS,DuplicateCount)
AS
(
SELECT PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE,STATUS,COMMENTS,ROW_NUMBER() 
OVER(PARTITION BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE ORDER BY PART_NUMBER ) 
as DuplicateCount FROM dbo.LOAD_PARTREVISION
)
 UPDATE CTE SET STATUS='1',COMMENTS='DUPLICATE STATUS' WHERE DuplicateCount>1;
  
 
WITH CTE(PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE,STATUS,COMMENTS,DuplicateCount)
AS
(
SELECT PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE,STATUS,COMMENTS,ROW_NUMBER() 
OVER(PARTITION BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE ORDER BY PART_NUMBER ) 
as DuplicateCount FROM dbo.LOAD_DATASETS
)
 UPDATE CTE SET STATUS='1',COMMENTS='DUPLICATE STATUS' WHERE DuplicateCount>1;
  
UPDATE dbo.LOAD_PARTREVISION SET STATUS ='1', COMMENTS='MULTIPLE STATUS' WHERE PUID IN (SELECT PUID   FROM dbo.LOAD_PARTREVISION WHERE STATUS ='0' GROUP BY
  PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,SITE HAVING COUNT(RELEASE_STATUS) = 2) AND RELEASE_STATUS='Production';  
  
   UPDATE dbo.LOAD_DATASETS SET STATUS ='1', COMMENTS='MULTIPLE STATUS' WHERE PUID IN (SELECT PUID FROM dbo.LOAD_DATASETS WHERE STATUS ='0' GROUP BY
 PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,SITE  HAVING COUNT(DATASET_REL_STATUS) = 2 ) AND DATASET_REL_STATUS='Production' ;
  
UPDATE [dbo].[LOAD_PARTREVISION] SET STATUS = '1', COMMENTS='EMPTY PART_NUMBER' WHERE PART_NUMBER ='';
UPDATE [dbo].[LOAD_DATASETS]  SET STATUS = '1', COMMENTS='EMPTY PART_NUMBER' WHERE PART_NUMBER ='';
  
  
END
GO
/****** Object:  StoredProcedure [dbo].[GENERATE_DOCUMENT_NUMBER_SITE]    Script Date: 06/24/2019 17:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lokesh Podigiri
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GENERATE_DOCUMENT_NUMBER_SITE] 
	-- Add the parameters for the stored procedure here
	@SITE_ID NVARCHAR (MAX)=NULL
AS
BEGIN
	DECLARE
		 @alt_drw_type varchar(20) = 'ALTERNATE_ID', 
         @alias_drw_type varchar(10) = 'ALIAS_ID', 
         @drwItem_drw_type varchar(20) = 'DRAWING_ITEM_VIEW', 
         @drwItem_drw_type_multi_rev varchar(32) = 'DRAWING_ITEM_VIEW_MULTI_REVS', 
         @Doc_id_as_drw_type varchar(20) = 'DOC_ITEM_ID', 
         @Drw_id_as_drw_type varchar(20) = 'DRAWING_ITEM_ID', 
         @mat_code_as_drw_type varchar(20) = 'MATCODE_MATERIALS', 
         @site varchar(20)= @SITE_ID; 
         
    DELETE FROM dbo.LOAD_DOCUMENTNUMBER WHERE SITE=@site;
	
	insert into LOAD_DOCUMENTNUMBER(PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)
	SELECT PR.PART_NUMBER,PR.PART_REVISION,PR.PART_TYPE,ALT.ALTERNATE_ID,PR.PART_REVISION,@alt_drw_type,ALT.SITE 
	FROM LOAD_ALT_ALIAS_ID ALT LEFT JOIN LOAD_PARTREVISION PR
	ON ALT.ITEM_ID = PR.PART_NUMBER AND PR.SITE = ALT.SITE 
	WHERE ALT.ALTERNATE_ID <> '' AND PR.PART_TYPE NOT IN ('Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision') AND ALT.SITE=@site;
	
	insert into LOAD_DOCUMENTNUMBER(PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)
	SELECT PR.PART_NUMBER,PR.PART_REVISION,PR.PART_TYPE,ALT.ALIAS_ID,PR.PART_REVISION,@alias_drw_type,ALT.SITE 
	FROM LOAD_ALT_ALIAS_ID ALT LEFT JOIN LOAD_PARTREVISION PR
	ON ALT.ITEM_ID = PR.PART_NUMBER AND PR.SITE = ALT.SITE 
	WHERE ALT.ALIAS_ID <> '' AND PR.PART_TYPE NOT IN ('Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision') AND ALT.SITE=@site;
	
	insert into LOAD_DOCUMENTNUMBER(PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)
	SELECT PD.ITEM_ID,PD.ITEM_REV,PR.PART_TYPE,PD.DRAWING_ID,PD.DRAWING_REV,@drwItem_drw_type,PD.SITE 
	FROM dbo.LOAD_PARTDRAWING PD LEFT JOIN LOAD_PARTREVISION PR
	ON PD.ITEM_ID = PR.PART_NUMBER AND PD.SITE = PR.SITE 
	WHERE PD.ITEM_ID <> '' AND PD.SITE=@site;
	
	insert into LOAD_DOCUMENTNUMBER(PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)
	SELECT [PART_NUMBER],[PART_REVISION],'WGP4_MatSpecRevision',[MAT_LOCAL_CODE],[PART_REVISION],@mat_code_as_drw_type,SITE from [LOAD_MATERIALCODE]
	where [PART_NUMBER]<>'' AND SITE=@site;
	  
	
	insert into LOAD_DOCUMENTNUMBER(PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)
	SELECT [PART_NUMBER],[PART_REVISION],[PART_TYPE],[PART_NUMBER],[PART_REVISION],@Doc_id_as_drw_type,SITE FROM [LOAD_PARTREVISION] 
	WHERE [PART_TYPE]='DocumentRevision' AND [PART_NUMBER] NOT Like 'SysDoC%' AND SITE=@site ;
	
	
	insert into LOAD_DOCUMENTNUMBER(PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)
	SELECT PD.DRAWING_ID,PD.DRAWING_REV,'Drawing Item Revision',PD.DRAWING_ID,PD.DRAWING_REV,@Drw_id_as_drw_type,PD.SITE 
	FROM dbo.LOAD_PARTDRAWING PD WHERE PD.ITEM_ID = '' AND SITE=@site ; 
	
	
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[EXTRACT_TRANSFORM_LED]    Script Date: 06/24/2019 17:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lokesh Podigiri
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[EXTRACT_TRANSFORM_LED] 
	-- Add the parameters for the stored procedure here
	@SITE_ID NVARCHAR (MAX)=NULL
	

AS
BEGIN
DECLARE	@return_value int

EXEC	@return_value = [dbo].[IMPORT_LED_IR_SITE]
		@SITE_ID;
SELECT	'Return Value 4 [IMPORT_LED_IR_SITE]' = @return_value
SELECT COUNT(*) AS 'TOTAL ROWS' from [dbo].LOAD_LED_IR where SITE=@SITE_ID+'_PROD';

EXEC	@return_value = [dbo].IMPORT_LED_ALT_ALIAS_SITE
		@SITE_ID;
SELECT	'Return Value 4 IMPORT_LED_ALT_ALIAS_SITE' = @return_value;
SELECT COUNT(*) AS 'TOTAL ROWS' from [dbo].LOAD_LED_ALT_ALIAS_ID where SITE=@SITE_ID+'_PROD';


EXEC	@return_value = [dbo].IMPORT_LED_CERTIFICATE_SITE
		@SITE_ID;
SELECT	'Return Value 4 IMPORT_LED_CERTIFICATE_SITE' = @return_value;
SELECT COUNT(*) AS 'TOTAL ROWS' from [dbo].LOAD_LED_CERTIFICATE where SITE=@SITE_ID+'_PROD';

EXEC	@return_value = [dbo].IMPORT_LED_IOM_SITE
		@SITE_ID;
SELECT	'Return Value 4 IMPORT_LED_IOM_SITE' = @return_value;
SELECT COUNT(*) AS 'TOTAL ROWS' from [dbo].LOAD_LED_IOM where SITE=@SITE_ID+'_PROD';

EXEC	@return_value = [dbo].IMPORT_LED_SUPPORT_PART_SITE
		@SITE_ID;
SELECT	'Return Value 4 IMPORT_LED_SUPPORT_PART_SITE' = @return_value;
SELECT COUNT(*) AS 'TOTAL ROWS' from [dbo].LOAD_LED_SUPPORTPARTS where SITE=@SITE_ID+'_PROD';

EXEC	@return_value = [dbo].IMPORT_LED_SUPPORT_PRODUCT_SITE
		@SITE_ID;
SELECT	'Return Value 4 IMPORT_LED_SUPPORT_PRODUCT_SITE' = @return_value;
SELECT COUNT(*) AS 'TOTAL ROWS' from [dbo].LOAD_LED_SUPPORTPRODUCT where SITE=@SITE_ID+'_PROD';

EXEC	@return_value = [dbo].IMPORT_LED_INACTIVE_BAD_DATA
		@SITE_ID;
SELECT	'Return Value 4 IMPORT_LED_INACTIVE_BAD_DATA' = @return_value;

END
GO
/****** Object:  StoredProcedure [dbo].[EXTRACT_TRANSFORM]    Script Date: 06/24/2019 17:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lokesh Podigiri
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[EXTRACT_TRANSFORM] 
	-- Add the parameters for the stored procedure here
	@SITE_ID NVARCHAR (MAX)=NULL
	

AS
BEGIN
DECLARE	@return_value int
		,@IRXML_NAME NVARCHAR (MAX)
		,@ALT_ALIAS_XML_NAME  NVARCHAR (MAX)
		,@IR_DOCREFERENCE_XML_NAME  NVARCHAR (MAX)
		,@DOCUMENT_ITEM_XML_NAME  NVARCHAR (MAX)
		,@MATCODE_XML_NAME  NVARCHAR (MAX)
		,@DRAWINGITEM_XML_NAME  NVARCHAR (MAX)
		,@DATASET_XML_NAME  NVARCHAR (MAX)
		,@DATASETFILESLOC_XML_NAME  NVARCHAR (MAX)
		,@DATASETFILESLOCZIP_XML_NAME  NVARCHAR (MAX)
		,@ETO_XML_NAME  NVARCHAR (MAX)
		,@PCN_XML_NAME  NVARCHAR (MAX)
		,@SITE_NAME NVARCHAR (MAX);

SET @IRXML_NAME='outGPDM_'+@SITE_ID+'_IRLocal.xml';
SET @ALT_ALIAS_XML_NAME='outGPDM_'+@SITE_ID+'_ALIAS_ALTERNATE.xml';
SET @IR_DOCREFERENCE_XML_NAME='outGPDM_'+@SITE_ID+'_IRDocRefrenceLocal.xml';
SET @DOCUMENT_ITEM_XML_NAME='outGPDM_'+@SITE_ID+'_DOCUMENT_SUBTYPE.xml';
SET @MATCODE_XML_NAME='outGPDM_'+@SITE_ID+'_MaterialLocal.xml';
SET @DRAWINGITEM_XML_NAME='outGPDM_'+@SITE_ID+'_DRWLocal.xml';
SET @DATASET_XML_NAME='outGPDM_'+@SITE_ID+'_DatasetLocal.xml';
SET @DATASETFILESLOC_XML_NAME='outGPDM_'+@SITE_ID+'_DatasetLocalFiles.xml';
SET @ETO_XML_NAME='outGPDM_'+@SITE_ID+'_ETO.xml';
SET @PCN_XML_NAME='outGPDM_'+@SITE_ID+'_PCN.xml';

SET @SITE_NAME=@SITE_ID+'_PROD';

EXEC	@return_value = [dbo].[IMPORT_PART_REVISION_SITE]
		@IRXML_NAME,@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL PARTS IMPORTED' from [dbo].LOAD_PARTREVISION where SITE=@SITE_NAME;

EXEC	@return_value = [dbo].[IMPORT_ALT_ALIAS_ID_SITE]
		@ALT_ALIAS_XML_NAME,@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL ALT IDS IMPORTED' from [dbo].LOAD_ALT_ALIAS_ID where SITE=@SITE_NAME and LEN(ALTERNATE_ID)>0;
SELECT COUNT(*) AS 'TOTAL ALIAS IDS IMPORTED' from [dbo].LOAD_ALT_ALIAS_ID where SITE=@SITE_NAME and LEN(ALIAS_ID)>0;	

EXEC	@return_value = [dbo].[IMPORT_DOCITEM_REFERENCES_SITE]
		@IR_DOCREFERENCE_XML_NAME,@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL IR DOC REFS IMPORTED' from [dbo].LOAD_DOCITEM_REFERENCES where SITE=@SITE_NAME and LEN(DOCUMENT_ITEM_ID)>0;

EXEC	@return_value = [dbo].[IMPORT_DOCUMENT_SUBTYPE_SITE]
		@DOCUMENT_ITEM_XML_NAME,@SITE_NAME;;


EXEC	@return_value = [dbo].[IMPORT_MATERIAL_CODE_SITE]
		@MATCODE_XML_NAME,@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL MATERIALS IMPORT' from [dbo].LOAD_MATERIALCODE where SITE=@SITE_NAME and LEN(MAT_LOCAL_CODE) >0 ;

EXEC	@return_value = [dbo].[IMPORT_PARTDRAWING_SITE]
		@DRAWINGITEM_XML_NAME,@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL DRAWINGS IMPORTED' from [dbo].LOAD_PARTDRAWING where SITE=@SITE_NAME;


EXEC	@return_value = [dbo].[IMPORT_DATASET_SITE]
		@DATASET_XML_NAME,@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL DATASETS IMPORTED' from [dbo].LOAD_DATASETS where SITE=@SITE_NAME;

EXEC	@return_value = [dbo].[IMPORT_DATASETFILES_SITE]
		@DATASETFILESLOC_XML_NAME,@SITE_NAME;
SELECT	COUNT(*) AS 'TOTAL ND PDF FILES IMPORTED' from [dbo].[LOAD_DATASETS_FILESPATH] where SITE=@SITE_NAME;

EXEC	@return_value = [dbo].[IMPORT_ETO_SITE]
		@ETO_XML_NAME,@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL ETOs IMPORTED' from [dbo].LOAD_ETO where SITE=@SITE_NAME;


EXEC	@return_value = [dbo].[IMPORT_PCN_SITE]
		@PCN_XML_NAME,@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL PCNS IMPORTED' from [dbo].LOAD_PCN where SITE=@SITE_NAME;

EXEC	@return_value = [dbo].[GENERATE_DOCUMENT_NUMBER_SITE]
		@SITE_NAME;
SELECT COUNT(*) AS 'TOTAL DOCUMENT NUMBERS GENERATED' from [dbo].LOAD_ALT_ALIAS_ID where SITE=@SITE_NAME;

EXEC	@return_value = [dbo].[TRANSFORMATION_SITE]
		@SITE_ID = @SITE_NAME;
SELECT COUNT(*) AS 'TOTAL Parts Having Zero Status' from [dbo].LOAD_PARTREVISION where SITE=@SITE_NAME and STATUS='0';
SELECT COUNT(*) AS 'TOTAL Documents Having Zero Status Before Trans' from [dbo].LOAD_DATASETS where SITE=@SITE_NAME and STATUS='0';

EXEC	@return_value = [dbo].[TRASNFROMATION_DATASET_SITE]
		@SITE_ID = @SITE_NAME;

SELECT COUNT(*) AS 'TOTAL TRANSFORMED Datasets to PROD' from [dbo].LOAD_DATASETS_TRANS where SITE=@SITE_NAME and STATUS='0';

EXEC	@return_value = [dbo].[INACTIVE_BAD_DATA]
		@SITE_ID = @SITE_NAME;
SELECT	'Return Value' = @return_value;


END
GO
/****** Object:  Default [DF_LOAD_PCN_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_PCN] ADD  CONSTRAINT [DF_LOAD_PCN_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_PARTREVISION_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_PARTREVISION] ADD  CONSTRAINT [DF_LOAD_PARTREVISION_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_PARTDRAWING_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_PARTDRAWING] ADD  CONSTRAINT [DF_LOAD_PARTDRAWING_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_LED_SUPPORTPRODUCT_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_LED_SUPPORTPRODUCT] ADD  CONSTRAINT [DF_LOAD_LED_SUPPORTPRODUCT_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_LED_SUPPORTPARTS_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_LED_SUPPORTPARTS] ADD  CONSTRAINT [DF_LOAD_LED_SUPPORTPARTS_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_LED_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_LED_IR] ADD  CONSTRAINT [DF_LOAD_LED_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_LED_IOM_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_LED_IOM] ADD  CONSTRAINT [DF_LOAD_LED_IOM_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_LED_CERTIFICATE_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_LED_CERTIFICATE] ADD  CONSTRAINT [DF_LOAD_LED_CERTIFICATE_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_LED_ALT_ALIAS_ID_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_LED_ALT_ALIAS_ID] ADD  CONSTRAINT [DF_LOAD_LED_ALT_ALIAS_ID_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_ETO_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_ETO] ADD  CONSTRAINT [DF_LOAD_ETO_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_DOCUMENTNUMBER_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_DOCUMENTNUMBER] ADD  CONSTRAINT [DF_LOAD_DOCUMENTNUMBER_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_DOCUMENT_SUBTYPE_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_DOCUMENT_SUBTYPE] ADD  CONSTRAINT [DF_LOAD_DOCUMENT_SUBTYPE_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_DOC_REFERENCES_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_DOCITEM_REFERENCES] ADD  CONSTRAINT [DF_LOAD_DOC_REFERENCES_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_DATASETS_TRANS_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_DATASETS_TRANS] ADD  CONSTRAINT [DF_LOAD_DATASETS_TRANS_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_DATASETS_FILESPATH_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_DATASETS_FILESPATH] ADD  CONSTRAINT [DF_LOAD_DATASETS_FILESPATH_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_DATASETS_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_DATASETS] ADD  CONSTRAINT [DF_LOAD_DATASETS_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
/****** Object:  Default [DF_LOAD_ALT_ALIAS_ID_DATE_IMPORTED]    Script Date: 06/24/2019 17:31:12 ******/
ALTER TABLE [dbo].[LOAD_ALT_ALIAS_ID] ADD  CONSTRAINT [DF_LOAD_ALT_ALIAS_ID_DATE_IMPORTED]  DEFAULT (getdate()) FOR [DATE_IMPORTED]
GO
