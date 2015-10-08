<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=request.getContextPath()%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/themes/icon.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/logout.css"/>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/tablen.css"/>
	<script src="<%=request.getContextPath()%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/tiles.js"></script>
    <script src="<%=request.getContextPath()%>/js/moduleWindow.js"></script>
	<script src="<%=request.getContextPath()%>/menus.js"></script>
	<script src="<%=request.getContextPath()%>/js/common.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js"></script>
	<script src="<%=request.getContextPath()%>/js/overlay.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.json-2.2.js"></script>
	<script src="<%=request.getContextPath()%>/js/json2.js"></script>
	<script src="<%=request.getContextPath()%>/locale/easyui-lang-zh_CN.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js"></script>
   	<script src="<%=request.getContextPath()%>/js/uploadmodal.js"></script> 
	<script src="<%=request.getContextPath()%>/js/datecommon.js"></script>
	
</head>
<body class="easyui-layout">  
<script>
	$(function(){
		$('#uniondetailgrid').datagrid({
			singleSelect:'true',
			fitColumns:'true',
			rownumbers:'true'
		});
	});
	


	function query(){
		var params = {};
		var fields =$('#userqueryform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		$.ajax({
		   type: "post",
		   url: "<%=request.getContextPath()%>/Userinfo/getUnioninfo2.do",
		   data: params,
		   dataType: "json",
		   success: function(jsondata){
				jsondata.birthday=formatterDate(jsondata.birthday);
				$('#sotremainform').form('load',jsondata);
				for(var i=0;i<jsondata.memberlist.length;i++){
					jsondata.memberlist[i].birthday = formatterDate(jsondata.memberlist[i].birthday);
				}
				$('#uniondetailgrid').datagrid('loadData',jsondata.memberlist);
		   }
		});
	}
	var genderdata = [{label:'01',name:'男'},{label:'02',name:'女'}];
	function formatgender(row){
		for(var i=0; i<genderdata.length; i++){
			if (genderdata[i].label == row) return genderdata[i].name;
		}
		return row;
	}
	</script>
	<div class="easyui-panel" title="" >
	<form id="userqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					
					<tr>
						<td align="right">合作医疗证号：</td>
						<td>
							<input id="union_id" class="easyui-validatebox" type="text" style="width:200px" name="union_id" />
						</td>
						<td align="right">卡号：</td>
						<td>
							<input id="card_id" class="easyui-validatebox" type="text" style="width:200px" name="card_id"/>
						</td>
						
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="###" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
					<!-- <a href="#" class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
			</div>
	</form>
	<form id="sotremainform" method="post">
		<div title="登记信息" data-options="" style="overflow:auto">
			<table  width="100%" class="table table-bordered">
					<input id="user_id"  type="hidden" name="user_id"/>	
					<tr>
						<td align="right">合作医疗证号：</td>
						<td>
							<input class="easyui-validatebox" name="union_id" id="union_id" style="width:200px;" data-options="required:false"/>					
						</td>
						<td align="right">卡号：</td>
						<td>
							<input class="easyui-validatebox" name="card_id" id="card_id" style="width:200px;"  data-options="required:false"/>					
						</td>
					</tr>
					<tr>
						<td align="right">户主名称：</td>
						<td><input id="user_name" class="easyui-validatebox" type="text" style="width:200px;" name="user_name" data-options="required:false"/></td>
						<td align="right">性别：</td>
						<td>
							<select id="gender" class="easyui-combobox" name="gender" style="width:200px;" data-options="required:false" editable="false">
								<option value="01">男</option>
								<option value="02">女</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">出生日期：</td>
						<td>
							<input id="birthday" class="easyui-datebox" style="width:200px" name="birthday" data-options="required:false"/>			
						</td>
						<td align="right">联系电话：</td>
						<td>
							<input class="easyui-validatebox" name="telephone" id="telephone" style="width:200px;" data-options="required:false"/>
						</td>
					</tr>
					<tr>
						<td align="right">身份证号：</td>
						<td>
							<input class="easyui-validatebox" name="idnumber" id="aidnumberge" style="width:200px;" data-options="required:false"/>				
						</td>
						<td align="right">所属行政区：</td>
						<td>
							<select id="org_code" class="easyui-combotree" style="width:200px;"  data-options="required:false" name="org_code"></select>
						</td>
					</tr>
					<tr>
						<td align="right">小组：</td>
						<td>
							<input class="easyui-validatebox" name="team" id="address" style="width:200px;" data-options="required:false"/>
						</td>
						<td align="right">人员属性：</td>
						<td>
							<select id="role_id" class="easyui-combobox" name="role_id" style="width:200px;" data-options="required:false" editable="false">
								<option value="10" selected>一般人员</option>
								<option value="20">五保</option>
								<option value="30">低保</option>
								<option value="40">优扰</option>
								<option value="50">残疾</option>
								<option value="60">残疾</option>
							</select>
						</td>
					</tr>
				</table>
			
		</div>
	</form>
		<div title="" style="overflow:auto" data-options="
						">
					<table id="uniondetailgrid" class="easyui-datagrid"
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'user_id',width:80,align:'center',hidden:'true'"></th>
								<th data-options="field:'user_name',width:120,align:'center',editor:{type:'text',options:{required:false}}">人员名称</th>
								<th data-options="field:'gender',width:50,align:'center',formatter:formatgender,editor:{type:'combobox',options:{valueField:'label',textField: 'name',data:genderdata}}">性别</th>
								<th data-options="field:'birthday',width:50,align:'center',editor:{type:'datebox',options:{required:false}}">出生日期</th>
								<th data-options="field:'leader_relation',width:150,align:'center',editor:{type:'text',options:{required:false}}">与户主关系</th>
							</tr>
						</thead>
					</table>
		</div>
	</div>
</body>
</html>