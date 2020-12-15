using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;
using Datamart.Models;

namespace Datamart.Controllers
{
    public class AdminController : Controller
    {
        DMProdEntities model = new DMProdEntities();

        public ActionResult DataPage()
        {

            return View();
        }

        public ActionResult UserSearch(string userID, string email, string userName, string userRole)
        {
            //if (Convert.ToString(Session["username"]) != "")
            //{
            userID = userID != "undefined" ? userID : "";
            userID = userID != "null" ? userID.Replace("_", "[_]") : "";
            email = email != "undefined" ? email.Replace("_", "[_]") : "";
            userName = userName != "undefined" ? userName : "";
            userRole = userRole != "undefined" ? userRole.Replace("_", "[_]") : "";


            var data = Mainclass.Display("exec [sp_displayuser] '" + userID + "','" + email + "','" + userName + "','" + userRole + "'");
            /*model.sp_partsearch(Partnumber, LegPartNumer, prtstatus, dconum, LegDocNumber, parttyp).ToList();*/
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
            //}
            //else
            //    return Json("1", JsonRequestBehavior.AllowGet);

        }

        public ActionResult AddUser(string userEmail, string usrRole, string firstName, string lastName, string userId, string appPwd, string userTitle, string companyName, string userPhone, string userFax)
        {
            userEmail = userEmail != "undefined" ? userEmail : "";
            usrRole = usrRole != "undefined" ? usrRole : "";
            firstName = firstName != "undefined" ? firstName : "";
            lastName = lastName != "undefined" ? lastName : "";
            appPwd = appPwd != "undefined" ? appPwd : "";
            //byte[] array = System.Text.Encoding.ASCII.GetBytes(appPwd);
            //appPwd = Mainclass.ByteArrayToString(array);
            userTitle = userTitle != "undefined" ? userTitle : "";
            companyName = companyName != "undefined" ? companyName : "";
            userPhone = userPhone != "undefined" ? userPhone : "";
            userFax = userFax != "undefined" ? userFax : "";
            userId = userId != "undefined" ? userId.Replace("_", "[_]") : "";

            string query = "exec [sp_adduserapp] '" + userEmail + "','" + usrRole + "','" + firstName + "','" + lastName + "','" + userId + "','" + appPwd + "','" + userTitle + "','" + companyName + "','" + userPhone + "','" + userFax + "'";
            var data = Mainclass.Display("exec [sp_adduserapp] '" + userEmail + "','" + usrRole + "','" + firstName + "','" + lastName + "','" + userId + "','" + appPwd + "','" + userTitle + "','" + companyName + "','" + userPhone + "','" + userFax + "'");
            /*model.sp_partsearch(Partnumber, LegPartNumer, prtstatus, dconum, LegDocNumber, parttyp).ToList();*/
            var jsonResult = Json(data, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
            //}
            //else
            //    return Json("1", JsonRequestBehavior.AllowGet);

        }

        public JsonResult GetUserType()
        {
            var data = model.usertypes.Select(n => new { utid = n.utid, name = n.name }).ToList();
            return Json(data.OrderBy(a => a.name), JsonRequestBehavior.AllowGet);
        }


    }
}
