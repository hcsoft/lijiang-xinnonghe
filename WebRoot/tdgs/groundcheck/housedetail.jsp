<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

	<title>Complex Layout - jQuery EasyUI Demo</title>

	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<link rel="stylesheet" href="<%=spath%>/css/tablen.css"/>
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
</head>   
<body>
<script>
	$(function(){
		var row = $('#groundcheckgrid').datagrid('getSelected');
		if(type == 'query' || type == 'finalcheck'){
			$('#groundsavebutton').hide();
		}else{
			if(row.state=='0'){
				$('#groundsavebutton').show();
			}else{
				$('#groundsavebutton').hide();
			}
		}
		$.ajax({
		   type: "post",
		   url: "/GroundCheckServlet/gethousebus.do",
		   data: {busid:row.busid},
		   dataType: "json",
		   success: function(jsondata){
				$('#housedetailform').form('load',jsondata);
				if(jsondata.businesscode=='61'){
					$('#houseamount').val(jsondata.transmoney);
				}
		   }
		});
	});
	function savehousebus(){
		var row = $('#groundcheckgrid').datagrid('getSelected');
		var index = $('#groundcheckgrid').datagrid('getRowIndex',row);
		//alert(index);
		Load();
		var params = {};
		var fields =$('#housedetailform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		});
		params.bustype= row.bustype;
		//params.locationtype=$('#locationtype').value;
		//params.belongtowns=$('#belongtowns').value;
		//params.detailaddress=$('#detailaddress').value;
		$.ajax({
			type: "post",
			url: "/GroundCheckServlet/updatebus.do",
			data: params,
			dataType: "json",
			success: function(jsondata){
				//$('#groundcheckgrid').datagrid('reload');
				$('#housewindow').window('close');
				dispalyLoad();    
				$.messager.alert('返回消息','保存成功！');
				$('#groundcheckgrid').datagrid('selectRow',index);
			},error:function (data, status, e){ 
				dispalyLoad();  
				$.messager.alert('返回消息','保存失败!');   
			}  
		});
	}
</script>
	<div class="easyui-panel" title="" style="overflow:auto;padding:10px">
	<form id="housedetailform" method="post">
			<input type='hidden'  name = 'houseid' id ='houseid'/>
			<input type='hidden'  name = 'busid' id ='busid'/>
			<table id="housetable" class="table table-bordered" >
				<tr>
					<td align="right">
						业务类型：
					</td>
					<td>
						<input id="businesscode" name="businesscode" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'businesscode',
						textField: 'businessname',
						required:'true',
						data:businessdata" disabled="true"/>
					</td>
					<td align="right">
						状态：
					</td>
					<td align="left">
						<select id="state" class="easyui-combobox" style="width:200px" name="state" editable="false" disabled="true">
							<option value="0">待审核</option>
							<option value="1">已审核</option>
							<option value="3">已终审</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">
						转出方计算机编码：
					</td>
					<td>
						<input id="lessorid" class="easyui-validatebox" type="text" name="lessorid" style="width:200px;" data-options="required:false" disabled="true"></input>
					</td>
					<td align="right">
						转出方名称：
					</td>
					<td align="left">
						<input id="lessortaxpayername" class="easyui-validatebox" type="text" name="lessortaxpayername" style="width:200px;" data-options="required:false" disabled="true"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
						转入方计算机编码：
					</td>
					<td>
						<input id="lesseesid" class="easyui-validatebox" type="text" name="lesseesid" style="width:200px;" data-options="required:false" disabled="true"></input>
					</td>
					<td align="right">
						转入方名称：
					</td>
					<td align="left">
						<input id="lesseestaxpayername" class="easyui-validatebox" type="text" name="lesseestaxpayername" style="width:200px;" data-options="required:false" disabled="true"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
						房产用途：
					</td>
					<td>
						<input id="purpose" name="purpose" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
						url: '/ComboxService/getComboxs.do?codetablename=COD_HOUSEUSECODE'" />
					</td>
					<td align="right">
						投入使用时间：
					</td>
					<td>
						<input id="usedates" name="usedates" class="easyui-datebox" style="width:200px;" data-options="" disabled="true"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
						使用年限起：
					</td>
					<td>
						<input id="limitbegins" name='limitbegins' class="easyui-datebox" style="width:200px;" data-options="" disabled="true"></input>
					</td>

					<td align="right">
						使用年限止：
					</td>
					<td>
						<input id="limitends" name='limitends' class="easyui-datebox" style="width:200px;" data-options="" disabled="true"></input>
					</td>
				</tr>
				<tr>
					<td align="right">所属村（居）委会：</td>
					<td>
						<input id="belongtowns" name="belongtowns" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:false,
						data:belongtowns" />
					</td>
					<td align="right">
						详细地址：
					</td>
					<td>
						<input id="detailaddress" class="easyui-validatebox" style="width:200px;" type="text" name="detailaddress" data-options="required:false"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
					总价/年租金（元）：
					</td>
					<td>
						<input id="houseamount" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="houseamount" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" disabled="true"/></input>
					</td>
					<td align="right">
					建筑面积（平方米）：
					</td>
					<td>
						<input id="housearea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="housearea" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" disabled="true" /><font color="red" id="maxgroundarea" ></font></input>
					</td>
				</tr>
			</table>
			<div align='center' id="housesavebutton"> <a href="###"   class="easyui-linkbutton" data-options="iconCls:'icon-save',region:'center'" onclick="savehousebus()">保存</a></div>
		</form>
		
		</div>
</body>
  
</html>