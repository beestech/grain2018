﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CheckOutDetail.aspx.cs" Inherits="Web.Settle.CheckOutDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="../Scripts/WebInner.js" type="text/javascript"></script>
    <script src="../Scripts/Common.js" type="text/javascript"></script>
    <link href="../Styles/Common.css" rel="stylesheet" type="text/css" />
    
   
    <script src="../Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script src="../Lodop6.198/LodopFuncs.js" type="text/javascript"></script>
    <style>
    #divGuoBang
    {
        background-color:#efefef;
        border:1px solid #555;
        border-radius:10px;
         margin:10px;
         padding-left:20px;
        }
        #divZhiJian
        {
             background-color:#efefef;
        border:1px solid #555;
        border-radius:10px;
           padding-left:20px;
         margin:10px;
            }
    </style>
      <script type="text/javascript">
          /*--------窗体启动设置和基本设置--------*/
          /*--loadFuntion--*/
          $(function () {
              var ID = getQueryString('ID');
              var WBID = getQueryString('WBID');
              var VarietyID = getQueryString('VarietyID');
              var VarietyLevelID = getQueryString('VarietyLevelID');
              if (ID == '' || WBID == '' || VarietyID == '') {
                  location.href = '/Settle/CheckOut.aspx';
              }
              $('input[name=SA_VarietyStorage_ID]').val(ID);
              $('input[name=WB_ID]').val(WBID);
              $('input[name=Variety_ID]').val(VarietyID);
              $('input[name=VarietyLevel_ID]').val(VarietyLevelID);
              $('input[name=SA_VarietyStorage_ID]').val(ID);
           
              GetStorageVarietyInfo(ID);
              //过磅人员
              GetWeigh();
              //出库类型
              GetStockType();
              //质检人员
              GetQuality();
              GetVarietyInfo(VarietyID);
              GetStorageVarietyLevel(VarietyID);
              //网点仓库
              GetWBWH(WBID);
              $('select[name=Weigh_Name]').change(function () { $('input[name=strWeigh]').val($('select[name=Weigh_Name] option:selected').text()) });
              $('select[name=WBWH]').change(function () { $('input[name=SA_Account_WH]').val($('select[name=WBWH] option:selected').text()) });
              $('select[name=Quanlity_Name]').change(function () { $('input[name=strQuality]').val($('select[name=Quanlity_Name] option:selected').text()) });
              $('select[name=StockType_Name]').change(function () { $('input[name=strStockType]').val($('select[name=StockType_Name] option:selected').text()) });

              //获取日期
              //添加时间
              var now = new Date(); //获取系统日期，即Sat Jul 29 08:24:48 UTC+0800 2006
              var yy = now.getFullYear(); //截取年，即2006
              var mo = now.getMonth() + 1; //截取月，即07 （系统中的月份为0~11，所有使用的时候要+1）
              var dd = now.getDate(); //截取日，即29
              //取时间
              var hh = now.getHours(); //截取小时，即8
              var mm = now.getMinutes(); //截取分钟，即34
              var ss = now.getSeconds(); //获取秒 
              $('input[name=dt_Trade]').val(yy + '-' + mo + '-' + dd);

          });

          //查找商品存量信息
          function GetStorageVarietyInfo(obj) {
              
              $.ajax({
                  url: '/Ashx/settle.ashx?type=GetStorageVarietyInfo&ID=' + obj,
                  type: 'post',
                  data: '',
                  dataType: 'json',
                  success: function (r) {
                      $('input[name=WB_ID]').val(r[0].WBID);
                      $('input[name=Variety_ID]').val(r[0].VarietyID);
                      $('input[name=numStorage]').val(r[0].numStorage);
                      
                  }, error: function (r) {
                      if (r.responseText != "Error") {
                         showMsg('加载商品存储信息失败 ！');
                      }
                  }
              });
          }
          


          function GetVarietyInfo(VarietyID) {

              $.ajax({
                  url: '/BasicData/StoragePara/storage.ashx?type=GetStorageVarietyByID&ID=' + VarietyID,
                  type: 'post',
                  data: '',
                  dataType: 'json',
                  success: function (r) {
                      $('#S_VarietyName').html(r[0].strName);
                      $('input[name=Variety_Name]').val(r[0].strName);
                  }, error: function (r) {
                      if (r.responseText != "Error") {
                         showMsg('加载信息失败 ！');
                      }
                  }
              });
          }

          function GetStorageVarietyLevel(VarietyID) {

              $.ajax({
                  url: '/BasicData/StoragePara/storage.ashx?type=GetStorageVarietyLevel&VarietyID=' + VarietyID,
                  type: 'post',
                  data: '',
                  dataType: 'text',
                  success: function (r) {
                      $('#S_Level').html(r);
                      $('input[name=strLevel]').val(r);
                  }, error: function (r) {
                      if (r.responseText != "Error") {
                         showMsg('加载信息失败 ！');
                      }
                  }
              });
          }

          //获取网店仓库信息
          function GetWBWH(WBID) {
              $.ajax({
                  url: '/Ashx/settlebasic.ashx?type=GetWBWH&WBID=' + WBID,
                  type: 'post',
                  data: '',
                  dataType: 'json',
                  success: function (r) {
                      $('select[name=WBWH]').empty();
                      for (var i = 0; i < r.length; i++) {
                          $('select[name=WBWH]').append("<option value='" + r[i].ID + "'>" + r[i].strName + "</option>");
                          $('input[name=SA_Account_WH]').val(r[0].strName); //仓库名称
                      }
                  }, error: function (r) {
                      if (r.responseText != "Error") {
                         showMsg('加载信息失败 ！');
                      }
                  }
              });
          }

          function GetStockType() {
              $.ajax({
                  url: '/Ashx/settlebasic.ashx?type=GetStockType',
                  type: 'post',
                  data: '',
                  dataType: 'json',
                  success: function (r) {
                      $('select[name=StockType_Name]').empty();
                      for (var i = 0; i < r.length; i++) {
                          $('select[name=StockType_Name]').append("<option value='" + r[i].ID + "'>" + r[i].strName + "</option>");
                          $('input[name=strStockType]').val(r[0].strName);
                      }
                  }, error: function (r) {
                      if (r.responseText != "Error") {
                         showMsg('加载信息失败 ！');
                      }
                  }
              });
          }

          function GetWeigh() {
              $.ajax({
                  url: '/Ashx/settlebasic.ashx?type=GetWeigh',
                  type: 'post',
                  data: '',
                  dataType: 'json',
                  success: function (r) {
                      $('select[name=Weigh_Name]').empty();
                      for (var i = 0; i < r.length; i++) {
                          $('select[name=Weigh_Name]').append("<option value='" + r[i].ID + "'>" + r[i].strName + "</option>");
                          $('input[name=strWeigh]').val(r[0].strName);
                      }
                  }, error: function (r) {
                      if (r.responseText != "Error") {
                         showMsg('加载信息失败 ！');
                      }
                  }
              });
          }

          function GetQuality() {
              $.ajax({
                  url: '/Ashx/settlebasic.ashx?type=GetQuality',
                  type: 'post',
                  data: '',
                  dataType: 'json',
                  success: function (r) {
                      $('select[name=Quanlity_Name]').empty();
                      for (var i = 0; i < r.length; i++) {
                          $('select[name=Quanlity_Name]').append("<option value='" + r[i].ID + "'>" + r[i].strName + "</option>");
                          $('input[name=strQuality]').val(r[0].strName);
                      }
                  }, error: function (r) {
                      if (r.responseText != "Error") {
                         showMsg('加载信息失败 ！');
                      }
                  }
              });
          }

          //查找网店信息
          function FunQuery() {
              var AccountNumber = $('#SA_Account').val();
              var WBID = $('input[name=WB_ID]').val();
              $.ajax({
                  url: '/Ashx/settlebasic.ashx?type=Get_SA_Account&AccountNumber=' + AccountNumber + '&WBID=' + WBID,
                  type: 'post',
                  data: '',
                  dataType: 'json',
                  success: function (r) {
                      $('input[name=AccountNumber]').val(r[0].AccountNumber);
                      $('#SAInfo').fadeIn('normal');
                      $('#D_AccountNumber').html(r[0].AccountNumber);
                      $('#D_strName').html(r[0].strName);
                      $('input[name=SA_Account_Name]').val(r[0].strName);
                      $('#D_PhoneNo').html(r[0].PhoneNO);
                      $('#D_strAddress').html(r[0].strAddress);
                      $('#btnCheckOut').removeAttr('disabled');

                  }, error: function (r) {
                      $('#SAInfo').fadeOut('normal');
                      $('input[name=AccountNumber]').val('');
                      $('#btnCheckOut').attr('disabled','disabled');
                     showMsg('无法获取此账号信息 ！');
                  }
              });
          }

          //出库操作
          function frmSubmit() {
              if ($('input[name=AccountNumber]').val() == "") {
                 showMsg('您还没有选择网点账号，不能出库 ！');
                  return false;
              }
              if (!frmCheck()) {
                  return false;
              }
              var msg = '您确认已经仔细检查输入信息，并继续操作吗？';
              showConfirm(msg, function (obj) {
                  if (obj == 'yes') {
                      
                      $.ajax({
                          url: '/Ashx/settle.ashx?type=AddSA_CheckOut',
                          type: 'post',
                          data: $('#form1').serialize(),
                          dataType: 'text',
                          success: function (r) {
                              if (r == "0") {
                                  showMsg('出库失败 ！');
                              } else {
                                  showMsg('出库成功 ！');
                                  $('#btnCheckOut').attr('disabled', 'disabled');
                                  $('#btnPrint').removeAttr('disabled');
                                  $('#btnPrintPage').removeAttr('disabled');
                              
                                  $('input[name=CheckOutID]').val(r);
                              }

                          }, error: function (r) {
                              showMsg('出库失败 ！');
                          }
                      });
                  }
                  else {
                      //console.log('你点击了取消！');
                  }

              });

          }


          //加载新的业务编号
          function InitBusinessNO() {
              $.ajax({
                  url: "/Ashx/settle.ashx?type=GetNewBusinessNO&AccountNumber=" + $('input[name=AccountNumber]').val(),
                  type: 'post',
                  data: '',
                  dataType: 'text',
                  success: function (r) {
                      $('input[name=BusinessNO]').val(r);
                      frmSubmit();
                  }, error: function (r) {
                     showMsg('加载信息失败 ！');
                  }
              });
          }





          function frmCheck() {

              if (!CheckInput('CheckOutNO', '磅单编号', -1)) {
                  return false;
              }
              if (!CheckInput('LicensePN', '车牌号', -1)) {
                  return false;
              }
              if (!CheckInput('dt_Trade', '入库日期', -1)) {
                  return false;
              }
              

              if (!CheckNumDecimal($('input[name=Weight_Mao]').val(), '毛重', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=Weight_Pi]').val(), '皮重', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=ShuiFenHanLiang]').val(), '水分含量', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=ShuiFenKouZhong]').val(), '水分扣重', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=ChuLiangRongLiang]').val(), '储粮容量', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=RongLiangKouZhong]').val(), '容重扣重', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=ZaZhiHanLiang]').val(), '杂质含量', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=ZazhiKouZhong]').val(), '杂质扣重', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=QiTaKouZhong]').val(), '其他扣重', 2)) {
                  return false;
              }
              if (!CheckNumDecimal($('input[name=Weight_Reality]').val(), '出库实重', 2)) {
                  return false;
              }

              var numStorage = $('input[name=numStorage]').val();
              var Weight_Reality = $('input[name=Weight_Reality]').val();
              if (parseFloat(Weight_Reality) > parseFloat(numStorage)) {
                 showMsg('出库重量大于产品库存，无法出货 ！');
                  return false
              }
              return true;
          }

          //添加出库
          function FunAdd() {
              if ($('input[name=AccountNumber]').val()=='') {
                 showMsg('请选择网点账号 ！');
                  return;
              }
              var Weight_Mao = $('input[name=Weight_Mao]').val();
              var Weight_Pi=$('input[name=Weight_Pi]').val();
              if (!CheckNumDecimal(Weight_Mao, '毛重', 2)) {
                  return false;
              }
              if (!CheckNumDecimal(Weight_Pi, '皮重', 2)) {
                  return false;
              }
              var Weight_Total = parseFloat(Weight_Mao) - parseFloat(Weight_Pi);
              $('input[name=Weight_Total]').val(Weight_Total);
              $('#btnAdd').attr('disabled','disabled');
          }
          //清空重新添加
          function FunClear() {
              $('#SA_Account').val('');
              $('#SAInfo').fadeOut('normal');
              $('input[name=AccountNumber]').val(''); //清空查询编号
              $('input[name=CheckOutNO]').val('');
              $('input[name=LicensePN]').val('');
              $('input[name=Weight_Mao]').val('0');
              $('input[name=Weight_Pi]').val('0');
              $('input[name=Weight_Total]').val('0');
              $('#btnAdd').removeAttr('disabled');
             

          }

          function FunJiSuan() {
              if (!frmCheck()) {
                  return;
              }
              var Weight_Total = $('input[name=Weight_Total]').val();

              var ShuiFenHanLiang = $('input[name=ShuiFenHanLiang]').val();
              var ShuiFenKouZhong= $('input[name=ShuiFenKouZhong]').val();
               ShuiFenKouZhong=accMul(parseFloat(Weight_Total),parseFloat( ShuiFenHanLiang));
              ShuiFenKouZhong=accMul(parseFloat(ShuiFenKouZhong),0.01);
             

              var ChuLiangRongLiang = $('input[name=ChuLiangRongLiang]').val();
              var RongLiangKouZhong=$('input[name=RongLiangKouZhong]').val();
               RongLiangKouZhong=accMul(parseFloat(Weight_Total),parseFloat( ChuLiangRongLiang));
              RongLiangKouZhong=accMul(parseFloat(RongLiangKouZhong),0.01);
              

              var ZaZhiHanLiang = $('input[name=ZaZhiHanLiang]').val();
              var ZazhiKouZhong=$('input[name=ZazhiKouZhong]').val();
               ZazhiKouZhong=accMul(parseFloat(Weight_Total),parseFloat( ZaZhiHanLiang));
              ZazhiKouZhong=accMul(parseFloat(ZazhiKouZhong),0.01);
              

              var QiTaKouZhong=$('input[name=QiTaKouZhong]').val();

              var Weight_Reality=parseFloat(Weight_Total)-parseFloat(ShuiFenKouZhong)-parseFloat(RongLiangKouZhong)-parseFloat(ZaZhiHanLiang)-parseFloat(QiTaKouZhong);
              Weight_Reality = changeTwoDecimal_f(Weight_Reality);
              $('input[name=Weight_Reality]').val(Weight_Reality);

               ShuiFenKouZhong=changeTwoDecimal_f(ShuiFenKouZhong);
              $('input[name=ShuiFenKouZhong]').val(ShuiFenKouZhong);

              RongLiangKouZhong=changeTwoDecimal_f(RongLiangKouZhong);
              $('input[name=RongLiangKouZhong]').val(RongLiangKouZhong);

              ZazhiKouZhong=changeTwoDecimal_f(ZazhiKouZhong);
              $('input[name=ZazhiKouZhong]').val(ZazhiKouZhong);

          }



          var p_left = 0; var p_ltop = 0; var p_lwidth = 0; var p_lheight = 0;
          $(function () {
              $.ajax({
                  url: '/Ashx/wbinfo.ashx?type=GetPrintSetting',
                  type: 'post',
                  data: '',
                  dataType: 'json',
                  success: function (r) {
                      p_lwidth = r[0].Width;
                      p_lheight = r[0].Height;
                      p_lleft = r[0].DriftRateX;
                      p_ltop = r[0].DriftRateY;
                  }, error: function (r) {
                     showMsg('加载网点打印坐标时出现错误 ！');
                  }
              });
          });


          function CreateOneFormPage() {
              LODOP = getLodop();
              LODOP.PRINT_INIT("存折打印");
              LODOP.SET_PRINT_STYLE("FontSize", 18);
              LODOP.SET_PRINT_STYLE("Bold", 1);
              LODOP.ADD_PRINT_TEXT(0, 0, 0, 0, "打印页面部分内容");

              LODOP.ADD_PRINT_HTM(p_ltop, p_lleft, p_lwidth, p_lheight, document.getElementById("divPrint").innerHTML);

          };




          function PrintCunZhe() {

              $.ajax({
                  url: '/Ashx/settle.ashx?type=PrintSA_CheckOutLog&AccountNumber=' + $('input[name=AccountNumber]').val() + '&BusinessNO=' + $('input[name=BusinessNO]').val(),
                  type: 'post',
                  data: '',
                  dataType: 'text',
                  success: function (r) {

                      $('#divPrint').html('');
                      $('#divPrint').append(r);
                      CreateOneFormPage();
                      LODOP.PREVIEW(); //打印存折
                  }, error: function (r) {
                     showMsg('打印存折时出现错误 ！');
                  }
              });
          }




          function PrintPage() {
              var ID = $('input[name=CheckOutID]').val();
              $.ajax({
                  url: '/Ashx/settle.ashx?type=PrintCheckOut&ID=' + ID,
                  type: 'post',
                  data: '',
                  dataType: 'text',
                  success: function (r) {

                      $('#divPrintPaper').html('');
                      $('#divPrintPaper').append(r);
                      CreatePage();
                      LODOP.PREVIEW(); //打印存折
                  }, error: function (r) {
                     showMsg('加载打印坐标时出现错误 ！');
                  }
              });

          }

          //小票打印
          function CreatePage() {
              LODOP = getLodop();
              LODOP.PRINT_INIT("小票打印");
              LODOP.SET_PRINT_STYLE("FontSize", 12);
              LODOP.SET_PRINT_STYLE("Bold", 1);
              LODOP.ADD_PRINT_TEXT(0, 0, 0, 0, "打印页面部分内容");

              LODOP.ADD_PRINT_HTM(20, 60, 800, 400, document.getElementById("divPrintPaper").innerHTML);

          };



      </script>
</head>
<body>
<div id="divPrint" style="display:none">

    </div>
     <div id="divPrintPaper" style="display:none">

    </div>

    <form id="form1" runat="server">
    <div class="pageHead">
       <b>出库过磅与质检数据录入</b>
       <%-- <span id="spanHelp" style="cursor: pointer">帮助</span>--%>
    </div>
    <div id="divHelp"  class="pageHelp">
<span>提示1：各种查询可以独使用，也可以联合使用，但必须保证至少有一项查询条件。</span><br />
<span>提示2：每项查询均为模糊查询条件，为保证查找信息的正确性，请输入完整的查询信息。</span><br />

</div>
    
<div id="storageQuery">

</div>
    <div style="margin: 20px 0px;">
      
      <form id="form1">
        <div id="divGuoBang">
        <p style="color:Blue; font-weight:bold;font-size:16px;">填写过磅数据</p>
        <table><tr><td align="right" style="width:100px"><span style="height:25px;">网点账号:</span></td>
        <td style="width:130px;"><input type="text" id="SA_Account" style="width:120px; font-size:16px; font-weight:bold" /></td>
       <td>
        <input type="button" id="btnQuerySA" value="查询" onclick="FunQuery()" style="width:80px; font-weight:bold;" />
       </td>
        </tr></table>
     
         <div id="SAInfo" runat="server"   style="display:none;">
            <table class="tabData"  style="margin:10px 0px;">
                
                <tr>
                    <th align="center" style="width:150px; height:20px;">
                        账号
                    </th>
                    <th align="center" style="width:150px;">
                        姓名
                    </th>
                     <th align="center" style="width:150px;">
                        移动电话
                    </th>
                     
                     <th align="center" style="width:200px;">
                        储户地址
                    </th>
                   
                </tr>
                   <tr>
                  
                    <td style="height:25px;">
                        <span style="font-weight:bold; color:#333;" id="D_AccountNumber"   runat="server"></span>
                    </td>
                    
                    <td>
                        <span style="font-weight:bold; color:#333;" id="D_strName" runat="server"></span>
                    </td>
                    <td>
                         <span style="font-weight:bold; color:#333;" id="D_PhoneNo" runat="server"></span>
                    </td>
                     <td>
                        <span style="font-weight:bold; color:#333;" id="D_strAddress" runat="server"></span>
                    </td>
                     
                </tr>
            </table>
        </div>
        <table style="height:25px;">
        <tr><td align="right"  style="width:100px;">  <span>磅单编号:</span></td>
        <td style="width:200px;"> <input type="text" name="CheckOutNO" /></td>
        <td align="right" style="width:80px;"><span>过磅人员:</span></td>
        <td>
        <select name="Weigh_Name" style="width:120px;"></select>
        </td>
        </tr>
        </table>
         <table style="height:25px;">
        <tr><td align="right"  style="width:100px;">   <span>车牌号:</span></td>
        <td style="width:120px;"> <input type="text" name="LicensePN" style="width:80px;" /></td>
        <td align="right" style="width:50px;"><span>毛重:</span></td>
        <td style="width:120px;"> <input type="text" name="Weight_Mao" value="0" style="width:80px;" /><span>公斤</span></td>
        <td align="right" style="width:50px;"><span>皮重:</span></td>
        <td style="width:120px;"> <input type="text" name="Weight_Pi" value="0" style="width:80px;" /><span>公斤</span></td>
        <td style="width:60px;"><input type="button" id="btnAdd" onclick="FunAdd();" value="添加" /></td>
         <td style="width:60px;"><input type="button" id="btnClear" onclick="FunClear();" value="重新输入" /></td>
        </tr>
        </table>

        </div>


       <div id="divZhiJian">
        <p style="color:Blue; font-weight:bold; font-size:16px;">填写质检数据</p>
       <table class="tabEdit" style="margin:10px 0px ">
       <tr>
       <td align="right" style="height:25px; width:100px;"><span>品种</span></td>
       <td style="width:200px"><span id="S_VarietyName"></span></td>
       <td align="right" style="width:100px"><span>净重(含杂)</span></td>
       <td style="width:200px;"><input type="text" name="Weight_Total" value="0" style="width:100px;" /><span>公斤</span></td>
       </tr>

        <tr>
       <td align="right" style="height:25px; width:100px;"><span>水分含量</span></td>
       <td style="width:200px"><input type="text" name="ShuiFenHanLiang" value="0" style="width:100px;" />%</td>
       <td align="right" style="width:100px"><span>水分扣重</span></td>
       <td style="width:200px;"><input type="text" name="ShuiFenKouZhong" value="0" readonly="readonly" style="width:100px; background-color:#eee" /><span>公斤</span></td>
       </tr>

        <tr>
       <td align="right" style="height:25px; width:100px;"><span>储粮容量</span></td>
       <td style="width:200px"><input type="text" name="ChuLiangRongLiang" value="0" style="width:100px;" />%</td>
       <td align="right" style="width:100px"><span>容重扣重</span></td>
       <td style="width:200px;"><input type="text" name="RongLiangKouZhong" value="0" readonly="readonly" style="width:100px; background-color:#eee" /><span>公斤</span></td>
       </tr>

        <tr>
       <td align="right" style="height:25px; width:100px;"><span>杂质含量</span></td>
       <td style="width:200px"><input type="text" name="ZaZhiHanLiang" value="0" style="width:100px;" />%</td>
       <td align="right" style="width:100px"><span>杂质扣重</span></td>
       <td style="width:200px;"><input type="text" name="ZazhiKouZhong" value="0" readonly="readonly" style="width:100px; background-color:#eee" /><span>公斤</span></td>
       </tr>

        <tr>
       <td align="right" style="height:25px; width:100px;"><span>其他扣重</span></td>
       <td style="width:200px"><input type="text" name="QiTaKouZhong" value="0" style="width:100px;" /><span>公斤</span></td>
       <td align="right" style="width:100px"><span>出库等级</span></td>
       <td style="width:200px;"><span id="S_Level"></span></td>
       </tr>

        <tr>
       <td align="right" style="height:25px; width:100px;"><span>计算实重</span></td>
       <td style="width:200px"><input type="button" id="btnJiSuan" onclick="FunJiSuan();" value="计算实重"  style="width:80px;" /></td>
       <td align="right" style="width:100px"><span>出库实重</span></td>
       <td style="width:200px;"><input type="text" name="Weight_Reality" value="0" readonly="readonly" style="width:100px; background-color:#eee" /><span>公斤</span></td>
       </tr>

        <tr>
       <td align="right" style="height:25px; width:100px;"><span>出库仓号</span></td>
       <td style="width:200px"><select name="WBWH" style="width:120px;"></select></td>
       <td align="right" style="width:100px"><span>入库日期</span></td>
       <td style="width:200px;"><input type="text" id="txtdate" name="dt_Trade"  style="width:100px;" /></td>
       </tr>

        <tr>
       <td align="right" style="height:25px; width:100px;"><span>出库类型</span></td>
       <td style="width:200px"><select name="StockType_Name"  style="width:120px;" ></select></td>
       <td align="right" style="width:100px"><span>质检员</span></td>
       <td style="width:200px;"><select name="Quanlity_Name"  style="width:120px;" ></select></td>
       </tr>

       </table>
      
        </div>
        </form>

        <div style=" padding-left:100px;">
        <input type="button" value="出库" id="btnCheckOut" disabled="disabled"  onclick="InitBusinessNO();" style="width:80px; font-size:16px; font-weight:bold" />&nbsp;&nbsp;
        <input type="button" value="打印存折" id="btnPrint" disabled="disabled"  onclick="PrintCunZhe();" style="width:120px; font-size:16px; font-weight:bold" />&nbsp;&nbsp;
        <input type="button" value="打印过磅单" id="btnPrintPage" disabled="disabled"  onclick="PrintPage();" style="width:120px; font-size:16px; font-weight:bold" />
        </div>
    
    <div  style="display:none;">
    <%--出库业务编号 --%>
      <input type="text" name="BusinessNO" />
     <%--新增的出库信息编号 --%>
      <input type="text" name="CheckOutID" />
       <%--产品存储表编号--%>
     <input type="text" name="SA_VarietyStorage_ID" />
      <%--网点编号--%>
     <input type="text" name="WB_ID" />
      <%--产品登记--%>
      <input type="text" name="strLevel" />
      <%--存储产品编号--%>
     <input type="text" name="Variety_ID" />
        <%--存储产品等级编号--%>
     <input type="text" name="VarietyLevel_ID" />
      <%--存储产品名称--%>
     <input type="text" name="Variety_Name" />
      <%--存储产品库存--%>
     <input type="text" name="numStorage" />
     
     <%--网点账户--%>
      <input type="text" name="AccountNumber" />
     <%--网点账户名--%>
      <input type="text" name="SA_Account_Name" />

     <%--过磅人员--%>
     <input type="text" name="strWeigh" />

     <%--出仓库号--%>
     <input type="text" name="SA_Account_WH" />

     <%--出库类型 --%>
     <input type="text" name="strStockType" />

      <%--质检人员--%>
     <input type="text" name="strQuality" />

     <%--年份（暂用）--%>
     <input type="text" name="strYear" value="2015"  />
    </div>
    </form>
    
    <%--定义编号--%>
    <input type="hidden" id="WBID" value="" />
    <%--定义背景色的隐藏域--%>
    <input type="hidden" id="colorName" value="" />
</body>
</html>


