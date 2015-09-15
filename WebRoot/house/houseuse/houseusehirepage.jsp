<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
	<script src="<%=spath%>/js/dropdown.js"></script>
    <script src="<%=spath%>/js/tiles.js"></script>
    <script src="<%=spath%>/js/moduleWindow.js"></script>
	<script src="<%=spath%>/menus.js"></script>
	
	<script src="<%=spath%>/js/jquery.simplemodal.js"></script>
	<script src="<%=spath%>/js/overlay.js"></script>
	<script src="<%=spath%>/js/jquery.json-2.2.js"></script>
	<script src="<%=spath%>/js/json2.js"></script>
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>
	<script src="/js/datecommon.js"></script>	
	<script src="/js/common.js"></script>
	<script src="/js/widgets.js"></script>
    <script src="../house.js"></script>
    <script>
	<%
       String businesstype = request.getParameter("businesstype");
	   if(businesstype == null || businesstype.trim().equals("")){
		   businesstype = "61";
	   }
    %>
	
    var bustype = <%=businesstype%>;
    var modename = cacheMap.get(bustype).bustypename;
    
   // CommonUtils.enableAjaxProgressBar();
    
    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
    
	$(function(){
		   var managerLink = new OrgLink();
	       managerLink.sendMethod = false;
	       managerLink.loadData();
		   var firstDay = DateUtils.getYearFirstDay();
		   var lastDay = DateUtils.getCurrentDay();
		   $('#usedatebegin').datebox('setValue',firstDay);
		   $('#usedateend').datebox('setValue',lastDay);
		   //530122
		   
		   $('#houseownergrid').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			rowStyler:settings.rowStyle,
			pageList:[15],
			onDblClickRow:dbclickevent
		   });
		   var p = $('#houseownergrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
			$('#houseownerinfoform #businesstype').val(bustype);
			$('#houseownerinfoform #businesscode').val(bustype);
			
			
			$('#houseownerqueryform #businesstype').val(bustype);
			$('#houseownerqueryform #businesscode').val(bustype);

			$('#limitbegin').datebox({
				onSelect: function(date){
				    var str = DateUtils.getDay(date);
					$('#usedate').val(str);
				}
			});
			
			$('#modeladdinfo').linkbutton({   
			    text: modename  
			});
			$('#houseownerquerywindow').window({
				title:modename+'查询条件'
			});
	    });
	    function dbclickevent(rowindex,rowdata){
	    	detailoper(rowindex,rowdata,true)
	    }
	    function detailoper(rowindex,rowdata,hideoperbtn){
				   $('#houseownerinfoform').form('clear');
				   $.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/houseuse/get.do?d="+new Date(),
					  data: {'key':rowdata.busid,'businesstype':bustype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  var bushousebo = jsondata.result;
							  var basehousebo = bushousebo.baseHouse;
							  for(var p in bushousebo){
								   var value = bushousebo[p];
								   if(p.indexOf('date') >=0){
									   value = formatterDate(value);
								   }
								   var input = $('#houseownerinfoform #'+p);
								   if(!input)
									   continue;
								   if(input.hasClass("easyui-validatebox")){
										input.val(value);
								   }else if(input.hasClass("easyui-numberbox")){
									    input.numberbox('setValue',value);
								   }
								   else if(input.hasClass("easyui-datebox")){
									   value = formatterDate(value);
										input.datebox('setValue',value);
								   }
								   else if(input.hasClass("easyui-combobox")){
										input.combobox('setValue',value);
								   }else{
									   input.val(value);
								   }
							  }
							    basehousebo['lessorid'] = basehousebo['taxpayerid'];
							    basehousebo['lessortaxpayername'] = basehousebo['taxpayername'];
							    basehousebo['housearea_s'] = basehousebo['housearea'];
							    basehousebo['usedate_s'] = basehousebo['usedate'];
							    
							    $('#houseownerinfoform input[data-select="s"]').each(function(){
							    	var id = this.id;
							    	if(id){
							    		if(id in basehousebo){
							    			var value = basehousebo[id];
							    			if(id.indexOf('date') >= 0){
							    				value = formatterDate(value);
							    			}
							    			$(this).val(value);
							    		}
							    	}
							    });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
								  
							  });
						  }
					  }
			      });
				   if(hideoperbtn) {
					   $('#ownerOperDiv').hide();
					   $('#houseowneraddwindow').window({title:modename+'信息查看'});
				   }
				   else {
					   $('#ownerOperDiv').show();
					   $('#houseowneraddwindow').window({title:modename+'信息查看'});
				   }
				   
				   $('#houseowneraddwindow').window('open');
				   
	    }
		function query(){
			var params = {};
			var fields =$('#houseownerqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['pagesize'] = 15;
		    var opts = $('#houseownergrid').datagrid('options');
		    opts.url = '/houseuse/select.do?d='+new Date();
		    $('#houseownergrid').datagrid('load',params); 
		    $('#houseownerquerywindow').window('close');
		}
		function openQuery(){
			$('#houseownerquerywindow').window('open');
		}

		//新增房产所有权转移开始。。。。。 
		function openHouseOwnerAdd(){
			$('#houseownerinfoform').form('clear');
			$('#houseownerinfoform #businesstype').val(bustype);
			$('#houseownerinfoform #businesscode').val(bustype);
			$('#houseownerinfoform #houseamount').val("0");
			$('#ownerOperDiv').show();
			$('#houseowneraddwindow').window({title:modename+'信息增加'});
			$('#houseowneraddwindow').window('open');
		}
		function chooseHouseInfo(){
			WidgetUtils.showChooseBaseHouseInfo(function(rowIndex,rowData){
				   if(rowData){
					    rowData['lessorid'] = rowData['taxpayerid'];
					    rowData['lessortaxpayername'] = rowData['taxpayername'];
					    rowData['housearea_s'] = rowData['housearea'];
					    rowData['usedate_s'] = rowData['usedate'];
					    $('#houseownerinfoform input[data-select="s"]').each(function(){
					    	var id = this.id;
					    	if(id){
					    		if(id in rowData){
					    			var value = rowData[id];
					    			if(id.indexOf('date') >= 0){
					    				value = formatterDate(value);
					    			}
					    			$(this).val(value);
					    		}
					    	}
					    });
			      }
			},{
			    state:'1',
			    valid:'1'
			});
		}
		function chooseTaxpayer(){
			WidgetUtils.showChooseTaxpayerInfo(function(rowIndex,rowData){
				$('#houseownerinfoform #lesseesid').val(rowData.taxpayerid);
				$('#houseownerinfoform #lesseestaxpayername').val(rowData.taxpayername);
			});
		}
		function clearAllOwnerData(){
			$('#houseownerinfoform').form('clear');
		}
		function validateFormData(){
			var inputAry = $('#houseownerinfoform input[data-validate="p"]');
			result = CommonUtils.validateForm(inputAry);
			if(!result){
				return false;
			}
			return true;
		}
		function saveOwnerHouse(){
			var result = validateFormData();
			if(!result)
				return false;
			var params = {};
			var fields =$('#houseownerinfoform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});			
			var busid = $('#houseownerinfoform #busid').val();
			var operurl = "/houseuse/add.do?d="+new Date();
			var infomessage = '新增'+modename+'信息成功';
			if(busid){
				operurl = "/houseuse/update.do?d="+new Date();
				infomessage = '修改'+modename+'信息成功';
			}
			$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: operurl,
					  data: params,
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息',infomessage,'info',function(){
								  $('#houseowneraddwindow').window('close');
								  query();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			   });
		}
		//新增自建房结束
		
       //修改房产开始
       function openUpdate(){
    	   var row = $('#houseownergrid').datagrid('getSelected');
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要修改的'+modename+'信息!','info');
    		   return false;
    	   }
    	   if(row.state == '0'){
    		   detailoper(null,row,false);
    	   }else{
    		   $.messager.alert('提示消息','只有状态为初始状态的'+modename+'信息才能修改!','info');
    	   }
    	   
       }
	  
       function cancelHouse(){
    	   var row = $('#houseownergrid').datagrid('getSelected');
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要删除的'+modename+'信息!','info');
    		   return false;
    	   }
    	   $.messager.confirm('确认', '你确认删除当前的'+modename+'信息？', function(r){
				if (r){
					$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/houseuse/cancel.do?d="+new Date(),
					  data: {'key':row.busid,"businesstype":bustype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息','删除'+modename+'信息成功','info',function(){
								  query();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			        });
				}
			});
       }
       function checkHouse(checktype){
    	   var checkmsg = "";
    	   var confirmmsg = "";
    	   var url = "";
    	   if(checktype == '1'){
    		   checkmsg = '请选择需要审核的'+modename+'信息!';
    		   confirmmsg = "你确认审核当前的"+modename+"信息？";
    		   url = "/houseuse/check.do?d="+new Date();
    	   }else{
    		   checkmsg = '请选择需要取消审核的'+modename+'信息!';
    		   confirmmsg = "你确认取消审核当前的"+modename+"信息？";
    		   url = "/houseuse/uncheck.do?d="+new Date();
    	   }
    	   var row = $('#houseownergrid').datagrid('getSelected');
    	   if(row == null){
    		   $.messager.alert('提示消息',checkmsg,'info');
    		   return false;
    	   }
    	   $.messager.confirm('确认', confirmmsg, function(r){
				if (r){
					$.ajax({
					  type: "get",
					  async:true,
					  processbar:true,
					  cache:false,
					  url: url,
					  data: {'key':row.busid,"businesstype":bustype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息',jsondata.message,'info',function(){
								  query();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			        });
				}
			});
       }
		function getStateName(value,row,index){
			var state = row.state;
			if(state == "0")
				return "未审核";
			else if(state == "1")
				return "已审核";
			else if(state == "2")
				return "存在后续业务";
			else if(state == "3")
				return "已终审";
		}
		function exportExcel(){
			var params = {};
			var fields =$('#houseownerqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['propNames'] = 'statename,lessorid,lessortaxpayername,lesseesid,lesseestaxpayername,housearea,houseamount,limitbegin,limitend,purpose,protocolnumber';
			params['colNames'] = '状态,出租计算机编码,出租纳税人名称,承租计算机编码,承租纳税人名称,转移房产建筑面积,'+
                                 '转移总价,租房起日期,租房止日期,房产用途,转移协议号';
			params['modelName']=modename;
			
			CommonUtils.downloadFile("/houseuse/houseownerexport.do?date="+new Date(),params);
		}
		
	</script>
</head>
<body>
     <div class="easyui-layout" style="width:100%;height:570px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='houseownergrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
				        <th data-options="field:'busid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">业务主键</th>
					    <th data-options="field:'houseid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">房产主键</th>
						<th data-options="field:'statename',width:80,align:'center',formatter:getStateName,editor:{type:'validatebox'}">状态</th>
						<th data-options="field:'lessorid',width:100,align:'center',editor:{type:'validatebox'}">出租计算机编码</th>
						<th data-options="field:'lessortaxpayername',width:220,align:'left',editor:{type:'validatebox'}">出租纳税人名称</th>
						<th data-options="field:'lesseesid',width:100,align:'center',editor:{type:'validatebox'}">承租计算机编码</th>
						<th data-options="field:'lesseestaxpayername',width:220,align:'left',editor:{type:'validatebox'}">承租纳税人名称</th>
						
						<th data-options="field:'housearea',width:120,align:'center',editor:{type:'validatebox'}">转移房产建筑面积</th>
						<th data-options="field:'houseamount',width:150,align:'center',editor:{type:'validatebox'}">转移总价</th>
						<th data-options="field:'limitbegin',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">租房起日期</th>
						<th data-options="field:'limitend',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">租房止日期</th>
						<th data-options="field:'purpose',width:120,align:'center',editor:{type:'validatebox'}">房产用途</th>
						<th data-options="field:'protocolnumber',width:120,align:'center',editor:{type:'validatebox'}">转移协议号</th>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a id="modeladdinfo" class="easyui-linkbutton" data-options="iconCls:'icon-business1',plain:true" onclick="openHouseOwnerAdd()">使用权转移</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openUpdate()">修改</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="cancelHouse()">删除</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportExcel()">导出</a>
				<a style="display:none" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="checkHouse(1)">审核</a>
				<a style="display:none" class="easyui-linkbutton" data-options="iconCls:'icon-uncheck',plain:true" onclick="checkHouse(0)">取消审核</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">退出</a>
			</div>
		</div>
	</div>
	<div id="houseowneraddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产使用权转移登记',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:815px;height:435px;" data-close="autoclose">
		    <div id="housepanel" title="" data-options="selected:true" 
		    style="overflow:auto;padding:10px;">  
		       <form id="houseownerinfoform" method="post">
		       
		            <input type="hidden" id="businesstype" name="businesstype"/>
		            <input type="hidden" id="businesscode" name="businesscode"/>
		            <input type="hidden" id="busid" name="busid"/>
		            <input type="hidden" id="usedate" name="usedate"/>
		            <input type="hidden" id="landtaxarea" name="landtaxarea" value="0"/>
		            
		            <input type="hidden" id="houseid" name="houseid" data-select="s"/>
		            <input type="hidden" id="houseamount" name="houseamount" value="0"/>
				<table id="narjcxx1x" width="100%"  cellpadding="3" cellspacing="0">
				   <tr>
					     <td colspan="4"><fieldset><font color="blue" style="font-weight: bold;">房产信息</font></fieldset></td>
					</tr>
					<tr>
					    <td align="right">出租计算机编码：</td>
						<td>
							<input id="lessorid" class="easyui-validatebox" name="lessorid"  readonly="true" data-validate="p" data-select="s"/>
						</td>
						
						<td align="right">出租纳税人名称：</td>
						<td>
							<input id="lessortaxpayername" class="easyui-validatebox" name="lessortaxpayername" readonly="true" data-validate="p" data-select="s"/>	
							<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseHouseInfo()" 
							   style="color: blue;font-weight: bold;">选择房产</a>				
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-validatebox"  id="housesourcename"  name="housesourcename" readonly="true" data-select="s"/>	
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="housearea_s"  name="housearea_s" readonly="true" data-select="s"/>
						</td>
					</tr>
					<tr>
						<td align="right">房产原值：</td>
						<td>
							<input class="easyui-validatebox"  id="housetaxoriginalvalue"  name="housetaxoriginalvalue" readonly="true" data-select="s"/>
						</td>
						<td align="right">投入使用日期：</td>
						<td>
							<input id="usedate_s" class="easyui-validatebox" name="usedate_s" readonly="true" data-select="s"/>	
						</td>
					</tr>
					<tr>
						<td align="right">详细地址：</td>
						<td>
							<input class="easyui-validatebox"  id="detailaddress"  name="detailaddress" readonly="true" data-select="s"/>	
						</td>
						<td align="right">所属村委会：</td>
						<td>
							<input class="easyui-validatebox"  id="belongtownsname"  name="belongtownsname" readonly="true" data-select="s"/>	
						</td>
					</tr>
					<tr>
					     <td colspan="4"><fieldset><font color="blue" style="font-weight: bold;">房产转移信息</font></fieldset></td>
					</tr>					
					<tr>
						<td align="right">承租计算机编码：</td>
						<td>
							<input class="easyui-validatebox"  id="lesseesid"  name="lesseesid" readonly="true"/>				
						</td>
						<td align="right">承租纳税人名称：</td>
						<td>
							<input class="easyui-validatebox"  id="lesseestaxpayername"  name="lesseestaxpayername" data-validate="p"/>		
							<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseTaxpayer()" 
							   style="color: blue;font-weight: bold;">选择纳税人</a>				
						</td>
					</tr>
					<tr>
						<td align="right">转移建筑面积：</td>
						<td>
							<input class="easyui-numberbox"  id="housearea"  name="housearea" data-options="min:1,precision:2" data-validate="p"/>				
						</td>
						<td align="right">年租金：</td>
						<td>
							<input class="easyui-numberbox"  id="transmoney"  name="transmoney" data-options="min:0,precision:2" data-validate="p"/>				
						</td>
					</tr>
					<tr>
						<td align="right">租房起日期：</td>
						<td>
							<input id="limitbegin" class="easyui-datebox" name="limitbegin" data-validate="p"/>		
						</td>
						<td align="right">租房止日期：</td>
						<td>
							<input id="limitend" class="easyui-datebox"  name="limitend" data-validate="p"/>				
						</td>
					</tr>
					<tr>
						<td align="right">房产用途：</td>
						<td>
							<input class="easyui-validatebox"  id="purpose"  name="purpose"/>					
						</td>
						<td align="right">转移协议号：</td>
						<td>
							<input id="protocolnumber" class="easyui-validatebox"  name="protocolnumber" />					
						</td>
					</tr>
				</table>
			</form>
		    </div>  
	    <div style="text-align:center;padding:5px;height: 25px;" id="ownerOperDiv">  
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveOwnerHouse()">保存</a>
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="clearAllOwnerData()">清除所有数据</a>
	    </div>
	</div>
	
	
	<div id="houseownerquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产所有权转移查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;height:230px;" data-close="autoclose">
			<form id="houseownerqueryform" method="post">
			   <input type="hidden" id="businesstype" name="businesstype"/>
			   <input type="hidden" id="businesscode" name="businesscode"/>
				<table id="narjcxx" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">专管员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">出租方计算机编码：</td>
						<td><input id="lessorid" class="easyui-validatebox" type="text" name="lessorid"/></td>
						<td align="right">出租方纳税人名称：</td>
						<td>
							<input id="lessortaxpayername" class="easyui-validatebox" type="text" name="lessortaxpayername"/>
						</td>

					</tr>
					<tr>
						<td align="right">承租方计算机编码：</td>
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid"/></td>
						<td align="right">承租方纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername"/>
						</td>

					</tr>
					<tr>
						<td align="right">投入使用日期：</td>
						<td colspan="5">
							<input id="usedatebegin" class="easyui-datebox" name="usedatebegin"/>
						至
							<input id="usedateend" class="easyui-datebox"  name="usedateend"/>
						</td>
					</tr>
				</table>
			</form>
	    <div style="text-align:center;padding:5px;height: 25px;">  
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
	    </div>
	</div>
</body>
</html>