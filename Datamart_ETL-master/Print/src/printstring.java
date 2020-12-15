
public class printstring {
	public static void main(String[] args) {
		String owningSitePUID=null; 
		TcDBConnection conn = new TcDBConnection();
		String PRELEASE_STATUS_LIST_TABNAME = "PRELEASE_STATUS_LIST_0";
		//String PRELEASE_STATUS_LIST_TABNAME = "PRELEASE_STATUS_LIST";
		String lastExtractionTimeStamp = "TIME";
		// For non-Aus String PRELEASE_STATUS_LIST_TABNAME = "PRELEASE_STATUS_LIST";
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
		    		+" WHEN Dataset.PART_TYPE = 'DocumentRevision' AND Dataset.DATASET_TYPE NOT IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) THEN Options_DocumentPartType.oid"
		    		+" WHEN Dataset.PART_TYPE = 'Document' AND Dataset.DATASET_TYPE NOT IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) THEN Options_DocumentPartType.oid"
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
		    		+" ON Dataset.DATASET_NAME=DESTFILE_PATH.DATASET_NAME and Dataset.PUID=DESTFILE_PATH.PARTREV_PUID and Dataset.DATASET_TYPE=DESTFILE_PATH.DATASET_TYPE "
		    		+" WHERE Dataset.PART_NUMBER=Items.itemid AND Dataset.PART_REVISION=Items.revision and Dataset.SITE=Items.site";
		 
		 
		 String strLoadDatasetPartCentric = "insert into DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT PART_NUMBER, PART_REVISION, PART_TYPE, DATASET_NAME, DATASET_TYPE, DATASET_DESCRIPTION, "
			    	+"DATASET_CREATED_DATE,DATASET_REL_STATUS,DATASET_REL_DATE,STATUS, 'Part Centric',IS_DOCNUMBER,IS_PRT_UNDER_DRW, "
		            +"SITE,PUID,OBJ_TAG,DATE_IMPORTED FROM DMProcessDB.dbo.LOAD_DATASETS "
		            +"WHERE (IS_DOCNUMBER = '0' AND IS_PRT_UNDER_DRW = '0') AND STATUS = '0' AND DATASET_TYPE IN ( 'DetailedPDF', 'Non DetailedPDF', 'MaterialSpecSheet', 'PDF','Tech Rebuild CenterPDF','MISC','Zip' ) "
			    	+"AND PART_TYPE <> 'DocumentRevision' ";
			    	
			    
			  /*  String strLoadDatasetDrawingCentric = "INSERT DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT "
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
				  +"DS.PART_TYPE <> 'DocumentRevision'";*/
			    
			    
			    String strIRLocal = "SELECT t3.pitem_id||'|'||t2.pitem_revision_id||'|'||t1.pobject_type||'|'||replace(replace(t1.pobject_desc,char(10),' '),char(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_NAME,char(10),' '),char(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_DESCRIPTION,char(10),' '),char(13),' ')||'|'||t2.PWGP4_DESIGN_CENTRE||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'|| TO_CHAR(t1.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss') ||'|'||PRELEASESTATUS.pname||'|'||t2.PWGP4_LENGTH||'|'||t2.PWGP4_WIDTH||'|'||t2.PWGP4_HEIGHT||'|'||t2.PWGP4_WEIGHT||'|'||''||'|'||t2.PWGP4_MATERIAL_CODE||'|'||t2.PWGP4_T4S_ENABLED||'|'||'0'||'|'||''||'|'||'"+conn.getSiteID()+"'||'|'||t2.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
	        			 +" from infodba.pitemrevision t2"
	        			 +" LEFT JOIN infodba.pitem t3 on  t2.ritems_tagu = t3.puid"
	        			 +" LEFT JOIN infodba.pworkspaceobject t1 on  t1.puid =t2.puid"
			        	 +" LEFT JOIN infodba.PPOM_APPLICATION_OBJECT t4 on (t1.PUID = t4.PUID)"
			        	 +" LEFT JOIN infodba."+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = t2.puid"
			        	 +" LEFT JOIN infodba.PRELEASESTATUS on PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
			        	 +" LEFT JOIN infodba.ppom_object on ppom_object.puid = t1.puid"
			        	 +" WHERE t1.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"')";
			    
			    
			    String sqrPartDRW = "update DMProcessDB.dbo.LOAD_DATASETS set  IS_PRT_UNDER_DRW = 'Y' where PART_NUMBER  in "
			    		+ "(select distinct ITEM_ID from DMProcessDB.dbo.LOAD_PARTDRAWING PD, DMProcessDB.dbo.LOAD_DATASETS DS "
			    		+ "where DS.PART_NUMBER = PD.ITEM_ID and DS.PART_REVISION = PD.ITEM_REV "
			    		+ "and PD.DRAWING_ID <>'' and PD.DRAWING_REV <>'' and PD.SITE = DS.SITE )";
			    
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
			    
			    
			    String strQuery12 = "INSERT INTO DMProd.dbo.eto_orderparts (etoeid,orderparts_itemid,orderparts_drawingid,site,status,orderparts_iid,puid)"
						+" SELECT DISTINCT t2.eid,t1.related_item,t1.RELATED_ITEM_REVISION,t2.site,t1.STATUS,t3.iid,t1.PUID"
						+" FROM  DMProcessDB.dbo.LOAD_ETO_REV t1, DMProd.dbo.eto_report t2 , DMProd.dbo.items t3"
						+" WHERE t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision and t1.relation_name='order-parts' and t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]";
				
		      	 strIRLocal = "SELECT t3.pitem_id||'|'||t2.pitem_revision_id||'|'||t1.pobject_type||'|'||replace(replace(t1.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_NAME,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_DESCRIPTION,CHR(10),' '),CHR(13),' ')||'|'||t2.PWGP4_DESIGN_CENTRE||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'|| TO_CHAR(t1.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss') ||'|'||PRELEASESTATUS.pname||'|'||t2.PWGP4_LENGTH||'|'||t2.PWGP4_WIDTH||'|'||t2.PWGP4_HEIGHT||'|'||t2.PWGP4_WEIGHT||'|'||''||'|'||t2.PWGP4_MATERIAL_CODE||'|'||t2.PWGP4_T4S_ENABLED||'|'||'0'||'|'||''||'|'||'"+conn.getSiteID()+"'||'|'||t2.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
		       			 +" from infodba.pitemrevision t2"
		       			 +" LEFT JOIN infodba.pitem t3 on  t2.ritems_tagu = t3.puid"
		       			 +" LEFT JOIN infodba.pworkspaceobject t1 on  t1.puid =t2.puid"
		    	        	 +" LEFT JOIN infodba.PPOM_APPLICATION_OBJECT t4 on (t1.PUID = t4.PUID)"
		    	        	 +" LEFT JOIN infodba."+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = t2.puid"
		    	        	 +" LEFT JOIN infodba.PRELEASESTATUS on PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
		    	        	 +" LEFT JOIN infodba.ppom_object on ppom_object.puid = t1.puid"
		    	        	 +" LEFT JOIN infodba.POM_TIMESTAMP timestamp on timestamp.puid = t1.puid"
		    	
		    	        	 +" WHERE t1.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))";
		      	 
	        	 strIRLocal = "SELECT t3.pitem_id||'|'||t2.pitem_revision_id||'|'||t1.pobject_type||'|'||replace(replace(t1.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_NAME,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_DESCRIPTION,CHR(10),' '),CHR(13),' ')||'|'||t2.PWGP4_DESIGN_CENTRE||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'|| TO_CHAR(t1.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss') ||'|'||PRELEASESTATUS.pname||'|'||t2.PWGP4_LENGTH||'|'||t2.PWGP4_WIDTH||'|'||t2.PWGP4_HEIGHT||'|'||t2.PWGP4_WEIGHT||'|'||''||'|'||t2.PWGP4_MATERIAL_CODE||'|'||t2.PWGP4_T4S_ENABLED||'|'||'0'||'|'||''||'|'||'"+conn.getSiteID()+"'||'|'||t2.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
	        			 +" from infodba.pitemrevision t2"
	        			 +" LEFT JOIN infodba.pitem t3 on  t2.ritems_tagu = t3.puid"
	        			 +" LEFT JOIN infodba.pworkspaceobject t1 on  t1.puid =t2.puid"
			        	 +" LEFT JOIN infodba.PPOM_APPLICATION_OBJECT t4 on (t1.PUID = t4.PUID)"
			        	 +" LEFT JOIN infodba."+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = t2.puid"
			        	 +" LEFT JOIN infodba.PRELEASESTATUS on PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
			        	 +" LEFT JOIN infodba.ppom_object on ppom_object.puid = t1.puid"
			        	 +" WHERE t1.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"')";
	        	 
	        	 String strDRWLocal = "select distinct pitem.pitem_id||'|'||pitemrevision.pitem_revision_id||'|'||t_03.pitem_id||'|'||t_02.pitem_revision_id||'|'||'"+conn.getSiteID()+"'||'|'||pitemrevision.puid||'|'||'11111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' "
                    		+ "from infodba.pitem,infodba.pitemrevision,infodba.pstructure_revisions,infodba.pPSBOMViewRevision,infodba.ppsoccurrence,infodba.PWORKSPACEOBJECT t_01 , infodba.PITEMREVISION t_02 , infodba.PITEM t_03, infodba.PWORKSPACEOBJECT pwo, infodba.ppom_object,infodba.PPOM_APPLICATION_OBJECT t4 "
                    		+ "where pitem.puid=pitemrevision.ritems_tagu and pitemrevision.puid=pstructure_revisions.puid and pPSBOMViewRevision.puid=pvalu_0 and RPARENT_BVRU=pPSBOMViewRevision.puid "
                    		+ "and ( t_02.ritems_tagu = t_03.puid ) AND (t_01.puid = t_02.puid ) and ppsoccurrence.rchild_itemu  = t_02.puid and pwo.puid = pitemrevision.puid "
                    		+ "and pwo.pobject_type  =  'Drawing Item Revision' "
         				+ "and pitem.puid= t4.PUID "
                    		+ "and ppom_object.puid = t_01.puid and (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;
            
	        	 strIRLocal = "SELECT t3.pitem_id||'|'||t2.pitem_revision_id||'|'||t1.pobject_type||'|'||replace(replace(t1.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_NAME,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_DESCRIPTION,CHR(10),' '),CHR(13),' ')||'|'||t2.PWGP4_DESIGN_CENTRE||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'|| TO_CHAR(t1.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss') ||'|'||PRELEASESTATUS.pname||'|'||t2.PWGP4_LENGTH||'|'||t2.PWGP4_WIDTH||'|'||t2.PWGP4_HEIGHT||'|'||t2.PWGP4_WEIGHT||'|'||''||'|'||t2.PWGP4_MATERIAL_CODE||'|'||t2.PWGP4_T4S_ENABLED||'|'||'0'||'|'||''||'|'||'"+conn.getSiteID()+"'||'|'||t2.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
	           			 +" from infodba.pitemrevision t2"
	           			 +" LEFT JOIN infodba.pitem t3 on  t2.ritems_tagu = t3.puid"
	           			 +" LEFT JOIN infodba.pworkspaceobject t1 on  t1.puid =t2.puid"
	                	 +" LEFT JOIN infodba.PPOM_APPLICATION_OBJECT t4 on (t1.PUID = t4.PUID)"
	                	 +" LEFT JOIN infodba."+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = t2.puid"
	                	 +" LEFT JOIN infodba.PRELEASESTATUS on PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
	                	 +" LEFT JOIN infodba.ppom_object on ppom_object.puid = t1.puid"
	                	 +" LEFT JOIN infodba.POM_TIMESTAMP timestamp on timestamp.puid = t1.puid"
	                	 +" WHERE t1.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))";
	        	 String strLoadDatasetDrawingCentric1 = "INSERT DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT "
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
	        				+" WHERE  t1.relation_name = 'IMAN_reference'"; 
	        		
	        		String strQuery121 = "INSERT INTO DMProd.dbo.eto_orderparts (etoeid,orderparts_itemid,orderparts_drawingid,site,status,orderparts_iid,puid)"
	        				+" SELECT DISTINCT t2.eid,t1.related_item,t1.RELATED_ITEM_REVISION,t2.site,t1.STATUS,t3.iid,t1.PUID "
	        				+" FROM  DMProcessDB.dbo.LOAD_ETO_REV t1 "
	        				+" LEFT JOIN  DMProd.dbo.eto_report t2 ON t1.ETO_NUMBER= t2.etoid AND t1.ETO_REVISION = t2.revision"
	        				+" LEFT JOIN  DMProd.dbo.items t3 ON t3.itemid=t1.[RELATED_ITEM] and t3.revision=t1.[RELATED_ITEM_REVISION]"
	        				+" WHERE t1.relation_name='order-parts' ";
	        		
		 String strLoadDatasetRemain = "INSERT DMProcessDB.dbo.LOAD_DATASETS_TRANS SELECT DISTINCT DN.PART_NUMBER, DN.PART_REVISION, DN.PART_TYPE, DS.DATASET_NAME, " 
		    		+"DS.DATASET_TYPE, DS.DATASET_DESCRIPTION,DS.DATASET_CREATED_DATE,DS.DATASET_REL_STATUS, DS.DATASET_REL_DATE, "
	        +"DS.STATUS,DS.COMMENTS,DS.IS_DOCNUMBER, DS.IS_PRT_UNDER_DRW,DS.SITE,DS.PUID, DS.OBJ_TAG,DS.DATE_IMPORTED "
	        +"FROM DMProcessDB.dbo.LOAD_DATASETS DS, DMProcessDB.dbo.LOAD_DOCUMENTNUMBER DN "
	        +"WHERE DS.PART_NUMBER = DN.DRAWING_NUMBER AND DS.PART_REVISION = DN.DRAWING_REVISION AND "
	        +"DS.SITE = DN.SITE AND DS.STATUS = '0' AND  DS.PART_TYPE = 'DocumentRevision'";
		 
		 
		 String strQueryPCNImpactedItem = "INSERT INTO [DMProd].[dbo].[pcn_impacteditem] ([pid],[impacteditem_iid],[createduser],[lastmoduser],[status],[puid])"
		    		+" SELECT distinct PCN_REPORT.[pid],IMPACTED_ITEM.iid ,'1','1',PCN_REPORT.status,PCN.puid"   
		    		+" FROM [DMProd].[dbo].[pcn_report] AS PCN_REPORT "
		    		+" LEFT OUTER JOIN DMProcessDB.dbo.LOAD_PCN_REL AS PCN ON PCN.PCN_NUMBER=PCN_REPORT.pcnid AND PCN.PCN_REVISION=PCN_REPORT.revision "
		    +" LEFT OUTER JOIN [DMProd].[dbo].items AS IMPACTED_ITEM ON IMPACTED_ITEM.itemid = PCN.RELATED_ITEM AND IMPACTED_ITEM.revision = PCN.RELATED_ITEM_REVISION and PCN.RELATION_NAME='CMHasImpactedItem'"
		    +" AND IMPACTED_ITEM.iid IS NOT NULL";
		 
		
		String  strALIAS_ALTERNATE =  "select distinct t_01.PITEM_ID||'|'||t_02.PIDFR_ID ||'|'||t_07.PIDFR_ID||'|'||t_01.pwgp4_item_id_legacy||'|'||t_01.pwgp4_drawing_id_legacy ||'|'||'"+conn.getSiteID()+"'||'|'||t_01.PUID||'|'||'111111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
		             + "from infodba.PITEM t_01" 
		             + " left outer join infodba.PIDENTIFIER t_02 on t_01.puid = t_02.raltid_ofu" 
		             + " left outer join infodba.PWORKSPACEOBJECT t_03 on t_03.PUID=t_01.puid"
					 + " left outer join infodba.PPOM_APPLICATION_OBJECT t4 on t4.PUID=t_01.puid"
		             + " left outer join infodba.ppom_object t_05 on t_05.puid=t_03.puid"
		             + " left outer join infodba.PIMANRELATION t_06 on  t_01.puid = t_06.rprimary_objectu  and t_06.rrelation_typeu  in (select PUID from infodba.PIMANTYPE where PTYPE_NAME='IMAN_aliasid')"
		             + " left outer join infodba.PIDENTIFIER t_07 on  t_06.rsecondary_objectu = t_07.puid"
		             + " where (t_02.PIDFR_ID is not null or t_07.PIDFR_ID is not null or t_01.pwgp4_item_id_legacy is not null or t_01.pwgp4_drawing_id_legacy is not null) and t_03.pactive_seq !=0 and (t_05.rowning_siteu is null or t_05.rowning_siteu ='"+owningSitePUID+"') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ;            			
		String strALIAS_ALTERNATE1 =  "select distinct t_01.PITEM_ID||'|'||t_02.PIDFR_ID ||'|'||t_07.PIDFR_ID||'|'||t_01.pwgp4_item_id_legacy||'|'||t_01.pwgp4_drawing_id_legacy ||'|'||'"+conn.getSiteID()+"'||'|'||t_01.PUID||'|'||'111111'||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
		             + "from infodba.PITEM t_01" 
		             + " left outer join infodba.PIDENTIFIER t_02 on t_01.puid = t_02.raltid_ofu" 
		             + " left outer join infodba.PWORKSPACEOBJECT t_03 on t_03.PUID=t_01.puid"
		             + " left outer join infodba.ppom_object t_05 on t_05.puid=t_03.puid"
		             + " left outer join infodba.PIMANRELATION t_06 on  t_01.puid = t_06.rprimary_objectu  and t_06.rrelation_typeu  in (select PUID from infodba.PIMANTYPE where PTYPE_NAME='IMAN_aliasid')"
		             + " left outer join infodba.PIDENTIFIER t_07 on  t_06.rsecondary_objectu = t_07.puid"
		             + " where (t_02.PIDFR_ID is not null or t_07.PIDFR_ID is not null or t_01.pwgp4_item_id_legacy is not null or t_01.pwgp4_drawing_id_legacy is not null) and t_03.pactive_seq !=0 and (t_05.rowning_siteu is null or t_05.rowning_siteu ='"+owningSitePUID+"')";
          
		 String strIRDocRefrenceLocal = "select pt1.pitem_id||'|'||pt2.pitem_revision_id||'|'||pwo.pobject_type||'|'||ct1.pitem_id||'|'||ct2.pitem_revision_id||'|'||cwo.POBJECT_NAME||'|'||'"+conn.getSiteID()+"'||'|'||pt2.puid||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
         		 + " FROM pitemrevision pt2"
         		 + " LEFT JOIN pitem pt1 ON pt2.ritems_tagu = pt1.puid"
		             + " LEFT JOIN pimanrelation irel ON irel.rprimary_objectu = pt2.puid "
		             + " LEFT JOIN pitemrevision ct2 ON irel.rsecondary_objectu = ct2.puid"
		             + " LEFT JOIN pitem ct1 ON ct2.ritems_tagu = ct1.puid OR ct1.puid = irel.rsecondary_objectu "
		             + " LEFT JOIN pimantype itype ON itype.puid=irel.rrelation_typeu"
		             + " LEFT JOIN pworkspaceobject pwo ON pwo.puid = pt2.puid"
		             + " LEFT JOIN pworkspaceobject cwo ON  cwo.puid =  ct1.puid "
		             + " LEFT JOIN ppom_object ON ppom_object.puid = pwo.puid "
		             + " LEFT JOIN PPOM_APPLICATION_OBJECT t4 ON t4.PUID = ct2.PUID "
		             + " WHERE pwo.pactive_seq !=0 AND itype.ptype_name = 'IMAN_reference' AND cwo.pobject_type IN ('Document','Drawing Item') AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS')" ; 
		 String strIRDocRefrenceLocal2 = "select pt1.pitem_id||'|'||pt2.pitem_revision_id||'|'||pwo.pobject_type||'|'||ct1.pitem_id||'|'||ct2.pitem_revision_id||'|'||cwo.POBJECT_NAME||'|'||'"+conn.getSiteID()+"'||'|'||pt2.puid||'|'||'0'||'|'||'COMMENTS'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'~~' as result "
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
	          
		 
		 String  strItemLoadQuery = "INSERT INTO [DMProd].[dbo].[items] ([itemid],[itemname],[description],[revision],[drawingid],[site],[updatedrefid],[status],[dcoid],[length],[width],[height],[encumbrance],[weight],[erp_part_name],[erp_part_description],[datereleased],[drawing_revision],[legacy_part_number],[legacy_document_number],[itemtype],[itemstatus],[puid],[t4s_mm_status],[t4s_dir_status]) "
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
		 
		 
		 String strIRLocal1 = "SELECT t3.pitem_id||'|'||t2.pitem_revision_id||'|'||t1.pobject_type||'|'||replace(replace(t1.pobject_desc,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_NAME,CHR(10),' '),CHR(13),' ')||'|'||replace(replace(t2.PWGP4_ERP_PART_DESCRIPTION,CHR(10),' '),CHR(13),' ')||'|'||t2.PWGP4_DESIGN_CENTRE||'|'||TO_CHAR(t4.PCREATION_DATE,'YYYY-MM-DD hh:mm:ss')||'|'|| TO_CHAR(t1.PDATE_RELEASED,'YYYY-MM-DD hh:mm:ss') ||'|'||PRELEASESTATUS.pname||'|'||t2.PWGP4_LENGTH||'|'||t2.PWGP4_WIDTH||'|'||t2.PWGP4_HEIGHT||'|'||t2.PWGP4_WEIGHT||'|'||''||'|'||t2.PWGP4_MATERIAL_CODE||'|'||t2.PWGP4_T4S_ENABLED||'|'||'0'||'|'||''||'|'||'"+conn.getSiteID()+"'||'|'||t2.puid||'|'||'11111'||'|'||to_char(sysdate,'YYYY-MM-DD hh:mm:ss')||'|'||replace(t2.PWGP4_T4S_MMSTATUS,'|','#')||'|'||replace(t2.PWGP4_T4S_DIRSTATUS,'|','#')||'~~' as result "
	   			 +" from pitemrevision t2"
	   			 +" LEFT JOIN pitem t3 on  t2.ritems_tagu = t3.puid"
	   			 +" LEFT JOIN pworkspaceobject t1 on  t1.puid =t2.puid"
	        	 +" LEFT JOIN PPOM_APPLICATION_OBJECT t4 on (t1.PUID = t4.PUID)"
	        	 +" LEFT JOIN "+PRELEASE_STATUS_LIST_TABNAME+" ON "+PRELEASE_STATUS_LIST_TABNAME+".puid = t2.puid"
	        	 +" LEFT JOIN PRELEASESTATUS on PRELEASESTATUS.puid = "+PRELEASE_STATUS_LIST_TABNAME+".pvalu_0"
	        	 +" LEFT JOIN ppom_object on ppom_object.puid = t1.puid"
	        	 +" LEFT JOIN POM_TIMESTAMP timestamp on timestamp.puid = t1.puid"
	        	 +" WHERE t1.pactive_seq!=0 AND (ppom_object.rowning_siteu is null or ppom_object.rowning_siteu ='"+owningSitePUID+"' or ppom_object.rowning_siteu='AAAAAAAAAAAAAA') AND (t4.plast_mod_date >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS') OR timestamp.PDBTIMESTAMP >= TO_DATE('" + lastExtractionTimeStamp +"', 'YYYY/MM/DD HH24:MI:SS'))";
	      
		 
		 
		 String printlist[] = {strIRLocal1};
    	  
    	for(int i=0;i<printlist.length;i++){
	   
	    System.out.println(printlist[i]);
	   // System.out.println("\n");
	    }
	    
	}
}
