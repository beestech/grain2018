using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.User.Query
{
    public partial class depStorageSwitchRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ValidateIsAdmin();
                Bind();
                
            }
        }

        private void ValidateIsAdmin()
        {
            if (Session["UserGroup_ID"] != null)
            {
                int id = Convert.ToInt32(Session["UserGroup_ID"]);
                if (id == 4)
                {
                    var wbId = Session["WB_ID"];
                    //营业员
                    string wbName = SQLHelper.ExecuteScalar("select  strName from WB where ID=" + wbId).ToString();
                    lblWb.Text = wbName;
                    ddlWB.Visible = false;
                }
                else
                {
                    //管理员
                    BindDDL();
                }          
            }
        }


        private void BindDDL()
        {
            string sql = @"select distinct w.strName,w.ID from Dep_StorageSwitch as d inner join WB as w
on d.WBID=w.ID";
            var dt=SQLHelper.ExecuteDataTable(sql);
            if (dt.Rows.Count > 0)
            {
                ddlWB.DataSource = dt;
                ddlWB.DataTextField = "strName";
                ddlWB.DataValueField = "ID";
                ddlWB.DataBind();
                ddlWB.Items.Insert(0, new ListItem("-请选择-", ""));
            }
        }

        private void Bind()
        {
            StringBuilder sql = new StringBuilder();
            sql.Append(@" select de.strName as DepositorName,de.AccountNumber,w.strName as wbName,sv.strName as vName,d.StorageNumberRaw,d.StorageNumberSwitch,
                 CONVERT(NVARCHAR(100),d.StorageDate,23) AS StorageDate , CONVERT(NVARCHAR(100),d.SwitchDate,23) as SwitchDate,
                            CASE(d.ISSwitch) WHEN 1 THEN '是' ELSE '否' END AS ISSwitch from Dep_StorageSwitch as d
                            left outer join Dep_StorageInfo as s
                            on d.Dep_StorageInfo_ID=s.ID
                            left outer join Depositor as de on s.AccountNumber=de.AccountNumber
                            left outer join WB as w on w.ID=d.WBID
                            left outer join Users as u on u.ID=d.UserID
                            left outer join StorageVariety as sv on sv.ID=d.VarietyID
                            where 1=1 ");
            //and d.WBID ='' and de.AccountNumber='' and d.StorageDate >'' and d.StorageDate<'' and d.ISSwitch=''
            //order by d.StorageDate desc
            if (!string.IsNullOrWhiteSpace(ddlWB.SelectedValue))
            {
                sql.Append(" and w.ID =" + ddlWB.SelectedValue + " ");
            }
            if (!string.IsNullOrWhiteSpace(txtAccountNumber.Value))
            {
                sql.Append(" and de.AccountNumber='" + txtAccountNumber.Value + "' ");
            }           
            if (!string.IsNullOrWhiteSpace(Qdtstart.Value) && !string.IsNullOrWhiteSpace(Qdtend.Value))
            {
                var endTime = Qdtend.Value + " 23:59:59";
                sql.Append(" and (d.StorageDate >'" + Qdtstart.Value + "' and d.StorageDate<'" + endTime + "') ");
            }

                if (!ddlIsSwitch.SelectedValue.Equals("2")) {
                    sql.Append("  and d.ISSwitch=" + ddlIsSwitch.SelectedValue);
                }

            sql.Append("      order by d.StorageDate desc ");
            var dt=SQLHelper.ExecuteDataTable(sql.ToString());
                if (dt.Rows.Count > 0) {
                    Repeater1.DataSource = dt;
                    Repeater1.DataBind();
                }
            else
            {
                Repeater1.DataSource = "";
                Repeater1.DataBind();
                ClientScript.RegisterClientScriptBlock(GetType(), "", "<script>alert('没有您要查询的数据！');</script>"); 
            }

        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            Bind();
        }
    }
}