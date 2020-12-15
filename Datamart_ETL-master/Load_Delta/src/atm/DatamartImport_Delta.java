package atm;

import java.io.File;
import java.io.FileFilter;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DatamartImport_Delta {

	public static void main(String[] args) {

		String strPropFileArg = null;
		String strPropFileLocation = null;
		DmDBConnection conn = new DmDBConnection();
		Connection connection = null;
		DMLogger logger = new DMLogger();
		String strLogFileName = null;
		String DBName = null;
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
    	Date date = new Date();
  		
		if( args.length == 0 )
		{
			System.out.println("Configutation properties file is missing from commandline argument");
			System.out.println("Exiting...aplication");
			System.out.println("	USAGE: DMProd_import.jar -in_file=<properties file with absolute path.>");
			System.exit(0);
			
		}
		else
		{
			strPropFileArg = args[0];
			if(strPropFileArg.contentEquals("-h"))
			{
				System.out.println("USAGE: DMProd_import -in_file=<properties file with absolute path.>");
				System.exit(0);
			}
			else if(strPropFileArg.contains("-in_file="))
			{
				strPropFileLocation = strPropFileArg.substring(9,strPropFileArg.length());
				System.out.println("Properties file : "+ strPropFileLocation);
				
				 if(strPropFileLocation != null)
			        {
					 	conn.setPropertiesFile(strPropFileLocation);
					 	connection = conn.getDBConnection();
					 	/*strLogFileName = new File(".").getAbsolutePath() + "\\DMProdDB_DeltaLoad_"+ dateFormat.format(date)+".log";
					 	strLogFileName = strLogFileName.replace("\\.\\", "\\");*/
					 	
					 	strLogFileName =  conn.getFileProcessLocation()+"\\DMProdDB_DeltaLoad_"+ dateFormat.format(date)+".log";
					 	logger.setOutLogFile( strLogFileName);
						System.out.println("INFO: Logging file location : " + strLogFileName);
						
					 	logger.setOutLogFile( strLogFileName);
			        }
			        else
			        {
			        	System.out.println("Error in reading properties file....");
						System.exit(0);
			        }
				
			}
			else
			{
				System.out.println("USAGE: DMProd_import.jar -in_file=<properties file with absolute path.>");
				System.exit(0);
			}
			
		}
		
	     
		System.out.println(" Delta Import Started.............");
		
		//28-DEC-2017 - use existing hard coded Option table from DMProd.
		/*System.out.println("Generating Option table data");
		GenerateOptionTableData();*/
		connection = conn.getDBConnection();
        DBName=conn.getDBName();		
        Deltaload(connection,  DBName);

		System.out.println("Moving files to DM_Volume..");
		MoveDatasetsToVolume(conn.getFileProcessLocation());
		
		System.out.println("Normalizing DMProd database Completed.");
		System.out.println("Completed Normalizing DMProd.");
		
		System.out.println("Summary.........");
		ReportImportedData(connection,  DBName);
		
		
		
		System.out.println("BYE.");
		
	}
	
	public static void Deltaload(Connection connection, String DBName)
	{
		CallableStatement stmt = null; 
		CallableStatement stmt2 = null; 
				
		try { 
			 //stmt = connection.createStatement();
			  DMLogger.log("	Transforming Data from  [DeltaLoad] tables....");
	    	  stmt = connection.prepareCall("{call "+DBName+".dbo.DeltaLoad()}")	;      
	    	  stmt.execute();
	    	  stmt.getMoreResults();	    	 
	    	  DMLogger.log("    Transformation completed...");	    	 
	      }  
	
	      // Handle any errors that may have occurred.  
		 catch (SQLException e) {  	    	  
	         e.printStackTrace();  
	         DMLogger.log("	Got a SQLException1! "+e.getMessage());
	         
	      }
		 catch (Exception e) {  	    	  
	         e.printStackTrace();  
	         DMLogger.log("	Got an exception1! "+e.getMessage());
	      }
	      finally {  
	         if (stmt != null) 
	        	 try { stmt.close(); }         
	         
	         catch(Exception e) {
		         e.printStackTrace();  
		         DMLogger.log("	Got an exception1! "+e.getMessage());
	         } 
	      	}
		
		try { 
	    	  DMLogger.log("	Executing sp_build_datamart....");
	    	  stmt2 = connection.prepareCall("{call "+DBName+".dbo.sp_build_datamart()}");
	    	  DMLogger.log("	Completed sp_build_datamart execution...");
	    	  stmt2.execute();
	    	  stmt2.getMoreResults();	 
	      }  
	
	      // Handle any errors that may have occurred.  
		 catch (SQLException e) {  	    	  
	         e.printStackTrace();  
	         DMLogger.log("	Got a SQLException2! "+e.getMessage());
	      }
		 catch (Exception e) {  	    	  
	         e.printStackTrace();  
	         DMLogger.log("	Got an exception2! "+e.getMessage());
	      }
	      finally {  	         
	         if (stmt2 != null) 
	        	 try { stmt2.close(); } 
	         catch(Exception e) {
		         e.printStackTrace();  
		         DMLogger.log("	Got an exception2! "+e.getMessage());
	         } 
	      	}
		
	}
	
	
	public static void MoveDatasetsToVolume(String FileProcessLocation)
	{
		List<String> dirList = 	findFoldersInDirectory(FileProcessLocation);
		
		for (int i = 0; i < dirList.size(); i++)
		{
			File folder = new File(FileProcessLocation+"\\"+dirList.get(i)+"\\Volume1");
			if(folder.exists())
			{
				DMLogger.log("-----------------------------------------------------------------");
				DMLogger.log("Moving volume files to DM_Volume : " + dirList.get(i)+"\\Volume1");
				DMLogger.log("-----------------------------------------------------------------\n");
				
				File[] listOfFiles = folder.listFiles();
		
				for (File file : listOfFiles) 
				{
				    if (file.isFile()) {
				        //DMLogger.log("	 Moving file to DM_Volume -> " + file.getName());
				        System.out.print(".");
				        
				        File actFile = new File(file.getAbsolutePath());
						if(actFile.renameTo (new File("E:\\DataMart\\Volume1\\" + file.getName())))
						{
							actFile.delete();
						}
						else
						{
							actFile.delete();
						}
				    }
				}
				DMLogger.log("\n------------------------------------------------------------------");
				DMLogger.log("Completed.");
				DMLogger.log("------------------------------------------------------------------");
			}
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
	
	public static void ReportImportedData(Connection connection, String DBName)
	{
		Statement stmt = null;  
		ResultSet Results = null;	    
	    
	    String strQuery1 = "SELECT COUNT(*) from "+DBName+".dbo.items where status='0'";
	    String strQuery2 = "SELECT COUNT(*) from "+DBName+".dbo.items_doc_references where status='0'";
	    String strQuery3 = "SELECT COUNT(*) from "+DBName+".dbo.itemreport_dataset, "+DBName+".dbo.items where "+DBName+".dbo.itemreport_dataset.iid="+DBName+".dbo.items.iid and "+DBName+".dbo.items.status='0'";
	    String strQuery4 = "SELECT COUNT(*) from "+DBName+".dbo.pcn_report where status='0'";
	    String strQuery5 = "SELECT COUNT(*) from "+DBName+".dbo.eto_report where STATUS='0'";
	    
	    String strQuery6 = "UPDATE "+DBName+".dbo.lookup_data SET value = DATEADD(DD,-1,CAST(CAST(GETDATE() AS DATE) AS DATE))";
	    
	    try { 
			
	    	  stmt = connection.createStatement();  
	  
	    	  String [][] _qry_args = {
	        		 {"TOTAL ITEMS PASSED to PROD",strQuery1},
	        		 {"TOTAL ITEMS DOC_REFERENCES ",strQuery2},
	        		 {"TOTAL DATASETS PASSED to PROD",strQuery3},
	        		 {"TOTAL PCNs PASSED to PROD",strQuery4},
	        		 {"TOTAL ETOs PASSED to PROD",strQuery5}
    		       };
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.print("	"+_qry_args[i][0]+" : ");
	             Results = stmt.executeQuery(_qry_args[i][1]);

	                while (Results.next())
	                {
	                    System.out.println(Results.getString(1));
	                }
	         	}  
	         
	         PreparedStatement prestmt = connection.prepareStatement(strQuery6);
	         int i =prestmt.executeUpdate(); 
	         }
	
	      // Handle any errors that may have occurred.  
	      catch (Exception e) {  
	    	  System.err.println("Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	        // if (connection != null) try { connection.close(); } catch(Exception e) {}  
	      	}
	}

		
}
