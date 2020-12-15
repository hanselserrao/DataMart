using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using DatamartAPI.Log;
using DatamartAPI.Database;
using System.Data;
using System.Collections;

namespace DatamartAPI.Controllers
{
    [RoutePrefix("document")]
    public class DocumentController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        [Route("getFile")]  // unconstrained parameter
        public HttpResponseMessage GetFile(string drawingID)
        {
            Logger.LogInfo("Document Webservice called");
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            if (String.IsNullOrEmpty(drawingID))
                return Request.CreateResponse(HttpStatusCode.BadRequest);

            string localFilePath;
            localFilePath = getDocumentFilePath(drawingID);

            if (!File.Exists(localFilePath))
            {
                //Throw 404 (Not Found) exception if File not found.
                response.StatusCode = HttpStatusCode.NotFound;
                response.ReasonPhrase = string.Format("File not found for {0} .", drawingID);
                throw new HttpResponseException(response);
            }
            FileInfo fileIn = new FileInfo(localFilePath);
            string fileName = fileIn.Name;

            response.Content = new StreamContent(new FileStream(localFilePath, FileMode.Open, FileAccess.Read));
            response.Content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment");
            response.Content.Headers.ContentDisposition.FileName = fileName;
            response.Content.Headers.ContentType = new MediaTypeHeaderValue(System.Web.MimeMapping.GetMimeMapping(fileName));//new MediaTypeHeaderValue("application/pdf");

            return response;
        }

        private string getDocumentFilePath(string drawingID)
        {
            DataSet ds = null;
            using (IDatabase db = new SqlDatabase())
            {
                try
                {
                    ArrayList list = new ArrayList();
                    list.Add(new KeyValuePair<string, string>("@drawingID", drawingID));
                    ds = db.ExecuteDataSet("[dbo].[sp_getDocumentFilePath]", CommandType.StoredProcedure, list);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        return ds.Tables[0].Rows[0]["fileurl"].ToString();
                    }
                    else
                    {
                        return "";
                    }
                }
                catch (Exception ex)
                {
                    Logger.LogException(ex);
                    return "";
                }
            }
            return "";
        }
        
        // POST api/<controller>
        public void Post([FromBody]string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
        /*
        [Route("getfile/{drawingID}")]  // unconstrained parameter
        public string GetFile(string drawingID)
        {
            Log.Logger.LogInfo("Document Webservice called");
            return "value3:" + drawingID;
        }
        */

        // GET api/<controller>/5
        //[Route("GetDocument/{id}")]
        /*
        [Route("{id}")]
        public string GetData(string id)
        {
            Log.Logger.LogInfo("Document Webservice called");
            return "value2" + id;
        }
        public string Get(string id)
        {
            Log.Logger.LogInfo("Document Webservice called");
            return "value1" + id;
        }


        */

    }

    internal class FileContentResult : IActionResult
    {
        private object fileData;
        private string v;

        public FileContentResult(object fileData, string v)
        {
            this.fileData = fileData;
            this.v = v;
        }
    }

    public interface IActionResult
    {
    }
}