using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.User.Storage
{
    public partial class storageCombine : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                btnHeBing.Visible = false;
            }
        }
        private void Bind()
        {
            string accountnumber = txtAC.Value;
            if (string.IsNullOrWhiteSpace(accountnumber))
            {
                ClientScript.RegisterClientScriptBlock(GetType(), "","<script>alert('请填写储户账号！')</script>");
                return;
            }
            string sql = string.Format(@"SELECT  A.ID, A.TypeID,A.StorageRateID,A.StorageNumber,convert(varchar(10),A.StorageDate,120) AS StorageDate,A.ISVirtual,
                             DATEDIFF( Day, A.StorageDate,GETDATE())AS daycount,
                            A.AccountNumber,B.ID AS VarietyID,A.VarietyLevelID,l.strName as LevelName, B.strName AS VarietyName,A.Price_ShiChang,A.Price_DaoQi,A.CurrentRate,A.WeighNo,
                            C.ID AS TimeID, C.strName AS TimeName,C.InterestType,A.StorageFee,D.strName AS UnitName
                            FROM dbo.Dep_StorageInfo A INNER JOIN dbo.StorageVariety B ON A.VarietyID=B.ID
                            INNER JOIN dbo.StorageTime C ON A.TimeID=C.ID
                            inner join StorageVarietyLevel_B as l on l.ID=a.VarietyLevelID
                            LEFT JOIN dbo.BD_MeasuringUnit D ON B.MeasuringUnitID=D.ID

                            where a.AccountNumber='{0}'
                            and a.StorageNumber >0 order by B.strName,C.strName", accountnumber);
            var dt = SQLHelper.ExecuteDataTable(sql);
            repeater1.DataSource = dt;
            repeater1.DataBind();
        }

        protected void btnHeBing_Click(object sender, EventArgs e)
        {
            btnHeBing.Visible = true;
            int selectNum = 0;
            string ids = string.Empty;
            foreach (RepeaterItem item in repeater1.Items)
            {
                CheckBox cb = (CheckBox)item.FindControl("selectHB");
                if (cb.Checked == true)
                {
                    selectNum += 1;
                    ids += cb.ToolTip + ",";

                }
            }
            if (ids.Length == 0 || selectNum == 0)
            {
                ClientScript.RegisterClientScriptBlock(GetType(), "", "<script>alert('请选择两条存储信息合并！');</script>");
                return;
            }
            ids = ids.Substring(0, ids.Length - 1);
            string[] Ids = ids.Split(',');
            if (Ids.Length == 2)
            {
                string hebingSql = "select distinct  AccountNumber,TimeID,VarietyLevelID, VarietyID from Dep_StorageInfo where ID in (" + Ids[0] + "," + Ids[1] + ")";
                var dt = SQLHelper.ExecuteDataTable(hebingSql);
                //显示需要合并的两条项目
                //判断两条数据的存期，等级、产品是否相同
                if (dt.Rows.Count > 1)//选择的两天数据不是相同的存期，产品、等级
                {
                    ClientScript.RegisterClientScriptBlock(GetType(), "", "<script>alert('选择的两条数据不能合并，原因可能是存期，产品名称、等级不相同！');</script>");
                    return;
                }
                //double storageNumber1 = 0, storageNumber2 = 0;
                //int IdOne = 0, IdTwo = 0;
                //hebingSql = "select ID,storagenumber from Dep_StorageInfo  where ID in (" + Ids[0] + "," + Ids[1] + ")";
                //var storageNumberdt = SQLHelper.ExecuteDataTable(hebingSql);
                //storageNumber1 = Convert.ToDouble(storageNumberdt.Rows[0]["storagenumber"]);
                //storageNumber2 = Convert.ToDouble(storageNumberdt.Rows[1]["storagenumber"]);
                //IdOne = Convert.ToInt32(storageNumberdt.Rows[0]["ID"]);
                //IdTwo = Convert.ToInt32(storageNumberdt.Rows[1]["ID"]);
                //绑定弹出框repeater1
                string sql = string.Format(@"SELECT  A.ID, A.TypeID,A.StorageRateID,A.StorageNumber,convert(varchar(10),A.StorageDate,120) AS StorageDate,A.ISVirtual,
                             DATEDIFF( Day, A.StorageDate,GETDATE())AS daycount,
                            A.AccountNumber,B.ID AS VarietyID,A.VarietyLevelID,l.strName as LevelName, B.strName AS VarietyName,A.Price_ShiChang,A.Price_DaoQi,A.CurrentRate,A.WeighNo,
                            C.ID AS TimeID, C.strName AS TimeName,C.InterestType,A.StorageFee,D.strName AS UnitName
                            FROM dbo.Dep_StorageInfo A INNER JOIN dbo.StorageVariety B ON A.VarietyID=B.ID
                            INNER JOIN dbo.StorageTime C ON A.TimeID=C.ID
                            inner join StorageVarietyLevel_B as l on l.ID=a.VarietyLevelID
                            LEFT JOIN dbo.BD_MeasuringUnit D ON B.MeasuringUnitID=D.ID

                            where a.ID in ({0},{1})
                            and a.StorageNumber >0", Ids[0], Ids[1]);
                var dtHB = SQLHelper.ExecuteDataTable(sql);
                repeater2.DataSource = dtHB;
                repeater2.DataBind();

                StringBuilder sb = new StringBuilder("$(function (){");
                sb.Append(" $('#divfrm').show();");
                sb.Append(" });");
                ClientScript.RegisterClientScriptBlock(GetType(), "", sb.ToString(),true);
            }
            else
            {
                ClientScript.RegisterClientScriptBlock(GetType(), "", "<script>alert('只能选择两条存储信息合并！');</script>");
                return;
            }

        
        }

        private int HB(double num1,double num2,int idOne,int idTwo,string AccountNumber)
        {
            int depsID_Operate = 0;

            string sqlUpdate = string.Empty;
            string sqlUpdateSm = string.Empty;//置零
            SqlParameter[] para = null;
            SqlParameter[] para2 = null;
            if (num1 > num2)
            {
                depsID_Operate = idOne;
                sqlUpdate="update Dep_StorageInfo set StorageNumber=StorageNumber+@NewNumber where ID=@ID";
                sqlUpdateSm = "update Dep_StorageInfo set StorageNumber=0 where ID=@ID ";
                 para = new SqlParameter[]
                {
                    new SqlParameter("@NewNumber",num2),
                    new SqlParameter("@ID",idOne)
                };
                para2 = new SqlParameter[]
                {
                      new SqlParameter("@ID",idTwo)
                };
            }
            else if (num1 == num2)
            {
                depsID_Operate = idOne;
                sqlUpdate = "update Dep_StorageInfo set StorageNumber=StorageNumber+@NewNumber where ID=@ID";
                sqlUpdateSm = "update Dep_StorageInfo set StorageNumber=0 where ID=@ID ";
                para = new SqlParameter[]
                {
                    new SqlParameter("@NewNumber",num2),
                    new SqlParameter("@ID",idOne)
                };
                para2 = new SqlParameter[]
                {
                      new SqlParameter("@ID",idOne)
                };
            }
            else
            {
                depsID_Operate = idTwo;
                sqlUpdate = "update Dep_StorageInfo set StorageNumber=StorageNumber+@NewNumber where ID=@ID";
                sqlUpdateSm = "update Dep_StorageInfo set StorageNumber=0 where ID=@ID ";
                para = new SqlParameter[]
                {
                    new SqlParameter("@NewNumber",num1),
                    new SqlParameter("@ID",idTwo)
                };
                para2 = new SqlParameter[]
               {
                      new SqlParameter("@ID",idOne)
               };
            }
            var wbId = Session["WB_ID"];//网点ID
            var userId = Session["ID"];

            #region 添加操作记录

            //根据depID查询出存储信息
            string depStorageInfoSql = @"select Price_ShiChang,VarietyID,s.strName as TimeName,v.strName as VarietyName from Dep_StorageInfo as d 
                                                        left outer join StorageTime as s
                                                        on s.ID=d.TimeID
                                                        left outer join StorageVariety as v
                                                        on v.ID=d.VarietyID
                                                         where d.ID=" + depsID_Operate;
             var dt = SQLHelper.ExecuteDataTable(depStorageInfoSql);

            StringBuilder strSqlOperateLog = new StringBuilder();
            SqlParameter[] parametersOperateLog = null;
            if (dt.Rows.Count > 0)
            {
                double Price = Convert.ToDouble(dt.Rows[0]["Price_ShiChang"]);
                string VarietyID = dt.Rows[0]["VarietyID"].ToString();
                string TimeName = dt.Rows[0]["TimeName"].ToString();
                string VarietyName = dt.Rows[0]["VarietyName"].ToString();
                string UnitID = "公斤";
                double Count_Trade = num1 + num2;
                string BusinessNO = common.GetNewBusinessNO_Dep(AccountNumber);//交易流水号
                string Money_Trade = "0";//存入的时候没有交易量
                double Count_Balance = common.GetDep_StorageNumber(AccountNumber, VarietyID);//储户总结存
                                                                                             //Count_Balance = Count_Balance + Convert.ToDouble(StorageNumber);
               
                strSqlOperateLog.Append("insert into [Dep_OperateLog] (");
                strSqlOperateLog.Append("WBID,UserID,Dep_AccountNumber,BusinessNO,BusinessName,VarietyID,UnitID,Price,GoodCount,Count_Trade,Money_Trade,Count_Balance,dt_Trade,VarietyName,UnitName,Dep_SID,numInterest)");
                strSqlOperateLog.Append(" values (");
                strSqlOperateLog.Append("@WBID,@UserID,@Dep_AccountNumber,@BusinessNO,@BusinessName,@VarietyID,@UnitID,@Price,@GoodCount,@Count_Trade,@Money_Trade,@Count_Balance,@dt_Trade,@VarietyName,@UnitName,@Dep_SID,@numInterest)");
                strSqlOperateLog.Append(";select @@IDENTITY");
                 parametersOperateLog =new SqlParameter[] {
                    new SqlParameter("@WBID", SqlDbType.Int,4),
                    new SqlParameter("@UserID", SqlDbType.Int,4),
                    new SqlParameter("@Dep_AccountNumber", SqlDbType.NVarChar,50),
                    new SqlParameter("@BusinessNO", SqlDbType.NVarChar,50),
                    new SqlParameter("@BusinessName", SqlDbType.NVarChar,50),
                    new SqlParameter("@VarietyID", SqlDbType.NVarChar,50),
                    new SqlParameter("@UnitID", SqlDbType.NVarChar,50),
                    new SqlParameter("@Price", SqlDbType.Decimal,9),
                    new SqlParameter("@GoodCount", SqlDbType.Decimal,9),
                    new SqlParameter("@Count_Trade", SqlDbType.Decimal,9),
                    new SqlParameter("@Money_Trade", SqlDbType.Decimal,9),
                    new SqlParameter("@Count_Balance", SqlDbType.Decimal,9),
                    new SqlParameter("@dt_Trade", SqlDbType.DateTime),
                    new SqlParameter("@VarietyName", SqlDbType.NVarChar,50),
                    new SqlParameter("@UnitName", SqlDbType.NVarChar,50),
                           new SqlParameter("@Dep_SID", SqlDbType.Int,4),
                           new SqlParameter("@numInterest", SqlDbType.Decimal,9)};
                parametersOperateLog[0].Value = wbId;
                parametersOperateLog[1].Value = userId;
                parametersOperateLog[2].Value = AccountNumber;
                parametersOperateLog[3].Value = BusinessNO;
                parametersOperateLog[4].Value = "19";//1:存入 2：兑换  3:存转销 4: 提取
                parametersOperateLog[5].Value = VarietyID;
                parametersOperateLog[6].Value = UnitID;
                parametersOperateLog[7].Value = Price;
                parametersOperateLog[8].Value = Count_Trade;
                parametersOperateLog[9].Value = Count_Trade;
                parametersOperateLog[10].Value = Money_Trade;
                parametersOperateLog[11].Value = Count_Balance;
                parametersOperateLog[12].Value = DateTime.Now;
                parametersOperateLog[13].Value = TimeName + VarietyName;
                parametersOperateLog[14].Value = UnitID;
                parametersOperateLog[15].Value = depsID_Operate;
                parametersOperateLog[16].Value = 0;

            }

            #endregion

            int result = 0;
            //添加事务处理
            using (SqlTransaction tran = SQLHelper.BeginTransaction(SQLHelper.connectionString))
            {
                try
                {
                    //SQLHelper.ExecuteNonQuery(tran, CommandType.Text, strSql.ToString());//添加兑换交易记录

                    result = SQLHelper.ExecuteNonQuery(tran, CommandType.Text, sqlUpdate, para);
                    SQLHelper.ExecuteNonQuery(tran, CommandType.Text, sqlUpdateSm, para2);
                    if (result > 0)
                    {
                        //插入数据到合并记录表
                      
                        string insertStorageCombine = @"insert into StorageCombine(DepsIDOne,DepsIDTwo,UserID,WBID,dt_Create,AccountNumber)
                                                        values(@DepsIDOne,@DepsIDTwo,@UserID,@WBID,@dt_Create,@AccountNumber)";
                        SqlParameter[] paras = new SqlParameter[]
                        {
                            new SqlParameter("@DepsIDOne",idOne),
                            new SqlParameter("@DepsIDTwo",idTwo),
                            new SqlParameter("@UserID",userId),
                            new SqlParameter("@WBID",wbId),
                            new SqlParameter("@dt_Create",DateTime.Now),
                            new SqlParameter("@AccountNumber",AccountNumber)
                        };
                        SQLHelper.ExecuteNonQuery(tran, CommandType.Text, insertStorageCombine, paras);
                        SQLHelper.ExecuteNonQuery(tran, CommandType.Text, strSqlOperateLog.ToString(), parametersOperateLog);

                        tran.Commit();

                    }
                }
                catch(Exception ex) {
                    tran.Rollback();
                    var res = new { state = "error", msg = "数据库执行错误!" };
                    result = 0;
                    return result;
                }
            }

            return result;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            btnHeBing.Visible = true;
            int selectNum = 0;
            string ids = string.Empty;
            string accountNumber = txtAC.Value;
            //for (int i = 0; i < repeater2.Items.Count; i++)
            //{
            //    repeater1
            //}
            foreach (RepeaterItem item in repeater2.Items)
            {
                //Label cb = (Label)item.FindControl("lblID");
                string str_ID = ((CheckBox)item.FindControl("lblID")).ToolTip;
                selectNum += 1;
               ids += str_ID + ",";              
            }
            //if (ids.Length == 0 || selectNum == 0)
            //{
            //    ClientScript.RegisterClientScriptBlock(GetType(), "", "<script>alert('请选择两条存储信息合并！');</script>");
            //    return;
            //}
            ids = ids.Substring(0, ids.Length - 1);
            string[] Ids = ids.Split(',');
            //if (Ids.Length == 2)
            //{
                //string hebingSql = "select distinct  AccountNumber,TimeID,VarietyLevelID, VarietyID from Dep_StorageInfo where ID in (" + Ids[0] + "," + Ids[1] + ")";
                //var dt = SQLHelper.ExecuteDataTable(hebingSql);
                ////显示需要合并的两条项目
                ////判断两条数据的存期，等级、产品是否相同
                //if (dt.Rows.Count > 1)//选择的两天数据不是相同的存期，产品、等级
                //{
                //    ClientScript.RegisterClientScriptBlock(GetType(), "", "<script>alert('选择的两条数据不能合并，原因可能是存期，产品名称、等级不相同！');</script>");
                //    return;
                //}
                double storageNumber1 = 0, storageNumber2 = 0;
                int IdOne = 0, IdTwo = 0;
                string hebingSql = "select ID,storagenumber from Dep_StorageInfo  where ID in (" + Ids[0] + "," + Ids[1] + ")";
                var storageNumberdt = SQLHelper.ExecuteDataTable(hebingSql);
                storageNumber1 = Convert.ToDouble(storageNumberdt.Rows[0]["storagenumber"]);
                storageNumber2 = Convert.ToDouble(storageNumberdt.Rows[1]["storagenumber"]);
                IdOne = Convert.ToInt32(storageNumberdt.Rows[0]["ID"]);
                IdTwo = Convert.ToInt32(storageNumberdt.Rows[1]["ID"]);
               if( HB(storageNumber1, storageNumber2, IdOne, IdTwo, accountNumber) > 0)
                {
                ClientScript.RegisterClientScriptBlock(GetType(), "", "<script>alert('操作成功！');</script>");
                Bind();
                return;
                }

            //插入数据到储户存量合并记录表

            //点击按钮合并
            //}
            //else
            //{
            //    ClientScript.RegisterClientScriptBlock(GetType(), "", "<script>alert('只能选择两条存储信息合并！');</script>");
            //    return;
            //}
        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            btnHeBing.Visible = true;
            Bind();
        }
        decimal sum = 0;
        protected void repeater2_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            btnHeBing.Visible = true;
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)

            {

                string num = DataBinder.Eval(e.Item.DataItem, "StorageNumber").ToString().Trim();

                if (!num.Equals(""))

                    sum += Convert.ToDecimal(num);
            }
            this.lblSum.Text = sum.ToString();
        }
    
    }
}