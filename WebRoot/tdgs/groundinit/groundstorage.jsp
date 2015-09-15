<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/toolbar.css">
	<link rel="stylesheet" href="/css/logout.css"/>
	<link rel="stylesheet" href="/css/tablen.css"/>
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/dropdown.js"></script>
    <script src="/js/tiles.js"></script>
    <script src="/js/moduleWindow.js"></script>
	<script src="/menus.js"></script>
	<script src="/js/common.js"></script>
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>
	<script src="/js/jquery.simplemodal.js"></script>
   	<script src="/js/uploadmodal.js"></script> 

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
	var belongtocountry = new Array();
	var belongtowns = new Array();
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");   
		datatype = paras[0].substr(paras[0].indexOf("=") + 1); 
		//alert(datatype);
		$.ajax({
			   type: "post",
			   async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
				  locationdata= jsondata;
					for (var i = 0; i < jsondata.length; i++) {
						if(jsondata[i].key.length==9){
							var newdetail={};
							newdetail.key=jsondata[i].key;
							newdetail.value=jsondata[i].value;
							belongtocountry.push(newdetail);
						}
						if(jsondata[i].key.length==12){
							var newdetail={};
							newdetail.key=jsondata[i].key;
							newdetail.value=jsondata[i].value;
							belongtowns.push(newdetail);
						}
					}
			   }
			});
		var regex = new RegExp("\"","g");  
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#taxorgsupcode').combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							//alert(n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//alert(JSON.stringify(jsondata));
									   $('#taxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#taxorgcode').combobox({
						data : jsondata.taxOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/taxDeptOptionByOrg.do",
								   data: {"taxOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#taxdeptcode').combobox({
						data : jsondata.taxDeptOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/getTaxEmpByOrgCode.do",
								   data: {"taxDeptCode":n.key,"emptype":"30"},
								   dataType: "json",
								   success: function(jsondata){	
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}



				   $('#taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
	           }
	   });
			$('#groundstoragegrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				idField:'landstoreid',
				view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundstoragequerywindow').window('open');
					}
				},{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						opttype='add';
						$('#groundstorewindow').window('open');
						$('#groundstorewindow').window('refresh', 'groundstoretypeselect.jsp');
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						var row = $('#groundstoragegrid').datagrid('getSelected');
						if(row && selectindex != undefined){
							opttype='modify';
							$('#groundstorewindow').window('open');
							$('#groundstorewindow').window('refresh', 'groundstore-01.jsp');
						}
						
					}
				},{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						var row = $('#groundstoragegrid').datagrid('getSelected');
						if(row && selectindex != undefined){
							$.messager.confirm('提示框', '你确定要删除吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/InitGroundServlet/deletelandstoreinfo.do",
										data: {landstoreid:row.landstoreid},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"删除成功");
											$('#groundstoragegrid').datagrid('reload');
											selectindex = undefined;
											//$('#groundstoragegrid').datagrid('selectRow',selectindex);
										}
									});
								}
							})
						}
					}
				}],
				onClickRow:function(index){
					var row = $('#groundstoragegrid').datagrid('getSelected');
					selectindex = index;
					selectid = row.landstoreid;
				},
				onClickCell: function (rowIndex, field, value) {
					if(field=="file"){
						$('#groundstoragegrid').datagrid('selectRow',rowIndex);
						var row = $('#groundstoragegrid').datagrid('getSelected');
						businesscode = row.businesscode;
						businessnumber = row.businessnumber;
						//alert(businesscode+"-----"+businessnumber);
					}
				}
			});
			
			var p = $('#groundstoragegrid').datagrid('getPager');  
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
			
		});
	var viewed = $.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
								if(selectid != undefined){
									$('#groundstoragegrid').datagrid('selectRecord',selectid);
									var row = $('#groundstoragegrid').datagrid('getSelected');
									var index = $('#groundstoragegrid').datagrid('getRowIndex',row);
									var lastindex = $('#groundstoragegrid').datagrid('getData')['total']-1;
									if(index > lastindex){
										$('#groundstoragegrid').datagrid('unselectRow',index);
									}
								}else{
									selectindex = undefined;
								}
							} 
				});
	//结束所有行的编辑
		function endEdits(){
			var rows = $('#groundstoragedetailgrid').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#groundstoragedetailgrid').datagrid('endEdit', i);
			}
			$('#groundstoragedetailgrid').datagrid('acceptChanges');
		}
		
		function endEditing(){  
            if (editIndex == undefined){return true}
            if ($('#groundstoragedetailgrid').datagrid('validateRow', editIndex)){
				$('#groundstoragedetailgrid').datagrid('endEdit', editIndex);
                editIndex = undefined;  
                return true;  
            } else {  
                return false;  
            }  
        }

		function query(){
			var params = {};
			var fields =$('#groundstoragequeryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#groundstoragegrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			params.datatype=datatype;
			$('#groundstoragegrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundstoragegrid').datagrid('options');
			opts.url = '/InitGroundServlet/getlandstoreinfo.do';
			$('#groundstoragegrid').datagrid('load',params); 
			var p = $('#groundstoragegrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundstoragequerywindow').window('close');
			
		}

		function save(){
			var params = {};
			var fields =$('#groundstorageeditform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			$.ajax({
			   type: "post",
			   url: "/InitGroundServlet/savelandstoremain.do",
			   data: params,
			   dataType: "json",
			   success: function(jsondata){
				   $('#groundstoragegrid').datagrid('reload');
				  $('#groundstorageeditwindow').window('close');
				  $.messager.alert('返回消息','保存成功！');
			   }
			});
		}

		function refreshLandstoredetail(){
			var row = $('#groundstoragegrid').datagrid('getSelected');
			if(row && selectindex != undefined){
				$.ajax({
				   type: "post",
				   url: "/InitGroundServlet/getlandstoresub.do",
				   data: {landstoreid:row.landstoreid},
				   dataType: "json",
				   success: function(jsondata){
					  $('#groundstoragedetailgrid').datagrid('loadData',jsondata);
				   }
				});
			}
		}

	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
	}
	

	

	</script>
</head>
<body>
	<form id="groundstorageform" method="post">
		<div title="批复信息" data-options="
						tools:[{
							handler:function(){
								$('#groundstoragegrid').datagrid('reload');
							}
						}]">
					
						<table id="groundstoragegrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'landstoreid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'approvetype',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
									<th data-options="field:'taxpayerid',width:80,align:'left',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'approvenumberlevel',width:100,align:'left',formatter:function(value,row,index){
										if(value=='01'){
											return '国家';
										}
										if(value=='02'){
											return '省';
										}
										if(value=='03'){
											return '市';
										}
										if(value=='04'){
											return '县';
										}
									},
									
									editor:{type:'validatebox'}">批复级别</th>
									<th data-options="field:'approvenumber',width:100,align:'left',editor:{type:'validatebox'}">批复文号</th>
									<th data-options="field:'approvedates',width:60,align:'center',editor:{type:'validatebox'}">批复日期</th>
									<th data-options="field:'areatotal',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">批复总面积(平方米)</th>
									<!-- <th data-options="field:'areasell',width:100,align:'center',editor:{type:'validatebox'}">已出让面积</th> -->
									<th data-options="field:'areaplough',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">农用地面积(平方米)</th>
									<th data-options="field:'areabuild',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">建设用地面积(平方米)</th>
									<th data-options="field:'areauseless',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">未利用地面积(平方米)</th>
									<!-- <th data-options="field:'file',width:100,align:'center',formatter:uploadbutton">附件管理</th> -->
									<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="groundstoragequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstoragequeryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td>
							<input id="querytaxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="querytaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayername"/>
						</td>
						
					</tr>
					<tr>
						<td align="right">批复文号：</td>
						<td>
							<input id="queryapprovenumber" class="easyui-validatebox" type="text" style="width:200px" name="queryapprovenumber"/>
						</td>
						<td align="right">批复时间：</td>
						<td colspan="3">
							<input id="approvedatebegin" class="easyui-datebox" name="approvedatebegin"/>
						至
							<input id="approvedateend" class="easyui-datebox"  name="approvedateend"/>
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
	<!-- <div id="groundstorageeditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstorageeditform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
					<input id="landstoreid"  type="hidden" name="landstoreid"/>	
					<tr>
						<td align="right">批复类型：</td>
						<td>
							<input class="easyui-combobox" name="approvetype" id="approvetype" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">批复名称：</td>
						<td>
							<input class="easyui-validatebox" name="name" id="name"/>					
						</td>
					</tr>
					<tr>
						<td align="right">厅级批准文号：</td>
						<td><input id="approvenumber" class="easyui-validatebox" type="text" name="approvenumber"/></td>
						<td align="right">市级批准文号：</td>
						<td>
							<input id="approvenumbercity" class="easyui-validatebox" type="text" name="approvenumbercity"/>
						</td>
					</tr>
					<tr>
						<td align="right">纳税人计算机编码：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayer" id="taxpayer"/>					
						</td>
						<td align="right">纳税人计算机名称：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayername" id="taxpayername"/>					
						</td>
					</tr>
					<tr>
						<td align="right">批复日期：</td>
						<td colspan="3">
							<input id="approvedates" class="easyui-datebox" name="approvedates"/>
						</td>
					</tr>
					
				</table>
			</form>
			<div style="text-align:center;padding:5px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="quereyreg()">税务登记查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
			</div>
		</div>
	</div> -->
	<!-- <div id="groundstoragedetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复明细',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:800px;height:400px;">
	<table id="groundstoragedetailgrid"></table>
	</div> -->
	<div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
	<div id="groundstorewindow" class="easyui-window" data-options="closed:true,modal:true,title:'批复',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:1000px;height:500px;">
	</div>
	<!-- <div id="groundstorageaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:200px;">
	</div> -->
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>