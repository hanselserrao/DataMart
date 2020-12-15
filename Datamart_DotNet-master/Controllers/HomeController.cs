using Datamart.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Drawing;
using Spire.Pdf;
using Spire.Pdf.Graphics;
using System.Text.RegularExpressions;

namespace Datamart.Controllers
{
    public class HomeController : Controller
    {

        string count = ConfigurationManager.AppSettings["count"];
        [HttpGet]
        public string DownLoadFile(string FileName, string fileType, string datasetName, string docType)
        {
            #region
            try
            {
                if (System.IO.File.Exists(FileName))
                {
                    FileInfo fileIn = new FileInfo(FileName);
                    WebClient req = new WebClient();
                    Response.Clear();
                    Response.ClearContent();
                    Response.ClearHeaders();
                    Response.Buffer = true;
                    if (docType != "IOM Manual")
                    {
                        FileName = ApplyWaterMark(FileName, fileIn);
                    }

                    byte[] data = req.DownloadData(FileName);
                    //Response.AddHeader("Content-Disposition", "attachment;filename=\"" + FileName.Split('\\')[count] + "\"");
                    Response.AddHeader("Content-Disposition", "attachment;filename=\"" + datasetName.Replace('/', '-') + fileIn.Extension.ToString() + "\"");
                    var lenth = data.Length;
                    Response.BinaryWrite(data);
                    Response.End();
                    if (docType != "IOM Manual")
                    {
                        System.IO.File.Delete(FileName);

                    }
                    return "";
                }
                else
                {
                    return "No File is present in location";
                }
            }
            catch (Exception ex)
            {
                return ("Soeting wend wrong" + ex.ToString());
            }

            // return "";



            #endregion

        }

        public string ApplyWaterMark(string FileName, FileInfo fileIn)
        {

            string WaterMark = ConfigurationManager.AppSettings["WatermarkComment"];
            string newFileName = string.Empty;
            PdfDocument doc = new PdfDocument();
            doc.LoadFromFile(FileName);
            newFileName = fileIn.DirectoryName + "/" + DateTime.Now.ToString("hhmmss") + "_" + fileIn.Name;
            foreach (PdfPageBase page in doc.Pages)
            {
                PdfTilingBrush brush
                   = new PdfTilingBrush(new SizeF(page.Canvas.ClientSize.Width / 1, page.Canvas.ClientSize.Height / 1));
                brush.Graphics.SetTransparency(0.1f);
                brush.Graphics.Save();
                brush.Graphics.TranslateTransform(brush.Size.Width / 2, brush.Size.Height / 2);
                brush.Graphics.RotateTransform(-45);
                brush.Graphics.DrawString(WaterMark + ' ' + DateTime.Now.ToString("dd-MMM-yyyy"),
                    new PdfFont(PdfFontFamily.Helvetica, 28), PdfBrushes.Blue, 0, 0,
                    new PdfStringFormat(PdfTextAlignment.Center));
                brush.Graphics.Restore();
                brush.Graphics.SetTransparency(1);
                page.Canvas.DrawRectangle(brush, new RectangleF(new PointF(0, 0), page.Canvas.ClientSize));
            }
            doc.SaveToFile(newFileName);
            return newFileName;
        }


        DMProdEntities model = new DMProdEntities();
        //public ActionResult GetControls()
        //{
        //    var data = model.controls.ToList();
        //    return Json(data,JsonRequestBehavior.AllowGet);
        //}
        [Route("search")]
        public ActionResult Dashboard()
        {
            //if (Session["username"] != null)
            //{
            return View();
            //}
            //else
            //{
            //    return RedirectToAction("Login", "Home");
            //}
        }
        public ActionResult DataPage()
        {

            return View();
        }
        public ActionResult PartSearch(string Partnumber, string LegPartNumer, string partStatus, string DocNumber, string LegDocNumber, string PartType, string PartDescription)
        {
            //if (Convert.ToString(Session["username"]) != "")
            //{
            Partnumber = Partnumber != "undefined" ? Partnumber : "";
            Partnumber = Partnumber != "null" ? Partnumber.Replace("_", "[_]") : "";
            LegPartNumer = LegPartNumer != "undefined" ? LegPartNumer.Replace("_", "[_]") : "";
            partStatus = partStatus != "undefined" ? partStatus : "";
            DocNumber = DocNumber != "undefined" ? DocNumber.Replace("_", "[_]") : "";
            LegDocNumber = LegDocNumber != "undefined" ? LegDocNumber.Replace("_", "[_]") : "";
            PartType = PartType != "undefined" ? PartType : "";
            PartDescription = PartDescription != "undefined" ? PartDescription.Replace("_", "[_]") : "";


            var data = Mainclass.Display("exec sp_partsearch '" + Partnumber + "','" + LegPartNumer + "','" + partStatus + "','" + DocNumber + "','" + LegDocNumber + "','" + PartType + "','" + PartDescription + "','" + count + "'");
            /*model.sp_partsearch(Partnumber, LegPartNumer, prtstatus, dconum, LegDocNumber, parttyp).ToList();*/
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
            //}
            //else
            //    return Json("1", JsonRequestBehavior.AllowGet);

        }
        public ActionResult DocSearch(string documentNumber, string legacyPartNumber, string docStatus, string documentDescription, string LegDocumentNumber, string docType, string PartDescription)
        {
           // if (Convert.ToString(Session["username"]) != "")
            //{
                documentNumber = documentNumber != "undefined" ? documentNumber : "";

                documentNumber = documentNumber != "null" ? documentNumber.Replace("_", "[_]") : "";
                legacyPartNumber = legacyPartNumber != "undefined" ? legacyPartNumber.Replace("_", "[_]") : "";
                docStatus = docStatus != "undefined" ? docStatus : "";
                documentDescription = documentDescription != "undefined" ? documentDescription.Replace("_", "[_]") : "";
                LegDocumentNumber = LegDocumentNumber != "undefined" ? LegDocumentNumber.Replace("_", "[_]") : "";
                docType = docType != "undefined" ? docType : "";
                PartDescription = PartDescription != "undefined" ? PartDescription.Replace("_", "[_]") : "";

            var data = Mainclass.DisplayDoc("exec sp_docsearch '" + documentNumber + "','" + documentDescription + "','" + legacyPartNumber + "','" + docStatus + "','" + LegDocumentNumber + "','" + docType + "','" + PartDescription + "','" + count + "'");

                //var data = model.sp_docsearch(documentNumber.ToString(), documentDescription, legacyPartNumber, prtstatus, LegDocumentNumber, parttyp).ToList();
                var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            /*
            }
            else
                return Json("1", JsonRequestBehavior.AllowGet);
           */
        }

        public ActionResult PcnSearch(string Pcnnumber, string PcnDescription, string problem, string solution, string impected)
        {
            //if (Convert.ToString(Session["username"]) != "")
            //{
                Pcnnumber = Pcnnumber != "undefined" ? Pcnnumber : "";
                Pcnnumber = Pcnnumber != "null" ? Pcnnumber.Replace("_", "[_]") : "";
                PcnDescription = PcnDescription != "undefined" ? PcnDescription.Replace("_", "[_]") : "";
                problem = problem != "undefined" ? problem.Replace("_", "[_]") : "";
                impected = impected != "undefined" ? impected.Replace("_", "[_]") : "";
                solution = solution != "undefined" ? solution.Replace("_", "[_]") : "";

                //if (solution == "")
                //    dconum = null;
                //else
                //    dconum = Convert.ToInt32(solution);
                //int? parttyp = 0;
                //if (impected == "")
                //    parttyp = null;
                //else
                //    parttyp = Convert.ToInt32(impected);
                //int? vproblem = 0;
                //if (problem == "")
                //    vproblem = null;
                //else
                //    vproblem = Convert.ToInt32(problem);
                var data = Mainclass.DisplayDoc("exec sp_pcnsearch '" + Pcnnumber + "','" + PcnDescription + "','" + problem + "','" + solution + "','" + impected + "','" + count + "'");
                //for (int i = 0; i < data.Count; i++)
                //{
                //    var probem = Mainclass.Display("Select problemdata=(it.itemid+'/'+it.revision) from [dbo].[items] it  join pcnitem_report pcnreport on pcnreport.problemitem_iid=it.iid  join pcn_report pcn on pcn.pid='" + data[i]["pid"] + "'");
                //    var solutio = Mainclass.Display("Select problemdata=(it.itemid+'/'+it.revision) from [dbo].[items] it  join pcnitem_report pcnreport on pcnreport.problemitem_iid=it.iid  join pcn_report pcn on pcn.pid='" + data[i]["pid"] + "'");
                //    var impacted = Mainclass.Display("Select problemdata=(it.itemid+'/'+it.revision) from [dbo].[items] it  join pcnitem_report pcnreport on pcnreport.problemitem_iid=it.iid  join pcn_report pcn on pcn.pid='" + data[i]["pid"] + "'");


                //    data[i].Add("problem", probem);

                //    data[i].Add("solution", solutio);

                //    data[i].Add("impacted", impacted);
                //}
                //var data = model.sp_pcnsearch(Pcnnumber.ToString(), PcnDescription, vproblem, dconum, parttyp).ToList();
                var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            /*
            }
            else
                return Json("1", JsonRequestBehavior.AllowGet);*/
        }

        public ActionResult EtoSearch(string Etonumber, string projectName, string ordernumber, string customername, string gag, string doc, string routing, string orderpart, string reference)
        {
            //if (Convert.ToString(Session["username"]) != "")
            //{
                Etonumber = Etonumber != "undefined" ? Etonumber : "";
                Etonumber = Etonumber != "null" ? Etonumber.Replace("_", "[_]") : "";
                projectName = projectName != "undefined" ? projectName.Replace("_", "[_]") : "";
                ordernumber = ordernumber != "undefined" ? ordernumber.Replace("_", "[_]") : "";
                customername = customername != "undefined" ? customername.Replace("_", "[_]") : "";
                gag = gag != "undefined" ? gag.Replace("_", "[_]") : "";
                doc = doc != "undefined" ? doc.Replace("_", "[_]") : "";
                routing = routing != "undefined" ? routing : "";
                orderpart = orderpart != "undefined" ? orderpart.Replace("_", "[_]") : "";
                reference = reference != "undefined" ? reference.Replace("_", "[_]") : "";

                var data = Mainclass.DisplayDoc("exec sp_etoSearch '" + Etonumber + "','" + projectName + "','" + ordernumber + "','" + customername + "','" + gag + "','" + doc + "','" + routing + "','" + orderpart + "','" + reference + "','" + count + "'");

                //var data = model.sp_etoSearch(Etonumber, projectName, ordernumber, customername, Vgag, Vdoc, vrouting, Vorderpart, Vref).ToList();
                var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            /*}
            else
                return Json("1", JsonRequestBehavior.AllowGet);*/
        }
        public JsonResult LEDSearch(string liftpartNumber, string liftDocNumber, string liftPartType, string liftdesc, string Compwhereused, string liftpartStatus, string Productwhere,
            string hasCertification, string hasInsDoc, string tare, string wll, string tarevalue, string wllvalue, string SearchBy)
        {
            /*if (Convert.ToString(Session["username"]) != "")
            {*/
                liftpartNumber = liftpartNumber != "undefined" ? liftpartNumber : "";
                liftpartNumber = liftpartNumber != "null" ? liftpartNumber.Replace("_", "[_]") : "";
                liftDocNumber = liftDocNumber != "undefined" ? liftDocNumber.Replace("_", "[_]") : "";
                liftPartType = liftPartType != "undefined" ? liftPartType : "";
                liftdesc = liftdesc != "undefined" ? liftdesc : "";
                liftpartStatus = liftpartStatus != "undefined" ? liftpartStatus : "";

                Compwhereused = Compwhereused != "undefined" ? Compwhereused.Replace("_", "[_]") : "";
                Productwhere = Productwhere != "undefined" ? Productwhere.Replace("_", "[_]") : "";
                hasInsDoc = hasInsDoc != "undefined" ? hasInsDoc : "";
                hasCertification = hasCertification != "undefined" ? hasCertification : "";
                tare = tare != "undefined" ? tare : "";
                wll = wll != "undefined" ? wll : "";
                wllvalue = wllvalue != "undefined" ? wllvalue : "0.0";
                tarevalue = tarevalue != "undefined" ? tarevalue : "0.0";
                SearchBy = SearchBy != "undefined" ? SearchBy : "";
                var data = Mainclass.Display("exec [sp_LEDSearch] @liftpartNumber = '" + liftpartNumber + "', @liftDocNumber = '" + liftDocNumber + "', @liftPartType = '" + liftPartType + "', @liftdesc = '" + liftdesc + "', @Compwhereused = '" + Compwhereused + "', @liftpartStatus = '" + liftpartStatus + "', @Productwhere = '" + Productwhere + "', @hasCertification = '" + hasCertification + "', @hasInsDoc = '" + hasInsDoc + "', @tare = '" + tare + "', @wll = '" + wll + "', @tarevalue = '" + tarevalue + "', @wllvalue = '" + wllvalue + "', @SearchBy = '" + SearchBy + "', @count = " + count + "");

                var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            /*}
            else
                return Json("1", JsonRequestBehavior.AllowGet);*/
        }


        public ActionResult DatamartSearch(string searchString)
        {
            searchString = searchString.Trim();
            string whereClause = "1 = 1";
            searchString = searchString.Trim();
            //searchString = Regex.Replace(searchString, @"\s+", " ");
            string[] keywords = Regex.Split(searchString, @"\s+");
            foreach (string key in keywords)
            {
                whereClause = whereClause + " and itemdata like ''%" + key + "%''";
            }
            var data = Mainclass.DisplayDoc("exec sp_search_datamart @searchText ='" + whereClause.ToString() + "', @count = " + count);

            //var data = model.sp_docsearch(documentNumber.ToString(), documentDescription, legacyPartNumber, prtstatus, LegDocumentNumber, parttyp).ToList();
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }


        public JsonResult GetLEDType()
        {

            var data = (from e in model.options
                        join led in model.led_ir on e.oid equals led.tooltype
                        select new
                        {
                            id = e.oid,
                            name = e.name
                        }).Distinct().OrderBy(a => a.name);
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetLEDStatus()
        {

            var data = (from e in model.options
                        join led in model.led_ir on e.oid equals led.toolstatus
                        select new
                        {
                            id = e.oid,
                            name = e.name
                        }).Distinct().OrderBy(a => a.name);
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetLednumber(string prefix)
        {

            var data = model.ledkeywordsearch(prefix);
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetPartnumber(string prefix)
        {

            var data = model.searchpart(prefix);
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetPcnnumber(string prefix)
        {

            var data = model.pcnkeywordsearch(prefix).ToList();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetEtonumber(string prefix)
        {

            var data = model.etokeywordsearch(prefix).ToList();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetDocnumber(string prefix)
        {

            var data = model.dockeywordsearch(prefix);
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetPartStatus()
        {
            var data = model.options.Where(a => a.categoryid == 2).Select(n => new { oid = n.oid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetPartType()
        {
            var data = model.options.Where(a => a.categoryid == 1).Select(n => new { oid = n.oid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetDocType()
        {//join d in model.itemreport_dataset on e.oid equals d.documenttype  &
            var data = (from e in model.options
                        where e.categoryid == 6
                        select new
                        {
                            oid = e.oid,
                            name = e.name,
                        }).Distinct().OrderBy(a => a.name);

            //var data = model.options.Where(a => a.categoryid == 6).Select(n => new { oid = n.oid, name = n.name })

            //    .ToList();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetLedPartdetail(long id)
        {
            var data = Mainclass.Display("exec sp_ledsearchdetail " + id + "");
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        public ActionResult GetPartdetail(long id)
        {
            var data = Mainclass.DisplayDoc("exec searchpartdetail " + id + "");
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        public ActionResult Getpcndetail(int id)
        {
            var data = Mainclass.Display("DECLARE @problem NVARCHAR(max) DECLARE @solution NVARCHAR(max) DECLARE @impacted NVARCHAR(max)  exec[sp_pcndetail] " + id + ",@problem OUTPUT , @solution OUTPUT, @impacted OUTPUT  select  @problem as problem,@solution as solution,  @impacted as impacted");

            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        public ActionResult Getetodetail(int id)
        {
            var data = Mainclass.Display("DECLARE @document NVARCHAR(max) DECLARE @gadrawing NVARCHAR(max) DECLARE @routing NVARCHAR(max)  DECLARE @order NVARCHAR(max)  DECLARE @reference NVARCHAR(max)  exec [sp_etodetail] " + id + ", @document OUTPUT, @gadrawing OUTPUT, @routing OUTPUT , @order OUTPUT , @reference OUTPUT select  @document as document, @gadrawing as ga, @routing as routing , @order as [order] , @reference as reference");
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        public JsonResult Getledsearchdetail(int id)
        {
            var data = Mainclass.Display("DECLARE @document NVARCHAR(max) DECLARE @certification NVARCHAR(max)  DECLARE @partwhere NVARCHAR(max)  DECLARE @productwhere NVARCHAR(max) exec sp_ledsearchdetail " + id + ", @document OUTPUT, @certification OUTPUT, @partwhere OUTPUT, @productwhere OUTPUT select  @document as document, @certification as certification, @partwhere as partwhere, @productwhere as productwhere");
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        public ActionResult GetDocdetail(long id)
        {
            var data = model.searchdocdetail(id);
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        public ActionResult Login()
        {



            return View();
        }

        public ActionResult ForgetPassword(string email)
        {
            var dta = model.users.Where(a => a.email == email).FirstOrDefault();
            if (dta != null)
            {

                try
                {
                    var pass = "<b>" + Mainclass.GetString(dta.password) + "</b>";
                    string mailBody = ConfigurationManager.AppSettings["mailBody"];
                    string mailSubject = ConfigurationManager.AppSettings["mailSubject"];
                    mailBody = string.Format(mailBody, pass, "<b>" + email + "</b>");
                    Mainclass.BuildEmail(email, mailSubject, mailBody);
                    return Json(1, JsonRequestBehavior.AllowGet);
                }
                catch (Exception e)
                {

                    return Json(2, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(0, JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult Logout()
        {
            Session.Clear();
            Session.Abandon();
            return Json("", JsonRequestBehavior.AllowGet);
        }

        public ActionResult VerifySession()
        {
            string role = string.Empty;
            int CacheExpiration = Convert.ToInt32(ConfigurationManager.AppSettings["CacheExpirationMins"]);

            string etlLastUpdate = Caching.GetObjectFromCache<string>("resultOfExpensiveQuery", CacheExpiration, Caching.getETLLastUpdate);

            if (Session["role"] != null)
            {
                role = Convert.ToString(Session["role"]);
                if ((Session["role"].ToString() == "Änonymous" || Session["role"].ToString() == ""))
                    return Json(new { SessionExist = false, role, etlLastUpdate }, JsonRequestBehavior.AllowGet);
                else
                    return Json(new { SessionExist = true, role, etlLastUpdate }, JsonRequestBehavior.AllowGet); ;
            }
            return Json(new { SessionExist = false, role, etlLastUpdate }, JsonRequestBehavior.AllowGet); ;
        }

        public ActionResult ChangePassword(string email, string password, string newpassword)
        {
            password = password != "undefined" ? password : "";
            byte[] array = Encoding.ASCII.GetBytes(password);
            var data = Mainclass.Display("exec sp_validateUser @Email = '" + email + "'");
            if ((data != null) && (data.Count > 0))
            {
                string username = data[0]["email"].ToString();
                string role = data[0]["userRole"].ToString();
                Session["username"] = username;
                Session["role"] = role;
                int status = Convert.ToInt32(data[0]["status"]);
                if (status != 1)
                {
                    return Json(new { mode = 4, username }, JsonRequestBehavior.AllowGet);
                }
                byte[] pwd;

                if ((data[0]["password"] == DBNull.Value) && (password == ""))
                {
                    pwd = Encoding.ASCII.GetBytes(password);
                }
                else
                {
                    pwd = (byte[])data[0]["password"];
                }
                if (System.Collections.StructuralComparisons.StructuralEqualityComparer.Equals(array, pwd))
                {
                    var data1 = Mainclass.Display("exec sp_changepwd @email = '" + email + "', @newpassword = '" + newpassword + "'");
                    if ((data1 != null) && (data1.Count > 0))
                    {
                        string errorno = data1[0]["ErrorNumber"].ToString();
                        string errmsg = data1[0]["ErrorMessage"].ToString();
                        if (errorno == "0")
                            return Json(new { mode = 1 }, JsonRequestBehavior.AllowGet);
                        else
                            return Json(new { mode = 2, errormessage = errmsg }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { mode = 6 }, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json(new { mode = 3 }, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(new { mode = 5 }, JsonRequestBehavior.AllowGet);
            }
        }



        public ActionResult Login1(string email, string password, string context = "") //KAMLESH-ROLE
        {
            //    var remember = fc["rememberme"] != null ? true : false;
            //    string email = Convert.ToString(fc["Email"]);
            //    string pass = Convert.ToString(fc["Password"]);
            //    HttpCookie emailCookie = new HttpCookie("Email");
            //    HttpCookie passCookie = new HttpCookie("Password");
            //    if (remember == true)
            //    {

            //        //Set the Cookie value.
            //        emailCookie.Values["Name"] = email;
            //        passCookie.Values["Password"] = pass;
            //        //Set the Expiry date.

            //    }
            //    else
            //    {
            //        emailCookie.Values["Name"] = null;
            //        passCookie.Values["Password"] = null;
            //    }
            //    emailCookie.Expires = DateTime.Now.AddDays(15);
            //    passCookie.Expires = DateTime.Now.AddDays(15);
            //    Response.Cookies.Add(emailCookie);
            //    Response.Cookies.Add(passCookie);
            byte[] array = Encoding.ASCII.GetBytes(password);

            var data = Mainclass.Display("exec sp_validateUser @Email = '" + email + "'");

            //var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            //jsonResult.MaxJsonLength = int.MaxValue;

            
            //var dta = model.users.Where(a => a.email == email && a.password == array).FirstOrDefault();
            if ((data != null) && (data.Count > 0))
            {
                string username = data[0]["email"].ToString();
                string role = data[0]["userRole"].ToString();
                Session["username"] = username;
                Session["role"] = role;
                int status = Convert.ToInt32(data[0]["status"]);
                if (data[0]["password"] == DBNull.Value)
                {
                    return Json(new { mode = 5, username }, JsonRequestBehavior.AllowGet);
                }

                byte[] pwd = (byte[])data[0]["password"];
                if (status != 1)
                {
                    return Json(new { mode = 4, username }, JsonRequestBehavior.AllowGet);
                }
                if ((role == "Admin") && (context!="ADM"))
                {
                    return Json(new { mode = 2 }, JsonRequestBehavior.AllowGet);
                }
                if ((role == "RegularUser") && (context != "APP"))
                {
                    return Json(new { mode = 2 }, JsonRequestBehavior.AllowGet);
                }
                if (System.Collections.StructuralComparisons.StructuralEqualityComparer.Equals(array, pwd))
                {
                    return Json(new { mode = 1, username, role}, JsonRequestBehavior.AllowGet); 
                }
                return Json(new { mode = 3 }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { mode = 2 }, JsonRequestBehavior.AllowGet);
            }
        }
    }



}


