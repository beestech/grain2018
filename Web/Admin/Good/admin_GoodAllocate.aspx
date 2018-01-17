<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin_GoodAllocate.aspx.cs" Inherits="Web.Admin.Good.admin_GoodAllocate" %>

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
            <b>调货记录</b>
        </div>

        <div class="QueryHead">
            <table>
                <tr>
                    <td><span>调货网点:</span>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddldiaohuo" runat="server" Width="100px" Height="30px" >
                            
                        </asp:DropDownList>
                       <%-- <input type="text" id="txtWBID" onkeyup="InitWBID();" style="font-size: 16px; width: 100px; height: 26px; font-weight: bolder;" runat="server" />--%>
                        </td>
                    <td><span>接收网点:</span></td>
                    <td>
                        <asp:DropDownList ID="ddljieshou" runat="server" Width="100px" Height="30px">
                            </asp:DropDownList>
                    </td>
                    <td><span>日期:</span>
                    </td>
                    <td>
                        <input type="text" id="Qdtstart" readonly="readonly" onclick="WdatePicker();" style="font-size: 16px; width: 100px; font-weight: bolder;" runat="server" />
                        <span>-</span>
                        <input type="text" id="Qdtend" readonly="readonly" onclick="WdatePicker()" style="font-size: 16px; width: 100px; font-weight: bolder;" runat="server" />
                    </td>
                     <td><span>商品名称:</span></td>
                    <td>
                        <input type="text" id="txtstrName" style="width:100px;" runat="server" />
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
                        <th style="min-width: 100px; height: 20px; text-align: center;">调货网点
                        </th>
                        <th style="min-width: 100px; text-align: center;">接收网点
                        </th>
                         <th style="min-width: 100px; height: 20px; text-align: center;">调货仓库
                        </th>
                        <th style="min-width: 100px; text-align: center;">接收仓库
                        </th>
                        <th style="min-width: 100px; text-align: center;">商品
                        </th>
                        <th style="min-width: 100px; text-align: center;">数量
                        </th>
                        <th style="min-width: 100px; text-align: center;">价格
                        </th>
                        <th style="min-width: 100px; text-align: center;">时间
                        </th>
                        <th style="min-width: 100px; text-align: center;">操作人
                        </th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr 
                    onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                    <td style="height:25px">
                        <%#Eval("diaohuo")%>
                    </td>
                    <td>
                        <%#Eval("jieshou")%>
                    </td>
                     <td>
                        <%#Eval("diaohuoCK")%>
                    </td>
                    <td>
                        <%#Eval("jieshouCK")%>
                    </td>
                    <td>
                        <%#Eval("goodName")%>
                    </td>
                    <td>
                        <%#Eval("Quantity")%>
                    </td>
                     <td>
                        <%#Eval("Price_Stock")%>
                    </td>
                     <td>
                        <%#Convert.ToDateTime(Eval("dt_Trade")).ToShortDateString()%>
                    </td>
                     <td>
                        <%#Eval("UserName")%>
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
