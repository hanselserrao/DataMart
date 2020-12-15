package atm;


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
	private String fileProcessLocation = "";
	public TcDBConnection() {		
	}
	
	  public static TcDBConnection getInstance() {
	      if(instance == null) {
	         instance = new TcDBConnection();
	      }
	      return instance;
	   }
	  public String getFileProcessLocation() {	
	    	return this.fileProcessLocation;
	    }
    public void setUserID(String userid) {	
    	this.userid = userid;
    	return;
    }
    public String getUserID() {	
    	
    	return this.userid;
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
    	return this.site_id;
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

	public void setNumberOfDays(String numberOfDays) {
		this.numberOfDays = numberOfDays;
		return;
	}
	
    
    public EnumConnectStatus validUserID() {
    	if (this.userid.isEmpty()) return EnumConnectStatus.IDENTITY_EMPTY_ERR;
    	return EnumConnectStatus.IDENTITY_OK;
    }
    
    public EnumConnectStatus validPassWord() {
    	if (this.password.isEmpty()) return EnumConnectStatus.PASSWORD_BLANK_WARNING;
    	return EnumConnectStatus.PASSEORD_OK;
    }
    
    public EnumConnectStatus validJDBCURL() {
    	if (this.sxJdbcURL.isEmpty()) return EnumConnectStatus.CONN_URL_NOT_CORRECT_ERR;
    	return EnumConnectStatus.CONN_URL_OK;
    }
    
    public EnumConnectStatus validDriver() {
    	if (this.driver.isEmpty()) return EnumConnectStatus.DRIVER_NOT_CORRECT_ERR;
    	return EnumConnectStatus.DRIVER_OK;
    }
    
    public EnumConnectStatus validConn() {
    	EnumConnectStatus estatus;
    	
    	estatus = validDriver();
    	if (estatus.equals(EnumConnectStatus.DRIVER_NOT_CORRECT_ERR)) return estatus;
    	
        estatus = validUserID();
        if (estatus.equals(EnumConnectStatus.IDENTITY_EMPTY_ERR)) return estatus;
        
        estatus = validPassWord();
        if (estatus.equals(EnumConnectStatus.PASSWORD_BLANK_WARNING)) return EnumConnectStatus.PASSWORD_BLANK_WARNING;
        
        estatus = validJDBCURL();
        if (estatus.equals(EnumConnectStatus.CONN_URL_NOT_CORRECT_ERR)) return EnumConnectStatus.CONN_URL_NOT_CORRECT_ERR;
        
        return EnumConnectStatus.STATUS_OK;
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
			        System.out.println("Delta days are"+properties.getProperty("DeltaNumberOfDays"));
			        setNumberOfDays(properties.getProperty("DeltaNumberOfDays"));
			        setFileProcessLocation(properties.getProperty("fileProcessLocation"));
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
    
    private void setFileProcessLocation(String fileProcessPath) {
		this.fileProcessLocation = fileProcessPath;
		return;
		
	}

	public void DisConnect() {
    	try {
      	    if (conn != null) conn.close();
    	} catch (Exception e){}
    }
}
