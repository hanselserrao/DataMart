package atm;


import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DMLogger {
	private static String strOutLogFile = null;
	
	public DMLogger() {		
	}
	 public void setOutLogFile(String logFile) {	
	    	this.strOutLogFile = logFile;
	    	return;
	    }
	
	 
    public static void log(String message) 
    { 
    	System.out.println(message);
    	/*DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    	Date date = new Date();
    	//System.out.println(dateFormat.format(date));
     	
    	PrintWriter out = null;
		try 
		{
			out = new PrintWriter(new FileWriter(strOutLogFile, true), true);
		} catch (IOException e) 
		{
			e.printStackTrace();
		}
		out.write(dateFormat.format(date)+"     " + message + "\n");
		out.close();*/
    }
}