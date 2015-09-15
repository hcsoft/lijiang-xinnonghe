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
	function formatterDate(value,row,index){
			return formatDatebox(value);
	}
	
    //初始化列的标题
    function initialColumn(){
			
			var result = new Map();

			var taxpayeridCol = {'field':'taxpayerid','width':100,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'计算机编码','orgcol':'taxpayername'};
			var taxpayernameCol = {'field':'taxpayername','width':200,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'纳税人名称'};
			var taxtypecodeCol = {'field':'taxtypecode','width':100,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'税种代码','orgcol':'taxtypename'};
			var taxtypenameCol = {'field':'taxtypename','width':120,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'税种'};

			var taxcodeCol = {'field':'taxcode','width':100,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'税目代码','orgcol':'taxname'};
			var taxnameCol = {'field':'taxname','width':120,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'税目'};
			var taxorgcodeCol = {'field':'taxorgcode','width':100,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'区县税务机关代码','orgcol':'taxorgname'};
			var taxorgnameCol = {'field':'taxorgname','width':200,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'区县税务机关'};

            var taxdeptcodeCol = {'field':'taxdeptcode','width':100,'hidden':false,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'主管税务机关代码','orgcol':'taxdeptname'};
			var taxdeptnameCol = {'field':'taxdeptname','width':200,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'主管税务机关'};
			var taxmanagercodeCol = {'field':'taxmanagercode','width':100,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'税收管理员代码','orgcol':'taxmanagername'};
			var taxmanagernameCol = {'field':'taxmanagername','width':120,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'税收管理员'};

            var taxyearCol = {'field':'taxyear','width':100,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'所属期年份'};
			var taxyearmonthCol = {'field':'taxyearmonth','width':100,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'所属期月份'};
			var shouldtaxmoneyCol = {'field':'shouldtaxmoney','width':120,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'应纳税总额'};
			var avoidtaxmoneyCol = {'field':'avoidtaxmoney','width':120,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'减免总额'};
			var owetaxmoneyCol = {'field':'owetaxmoney','hidden':false,'width':120,'align':'center','editor':{'type':'validatebox'},'title':'欠税总额'};
			var alreadyshouldtaxmoneyCol = {'field':'alreadyshouldtaxmoney','hidden':false,'width':120,'align':'center','editor':{'type':'validatebox'},'title':'已清缴'};
			var stayinspecttaxmoneyCol = {'field':'stayinspecttaxmoney','hidden':false,'width':120,'align':'center','editor':{'type':'validatebox'},'title':'待核查'};

			result.push(taxpayeridCol.field,taxpayeridCol);
			result.push(taxpayernameCol.field,taxpayernameCol);
			result.push(taxtypecodeCol.field,taxtypecodeCol);
			result.push(taxtypenameCol.field,taxtypenameCol);

			result.push(taxcodeCol.field,taxcodeCol);
			result.push(taxnameCol.field,taxnameCol);
			result.push(taxorgcodeCol.field,taxorgcodeCol);
			result.push(taxorgnameCol.field,taxorgnameCol);
			
			result.push(taxdeptcodeCol.field,taxdeptcodeCol);
			result.push(taxdeptnameCol.field,taxdeptnameCol);
			result.push(taxmanagercodeCol.field,taxmanagercodeCol);
			result.push(taxmanagernameCol.field,taxmanagernameCol);

			result.push(taxyearCol.field,taxyearCol);
			result.push(taxyearmonthCol.field,taxyearmonthCol);
			result.push(shouldtaxmoneyCol.field,shouldtaxmoneyCol);
			result.push(avoidtaxmoneyCol.field,avoidtaxmoneyCol);
			result.push(owetaxmoneyCol.field,owetaxmoneyCol);
			result.push(alreadyshouldtaxmoneyCol.field,alreadyshouldtaxmoneyCol);
			result.push(stayinspecttaxmoneyCol.field,stayinspecttaxmoneyCol);

            return result;
	}
    function ColState(field,orgfield,display){
    	this.field = field;
    	this.orgfield = orgfield;
    	this.display = display;
    }
    function inititalColState(){
    	var result = new Map();
    	result.push("taxpayerid",new ColState('taxpayerid','taxpayername',false));
    	result.push("taxpayername",new ColState('taxpayername','taxpayerid',true));
    	result.push("taxtypecode",new ColState('taxtypecode','taxtypename',false));
    	result.push("taxtypename",new ColState('taxtypename','taxtypecode',true));
    	result.push("taxcode",new ColState('taxcode','taxname',false));
    	result.push("taxname",new ColState('taxname','taxcode',true));
    	result.push("taxorgcode",new ColState('taxorgcode','taxorgname',false));
    	result.push("taxorgname",new ColState('taxorgname','taxorgcode',true));
    	result.push("taxdeptcode",new ColState('taxdeptcode','taxdeptname',false));
    	result.push("taxdeptname",new ColState('taxdeptname','taxdeptcode',true));
    	result.push("taxmanagercode",new ColState('taxmanagercode','taxmanagername',false));
    	result.push("taxmanagername",new ColState('taxmanagername','taxmanagercode',true));
    	result.push("taxyear",new ColState('taxyear','taxyear',true));
    	result.push("taxyearmonth",new ColState('taxyearmonth','taxyearmonth',true));
    	return result;
    }
    var colStateMap = inititalColState();
    var mapColumn = initialColumn();
   
    function getDisplayColumn(ary){
    	var result = new Array();
    	for(var i = 0;i < ary.length;i++){
    		var field = ary[i];
    		var value = colStateMap.get(field);
    		if(value == null){
    			$.messager.alert('提示消息','属性配置没有找到!','info');
    		}
    		if(value && value.display){
    			result.push(field);
    		}
    	}
    	return result;
    }
    var managerLink = new OrgLink("9");
    managerLink.sendMethod = true;
    
    var taxLink = new TaxLink("taxtypecode","10,12,20",true,"taxcode");
	$(function(){
		  
		    managerLink.loadData();
		    taxLink.loadData();
		    
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
				pagination:true
			});
			
			p = $('#shouldtaxdetailgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			$('#totalgrid').datagrid({
				fitColumns:false,
				pageList:100
			});
			p = $('#totalgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			
		});
	    function getWhereCondition(params){
	    	
	    	var result = '';
	    	if(params.taxorgsupcode){
	    		result += " and a.taxorgsupcode = '"+params.taxorgsupcode+"' ";
	    	}
	    	if(params.taxorgcode){
	    		result += " and a.taxorgcode = '"+params.taxorgcode+"' ";
	    	}
	    	if(params.taxdeptcode){
	    		result += " and a.taxdeptcode = '"+params.taxdeptcode+"' ";
	    	}
	    	if(params.taxmanagercode){
	    		result += " and a.taxmanagercode = '"+params.taxmanagercode+"' ";
	    	}
	    	if(params.taxpayerid){
	    		result += " and a.taxpayerid = '"+params.taxpayerid+"' ";
	    	}
	    	if(params.taxpayername){
	    		result += " and a.taxpayername like '%"+params.taxpayername+"%' ";
	    	}
	    	if(params.taxtypecode){
	    		result += " and substring(b.taxcode,1,2) = '"+params.taxtypecode+"' ";
	    	}
	    	if(params.taxcode){
	    		result += " and b.taxcode = '"+params.taxcode+"' ";
	    	}
	    	if(params.begindate){
	    		result += " and b.taxbegindate >= '"+params.begindate+"' ";
	    	}
	    	if(params.enddate){
	    		result += " and b.taxenddate <= '"+params.enddate+"' ";
	    	}
	    	return result;
	    }
	    /*
	        row.taxtypename = '小计';
	    			       $('#groundstoragegrid').datagrid('refreshRow', i); 
	    				   $('#groundstoragegrid').datagrid('mergeCells',{
	    					 index:1,
	    					 field:'taxtypename',
	    					 rowspan:2,
	    					 colspan:5
	    				   }); 
	    */
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
    			if(row.state == 2){  //小计 
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
	    
		function query(){
			$('#groundstoragegrid').datagrid('load',[]);
			var rows = $('#totalgrid').datagrid('getRows');
			if(!rows || rows.length == 0){
				$.messager.alert('提示消息','请选择展现内容，再进行查询!','info');
				return;
			}
			var params = {};
			var fields =$('#shouldtaxqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			});
			var whereCondition = getWhereCondition(params);
			
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
			
			subtotalFieldAry = getDisplayColumn(subtotalAry);   //只包含显示的项
			
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
			groupFieldAry = getDisplayColumn(tempAry);  //只包含显示的项
			var colDisplayStrs = groupFieldAry.join(',')+',shouldtaxmoney,avoidtaxmoney,owetaxmoney,alreadyshouldtaxmoney,stayinspecttaxmoney';
			var subtotalField = subtotalAry.length == 0 ? '' : subtotalAry.join(',');
			
			//opts.columns 是数组中再有数组[[col1,col2]]
			var columnAry = new Array();
			var colAry = new Array();
			columnAry.push(colAry);
			
			var colStrs = colDisplayStrs.split(',');
			for(var i = 0;i < colStrs.length;i++){
			   var key = colStrs[i];
			   var col = mapColumn.get(key);
			   if(col){
			      colAry.push(col);
			   }
			}
			columnArray = columnAry;
			var newParams = {};
			newParams['selectFields'] =  tempAry.join(',');
			newParams['whereCondition'] = whereCondition;
			newParams['subtotalField'] = subtotalField;
			newParams['rows'] = 100;
			$('#groundstoragegrid').datagrid({
				columns:columnAry
			});
           
			var opts = $('#groundstoragegrid').datagrid('options');
			opts.url = '/shouldtaxgather/shouldtaxgathertotal.do?d='+new Date();
			$('#groundstoragegrid').datagrid('load',newParams); 
			var p = $('#groundstoragegrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
			
			$('#groundstoragequerywindow').window('close');			
		}
		function openQuery(){
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
		
		function queryDetail(row){
			var params = {};
			var fields =$('#groundstoragequeryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
	 		    
			if(row.taxPayerId != null){
				params['taxpayerid'] = row.taxPayerId;
			}
			if(row.taxPayerName != null){
				params['taxpayername'] = row.taxPayerName;
			}
			if(row.taxTypeCode != null){
				params['taxTypeCode'] = row.taxTypeCode;
			}
			if(row.taxempCode != null){
				params['taxempCode'] = row.taxempCode;
			}
			if(row.taxyear != null){
				params['taxyear'] = row.taxyear;
			}
			if(row.taxyearmonth != null){
				params['taxyearmonth'] = row.taxyearmonth;
			}
			var d  = new Date(row.taxBeginDate);
			if(row.taxBeginDate != null){
				params['taxBeginDate'] = d;
			}

			var opts = $('#shouldtaxdetailgrid').datagrid('options');
			opts.url = '/shouldtaxgather/shouldtaxgatherdetail.do';
			
			$('#shouldtaxdetailgrid').datagrid('load',params); 
			var p = $('#shouldtaxdetailgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
		}
		function viewDetail(){
		    var row = $('#groundstoragegrid').datagrid('getSelected');
		    if(row == null){
		    	alert("请选中你要查看的明细行！");
		    	return;
		    }
		    $('#shouldtaxdetail').window('open'); 
		    queryDetail(row);
		}
		
		function addCheckBox(value,row,index){
			var result = "";
			result = "<input type='checkbox' value='"+row.key+"' />";
			return result;
		}

		function exit(){
			var oIframes = parent.$("iframe");
			var currentUrl = "/tdgs/shouldtaxgather/shouldtaxgatherpage.jsp";
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
    <div>
    <form id="groundstorageform" method="post">
	<table id='groundstoragegrid' class="easyui-datagrid" style="width:1320px;height:560px;overflow: scroll;"
			data-options="iconCls:'icon-edit',singleSelect:true,toolbar:'#tb',pageList:[100],
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
			    <th data-options="field:'taxtypename',width:120,align:'center',editor:{type:'validatebox'}">税种</th>
				<th data-options="field:'shouldTaxMoney',width:120,align:'center',editor:{type:'validatebox'}">应纳税总额</th>
				<th data-options="field:'oweTaxMoney',width:120,align:'center',editor:{type:'validatebox'}">欠税总额</th>
				<th data-options="field:'alreadyShouldTaxMoney',width:120,align:'center',editor:{type:'validatebox'}">已清缴</th>
			    <th data-options="field:'stayInspectTaxMoney',width:120,align:'center',editor:{type:'validatebox'}">待核查</th>
			</tr>
		</thead>
	</table>
    </form>
	<div id="tb" style="height:auto">
		<div style="height:25px;">
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询统计</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print',plain:true" onclick="">打印</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="">导出</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-tip',plain:true" onclick="viewDetail()">查看明细</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true" onclick="exit();">退出</a>
		</div>
	</div>
	
	</div>
	<div id="groundstoragequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税查询统计条件',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:640px;height:560px;">
		<div style="height: 25px;margin-top: 5px;color: blue;"><fieldset>查询条件</fieldset></div>
		<div class="easyui-panel" style="width:620px;">
			<form id="shouldtaxqueryform" method="post">
				<table id="narjcxx" width="100%"  cellpadding="10" cellspacing="0">
				  
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
						<td align="right">计算机编码：</td>
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername"/>
						</td>

					</tr>
					<tr>
					    <td align="right">税种：</td>
						<td>
							<input id="taxtypecode" class="easyui-combobox" type="text" name="taxtypecode"/>
						</td>
						<td align="right">税目：</td>
						<td>
							<input id="taxcode" class="easyui-combobox" type="text" name="taxcode"/>
						</td>
					</tr>
					<tr>
						<td align="right">所属期：</td>
						<td colspan="5">
							<input id="begindate" class="easyui-datebox" name="begindate"/>
						至
							<input id="enddate" class="easyui-datebox"  name="enddate"/>
						</td>
					</tr>
				</table>
			</form>
			
		</div>
		<div class="easyui-panel" style="width:620px;height: 240px;">
		        <div style="height: 25px;margin-top: 5px;color: blue;"><fieldset>展现内容</fieldset></div>
		        <div>
				<table  width="100%"  cellpadding="5" cellspacing="0">
					<tr>
						<td align="left">
						    <div class="easyui-panel" style="width:300px;height: 195px;" data-options="border:false">
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
								<table id='totalgrid' class="easyui-datagrid" style="width:285px;height:195px;overflow: scroll;"
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
				</div>
	    </div>
			
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
	</div>
	
	<div id="shouldtaxdetail" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税明细信息',collapsible:false,minimizable:false,maximizable:false,closable:true" 
	   style="width:1120px;height:440px;">
            <div style="text-align:center;padding:5px;height:25px;" id="detailTotalDiv">  
				 
			</div>
			<table id='shouldtaxdetailgrid' class="easyui-datagrid" style="width:1100px;height:360px;overflow: scroll;"
			data-options="iconCls:'icon-edit',singleSelect:true,idField:'taxPayerId',onLoadSuccess:function(data){
			   var detail = data.detailTotal;
			   var shouldTaxMoney = detail.shouldTaxMoney;
			   var alreadyTaxMoney = detail.alreadyTaxMoney;
			   var stayInspectTaxMoney = detail.stayInspectTaxMoney;
			   var oweTaxMoney = detail.oweTaxMoney;
			   var oText = '应纳税金额：'+shouldTaxMoney+'，已纳税、清缴金额：'+alreadyTaxMoney+'，待核查金额：'+stayInspectTaxMoney+'，欠税金额：'+oweTaxMoney;
			   $('#detailTotalDiv').text(oText);
			  
			}">
				<thead>
					<tr>
						<th data-options="field:'taxPayerId',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxPayerName',width:130,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxTypeName',width:120,align:'center',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxName',width:120,align:'center',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'taxempName',width:100,align:'center',editor:{type:'validatebox'}">专管员</th>
						<th data-options="field:'taxStateName',width:100,align:'center',editor:{type:'validatebox'}">纳税状态</th>
						<th data-options="field:'taxBeginDate',width:80,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">所属期起</th>
						<th data-options="field:'taxEndDate',width:80,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">所属期止</th>
						<th data-options="field:'payDate',width:80,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">催缴日期</th>
						<th data-options="field:'shouldTaxMoney',width:80,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">金额</th>
						
					</tr>
				</thead>
			</table>
	</div>
</body>
</html>