<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="businessStatisticsDetail.aspx.cs" Inherits="Web.User.Query.businessStatisticsDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <script src="../../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="../../Scripts/WebInner.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="pageHead">
            <a href="#" onclick="javascript :history.back(-1);"><img src="../../images/icon-back.png" /></a>
            <b>储户基本信息查询</b><%--<span id="spanHelp" style="cursor: pointer">帮助</span>--%>
        </div>
        <div id="divHelp" style="border: 1px solid #333; border-radius: 5px; display: none;">
            <span>提示1：</span><br />
            <span>提示2：</span><br />
            <span>提示3：</span><br />
        </div>
         <div class="QueryHead">
            <table>
                <tr>
                    <td> <span>存储种类:</span></td>
                    <td><span>
                        <asp:DropDownList runat="server" ID="ddlVariety">                            
                        </asp:DropDownList>
                    
                    </span></td>
                    <td style="width: 60px">
                         <asp:ImageButton ID="ImageButton1" ImageUrl="~/images/search_red.png"
                runat="server" OnClick="ImageButton1_Click"/>
                    </td>
                </tr>

            </table>
        </div>
        <!--储户基本信息-->
        <div id="depositorInfo" runat="server" style="display: none;margin: 10px 0px;">
            <table class="tabData" style=" max-width: 750px;">
                <thead>

                    <tr>
                        <td colspan="6">基本信息
                        </td>
                    </tr>
                </thead>
                <tr class="tr_head">
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
        <!--存储信息-->
         <div id="StorageList" runat="server" style="display: none;margin: 10px 0px;">
            <asp:Repeater ID="Repeater1" runat="server">
                <HeaderTemplate>
                    <table class="tabData" style="width: 750px;">
                        <thead>
                            <tr>
                                <td colspan="8" align="center">存储信息</td>
                            </tr>
                        </thead>

                        <tr class="tr_head">
                            <th style="width: 120px; height: 20px; text-align: center;">存贷产品
                            </th>
                            <th style="width: 80px; text-align: center;">结存数量
                            </th>
                            <th style="width: 100px; text-align: center;">存入时间
                            </th>
                            <th style="width: 80px; text-align: center;">存入价
                            </th>
                            <th style="width: 80px; text-align: center;">存期
                            </th>
                            <th style="width: 80px; text-align: center;">天数
                            </th>
                            <th style="width: 80px; text-align: center;">活期利率
                            </th>
                            <th style="width: 120px; text-align: center;">利息
                            </th>

                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 25px;">
                            <%#Eval("VarietyID")%>
                        </td>
                        <td>
                            <%#Eval("StorageNumber")%>
                        </td>
                        <td>
                            <%#Eval("StorageDate")%>
                        </td>
                        <td>
                            <%#Eval("Price_ShiChang")%>
                        </td>
                        <td>
                            <%#Eval("TimeID")%>
                        </td>
                        <td>
                            <%#GetDay(Eval("StorageDate"))%>
                        </td>
                        <td>
                            <%#Eval("CurrentRate")%>
                        </td>
                        <td>
                            <%#Eval("strLixi")%>
                        </td>

                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    <tr>
                        <td colspan="2">
                            <span style="font-weight: bolder">折合现金合计:</span>
                        </td>
                        <td colspan="6" style="text-align: center">
                            <span id="spanTotal" runat="server" style="color: Red; font-size: 16px">￥<%=numTotol %></span>

                        </td>
                    </tr>
                    <!--底部模板-->
                    </table>
                <!--表格结束部分-->
                </FooterTemplate>
            </asp:Repeater>
        </div>
         <!--修改记录-->
        <div id="sv_updateStorage" runat="server" style="display: none;margin: 10px 0px;">
            <asp:Repeater ID="r_updateStorage" runat="server">
                <HeaderTemplate>
                    <table class="tabData" style="max-width:750px;">
                        <thead>
                            <tr>
                                <td colspan="8" align="center">储户存粮修改信息</td>
                            </tr>
                        </thead>

                        <tr class="tr_head">
                            <th style="width: 100px; height: 20px; text-align: center;">储户账号
                            </th>
                            <th style="width: 100px; text-align: center;">产品名称
                            </th>                            
                            <th style="width: 100px; text-align: center;">存入数量
                            </th>
                            <th style="width: 100px; text-align: center;">修改数量
                            </th>
                            <th style="width: 100px; text-align: center;">结存
                            </th>
                            <th style="width: 100px; text-align: center;">操作人</th>
                            <th style="width: 100px; text-align: center;">网点</th>
                            <th style="width: 100px; text-align: center;">日期</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 25px;">
                            <%#Eval("AccountNumber")%>
                        </td>
                        <td>
                            <%#Eval("VarietyName")%>
                        </td>
                        <td>
                            <%#Eval("StorageNumberRaw")%>
                        </td>
                        <td>
                            <%#Eval("StorageNumberChange")%>
                        </td>
                        <td>
                            <%#Eval("StorageNumber")%>
                        </td>
                        <td>
                            <%#Eval("strLoginName")%>
                        </td>
                        <td>
                            <%#Eval("strName")%>
                        </td>
                        <td>
                            <%# Convert.ToDateTime(Eval("createDate")).ToShortDateString()%>
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
        <!--退还记录-->
        <div id="sv_returnStorage" runat="server" style="display: none;margin: 10px 0px;">
            <asp:Repeater ID="R_ReturnStorage" runat="server">
                <HeaderTemplate>
                    <table class="tabData" style="max-width:750px;">
                        <thead>
                            <tr>
                                <td colspan="7" align="center">储户存粮退还信息</td>
                            </tr>
                        </thead>

                        <tr class="tr_head">
                            <th style="width: 100px; height: 20px; text-align: center;">储户账号
                            </th>
                            <th style="width: 100px; text-align: center;">产品名称
                            </th>                            
                            <th style="width: 100px; text-align: center;">存入数量
                            </th>
                            <th style="width: 100px; text-align: center;">退还数量
                            </th>
                            <th style="width: 100px; text-align: center;">结存数量
                            </th>
                            </th>
                            <th style="width: 100px; text-align: center;">操作人</th>
                            <th style="width: 100px; text-align: center;">网点</th>
                            <th style="width: 100px; text-align: center;">日期</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 25px;">
                            <%#Eval("AccountNumber")%>
                        </td>
                        <td>
                            <%#Eval("VarietyName")%>
                        </td>
                        <td>
                            <%#Eval("StorageNumberRaw")%>
                        </td>
                        <td>
                            <%#Eval("returnNumber")%>
                        </td>
                        <td>
                            <%#Eval("StorageNumber")%>
                        </td>
                        <td>
                            <%#Eval("strLoginName")%>
                        </td>
                        <td>
                            <%#Eval("strName")%>
                        </td>
                        <td>
                            <%# Convert.ToDateTime(Eval("createDate")).ToShortDateString()%>
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
        <!--兑换-->
        <div id="exchangeList" runat="server" style="display: none;margin: 10px 0px;">
            <asp:Repeater ID="R_exchange" runat="server">
                <HeaderTemplate>
                    <table class="tabData"  style="max-width:750px;">
                        <thead>
                            <tr>
                                <td colspan="9" align="center">兑换信息</td>
                            </tr>
                        </thead>

                        <tr class="tr_head">
                            <th style="width: 100px; height: 20px; text-align: center;">业务名称
                            </th>
                            <th style="width: 150px; text-align: center;">产品名称
                            </th>
                            <th style="width: 100px; text-align: center;">产品数量
                            </th>
                            <th style="width: 100px; text-align: center;">商品名称
                            </th>
                            <th style="width: 100px; text-align: center;">商品价格
                            </th>
                            <th style="width: 100px; text-align: center;">商品数量
                            </th>
                            <th style="width: 100px; text-align: center;">利息
                            </th>
                            <th style="width: 100px; text-align: center;">金额
                            </th>
                            <th style="width: 100px; text-align: center;">日期
                            </th>

                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 25px;">
                            <%#Eval("BusinessName")%>
                        </td>
                        <td>
                            <%#Eval("strName")%>
                        </td>
                        <td>
                            <%#Eval("VarietyCount")%>
                        </td>
                        <td>
                            <%#Eval("GoodName")%>
                        </td>
                        <td>
                            <%#Eval("GoodPrice")%>
                        </td>
                        <td>
                            <%#Eval("GoodCount")%>
                        </td>
                        <td>
                            <%#Eval("VarietyInterest")%>
                        </td>
                        <td>
                            <%#Eval("Money_DuiHuan")%>
                        </td>
                        <td>
                            <%# Convert.ToDateTime(Eval("dt_Exchange")).ToShortDateString()%>
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
        <!--分时批量兑换-->
        <div id="goodExchangeGroup" runat="server" style="display: none;margin: 10px 0px;">
            <asp:Repeater ID="R_goodExchangeGroup" runat="server">
                <HeaderTemplate>
                    <table class="tabData"  style="max-width:750px;">
                        <thead>
                            <tr>
                                <td colspan="9" align="center">分时批量兑换信息</td>
                            </tr>
                        </thead>

                        <tr class="tr_head">
                            <th style="width: 100px; height: 20px; text-align: center;">业务名称
                            </th>
                            <th style="width: 150px; text-align: center;">产品名称
                            </th>
                            <th style="width: 100px; text-align: center;">产品数量
                            </th>
                            <th style="width: 100px; text-align: center;">商品名称
                            </th>
                            <th style="width: 100px; text-align: center;">商品价格
                            </th>
                            <th style="width: 100px; text-align: center;">商品数量
                            </th>
                            <th style="width: 100px; text-align: center;">利息
                            </th>
                            <th style="width: 100px; text-align: center;">金额
                            </th>
                            <th style="width: 100px; text-align: center;">日期
                            </th>

                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 25px;">
                            <%#Eval("BusinessName")%>
                        </td>
                        <td>
                            <%#Eval("strName")%>
                        </td>
                        <td>
                            <%#Eval("VarietyCount")%>
                        </td>
                        <td>
                            <%#Eval("GoodName")%>
                        </td>
                        <td>
                            <%#Eval("GoodPrice")%>
                        </td>
                        <td>
                            <%#Eval("GoodCount")%>
                        </td>
                        <td>
                            <%#Eval("VarietyInterest")%>
                        </td>
                        <td>
                            <%#Eval("Money_DuiHuan")%>
                        </td>
                        <td>
                            <%# Convert.ToDateTime(Eval("dt_Exchange")).ToShortDateString()%>
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
        <!--存转销-->
         <div id="SellList" runat="server" style="display: none;margin: 10px 0px;">
            <asp:Repeater ID="R_Sell" runat="server">
                <HeaderTemplate>
                    <table class="tabData" style="max-width:750px;">
                        <thead>
                            <tr>
                                <td colspan="8" align="center">存转销信息</td>
                            </tr>
                        </thead>

                        <tr class="tr_head">
                            <th style="width: 100px; height: 20px; text-align: center;">业务名称
                            </th>
                            <th style="width: 100px; text-align: center;">产品名称
                            </th>
                            <th style="width: 150px; text-align: center;">产品数量
                            </th>
                            <th style="width: 100px; text-align: center;">存储天数
                            </th>
                            <th style="width: 100px; text-align: center;">利息
                            </th>
                            <th style="width: 100px; text-align: center;">保管费
                            </th>
                            <th style="width: 100px; text-align: center;">金额</th>
                            <th style="width: 100px; text-align: center;">日期</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 25px;">
                            <%#Eval("BusinessName")%>
                        </td>
                        <td>
                            <%#Eval("VarietyName")%>
                        </td>
                        <td>
                            <%#Eval("VarietyCount")%>
                        </td>
                        <td>
                            <%#Eval("StorageDate")%>
                        </td>
                        <td>
                            <%#Eval("VarietyInterest")%>
                        </td>
                        <td>
                            <%#Eval("StorageMoney")%>
                        </td>
                        <td>
                            <%#Eval("VarietyMoney")%>
                        </td>
                        <td>
                            <%#  Convert.ToDateTime(Eval("dt_Sell")).ToShortDateString()%>
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
        <!--换购信息-->
         <div id="ShoppingList" runat="server" style="display: none;margin: 10px 0px;">
            <asp:Repeater ID="R_Shopping" runat="server">
                <HeaderTemplate>
                    <table class="tabData" style="max-width:750px;">
                        <thead>
                            <tr>
                                <td colspan="7" align="center">换购信息</td>
                            </tr>
                        </thead>

                        <tr class="tr_head">
                            <th style="width: 100px; height: 20px; text-align: center;">业务名称
                            </th>
                            <th style="width: 100px; text-align: center;">产品名称
                            </th>
                            <th style="width: 150px; text-align: center;">产品数量
                            </th>
                            <th style="width: 100px; text-align: center;">存储天数
                            </th>
                            <th style="width: 100px; text-align: center;">利息
                            </th>
                            <th style="width: 100px; text-align: center;">金额
                            </th>
                            <th style="width: 100px; text-align: center;">日期</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 25px;">
                            <%#Eval("BusinessName")%>
                        </td>
                        <td>
                            <%#Eval("VarietyName")%>
                        </td>
                        <td>
                            <%#Eval("VarietyCount")%>
                        </td>
                        <td>
                            <%#Eval("StorageDate")%>
                        </td>
                        <td>
                            <%#Eval("VarietyInterest")%>
                        </td>
                        <td>
                            <%#Eval("VarietyMoney")%>
                        </td>
                        <td>
                            <%# Convert.ToDateTime(Eval("dt_Sell")).ToShortDateString()%>
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
