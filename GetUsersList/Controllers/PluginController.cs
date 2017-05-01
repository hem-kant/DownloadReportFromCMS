using Alchemy4Tridion.Plugins;
using System;
using System.Linq;
using System.Net.Http;
using System.Web.Http;
using System.Xml;
using Tridion.ContentManager.CoreService.Client;
using Newtonsoft.Json;
using System.Text;
using System.Security.Cryptography;
using System.IO;
using System.Collections.Generic;
using GetUsersList.Model;
using GetUsersList.Helper;
using Newtonsoft.Json.Linq;
using System.Xml.Linq;

namespace GetUsersList.Controllers
{
    /// <summary>
    /// An ApiController to create web services that your plugin can interact with.
    /// </summary>
    /// <remarks>
    /// The AlchemyRoutePrefix accepts a Service Name as its first parameter.  This will be used by both
    /// the generated Url's as well as the generated JS proxy.
    /// <c>/Alchemy/Plugins/{YourPluginName}/api/{ServiceName}/{action}</c>
    /// <c>Alchemy.Plugins.YourPluginName.Api.Service.action()</c>
    /// 
    /// The attribute is optional and if you exclude it, url's and methods will be attached to "api" instead.
    /// <c>/Alchemy/Plugins/{YourPluginName}/api/{action}</c>
    /// <c>Alchemy.Plugins.YourPluginName.Api.action()</c>
    /// </remarks>
    [AlchemyRoutePrefix("Service")]
    public class PluginController : AlchemyApiController
    {
        /// // GET /Alchemy/Plugins/{YourPluginName}/api/{YourServiceName}/YourRoute
        /// <summary>
        /// Just a simple example..
        /// </summary>
        /// <returns>A string "Your Response" as the response message.</returns>
        /// </summary>
        /// <remarks>
        /// All of your action methods must have both a verb attribute as well as the RouteAttribute in
        /// order for the js proxy to work correctly.
        /// </remarks>
        /// 
        [Route("AjaxMethod")]
        [HttpPost]
        public PersonModel AjaxMethod(PersonModel person)
        {
            person.dateTime = DateTime.Now.ToString();
            return person;
        }

        [HttpGet]
        [Route("GetUserListData")]
        public List<TridionUserDetails> GetUserListData()
        {
            List<TridionUserDetails> AuthorList = new List<TridionUserDetails>();
            var filter = new UsersFilterData { IsPredefined = false };
            var users = Client.GetSystemWideList(filter);
            foreach (TrusteeData user in users)
            {
                AuthorList.Add(new TridionUserDetails(user.Id, user.Description, user.Title, user.IsEditable));
            }
            return AuthorList;
        }

        [HttpGet]
        [Route("GetPublicationList")]
        public List<pubItem> GetPublicationList()
        {
            XmlDocument publicationList = new XmlDocument();
            PublicationsFilterData filter = new PublicationsFilterData();
            XElement publications = Client.GetSystemWideListXml(filter);
            publicationList.Load(publications.CreateReader());
            ListPublications pubList = TransformObjectAndXml.Deserialize<ListPublications>(publicationList);
            List<pubItem> Item = pubList.Item;
            List<pubItem> Item2 = new List<pubItem>();
            foreach (var item in Item)
            {
                var splitTCMID = item.ID.Split('-');
                item.ID = splitTCMID[1];
                Item2.Add(item);
            }
            return Item2;
        }

        [HttpPost]
        [Route("AjaxGetComponent")]
        public ListItems AjaxGetComponent(JObject pubId)
        {
            var itemTypes = new List<ItemType>();
            dynamic json = pubId;
            DateTime endDate = DateTime.Now;
            if (json.itemType=="16")
            {
                itemTypes.Add(ItemType.Component);
            }
            if (json.itemType == "32")
            {
                itemTypes.Add(ItemType.ComponentTemplate);
            }
            if (json.itemType == "64")
            {
                itemTypes.Add(ItemType.Page);
            }
            if (json.itemType == "512")
            {
                itemTypes.Add(ItemType.Category);
            }
            if (json.itemType == "1024")
            {
                itemTypes.Add(ItemType.Keyword);
            }
            if (json.itemType == "8")
            {
                itemTypes.Add(ItemType.Schema);
            }
            if (json.itemType == "2")
            {
                itemTypes.Add(ItemType.StructureGroup);
            }
            if (json.itemType == "2048")
            {
                itemTypes.Add(ItemType.TemplateBuildingBlock);
            }
            if (json.itemType == "128")
            {
                itemTypes.Add(ItemType.PageTemplate);
            }
            var filtera = new RepositoryItemsFilterData();
            filtera.Recursive = true;
            filtera.ItemTypes = itemTypes.ToArray();
            //var listXml = Client.GetListXml(json.pubId, filtera);

            var listXml = Client.GetListXml("tcm:0-" + json.pubId + "-1", filtera);
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(listXml.ToString());
            ListItems compList = TransformObjectAndXml.Deserialize<ListItems>(doc);

            return compList;
        }
        [HttpGet]
        [Route("Hello")]
        public string SayHello()
        {
            //List<TridionUserDetails> AuthorList = new List<TridionUserDetails>();
            //var filter = new UsersFilterData { IsPredefined = false };
            //var users = Client.GetSystemWideList(filter);
            var itemTypes = new List<ItemType>();
            //itemTypes.Add(ItemType.Page);
            itemTypes.Add(ItemType.Component);

            var filtera = new RepositoryItemsFilterData();
            filtera.Recursive = true;
            filtera.ItemTypes = itemTypes.ToArray();

            var listXml = Client.GetListXml("tcm:0-6-1", filtera);
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(listXml.ToString());
            string json = JsonConvert.SerializeXmlNode(doc);

            //foreach (TrusteeData user in users)
            //{
            //    //if (user.Id == "tcm:0-15-65552" || user.Id == "tcm:0-15-65552")
            //    //{
            //        AuthorList.Add(new TridionUserDetails(user.Id, user.Description, user.Title, user.IsEditable));
            //    //}

            //}
            //var output = JsonConvert.SerializeObject(AuthorList);

            return json;
        }
    }
}
public class PersonModel
{
    ///<summary>
    /// Gets or sets Name.
    ///</summary>
    public string name { get; set; }

    ///<summary>
    /// Gets or sets DateTime.
    ///</summary>
    public string dateTime { get; set; }
}
public class TridionUserDetails
{
    private string tcmuri;
    private string name;
    private string title;
    private bool? isEditable;


    public TridionUserDetails(string tcmuri, string name, string title, bool? isEditable)
    {
        this.tcmuri = tcmuri;
        this.name = name;
        this.title = title;
        this.isEditable = isEditable;


    }

    public string Tcmuri
    {
        get { return tcmuri; }
        set { tcmuri = value; }
    }

    public string Name
    {
        get { return name; }
        set { name = value; }
    }
    public string UserId
    {
        get { return title; }
        set { title = value; }
    }

    public bool? IsEditable
    {
        get { return isEditable; }
        set { isEditable = value; }
    }


}