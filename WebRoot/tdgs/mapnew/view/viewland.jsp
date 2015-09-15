<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>土地相关信息</title>
	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="/css/tablen.css">
	<link rel="stylesheet" href="/css/spectrum.css">
	
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/easyui-lang-zh_CN.js"></script>
	<script src="/js/spectrum.js"></script>
	<script src="/js/datecommon.js"></script>	
	<script src="/js/common.js"></script>
	<script src="/js/widgets.js"></script>
  </head>
     <%
        String estateid = request.getParameter("estateid");
        System.out.println("estateid="+estateid);
     %>
  </script>
  <body style="overflow:hidden" >
       <div id="esatediv" style="width:100%; height:570px;overflow:hidden;">
		           <div id="tt" class="easyui-tabs" style="width:100;height:570px;">  
					    <div title="土地基本信息" data-options="closable:false"  style="padding:5px">  
					        <form id="baselandform" name="baselandform">
					        <table id="baselandtable" width="99%" cellpadding="5" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
								<tr>
									<td align="right">计算机编码：</td>
									<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" data-insert='p' value="dddd"/></td>
									<td align="right">纳税人名称：</td>
									<td>
										<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" data-insert='p'/>
									</td>
								</tr>
								<tr>
									<td align="right">宗地编号：</td>
									<td>
										<input class="easyui-validatebox"  id="estateserialno"  name="estateserialno" data-insert='p'/>			
									</td>
									<td align="right">土地证类型：</td>
									<td>
										<input class="easyui-validatebox"  id="landcertificatetypename"  name="landcertificatetypename" data-insert='p'/>	
									</td>
								</tr>
								<tr>
									<td align="right">土地证号：</td>
									<td>
										<input class="easyui-validatebox"  id="landcertificate"  name="landcertificate"  data-insert='p'/>			
									</td>
									<td align="right">发证日期：</td>
									<td>
										<input class="easyui-datebox"  id="landcertificatedate"  name="landcertificatedate" data-insert='p'/>	
									</td>
								</tr>
								<tr>
									<td align="right">使用起日期：</td>
									<td>
										<input class="easyui-datebox"  id="datebegin"  name="datebegin" data-insert='p'/>			
									</td>
									<td align="right">使用止日期：</td>
									<td>
										<input class="easyui-datebox"  id="dateend"  name="dateend" data-insert='p'/>	
									</td>
								</tr>
								
								<tr>
									<td align="right">坐落地类型：</td>
									<td>
										<input class="easyui-validatebox" name="locationtypename" id="locationtypename" data-insert='p'/>					
									</td>
									<td align="right">所属乡镇：</td>
									<td>
										<input class="easyui-validatebox" name="belongtocountryname" id="belongtocountryname" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">实际交付日期：</td>
									<td>
										<input class="easyui-datebox" name="holddate" id="holddate" data-insert='p'/>					
									</td>
									<td align="right">获得土地总价(元)：</td>
									<td>
										<input class="easyui-validatebox" name="landmoney" id="landmoney" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">宗地面积(平方米)：</td>
									<td>
										<input class="easyui-validatebox" name="landarea" id="landarea" data-insert='p'/>					
									</td>
									<td align="right">使用权面积(平方米)：</td>
									<td>
										<input class="easyui-validatebox" name="taxarea" id="taxarea" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">土地单价(元)：</td>
									<td>
										<input class="easyui-validatebox" name="landunitprice" id="landunitprice" data-insert='p'/>					
									</td>
									<td align="right">土地使用税税率：</td>
									<td>
										<input class="easyui-validatebox" name="taxrate" id="taxrate" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">详细地址：</td>
									<td colspan="3">
										<input class="easyui-validatebox" name="detailaddress" id="detailaddress" data-insert='p'/>					
									</td>
								</tr>
							</table>
							</form>
					    </div>
					    <div title="应纳税信息" data-options="closable:false" style="overflow:auto;padding:5px;">  
					        <table id='landshouldtaxtable' class="easyui-datagrid" style="width:99;height:520px;overflow: scroll;"
									data-options="iconCls:'icon-edit',singleSelect:true">
								<thead>
										<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
										<th data-options="field:'taxpayername',width:220,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
										<th data-options="field:'taxtypename',width:120,align:'center',editor:{type:'validatebox'}">税种</th>
										<th data-options="field:'taxname',width:100,align:'center',editor:{type:'validatebox'}">税目</th>
										<th data-options="field:'taxyear',width:80,align:'center',editor:{type:'validatebox'}">税款所属年份</th>
										<th data-options="field:'shouldtaxmoney',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">应缴金额</th>
										<th data-options="field:'alreadyshouldtaxmoney',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">已缴金额</th>
										<th data-options="field:'owetaxmoney',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">欠税金额</th>
										<th data-options="field:'avoidtaxamount',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">减免金额</th>
								</thead>
							</table>   
					    </div>
					    <div title="土地历史交易" data-options="closable:false" style="padding:5px;">  
					         <table id='landhistorytable' class="easyui-datagrid" style="width:99;height:520px;overflow: scroll;"
									data-options="iconCls:'icon-edit',singleSelect:true">
								<thead>
								        <th data-options="field:'oper',formatter:viewLandHistory,hidden:false,width:120,align:'center',editor:{type:'validatebox'}">查看详细信息</th>
								        <th data-options="field:'businessnumber',hidden:true,width:100,align:'center',editor:{type:'validatebox'}">业务编号</th>
								        <th data-options="field:'busid',width:100,hidden:true,align:'center',editor:{type:'validatebox'}">业务id</th>
										<th data-options="field:'businessname',width:100,align:'center',editor:{type:'validatebox'}">业务类型</th>
										<th data-options="field:'outtaxpayerid',width:120,align:'left',editor:{type:'validatebox'}">转出计算机编码</th>
										<th data-options="field:'outtaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转出纳税人名称</th>
										<th data-options="field:'intaxpayerid',width:120,align:'center',editor:{type:'validatebox'}">转入计算机编码</th>
										<th data-options="field:'intaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转入纳税人名称</th>
										<th data-options="field:'busdate',hidden:false,width:120,formatter:formatterDate,align:'center',editor:{type:'validatebox'}">实际交付土地日期</th>
										<th data-options="field:'busarea',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">交易面积(平方米)</th>
										
								</thead>
							</table>      
					    </div>  
					    <div title="土地相关房产信息" data-options="closable:false" style="padding:5px;">  
					        <table id='houseoflandtable' class="easyui-datagrid" style="width:99;height:520px;overflow: scroll;"
									data-options="iconCls:'icon-edit',singleSelect:true">
								<thead>
								        <th data-options="field:'oper',formatter:viewHouseInfo,hidden:false,width:120,align:'center',editor:{type:'validatebox'}">查看详细信息</th>
								        <th data-options="field:'houseid',width:100,hidden:true,align:'center',editor:{type:'validatebox'}">房产id</th>
										<th data-options="field:'taxpayerid',width:120,align:'left',editor:{type:'validatebox'}">计算机编码</th>
										<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
										<th data-options="field:'housesourcename',width:120,align:'center',editor:{type:'validatebox'}">房产来源</th>
										<th data-options="field:'housecertificatetypename',width:130,align:'center',editor:{type:'validatebox'}">房产证类型</th>
										<th data-options="field:'housecertificate',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">房产证号</th>
										<th data-options="field:'housearea',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">房产面积(平方米)</th>
										<th data-options="field:'usedate',hidden:false,width:120,formatter:formatterDate,align:'center',editor:{type:'validatebox'}">投入使用日期</th>
										<th data-options="field:'belongtownsname',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">村委会</th>
										<th data-options="field:'detailaddress',hidden:false,width:220,align:'center',editor:{type:'validatebox'}">详细地址</th>
								</thead>
							</table>     
					    </div>
			      </div> 
		     </div> 
		     
		     <div id="baselanddetaildiv" class="easyui-window" data-options="closed:true,modal:true,title:'土地采集',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;">
	      <form id="baselanddetailform" name="baselanddetailform">
	      <table id="baselanddetailtable" width="100%" cellpadding="5" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
								<tr>
									<td align="right">计算机编码：</td>
									<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" data-insert='p'/></td>
									<td align="right">纳税人名称：</td>
									<td>
										<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" data-insert='p'/>
									</td>
								</tr>
								<tr>
									<td align="right">宗地编号：</td>
									<td>
										<input class="easyui-validatebox"  id="estateserialno"  name="estateserialno" data-insert='p'/>			
									</td>
									<td align="right">土地证类型：</td>
									<td>
										<input class="easyui-validatebox"  id="landcertificatetypename"  name="landcertificatetypename" data-insert='p'/>	
									</td>
								</tr>
								<tr>
									<td align="right">土地证号：</td>
									<td>
										<input class="easyui-validatebox"  id="landcertificate"  name="landcertificate"  data-insert='p'/>			
									</td>
									<td align="right">发证日期：</td>
									<td>
										<input class="easyui-datebox"  id="landcertificatedate"  name="landcertificatedate" data-insert='p'/>	
									</td>
								</tr>
								<tr>
									<td align="right">使用起日期：</td>
									<td>
										<input class="easyui-datebox"  id="datebegin"  name="datebegin" data-insert='p'/>			
									</td>
									<td align="right">使用止日期：</td>
									<td>
										<input class="easyui-datebox"  id="dateend"  name="dateend" data-insert='p'/>	
									</td>
								</tr>
								
								<tr>
									<td align="right">坐落地类型：</td>
									<td>
										<input class="easyui-validatebox" name="locationtypename" id="locationtypename" data-insert='p'/>					
									</td>
									<td align="right">所属乡镇：</td>
									<td>
										<input class="easyui-validatebox" name="belongtocountryname" id="belongtocountryname" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">实际交付日期：</td>
									<td>
										<input class="easyui-datebox" name="holddate" id="holddate" data-insert='p'/>					
									</td>
									<td align="right">获得土地总价(元)：</td>
									<td>
										<input class="easyui-validatebox" name="landmoney" id="landmoney" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">宗地面积(平方米)：</td>
									<td>
										<input class="easyui-validatebox" name="landarea" id="landarea" data-insert='p'/>					
									</td>
									<td align="right">使用权面积(平方米)：</td>
									<td>
										<input class="easyui-validatebox" name="taxarea" id="taxarea" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">土地单价(元)：</td>
									<td>
										<input class="easyui-validatebox" name="landunitprice" id="landunitprice" data-insert='p'/>					
									</td>
									<td align="right">土地使用税税率：</td>
									<td>
										<input class="easyui-validatebox" name="taxrate" id="taxrate" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">详细地址：</td>
									<td colspan="3">
										<input class="easyui-validatebox" name="detailaddress" id="detailaddress" data-insert='p'/>					
									</td>
								</tr>
							</table>
			</form>
	</div>
	<div id="buslanddetaildiv" class="easyui-window" data-options="closed:true,modal:true,title:'土地业务',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;">
	      <form id="buslanddetailform" name="baselanddetailform">
	      <table id="buslanddetailtable" width="100%" cellpadding="5" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
	
	                            <tr>
								    <td colspan="4" style="font-size: 15px;font-weight: bold;padding: 5px;">土地基本信息</td>
								</tr>
								<tr>
									<td align="right">计算机编码：</td>
									<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" data-insert='p'/></td>
									<td align="right">纳税人名称：</td>
									<td>
										<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" data-insert='p'/>
									</td>
								</tr>
								<tr>
									<td align="right">坐落地类型：</td>
									<td>
										<input class="easyui-validatebox"  id="locationtypename"  name="locationtypename" data-insert='p'/>			
									</td>
									<td align="right">所属乡镇：</td>
									<td>
										<input class="easyui-validatebox"  id="countyname"  name="countyname" data-insert='p'/>	
									</td>
								</tr>
								<tr>
									<td align="right">所属村委会：</td>
									<td>
										<input class="easyui-validatebox"  id="villagename"  name="villagename"  data-insert='p'/>			
									</td>
									<td align="right">实际交付日期：</td>
									<td>
										<input class="easyui-datebox" name="landholddate" id="landholddate" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">获得土地总价(元)：</td>
									<td>
										<input class="easyui-validatebox" name="landmoney" id="landmoney" data-insert='p'/>					
									</td>
									<td align="right">宗地面积(平方米)：</td>
									<td>
										<input class="easyui-validatebox" name="landarea" id="landarea" data-insert='p'/>					
									</td>
								</tr>
								<tr>
									<td align="right">详细地址：</td>
									<td colspan="3">
										<input class="easyui-validatebox" name="landdetailaddress" id="landdetailaddress" data-insert='p'/>					
									</td>
								</tr>
								<tr>
								    <td colspan="4"  style="font-size: 15px;font-weight: bold;padding: 5px;">土地业务信息</td>
								</tr>
								<tr>
									<td align="right">转出计算机编码：</td>
									<td><input id="lessorid" class="easyui-validatebox" type="text" name="lessorid" data-insert='p'/></td>
									<td align="right">转出纳税人名称：</td>
									<td>
										<input id="lessortaxpayername" class="easyui-validatebox" type="text" name="lessortaxpayername" data-insert='p'/>
									</td>
								</tr>
								<tr>
									<td align="right">转入计算机编码：</td>
									<td><input id="lesseesid" class="easyui-validatebox" type="text" name="lesseesid" data-insert='p'/></td>
									<td align="right">转入纳税人名称：</td>
									<td>
										<input id="lesseestaxpayername" class="easyui-validatebox" type="text" name="lesseestaxpayername" data-insert='p'/>
									</td>
								</tr>
								<tr>
									<td align="right">协议书号：</td>
									<td><input id="protocolnumber" class="easyui-validatebox" type="text" name="protocolnumber" data-insert='p'/></td>
									<td align="right">土地用途：</td>
									<td>
										<input id="purpose" class="easyui-validatebox" type="text" name="purpose" data-insert='p'/>
									</td>
								</tr>
								<tr>
									<td align="right">获得土地日期：</td>
									<td><input id="holddate" class="easyui-datebox" type="text" name="holddate" data-insert='p'/></td>
									<td align="right">转移面积(平方米)：</td>
									<td>
										<input id="landarea" class="easyui-validatebox" type="text" name="landarea" data-insert='p'/>
									</td>
								</tr>
								<tr>
									<td align="right">转移总价(元)：</td>
									<td colspan="3"><input id="landamount" class="easyui-validatebox" type="text" name="landamount" data-insert='p'/></td>
								</tr>
					</table>
			</form>
	</div>
	<div id="houseinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产相关信息',collapsible:false,
	   minimizable:false,maximizable:false,closable:true,href:'viewhouse.jsp'" style="width:920px;height:500px;">
	</div>	
	<script>
	  function setFormValue(obj,elements){
		   for(var i = 0;i < elements.length;i++){
			   var input = $(elements[i]);
			   var elementsId = elements[i].id;
			   var value = obj[elementsId];
			   if(elementsId.indexOf('date') >= 0){
				   value = formatterDate(value);
			   }
			   if(input.hasClass("easyui-validatebox")){
					input.val(value);
			   }else if(input.hasClass("easyui-numberbox")){
				    input.numberbox('setValue',value);
			   }
			   else if(input.hasClass("easyui-datebox")){
					input.datebox('setValue',value);
			   }
			   else if(input.hasClass("easyui-combobox")){
					input.combobox('setValue',value);
			   }else{
				   input.val(value);
			   }
		   }
	   }
	  
      function showLandHistory(busid,businessnumber,businesscode){
	  if(businessnumber == '-1' || businesscode == '32'){
		  $('#baselanddetailform').form('clear');
		  var elements = $('#baselanddetailtable input[data-insert="p"]');
		  if(businessnumber == '-1'){
			  $.ajax({
					   type: "post",
					   async:false,
					   url: "/landavoidtaxmanager/selectsingleland.do",
					   data: {'estateid':busid},
					   dataType: "json",
					   success: function(jsondata){
						  if(jsondata.sucess){
							  setFormValue(jsondata.result,elements);
							   $('#baselanddetaildiv').window('open');
						  }
					   }
		      });
		  }else{
			   $.ajax({
					   type: "post",
					   async:false,
					   url: "/viewanalizy/getbusestate.do",
					   data: {'busid':busid},
					   dataType: "json",
					   success: function(data){
						  if(data){
							  setFormValue(data.baseEstate,elements);
							  $('#baselanddetaildiv').window('open');
						  }
					   }
		       });
		  }
	  }else{
		  $('#buslanddetailform').form('clear');
		  var elements = $('#buslanddetailtable input[data-insert="p"]');
		  $.ajax({
					   type: "post",
					   async:false,
					   url: "/viewanalizy/getbusestate.do",
					   data: {'busid':busid},
					   dataType: "json",
					   success: function(jsondata){
						  if(jsondata != null){
							  setFormValue(jsondata,elements);
							  $('#buslanddetaildiv').window('open');
						  }
					   }
		   });
	  }
  }
  function viewLandHistory(value,row,index){
	  var buscode = 'xd';
	  if($.trim(row.businesscode) != '')
		  buscode = row.businesscode;
	  var result =  "<a href=javascript:showLandHistory('"+row.busid+"','"+row.businessnumber+"','"+buscode+"')>土地业务详细信息</a>";
 	 return result;
  }
  function showHouseInfo(houseid){
	  $('#houseinfowindow').window({
		  href:'viewhouse.jsp?d='+new Date(),
		  onLoad:function(){
		     houseinfoLoaded(houseid);
		  }
	  });
	  $('#houseinfowindow').window('open');
  }
  function viewHouseInfo(value,row,index){
	  return "<a href=javascript:showHouseInfo('"+row.houseid+"')>房产信息</a>";
  }
  function afterLandLoaded(estateid){
	  var elements = $('#landinfowindow #baselandtable input[data-insert="p"]');
	      $.ajax({
					   type: "post",
					   async:false,
					   url: "/landavoidtaxmanager/selectsingleland.do",
					   data: {'estateid':estateid},
					   dataType: "json",
					   success: function(jsondata){
						  if(jsondata.sucess){
							  setFormValue(jsondata.result,elements);
						  }
					   }
		   });
        //获取应纳税信息、历史交易信息、房产信息
        var paramsArg = {};
	   paramsArg['estateid'] = estateid;
	   //加载应纳税
	    $.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/viewanalizy/getlandcomposite.do?d="+new Date(),
					  data: paramsArg,
					  dataType: "json",
					  success:function(data){
						  $('#landshouldtaxtable').datagrid('loadData',data.shouldTaxInfo);
						  $('#landhistorytable').datagrid('loadData',data.historyInfo);
						  $('#houseoflandtable').datagrid('loadData',data.houseInfo);
					  }
	    });
  }
  </script>
  </body>
</html>
