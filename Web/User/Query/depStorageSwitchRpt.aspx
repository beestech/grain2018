<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="depStorageSwitchRpt.aspx.cs" Inherits="Web.User.Query.depStorageSwitchRpt" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="../../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="../../Scripts/WebInner.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    
   
    <script src="../../Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
     <div class="pageHead">
            <b>预存转实存记录统计</b>
        </div>

        <div class="QueryHead">
            <table>
                <tr>
                    <td><span>网点:</span>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlWB" runat="server" Width="100px" Height="30px" >
                            
                        </asp:DropDownList>
                       <%-- <input type="text" id="txtWBID" onkeyup="InitWBID();" style="font-size: 16px; width: 100px; height: 26px; font-weight: bolder;" runat="server" />--%>
                        </td>
                    <td><span>储户账号:</span></td>
                    <td>
                        <input type="text" id="txtAccountNumber" style="width:100px;" runat="server" />
                    </td>
                    <td><span>预存日期:</span>
                    </td>
                    <td>
                        <input type="text" id="Qdtstart" readonly="readonly" onclick="WdatePicker();" style="font-size: 16px; width: 100px; font-weight: bolder;" runat="server" />
                        <span>-</span>
                        <input type="text" id="Qdtend" readonly="readonly" onclick="WdatePicker()" style="font-size: 16px; width: 100px; font-weight: bolder;" runat="server" />
                    </td>
                     <td><span>是否转实存?</span></td>
                    <td>
                        <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ID="rblIsSwitch">
                            <asp:ListItem Text="是" Value="1" />
                            <asp:ListItem Text="否" Value="0" />
                            <asp:ListItem Text="全部" Value="2" />
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 60px">
                        <asp:ImageButton ID="ImageButton1" runat="server"
                            ImageUrl="~/images/search_red.png" OnClick="ImageButton1_Click" />
                    </td>
                 <%--   <td>
                        <asp:Button ID="btnOutPut" runat="server" class="outputExcel" Width="50px" Text="Excel"/>
                    </td>--%>
                </tr>
            </table>
        </div>

        <asp:Repeater ID="Repeater1" runat="server">
            <HeaderTemplate>
                <table class="tabData">
                    <tr class="tr_head">
                        <th style="min-width: 100px; height: 20px; text-align: center;">储户姓名
                        </th>
                        <th style="min-width: 100px; text-align: center;">储户账号
                        </th>
                         <th style="min-width: 100px; height: 20px; text-align: center;">网点
                        </th>
                        <th style="min-width: 100px; text-align: center;">存储产品
                        </th>
                        <th style="min-width: 100px; text-align: center;">预存数量
                        </th>
                        <th style="min-width: 100px; text-align: center;">转存数量
                        </th>
                        <th style="min-width: 100px; text-align: center;">预存日期
                        </th>
                        <th style="min-width: 100px; text-align: center;">转存日期
                        </th>
                        <th style="min-width: 100px; text-align: center;">是否已转存
                        </th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr 
                    onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                    <td style="height:25px">
                        <%#Eval("DepositorName")%>
                    </td>
                    <td>
                        <%#Eval("AccountNumber")%>
                    </td>
                     <td>
                        <%#Eval("wbName")%>
                    </td>
                    <td>
                        <%#Eval("vName")%>
                    </td>
                    <td>
                        <%#Eval("StorageNumberRaw")%>
                    </td>
                    <td>
                        <%#Eval("StorageNumberSwitch")%>
                    </td>
                     <td>
                     <%#Convert.ToDateTime(Eval("StorageDate")).ToShortDateString()%>
                    </td>
                     <td>
                        <%#Eval("SwitchDate")%>
                    </td>
                     <td>
                        <%#Eval("ISSwitch")%>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>

                <!--底部模板-->
                </table>
                <!--表格结束部分-->
            </FooterTemplate>
        </asp:Repeater>     
        <input type="hidden" id="colorName" value="" />
    </form>
</body>
</html>
