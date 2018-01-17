using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.User.Goods
{
    public partial class user_GoodAllocate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindRpt();
            }
        }

        private void BindRpt()
        {
            if (Session["WB_ID"] != null)
            {
                var id = Session["WB_ID"];//网点ID
                StringBuilder sql = new StringBuilder();
                sql.Append(@"select * from
                                  (select 
	                                (select strName from WB where wb.ID=GoodAllocate.WBID)as diaohuo,
	                                (select strName from WB where wb.ID=GoodAllocate.AllocateWBID)as jieshou,
	                                (select strName from Good where Good.ID=GoodAllocate.GoodID)as goodName,
	                                (select strRealName from Users where Users.ID=GoodAllocate.UserID)as UserName,
                                    (select  strName from WBWareHouse where WBWareHouse.ID=GoodAllocate.WBWareHouseID)as diaohuoCK,
	                                (select  strName from WBWareHouse where WBWareHouse.ID=GoodAllocate.AllocateWBWareHouseID)as jieshouCK,
	                                Quantity,Price_Stock,dt_Trade,AllocateWBID, WBID
                                from GoodAllocate) a
                                where 1=1 ");
                sql.Append("  and (WBID=" + id + " or AllocateWBID=" + id + ") ");
                if (!string.IsNullOrWhiteSpace(Qdtstart.Value) && !string.IsNullOrWhiteSpace(Qdtend.Value))
                {
                    var endTime = Qdtend.Value + " 23:59:59";
                    sql.Append(" and (dt_Trade >'" + Qdtstart.Value + "' and dt_Trade<'" + endTime + "') ");
                }
                if (!string.IsNullOrWhiteSpace(txtstrName.Value))
                {
                    sql.Append(" and goodName like '%" + Fun.SafeData(txtstrName.Value).Trim() + "%'");
                }
                sql.Append(" order by dt_Trade desc");

                DataTable dt = SQLHelper.ExecuteDataTable(sql.ToString());
                Repeater1.DataSource = dt;
                Repeater1.DataBind();

            }
        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            BindRpt();
        }
    }
}