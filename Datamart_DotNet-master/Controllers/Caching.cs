using System;
using System.Runtime.Caching;
using Datamart.Models;
using System.Linq;

namespace Datamart.Controllers
{
    public static class Caching
    {
        public static T GetObjectFromCache<T>(string cacheItemName, int cacheTimeInMinutes, Func<T> objectSettingFunction)
        {
            ObjectCache cache = MemoryCache.Default;
            var cachedObject = (T)cache[cacheItemName];
            if (cachedObject == null)
            {
                CacheItemPolicy policy = new CacheItemPolicy();
                policy.AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(cacheTimeInMinutes);
                cachedObject = objectSettingFunction();
                cache.Set(cacheItemName, cachedObject, policy);
            }
            return cachedObject;
        }

        public static String getETLLastUpdate()
        {
            DMProdEntities model = new DMProdEntities();
            var data = model.lookup_data.Where(a => a.code == "ETL_LAST_UPDATE").Select(n => new {value = n.value}).ToList();
            if (data != null && data.Count >= 1)
            {
                return data[0].value;
            }
            else
            {
                return "Unavailable in Database";
            }
            //return Json(data.OrderBy(a => a.name), System.Web.Mvc.JsonRequestBehavior.AllowGet);
        }
    }
}