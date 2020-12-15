package atm;


import java.io.File;
import java.io.FileFilter;
import java.sql.Connection;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class ProcessDeltaDB {

	public static void main(String[] args) {
		
		String strPropFileArg = null;
		String strPropFileLocation = null;
		DmDBConnection conn = new DmDBConnection();
		Connection connection = null;
		DMLogger logger = new DMLogger();
		String strLogFileName = null;
		File propfilePath = null;
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
    	Date date = new Date();
		
		if( args.length == 0 )
		{
			System.out.println("Configutation properties file is missing from commandline argument");
			System.out.println("Exiting...aplication");
			System.out.println("	USAGE: ProcessDeltaDB -in_file=<properties file with absolute path.>");
			System.exit(0);
			
		}
		else
		{
			strPropFileArg = args[0];
			if(strPropFileArg.contentEquals("-h"))
			{
				System.out.println("USAGE: DMDeltaDB_Import -in_file=<properties file with absolute path.>");
				System.exit(0);
			}
			else if(strPropFileArg.contains("-in_file="))
			{
				strPropFileLocation = strPropFileArg.substring(9,strPropFileArg.length());
				propfilePath = new File(strPropFileLocation);
				
		    	System.out.println("Properties File Location : " + propfilePath.getAbsolutePath());
		    	
				if(propfilePath.isFile())
				{
				 if(strPropFileLocation != null)
			        {
					 	conn.setPropertiesFile(propfilePath.getAbsolutePath());
				        connection = conn.getDBConnection();
				        
				        strLogFileName =  conn.getFileProcessLocation()+"/DMProcess_Delta_load_"+ dateFormat.format(date)+".log";
					 	logger.setOutLogFile( strLogFileName);
					 	
				        if(connection == null)
				        {
				        	System.out.println("ERROR: Couldn't get the DB Connection handle...Exiting");
							System.exit(0);
				        }
			        }
			        else
			        {
			        	System.out.println("Error in reading properties file....");
						System.exit(0);
			        }
				}
				else
				{
					System.out.println("	ERROR: dmconfig.properties file didn't find at jar file location...");
					System.exit(0);
					
				}
			}
			else
			{
				System.out.println("USAGE: DMDeltaDB_Import -in_file=<properties file with absolute path.>");
				System.exit(0);
			}
			
		}
		
	     
        System.out.println("ProcessDeltaDB Data Import Process started : ");

		DMLogger.log("Started....Unzipping.");
			unzipFilesdump(conn.getZipFileLocation()+"//Delta", conn.getFileProcessLocation()+"//Delta");
		DMLogger.log("UnZipping Completed.");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Cleaning DMDeltaDB Tables........");
			CleanDMDeltaDBTables();
		DMLogger.log("Cleaning DMDeltaDB Completed.....");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Bulk Load Started for Sites..................");
			ProcessBulkLoadFromFolder(conn.getFileProcessLocation()+"//Delta");
		DMLogger.log("Bulk Load Completed for All Sites................");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Cleaning Line feeds........");
			RemoveLineFeeds();
		DMLogger.log("Cleaning Line feeds Completed.....");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Normalizing Table DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER.........");
			NormalizeDocumentData();
		DMLogger.log("Normalizing Table DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER is Completed.");
				
		DMLogger.log("-----------------------------------");
		DMLogger.log("Normalizing Table DMDeltaDB.dbo.LOAD_DATASETS_TRANS.........");
			Load_dataset_set_trans(); //build LOAD_DATASETS_TRANS
		DMLogger.log("Normalizing Table DMDeltaDB.dbo.LOAD_DATASETS_TRANS is Completed.");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Normalizing Transformation DMDeltaDB Tables.........");
			TransformationDMDeltaDBTables(); //build LOAD_DATASETS_TRANS
		DMLogger.log("Normalizing Transformation DMDeltaDB Tables are Completed.");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Cleaning Line feeds........");
			RemoveLineFeeds();
		DMLogger.log("Cleaning Line feeds Completed.....");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Normalizing DMDeltaDB tables data to DMProcessDB.........");
			Transform_DMDeltaDB_to_DMProcessDB(); //build LOAD_DATASETS_TRANS
		DMLogger.log("Normalizing DMDeltaDB tables data to DMProcessDB Tables are Completed.");
		
		
				
	}
	private static void RemoveLineFeeds() {
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
	         
	    	  String [][] _qry_args = {
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_PCN SET PCN_NUMBER = replace(PCN_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_ALT_ALIAS_ID SET ITEM_ID = replace(ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_DATASETS SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_DATASETS_FILESPATH SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_DOCUMENT_SUBTYPE SET ITEM_ID = replace(ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_PARTDRAWING SET DRAWING_ID = replace(DRAWING_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_ETO_REV SET ETO_NUMBER = replace(ETO_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_DOCITEM_REFERENCES SET ITEM_ID = replace(ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_PARTREVISION SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_LED_IR SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_LED_ALT_ALIAS_ID SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_LED_CERTIFICATE SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_LED_IOM SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_LED_SUPPORTPARTS SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_LED_SUPPORTPRODUCT SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_MATERIALCODE SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER SET PART_NUMBER = replace(LTRIM(RTRIM(PART_NUMBER)), char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_DATASETS_TRANS SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER SET DRAWING_NUMBER = replace(DRAWING_NUMBER, char(10), '')"}
	    			 };
	
	    	  DMLogger.log("	Cleaning Line feed from  [DMDeltaDB] tables....");
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 DMLogger.log("	INFO: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	         }
	         DMLogger.log("	[DMDeltaDB] Cleaning Line feed completed...");
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	         //if (connection != null) try { connection.close(); } catch(Exception e) {}  
	      	}
		
	}
	public static void Transform_DMDeltaDB_to_DMProcessDB()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
	    //LOAD_ALT_ALIAS_ID
	    //select COUNT(*) from DMProcessDB.dbo.LOAD_ALT_ALIAS_ID where ITEM_ID in (select ITEM_ID from DMDeltaDB.dbo.LOAD_ALT_ALIAS_ID);
	    String qry1 = "delete from DMProcessDB.dbo.LOAD_ALT_ALIAS_ID where ITEM_ID in (select ITEM_ID from DMDeltaDB.dbo.LOAD_ALT_ALIAS_ID)";
	    String qry2 = "insert into DMProcessDB.dbo.LOAD_ALT_ALIAS_ID select * from  DMDeltaDB.dbo.LOAD_ALT_ALIAS_ID";  
	    
	    //LOAD_DATASETS  
	    //select COUNT(*) from DMProcessDB.dbo.LOAD_DATASETS where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_DATASETS);
	    String qry3 = "delete from DMProcessDB.dbo.LOAD_DATASETS where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_DATASETS)";
	    String qry4 = "insert into DMProcessDB.dbo.LOAD_DATASETS select * from  DMDeltaDB.dbo.LOAD_DATASETS";  
	    
	    //LOAD_DATASETS_FILESPATH
	    //select COUNT(*) from DMProcessDB.dbo.LOAD_DATASETS_FILESPATH where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_DATASETS_FILESPATH);
	    String qry5 = "delete from DMProcessDB.dbo.LOAD_DATASETS_FILESPATH where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_DATASETS_FILESPATH)";
	    String qry6 = "insert into DMProcessDB.dbo.LOAD_DATASETS_FILESPATH select * from  DMDeltaDB.dbo.LOAD_DATASETS_FILESPATH";


	  //LOAD_DATASETS_TRANS
	   //select COUNT(*) from DMProcessDB.dbo.LOAD_DATASETS_TRANS where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_DATASETS_TRANS);
	    String qry7 = "delete from DMProcessDB.dbo.LOAD_DATASETS_TRANS where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_DATASETS_TRANS)";
	    String qry8 = "insert into DMProcessDB.dbo.LOAD_DATASETS_TRANS select * from  DMDeltaDB.dbo.LOAD_DATASETS_TRANS";

	  //LOAD_DOCITEM_REFERENCES
	  // select COUNT(*) from DMProcessDB.dbo.LOAD_DOCITEM_REFERENCES where ITEM_ID in (select ITEM_ID from DMDeltaDB.dbo.LOAD_DOCITEM_REFERENCES)";
	  String qry9 = "delete from DMProcessDB.dbo.LOAD_DOCITEM_REFERENCES where ITEM_ID in (select ITEM_ID from DMDeltaDB.dbo.LOAD_DOCITEM_REFERENCES)";
	  String qry10 = "insert into DMProcessDB.dbo.LOAD_DOCITEM_REFERENCES select * from  DMDeltaDB.dbo.LOAD_DOCITEM_REFERENCES"; 

	  //LOAD_DOCUMENT_SUBTYPE
	   //select COUNT(*) from DMProcessDB.dbo.LOAD_DOCUMENT_SUBTYPE where ITEM_ID in (select ITEM_ID from DMDeltaDB.dbo.LOAD_DOCUMENT_SUBTYPE);
	  String qry11 = "delete from DMProcessDB.dbo.LOAD_DOCUMENT_SUBTYPE where ITEM_ID in (select ITEM_ID from DMDeltaDB.dbo.LOAD_DOCUMENT_SUBTYPE)";
	  String qry12 = "insert into DMProcessDB.dbo.LOAD_DOCUMENT_SUBTYPE select * from  DMDeltaDB.dbo.LOAD_DOCUMENT_SUBTYPE";  

	  //LOAD_DOCUMENTNUMBER
	  // select COUNT(*) from DMProcessDB.dbo.LOAD_DOCUMENTNUMBER where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER);
	  String qry13 = "delete from DMProcessDB.dbo.LOAD_DOCUMENTNUMBER where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER)";
	  String qry14 = "insert into DMProcessDB.dbo.LOAD_DOCUMENTNUMBER select * from  DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER";  

	  //LOAD_ETO
	  //select COUNT(*) from DMProcessDB.dbo.LOAD_ETO where ETO_NUMBER in (select ETO_NUMBER from DMDeltaDB.dbo.LOAD_ETO);
	  String qry15 = "delete from DMProcessDB.dbo.LOAD_ETO where ETO_NUMBER in (select ETO_NUMBER from DMDeltaDB.dbo.LOAD_ETO)";
	  String qry16 = "insert into DMProcessDB.dbo.LOAD_ETO select * from  DMDeltaDB.dbo.LOAD_ETO";  
	    
	   //LOAD_ETO_REV
	   //select COUNT(*) from DMProcessDB.dbo.LOAD_ETO_REV where ETO_NUMBER in (select ETO_NUMBER from DMDeltaDB.dbo.LOAD_ETO_REV);
	  String qry17 = "delete from DMProcessDB.dbo.LOAD_ETO_REV where ETO_NUMBER in (select ETO_NUMBER from DMDeltaDB.dbo.LOAD_ETO_REV)";
	  String qry18 = "insert into DMProcessDB.dbo.LOAD_ETO_REV select * from  DMDeltaDB.dbo.LOAD_ETO_REV";  
	    
	    //LOAD_LED_ALT_ALIAS_ID
	   //select COUNT(*) from DMProcessDB.dbo.LOAD_LED_ALT_ALIAS_ID where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_ALT_ALIAS_ID);
	  String qry19 = "delete from DMProcessDB.dbo.LOAD_LED_ALT_ALIAS_ID where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_ALT_ALIAS_ID)";
	  String qry20 = "insert into DMProcessDB.dbo.LOAD_LED_ALT_ALIAS_ID select * from  DMDeltaDB.dbo.LOAD_LED_ALT_ALIAS_ID"; 

	  //LOAD_LED_CERTIFICATE
	   //select COUNT(*) from DMProcessDB.dbo.LOAD_LED_CERTIFICATE where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_CERTIFICATE);
	  String qry21 = "delete from DMProcessDB.dbo.LOAD_LED_CERTIFICATE where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_CERTIFICATE)";
	  String qry22 = "insert into DMProcessDB.dbo.LOAD_LED_CERTIFICATE select * from  DMDeltaDB.dbo.LOAD_LED_CERTIFICATE";  
	    
	    
	  //LOAD_LED_IOM
	   //select COUNT(*) from DMProcessDB.dbo.LOAD_LED_IOM where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_IOM);
	  String qry23 = "delete from DMProcessDB.dbo.LOAD_LED_IOM where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_IOM)";
	  String qry24 = "insert into DMProcessDB.dbo.LOAD_LED_IOM select * from  DMDeltaDB.dbo.LOAD_LED_IOM";  

	  //LOAD_LED_IR
	  // select COUNT(*) from DMProcessDB.dbo.LOAD_LED_IR where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_IR);
	  String qry25 = "delete from DMProcessDB.dbo.LOAD_LED_IR where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_IR)";
	  String qry26 = "insert into DMProcessDB.dbo.LOAD_LED_IR select * from  DMDeltaDB.dbo.LOAD_LED_IR";  

	  //LOAD_LED_SUPPORTPARTS
	  // select COUNT(*) from DMProcessDB.dbo.LOAD_LED_SUPPORTPARTS where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_SUPPORTPARTS);
	  String qry27 = "delete from DMProcessDB.dbo.LOAD_LED_SUPPORTPARTS where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_SUPPORTPARTS)";
	  String qry28 = "insert into DMProcessDB.dbo.LOAD_LED_SUPPORTPARTS select * from  DMDeltaDB.dbo.LOAD_LED_SUPPORTPARTS";  

	  //LOAD_LED_SUPPORTPRODUCT
	  // select COUNT(*) from DMProcessDB.dbo.LOAD_LED_SUPPORTPRODUCT where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_SUPPORTPRODUCT);
	  String qry29 = "delete from DMProcessDB.dbo.LOAD_LED_SUPPORTPRODUCT where LED_ITEM_ID in (select LED_ITEM_ID from DMDeltaDB.dbo.LOAD_LED_SUPPORTPRODUCT)";
	  String qry30 = "insert into DMProcessDB.dbo.LOAD_LED_SUPPORTPRODUCT select * from  DMDeltaDB.dbo.LOAD_LED_SUPPORTPRODUCT";  


	  //LOAD_MATERIALCODE
	  // select COUNT(*) from DMProcessDB.dbo.LOAD_MATERIALCODE where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_MATERIALCODE);
	  String qry31 = "delete from DMProcessDB.dbo.LOAD_MATERIALCODE where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_MATERIALCODE)";
	  String qry32 = "insert into DMProcessDB.dbo.LOAD_MATERIALCODE select * from  DMDeltaDB.dbo.LOAD_MATERIALCODE";  
	    
	  //LOAD_PARTDRAWING
	   //select COUNT(*) from DMProcessDB.dbo.LOAD_PARTDRAWING where DRAWING_ID in (select DRAWING_ID from DMDeltaDB.dbo.LOAD_PARTDRAWING);
	  String qry33 = "delete from DMProcessDB.dbo.LOAD_PARTDRAWING where DRAWING_ID in (select DRAWING_ID from DMDeltaDB.dbo.LOAD_PARTDRAWING)";
	  String qry34 = "insert into DMProcessDB.dbo.LOAD_PARTDRAWING select * from  DMDeltaDB.dbo.LOAD_PARTDRAWING";  

	  //LOAD_PARTREVISION
	  // select COUNT(*) from DMProcessDB.dbo.LOAD_PARTREVISION where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_PARTREVISION);
	  String qry35 = "delete from DMProcessDB.dbo.LOAD_PARTREVISION where PART_NUMBER in (select PART_NUMBER from DMDeltaDB.dbo.LOAD_PARTREVISION)";
	  String qry36 = "insert into DMProcessDB.dbo.LOAD_PARTREVISION select * from  DMDeltaDB.dbo.LOAD_PARTREVISION"; 

	  //LOAD_PCN
	  // select COUNT(*) from DMProcessDB.dbo.LOAD_PCN where PCN_NUMBER in (select PCN_NUMBER from DMDeltaDB.dbo.LOAD_PCN);
	  String qry37 = "delete from DMProcessDB.dbo.LOAD_PCN where PCN_NUMBER in (select PCN_NUMBER from DMDeltaDB.dbo.LOAD_PCN)";
	  String qry38 = "insert into DMProcessDB.dbo.LOAD_PCN select * from  DMDeltaDB.dbo.LOAD_PCN";  

	  String[][] qryStatus = { 
			  	{qry1},{qry2},{qry3},{qry4},{qry5},{qry6},{qry7},{qry8},
			  	{qry9},{qry10},{qry11},{qry12},{qry13},{qry14},{qry15},{qry16},
			  	{qry17},{qry18},{qry19},{qry20},{qry21},{qry22},{qry23},{qry24},
			  	{qry25},{qry26},{qry27},{qry28},{qry29},{qry30},{qry31},{qry32},
			  	{qry33},{qry34},{qry35},{qry36},{qry37},{qry38}
				};
	  
	      try { 
	
	    	  stmt = connection.createStatement();  
	    	  
	    	  for (int i=0;i<qryStatus.length;i++) 
		         {
		        	 DMLogger.log("	INFO:" +qryStatus[i][0]);
		        	 stmt.executeUpdate(qryStatus[i][0]);
		        	 DMLogger.log("	Completed...");
		         }
	    	  
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("ERROR: Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	      	}
	}
	public static void TransformationDMDeltaDBTables()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
	    String qryETO_TableNormalization = "delete from [DMDeltaDB].[dbo].[LOAD_ETO_REV] "
	    		+ "where RELATION_NAME is null and [ETO_NUMBER] in (SELECT distinct [ETO_NUMBER] FROM [DMDeltaDB].[dbo].[LOAD_ETO_REV] where RELATION_NAME is not null)";

	    
	    String qryPartRevStatus = "UPDATE DMDeltaDB.dbo.LOAD_PARTREVISION "
	    		+ "SET STATUS = "
	    		+ "CASE "
	    		+ "WHEN LOAD_PARTREVISION.STATUS = '1' THEN LOAD_PARTREVISION.STATUS "
	    		+ "WHEN LOAD_PARTREVISION.RELEASE_STATUS NOT IN ( 'Production', 'Superseded' ) THEN '1' "
	    		+ "WHEN (LOAD_PARTREVISION.RELEASE_STATUS IS NULL) THEN '1' "
	    		+ "WHEN (LOAD_PARTREVISION.RELEASE_STATUS='') THEN '1' "
	    		+ "WHEN LOAD_PARTREVISION.RELEASE_STATUS IN ( 'Production', 'Superseded' ) THEN '0' "
	    		+ "ELSE '9' "
	    		+ "END, "
	    		+ "COMMENTS = "
	    		+ "CASE "
	    		+ "WHEN LOAD_PARTREVISION.STATUS = '1' THEN LOAD_PARTREVISION.COMMENTS"
	    		+ " WHEN LOAD_PARTREVISION.RELEASE_STATUS NOT IN ( 'Production', 'Superseded' ) THEN 'STATUS NOT IN SUPERSEED / PROD' "
	    		+ " WHEN (LOAD_PARTREVISION.RELEASE_STATUS IS NULL) THEN 'STATUS IS NULL' "
	    		+ " WHEN (LOAD_PARTREVISION.RELEASE_STATUS ='') THEN 'STATUS IS NULL' "
	    		+ " WHEN LOAD_PARTREVISION.RELEASE_STATUS IN ( 'Production', 'Superseded' ) THEN 'STATUS IN SUPERSEED / PROD' "
	    		+ " ELSE 'NOT PROCESSED' "
	    		+ "END;";
	    
	    String qryDataSetStatus = "UPDATE DMDeltaDB.dbo.LOAD_DATASETS "
	    		+ "SET  "
	    		+ "STATUS =  "
	    		+ "CASE  "
	    		+ " WHEN LOAD_DATASETS.STATUS = '1' THEN LOAD_DATASETS.STATUS "
	    		+ "WHEN LOAD_DATASETS.DATASET_REL_STATUS NOT IN ( 'Production', 'Superseded' ) THEN '1' "
	    		+ "WHEN LOAD_DATASETS.DATASET_REL_STATUS IS NULL THEN '1' "
	    		+ "WHEN LOAD_DATASETS.DATASET_REL_STATUS ='' THEN '1' "
	    		+ "WHEN LOAD_DATASETS.DATASET_REL_STATUS IN ( 'Production', 'Superseded' ) THEN '0' "
	    		+ "ELSE '9' "
	    		+ "END,  "
	    		+ "COMMENTS =  "
	    		+ "CASE  "
	    		+ " WHEN LOAD_DATASETS.STATUS = '1' THEN LOAD_DATASETS.COMMENTS "
	    		+ " WHEN LOAD_DATASETS.DATASET_REL_STATUS NOT IN ( 'Production', 'Superseded' ) THEN 'STATUS NOT IN SUPERSEED / PROD' "
	    		+ " WHEN LOAD_DATASETS.DATASET_REL_STATUS IS NULL THEN 'STATUS IS NULL' "
	    		+ " WHEN LOAD_DATASETS.DATASET_REL_STATUS ='' THEN 'STATUS IS NULL' "
	    		+ " WHEN LOAD_DATASETS.DATASET_REL_STATUS IN ( 'Production', 'Superseded' ) THEN 'STATUS IN SUPERSEED / PROD' "
	    		+ " ELSE 'NOT PROCESSED' "
	    		+ "END; ";
	    
	    String qryPartRevSetDuplicate = "WITH CTE(PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE,STATUS,COMMENTS,DuplicateCount) "
	    		+ "AS "
				+ "( "
				+ "SELECT PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE,STATUS,COMMENTS,ROW_NUMBER()  "
				+ "OVER(PARTITION BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE ORDER BY PART_NUMBER )  "
				+ "as DuplicateCount FROM DMDeltaDB.dbo.LOAD_PARTREVISION "
				+ ") "
				+ "UPDATE CTE SET STATUS='1',COMMENTS='DUPLICATE STATUS' WHERE DuplicateCount>1; ";
	    
	    String qryDatsetSetDuplicate = "WITH CTE(PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE,STATUS,COMMENTS,DuplicateCount) "
	    		+ "AS "
	    		+ "( "
	    		+ "SELECT PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE,STATUS,COMMENTS,ROW_NUMBER() " 
	    		+ "OVER(PARTITION BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE ORDER BY PART_NUMBER )  "
	    		+ "as DuplicateCount FROM DMDeltaDB.dbo.LOAD_DATASETS)"
	    		+ "UPDATE CTE SET STATUS='1',COMMENTS='DUPLICATE STATUS' WHERE DuplicateCount>1;";
	    		
	    String[][] qryUpdateStatus = { 
	    		{"UPDATE DMDeltaDB.dbo.LOAD_PARTREVISION SET COMMENTS='NOT PROCESSED', STATUS='9'"},
	    		{"UPDATE DMDeltaDB.dbo.LOAD_DATASETS SET COMMENTS='NOT PROCESSED',STATUS='9'"},
	    		{"UPDATE DMDeltaDB.dbo.LOAD_PARTREVISION SET STATUS = '1', COMMENTS='SYS DOC' WHERE PART_NUMBER LIKE 'SysDoc%'"},
	    		{"UPDATE DMDeltaDB.dbo.LOAD_DATASETS  SET STATUS = '1', COMMENTS='SYS DOC' WHERE PART_NUMBER LIKE 'SysDoc%'"},
    			{"UPDATE DMDeltaDB.dbo.LOAD_ETO SET STATUS = '0', COMMENTS='ALL STATUS IS ALLOWED'"},
	    		{"UPDATE DMDeltaDB.dbo.LOAD_PCN SET STATUS = '0', COMMENTS='ALL STATUS IS ALLOWED'"},
    			
	    		{"UPDATE DMDeltaDB.dbo.LOAD_PARTREVISION SET STATUS = '1', COMMENTS='PART TYPE' WHERE PART_TYPE NOT IN ('WGP4_ConeCrusherRevision',"
	    			+ "'WGP4_ConveyorsRevision','WGP4_ElastomerRevision','WGP4_FeederRevision','WGP4_HPGRRevision',"
					+ "'WGP4_HoseRevision','WGP4_MechSealRevision','WGP4_MechatronicRevision','WGP4_Mill_LinerRevision',"
					+ "'WGP4_PartResorceRevision','WGP4_PlantRevision','WGP4_SpoolRevision','WGP4_WasherRevision',"
					+ "'WGP7CycClustRevision','Warman Cyclone Revision','Warman Equipment Revision','Warman Part Tool Revision',"
					+ "'Warman Pump Revision','Warman Tool Aid Revision','Weir Minerals Revision','Weir Screen Revision',"
					+ "'Weir Valve Revision','ItemRevision','Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision','WGP4_Ball_FeederRevision',"
					+ "'WGP4_BargeRevision','WGP4_BladeMillRevision','WGP4_CentrifugeRevision','WGP4_LiftingERevision','WGP4_TransportCRevision')"},
    			
				{"UPDATE DMDeltaDB.dbo.LOAD_DATASETS  SET STATUS = '1', COMMENTS='PART TYPE' WHERE PART_TYPE NOT IN ('WGP4_ConeCrusherRevision',"
					+ "'WGP4_ConveyorsRevision','WGP4_ElastomerRevision','WGP4_FeederRevision','WGP4_HPGRRevision',"
					+ "'WGP4_HoseRevision','WGP4_MechSealRevision','WGP4_MechatronicRevision','WGP4_Mill_LinerRevision',"
					+ "'WGP4_PartResorceRevision','WGP4_PlantRevision','WGP4_SpoolRevision','WGP4_WasherRevision',"
					+ "'WGP7CycClustRevision','Warman Cyclone Revision','Warman Equipment Revision','Warman Part Tool Revision',"
					+ "'Warman Pump Revision','Warman Tool Aid Revision','Weir Minerals Revision','Weir Screen Revision',"
					+ "'Weir Valve Revision','ItemRevision','Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision','WGP4_Ball_FeederRevision',"
					+ "'WGP4_BargeRevision','WGP4_BladeMillRevision','WGP4_CentrifugeRevision','WGP4_LiftingERevision','WGP4_TransportCRevision')"},
				{"UPDATE DMDeltaDB.dbo.LOAD_PARTREVISION SET STATUS = '1', COMMENTS='EMPTY PART_NUMBER' WHERE PART_NUMBER =''"},
				{"UPDATE DMDeltaDB.dbo.LOAD_DATASETS  SET STATUS = '1', COMMENTS='EMPTY PART_NUMBER' WHERE PART_NUMBER =''"},

				{"UPDATE DMDeltaDB.dbo.LOAD_PARTREVISION SET STATUS ='1', COMMENTS='MULTIPLE STATUS' WHERE PUID IN "
						+ "(SELECT PUID FROM DMDeltaDB.dbo.LOAD_PARTREVISION WHERE STATUS ='0' "
						+ "GROUP BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,SITE "
						+ "HAVING COUNT(RELEASE_STATUS) = 2) AND RELEASE_STATUS='Production'"},  
						  
				{"UPDATE DMDeltaDB.dbo.LOAD_DATASETS SET STATUS ='1', COMMENTS='MULTIPLE STATUS' WHERE PUID IN"
						+ " (SELECT PUID FROM DMDeltaDB.dbo.LOAD_DATASETS WHERE STATUS ='0' "
						+ "GROUP BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,SITE  "
						+ "HAVING COUNT(DATASET_REL_STATUS) = 2 ) AND DATASET_REL_STATUS='Production'"},
				{qryPartRevStatus},
				{qryDataSetStatus},
				{qryPartRevSetDuplicate},
				{qryDatsetSetDuplicate},
				{qryETO_TableNormalization}
	
	    };
	    
    
	      try { 
	
	    	  stmt = connection.createStatement();  
	    	  
	    	  for (int i=0;i<qryUpdateStatus.length;i++) 
		         {
		        	 DMLogger.log("	INFO:" +qryUpdateStatus[i][0]);
		        	 stmt.executeUpdate(qryUpdateStatus[i][0]);
		        	 DMLogger.log("	Completed...");
		         }
	    	  
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("ERROR: Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	         //if (connection != null) try { connection.close(); } catch(Exception e) {}  
	      	}
		
	}
	public static void NormalizeDocumentData()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
	         
	    	  String [][] _qry_args = {
	        		 {"Deleteting records from DocumentNumber...","truncate table DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER"},
	        		 /*Alternate_ID*/{"Inserting ALTERNATE_ID records into table DocumentNumber...","insert into DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER select t1.part_number, t1.part_revision, t1.part_type, t2.alternate_id, t1.part_revision, 'ALTERNATE_ID', t1.site, GETDATE() from DMDeltaDB.dbo.LOAD_PARTREVISION t1, DMDeltaDB.dbo.LOAD_ALT_ALIAS_ID t2 where t1.PART_NUMBER = t2.item_id and t2.ALTERNATE_ID <> '' and t1.PART_TYPE not in ('Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision')"},
	        		 /*Alias_ID*/{"Inserting ALIAS_ID records into table DocumentNumber...","insert into DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER select t1.part_number, t1.part_revision, t1.part_type, t2.alternate_id, t1.part_revision, 'ALIAS_ID', t1.site, GETDATE() from DMDeltaDB.dbo.LOAD_PARTREVISION t1, DMDeltaDB.dbo.LOAD_ALT_ALIAS_ID t2 where t1.PART_NUMBER = t2.item_id and t2.ALIAS_ID <> '' and t1.PART_TYPE not in ('Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision')"},
	        		 /*1MATCODE_MATERIALS*/{"Inserting MATCODE_MATERIALS records into table DocumentNumber...","insert into DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER	SELECT t1.PART_NUMBER,t1.PART_REVISION,'WGP4_MatSpecRevision',t1.MAT_LOCAL_CODE,t1.PART_REVISION,'MATCODE_MATERIALS',t1.SITE, GETDATE() from DMDeltaDB.dbo.LOAD_MATERIALCODE t1 where t1.PART_NUMBER<>''"},
	        		 
	        		 /*DRAWING_ITEM_ID*/{"Inserting DRAWING_ITEM_ID records into table DocumentNumber...","insert into DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER (PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)	SELECT PD.DRAWING_ID,PD.DRAWING_REV,'Drawing Item Revision',PD.DRAWING_ID,PD.DRAWING_REV,'DRAWING_ITEM_ID',PD.SITE 	FROM DMDeltaDB.dbo.LOAD_PARTDRAWING PD WHERE PD.ITEM_ID = ''"},
	        		 /*DOC_ITEM_ID*/{"Inserting DOC_ITEM_ID records into table DocumentNumber...","insert into DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER (PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)	SELECT [PART_NUMBER],[PART_REVISION],[PART_TYPE],[PART_NUMBER],[PART_REVISION],'DOC_ITEM_ID',SITE FROM DMDeltaDB.dbo.LOAD_PARTREVISION WHERE [PART_TYPE]='DocumentRevision' AND [PART_NUMBER] NOT Like 'SysDoC%'"},
	        		 /*Drawing_ID*/{"Inserting DRAWING_ID records into table DocumentNumber...","insert into DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER (PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)  SELECT PD.ITEM_ID,PD.ITEM_REV,PR.PART_TYPE,PD.DRAWING_ID,PD.DRAWING_REV,'DRAWING_ITEM_VIEW',PD.SITE FROM DMDeltaDB.dbo.LOAD_PARTDRAWING PD LEFT JOIN DMDeltaDB.dbo.LOAD_PARTREVISION PR ON PD.ITEM_ID = PR.PART_NUMBER AND PD.SITE = PR.SITE WHERE PD.ITEM_ID <> ''"},

	         	};
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 DMLogger.log("	INFO:"+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 DMLogger.log("	Completed...");
	         }
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	         //if (connection != null) try { connection.close(); } catch(Exception e) {}  
	      	}
		
	}
	private static void Load_dataset_set_trans() {

		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
	    String sqrDOCNumber = "update DMDeltaDB.dbo.LOAD_DATASETS set IS_DOCNUMBER = 'Y' where puid in "
	    		+ "(select distinct DS.PUID from DMDeltaDB.dbo.LOAD_DATASETS DS, DMDeltaDB.dbo.LOAD_PARTDRAWING pd "
	    		+"where DS.PART_NUMBER = PD.DRAWING_ID and DS.PART_REVISION = PD.DRAWING_REV AND "
	    		+"PD.ITEM_ID <>'' AND PD.ITEM_REV <>'' AND PD.PUID = DS.PUID AND PD.SITE = DS.SITE)";
	    
	    String sqrPartDRW = "update DMDeltaDB.dbo.LOAD_DATASETS set  IS_PRT_UNDER_DRW = 'Y' where PART_NUMBER  in "
	    		+ "(select distinct ITEM_ID from DMDeltaDB.dbo.LOAD_PARTDRAWING PD, DMDeltaDB.dbo.LOAD_DATASETS DS "
	    		+ "where DS.PART_NUMBER = PD.ITEM_ID and DS.PART_REVISION = PD.ITEM_REV "
	    		+ "and PD.DRAWING_ID <>'' and PD.DRAWING_REV <>'' and PD.SITE = DS.SITE )";
	    
	    String strLoadDatasetPartCentric = "insert into DMDeltaDB.dbo.LOAD_DATASETS_TRANS SELECT PART_NUMBER, PART_REVISION, PART_TYPE, DATASET_NAME, DATASET_TYPE, DATASET_DESCRIPTION, "
	    	+"DATASET_CREATED_DATE,DATASET_REL_STATUS,DATASET_REL_DATE,STATUS, 'Part Centric',IS_DOCNUMBER,IS_PRT_UNDER_DRW, "
            +"SITE,PUID,OBJ_TAG,DATE_IMPORTED FROM DMDeltaDB.dbo.LOAD_DATASETS "
            +"WHERE (IS_DOCNUMBER = '0' AND IS_PRT_UNDER_DRW = '0') AND STATUS = '0' AND DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','Technical EngineeringPDF','Zip' ) "
	    	+"AND PART_TYPE <> 'DocumentRevision' ";
	    	
	    
	    String strLoadDatasetDrawingCentric = "INSERT DMDeltaDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT "
	    		+"DN.PART_NUMBER,DN.PART_REVISION,DN.PART_TYPE,DS.DATASET_NAME,DS.DATASET_TYPE, "
          +"DS.DATASET_DESCRIPTION,DS.DATASET_CREATED_DATE,DS.DATASET_REL_STATUS,DS.DATASET_REL_DATE, "
          +"DS.STATUS,'Drawing Centric',DS.IS_DOCNUMBER,DS.IS_PRT_UNDER_DRW,DS.SITE, "
          +"DS.PUID,DS.OBJ_TAG,DS.DATE_IMPORTED "
          +"FROM DMDeltaDB.dbo.LOAD_DATASETS DS , DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER DN "
          +"WHERE DS.PART_NUMBER = DN.DRAWING_NUMBER AND "
		  +"DS.PART_REVISION = DN.DRAWING_REVISION AND "
		  +"DS.SITE = DN.SITE AND DN.PART_TYPE <> 'Drawing Item Revision' AND "
		  +"(DS.IS_DOCNUMBER = 'Y' OR DS.IS_PRT_UNDER_DRW = 'Y') AND "
		  +"DS.STATUS = '0' AND DS.DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','Technical EngineeringPDF') AND " 
		  +"DS.PART_TYPE <> 'DocumentRevision'";
	    
	    
	    String strLoadDatasetRemain = "INSERT DMDeltaDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT DN.PART_NUMBER, DN.PART_REVISION, DN.PART_TYPE, DS.DATASET_NAME, " 
	    		+"DS.DATASET_TYPE, DS.DATASET_DESCRIPTION,DS.DATASET_CREATED_DATE,DS.DATASET_REL_STATUS, DS.DATASET_REL_DATE, "
        +"DS.STATUS,DS.COMMENTS,DS.IS_DOCNUMBER, DS.IS_PRT_UNDER_DRW,DS.SITE,DS.PUID, DS.OBJ_TAG,DS.DATE_IMPORTED "
        +"FROM DMDeltaDB.dbo.LOAD_DATASETS DS, DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER DN "
        +"WHERE DS.PART_NUMBER = DN.DRAWING_NUMBER AND DS.PART_REVISION = DN.DRAWING_REVISION AND "
        +"DS.SITE = DN.SITE AND DS.STATUS = '0' AND  DS.PART_TYPE = 'DocumentRevision'";
	    
	      try { 
	
	    	  stmt = connection.createStatement();  
	    	  
	    	  DMLogger.log("	INFO: Updating Document Number in LOAD_DATASETS table");
	    	  stmt.executeUpdate(sqrDOCNumber);
	    	  DMLogger.log("	Completed...");
	    	  DMLogger.log("	INFO: Updating Drawing number in LOAD_DATASETS table");
	    	  stmt.executeUpdate(sqrPartDRW);
	    	  DMLogger.log("	Completed...");
	    	  DMLogger.log("	INFO: Loading PartCentric data into Dataset_Trans table");
	    	  stmt.executeUpdate(strLoadDatasetPartCentric);
	    	  DMLogger.log("	Completed...");
	    	  DMLogger.log("	INFO: Loading DrawingCentric data into Dataset_Trans table");
	    	  stmt.executeUpdate(strLoadDatasetDrawingCentric);
	    	  DMLogger.log("	Completed...");
	    	  DMLogger.log("	INFO: Loading Remaing dataset into Dataset_Trans table");
	    	  stmt.executeUpdate(strLoadDatasetRemain);
	    	  DMLogger.log("	Completed...");
	    	  
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("ERROR: Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	         //if (connection != null) try { connection.close(); } catch(Exception e) {}  
	      	}
		
	}
	private static void CleanDMDeltaDBTables() {
		
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
	         
	    	  String [][] _qry_args = {
	    			  {"Deleteting records from LOAD_PCN...","truncate table DMDeltaDB.dbo.LOAD_PCN"},
	    			  {"Deleteting records from LOAD_PARTREVISION...","truncate table DMDeltaDB.dbo.LOAD_PARTREVISION"},
	    			  {"Deleteting records from LOAD_PARTDRAWING...","truncate table DMDeltaDB.dbo.LOAD_PARTDRAWING"},
	    			  {"Deleteting records from LOAD_MATERIALCODE...","truncate table DMDeltaDB.dbo.LOAD_MATERIALCODE"},
	    			  {"Deleteting records from LOAD_LED_SUPPORTPRODUCT...","truncate table DMDeltaDB.dbo.LOAD_LED_SUPPORTPRODUCT"},
	    			  {"Deleteting records from LOAD_LED_SUPPORTPARTS...","truncate table DMDeltaDB.dbo.LOAD_LED_SUPPORTPARTS"},
	    			  {"Deleteting records from LOAD_LED_IR...","truncate table DMDeltaDB.dbo.LOAD_LED_IR"},
	    			  {"Deleteting records from LOAD_LED_IOM...","truncate table DMDeltaDB.dbo.LOAD_LED_IOM"},
	    			  {"Deleteting records from LOAD_LED_CERTIFICATE...","truncate table DMDeltaDB.dbo.LOAD_LED_CERTIFICATE"},
	    			  {"Deleteting records from LOAD_LED_ALT_ALIAS_ID...","truncate table DMDeltaDB.dbo.LOAD_LED_ALT_ALIAS_ID"},
	    			  {"Deleteting records from LOAD_ETO...","truncate table DMDeltaDB.dbo.LOAD_ETO"},
	    			  {"Deleteting records from LOAD_DOCUMENTNUMBER...","truncate table DMDeltaDB.dbo.LOAD_DOCUMENTNUMBER"},
	    			  {"Deleteting records from LOAD_DOCUMENT_SUBTYPE...","truncate table DMDeltaDB.dbo.LOAD_DOCUMENT_SUBTYPE"},
	    			  {"Deleteting records from LOAD_DOCITEM_REFERENCES...","truncate table DMDeltaDB.dbo.LOAD_DOCITEM_REFERENCES"},
	    			  {"Deleteting records from LOAD_DATASETS_TRANS...","truncate table DMDeltaDB.dbo.LOAD_DATASETS_TRANS"},
	    			  {"Deleteting records from LOAD_DATASETS_FILESPATH...","truncate table DMDeltaDB.dbo.LOAD_DATASETS_FILESPATH"},
	    			  {"Deleteting records from LOAD_DATASETS...","truncate table DMDeltaDB.dbo.LOAD_DATASETS"},
	    			  {"Deleteting records from LOAD_ALT_ALIAS_ID...","truncate table DMDeltaDB.dbo.LOAD_ALT_ALIAS_ID"},
	    			  {"Deleteting records from LOAD_ETO_REV...","truncate table DMDeltaDB.dbo.LOAD_ETO_REV"}	   	
	         	};
	
	    	  DMLogger.log("	Cleaning data from  [DMDeltaDB] tables....");
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 DMLogger.log("	INFO: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	         }
	         DMLogger.log("	[DMDeltaDB] database cleaning completed...");
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	         //if (connection != null) try { connection.close(); } catch(Exception e) {}  
	      	}
	}
	public static void  unzipFilesdump(String strZipFileLocation, String strdstDirectory)
	{
    
 		File folder = new File(strZipFileLocation);
		File[] listOfFiles = folder.listFiles();
		for (File file : listOfFiles) 
		{
		    if (file.isFile()) 
		    {
		    	DMLogger.log(file.getAbsolutePath());
		    	UnZip unZip = new UnZip();
			    unZip.unZipIt( file.getAbsolutePath(),strdstDirectory);
		    }
		}
	}
	public static void ProcessBulkLoadFromFolder(String strProcessFileFolderName)
	{
		List<String> dirList = 	findFoldersInDirectory(strProcessFileFolderName);
		
		for (int i = 0; i < dirList.size(); i++)
		{
			DMLogger.log("-----------------------------------");
			DMLogger.log("Processing SITE : " + dirList.get(i));
			DMLogger.log("-----------------------------------");
			File folder = new File(strProcessFileFolderName+"\\"+dirList.get(i));
			File[] listOfFiles = folder.listFiles();
	
			for (File file : listOfFiles) 
			{
			    if (file.isFile()) {
			        DMLogger.log("	INFO:" + file.getAbsolutePath());
			        BulkloadIntoDeltaDB(file.getAbsolutePath());
			    }
			}
			DMLogger.log("-----------------------------------");
			DMLogger.log("Bulk load completed for SITE : " + dirList.get(i));
			DMLogger.log("-----------------------------------");
		}
	}
	public static List<String> findFoldersInDirectory(String directoryPath) 
	{
	    File directory = new File(directoryPath);
		
	    FileFilter directoryFileFilter = new FileFilter() 
	    {
	        public boolean accept(File file) {
	            return file.isDirectory();
	        }
	    };
			
	    File[] directoryListAsFile = directory.listFiles(directoryFileFilter);
	    List<String> foldersInDirectory = new ArrayList<String>(directoryListAsFile.length);
	    for (File directoryAsFile : directoryListAsFile) 
	    {
	        foldersInDirectory.add(directoryAsFile.getName());
	    }

	    return foldersInDirectory;
	}
	public static void BulkloadIntoDeltaDB(String strFileName)
	{
		String dbTableName = null;
		if (strFileName.contains("_IRLocal.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_PARTREVISION";}
		else if (strFileName.contains("_ALIAS_ALTERNATE.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_ALT_ALIAS_ID";}
		else if (strFileName.contains("_DatasetLocal.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_DATASETS";} 
		else if (strFileName.contains("_DatasetLocalFiles.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_DATASETS_FILESPATH";} 
		else if (strFileName.contains("_DOCUMENT_SUBTYPE.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_DOCUMENT_SUBTYPE";} 
		else if (strFileName.contains("_DRWLocal.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_PARTDRAWING";} 
		else if (strFileName.contains("_IRDocRefrenceLocal.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_DOCITEM_REFERENCES";} 
		else if (strFileName.contains("_LEDIRLocal.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_LED_IR";} 
		else if (strFileName.contains("_LED_ALTERNATE_ALIAS.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_LED_ALT_ALIAS_ID";} 
		else if (strFileName.contains("_LED_CERTIFICATE.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_LED_CERTIFICATE";} 
		else if (strFileName.contains("_LED_IOM.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_LED_IOM";} 
		else if (strFileName.contains("_LED_SUPPORT_PART.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_LED_SUPPORTPARTS";} 
		else if (strFileName.contains("_LED_SUPPORT_PRODUCT.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_LED_SUPPORTPRODUCT";} 
		else if (strFileName.contains("_MaterialLocal.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_MATERIALCODE";} 
		//else if (strFileName.contains("NDPDF_FILES_LOCATION.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_PARTREVISION";} 
		//else if (strFileName.contains("NDPDF_Physical_Files_Export.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_PARTREVISION";}
		else if (strFileName.contains("_PCN_IMPACTED_DATA.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_PCN";} 
		else if (strFileName.contains("_PCN_PROBLEM_DATA.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_PCN";} 
		else if (strFileName.contains("_PCN_SOLUTION_DATA.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_PCN";}
		else if (strFileName.contains("_PCN_NORELATED_DATA.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_PCN";}
		else if (strFileName.contains("_ETO_ALL_DATA.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_ETO_REV";} 
		else if (strFileName.contains("_ETO_ORDER_PARTS.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_ETO_REV";} 
		else if (strFileName.contains("_ETO_RELATION_DATA.txt") ){dbTableName = "DMDeltaDB.dbo.LOAD_ETO_REV";} 
		else
		{
			dbTableName = null;
		}

		if(dbTableName!= null)
		{
			insertBulkData(dbTableName,strFileName);
		}
        	
	}
	public static void insertBulkData(String dbTableName, String strFileName )
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
	    String strQuery = "BULK INSERT "+ dbTableName+" FROM  '" + strFileName + "' WITH (FIELDTERMINATOR = '|',ROWTERMINATOR = '~~')";
		
	      try { 
	
	    	  stmt = connection.createStatement();  
	    	  DMLogger.log("	INFO:"+strQuery);
	    	  stmt.executeUpdate(strQuery);
	    	  DMLogger.log("	Completed...");
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("ERROR: Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	         //if (connection != null) try { connection.close(); } catch(Exception e) {}  
	      	}
		
	}
	
}
