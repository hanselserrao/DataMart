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
    
    public partial class itemreport_dataset
    {
        public int bid { get; set; }
        public Nullable<int> iid { get; set; }
        public string datasetname { get; set; }
        public string datasetdesc { get; set; }
        public Nullable<int> datasettype { get; set; }
        public Nullable<int> datasetstatus { get; set; }
        public Nullable<int> status { get; set; }
        public int createduser { get; set; }
        public System.DateTime createdtm { get; set; }
        public int lastmoduser { get; set; }
        public System.DateTime lastmoddtm { get; set; }
        public Nullable<int> documenttype { get; set; }
        public string pwnt_path { get; set; }
        public string psd_path { get; set; }
        public string pfile_name { get; set; }
        public string site { get; set; }
    }
}
