


import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;


public class TcDBConnection {
	
	private String driver = "oracle.jdbc.driver.OracleDriver";
	private String userid = "";
	private String password = "";
	private String sxJdbcURL = "";
	private String site_id = "";
	private File propertiesFile = null;
	private String outputFileLocation="";
	private String numberOfDays = null;
	private  static Connection conn = null;
	private static TcDBConnection instance = null;
	
	public TcDBConnection() {		
	}
	
	  public static TcDBConnection getInstance() {
	      if(instance == null) {
	         instance = new TcDBConnection();
	      }
	      return instance;
	   }
	  
    public void setUserID(String userid) {	
    	this.userid = userid;
    	return;
    }
    private void setDataOutputLocation(String ouputFileLoc) {
    	this.outputFileLocation = ouputFileLoc;
    	return;
	}
    public void setPropertiesFile(File propFile) {	
    	this.propertiesFile = propFile;
    	return;
    }
    
    public void setSiteID(String siteid) {	
    	this.site_id = siteid;
    	return;
    }
    public String getSiteID() {	
    	return "AUS_PROD";
    }
    public String getOutputFileLocation() {	
    	return this.outputFileLocation;
    }
    public void setPassWord(String pwd) {
    	this.password = pwd;
        return;  	
    }
    
    public void setJDBCURL(String jurl) {
    	this.sxJdbcURL = jurl;
    	return;
    }
    
    public String getNumberOfDays() {
		return this.numberOfDays;
	}

	public void setNumberOfDays(String string) {
		this.numberOfDays = string;
	}
    
  
    public Connection getDBConnection() {
    	
    	if(conn != null) {
    		return conn;
    	}
    	else 
    	{
	    	Properties properties = new Properties();
	    	InputStream input = null;
			if( propertiesFile.isFile())
			{
		    	try {
		    		input = new FileInputStream(propertiesFile);
		    		properties.load(input);
		    		setUserID(properties.getProperty("tcDBUser"));
			        setPassWord(properties.getProperty("tcDBPwd"));
			        setSiteID(properties.getProperty("siteID"));
			        setNumberOfDays(properties.getProperty("DeltaNumberOfDays"));
			        setDataOutputLocation(properties.getProperty("dataOutputLocation"));
			         
			        String str;
			        str = "jdbc:oracle:thin:"+properties.getProperty("tcDBUser")+"/"+properties.getProperty("tcDBPwd")+"@"+properties.getProperty("tcDBServer")+":"+properties.getProperty("tcDBPort")+":"+properties.getProperty("tcDBSid");
			        //System.out.println(str);
			        setJDBCURL(str);
			  		
			    	}catch(Exception e) {
			            e.printStackTrace();
			        } finally {
			    		if (input != null) {
			    			try {
			    				input.close();
			    			} catch (IOException e) {
			    				e.printStackTrace();
			    			}
			    		}
			        }
			
			    		 
			    	Properties prop = new Properties();      
			    	prop.put("user", this.userid);
			    	prop.put("password", this.password);
			
			    	try {
			     	    Class.forName("oracle.jdbc.OracleDriver");
					    conn = DriverManager.getConnection(sxJdbcURL, prop);
					    return conn;
			        } catch(Exception e) {
			            e.printStackTrace();
			        } 
				}
			else
			{
				System.out.println("ERROR: Properties file is not found ...Exiting");
				System.out.println("USAGE: DataMartDataExtract -in_file=<properties file with absolutepath>");
				System.exit(0);
			}

			return null;
    	}

    }
    


	public void DisConnect() {
    	try {
      	    if (conn != null) conn.close();
    	} catch (Exception e){}
    }
}
