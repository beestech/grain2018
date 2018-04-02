<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="businessStatistics.aspx.cs" Inherits="Web.User.Query.businessStatistics" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <script src="../../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="../../Scripts/WebInner.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" /> 
    <script src="../../Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <title></title>
    <script>
        $(function () {
            var wbinfo = JSON.parse(localStorage.getItem('wbinfo'));
            var ISHQ = wbinfo[0].ISHQ;
            if (!ISHQ) {
               //hide网点
                $('.tdWd').hide();
            } else {
                //显示网点
                $('.tdWd').show();
            }
        });
    </script>
</head>
<body>
       <div id="divPrint" style="display: none">
    </div>
    <div id="divPrintPaper" style="display: none">
    </div>
    <form id="form1" runat="server">
        <div class="pageHead">
            <b>储户业务统计</b>
        </div>
        <div class="QueryHead">
            <table>
                <tr>
                    <td class="tdWd"><span>网点:</span></td>
                    <td class="tdWd">
                        <asp:DropDownList ID="ddlWd" runat="server" Width="120px" Height="30px" >
                            
                        </asp:DropDownList>
                        
                    </td>
                    <td><span>存粮种类:</span></td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlName"  Width="120px" Height="30px">                            
                        </asp:DropDownList>
<%--                        <input type="text" id="Text1" style="font-size: 16px; width: 120px;height:26px; font-weight: bolder;" runat="server" />--%>
                    </td>
                    <td><span>储户账号:</span></td>
                    <td>
                        <input type="text" id="QAccountNumber" style="font-size: 16px; width: 120px;height:26px; font-weight: bolder;" runat="server" />
                    </td>
                  <%--  <td><span>日期:</span></td>
                    <td>
                        <input type="text" id="Qdtstart" onclick="WdatePicker();" style="font-size: 16px; width: 100px;height:26px; font-weight: bolder;" runat="server" />
                        <span>-</span>
                        <input type="text" id="Qdtend" onclick="WdatePicker()" style="font-size: 16px; width: 100px;height:26px; font-weight: bolder;" runat="server" />
                    </td>--%>

                    <td>
                        <asp:ImageButton ID="ImageButton1" ImageUrl="~/images/search_red.png"
                            runat="server" OnClick="ImageButton1_Click" /></td>

                </tr>

            </table>
        </div>

        <div id="depositorInfo" runat="server" style="display: none;">
            <table class="tabData" style="margin: 10px 0px;">
                <tr>
                    <td colspan="6" style="border-bottom: 1px solid #aaa; height: 25px; text-align: center">
                        <span style="font-size: 16px; font-weight: bolder; color: Green">储户基本信息</span>
                    </td>
                </tr>
                <tr>
                    <th align="center" style="width: 100px; height: 30px;">储户账号
                    </th>
                    <th align="center" style="width: 100px;">储户姓名
                    </th>
                    <th align="center" style="width: 100px;">移动电话
                    </th>
                    <th align="center" style="width: 100px;">当前状态
                    </th>
                    <th align="center" style="width: 150px;">身份证号
                    </th>
                    <th align="center" style="width: 200px;">储户地址
                    </th>

                </tr>
                <tr>

                    <td style="height: 30px;">
                        <span style="font-weight: bolder; color: Blue;" id="D_AccountNumber" runat="server"></span>
                    </td>

                    <td>
                        <span style="font-weight: bolder; color: Blue;" id="D_strName" runat="server"></span>
                    </td>
                    <td>
                        <span style="font-weight: bolder; color: Blue;" id="D_PhoneNo" runat="server"></span>
                    </td>
                    <td>
                        <span style="font-weight: bolder; color: Blue;" id="D_numState" runat="server"></span>
                    </td>
                    <td>
                        <span style="font-weight: bolder; color: Blue;" id="D_IDCard" runat="server"></span>
                    </td>
                    <td>
                        <span style="font-weight: bolder; color: Blue;" id="D_strAddress" runat="server"></span>
                    </td>
                </tr>
            </table>
        </div>

        <div id="StorageList" style="margin: 10px 0px">
            <asp:Repeater ID="Repeater1" runat="server">
                <HeaderTemplate>
                    <table class="tabData">
                        <tr class="tr_head">
                            <th style="width: 100px; height: 20px; text-align: center;">储户姓名
                            </th>
                            <th style="width: 100px; text-align: center;">储户账号
                            </th>
                            <th style="width: 120px; text-align: center;">存储产品
                            </th>
                            <th style="width: 60px; text-align: center;">始存数量
                            </th>
                            <th style="width: 60px; text-align: center;">兑换
                            </th>
                            <th style="width: 60px; text-align: center;">存转销
                            </th>
                            <th style="width: 80px; text-align: center;">产品换购
                            </th>
                            <th style="width: 80px; text-align: center;">修改存粮数
                            </th>
                            <th style="width: 80px; text-align: center;">退还存粮数
                            </th>
                            <th style="width: 100px; text-align: center;">结余
                            </th>
                            <th>操作</th>                            
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr 
                        onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 25px;">

                            <%#Eval("DepName")%>
                        </td>
                        <td>
                            <%#Eval("Dep_AccountNumber ")%>

                        </td>
                        <td>
                            <%#Eval("VarietyName")%>
                        </td>
                        <td>
                            <%# Eval("StorageNumberRaw") %>
                        </td>
                        <td>
                            <%# Eval("ExhcangeNumberTotal") %>
                        </td>
                        <td>
                            <%#(Eval("StorageSellCount"))%>
                        </td>                        
                        <td>
                            <%#(Eval("StorageShoppingCount"))%>
                        </td>
                        <td>
                            <%#(Eval("VarietyCount_error"))%>
                        </td>
                        <td>
                            <%#(Eval("VarietyCount_return"))%>
                        </td>
                        <td>
                            <%#(Eval("StorageNumber"))%>
                        </td>
                        <td>
                            <a href='businessStatisticsDetail.aspx?account=<%# Eval("Dep_AccountNumber") %>&vId=<%# Eval("VarietyID") %>'>详细</a>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>

                    <!--底部模板-->
                    </table>
                <!--表格结束部分-->
                </FooterTemplate>
            </asp:Repeater>

        </div>

        <div style="display: none;">
            <%--选择兑换的存储产品信息--%>
            <input type="text" name="txtDep_SID" value="" />
            <%--定义编号--%>
            <input type="hidden" id="WBID" value="" />
            <%--定义背景色的隐藏域--%>
            <input type="hidden" id="colorName" value="" />
        </div>
    </form>
</body>
</html>
