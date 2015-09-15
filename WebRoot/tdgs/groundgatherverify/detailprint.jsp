<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<link rel="stylesheet" href="<%=spath%>/css/tablen.css"/>
	<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
    <script src="<%=spath%>/js/tiles.js"></script>
    <script src="<%=spath%>/js/moduleWindow.js"></script>
	<script src="<%=spath%>/menus.js"></script>
	
	<script src="<%=spath%>/js/jquery.simplemodal.js"></script>
	<script src="<%=spath%>/js/overlay.js"></script>
	<script src="<%=spath%>/js/jquery.json-2.2.js"></script>
	<script src="<%=spath%>/js/json2.js"></script>
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>

	<script src="<%=spath%>/js/LodopFuncs.js"></script>
	<object  id="LODOP_OB" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width=0 height=0 > 
	       <embed id="LODOP_EM" type="application/x-print-lodop" width=0 height=0></embed>
	</object>

	<script>
	var qrcode="";
	var LODOP; //声明为全局变量 
	function CreateOneFormPage(){
		LODOP=getLodop(document.getElementById('LODOP_OB'),document.getElementById('LODOP_EM'));  
		LODOP.SET_LICENSES("昆明恒辰科技有限公司","055595969718688748719056235623","","");
		LODOP.PRINT_INIT("土地使用税、房产税税源核实表");
		LODOP.SET_PRINT_STYLE("FontSize",18);
		LODOP.SET_PRINT_STYLE("Bold",1);
//		alert(document.getElementById("content").innerHTML);
		LODOP.ADD_PRINT_HTM(0,0,'100%','100%',document.getElementById("content").innerHTML);
//		LODOP.ADD_PRINT_TABLE(0,0,'100%','100%',document.getElementById("content").innerHTML);
//		LODOP.ADD_PRINT_URL(0,0,'100%','100%',"file:///D:/Workspaces/jnds-tdgs/WebRoot/tdgs/groundgathercheck/detailprint.html")

//		LODOP.ADD_PRINT_TABLE(0,0,'100%','100%',document.getElementById("content1").innerHTML);
//		LODOP.ADD_PRINT_TABLE(document.getElementById("content1").offsetHeight,0,'100%','100%',document.getElementById("content2").innerHTML);
//		LODOP.ADD_PRINT_TABLE(document.getElementById("content1").offsetHeight+document.getElementById("content2").offsetHeight,0,'100%','100%',document.getElementById("content3").innerHTML);
//		LODOP.ADD_PRINT_TABLE(document.getElementById("content1").offsetHeight+document.getElementById("content2").offsetHeight+document.getElementById("content3").offsetHeight,0,'100%','100%',document.getElementById("content4").innerHTML);


		LODOP.SET_PRINT_PAGESIZE(2,0,0,"");
//		qrcode="5301240002744|晋宁县水利管理服务公司|土地面积:40109.95|免税土地面积:0|应税土地面积:40109.95|房产原值:667261.58|减免房产原值:|应税房产原值: 667,261.58";
//		LODOP.SET_SHOW_MODE("LANGUAGE",0);
//		alert(qrcode);
//		LODOP.ADD_PRINT_BARCODE(78,920,150,150,"QRCode",qrcode);
		LODOP.ADD_PRINT_BARCODE(78,956,150,150,"QRCode",qrcode);
//		LODOP.ADD_PRINT_BARCODE(82,947,150,150,"QRCode","12345汉字内容");
//		LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",3);
//		LODOP.ADD_PRINT_TEXT(3,653,135,20,"总页号：第#页/共&页");
	};
	
	function SaveAsFile(){ 
		LODOP=getLodop(document.getElementById('LODOP_OB'),document.getElementById('LODOP_EM'));   
		LODOP.SET_LICENSES("昆明恒辰科技有限公司","055595969718688748719056235623","","");
		LODOP.PRINT_INIT("土地使用税、房产税税源核实表"); 
		LODOP.ADD_PRINT_TABLE(0,0,'100%','100%',document.getElementById("content2").innerHTML); 
		LODOP.SET_SAVE_MODE("Orientation",2); //Excel文件的页面设置：横向打印   1-纵向,2-横向;
		LODOP.SET_SAVE_MODE("PaperSize",9);  //Excel文件的页面设置：纸张大小   9-对应A4
		LODOP.SET_SAVE_MODE("Zoom",90);       //Excel文件的页面设置：缩放比例
		LODOP.SET_SAVE_MODE("CenterHorizontally",true);//Excel文件的页面设置：页面水平居中
		LODOP.SET_SAVE_MODE("CenterVertically",true); //Excel文件的页面设置：页面垂直居中
//		LODOP.SET_SAVE_MODE("QUICK_SAVE",true);//快速生成（无表格样式,数据量较大时或许用到） 
		LODOP.SAVE_TO_FILE($("#taxpayername").html()+".xls"); 
	};
	
	function prn1_preview() {	
		CreateOneFormPage();	
		LODOP.SET_PREVIEW_WINDOW(1,0,0,0,0,"");	
		LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED",1);//横向时的正向显示
		LODOP.PREVIEW();	
	};
	function prn1_print() {		
		CreateOneFormPage();
		LODOP.PRINT();	
		
	};
	function prn1_printA() {		
		CreateOneFormPage();
		if (LODOP.PRINTA()){ 
		
		var url = location.href;
		//alert(url);
		$.ajax({
		   type: "post",
		   url: "/GroundGatherVerifyPrintServlet/printUpdate.do?"+url.substring(url.indexOf("?")+1,url.length),
		  // data: {estateid:row.estateid,opttype:1,intotaxscopeflag:'1'},
		   dataType: "json",
		   success: function(jsondata){
			 // $.messager.alert('返回消息',jsondata);
			  
		   }
		});	
		}
	};
	var flag=45;//强制分页标志 多少行开始分页
	
	
	$(function(){
		var url = location.href;
//		alert(url.substring(url.indexOf("?")+1,url.length));
		 /**/ $.ajax({
			type: 'POST',
	        url: "/GroundGatherVerifyPrintServlet/print.do?"+url.substring(url.indexOf("?")+1,url.length),
//	        data: {taxstate:taxstate,serialno:rows.serialno,subid:subid.toString()},
	       	dataType: "json",
	        success: function (data) {
	        		if(null==data.taxpayerid || ""==data.taxpayerid){
	        			$('#btn_preview').linkbutton('disable');
	        			$('#btn_print').linkbutton('disable');
	        			$.messager.alert('提示',"获取打印信息失败！");
	        		}else{
	        			 $("#taxdeptcode").html(data.taxdeptcode);
	        			 $("#taxmanagercode").html(data.taxmanagercode);
	        			 $("#printdate").html(data.printdate);
	        			 $("#taxpayerid").html(data.taxpayerid);
	        			 $("#taxpayername").html(data.taxpayername);
	        			 $("#econaturecode").html(data.econaturecode);
	        			 $("#callingcode").html(data.callingcode);
	        			 $("#taxcontactperson").html(data.taxcontactperson);
	        			 $("#taxcontactpersontel").html(data.taxcontactpersontel);
	        			 qrcode=data.qrcode;
	        			 
	        			 var pageflag=19;//第一页19行固定高度
	        			 var page=1;
	        			 for(var i=0;i<data.landlist.length;i++){
	        				 var landdata=data.landlist[i];
	        				 //按文字计算分页数量
	        				 var landsource=landdata.landsource.indexOf("其他")>=0?2:1;//土地来源
	        				 var landcertificate=landdata.landcertificate.length/14+(landdata.landcertificate.length%14>0?1:0);//土地使用权证号
	        				 var belongtowns=landdata.belongtowns.length/5+(landdata.belongtowns.length%5>0?1:0);//所属乡镇
	        				 var detailaddress=landdata.detailaddress.length/9+(landdata.detailaddress.length%9>0?1:0);//土地坐落地
	        				 
	        				 var num=new Array();
	        				 num.push(landsource);
	        				 num.push(landcertificate);
	        				 num.push(belongtowns);
	        				 num.push(detailaddress);
	        				 pageflag=pageflag+Math.max.apply(null, num);//取最大值
	        				 var pagehtml="<tr>";
	        				 if(pageflag>=flag){
	        					 //分页
	        					 pagehtml="<tr style='page-break-after:always'>";
	        					 pageflag=0; 
	        					 page++;
	        				 }
	        				 
	        				 var tr="<tr><td height='21' colspan='1' width='35' valign='middle'  align='center'><font size='2'>"+landdata.no+"</font></td>"
	        				 +"<td height='21' colspan='1' width='35' valign='middle'  align='center'><font size='2'>"+landdata.landsource+"</font></td>"
	        				 +"<td height='21' colspan='2' width='168' valign='middle'  align='center'><font size='2'>"+landdata.landcertificate+"</font></td>"
	        				 +"<td height='21' colspan='1' width='70' valign='middle'  align='center'><font size='2'>"+landdata.landuse+"</font></td>"
	        				 +"<td height='21' colspan='1' width='69' valign='middle'  align='center'><font size='2'>"+landdata.belongtowns+"</font></td>"
	        				 +"<td height='21' colspan='2' width='155' valign='middle'  align='center'><font size='2'>"+landdata.detailaddress+"</font></td>"
	        				 +"<td height='21' colspan='1' width='111' valign='middle'  align='center'><font size='2'>"+landdata.holddate+"</font></td>"
	        				 +"<td height='21' colspan='1' width='85' valign='middle'  align='center'><font size='2'>"+landdata.landmoney+"</font></td>"
	        				 +"<td height='21' colspan='1' width='100' valign='middle'  align='center'><font size='2'>"+landdata.landarea+"</font></td>"
	        				 +"<td height='21' colspan='1' width='92' valign='middle'  align='center'><font size='2'>"+landdata.taxfreearea+"</font></td>"
	        				 +"<td height='21' colspan='2' width='87' valign='middle'  align='center'><font size='2'>"+landdata.taxarea+"</font></td>"
	        				 +"<td height='21' colspan='1' width='92' valign='middle'  align='center'><font size='2'>"+landdata.landtaxprice+"</font></td></tr>";
//	        				 $("#landtable tr:eq(1)").after(tr);
	        				 $("#landtable").append(tr);
	        				 if(page>1 && pageflag==0){
	        					 $("#landtable").append(pagehtml+"<td colspan='15'><div align='center' id='page"+(page-1)+"'>第 1 页,共 3 页</div></td></tr>");
	        					 var $tr1=$("#landtable tr:eq(0)").clone();
	        					 $("#landtable").append($tr1);
	        					 var $tr2=$("#landtable tr:eq(1)").clone();
	        					 $("#landtable").append($tr2);
	        					 pageflag=pageflag+3;//土地3行表头
	        				 }
	        			 }
	        			 pageflag=pageflag+1;//合计
	        			 $("#landtable").append("<tr><td height='21' colspan='9' width='643' valign='middle'  align='center'><font size='2'>合计</font></td>"
	                     +"<td height='21' colspan='1' width='85' valign='middle'  align='center'><font size='2'>"+data.landmoneysum+"</font></td>"
	                     +"<td height='21' colspan='1' width='100' valign='middle'  align='center'><font size='2'>"+data.landareasum+"</font></td>"
	                     +"<td height='21' colspan='1' width='92' valign='middle'  align='center'><font size='2'>"+data.taxfreeareasum+"</font></td>"
	                     +"<td height='21' colspan='2' width='97' valign='middle'  align='center'><font size='2'>"+data.taxareasum+"</font></td>"
	                     +"<td height='21' colspan='1' width='92' valign='middle'  align='center'><font size='2'></font></td></tr>");
	        			 
	        			 pageflag=pageflag+3;//房产3行表头
	        			 for(var i=0;i<data.houselist.length;i++){
	        				 var housedata=data.houselist[i];
	        				 
	        				 //按文字计算分页数量
	        				 var housesource=housedata.housesource.indexOf("其他")>=0?2:1;//房产来源
	        				 var housecertificate=housedata.housecertificate.length/18+(housedata.housecertificate.length%18>0?1:0);//房屋产权证号
	        				 var housepurposes=housedata.housepurposes.length/4+(housedata.housepurposes.length%4>0?1:0);//用途
	        				 var belongtowns=housedata.belongtowns.length/5+(housedata.belongtowns.length%5>0?1:0);//所属乡镇
	        				 var detailaddress=housedata.detailaddress.length/9+(housedata.detailaddress.length%9>0?1:0);//房产坐落地
	        				 

	        				 var num=new Array();
	        				 num.push(housesource);
	        				 num.push(housecertificate);
	        				 num.push(housepurposes);
	        				 num.push(belongtowns);
	        				 num.push(detailaddress);
	        				 
	        				 pageflag=pageflag+Math.max.apply(null, num);//取最大值
//	        				 alert(housedata.housecertificate+"-----"+Math.max.apply(null, num));
	        				 var pagehtml="<tr>";
	        				 if(pageflag>=flag){
	        					 //分页
	        					 pagehtml="<tr style='page-break-after:always'>";
	        					 pageflag=0; 
	        					 page++;
	        				 }
	        				 
	        				 var tr="<tr><td height='21' colspan='1' width='35' valign='middle'  align='center'><font size='2'>"+housedata.no+"</font></td>"
	        				 +"<td height='21' colspan='1' width='35' valign='middle'  align='center'><font size='2'>"+housedata.housesource+"</font></td>"
	        				 +"<td height='21' colspan='2' width='168' valign='middle'  align='center'><font size='2'>"+housedata.housecertificate+"</font></td>"
	        				 +"<td height='21' colspan='1' width='70' valign='middle'  align='center'><font size='2'>"+housedata.housepurposes+"</font></td>"
	        				 +"<td height='21' colspan='1' width='69' valign='middle'  align='center'><font size='2'>"+housedata.belongtowns+"</font></td>"
	        				 +"<td height='21' colspan='2' width='155' valign='middle'  align='center'><font size='2'>"+housedata.detailaddress+"</font></td>"
	        				 +"<td height='21' colspan='1' width='111' valign='middle'  align='center'><font size='2'>"+housedata.usedate+"</font></td>"
	        				 +"<td height='21' colspan='1' width='85' valign='middle'  align='center'><font size='2'>"+housedata.housearea+"</font></td>"
	        				 +"<td height='21' colspan='1' width='100' valign='middle'  align='center'><font size='2'>"+housedata.houseoriginalvalue+"</font></td>"
	        				 +"<td height='21' colspan='1' width='92' valign='middle'  align='center'><font size='2'>"+housedata.landmoney+"</font></td>"
	        				 +"<td height='21' colspan='2' width='87' valign='middle'  align='center'><font size='2'>"+housedata.reducenum+"</font></td>"
	        				 +"<td height='21' colspan='1' width='92' valign='middle'  align='center'><font size='2'>"+housedata.housetaxoriginalvalue+"</font></td></tr>";
	        				 $("#housetable").append(tr);
	        				 if( pageflag==0){
	        					 $("#housetable").append(pagehtml+"<td colspan='15'><div align='center' id='page"+(page-1)+"'>第 1 页,共 3 页</div></td></tr>");
	        					 var $tr1=$("#housetable tr:eq(0)").clone();
	        					 $("#housetable").append($tr1);
	        					 var $tr2=$("#housetable tr:eq(1)").clone();
	        					 $("#housetable").append($tr2);
	        					 var $tr3=$("#housetable tr:eq(2)").clone();
	        					 $("#housetable").append($tr3);
	        					 pageflag=pageflag+3;//房产3行表头
	        				 }
	        			 }
	        			
	        			 pageflag=pageflag+9;//房产合计+后面固定的内容
	        			 if(pageflag>=flag){
	        				 page++;
	        				 $("#housetable").append("<tr style='page-break-after:always'><td colspan='15'><div align='center' id='page"+(page-1)+"'>第 1 页,共 3 页</div></td></tr>");
//	        				 $("#housetable").append("<tr border='0'><td border='0' colspan='14'>&nbsp;</td></tr>");
	        			 }
	        				 
	        			 $("#housetable").append("<tr><td height='21' colspan='9' width='643' valign='middle'  align='center'><font size='2'>合计</font></td>"
	                     +"<td height='21' colspan='1' width='85' valign='middle'  align='center'><font size='2'>"+data.houseareasum+"</font></td>"
	                     +"<td height='21' colspan='1' width='100' valign='middle'  align='center'><font size='2'>"+data.houseoriginalvaluesum+"</font></td>"
	                     +"<td height='21' colspan='1' width='92' valign='middle'  align='center'><font size='2'>"+data.landmoney2sum+"</font></td>"
	                     +"<td height='21' colspan='2' width='97' valign='middle'  align='center'><font size='2'>"+data.reducenumsum+"</font></td>"
	                     +"<td height='21' colspan='1' width='92' valign='middle'  align='center'><font size='2'>"+data.housetaxoriginalvaluesum+"</font></td></tr>");
	        			 
	        			 //更新页码
	        			 for(var i=1;i<page;i++){
	        				 $("#page"+i).html("<font size='3'>第 "+i+" 页 , 共 "+page+" 页</font>");
	        			 }
	        			 $("#foot").html("<font size='3'>第 "+page+" 页 , 共 "+page+" 页</font>"); 
	        		}
	        }
	    });  
	})
	</script>
</head>
<body>
<div id="content">
<table    border="0" cellpadding="0" cellspacing="0"   bordercolor="#000000">
  <tr>
    <td>
    <div align="center">
        <table  border="0" >
          <tr>
            <td   valign="top"> 
            <div align="center" > <!-- id="content2" -->
                  <table  border="0" >
                  <th>
                  	<td height="21" colspan="15"  valign="middle"  align="center"><font size="5"><strong>土地使用税、房产税税源核实表</strong></font></td>
                  </th>
                  <tr> 
                    <td colspan="2" height="21" width="89" nowrap> <div align="left" ><font size="2">主管税务机关:</font></div></td>
                    <td colspan="2" height="21" width="214" > <div align="left" ><font id="taxdeptcode" size="2"></font></div></td>
                    <td colspan="1" height="21" width="74" > <div align="left" ><font size="2">税收管理员:</font></div></td> 
                    <td colspan="2" height="21" width="155" > <div align="left" ><font id="taxmanagercode" size="2"></font></div></td> 
                    <td colspan="1" height="21" width="111" > <div align="left" ><font size="2">制表时间：</font></div></td> 
                    <td colspan="2" height="21" width="185" > <div align="left" ><font id="printdate" size="2"></font></div></td> 
                    <td colspan="1" height="21" width="92" > <div align="center" ><font size="2"></font></div></td>
                    <td colspan="3" height="21" width="179" > <div align="center" ><font size="2">单位：平方米、元</font></div></td>
                  </tr>
                </table>
                <table   width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
                  <tr > 
                    <td height="75" colspan="2" width="89" valign="middle"  align="center"><font size="2">计算机编码</font></td>
                    <td height="75" colspan="1" width="149" valign="middle"  align="center"><font id="taxpayerid" size="2"></font></td>
                    <td height="75" colspan="2" width="139" valign="middle"  align="center"><font size="2">纳税人名称</font></td>
                    <td height="75" colspan="3" width="266" valign="middle"  align="center"><font id="taxpayername" size="2"></font></td>
                    <td height="75" colspan="1" width="85" valign="middle"  align="center"><font size="2">注册类型</font></td>
                    <td height="75" colspan="2" width="192" valign="middle"  align="center"><font id="econaturecode" size="2"></font></td>
                    <!--  -->
                    <td height="75" colspan="1" width="26" rowspan="2" valign="middle" align="center"><font size="2">二<br>维<br>码</font></td>
                    <td height="75" colspan="2" width="153" rowspan="2" valign="middle"  align="center"><font size="2"></font></td>
                    
                  </tr>
                  <tr >
                    <td height="75" colspan="2" width="89" valign="middle"  align="center"><font size="2">所属行业</font></td>
                    <td height="75" colspan="1" width="149" valign="middle"  align="center"><font id="callingcode" size="2"></font></td>
                    <td height="75" colspan="2" width="139" valign="middle"  align="center"><font size="2">联系人</font></td>
                    <td height="75" colspan="3" width="266" valign="middle"  align="center"><font id="taxcontactperson" size="2"></font></td>
                    <td height="75" colspan="1" width="85" valign="middle"  align="center"><font size="2">联系电话</font></td>
                    <td height="75" colspan="2" width="192" valign="middle"  align="center"><font id="taxcontactpersontel" size="2"></font></td>
                  </tr>
				</table>
				 
				<table id="landtable" width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
				  <tr>
                  	<td height="21" colspan="15"  valign="middle"  align="center"><strong><font size="3">土地使用税税源信息</strong></font></td>
                  </tr>
                   <tr>
                    <td height="21" colspan="1" width="35" valign="middle"  align="center"><font size="2">序号</font></td>
                  	<td height="21" colspan="1" width="35" valign="middle"  align="center"><font size="2">土地来源</font></td>
                    <td height="21" colspan="2" width="168" valign="middle"  align="center"><font size="2">土地使用权证号</font></td>
                    <td height="21" colspan="1" width="70" valign="middle"  align="center"><font size="2">用途</font></td>
                    <td height="21" colspan="1" width="69" valign="middle"  align="center"><font size="2">所属乡镇(街道办)</font></td>
                    <td height="21" colspan="2" width="155" valign="middle"  align="center"><font size="2">土地坐落地</font></td>
                    <td height="21" colspan="1" width="111" valign="middle"  align="center"><font size="2">取得土地时间</font></td>
                    <td height="21" colspan="1" width="85" valign="middle"  align="center"><font size="2">土地价值</font></td>
                    <td height="21" colspan="1" width="100" valign="middle"  align="center"><font size="2">土地面积</font></td>
                    <td height="21" colspan="1" width="92" valign="middle"  align="center"><font size="2">免税土地面积</font></td>
                    <td height="21" colspan="2" width="87" valign="middle"  align="center"><font size="2">应税土地面积</font></td>
                    <td height="21" colspan="1" width="92" valign="middle"  align="center"><font size="2">土地等级</font></td>
                  </tr>
				</table>
				<table id="housetable" width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
				   <tr>
                  		<td height="21" colspan="15"  valign="middle"  align="center"><font size="3"><strong>房产税税源信息</strong></font></td>
                   </tr>
                   <tr>
                    <td height="21" colspan="1" width="35" rowspan="2" valign="middle"  align="center"><font size="2">序号</font></td>
                  	<td height="21" colspan="1" width="35" rowspan="2" valign="middle"  align="center"><font size="2">房产来源</font></td>
                    <td height="21" colspan="2" width="168" rowspan="2" valign="middle"  align="center"><font size="2">房屋产权证号</font></td>
                    <td height="21" colspan="1" width="70" rowspan="2" valign="middle"  align="center"><font size="2">用途</font></td>
                    <td height="21" colspan="1" width="69" rowspan="2" valign="middle"  align="center"><font size="2">所属乡镇(街道办)</font></td>
                    <td height="21" colspan="2" width="155" rowspan="2" valign="middle"  align="center"><font size="2">房产坐落地</font></td>
                    <td height="21" colspan="1" width="111" rowspan="2" valign="middle"  align="center"><font size="2">投入使用时间</font></td>
                    <td height="21" colspan="1" width="85" rowspan="2" valign="middle"  align="center"><font size="2">建筑面积</font></td>
                    <td height="21" colspan="2" width="192" rowspan="1" valign="middle"  align="center"><font size="2">计税房产原值</font></td>
                    <td height="21" colspan="2" width="87" rowspan="2" valign="middle"  align="center"><font size="2">减免房产原值</font></td>
                    <td height="21" colspan="1" width="92" rowspan="2" valign="middle"  align="center"><font size="2">应税房产原值</font></td>
                  </tr>
                  <tr>
                  	<td height="21" colspan="1" width="100" valign="middle"  align="center"><font size="2">房产原值</font></td>
                    <td height="21" colspan="1" width="92" valign="middle"  align="center"><font size="2">土地价值</font></td>
                  </tr>
				</table>
				<table  width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
                   <tr>
                  	<td height="21" colspan="15" width="100%" valign="top"  align="left">
                  		<font size="2">告知事项：
                  		<br>
                  		1、根据你单位  年  月  日提供房产税、土地使用税的涉税资料（附件），经审核确认如上税源。
                  		<br>
                  		2、今后你单位在生产经营过程中，若土地使用税、房产税的计税依据发生变化，根据《中华人民共和国税收征收管理法》的规定，应如实向我分局申报，否则将承担相应的法律责任。
                  		<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;审核人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主管税务机关负责人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主管税务机关（签章）
                  		</font>
                  	</td>
                    <!-- <td height="21" colspan="3" width="326" valign="top"  align="left"><font size="2">主管税务机关的核实意见：
                    	<br><br><br>
                    	税收管员：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分局负责人：
                    	<br>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp; 月&nbsp;&nbsp; 日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	&nbsp;年&nbsp;&nbsp; 月&nbsp;&nbsp; 日	
                    </font></td>
                    <td height="21" colspan="4" width="271" valign="middle"  align="left"><font size="2">审核小组意见:
                    	<br><br><br>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	&nbsp;&nbsp;&nbsp;审核人员签字:
                    	<br>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;月&nbsp;&nbsp;日	
                    </font></td> -->
				</table>
				<table  width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
                   <tr>
                  	<td height="21" colspan="15" width="100%" valign="top"  align="left">
                  		<font size="2">纳税人声明：我单位提供的资料是真实、合法、完整的，如有虚假，愿承担相应的法律责任。
                  		<br>
                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经核实此税源核实表中土地使用税、房产税信息与我单位提供的一致，税源准确无误。
                  		<br>
						经办人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;企业负责人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;纳税人公章
                  		</font>
                  	</td>
				</table>
				 <table border="0" width="100%">
                  <tr> 
                    <td colspan="15" height="21" > 
                    <div align="left" ><font size="2">注：本核实表一式二份，纳税人和主管税务机关各一份。</font></div>
                    <div align="center" id="foot"></div>
                    </td>
                  </tr>
                </table>
                
               </div>
			</td>
          </tr>
        </table>
     </div>
     </td>
  </tr>
</table>
</div>	
<table width="1099">
<tr>
  	<td height="24" colspan="10" class="TitTab1">
		<div align="center">
			<!--<a id="btn_preview" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-viewdetail'" onclick="prn1_preview()">打印预览</a>-->
			<a id="btn_print" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="prn1_printA()">打印</a>
<!--			<a id="btn_print" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export'" onclick="SaveAsFile()">导出</a> -->
	  	</div>
	</td>
</tr>
</table>
</body>
</html>