package Delta;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DmDBConnection {
	private String driver = "jdbc:sqlserver://DESKTOP-B07CHL4:1433";
	private String userid = "";
	private String password = "";
	private String sxJdbcURL = "";
	private String propertiesFile;
	private String zipFileLocation = "";
	private String fileProcessLocation = "";
	private String DBName = "";

	

	private  static Connection conn = null;
	private static DmDBConnection instance = null;
	
	public DmDBConnection() {		
	}
	
	  public static DmDBConnection getInstance() {
	      if(instance == null) {
	         instance = new DmDBConnection();
	      }
	      return instance;
	   }
	  
	  public String getZipFileLocation() {	
	    	return this.zipFileLocation;
	    }
	  public String getFileProcessLocation() {	
	    	return this.fileProcessLocation;
	    }
    public void setUserID(String userid) {	
    	this.userid = userid;
    	return;
    }
    
    public void setPassWord(String pwd) {
    	this.password = pwd;
        return;  	
    }
    
    public void setJDBCURL(String jurl) {
    	this.sxJdbcURL = jurl;
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
   	
			if( propertiesFile != null)
			{
		    	try {
		    		input = new FileInputStream(propertiesFile);
		    		properties.load(input);
		    		setUserID(properties.getProperty("dmDBUser"));
			        setPassWord(properties.getProperty("dmDBPwd"));
			        setZipFileLocation(properties.getProperty("zipFileLocation"));
			        setFileProcessLocation(properties.getProperty("fileProcessLocation"));
			        setDBName(properties.getProperty("dmTDBName"));
			        String str;
			        str = "jdbc:sqlserver://"+properties.getProperty("dmDBServer")+":"+properties.getProperty("dmDBPort");
			        //DMLogger.log(str);
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
		    		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				    conn = DriverManager.getConnection(sxJdbcURL, prop);
				    return conn;
		        } catch(Exception e) {
		            e.printStackTrace();
		        } 

			}
			else
			{
				DMLogger.log("ERROR: Properties file is not found ...Exiting");
				DMLogger.log("USAGE: DMProcessDB_Import.jar -in_file=<properties file location>");
				System.exit(0);
			}
	    	
			return null;
    	}
    }
    
    private void setZipFileLocation(String zipLocPath) {
		this.zipFileLocation = zipLocPath;
		return;
		
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

	public void setPropertiesFile(String propfilePath) {
		this.propertiesFile = propfilePath;
    	return;
	}

	public String getDBName() {
		return DBName;
	}

	public void setDBName(String dBName) {
		this.DBName = dBName;
	}
}
