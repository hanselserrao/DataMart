using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Datamart.Models
{
    public class PCN
    {
        public Dictionary<string, int> problem = new Dictionary<string, int>();
        public Dictionary<string, int> solution = new Dictionary<string, int>();
        public Dictionary<string, int> impacted = new Dictionary<string, int>();
    }
}