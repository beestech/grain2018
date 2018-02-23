using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.Admin.Report
{
    public partial class goodExchangeGroupRpt : System.Web.UI.Page
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
            StringBuilder strSql = new StringBuilder();
            strSql.Append("   SELECT ID,strName ");
            strSql.Append("   FROM dbo.WB");
            strSql.Append("   WHERE  ISHQ=0 and ISSimulate=0");//排除总部和模拟网点
            var dt = SQLHelper.ExecuteDataTable(strSql.ToString());
            ddlWb.DataSource = dt;
            ddlWb.DataTextField = "strName";
            ddlWb.DataValueField = "ID";
            ddlWb.DataBind();
            ddlWb.Items.Insert(0, new ListItem("请选择", ""));
            //存粮类型
            string sql = @"select distinct s.strName,s.ID from Dep_StorageInfo as d inner join StorageVariety as s
on d.VarietyID=s.ID";
            var dtVariety = SQLHelper.ExecuteDataTable(sql);
            ddlStorage.DataSource = dtVariety;
            ddlStorage.DataTextField = "strName";
            ddlStorage.DataValueField = "ID";
            ddlStorage.DataBind();
            ddlStorage.Items.Insert(0, new ListItem("请选择", ""));

        }

        private void Query()
        {
            StringBuilder sql = new StringBuilder(@"select w.strName as exchangeName,w.ID as exWBID,b.ID as dep_WBID,b.strName as depStrName,v.ID as StorageVarietyID,v.strName as StorageName,g.GoodName,g.GoodID,ISReturn,sum(g.GoodCount)as GoodCount,
                                                    SUM(g.Money_DuiHuan)as Money_DuiHuan,
                                                    SUM(g.VarietyCount)as VarietyCount,SUM(g.VarietyInterest)as VarietyInterest
                                                     from GoodExchangeGroup as g inner join Depositor as d
                                                    on g.Dep_AccountNumber=d.AccountNumber
                                                    inner join WB as w on w.ID=g.WBID 
                                                    inner join WB as b on d.WBID=b.ID
                                                    inner join Dep_StorageInfo as s
                                                    on g.Dep_SID=s.ID
                                                    left outer join StorageVariety as v
                                                    on v.ID=s.VarietyID");
            sql.Append("  where ISReturn =0 ");
            if (!string.IsNullOrWhiteSpace(ddlWb.SelectedValue))
            {
                sql.Append(string.Format(" and (w.ID={0} or b.ID={0})", ddlWb.SelectedValue));
            }
            if (!string.IsNullOrWhiteSpace(ddlStorage.SelectedValue))
            {
                sql.Append(string.Format(" and v.ID={0}", ddlStorage.SelectedValue));
            }
            if (!string.IsNullOrWhiteSpace(Qdtstart.Value))
            {
                sql.Append("   AND g.dt_Exchange> '" + Qdtstart.Value + "'");                
            }
            if (!string.IsNullOrWhiteSpace(Qdtend.Value))
            {
                var dtEnd=Convert.ToDateTime(Qdtend.Value).AddDays(1);
                sql.Append("   AND g.dt_Exchange< '" + dtEnd + "'");
            }
            sql.Append("  group by b.ID ,w.ID,w.strName,b.strName,v.strName,v.ID,g.GoodName,g.GoodID,ISReturn");
            var dt=SQLHelper.ExecuteDataTable(sql.ToString());
            Repeater1.DataSource = dt;
            Repeater1.DataBind();
          
        }

        private void Detail()
        {

        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            Query();
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            //显示div detail
            StringBuilder script = new StringBuilder("$(function(){");
            script.Append("  $('.datadetail').fadeIn(); ");
            script.Append(" })");
            ClientScript.RegisterClientScriptBlock(GetType(), "", script.ToString(), true);
            if (e.CommandName.Equals("detail"))
            {
                string[] paras = e.CommandArgument.ToString().Split(',');

                string exWBID =paras[0];
                string exWBName = paras[1];
                string dep_WBID = paras[2];
                string dep_WBName = paras[3];
                string goodId =paras[4];
                string goodName = paras[5];
                string StorageVarietyID = paras[6];
                string VarietyName = paras[7];
                string startDate = Qdtstart.Value;
                string endDate = Qdtend.Value;
                lbldepWb.Text = dep_WBName;
                lblExchangewb.Text = exWBName;
                lblGoodName.Text = goodName;
                lblVarietyName.Text = VarietyName;
                lblStartDate.Text = Qdtstart.Value;
                lblEndDate.Text = Qdtend.Value;
                StringBuilder sql = new StringBuilder();
                sql.Append(@"select w.strName as exchangeName,b.strName as depStrName,g.Dep_AccountNumber,d.strName as Dep_Name,g.GoodID,g.GoodCount,
                                g.Money_DuiHuan,
                                g.VarietyCount,g.VarietyInterest,
                                CONVERT(varchar(100), dt_Exchange, 23) AS dt_Exchange,
                                CASE(ISReturn) WHEN 0 THEN '兑换' ELSE '退还兑换' END AS ISReturn
                                 from GoodExchangeGroup as g inner join Depositor as d
                                on g.Dep_AccountNumber=d.AccountNumber
                                inner join WB as w on w.ID=g.WBID 
                                inner join WB as b on d.WBID=b.ID
                                inner join Dep_StorageInfo as s
                                on g.Dep_SID=s.ID
                                inner join StorageVariety as v
                                on v.ID=s.VarietyID
                                where 1=1 and w.ISSimulate=0 ");
                if (!string.IsNullOrWhiteSpace(exWBID))
                {
                    sql.Append("   AND w.ID = " + exWBID);
                }
                if (!string.IsNullOrWhiteSpace(dep_WBID))
                {
                    sql.Append("   AND b.ID = " + dep_WBID);
                }
                if (!string.IsNullOrWhiteSpace(goodId))
                {
                    sql.Append("   AND g.GoodID = " + goodId);
                }
                if (!string.IsNullOrWhiteSpace(StorageVarietyID))
                {
                    sql.Append("   AND v.ID = " + StorageVarietyID);
                }
                if (!string.IsNullOrWhiteSpace(startDate))
                {
                    sql.Append("   AND dt_Exchange> '" + startDate + "'");
                }
                if (!string.IsNullOrWhiteSpace(endDate))
                {
                    if (Fun.IsDateTime(endDate))
                    {
                        endDate = Convert.ToDateTime(endDate).AddDays(1).ToShortDateString();
                        sql.Append("   AND dt_Exchange < '" + endDate + "'");
                    }

                }
                sql.Append("  order by dt_Exchange");

                var dt=SQLHelper.ExecuteDataTable(sql.ToString());
                rptDetail.DataSource = dt;
                rptDetail.DataBind();
            }

        }
    }
}