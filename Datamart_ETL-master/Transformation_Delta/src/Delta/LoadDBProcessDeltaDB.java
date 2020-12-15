package Delta;

import java.io.File;
import java.io.FileFilter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class LoadDBProcessDeltaDB {

	public static void main(String[] args) {
		
		String strPropFileArg = null;
		String strPropFileLocation = null;
		DmDBConnection conn = new DmDBConnection();
		Connection connection = null;
		DMLogger logger = new DMLogger();
		String strLogFileName = null;
		File propfilePath = null;
		String DBName = null;
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
    	Date date = new Date();
    	
 		if( args.length == 0 )
		{
			System.out.println("Configutation properties file is missing from commandline argument");
			System.out.println("Exiting...aplication");
			System.out.println("	USAGE: DMProcessDB_Import_Delta -in_file=<properties file with absolute path.>");
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
		
	     
        try {
        	connection = conn.getDBConnection();
	        DBName=conn.getDBName();
	        strLogFileName =  conn.getFileProcessLocation()+"/DMProcess_FULL_load_"+ dateFormat.format(date)+".log";
		 	logger.setOutLogFile( strLogFileName);
		 	
	        if(connection == null)
	        {
	        	System.out.println("ERROR: Couldn't get the DB Connection handle...Exiting");
				System.exit(0);
	        }
        	
			System.out.println("DMProcessDB Data Delta Import Process started : ");

			DMLogger.log("Started....Unzipping.");
				//unzipFilesdump(conn.getZipFileLocation(), conn.getFileProcessLocation());
				unzipFilesdump(conn.getZipFileLocation(), conn.getFileProcessLocation());
			DMLogger.log("UnZipping Completed.");
			
			DMLogger.log("-----------------------------------");
			DMLogger.log("Cleaning DMProcessDB Tables........");
				CleanDMProcessDBTables(connection , DBName);
			DMLogger.log("Cleaning DMProcessDB Completed.....");
			
			DMLogger.log("-----------------------------------");
			DMLogger.log("Bulk Load Started for Sites..................");
				ProcessBulkLoadFromFolder(conn.getFileProcessLocation(), DBName);
			DMLogger.log("Bulk Load Completed for All Sites................");
				
			DMLogger.log("-----------------------------------");
			DMLogger.log("Cleaning Line feeds........");
				RemoveLineFeeds(connection , DBName);
			DMLogger.log("Cleaning Line feeds Completed.....");
			
			DMLogger.log("-----------------------------------");
			DMLogger.log("Normalizing Transformation DMProcessDB Tables.........");
				TransformationDMProcessDBTables(connection , DBName); //build LOAD_DATASETS_TRANS
			DMLogger.log("Normalizing Transformation DMProcessDB Tables are Completed.");
			
			DMLogger.log("-----------------------------------");
			DMLogger.log("Normalizing Table DMProcessDB.dbo.LOAD_DOCUMENTNUMBER.........");
				NormalizeDocumentData(connection , DBName);
			DMLogger.log("Normalizing Table DMProcessDB.dbo.LOAD_DOCUMENTNUMBER is Completed.");
					
			DMLogger.log("-----------------------------------");
			DMLogger.log("Normalizing Table DMProcessDB.dbo.LOAD_DATASETS_TRANS.........");
				Load_dataset_set_trans(connection , DBName); //build LOAD_DATASETS_TRANS
			DMLogger.log("Normalizing Table DMProcessDB.dbo.LOAD_DATASETS_TRANS is Completed.");	
			
			
			DMLogger.log("-----------------------------------");
			DMLogger.log("Cleaning Line feeds........");
				RemoveLineFeeds(connection , DBName);
			DMLogger.log("Cleaning Line feeds Completed.....");
			
			System.out.println(DBName+" Data Import Process completed. ");
			System.out.println("Log file generated at : " + logger.getOutLogFile());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				connection.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
				
	}
	private static void RemoveLineFeeds(Connection connection, String DBName) {
		
		CallableStatement stmt = null; 
		
		try { 
				 
	    	  stmt = connection.prepareCall("{call "+DBName+".dbo.REMOVE_LINE_FEEDS()}")	;      
	    	  stmt.execute();	    	  
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
	public static void TransformationDMProcessDBTables(Connection connection, String DBName)
	{
		CallableStatement stmt = null; 
				
		try { 
			
	    	  //stmt = connection.createStatement();
			  DMLogger.log("	Transforming Data from  [DMProcessDB] tables....");
	    	  stmt = connection.prepareCall("{call "+DBName+".dbo.TRANSFORMATION()}")	;      
	    	  stmt.execute();
	    	  DMLogger.log("	[DMProcessDB] Transformation completed...");
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) 
	        	 try { stmt.close(); } 
	         catch(Exception e) {}  
	         
	      	}	
		
	}
	public static void NormalizeDocumentData(Connection connection, String DBName)
	{
		CallableStatement stmt = null; 
		
		try { 
			
	    	  //stmt = connection.createStatement();
			  DMLogger.log("	Normalizing Document Number Data from  "+DBName+" tables....");
	    	  stmt = connection.prepareCall("{call "+DBName+".dbo.NORMALIZE_DOCUMENT_DATA()}")	;      
	    	  stmt.execute();
	    	  DMLogger.log("	Normalizing Document Number Data from  "+DBName+" tables....completed ");
	      }  
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) 
	        	 try { stmt.close(); } 
	         catch(Exception e) {}  
	         
	      	}
		
	}
	private static void Load_dataset_set_trans(Connection connection, String DBName) {
		CallableStatement stmt = null; 
				
				try { 
					
			    	  //stmt = connection.createStatement();
					  DMLogger.log("	Normalizing Dataset from  "+DBName+" tables....");
			    	  stmt = connection.prepareCall("{call "+DBName+".dbo.[TRASNFROMATION_DATASET]()}")	;      
			    	  stmt.execute();
			    	  DMLogger.log("	Normalizing Dataset from  "+DBName+" tables....completed ");
			      }  
			
			      // Handle any errors that may have occurred.  
			      catch (Exception e) {  
			    	  System.err.println("Got an exception! ");
			         e.printStackTrace();  
			      }
			      finally {  
			         if (stmt != null) 
			        	 try { stmt.close(); } 
			         catch(Exception e) {}  
			         
			      	}

	}
	private static void CleanDMProcessDBTables(Connection connection, String DBName) {
		
		CallableStatement stmt = null;  
	    //DmDBConnection conn = new DmDBConnection();
	    //Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  //stmt = connection.createStatement();
	    	  stmt = connection.prepareCall("{call "+DBName+".dbo.TRUNCATE_DB()}")	;      
	    	  stmt.execute();
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
	public static void ProcessBulkLoadFromFolder(String strProcessFileFolderName, String DBName)
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
			        BulkloadIntoDB(file.getAbsolutePath(),DBName);
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
	public static void BulkloadIntoDB(String strFileName,  String DBName)
	{
		String dbTableName = null;
		if (strFileName.contains("_IRLocal.txt") ){dbTableName = DBName+".dbo.LOAD_PARTREVISION";}
		else if (strFileName.contains("_ALIAS_ALTERNATE.txt") ){dbTableName = DBName+".dbo.LOAD_ALT_ALIAS_ID";}
		else if (strFileName.contains("_DatasetLocal.txt") ){dbTableName = DBName+".dbo.LOAD_DATASETS";} 
		else if (strFileName.contains("_DatasetLocalFiles.txt") ){dbTableName = DBName+".dbo.LOAD_DATASETS_FILESPATH";} 
		else if (strFileName.contains("_DocumentCategory.txt") ){dbTableName = DBName+".dbo.LOAD_DOCUMENT_CATEGORY";} 
		else if (strFileName.contains("_DocumentName.txt") ){dbTableName = "DMProcessDB.dbo.LOAD_DOCUMENT_REV_NAME";} 
		else if (strFileName.contains("_DOCUMENT_SUBTYPE.txt") ){dbTableName = DBName+".dbo.LOAD_DOCUMENT_SUBTYPE";} 
		else if (strFileName.contains("_DRWLocal.txt") ){dbTableName = DBName+".dbo.LOAD_PARTDRAWING";} 
		else if (strFileName.contains("_IRDocRefrenceLocal.txt") ){dbTableName = DBName+".dbo.LOAD_DOCITEM_REFERENCES";} 
		else if (strFileName.contains("_LEDIRLocal.txt") ){dbTableName = DBName+".dbo.LOAD_LED_IR";} 
		//else if (strFileName.contains("_LED_ALTERNATE_ALIAS.txt") ){dbTableName = DBName+".dbo.LOAD_LED_ALT_ALIAS_ID";} 
		else if (strFileName.contains("_LED_CERTIFICATE.txt") ){dbTableName = DBName+".dbo.LOAD_LED_CERTIFICATE";} 
		else if (strFileName.contains("_LED_IOM.txt") ){dbTableName = DBName+".dbo.LOAD_LED_IOM";} 
		else if (strFileName.contains("_LED_SUPPORT_PART.txt") ){dbTableName = DBName+".dbo.LOAD_LED_SUPPORTPARTS";} 
		else if (strFileName.contains("_LED_SUPPORT_PRODUCT.txt") ){dbTableName = DBName+".dbo.LOAD_LED_SUPPORTPRODUCT";} 
		else if (strFileName.contains("_MaterialLocal.txt") ){dbTableName = DBName+".dbo.LOAD_MATERIALCODE";} 
		//else if (strFileName.contains("NDPDF_FILES_LOCATION.txt") ){dbTableName = DBName+".dbo.LOAD_PARTREVISION";} 
		//else if (strFileName.contains("NDPDF_Physical_Files_Export.txt") ){dbTableName = DBName+".dbo.LOAD_PARTREVISION";}
		//else if (strFileName.contains("_PCN_IMPACTED_DATA.txt") ){dbTableName = DBName+".dbo.LOAD_PCN";} 
		//else if (strFileName.contains("_PCN_PROBLEM_DATA.txt") ){dbTableName = DBName+".dbo.LOAD_PCN";} 
		//else if (strFileName.contains("_PCN_SOLUTION_DATA.txt") ){dbTableName = DBName+".dbo.LOAD_PCN";}
		else if (strFileName.contains("_PCN_NORELATED_DATA.txt") ){dbTableName = DBName+".dbo.LOAD_PCN";}
		else if (strFileName.contains("_PCN_RELATION_DATA.txt") ){dbTableName = DBName+".dbo.LOAD_PCN_REL";}
		else if (strFileName.contains("_ETO_ALL_DATA.txt") ){dbTableName = DBName+".dbo.LOAD_ETO_REV";} 
		else if (strFileName.contains("_ETO_ORDER_PARTS.txt") ){dbTableName = DBName+".dbo.LOAD_ETO_REV";} 
		else if (strFileName.contains("_ETO_RELATION_DATA.txt") ){dbTableName = DBName+".dbo.LOAD_ETO_REV";}
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
	    	  //DMLogger.log("	INFO: Loading "+strFileName+" to "+dbTableName+" completed");
	    	  stmt.executeUpdate(strQuery);
	    	  //DMLogger.log("	INFO: Loading "+strFileName+" to "+dbTableName+" completed");
	    	  //DMLogger.log("	Completed...");
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
