using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace DatamartAPI.Log
{
    public class Logger
    {

        /// <summary>
        /// Returns generated path to logfile
        /// </summary>
        /// <returns></returns>
        protected static string GetFileName(bool info)
        {
            //string folder = info ? GetInfoFolder() : GetErrorFolder();
            string folder = HttpContext.Current.Server.MapPath("~/App_Data") + "\\LogFile";
            if (folder == null) return null;
            StringBuilder stb = new StringBuilder();
            stb.AppendFormat("{0}\\{1}{2}{3}.txt", folder, DateTime.Now.ToString("dd"), DateTime.Now.ToString("MM"), DateTime.Now.ToString("yyyy"));
            return stb.ToString();
        }

        /// <summary>
        /// Gets the enable loging
        /// </summary>
        /// <returns></returns>
        protected static bool GetEnableLogging()
        {
            IDictionary dic = System.Configuration.ConfigurationManager.GetSection("ErrorHandling") as IDictionary;
            bool enableLogging = false;
            if (dic != null || dic["EnableLogging"] != null)
            {
                Boolean.TryParse(dic["EnableLogging"].ToString().Trim(), out enableLogging);
            }
            return enableLogging;
        }

        /// <summary>
        /// Gets the name of error loging folder
        /// </summary>
        /// <returns></returns>
        protected static string GetErrorFolder()
        {
            IDictionary dic = System.Configuration.ConfigurationManager.GetSection("ErrorHandling") as IDictionary;
            string folder = dic == null || dic["ErrorLogFilesDir"] == null ? "" : dic["ErrorLogFilesDir"].ToString().Trim();
            if (!Directory.Exists(folder))
            {
                return null;
            }
            else return folder;
        }

        /// <summary>
        /// Gets the name of info loging folder
        /// </summary>
        /// <returns></returns>
        protected static string GetInfoFolder()
        {
            IDictionary dic = System.Configuration.ConfigurationManager.GetSection("ErrorHandling") as IDictionary;
            string folder = dic == null || dic["AppLogFilesDir"] == null ? "" : dic["AppLogFilesDir"].ToString().Trim();
            if (!Directory.Exists(folder))
            {
                return null;
            }
            else return folder;
        }

        /// <summary>
        /// An internal method for writing data to file
        /// </summary>
        /// <param name="stb">
        /// Data to be written
        /// </param>
        /// <param name="info">
        /// If true, writes to info log folder
        /// </param>
        protected static void WriteToFile(StringBuilder stb, bool info)
        {
            if (GetEnableLogging())
            {
                string path = GetFileName(info);
                if (path != null)
                {
                    using (StreamWriter sw = File.AppendText(path))
                    {
                        sw.Write(stb.ToString());
                        sw.Close();
                    }
                }
            }
        }

        /// <summary>
        /// Logs any information to some text logfile in specific format
        /// </summary>
        /// <param name="info">
        /// String containing information to be loged
        /// </param>
        /// /// <param name="includeAdditionalInfo">
        /// In true, additional info about request, session etc. will be included into log record
        /// </param>
        public static void LogInfo(string info)
        {
            StringBuilder stb = new StringBuilder();
            stb.Append("<Activity>");
            stb.AppendLine();
            stb.AppendFormat("<DateTime>{0}</DateTime>", DateTime.Now);
            stb.AppendLine();
            stb.AppendFormat("<Summary>Some info was loged on {0} {1}</Summary>", DateTime.Now.ToLongDateString(), DateTime.Now.ToLongTimeString());
            stb.AppendLine();
            stb.AppendFormat("<Message>{0}</Message>", info);
            stb.AppendLine();
            stb.Append("</Activity>");
            stb.AppendLine();
            stb.AppendLine();
            lock (typeof(Logger))
            {
                WriteToFile(stb, true);
            }

        }


        /// <summary>
        /// Logs as exception pointed to some text logfile in specific format
        /// </summary>
        /// <param name="er">
        /// Exception to be loged
        /// </param>
        public static void LogException(Exception er)
        {
            LogException(er, string.Empty, ErrorLevel.ERROR);
        }

        /// <summary>
        /// Logs as exception pointed to some text logfile in specific format
        /// </summary>
        /// <param name="er">
        /// Exception to be loged
        /// </param>
        /// <param name="strMessage">
        /// custom message to be loged
        /// </param>
        public static void LogException(Exception er, string strMessage)
        {
            LogException(er, string.Empty, ErrorLevel.ERROR);
        }

        /// <summary>
        /// Logs as exception pointed to some text logfile in specific format
        /// </summary>
        /// <param name="er">
        /// Exception to be loged
        /// </param>
        /// <param name="strMessage">
        /// custom message to be loged
        /// </param>
        /// <param name="errLevel">
        /// error level
        /// </param>
        public static void LogException(Exception er, string strMessage, ErrorLevel errLevel)
        {

            if (er != null && !(er is System.Threading.ThreadAbortException))
            {
                try
                {
                    StringBuilder stb = new StringBuilder();
                    stb.Append("<Exception>");
                    stb.AppendLine();
                    stb.AppendFormat("<DateTime>{0}</DateTime>", DateTime.Now);
                    stb.AppendLine();
                    stb.AppendFormat("<Summary>An unhandled exception occured on {0} {1}", DateTime.Now.ToLongDateString(), DateTime.Now.ToLongTimeString() + "</Summary>");
                    stb.AppendLine();
                    if (strMessage != string.Empty)
                    {
                        stb.AppendFormat("<CustomMessage>{0}</CustomMessage>", strMessage);
                        stb.AppendLine();
                    }
                    stb.Append("<Info>");
                    stb.AppendLine();

                    stb.AppendFormat("<ErrorMessage>{0}</ErrorMessage>", er.ToString());

                    if (er.InnerException != null)
                    {
                        stb.AppendLine();
                        stb.AppendFormat("<InnerException>{0}</InnerException>", er.InnerException.ToString());
                    }
                    stb.AppendLine();
                    stb.AppendLine();
                    stb.Append("</Exception>");
                    stb.AppendLine();
                    stb.AppendLine();
                    lock (typeof(Logger))
                    {
                        WriteToFile(stb, false);
                    }


                }
                catch (Exception)
                {
                    //do nothing for now
                }
            }
        }

    }

    /// <summary>
    /// Level of error
    /// </summary>
    public enum ErrorLevel : int
    {
        FATAL_ERROR = 3,
        ERROR = 2,
        WARNING = 1
    }
}