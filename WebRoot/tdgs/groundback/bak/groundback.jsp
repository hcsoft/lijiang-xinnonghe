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
	
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>
	<script src="/js/jquery.simplemodal.js"></script>
   	<script src="/js/uploadmodal.js"></script> 

	<script>
	var groundusedata = new Array();//土地用途缓存
	var belongtocountry = new Array();
	var belongtowns = new Array();
	var opttype ='';
	var businesstype;
	var taxpayerid;
	var taxpayername;
	var landstoreid;
	var landstoresubid;
	var targetestateid;
	var busid;
	$(function(){
		//取得url参数
		//var paraString = location.search;
		//var paras = paraString.split("&");   
		//businesscode = paras[0].substr(paras[0].indexOf("=") + 1); 
		//alert(buttonbusinesstype);
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_GROUNDUSECODE'},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
				  groundusedata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {codetablename:'COD_BELONGTOCOUNTRYCODE'},
			   dataType: "json",
			   success: function(jsondata){
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
				   $('#querytaxorgsupcode').combobox({
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
									   $('#querytaxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#querytaxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#querytaxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#querytaxorgcode').combobox({
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
									   $('#querytaxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#querytaxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#querytaxdeptcode').combobox({
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
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#querytaxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}
				   $('#querytaxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
	           }
	   });
			$('#groundnotapproveholdgrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				idField:'ownerid',
				//view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundnotapproveholdquerywindow').window('open');
					}
				},{
						text:'修改',
						iconCls:'icon-edit',
						id:'edit',
						handler:function(){
							var row = $('#groundnotapproveholdgrid').datagrid('getSelected');
							if(row){
								opttype='edit';
								if(row.businesscode =='13'){//收回
									targetestateid = row.targetestateid;
									businesstype = row.businesscode;
									busid = row.busid;
									taxpayerid = row.lesseesid;
									taxpayername = row.lesseestaxpayername;
									$('#groundbusinesswindow').window('open');
									$('#groundbusinesswindow').window('refresh', '../groundnotapprovehold/reginfo.jsp');
								}
							}else{
								alert("请选择需要修改的数据！");
							}
						}
					},{
					text:'收回',
					iconCls:'icon-add',
					id:'wpxz',
					handler:function(){
						$('#groundbusinesswindow').window('open');
						$('#groundbusinesswindow').window('refresh', 'reginfo.jsp');
					}
				},{
						text:'删除',
						iconCls:'icon-cancel',
						handler:function(){
							
						}
				},{
						text:'终审',
						iconCls:'icon-check',
						handler:function(){
							
						}
				},{
						text:'撤销终审',
						iconCls:'icon-uncheck',
						handler:function(){
							
						}
				}
				//,{
				//	text:'修改',
				//	iconCls:'icon-edit',
				//	id:'check',
				//	handler:function(){
				//		var row = $('#groundnotapproveholdgrid').datagrid('getSelected');
				//		if(row){
				//			$('#groundbusinesswindow').window('open');
				//			$('#groundbusinesswindow').window('refresh', 'reginfo.jsp');
				//			opttype = 'edit';
				//		}else{
				//			alert("请选择需要修改的数据！");
				//		}
				//	}
				//},{
				//	text:'删除',
				//	id:'uncheck',
				//	iconCls:'icon-cancel',
				//	handler:function(){
				//		var row = $('#groundnotapproveholdgrid').datagrid('getSelected');
				//		if(row){
				//		}else{
				//			alert("请选择需要取消审核的数据！");
				//		}
				//	}
				//}
				],
				onClickRow:function(rowIndex, rowData){
					if(rowData.state!='0'){
						$('#edit').linkbutton('disable');
					}else{
						$('#edit').linkbutton('enable');
					}
				}
			});
			
			var p = $('#groundnotapproveholdgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
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
									$('#groundnotapproveholdgrid').datagrid('selectRecord',selectid);
									var row = $('#groundnotapproveholdgrid').datagrid('getSelected');
									var index = $('#groundnotapproveholdgrid').datagrid('getRowIndex',row);
									var lastindex = $('#groundnotapproveholdgrid').datagrid('getData')['total']-1;
									if(index > lastindex){
										$('#groundnotapproveholdgrid').datagrid('unselectRow',index);
									}
								}else{
									selectindex = undefined;
								}
							} 
				});


		function query(){
			var params = {};
			var fields =$('#groundnotapproveholdqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			params.businesscode = '13';
			$('#groundnotapproveholdgrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundnotapproveholdgrid').datagrid('options');
			opts.url = '/GroundCheckServlet/getgroundbusinessinfo.do';
			$('#groundnotapproveholdgrid').datagrid('load',params); 
			var p = $('#groundnotapproveholdgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundnotapproveholdgrid').datagrid('unselectAll');
			$('#groundnotapproveholdquerywindow').window('close');
			
		}



	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
	}
	function formatgrounduse(row){
		for(var i=0; i<groundusedata.length; i++){
			if (groundusedata[i].key == row) return groundusedata[i].value;
		}
		return row;
	}
	

	function uploadbutton(row){
		return '<a  class="easyui-linkbutton" id=\'uploadbtn\' data-options=\'iconCls:\'icon-save\'\' onclick="uploadfile()">附件管理</a>';
	}
	//function quereyreg(){
	//	$('#reginfowindow').window('open');//打开新录入窗口
	//	$('#reginfowindow').window('refresh', 'reginfo.jsp');
	//}
	function uploadfile(){
		uploadModal.init("uploadbtn","02","111");
	}
	function Load() {  
    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");  
    $("<div class=\"datagrid-mask-msg\"></div>").html("正在操作，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
	}  
  
//hidden Load   
function dispalyLoad() {  
    $(".datagrid-mask").remove();  
    $(".datagrid-mask-msg").remove();  
} 
	</script>
</head>
<body>
	<form id="groundstorageform" method="post">
		<div title="批复信息" data-options="
						tools:[{
							handler:function(){
								$('#groundnotapproveholdgrid').datagrid('reload');
							}
						}]">
					
						<table id="groundnotapproveholdgrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<!-- <th data-options="checkbox:true"></th> -->
									<th data-options="field:'busid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<!-- <th data-options="field:'lessorid',width:100,align:'center',editor:{type:'validatebox'}">转出方计算机编码</th>
									<th data-options="field:'lessortaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转出方名称</th> -->
									<th data-options="field:'lesseesid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'lesseestaxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<!-- <th data-options="field:'purpose',width:50,formatter:formatgrounduse,align:'center',editor:{type:'validatebox'}">土地用途</th> -->
									<!-- <th data-options="field:'protocolnumber',width:100,align:'center',editor:{type:'validatebox'}">协议书号</th> -->
									<th data-options="field:'holddates',width:70,align:'center',editor:{type:'validatebox'}">实际收回时间</th>
									<th data-options="field:'landarea',width:60,align:'center',editor:{type:'validatebox'}">收回面积</th>
									<th data-options="field:'landamount',width:60,align:'center',editor:{type:'validatebox'}">收回原因</th>
									<!-- <th data-options="field:'limitbegins',width:60,align:'center',editor:{type:'validatebox'}">土地使用起时间</th>
									<th data-options="field:'limitends',width:60,align:'center',editor:{type:'validatebox'}">土地使用止时间</th> -->
									<!-- <th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th> -->
									<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'parentbusinessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'targetestateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="groundnotapproveholdquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收回查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundnotapproveholdqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<input type="hidden" name="businesscode" id="businesscode"/>
					
					<!-- <tr>
						<td align="right">转出方计算机编码：</td>
						<td>
							<input id="querylessorid" class="easyui-validatebox" type="text" style="width:200px" name="querylessorid"/>
						</td>
						<td align="right">转出方名称：</td>
						<td>
							<input id="querylessortaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querylessortaxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">转入方计算机编码：</td>
						<td>
							<input id="querylesseesid" class="easyui-validatebox" type="text" style="width:200px" name="querylesseesid"/>
						</td>
						<td align="right">转入方名称：</td>
						<td>
							<input id="querylesseestaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querylesseestaxpayername"/>
						</td>
					</tr> -->
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgsupcode" style="width:200px" id="querytaxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgcode" style="width:200px" id="querytaxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="querytaxdeptcode" style="width:200px" id="querytaxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="querytaxmanagercode" style="width:200px" id="querytaxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">宗地编号：</td>
						<td>
							<input id="queryestateserialno" class="easyui-validatebox" type="text" style="width:200px" name="queryestateserialno"/>
						</td>
						<td align="right">土地坐落详细地址：</td>
						<td>
							<input id="querydetailaddress" class="easyui-validatebox" type="text" style="width:200px" name="querydetailaddress"/>
						</td>
					</tr>
					<tr>
						<td align="right" >状态：</td>
						<td colspan="3">
							<select id="state" class="easyui-combobox" style="width:200px" name="state" editable="false">
								<option value="">全部</option>
								<option value="0">待审核</option>
								<option value="1">已审核</option>
							</select>
						</td>
						<!-- <td align="right">业务类型：</td>
						<td>
							<select id="businesscode" class="easyui-combobox" style="width:200px" name="businesscode" editable="false">
								<option value="">全部</option>
								<option value="01">土地收储</option>
								<option value="11">土地出让</option>
								<option value="12">土地划拨</option>
								<option value="13">收回</option>
								<option value="21">土地转让</option>
								<option value="22">土地投资联营</option>
								<option value="23">土地捐赠</option>
								<option value="24">土地融资租赁</option>
								<option value="25">土地出典</option>
								<option value="26">土地划转</option>
								<option value="31">土地出租</option>
							</select>
						</td> -->
					</tr>
					<tr>
						<td align="right">实际收回时间：</td>
						<td colspan="3">
							<input id="queryholddatebegin" class="easyui-datebox" style="width:200px" name="queryholddatebegin"/>
						至
							<input id="queryholddateend" class="easyui-datebox"  style="width:200px" name="queryholddateend"/>
						</td>
					</tr>
					<tr>
						<td align="right">录入时间：</td>
						<td colspan="3">
							<input id="optdatebegin" class="easyui-datebox" style="width:200px" name="optdatebegin"/>
						至
							<input id="optdateend" class="easyui-datebox" style="width:200px"  name="optdateend"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a  class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
					<!-- <a  class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
			</div>
		</div>
	</div>
	<!-- <div id="groundstorageeditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstorageeditform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
					<input id="ownerid"  type="hidden" name="ownerid"/>	
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
				<a  class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="quereyreg()">税务登记查询</a>
				<a  class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
			</div>
		</div>
	</div> -->
	<!-- <div id="groundstoragedetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复明细',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:800px;height:400px;">
	<table id="groundstoragedetailgrid"></table>
	</div> -->
	<!-- <div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div> -->
	<div id="groundbusinesswindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收回',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div>
	<!-- <div id="groundstorageaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:200px;">
	</div> -->
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>