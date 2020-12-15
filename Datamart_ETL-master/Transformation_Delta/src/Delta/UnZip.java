package Delta;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class UnZip {
	
	 	List<String> fileList;
	    
	    public void unZipIt(String zipFile, String outputFolder)
	    {

	     byte[] buffer = new byte[1024];
	    
	     DMLogger.log("UnZipping folder Started.....");
	     try{
	    		
	    	//create output directory is not exists
	    	File folder = new File(outputFolder);
	    	if(!folder.exists()){
	    		folder.mkdir();
	    	}
	    		
	    	//get the zip file content
	    	ZipInputStream zis = 
	    		new ZipInputStream(new FileInputStream(zipFile));
	    	//get the zipped file list entry
	    	ZipEntry ze = zis.getNextEntry();
	    		
	    	while(ze!=null){
	    			
	    	   String fileName = ze.getName();
	    	   
	           File newFile = new File(outputFolder + File.separator + fileName);
	    	   //File newFile = new File(outputFolder);
	                
	           DMLogger.log("file unzip : "+ newFile.getAbsoluteFile());
	            
	           if(newFile.getAbsoluteFile().toString().contains(".") != true)
	           {
	        	   File pfolder = new File(newFile.getAbsoluteFile().toString());
	   	    		if(!pfolder.exists())
	   	    		{
	   	    			pfolder.mkdir();
	   	    		 DMLogger.log("Created Directory");
	   	    		}
	   	    		ze = zis.getNextEntry();
	   	    		continue;
	           }
	           new File(newFile.getParent()).mkdirs();
	              
	            FileOutputStream fos = new FileOutputStream(newFile);             

	            int len;
	            while ((len = zis.read(buffer)) > 0) {
	       		fos.write(buffer, 0, len);
	            }
	        		
	            fos.close(); 
	            ze = zis.getNextEntry();
	    	}
	    	
	        zis.closeEntry();
	    	zis.close();
	    		
	    	DMLogger.log("Completed.");
	    		
	    }catch(IOException ex){
	       ex.printStackTrace(); 
	    }
	   }    
}
