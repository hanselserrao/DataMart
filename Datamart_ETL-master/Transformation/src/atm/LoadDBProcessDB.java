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


public class LoadDBProcessDB {

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
			System.out.println("	USAGE: DMProcessDB_Import -in_file=<properties file with absolute path.>");
			System.exit(0);
			
		}
		else
		{
			strPropFileArg = args[0];
			if(strPropFileArg.contentEquals("-h"))
			{
				System.out.println("USAGE: DMProcessDB_Import -in_file=<properties file with absolute path.>");
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
				        
				        strLogFileName =  conn.getFileProcessLocation()+"\\DMProcess_FULL_load_"+ dateFormat.format(date)+".log";
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
				System.out.println("USAGE: DMProcessDB_Import -in_file=<properties file with absolute path.>");
				System.exit(0);
			}
			
		}
		
	     
        System.out.println("DMProcessDB Data Import Process started : ");

		DMLogger.log("Started....Unzipping.");
			//unzipFilesdump(conn.getZipFileLocation(), conn.getFileProcessLocation());
			unzipFilesdump(conn.getZipFileLocation(), conn.getFileProcessLocation());
		DMLogger.log("UnZipping Completed.");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Cleaning DMProcessDB Tables........");
			CleanDMProcessDBTables();
		DMLogger.log("Cleaning DMProcessDB Completed.....");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Bulk Load Started for Sites..................");
			ProcessBulkLoadFromFolder(conn.getFileProcessLocation());
		DMLogger.log("Bulk Load Completed for All Sites................");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Cleaning Line feeds........");
			RemoveLineFeeds();
		DMLogger.log("Cleaning Line feeds Completed.....");
				
		DMLogger.log("-----------------------------------");
		DMLogger.log("Normalizing Table DMProcessDB.dbo.LOAD_DOCUMENTNUMBER.........");
			NormalizeDocumentData();
		DMLogger.log("Normalizing Table DMProcessDB.dbo.LOAD_DOCUMENTNUMBER is Completed.");
				
		// Reversed the methods to execute 	TransformationDMProcessDBTables first
		DMLogger.log("-----------------------------------");
		DMLogger.log("Normalizing Transformation DMProcessDB Tables.........");
			TransformationDMProcessDBTables(); //build LOAD_DATASETS_TRANS
		DMLogger.log("Normalizing Transformation DMProcessDB Tables are Completed.");
		
		DMLogger.log("-----------------------------------");
		DMLogger.log("Normalizing Table DMProcessDB.dbo.LOAD_DATASETS_TRANS.........");
			Load_dataset_set_trans(); //build LOAD_DATASETS_TRANS
		DMLogger.log("Normalizing Table DMProcessDB.dbo.LOAD_DATASETS_TRANS is Completed.");
		
		//DMLogger.log("-----------------------------------");
		//DMLogger.log("Cleaning Line feeds........");
		//	RemoveLineFeeds();
		//DMLogger.log("Cleaning Line feeds Completed.....");
		
		System.out.println("DMProcessDB Data Import Process completed. ");
		System.out.println("Log file generated at : " + logger.getOutLogFile());
				
	}
	private static void RemoveLineFeeds() {
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
	         
	    	  String [][] _qry_args = {
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_PCN SET PCN_NUMBER = replace(PCN_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_PCN_REL SET PCN_NUMBER = replace(PCN_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_ALT_ALIAS_ID SET ITEM_ID = replace(ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DATASETS SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DATASETS_FILESPATH SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DOCUMENT_SUBTYPE SET ITEM_ID = replace(ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_PARTDRAWING SET DRAWING_ID = replace(DRAWING_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_ETO_REV SET ETO_NUMBER = replace(ETO_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DOCITEM_REFERENCES SET ITEM_ID = replace(ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_PARTREVISION SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_LED_IR SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			 // {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_LED_ALT_ALIAS_ID SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_LED_CERTIFICATE SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_LED_IOM SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_LED_SUPPORTPARTS SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_LED_SUPPORTPRODUCT SET LED_ITEM_ID = replace(LED_ITEM_ID, char(10), '')"},
	    			  //{"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_MATERIALCODE SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DOCUMENTNUMBER SET PART_NUMBER = replace(LTRIM(RTRIM(PART_NUMBER)), char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DATASETS_TRANS SET PART_NUMBER = replace(PART_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DOCUMENTNUMBER SET DRAWING_NUMBER = replace(DRAWING_NUMBER, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DOCUMENT_REV_NAME SET PUID = replace(PUID, char(10), '')"},
	    			  {"Cleaning line feed...","UPDATE DMProcessDB.dbo.LOAD_DOCUMENT_CATEGORY SET PUID = replace(PUID, char(10), '')"}
	    			 };
	
	    	  DMLogger.log("	Cleaning Line feed from  [DMProcessDB] tables....");
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 DMLogger.log("	INFO: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	         }
	         DMLogger.log("	[DMProcessDB] Cleaning Line feed completed...");
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
	public static void TransformationDMProcessDBTables()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
	    String qryETO_TableNormalization = "delete from [DMProcessDB].[dbo].[LOAD_ETO_REV] "
	    		+ "where RELATION_NAME is null and [ETO_NUMBER] in (SELECT distinct [ETO_NUMBER] FROM [DMProcessDB].[dbo].[LOAD_ETO_REV] where RELATION_NAME is not null)";


	    String qryPartRevStatus = "UPDATE DMProcessDB.dbo.LOAD_PARTREVISION "
	    		+ "SET STATUS = "
	    		+ "CASE "
	    		+ "WHEN LOAD_PARTREVISION.STATUS = '1' THEN LOAD_PARTREVISION.STATUS "
	    		+ "WHEN LOAD_PARTREVISION.RELEASE_STATUS NOT IN ( 'Production', 'Superseded', 'Obsolete' ) THEN '1' "
	    		+ "WHEN (LOAD_PARTREVISION.RELEASE_STATUS IS NULL) THEN '1' "
	    		+ "WHEN (LOAD_PARTREVISION.RELEASE_STATUS='') THEN '1' "
	    		+ "WHEN LOAD_PARTREVISION.RELEASE_STATUS IN ( 'Production', 'Superseded', 'Obsolete' ) THEN '0' "
	    		+ "ELSE '9' "
	    		+ "END, "
	    		+ "COMMENTS = "
	    		+ "CASE "
	    		+ "WHEN LOAD_PARTREVISION.STATUS = '1' THEN LOAD_PARTREVISION.COMMENTS"
	    		+ " WHEN LOAD_PARTREVISION.RELEASE_STATUS NOT IN ( 'Production', 'Superseded', 'Obsolete' ) THEN 'STATUS NOT IN SUPERSEED / PROD / OBS' "
	    		+ " WHEN (LOAD_PARTREVISION.RELEASE_STATUS IS NULL) THEN 'STATUS IS NULL' "
	    		+ " WHEN (LOAD_PARTREVISION.RELEASE_STATUS ='') THEN 'STATUS IS NULL' "
	    		+ " WHEN LOAD_PARTREVISION.RELEASE_STATUS IN ( 'Production', 'Superseded', 'Obsolete' ) THEN 'STATUS IN SUPERSEED / PROD / OBS' "
	    		+ " ELSE 'NOT PROCESSED' "
	    		+ "END;";
	    
	    String qryDataSetStatus = "UPDATE DMProcessDB.dbo.LOAD_DATASETS "
	    		+ "SET  "
	    		+ "STATUS =  "
	    		+ "CASE  "
	    		+ " WHEN LOAD_DATASETS.STATUS = '1' THEN LOAD_DATASETS.STATUS "
	    		+ "WHEN LOAD_DATASETS.DATASET_REL_STATUS NOT IN ( 'Production', 'Superseded', 'Obsolete' ) THEN '1' "
	    		+ "WHEN LOAD_DATASETS.DATASET_REL_STATUS IS NULL THEN '1' "
	    		+ "WHEN LOAD_DATASETS.DATASET_REL_STATUS ='' THEN '1' "
	    		+ "WHEN LOAD_DATASETS.DATASET_REL_STATUS IN ( 'Production', 'Superseded', 'Obsolete' ) THEN '0' "
	    		+ "ELSE '9' "
	    		+ "END,  "
	    		+ "COMMENTS =  "
	    		+ "CASE  "
	    		+ " WHEN LOAD_DATASETS.STATUS = '1' THEN LOAD_DATASETS.COMMENTS "
	    		+ " WHEN LOAD_DATASETS.DATASET_REL_STATUS NOT IN ( 'Production', 'Superseded', 'Obsolete' ) THEN 'STATUS NOT IN SUPERSEED / PROD / OBS' "
	    		+ " WHEN LOAD_DATASETS.DATASET_REL_STATUS IS NULL THEN 'STATUS IS NULL' "
	    		+ " WHEN LOAD_DATASETS.DATASET_REL_STATUS ='' THEN 'STATUS IS NULL' "
	    		+ " WHEN LOAD_DATASETS.DATASET_REL_STATUS IN ( 'Production', 'Superseded', 'Obsolete' ) THEN 'STATUS IN SUPERSEED / PROD / OBS' "
	    		+ " ELSE 'NOT PROCESSED' "
	    		+ "END; ";
	    
	    String qryPartRevSetDuplicate = "WITH CTE(PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE,STATUS,COMMENTS,DuplicateCount) "
	    		+ "AS "
				+ "( "
				+ "SELECT PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE,STATUS,COMMENTS,ROW_NUMBER()  "
				+ "OVER(PARTITION BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,RELEASE_STATUS,SITE ORDER BY PART_NUMBER )  "
				+ "as DuplicateCount FROM DMProcessDB.dbo.LOAD_PARTREVISION "
				+ ") "
				+ "UPDATE CTE SET STATUS='2',COMMENTS='DUPLICATE STATUS' WHERE DuplicateCount>1; ";
	    
	    String qryDatsetSetDuplicate = "WITH CTE(PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE,STATUS,COMMENTS,DuplicateCount) "
	    		+ "AS "
	    		+ "( "
	    		+ "SELECT PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE,STATUS,COMMENTS,ROW_NUMBER() " 
	    		+ "OVER(PARTITION BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,DATASET_REL_STATUS,SITE ORDER BY PART_NUMBER )  "
	    		+ "as DuplicateCount FROM DMProcessDB.dbo.LOAD_DATASETS)"
	    		+ "UPDATE CTE SET STATUS='2',COMMENTS='DUPLICATE STATUS' WHERE DuplicateCount>1;";
	    
		String strUp1 = "UPDATE DMProcessDB.dbo.LOAD_ALT_ALIAS_ID SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (ITEM_ID='' or LEN(ITEM_ID)<1) ";
		String strUp2 = "UPDATE DMProcessDB.dbo.LOAD_DATASETS SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) ";
		String strUp3 = "UPDATE DMProcessDB.dbo.LOAD_DATASETS_FILESPATH SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) ";
		String strUp4 = "UPDATE DMProcessDB.dbo.LOAD_DATASETS_TRANS SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1)  ";
		String strUp5 = "UPDATE DMProcessDB.dbo.LOAD_ETO SET STATUS='2' , COMMENTS='EMPTY ETO NUMBER' WHERE  (ETO_NUMBER='' or LEN(ETO_NUMBER)<1) ";
		//String strUp6 = "UPDATE dbo.LOAD_MATERIALCODE SET STATUS='1' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) ";
		String strUp7 = "UPDATE DMProcessDB.dbo.LOAD_PARTDRAWING SET STATUS='2' , COMMENTS='EMPTY DRAWING ITEM ID' WHERE  (DRAWING_ID='' or LEN(DRAWING_ID)<1) ";
		String strUp8 = "UPDATE DMProcessDB.dbo.LOAD_PARTREVISION SET STATUS='2' , COMMENTS='EMPTY PART NUMBER' WHERE  (PART_NUMBER='' or LEN(PART_NUMBER)<1) ";
		String strUp9 = "UPDATE DMProcessDB.dbo.LOAD_PARTREVISION SET STATUS='2' , COMMENTS='PART NUMBER LENGTH > 18' WHERE LEN(PART_NUMBER)>18 ";
		String strUp10 = "UPDATE DMProcessDB.dbo.LOAD_PCN SET STATUS='2' , COMMENTS='EMPTY PCN NUMBER' WHERE (PCN_NUMBER='' or LEN(PCN_NUMBER)<1) ";
		String strUp11 = "UPDATE DMProcessDB.dbo.LOAD_LED_IR SET STATUS= CASE WHEN LOAD_LED_IR.[RELEASE_STATUS] in ( 'Production', 'Superseded', 'Obsolete' ) THEN '0'"
				+ " WHEN LOAD_LED_IR.[RELEASE_STATUS] NOT in ( 'Production', 'Superseded', 'Obsolete' ) THEN '1' END; "; 		
	    String[][] qryUpdateStatus = { 
	    		{"UPDATE DMProcessDB.dbo.LOAD_PARTREVISION SET COMMENTS='NOT PROCESSED', STATUS='9'"},
	    		{"UPDATE DMProcessDB.dbo.LOAD_DATASETS SET COMMENTS='NOT PROCESSED',STATUS='9'"},
	    		{"UPDATE DMProcessDB.dbo.LOAD_PARTREVISION SET STATUS = '2', COMMENTS='SYS DOC' WHERE PART_NUMBER LIKE 'SysDoc%'"},
	    		{"UPDATE DMProcessDB.dbo.LOAD_DATASETS  SET STATUS = '2', COMMENTS='SYS DOC' WHERE PART_NUMBER LIKE 'SysDoc%'"},
    			{"UPDATE DMProcessDB.dbo.LOAD_ETO SET STATUS = '0', COMMENTS='ALL STATUS IS ALLOWED'"},
	    		{"UPDATE DMProcessDB.dbo.LOAD_PCN SET STATUS = '0', COMMENTS='ALL STATUS IS ALLOWED'"},
    			
	    		{"UPDATE DMProcessDB.dbo.LOAD_PARTREVISION SET STATUS = '1', COMMENTS='PART TYPE' WHERE PART_TYPE NOT IN ('WGP4_ConeCrusherRevision',"
	    			+ "'WGP4_ConveyorsRevision','WGP4_ElastomerRevision','WGP4_FeederRevision','WGP4_HPGRRevision',"
					+ "'WGP4_HoseRevision','WGP4_MechSealRevision','WGP4_MechatronicRevision','WGP4_Mill_LinerRevision',"
					+ "'WGP4_PartResorceRevision','WGP4_PlantRevision','WGP4_SpoolRevision','WGP4_WasherRevision',"
					+ "'WGP7CycClustRevision','Warman Cyclone Revision','Warman Equipment Revision','Warman Part Tool Revision',"
					+ "'Warman Pump Revision','Warman Tool Aid Revision','Weir Minerals Revision','Weir Screen Revision',"
					+ "'Weir Valve Revision','ItemRevision','Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision','WGP4_Ball_FeederRevision',"
					+ "'WGP4_BargeRevision','WGP4_BladeMillRevision','WGP4_CentrifugeRevision','WGP4_LiftingERevision','WGP4_TransportCRevision','WGP4_SkidRevision','WGP4_WeirMagnetRevision','WGP4_WeirProductRevision')"},
    			
				{"UPDATE DMProcessDB.dbo.LOAD_DATASETS  SET STATUS = '1', COMMENTS='PART TYPE' WHERE PART_TYPE NOT IN ('WGP4_ConeCrusherRevision',"
					+ "'WGP4_ConveyorsRevision','WGP4_ElastomerRevision','WGP4_FeederRevision','WGP4_HPGRRevision',"
					+ "'WGP4_HoseRevision','WGP4_MechSealRevision','WGP4_MechatronicRevision','WGP4_Mill_LinerRevision',"
					+ "'WGP4_PartResorceRevision','WGP4_PlantRevision','WGP4_SpoolRevision','WGP4_WasherRevision',"
					+ "'WGP7CycClustRevision','Warman Cyclone Revision','Warman Equipment Revision','Warman Part Tool Revision',"
					+ "'Warman Pump Revision','Warman Tool Aid Revision','Weir Minerals Revision','Weir Screen Revision',"
					+ "'Weir Valve Revision','ItemRevision','Drawing Item Revision','DocumentRevision','WGP4_MatSpecRevision','WGP4_Ball_FeederRevision',"
					+ "'WGP4_BargeRevision','WGP4_BladeMillRevision','WGP4_CentrifugeRevision','WGP4_LiftingERevision','WGP4_TransportCRevision','WGP4_SkidRevision','WGP4_WeirMagnetRevision','WGP4_WeirProductRevision')"},
				
				{qryPartRevStatus},
				{qryDataSetStatus},	
				{qryPartRevSetDuplicate},
				{qryDatsetSetDuplicate},
				
				{"UPDATE DMProcessDB.dbo.LOAD_PARTREVISION SET STATUS ='2', COMMENTS='MULTIPLE STATUS' WHERE PUID IN "
						+ "(SELECT PUID FROM DMProcessDB.dbo.LOAD_PARTREVISION WHERE STATUS ='0' "
						+ "GROUP BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATE_CREATED,SITE "
						+ "HAVING COUNT(RELEASE_STATUS) = 2) AND RELEASE_STATUS='Production'"},  
						  
				{"UPDATE DMProcessDB.dbo.LOAD_DATASETS SET STATUS ='2', COMMENTS='MULTIPLE STATUS' WHERE PUID IN"
						+ " (SELECT PUID FROM DMProcessDB.dbo.LOAD_DATASETS WHERE STATUS ='0' "
						+ "GROUP BY PUID,PART_NUMBER,PART_REVISION,PART_TYPE,DATASET_NAME,DATASET_TYPE,DATASET_CREATED_DATE,SITE  "
						+ "HAVING COUNT(DATASET_REL_STATUS) = 2 ) AND DATASET_REL_STATUS='Production'"},
				
			
				{qryETO_TableNormalization},
				{strUp1},
				{strUp2},
				{strUp3},
				{strUp4},
				{strUp5},
				//{strUp6},
				{strUp7},
				{strUp8},
				{strUp9},
				{strUp10},					
				{strUp11}
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
	        		
	        		 //Alternate_ID
	    			 {"Inserting ALTERNATE_ID records into table DocumentNumber...","insert into DMProcessDB.dbo.LOAD_DOCUMENTNUMBER select t1.part_number, t1.part_revision, t1.part_type, t2.alternate_id, t1.part_revision, 'ALTERNATE_ID', t1.site, GETDATE() from DMProcessDB.dbo.LOAD_PARTREVISION t1, DMProcessDB.dbo.LOAD_ALT_ALIAS_ID t2 where t1.PART_NUMBER = t2.item_id and t2.ALTERNATE_ID <> '' and t1.PART_TYPE not in ('Drawing Item Revision','DocumentRevision')"},
	        		 
	    			 //*Alias_ID
	    			 {"Inserting ALIAS_ID records into table DocumentNumber...","insert into DMProcessDB.dbo.LOAD_DOCUMENTNUMBER select t1.part_number, t1.part_revision, t1.part_type, t2.alias_id, t1.part_revision, 'ALIAS_ID', t1.site, GETDATE() from DMProcessDB.dbo.LOAD_PARTREVISION t1, DMProcessDB.dbo.LOAD_ALT_ALIAS_ID t2 where t1.PART_NUMBER = t2.item_id and t2.ALIAS_ID <> '' and t1.PART_TYPE not in ('Drawing Item Revision','DocumentRevision')"},
	        		 
	    			 //Multi Drawing Items
	    			 //{"Updating Status for Multiple Drawing Items into table LOAD_PARTDRAWING...","UPDATE DMProcessDB.dbo.LOAD_PARTDRAWING SET STATUS='1' WHERE ITEM_ID IN (SELECT DISTINCT ITEM_ID from(SELECT row_number() OVER(PARTITION BY PD.ITEM_ID ORDER BY PD.ITEM_ID) AS rn,PD.ITEM_ID,PD.DRAWING_ID FROM DMProcessDB.dbo.LOAD_PARTDRAWING PD LEFT JOIN DMProcessDB.dbo.LOAD_PARTREVISION PR ON PD.ITEM_ID = PR.PART_NUMBER AND PD.SITE = PR.SITE GROUP BY PD.ITEM_ID,PD.DRAWING_ID HAVING COUNT(*) >1) AS t WHERE t.rn>1)"},
	    			 {"Updating Status for Multiple Drawing Items into table LOAD_PARTDRAWING...","UPDATE DMProcessDB.dbo.LOAD_PARTDRAWING SET STATUS='1' WHERE ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM DMProcessDB.dbo.LOAD_PARTDRAWING WHERE ITEM_ID IN ( SELECT ITEM_ID FROM DMProcessDB.dbo.LOAD_PARTDRAWING GROUP BY ITEM_ID HAVING COUNT(*) >1) GROUP BY  ITEM_ID,DRAWING_ID)"},
	        		 //Drawing_ID
	    			 {"Inserting DRAWING_ID records into table DocumentNumber...","insert into DMProcessDB.dbo.LOAD_DOCUMENTNUMBER (PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)  SELECT PD.ITEM_ID,PD.ITEM_REV,PR.PART_TYPE,PD.DRAWING_ID,PD.DRAWING_REV,'DRAWING_ITEM_VIEW',PD.SITE FROM DMProcessDB.dbo.LOAD_PARTDRAWING PD LEFT JOIN DMProcessDB.dbo.LOAD_PARTREVISION PR ON PD.ITEM_ID = PR.PART_NUMBER AND PD.SITE = PR.SITE WHERE PD.ITEM_ID <> '' AND PD.STATUS=0 "},
	        		 	    			 
	        		 //DRAWING_ITEM_ID
	    			 {"Inserting DRAWING_ITEM_ID records into table DocumentNumber...","insert into DMProcessDB.dbo.LOAD_DOCUMENTNUMBER (PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)	SELECT Distinct PR.[PART_NUMBER],PR.[PART_REVISION],PR.[PART_TYPE],PR.[PART_NUMBER],PR.[PART_REVISION],'DRAWING_ITEM_ID',PR.SITE FROM [DMProcessDB].[dbo].[LOAD_PARTREVISION] PR WHERE PR.[PART_NUMBER] NOT IN (select DISTINCT PD.DRAWING_ID from [DMProcessDB].[dbo].LOAD_PARTDRAWING PD where PD.DRAWING_ID is NOT NULL UNION select DISTINCT ALT.ALTERNATE_ID from [DMProcessDB].[dbo].LOAD_ALT_ALIAS_ID ALT WHERE ALT.ALTERNATE_ID is NOT NULL UNION select ALIAS.ALIAS_ID from [DMProcessDB].[dbo].LOAD_ALT_ALIAS_ID ALIAS where ALIAS.ALIAS_ID  is not NULL) AND  PR.[PART_TYPE]='Drawing Item Revision'"},
	        		 
	    			 //DOC_ITEM_ID
	    			 {"Inserting DOC_ITEM_ID records into table DocumentNumber...","insert into DMProcessDB.dbo.LOAD_DOCUMENTNUMBER (PART_NUMBER,PART_REVISION,PART_TYPE,DRAWING_NUMBER,DRAWING_REVISION,DRAWING_TYPE,SITE)	SELECT [PART_NUMBER],[PART_REVISION],[PART_TYPE],[PART_NUMBER],[PART_REVISION],'DOC_ITEM_ID',SITE FROM DMProcessDB.dbo.LOAD_PARTREVISION WHERE [PART_TYPE]='DocumentRevision' AND [PART_NUMBER] NOT Like 'SysDoC%'"},
	        			        		 
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
	/*private static void Load_dataset_set_trans() {

		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    String isDocZero = "UPDATE DMProcessDB.dbo.LOAD_DATASETS SET IS_DOCNUMBER = '0' FROM DMProcessDB.dbo.LOAD_DATASETS";
	    String isPartZero = "UPDATE DMProcessDB.dbo.LOAD_DATASETS SET IS_PRT_UNDER_DRW = '0' FROM DMProcessDB.dbo.LOAD_DATASETS";
	   // Removed PD.PUID = DS.PUID condition as one shows Part Rev PUID and other shows Dataset PUID
	    String sqrDOCNumber = "update DMProcessDB.dbo.LOAD_DATASETS set IS_DOCNUMBER = 'Y' where puid in "
	    		+ "(select distinct DS.PUID from DMProcessDB.dbo.LOAD_DATASETS DS, DMProcessDB.dbo.LOAD_PARTDRAWING pd "
	    		+"where DS.PART_NUMBER = PD.DRAWING_ID and DS.PART_REVISION = PD.DRAWING_REV AND "
	    		+"PD.ITEM_ID <>'' AND PD.ITEM_REV <>''  AND PD.SITE = DS.SITE)";
	    
	    String sqrPartDRW = "update DMProcessDB.dbo.LOAD_DATASETS set  IS_PRT_UNDER_DRW = 'Y' where PART_NUMBER  in "
	    		+ "(select distinct ITEM_ID from DMProcessDB.dbo.LOAD_PARTDRAWING PD, DMProcessDB.dbo.LOAD_DATASETS DS "
	    		+ "where DS.PART_NUMBER = PD.ITEM_ID and DS.PART_REVISION = PD.ITEM_REV "
	    		+ "and PD.DRAWING_ID <>'' and PD.DRAWING_REV <>'' and PD.SITE = DS.SITE )";
	    
	    String Part_centric = "UPDATE DMProcessDB.dbo.LOAD_DATASETS set  IS_DOCNUMBER = '0' , IS_PRT_UNDER_DRW = '0' WHERE PART_NUMBER in "
	    		+ "( SELECT PART_NUMBER FROM DMProcessDB.dbo.LOAD_ALT_ALIAS_ID WHERE  LEN(ALIAS_ID) >0 OR  LEN(ALTERNATE_ID) >0)";
	    
	    String strLoadDatasetPartCentric = "insert into DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT PART_NUMBER, PART_REVISION, PART_TYPE, DATASET_NAME, DATASET_TYPE, DATASET_DESCRIPTION, "
	    	+"DATASET_CREATED_DATE,DATASET_REL_STATUS,DATASET_REL_DATE,STATUS, 'Part Centric',IS_DOCNUMBER,IS_PRT_UNDER_DRW, "
            +"SITE,PUID,OBJ_TAG,DATE_IMPORTED FROM DMProcessDB.dbo.LOAD_DATASETS "
            +"WHERE (IS_DOCNUMBER = '0' AND IS_PRT_UNDER_DRW = '0') AND STATUS = '0' AND DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) "
	    	+"AND PART_TYPE <> 'DocumentRevision' ";
	    	
	    
	    String strLoadDatasetDrawingCentric = "INSERT DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT "
	    		+"DN.PART_NUMBER,DN.PART_REVISION,DN.PART_TYPE,DS.DATASET_NAME,DS.DATASET_TYPE, "
          +"DS.DATASET_DESCRIPTION,DS.DATASET_CREATED_DATE,DS.DATASET_REL_STATUS,DS.DATASET_REL_DATE, "
          +"DS.STATUS,'Drawing Centric',DS.IS_DOCNUMBER,DS.IS_PRT_UNDER_DRW,DS.SITE, "
          +"DS.PUID,DS.OBJ_TAG,DS.DATE_IMPORTED "
          +"FROM DMProcessDB.dbo.LOAD_DATASETS DS , DMProcessDB.dbo.LOAD_DOCUMENTNUMBER DN "
          +"WHERE DS.PART_NUMBER = DN.DRAWING_NUMBER AND "
		  +"DS.PART_REVISION = DN.DRAWING_REVISION AND "
		  +"DS.SITE = DN.SITE AND DN.PART_TYPE <> 'Drawing Item Revision' AND "
		  +"(DS.IS_DOCNUMBER = 'Y' OR DS.IS_PRT_UNDER_DRW = 'Y') AND "
		  +"DS.STATUS = '0' AND DS.DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) AND " 
		  +"DS.PART_TYPE <> 'DocumentRevision'";
	    
	    
	    String strLoadDatasetRemain = "INSERT DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT DN.PART_NUMBER, DN.PART_REVISION, DN.PART_TYPE, DS.DATASET_NAME, " 
	    		+"DS.DATASET_TYPE, DS.DATASET_DESCRIPTION,DS.DATASET_CREATED_DATE,DS.DATASET_REL_STATUS, DS.DATASET_REL_DATE, "
        +"DS.STATUS,DS.COMMENTS,DS.IS_DOCNUMBER, DS.IS_PRT_UNDER_DRW,DS.SITE,DS.PUID, DS.OBJ_TAG,DS.DATE_IMPORTED "
        +"FROM DMProcessDB.dbo.LOAD_DATASETS DS, DMProcessDB.dbo.LOAD_DOCUMENTNUMBER DN "
        +"WHERE DS.PART_NUMBER = DN.DRAWING_NUMBER AND DS.PART_REVISION = DN.DRAWING_REVISION AND "
        +"DS.SITE = DN.SITE AND DS.STATUS = '0' AND  DS.PART_TYPE = 'DocumentRevision'";
	    
	      try { 
	
	    	  stmt = connection.createStatement();  
	    	  DMLogger.log("	INFO: Updating IS_DOCNUMBER to Zero in LOAD_DATASETS table");
	    	  stmt.executeUpdate(isDocZero);
	    	  DMLogger.log("	INFO: Updating IS_PRT_UNDER_DRW to Zero in LOAD_DATASETS table");
	    	  stmt.executeUpdate(isPartZero);
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
		
	}*/
	private static void Load_dataset_set_trans() {

		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    String isDocZero = "UPDATE DMProcessDB.dbo.LOAD_DATASETS SET IS_DOCNUMBER = '0',IS_PRT_UNDER_DRW = '0'";
	    //String isPartZero = "UPDATE DMProcessDB.dbo.LOAD_DATASETS SET  FROM DMProcessDB.dbo.LOAD_DATASETS";
	   // Removed PD.PUID = DS.PUID condition as one shows Part Rev PUID and other shows Dataset PUID
	    String sqrDOCNumber = "update DMProcessDB.dbo.LOAD_DATASETS set IS_DOCNUMBER = 'Y' where puid in "
	    		+ "(select distinct DS.PUID from DMProcessDB.dbo.LOAD_DATASETS DS, DMProcessDB.dbo.LOAD_PARTDRAWING pd "
	    		+"where DS.PART_NUMBER = PD.DRAWING_ID and DS.PART_REVISION = PD.DRAWING_REV AND "
	    		+"PD.ITEM_ID <>'' AND PD.ITEM_REV <>''  AND PD.SITE = DS.SITE)";
	    
	    String sqrPartDRW = "update DMProcessDB.dbo.LOAD_DATASETS set  IS_PRT_UNDER_DRW = 'Y' where PART_NUMBER  in "
	    		+ "(select distinct ITEM_ID from DMProcessDB.dbo.LOAD_PARTDRAWING PD, DMProcessDB.dbo.LOAD_DATASETS DS "
	    		+ "where DS.PART_NUMBER = PD.ITEM_ID and DS.PART_REVISION = PD.ITEM_REV "
	    		+ "and PD.DRAWING_ID <>'' and PD.DRAWING_REV <>'' and PD.SITE = DS.SITE )";
	    
	    String Part_centric = "UPDATE DMProcessDB.dbo.LOAD_DATASETS set  IS_DOCNUMBER = '0' , IS_PRT_UNDER_DRW = '0' WHERE PART_NUMBER in "
	    		+ "( SELECT ITEM_ID FROM DMProcessDB.dbo.LOAD_ALT_ALIAS_ID WHERE  LEN(ALIAS_ID) >0 OR  LEN(ALTERNATE_ID) >0)";
	    
	    String strLoadDatasetPartCentric = "insert into DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT PART_NUMBER, PART_REVISION, PART_TYPE, DATASET_NAME, DATASET_TYPE, DATASET_DESCRIPTION, "
	    	+"DATASET_CREATED_DATE,DATASET_REL_STATUS,DATASET_REL_DATE,STATUS, 'Part Centric',IS_DOCNUMBER,IS_PRT_UNDER_DRW, "
            +"SITE,PUID,OBJ_TAG,DATE_IMPORTED FROM DMProcessDB.dbo.LOAD_DATASETS "
            +"WHERE (IS_DOCNUMBER = '0' AND IS_PRT_UNDER_DRW = '0') AND STATUS = '0' AND DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) "
	    	+"AND PART_TYPE <> 'DocumentRevision' ";
	    	
	    
	    String strLoadDatasetDrawingCentric = "INSERT DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT "
	    		+"DN.PART_NUMBER,DN.PART_REVISION,DN.PART_TYPE,DS.DATASET_NAME,DS.DATASET_TYPE, "
          +"DS.DATASET_DESCRIPTION,DS.DATASET_CREATED_DATE,DS.DATASET_REL_STATUS,DS.DATASET_REL_DATE, "
          +"DS.STATUS,'Drawing Centric',DS.IS_DOCNUMBER,DS.IS_PRT_UNDER_DRW,DS.SITE, "
          +"DS.PUID,DS.OBJ_TAG,DS.DATE_IMPORTED "
          +"FROM DMProcessDB.dbo.LOAD_DATASETS DS , DMProcessDB.dbo.LOAD_DOCUMENTNUMBER DN "
          +"WHERE DS.PART_NUMBER = DN.DRAWING_NUMBER AND "
		  +"DS.PART_REVISION = DN.DRAWING_REVISION AND "
		  +"DS.SITE = DN.SITE AND DN.PART_TYPE <> 'Drawing Item Revision' AND "
		  +"(DS.IS_DOCNUMBER = 'Y' OR DS.IS_PRT_UNDER_DRW = 'Y') AND "
		  +"DS.STATUS = '0' AND DS.DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) AND " 
		  +"DS.PART_TYPE <> 'DocumentRevision'";
	    
	    
	    String strLoadDatasetRemain = "INSERT DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT DN.PART_NUMBER, DN.PART_REVISION, DN.PART_TYPE, DS.DATASET_NAME, " 
	    		+"DS.DATASET_TYPE, DS.DATASET_DESCRIPTION,DS.DATASET_CREATED_DATE,DS.DATASET_REL_STATUS, DS.DATASET_REL_DATE, "
        +"DS.STATUS,DS.COMMENTS,DS.IS_DOCNUMBER, DS.IS_PRT_UNDER_DRW,DS.SITE,DS.PUID, DS.OBJ_TAG,DS.DATE_IMPORTED "
        +"FROM DMProcessDB.dbo.LOAD_DATASETS DS, DMProcessDB.dbo.LOAD_DOCUMENTNUMBER DN "
        +"WHERE DS.PART_NUMBER = DN.DRAWING_NUMBER AND DS.PART_REVISION = DN.DRAWING_REVISION AND "
        +"DS.SITE = DN.SITE AND DS.STATUS = '0' AND  DS.PART_TYPE = 'DocumentRevision'";
	    
	      try { 
	
	    	  stmt = connection.createStatement();  
	    	  DMLogger.log("	INFO: Updating IS_DOCNUMBER,IS_PRT_UNDER_DRW to Zero in LOAD_DATASETS table");
	    	  stmt.executeUpdate(isDocZero);
	    	  //DMLogger.log("	INFO: Updating IS_PRT_UNDER_DRW to Zero in LOAD_DATASETS table");
	    	  //stmt.executeUpdate(isPartZero);
	    	  DMLogger.log("	INFO: Updating Document Number in LOAD_DATASETS table");
	    	  stmt.executeUpdate(sqrDOCNumber);
	    	  DMLogger.log("	Completed...");
	    	  DMLogger.log("	INFO: Updating Drawing number in LOAD_DATASETS table");
	    	  stmt.executeUpdate(sqrPartDRW);
	    	  DMLogger.log("	Completed...");
	    	  DMLogger.log("	INFO: Updating Part_centric in LOAD_DATASETS table");
	    	  stmt.executeUpdate(Part_centric);
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
	
	
	private static void CleanDMProcessDBTables() {
		
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
	         
	    	  String [][] _qry_args = {
	    			  {"Deleteting records from LOAD_PCN...","truncate table DMProcessDB.dbo.LOAD_PCN"},
	    			  {"Deleteting records from LOAD_PCN_REL...","truncate table DMProcessDB.dbo.LOAD_PCN_REL"},
	    			  {"Deleteting records from LOAD_PARTREVISION...","truncate table DMProcessDB.dbo.LOAD_PARTREVISION"},
	    			  {"Deleteting records from LOAD_PARTDRAWING...","truncate table DMProcessDB.dbo.LOAD_PARTDRAWING"},
	    			 // {"Deleteting records from LOAD_MATERIALCODE...","truncate table DMProcessDB.dbo.LOAD_MATERIALCODE"},
	    			  {"Deleteting records from LOAD_LED_SUPPORTPRODUCT...","truncate table DMProcessDB.dbo.LOAD_LED_SUPPORTPRODUCT"},
	    			  {"Deleteting records from LOAD_LED_SUPPORTPARTS...","truncate table DMProcessDB.dbo.LOAD_LED_SUPPORTPARTS"},
	    			  {"Deleteting records from LOAD_LED_IR...","truncate table DMProcessDB.dbo.LOAD_LED_IR"},
	    			  {"Deleteting records from LOAD_LED_IOM...","truncate table DMProcessDB.dbo.LOAD_LED_IOM"},
	    			  {"Deleteting records from LOAD_LED_CERTIFICATE...","truncate table DMProcessDB.dbo.LOAD_LED_CERTIFICATE"},
	    			  //{"Deleteting records from LOAD_LED_ALT_ALIAS_ID...","truncate table DMProcessDB.dbo.LOAD_LED_ALT_ALIAS_ID"},
	    			  {"Deleteting records from LOAD_ETO...","truncate table DMProcessDB.dbo.LOAD_ETO"},
	    			  {"Deleteting records from LOAD_ETO_REV...","truncate table DMProcessDB.dbo.LOAD_ETO_REV"},
	    			  {"Deleteting records from LOAD_DOCUMENTNUMBER...","truncate table DMProcessDB.dbo.LOAD_DOCUMENTNUMBER"},
	    			  {"Deleteting records from LOAD_DOCUMENT_SUBTYPE...","truncate table DMProcessDB.dbo.LOAD_DOCUMENT_SUBTYPE"},
	    			  {"Deleteting records from LOAD_DOCUMENT_CATEGORY...","truncate table DMProcessDB.dbo.LOAD_DOCUMENT_CATEGORY"},
	    			  {"Deleteting records from LOAD_DOCITEM_REFERENCES...","truncate table DMProcessDB.dbo.LOAD_DOCITEM_REFERENCES"},
	    			  {"Deleteting records from LOAD_DOCUMENT_REV_NAME...","truncate table DMProcessDB.dbo.LOAD_DOCUMENT_REV_NAME"},
	    			  {"Deleteting records from LOAD_DATASETS_TRANS...","truncate table DMProcessDB.dbo.LOAD_DATASETS_TRANS"},
	    			  {"Deleteting records from LOAD_DATASETS_FILESPATH...","truncate table DMProcessDB.dbo.LOAD_DATASETS_FILESPATH"},
	    			  {"Deleteting records from LOAD_DATASETS...","truncate table DMProcessDB.dbo.LOAD_DATASETS"},
	    			  {"Deleteting records from LOAD_ALT_ALIAS_ID...","truncate table DMProcessDB.dbo.LOAD_ALT_ALIAS_ID"}	    			     	
	         	};
	
	    	  DMLogger.log("	Cleaning data from  [DMProcessDB] tables....");
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 DMLogger.log("	INFO: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	         }
	         DMLogger.log("	[DMProcessDB] database cleaning completed...");
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
    
		System.out.println("	zipFileLocation : " + strZipFileLocation);
 		File folder = new File(strZipFileLocation);
 		if(folder.exists())
 		{
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
 		else
 		{
 			System.out.println("	Error: Folder doesn't exists....");
 			System.exit(0);
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
			        BulkloadIntoDB(file.getAbsolutePath());
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
	public static void BulkloadIntoDB(String strFileName)
	{
		String dbTableName = null;
		if (strFileName.contains("_IRLocal.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PARTREVISION";}
		else if (strFileName.contains("_ALIAS_ALTERNATE.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_ALT_ALIAS_ID";}
		else if (strFileName.contains("_DatasetLocal.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_DATASETS";} 
		else if (strFileName.contains("_DatasetLocalFiles.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_DATASETS_FILESPATH";} 
		else if (strFileName.contains("_DocumentCategory.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_DOCUMENT_CATEGORY";}
		else if (strFileName.contains("_DocumentName.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_DOCUMENT_REV_NAME";} 
		else if (strFileName.contains("_DOCUMENT_SUBTYPE.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_DOCUMENT_SUBTYPE";} 
		else if (strFileName.contains("_DRWLocal.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PARTDRAWING";} 
		else if (strFileName.contains("_IRDocRefrenceLocal.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_DOCITEM_REFERENCES";} 
		else if (strFileName.contains("_LEDIRLocal.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_LED_IR";} 
		//else if (strFileName.contains("_LED_ALTERNATE_ALIAS.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_LED_ALT_ALIAS_ID";} 
		else if (strFileName.contains("_LED_CERTIFICATE.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_LED_CERTIFICATE";} 
		else if (strFileName.contains("_LED_IOM.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_LED_IOM";} 
		else if (strFileName.contains("_LED_SUPPORT_PART.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_LED_SUPPORTPARTS";} 
		else if (strFileName.contains("_LED_SUPPORT_PRODUCT.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_LED_SUPPORTPRODUCT";} 
		//else if (strFileName.contains("_MaterialLocal.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_MATERIALCODE";} 
		//else if (strFileName.contains("NDPDF_FILES_LOCATION.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PARTREVISION";} 
		//else if (strFileName.contains("NDPDF_Physical_Files_Export.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PARTREVISION";}
		//else if (strFileName.contains("_PCN_IMPACTED_DATA.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PCN";} 
		//else if (strFileName.contains("_PCN_PROBLEM_DATA.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PCN";} 
		//else if (strFileName.contains("_PCN_SOLUTION_DATA.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PCN";}
		else if (strFileName.contains("_PCN_NORELATED_DATA.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PCN";}
		else if (strFileName.contains("_PCN_RELATION_DATA.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_PCN_REL";}
		else if (strFileName.contains("_ETO_ALL_DATA.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_ETO_REV";} 
		else if (strFileName.contains("_ETO_ORDER_PARTS.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_ETO_REV";} 
		else if (strFileName.contains("_ETO_RELATION_DATA.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_ETO_REV";} 
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
	    
	    String strQuery = "BULK INSERT "+ dbTableName+" FROM  '" + strFileName + "' WITH (CODEPAGE = 'ACP', FIELDTERMINATOR = '|',ROWTERMINATOR = '~~')";
		
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
