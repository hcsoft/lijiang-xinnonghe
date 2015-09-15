<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<base target="_self"/>
	<title>应纳税汇总查询</title>

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
	<script src="shouldtaxgather.js"></script>		
    <script>
    $.fn.combo.defaults.editable = false;
	function formatterDate(value,row,index){
			return formatDatebox(value);
	}
	function addViewDetailButton(value,row,index){
		       if(row.state === 1)
			      return "<input type='button' value='查看明细' onclick='queryDetail("+index+")'/>";
	}
	function formatValue(value,row,index){
		return value;
	}
	
    var managerLink = new OrgLink();
    managerLink.sendMethod = true;
    
    var taxLink = new TaxLink("taxtypecode","10,12,20",true,"taxcode");
	$(function(){
		    managerLink.loadData();
		    taxLink.loadData();
		    CommonUtils.getCacheCodeFromTable('COD_BELONGTOCOUNTRYCODE','belongtocountrycode',
			                                 'belongtocountryname','#shouldtaxqueryform #belongtocountrycode',
			                                  " and valid = '01' and belongtocountrycode != '5301220000' and belongtocountrycode like '530122%' ",true);
		    
		    $('#taxsel').combo({
                  multiple:true
             });
		    $('#taxseldiv').appendTo($('#taxsel').combo('panel'));
		    
		    //设置多选下拉框   taxtypcodesel
		    $('#taxtypesel').combo({
                  multiple:true
            });
            $('#taxtypeseldiv').appendTo($('#taxtypesel').combo('panel'));
            $('#taxtypeseldiv input').click(function(){
            	var tempValue = '';
            	var value = '';
            	var display = '';
            	var oInputs = $('#taxtypeseldiv input');
            	for(var i = 0;i < oInputs.length;i++){
            		var oInput = oInputs[i];
            		if(oInput.checked){
            			value += "'"+oInput.value + "',";
            			tempValue += oInput.value + ",";
            			display += $(oInput).next('span').text()+',';
            		}
            	}
            	if(value){
            		value = value.substring(0,value.length-1);
            		tempValue = tempValue.substring(0,tempValue.length-1);
            	}
            	if(display){
            		display = display.substring(0,display.length-1);
            	}
                $('#taxtypesel').combo('setValue', value).combo('setText', display);
                var taxtypecode = tempValue;
                  //获取税种
                $('#taxseldiv span[data-x="removespan"]').remove();
                $('#taxsel').combo('setValue','').combo('setText','');
                if(taxtypecode){
                	 $.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/ComboxService/gettaxcomboxs.do?d="+new Date(),
					  data: {"taxcode":taxtypecode,"gettaxcode":true},
					  dataType: "json",
					  success:function(jsondata){
						 if(jsondata){
							 var oDiv = $("#taxseldiv");
							 for(var i = 0;i < jsondata.key.length;i++){
								 var valueAry = jsondata.value[i];
								 for(var j = 0;j < valueAry.length;j++){
									 var v = valueAry[j];
									 var index = v.keyvalue.indexOf('-');
									 var taxdisplay = v.keyvalue.substring(index+1);
									 //创建input标签
									 var newInput = $("<span data-x='removespan'><input type='checkbox' name='ck'"+j+" value='"+v.key+"'><span>"+taxdisplay+"</span><br/></span>");
									 newInput.bind('click',function(){
										   var oInputs =  $('#taxseldiv input');
										    var value = '';
							            	var display = '';
							            	for(var i = 0;i < oInputs.length;i++){
							            		var oInput = oInputs[i];
							            		if(oInput.checked){
							            			value += "'"+oInput.value + "',";
							            			display += $(oInput).next('span').text()+',';
							            		}
							            	}
							            	if(value){
							            		value = value.substring(0,value.length-1);
							            	}
							            	if(display){
							            		display = display.substring(0,display.length-1);
							            	}
							            	$('#taxsel').combo('setValue', value).combo('setText', display);
									 });
									 oDiv.append(newInput);
								 }
							 }
						 }
					  }
				    });
                }
                  
            });
            
            
		    $('#groundstoragegrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true
			});
			
			var p = $('#groundstoragegrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			$('#shouldtaxdetailgrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				rowStyler:settings.rowStyle
			});
			
			p = $('#shouldtaxdetailgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			$('#totalgrid').datagrid({
				fitColumns:false,
				pageList:[18]
			});
			p = $('#totalgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			
		    var oParent = $('#processDialog').parent();
			oParent.css('padding','0');
			oParent.css('border-width','0');
			
			$('#paramgrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:false,
				pageList:[1000]
			});
				 
			p = $('#paramgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			var firstDay = DateUtils.getYearFirstDay();
			var lastDay = DateUtils.getCurrentDay();
		     $('#begindate').datebox('setValue',firstDay);
		     $('#enddate').datebox('setValue',lastDay);
		     
			queryModel();
		});
	    
	    function queryModel(){
	    	var params = {};
	    	params['bylogininfo'] = true;
	    	params['rows'] = 100;
	    	params['status'] = '1';
	    	$.ajax({
				   type: "get",
				   async:false,
				   url: '/modeldefine/querymodel.do?d='+new Date(),
				   data:params,
				   dataType: "json",
				   success: function(jsondata){
					   $('#paramgrid').datagrid('loadData',jsondata.rows);
				   }
			});
	    	/*
			var opts = $('#paramgrid').datagrid('options');
			opts.url = '/modeldefine/querymodel.do?d='+new Date();
			$('#paramgrid').datagrid('load',params); 
			*/
			var p = $('#paramgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
	    }
	    function clearPanel(){
			$('#modelname').val('');
			$('#totalgrid').datagrid('loadData',[]);
			var oCk = $("#modeladdwindow").find("input[type='checkbox']");
			for(var i = 0;i < oCk.length;i++){
				oCk[i].checked = false;
			}
		}
	    function viewModel(rowIndex, rowData){
	    	clearPanel();
	    	$.ajax({
				   type: "get",
				   async:false,
				   url: "/modeldefine/getmodel.do?date="+new Date(),
				   data:{"modelid":rowData.modelid},
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
							   var ckValue = ck.value;
							   for(var j = 0;j < items.length;j++){
								   if(ckValue.indexOf(items[j]) != -1){
									   ck.checked = true;
								   }
							   }
							   if(ck.checked){
								   changeCondition(ck);
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
	    function getWhereCondition(params){
	    	//taxtypesel
	    	var result = '';
	    	if(params.taxorgsupcode){
	    		result += " and taxorgsupcode = '"+params.taxorgsupcode+"' ";
	    	}
	    	if(params.taxorgcode){
	    		result += " and taxorgcode = '"+params.taxorgcode+"' ";
	    	}
	    	if(params.taxdeptcode){
	    		result += " and taxdeptcode = '"+params.taxdeptcode+"' ";
	    	}
	    	if(params.taxmanagercode){
	    		result += " and taxmanagercode = '"+params.taxmanagercode+"' ";
	    	}
	    	if(params.taxpayerid){
	    		result += " and taxpayerid = '"+params.taxpayerid+"' ";
	    	}
	    	if(params.taxpayername){
	    		result += " and taxpayername like '%"+params.taxpayername+"%' ";
	    	}
	    	if(params.taxtypecode){
	    		result += " and taxtypecode = '"+params.taxtypecode+"' ";
	    	}
	    	if(params.taxcode){
	    		result += " and taxcode = '"+params.taxcode+"' ";
	    	}
	    	if(params.begindate){
	    		result += " and taxbegindate >= '"+params.begindate+"' ";
	    	}
	    	if(params.enddate){
	    		result += " and taxenddate <= '"+params.enddate+"' ";
	    	}
	    	var taxtypecodes = $('#taxtypesel').combo('getValue');
	    	var taxcodes = $('#taxsel').combo('getValue');
	    	if(taxtypecodes){
	    		result += " and taxtypecode in ("+taxtypecodes+") ";
	    	}
	    	if(taxcodes){
	    		result += " and taxcode in ("+taxcodes+") ";
	    	}
	    	if(params.belongtocountrycode){
	    		result += " and belongtocountrycode = '"+params.belongtocountrycode+"' ";
	    	}
	    	return result;
	    }
	    
	    function processGrid(data){
            //合并行,列
    		var rows = $(this).datagrid('getRows');
    		for(var i = 0;i < rows.length;i++){
    			  var row = rows[i];
    			  if(row.state == 2){
    				   var splitLen = groupFieldAry.length - subtotalFieldAry.length;
	    			   row[groupFieldAry[subtotalFieldAry.length]] = '小计'
    			       $('#groundstoragegrid').datagrid('refreshRow',i);
    				   $(this).datagrid('mergeCells',{
    					 index:i,
    					 field:groupFieldAry[subtotalFieldAry.length],
    					 rowspan:1,
    					 colspan:splitLen
    				   }); 
    				   
    			  }
    		}
    		var beginIndex = 0;
    		var endIndex = 0;
    		
    		for(var i = 0;i < rows.length;i++){
    			var row = rows[i];
    			//每页放的是18条记录
    			if(row.state == 2 || (row.state != 2 &&row.state != 99 && i == 17)){  //小计 
    				   //列合并
    				   endIndex = i;
    				   for(var j = 0;j < subtotalFieldAry.length;j++){
	    				var field = subtotalFieldAry[j];
	    				if(endIndex <= beginIndex)
	    					break;
    				    $(this).datagrid('mergeCells',{
    					 index:beginIndex,
    					 field:field,
    					 rowspan:endIndex-beginIndex+1,
    					 colspan:1
    				    }); 
	    			   }
	    			   beginIndex = endIndex+1;
    			}else if(row.state == 99){ //合计
    				   row[groupFieldAry[0]] = '总计'
    			       $('#groundstoragegrid').datagrid('refreshRow',i);
    				   $(this).datagrid('mergeCells',{
    					 index:i,
    					 field:groupFieldAry[0],
    					 rowspan:1,
    					 colspan:groupFieldAry.length
    				   }); 
    			}
    		}
	    }
	    var subtotalFieldAry = null;
	    var groupFieldAry = null;
	    
	    /**
	     * 获取统计列表的选择行，返回行（row），如果没有选中返回null
	     */
	    function getModelRow(){
	    	var row = null;
	    	var oGroupCk = $("#layoutDiv").find("input[type='checkbox']");
	    	var selectRow = null;
			for(var i = 1;i < oGroupCk.length;i++){
				if(oGroupCk[i].checked){
					selectRow = i-1;
					break;
				}
			}
			if(selectRow == null){
				row = null;
			}
			var rows = $('#paramgrid').datagrid('getRows');
			for(var i = 0;i < rows.length;i++){
				if(selectRow == i){
					row = rows[i];
				}
			}
			if(row == null){
				$.messager.alert('提示消息','请选择统计模板，再进行操作!','info');
				return null;
			}
			return row;
	    }
	    /**
	     * 此方法获取查询统计和excel导出的参数，后台的control不会全部用
	     */ 
	    function getCondition(){
	    	var result = {};
	    	var row = getModelRow();
	    	if(row == null){
	    		return null;
	    	}else{
	    		var params = {};
			    var fields =$('#shouldtaxqueryform').serializeArray();
			    $.each( fields, function(i, field){
				    params[field.name] = field.value;
			    });
			    var whereCondition = getWhereCondition(params); //获取查询条件
			    var groupStr = row.totalitem; //group字符串  包含
			    var subtotalStr = row.subtotalitem; //字符串
	    	    groupStr = ShouldTaxUtils.getNewGroupStr(groupStr,subtotalStr);
			    result['selectFields'] = groupStr;
			    result['subtotalField'] =  subtotalStr;
			    result['whereCondition'] = whereCondition;
			    result['rows'] = 18;
			    
			    var groupArray = groupStr?groupStr.split(","):new Array();
			    var subtotalAry = subtotalStr?subtotalStr.split(","):new Array();
			    
			    var groupByName = ShouldTaxUtils.getDisplayColumnFieldAry(groupArray,false);
			    var subtotalName = ShouldTaxUtils.getDisplayColumnFieldAry(subtotalAry,false);
			    
			    groupFieldAry = groupByName;
			    subtotalFieldAry = subtotalName;
			    result['groupByName'] = groupByName.join(",");
			    result['subtotalName'] =  subtotalName.join(",");
			    
			    
			    var exportMapObj = ShouldTaxUtils.getExportMapping(groupArray);
			    
			    var propertyNames = exportMapObj.property;
			    var displayNames = exportMapObj.display;
			    result['propertyNames'] = propertyNames;
			    result['displayNames'] =  displayNames;
			    
			    var colArray = ShouldTaxUtils.getDisplayColumnInfoAry(groupArray);
			    result['colInfo'] =  colArray;
	    	}
	    	return result;
	    }
		function query(){
			
			var params = getCondition();
			if(params == null){
				return null;
			}
			
			$('#groundstoragegrid').datagrid('loadData',[]);
			//$('#groundstoragegrid').datagrid('reload');
			//opts.columns 是数组中再有数组[[col1,col2]]
			var columnAry = new Array();
			var colAry = params['colInfo'];
			columnAry.push(colAry);
			
			var newParams = {};
			var ischeck = $('#ownstaus').attr('checked');
			newParams['ownstaus'] = ischeck?'1':'0';
			newParams['selectFields'] = params['selectFields'];
			newParams['subtotalField'] = params['subtotalField'];
			newParams['whereCondition'] = params['whereCondition'];
			newParams['rows'] = params['rows'];
			newParams['pagesize'] = params['rows'];
			/*
			var opts = $('#groundstoragegrid').datagrid('options');
			opts.url = '/shouldtaxgather/shouldtaxgathertotal.do?d='+new Date().getTime();
			$('#groundstoragegrid').datagrid('load',newParams); 
			*/
			$('#groundstoragegrid').datagrid({
				url:'/shouldtaxgather/shouldtaxgathertotal.do?d='+new Date().getTime(),
				columns:columnAry,
				queryParams:newParams,
				pageSize:18
			});
			
			var p = $('#groundstoragegrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
			
			$('#groundstoragequerywindow').window('close');			
			return new Object;
		}
		/**
		 * 导出主表的数据至excel
		 */
		function exportMainExcel(){
			var params = getCondition();
			if(params == null){
				return null;
			}
			var ischeck = $('#ownstaus').attr('checked');
			params['ownstaus'] = ischeck?'1':'0';
			delete params['colInfo'];
			
			CommonUtils.downloadFile("/shouldtaxgather/shouldtaxgathertotalexport.do?date="+new Date(),params);

		}
		
		var selectRow = null;
		function openQuery(){
			var oGroupCk = $("#layoutDiv").find("input[type='checkbox']");
			for(var i = 1;i < oGroupCk.length;i++){
				if(oGroupCk[i].checked){
					selectRow = i-1;
					break;
				}
			}
			if(selectRow == null){
				$.messager.alert('提示消息','请先选择统计模板，再进行查询!','info');
				return;
			}
			$('#groundstoragequerywindow').window('open');
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

		function getDetailCondition(rowIndex){
			var result = {};
	    	var row = getModelRow();
	    	if(row == null){
	    		return null;
	    	}
	    	var groupStr = row.totalitem;
			var groupAry = groupStr.split(",");
			var newGroupAry = ShouldTaxUtils.getHiddenColumn(groupAry);
			rows = $('#groundstoragegrid').datagrid('getRows');
			row = null;
			for(var i = 0;i < rows.length;i++){
				if(rowIndex == i){
					row = rows[i];
				}
			}
			//获取查询条件
			var params = {};
			var fields =$('#shouldtaxqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			});
			var whereCondition = getWhereCondition(params);
			
			for(var i = 0 ;i < newGroupAry.length;i++){
				var value = row[newGroupAry[i]];
                //对taxyearmonth
				whereCondition += " and "+newGroupAry[i] + " = '"+value+"' ";
			}
			result["whereCondition"] = whereCondition;
			result["rows"] = 10;
			var exportInfo = ShouldTaxUtils.getDetailExprtMap();
			result["propertyCols"] = exportInfo.propertyCols;
			result["dislpayCols"] = exportInfo.dislpayCols;
			return result;
		}
		function queryDetail(rowIndex){
			$('#shouldtaxdetailgrid').datagrid('loadData',[]);
			var params = getDetailCondition(rowIndex);
			if(params == null){
				return;
			}
			mainRowIndex = rowIndex;
			var newParams = {};
			newParams['whereCondition'] = params['whereCondition'];
			newParams['rows'] = params['rows'];
			var opts = $('#shouldtaxdetailgrid').datagrid('options');
			opts.url = '/shouldtaxgather/shouldtaxgatherdetail.do?d='+new Date();
			$('#shouldtaxdetailgrid').datagrid('load',newParams); 
			var p = $('#shouldtaxdetailgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
			
			$('#shouldtaxdetail').window('open'); 
		    
		}
		var mainRowIndex = null;
		
		
		/**
		 * 导出主表的数据至excel
		 */
		function exportDetailExcel(){
			var params = getDetailCondition(mainRowIndex);
			if(params == null){
				return null;
			}
			CommonUtils.downloadFile("/shouldtaxgather/shouldtaxgatherdetailexport.do?date="+new Date(),params);
		}
		
		function addCheckBox(value,row,index){
			var result = "";
			result = "<input type='checkbox' value='"+row.key+"' />";
			return result;
		}
		
	</script>
</head>
<body>
     <div class="easyui-layout" style="width:100%;height:550px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='groundstoragegrid' class="easyui-datagrid" style="width:99;height:522px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[18],
					rowStyler: function(index,row){
					     if(row.state == 2){
					         return 'background-color:#CCC0DA;';
					     }else if(row.state == 99){
					         return 'background-color:#80B4E3;';
					     }
						 
					},
					onLoadSuccess:processGrid
					">
				<thead>
					<tr>
					    <th data-options="field:'taxtypename',width:120,align:'left',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'shouldTaxMoney',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴金额</th>
						<th data-options="field:'alreadyShouldTaxMoney',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">实缴金额</th>
						<th data-options="field:'avoidtaxmoney',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">减免金额</th>
						<th data-options="field:'owetaxmoney',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">欠税金额</th>
					</tr>
				</thead>
			</table>
		    </form>
	    </div>
	    <div data-options="region:'west'" id="mainWestDiv" style="height:560px;width:200px;overflow: hidden;" id="groupDiv" >
	        <table id='paramgrid' class="easyui-datagrid" style="height:560px;width:200px;overflow: hidden;"
					data-options="iconCls:'icon-edit',singleSelect:true,onDblClickRow:function(rowIndex,rowData){
					    viewModel(rowIndex, rowData);
					}">
				<thead>
					<tr>
					    <th data-options="field:'modelid',width:50,align:'center',checkbox:true,editor:{type:'checkbox'}"></th>
						<th data-options="field:'modelname',width:160,align:'center',editor:{type:'validatebox'}">统计模板(双击查看模板)</th>
						<th data-options="field:'totalitem',hidden:true,width:125,align:'center',editor:{type:'validatebox'}">统计项</th>
						<th data-options="field:'subtotalitem',hidden:true,width:125,align:'center',editor:{type:'validatebox'}">小计项</th>
					</tr>
				</thead>
			</table>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询统计</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportMainExcel()">导出EXCEL</a>
				<!-- <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">退出</a> -->
			</div>
		</div>
	</div>
	
	<div id="modeladdwindow" class="easyui-window" data-options="border:false,closed:true,modal:true,title:'模板查看',
	 collapsible:false,minimizable:false,maximizable:false,closable:true" 
	style="width:640px;height:320px;">
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
	</div>
	
	<div id="groundstoragequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税查询统计条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:760px;>
		<div class="easyui-panel" style="width:100">
			<form id="shouldtaxqueryform" method="post">   
				<table id="narjcxx" width="100%"  class="table table-bordered">
				  
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						
					</tr>
					
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)" style="width:250px"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" style="width:250px"/>
						</td>

					</tr>
					<tr>
					    <td align="right">税种：</td>
						<td>
							<select id="taxtypesel" style="width:150px"></select>
						    <div id="taxtypeseldiv" style="padding: 5px;font-size: 16px;">
						        <input type="checkbox" name="ckland" value="12"><span>土地使用税</span><br/>
						        <input type="checkbox" name="ckhouse" value="10"><span>房产税</span><br/>
						        <input type="checkbox" name="ckplough" value="20"><span>耕地占用税</span><br/>
						    </div>
						</td>
						<td align="right">税目：</td>
						<td>
							<select id="taxsel" style="width:240px"></select>
							<div id="taxseldiv" style="padding: 5px;font-size: 16px;">
						    </div>
						</td>
					</tr>
<%--					<tr style="display: none;">--%>
<%--					    <td align="right">税种：</td>--%>
<%--						<td>--%>
<%--							<input id="taxtypecode" class="easyui-combobox" type="text" name="taxtypecode" data-options="multiple:true"/>--%>
<%--						</td>--%>
<%--						<td align="right">税目：</td>--%>
<%--						<td>--%>
<%--							<input id="taxcode" class="easyui-combobox" type="text" name="taxcode" data-options="multiple:true"/>--%>
<%--						</td>--%>
<%--					</tr>--%>
					<tr>
						<td align="right">纳税人所属乡镇：</td>
						<td colspan="3">
							<input class="easyui-combobox" name="belongtocountrycode" id="belongtocountrycode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>
						</td>
					</tr>
					<tr>
						<td align="right">所属期：</td>
						<td colspan="3">
							<input id="begindate" class="easyui-datebox" name="begindate"/>
						至
							<input id="enddate" class="easyui-datebox"  name="enddate"/>
						</td>
					</tr>
					
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
			
		</div>
		
			
			
	</div>
	
	<div id="detailtb" style="height:25px;" style="display:none;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportDetailExcel()" style="display:none;">导出EXCEL</a>
	</div>
			
	<div id="shouldtaxdetail" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税明细信息',collapsible:false,minimizable:false,maximizable:false,closable:true" 
	   style="width:1120px;height:460px;">
<%--            <div style="text-align:center;padding:5px;height:25px;display: none;" id="detailTotalDiv">  --%>
<%--				 --%>
<%--			</div>--%>
			<table id='shouldtaxdetailgrid' class="easyui-datagrid" style="width:1100px;height:420px;overflow: scroll;"
			data-options="iconCls:'icon-edit',singleSelect:true,idField:'taxpayerid',pageList:[10],nowrap:true">
				<thead>
					<tr>
						<th data-options="field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxtypename',width:160,align:'left',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',width:120,align:'left',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'taxorgname',width:160,align:'left',editor:{type:'validatebox'}">区县税务机关</th>
						<th data-options="field:'taxdeptname',width:160,align:'left',editor:{type:'validatebox'}">主管税务机关</th>
						<th data-options="field:'taxmanagername',width:120,align:'left',editor:{type:'validatebox'}">税收管理员</th>
						<th data-options="field:'taxbegindate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">计税起日期</th>
						<th data-options="field:'taxenddate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">计税止日期</th>
						<th data-options="field:'shouldtaxmoney',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴金额</th>
						<th data-options="field:'alreadyshouldtaxmoney',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">已缴金额</th>
						<th data-options="field:'owetaxmoney',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">欠税金额</th>
						<th data-options="field:'derateflagname',width:120,align:'left',editor:{type:'validatebox'}">状态</th>
						<th data-options="field:'levydatetypename',width:250,align:'left',editor:{type:'validatebox'}">征期类型</th>
											</tr>
				</thead>
			</table>
	</div>
	<div id="processDialog" class="easyui-window easyui-progressbar" data-options="closed:true,modal:true,collapsible:true,noheader:true,border:false"  
	style="width:300px;height:45px;">
	</div>
</body>
</html>