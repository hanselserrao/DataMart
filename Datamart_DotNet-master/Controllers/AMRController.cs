using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Mvc;
using Datamart.Models;
using System.Configuration;


namespace Datamart.Controllers
{
    public class AMRController : Controller
    {
        DMProdEntities model = new DMProdEntities();
        public ActionResult DataPage()
        {
            return View();
        }

        public ActionResult AMRSearch(string amrType, string amrEmail, string amrStatus, string amrItemNo, string amrRequestNo, string amrNewMaterialCode, string amrPartDescription)
        {
            //if (Convert.ToString(Session["username"]) != "")
            //{
            amrEmail = amrEmail != "undefined" ? amrEmail : "";
            amrItemNo = amrItemNo != "undefined" ? amrItemNo.Replace("_", "[_]") : "";
            amrRequestNo = amrRequestNo != "undefined" ? amrRequestNo.Replace("_", "[_]") : "";
            amrNewMaterialCode = amrNewMaterialCode != "undefined" ? amrNewMaterialCode : "";
            amrPartDescription = amrPartDescription != "undefined" ? amrPartDescription.Replace("_", "[_]") : "";

            string query = "exec [sp_displayamrrequest] '" + amrType + "','" + amrEmail + "','" + amrStatus + "','" + amrItemNo + "','" + amrRequestNo + "','" + amrNewMaterialCode + "','" + amrPartDescription + "'";
            var data = Mainclass.Display("exec [sp_displayamrrequest] '" + amrType + "','" + amrEmail + "','" + amrStatus + "','" + amrItemNo + "','" + amrRequestNo + "','" + amrNewMaterialCode + "','" + amrPartDescription + "'");
            /*model.sp_partsearch(Partnumber, LegPartNumer, prtstatus, dconum, LegDocNumber, parttyp).ToList();*/
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
            //}
            //else
            //    return Json("1", JsonRequestBehavior.AllowGet);

        }

        public string UploadFile()
        {
            string filepath = string.Empty;
            try
            {
                filepath = ConfigurationManager.AppSettings["UploadFilePath"] + Request.Files[0].FileName;
                //string path = Server.MapPath(filepath);
                Request.Files[0].SaveAs(filepath);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return filepath;
        }


        public int SendAMRMail(string email, string productid, string partNumber, string amrType, string file_path, string productName, string partDescription, string remarks)
        {
            string to = email;
            string cc = string.Empty;
            int result = 1;
            if  (productid != "" && productid != "0")
            {
                int product = Convert.ToInt32(productid);
                var dta = model.products.Where(a => a.ProductID == product).FirstOrDefault();
                if (dta.ProductOwnerEmail != null && dta.ProductOwnerEmail != "")
                {
                    to = dta.ProductOwnerEmail;
                    cc = email;
                }
            }

            try
            {
                string mailBody = ConfigurationManager.AppSettings["AMRMailBody"];
                string mailSubject = ConfigurationManager.AppSettings["AMRMailSubject"];
                if (amrType == "AMR Request")
                {
                    mailBody = string.Format(mailBody, amrType, email,partNumber, partDescription,"");
                }
                else if (amrType == "Data Issue")
                {
                    mailBody = string.Format(mailBody, amrType, email, partNumber, partDescription, "Product :- " + productName + "<BR>Remarks :-" + remarks.Replace("\\n","<br>"));
                }
                else if (amrType == "Request For Basic Data")
                {
                    mailBody = string.Format(mailBody, "new request for Basic Data", email, partNumber, partDescription, "Product :- " + productName + "<BR>Remarks :-" + remarks.Replace("\\n", "<br>"));
                }
                //mailBody = string.Format(mailBody, "<b>" + email + "</b>", "<b>" + partNumber + "</b>", "<b>" + amrType + "</b>");
                mailSubject = string.Format(mailSubject, amrType, partNumber);
                Mainclass.BuildEmail(to, mailSubject, mailBody, cc, file_path);
                result =  0;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result; 
        }



        [HttpPost]
        public ActionResult CreateAMRRequest(string amrType, string amrTypeName, string userEmail, string amrPartStatus, string amrPartNo, string amrPartDescription, string amrNewMaterialCode, string amrExistingMaterial, string amrRequestNumber, string amrDrawingNumber, string amrDrawingRevNo, string amrSite, string amrPriority, string amrDCO, string amrDueDate, string amrCastingRequest, string productId, string remarks, string productName, string file_data)
        {
            try
            {
                if (Request.Files.Count > 0)
                {
                    file_data = UploadFile();
                }
                else
                {
                    file_data = "";
                }
                amrType = amrType != "undefined" ? amrType : "0";
                userEmail = userEmail != "undefined" ? userEmail : "";
                amrPartStatus = amrPartStatus != "undefined" ? amrPartStatus : "0";
                amrPartNo = amrPartNo != "undefined" ? amrPartNo : "";
                amrPartDescription = amrPartDescription != "undefined" ? amrPartDescription : "";
                amrNewMaterialCode = amrNewMaterialCode != "undefined" ? amrNewMaterialCode : "";
                amrExistingMaterial = amrExistingMaterial != "undefined" ? amrExistingMaterial : "";
                amrRequestNumber = amrRequestNumber != "undefined" ? amrRequestNumber : "";
                amrDrawingNumber = amrDrawingNumber != "undefined" ? amrDrawingNumber : "";
                amrDrawingRevNo = amrDrawingRevNo != "undefined" ? amrDrawingRevNo : "";
                amrSite = amrSite != "undefined" ? amrSite : "";
                amrPriority = amrPriority != "undefined" ? amrPriority : "";
                amrDCO = amrDCO != "undefined" ? amrDCO : "";
                amrDueDate = amrDueDate != "undefined" ? amrDueDate : "";
                amrCastingRequest = amrCastingRequest != "undefined" ? amrCastingRequest : "";
                productId = productId != "undefined" ? productId : "";
                productName = productName != "undefined" ? productName : "";
                file_data = file_data != "undefined" ? file_data : "";
                remarks = remarks != "undefined" ? remarks : "";
                remarks = remarks.Replace("\n", "\\n");
                //var data = Mainclass.Display(@"exec [sp_createamrrequest] '" + amrType + "','" + userEmail + "','" + amrPartStatus + "','" + amrPartNo + "','" + amrPartDescription + "','" + amrNewMaterialCode + "','" + amrExistingMaterial + "','" + amrRequestNumber + "','" + amrDrawingNumber + "','" + amrDrawingRevNo + "','" + amrSite + "','" + amrPriority + "','" + amrDCO + "','" + amrDueDate + "','" + amrCastingRequest + "','" + productId + "','" + file_data + "','" + remarks + "'");

                var data = Mainclass.Display("exec [sp_createamrrequest] @amr_type_id = '" + amrType + "', @requested_by = '" + userEmail + "', @status = '" + amrPartStatus + "', @item_no = '" + amrPartNo + "', @part_description = '" + amrPartDescription + "', @new_material_code = '" + amrNewMaterialCode + "', @existing_material_code = '" + amrExistingMaterial + "', @request_no = '" + amrRequestNumber + "', @drawing_no = '" + amrDrawingNumber + "', @drawing_rev_no = '" + amrDrawingRevNo + "', @site = '" + amrSite + "', @priority = '" + amrPriority + "', @dco = '" + amrDCO + "', @due_date = '" + amrDueDate + "', @casting_requested = '" + amrCastingRequest + "', @productid = '" + productId + "', @file_path = '" + file_data + "', @remarks = '" + remarks + "'");


                if (data != null && data.Count > 0)
                {
                    
                    if (data[0]["ErrorNumber"].ToString() == "0")
                    {
                        try
                        {
                            SendAMRMail(userEmail, productId, amrPartNo, amrTypeName, file_data, productName, amrPartDescription, remarks);
                        }
                        catch (Exception ex)
                        {
                            return Json(new { ErrorNumber = 2, ErrorMessage = "AMR Record saved. Email failed  :" + ex.Message }, JsonRequestBehavior.AllowGet);
                        }
                    }
                    var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
                    string errorno = data[0]["ErrorNumber"].ToString();
                    string errmsg = data[0]["ErrorMessage"].ToString();
                    return Json(new { ErrorNumber = errorno, ErrorMessage = errmsg }, JsonRequestBehavior.AllowGet);

                }
                else
                {
                    return Json(new { ErrorNumber = 1, ErrorMessage = "Unexpected Error in Database Procedure" }, JsonRequestBehavior.AllowGet);
                }
                /*model.sp_partsearch(Partnumber, LegPartNumer, prtstatus, dconum, LegDocNumber, parttyp).ToList();*/
            }
            catch (Exception ex)
            {
                return Json(new { ErrorNumber = 1, ErrorMessage = ex.Message }, JsonRequestBehavior.AllowGet);

            }
        }


        public JsonResult GetAMRType()
        {
            var data = model.options.Where(a => a.categoryid == 8).Select(n => new { oid = n.oid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetProduct()
        {
            var data = model.products.Select(n => new { oid = n.ProductID, name = n.ProductCode}).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetAMRStatus()
        {
            var data = model.options.Where(a => a.categoryid == 9).Select(n => new { oid = n.oid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetPartStatus()
        {
            var data = model.options.Where(a => a.categoryid == 2).Select(n => new { oid = n.oid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetSite()
        {
            var data = model.options.Where(a => a.categoryid == 10).Select(n => new { oid = n.oid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetPriority()
        {
            var data = model.options.Where(a => a.categoryid == 11).Select(n => new { oid = n.oid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetDCO()
        {
            var data = model.options.Where(a => a.categoryid == 5).Select(n => new { oid = n.oid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }

    }
}