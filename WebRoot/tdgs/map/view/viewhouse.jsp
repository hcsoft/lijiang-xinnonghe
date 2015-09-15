<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>房产相关信息</title>
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
  <body style="overflow:hidden" >
          <div id="esatediv" style="width:100%; height:480px;overflow:hidden;">
	       <div id="housetabs" class="easyui-tabs" style="width:100;height:480px;">  
                <div title="房产基本信息" data-options="closable:false" style="padding:5px;">  
                  <form id="basehouseform" name="basehouseform">
			      <table id="basehousetable" width="100%"  cellpadding="5" cellspacing="0">
					<tr>
					    <td align="right">计算机编码：</td>
						<td>
							<input id="taxpayerid" class="easyui-validatebox" name="taxpayerid"  data-insert="p"/>				
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" name="taxpayername" data-insert="p"/>			
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-validatebox"  id="housesourcename"  name="housesourcename" data-insert="p"/>	
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="housearea"  name="housearea"  data-insert="p"/>
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-validatebox"  id="countrytown"  name="countrytown" data-insert="p"/>	
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="belongtownsname"  name="belongtownsname"  data-insert="p"/>
						</td>
					</tr>
					<tr>
						<td align="right">投入使用日期：</td>
						<td>
							<input id="usedate" class="easyui-datebox" name="usedate" data-insert="p"/>	
						</td>
						<td align="right">详细地址：</td>
						<td>
							<input class="easyui-validatebox"  id="detailaddress"  name="detailaddress" data-insert="p"/>	
						</td>
					</tr>
					<tr>
						<td align="right">房产建筑安装成本：</td>
						<td>
							<input class="easyui-validatebox"  id="buildingcost"  name="buildingcost" data-insert="p"/>
						</td>
						<td align="right">设备价款：</td>
						<td>
							<input class="easyui-validatebox"  id="devicecost"  name="devicecost" data-insert="p"/>
						</td>
					</tr>
					<tr>
						<td align="right">房产证类型：</td>
						<td>
							<input class="easyui-validatebox"  id="housecertificatetypename"  name="housecertificatetypename" data-insert="p"/>				
						</td>
						<td align="right">房产证号：</td>
						<td>
							<input id="housecertificate" class="easyui-validatebox" type="text" name="housecertificate" data-insert="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">填发日期：</td>
						<td>
							<input id="housecertificatedate" class="easyui-datebox" type="text" name="housecertificatedate" data-insert="p"/>					
						</td>
						<td align="right">幢号：</td>
						<td>
							<input id="buildingnumber" class="easyui-validatebox"  name="buildingnumber" data-insert="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">结构：</td>
						<td>
							<input id="housestructure" class="easyui-validatebox"  name="housestructure" data-insert="p"/>					
						</td>
						<td align="right">房屋总层数：</td>
						<td>
							<input class="easyui-numberbox"  id="sumplynumber"  name="sumplynumber" data-insert="p" />					
						</td>
					</tr>
					<tr>
						<td align="right">所在层数：</td>
						<td>
							<input class="easyui-numberbox"  id="plynumber"  name="plynumber" data-insert="p" />					
						</td>
						<td align="right">设计用途：</td>
						<td>
							<input class="easyui-validatebox"  id="designapplication"  data-insert="p" />					
						</td>
					</tr>
					<tr>
					    <td align="right">建房注册号：</td>
						<td>
							<input id="registrationnumber" class="easyui-validatebox" type="text" name="registrationnumber" data-insert="p" />					
						</td>
						<td align="right">权属性质：</td>
						<td>
							<input class="easyui-validatebox"  id="natureofproperty"  name="natureofproperty" data-insert="p" />					
						</td>
					</tr>
				</table>
				</form>
			    </div>
			    <div title="应纳税信息" data-options="closable:false" style="overflow:auto;padding:5px;">  
					        <table id='houseshouldtaxtable' class="easyui-datagrid" style="width:99;height:435px;overflow: scroll;"
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
					    <div title="房产历史交易" data-options="closable:false" style="padding:5px;">  
					         <table id='househistorytable' class="easyui-datagrid" style="width:99;height:435px;overflow: scroll;"
									data-options="iconCls:'icon-edit',singleSelect:true">
								<thead>
								        <th data-options="field:'oper',formatter:viewBusHouseInfo,hidden:false,width:120,align:'center',editor:{type:'validatebox'}">查看详细信息</th>
								        <th data-options="field:'businessnumber',hidden:true,width:100,align:'center',editor:{type:'validatebox'}">业务编号</th>
								        <th data-options="field:'busid',width:100,hidden:true,align:'center',editor:{type:'validatebox'}">业务id</th>
								        <th data-options="field:'businesscode',width:100,hidden:true,align:'center',editor:{type:'validatebox'}">业务id</th>
										<th data-options="field:'businessname',width:100,align:'center',editor:{type:'validatebox'}">业务类型</th>
										<th data-options="field:'outtaxpayerid',width:120,align:'left',editor:{type:'validatebox'}">转出计算机编码</th>
										<th data-options="field:'outtaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转出纳税人名称</th>
										<th data-options="field:'intaxpayerid',width:120,align:'center',editor:{type:'validatebox'}">转入计算机编码</th>
										<th data-options="field:'intaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转入纳税人名称</th>
										<th data-options="field:'busdate',hidden:false,width:120,formatter:formatterDate,align:'center',editor:{type:'validatebox'}">实际交付土地日期</th>
										<th data-options="field:'busarea',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">交易面积</th>
										
								</thead>
							</table>      
					    </div>  
		   </div>
	</div>
	
	<div id="basehousedetaildiv" class="easyui-window easyui-layout" data-options="closed:true,modal:true,title:'房产信息',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:1150px;height:550px;overflow: hidden;">
	     <div data-options="region:'center'" style="width:450px;height:500px;overflow: hidden;"> 
                  <form id="basehousedetailform" name="basehousedetailform">
			      <table id="basehousedetailtable" width="100%"  cellpadding="5" cellspacing="0">
					<tr>
					    <td align="right">计算机编码：</td>
						<td>
							<input id="taxpayerid" class="easyui-validatebox" name="taxpayerid"  data-insert="p"/>				
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" name="taxpayername" data-insert="p"/>			
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-validatebox"  id="housesourcename"  name="housesourcename" data-insert="p"/>	
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="housearea"  name="housearea"  data-insert="p"/>
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-validatebox"  id="countrytown"  name="countrytown" data-insert="p"/>	
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="belongtownsname"  name="belongtownsname"  data-insert="p"/>
						</td>
					</tr>
					<tr>
						<td align="right">投入使用日期：</td>
						<td>
							<input id="usedate" class="easyui-datebox" name="usedate" data-insert="p"/>	
						</td>
						<td align="right">详细地址：</td>
						<td>
							<input class="easyui-validatebox"  id="detailaddress"  name="detailaddress" data-insert="p"/>	
						</td>
					</tr>
					<tr>
						<td align="right">房产建筑安装成本：</td>
						<td>
							<input class="easyui-validatebox"  id="buildingcost"  name="buildingcost" data-insert="p"/>
						</td>
						<td align="right">设备价款：</td>
						<td>
							<input class="easyui-validatebox"  id="devicecost"  name="devicecost" data-insert="p"/>
						</td>
					</tr>
					<tr>
						<td align="right">房产证类型：</td>
						<td>
							<input class="easyui-validatebox"  id="housecertificatetypename"  name="housecertificatetypename" data-insert="p"/>				
						</td>
						<td align="right">房产证号：</td>
						<td>
							<input id="housecertificate" class="easyui-validatebox" type="text" name="housecertificate" data-insert="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">填发日期：</td>
						<td>
							<input id="housecertificatedate" class="easyui-datebox" type="text" name="housecertificatedate" data-insert="p"/>					
						</td>
						<td align="right">幢号：</td>
						<td>
							<input id="buildingnumber" class="easyui-validatebox"  name="buildingnumber" data-insert="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">结构：</td>
						<td>
							<input id="housestructure" class="easyui-validatebox"  name="housestructure" data-insert="p"/>					
						</td>
						<td align="right">房屋总层数：</td>
						<td>
							<input class="easyui-numberbox"  id="sumplynumber"  name="sumplynumber" data-insert="p" />					
						</td>
					</tr>
					<tr>
						<td align="right">所在层数：</td>
						<td>
							<input class="easyui-numberbox"  id="plynumber"  name="plynumber" data-insert="p" />					
						</td>
						<td align="right">设计用途：</td>
						<td>
							<input class="easyui-validatebox"  id="designapplication"  data-insert="p" />					
						</td>
					</tr>
					<tr>
					    <td align="right">建房注册号：</td>
						<td>
							<input id="registrationnumber" class="easyui-validatebox" type="text" name="registrationnumber" data-insert="p" />					
						</td>
						<td align="right">权属性质：</td>
						<td>
							<input class="easyui-validatebox"  id="natureofproperty"  name="natureofproperty" data-insert="p" />					
						</td>
					</tr>
				</table>
				</form>
			</div>   
			<div data-options="region:'west'"  style="width:500px;height:500px;">  
		      <table id='landinfogridbyhouse' class="easyui-datagrid" style="width:99;height:500px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true">
				<thead>
				    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
					<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
					<th data-options="field:'taxpayername',width:215,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
					<th data-options="field:'estateserialno',width:100,align:'left',editor:{type:'validatebox'}">宗地编号</th>
					<th data-options="field:'landcertificatetypename',width:175,align:'left',editor:{type:'validatebox'}">土地证类型</th>
					<th data-options="field:'landcertificate',width:175,align:'center',editor:{type:'validatebox'}">土地证号</th>
					<th data-options="field:'locationtypename',width:175,align:'center',editor:{type:'validatebox'}">坐落地类型</th>
					<th data-options="field:'belongtocountryname',width:175,align:'center',editor:{type:'validatebox'}">所属村委会</th>
					<th data-options="field:'detailaddress',width:250,align:'center',editor:{type:'validatebox'}">详细地址</th>
					<th data-options="field:'holddate',width:120,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">交付日期</th>
					<th data-options="field:'landmoney',width:120,align:'center',editor:{type:'validatebox'}">土地总价</th>
					<th data-options="field:'landarea',width:120,align:'center',editor:{type:'validatebox'}">土地面积</th>
					<th data-options="field:'landunitprice',width:120,align:'center',editor:{type:'validatebox'}">土地单价</th>
				</thead>
			</table>
		    </div> 
		</div>

		<div id="bushousedetaildiv" class="easyui-window easyui-layout" data-options="closed:true,modal:true,title:'房产所有权业务',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:1150px;height:550px;overflow: hidden;" data-close="autoclose">
		    <div data-options="region:'center'" style="width:450px;height:500px;overflow: hidden;">  
		       <form id="bushousedetailform" method="post">
				<table id="bushousedetailtable" width="100%"  cellpadding="3" cellspacing="0">
				   <tr>
					     <td colspan="4"><fieldset><font color="blue" style="font-weight: bold;">房产信息</font></fieldset></td>
					</tr>
					<tr>
					    <td align="right">转出计算机编码：</td>
						<td>
							<input id="lessorid" class="easyui-validatebox" name="lessorid"  readonly="true"  data-out="p"/>
						</td>
						
						<td align="right">转出纳税人名称：</td>
						<td>
							<input id="lessortaxpayername" class="easyui-validatebox" name="lessortaxpayername" data-out="p"/>			
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-validatebox"  id="housesourcename"  name="housesourcename" data-in="p"/>	
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="housearea"  name="housearea" data-in="p"/>
						</td>
					</tr>
					<tr>
						<td align="right">房产原值：</td>
						<td>
							<input class="easyui-validatebox"  id="housetaxoriginalvalue"  name="housetaxoriginalvalue" data-in="p"/>
						</td>
						<td align="right">投入使用日期：</td>
						<td>
							<input id="usedate" class="easyui-datebox" name="usedate"  data-in="p"/>	
						</td>
					</tr>
					<tr>
						<td align="right">详细地址：</td>
						<td>
							<input class="easyui-validatebox"  id="detailaddress"  name="detailaddress" data-in="p"/>	
						</td>
						<td align="right">所属村委会：</td>
						<td>
							<input class="easyui-validatebox"  id="belongtownsname"  name="belongtownsname" data-in="p"/>	
						</td>
					</tr>
					<tr>
					     <td colspan="4"><fieldset><font color="blue" style="font-weight: bold;">房产转移信息</font></fieldset></td>
					</tr>					
					<tr>
						<td align="right">转入计算机编码：</td>
						<td>
							<input class="easyui-validatebox"  id="lesseesid"  name="lesseesid" data-out="p"/>				
						</td>
						<td align="right">转入纳税人名称：</td>
						<td>
							<input class="easyui-validatebox"  id="lesseestaxpayername"  name="lesseestaxpayername" data-out="p"/>				
						</td>
					</tr>
					<tr>
						<td align="right">转移建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="housearea"  name="housearea"  data-out="p"/>				
						</td>
						<td align="right">转移总价：</td>
						<td>
							<input class="easyui-validatebox"  id="houseamount"  name="houseamount" data-out="p"/>				
						</td>
					</tr>
					<tr>
						
						<td align="right">投入使用日期：</td>
						<td>
							<input id="usedate" class="easyui-datebox" name="usedate"  data-out="p"/>				
						</td>
						<td align="right">房产用途：</td>
						<td>
							<input class="easyui-validatebox"  id="purpose"  data-out="p"/>					
						</td>
					</tr>
					<tr>
						
						<td align="right">转移协议号：</td>
						<td>
							<input id="protocolnumber" class="easyui-validatebox"  name="protocolnumber" />					
						</td>
					</tr>
				</table>
			</form>
		    </div>  
		    <div data-options="region:'west'"  style="width:500px;height:500px;">  
		      <table id='landinfoowngrid' class="easyui-datagrid" style="width:99;height:500px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[8],toolbar:'#selectlandtb'">
				<thead>
				    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
					<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
					<th data-options="field:'taxpayername',width:215,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
					<th data-options="field:'estateserialno',width:100,align:'left',editor:{type:'validatebox'}">宗地编号</th>
					<th data-options="field:'landcertificatetypename',width:175,align:'left',editor:{type:'validatebox'}">土地证类型</th>
					<th data-options="field:'landcertificate',width:175,align:'center',editor:{type:'validatebox'}">土地证号</th>
					<th data-options="field:'locationtypename',width:175,align:'center',editor:{type:'validatebox'}">坐落地类型</th>
					<th data-options="field:'belongtocountryname',width:175,align:'center',editor:{type:'validatebox'}">所属村委会</th>
					<th data-options="field:'detailaddress',width:250,align:'center',editor:{type:'validatebox'}">详细地址</th>
					<th data-options="field:'holddate',width:120,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">交付日期</th>
					<th data-options="field:'landmoney',width:120,align:'center',editor:{type:'validatebox'}">土地总价</th>
					<th data-options="field:'landarea',width:120,align:'center',editor:{type:'validatebox'}">土地面积</th>
					<th data-options="field:'landunitprice',width:120,align:'center',editor:{type:'validatebox'}">土地单价</th>
				</thead>
			</table>
		    </div> 
	</div>
	
	<div id="hirehousedetaildiv" class="easyui-window easyui-layout" data-options="closed:true,modal:true,title:'房产使用权业务',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:700px;height:550px;overflow: hidden;" data-close="autoclose">
		    <div data-options="region:'center'" style="width:450px;height:500px;overflow: hidden;">  
		       <form id="hirehousedetailform" method="post">
				<table id="hirehousedetailtable" width="100%"  cellpadding="3" cellspacing="0">
				  <tr>
					     <td colspan="4"><fieldset><font color="blue" style="font-weight: bold;">房产信息</font></fieldset></td>
					</tr>
					<tr>
					    <td align="right">出租计算机编码：</td>
						<td>
							<input id="lessorid" class="easyui-validatebox" name="lessorid"  readonly="true" data-out="p"/>
						</td>
						
						<td align="right">出租纳税人名称：</td>
						<td>
							<input id="lessortaxpayername" class="easyui-validatebox" name="lessortaxpayername" data-out="p"/>				
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-validatebox"  id="housesourcename"  name="housesourcename" data-in="p"/>	
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="housearea"  name="housearea" data-in="p">
						</td>
					</tr>
					<tr>
						<td align="right">房产原值：</td>
						<td>
							<input class="easyui-validatebox"  id="housetaxoriginalvalue"  name="housetaxoriginalvalue" data-in="p"/>
						</td>
						<td align="right">投入使用日期：</td>
						<td>
							<input id="usedate" class="easyui-validatebox" name="usedate" data-in="p"/>	
						</td>
					</tr>
					<tr>
						<td align="right">详细地址：</td>
						<td>
							<input class="easyui-validatebox"  id="detailaddress"  name="detailaddress" data-in="p"/>	
						</td>
						<td align="right">所属村委会：</td>
						<td>
							<input class="easyui-validatebox"  id="belongtownsname"  name="belongtownsname" data-in="p"/>	
						</td>
					</tr>
					<tr>
					     <td colspan="4"><fieldset><font color="blue" style="font-weight: bold;">房产转移信息</font></fieldset></td>
					</tr>					
					<tr>
						<td align="right">承租计算机编码：</td>
						<td>
							<input class="easyui-validatebox"  id="lesseesid"  name="lesseesid" data-out="p"/>				
						</td>
						<td align="right">承租纳税人名称：</td>
						<td>
							<input class="easyui-validatebox"  id="lesseestaxpayername"  name="lesseestaxpayername" data-out="p"/>				
						</td>
					</tr>
					<tr>
						<td align="right">转移建筑面积：</td>
						<td>
							<input class="easyui-numberbox"  id="housearea"  name="housearea" data-out="p"/>				
						</td>
						<td align="right">年租金：</td>
						<td>
							<input class="easyui-numberbox"  id="transmoney"  name="transmoney" data-out="p"/>				
						</td>
					</tr>
					<tr>
						<td align="right">租房起日期：</td>
						<td>
							<input id="limitbegin" class="easyui-datebox" name="limitbegin" data-out="p"/>		
						</td>
						<td align="right">租房止日期：</td>
						<td>
							<input id="limitend" class="easyui-datebox"  name="limitend" data-out="p"/>				
						</td>
					</tr>
					<tr>
						<td align="right">房产用途：</td>
						<td>
							<input class="easyui-validatebox"  id="purpose"  name="purpose" data-out="p"/>					
						</td>
						<td align="right">转移协议号：</td>
						<td>
							<input id="protocolnumber" class="easyui-validatebox"  name="protocolnumber" data-out="p" />					
						</td>
					</tr>
				</table>
			</form>
		    </div>  
	</div>
	<script>
	   function houseinfoLoaded(houseid){
		  $('#basehouseform').form('clear');
		  var elements = $('#basehousetable input[data-insert="p"]');
	
		  var paramsArg = {};
		   paramsArg['houseid'] = houseid;
		   //加载应纳税
		    $.ajax({
						  type: "get",
						  async:true,
						  cache:false,
						  url: "/viewanalizy/gethousecomposite.do?d="+new Date(),
						  data: paramsArg,
						  dataType: "json",
						  success:function(data){
							  $('#houseshouldtaxtable').datagrid('loadData',data.shouldTaxInfo);
							  $('#househistorytable').datagrid('loadData',data.historyInfo);
							   setFormValue(data.baseHouse,elements);
								  $('#housediv').window('open');
						  }
		    });
       }
	   
	  function setHouseFormValue(obj,elements){
		   for(var i = 0;i < elements.length;i++){
			   var input = $(elements[i]);
			   var elementsId = elements[i].id;
			   var value = obj[elementsId];
			   
			   if(elementsId.indexOf('date') >= 0 || elementsId.indexOf('limit') >=0){
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
	  //businessnumber=-1表示采集,businesscode=72
	  function showBusHouseInfo(busid,businessnumber,businesscode){
		  var elements = $('#basehousedetailtable input[data-insert="p"]');
		  if(businessnumber == '-1' || businesscode == '54'){
			  //basehousedetaildiv  landinfogridbyhouse
			  $('#basehousedetailform').form('clear');
			  if(businessnumber == '-1'){
				  $.ajax({
						   type: "post",
						   async:false,
						   url: "/viewanalizy/getbasehouse.do",
						   data: {'houseid':busid},
						   dataType: "json",
						   success: function(data){
							  setHouseFormValue(data,elements);
							  $('#basehousedetaildiv #landinfogridbyhouse').datagrid('loadData',data.estateList);
							  $('#basehousedetaildiv').window('open');
						   }
			     });
			  }else{
				   $.ajax({
						   type: "post",
						   async:false,
						   url: "/viewanalizy/getbushouse.do",
						   data: {'busid':busid},
						   dataType: "json",
						   success: function(data){
							  setHouseFormValue(data.baseHouse,elements);
							  $('#landinfogridbyhouse').datagrid('loadData',data.baseHouse.estateList);
							  $('#basehousedetaildiv').window('open');
						   }
			     });
				   
				   
			  }
			  
		  }else{
			  
			  $.ajax({
						   type: "post",
						   async:false,
						   url: "/viewanalizy/getbushouse.do",
						   data: {'busid':busid},
						   dataType: "json",
						   success: function(data){
							  if(data.ownflag == '2'){
								  var inelements = $('#hirehousedetailtable input[data-in="p"]');
		                          var outelements = $('#hirehousedetailtable input[data-out="p"]');
								  setHouseFormValue(data,outelements);
							      setHouseFormValue(data.baseHouse,inelements);
							      $('#hirehousedetaildiv').window('open');
							  }else{
								  var inelements = $('#bushousedetailtable input[data-in="p"]');
		                          var outelements = $('#bushousedetailtable input[data-out="p"]');
								  setHouseFormValue(data,outelements);
								  setHouseFormValue(data.baseHouse,inelements);
								  $('#landinfoowngrid').datagrid('loadData',data.estateList);
								  $('#bushousedetaildiv').window('open');
							  }
							  
						   }
			     });
		  }
	  }
      function viewBusHouseInfo(value,row,index){
	     return "<a href=javascript:showBusHouseInfo('"+row.busid+"','"+row.businessnumber+"','"+row.businesscode+"')>房产业务详细信息</a>";
      }
	 
  </script>
  </body>
</html>
