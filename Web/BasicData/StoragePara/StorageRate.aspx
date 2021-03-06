﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StorageRate.aspx.cs" Inherits="Web.BasicData.StoragePara.StorageRate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="../../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="../../Styles/Common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <script src="../../Scripts/WebInner.js" type="text/javascript"></script>
    
   
    <style type="text/css">
        .spanwarning {
            font-size: 12px;
            color: red;
        }
        .spanwarning_choose {
            font-size: 12px;
            color: red;
        }
    </style>
    <script type="text/javascript">
       /*--------窗体启动设置和基本设置--------*/

        $(function () {
            InitTypeID(); //加载储户类型
            InitVarietyID();//加载存储期限类型
            $('select[name=TypeID]').change(function () {
                InitTimeID($('select[name=TypeID] option:selected').val());
            });
            $('select[name=TimeID]').change(function () {
                select_timeinfo();
            });

            $('select[name=VarietyID]').change(function () {
                //根据存储类型加载存储期限
                InitVarietyLevelID($('select[name=VarietyID] option:selected').val());
                //显示更新产品类型
                $('#bVarietyID1').html($('select[name=VarietyID] option:selected').text());
                $('#bVarietyID2').html($('select[name=VarietyID] option:selected').text());
                //加载存储产品的计量单位 
                InitVarietyUnit($('select[name=VarietyID] option:selected').val());
            });
        });

        function select_timeinfo() {
            var InterestType = $('select[name=TimeID] option:selected').attr('InterestType');
            var PricePolicy = $('select[name=TimeID] option:selected').attr('PricePolicy');
            var ISRegular = $('select[name=TimeID] option:selected').attr('ISRegular');
            var numStorageDate = $('select[name=TimeID] option:selected').attr('numStorageDate');
            var strspan = '';
            if (ISRegular) {
                strspan += '存储类型:定期;'
                strspan += '最低存储期限' + numStorageDate + '天;'
            } else {
                strspan += '存储类型:活期;'
            }
            strspan += '价格政策:存储不超过' + PricePolicy + '天，存转销时需扣除保管费。';
            $('#span_timeinfo').html(strspan);

            $('.spanwarning_choose').hide();
            $('#tr_EarningRate').hide();
            $('#tr_LossRate').hide();
            if (InterestType == 2) {//分红
                $('#tr_EarningRate').show();
                $('#tr_LossRate').show();
            } else if (InterestType == 3) {//定期
                $('#span_Price_DaoQi').show();
            }
            else if (InterestType == 4) {//入股
                $('#span_Price_HeTong').show();
            }
        }

        //加载储户类型
        function InitTypeID() {
            $.ajax({
                url: '/BasicData/StoragePara/storage.ashx?type=GetStorageUser',
                type: 'post',
                data: '',
                dataType: 'json',
                success: function (r) {
                    $('select[name=TypeID]').empty();
                    for (var i = 0; i < r.length; i++) {
                        $('select[name=TypeID]').append("<option value='" + r[i].ID + "'>" + r[i].strName + "</option>");
                    }
                    //根据存储类型加载存储期限
                    InitTimeID($('select[name=TypeID] option:selected').val());
                }, error: function (r) {
                   showMsg('加载储户类型失败 ！');
                }
            });
        }
        /*加载存储期限
        TypeID: 储户类型，必须
        TimeID：已选择期限类型，非必须
        */
        function InitTimeID(TypeID,TimeID) {
            $('select[name=TimeID]').empty();
            $.ajax({
                url: '/BasicData/StoragePara/storage.ashx?type=GetStorageTimeByTypeID&TypeID='+TypeID,
                type: 'post',
                data: '',
                dataType: 'json',
                success: function (r) {
                   
                    for (var i = 0; i < r.length; i++) {
                        var optionselected = '';
                        if (!isNull(TimeID)) {
                            if (TimeID == r[i].ID) {
                                optionselected = 'selected="selected"';
                            }
                        }
                        $('select[name=TimeID]').append("<option value='" + r[i].ID + "' InterestType='" + r[i].InterestType + "' PricePolicy='" + r[i].PricePolicy + "' ISRegular='" + r[i].ISRegular + "' numStorageDate='" + r[i].numStorageDate + "' " + optionselected + " >" + r[i].strName + "</option>");
                    }
                    select_timeinfo();
                    
                }, error: function (r) {
                   showMsg('该储户类型中不存在存储期限，请设置存储期限后再添加 ！');
                }
            });
        }

       
        //加载存储产品
        function InitVarietyID() {
            $.ajax({
                url: '/BasicData/StoragePara/storage.ashx?type=GetStorageVariety',
                type: 'post',
                data: '',
                dataType: 'json',
                success: function (r) {
                    $('select[name=VarietyID]').empty();
                    for (var i = 0; i < r.length; i++) {
                        $('select[name=VarietyID]').append("<option value='" + r[i].ID + "'>" + r[i].strName + "</option>");
                    }
                    //根据存储类型加载存储期限
                    InitVarietyLevelID($('select[name=VarietyID] option:selected').val());
                    //显示更新产品类型
                    $('#bVarietyID1').html($('select[name=VarietyID] option:selected').text());
                    $('#bVarietyID2').html($('select[name=VarietyID] option:selected').text());
                    //加载存储产品的计量单位 
                    InitVarietyUnit($('select[name=VarietyID] option:selected').val());
                }, error: function (r) {
                   showMsg('加载存储产品失败 ！');
                }
            });
        }
        //加载存储产品的计量单位
        function InitVarietyUnit(VarietyID) {
            $.ajax({
                url: '/BasicData/StoragePara/storage.ashx?type=GetStorageVarietyUnitByID&VarietyID=' + VarietyID,
                type: 'post',
                data: '',
                dataType: 'text',
                success: function (r) {
                 
                    $('#spanCurrentRate').html('元/' + r + '/月');
                    $('#spanPrice_ShiChang').html('元/' + r);
                    $('#spanPrice_XiaoShou').html('元/' + r);
                    $('#spanPrice_DaoQi').html('元/' + r);
                    $('#spanPrice_HeTong').html('元/' + r);
                }, error: function (r) {
                   showMsg('加载该产品的计量单位时出现错误！');
                }
            });
        }
        //加载存储产品的品种等级 
        function InitVarietyLevelID(VarietyID) {
            $('select[name=VarietyLevelID]').empty();
            $.ajax({
                url: '/BasicData/StoragePara/storage.ashx?type=GetStorageLevelByVarietyID&VarietyID=' + VarietyID,
                type: 'post',
                data: '',
                dataType: 'json',
                success: function (r) {
                  
                    for (var i = 0; i < r.length; i++) {
                        $('select[name=VarietyLevelID]').append("<option value='" + r[i].ID + "'>" + r[i].strName + "</option>");
                    }

                }, error: function (r) {
                   showMsg('该产品不存在产品等级，请设置后再添加 ！');
                }
            });
        }
        /*--------End  窗体启动设置和基本设置--------*/


        /*--------自定义div窗口的开启和关闭--------*/

        //显示新增数据窗口
        function ShowFrm_Add(wbid) {
            $('#trAdd').fadeIn("fast");
            $('#trUpdate').fadeOut("fast");

            $("select[name=VarietyID]").get(0).selectedIndex=0;//设置索引为1的项选中
            $("select[name=VarietyLevelID]").get(0).selectedIndex=0;
            $("select[name=VarietyLevelID]").removeAttr("disabled");
            $("select[name=VarietyID]").removeAttr("disabled");
          
            $('input[name=StorageFee]').val('0.000');
            $('input[name=BankRate]').val('0.0000');
            $('input[name=CurrentRate]').val('0.0100');
            $('input[name=Price_ShiChang]').val('2.480');
            $('input[name=Price_DaoQi]').val('2.480');
            $('input[name=Price_HeTong]').val('2.480');
            $('input[name=Price_XiaoShou]').val('2.480');

            InitTypeID();
            $("select[name=TypeID]").removeAttr("disabled");
            $("select[name=TimeID]").removeAttr("disabled");
            //受益和亏损比率
            $('#tr_EarningRate').hide();
            $('#tr_LossRate').hide();
            $('input[name=EarningRate]').val('100');
            $('input[name=LossRate]').val('100');
        }
        //显示更新数据窗口
        function ShowFrm_Update(wbid) {
            $('#trAdd').fadeOut("fast");
            $('#trUpdate').fadeIn("fast");

            /*----数据提交----*/
            $.ajax({
                url: 'storage.ashx?type=GetStorageRateByID&ID=' + wbid,
                type: 'post',
                data: '',
                dataType: 'json',
                success: function (r) {
                   
                    $("select[name=TypeID]  option[value='" + r[0].TypeID + "'] ").attr("selected", 'selected');
                    InitTimeID(r[0].TypeID, r[0].TimeID);//显示存期类型
                    $("select[name=VarietyID]  option[value='" + r[0].VarietyID + "'] ").attr("selected", 'selected');
                    $("select[name=VarietyLevelID]  option[value='" + r[0].VarietyLevelID + "'] ").attr("selected", 'selected');
                  
                   
                    $("select[name=TypeID]").attr("disabled", "disabled");
                    $("select[name=VarietyID]").attr("disabled", "disabled");
                    $("select[name=VarietyLevelID]").attr("disabled", "disabled");
                    $("select[name=TimeID]").attr("disabled", "disabled");

                    $('input[name=StorageFee]').val(r[0].StorageFee);
                    $('input[name=BankRate]').val(r[0].BankRate);
                    $('input[name=CurrentRate]').val(r[0].CurrentRate);
                    $('input[name=EarningRate]').val(r[0].EarningRate);
                    $('input[name=LossRate]').val(r[0].LossRate);
                    $('input[name=Price_ShiChang]').val(r[0].Price_ShiChang);
                    $('input[name=Price_DaoQi]').val(r[0].Price_DaoQi);
                    $('input[name=Price_HeTong]').val(r[0].Price_HeTong);
                    $('input[name=Price_XiaoShou]').val(r[0].Price_XiaoShou);

                }, error: function (r) {
                   showMsg('加载信息失败 ！');
                }
            });
            /*---End 数据提交----*/
        }
         /*--------End 自定义div窗口的开启和关闭--------*/


         /*--------数据增删改操作--------*/
        //新增数据方法
        function FunAdd() {
            if (!SubmitCheck()) {//检测输入内容
                return false;
            }
            var msg = '您确认已经仔细检查输入信息，并继续操作吗？';
            showConfirm(msg, function (obj) {
                if (obj == 'yes') {
                    
                    $.ajax({
                        url: 'storage.ashx?type=AddStorageRate',
                        type: 'post',
                        data: $('#form1').serialize(),
                        dataType: 'text',
                        success: function (r) {
                            if (r == "OK") {
                                showMsg('添加数据成功 ！');
                                CloseFrm();
                                location.reload();
                            } else if (r == "1") {
                                showMsg('已存在相同的类型名称，请修改后添加 ！');
                            }
                        }, error: function (r) {
                            showMsg('添加数据失败 ！');
                        }
                    });
                } else {
                    //console.log('你点击了取消！');
                }

            });
        }
        //更新数据方法
        function FunUpdate() {
            if (!SubmitCheck()) {//检测输入内容
                return false;
            }
          
            var wbid = $('#WBID').val();
            var msg = '您确认已经仔细检查输入信息，并继续操作吗？';
            showConfirm(msg, function (obj) {
                if (obj == 'yes') {
                    
                    $.ajax({
                        url: 'storage.ashx?type=UpdateStorageRate&ID=' + wbid,
                        type: 'post',
                        data: $('#form1').serialize(),
                        dataType: 'text',
                        success: function (r) {
                            if (r == "OK") {
                                showMsg('更新数据成功 ！');
                                CloseFrm();
                                location.reload();
                            } else {
                                showMsg('更新数据失败 ！');
                            }
                        }, error: function (r) {
                            showMsg('更新数据失败 ！');
                        }
                    });
                } else {
                    //console.log('你点击了取消！');
                }

            });
        }

        //删除数据方法
        function FunDelete(wbid) {
            SingleDataDelete('storage.ashx?type=DeleteStorageRateByID&ID=' + wbid);
          
        }
        //提交检测
        function SubmitCheck() {
            if (!CheckSelect('TypeID', '储户类型')) {
                return false;
            }
            if (!CheckSelect('TimeID', '存储期限')) {
                return false;
            }
            if (!CheckSelect('VarietyID', '存储产品')) {
                return false;
            }
            if (!CheckSelect('VarietyLevelID', '产品等级')) {
                return false;
            }

            if (!CheckNumDecimal($('input[name=StorageFee]').val(), '保管费率', 3)) {
                return false;
            }
            if (!CheckNumDecimal($('input[name=CurrentRate]').val(), '活期利率', 4)) {
                return false;
            }
            if (!CheckNumDecimal($('input[name=BankRate]').val(), '银行利率', 4)) {
                return false;
            }
            if (!CheckNumDecimal($('input[name=Price_ShiChang]').val(), '市场价', 3)) {
                return false;
            }
            if (!CheckNumDecimal($('input[name=Price_DaoQi]').val(), '到期价', 3)) {
                return false;
            }
            if (!CheckNumDecimal($('input[name=Price_HeTong]').val(), '合同价', 3)) {
                return false;
            }
            if (!CheckNumDecimal($('input[name=Price_XiaoShou]').val(), '销售价', 3)) {
                return false;
            }
          
            if (!CheckNumInt($('input[name=EarningRate]').val(), '受益比例', 2)) {
                return false;
            }
            if (!CheckNumInt($('input[name=LossRate]').val(), '亏损比例', 2)) {
                return false;
            }

            return true;
        }
         /*--------End 数据增删改操作--------*/
     
    </script>
</head>
<body>
     <form id="form1" runat="server">
<div class="pageHead">
<b>存粮价格与利率管理</b><span id="spanHelp" style="cursor:pointer" >帮助</span>
</div>
<div id="divHelp"  class="pageHelp">
<span>特别提示：这些数据是系统关键数据，要谨慎修改。</span><br />
<span>提示1：有的单位不收保管费，有的单位收取次年保管费（存储满一年后开始收保管费）；不收取保管费的，请将保管费设为0；有的单位支付利息，有的不支付利息，如果有利息，请设置月利息；不支付利息的，请将利息设为0；
</span><br />
<span>提示2：粮食价格国家标准是以三级为标准，程序中也以三级价格为准，这里设置的价格都是三级产品的定价。</span><br />
<span>提示3：VIP兑换与群众兑换类型即活期储户，活期储粮结算时，按单位的活期价格政策执行，可以设定按“存入价+利息”，也可设定按“市场价”结算；群众储粮类型即定期储粮，定期储粮结算时按到期价进行结算，有存期但不到期，经管理员授权后可以按合同约定价进行结算，请根据实际情况进行设置；活期储户的存期中有一类叫分红，分红储粮结算时按市场价结算，储户受益/担损的比例，由存入时协商约定；其它类型储户仅程序计算与企业运营需要，并不储粮。</span><br />
</div>

<div class="QueryHead">
<table>
            <tr>
            <td><b>已有存粮价格与利率列表</b></td>
            
            <td><%=GetAddItem() %></td>
            </tr>
            
        </table>
</div>
<asp:Repeater ID="Repeater1" runat="server">
    <HeaderTemplate>
        <table  class="tabData" >
          <tr class="tr_head" >
                <th style="width:100px; text-align:center;">
                    类型</th>
                    <th style="width:100px; text-align:center;">
                    品种</th>
                    <th style="width:100px; text-align:center;">
                    等级</th>
                    <th style="width:100px; text-align:center;">
                    期限</th>
                    <th style="width:80px; text-align:center;">
                    保管费</th>
                    <th style="width:80px; text-align:center;">
                    活期利率</th>
                    <th style="width:60px; text-align:center;">
                    市场价</th>
                    <th style="width:60px; text-align:center;">
                    到期价</th>
                    <th style="width:60px; text-align:center;">
                    合同价</th>
                    <th style="width:60px; text-align:center;">
                    销售价</th>
                    <th style="width:80px; text-align:center;">
                    受益比例</th>
                
                    <th style="width:100px; text-align:center;">
                    查看/修改</th>
                   <th style="width:80px; text-align:center;">
                    删除</th>
                
            </tr>
        
    </HeaderTemplate>
    <ItemTemplate>
    <tr  onmouseover="change_colorOver(this)" onmouseout="change_colorOut(this)">
        <td><%#Eval("TypeID")%></td>
         <td><%#Eval("VarietyID")%></td>
          <td><%#Eval("VarietyLevelID")%></td>
          <td><%#Eval("TimeID")%></td>
          <td><%#Eval("StorageFee")%></td>
          <td><%#Eval("CurrentRate")%></td>
          <td><%#Eval("Price_ShiChang")%></td>
          <td><%#Eval("Price_DaoQi")%></td>
          <td><%#Eval("Price_HeTong")%></td>
          <td><%#Eval("Price_XiaoShou")%></td>
          <td><%#getEarningRate(Eval("EarningRate"))%></td>
         <td> <%# GetUpdateItem(Eval("ID")) %> </td>
      <td> <%# GetDeleteItem(Eval("ID")) %></td>
   
    </tr>
    </ItemTemplate>
    
    <FooterTemplate><!--底部模板-->
        </table>        <!--表格结束部分-->
        </FooterTemplate>
    </asp:Repeater>
   <div class="divWarning">
   <b>特别提示:</b><span>这是系统关键数据，最好不要添加、修改、删除!</span>
   </div>
    <div  id="divfrm" class="pageEidt" style="display:none; ">
   
    <img class="imgclose" src="../../images/winClose.png" alt="关闭窗口"  style="float:right; cursor:pointer;" onclick="CloseFrm()" /> 
    <div style="clear:both;">
        <table class="tabEdit">
            
            <tr>
            <td align="right" style="width:100px;"><span>储户类型:</span></td>
            <td><select name="TypeID" style="width:100px; " ></select>
            <span>存储期限:</span>
            <select name="TimeID" style="width:100px; " ></select>
            </td>
            </tr>
            <tr>
                <td></td>
            <td><span id="span_timeinfo" style="font-size:12px;color:#666;"></span></td>
            
            </tr>
                        <tr>
             <td align="right"><span>存储产品:</span></td>
            <td><select name="VarietyID" style="width:100px; " ></select>
            <span>品种等级:</span>
            <select name="VarietyLevelID" style="width:100px;" ></select>
            </td>
            </tr>
                 
            <tr>
           <td align="right" ><span>保管费率:</span></td>
            <td><input  name="StorageFee" type="text" style="width:60px;" />%
                <span id="span_PricePolicy" style="font-size:12px; color:#666;"></span>
                <span class="spanwarning">(必填)</span>
            </td>
           
            </tr>
            <tr style="display:none;">
           <td align="right"><span>银行利率:</span></td>
            <td><input name="BankRate" type="text" style="width:100px;"  /></td>
            </tr>
            <tr>
            <td align="right" ><span>活期利率:</span></td>
            <td><input name="CurrentRate" type="text" style="width:100px;"  /><span id="spanCurrentRate"></span>
                   <span class="spanwarning" id="span_CurrentRate">(必填)</span>
            </td>
            </tr>
           
           <tr>
            <td align="right" ><span>市场价格:</span></td>
            <td><input name="Price_ShiChang" type="text" style="width:100px;"  /><span id="spanPrice_ShiChang"></span>
                 <span class="spanwarning" id="span_Price_ShiChang">(必填)</span>
          <%--  <input type="checkbox" name="chkPrice_ShiChang" />
            <span style="font-size:12px;">同步更新各存期<b id="bVarietyID1"></b>的市场价</span>--%>
                 <input type="checkbox" id="ISDefault-chkPrice_ShiChang"  name="chkPrice_ShiChang" value="1" class="custom-checkbox"  /><label for="ISDefault-chkPrice_ShiChang"></label><span style="margin:0px 0px 0px 5px;font-size:12px;">同步更新各存期<b id="bVarietyID1"></b>的市场价</span>
            </td>
            </tr>
            <tr style="display:none;">
            <td align="right" ><span>销售价格:</span></td>
            <td><input name="Price_XiaoShou" type="text" style="width:100px;"  /><span id="spanPrice_XiaoShou"></span>
                <span class="spanwarning_choose" id="span_Price_XiaoShou">(必填)</span>
              <%--<input type="checkbox" name="chkPrice_XiaoShou" />
            <span style="font-size:12px;">同步更新各存期<b id="bVarietyID2"></b>的销售价</span>--%>
                 <input type="checkbox" id="ISDefault-chkPrice_XiaoShou"  name="chkPrice_XiaoShou" value="1" class="custom-checkbox"  /><label for="ISDefault-chkPrice_XiaoShou"></label><span style="margin:0px 0px 0px 5px;font-size:12px;">同步更新各存期<b id="bVarietyID2"></b>的市场价</span>
            </td>
            </tr>
             <tr>
            <td align="right" ><span>到期价格:</span></td>
            <td><input name="Price_DaoQi" type="text" style="width:100px;"  /><span id="spanPrice_DaoQi"></span>
                  <span class="spanwarning_choose" id="span_Price_DaoQi">(必填)</span>
            </td>
            </tr>
             <tr>
            <td align="right" ><span>合同价格:</span></td>
            <td><input name="Price_HeTong" type="text" style="width:100px;"  /><span id="spanPrice_HeTong"></span>
                  <span class="spanwarning_choose" id="span_Price_HeTong">(必填)</span>
            </td>
            </tr>
             
             <tr id="tr_EarningRate">
             <td align="right" ><span>受益比率:</span></td>
            <td><input name="EarningRate" type="text" style="width:60px;" />%
                    <span class="spanwarning" >(必填)</span>
                 <span  style="font-size:12px; color:#666;">受益比率为100%时，则所有的受益属于储户</span>
            </td>
            </tr>
             <tr id="tr_LossRate">
             <td align="right" ><span>亏损比率:</span></td>
            <td><input name="LossRate" type="text" style="width:60px;" />%
                   <span class="spanwarning" >(必填)</span>
                 <span  style="font-size:12px; color:#666;">亏损比率为100%时，则所有的亏损由储户承担</span>
            </td>
            </tr>
            
             
            <tr id="trAdd">
            <td></td>
            <td ><input type="button" id="btnAdd" value="添加" onclick="FunAdd()" /> </td>
            </tr>
               <tr id="trUpdate">
            <td></td>
            <td ><input type="button" id="btnUpdate" value="修改" onclick="FunUpdate()" />
         
             </td>
            </tr>
        </table>
        </div>
    </div>

    </form>
    <%--定义编号--%>
    <input type="hidden" id="WBID" value="" />
    <%--定义背景色的隐藏域--%>
    <input type="hidden" id="colorName" value="" />
</body>
</html>


