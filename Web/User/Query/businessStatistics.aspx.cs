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
    public partial class businessStatistics : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDdl();
            }

        }

        private void BindDdl()
        {
            if (Session["ISHQ"] != null)
            {
                        

                bool flag = Convert.ToBoolean(Session["ISHQ"]);
                if (flag)
                {
                    StringBuilder strSql = new StringBuilder();
                    strSql.Append("   SELECT ID,strName ");
                    strSql.Append("   FROM dbo.WB");
                    strSql.Append("   WHERE  ISHQ=0 and ISSimulate=0");//排除总部和模拟网点
                    DataTable dt = SQLHelper.ExecuteDataTable(strSql.ToString());
                    ddlWd.DataSource = dt;
                    ddlWd.DataTextField = "strName";
                    ddlWd.DataValueField = "ID";
                    ddlWd.DataBind();
                    ddlWd.Items.Insert(0, new ListItem("请选择", ""));
                    //存粮种类绑定
                    string sql = "select  ID,strName from StorageVariety";
                    dt = SQLHelper.ExecuteDataTable(sql);
                    ddlName.DataSource = dt;
                    ddlName.DataTextField = "strName";
                    ddlName.DataValueField = "ID";
                    ddlName.DataBind();
                    ddlName.Items.Insert(0, new ListItem("请选择", ""));


                }
                else {
                    //存粮种类绑定
                    string sql = "select  ID,strName from StorageVariety";
                    var dt = SQLHelper.ExecuteDataTable(sql);
                    ddlName.DataSource = dt;
                    ddlName.DataTextField = "strName";
                    ddlName.DataValueField = "ID";
                    ddlName.DataBind();
                    ddlName.Items.Insert(0, new ListItem("请选择", ""));
                }
            }
        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            if (Session["ISHQ"] != null)
            {
                bool flag = Convert.ToBoolean(Session["ISHQ"]);
                if (flag)
                {
                    //总部

                    StringBuilder sql = new StringBuilder();
                    sql.Append(@"SELECT DISTINCT Dep_AccountNumber,P.strName AS DepName, b.strName AS VarietyName,b.ID,
                                ( SELECT SUM( StorageNumberRaw)  FROM dbo.Dep_StorageInfo m  WHERE  m.AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID ) StorageNumberRaw,
                                ( SELECT SUM( StorageNumber)  FROM dbo.Dep_StorageInfo m  WHERE  m.AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID ) AS StorageNumber,
                                ( SELECT SUM( Count_Trade)  FROM dbo.Dep_OperateLog m WHERE BusinessName ='5' AND m.Dep_AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID)
                                AS VarietyCount_error,
                                ( SELECT SUM( Count_Trade)  FROM dbo.Dep_OperateLog m WHERE BusinessName ='8' AND m.Dep_AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID)
                                AS VarietyCount_return,
                                ( SELECT SUM( m.Count_Trade) FROM dbo.Dep_OperateLog m WHERE BusinessName IN('2','6') AND m.Dep_AccountNumber=A.Dep_AccountNumber
                                AND m.VarietyID=A.VarietyID)AS ExchangeCount,  
                                ( SELECT SUM( m.Count_Trade) FROM dbo.Dep_OperateLog m WHERE BusinessName IN('17','18') AND m.Dep_AccountNumber=A.Dep_AccountNumber
                                AND m.VarietyID=A.VarietyID)AS ExchangeCountGroup,
                                ( SELECT SUM( Count_Trade)  FROM dbo.Dep_OperateLog m WHERE BusinessName IN ('3','7') AND m.Dep_AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID)
                                AS StorageSellCount,
                                ( SELECT SUM( Count_Trade)  FROM dbo.Dep_OperateLog m WHERE BusinessName IN ('9','10') AND m.Dep_AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID)
                                AS StorageShoppingCount
                                FROM dbo.Dep_OperateLog A INNER JOIN dbo.Depositor P ON A.Dep_AccountNumber=P.AccountNumber
                                LEFT OUTER JOIN dbo.StorageVariety B ON A.VarietyID=B.ID OR A.VarietyID=B.strName
                                WHERE 1=1  AND P.ISClosing=0 ");
                    //判断VarietyCount_error是否为0
                    string wd = ddlWd.SelectedValue;
                    string vy = ddlName.SelectedValue;
                    if (!string.IsNullOrWhiteSpace(wd))
                    {
                      
                            sql.Append(" AND (A.WBID=" + wd + " OR P.WBID=" + wd + ") ");
                        
                    }
                    if (!string.IsNullOrWhiteSpace(vy))
                    {                       
                            sql.Append("  AND B.ID="+vy+"");
                    }
                    if (!string.IsNullOrWhiteSpace(QAccountNumber.Value))
                    {
                        sql.Append(" AND A.Dep_AccountNumber='" + QAccountNumber.Value + "' ");
                    }
                    DataTable dt = SQLHelper.ExecuteDataTable(sql.ToString());
                    var newDt=ForDt(dt);
                    Repeater1.DataSource = newDt;
                    Repeater1.DataBind();
                }
                else
                {
                   
                    //网点
                    StringBuilder sql = new StringBuilder();
                    sql.Append(@"SELECT DISTINCT Dep_AccountNumber,P.strName AS DepName, b.strName AS VarietyName,b.ID,
                                ( SELECT SUM( StorageNumberRaw)  FROM dbo.Dep_StorageInfo m  WHERE  m.AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID )
                                AS StorageNumberRaw,
                                ( SELECT SUM( StorageNumber)  FROM dbo.Dep_StorageInfo m  WHERE  m.AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID )
                                AS StorageNumber,
                                ( SELECT SUM( Count_Trade)  FROM dbo.Dep_OperateLog m WHERE BusinessName ='5' AND m.Dep_AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID)
                                AS VarietyCount_error,
                                ( SELECT SUM( Count_Trade)  FROM dbo.Dep_OperateLog m WHERE BusinessName ='8' AND m.Dep_AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID)
                                AS VarietyCount_return,
                                ( SELECT SUM( m.Count_Trade) FROM dbo.Dep_OperateLog m WHERE BusinessName IN('2','6') AND m.Dep_AccountNumber=A.Dep_AccountNumber
                                AND m.VarietyID=A.VarietyID)AS ExchangeCount,  
                                ( SELECT SUM( m.Count_Trade) FROM dbo.Dep_OperateLog m WHERE BusinessName IN('17','18') AND m.Dep_AccountNumber=A.Dep_AccountNumber
                                AND m.VarietyID=A.VarietyID)AS ExchangeCountGroup,
                                ( SELECT SUM( Count_Trade)  FROM dbo.Dep_OperateLog m WHERE BusinessName IN ('3','7') AND m.Dep_AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID)
                                AS StorageSellCount,
                                ( SELECT SUM( Count_Trade)  FROM dbo.Dep_OperateLog m WHERE BusinessName IN ('9','10') AND m.Dep_AccountNumber=A.Dep_AccountNumber AND m.VarietyID=A.VarietyID)
                                AS StorageShoppingCount
                                FROM dbo.Dep_OperateLog A INNER JOIN dbo.Depositor P ON A.Dep_AccountNumber=P.AccountNumber
                                LEFT OUTER JOIN dbo.StorageVariety B ON A.VarietyID=B.ID OR A.VarietyID=B.strName
                                WHERE 1=1  AND P.ISClosing=0 ");
                    //判断VarietyCount_error是否为0
                    var wbid = Session["WB_ID"];

                    if (!string.IsNullOrWhiteSpace(wbid.ToString()))
                    {

                        sql.Append(" AND (A.WBID=" + wbid + " OR P.WBID=" + wbid + ") ");

                    }
                    if (!string.IsNullOrWhiteSpace(ddlName.SelectedValue))
                    {
                        sql.Append("  AND B.ID=" + ddlName.SelectedValue + "");
                    }
                    if (!string.IsNullOrWhiteSpace(QAccountNumber.Value))
                    {
                        sql.Append(" AND A.Dep_AccountNumber='" + QAccountNumber.Value + "' ");
                    }
                    DataTable dt = SQLHelper.ExecuteDataTable(sql.ToString());

                    var newDt = ForDt(dt);
                    Repeater1.DataSource = newDt;
                    Repeater1.DataBind();

                }
            }
        }

       

        private List<BusinessStatisticsModel> ForDt(DataTable dt)
        {
            List<BusinessStatisticsModel> lists = new List<BusinessStatisticsModel>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["VarietyName"] == null || string.IsNullOrWhiteSpace(dt.Rows[i]["VarietyName"].ToString()))
                {
                    continue;
                }
                BusinessStatisticsModel bm = new BusinessStatisticsModel();
                bm.DepName = dt.Rows[i]["DepName"].ToString();
                bm.Dep_AccountNumber = dt.Rows[i]["Dep_AccountNumber"].ToString();
                bm.VarietyName = dt.Rows[i]["VarietyName"].ToString();
                bm.DepName = dt.Rows[i]["DepName"].ToString();
                bm.VarietyID = dt.Rows[i]["ID"].ToString();
                //VarietyCount_return
                bm.VarietyCount_return = Convert.ToDouble(string.IsNullOrWhiteSpace(dt.Rows[i]["VarietyCount_return"].ToString()) ? 0 : dt.Rows[i]["VarietyCount_return"]);
                bm.VarietyCount_error = Convert.ToDouble(string.IsNullOrWhiteSpace(dt.Rows[i]["VarietyCount_error"].ToString()) ? 0 : dt.Rows[i]["VarietyCount_error"]);
                bm.StorageNumberRaw = Convert.ToDouble(string.IsNullOrWhiteSpace(dt.Rows[i]["StorageNumberRaw"].ToString()) ? 0 : dt.Rows[i]["StorageNumberRaw"]);
                double exchangeCountGroup = 0;
               double exchangeCount = 0;
                if (string.IsNullOrWhiteSpace(dt.Rows[i]["ExchangeCount"].ToString()))
                {
                   
                }
                else
                {
                    exchangeCount = Convert.ToDouble(dt.Rows[i]["ExchangeCount"]);
                }
                if (string.IsNullOrWhiteSpace(dt.Rows[i]["ExchangeCountGroup"].ToString()))
                {
                   
                }
                else
                {
                    exchangeCountGroup= Convert.ToDouble(dt.Rows[i]["ExchangeCountGroup"]);
                }

                bm.ExhcangeNumberTotal = exchangeCount + exchangeCountGroup;

                bm.StorageSellCount = Convert.ToDouble(string.IsNullOrWhiteSpace(dt.Rows[i]["StorageSellCount"].ToString()) ? 0 : dt.Rows[i]["StorageSellCount"]);
                bm.StorageShoppingCount = Convert.ToDouble(string.IsNullOrWhiteSpace(dt.Rows[i]["StorageShoppingCount"].ToString()) ? 0 : dt.Rows[i]["StorageShoppingCount"]);
                bm.StorageNumber = Convert.ToDouble(string.IsNullOrWhiteSpace(dt.Rows[i]["StorageNumber"].ToString()) ? 0 : dt.Rows[i]["StorageNumber"]);
                lists.Add(bm);
            }
            return lists;
        }

    }

    public class BusinessStatisticsModel
    {
        public string DepName { get; set; }

        public string VarietyID { get; set; }
        public string Dep_AccountNumber { get; set; }
        public string VarietyName { get; set; }
        public double StorageNumberRaw { get; set; }
        public double ExhcangeNumberTotal { get; set; }
        public double StorageSellCount { get; set; }
        public double StorageShoppingCount { get; set; }
        public double StorageNumber { get; set; }

        public double VarietyCount_return { get; set; }
        public double VarietyCount_error { get; set; }
    }
}