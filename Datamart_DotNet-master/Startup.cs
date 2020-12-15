using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Datamart.Startup))]
namespace Datamart
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
