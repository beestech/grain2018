<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="storageCombine.aspx.cs" Inherits="Web.User.Storage.storageCombine" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <script src="../../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="../../Scripts/WebInner.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" /> 
    <script src="../../Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>    
    <script src="../../Scripts/excelhelper.js" type="text/javascript"></script>
    <title></title>
    <style>
        .hf { display:none;
        }
        .auto-style1 {
            width: 100px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
          <div class="pageHead">
            <b>储户存粮合并</b>
        </div>
    <div>
      <div class="QueryHead">
            <table>
                <tr>
                    <td><span>储户账号:</span>
                    </td>
                    <td>
                        <input type="text" id="txtAC"  style="font-size: 16px; width: 100px;height:26px; font-weight: bolder;" runat="server" />
                   </td>
                    <td><span>密码:</span>
                    </td>
                    <td>
                        <input type="password" id="txtPwd"  style="font-size: 16px; width: 100px; font-weight: bolder;" runat="server" />                       
                    </td>
                    <td style="width: 60px">
                        <asp:ImageButton ID="ImageButton1" runat="server"
                            ImageUrl="~/images/search_red.png" OnClick="ImageButton1_Click" />
                    </td>                                       
                </tr>
            </table>
        </div>
        <p style="color:red">
            注:合并储户存粮条件》只能选择两条数据进行合并且选择的两条数据存贷产品、存储等级、存期要相同才能进行合并。
        </p>
        <table class="tabData" id="dataInfo">
            <thead>
                <tr class="tr_head">  
                    <th style="width: 100px; height: 20px; text-align: center;">选择合并</th>                    
                    <th style="width: 100px; text-align: center;">储户账号</th>
                    <th style="text-align: center;" class="auto-style1">存贷产品</th>
                    <th style="width: 100px; text-align: center;">结存数量KG</th>
                    <th style="width: 100px; text-align: center;">存储日期</th>
                    <th style="width: 100px; text-align: center;">存储等级</th>
                    <th style="width: 100px; text-align: center;">存期</th>
                    <th style="width: 100px; text-align: center;">存入价</th>
                </tr>
            </thead>
            <tbody>
                 <asp:Repeater runat="server" ID="repeater1">
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
                        <td style="height: 30px;">
                            <asp:CheckBox ID="selectHB" ToolTip='<%#Eval("ID") %>' Text="" runat="server"/>
                        </td>
                        <td><%# Eval("AccountNumber") %></td>
                        <td><%# Eval("VarietyName") %></td>
                        <td><%# Eval("StorageNumber") %></td>
                        <td><%# Eval("StorageDate") %></td>
                        <td><%# Eval("LevelName") %></td>
                        <td><%# Eval("TimeName") %></td>
                        <td ><%# Eval("Price_ShiChang") %></td>
                    </tr>
                </ItemTemplate> 
            </asp:Repeater>        
            </tbody>
            <tfoot>
                <tr>
                    <td><asp:Button Text="合并" runat="server" ID="btnHeBing"  OnClick="btnHeBing_Click" /></td>
                    <td colspan="7"></td>
                </tr>
            </tfoot>
        </table>
        
        <div id="divfrm" class="pageEidt" style="display: none ; ">
            <img class="imgclose" src="../../images/winClose.png" alt="关闭窗口" style="float: right; cursor: pointer;" onclick="CloseFrm()" />
            <div style="clear: both;">
                 <table class="tabEdit" style="margin: 10px;">                               
                 <asp:Repeater runat="server" ID="repeater2" OnItemDataBound="repeater2_ItemDataBound">
                     <HeaderTemplate>
                         <tr class="tr_head">                                                  
                            <th style="width: 100px; height: 20px; text-align: center;">存贷产品</th>
                            <th style="width: 100px; text-align: center;">结存数量KG</th>
                            <th style="width: 100px; text-align: center;">存储日期</th>
                            <th style="width: 100px; text-align: center;">存储等级</th>
                            <th style="width: 100px; text-align: center;">存期</th>
                            <th style="width: 100px; text-align: center;">存入价</th>
                         </tr>
                     </HeaderTemplate>
                <ItemTemplate>
                    <tr onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">                        
                       
                        <td style="text-align: center;"><%# Eval("VarietyName") %>
                            <asp:CheckBox  ToolTip='<%# Eval("ID") %>' ID="lblID" CssClass="hf" runat="server" />
                        </td>
                        <td style="text-align: center;"><%# Eval("StorageNumber") %></td>
                        <td style="text-align: center;"><%# Eval("StorageDate") %></td>
                        <td style="text-align: center;"><%# Eval("LevelName") %></td>
                        <td style="text-align: center;"><%# Eval("TimeName") %></td>
                        <td style="text-align: center;"><%# Eval("Price_ShiChang") %></td>
                    </tr>
                </ItemTemplate>
                  
            </asp:Repeater>        
               <tr>
                             <td>  <span style="color: darkslateblue;">合并存粮数:</span></td>
                             <td>
                                  <span style="color: green; text-align:center"><asp:Label ID="lblSum" runat="server" /></span></td>
                            <td colspan="4"></td>
                         </tr>
                </table>
                <table style="margin: 10px 0px 0px 100px">                   
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button Text="确认合并" ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
         <div style="display: none;">          
            <%--定义背景色的隐藏域--%>
            <input type="hidden" id="colorName" value="" />
        </div>
    </form>
</body>
</html>
