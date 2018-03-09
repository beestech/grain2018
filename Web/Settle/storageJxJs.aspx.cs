using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.Settle
{
    public partial class storageJxJs : System.Web.UI.Page
    {
        public double TotalLiXi = 0;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private void Bind(string wbId,string startDt,string endDt)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append(@" select s.ID,CONVERT(NVARCHAR(100),s.StorageDate,23) AS StorageDate,s.BusinessName,CONVERT(NVARCHAR(100),s.StorageJxDate,23) AS StorageJxDate ,s.Price_Shichang,s.StorageNumber,w.strName as WBName,d.strName as DepName,s.AccountNumber,
                            v.strName as goodName,s.CurrentRate,s.Lixi ,
                            (select strName as OldTypeName from StorageType where ID=s.OldTypeID) as OldTypeName,
                            (select strName as OldTimeName from StorageTime where ID=s.OldTimeID) as OldTimeName,
                            (select strName as TypeName from StorageType where ID=s.TypeID) as TypeName,
                            (select strName as TimeName from StorageTime where ID=s.TimeID) as TimeName
                            from StorageJxRecord
                            as s inner join WB as w
                            on w.ID=s.WBID
                            inner join Depositor as d
                            on d.AccountNumber=s.AccountNumber
                            inner join StorageVariety as v
                            on v.ID=s.VarietyID");
            sql.Append(" where 1=1 ");
            if (!string.IsNullOrWhiteSpace(wbId))
            {
                sql.Append("  s.WBID= " + wbId);
            }
            if (!string.IsNullOrWhiteSpace(startDt) && !string.IsNullOrWhiteSpace(endDt)){
                var end_dt = Convert.ToDateTime(endDt);
                sql.Append(" and (s.StorageDate>'"+startDt+"' and s.StorageDate<'"+ end_dt .AddDays(1)+ "')");
            }
            var dt=SQLHelper.ExecuteDataTable(sql.ToString());
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                  
                    repeater2.DataSource = dt;
                    repeater2.DataBind();
                    Repeater1.DataSource = dt;                   
                    Repeater1.DataBind();
                }
                else
                {                 
                    repeater2.DataSource = "";
                    repeater2.DataBind();
                    Repeater1.DataSource = "";
                    Repeater1.DataBind();
                }
            }
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (!string.IsNullOrWhiteSpace(dt.Rows[i]["Lixi"].ToString()))
                {

                    TotalLiXi += Convert.ToDouble(dt.Rows[i]["Lixi"].ToString());
                }
            }
            TotalLiXi = Math.Round(TotalLiXi, 2);
        }       
        /// <summary>
        /// 未结算，已结算
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        public string GetIsJs(object ID)
        {
            string strReturn = string.Empty;
            string sql = @"select ID from StorageJxCalculate where storageJxRecordID=" + ID;
            var scalar=SQLHelper.ExecuteScalar(sql);

            if (scalar==null||string.IsNullOrWhiteSpace(scalar.ToString()))
            {
                strReturn = "  <a style='color:Red; font-weight:bold;' href='#' onclick='GetSingle(" + ID + ")'>未结算</a>";
            }
            else
            {
                strReturn = "<span style='color:Green'>已结算</span>&nbsp;<a style='color:Blue; font-weight:bold;' href='#' onclick='PrintPage(" + ID + ")'>结算单据</a>";
            }
            return strReturn;
        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            string wbid = QWBID.Value;
            string start = Qdtstart.Value;
            string end = Qdtend.Value;
            Bind(wbid, start, end);
        }
    }
}