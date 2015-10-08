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
	<script>
	var selectindex = undefined;
	var selectid = undefined;
	var editIndex = undefined;
	var locationdata = new Object;
	var approvetype;//批复类型
	var opttype;//操作类型
	var businesscode;
	var businessnumber;
	var datatype;//0：期初数据整理 1：日常业务 2：补录批复
	var orgdata = new Object;
	var empdata = new Object;
	var doctordata = new Object;
	var orgname;
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");  
		empcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
		orgcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
		datatype = paras[0].substr(paras[0].indexOf("=") + 1); 
			$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXORGCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  orgdata= jsondata;
			   }
			});
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_TAXEMPCODE'},
		   dataType: "json",
		   success: function(jsondata){
			  empdata= jsondata;
		   }
		});
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxsFromTable.do",
		   data: {codetablename:'COD_TAXEMPCODE',key:'taxempcode',value:'taxempname',where:" and taxorgcode='"+orgcode+"' and doctorflag='01'"},
		   dataType: "json",
		   success: function(jsondata){
			  doctordata= jsondata;
		   }
		});
		
			$('#userinfogrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#userquerywindow').window('open');
					}
				},{
					text:'查看减免明细',
					iconCls:'icon-tip',
					handler:function(){
						var row = $('#userinfogrid').datagrid('getSelected');
						if(row){
							$('#deratewindow').window('open');
							if(datatype=='10'){
								$('#deratewindow').window('refresh', 'deratedetail-10.jsp');
							}else{
								$('#deratewindow').window('refresh', 'deratedetail-20.jsp');
							}
						}else{
							alert('请选择人员');
						}
						
					}
				}],
				onClickRow:function(index){
					var row = $('#userinfogrid').datagrid('getSelected');
					selectindex = index;
					selectid = row.landstoreid;
				}
			});
			
			var p = $('#userinfogrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false,
					pageSize: 15
				});

			$.extend($.fn.datagrid.defaults.editors, {
							uploadfile: {
							init: function(container, options)
								{
									var editorContainer = $('<div/>');
									var button = $("<a href='javascript:void(0)'></a>")
										 .linkbutton({plain:true, iconCls:"icon-remove"});
									editorContainer.append(button);
									editorContainer.appendTo(container);
									return button;
								},
							getValue: function(target)
								{
									return $(target).text();
								},
							setValue: function(target, value)
								{
									$(target).text(value);
								},
							resize: function(target, width)  
								 {  
									var span = $(target);  
									if ($.boxModel == true){  
										span.width(width - (span.outerWidth() - span.width()) - 10);  
									} else {  
										span.width(width - 10);  
									}  
								}	
							}
						});
			setTimeout('query()',100);
		});
	var viewed = $.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
								$('#userinfogrid').datagrid('unselectAll');
							} 
				});
	function endEdits(){
		var rows = $('#deratedetailgrid').datagrid('getRows');
		for ( var i = 0; i < rows.length; i++) {
			$('#deratedetailgrid').datagrid('endEdit', i);
		}
		$('#deratedetailgrid').datagrid('acceptChanges');
	}
	function endEditing(){  
        if (editIndex == undefined){return true};
		var rows = $('#deratedetailgrid').datagrid('getRows');
		var row = rows[editIndex];
		var begindate = $('#deratedetailgrid').datagrid('getEditor', {index:editIndex,field:'hospital_begindate'});
		var enddate = $('#deratedetailgrid').datagrid('getEditor', {index:editIndex,field:'hospital_enddate'});
		//var productname = $(ed.target).combobox('getText');
		if(datatype=='20'){
			var datea = $(begindate.target).combobox('getValue');
			var dateb = $(enddate.target).combobox('getValue');
			if(!dateCompare(datea,dateb)){
				alert('起日期不能大于止日期!');
				return;
			}
		}
        if ($('#deratedetailgrid').datagrid('validateRow', editIndex)){
			$('#deratedetailgrid').datagrid('endEdit', editIndex);
            editIndex = undefined;  
            return true;  
        } else {  
            return false;  
        }  
    }
		function query(){
			var params = {};
			var fields =$('#userqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#userinfogrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			//params.datatype=datatype;
			$('#userinfogrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#userinfogrid').datagrid('options');
			opts.url = '<%=request.getContextPath()%>/Derate/getuserlist.do';
			$('#userinfogrid').datagrid('load',params); 
			var p = $('#userinfogrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#userquerywindow').window('close');
			
		}
	function formatorg(value,row,index){
		for(var i=0; i<orgdata.length; i++){
			if (orgdata[i].key == value) return orgdata[i].value;
		}
		return value;
	}
	function formatemp(value,row,index){
		for(var i=0; i<empdata.length; i++){
			if (empdata[i].key == value) return empdata[i].value;
		}
		return value;
	}
	$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		},
		isAfter: {
			validator: function(value, param){
				var dateA = $.fn.datebox.defaults.parser(value);
				var dateB = $.fn.datebox.defaults.parser($(param[0]).datebox('getValue'));
				alert(dateA+"------"+dateB);
				return dateA<dateB;
				},
			 message: '起日期不能大于使用止日期！'
		}
	});
	</script>
</head>
<body>
	<form id="groundstorageform" method="post">
		<div title="参合人员信息" data-options="
						tools:[{
							handler:function(){
								$('#userinfogrid').datagrid('reload');
							}
						}]">
					
						<table id="userinfogrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'user_id',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<%--<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton"> 附件管理</th>--%>
									<th data-options="field:'union_id',width:80,align:'left',editor:{type:'validatebox'}">合作医疗证号</th>
									<th data-options="field:'card_id',width:80,align:'left',editor:{type:'validatebox'}">卡号</th>
									<th data-options="field:'person_no',width:80,align:'left',editor:{type:'validatebox'}">个人编号</th>
									<th data-options="field:'user_name',width:200,align:'left',editor:{type:'validatebox'}">人员名称</th>
									<th data-options="field:'gender',width:100,align:'left',formatter:function(value,row,index){
										if(value=='01'){
											return '男';
										}
										if(value=='02'){
											return '女';
										}
										return value;
									},
									
									editor:{type:'validatebox'}">性别</th>
									<th data-options="field:'birthday',width:60,align:'center',editor:{type:'validatebox'}">出生日期</th>
									<%--<th data-options="field:'role_id',width:100,align:'left',editor:{type:'validatebox'}">角色</th>
									<th data-options="field:'hospital_id',width:60,align:'center',editor:{type:'validatebox'}">所属单元</th>--%>
									<th data-options="field:'valid',width:100,align:'left',formatter:function(value,row,index){
										if(value=='1'){
											return '有效';
										}
										if(value=='0'){
											return '无效';
										}
									},
									
									editor:{type:'validatebox'}">有效标识</th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="userquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'参合人员查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:150px;">
		<div class="easyui-panel" title="" style="width:900px;">
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
					<tr>
						<td align="right">姓名：</td>
						<td>
							<input id="user_name" class="easyui-validatebox" type="text" style="width:200px" name="user_name" />
						</td>
						<td align="right">个人编号：</td>
						<td>
							<input id="person_no" class="easyui-validatebox" type="text" style="width:200px" name="person_no"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="###" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
					<!-- <a href="#" class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
			</div>
		</div>
	</div>
	
	<div id="deratewindow" class="easyui-window" data-options="closed:true,modal:true,title:'减免信息',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:1000px;height:550px;">
	</div>
	

</body>
</html>