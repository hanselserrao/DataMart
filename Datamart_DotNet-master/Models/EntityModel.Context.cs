﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class DMProdEntities : DbContext
    {
        public DMProdEntities()
            : base("name=DMProdEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<attempt> attempts { get; set; }
        public virtual DbSet<category> categories { get; set; }
        public virtual DbSet<item> items { get; set; }
        public virtual DbSet<items_doc_references> items_doc_references { get; set; }
        public virtual DbSet<led_iom_certificate> led_iom_certificate { get; set; }
        public virtual DbSet<led_ir> led_ir { get; set; }
        public virtual DbSet<led_support_products> led_support_products { get; set; }
        public virtual DbSet<option> options { get; set; }
        public virtual DbSet<pcnitem_report> pcnitem_report { get; set; }
        public virtual DbSet<real_displaynames> real_displaynames { get; set; }
        public virtual DbSet<useractivity> useractivities { get; set; }
        public virtual DbSet<useractivitycategory> useractivitycategories { get; set; }
        public virtual DbSet<user> users { get; set; }
        public virtual DbSet<usertype> usertypes { get; set; }
        public virtual DbSet<documentitems_subtype> documentitems_subtype { get; set; }
        public virtual DbSet<eto_hasdocument> eto_hasdocument { get; set; }
        public virtual DbSet<eto_hasgadrawing> eto_hasgadrawing { get; set; }
        public virtual DbSet<eto_hasrouting> eto_hasrouting { get; set; }
        public virtual DbSet<eto_orderparts> eto_orderparts { get; set; }
        public virtual DbSet<eto_references> eto_references { get; set; }
        public virtual DbSet<eto_report> eto_report { get; set; }
        public virtual DbSet<etoitem_report> etoitem_report { get; set; }
        public virtual DbSet<itemreport_dataset> itemreport_dataset { get; set; }
        public virtual DbSet<led_support_part> led_support_part { get; set; }
        public virtual DbSet<pcn_report> pcn_report { get; set; }
        public virtual DbSet<lookup_data> lookup_data { get; set; }
        public virtual DbSet<product> products { get; set; }
    
        [DbFunction("DMProdEntities", "SplitString")]
        public virtual IQueryable<SplitString_Result> SplitString(string input, string character)
        {
            var inputParameter = input != null ?
                new ObjectParameter("Input", input) :
                new ObjectParameter("Input", typeof(string));
    
            var characterParameter = character != null ?
                new ObjectParameter("Character", character) :
                new ObjectParameter("Character", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.CreateQuery<SplitString_Result>("[DMProdEntities].[SplitString](@Input, @Character)", inputParameter, characterParameter);
        }
    
        public virtual ObjectResult<string> dockeywordsearch(string prefix)
        {
            var prefixParameter = prefix != null ?
                new ObjectParameter("prefix", prefix) :
                new ObjectParameter("prefix", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("dockeywordsearch", prefixParameter);
        }
    
        public virtual ObjectResult<string> etokeywordsearch(string prefix)
        {
            var prefixParameter = prefix != null ?
                new ObjectParameter("prefix", prefix) :
                new ObjectParameter("prefix", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("etokeywordsearch", prefixParameter);
        }
    
        public virtual int GENERATE_OPTIONS()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("GENERATE_OPTIONS");
        }
    
        public virtual ObjectResult<string> ledkeywordsearch(string prefix)
        {
            var prefixParameter = prefix != null ?
                new ObjectParameter("prefix", prefix) :
                new ObjectParameter("prefix", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("ledkeywordsearch", prefixParameter);
        }
    
        public virtual int Load_All_Sites()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("Load_All_Sites");
        }
    
        public virtual int LOAD_LED_SITE_ALL()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("LOAD_LED_SITE_ALL");
        }
    
        public virtual int NORMALIZE_ETORELATION_ALL()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("NORMALIZE_ETORELATION_ALL");
        }
    
        public virtual int NORMALIZE_ITEMS_ALL()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("NORMALIZE_ITEMS_ALL");
        }
    
        public virtual int NORMALIZE_ITEMS_DOC_REFERENCES_ALL()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("NORMALIZE_ITEMS_DOC_REFERENCES_ALL");
        }
    
        public virtual int NORMALIZE_ITEMSREPORTDSET_ALL()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("NORMALIZE_ITEMSREPORTDSET_ALL");
        }
    
        public virtual int NORMALIZE_PCN_ALL()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("NORMALIZE_PCN_ALL");
        }
    
        public virtual ObjectResult<string> pcnkeywordsearch(string prefix)
        {
            var prefixParameter = prefix != null ?
                new ObjectParameter("prefix", prefix) :
                new ObjectParameter("prefix", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("pcnkeywordsearch", prefixParameter);
        }
    
        public virtual ObjectResult<searchdocdetail_Result> searchdocdetail(Nullable<long> partid)
        {
            var partidParameter = partid.HasValue ?
                new ObjectParameter("partid", partid) :
                new ObjectParameter("partid", typeof(long));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<searchdocdetail_Result>("searchdocdetail", partidParameter);
        }
    
        public virtual ObjectResult<searchleddetail_Result> searchleddetail(Nullable<long> partid)
        {
            var partidParameter = partid.HasValue ?
                new ObjectParameter("partid", partid) :
                new ObjectParameter("partid", typeof(long));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<searchleddetail_Result>("searchleddetail", partidParameter);
        }
    
        public virtual ObjectResult<string> searchpart(string prefix)
        {
            var prefixParameter = prefix != null ?
                new ObjectParameter("prefix", prefix) :
                new ObjectParameter("prefix", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("searchpart", prefixParameter);
        }
    
        public virtual ObjectResult<searchpartdetail_Result> searchpartdetail(Nullable<long> partid)
        {
            var partidParameter = partid.HasValue ?
                new ObjectParameter("partid", partid) :
                new ObjectParameter("partid", typeof(long));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<searchpartdetail_Result>("searchpartdetail", partidParameter);
        }
    
        public virtual ObjectResult<sp_docsearch_Result> sp_docsearch(string docnumber, string docname, string legacyitemnumber, Nullable<int> docstatus, string legacydocnumber, Nullable<int> doctype, string partDescription, Nullable<int> count)
        {
            var docnumberParameter = docnumber != null ?
                new ObjectParameter("docnumber", docnumber) :
                new ObjectParameter("docnumber", typeof(string));
    
            var docnameParameter = docname != null ?
                new ObjectParameter("docname", docname) :
                new ObjectParameter("docname", typeof(string));
    
            var legacyitemnumberParameter = legacyitemnumber != null ?
                new ObjectParameter("legacyitemnumber", legacyitemnumber) :
                new ObjectParameter("legacyitemnumber", typeof(string));
    
            var docstatusParameter = docstatus.HasValue ?
                new ObjectParameter("docstatus", docstatus) :
                new ObjectParameter("docstatus", typeof(int));
    
            var legacydocnumberParameter = legacydocnumber != null ?
                new ObjectParameter("legacydocnumber", legacydocnumber) :
                new ObjectParameter("legacydocnumber", typeof(string));
    
            var doctypeParameter = doctype.HasValue ?
                new ObjectParameter("doctype", doctype) :
                new ObjectParameter("doctype", typeof(int));
    
            var partDescriptionParameter = partDescription != null ?
                new ObjectParameter("PartDescription", partDescription) :
                new ObjectParameter("PartDescription", typeof(string));
    
            var countParameter = count.HasValue ?
                new ObjectParameter("count", count) :
                new ObjectParameter("count", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_docsearch_Result>("sp_docsearch", docnumberParameter, docnameParameter, legacyitemnumberParameter, docstatusParameter, legacydocnumberParameter, doctypeParameter, partDescriptionParameter, countParameter);
        }
    
        public virtual int sp_etodetail(Nullable<int> etoid, ObjectParameter document, ObjectParameter gadrawing, ObjectParameter routing, ObjectParameter order, ObjectParameter reference)
        {
            var etoidParameter = etoid.HasValue ?
                new ObjectParameter("etoid", etoid) :
                new ObjectParameter("etoid", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_etodetail", etoidParameter, document, gadrawing, routing, order, reference);
        }
    
        public virtual ObjectResult<sp_etoSearch_Result> sp_etoSearch(string etoNumber, string projectName, string ordernumber, string customername, string gagrowing, string document, string routing, string orderparts, string reference, Nullable<int> count)
        {
            var etoNumberParameter = etoNumber != null ?
                new ObjectParameter("etoNumber", etoNumber) :
                new ObjectParameter("etoNumber", typeof(string));
    
            var projectNameParameter = projectName != null ?
                new ObjectParameter("projectName", projectName) :
                new ObjectParameter("projectName", typeof(string));
    
            var ordernumberParameter = ordernumber != null ?
                new ObjectParameter("ordernumber", ordernumber) :
                new ObjectParameter("ordernumber", typeof(string));
    
            var customernameParameter = customername != null ?
                new ObjectParameter("customername", customername) :
                new ObjectParameter("customername", typeof(string));
    
            var gagrowingParameter = gagrowing != null ?
                new ObjectParameter("gagrowing", gagrowing) :
                new ObjectParameter("gagrowing", typeof(string));
    
            var documentParameter = document != null ?
                new ObjectParameter("document", document) :
                new ObjectParameter("document", typeof(string));
    
            var routingParameter = routing != null ?
                new ObjectParameter("routing", routing) :
                new ObjectParameter("routing", typeof(string));
    
            var orderpartsParameter = orderparts != null ?
                new ObjectParameter("orderparts", orderparts) :
                new ObjectParameter("orderparts", typeof(string));
    
            var referenceParameter = reference != null ?
                new ObjectParameter("reference", reference) :
                new ObjectParameter("reference", typeof(string));
    
            var countParameter = count.HasValue ?
                new ObjectParameter("count", count) :
                new ObjectParameter("count", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_etoSearch_Result>("sp_etoSearch", etoNumberParameter, projectNameParameter, ordernumberParameter, customernameParameter, gagrowingParameter, documentParameter, routingParameter, orderpartsParameter, referenceParameter, countParameter);
        }
    
        public virtual ObjectResult<sp_LEDSearch_Result> sp_LEDSearch(string liftpartNumber, string liftDocNumber, Nullable<int> liftPartType, string liftdesc, string compwhereused, Nullable<int> liftpartStatus, string productwhere, string hasCertification, string hasInsDoc, string tare, string wll, Nullable<double> tarevalue, Nullable<double> wllvalue, Nullable<int> searchBy, Nullable<int> count)
        {
            var liftpartNumberParameter = liftpartNumber != null ?
                new ObjectParameter("liftpartNumber", liftpartNumber) :
                new ObjectParameter("liftpartNumber", typeof(string));
    
            var liftDocNumberParameter = liftDocNumber != null ?
                new ObjectParameter("liftDocNumber", liftDocNumber) :
                new ObjectParameter("liftDocNumber", typeof(string));
    
            var liftPartTypeParameter = liftPartType.HasValue ?
                new ObjectParameter("liftPartType", liftPartType) :
                new ObjectParameter("liftPartType", typeof(int));
    
            var liftdescParameter = liftdesc != null ?
                new ObjectParameter("liftdesc", liftdesc) :
                new ObjectParameter("liftdesc", typeof(string));
    
            var compwhereusedParameter = compwhereused != null ?
                new ObjectParameter("Compwhereused", compwhereused) :
                new ObjectParameter("Compwhereused", typeof(string));
    
            var liftpartStatusParameter = liftpartStatus.HasValue ?
                new ObjectParameter("liftpartStatus", liftpartStatus) :
                new ObjectParameter("liftpartStatus", typeof(int));
    
            var productwhereParameter = productwhere != null ?
                new ObjectParameter("Productwhere", productwhere) :
                new ObjectParameter("Productwhere", typeof(string));
    
            var hasCertificationParameter = hasCertification != null ?
                new ObjectParameter("hasCertification", hasCertification) :
                new ObjectParameter("hasCertification", typeof(string));
    
            var hasInsDocParameter = hasInsDoc != null ?
                new ObjectParameter("hasInsDoc", hasInsDoc) :
                new ObjectParameter("hasInsDoc", typeof(string));
    
            var tareParameter = tare != null ?
                new ObjectParameter("tare", tare) :
                new ObjectParameter("tare", typeof(string));
    
            var wllParameter = wll != null ?
                new ObjectParameter("wll", wll) :
                new ObjectParameter("wll", typeof(string));
    
            var tarevalueParameter = tarevalue.HasValue ?
                new ObjectParameter("tarevalue", tarevalue) :
                new ObjectParameter("tarevalue", typeof(double));
    
            var wllvalueParameter = wllvalue.HasValue ?
                new ObjectParameter("wllvalue", wllvalue) :
                new ObjectParameter("wllvalue", typeof(double));
    
            var searchByParameter = searchBy.HasValue ?
                new ObjectParameter("SearchBy", searchBy) :
                new ObjectParameter("SearchBy", typeof(int));
    
            var countParameter = count.HasValue ?
                new ObjectParameter("count", count) :
                new ObjectParameter("count", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_LEDSearch_Result>("sp_LEDSearch", liftpartNumberParameter, liftDocNumberParameter, liftPartTypeParameter, liftdescParameter, compwhereusedParameter, liftpartStatusParameter, productwhereParameter, hasCertificationParameter, hasInsDocParameter, tareParameter, wllParameter, tarevalueParameter, wllvalueParameter, searchByParameter, countParameter);
        }
    
        public virtual int sp_ledsearchdetail(Nullable<int> ledid, ObjectParameter document, ObjectParameter certification, ObjectParameter partwhere, ObjectParameter productwhere)
        {
            var ledidParameter = ledid.HasValue ?
                new ObjectParameter("ledid", ledid) :
                new ObjectParameter("ledid", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_ledsearchdetail", ledidParameter, document, certification, partwhere, productwhere);
        }
    
        public virtual ObjectResult<sp_partsearch_Result> sp_partsearch(string itemnumber, string legacyitemnumber, Nullable<int> itemstatus, string docnumber, string legacydocnumber, Nullable<int> itemtype, string partDescription, Nullable<int> count)
        {
            var itemnumberParameter = itemnumber != null ?
                new ObjectParameter("itemnumber", itemnumber) :
                new ObjectParameter("itemnumber", typeof(string));
    
            var legacyitemnumberParameter = legacyitemnumber != null ?
                new ObjectParameter("legacyitemnumber", legacyitemnumber) :
                new ObjectParameter("legacyitemnumber", typeof(string));
    
            var itemstatusParameter = itemstatus.HasValue ?
                new ObjectParameter("itemstatus", itemstatus) :
                new ObjectParameter("itemstatus", typeof(int));
    
            var docnumberParameter = docnumber != null ?
                new ObjectParameter("docnumber", docnumber) :
                new ObjectParameter("docnumber", typeof(string));
    
            var legacydocnumberParameter = legacydocnumber != null ?
                new ObjectParameter("legacydocnumber", legacydocnumber) :
                new ObjectParameter("legacydocnumber", typeof(string));
    
            var itemtypeParameter = itemtype.HasValue ?
                new ObjectParameter("itemtype", itemtype) :
                new ObjectParameter("itemtype", typeof(int));
    
            var partDescriptionParameter = partDescription != null ?
                new ObjectParameter("PartDescription", partDescription) :
                new ObjectParameter("PartDescription", typeof(string));
    
            var countParameter = count.HasValue ?
                new ObjectParameter("count", count) :
                new ObjectParameter("count", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_partsearch_Result>("sp_partsearch", itemnumberParameter, legacyitemnumberParameter, itemstatusParameter, docnumberParameter, legacydocnumberParameter, itemtypeParameter, partDescriptionParameter, countParameter);
        }
    
        public virtual int sp_pcndetail(Nullable<int> pcnid, ObjectParameter problem, ObjectParameter solution, ObjectParameter impacted)
        {
            var pcnidParameter = pcnid.HasValue ?
                new ObjectParameter("pcnid", pcnid) :
                new ObjectParameter("pcnid", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_pcndetail", pcnidParameter, problem, solution, impacted);
        }
    
        public virtual ObjectResult<sp_pcnimpacteddetail_Result> sp_pcnimpacteddetail(Nullable<int> pcnid)
        {
            var pcnidParameter = pcnid.HasValue ?
                new ObjectParameter("pcnid", pcnid) :
                new ObjectParameter("pcnid", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_pcnimpacteddetail_Result>("sp_pcnimpacteddetail", pcnidParameter);
        }
    
        public virtual ObjectResult<sp_pcnproblemdetail_Result> sp_pcnproblemdetail(Nullable<int> pcnid)
        {
            var pcnidParameter = pcnid.HasValue ?
                new ObjectParameter("pcnid", pcnid) :
                new ObjectParameter("pcnid", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_pcnproblemdetail_Result>("sp_pcnproblemdetail", pcnidParameter);
        }
    
        public virtual ObjectResult<sp_pcnsearch_Result> sp_pcnsearch(string pcnNumber, string pcndesc, string problem, string solution, string impected, Nullable<int> count)
        {
            var pcnNumberParameter = pcnNumber != null ?
                new ObjectParameter("pcnNumber", pcnNumber) :
                new ObjectParameter("pcnNumber", typeof(string));
    
            var pcndescParameter = pcndesc != null ?
                new ObjectParameter("pcndesc", pcndesc) :
                new ObjectParameter("pcndesc", typeof(string));
    
            var problemParameter = problem != null ?
                new ObjectParameter("problem", problem) :
                new ObjectParameter("problem", typeof(string));
    
            var solutionParameter = solution != null ?
                new ObjectParameter("solution", solution) :
                new ObjectParameter("solution", typeof(string));
    
            var impectedParameter = impected != null ?
                new ObjectParameter("impected", impected) :
                new ObjectParameter("impected", typeof(string));
    
            var countParameter = count.HasValue ?
                new ObjectParameter("count", count) :
                new ObjectParameter("count", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_pcnsearch_Result>("sp_pcnsearch", pcnNumberParameter, pcndescParameter, problemParameter, solutionParameter, impectedParameter, countParameter);
        }
    
        public virtual int sp_pcnsolutiondetail(Nullable<int> pcnid)
        {
            var pcnidParameter = pcnid.HasValue ?
                new ObjectParameter("pcnid", pcnid) :
                new ObjectParameter("pcnid", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_pcnsolutiondetail", pcnidParameter);
        }
    
        public virtual int TRUNCATE_DMPROD_LED()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("TRUNCATE_DMPROD_LED");
        }
    
        public virtual int usp_SendTextEmail(string serverAddr, string from, string to, string subject, string bodytext, string user, string password, Nullable<int> sSLConnection, Nullable<int> serverPort)
        {
            var serverAddrParameter = serverAddr != null ?
                new ObjectParameter("ServerAddr", serverAddr) :
                new ObjectParameter("ServerAddr", typeof(string));
    
            var fromParameter = from != null ?
                new ObjectParameter("From", from) :
                new ObjectParameter("From", typeof(string));
    
            var toParameter = to != null ?
                new ObjectParameter("To", to) :
                new ObjectParameter("To", typeof(string));
    
            var subjectParameter = subject != null ?
                new ObjectParameter("Subject", subject) :
                new ObjectParameter("Subject", typeof(string));
    
            var bodytextParameter = bodytext != null ?
                new ObjectParameter("Bodytext", bodytext) :
                new ObjectParameter("Bodytext", typeof(string));
    
            var userParameter = user != null ?
                new ObjectParameter("User", user) :
                new ObjectParameter("User", typeof(string));
    
            var passwordParameter = password != null ?
                new ObjectParameter("Password", password) :
                new ObjectParameter("Password", typeof(string));
    
            var sSLConnectionParameter = sSLConnection.HasValue ?
                new ObjectParameter("SSLConnection", sSLConnection) :
                new ObjectParameter("SSLConnection", typeof(int));
    
            var serverPortParameter = serverPort.HasValue ?
                new ObjectParameter("ServerPort", serverPort) :
                new ObjectParameter("ServerPort", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_SendTextEmail", serverAddrParameter, fromParameter, toParameter, subjectParameter, bodytextParameter, userParameter, passwordParameter, sSLConnectionParameter, serverPortParameter);
        }
    }
}
