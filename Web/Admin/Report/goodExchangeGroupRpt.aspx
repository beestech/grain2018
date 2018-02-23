<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="goodExchangeGroupRpt.aspx.cs" Inherits="Web.Admin.Report.goodExchangeGroupRpt" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
     <script src="../../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="../../Scripts/WebInner.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/excelhelper.js"></script>
    <script src="../../Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script src="../../Scripts/fakeLoader.js" type="text/javascript"></script>
    <link href="../../Styles/fakeLoader.css" rel="stylesheet" />
    
    <style>
          .Query {
            margin: 0px 0px 5px 0px;
            background: #e0eeee;
            border: 1px solid #9ac0cd;
            border-radius: 10px;
            max-width: 965px;
            padding: 0px 5px 5px 5px;
        }

            .Query span {
                font-size: 12px;
                color: #333;
            }

            .Query img {
                width: 30px;
                height: 30px;
                margin: 0px 10px -8px 10px;
                cursor: pointer;
            }

            .Query .outputExcel {
                width: 60px;
                color: #111;
            }

        #dataInfo {
            display: none;
        }

            #dataInfo .btndetail {
                width: 50px;
                height: 20px;
                /*background: #cdcdcd;
                border: 1px solid #aaa;*/
                /*color: green;*/
                cursor: pointer;
            }
          .datadetail {
            display: none;
            position: fixed;
            top: 300px;
            left: 350px;
            width: 850px;
            height: 200px;
            background: #efefef;
            border: 2px solid #9ac0cd;
            padding: 5px 10px;
            border-radius: 10px;
            z-index: 100;
        }

        .datainner {
            width: 100%;
            height: 100%;
            overflow: auto;
        }

        .datadetail .datadetail_head {
            float: left;
            font-size: 14px;
            margin: 5px 0px 10px 0px;
        }

            .datadetail .datadetail_head .spaninfo {
                margin-left: 5px;
                color: blue;
            }

        .datadetail .div_close {
            float: right;
        }

        .datadetail #dataInfo_detail {
            clear: both;
        }

        .datadetail .div_close #noticeclose {
            font-size: 18pt;
            color: red;
            background: #efefef;
            border-radius: 50%;
            border: 1px solid #ccc;
            width: 30px;
            height: 30px;
            cursor: pointer;
        }
    </style>    
    <script>
        $(function () {
            $('.imgclose').click(function () {
                $('.datadetail').fadeOut();
            })
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="pageHead">
            <b>分时批量兑换汇总报表</b>
        </div>

        <div class="QueryHead">
            <table>
                <tr>
                    <td><span>网点:</span>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlWb" runat="server" Width="100px" Height="30px" >
                            
                        </asp:DropDownList>
                       <%-- <input type="text" id="txtWBID" onkeyup="InitWBID();" style="font-size: 16px; width: 100px; height: 26px; font-weight: bolder;" runat="server" />--%>
                        </td>
                    <td><span>存粮类型:</span></td>
                    <td>
                        <asp:DropDownList ID="ddlStorage" runat="server" Width="100px" Height="30px">
                            </asp:DropDownList>
                    </td>
                    <td><span>日期:</span>
                    </td>
                    <td>
                        <input type="text" id="Qdtstart" readonly="readonly" onclick="WdatePicker();" placeholder="开始时间" style="font-size: 16px; width: 100px; font-weight: bolder;" runat="server" />
                        <span>-</span>
                        <input type="text" id="Qdtend" readonly="readonly" onclick="WdatePicker()" placeholder="结束时间" style="font-size: 16px; width: 100px; font-weight: bolder;" runat="server" />
                    </td>
                    
                    <td style="width: 60px">
                        &nbsp;
                        <asp:ImageButton ID="ImageButton1" runat="server"
                            ImageUrl="~/images/search_red.png" OnClick="ImageButton1_Click" />
                    </td>
                 <%--   <td>
                        <asp:Button ID="btnOutPut" runat="server" class="outputExcel" Width="50px" Text="Excel"/>
                    </td>--%>
                </tr>
            </table>
        </div>

        <asp:Repeater ID="Repeater1" runat="server" OnItemCommand="Repeater1_ItemCommand">
            <HeaderTemplate>
                <table class="tabData">
                    <tr class="tr_head">
                        <th style="min-width: 100px; height: 20px; text-align: center;">储户网点
                        </th>
                        <th style="min-width: 100px; text-align: center;">交易网点
                        </th>
                         <th style="min-width: 100px; height: 20px; text-align: center;">存粮类型
                        </th>
                        <th style="min-width: 100px; text-align: center;">交易商品
                        </th>
                        <th style="min-width: 100px; text-align: center;">交易量
                        </th>
                        <th style="min-width: 100px; text-align: center;">折合原粮
                        </th>
                        <th style="min-width: 100px; text-align: center;">￥金额
                        </th>
                        <th style="min-width: 100px; text-align: center;">￥利息
                        </th>
                        <th style="min-width: 100px; text-align: center;">操作
                        </th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr 
                    onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                    <td style="height:25px">
                        <%#Eval("depStrName")%>
                    </td>
                    <td>
                        <%#Eval("exchangeName")%>
                    </td>
                     <td>
                        <%#Eval("StorageName")%>
                    </td>
                    <td>
                        <%#Eval("GoodName")%>
                    </td>
                    <td>
                        <%#Eval("GoodCount")%>
                    </td>
                    <td>
                        <%#Eval("VarietyCount")%>
                    </td>
                     <td>
                        <%#Eval("Money_DuiHuan")%>
                    </td>
                     <td>
                        <%# Eval("VarietyInterest")%>
                    </td>
                     <td>                         
                         <asp:LinkButton Text="详细" CommandName="detail" CommandArgument='<%# Eval("exWBID")+","+Eval("exchangeName")+","+Eval("dep_WBID")+","+Eval("depStrName")+","+Eval("GoodID")+","+Eval("GoodName")+","+Eval("StorageVarietyID")+","+Eval("StorageName")  %>' runat="server" />                        
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>

                <!--底部模板-->
                </table>
                <!--表格结束部分-->
            </FooterTemplate>
        </asp:Repeater>     

        <div class="datadetail">
                 <div class="datainner">
                <div class="datadetail_head">
                    <span>储户网点:</span><span id="spanWBID" class="spaninfo">
                        <asp:Label ID="lbldepWb" runat="server" />
                                      </span>
                    <span>交易网点:</span><span id="spanTradeWBID" class="spaninfo">
                        <asp:Label ID="lblExchangewb" runat="server" />
                                      </span>                    
                    <br />
                    <span>商品类型:</span><span id="spanGoodID" class="spaninfo">
                        <asp:Label ID="lblGoodName" runat="server" />
                                      </span>
                    <span>存粮类型:</span><span id="spanVarietyID" class="spaninfo">
                        <asp:Label ID="lblVarietyName" runat="server" />
                                      </span>
                    <span>开始时间:</span><span id="spandtBegin" class="spaninfo">
                        <asp:Label ID="lblStartDate" runat="server" />
                                      </span>
                    <span>结束时间:</span><span id="spandtEnd" class="spaninfo">
                        <asp:Label ID="lblEndDate" runat="server" />
                                      </span>
                </div>
                <img class="imgclose" src="../../images/winClose.png" alt="关闭窗口" style="float: right; cursor: pointer;" />
                <!--<div class="div_close">
                    <input type="button" id="noticeclose" value="×">
                </div>-->
                <asp:Repeater runat="server" ID="rptDetail">
                    <HeaderTemplate>
                        <table class="tabData" id="dataInfo_detail">
                    <tr class="tr_head">
                        <th style="width: 100px; height:20px; text-align: center;">
                            类型
                        </th>
                        <th style="width: 80px; text-align: center;">
                            账号
                        </th>
                        <th style="width: 80px; text-align: center;">
                            姓名
                        </th>
                        <th style="width: 80px; text-align: center;">
                            交易量
                        </th>
                        <th style="width: 80px; text-align: center;">
                            折合原粮
                        </th>
                        <th style="width: 80px; text-align: center;">
                            折合现金
                        </th>
                        <th style="width: 80px; text-align: center;">
                            利息
                        </th>
                        <th style="width: 80px; text-align: center;">
                            时间
                        </th>
                    </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("IsReturn") %></td>
                            <td><%# Eval("Dep_AccountNumber") %></td>
                            <td><%# Eval("Dep_Name") %></td>
                            <td><%# Eval("GoodCount") %></td>
                            <td><%# Eval("VarietyCount") %></td>
                            <td><%# Eval("Money_DuiHuan") %></td>
                            <td><%# Eval("VarietyInterest") %></td>
                            <td><%# Eval("dt_Exchange") %></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>

                <!--底部模板-->
                </table>
                <!--表格结束部分-->
            </FooterTemplate>
                </asp:Repeater>              
            </div>
            </div>
        <input type="hidden" id="colorName" value="" />
    </form>
</body>
</html>
