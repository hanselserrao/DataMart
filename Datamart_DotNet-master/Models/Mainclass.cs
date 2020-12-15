using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Script.Serialization;
using System.Text;

namespace Datamart.Models
{
    public static class Mainclass
    {
      
        static string Test = ConfigurationManager.ConnectionStrings["Defaultconnection"].ConnectionString;
        public static string GetString(byte[] bytes)
        {
            string result = System.Text.Encoding.UTF8.GetString(bytes);
            return result;
        }

        public static string ByteArrayToString(byte[] ba)
        {
            StringBuilder hex = new StringBuilder(ba.Length * 2);
            foreach (byte b in ba)
                hex.AppendFormat("{0:x2}", b);
            return hex.ToString();
        }

        public static List<Dictionary<string, object>> DataTableToJSONWithJavaScriptSerializer(DataTable table)
        {
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
            Dictionary<string, object> childRow;
            foreach (DataRow row in table.Rows)
            {
                childRow = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    childRow.Add(col.ColumnName, row[col]);
                }
                parentRow.Add(childRow);
            }
            return parentRow;
        }
        public static List<Dictionary<string, object>> Display(string d1)
        {
            SqlConnection con = new SqlConnection(Test);
            con.Open();
            //con.ConnectionTimeout = 3000;
            DataSet ds = new DataSet();
            SqlCommand cmd = new SqlCommand(d1, con);
            cmd.CommandTimeout = 150;
            //cmd.ExecuteNonQuery();
            SqlDataAdapter ad = new SqlDataAdapter(cmd);
            ad.Fill(ds);
            DataTable dt = new DataTable();
            dt = ds.Tables[0];
            List<Dictionary<string, object>> str = DataTableToJSONWithJavaScriptSerializer(dt);
            con.Close();
            return str;
        }

        public static List<List<Dictionary<string, object>>> DisplayDoc(string d1)
        {
            SqlConnection con = new SqlConnection(Test);
            con.Open();
            //con.ConnectionTimeout = 3000;
            DataSet ds = new DataSet();
            SqlCommand cmd = new SqlCommand(d1, con);
            cmd.CommandTimeout = 150;
            cmd.ExecuteNonQuery();
            SqlDataAdapter ad = new SqlDataAdapter(cmd);
            ad.Fill(ds);
            List<List<Dictionary<string, object>>> str = DataTableToJSONWithJavaScriptSerializer(ds);
            con.Close();
            return str;
        }

        public static List<List<Dictionary<string, object>>> DataTableToJSONWithJavaScriptSerializer(DataSet dataset)
        {
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();

            List< List <Dictionary <string,object>>> ssvalue = new List<List<Dictionary<string, object>>>();
            // Dictionary<string, object> tablecount;
            foreach (DataTable table in dataset.Tables)
            {
                List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
                Dictionary<string, object> childRow;

                string tablename = table.TableName;
                foreach (DataRow row in table.Rows)
                {
                    childRow = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        childRow.Add(col.ColumnName, row[col]);
                    }
                    parentRow.Add(childRow);
                }

                ssvalue.Add(parentRow);
            }

            return ssvalue;
        }

        public static void BuildEmail(string email, string mailSubject , string mailBody, string cc="", string file_path = "")
        {
            string mailHost = ConfigurationManager.AppSettings["mailHost"];
            string mailPort = ConfigurationManager.AppSettings["mailPort"];
            string mailFrom = ConfigurationManager.AppSettings["mailFrom"];
            string networkUser = ConfigurationManager.AppSettings["networkUser"];
            string networkpwd = ConfigurationManager.AppSettings["networkpwd"];

            Sendmail(email, mailSubject, mailBody, mailFrom, mailHost, Convert.ToInt32(mailPort), networkUser, networkpwd, cc, file_path);
        }

        public static void Sendmail(string to, string subj, string body, string from, string mailhost, int mailport, string networkUser, string networkpwd, string cc, string file_path)
        {
            try
            {
                MailMessage mm = new MailMessage();
                MailAddress objfrom = new MailAddress(from);
                MailAddress objto = new MailAddress(to);
                mm.Subject = subj;
                mm.Body = body;
                mm.From = objfrom;
                mm.To.Add(objto);
                if (cc != "")
                {
                    MailAddress objcc = new MailAddress(cc);
                    mm.CC.Add(objcc);
                }
                if (file_path != "")
                {
                    mm.Attachments.Add(new Attachment(file_path));
                }
                mm.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                smtp.Host = mailhost;
                smtp.Port = mailport;
                smtp.EnableSsl = true;

                //smtp.Host = "smtp.gmail.com";
                //smtp.Port = 587;
                //smtp.EnableSsl = true;
                //smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                NetworkCredential NetworkCred = new NetworkCredential(networkUser, networkpwd);
                smtp.UseDefaultCredentials = true;
                //Object mailState = mm;
                smtp.Credentials = NetworkCred;
                smtp.Send(mm);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}