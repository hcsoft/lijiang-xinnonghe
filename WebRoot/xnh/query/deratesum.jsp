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
	var orgname;
	var sumtypedata = [{sumcode:'derate_date_year',sumname:'减免日期（按年）',column:''},{sumcode:'derate_date_yearmonth',sumname:'减免日期（按年月）'},{sumcode:'derate_date_yearmonthday',sumname:'减免日期（按日）'},{sumcode:'opt_orgcode',sumname:'医疗机构'},{sumcode:'user_id',sumname:'参合人员'},{sumcode:'union_id',sumname:'医疗证'}];
	var cloumns=new Array();
	var cloumns=new Array();
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");   
		datatype = paras[0].substr(paras[0].indexOf("=") + 1); 
		var empcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
		var orgcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
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
			async: false,
			url: "/ComboxService/gettaxorgtree.do",
			dataType: "json",
			success: function(jsondata) {
				orgtree = jsondata;
				$('#taxorgcode').combotree({
					data: orgtree,
					valueField: 'id',
					textField: 'text'
				});
				$('#taxorgcode').combotree('setValue', orgcode);
			}
		});
		
			$('#deratesumgrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#deratesumwindow').window('open');
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						
					}
				}],
				onClickRow:function(index){
					var row = $('#deratesumgrid').datagrid('getSelected');
					selectindex = index;
					selectid = row.user_id;
				}
			});
			
			var p = $('#deratesumgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false,
					pageSize: 15
				});
			$('#sumtypegrid').datagrid({
				fitColumns: false,
				pagination:false,
				data:sumtypedata
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
			//setTimeout('query()',100);
		});
	var viewed = $.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
								$('#deratesumgrid').datagrid('unselectAll');
							} 
				});
	
		function query(){
			$('#deratesumgrid').datagrid('hideColumn','derate_date_year');
			$('#deratesumgrid').datagrid('hideColumn','derate_date_yearmonth');
			$('#deratesumgrid').datagrid('hideColumn','derate_date_yearmonthday');
			$('#deratesumgrid').datagrid('hideColumn','user_id');
			$('#deratesumgrid').datagrid('hideColumn','opt_orgcode');
			$('#deratesumgrid').datagrid('hideColumn','user_name');
			$('#deratesumgrid').datagrid('hideColumn','union_id');
			var params = {};
			var fields =$('#deratesumform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			var sumtype = "";
			var rows = $('#sumtypegrid').datagrid('getChecked');
			if (rows.length > 0) {
				for (var i = 0; i < rows.length; i++) {
					sumtype = sumtype + rows[i].sumcode+',';
					$('#deratesumgrid').datagrid('showColumn',rows[i].sumcode);
					if(rows[i].sumcode =='user_id'){
						$('#deratesumgrid').datagrid('showColumn','user_name');
						$('#deratesumgrid').datagrid('hideColumn','user_id');
					}
				}
			}
			cloumns.push
			sumtype = sumtype.substring(0, sumtype.length - 1);
            params.sumtype = sumtype;
			$('#deratesumgrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#deratesumgrid').datagrid('options');
			opts.url = '<%=request.getContextPath()%>/Deratequery/getderatesum.do';
			$('#deratesumgrid').datagrid('load',params); 
			var p = $('#deratesumgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#deratesumwindow').window('close');
			
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
	<div class="easyui-layout" style="width:100%;height:550px;">
		<form id="groundstorageform" method="post">
			<div data-options="region:'west'" id="mainWestDiv" style="height:550px;width:200px;overflow: hidden;">
				<table id='sumtypegrid'  style="height:550px;width:200px;overflow: hidden;"
				data-options="iconCls:'icon-edit',rowStyler:function(x,x){
				return 'background-color:#fff;';
				}">
					<thead>
						<tr>
							<th data-options="field:'checked',width:50,align:'center',checkbox:true,editor:{type:'checkbox'}">
							<th data-options="field:'sumcode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
							</th>
							<th data-options="field:'sumname',width:125,align:'center',editor:{type:'validatebox'}">
								汇总条件
							</th>
						</tr>
					</thead>
				</table>
			</div>
			<div title="" data-options="region:'center',
			tools:[{
			handler:function(){
			$('#deratesumgrid').datagrid('reload');
			}
			}]">
				<table id="deratesumgrid" style="overflow:visible;height:540px;" data-options="iconCls:'icon-edit',singleSelect:true"
				rownumbers="true">
					<thead>
						<tr>
							<th data-options="field:'user_id',width:180,align:'center',hidden:true,editor:{type:'text'}">
							</th>

							<th data-options="field:'derate_date_year',width:180,align:'center',hidden:true,editor:{type:'text'}">
								减免日期（年）
							</th>
							<th data-options="field:'derate_date_yearmonth',width:180,align:'center',hidden:true,editor:{type:'text'}">
								减免日期（年月）
							</th>
							<th data-options="field:'derate_date_yearmonthday',width:180,align:'center',hidden:true,editor:{type:'text'}">
								减免日期（年月日）
							</th>
							<th data-options="field:'opt_orgcode',width:120,align:'center',hidden:true,editor:{type:'text'}">
								医疗机构
							</th>
							<th data-options="field:'user_name',width:120,align:'center',hidden:true,editor:{type:'text'}">
								用户
							</th>
							<th data-options="field:'union_id',width:150,align:'center',hidden:true,editor:{type:'text'}">
								合作医疗证号
							</th>
							<th data-options="field:'derate_type10',width:100,formatter:formatnumber,align:'right',editor:{type:'validatebox'}">
								门诊减免金额
							</th>
							<th data-options="field:'derate_type20',width:100,formatter:formatnumber,align:'right',editor:{type:'validatebox'}">
								住院减免金额
							</th>
							
						</tr>
					</thead>
				</table>
			</div>
		</form>
	</div>
	<div id="deratesumwindow" class="easyui-window" data-options="closed:true,modal:true,title:'减免汇总',collapsible:false,minimizable:false,maximizable:false,closable:true"
	style="width:800px;height:200px;">
		<div class="easyui-panel" title="" style="width:750px;">
			<form id="deratesumform" method="post">
				<table id="deratesumtable" width="100%" class="table table-bordered">
					<tr>
						<td align="right">医疗机构：</td>
						<td>
							<input id="taxorgcode" name="taxorgcode" style="width:200px"/>
						</td>
						<td align="right">卡号：</td>
						<td>
							<input id="card_id" class="easyui-validatebox" type="text" style="width:200px" name="card_id"/>
						</td>
					</tr>
					<tr>
						<td align="right">
							减免日期：
						</td>
						<td colspan="3">
							<input id="deratebegin" class="easyui-datebox" style="width:200px" name="deratebegin"
							/>
							至
							<input id="derateend" class="easyui-datebox" style="width:200px" name="derateend"
							/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">
				<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" href="###" onclick="query()">
					查询
				</a>
				<!-- <a class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'">查询</a> -->
			</div>
		</div>
	</div>
</body>

</html>