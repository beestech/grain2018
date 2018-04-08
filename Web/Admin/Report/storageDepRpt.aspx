<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="storageDepRpt.aspx.cs" Inherits="Web.Admin.Report.storageDepRpt" %>

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
</head>
<body>
    <form id="form1" runat="server">
    <div class="pageHead">
            <b>月度结存统计</b>
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
                    <td><span>年份:</span></td>
                    <td>
                        <asp:DropDownList runat="server"  Width="120px" Height="30px" ID="ddlYear">                            
                        </asp:DropDownList>
                    </td>
                    <td><span>月份:</span></td>
                    <td>
                        <select runat="server" style="width:100px; height:30px" id="select_month">
                            <option value="1">1月</option>
                            <option value="2">2月</option>
                            <option value="3">3月</option>
                            <option value="4">4月</option>
                            <option value="5">5月</option>
                            <option value="6">6月</option>
                            <option value="7">7月</option>
                            <option value="8">8月</option>
                            <option value="9">9月</option>
                            <option value="10">10月</option>
                            <option value="11">11月</option>
                            <option value="12">12月</option>
                        </select>
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
        <div>
             <asp:Repeater ID="Repeater1" runat="server" OnItemDataBound="Repeater1_ItemDataBound">
                <HeaderTemplate>
                    <table class="tabData">
                        <tr class="tr_head">
                            <th style="width: 200px; height: 20px; text-align: center;">网点
                            </th>
                            <th style="width: 100px; text-align: center;">存贷产品
                            </th>
                            <th style="width: 100px; text-align: center;">存期
                            </th>
                            <th style="width: 100px; text-align: center;">结存数量
                            </th>
                            <th style="width: 100px; text-align: center;">单位
                            </th>
                            <th style="width: 100px; text-align: center;">￥价格
                            </th>
                            <th style="width: 100px; text-align: center;">￥金额合计
                            </th>
                           
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr 
                        onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 30px;">

                            <%#Eval("WBName")%>
                        </td>
                        <td>
                            <%#Eval("VarietyName ")%>

                        </td>
                        <td>
                            <%#Eval("TimeName")%>
                        </td>
                        <td>
                            <asp:Label Text='<%# getDepStorageNum(Eval("StorageNumber").ToString(),Eval("WBID").ToString(),Eval("VarietyID").ToString(),ddlYear.SelectedValue,select_month.Value) %>' ID="lblNumber" runat="server" />
                            
                        </td>
                        <td>
                            公斤
                        </td>
                        <td>
                            <%# Eval("Price_ShiChang") %>
                        </td>
                        <td>
                            <asp:Label Text='<%#  Calculate(Eval("Price_ShiChang").ToString(),Eval("StorageNumber").ToString(),Eval("WBID").ToString(),Eval("VarietyID").ToString(),ddlYear.SelectedValue,select_month.Value)%>' ID="lblMoney" runat="server" />
                            
                        </td>                        
                                       
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        <tr>
                            <td  style="height: 30px; color:green; font-weight:bold">合计</td>
                            <td></td>
                            <td></td>
                            <td>
                                <asp:Label ID="lblTotalNumber" runat="server" /></td>
                            <td></td>
                            <td></td>
                            <td>
                                <asp:Label ID="lblTotalMoney" runat="server" /></td>
                        </tr>
                    <!--底部模板-->
                    </table>
                <!--表格结束部分-->
                </FooterTemplate>
            </asp:Repeater>

        </div>

        <input type="hidden" id="colorName" value="" />
    </form>
</body>
</html>
