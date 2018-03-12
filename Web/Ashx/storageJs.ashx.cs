using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace Web.Ashx
{
    /// <summary>
    /// storageJs 的摘要说明
    /// </summary>
    public class storageJs : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //common.IsLogin();
            if (context.Request.QueryString["type"] != null)
            {
                string strType = context.Request.QueryString["type"].ToString();
                switch (strType)
                {
                    case "ISHaveJs": ISHaveJs(context); break;//判断是否已经结算
                    case "GetSingle": GetSingle(context); break;//获取结息记录信息
                    case "AddStorageJxCalculate": AddStorageJxCalculate(context); break;
                    case "AddAllStorageJxCalculate": AddAllStorageJxCalculate(context); break;
                    case "Print":Print(context); break;
                }
            }
        }

        private void Print(HttpContext context)
        {
            //获取需要打印的信息
            string storageJxRecordID = context.Request.QueryString["ID"].ToString();

            StringBuilder strSql = new StringBuilder();
            strSql.Append(@"select  s.ID,s.WBID,s.storageJxRecordID,s.strGUID,s.serialNumber,s.BusinessName,CONVERT(NVARCHAR(100),dt_Trade,23) AS dt_Trade,d.strName as DepName,
                            w.strName as WBName,t.strName as TypeName,st.strName as TimeName,s.Unit,s.Accountant_Name,
                            v.strName as goodName,s.AccountNumber,CONVERT(nvarchar(100),StorageDate,23) as StorageDate,
                            s.CurrentRate,s.Lixi,s.numWeight,s.numPrice
                             from StorageJxCalculate as s
                             left outer join WB as w 
                             on w.ID=s.WBID
                             left outer join StorageType as t
                             on t.ID=s.TypeID
                             left outer join StorageTime as st
                             on st.ID=s.TimeID
                             left outer join StorageVariety as v
                             on v.ID=s.VarietyID
                             left outer join Depositor as d
                             on d.AccountNumber=s.AccountNumber
                             where 1=1 ");            
            strSql.Append(" and s.storageJxRecordID=@storageJxRecordID ");
            SqlParameter[] parameters = {
                    new SqlParameter("@storageJxRecordID", SqlDbType.Int,4)};
            parameters[0].Value = storageJxRecordID;

            DataTable dtLog = SQLHelper.ExecuteDataTable(strSql.ToString(), parameters);
            if (dtLog == null || dtLog.Rows.Count == 0)
            {
                context.Response.Write("");
                return;
            }
            string strGUID = dtLog.Rows[0]["strGUID"].ToString();
            string serialNumber = dtLog.Rows[0]["serialNumber"].ToString();
            string WBName = dtLog.Rows[0]["WBName"].ToString();
            string Dep_AN = dtLog.Rows[0]["AccountNumber"].ToString();
            string Dep_Name = dtLog.Rows[0]["DepName"].ToString();
//            string StorageDay = dtLog.Rows[0]["StorageDay"].ToString();
            string BusinessName = dtLog.Rows[0]["BusinessName"].ToString();
            string GoodName = dtLog.Rows[0]["goodName"].ToString();
            string UnitName = dtLog.Rows[0]["Unit"].ToString();
            string numWeight = dtLog.Rows[0]["numWeight"].ToString();
            string numPrice = dtLog.Rows[0]["numPrice"].ToString();
            string Lixi= dtLog.Rows[0]["Lixi"].ToString();
            string Money_Total = dtLog.Rows[0]["Lixi"].ToString();
          //  string Money_Surplus = dtLog.Rows[0]["Money_Surplus"].ToString();
            string Money_Reality = dtLog.Rows[0]["Lixi"].ToString();
            string dt_Trade = dtLog.Rows[0]["dt_Trade"].ToString();
            string StorageDate = dtLog.Rows[0]["StorageDate"].ToString();
            string Accountant_Name = dtLog.Rows[0]["Accountant_Name"].ToString();



            StringBuilder strReturn = new StringBuilder();
            //标题
            string CompanyName = common.GetCompanyInfo()["strName"].ToString();
            strReturn.Append("  <table style='width: 640px; padding: 10px 0px;'>");
            strReturn.Append("   <tr><td align='center' style='font-size: 18px; font-weight: bolder; text-align: center;'><span>" + CompanyName + "  利息结算凭证</span></td> </tr>");
            strReturn.Append("   <tr><td align='center' style='font-size: 12px;  text-align: center;'> <span>防伪码：" + strGUID + "</span>  &nbsp;&nbsp;<span>编号：" + serialNumber + "</span> </td> </tr>");
            strReturn.Append("  </table>");


            //首行内容
            strReturn.Append("  <table style='font-size: 14px; padding-bottom:5px;'><tr>");
            strReturn.Append("    <td style='width: 200px;'>  <span >网点名称：" + WBName + "</span> </td>");
            strReturn.Append("    <td style='width: 240px;'>  <span >储户姓名：" + Dep_Name + "</span> </td>");
            strReturn.Append("    <td style='width: 200px;'>  <span >日期：" + StorageDate + "</span> </td>");
            strReturn.Append("   </tr> </table>");


            //表格内容
            strReturn.Append("    <table class='tabPrint' style='padding: 5px 0px; font-size: 14px;'>");
            //添加表格样式
            strReturn.Append("    <style>");
            strReturn.Append("    table.tabPrint{ border-collapse: collapse; border: 1px solid #666;  font-size: 14px;}");
            strReturn.Append("     table.tabPrint thead td, table.set_border th{ font-weight: bold; background-color: White;}");
            strReturn.Append("    table.tabPrint tr:nth-child(even){ background-color: #666;}");
            strReturn.Append("     table.tabPrint td, table.border th{  border: 1px solid #666;}");
            strReturn.Append("   </style>");


            strReturn.Append("   <tr style='height: 20px;'>");
            strReturn.Append("    <td style='width: 100px;'> <span>业务名称</span></td>");
            strReturn.Append("    <td style='width: 100px;'> <span>储户账号</span></td>");
            strReturn.Append("    <td style='width: 100px;'> <span>产品类型</span></td>");
            strReturn.Append("    <td style='width: 80px;'> <span>重量</span></td>");
            strReturn.Append("    <td style='width: 80px;'> <span>单价</span></td>");
            strReturn.Append("    <td style='width: 90px;'> <span>应付利息</span></td>");
            strReturn.Append("    <td style='width: 90px;'> <span>实付利息</span></td>");
            strReturn.Append("  </tr>");

            strReturn.Append("   <tr style='height: 20px;'>");
            strReturn.Append("    <td > <span>" + BusinessName + "</span></td>");
            strReturn.Append("    <td> <span>" + Dep_AN + "</span></td>");
            strReturn.Append("    <td> <span>" + GoodName + "</span></td>");
            strReturn.Append("    <td> <span>" + numWeight + "</span></td>");
            strReturn.Append("    <td> <span>" + numPrice + "</span></td>");
            strReturn.Append("    <td> <span>￥" + Money_Total + "</span></td>");
            strReturn.Append("    <td> <span>￥" + Money_Reality + "</span></td>");
            strReturn.Append("  </tr>");
            string strMoney_Reality = Fun.ChangeToRMB(Money_Reality);
            strReturn.Append("   <tr style='height: 20px;'>");
            strReturn.Append("    <td> <span>大写金额</span></td>");
            strReturn.Append("    <td colspan='4'> <span>" + strMoney_Reality + "</span></td>");
            strReturn.Append("    <td colspan='2'></td>");//<span>余款合计:￥</span> <span>" + Money_Surplus + "</span>

            strReturn.Append("  </tr>");


            //第三行内容
            strReturn.Append("   <table style='font-size: 14px; padding:5px 0px;'>");
            strReturn.Append("    <tr style='height: 25px;'>");
            strReturn.Append("   <td style='width:160px;'> <span>付款日期：" + dt_Trade + "</span></td>");
            strReturn.Append("   <td style='width:160px;'> <span>计量单位：元、" + UnitName + "</span></td>");
            strReturn.Append("   <td style='width:160px;'> <span>总部会计：" + Accountant_Name + "</span></td>");
            strReturn.Append("   <td align='right' style='width:80px;'> <span>分行签名：</span></td><td> <div style='width:80px;height:25px; border-bottom:1px solid #333;'></div></td>");
            strReturn.Append("  </tr>");


            strReturn.Append("  </table>");


            context.Response.Write(strReturn.ToString());
        }

        /// <summary>
        /// 遍历记录插入数据到利息结算表
        /// </summary>
        /// <param name="context"></param>
        private void AddAllStorageJxCalculate(HttpContext context)
        {
            string WBID = context.Request.QueryString["WBID"].ToString();
            string WBName = common.GetWBInfoByID(Convert.ToInt32(WBID))["strName"].ToString();
            string dtStart = context.Request.QueryString["dtStart"].ToString();
            string dtEnd = context.Request.QueryString["dtEnd"].ToString();
            StringBuilder getStorageJxInfoSql = new StringBuilder();
            getStorageJxInfoSql.Append(@" select s.ID,s.StorageDate,s.UserId,s.WBID,s.StorageJxDate,s.Price_Shichang,s.StorageNumber,s.VarietyID,w.strName as WBName,d.strName as DepName,
                                            s.AccountNumber,s.TypeID,s.TimeID,v.strName as goodName,s.CurrentRate,s.Lixi ,s.BusinessName,
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
                                            on v.ID=s.VarietyID where 1=1 ");
            if (!string.IsNullOrWhiteSpace(WBID))
            {
                getStorageJxInfoSql.Append(string.Format(" and s.WBID={0} ", WBID));
            }
            if (!string.IsNullOrWhiteSpace(dtStart) && !string.IsNullOrWhiteSpace(dtStart))
            {

                getStorageJxInfoSql.Append(" and (s.StorageDate>'" + dtStart + "' and s.StorageDate<'" + Convert.ToDateTime(dtEnd).AddDays(1) + "')");
            }
            var dt = SQLHelper.ExecuteDataTable(getStorageJxInfoSql.ToString());
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        int id = Convert.ToInt32(dt.Rows[i]["ID"]);
                        //判断是否已经结算
                        string sql = @"select count(ID) from StorageJxCalculate where storageJxRecordID=" + id;
                        var scalar = SQLHelper.ExecuteScalar(sql);
                        int res = Convert.ToInt32(scalar);
                        if (res>0)
                        {
                            continue;
                        }
                        #region 添加数据
                        int StorageJxRecordID = id;
                        string strGUID = Fun.getGUID();//获取新的GUID
                                                       //临时暂用的编号
                        string serialNumber = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + "0000001";
                        string wbId = dt.Rows[0]["WBID"].ToString();
                        string userID = dt.Rows[0]["UserId"].ToString();
                        string accountNumber = dt.Rows[0]["AccountNumber"].ToString();
                        string unit = "公斤";
                        string numWeight = dt.Rows[0]["StorageNumber"].ToString();
                        string numPrice = dt.Rows[0]["Price_Shichang"].ToString();
                        string varietyID = dt.Rows[0]["VarietyID"].ToString();
                        string liXi = dt.Rows[0]["LiXi"].ToString();
                        DateTime dt_Trade = DateTime.Now;
                        string storageDate = dt.Rows[0]["StorageDate"].ToString();
                        string businessName = dt.Rows[0]["BusinessName"].ToString();
                        //string accountantName = dt.Rows[0]["StorageDate"].ToString();
                        string currentRate = dt.Rows[0]["CurrentRate"].ToString();
                        string typeID = dt.Rows[0]["TypeID"].ToString();
                        string timeID = dt.Rows[0]["TimeID"].ToString();
                        string Accountant_Name = "";
                        string insertSql = @"insert into StorageJxCalculate(storageJxRecordID,strGUID,serialNumber,AccountNumber,WBID,UserID,Unit,numWeight,
                                    numPrice,Lixi,dt_Trade,StorageDate,BusinessName,Accountant_Name,CurrentRate,VarietyID,TypeID,TimeID)values(@storageJxRecordID,
                                    @strGUID,@serialNumber,@AccountNumber,@WBID,@UserID,@Unit,@numWeight,@numPrice,@Lixi,@dt_Trade,@StorageDate,@BusinessName,
                                    @Accountant_Name,@CurrentRate,@VarietyID,@TypeID,@TimeID)";
                        SqlParameter[] paras = new SqlParameter[]
                        {
                    new SqlParameter("@storageJxRecordID",StorageJxRecordID),
                    new SqlParameter("@strGUID",strGUID),
                    new SqlParameter("@serialNumber",serialNumber),
                    new SqlParameter("@AccountNumber",accountNumber),
                    new SqlParameter("@WBID",wbId),
                    new SqlParameter("@UserID",userID),
                    new SqlParameter("@Unit",unit),
                    new SqlParameter("@numWeight",numWeight),
                    new SqlParameter("@numPrice",numPrice),
                    new SqlParameter("@Lixi",liXi),
                    new SqlParameter("@dt_Trade",dt_Trade),

                    new SqlParameter("@StorageDate",storageDate),
                    new SqlParameter("@BusinessName",businessName),
                    new SqlParameter("@Accountant_Name",Accountant_Name),
                    new SqlParameter("@CurrentRate",currentRate),
                    new SqlParameter("@VarietyID",varietyID),
                    new SqlParameter("@TypeID",typeID),
                    new SqlParameter("@TimeID",timeID)
                        };

                        int result = SQLHelper.ExecuteNonQuery(insertSql, paras);
                        if (result > 0)
                        {
                            context.Response.Write("OK");
                        }
                        else
                        {
                            context.Response.Write("Error");
                        }

                        #endregion
                    }

                }
                else
                {
                    context.Response.Write("Data Error");
                }
            }
            else
            {
                context.Response.Write("Data Error");
            }
        }

        /// <summary>
        /// 添加数据到利息结算表
        /// </summary>
        /// <param name="context"></param>
        private void AddStorageJxCalculate(HttpContext context)
        {
            string ID = context.Request.QueryString["ID"].ToString();
            string Accountant_Name = context.Request.QueryString["Accountant"].ToString();
            string getStorageJxInfoSql = @"select s.ID,s.StorageDate,s.UserId,s.WBID,s.StorageJxDate,s.Price_Shichang,s.StorageNumber,s.VarietyID,w.strName as WBName,d.strName as DepName,
                            s.AccountNumber,s.TypeID,s.TimeID,v.strName as goodName,s.CurrentRate,s.Lixi ,s.BusinessName,
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
                            on v.ID=s.VarietyID where s.ID=" + ID;
            DataTable dt = SQLHelper.ExecuteDataTable(getStorageJxInfoSql.ToString());

            if (dt != null && dt.Rows.Count != 0)
            {
                string StorageJxRecordID = ID;
                string strGUID = Fun.getGUID();//获取新的GUID
                                               //临时暂用的编号
                string serialNumber = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + "0000001";
                string wbId = dt.Rows[0]["WBID"].ToString();
                string userID = dt.Rows[0]["UserId"].ToString();
                string accountNumber= dt.Rows[0]["AccountNumber"].ToString();
                string unit = "公斤";
                string numWeight = dt.Rows[0]["StorageNumber"].ToString();
                string numPrice = dt.Rows[0]["Price_Shichang"].ToString();
                string varietyID = dt.Rows[0]["VarietyID"].ToString();
                string liXi = dt.Rows[0]["LiXi"].ToString();
                DateTime dt_Trade = DateTime.Now;
                string storageDate= dt.Rows[0]["StorageDate"].ToString();
                string businessName = dt.Rows[0]["BusinessName"].ToString();
                //string accountantName = dt.Rows[0]["StorageDate"].ToString();
                string currentRate = dt.Rows[0]["CurrentRate"].ToString();
                string typeID = dt.Rows[0]["TypeID"].ToString();
                string timeID = dt.Rows[0]["TimeID"].ToString();

                string insertSql = @"insert into StorageJxCalculate(storageJxRecordID,strGUID,serialNumber,AccountNumber,WBID,UserID,Unit,numWeight,
                                    numPrice,Lixi,dt_Trade,StorageDate,BusinessName,Accountant_Name,CurrentRate,VarietyID,TypeID,TimeID)values(@storageJxRecordID,
                                    @strGUID,@serialNumber,@AccountNumber,@WBID,@UserID,@Unit,@numWeight,@numPrice,@Lixi,@dt_Trade,@StorageDate,@BusinessName,
                                    @Accountant_Name,@CurrentRate,@VarietyID,@TypeID,@TimeID)";
                SqlParameter[] paras = new SqlParameter[]
                {
                    new SqlParameter("@storageJxRecordID",ID),
                    new SqlParameter("@strGUID",strGUID),
                    new SqlParameter("@serialNumber",serialNumber),
                    new SqlParameter("@AccountNumber",accountNumber),
                    new SqlParameter("@WBID",wbId),
                    new SqlParameter("@UserID",userID),
                    new SqlParameter("@Unit",unit),
                    new SqlParameter("@numWeight",numWeight),
                    new SqlParameter("@numPrice",numPrice),
                    new SqlParameter("@Lixi",liXi),
                    new SqlParameter("@dt_Trade",dt_Trade),

                    new SqlParameter("@StorageDate",storageDate),
                    new SqlParameter("@BusinessName",businessName),
                    new SqlParameter("@Accountant_Name",Accountant_Name),
                    new SqlParameter("@CurrentRate",currentRate),
                    new SqlParameter("@VarietyID",varietyID),
                    new SqlParameter("@TypeID",typeID),
                    new SqlParameter("@TimeID",timeID)
                };

                int result = SQLHelper.ExecuteNonQuery(insertSql, paras);
                if (result > 0)
                {
                    context.Response.Write("OK");
                }
                else
                {
                    context.Response.Write("Error");
                }

            }
            else
            {
                context.Response.Write("Data Error");
            }
        }

        /// <summary>
        /// 利息是否结算
        /// </summary>
        /// <param name="context"></param>
        void ISHaveJs(HttpContext context)
        {
            string ID = context.Request.QueryString["ID"].ToString();
            string strSql = " SELECT COUNT(ID) FROM dbo.SA_Sell WHERE  StorageSellID=" + ID;
            context.Response.Write(SQLHelper.ExecuteScalar(strSql.ToString()).ToString());
        }
        void GetSingle(HttpContext context)
        {
            string ID = context.Request.QueryString["ID"].ToString();
            string sql = @"select s.ID,CONVERT(NVARCHAR(100), s.StorageDate,23) AS StorageDate,s.StorageJxDate,s.Price_Shichang,s.StorageNumber,w.strName as WBName,d.strName as DepName,
                            s.AccountNumber,v.strName as goodName,s.CurrentRate,s.Lixi ,
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
                            on v.ID=s.VarietyID where s.ID=" + ID;

            DataTable dt = SQLHelper.ExecuteDataTable(sql.ToString());

            if (dt != null && dt.Rows.Count != 0)
            {
                context.Response.Write(JsonHelper.ToJson(dt));
            }
            else
            {
                context.Response.Write("Error");
            }

        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}