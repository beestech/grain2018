using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.Admin.Report
{
    public partial class storageDepRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDLL();
                //Bind();
            }
        }

        private void BindDLL()
        {
            string sql = @"select distinct s.ID,s.strName from Dep_OperateLog as d
inner join StorageVariety as s
on d.VarietyID =s.ID";
            var dt=SQLHelper.ExecuteDataTable(sql);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlName.DataSource = dt;
                ddlName.DataTextField = "strName";
                ddlName.DataValueField = "ID";
                ddlName.DataBind();
                ddlName.Items.Insert(0, new ListItem("全部", ""));
            }
            StringBuilder strSql = new StringBuilder();
            strSql.Append("   SELECT ID,strName ");
            strSql.Append("   FROM dbo.WB");
            strSql.Append("   WHERE  ISHQ=0 and ISSimulate=0");//排除总部和模拟网点
           var dt_1 = SQLHelper.ExecuteDataTable(strSql.ToString());
            ddlWd.DataSource = dt_1;
            ddlWd.DataTextField = "strName";
            ddlWd.DataValueField = "ID";
            ddlWd.DataBind();
            ddlWd.Items.Insert(0, new ListItem("全部", ""));


            for (int i = DateTime.Now.Year-1; i <= DateTime.Now.Year; i++)
            {
                ddlYear.Items.Add(i.ToString());
            }
            ddlYear.SelectedValue = DateTime.Now.Year.ToString();
        }

        private void Bind()
        {
            StringBuilder sql = new StringBuilder();
            sql.Append(@"SELECT C.ID as WBID, C.strName AS WBName,s.Price_ShiChang,
SUM( count_trade) as StorageNumber, (sum(count_trade)*s.Price_ShiChang) as TotalPrice, T.ID as TimeID,
 T.strName AS  TimeName ,E.ID as VarietyID, E.strName AS  VarietyName
                
                 FROM dbo.Dep_OperateLog A INNER JOIN dbo.Depositor D ON A.Dep_AccountNumber=D.AccountNumber   
                  INNER JOIN dbo.WB C ON D.WBID=C.ID
                  inner join Dep_StorageInfo as s
                  on s.ID=a.Dep_SID
                  INNER JOIN dbo.StorageTime T ON  T.ID=s.TimeID
                  INNER JOIN dbo.StorageVariety E ON A.VarietyID=E.ID
                  where 1=1");
            if (!string.IsNullOrWhiteSpace(ddlWd.SelectedValue))
            {
                sql.Append(string.Format(" and d.WBID='{0}' ", ddlWd.SelectedValue));
            }
            if (!string.IsNullOrWhiteSpace(ddlName.SelectedValue))
            {
                sql.Append(string.Format(" and A.VarietyID ='{0}'", ddlName.SelectedValue));
            }
            string year = ddlYear.SelectedValue;
            string month = select_month.Value;
            string date = year + "-" + month + "-1";
            DateTime d_t = Convert.ToDateTime(date);

            var dtStart=FirstDayOfMonth(d_t);
            var dtEnd = LastDayOfMonth(d_t);

            sql.Append(string.Format(" and  A.dt_Trade >'{0}' and A.dt_Trade < '{1}' ", dtStart.ToString(), dtEnd.ToString()));
            sql.Append("  group by  C.ID, C.strName,T.ID, T.strName ,E.ID, E.strName,s.Price_ShiChang");

            var dt = SQLHelper.ExecuteDataTable(sql.ToString());
            Repeater1.DataSource = dt;
            Repeater1.DataBind();

        }

        public string Calculate(string price,string storageNumber, string WBID, string VarietyID, string timeID, string price_sc, string year, string month)
        {
            string number = getDepStorageNum(storageNumber, WBID, VarietyID,timeID,price_sc, year, month);
            if (number.Equals("0"))
            {
                return "0.00";
            }
            return Math.Round(Convert.ToDouble(price) * Convert.ToDouble(number), 2).ToString();
            
        }
        /// <summary>
        /// 按时间区间取得网点农产品结存数量
        /// </summary>
        /// <param name="WBID">网点编号</param>
        /// <param name="VarietyID">产品ID</param>
        /// <param name="Qdtstart">开始时间</param>
        /// <param name="Qdtend">结束时间</param>
        public string getDepStorageNum(string storageNumber,string WBID, string VarietyID,string timeID,string price, string year, string month)
        {

                if (storageNumber.Equals("0.00")||storageNumber.Equals("0"))
                {
                    return "0.00";
                }


           // string Qdtstart, Qdtend = "";
            string date = year + "-" + month + "-1";
            DateTime d_t = Convert.ToDateTime(date);
            var dtStart = FirstDayOfMonth(d_t);
            var dtEnd = LastDayOfMonth(d_t);
            StringBuilder strSqlCommune = new StringBuilder();
            strSqlCommune.Append("  SELECT A.BusinessName, A.Count_Trade, A.GoodCount, CONVERT(NVARCHAR(100),A.dt_Trade,23) AS dt_Trade ");
            strSqlCommune.Append("  FROM dbo.Dep_OperateLog A  inner join Dep_StorageInfo as s on s.ID = A.Dep_SID ");
            strSqlCommune.Append("  where 1=1");
            strSqlCommune.Append("  AND A.WBID = '" + WBID + "'");
            strSqlCommune.Append("  AND A.VarietyID = '" + VarietyID + "' and s.TimeID='" + timeID + "' and s.Price_ShiChang='" + price + "'");

          
                strSqlCommune.Append("   AND A.dt_Trade> '" +dtStart + "'");
            
           
                //Qdtend = Convert.ToDateTime(Qdtend).AddDays(1).ToString();
                strSqlCommune.Append("   AND A.dt_Trade < '" +dtEnd + "'");
            

            strSqlCommune.Append("   order by A.dt_Trade desc");

            DataTable dt = SQLHelper.ExecuteDataTable(strSqlCommune.ToString());
            decimal storageNum = 0;
            if (dt == null || dt.Rows.Count == 0)
            {
                return "0";
            }
            else
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    decimal countTrade = System.Math.Abs(Convert.ToDecimal(dt.Rows[i][1]));
                    switch (dt.Rows[i][0].ToString())
                    {
                        case "1": storageNum += countTrade; break;
                        case "2": storageNum -= countTrade; break;
                        case "3": storageNum -= countTrade; break;
                        case "4": storageNum -= countTrade; break;
                        case "5":
                            if (Convert.ToDecimal(dt.Rows[i][2]) < 0)
                            {
                                storageNum -= countTrade;
                            }
                            else
                            {
                                storageNum += countTrade;
                            }
                            break;
                        case "6": storageNum += countTrade; break;
                        case "7": storageNum += countTrade; break;
                        case "8": storageNum -= countTrade; break;
                        case "9": storageNum -= countTrade; break;
                        case "10": storageNum += countTrade; break;
                        case "17": storageNum -= countTrade; break;
                        case "18": storageNum += countTrade; break;
                    }
                }
            }
            return storageNum.ToString();
        }

        #region 时间转换
        ///<summary>
        /// 取得某月的第一天
        /// </summary>
        /// <param name="datetime">要取得月份第一天的时间</param>
        /// <returns></returns>
        public static DateTime FirstDayOfMonth(DateTime datetime)
        {
            return datetime.AddDays(1 - datetime.Day);
        }
        /// <summary>
        /// 取得某月的最后一天
        /// </summary>
        /// <param name="datetime">要取得月份最后一天的时间</param>
        /// <returns></returns>
        public static DateTime LastDayOfMonth(DateTime datetime)
        {
            return datetime.AddDays(1 - datetime.Day).AddMonths(1).AddDays(-1);
        }
        #endregion

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            Bind();
        }

        decimal ta;
        decimal money;
        protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                Label lbl = e.Item.FindControl("lblNumber") as Label;
                Label lbl1 = e.Item.FindControl("lblMoney") as Label;
                ta += Convert.ToDecimal(lbl.Text);
                money += Convert.ToDecimal(lbl1.Text);
            }

            if (e.Item.ItemType == ListItemType.Footer)
            {
                if (e.Item.FindControl("lblTotalNumber") != null && e.Item.FindControl("lblTotalMoney") != null)
                {
                    Label lbl = (Label)e.Item.FindControl("lblTotalNumber");
                    Label lbl1 = (Label)e.Item.FindControl("lblTotalMoney");
                    lbl.Text = string.Format("{0}", ta);
                    lbl1.Text = string.Format("{0}", money);
                }
            }
        }
    }
}