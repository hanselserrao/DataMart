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

public class DatamartImport {

	public static void main(String[] args) {

		String strPropFileArg = null;
		String strPropFileLocation = null;
		DmDBConnection conn = new DmDBConnection();
		Connection connection = null;
		DMLogger logger = new DMLogger();
		String strLogFileName = null;
		
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
					 	/*strLogFileName = new File(".").getAbsolutePath() + "\\DMProdDB_FullLoad_"+ dateFormat.format(date)+".log";
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
		
	     
		System.out.println("Normalizing DMProd database Started.............");
		
		//28-DEC-2017 - use existing hard coded Option table from DMProd.
		/*System.out.println("Generating Option table data");
		GenerateOptionTableData();*/
		System.out.println("Normalize Options data");
		GenerateOptionTableData();
		System.out.println("Normalize ITEM data");
		Normalize_ITEM_into_DMProd();
		
		System.out.println("Normalize Document Category data");
		Normalize_DocumentCategory_into_DMProd();
		
		System.out.println("Normalize ITEM Document Reference data");
		Normalize_Item_DocumentRef_into_DMProd();
		
		System.out.println("Normalize ITEM Dataset Report data");
		Normalize_ItemsReport_Dataset();
		
		System.out.println("Normalize PCN Items");
		Normalize_PCN_ALL();
		
		System.out.println("Normalize LED Items");
		Normalize_LED_Items();

		System.out.println("Normalize ETO Relations Data");
		Normalize_ETO_Relations();
		System.out.println("Rebuilding Datamart DB");
		Build_Datamart();
		System.out.println("Moving files to DM_Volume..");
		MoveDatasetsToVolume(conn.getFileProcessLocation());
		
		System.out.println("Normalizing DMProd database Completed.");
		System.out.println("Completed Normalizing DMProd.");
		
		System.out.println("Summary & Update.........");
		ReportImportedData();
		
		//System.out.println("Summary.........");
		//Update_lookup_data();
		
		
		
		System.out.println("BYE.");
		
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
	public static void ReportImportedData()
	{
		Statement stmt = null;  
		ResultSet Results = null;
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
	    
	    String strQuery1 = "SELECT COUNT(*) from DMProd.dbo.items where status='0'";
	    String strQuery2 = "SELECT COUNT(*) from DMProd.dbo.items_doc_references where status='0'";
	    String strQuery3 = "SELECT COUNT(*) from DMProd.dbo.itemreport_dataset, DMProd.dbo.items where DMProd.dbo.itemreport_dataset.iid=DMProd.dbo.items.iid and DMProd.dbo.items.status='0'";
	    String strQuery4 = "SELECT COUNT(*) from DMProd.dbo.pcn_report";
	    String strQuery5 = "SELECT COUNT(*) from DMProd.dbo.eto_report";
	    
	    
	    String strQuery6 = "UPDATE DMProd.dbo.lookup_data SET value = CAST(GETDATE() AS DATE)";
	    
	    
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
	public static void Normalize_ETO_Relations()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
		String strQuery1 = "truncate table DMProd.dbo.eto_report";
		String strQuery2 = "truncate table DMProd.dbo.eto_hasgadrawing";
		String strQuery3 = "truncate table DMProd.dbo.eto_hasdocument";
		String strQuery4 = "truncate table DMProd.dbo.eto_hasrouting";
		String strQuery5 = "truncate table DMProd.dbo.eto_references";
		String strQuery6 = "truncate table DMProd.dbo.eto_orderparts";

	    
		String strQuery7 = "INSERT INTO DMProd.dbo.eto_report"
			+" (etoid,projectname,weirorderno,customer,status,createduser,lastmoduser,revision,site,puid)"
			+" SELECT distinct t1.ETO_NUMBER, t1.PROJECT_NAME, t1.ORDER_NUMBER, t1.CUSTOMER"
			+" ,t1.STATUS,'1','1',t1.ETO_REVISION, t1.SITE,t1.PUID "
			+" FROM DMProcessDB.dbo.LOAD_ETO_REV t1";
			//+" WHERE t1.STATUS='0'";
	    
/*
		String strQuery8 = "INSERT INTO DMProd.dbo.eto_hasgadrawing (etoeid,hasga_itemid,hasga_drawingid,site,status,hasga_iid,puid)"
				+" SELECT DISTINCT t2.eid,t1.related_item,t1.related_item,t2.site,t1.STATUS,t3.iid,t1.PUID"
				+" FROM  DMProcessDB.dbo.LOAD_ETO_REV t1, DMProd.dbo.eto_report t2 , DMProd.dbo.items t3"
				+" WHERE t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name='WGP4_has_ga' and t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]";
		
		
		String strQuery9 = "INSERT INTO DMProd.dbo.eto_hasdocument(etoeid,hasdocument_itemid,hasdocument_drawingid,site,status,hasdocument_iid,puid)"
				+" SELECT DISTINCT t2.eid, t1.related_item, t1.related_item, t2.site, t1.STATUS,t3.iid,t1.PUID"
				+" FROM DMProcessDB.dbo.LOAD_ETO_REV t1, DMProd.dbo.eto_report t2 , DMProd.dbo.items t3"
				+" WHERE t1.ETO_NUMBER = t2.etoid AND t1.ETO_REVISION = t2.revision and  t1.relation_name = 'WGP4_has_doc' and t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]";
		

		String strQuery10 = "INSERT INTO DMProd.dbo.eto_hasrouting(etoeid,hasrouting_itemid,hasrouting_drawingid,site,status,hasrouting_iid,puid)"
				+" SELECT DISTINCT t2.eid, t1.related_item, t1.RELATED_ITEM_REVISION, t2.site, t1.STATUS ,t3.iid,t1.PUID"
				+" FROM DMProcessDB.dbo.LOAD_ETO_REV t1, DMProd.dbo.eto_report t2 , DMProd.dbo.items t3"
				+" WHERE t1.ETO_NUMBER = t2.etoid AND t1.ETO_REVISION = t2.revision and t1.relation_name = 'WGP4_has_routing' and t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]";
		
		String strQuery11 = "INSERT INTO DMProd.dbo.eto_references(etoeid,references_itemid,references_drawingid,site,status,references_iid,puid)"
				+" SELECT DISTINCT t2.eid, t1.related_item, t1.related_item, t2.site, t1.STATUS,t3.iid,t1.PUID"
				+" FROM DMProcessDB.dbo.LOAD_ETO_REV t1, DMProd.dbo.eto_report t2 , DMProd.dbo.items t3"
				+" WHERE t1.ETO_NUMBER = t2.etoid AND t1.ETO_REVISION = t2.revision and t1.relation_name = 'IMAN_reference' and t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]"; 
		
		String strQuery12 = "INSERT INTO DMProd.dbo.eto_orderparts (etoeid,orderparts_itemid,orderparts_drawingid,site,status,orderparts_iid,puid)"
				+" SELECT DISTINCT t2.eid,t1.related_item,t1.RELATED_ITEM_REVISION,t2.site,t1.STATUS,t3.iid,t1.PUID"
				+" FROM  DMProcessDB.dbo.LOAD_ETO_REV t1, DMProd.dbo.eto_report t2 , DMProd.dbo.items t3"
				+" WHERE t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and t1.relation_name='order-parts' and t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]";
		
	*/	
		
		String strQuery8 = "INSERT INTO DMProd.dbo.eto_hasgadrawing (etoeid,hasga_itemid,hasga_drawingid,site,status,hasga_iid,puid)"
				+" SELECT DISTINCT t2.eid,t1.related_item,t1.related_item,t2.site,t1.STATUS,t3.iid,t1.PUID "
				+" FROM  DMProcessDB.dbo.LOAD_ETO_REV t1"
				+" LEFT JOIN  DMProd.dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid  OR (t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision)"
				+" LEFT JOIN DMProd.dbo.items t3  ON t3.itemid=t1.[RELATED_ITEM] AND t3.revision=t1.[RELATED_ITEM_REVISION]"
				+" WHERE   t1.relation_name='WGP4_has_ga'";
		String strQuery9 = "INSERT INTO DMProd.dbo.eto_hasdocument(etoeid,hasdocument_itemid,hasdocument_drawingid,site,status,hasdocument_iid,puid)"
				+" SELECT DISTINCT t2.eid, t1.related_item, t1.related_item, t2.site, t1.STATUS,t3.iid,t1.PUID" 
				+" FROM DMProcessDB.dbo.LOAD_ETO_REV t1"
				+" LEFT JOIN DMProd.dbo.eto_report t2 ON t1.ETO_NUMBER = t2.etoid OR (t1.ETO_NUMBER = t2.etoid AND t1.ETO_REVISION = t2.revision)"
				+" LEFT JOIN DMProd.dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]"
				+" WHERE t1.relation_name = 'WGP4_has_doc'"; 
		
		
		String strQuery10 = "INSERT INTO DMProd.dbo.eto_hasrouting(etoeid,hasrouting_itemid,hasrouting_drawingid,site,status,hasrouting_iid,puid)"
				+" SELECT DISTINCT t2.eid, t1.related_item, t1.RELATED_ITEM_REVISION, t2.site, t1.STATUS ,t3.iid,t1.PUID "
				+" FROM DMProcessDB.dbo.LOAD_ETO_REV t1"
				+" LEFT JOIN  DMProd.dbo.eto_report t2 ON t1.ETO_NUMBER = t2.etoid OR (t1.ETO_NUMBER = t2.etoid AND t1.ETO_REVISION = t2.revision)"
				+" LEFT JOIN  DMProd.dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]"
				+" WHERE  t1.relation_name = 'WGP4_has_routing'";
		
		String strQuery11 = "INSERT INTO DMProd.dbo.eto_references(etoeid,references_itemid,references_drawingid,site,status,references_iid,puid)"
				+" SELECT DISTINCT t2.eid, t1.related_item, t1.related_item, t2.site, t1.STATUS,t3.iid,t1.PUID "
				+" FROM DMProcessDB.dbo.LOAD_ETO_REV t1"
				+" LEFT JOIN  DMProd.dbo.eto_report t2 ON t1.ETO_NUMBER = t2.etoid OR (t1.ETO_NUMBER = t2.etoid AND t1.ETO_REVISION = t2.revision) "
				+" LEFT JOIN  DMProd.dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]"
				+" WHERE  t1.relation_name = 'WGP4_eto_references'"; 
		
		String strQuery12 = "INSERT INTO DMProd.dbo.eto_orderparts (etoeid,orderparts_itemid,orderparts_drawingid,site,status,orderparts_iid,puid)"
				+" SELECT DISTINCT t2.eid,t1.related_item,t1.RELATED_ITEM_REVISION,t2.site,t1.STATUS,t3.iid,t1.PUID "
				+" FROM  DMProcessDB.dbo.LOAD_ETO_REV t1 "
				+" LEFT JOIN  DMProd.dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision"
				+" LEFT JOIN  DMProd.dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]"
				+" WHERE t1.relation_name='order-parts' ";
		
		 try { 
				
	    	  stmt = connection.createStatement();  
  	  
	    	  String [][] _qry_args = {
	        		 {"delete data from DMProd.dbo.eto_report...",strQuery1},
	        		 {"delete data from DMProd.dbo.eto_hasgadrawing...",strQuery2},
	        		 {"delete data from DMProd.dbo.eto_hasdocument...",strQuery3},
	        		 {"delete data from DMProd.dbo.eto_hasrouting...",strQuery4},
	        		 {"delete data from DMProd.dbo.eto_references...",strQuery5},
	        		 {"delete data from DMProd.dbo.eto_orderparts...",strQuery6},
	        		 
	        		 {"INSERT data INTO DMProd.dbo.eto_report..",strQuery7},
	        		 {"INSERT data INTO DMProd.dbo.eto_hasgadrawing...",strQuery8},
	        		 {"INSERT data INTO DMProd.dbo.eto_hasdocument...",strQuery9},
	        		 {"INSERT data INTO DMProd.dbo.eto_hasrouting...",strQuery10},
	        		 {"INSERT data INTO DMProd.dbo.eto_references...",strQuery11},
	        		 {"INSERT data INTO DMProd.dbo.eto_orderparts...",strQuery12}
	        		 
	        		 
      		       };
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.println("	Executing query ["+i+"]: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 System.out.println("	Completed...");
	         }	
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
	public static void Normalize_LED_Items()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
		String strQuery1 = "truncate table DMProd.dbo.led_ir";
		String strQuery2 = "truncate table DMProd.dbo.led_iom_certificate";
		String strQuery3 = "truncate table DMProd.dbo.led_support_products";
		String strQuery4 = "truncate table DMProd.dbo.led_support_part";

		String strQuery5 = "INSERT INTO DMProd.dbo.led_ir(LEDItemID,revision,toolname,description,wll,tare,status,createduser,createddtm,lastmoduser,lastmoddtm,tooltype,toolstatus,length,width,height,dco,drawingid,site,puid)"
		+" SELECT DISTINCT LED_IR.LED_ITEM_ID,LED_IR.LED_REVISION,LED_IR.LED_ITEM_ID,LED_IR.DESCRIPTION,LED_IR.WLL,LED_IR.TARE,LED_IR.STATUS,'1',LED_IR.DATE_CREATED,'1',LED_IR.DATE_CREATED,Options_ItemType.oid,Options_ItemRelStat.oid,LED_IR.WLENGTH,LED_IR.WIDTH,LED_IR.HEIGHT,LED_IR.DCO,DOC_NUM.DRAWING_NUMBER,LED_IR.SITE,LED_IR.PUID"
		+" 	FROM DMProcessDB.dbo.LOAD_LED_IR AS LED_IR"
			+" LEFT OUTER JOIN DMProd.dbo.options as Options_ItemType"
			+" ON Options_ItemType.description=LED_IR.LED_ITEMTYPE AND Options_ItemType.status='1' and Options_ItemType.categoryid='1'"
			+" LEFT OUTER JOIN DMProd.dbo.options as Options_ItemRelStat"
			+" ON Options_ItemRelStat.name=LED_IR.RELEASE_STATUS AND Options_ItemRelStat.status='1' and Options_ItemRelStat.categoryid='2'"
			+" LEFT OUTER JOIN DMProcessDB.dbo.LOAD_DOCUMENTNUMBER as DOC_NUM"
			+" ON LED_IR.LED_ITEM_ID=DOC_NUM.PART_NUMBER and LED_IR.LED_REVISION=DOC_NUM.PART_REVISION and LED_IR.SITE=DOC_NUM.SITE";
			//+" where LED_IR.STATUS='0'";


		String strQuery6 = "INSERT INTO DMProd.dbo.led_support_products(productname,status,createduser,createddtm,lastmoduser,toolid,site,puid)"
		+" SELECT PRODUCTS.SUPPORT_PRODUCT_ITEM_ID,LED_ITEMREV.status,'1',PRODUCTS.DATE_IMPORTED,'1',LED_ITEMREV.iid,PRODUCTS.SITE,PRODUCTS.PUID"
			  +" FROM DMProcessDB.dbo.LOAD_LED_SUPPORTPRODUCT AS PRODUCTS"
			  +" LEFT OUTER JOIN DMProd.dbo.led_ir AS LED_ITEMREV"
			  +" ON LED_ITEMREV.LEDItemID=PRODUCTS.LED_ITEM_ID AND LED_ITEMREV.revision=PRODUCTS.LED_ITEM_REVISION"
			  +" WHERE LEN(LED_ITEMREV.iid) >0 ";
		//and LED_ITEMREV.status='1'";

			  
			  
		String strQuery7 = "INSERT INTO DMProd.dbo.led_support_part(partname ,status,createduser,createddtm,lastmoduser,toolid,site,puid)"
		+" SELECT DISTINCT PARTS.SUPPORT_PART_ITEM_ID,LED_ITEMREV.status,'1',PARTS.DATE_IMPORTED,'1',LED_ITEMREV.iid,PARTS.SITE,PARTS.puid"
			  +" FROM DMProcessDB.dbo.LOAD_LED_SUPPORTPARTS AS PARTS"
			  +" LEFT OUTER JOIN DMProd.dbo.led_ir AS LED_ITEMREV"
			  +" ON LED_ITEMREV.LEDItemID=PARTS.LED_ITEM_ID AND LED_ITEMREV.revision=PARTS.LED_ITEM_REVISION "
			  +" WHERE LEN(LED_ITEMREV.iid) >0 ";//and LED_ITEMREV.status='1'";

		String strQuery8 = "INSERT INTO DMProd.dbo.led_iom_certificate(toolid,docrefid,docname,createduser,lastmoduser,site,puid)"
		+" SELECT LED_ITEMREV.iid,'1',IOM.IOM_ITEM_ID,'1','1',LED_ITEMREV.site,LED_ITEMREV.PUID"
			   +" FROM DMProd.dbo.led_ir AS LED_ITEMREV"
		       +" LEFT OUTER JOIN DMProcessDB.dbo.LOAD_LED_IOM as IOM"
		       +" ON LED_ITEMREV.LEDItemID=IOM.LED_ITEM_ID AND LED_ITEMREV.revision=IOM.LED_ITEM_REVISION "
			   +" where LEN(IOM.IOM_ITEM_ID)>0  and LED_ITEMREV.status='0'";  
			   
		String strQuery9 = "INSERT INTO DMProd.dbo.led_iom_certificate(toolid,docrefid,docname ,createduser ,lastmoduser,site,puid)"
		+" SELECT LED_ITEMREV.iid,'2',CERTIFICATE.CERTIFICATE_ITEM_ID,'1','1',LED_ITEMREV.site,LED_ITEMREV.PUID"
				+" FROM DMProd.dbo.led_ir AS LED_ITEMREV"
		       +" LEFT OUTER JOIN DMProcessDB.dbo.LOAD_LED_CERTIFICATE as CERTIFICATE"
		       +" ON LED_ITEMREV.LEDItemID=CERTIFICATE.LED_ITEM_ID AND LED_ITEMREV.revision=CERTIFICATE.LED_ITEM_REVISION "
			   +" where LEN(CERTIFICATE.CERTIFICATE_ITEM_ID)>0 and LED_ITEMREV.status='0'";    
		 try { 
				
	    	  stmt = connection.createStatement();  
  	  
	    	  String [][] _qry_args = {
	        		 /*led_ir*/{"truncate table DMProd.dbo.led_ir...",strQuery1},
	        		 /*led_iom_certificate*/{"truncate table DMProd.dbo.led_iom_certificate...",strQuery2},
	        		 /*led_support_products*/{"truncate table DMProd.dbo.led_support_products...",strQuery3},
	        		 /*led_support_part*/{"truncate table DMProd.dbo.led_support_part...",strQuery4},
	        		 /*led_support_part*/{"INSERT INTO DMProd.dbo.led_ir...",strQuery5},
	        		 /*pcnitem_report*/{"INSERT INTO DMProd.dbo.led_support_products...",strQuery6},
	        		 /*led_support_products*/{"INSERT INTO DMProd.dbo.led_support_part...",strQuery7},
	        		 /*led_iom_certificate*/{"INSERT INTO DMProd.dbo.led_iom_certificate...",strQuery8},
	        		 /*led_iom_certificate*/{"INSERT INTO DMProd.dbo.led_iom_certificate...",strQuery9}
      		        	};
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.println("	Executing query ["+i+"]: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 System.out.println("	Completed...");
	         }
	         
          
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
	public static void Normalize_PCN_ALL()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
	    String strQueryPCNRept = "INSERT INTO [DMProd].[dbo].[pcn_report]([pcnid],[revision],[pcnname]"
	    		+" ,[description],[synopsis],[createduser] ,[lastmoduser],[status],[site],[puid])"
	    		+" SELECT distinct [PCN_NUMBER],[PCN_REVISION],[PCN_NUMBER],[PCN_DESCRIPTION],[SYNOPSIS],'1','1',PCN.STATUS, [SITE],[PUID]"    
	    		+" FROM [DMProcessDB].[dbo].[LOAD_PCN] AS PCN";
	    		//+" WHERE PCN.STATUS='0'";
	    
	    
	    String strQueryPCNImpactedItem = "INSERT INTO [DMProd].[dbo].[pcn_impacteditem] ([pid],[impacteditem_iid],[createduser],[lastmoduser],[status],[puid])"
	    		+" SELECT distinct PCN_REPORT.[pid],IMPACTED_ITEM.iid ,'1','1',PCN_REPORT.status,PCN.puid"   
	    		+" FROM [DMProd].[dbo].[pcn_report] AS PCN_REPORT "
	    		+" LEFT OUTER JOIN DMProcessDB.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision "
	    +" LEFT OUTER JOIN [DMProd].[dbo].items AS IMPACTED_ITEM ON IMPACTED_ITEM.itemid = PCN.RELATED_ITEM AND IMPACTED_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasImpactedItem'"
	    +" AND IMPACTED_ITEM.iid IS NOT NULL";
	    //+" WHERE PCN_REPORT.status='1' AND IMPACTED_ITEM.iid IS NOT NULL";
	    
	    String strQueryPCNProblemItem = "INSERT INTO [DMProd].[dbo].[pcn_problemitem] ([pid],[problemitem_iid],[createduser],[lastmoduser],[status],[puid])"
	    		+" SELECT distinct PCN_REPORT.[pid],PROBLEM_ITEM.iid ,'1','1',PCN_REPORT.status,PCN.puid"   
	    		+" FROM [DMProd].[dbo].[pcn_report] AS PCN_REPORT "
	    		+" LEFT OUTER JOIN DMProcessDB.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision "
	    +" LEFT OUTER JOIN [DMProd].[dbo].items AS PROBLEM_ITEM ON PROBLEM_ITEM.itemid = PCN.RELATED_ITEM AND PROBLEM_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasProblemItem'"
	    +" AND PROBLEM_ITEM.iid IS NOT NULL";
	    //+" WHERE PCN_REPORT.status='1' AND PROBLEM_ITEM.iid IS NOT NULL";
	    
	    String strQueryPCNSolutionItem = "INSERT INTO [DMProd].[dbo].[pcn_solutionitem] ([pid],[solutionitem_iid],[createduser],[lastmoduser],[status],[puid])"
	    		+" SELECT distinct PCN_REPORT.[pid],SOLUTION_ITEM.iid ,'1','1',PCN_REPORT.status,PCN.puid"   
	    		+" FROM [DMProd].[dbo].[pcn_report] AS PCN_REPORT "
	    		+" LEFT OUTER JOIN DMProcessDB.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision "
	    +" LEFT OUTER JOIN [DMProd].[dbo].items AS SOLUTION_ITEM ON SOLUTION_ITEM.itemid = PCN.RELATED_ITEM AND SOLUTION_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasSolutionItem'"
	    +" AND SOLUTION_ITEM.iid IS NOT NULL";
	    //+" WHERE PCN_REPORT.status='1' AND SOLUTION_ITEM.iid IS NOT NULL";
	    
	  	    
	      try { 
	
	    	  stmt = connection.createStatement();  
   	  
	    	  String [][] _qry_args = {
	    			  /*pcn_report*/{"Deleteting records from DMProd.dbo.pcn_report...","truncate table [DMProd].[dbo].pcn_report"},  
	    			  /*pcn_impacteditem*/{"Deleteting records from DMProd.dbo.pcn_impacteditem...","truncate table [DMProd].[dbo].pcn_impacteditem"},
	    			  /*pcn_problemitem*/{"Deleteting records from DMProd.dbo.pcn_problemitem...","truncate table [DMProd].[dbo].pcn_problemitem"},
	    			  /*pcn_solutionitem*/{"Deleteting records from DMProd.dbo.pcn_solutionitem...","truncate table [DMProd].[dbo].pcn_solutionitem"},
	    			  /*pcn_report*/{"Inserting pcn data into DMProd.dbo.pcn_report...",strQueryPCNRept},	    			  
	    			  /*pcn_impacteditem*/{"Inserting pcn data into DMProd.dbo.pcn_impacteditem...",strQueryPCNImpactedItem},	    			  
	    			  /*pcn_problemitem*/{"Inserting pcn data into DMProd.dbo.pcn_problemitem...",strQueryPCNProblemItem},	    			  
	    			  /*pcn_solutionitem*/{"Inserting pcn data into DMProd.dbo.pcn_solutionitem...",strQueryPCNSolutionItem},	        		
	        		 /*status pcndata*/{"Set status to 0 for table pcn_report....","UPDATE [DMProd].[dbo].pcn_report SET status='0' WHERE  pcnid is NULL or pcnid=''"},
	        		};	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.println("	Executing query ["+i+"]: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 System.out.println("	Completed...");
	         }
	         
           
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
	public static void Normalize_ItemsReport_Dataset()
	{
		
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	    
	    String strDatasetNrmlizeQuery = " INSERT INTO [DMProd].[dbo].[itemreport_dataset]"
	    		+" ([iid]"
	    		+" ,[datasetname]"
	    		+" ,[datasetdesc]"
	    		+" ,[datasettype]"
	    		+" ,[datasetstatus]"
	    		+" ,[documenttype]"
	    		+" ,[pfile_name]"
	    		+" ,[status]"
	    		+" ,[site]" 
	    		+" ,[puid])"
	    		+" SELECT DISTINCT"
	    		+" Items.iid"
	    		+" ,Dataset.DATASET_NAME"
	    		+" ,Dataset.DATASET_DESCRIPTION"
	    		+" ,Options_DatsetType.oid"
	    		+" ,Options_DatsetRelStatus.oid"
	    		+" ,CASE "
	    		//+" WHEN Dataset.PART_TYPE = 'DocumentRevision' AND Dataset.DATASET_TYPE NOT IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) THEN Options_DocumentPartType.oid"
	    		//+" WHEN Dataset.PART_TYPE = 'Document' AND Dataset.DATASET_TYPE NOT IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) THEN Options_DocumentPartType.oid"
	    		+" WHEN Dataset.PART_TYPE = 'DocumentRevision'  THEN Options_DocumentPartType.oid"
	    		+" WHEN Dataset.PART_TYPE = 'Document' THEN Options_DocumentPartType.oid"
	    		+" ELSE Options_DocumentDSType.oid"
	    		+" END"
	    		+" ,'E:\\Datamart\\Volume1\\'+DESTFILE_PATH.FILE_PATH"
	    		+" ,Dataset.STATUS"
	    		+" ,Dataset.SITE"
	    		+" ,Dataset.PUID"
	    		+" FROM [DMProcessDB].[dbo].LOAD_DATASETS_TRANS AS Dataset"
	    		+" LEFT OUTER JOIN [DMProd].[dbo].items Items"
	    		+" ON Items.itemid=Dataset.PART_NUMBER and Items.revision=Dataset.PART_REVISION and Items.site=Dataset.SITE"
	    		+" LEFT OUTER JOIN [DMProd].[dbo].options as Options_DatsetType"
	    		+" ON Options_DatsetType.description=Dataset.DATASET_TYPE AND Options_DatsetType.status='1' and Options_DatsetType.categoryid='3'"
	    		+" LEFT OUTER JOIN [DMProd].[dbo].options as Options_DatsetRelStatus"
	    		+" ON Options_DatsetRelStatus.description=Dataset.DATASET_REL_STATUS AND Options_DatsetRelStatus.status='1' and Options_DatsetRelStatus.categoryid='4'"
	    		+" LEFT OUTER JOIN [DMProd].[dbo].options as Options_DocumentPartType"
	    		+" ON Options_DocumentPartType.name='IOM Manual' AND Options_DocumentPartType.status='1' and Options_DocumentPartType.categoryid='6'"
	    		+" LEFT OUTER JOIN [DMProd].[dbo].options as Options_DocumentDSType"
	    		+" ON Options_DocumentDSType.description=Dataset.DATASET_TYPE AND Options_DocumentDSType.status='1' and Options_DocumentDSType.categoryid='6'"
	    		+" LEFT OUTER JOIN [DMProcessDB].[dbo].LOAD_DATASETS_FILESPATH as DESTFILE_PATH"
	    		+" ON Dataset.DATASET_NAME=DESTFILE_PATH.DATASET_NAME and Dataset.PUID=DESTFILE_PATH.DATASET_PUID and Dataset.DATASET_TYPE=DESTFILE_PATH.DATASET_TYPE "
	    		+" WHERE Dataset.PART_NUMBER=Items.itemid AND Dataset.PART_REVISION=Items.revision and Dataset.SITE=Items.site and Dataset.status in (0,1)";
	    	
	      String UpdateDocType ="UPDATE [DMProd].[dbo].[itemreport_dataset] set [documenttype] = (SELECT oid from [DMProd].[dbo].[options] opt where opt.name='Other Drawings and Documents' and opt.[categoryid]='6') where [documenttype] is NULL or [documenttype] = ''";
	      try { 
	
	    	  stmt = connection.createStatement();  
   	  
	    	  String [][] _qry_args = {
	        		 {"Deleteting records from itemreport_dataset...","truncate table DMProd.dbo.itemreport_dataset"},
	        		 /*PartTye*/{"Normalizing itemReport dataset table.....",strDatasetNrmlizeQuery},
	        		 {"Updating NULL DOCTYPES to Others itemReport dataset table.....",UpdateDocType}
	         	};
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.println("	Executing query ["+i+"]: ["+i+"]: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 System.out.println("	Completed...");
	         }
          
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
	public static void GenerateOptionTableData()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
   	  
	    	  String [][] _qry_args = {
	        		 {"Deleteting records from DMProd.dbo.options...","truncate table DMProd.dbo.options"},
	        		 {"Deleteting records from DMProd.dbo.real_displaynames...","truncate table DMProd.dbo.real_displaynames"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status]) VALUES('DocumentRevision','Document Item',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status]) VALUES('Drawing Item Revision','Drawing',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status]) VALUES('ItemRevision','Commodity',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('Warman Cyclone Revision','Cyclone',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('Warman Equipment Revision','Equipment',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('Warman Part Tool Revision','Part Tool',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('Warman Pump Revision','Pump',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('Warman Tool Aid Revision','Tool Aid',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('Weir Minerals Revision','Part',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('Weir Screen Revision','Screen',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('Weir Valve Revision','Valve',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_BladeMillRevision','Blade Mill',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_CentrifugeRevision','Centrifuge',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_ConeCrusherRevision','Crusher',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_ConveyorsRevision','Conveyors',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_FeederRevision','Feeder',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_HoseRevision','Hose',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_HPGRRevision','HPGR',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_LiftingERevision','Lifting Equipment',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_MatSpecRevision','Material Specification',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_MechatronicRevision','Mechatronics',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_MechSealRevision','Mechanical Seal',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_Mill_LinerRevision','Mill Liner',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_PartResorceRevision','Part Resource',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_PlantRevision','Plant',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_SpoolRevision','Spool',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_TransportCRevision','Transport Cradle',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_WasherRevision','Washer',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP7CycClustRevision','Cyclone Cluster',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_Ball_FeederRevision','Ball Feeder',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_ElastomerRevision','Elastomer',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_SkidRevision','Skid',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_WeirMagnetRevision','Magnet',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_BargeRevision','Barge',1)"},
	        		 {"Inserting Real Display Name of Part Revisions","INSERT INTO [DMProd].[dbo].[real_displaynames]([real_name],[display_name],[status])  VALUES('WGP4_WeirProductRevision','Product',1)"},

	        		 /*PartTye*/{"Inserting PART_TYPE records into table Options...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) SELECT distinct PART_TYPE,PART_TYPE,'1','1'  FROM DMProcessDB.dbo.LOAD_PARTREVISION where STATUS='0'"},
	        		 /*RELEASE_STATUS*/{"Inserting RELEASE_STATUS records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) SELECT distinct RELEASE_STATUS,RELEASE_STATUS,'1','2'  FROM DMProcessDB.dbo.LOAD_PARTREVISION where STATUS='0'"},
	        		 /*DATASET_TYPE*/{"Inserting DATASET_TYPE records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) SELECT distinct DATASET_TYPE,DATASET_TYPE,'1','3'  FROM DMProcessDB.dbo.LOAD_DATASETS_TRANS where STATUS='0'"},
	        		 /*DATASET_REL_STATUS*/{"Inserting DATASET_REL_STATUS records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) SELECT distinct DATASET_REL_STATUS,DATASET_REL_STATUS,'1','4'  FROM DMProcessDB.dbo.LOAD_DATASETS_TRANS where STATUS='0'"},
	        		 /*DCO*/{"Inserting DCO records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) SELECT distinct DCO,DCO,'1','5'  FROM DMProcessDB.dbo.LOAD_PARTREVISION where STATUS='0' and DCO <> ''"},
	        		 /*DetailedPDF*/{"Inserting DetailedPDF ids into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Assembly/Master Drawing','DetailedPDF','1','6')"},
	        		 /*MaterialSpecSheet*/{"Inserting MaterialSpecSheet ids into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Material Specification','MaterialSpecSheet','1','6')"},
	        		 /*Other Drawings and Documents*/{"Inserting PDF ids into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Other Drawings and Documents','PDF','1','6')"},
	        		 /*IOM Manual*/{"Inserting DocumentRevision ids into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('IOM Manual','DocumentRevision','1','6')"},
	        		 /*General Arrangement*/{"Inserting Non DetailedPDF ids into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('General Arrangement','Non DetailedPDF','1','6')"},
	        		 
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('AMR Request', 'AMR Request', 1, 8)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Data Issue', 'Data Issue', 1, 8)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Request For Basic Data', 'Request For Basic Data', 1, 8)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('New', 'New', 1, 9)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Processing', 'Processing', 1, 9)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Submitted', 'Submitted', 1, 9)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Cancelled', 'Cancelled', 1, 9)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Completed', 'Completed', 1, 9)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Error', 'Error', 1, 9)"},
	        		 /*DCO*/{"Inserting DCO records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) select distinct site, site,'1','10'  FROM [DMProd].[dbo].[items] where site is not null or site <>''"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Low', 'Low', 1, 11)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Medium', 'Medium', 1, 11)"},
	        		 /*PR*/{"Inserting Problem Report records into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('High', 'High', 1, 11)"},     		 
	        		/*General Arrangement {"Inserting Tech Rebuild centerPDF ids into table Option...","INSERT INTO DMProd.dbo.options (name,description,status,categoryid) values ('Tech Rebuild','Tech Rebuild CenterPDF','1','6')"},*/
	        		 
	        		 /*update option name*/{"updating option name...","UPDATE DMProd.dbo.options SET \"options\".name = \"dis\".display_name FROM DMProd.dbo.options AS \"options\" INNER JOIN DMProd.dbo.real_displaynames AS \"dis\" ON \"dis\".real_name=\"options\".description WHERE  \"options\".categoryid='1';"},
   		 
	         	};
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.println("	Executing query ["+i+"]:  "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 System.out.println("	Completed...");
	         }
	         /*String _qry_args_real_name[] ={"UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'DocumentRevision','Document Item')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Drawing Item Revision','Drawing')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'ItemRevision','Commodity')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Warman Cyclone Revision','Cyclone')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Warman Equipment Revision','Equipment')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Warman Part Tool Revision','Part Tool')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Warman Pump Revision','Pump')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Warman Tool Aid Revision','Tool Aid')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Weir Minerals Revision','Part')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Weir Screen Revision','Screen')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'Weir Valve Revision','Valve')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_BladeMillRevision','Blade Mill')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_CentrifugeRevision','Centrifuge')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_ConeCrusherRevision','Crusher')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_ConveyorsRevision','Conveyors')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_FeederRevision','Feeder')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_HoseRevision','Hose')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_HPGRRevision','HPGR')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_LiftingERevision','Lifting Equipment')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_MatSpecRevision','Material Specification')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_MechatronicRevision','Mechatronics')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_MechSealRevision','Mechanical Seal')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_Mill_LinerRevision','Mill Liner')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_PartResorceRevision','Part Resource')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_PlantRevision','Plant')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_SpoolRevision','Spool')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_TransportCRevision','Transport Cradle')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_WasherRevision','Washer')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP7CycClustRevision','Cyclone Cluster')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_Ball_FeederRevision','Ball Feeder')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_ElastomerRevision','Elastomer')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_SkidRevision','Skid')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_WeirMagnetRevision','Magnet')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_BargeRevision','Barge')",
	        		 "UPDATE [DMProd].[dbo].[options] set name= REPLACE(name,'WGP4_WeirProductRevision','Product')"
	        		 
	        		 };
           
	      System.out.println("	Updating Real Names of Parts");
	      for (int i=0;i<_qry_args_real_name.length;i++) 
	         {	 
	    	     //System.out.println("	Executing query ["+i+"]:  "+_qry_args_real_name[i]);       	 
	        	 stmt.executeUpdate(_qry_args_real_name[i]);	        	 
	         }
	      System.out.println("	Completed...");*/
	      }
	      // Handle any errors that may have occurred.  
	      catch (SQLException e) {  
	    	  System.err.println("Got an exception! ");
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	        // if (connection != null) try { connection.close(); } catch(Exception e) {}  
	      	}
	}
	public static void Normalize_ITEM_into_DMProd()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
   	  
	    	  
	    	  /*String strItemLoadQuery = "INSERT INTO [DMProd].[dbo].[items] ([itemid],[itemname],[description],[revision],[drawingid],[site],[updatedrefid],[status],[dcoid],[length],[width],[height],[encumbrance],[weight],[erp_part_name],[erp_part_description],[datereleased],[drawing_revision],[legacy_part_number],[legacy_document_number],[itemtype],[itemstatus]) "
	    	  		+ "SELECT DISTINCT t1.PART_NUMBER,t1.PART_NUMBER,t1.PART_DESCRIPTION,t1.PART_REVISION,t3.DRAWING_NUMBER,t1.SITE,'1','1',ISNULL(t2.oid,0),t1.WLENGTH,t1.WIDTH,t1.HEIGHT,t1.ENCUMBRANCE,t1.WEIGHT,t1.ERP_PART_NAME,t1.ERP_PART_DESC,t1.DATE_RELEASED,t3.DRAWING_REVISION,t4.LEGACY_PART_NUMBER,t4.LEGACY_DRAWING_NUMBER,t5.oid,t6.oid "
	    	  		+ "FROM DMProcessDB.dbo.LOAD_PARTREVISION t1,DMProd.dbo.options t2,  DMProcessDB.dbo.LOAD_DOCUMENTNUMBER t3,DMProcessDB.dbo.LOAD_ALT_ALIAS_ID t4,DMProd.dbo.options t5,DMProd.dbo.options t6 "
	    	  		+ "where t1.PART_NUMBER = t3.PART_NUMBER and t1.PART_REVISION = t3.PART_REVISION and t1.SITE=t3.site and t1.PART_NUMBER = t4.ITEM_ID and t1.SITE=t4.site and t2.status = '1' and t2.categoryid= '5' and t5.description = t1.PART_TYPE and t5.status = '1' and t5.categoryid= '1' and  t6.name = t1.RELEASE_STATUS and t6.status = '1' and t6.categoryid= '2'";*/
	    	  
	    	  
	    	  String strItemLoadQuery = "INSERT INTO [DMProd].[dbo].[items] ([itemid],[itemname],[description],[revision],[drawingid],[site],[updatedrefid],[status],[dcoid],[length],[width],[height],[encumbrance],[weight],[erp_part_name],[erp_part_description],[datereleased],[drawing_revision],[legacy_part_number],[legacy_document_number],[itemtype],[itemstatus],[puid],[t4s_mm_status],[t4s_dir_status]) "
	    			 + "SELECT DISTINCT t1.[PART_NUMBER],t1.[PART_NUMBER],t1.[PART_DESCRIPTION]"
	    			 + ",t1.[PART_REVISION],t2.DRAWING_NUMBER,t1.SITE,'1',t1.STATUS,ISNULL(t6.oid,0),t1.WLENGTH,t1.WIDTH"
	    	    	 + "  ,t1.HEIGHT,t1.ENCUMBRANCE,t1.WEIGHT,t1.ERP_PART_NAME,t1.ERP_PART_DESC,t1.DATE_RELEASED"
	    	    	 + "  ,t2.DRAWING_REVISION,t3.LEGACY_PART_NUMBER,t3.LEGACY_DRAWING_NUMBER,t4.oid,t5.oid,t1.PUID,t1.T4S_MM_STATUS,t1.T4S_DIR_STATUS"
	    	    	 + " FROM [DMProcessDB].[dbo].[LOAD_PARTREVISION] as t1"
	    	    	 + " LEFT OUTER JOIN [DMProcessDB].[dbo].LOAD_DOCUMENTNUMBER as t2"
	    	    	 + " ON t1.PART_NUMBER=t2.PART_NUMBER and t1.PART_REVISION=t2.PART_REVISION and t1.SITE=t2.SITE"
	    	    	 + " LEFT OUTER JOIN [DMProcessDB].[dbo].LOAD_ALT_ALIAS_ID as t3"
	    	    	 + " ON t1.PART_NUMBER=t3.ITEM_ID AND  t1.SITE=t3.SITE"
	    	    	 + " LEFT OUTER JOIN DMProd.dbo.[options] as t6"
	    	    	 + " ON t6.name=t1.DCO AND t6.status='1' and t6.categoryid='5'"
	    	    	 + " LEFT OUTER JOIN  DMProd.dbo.[options]  as t4"
	    	    	 + " ON t4.description=t1.PART_TYPE AND t4.status='1' and t4.categoryid='1'"
	    	    	 + " LEFT OUTER JOIN  DMProd.dbo.[options]  as t5"
	    	    	 + " ON t5.name=t1.RELEASE_STATUS AND t5.status='1' and t5.categoryid='2'"
	    	    	 + " where t1.STATUS in (0,1)";
		    	String strDocumenNameLoadQuery = "INSERT INTO [DMProd].[dbo].[documentitem_name]"
		    		 + " ([puid],[document_rev_name],[site])"
		    		 + " SELECT DISTINCT PUID,DOCUMENT_REV_NAME,SITE from [DMProcessDB].[dbo].LOAD_DOCUMENT_REV_NAME";
 
	    	  
	    	    //Reset null data with a null value
		  		String strQuery13 = "update DMProd.dbo.items set width=0 where width is null";
		  	    String strQuery14 = "update DMProd.dbo.items set height=0 where height is null";
		  	    String strQuery15 = "update DMProd.dbo.items set length=0 where length is null";
		  	    String strQuery16 = "update DMProd.dbo.items set weight=0 where weight is null";
		  	    String strQuery17 = "update DMProd.dbo.items set description='' where description is null";
		  	    String strQuery18 = "update  it set it.itemname=doc.document_rev_name FROM DMProd.dbo.items it , DMProd.dbo.documentitem_name doc where it.puid=doc.puid and it.site=doc.site";
	  		
	    	 
	    	  String [][] _qry_args = {
	        		 {"Deleteting records from DMProd.dbo.items...","truncate table DMProd.dbo.items"},
	        		 {"Deleteting records from DMProd.dbo.documentitems_subtype...","truncate table DMProd.dbo.documentitems_subtype"},	   
	        		 {"Deleteting records from DMProd.dbo.documentitem_name...","truncate table DMProd.dbo.documentitem_name"},	   
	        		 /*ItemLoad*/{"Inserting records into table DMProd.dbo.items...",strItemLoadQuery},
	        		 {"Update dmprod.items weight NULL to 0...",strQuery13},
	        		 {"Update dmprod.items height NULL to 0...",strQuery14},
	        		 {"Update dmprod.items length NULL to 0...",strQuery15},
	        		 {"Update dmprod.items width NULL to 0...",strQuery16},
	        		 {"Update dmprod.items description NULL to ''...",strQuery17},
	        		 /*update weight attr*/{"Updating weight attribute...","UPDATE DMProd.dbo.items set weight=CONVERT(decimal(32,3),weight)"},
	        		 /*update encumbrance attr*/{"Updating encumbrance attribute...","UPDATE DMProd.dbo.items set encumbrance='' where encumbrance in ('X  X','x  x','0 X 0 X 0')"},
	        		 /*Insert documentitems_subtype*/{"Inserting records into table documentitems_subtype...","INSERT INTO [DMProd].[dbo].documentitems_subtype ([itemid],[name],[subtype],[site],[puid]) SELECT ITEM_ID,NAME,SUB_TYPE,SITE,PUID FROM DMProcessDB.dbo.LOAD_DOCUMENT_SUBTYPE WHERE STATUS='0'"},
	        		 ///*Replace Line feed char from Table*/ {"Remove line feed from table","UPDATE DMProd.dbo.items SET itemid = replace(itemid, char(10), '')"},
	        		 {"Inserting into Document Name table...",strDocumenNameLoadQuery},
	        		 {"Update dmprod.items name for Document items...",strQuery18}
	    	  };
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.println("	Executing query ["+i+"]: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 System.out.println("	Completed...");
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
	public static void Normalize_Item_DocumentRef_into_DMProd()
	{
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
   	  
	    	  
	    	  String strItemDocRefQuery = "INSERT INTO [DMProd].[dbo].[items_doc_references]([iid],[document_itemid],[document_name],[site],[status],[puid]) SELECT DISTINCT t1.iid,t2.DOCUMENT_ITEM_ID,t2.DOCUMENT_NAME,t2.SITE,t2.STATUS,T2.PUID "
	    	  		+ "FROM [DMProcessDB].[dbo].LOAD_DOCITEM_REFERENCES  t2, [DMProd].[dbo].items t1 "
	    	  		+ "where t2.ITEM_ID=t1.itemid and t2.PART_REVISION=t1.revision and t2.SITE=t1.site and LEN(t1.iid) > 0";
	    	  
	    	  String [][] _qry_args = {
	        		 {"Deleteting records from DMProd.dbo.items_doc_references...","truncate table DMProd.dbo.items_doc_references"},
	        		 //{"Deleteting records from DMProd.dbo.documentitems_subtype...","truncate table DMProd.dbo.documentitems_subtype"},
	        		 
	        		 /*ItemLoad*/{"Inserting records into table DMProd.dbo.items...",strItemDocRefQuery}
	        		 };
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.println("	Executing query ["+i+"]: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 System.out.println("	Completed...");
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
	public static void Normalize_DocumentCategory_into_DMProd(){
		Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
	      try { 
	
	    	  stmt = connection.createStatement();  
   	  
	    	  
	    	  String strItemCategory = "INSERT INTO [DMProd].[dbo].[documentitem_category]([puid],[document_item_id],[primary_category],[secondary_category],[teritory_category],[status],[createduser],[createddtm],[lastmoduser],[lastmoddtm]) "
	    			+ "SELECT DISTINCT [PUID],[DOCUMENT_ITEM_ID],[PRIMARY_CATEGORY],[SECONDARY_CATEGORY],[TERITORY_CATEGORY],'0','1',GETDATE(),'1',GETDATE() "
	    	  		+ "FROM [DMProcessDB].[dbo].[LOAD_DOCUMENT_CATEGORY]";
	    	  
	    	  String [][] _qry_args = {
	        		 {"Deleteting records from DMProd.dbo.documentitem_category...","truncate table DMProd.dbo.documentitem_category"},
	        		 //{"Deleteting records from DMProd.dbo.documentitems_subtype...","truncate table DMProd.dbo.documentitems_subtype"},
	        		 
	        		 /*ItemLoad*/{"Inserting records into table DMProd.dbo.documentitem_category...",strItemCategory}
	        		 };
	
	
	         for (int i=0;i<_qry_args.length;i++) 
	         {
	        	 System.out.println("	Executing query ["+i+"]: "+_qry_args[i][0]);
	        	 stmt.executeUpdate(_qry_args[i][1]);
	        	 System.out.println("	Completed...");
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
	
	public static void Build_Datamart()
	{
		//Statement stmt = null;  
	    DmDBConnection conn = new DmDBConnection();
	    Connection connection = conn.getDBConnection();
	      
		CallableStatement stmt = null; 
				
		try { 
			
	    	  //stmt = connection.createStatement();
			  DMLogger.log("	Executing sp_build_datamart....");
	    	  stmt = connection.prepareCall("{call DMProd.dbo.sp_build_datamart()}")	;      
	    	  stmt.execute();
	    	  DMLogger.log("	Completed sp_build_datamart execution...");
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
}
