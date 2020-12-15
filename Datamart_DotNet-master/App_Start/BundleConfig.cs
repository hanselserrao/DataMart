using System.Web;
using System.Web.Optimization;

namespace Datamart
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));



            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at https://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                     
                        "~/Scripts/angular.js",
                                 //"~/Scripts/angular.min.js",
                                 "~/Scripts/angular-material.js",
                         "~/Scripts/angular-animate.min.js",
                          "~/Scripts/angular-aria.min.js",
                           //"~/Scripts/angular-messages.min.js",

                           "~/Scripts/loading-bar.js",
                       "~/Scripts/autocomplete.js",
                      "~/Scripts/dirPagination.js",
                      "~/Scripts/component.js"));

            bundles.Add(new ScriptBundle("~/bundles/appmodule").Include(
                      "~/Scripts/Service/service.js",
                      "~/Scripts/Controller/MainController.js",
                      "~/Scripts/Controller/Home/IndexController.js",
                      "~/Scripts/Controller/Admin/IndexController.js"
                      ));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                    
                      "~/Content/style.css",
                       "~/Content/loading-bar.css",
                        "~/Content/angular-material.css",
                         "~/Content/autocomplete.css"
                         ));
        }
    }
}
