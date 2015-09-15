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

    <script>
	
    var managerLink = new OrgLink("9");
    managerLink.sendMethod = true;
    
	$(function(){
		  
		    managerLink.loadData();
		    $('#modeldefinegrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				pageList:[15],
				pageSize:15,
				rowStyler:settings.rowStyle
			});
			
			var p = $('#modeldefinegrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
		});
	
		function query(){
			var params = {};
			var fields =$('#modelqueryform').serializeArray();
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			var opts = $('#modeldefinegrid').datagrid('options');
			opts.url = '/modeldefine/querymodel.do?d='+new Date();
			$('#modeldefinegrid').datagrid('load',params); 
			$('#modelquerywindow').window('close');			
		}
		function openQuery(){
			$('#modelquerywindow').window('open');
		}
		
		
		
		var modelId = null;
		var operType = null;  //0表示新增，1表示修改
		
		function clearPanel(){
			$('#modelname').val('');
			$('#totalgrid').datagrid('loadData',[]);
			var oCk = $("#modeladdwindow").find("input[type='checkbox']");
			for(var i = 0;i < oCk.length;i++){
				oCk[i].checked = false;
			}
		}
		//add begin............................
		function openAdd(){
			$('#modeladdwindow').window({
				title:"模板新增"
			});
			$('#modeladdwindow').window('open');
			
			//设置值
			clearPanel();
			operType = 0;
		}
		function saveData(){
			var oModelName = $('#modelname').val();
			if(oModelName == null || oModelName == ""){
				$.messager.alert('提示消息','请录入模板名称!','info');
				$('#modelname').focus();
				return;
			}
			var rows = $('#totalgrid').datagrid('getRows');
			if(!rows || rows.length == 0){
				$.messager.alert('提示消息','请选择展现内容，再进行查询!','info');
				return;
			}
			
			//进行新增
			
			var groupStr = '';
			for(var i = 0;i < rows.length;i++){
				var row = rows[i];
				groupStr += row.key+',';
			}
			groupStr = groupStr.substring(0,groupStr.length-1);

			var subtotalStr = '';
			var oCk = $("#totaldiv").find("input[type='checkbox']");
			for(var i = 0 ; i < oCk.length;i++){
				if(oCk[i].checked){
					subtotalStr = subtotalStr + oCk[i].value+','
				}
			}
			if(subtotalStr != ''){
				subtotalStr = subtotalStr.substring(0,subtotalStr.length - 1);
			}
			
			var groupAry = groupStr.split(',');
			var subtotalAry = new Array();
			if(subtotalStr)
				subtotalAry = subtotalStr.split(',');
			
			
            var tempAry = new Array();
			for(var i = 0;i < subtotalAry.length;i++){
				tempAry.push(subtotalAry[i]);
			}
			for(var i = 0;i < groupAry.length;i++){
				var gStr = groupAry[i];
				var have = false;
				for(var j = 0;j < subtotalAry.length;j++){
					var sStr = subtotalAry[j];
					if(gStr == sStr){
						have = true;
						break;
					}
				}
				if(!have){
					tempAry.push(gStr);
				}
			}
			//进行新增
			var params = {};
			var selectField = tempAry.join(',');
			var subtotalField = subtotalAry.length == 0 ? '' : subtotalAry.join(',');
			params['modelname'] = oModelName;
			params['totalitem'] = selectField;
			params['subtotalitem'] = subtotalField;
			params['modelid'] = modelId;
			
			var url = '';
			var sucessMsg = "";
			var failMsg = "";
			if(operType === 0){
				url = "/modeldefine/addmodel.do?date="+new Date(),
				sucessMsg = "添加模板成功";
				failMsg = "添加模板失败";
				
			}else if(operType === 1){
				url = "/modeldefine/updatemodel.do?date="+new Date(),
				sucessMsg = "修改模板成功";
				failMsg = "修改模板失败";

			}
			
			$.ajax({
				   type: "get",
				   async:false,
				   url: url,
				   data:params,
				   dataType: "json",
				   success: function(jsondata){
					   if(jsondata.sucess){
						   $.messager.alert('提示消息',sucessMsg,'info',function(){
						       $('#modeladdwindow').window('close');
						       query();
					        });
					   }else{
						    $.messager.alert('提示消息',failMsg,'error');
					   }
					   
					   
				   }
			     });
		}
		function addCancel(){
			$('#modeladdwindow').window('close');
		}
		function changeCondition(cb){
			var key = cb.value;
			if(cb.checked){
			    var value = $(cb).parent().text();
			    $('#totalgrid').datagrid('appendRow',{'ckd':true,'key':key,'value':value});
			}else{
                var rows = $('#totalgrid').datagrid('getRows');	
                for(var i = 0;i < rows.length;i++){
                	var row = rows[i];
                	if(key == row.key){
                		 $('#totalgrid').datagrid('deleteRow',i);
                		 break;
                	}
                }
			}
		}
		//add end...............................
		
		//delete begin
		function deleteModel(){
			var oCk = $("#modelDiv").find("input[type='checkbox']");
			var modelIds = '';
			for(var i = 1;i < oCk.length;i++){
				if(oCk[i].checked){
					modelIds += oCk[i].value+',';
				}
			}
			if(modelIds == ''){
				$.messager.alert('提示消息','请选择需要删除的模板!','error');
				return;
			}
			if(modelIds){
				modelIds = modelIds.substring(0,modelIds.length - 1);
			}
			$.messager.confirm('删除模板','你确定要删除这些模板吗？',function(r){   
			    if (r){   
			      $.ajax({
					   type: "get",
					   async:false,
					   url: "/modeldefine/deletemodel.do?date="+new Date(),
					   data:{"modelids":modelIds},
					   dataType: "json",
					   success: function(jsondata){
						   if(jsondata.sucess){
							   $.messager.alert('提示消息','删除模板成功!','info',function(){
							       query();
						        });
						   }else{
							    $.messager.alert('提示消息','删除模板失败!','error');
						   }
					   }
			       });
			    }   
			});  
			
			
		}
		//delete end
		
		//edit begin
		
		
		function openEdit(){
			var oCk = $("#modelDiv").find("input[type='checkbox']");
			modelId = '';
			var num = 0;
			for(var i = 1;i < oCk.length;i++){
				if(oCk[i].checked){
					modelId = oCk[i].value;
					num++;
				}
			}
			if(num != 1){
				$.messager.alert('提示消息','请选择需要编辑的模板，有且只能选择一条!','info');
				return;
			}
			clearPanel();
			operType = 1;
			$('#modeladdwindow').window({
				title:"模板修改"
			});
			$.ajax({
				   type: "get",
				   async:false,
				   url: "/modeldefine/getmodel.do?date="+new Date(),
				   data:{"modelid":modelId},
				   dataType: "json",
				   success: function(jsondata){
					   if(jsondata.sucess){
						   var modelObj = jsondata.result;
						   var modelName = modelObj.modelname;
						   var totalItem = modelObj.totalitem;
						   var subtotalItem = modelObj.subtotalitem;
						   $('#modelname').val(modelName);
						   
						   
						   
						   var items = totalItem.split(",");
						   var oGroupCk = $("#modeladdwindow").find("input[type='checkbox']");
						   for(var i = 0;i < oGroupCk.length;i++){
							   var ck = oGroupCk[i];
							   ck.checked = false;
						   }
						   for(var j = 0;j < items.length;j++){
							   for(var i = 0;i < oGroupCk.length;i++){
								   var ck = oGroupCk[i];
								   if(ck.checked)
									   continue;
							       var ckValue = ck.value+',';
							       var itemValue = items[j]+',';
							       if(ckValue.indexOf(itemValue) != -1){
							    	   ck.checked = true;
							    	   changeCondition(ck);
							       }
							   }
						   }
						   
						   oCk = $("#totaldiv").find("input[type='checkbox']");
						   for(var i = 0 ; i < oCk.length;i++){
								var v = oCk[i].value;
								if(subtotalItem.indexOf(v) != -1){
									oCk[i].checked = true;
								}
						   }
						   $('#modeladdwindow').window('open');
						   
					   }else{
						    $.messager.alert('提示消息','获取模板失败!','error');
					   }
				   }
			 });
			
		}
		//edit end

		function addCheckBox(value,row,index){
			var result = "";
			result = "<input type='checkbox' value='"+row.key+"' />";
			return result;
		}
		function exit(){
			var oIframes = parent.$("iframe");
			var currentUrl = "/tdgs/shouldtaxgather/modeldefinepage.jsp";
			for(var i = 0;i < oIframes.length;i++){
				var oSrc =  oIframes.get(i).src;
				if(oSrc.indexOf(currentUrl) != -1){
					var oDiv = $(oIframes.get(i)).parent().parent().parent();
					var oId = oDiv[0].id;
				    parent.$('#'+oId).dialog('close');
				}
			}
		}
		
		
	</script>
</head>
<body>
    <div id="modelDiv">
    <form id="modeldefineform" method="post">
	<table id='modeldefinegrid' class="easyui-datagrid" style="width:1320px;height:560px;overflow: scroll;"
			data-options="iconCls:'icon-edit',toolbar:'#tb',pageList:[15],rowStyler:settings.rowStyle">
		<thead>
			<tr>
			    <th data-options="field:'modelid',width:50,align:'center',checkbox:true,editor:{type:'checkbox'}"></th>
			    <th data-options="field:'modelname',width:300,align:'center',editor:{type:'validatebox'}">模板名称</th>
				<th data-options="field:'taxorgsupname',width:120,align:'center',editor:{type:'validatebox'}">市级机关</th>
				<th data-options="field:'taxorgname',width:120,align:'center',editor:{type:'validatebox'}">县级机关</th>
				<th data-options="field:'taxempname',width:120,align:'center',editor:{type:'validatebox'}">录入人</th>
			</tr>
		</thead>
	</table>
    </form>
	<div id="tb" style="height:auto">
		<div style="height:25px;">
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openAdd()">新增</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openEdit()">修改</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteModel()">删除</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true" onclick="exit();">退出</a>
		</div>
	</div>
	
	</div>
	<div id="modelquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'模板查询条件',
	collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:640px;height:110px;">
			<form id="modelqueryform" method="post" >
			    <input type="hidden" name="status" id="status" value="1"/>
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
					
					<tr style="display: none;">
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" style="display:none;" name="taxdeptcode" id="taxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">专管员：</td>
						<td>
							<input class="easyui-combobox" style="display:none;" name="taxmanagercode" id="taxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
				</table>
			</form>
			
		<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
		</div>
	</div>
	<div id="modeladdwindow" class="easyui-window" data-options="border:false,closed:true,modal:true,title:'模板新增',
	 collapsible:false,minimizable:false,maximizable:false,closable:true" 
	style="width:640px;height:355px;">
	    <div class="easyui-panel" style="width:620px;margin-top: 10px;" data-options="border:false">
	       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	              模板名称：<input align="left" id="modelname" class="easyui-textbox" type="text" name="modelname" size="40"/>
	    </div>
		<div class="easyui-panel" id="checkDiv" style="width:620px;" data-options="border:false">
			<form id="modeladdform" method="post">
				<table id="addtable" width="100%"  cellpadding="10" cellspacing="0">
					<tr>
						<td align="left">
						    <div class="easyui-panel" style="width:300px;height: 195px;" >
						       <table>
						          
						          <tr>
						             <td align="left" style="width:120px;height: 30px;">
						                 <span><input type="checkbox" id="cbTaxType" name="cbTaxType" value="taxtypecode,taxtypename" onclick="changeCondition(this)"/>税种</span>
						            </td>
						            <td align="left" style="width:120px;height: 30px;">
						                 <input type="checkbox" id="cbTax" name="cbTax" value="taxcode,taxname" onclick="changeCondition(this)"/>税目
						            </td>
						          </tr>
						          <tr>
						             <td align="left" style="width:120px;height: 30px;">
						                 <input type="checkbox" id="cbTaxOrg" name="cbTaxOrg" value="taxorgcode,taxorgname" onclick="changeCondition(this)"/>区县税务机关
						            </td>
						            <td align="left" style="width:120px;height: 30px;">
						                 <input type="checkbox" id="cbTaxDept" name="cbTaxDept" value="taxdeptcode,taxdeptname" onclick="changeCondition(this)"/>主管税务机关
						            </td>
						          </tr>
						          <tr>
						             <td align="left" style="width:120px;height: 30px;">
						                 <input type="checkbox" id="cbTaxManager" name="cbTaxManager" value="taxmanagercode,taxmanagername" onclick="changeCondition(this)"/>税收管理员
						            </td>
						            <td align="left" style="width:120px;height: 30px;">
						                 <input type="checkbox" id="cbTaxpayerid" name="cbTaxpayerid" value="taxpayerid,taxpayername" onclick="changeCondition(this)"/>纳税人
						            </td>
						          </tr>
						          <tr>
						             <td align="left" style="width:120px;height: 30px;">
						                 <input type="checkbox" id="cbTaxyear" name="cbTaxyear" value="taxyear" onclick="changeCondition(this)"/>所属期年份
						            </td>
						            <td align="left" style="width:120px;height: 30px;">
						                 <input type="checkbox" id="cbTaxyearMonth" name="cbTaxyearMonth" value="taxyearmonth" onclick="changeCondition(this)"/>所属期月份
						            </td>
						          </tr>
						       </table>
						    </div>
						 </td>
						<td align="left">
						   <div id="totaldiv">
								<table id='totalgrid' class="easyui-datagrid" style="width:270px;height:195px;overflow: scroll;"
			                              data-options="iconCls:'icon-edit'">
			                         <thead>
			                          <th data-options="field:'ckd',width:100,align:'center',formatter:addCheckBox">小计条件</th>
			                          <th data-options="field:'key',hidden:true,width:100,align:'center',editor:{type:'validatebox'}">key值</th>
			                          <th data-options="field:'value',width:135,align:'center',editor:{type:'validatebox'}">统计条件</th>
			                          </thead>
			                   </table>
							</div>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div style="text-align:center;padding:10px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveData()">保存</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="addCancel()">取消</a>
		</div>
	</div>
</body>
</html>