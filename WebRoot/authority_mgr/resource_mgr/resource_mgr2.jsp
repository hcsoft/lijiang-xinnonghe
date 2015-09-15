<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<meta charset="UTF-8">
	<title>系统权限_资源管理</title>
	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="<%=spath%>/demo/demo.css">
	<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
	<script src="<%=spath%>/js/jquery.json-2.2.js"></script>
</head>
<body>
	<h2>系统权限</h2>
	<div class="demo-info">
		<div class="demo-tip icon-tip"></div>
		<div>资源管理</div>
	</div>
	<div style="margin:10px 0;"></div>
	<div class="easyui-panel" title="" style="width:800px">
		<div style="padding:10px 0 10px 60px">
	    <form id="saveForm" method="post">
	    	<table>
	    		<tr>
	    			<td align="right">资源名称:</td>
	    			<td><input type="text" name="brandName" id="brandName"></input></td>

					<td align="right">是否可用:</td>
	    			<td>
						<select class="easyui-combobox" name="enabled" id="enabled">
							<option value="1">是</option>
							<option value="0">否</option>
						</select>					
					</td>

	    		</tr>
	    		<tr>
					<td align="right">资源类型:</td>
	    			<td>
						<select class="easyui-combobox" name="resource_type" id="resource_type">
							<option value="00">url 页面路径</option>
							<option value="01">.do功能路径</option>
						</select>					
					</td>

	    			<td align="right">资源路径:</td>
	    			<td><input type="text" name="resource_content" id="resource_content" style="width:200px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td align="right">是否功能目录:</td>
	    			<td>
						<select class="easyui-combobox" name="isFunc" id="isFunc">
							<option value="00">功能目录</option>
							<option value="01">功能菜单</option>
						</select>						
					</td>

	    			<td align="right">所在功能目录:</td>
	    			<td>
						<input class="easyui-combobox" name="parent_menu_id" id="parent_menu_id" data-options="
									disabled:true,
									url: '/ComboxService/getComboxs.do?codetablename=COD_TAXCODE',
									valueField: 'key',
									textField: 'keyvalue',
									panelWidth: 300,
									panelHeight: 'auto'
								">					
					</td>
	    		</tr>


	    		<tr>
	    			<td align="right">排序串:</td>
	    			<td><input type="text" name="sort_str" id="sort_str"></input></td>


	    		</tr>

	    		<tr>
	    			<td align="right">是否两块:</td>
	    			<td>
						<select class="easyui-combobox" name="isDouble" id="isDouble">
							<option value="yes">是</option>
							<option value="no">否</option>
						</select>	
					</td>

	    			<td align="right">背景颜色:</td>
	    			<td><input type="text" name="bgColor" id="bgColor"></input></td>
	    		</tr>

	    		<tr>
	    			<td align="right">图标路径:</td>
	    			<td><input type="text" name="imgSrc" id="imgSrc"></input></td>


	    		</tr>

	    		<tr>
	    			<td align="right">资源描述:</td>
	    			<td colspan="3"><textarea name="resouce_describe" id="resouce_describe" style="width:400px;height:60px;"></textarea></td>
	    		</tr>
	    	</table>
	    </form>
	    </div>
	    <div style="text-align:center;padding:5px">
	    	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()">保存</a>
	    </div>
	</div>
	<script>
		function formatItem(row){
			var s = '<span style="font-weight:bold">' + row.resource_name + '</span><br/>' +
					'<span style="color:#888">' + row.resouce_describe + '</span>';
			return s;
		}
		function submitForm(){
			$('#ff').form('submit');
		}
		function clearForm(){
			$('#ff').form('clear');
		}

$(function(){
	//alert($("#isFunc").combobox('getValue'));
	//document.getElementById('isFunc').disabled = true;
	//document.getElementById("isFunc").disabled = true;
	/*
		$.ajax({
			   type: "get",
			   url: "/authorityMgrService/getFuncMenuTops.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				   alert(jsondata);
							$('#zzz').combobox({			
								data : jsondata,                        
									valueField:'value',                       
									textField:'text'		
							});




	           }
	   });

		*/

     $("#resource_type").combobox({  
         //相当于html >> select >> onChange事件  
         onChange:function(n,o){  
             if(n == "00"){
					//alert($("#isFunc").combobox("getValue"));
				$("#isFunc").combobox("enable");
				//$("#parent_menu_id").combobox({disabled:false});
				$("#sort_str").removeAttr("disabled"); 
				$("#isDouble").combobox({disabled:false});
				$("#bgColor").removeAttr("disabled"); 
				$("#imgSrc").removeAttr("disabled"); 
				if($("#isFunc").combobox("getValue") == "00"){
					$("#parent_menu_id").combobox("disable");	
				}else{
					//$("#parent_menu_id").combobox("enable");
				}	
			 }else{
			//	 alert($("#sort_str").val());
					//alert($("#isFunc").combobox("getValue"));
				$("#isFunc").combobox("disable");
				//$("#parent_menu_id").combobox({disabled:true});
				$("#sort_str").attr("disabled","disabled"); 
				$("#isDouble").combobox({disabled:true});
				$("#bgColor").attr("disabled","disabled"); 
				$("#imgSrc").attr("disabled","disabled"); 
				$("#parent_menu_id").combobox("disable");	
	
			 }
         } 
     }) 

     $("#isFunc").combobox({  
         //相当于html >> select >> onChange事件  
         onChange:function(n,o){  
             if(n == "00"){
				$("#parent_menu_id").combobox("disable");	
				if($("#resource_type").combobox("getValue") == "01"){
					$("#parent_menu_id").combobox("disable");	
				}
			 }else{
				$("#parent_menu_id").combobox("enable");
				if($("#resource_type").combobox("getValue") == "01"){
					$("#parent_menu_id").combobox("disable");	
				}				
			 }
         } 
     }) 

})
function save(){
		var params = {};
		var fields =$('#saveForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		//alert($.toJSON(params));
			
		$.ajax({
	           type: "post",
	           url: "/ResourceMgrService/save.do",
	           data: params,
	           dataType: "json",
	           success: function(jsondata){
					alert(jsondata.retStatus);
	           }
	   });
	
}
	</script>
</body>
</html>