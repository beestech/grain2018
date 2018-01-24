using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.User.Query
{
    public partial class businessStatisticsDetail : System.Web.UI.Page
    {
        public double numTotol = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string account= Request.QueryString["account"];
                string vid = Request.QueryString["vId"];
                if (!string.IsNullOrWhiteSpace(account)&&!string.IsNullOrWhiteSpace(vid))
                {
                    BindDDL(account);
                    LoadData(account,vid);
                }
            }
        }

        private void BindDDL(string account)
        {
            string sql = @"SELECT distinct Dep_StorageInfo.VarietyID,StorageVariety.strName FROM Dep_StorageInfo inner join StorageVariety on StorageVariety.ID=Dep_StorageInfo.VarietyID
 where AccountNumber='" + account + "'";
            var dt = SQLHelper.ExecuteDataTable(sql);
            ddlVariety.DataSource = dt;
            ddlVariety.DataTextField = "strName";
            ddlVariety.DataValueField = "VarietyID";
            ddlVariety.DataBind();
            ddlVariety.Items.Insert(0, new ListItem("请选择", ""));
            ddlVariety.Items.Insert(1, new ListItem("全部", ""));
            if (!string.IsNullOrWhiteSpace(Request.QueryString["vId"]))
            {
                ddlVariety.SelectedValue = Request.QueryString["vId"];
            }            

        }

        /// <summary>
        /// 初始化加载数据
        /// </summary>
        /// <param name="AccountNumber">储户账号</param>
        /// <param name="vId">VarietyID</param>
        private void LoadData(string AccountNumber,string vId)
        {            
            //查询账户 
            //DataTable dt = common.getDepInfo(AccountNumber, Convert.ToBoolean(Session["ISHQ"]), Session["WB_ID"].ToString());

            StringBuilder strSql = new StringBuilder();
            strSql.Append("   select ID,WBID,AccountNumber,strPassword,CunID as BD_Address_CunID,strAddress,strName,PhoneNO,ISSendMessage,BankCardNO,dt_Update,");
            strSql.Append("   numState,dt_Add,");
            strSql.Append("   CASE (IDCard) WHEN '' THEN '未填写' ELSE '******' END as IDCard");
            strSql.Append(" FROM dbo.Depositor ");
            strSql.Append(" where  1=1");
            strSql.Append(" and ISClosing=0");
            strSql.Append(string.Format(" and AccountNumber='{0}' ", AccountNumber));         
            DataTable dt = SQLHelper.ExecuteDataTable(strSql.ToString());
            
            if (dt != null && dt.Rows.Count != 0)
            {

                string numState = dt.Rows[0]["numState"].ToString();

                if (numState == "0")
                {
                    string StrScript;
                    StrScript = ("<script language=javascript>");
                    StrScript += ("alert('您查询的账户已经申请挂失!');");
                    StrScript += ("</script>");
                    System.Web.HttpContext.Current.Response.Write(StrScript);
                    return;
                }
                depositorInfo.Style.Add("display", "block");
                D_strName.InnerText = dt.Rows[0]["strName"].ToString();
                D_strAddress.InnerText = dt.Rows[0]["strAddress"].ToString();
                D_PhoneNo.InnerText = dt.Rows[0]["PhoneNo"].ToString();
                D_AccountNumber.InnerText = dt.Rows[0]["AccountNumber"].ToString();
                D_numState.InnerText = dt.Rows[0]["numState"].ToString();
                D_IDCard.InnerText = dt.Rows[0]["IDCard"].ToString();
            }
            //存粮信息

            string sql = string.Format(@" SELECT A.ID,A.StorageNumber,convert(varchar(10),A.StorageDate,120) AS StorageDate, A.AccountNumber,B.strName
   AS VarietyID,A.Price_ShiChang,A.Price_DaoQi,A.CurrentRate,C.strName AS TimeID,A.StorageFee,a.VarietyID as vid
   FROM dbo.Dep_StorageInfo A INNER JOIN dbo.StorageVariety B ON A.VarietyID=B.ID
   INNER JOIN dbo.StorageTime C ON A.TimeID=C.ID   
   where AccountNumber='{0}'", AccountNumber);
            if (!string.IsNullOrWhiteSpace(vId))
            {
                sql += string.Format(" and a.VarietyID={0}", vId);
            }
            var dtStorage = SQLHelper.ExecuteDataTable(sql.ToString());
            DataColumn dcstrlixi = new DataColumn("strlixi", typeof(string));
            DataColumn dcnumlixi = new DataColumn("numlixi", typeof(string));
            dtStorage.Columns.Add(dcstrlixi);
            dtStorage.Columns.Add(dcnumlixi);
            for (int i = 0; i < dtStorage.Rows.Count; i++)
            {
                Dictionary<string, string> dicLixi = common.GetLiXi_html(dtStorage.Rows[i]["ID"]);
                string strlixi = dicLixi["strLixi"];
                string numlixi = dicLixi["numLixi"];
                dtStorage.Rows[i]["strlixi"] = strlixi;
                dtStorage.Rows[i]["numlixi"] = numlixi;
            }
            //价值总额
            numTotol = common.GetLiXiTotal(dtStorage);
            if (dtStorage != null && dtStorage.Rows.Count != 0)
            {
                StorageList.Style.Add("display", "block");
                Repeater1.DataSource = dtStorage;
                Repeater1.DataBind();
            }

            //兑换
            string exchangeSql = string.Format(@"select g.BusinessName,s.strName,g.VarietyCount,g.GoodName,g.VarietyInterest,g.Money_DuiHuan,g.dt_Exchange,g.GoodPrice,g.GoodCount from GoodExchange as g 
                                                inner join  Dep_StorageInfo as d on g.Dep_SID=d.ID inner join 
                                                StorageVariety as s
                                                on s.ID=d.VarietyID
                                                where g.Dep_AccountNumber='{0}'", AccountNumber);
            if (!string.IsNullOrWhiteSpace(vId))
            {
                sql += string.Format(" and d.VarietyID={0}", vId);
            }
            var dtExchange = SQLHelper.ExecuteDataTable(exchangeSql);
            if (dtExchange != null && dtExchange.Rows.Count > 0)
            {
                exchangeList.Style.Add("display", "block");
                R_exchange.DataSource = dtExchange;
                R_exchange.DataBind();
            }

            //分时批量兑换
            string exchangeGroupSql = string.Format(@"SELECT BusinessName,s.strName,g.VarietyCount,g.GoodName,g.GoodPrice,g.GoodCount,g.VarietyInterest,g.Money_DuiHuan,dt_Exchange FROM dbo.GoodExchangeGroup as g 
                                                    inner join Dep_StorageInfo as d
                                                    on g.Dep_SID=d.ID
                                                    inner join StorageVariety as s on  s.ID=d.VarietyID
                                                    where g.Dep_AccountNumber='{0}'",AccountNumber);
            if (!string.IsNullOrWhiteSpace(vId))
            {
                sql += string.Format(" and s.ID={0}", vId);
            }
            var dtExchangeGroup = SQLHelper.ExecuteDataTable(exchangeGroupSql);
            if (dtExchangeGroup != null && dtExchangeGroup.Rows.Count > 0)
            {
                goodExchangeGroup.Style.Add("display", "block");
                R_goodExchangeGroup.DataSource = dtExchangeGroup;
                R_goodExchangeGroup.DataBind();
            }
            //存转销
            string sqlStorageSell = string.Format(@"select s.BusinessName,VarietyName,s.VarietyCount,s.StorageDate,s.VarietyInterest,s.StorageMoney ,s.VarietyMoney ,s.dt_Sell from StorageSell as s
where s.Dep_AccountNumber='{0}'", AccountNumber);
            if (!string.IsNullOrWhiteSpace(vId))
            {
                sql += string.Format(" and VarietyID={0}", vId);
            }
            var dtStorageSell = SQLHelper.ExecuteDataTable(sqlStorageSell);
            if (dtStorageSell != null && dtStorageSell.Rows.Count > 0)
            {
                SellList.Style.Add("display", "block");
                R_Sell.DataSource = dtStorageSell;
                R_Sell.DataBind();
            }

            //产品换购
            string sqlStorageShopping = string.Format(@"select s.BusinessName,s.VarietyName,s.VarietyCount,s.StorageDate,s.VarietyInterest,s.VarietyMoney,s.dt_Sell from StorageShopping as s
where Dep_AccountNumber={0}", AccountNumber);
            if (!string.IsNullOrWhiteSpace(vId))
            {
                sql += string.Format(" and VarietyID={0}", vId);
            }
            var dtStorageShop = SQLHelper.ExecuteDataTable(sqlStorageShopping);
            if (dtStorageShop != null && dtStorageShop.Rows.Count > 0)
            {
                ShoppingList.Style.Add("display", "block");
                R_Shopping.DataSource = dtStorageShop;
                R_Shopping.DataBind();
            }

            //修改记录
            string sqlUpdateStorage = string.Format(@"select s.VarietyName,s.AccountNumber,s.StorageNumberRaw,s.StorageNumber,
                                                    s.StorageNumberChange,w.strName,u.strLoginName,s.createDate from SV_UpdateRecord as s
                                                    inner join WB as w on w.ID=s.WBID
                                                    inner join Users as u on u.ID=s.UserID
                                                    where s.AccountNumber={0}",AccountNumber);
            if (!string.IsNullOrWhiteSpace(vId))
            {
                sql += string.Format(" and s.VarietyID={0}", vId);
            }
            var dtUpdateStorage=SQLHelper.ExecuteDataTable(sqlUpdateStorage);
            if (dtUpdateStorage != null && dtUpdateStorage.Rows.Count > 0)
            {
                sv_updateStorage.Style.Add("display", "block");
                r_updateStorage.DataSource = dtUpdateStorage;
                r_updateStorage.DataBind();
            }
            //退还记录
            string sqlReturnStorage = string.Format(@"select s.VarietyName,s.AccountNumber,s.StorageNumberRaw,
                                                        s.returnNumber,w.strName,u.strLoginName,s.createDate from SV_ReturnRecord as s
                                                        inner join WB as w on w.ID=s.WBID
                                                        inner join Users as u on u.ID=s.UserID
                                                        where s.AccountNumber='{0}' ",AccountNumber);
            if (!string.IsNullOrWhiteSpace(vId))
            {
                sql += string.Format(" and s.VarietyID={0}", vId);
            }
            var dtReturnStorage = SQLHelper.ExecuteDataTable(sqlReturnStorage);
            if (dtReturnStorage != null && dtReturnStorage.Rows.Count > 0)
            {
                sv_returnStorage.Style.Add("display", "block");
                R_ReturnStorage.DataSource = dtReturnStorage;
                R_ReturnStorage.DataBind();
            }


        }

        public string GetDay(object date)
        {
            DateTime t1 = Convert.ToDateTime(date);
            TimeSpan ts = DateTime.Now.Subtract(t1);
            int numday = Convert.ToInt32(Math.Floor((decimal)ts.TotalDays));
            return numday.ToString();

        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            string account = Request.QueryString["account"];
            string varId = ddlVariety.SelectedValue;
            
            LoadData(account,varId);
        }
    }
}