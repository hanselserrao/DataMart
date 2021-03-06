package atm;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;


public class ItemDataExport {

	public static void main(String[] args) throws Exception {

		File outfile = null;
		FileOutputStream fp = null;
		TcDBConnection conn = new TcDBConnection();
        Connection connection = null;
        Statement stmt1 = null;
        ResultSet Results = null;
        String str_outFileLocation=null;
		String strPropFileArg = null;
		String strPropFileLocation = null;
		String strDeltaArgument = null;
		boolean dDeltaExtraction = false;
		String lastExtractionTimeStamp = null;
		File propfilePath = null;
		String owningSitePUID = null;
		String deltaNumberOfDays = null;
		DMLogger logger = new DMLogger();
		String strLogFileName = null;
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
    	Date date = new Date();
		if( args.length < 2 )
		{
			System.out.println("Configutation properties file is missing from commandline argument");
			System.out.println("Exiting...aplication");
			System.out.println("	USAGE: DataMartDataExtract -in_file=<properties file with absolute path.> -delta=<true>");
			System.exit(0);
			
		}
		else
		{
			strPropFileArg = args[0];
			strDeltaArgument = args[1];
			if(strPropFileArg.contentEquals("-h"))
			{
				System.out.println("	USAGE: DataMartDataExtract -in_file=<properties file with absolute path.> <-delta=true>");
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
					 	conn.setPropertiesFile(propfilePath);
				        connection = conn.getDBConnection();
				        
				        deltaNumberOfDays = conn.getNumberOfDays();
				        strLogFileName =  conn.getFileProcessLocation()+"/Extraction_"+ dateFormat.format(date)+".log";
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
					System.out.println("	ERROR: Config.properties file didn't find at jar file location...");
					System.exit(0);
					
				}
			}
			else
			{
				System.out.println("USAGE: DataMartDataExtract -in_file=<properties file>");
				System.exit(0);
			}
			
			
			owningSitePUID = getsitePUID(conn.getSiteID());
			if( owningSitePUID == null)
			{
				System.out.println("---------------------------------------------");
				System.out.println("	ERROR: Given Site Id ["+conn.getSiteID()+"] doesnot exists in Teamcenter DB." );
				System.out.println("	Please check config.properties");
				System.out.println("	Exiting application.");
				System.out.println("---------------------------------------------");
				System.exit(0);
			}
				
			if(owningSitePUID!= null && strDeltaArgument.contains("-delta=true")) 
			{
				
				dDeltaExtraction = true;			
					
					DMLogger.log("---------------------------------------------");
					DMLogger.log("EXRACTION MODE : DELTA");
					DMLogger.log("---------------------------------------------");						
					
					if(deltaNumberOfDays == null)
					{
						deltaNumberOfDays = "7";
						DMLogger.log("Delta Days has not been provided. Setting default to 7 Days");
					}					
					else
					{
						
						DMLogger.log("Number of days that Delta Extraction would be performed is "+deltaNumberOfDays);
					}
					int inputDeltaDate = Integer.parseInt(deltaNumberOfDays);
					inputDeltaDate = -inputDeltaDate;
					
					Calendar cal = Calendar.getInstance();
					cal.add(Calendar.DATE , inputDeltaDate);
					SimpleDateFormat s = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					lastExtractionTimeStamp = s.format(new Date(cal.getTimeInMillis()));
		        	
			}
			else
			{
				DMLogger.log("---------------------------------------------");
				DMLogger.log("EXRACTION MODE : FULL");
				DMLogger.log("---------------------------------------------");
				dDeltaExtraction = false;
			}
			
		}
		
		if(dDeltaExtraction)
		{
			DMLogger.log("DELTA...Extraction process started......");
			
		}
		
		if ( owningSitePUID!= null && dDeltaExtraction != true ) //deltaExtraction = false
		{
	        System.out.println("FULL Extraction Process started at site : " + conn.getSiteID());
	        
	        //Create and log extraction time stamp at config.properties file location
	        String strTMFilePath = null;		
	    	
	    	strTMFilePath = new File(".").getAbsolutePath() + "\\dm_extract_timestamp.txt";
	    	strTMFilePath = strTMFilePath.replace("\\.\\", "\\");
			System.out.println("INFO: Logging timestamp file location : " + strTMFilePath);
			
			File file1 = new File(strTMFilePath);
			if (!file1.exists()) 
			{
				file1.createNewFile();
			}
			try{
	            FileWriter fw = new FileWriter(file1.getAbsoluteFile());
	            BufferedWriter bw = new BufferedWriter(fw);
	            bw.write(dateFormat.format(date));
	            bw.close();
	        }
	        catch(Exception e){
	            System.out.println(e);
	        }
	        
		}
		
		String strQryPCN_NonRelated_Items = null;
		String strPCNRelItems = null;
		String strQryPCNProbItems = null;
		String strQryPCNSolutionItems= null;
		String strQryPCNImpactedItems = null;
		String strIRLocal=null;
		String strDatasetLocal=null;
		String strDatasetLocalFiles=null;
		String strPHYSICAL_FILES=null;
		String strIRDocRefrenceLocal=null;
		String strALIAS_ALTERNATE=null;
		String strDRWLocal=null;
		String strDOCUMNET_SUBTYPE=null;
		String strMaterialLocal=null;
		String strLEDIRLocal=null;
		String strLED_ALIAS_ALTERNATE=null;
		String strLED_IOM=null;
		String strLED_CERTIFICATE=null;
		String strLED_SUPPORT_PART=null;
		String strLED_SUPPORT_PRODUCT=null;
		String strETO_RELATED_ITEMS=null;
		String strETO_ORDER_PARTS=null;
		String strETO_ALL_ITEMS = null;
		String strDocumentCategory = null;
		String strDocumentName = null;
		/*
		 *Date:12/7/2017
		 *  Dev02 and AUS-PROD are very old DB instances and they will not have PRELEASE_STATUS_LIST table � Instead they will have PRELEASE_STATUS_LIST_0.
		 */
		String PRELEASE_STATUS_LIST_TABNAME = "PRELEASE_STATUS_LIST";
		if(conn.getSiteID().contains("AUS") || conn.getSiteID().contains("Artarmon"))
		{
			PRELEASE_STATUS_LIST_TABNAME = "PRELEASE_STATUS_LIST_0";
		}
		
		//log timestamp completed.
		
        if(dDeltaExtraction)
        {
        	
      	 strIRLocal = "SELECT t3.pitem_id||'|'||t2.pitem_revision_id||'|'||t1.pobject_type||'|'||replace(replace(t1.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_NAME,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_DESCRIPTION,CHR(10),' '),CHR(13),' ')||'|'||t2.PWGP4_DESIGN_CENTRE||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'|| TO_CHAR(t1.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss') ||'|'||PRELEASESTATUS.pname||'|'||t2.PWGP4_LENGTH||'|'||t2.PWGP4_WIDTH||'|'||t2.PWGP4_HEIGHT||'|'||t2.PWGP4_WEIGHT||'|'||''||'|'||t2.PWGP4_MATERIAL_CODE||'|'||t2.PWGP4_T4S_ENABLED||'|'||'0'||'|'||''||'|'||'"+conn.getSiteID()+"'||'|'||t2.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'|'||replace(t2.PWGP4_T4S_MMSTATUS,'|','#')||'|'||replace(t2.PWGP4_T4S_DIRSTATUS,'|','#')||'~~' as result "
   			 +" from pitemrevision t2"
   			 +" LEFT JOIN pitem t3 on  t2.ritems_tagu = t3.puid"
   			 +" LEFT JOIN pworkspaceobject t1 on  t1.puid =t2.puid"
        	 +" LEFT JOIN PPOM_APPLICATION_OBJECT t4 on (t1.PUID = t4.PUID)"
        	 +" LEFT JOIN "+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = t2.puid"
        	 +" LEFT JOIN PRELEASESTATUS on PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
        	 +" LEFT JOIN ppom_object on ppom_object.puid = t1.puid"
        	 +" LEFT JOIN POM_TIMESTAMP timestamp on timestamp.puid = t1.puid"
        	 +" WHERE t1.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))";
      	
      	  strDatasetLocal =  "  SELECT t1.pitem_id||'|'||t2.pitem_revision_id||'|'||wo2.pobject_type||'|'||wo3.pobject_name||'|'||PDATASETTYPE.pdatasettype_name||'|'||replace(replace(wo3.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'|| to_char(t4.pcreation_date,'YYYY-MM-DD hh:mm:ss')||'|'||PRELEASESTATUS.pname||'|'|| to_char(wo3.pdate_released,'YYYY-MM-DD hh:mm:ss')||'|'||'0'||'|'||'COMMENTS'||'|'||'0'||'|'||'0'||'|'||'"+conn.getSiteID()+"'||'|'||pdataset.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
	              +" FROM pitemrevision t2"
	              +" LEFT JOIN pitem t1 ON t2.ritems_tagu = t1.puid"
	              +" LEFT JOIN pworkspaceobject wo2 ON wo2.puid = t2.puid"
	              +" LEFT JOIN ppom_object ON ppom_object.puid = t1.puid"
	              +" LEFT JOIN pimanrelation ON t2.puid=pimanrelation.rprimary_objectu"
	              +" LEFT JOIN pdataset ON pdataset.puid = pimanrelation.rsecondary_objectu"
	              +" LEFT JOIN pimantype ON pimantype.puid=pimanrelation.rrelation_typeu"
	              +" LEFT JOIN pdatasettype on pdatasettype.puid = pdataset.rdataset_typeu"
	              +" LEFT JOIN pworkspaceobject wo3 ON pdataset.puid = wo3.puid"
	              +" LEFT JOIN "+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = pdataset.puid"
	              +" LEFT JOIN PRELEASESTATUS ON PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
	              +" LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.puid = pdataset.puid"
	              +" LEFT JOIN POM_TIMESTAMP timestamp on timestamp.puid = t2.puid"
	              +" WHERE wo2.pactive_seq !=0  AND PDATASETTYPE.pdatasettype_name is not NULL AND pimantype.ptype_name = 'IMAN_specification' AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')  OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))";
  
      	strDatasetLocalFiles = "select t1.pitem_id||'|'||t2.pitem_revision_id||'|'||wo1.pobject_type||'|'||wo3.pobject_name||'|'||PDATASETTYPE.pdatasettype_name||'|'||PIMANFILE.pfile_name||'|'||'0'||'|'||'COMMENTS'||'|'||'"+conn.getSiteID()+"'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'|'||t2.puid||'|'||pdataset.puid||'~~' as result "
           		+ "from pitem t1, pitemrevision t2, pworkspaceobject wo1, pimantype, ppom_object, pimanrelation, pworkspaceobject wo3, PPOM_APPLICATION_OBJECT t4, pdataset, PDATASETTYPE, PIMANFILE, PIMANVOLUME, pref_list_0,POM_TIMESTAMP timestamp  "
           		+ "where wo1.puid = t2.puid and t2.ritems_tagu = t1.puid and pimantype.puid=pimanrelation.rrelation_typeu and pimantype.ptype_name = 'IMAN_specification' and pdatasettype.puid = pdataset.rdataset_typeu and pdataset.puid = pimanrelation.rsecondary_objectu and pdataset.puid = wo3.puid and t2.puid=pimanrelation.rprimary_objectu and t4.puid = pdataset.puid and pdataset.puid = pimanrelation.rsecondary_objectu and pimanfile.puid=pref_list_0.PVALU_0 and PIMANFILE.RVOLUME_TAGU=PIMANVOLUME.puid and "
           		+ "pimanrelation.RSECONDARY_OBJECTU=pref_list_0.puid and (PDATASETTYPE.pdatasettype_name = 'Tech Rebuild CenterPDF' or PDATASETTYPE.pdatasettype_name = 'Non DetailedPDF' or PDATASETTYPE.pdatasettype_name = 'Zip' or PDATASETTYPE.pdatasettype_name = 'MISC') and (LOWER(PIMANFILE.pfile_name) like '%.pdf' or LOWER(PIMANFILE.pfile_name) like '%.skp' or LOWER(PIMANFILE.pfile_name) like '%.stp') "
           		+ "and ppom_object.puid = wo1.puid and timestamp.puid = t2.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))" ;
    
      	strPHYSICAL_FILES = "select t1.pitem_id||'|'||t2.pitem_revision_id||'|'||wo1.pobject_type||'|'||wo3.pobject_name||'|'||PDATASETTYPE.pdatasettype_name, pimanvolume.pwnt_path_name||'/'||PIMANFILE.psd_path_name||'/'||PIMANFILE.pfile_name as result "
          		+ "from pitem t1, pitemrevision t2, pworkspaceobject wo1, ppom_object, pimantype, pimanrelation, pworkspaceobject wo3, PPOM_APPLICATION_OBJECT t4, pdataset, PDATASETTYPE, PIMANFILE,PIMANVOLUME,pref_list_0 ,POM_TIMESTAMP timestamp  "
          		+ "where wo1.puid = t1.puid and t2.ritems_tagu = t1.puid and pimantype.puid=pimanrelation.rrelation_typeu and pimantype.ptype_name = 'IMAN_specification' and pdatasettype.puid = pdataset.rdataset_typeu and "
          		+ "pdataset.puid = pimanrelation.rsecondary_objectu and pdataset.puid = wo3.puid and t2.puid=pimanrelation.rprimary_objectu and t4.puid = pdataset.puid "
          		+ "and pdataset.puid = pimanrelation.rsecondary_objectu and pimanfile.puid=pref_list_0.PVALU_0 and PIMANFILE.RVOLUME_TAGU=PIMANVOLUME.puid "
          		+ "and pimanrelation.RSECONDARY_OBJECTU=pref_list_0.puid and (PDATASETTYPE.pdatasettype_name = 'Tech Rebuild CenterPDF' or PDATASETTYPE.pdatasettype_name = 'Non DetailedPDF' or PDATASETTYPE.pdatasettype_name = 'Zip' or PDATASETTYPE.pdatasettype_name = 'MISC') and (LOWER(PIMANFILE.pfile_name) like '%.pdf' or LOWER(PIMANFILE.pfile_name) like '%.skp' or LOWER(PIMANFILE.pfile_name) like '%.stp') "              		
          		+ "and ppom_object.puid = wo1.puid  and timestamp.puid = t2.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))" ;
  
      	strIRDocRefrenceLocal = "select pt1.pitem_id||'|'||pt2.pitem_revision_id||'|'||pwo.pobject_type||'|'||ct1.pitem_id||'|'||ct2.pitem_revision_id||'|'||cwo.POBJECT_NAME||'|'||'"+conn.getSiteID()+"'||'|'||pt2.puid||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
        		 + " FROM pitemrevision pt2"
        		 + " LEFT JOIN pitem pt1 ON pt2.ritems_tagu = pt1.puid"
	             + " LEFT JOIN pimanrelation irel ON irel.rprimary_objectu = pt2.puid "
	             + " LEFT JOIN pitemrevision ct2 ON irel.rsecondary_objectu = ct2.puid"
	             + " LEFT JOIN pitem ct1 ON ct2.ritems_tagu = ct1.puid OR ct1.puid = irel.rsecondary_objectu "
	             + " LEFT JOIN pimantype itype ON itype.puid=irel.rrelation_typeu"
	             + " LEFT JOIN pworkspaceobject pwo ON pwo.puid = pt2.puid"
	             + " LEFT JOIN pworkspaceobject cwo ON  cwo.puid =  ct1.puid "
	             + " LEFT JOIN ppom_object ON ppom_object.puid = pwo.puid "
	             + " LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.PUID = pt2.PUID "
	             + " LEFT JOIN POM_TIMESTAMP timestamp on timestamp.puid = pt2.puid"
	             + " WHERE pwo.pactive_seq !=0 AND itype.ptype_name = 'IMAN_reference' AND cwo.pobject_type IN ('Document','Drawing Item') AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))" ;

      	strALIAS_ALTERNATE =  "select distinct t_01.PITEM_ID||'|'||t_02.PIDFR_ID ||'|'||t_07.PIDFR_ID||'|'||t_01.pwgp4_item_id_legacy||'|'||t_01.pwgp4_drawing_id_legacy ||'|'||'"+conn.getSiteID()+"'||'|'||t_01.PUID||'|'||'111111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
		             + "from PITEM t_01" 
		             + " left outer join PIDENTIFIER t_02 on t_01.puid = t_02.raltid_ofu" 
		             + " left outer join PWORKSPACEOBJECT t_03 on t_03.PUID=t_01.puid"
					 + " left outer join PPOM_APPLICATION_OBJECT t4 on t4.PUID=t_01.puid"
		             + " left outer join ppom_object t_05 on t_05.puid=t_03.puid"
		             + " left outer join PIMANRELATION t_06 on  t_01.puid = t_06.rprimary_objectu  and t_06.rrelation_typeu  in (select PUID from PIMANTYPE where PTYPE_NAME='IMAN_aliasid')"
		             + " left outer join PIDENTIFIER t_07 on  t_06.rsecondary_objectu = t_07.puid"
		             + " left outer join POM_TIMESTAMP timestamp on timestamp.puid = t_01.puid"
		             + " where (t_02.PIDFR_ID is not null or t_07.PIDFR_ID is not null or t_01.pwgp4_item_id_legacy is not null or t_01.pwgp4_drawing_id_legacy is not null) and t_03.pactive_seq !=0 and (t_05.rowning_siteu is null or t_05.rowning_siteu ='"+owningSitePUID+"' or t_05.rowning_siteu='AAAAAAAAAAAAAA') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))" ;          			
 
              strDRWLocal = "select distinct pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t_03.pitem_id||'|'||t_02.pitem_revision_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
                       		+ "from pitem,pitemrevision,pstructure_revisions,pPSBOMViewRevision,ppsoccurrence,PWORKSPACEOBJECT t_01 , PITEMREVISION t_02 , PITEM t_03, PWORKSPACEOBJECT pwo, ppom_object,PPOM_APPLICATION_OBJECT t4 "
                       		+ "where pitem.puid=pitemrevision.ritems_tagu and pitemrevision.puid=pstructure_revisions.puid and pPSBOMViewRevision.puid=pvalu_0 and RPARENT_BVRU=pPSBOMViewRevision.puid "
                       		+ "and ( t_02.ritems_tagu = t_03.puid ) AND (t_01.puid = t_02.puid ) and ppsoccurrence.rchild_itemu  = t_02.puid and pwo.puid = pitemrevision.puid "
                       		+ "and pwo.pobject_type  =  'Drawing Item Revision' and pwo.pactive_seq!=0  "
            				+ "and pitem.puid= t4.PUID "
                       		+ "and ppom_object.puid = t_01.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
                       
               strDOCUMNET_SUBTYPE = "select distinct pitem.pitem_id||'|'||pworkspaceobject.pobject_name||'|'||pwgp4_sub_type||'|'||'"+conn.getSiteID()+"'||'|'||pitem.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
               		+ "from pitem, pitemrevision, pworkspaceobject, ppom_object ,PPOM_APPLICATION_OBJECT t4 "
               		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 and pitem.puid= t4.PUID "
               		+ "and pwgp4_sub_type is not null and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
                                 
	         strQryPCN_NonRelated_Items = "SELECT ITEM.PITEM_ID||'|'||ITEM_REV.pitem_revision_id||'|'||replace(replace(PCN_REV.PWGP4_SYNOPSIS,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(WS_OBJ.POBJECT_DESC,CHR(10),' '),CHR(13),' ')||'|'||'0'||'|'||'ALL STATUS IS ALLOWED'||'|'||'"+conn.getSiteID()+"'||'|'||PCN_REV.PUID||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~'"
         			+"FROM PWGP4_PCNREVISION PCN_REV "
         			+"LEFT JOIN PITEMREVISION ITEM_REV ON ITEM_REV.PUID = PCN_REV.PUID "
         			+"LEFT JOIN PITEM ITEM ON ITEM_REV.ritems_tagu = ITEM.puid "
         			+"LEFT JOIN PWORKSPACEOBJECT WS_OBJ ON WS_OBJ.PUID = PCN_REV.PUID "
         			+"LEFT JOIN PPOM_OBJECT P_OBJ ON P_OBJ.PUID = WS_OBJ.PUID "
    				+"LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.PUID = PCN_REV.PUID "
         			+"WHERE WS_OBJ.pactive_seq!=0 AND  (P_OBJ.rowning_siteu is null or P_OBJ.rowning_siteu = '"+owningSitePUID+"' or P_OBJ.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
    				
	         strPCNRelItems = "SELECT ITEM.PITEM_ID||'|'||ITEM_REV.pitem_revision_id||'|'||itype.PTYPE_NAME||'|'||SEC_ITEM.PITEM_ID||'|'||SEC_ITEMREV.PITEM_REVISION_ID||'|'||'0'||'|'||PCN_REV.PUID||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
	         			+"FROM PWGP4_PCNREVISION PCN_REV "
	         			+"LEFT JOIN PITEMREVISION ITEM_REV ON ITEM_REV.PUID = PCN_REV.PUID "
	         			+"LEFT JOIN PITEM ITEM ON ITEM_REV.ritems_tagu = ITEM.puid "
	         			+"LEFT JOIN PWORKSPACEOBJECT WS_OBJ ON WS_OBJ.PUID = PCN_REV.PUID  "
	         			+"LEFT JOIN PPOM_OBJECT P_OBJ ON P_OBJ.PUID = WS_OBJ.PUID "
	    				+"LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.PUID = PCN_REV.PUID "
	         			+"LEFT JOIN PIMANRELATION IREL ON IREL.RPRIMARY_OBJECTU = PCN_REV.PUID "
	         			+"LEFT JOIN PITEMREVISION SEC_ITEMREV ON SEC_ITEMREV.puid=IREL.RSECONDARY_OBJECTU "
	         			+"LEFT JOIN PITEM SEC_ITEM ON SEC_ITEMREV.ritems_tagu=SEC_ITEM.PUID OR SEC_ITEM.PUID = IREL.RSECONDARY_OBJECTU "
	         			+"left join pimantype itype ON itype.puid=irel.rrelation_typeu "
	         			+"WHERE itype.PTYPE_NAME IN ('CMHasSolutionItem','CMHasImpactedItem','CMHasProblemItem') and WS_OBJ.pactive_seq!=0 AND  (P_OBJ.rowning_siteu is null or P_OBJ.rowning_siteu = '"+owningSitePUID+"' or P_OBJ.rowning_siteu='AAAAAAAAAAAAAA')  AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') "
	         			+"ORDER BY ITEM.PITEM_ID,ITEM_REV.pitem_revision_id,itype.PTYPE_NAME ";     	
	         	
	          strETO_ALL_ITEMS = "select t_item.PITEM_ID||'|'||t_itemrev.PITEM_REVISION_ID||'|'||t_wo2.POBJECT_NAME||'|'||t_etorev.PWGP4_ETO_WEIR_ORDER||'|'||t_wo.POBJECT_NAME||'|'||''||'|'||''||'|'||''||'|'||'0'||'|'||'COMMENTS'||'|'||'"+conn.getSiteID()+"'||'|'||t_itemrev.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
	                     +" from PWGP4_ETOREVISION t_etorev"
	                     +" left join pitemrevision t_itemrev on t_itemrev.puid=t_etorev.puid"
	                     +" left join pitem t_item on t_itemrev.ritems_tagu=t_item.PUID"
	                     +" left join pworkspaceobject t_wo on t_wo.puid=t_etorev.RWGP4_ETO_CUSTOMERU"
	                     +" left join pworkspaceobject t_wo2 on t_wo2.puid=t_etorev.PUID"
	                     +" left join ppom_object t_ppom on t_ppom.puid = t_wo2.puid"
	    				 +" LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.PUID = t_etorev.PUID "
	                     +" where t_wo2.pactive_seq!=0 and (t_ppom.rowning_siteu is null or t_ppom.rowning_siteu ='"+owningSitePUID+"' or t_ppom.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	             
	          strETO_RELATED_ITEMS = "select distinct t_item.pitem_id||'|'||t_itemrev.pitem_revision_id||'|'||t_wo2.pobject_name||'|'||t_etorev.pwgp4_eto_weir_order||'|'||t_wo.POBJECT_NAME||'|'||itype.ptype_name||'|'||t_item2.pitem_id||'|'||t_itemrev2.pitem_revision_id||'|'||'0'||'|'||'COMMENTS'||'|'||'"+conn.getSiteID()+"'||'|'||t_itemrev.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
	            		 +"  from  PWGP4_ETORevision t_etorev"
	            		 +"  left join pitemrevision t_itemrev on t_itemrev.puid=t_etorev.puid"
	            		 +"  left join pitem t_item on t_itemrev.ritems_tagu=t_item.PUID"
	            		 +"  left join pworkspaceobject t_wo on t_wo.puid=t_etorev.RWGP4_ETO_CUSTOMERU"
	            		 +"  left join pworkspaceobject t_wo2 on t_wo2.puid=t_etorev.PUID"
	            		 +"  left join ppom_object t_ppom on t_ppom.puid = t_wo2.puid"
	    				 +"  LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.PUID = t_etorev.PUID "
	            		 +"  left join pimanrelation irel on irel.rprimary_objectu = t_etorev.puid"
	            		 +"  left join  pitemrevision t_itemrev2 on t_itemrev2.puid=irel.rsecondary_objectu"
	            		 +"  left join pitem t_item2 on t_item2.puid=irel.rsecondary_objectu or t_itemrev2.ritems_tagu=t_item2.PUID"
	            		 +"  left join pimantype itype on itype.puid=irel.rrelation_typeu"
	            		 +"  where t_wo2.pactive_seq!=0 and itype.ptype_name in ('WGP4_has_ga', 'WGP4_has_doc', 'WGP4_has_routing','WGP4_eto_references') and (t_ppom.rowning_siteu is null or t_ppom.rowning_siteu ='"+owningSitePUID+"' or t_ppom.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	    				 
	           strETO_ORDER_PARTS = "select distinct t_item.pitem_id||'|'||t_itemrev.pitem_revision_id||'|'||t_wo2.pobject_name||'|'||t_etorev.pwgp4_eto_weir_order||'|'||t_wo.POBJECT_NAME||'|'||'order-parts'||'|'||t_item2.pitem_id||'|'||t_itemrev2.pitem_revision_id||'|'||'0'||'|'||'COMMENTS'||'|'||'"+conn.getSiteID()+"'||'|'||t_itemrev.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
	            		 +" from  PWGP4_ETORevision t_etorev"
	            		 +" left join pitemrevision t_itemrev on t_itemrev.puid=t_etorev.puid"
	            		 +" left join pitem t_item on t_itemrev.ritems_tagu=t_item.PUID"
	            		 +" left join pworkspaceobject t_wo on t_wo.puid=t_etorev.RWGP4_ETO_CUSTOMERU"
	            		 +" left join pworkspaceobject t_wo2 on t_wo2.puid=t_etorev.PUID"
	            		 +" left join ppom_object t_ppom on t_ppom.puid = t_wo2.puid"
	    				 +" LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.PUID = t_etorev.PUID "
	            		 +" left join pstructure_revisions t_strrev on t_itemrev.puid=t_strrev.puid"
	            		 +" left join pPSBOMViewRevision t_psbomview on t_psbomview.puid=t_strrev.pvalu_0"
	            		 +" left join ppsoccurrence t_psoccurence on t_psoccurence.RPARENT_BVRU=t_psbomview.puid "
	            		 +" left join  pitemrevision t_itemrev2 on t_psoccurence.rchild_itemu  = t_itemrev2.puid"
	            		 +" left join pitem t_item2 on t_itemrev2.ritems_tagu=t_item2.PUID"
	            		 +" where t_wo2.pactive_seq!=0 AND t_item2.pitem_id IS NOT NULL AND (t_ppom.rowning_siteu is null or t_ppom.rowning_siteu ='"+owningSitePUID+"' or t_ppom.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	             
	           strLEDIRLocal = "select t_03.pitem_id||'|'||t_02.pitem_revision_id||'|'||t_01.pobject_type||'|'||replace(replace(t_01.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'||t_02.pwgp4_WLL||'|'||t_02.pwgp4_weight||'|'||t_02.pwgp4_length||'|'||t_02.pwgp4_width||'|'||t_02.pwgp4_height||'|'||t_02.pwgp4_design_centre||'|'||PRELEASESTATUS.pname||'|'||'"+conn.getSiteID()+"'||'|'||t_02.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'|'||'COMMENTS'||'|'||'0'||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'||TO_CHAR(t_01.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss')||'~~' "
	              		+ "FROM PWORKSPACEOBJECT t_01 , PITEMREVISION t_02 ,PITEM t_03 , PPOM_APPLICATION_OBJECT t4, ppom_object, PRELEASESTATUS,"+PRELEASE_STATUS_LIST_TABNAME+" "
	              		+ "WHERE  ( t_02.ritems_tagu = t_03.puid ) AND (t_01.pactive_seq != 0 ) AND (t_01.puid = t_02.puid ) and (t_01.PUID = t4.PUID) AND PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0 "
	              		+ "and "+PRELEASE_STATUS_LIST_TABNAME+".puid =t_02.puid and (t_01.pobject_type  =  'WGP4_LiftingERevision' or  t_01.pobject_type  =  'WGP4_TransportCRevision') "
	              		+ "and ppom_object.puid = t_01.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	              
	              
	              strLED_IOM = "select pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t2.pitem_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
	              		+ "from pitem, pitemrevision,pworkspaceobject,pimanrelation,pimantype,pitem t2, pworkspaceobject w2, ppom_object,PPOM_APPLICATION_OBJECT t4 "
	              		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
	              		+ "and pimantype.puid=pimanrelation.rrelation_typeu and pitemrevision.puid=rprimary_objectu and pimantype.ptype_name = 'WGP4_Instruction_Document' "
	              		+ "and w2.puid = pimanrelation.rsecondary_objectu and t2.puid = w2.puid and w2.pobject_type = 'Document' and t4.puid=pitem.puid "
	              		+ "and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	              
	              strLED_CERTIFICATE = "select pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t2.pitem_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
	              		+ "from pitem, pitemrevision,pworkspaceobject,pimanrelation,pimantype,pitem t2, pworkspaceobject w2, ppom_object,PPOM_APPLICATION_OBJECT t4 "
	              		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
	              		+ "and pimantype.puid=pimanrelation.rrelation_typeu and pitemrevision.puid=rprimary_objectu and pimantype.ptype_name = 'WGP4_Certificate' "
	              		+ "and w2.puid = pimanrelation.rsecondary_objectu and t2.puid = w2.puid and w2.pobject_type = 'Document' and t4.puid=pitem.puid "
	              		+ "and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	         
	              strLED_SUPPORT_PART = "select pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t2.pitem_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
	              		+ "from pitem, pitemrevision,pworkspaceobject,pimanrelation,pimantype,pitem t2, pworkspaceobject w2, ppom_object,PPOM_APPLICATION_OBJECT t4 "
	              		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
	              		+ "and pimantype.puid=pimanrelation.rrelation_typeu and pitemrevision.puid=rprimary_objectu and pimantype.ptype_name = 'WGP4_Components' and "
	              		+ "w2.puid = pimanrelation.rsecondary_objectu and t2.puid = w2.puid  and t4.puid=pitem.puid  "
	              		+ "and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	         
	              strLED_SUPPORT_PRODUCT = "select pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t2.pitem_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
	              		+ "from pitem, pitemrevision,pworkspaceobject,pimanrelation,pimantype,pitem t2, pworkspaceobject w2, ppom_object,PPOM_APPLICATION_OBJECT t4 "
	              		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
	              		+ "and pimantype.puid=pimanrelation.rrelation_typeu and pitemrevision.puid=rprimary_objectu and pimantype.ptype_name = 'WGP4_Pumps' and w2.puid = pimanrelation.rsecondary_objectu "
	              		+ "and t2.puid = w2.puid  and t4.puid=pitem.puid "
	              		+ "and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	              strDocumentCategory = "SELECT PDOC.PUID||'|'||T1.PITEM_ID||'|'||PWGP4_PRIMARY_CATEGORY||'|'||PWGP4_SECONDARY_CATEGORY||'|'||PWGP4_TERTIARY_CATEGORY||'~~' as result "
	  					+ "FROM PDOCUMENT PDOC "
	  					+ "LEFT JOIN PITEM T1 ON T1.PUID=PDOC.PUID "
	  					+ "LEFT JOIN PWORKSPACEOBJECT T2 on  T2.puid =T1.PUID "
	  					+ "LEFT JOIN ppom_object on ppom_object.puid = T2.puid "
	  					+ "LEFT JOIN PPOM_APPLICATION_OBJECT T3 on (T3.PUID = T2.PUID) "
	  					+ "WHERE T2.pactive_seq!=0  AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='null' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') "
	  					+ "AND (PDOC.PWGP4_PRIMARY_CATEGORY IS NOT null OR PDOC.PWGP4_SECONDARY_CATEGORY IS NOT null OR PDOC.PWGP4_TERTIARY_CATEGORY IS NOT null) AND (T3.plast_mod_date >= TO_DATE('2019/02/26', 'YYYY/MM/DD HH24:MI:SS'))";
	              strDocumentName = "SELECT pwo.puid||'|'||pwo.POBJECT_NAME||'|'||'"+conn.getSiteID()+"'||'~~' as result from pworkspaceobject pwo "  
	            		+ "LEFT JOIN ppom_object on ppom_object.puid = pwo.puid "
	            		+ "LEFT JOIN PPOM_APPLICATION_OBJECT T1 on (T1.PUID = pwo.PUID) "
	            		+ "where pwo.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') "
	            		+ "AND pwo.pobject_type= 'DocumentRevision' AND upper(pwo.POBJECT_NAME) like '%IOM%' AND T1.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
	            
								
        }
        else
        {
        	
        	
        	 //Change in delta
        	 strIRLocal = "SELECT t3.pitem_id||'|'||t2.pitem_revision_id||'|'||t1.pobject_type||'|'||replace(replace(t1.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_NAME,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_DESCRIPTION,CHR(10),' '),CHR(13),' ')||'|'||t2.PWGP4_DESIGN_CENTRE||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'|| TO_CHAR(t1.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss') ||'|'||PRELEASESTATUS.pname||'|'||t2.PWGP4_LENGTH||'|'||t2.PWGP4_WIDTH||'|'||t2.PWGP4_HEIGHT||'|'||t2.PWGP4_WEIGHT||'|'||''||'|'||t2.PWGP4_MATERIAL_CODE||'|'||t2.PWGP4_T4S_ENABLED||'|'||'0'||'|'||''||'|'||'"+conn.getSiteID()+"'||'|'||t2.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'|'||replace(t2.PWGP4_T4S_MMSTATUS,'|','#')||'|'||replace(t2.PWGP4_T4S_DIRSTATUS,'|','#')||'~~' as result "
        			 +" from pitemrevision t2"
        			 +" LEFT JOIN pitem t3 on  t2.ritems_tagu = t3.puid"
        			 +" LEFT JOIN pworkspaceobject t1 on  t1.puid =t2.puid"
		        	 +" LEFT JOIN PPOM_APPLICATION_OBJECT t4 on (t1.PUID = t4.PUID)"
		        	 +" LEFT JOIN "+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = t2.puid"
		        	 +" LEFT JOIN PRELEASESTATUS on PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
		        	 +" LEFT JOIN ppom_object on ppom_object.puid = t1.puid"
		        	 +" WHERE t1.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
        	 
        	   //CHNAGE IN DELTA ADDED pdataset.puid INSTEAD OF T2.PUID 
              strDatasetLocal =  "  SELECT t1.pitem_id||'|'||t2.pitem_revision_id||'|'||wo2.pobject_type||'|'||wo3.pobject_name||'|'||PDATASETTYPE.pdatasettype_name||'|'||replace(replace(wo3.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'|| to_char(t4.pcreation_date,'YYYY-MM-DD hh:mm:ss')||'|'||PRELEASESTATUS.pname||'|'|| to_char(wo3.pdate_released,'YYYY-MM-DD hh:mm:ss')||'|'||'0'||'|'||'COMMENTS'||'|'||'0'||'|'||'0'||'|'||'"+conn.getSiteID()+"'||'|'||pdataset.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
					              +" FROM pitemrevision t2"
					              +" LEFT JOIN pitem t1 ON t2.ritems_tagu = t1.puid"
					              +" LEFT JOIN pworkspaceobject wo2 ON wo2.puid = t2.puid"
					              +" LEFT JOIN ppom_object ON ppom_object.puid = t1.puid"
					              +" LEFT JOIN pimanrelation ON t2.puid=pimanrelation.rprimary_objectu"
					              +" LEFT JOIN pdataset ON pdataset.puid = pimanrelation.rsecondary_objectu"
					              +" LEFT JOIN pimantype ON pimantype.puid=pimanrelation.rrelation_typeu"
					              +" LEFT JOIN pdatasettype on pdatasettype.puid = pdataset.rdataset_typeu"
					              +" LEFT JOIN pworkspaceobject wo3 ON pdataset.puid = wo3.puid"
					              +" LEFT JOIN "+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = pdataset.puid"
					              +" LEFT JOIN PRELEASESTATUS ON PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
					              +" LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.puid = pdataset.puid"
					              +" WHERE wo2.pactive_seq !=0 AND PDATASETTYPE.pdatasettype_name is not NULL AND pimantype.ptype_name = 'IMAN_specification' AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
					              
             
              strDatasetLocalFiles = "select t1.pitem_id||'|'||t2.pitem_revision_id||'|'||wo1.pobject_type||'|'||wo3.pobject_name||'|'||PDATASETTYPE.pdatasettype_name||'|'||PIMANFILE.pfile_name||'|'||'0'||'|'||'COMMENTS'||'|'||'"+conn.getSiteID()+"'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'|'||t2.puid||'|'||pdataset.puid||'~~' as result "
              		+ "from pitem t1, pitemrevision t2, pworkspaceobject wo1, pimantype, ppom_object, pimanrelation, pworkspaceobject wo3, PPOM_APPLICATION_OBJECT t4, pdataset, PDATASETTYPE, PIMANFILE, PIMANVOLUME, pref_list_0 "
              		+ "where wo1.puid = t2.puid and t2.ritems_tagu = t1.puid and pimantype.puid=pimanrelation.rrelation_typeu and pimantype.ptype_name = 'IMAN_specification' and pdatasettype.puid = pdataset.rdataset_typeu and pdataset.puid = pimanrelation.rsecondary_objectu and pdataset.puid = wo3.puid and t2.puid=pimanrelation.rprimary_objectu and t4.puid = pdataset.puid and pdataset.puid = pimanrelation.rsecondary_objectu and pimanfile.puid=pref_list_0.PVALU_0 and PIMANFILE.RVOLUME_TAGU=PIMANVOLUME.puid and "
              		+ "pimanrelation.RSECONDARY_OBJECTU=pref_list_0.puid and (PDATASETTYPE.pdatasettype_name = 'Non DetailedPDF' or PDATASETTYPE.pdatasettype_name = 'Tech Rebuild CenterPDF' or PDATASETTYPE.pdatasettype_name = 'Zip' or PDATASETTYPE.pdatasettype_name = 'MISC')  and (LOWER(PIMANFILE.pfile_name) like '%.pdf' or LOWER(PIMANFILE.pfile_name) like '%.skp' or LOWER(PIMANFILE.pfile_name) like '%.stp') "
              		+ "and ppom_object.puid = wo1.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')" ;
              //Change in delta
              strPHYSICAL_FILES = "select t1.pitem_id||'|'||t2.pitem_revision_id||'|'||wo1.pobject_type||'|'||wo3.pobject_name||'|'||PDATASETTYPE.pdatasettype_name, pimanvolume.pwnt_path_name||'/'||PIMANFILE.psd_path_name||'/'||PIMANFILE.pfile_name as result "
              		+ "from pitem t1, pitemrevision t2, pworkspaceobject wo1, ppom_object, pimantype, pimanrelation, pworkspaceobject wo3, PPOM_APPLICATION_OBJECT t4, pdataset, PDATASETTYPE, PIMANFILE,PIMANVOLUME,pref_list_0 "
              		+ "where wo1.puid = t1.puid and t2.ritems_tagu = t1.puid and pimantype.puid=pimanrelation.rrelation_typeu and pimantype.ptype_name = 'IMAN_specification' and pdatasettype.puid = pdataset.rdataset_typeu and "
              		+ "pdataset.puid = pimanrelation.rsecondary_objectu and pdataset.puid = wo3.puid and t2.puid=pimanrelation.rprimary_objectu and t4.puid = pdataset.puid "
              		+ "and pdataset.puid = pimanrelation.rsecondary_objectu and pimanfile.puid=pref_list_0.PVALU_0 and PIMANFILE.RVOLUME_TAGU=PIMANVOLUME.puid "
              		+ "and pimanrelation.RSECONDARY_OBJECTU=pref_list_0.puid and (PDATASETTYPE.pdatasettype_name = 'Tech Rebuild CenterPDF' or PDATASETTYPE.pdatasettype_name = 'Non DetailedPDF' or PDATASETTYPE.pdatasettype_name = 'Zip' or PDATASETTYPE.pdatasettype_name = 'MISC') and (LOWER(PIMANFILE.pfile_name) like '%.pdf' or LOWER(PIMANFILE.pfile_name) like '%.skp' or LOWER(PIMANFILE.pfile_name) like '%.stp') "
              		+ "and ppom_object.puid = wo1.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')" ;
            //Change in delta
              strIRDocRefrenceLocal = "select pt1.pitem_id||'|'||pt2.pitem_revision_id||'|'||pwo.pobject_type||'|'||ct1.pitem_id||'|'||ct2.pitem_revision_id||'|'||cwo.POBJECT_NAME||'|'||'"+conn.getSiteID()+"'||'|'||pt2.puid||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
            		 + " FROM pitemrevision pt2"
            		 + " LEFT JOIN pitem pt1 ON pt2.ritems_tagu = pt1.puid"
		             + " LEFT JOIN pimanrelation irel ON irel.rprimary_objectu = pt2.puid "
		             + " LEFT JOIN pitemrevision ct2 ON irel.rsecondary_objectu = ct2.puid"
		             + " LEFT JOIN pitem ct1 ON ct2.ritems_tagu = ct1.puid OR ct1.puid = irel.rsecondary_objectu "
		             + " LEFT JOIN pimantype itype ON itype.puid=irel.rrelation_typeu"
		             + " LEFT JOIN pworkspaceobject pwo ON pwo.puid = pt2.puid"
		             + " LEFT JOIN pworkspaceobject cwo ON  cwo.puid =  ct1.puid "
		             + " LEFT JOIN ppom_object ON ppom_object.puid = pwo.puid "
		             + " WHERE pwo.pactive_seq !=0 AND itype.ptype_name = 'IMAN_reference' AND cwo.pobject_type IN ('Document','Drawing Item') AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')" ;
		              
             
              strALIAS_ALTERNATE =  "select distinct t_01.PITEM_ID||'|'||t_02.PIDFR_ID ||'|'||t_07.PIDFR_ID||'|'||t_01.pwgp4_item_id_legacy||'|'||t_01.pwgp4_drawing_id_legacy ||'|'||'"+conn.getSiteID()+"'||'|'||t_01.PUID||'|'||'111111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
 		             + "from PITEM t_01" 
 		             + " left outer join PIDENTIFIER t_02 on t_01.puid = t_02.raltid_ofu" 
 		             + " left outer join PWORKSPACEOBJECT t_03 on t_03.PUID=t_01.puid"
 		             + " left outer join ppom_object t_05 on t_05.puid=t_03.puid"
 		             + " left outer join PIMANRELATION t_06 on  t_01.puid = t_06.rprimary_objectu  and t_06.rrelation_typeu  in (select PUID from PIMANTYPE where PTYPE_NAME='IMAN_aliasid')"
 		             + " left outer join PIDENTIFIER t_07 on  t_06.rsecondary_objectu = t_07.puid"
 		             + " where (t_02.PIDFR_ID is not null or t_07.PIDFR_ID is not null or t_01.pwgp4_item_id_legacy is not null or t_01.pwgp4_drawing_id_legacy is not null) and t_03.pactive_seq !=0 and (t_05.rowning_siteu is null or t_05.rowning_siteu ='"+owningSitePUID+"' or t_05.rowning_siteu='AAAAAAAAAAAAAA')";
             
              strDRWLocal = "select distinct pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t_03.pitem_id||'|'||t_02.pitem_revision_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
              		+ "from pitem,pitemrevision,pstructure_revisions,pPSBOMViewRevision,ppsoccurrence,PWORKSPACEOBJECT t_01 , PITEMREVISION t_02 , PITEM t_03, PWORKSPACEOBJECT pwo, ppom_object "
              		+ "where pitem.puid=pitemrevision.ritems_tagu and pitemrevision.puid=pstructure_revisions.puid and pPSBOMViewRevision.puid=pvalu_0 and RPARENT_BVRU=pPSBOMViewRevision.puid "
              		+ "and ( t_02.ritems_tagu = t_03.puid ) AND (t_01.puid = t_02.puid ) and ppsoccurrence.rchild_itemu  = t_02.puid and pwo.puid = pitemrevision.puid "
              		+ "and pwo.pobject_type  =  'Drawing Item Revision'  and pwo.pactive_seq!=0  "
              		+ "and ppom_object.puid = t_01.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
              
              strDOCUMNET_SUBTYPE = "select distinct pitem.pitem_id||'|'||pworkspaceobject.pobject_name||'|'||pwgp4_sub_type||'|'||'"+conn.getSiteID()+"'||'|'||pitem.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
              		+ "from pitem, pitemrevision, pworkspaceobject, ppom_object  "
              		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
              		+ "and pwgp4_sub_type is not null and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
             
        	strQryPCN_NonRelated_Items = "SELECT ITEM.PITEM_ID||'|'||ITEM_REV.pitem_revision_id||'|'||replace(replace(PCN_REV.PWGP4_SYNOPSIS,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(WS_OBJ.POBJECT_DESC,CHR(10),' '),CHR(13),' ')||'|'||'0'||'|'||'ALL STATUS IS ALLOWED'||'|'||'"+conn.getSiteID()+"'||'|'||PCN_REV.PUID||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~'"
        			+"FROM PWGP4_PCNREVISION PCN_REV "
        			+"LEFT JOIN PITEMREVISION ITEM_REV ON ITEM_REV.PUID = PCN_REV.PUID "
        			+"LEFT JOIN PITEM ITEM ON ITEM_REV.ritems_tagu = ITEM.puid "
        			+"LEFT JOIN PWORKSPACEOBJECT WS_OBJ ON WS_OBJ.PUID = PCN_REV.PUID "
        			+"LEFT JOIN PPOM_OBJECT P_OBJ ON P_OBJ.PUID = WS_OBJ.PUID "
        			+"WHERE WS_OBJ.pactive_seq!=0 AND  (P_OBJ.rowning_siteu is null or P_OBJ.rowning_siteu = '"+owningSitePUID+"' or P_OBJ.rowning_siteu='AAAAAAAAAAAAAA')";
        	strPCNRelItems = "SELECT ITEM.PITEM_ID||'|'||ITEM_REV.pitem_revision_id||'|'||itype.PTYPE_NAME||'|'||SEC_ITEM.PITEM_ID||'|'||SEC_ITEMREV.PITEM_REVISION_ID||'|'||'0'||'|'||PCN_REV.PUID||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
        			+"FROM PWGP4_PCNREVISION PCN_REV "
        			+"LEFT JOIN PITEMREVISION ITEM_REV ON ITEM_REV.PUID = PCN_REV.PUID "
        			+"LEFT JOIN PITEM ITEM ON ITEM_REV.ritems_tagu = ITEM.puid "
        			+"LEFT JOIN PWORKSPACEOBJECT WS_OBJ ON WS_OBJ.PUID = PCN_REV.PUID  "
        			+"LEFT JOIN PPOM_OBJECT P_OBJ ON P_OBJ.PUID = WS_OBJ.PUID "
        			+"LEFT JOIN PIMANRELATION IREL ON IREL.RPRIMARY_OBJECTU = PCN_REV.PUID "
        			+"LEFT JOIN PITEMREVISION SEC_ITEMREV ON SEC_ITEMREV.puid=IREL.RSECONDARY_OBJECTU "
        			+"LEFT JOIN PITEM SEC_ITEM ON SEC_ITEMREV.ritems_tagu=SEC_ITEM.PUID OR SEC_ITEM.PUID = IREL.RSECONDARY_OBJECTU "
        			+"left join pimantype itype ON itype.puid=irel.rrelation_typeu "
        			+"WHERE itype.PTYPE_NAME IN ('CMHasSolutionItem','CMHasImpactedItem','CMHasProblemItem') and WS_OBJ.pactive_seq!=0 AND  (P_OBJ.rowning_siteu is null or P_OBJ.rowning_siteu = '"+owningSitePUID+"' or P_OBJ.rowning_siteu='AAAAAAAAAAAAAA') "
        			+"ORDER BY ITEM.PITEM_ID,ITEM_REV.pitem_revision_id,itype.PTYPE_NAME ";
                   
            
            strETO_ALL_ITEMS = "select t_item.PITEM_ID||'|'||t_itemrev.PITEM_REVISION_ID||'|'||t_wo2.POBJECT_NAME||'|'||t_etorev.PWGP4_ETO_WEIR_ORDER||'|'||t_wo.POBJECT_NAME||'|'||''||'|'||''||'|'||''||'|'||'0'||'|'||'COMMENTS'||'|'||'"+conn.getSiteID()+"'||'|'||t_itemrev.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
                    +" from PWGP4_ETOREVISION t_etorev"
                    +" left join pitemrevision t_itemrev on t_itemrev.puid=t_etorev.puid"
                    +" left join pitem t_item on t_itemrev.ritems_tagu=t_item.PUID"
                    +" left join pworkspaceobject t_wo on t_wo.puid=t_etorev.RWGP4_ETO_CUSTOMERU"
                    +" left join pworkspaceobject t_wo2 on t_wo2.puid=t_etorev.PUID"
                    +" left join ppom_object t_ppom on t_ppom.puid = t_wo2.puid"
                    +" where t_wo2.pactive_seq!=0 and (t_ppom.rowning_siteu is null or t_ppom.rowning_siteu ='"+owningSitePUID+"' or t_ppom.rowning_siteu='AAAAAAAAAAAAAA')";
            
            strETO_RELATED_ITEMS = "select distinct t_item.pitem_id||'|'||t_itemrev.pitem_revision_id||'|'||t_wo2.pobject_name||'|'||t_etorev.pwgp4_eto_weir_order||'|'||t_wo.POBJECT_NAME||'|'||itype.ptype_name||'|'||t_item2.pitem_id||'|'||t_itemrev2.pitem_revision_id||'|'||'0'||'|'||'COMMENTS'||'|'||'"+conn.getSiteID()+"'||'|'||t_itemrev.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
           		 +"  from  PWGP4_ETORevision t_etorev"
           		 +"  left join pitemrevision t_itemrev on t_itemrev.puid=t_etorev.puid"
           		 +"  left join pitem t_item on t_itemrev.ritems_tagu=t_item.PUID"
           		 +"  left join pworkspaceobject t_wo on t_wo.puid=t_etorev.RWGP4_ETO_CUSTOMERU"
           		 +"  left join pworkspaceobject t_wo2 on t_wo2.puid=t_etorev.PUID"
           		 +"  left join ppom_object t_ppom on t_ppom.puid = t_wo2.puid"
           		 +"  left join pimanrelation irel on irel.rprimary_objectu = t_etorev.puid"
           		 +"  left join  pitemrevision t_itemrev2 on t_itemrev2.puid=irel.rsecondary_objectu"
           		 +"  left join pitem t_item2 on t_item2.puid=irel.rsecondary_objectu or t_itemrev2.ritems_tagu=t_item2.PUID"
           		 +"  left join pimantype itype on itype.puid=irel.rrelation_typeu"
           		 +"  where t_wo2.pactive_seq!=0 and itype.ptype_name in ('WGP4_has_ga', 'WGP4_has_doc', 'WGP4_has_routing','WGP4_eto_references') and (t_ppom.rowning_siteu is null or t_ppom.rowning_siteu ='"+owningSitePUID+"' or t_ppom.rowning_siteu='AAAAAAAAAAAAAA')";
            strETO_ORDER_PARTS = "select distinct t_item.pitem_id||'|'||t_itemrev.pitem_revision_id||'|'||t_wo2.pobject_name||'|'||t_etorev.pwgp4_eto_weir_order||'|'||t_wo.POBJECT_NAME||'|'||'order-parts'||'|'||t_item2.pitem_id||'|'||t_itemrev2.pitem_revision_id||'|'||'0'||'|'||'COMMENTS'||'|'||'"+conn.getSiteID()+"'||'|'||t_itemrev.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
           		 +" from  PWGP4_ETORevision t_etorev"
           		 +" left join pitemrevision t_itemrev on t_itemrev.puid=t_etorev.puid"
           		 +" left join pitem t_item on t_itemrev.ritems_tagu=t_item.PUID"
           		 +" left join pworkspaceobject t_wo on t_wo.puid=t_etorev.RWGP4_ETO_CUSTOMERU"
           		 +" left join pworkspaceobject t_wo2 on t_wo2.puid=t_etorev.PUID"
           		 +" left join ppom_object t_ppom on t_ppom.puid = t_wo2.puid"
           		 +" left join pstructure_revisions t_strrev on t_itemrev.puid=t_strrev.puid"
           		 +" left join pPSBOMViewRevision t_psbomview on t_psbomview.puid=t_strrev.pvalu_0"
           		 +" left join ppsoccurrence t_psoccurence on t_psoccurence.RPARENT_BVRU=t_psbomview.puid "
           		 +" left join  pitemrevision t_itemrev2 on t_psoccurence.rchild_itemu  = t_itemrev2.puid"
           		 +" left join pitem t_item2 on t_itemrev2.ritems_tagu=t_item2.PUID"
           		 +" where t_wo2.pactive_seq!=0 AND t_item2.pitem_id IS NOT NULL AND (t_ppom.rowning_siteu is null or t_ppom.rowning_siteu ='"+owningSitePUID+"' or t_ppom.rowning_siteu='AAAAAAAAAAAAAA') ";
            
             strLEDIRLocal = "select t_03.pitem_id||'|'||t_02.pitem_revision_id||'|'||t_01.pobject_type||'|'||replace(replace(t_01.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'||t_02.pwgp4_WLL||'|'||t_02.pwgp4_weight||'|'||t_02.pwgp4_length||'|'||t_02.pwgp4_width||'|'||t_02.pwgp4_height||'|'||t_02.pwgp4_design_centre||'|'||PRELEASESTATUS.pname||'|'||'"+conn.getSiteID()+"'||'|'||t_02.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'|'||'COMMENTS'||'|'||'0'||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'||TO_CHAR(t_01.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss')||'~~' "
             		+ "FROM PWORKSPACEOBJECT t_01 , PITEMREVISION t_02 ,PITEM t_03 , PPOM_APPLICATION_OBJECT t4, ppom_object, PRELEASESTATUS,"+PRELEASE_STATUS_LIST_TABNAME+" "
             		+ "WHERE  ( t_02.ritems_tagu = t_03.puid ) AND (t_01.pactive_seq != 0 ) AND (t_01.puid = t_02.puid ) and (t_01.PUID = t4.PUID) AND PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0 "
             		+ "and "+PRELEASE_STATUS_LIST_TABNAME+".puid =t_02.puid and (t_01.pobject_type  =  'WGP4_LiftingERevision' or  t_01.pobject_type  =  'WGP4_TransportCRevision') "
             				+ "and ppom_object.puid = t_01.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
              
             strLED_IOM = "select pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t2.pitem_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
             		+ "from pitem, pitemrevision,pworkspaceobject,pimanrelation,pimantype,pitem t2, pworkspaceobject w2, ppom_object "
             		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
             		+ "and pimantype.puid=pimanrelation.rrelation_typeu and pitemrevision.puid=rprimary_objectu and pimantype.ptype_name = 'WGP4_Instruction_Document' "
             		+ "and w2.puid = pimanrelation.rsecondary_objectu and t2.puid = w2.puid and w2.pobject_type = 'Document' "
             		+ "and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
             
             strLED_CERTIFICATE = "select pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t2.pitem_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
             		+ "from pitem, pitemrevision,pworkspaceobject,pimanrelation,pimantype,pitem t2, pworkspaceobject w2, ppom_object "
             		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
             		+ "and pimantype.puid=pimanrelation.rrelation_typeu and pitemrevision.puid=rprimary_objectu and pimantype.ptype_name = 'WGP4_Certificate' "
             		+ "and w2.puid = pimanrelation.rsecondary_objectu and t2.puid = w2.puid and w2.pobject_type = 'Document' "
             		+ "and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
        
             strLED_SUPPORT_PART = "select pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t2.pitem_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
             		+ "from pitem, pitemrevision,pworkspaceobject,pimanrelation,pimantype,pitem t2, pworkspaceobject w2, ppom_object "
             		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
             		+ "and pimantype.puid=pimanrelation.rrelation_typeu and pitemrevision.puid=rprimary_objectu and pimantype.ptype_name = 'WGP4_Components' and "
             		+ "w2.puid = pimanrelation.rsecondary_objectu and t2.puid = w2.puid "
             		+ "and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
        
             strLED_SUPPORT_PRODUCT = "select pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t2.pitem_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
             		+ "from pitem, pitemrevision,pworkspaceobject,pimanrelation,pimantype,pitem t2, pworkspaceobject w2, ppom_object "
             		+ "where pworkspaceobject.puid = pitemrevision.puid and pitem.puid = pitemrevision.ritems_tagu and pworkspaceobject.pactive_seq != 0 "
             		+ "and pimantype.puid=pimanrelation.rrelation_typeu and pitemrevision.puid=rprimary_objectu and pimantype.ptype_name = 'WGP4_Pumps' and w2.puid = pimanrelation.rsecondary_objectu "
             		+ "and t2.puid = w2.puid "
             		+ "and ppom_object.puid = pworkspaceobject.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA')";
        
            strDocumentCategory = "SELECT PDOC.PUID||'|'||T1.PITEM_ID||'|'||PWGP4_PRIMARY_CATEGORY||'|'||PWGP4_SECONDARY_CATEGORY||'|'||PWGP4_TERTIARY_CATEGORY||'~~' as result " 
					+"FROM PDOCUMENT PDOC "
					+"LEFT JOIN PITEM T1 ON T1.PUID=PDOC.PUID "
					+"LEFT JOIN PWORKSPACEOBJECT T2 on  T2.puid =T1.PUID " 
					+"LEFT JOIN ppom_object on ppom_object.puid = T2.puid "
					+"WHERE T2.pactive_seq!=0  AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='null' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') "
					+"AND (PDOC.PWGP4_PRIMARY_CATEGORY IS NOT null OR PDOC.PWGP4_SECONDARY_CATEGORY IS NOT null OR PDOC.PWGP4_TERTIARY_CATEGORY IS NOT null)";
            
            strDocumentName = "SELECT pwo.puid||'|'||pwo.POBJECT_NAME||'|'||'"+conn.getSiteID()+"'||'~~' as result from pworkspaceobject pwo "  
            		+ "LEFT JOIN ppom_object on ppom_object.puid = pwo.puid "
            		+ "where pwo.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') "
            		+ "AND pwo.pobject_type= 'DocumentRevision' AND upper(pwo.POBJECT_NAME) like '%IOM%'";
         
        }
        
        String[][] _qry_args = {
        	      /*IRLocal*/{strIRLocal,"IRLocal"},
        	      /*DatasetLocal*/{strDatasetLocal,"DatasetLocal"},
        	      ///*DatasetLocalFiles*/{"select t1.pitem_id||'|'||t2.pitem_revision_id||'|'||wo1.pobject_type||'|'||wo3.pobject_name||'|'||PDATASETTYPE.pdatasettype_name||'|'||PRELEASESTATUS.pname||'|'|| to_char(wo3.pdate_released,'YYYY-MM-DD hh:mm:ss')||'|'|| to_char(t4.pcreation_date,'YYYY-MM-DD hh:mm:ss')||'|'||wo3.pobject_desc||'|'||pimanfile.poriginal_file_name||'~~' as result from pitem t1, pitemrevision t2, pworkspaceobject wo1, pimantype, pimanrelation, pworkspaceobject wo3, PPOM_APPLICATION_OBJECT t4, pdataset, PDATASETTYPE, PRELEASESTATUS, PRELEASE_STATUS_LIST, PIMANFILE, pref_list_0 where wo1.puid = t1.puid and t2.ritems_tagu = t1.puid and pimantype.puid=pimanrelation.rrelation_typeu and pdatasettype.puid = pdataset.rdataset_typeu and pdataset.puid = pimanrelation.rsecondary_objectu and pdataset.puid = wo3.puid and t2.puid=pimanrelation.rprimary_objectu and t4.puid = pdataset.puid and PRELEASESTATUS.puid = PRELEASE_STATUS_LIST.pvalu_0 and PRELEASE_STATUS_LIST.puid = pdataset.puid and pdataset.puid = pimanrelation.rsecondary_objectu and pimanfile.puid=pref_list_0.PVALU_0 and pimanrelation.RSECONDARY_OBJECTU=pref_list_0.puid and (PDATASETTYPE.pdatasettype_name = 'Non DetailedPDF' or PDATASETTYPE.pdatasettype_name = 'Zip' )","DatasetLocalFiles"},
        	      /*DatasetLocalFiles*/{strDatasetLocalFiles,"DatasetLocalFiles"},
        	      /*PHYSICAL_FILES*/{strPHYSICAL_FILES,"NDPDF_Physical_Files_Export"},
        	      /*IRDocRefrenceLocal*/{strIRDocRefrenceLocal,"IRDocRefrenceLocal"},
        	      {strDocumentCategory,"DocumentCategory" },
        	      {strDocumentName,"DocumentName" },
        	      /*ALIAS_ALTERNATE*/{strALIAS_ALTERNATE,"ALIAS_ALTERNATE"},
        	      /*DRWLocal*/{strDRWLocal,"DRWLocal"},
        	    
        	    
        	      /*DOCUMNET_SUBTYPE*/{strDOCUMNET_SUBTYPE,"DOCUMENT_SUBTYPE"},
        	      /*MaterialLocal{strMaterialLocal,"MaterialLocal" },*/

        	      //LED-Start
        	      /*LEDIRLocal*/{strLEDIRLocal,"LEDIRLocal" },
        	      /*LED_ALIAS_ALTERNATE {strLED_ALIAS_ALTERNATE,"LED_ALTERNATE_ALIAS" },*/
        	      /*LED_IOM*/{strLED_IOM,"LED_IOM" },
        	      /*LED_CERTIFICATE*/{strLED_CERTIFICATE,"LED_CERTIFICATE" },
        	      /*LED_SUPPORT_PART*/{strLED_SUPPORT_PART,"LED_SUPPORT_PART" },
        	      /*LED_SUPPORT_PRODUCT*/{strLED_SUPPORT_PRODUCT,"LED_SUPPORT_PRODUCT" },
        	      //LED-END
        	      
        	      /*PCN*/
        	     // /*PCNN PROBLEM ITEMS{strQryPCNProbItems,"PCN_PROBLEM_DATA" },
        	     // /*PCNN solution ITEMS*/{strQryPCNSolutionItems,"PCN_SOLUTION_DATA" },
        	     // /*PCNN Impacted ITEMS*/{strQryPCNImpactedItems,"PCN_IMPACTED_DATA" },
        	      /*PCNN Related ITEMS*/{strPCNRelItems,"PCN_RELATION_DATA" },
        	      /*PCNN empty ITEMS*/{strQryPCN_NonRelated_Items,"PCN_NORELATED_DATA" },
        	      //PCN-END
        	      
        	      //ETO
        	      /*ETO ALL ITEMS*/{strETO_ALL_ITEMS,"ETO_ALL_DATA" },
        	      /*ETO RELATED ITEMS*/{strETO_RELATED_ITEMS,"ETO_RELATION_DATA" },
        	      /*ETO ORDER PARTS*/{strETO_ORDER_PARTS,"ETO_ORDER_PARTS" }
        	      //ETO-END
        	      
        	      
        	      
        	      };

        String outFilePathDir = null;
        if(dDeltaExtraction)
        {
        	outFilePathDir = conn.getOutputFileLocation()+"/DELTA_GPDM_"+conn.getSiteID()+"_EXPORT";
        }
    	else
    	{
    		outFilePathDir = conn.getOutputFileLocation()+"/FULL_GPDM_"+conn.getSiteID()+"_EXPORT";
    	}
        
        for (int i=0;i<_qry_args.length;i++)        
        {
        	
        	File folder = new File(outFilePathDir);
	    	if(!folder.exists()){
	    		folder.mkdir();
	    	}
        	str_outFileLocation = outFilePathDir+"/outGPDM_"+conn.getSiteID()+"_";
        	str_outFileLocation = str_outFileLocation + _qry_args[i][1]+".txt";
        	outfile= new File(str_outFileLocation);
        	
        	try 
        	{
	        	fp = new FileOutputStream(outfile);
	        	if(_qry_args[i][0] != null)
	        	{
	        		DMLogger.log("	Extracting data for : "+_qry_args[i][1]);
	        		DMLogger.log("	Extracting data for : "+_qry_args[i][0]);
	        		stmt1 = connection.createStatement();
	        		//connection.setSchema(conn.getUserID());
	    			if(stmt1 != null)
    				Results = stmt1.executeQuery(_qry_args[i][0]);
	    			
	    			if(_qry_args[i][1].equals("NDPDF_Physical_Files_Export") != true)
					{
	    				while (Results.next()) 
		    			{
	    					fp.write("\n".getBytes());
    						fp.write(Results.getString(1).getBytes());
    
		                }
					}
	        		else
	        		{
	        			while (Results.next()) 
		    			{
	    					intiateFileCopy(Results.getString(2), outFilePathDir );
	    					//System.out.println("Results.getString(2) is "+Results.getString(2)+"outFilePathDir is" +outFilePathDir);
		                }
	        		}
	        	}
	        	DMLogger.log("	Completed.");
        	}
        catch (IOException e1) {
        e1.printStackTrace();
        } finally {
          try {
                  if (fp != null)
                          fp.close();
          } catch (IOException ex) {
                  ex.printStackTrace();
          }
        }
          }
        
        System.out.println("Data Extraction completed.....");
        System.out.println("Zipping is in progress.....");
        zipFolder(outFilePathDir, outFilePathDir+".zip");
        //DeletefolderDump(outFilePathDir);
        System.out.println("completed.");
        System.out.println("Bye.");
        

	}

	
	private static String getsitePUID(String siteID) {
		Statement stmt = null;  
	    TcDBConnection conn = new TcDBConnection();
	    Connection connection = conn.getDBConnection();
	    ResultSet Results = null;
	    String sitePUID = null;
	    
	    String strQry = "select puid from ppom_imc where pname = '"+siteID+"'";
	    
	    try { 
	    	
	    	  stmt = connection.createStatement();  
	    	  //stmt.execute("ALTER SESSION SET CURRENT_SCHEMA=infodba");
	    	  Results = stmt.executeQuery(strQry);
	    	  while (Results.next()) 
  				{
	    		  sitePUID = Results.getString(1);
  				}
	      }  
	      catch (Exception e) {  
	    	  System.err.println("ERROR: Got an exception! ");
	    	  sitePUID = null;
	         e.printStackTrace();  
	      }
	      finally {  
	         if (stmt != null) try { stmt.close(); } catch(Exception e) {}  
	      	}
		return sitePUID;
	}


	private static void DeletefolderDump(String outFilePathDir) {
		// TODO Auto-generated method stub
		File directory = new File(outFilePathDir);
	    
	    if (directory.exists()) {
	        for (File file : directory.listFiles()) {
	            file.delete();
	        }
	        directory.delete();
	    }
	}

	private static void createTimeStampFile(String strTMfilepath) {

		try{

			DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	    	Date date = new Date();
	    	
            String content = dateFormat.format(date).toString();
            File file = new File(strTMfilepath);
                       
            if (!file.exists()) {

            }

            FileWriter fw = new FileWriter(file.getAbsoluteFile());
            BufferedWriter bw = new BufferedWriter(fw);

            bw.write(content);

            bw.close();
        }
        catch(Exception e){
            System.out.println(e);
        }
	}

	private static void intiateFileCopy(String srcFilePath, String strDstPath) {
		// TODO Auto-generated method stub
		
		strDstPath = strDstPath+"/Volume1/"; 
		File folder = new File(strDstPath);
    	if(!folder.exists()){
    		folder.mkdir();
    	}
		Path source = Paths.get(srcFilePath);
		strDstPath = strDstPath + source.getFileName();
		Path destination = Paths.get(strDstPath);
 
		//System.out.println("INFO :"+source);
		//System.out.println("INFO :"+destination);
		
		try {
			Files.copy(source, destination);
		} catch (IOException e) {
			//e.printStackTrace();
			//System.out.println("File not found : " + srcFilePath);
		}
	}
	 static public void zipFolder(String srcFolder, String destZipFile) throws Exception {
		 System.out.println("INFO :"+srcFolder);
		 System.out.println("INFO : ZIP file output location "+destZipFile);
		    ZipOutputStream zip = null;
		    FileOutputStream fileWriter = null;
		    fileWriter = new FileOutputStream(destZipFile);
		    zip = new ZipOutputStream(fileWriter);
		    addFolderToZip("", srcFolder, zip);
		    zip.flush();
		    zip.close();
		  }
		  static private void addFileToZip(String path, String srcFile, ZipOutputStream zip)
		      throws Exception {
		    File folder = new File(srcFile);
		    if (folder.isDirectory()) {
		      addFolderToZip(path, srcFile, zip);
		    } else {
		      byte[] buf = new byte[1024];
		      int len;
		      FileInputStream in = new FileInputStream(srcFile);
		      zip.putNextEntry(new ZipEntry(path + "/" + folder.getName()));
		      while ((len = in.read(buf)) > 0) {
		        zip.write(buf, 0, len);
		      }
		    }
		  }

		  static private void addFolderToZip(String path, String srcFolder, ZipOutputStream zip)
		      throws Exception {
		    File folder = new File(srcFolder);

		    for (String fileName : folder.list()) {
		      if (path.equals("")) {
		        addFileToZip(folder.getName(), srcFolder + "/" + fileName, zip);
		      } else {
		        addFileToZip(path + "/" + folder.getName(), srcFolder + "/" +   fileName, zip);
		      }
		    }
		  }
		  private static  boolean isInteger(String days)
			      throws Exception {
			    boolean isValidInteger = false;
			    try
			    {
			    	Integer.parseInt(days);
			    	isValidInteger = true;
			    }
			    catch (NumberFormatException ex)
			    {
			    	
			    }
			    return isValidInteger;
			  }
		  
		
}
