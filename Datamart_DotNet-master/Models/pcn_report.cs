//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Datamart.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class pcn_report
    {
        public int pid { get; set; }
        public string pcnid { get; set; }
        public string revision { get; set; }
        public string pcnname { get; set; }
        public string description { get; set; }
        public string synopsis { get; set; }
        public Nullable<int> createduser { get; set; }
        public Nullable<System.DateTime> createdtm { get; set; }
        public Nullable<int> lastmoduser { get; set; }
        public Nullable<System.DateTime> lastmoddtm { get; set; }
        public Nullable<int> status { get; set; }
        public string site { get; set; }
    }
}
