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
    
    public partial class attempt
    {
        public int attemptid { get; set; }
        public string usr { get; set; }
        public string pwd { get; set; }
        public string ip { get; set; }
        public System.DateTime ts { get; set; }
        public string browser { get; set; }
        public Nullable<int> systemid { get; set; }
        public string devicetype { get; set; }
        public string uniqueid { get; set; }
        public int attempts_status { get; set; }
        public string system_info { get; set; }
    }
}