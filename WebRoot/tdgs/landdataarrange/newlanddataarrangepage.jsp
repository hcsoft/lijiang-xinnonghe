<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<style type="text/css">
	    #mainWestDiv .datagrid-row-over{
			background:#fece2f;
			cursor:default;
		}
		#mainWestDiv .datagrid-row-selected{
			background:#fece2f;
		}
	</style>
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
	function StateData(checked,id,name){
		this.checked = checked;
		this.id = id;
		this.name = name;
	}
	function CompareData(ck,key,value,exportkey,exportvalue){
		this.ck = ck;
		this.key = key;
		this.value = value;
		this.exportkey = exportkey;
		this.exportvalue = exportvalue;
	}
	var stateDatas = [
		   new StateData(false,0,'导入'),new StateData(false,1,'无对应'),new StateData(false,2,'已关联未匹配'),
		   new StateData(false,3,'系统自动匹配'),new StateData(false,4,'人工确认匹配')
		];
	
	var managerLink = new OrgLink("9");
	managerLink.sendMethod = false;
	var loadBody = false;
	$(function(){
		    managerLink.loadData();
		    var p = $('#landdataarrangegrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
			});
		    
			$('#selldetailgrid').datagrid({
				fitColumns:false,
				rowStyler:settings.rowStyle,
				onClickRow:function(rowIndex,rowData){
				        getLandInfo();
				}
			});
			$('#landgrid').datagrid({
				fitColumns:false,
				rowStyler:settings.rowStyle
			});
			var clickEvent = function(){
				if(loadBody){
					query();
				}
			}
			$('#paramgrid').datagrid({
				fitColumns:false,
				onClickRow:clickEvent,
				onCheck:clickEvent,
				onUncheck:clickEvent,
				onCheckAll:clickEvent,
				onUncheckAll:clickEvent
			});
			
			$('#paramgrid').datagrid('loadData',stateDatas); 
			$('#paramgrid').datagrid('checkRow',1); 
			$('#paramgrid').datagrid('checkRow',2); 
			                                                  
			var compareDataAry = [
				   new CompareData(true,' and sourcelandcertificate= landcertificate ','按土地证号','comparenotes1','土地证号(比对情况)'),
				   new CompareData(true,' and sourcedetailaddress = detailaddress ','按地址','comparenotes2','地址(比对情况)'),
				   new CompareData(true,' and sourcearea = landarea ','按面积','comparenotes3','面积(比对情况)'),
				   new CompareData(true,' and sourcedate = holddate ','按日期','comparenotes4','日期(比对情况)'),
				   new CompareData(true,' and sourceestateserial = estateserial ','按宗地编号','comparenotes5','宗地编号(比对情况)')
				   ];
			$('#comparegrid').datagrid('loadData',compareDataAry);
						
			//设置进度条的边框
			var oParent = $('#processDialog').parent();
			oParent.css('padding','0');
			oParent.css('border-width','0');
			

		    //dataArrange();
		    loadBody = true;
		    $('#checkAllMatchCb').unbind("click");
		    $('#checkAllMatchCb').bind("click",function(){
		    	  checkAllMatch();
            });
		    
		});
	    
	    function openQuery(){
	    	$('#querywindow').window('open');
	    }
	    function getParamGridRow(index){
	    	var rows = $('#paramgrid').datagrid('getRows');
	    	for(var i = 0;i < rows.length;i++){
	    		if(index == i)
	    			return rows[i];
	    	}
	    }
	    function getCondition(){
	    	var result = {};
			var fields =$('#queryform').serializeArray();
			$.each(fields, function(i, field){
				result[field.name] = field.value;
			}); 
			var stateStr = '';
			result['datatype'] = '0';
			result['rows'] = 15;
            			
			var oCk = $("#mainWestDiv").find("input[type='checkbox']");
			
			for(var i = 1 ; i < oCk.length;i++){
				var r = getParamGridRow(i-1);
				if(oCk[i].checked){
					stateStr += (r.id+',');
				}
			}
			stateStr = stateStr.substring(0,stateStr.length-1);
			result['stateStr'] = stateStr;
			return result;
	    }
	     
		function query(){
			$('#totalNum').text('');
			$('#matchNum').text('');
			$('#partmatchNum').text('');
			$('#notmatchNum').text('');
			$('#personMatchNum').text('');
			var params = getCondition();
			var opts = $('#landdataarrangegrid').datagrid('options');
			opts.url = '/newlanddataarange/landdatainfo.do?d='+new Date();
			$('#landdataarrangegrid').datagrid('load',params); 
			$('#querywindow').window('close');
		}
		/**
		 * 导出数据至明细excel
		 */
		function exportMatchResultExcel(){
			var params = getCondition();
			var where = '';
			var exportkey = '';
			var exportvalue = '';
			
			var oCk = $("#comparewindow").find("input[type='checkbox']");
			for(var i = 1 ; i < oCk.length;i++){
				if(oCk[i].checked){
					var row = getCompareGridRow(i-1);
					where += row.key;
					exportkey += ','+row.exportkey;
					exportvalue += ','+row.exportvalue;
				}
			}
			
			params['comparewhere'] = where;
			params['compareCol']="1,2,3,4,5,6,7,8,9,10";
			params['mergeCols'] = "1,2,3,4,5,6,7,8,9,10";
			params['propertyNames'] = 'statename,sourcetaxpayerid,sourcetaxpayername,sourcetaxdeptname,sourcetaxmanagername,sourceestateserial,sourcedetailaddress,' +
			'sourcelandcertificate,sourcearea,sourcedate,taxpayerid,taxpayername,estateserial,detailaddress,landcertificate,landarea,holddate'+exportkey;
			params['displayNames'] = '状态,计算机编码(外部),纳税人名称(外部),主管机关,税收管理员,宗地编号(外部),详细地址(外部),土地证号(外部),' +
			'面积(外部),获取日期(外部),计算机编码(采集),纳税人名称(采集),宗地编号(采集),详细地址(采集),土地证号(采集),面积(采集),获取日期(采集)'+exportvalue;
			params['excelName'] = '出让数据比对结果.xls';	
			$('#comparewindow').window('close');
			CommonUtils.downloadFile("/landdataarange/excelmatchresultexport.do?date="+new Date(),params);

		}
		
		function getCompareGridRow(index){
			var rows = $('#comparegrid').datagrid('getRows');
	    	for(var i = 0;i < rows.length;i++){
	    		if(index == i)
	    			return rows[i];
	    	}
		}
		var exportType = null;
		function openCompareWindow(t){
			exportType = t;
			if(exportType == 1){
				 $('#exportHref').hide();
				 $('#compareHref').show();
			}else if(exportType == 0)
			{
				 $('#exportHref').show();
				 $('#compareHref').hide();
			}
			
			var oCk = $("#comparewindow").find("input[type='checkbox']");
			for(var i = 1 ; i < oCk.length;i++){
				oCk[i].checked = true;
			}
			$('#comparewindow').window('open');
		}
		function exportOrMatch(){
			if(exportType == 1){
				dataArrange(true);
			}else if(exportType == 0){
				exportMatchResultExcel();
			}
		}  
		
		
		var i = 0;
		function openProcess(){
			var value = $('#processDialog').progressbar('getValue');
			if (value < 100){
				value += Math.floor(Math.random() * 10);
				$('#processDialog').progressbar('setValue', value);
			}
			if(value == 100){
				$('#processDialog').progressbar('setValue', 0);
			}
		}
		
		function dataArrange(showConfigWindow){
			$('#processDialog').window('open');
			var timerId = setInterval(openProcess,200);
			var params = {};
			var fields =$('#queryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			var where = '';
			var notes = '';
			var oCk = $("#comparewindow").find("input[type='checkbox']");
			for(var i = 1 ; i < oCk.length;i++){
				if(oCk[i].checked){
					var row = getCompareGridRow(i-1);
					where += row.key;
					notes += '+'+row.exportkey;
				}
			}
			if(notes != ''){
				notes = notes.substring(1);
			}
			
			params['comparewhere'] = where;
			params['compareNotes'] = notes;
			params['compareid'] = '';
			//params 只有taxorgsupcode、taxorgcode起作用。
			$('#comparewindow').window('close');
			$.ajax({
				   type: "get",
				   async:false,
				   url: "/newlanddataarange/landdatacompare.do?date="+new Date(),
				   data:params,
				   dataType: "json",
				   success: function(jsondata){
					   	if(jsondata.sucess == true){
					   		 $('#processDialog').window('close');
					   	      clearInterval(timerId);	
					   		query();
					   		var total = jsondata.result.total;
					   		var match = jsondata.result.match;
					   		var partmatch = jsondata.result.partmatch;
					   		var notmatch = jsondata.result.notmatch;
					   		var personmatch = jsondata.result.personmatch;
					   		
					   		$('#totalNum').text(total);
					   		$('#matchNum').text(match);
					   		$('#partmatchNum').text(partmatch);
					   		$('#notmatchNum').text(notmatch);
					   		$('#personMatchNum').text(personmatch);
					   		if(showConfigWindow){
						   		$.messager.alert('提示消息','数据比对完成!','info');
						   		var params = getCondition();
								var opts = $('#landdataarrangegrid').datagrid('options');
								opts.url = '/newlanddataarange/landdatainfo.do?d='+new Date();
								$('#landdataarrangegrid').datagrid('load',params); 
								$('#querywindow').window('close');
					   		}
					   		
					   	}else{
					   		$.messager.alert('提示消息','进行数据比对发生错误!','error');
					   	}
				   }
			});
			
		}
		
		function exit(){
			var oIframes = parent.$("iframe");
			var currentUrl = "/tdgs/landdataarrange/landdataarrangepage.jsp";
			for(var i = 0;i < oIframes.length;i++){
				var oSrc =  oIframes.get(i).src;
				if(oSrc.indexOf(currentUrl) != -1){
					var oDiv = $(oIframes.get(i)).parent().parent().parent();
					var oId = oDiv[0].id;
				    parent.$('#'+oId).dialog('close');
				}
			}
		}
		function getRow(index){
			var rows = $('#landgrid').datagrid('getRows');
			for(var i = 0;i < rows.length;i++){
				if(i == index){
					return rows[i];
				}
			}
		}
		function queryLandInfo(){
			checkLand();
			$('#landquerywindow').window('close');
		}
		function checkLand(){
			$('#landDiv').window('open');
			var params1 = {};
			var params = {};
			var fields =$('#landqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params1[field.name] = field.value;
			});
			for(var p in params1){
				params[p.substr(0,p.length-1)] = params1[p];
			}
			params['bustype'] = 0;
			var opts = $('#groundtransfergrid').datagrid('options');
			opts.url = '/landdataarange/selectland.do?d='+new Date();
			$('#groundtransfergrid').datagrid('load',params); 
			var p = $('#groundtransfergrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
		}
		
		function matchCompare(index){
			$('#detailDiv').window('open');
			var sourceRow = $('#selldetailgrid').datagrid('getSelected');
			var estateRow = getRow(index);
			if(sourceRow && estateRow){
				var showInfo = getCompareMsg(sourceRow,estateRow);
				$.messager.confirm('确认需要匹配吗？', showInfo, function(r){
					if (r){
						var landgainid = sourceRow.landgainid;
						var estateid = estateRow.estateid;
						var notes = estateRow.remark;
						var bustype = $('#bustype').val();
						if(landgainid && estateid && bustype){
							$.ajax(
						   {
							   type:'post',
							   url:'/landdataarange/matchcomplete.do?date'+new Date(),
							   data:{'landgainid':landgainid,'estateid':estateid,'bustype':bustype,'notes':notes},
							   async:false,
							   dataType:'json',
							   success:function(jsondata){
								   if(jsondata.sucess){
									   queryCompareInfo(null);
									   query();
									   $.messager.alert('提示消息','完全匹配数据成功！','info');
		                               
								   }else{
									   $.messager.alert('提示消息','完全匹配数据失败！','error');
								   }
							   }
						   });
						}
					}
				});
				var msgWindow = $('.messager-window');
				msgWindow.css('width','420px');
				var childDivs = msgWindow.children();
				for(var i = 0;i < childDivs.length;i++){
					if(i == 0){
					    $(childDivs[i]).css('width','420px');
					}
					if(i == 1){
						$(childDivs[i]).css('width','400px');
					}
				}
				$('.window-shadow').hide();
				$('.messager-question').hide();
				
			}
		}
		
		
		function addButton(value,row,index){
			/*
			if(value == 2){
				return "<input type='button' value='备注' onclick='addnotes("+index+")'/>";
			}else{
				return "<input type='button' value='匹配' onclick='matchCompare("+index+")'/>"+
				       "<input type='button' value='备注' onclick='addnotes("+index+")'/>";
			}
			*/
			return "<input type='button' value='匹配' onclick='matchCompare("+index+")'/>"+
				       "<input type='button' value='备注' onclick='addnotes("+index+")'/>";
	    }
		function addLandCheckButton(value,row,index){
			   return "<input type='button' value='选择' onclick='checkLandRow("+index+")'/>";
	    }
		function checkLandRow(index){
			var rows = $('#groundtransfergrid').datagrid('getRows');
			var row = null;
			for(var i = 0;i < rows.length;i++){
				if(i == index){
					row = rows[i];
					break;
				}
			}
			if(row){
				$('#landDiv').window('close');
				$('#landgrid').datagrid('appendRow',row);
				
			}
			
		}
		function addCheckBox(value,row,index){
			var result = "";
			if(row.state == 4){   //完全匹配
				 result = "<input type='checkbox' value='"+row.landgainid+"' />";
			}
			return result;
		}
		var checkedCb = false;
		function checkAllMatch(cb){
			checkedCb = !checkedCb;
			var oCk = $("#sourceDiv").find("input[type='checkbox']");
			for(var i = 0 ; i < oCk.length;i++){
				if(checkedCb){
					oCk[i].checked="checked"
				}else{
					oCk[i].checked = 'false';
				}
				oCk[i].checked = checkedCb;
			}
		}
	</script>
</head>
<body>
    <div class="easyui-layout" style="width:100%;height:526px;">
	    <div data-options="region:'center'" style="height:500px;overflow: visible;" id="sourceDiv">
	     <form id="landdataarrangeform" method="post">
			<table id='landdataarrangegrid' class="easyui-datagrid" style="height:500px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,
				fitColumns:false,
				maximized:'true',
				pagination:true,
				pageList:[15],
				rowStyler:settings.rowStyle">
				<thead>
					<tr>
						<th data-options="field:'compareid',hidden:true,width:100,align:'center',editor:{type:'validatebox'}">主键</th>
						<th data-options="field:'state1',width:100,align:'center',formatter:addCheckBox"><input type="checkbox" id="checkAllMatchCb"/></th>
						<th data-options="field:'state',hidden:true,width:100,align:'center',editor:{type:'validatebox'}">状态代码</th>
						<th data-options="field:'statename',width:100,align:'center',editor:{type:'validatebox'}">状态</th>
						<th data-options="field:'taxpayerid',width:160,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:230,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'importtaxpayername',width:230,align:'left',editor:{type:'validatebox'}">导入纳税人名称</th>
						<th data-options="field:'area',width:230,align:'left',editor:{type:'validatebox'}">面积</th>
						<th data-options="field:'gaindate',width:120,align:'center',editor:{type:'validatebox'}">实际交互使用日期</th>
						<th data-options="field:'estateserial',width:230,align:'left',editor:{type:'validatebox'}">宗地编号</th>
						
						<th data-options="field:'landcertificate',width:120,align:'center',editor:{type:'validatebox'}">土地证号</th>
						<th data-options="field:'detailaddress',width:120,width:120,align:'center',editor:{type:'validatebox'}">详细地址</th>
						<th data-options="field:'taxdeptname',align:'center',editor:{type:'validatebox'}">主管税务机关</th>
						<th data-options="field:'taxmanagername',width:100,align:'center',editor:{type:'validatebox'}">专管员</th>
					</tr>
				</thead>
			</table>
	    </form>
	    </div>
	    <div data-options="region:'west'" id="mainWestDiv" style="height:500px;width:160px;overflow: hidden;">
	        <table id='paramgrid' class="easyui-datagrid" style="height:500px;width:160px;overflow: hidden;"
					data-options="iconCls:'icon-edit',idField:'itemid',rowStyler:function(x,x){
                        return 'background-color:#fff;';
                    }">
				<thead>
					<tr>
					    <th data-options="field:'checked',width:50,align:'center',checkbox:true,editor:{type:'checkbox'}"></th>
						<th data-options="field:'id',hidden:true,width:0,align:'center',editor:{type:'validatebox'}">主键</th>
						<th data-options="field:'name',width:125,align:'center',editor:{type:'validatebox'}">比对状态</th>
					</tr>
				</thead>
			</table>
	    </div>
		<div id="tb" data-options="region:'north'" style="height:25px;width:100%;overflow: visible">
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="openCompareWindow(1)">数据比对</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="openCompareWindow(0)">导出比对结果EXCEL</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-tip',plain:true" onclick="queryCompareInfo()">手工匹配</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true" onclick="undoAllCheckMatch()">撤销完全匹配</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true" onclick="exit();">退出</a>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<span>
				                参与比对数：<span id="totalNum" name="totalNum" style="color: red;font-weight: bold;font-size: 50;"></span>
				               系统完全匹配数：<span id="matchNum" name="matchNum" style="color: red;font-weight: bold;font-size: 50;"></span>
				               人工确认匹配数：<span id="personMatchNum" name="matchNum" style="color: red;font-weight: bold;font-size: 50;"></span>
				               无对应数：<span id="notmatchNum" name="partmatchNum" style="color: red;font-weight: bold;font-size: 50;"></span> 
				               已关联未匹配数：<span id="partmatchNum" name="notmatchNum" style="color: red;font-weight: bold;font-size: 50;"></span>
				</span>
			</div>
		</div>
	
	</div>
	
	<div id="processDialog" class="easyui-window easyui-progressbar" data-options="closed:true,modal:true,collapsible:true,noheader:true,border:false"  
	style="width:300px;height:45px;">
	</div>
	
	<div id="comparewindow" class="easyui-window" data-options="border:false,closed:true,modal:true,title:'比对条件',collapsible:false,minimizable:false,maximizable:false,closable:true" 
	style="width:440px;height:260px;">
		<div class="easyui-panel" data-options='border:false' title="" style="width:420px;">
		    <table id='comparegrid' class="easyui-datagrid" style="height:180px;width:420px;overflow: hidden;"
					data-options="iconCls:'icon-edit'">
				<thead>
					<tr>
					    <th data-options="field:'ck',width:50,align:'center',checkbox:true,editor:{type:'checkbox'}"></th>
						<th data-options="field:'key',hidden:true,width:0,align:'center',editor:{type:'validatebox'}"></th>
						<th data-options="field:'exportkey',hidden:true,width:0,align:'center',editor:{type:'validatebox'}"></th>
						<th data-options="field:'exportvalue',hidden:true,width:0,align:'center',editor:{type:'validatebox'}"></th>
						<th data-options="field:'value',width:365,align:'center',editor:{type:'validatebox'}">比对条件</th>
					</tr>
				</thead>
			</table>
			<div style="text-align:center;padding:5px;">  
			       
			    
					<a id = 'exportHref' href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="exportOrMatch()">导出</a>
					<a id = 'compareHref' href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="exportOrMatch()">比对</a>
			</div>
		</div>
	</div>
	
	
	<div id="querywindow" class="easyui-window" data-options="closed:true,modal:true,title:'数据整理查询条件',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:640px;height:250px;">
		<div class="easyui-panel" title="" style="width:620px;">
		    
			<form id="queryform" method="post">
				<table id="narjcxx" width="100%"  cellpadding="10" cellspacing="0">
				    <input type="hidden" id="bustype" name="bustype" value="0" />
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
						<td align="right">交互日期：</td>
						<td colspan="5">
							<input id="beginGainDate" class="easyui-datebox" name="beginGainDate"/>
						至
							<input id="endGainDate" class="easyui-datebox"  name="endGainDate"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	
</body>
</html>