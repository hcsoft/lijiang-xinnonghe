<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<base target="_self"/>
	<title>外部数据整理核实</title>

	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/toolbar.css">
	<link rel="stylesheet" href="/css/logout.css"/>
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
    <script src="/js/tiles.js"></script>
    <script src="/js/moduleWindow.js"></script>
	<script src="/menus.js"></script>
	
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>
	<script src="/js/datecommon.js"></script>	
    <script src="/js/common.js"></script>	
    
    <script>
    var taxorgdata = new Object;
	var taxempdata = new Object;
	var optcolumn =[[
					{field:'serialno',hidden:true,width:18},
					{field:'oper',title:'相关信息',formatter:addOper,width:100,align:'center'},
					{field:'oper1',title:'查看操作',formatter:addViewOper,width:200,align:'center'},
					{field:'comparestatename',title:'比对状态',width:100,align:'center'},
					{field:'checkstatename',title:'核查状态',width:100,align:'center'},
					{field:'taxpayerid',title:'计算机编码',width:100,align:'center'},
					{field:'taxpayername',title:'纳税人名称',width:260,align:'left'},
					{field:'importtaxpayername',title:'导入纳税人名称',width:260,align:'left'},
					{field:'holddate',title:'土地获得日期',formatter:formatterDate,width:100,align:'center'},
					{field:'area',title:'土地面积',formatter:formatnumber,width:100,align:'right'},
					{field:'address',title:'详细地址',width:260,align:'left'},
					{field:'landcertificate',title:'土地证号',width:200,align:'center'},
					{field:'estateserial',title:'宗地编号',width:100,align:'center'},
					{field:'getmoney',title:'成交价',width:100,align:'center'},
					{field:'telephone',title:'联系电话',width:100,align:'center'},
					{field:'importsourcename',title:'数据来源',width:100,align:'center'},
					{field:'taxdeptcode',title:'主管地税部门',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},width:260,align:'left'},
					{field:'taxmanagercode',title:'税收管理员',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},width:120,align:'left'}
				]];
	var showcolumn =[[
					{field:'serialno',hidden:true,width:18},
					{field:'comparestatename',title:'比对状态',width:100,align:'center'},
					{field:'checkstatename',title:'核查状态',width:100,align:'center'},
					{field:'taxpayerid',title:'计算机编码',width:100,align:'center'},
					{field:'taxpayername',title:'纳税人名称',width:260,align:'left'},
					{field:'importtaxpayername',title:'导入纳税人名称',width:260,align:'left'},
					{field:'holddate',title:'土地获得日期',formatter:formatterDate,width:100,align:'center'},
					{field:'area',title:'土地面积',formatter:formatnumber,width:100,align:'right'},
					{field:'address',title:'详细地址',width:260,align:'left'},
					{field:'landcertificate',title:'土地证号',width:200,align:'center'},
					{field:'estateserial',title:'宗地编号',width:100,align:'center'},
					{field:'getmoney',title:'成交价',width:100,align:'center'},
					{field:'telephone',title:'联系电话',width:100,align:'center'},
					{field:'importsourcename',title:'数据来源',width:100,align:'center'},
					{field:'taxdeptcode',title:'主管地税部门',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},width:260,align:'left'},
					{field:'taxmanagercode',title:'税收管理员',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},width:120,align:'left'}
				]];
    function CompareData(ck,key,value){
		this.ck = ck;
		this.key = key;
		this.value = value;
	}
    var compareDataAry = [
				   new CompareData(true,"  isnull(sourceestateserial,'1')  = isnull(destestateserial,'2')  ",'按宗地编号'),
				   new CompareData(true,"  isnull(sourcelandcertificate,'1')  = isnull(destlandcertificate,'2')  ",'按土地证号'),
				   new CompareData(true,"  isnull(sourcedetailaddress,'1')  = isnull(destdetailaddress,'2')  ",'按地址'),
				   new CompareData(true,"  isnull(sourcearea,0)  = isnull(destarea,1)  ",'按面积'),
				   new CompareData(true,"  isnull(sourceprice,0)  = isnull(destprice,2)  ",'按地价'),
				   new CompareData(true,"  convert(char,sourcedate,102) = convert(char,destdate,102) ",'按日期')
		    ];
	var managerLink = new OrgLink();
	managerLink.sendMethod = false;
	var loadBody = false;
	$(function(){
		    managerLink.loadData();
		    dataArrage();
			$('#comparegrid').datagrid('loadData',compareDataAry);
			$('#statustable input[type="checkbox"]').bind('click',function(){
				dataArrage();
			});
			$('#statustable input[type="radio"]').bind('click',function(){
				//alert($('#statustable input[type="radio"]:checked').val());
				//return;
				dataArrage();
			});
			$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXORGCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  taxorgdata= jsondata;
			   }
			});
			$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXEMPCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  taxempdata= jsondata;
			   }
			});
	 });
	function openDataArrange(){
		$('#comparewindow').window('open');
	}
	function dataArrage(){
		var params = getCondition();
		var column;
		if($('#statustable input[type="radio"]:checked').val()===" comparestate='3' "){
			column = optcolumn;
		}else{
			column = showcolumn;
		}
		$('#landdataarrangegrid').datagrid({
				iconCls:'icon-edit',
				singleSelect:true,
				fitColumns:false,
				maximized:'true',
				pagination:true,
				pageList:[15],
				queryParams:params,
				url:'/newdataarrange/getdataarrangeresult.do',
				rowStyler:settings.rowStyle,
				columns:column,
				onLoadSuccess:function(data){
					
					$('#matchNum').text(data.matchNum);
					$('#notmatchNum').text(data.notmatchNum);
					$('#partmatchNum').text(data.partmatchNum);
					
					$('#pageItem').text(parseInt(data.matchNum)+parseInt(data.notmatchNum)+parseInt(data.partmatchNum)+'');
					$('#matchspan').show();
				}
		});
		var p = $('#landdataarrangegrid').datagrid('getPager');  
	    $(p).pagination({  
				showPageList:false
		});
	}
	function getCondition(){
		var params = getWhereCondition();
		for(var p in params){
			console.log(p+'======='+params[p]);
		}
		var compareCondition = getCompareCondition();
		var otherCondition = getOtherCondition();
		params['compareCondition'] = compareCondition; 
		params['otherCondition'] = otherCondition; 
		console.log("compareCondition="+compareCondition);
		console.log("otherCondition="+otherCondition);
		return params;
	}
	function getWhereCondition(){
		var params = {};
	    var fields =$('#arrangeform').serializeArray();  
	    $.each(fields, function(i, field){
		  params[field.name] = field.value;
	    });
	    return params;
	}
	function getCompareCondition(){
		var compareAry = [];
	    for(var i = 0;i < compareDataAry.length;i++){
	    	if(compareDataAry[i].ck)
	    	  compareAry.push(compareDataAry[i].key);
	    }
	    if(compareAry.length>0)
	      return " and "+compareAry.join(' and ');
	    else
	      return '';
	}
	function getOtherCondition(){
		var otherCondition = '';
		var xary = [];
		var yary = [];
		$('#statustable input[data-type="x"]').each(function(i){
			if(this.checked)
			  xary.push(this.value);
		});
		$('#statustable input[data-type="y"]').each(function(i){
			if(this.checked)
			  yary.push(this.value);
		});
		if(xary.length > 0){
			otherCondition += " and ( "+xary.join(' or ') + ")";
		}
		if(yary.length > 0){
			otherCondition += " and ( "+yary.join(' or ') + ")";
		}
		return otherCondition;
	}
	function addOper(value,row,index){
		var result = "";
		var x = '123';
		if(row.checkstate == 0){   //完全匹配
			 result = '<a href="javascript:openCommitCheck(\''+row.serialno+'\',\''+row.checkstate+'\')")>开始核查</a>';
		}else if(row.checkstate == 1){   //完全匹配
			 result = '<a href="javascript:openCommitCheck(\''+row.serialno+'\',\''+row.checkstate+'\')")>填写核查意见</a>';
		}else if(row.checkstate == 2){
			result = "未审核";
		}else if(row.checkstate == 3){
			result = '<a href="javascript:openCommitCheck(\''+row.serialno+'\',\''+row.checkstate+'\')")>填写核查意见</a>';
		}else if(row.checkstate == 4){
			result = "审核通过";
		}
		return result;
	}
	function openCommitCheck(serialno,checkstate){
		$('#checkadvicewindow #serialno').val(serialno);
		if(checkstate==0){
			$.ajax({
			   type:'post',
			   url:'/newdataarrange/checking.do?date'+new Date(),
			   data:{'serialno':serialno},
			   async:true,
			   dataType:'json',
			   success:function(jsondata){
				   if(jsondata.sucess){
					   $.ajax({
							   type:'post',
							   url:'/newdataarrange/getestateadivice.do',
							   data:{'serialno':serialno},
							   async:true,
							   dataType:'json',
							   success:function(jsondata){
								   if(jsondata.length > 0){
									   for(var i = 0;i < jsondata.length;i++){
										   var obj = jsondata[i];
										   var info = '核查人：';
										   if(obj.taxempname){
											   info += obj.taxempname;
										   }
										   info+="  核查日期：";
										   if(obj.optdate){
											   info+=formatterDate(obj.optdate,0,0);
										   }
										   info += "<br/>审核人：";
										   if(obj.checkempname){
											   info += obj.checkempname;
										   }
										   info+=" 审核日期：";
										   if(obj.checkdate){
											   info+=formatterDate(obj.checkdate,0,0);
										   }
										   obj['checkestateinfo'] = info;
									   }
									   var lastobj = jsondata[jsondata.length-1];
									   if(!lastobj.checkempcode){
										   $('#checkadvicewindow #advice').val(lastobj.advice);
									   }
								   }else{
									   $('#checkadvicewindow #advice').val('');
								   }
								   $('#checkadvicetable').datagrid('loadData',[]);
								   $('#checkadvicetable').datagrid('loadData',jsondata);
								   
								   $('#checkadvicewindow').window('open');
							   }
						});
				   }else{
					   $.messager.alert('提示消息','开始核查数据失败！','error');
				   }
			   }
		   });
		}else{
			$.ajax({
				   type:'post',
				   url:'/newdataarrange/getestateadivice.do',
				   data:{'serialno':serialno},
				   async:true,
				   dataType:'json',
				   success:function(jsondata){
					   if(jsondata.length > 0){
						   for(var i = 0;i < jsondata.length;i++){
							   var obj = jsondata[i];
							   var info = '核查人：';
							   if(obj.taxempname){
								   info += obj.taxempname;
							   }
							   info+="  核查日期：";
							   if(obj.optdate){
								   info+=formatterDate(obj.optdate,0,0);
							   }
							   info += "<br/>审核人：";
							   if(obj.checkempname){
								   info += obj.checkempname;
							   }
							   info+=" 审核日期：";
							   if(obj.checkdate){
								   info+=formatterDate(obj.checkdate,0,0);
							   }
							   obj['checkestateinfo'] = info;
						   }
						   var lastobj = jsondata[jsondata.length-1];
						   if(!lastobj.checkempcode){
							   $('#checkadvicewindow #advice').val(lastobj.advice);
						   }
					   }else{
						   $('#checkadvicewindow #advice').val('');
					   }
					   $('#checkadvicetable').datagrid('loadData',[]);
					   $('#checkadvicetable').datagrid('loadData',jsondata);
					   
					   $('#checkadvicewindow').window('open');
				   }
			});
		}
		
		
	}
	function saveAndCommit(){
		var params = {
			'serialno':$('#checkadvicewindow #serialno').val(),
			'advice':$('#checkadvicewindow #advice').val(),
			'iscommit':'1'
		};
		console.log(params['serialno']+'='+params['advice']);
		commitAdivice(params);
	}
	function saveAndNotCommit(){
		var params = {
			'serialno':$('#checkadvicewindow #serialno').val(),
			'advice':$('#checkadvicewindow #advice').val(),
			'iscommit':'0'
		};
		console.log(params['serialno']+'='+params['advice']);
		commitAdivice(params);
	}
	function commitAdivice(params){
		$.ajax(
				   {
					   type:'post',
					   url:'/newdataarrange/commitcheck.do',
					   data:params,
					   async:true,
					   dataType:'json',
					   success:function(jsondata){
						   if(jsondata.sucess){
							   $.messager.alert('提示消息','提交核查意见成功！','info',function(){
								   if(params['iscommit'] == '1'){
									   var newparams = getCondition();
								       $('#landdataarrangegrid').datagrid('reload',newparams);
								   }
							   });
						   }else{
							   $.messager.alert('提示消息','提交核查意见失败！','error');
						   }
						   $('#checkadvicewindow').window('close');
					   }
				   });
	}
	function beginCheck(serialno){
		console.log('开始核查='+serialno);
		$.ajax(
		   {
			   type:'post',
			   url:'/newdataarrange/checking.do?date'+new Date(),
			   data:{'serialno':serialno},
			   async:true,
			   dataType:'json',
			   success:function(jsondata){
				   if(jsondata.sucess){
					   $.messager.alert('提示消息','开始核查数据成功！','info',function(){
						   var params = getCondition();
						   $('#landdataarrangegrid').datagrid('reload',params);
					   });
					   
				   }else{
					   $.messager.alert('提示消息','开始核查数据失败！','error');
				   }
			   }
		   });
	}
	function addViewOper(value,row,index){
		var result = "";
		result = '<a href="javascript:viewCheckEstateInfo(\''+row.serialno+'\')")>核查、审核意见</a>&nbsp;&nbsp;'
		+'<a href="javascript:getMatchInfo(\''+row.serialno+'\')")>比对情况</a>';
		return result;
	}
	function viewCheckEstateInfo(serialno){
		$.ajax({
			   type:'post',
			   url:'/newdataarrange/getestateadivice.do',
			   data:{'serialno':serialno},
			   async:true,
			   dataType:'json',
			   success:function(jsondata){
				   $('#checkadviceviewtable').datagrid('loadData',[]);
				   $('#checkadviceviewtable').datagrid('loadData',jsondata);
				   
				   $('#checkadviceviewwindow').window('open');
			   }
		});
	}
	function getMatchInfo(serialno){
		var params = getCondition();
		params['serialno'] = serialno;
		$.ajax({
			   type:'post',
			   url:'/newdataarrange/getmatchinfo.do',
			   data:params,
			   async:true,
			   dataType:'json',
			   success:function(jsondata){
				   $('#sourcematchtable').datagrid('loadData',[jsondata]);
				   $('#matchinfowindow').window('open');
			   }
		});
	}
	function sourceloadcomplet(data){
		var jsondata = data.rows[0];
		$('#destmatchtable').datagrid('loadData',[]);
		$('#destmatchtable').datagrid('loadData',jsondata.destList);
	}
	function destgridcolstyle(value,row,index){
		//dest is 4 length
		var field = this['field'];
		//console.log("==================="+field.substring(4,field.length));
		var rows = $('#sourcematchtable').datagrid('getRows');
		if(rows && rows.length > 0){
			var row = rows[0];
			var sourcefield = 'source'+field.substring(4,field.length);
			if(row[sourcefield] && value && row[sourcefield] == value){
				return  '';
			}else{
				return  'background-color:red;';
			}
		}
	}
	
	function exportInfo(){
		var param='';
		var fields = getCondition();
		param = param+'compareCondition='+fields.compareCondition;
		param = param+'&otherCondition='+fields.otherCondition;
		param = param+'&taxorgsupcode='+fields.taxorgsupcode;
		param = param+'&taxorgcode='+fields.taxorgcode;
		param = param+'&taxdeptcode='+fields.taxdeptcode;
		param = param+'&taxmanagercode='+fields.taxmanagercode;
		window.open("/newdataarrange/export.do?"+param, '',
		   'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
	}
	</script>
</head>
<body>
    <div class="easyui-layout" style="width:100%;height:526px;">
	    <div data-options="region:'center'" style="height:500px;overflow: visible;" id="sourceDiv">
	     <form id="landdataarrangeform" method="post">
			<table id='landdataarrangegrid'  style="height:500px;overflow: scroll;">
				<thead>
					
				</thead>
			</table>
	    </form>
	    </div>
	    <div data-options="region:'west'" id="mainWestDiv" style="height:500px;width:160px;overflow: hidden;">
	        <div style="height:500px;background-color: white;width:100%">
	              <table id="statustable" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
			        <tr height="25px">
			           <td colspan="4">
			                <span style="color: red;font-weight: bold;font-size: 12px;">比对状态</span> 
			           </td>
			       </tr>
			       
			       <tr>
			           <td><input type="radio" data-type="x" value=" comparestate='1' " name="comparestate"/>&nbsp;无采集土地数据</td>
			       </tr>
			       <tr>
			           <td><input type="radio" data-type="x" value=" comparestate='2' " name="comparestate"/>&nbsp;比对一致</td>
			       </tr>
			       <tr>
			           <td><input type="radio" data-type="x" value=" comparestate='3' " name="comparestate" checked/>&nbsp;比对不一致</td>
			       </tr>
			       <tr height="25px">
			           <td colspan="4">
			                <span style="color: red;font-weight: bold;font-size: 12px;">核查状态</span> 
			           </td>
			       </tr>
				  <tr>
			           <td><input type="checkbox" data-type="y" value=" checkstate='0' "/>&nbsp;待核查</td>
			       </tr>
			       <tr>
			           <td><input type="checkbox" data-type="y" value=" checkstate='1' "/>&nbsp;核查中</td>
			       </tr>
			       <tr>
			           <td><input type="checkbox" data-type="y" value=" checkstate='2' "/>&nbsp;未审核</td>
			       </tr>
			       <tr>
			           <td><input type="checkbox" data-type="y" value=" checkstate='3' "/>&nbsp;审核不通过</td>
			       </tr>
			       <tr>
			           <td><input type="checkbox" data-type="y" value=" checkstate='4' "/>&nbsp;审核通过</td>
			       </tr>
				 </table>
	        </div>
	    </div>
		<div id="tb" data-options="region:'north'" style="height:25px;width:100%;overflow: visible">
			<div style="height:25px;">
				<a href="#" style="display:none;" class="easyui-linkbutton" data-options="iconCls:'icon-business1',plain:true" onclick="openDataArrange()">数据比对</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportInfo()">导出</a>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<span id="matchspan" style="display: none;">  
				                参与比对数：<span id="pageItem" name="pageItem" style="color: red;font-weight: bold;font-size: 50;"></span>
				               比对一致：<span id="matchNum" name="matchNum" style="color: red;font-weight: bold;font-size: 50;"></span>
				               无采集土地数据：<span id="notmatchNum" name="partmatchNum" style="color: red;font-weight: bold;font-size: 50;"></span> 
				               比对不一致：<span id="partmatchNum" name="notmatchNum" style="color: red;font-weight: bold;font-size: 50;"></span>
				</span>
			</div>
		</div>
	</div>
	<div id="comparewindow" class="easyui-window" data-options="border:false,closed:true,modal:true,title:'整理、比对条件',collapsible:false,minimizable:false,maximizable:false,closable:true" 
	style="width:640px;height:370px;">
	<form id="arrangeform" name="arrangeform">
	    <table id="narjcxx" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
	       
	        <tr height="25px">
	           <td colspan="4">
	                <span style="color: red;font-weight: bold;font-size: 12px;">整理条件</span> 
	           </td>
	        </tr>
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
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
			</tr>
			
			<tr height="25px">
	           <td colspan="4">
	                <span style="color: red;font-weight: bold;font-size: 12px;">比对条件</span> 
	           </td>
	        </tr>
			<tr>
			   <td colspan="4">
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
			   </td>
			</tr>
		</table>
		</form>
			<div style="text-align:center;padding:5px;">  
			   <a id = 'compareHref' href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="dataArrange()">比对</a>
			</div>
	</div>
	
	<div id="checkadvicewindow" class="easyui-window" data-options="border:false,closed:true,modal:true,title:'核查意见填写窗口',collapsible:false,minimizable:false,maximizable:false,closable:true" 
	style="width:640px;height:370px;">
	    <table id="advicetable" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
			<tr>
			   <td colspan="1">
			        <table id='checkadvicetable' class="easyui-datagrid" style="height:180px;width:610px;overflow:scroll;"
					 data-options="iconCls:'icon-edit',nowrap:false">
				    <thead>
					  <tr>
						<th data-options="field:'advice',width:300,align:'center',editor:{type:'validatebox'}">核查意见</th>
						<th data-options="field:'checkcontent',width:300,align:'center',editor:{type:'validatebox'}">审核意见</th>
						<th data-options="field:'checkestateinfo',width:365,align:'left',editor:{type:'validatebox'}">核查审核相关</th>
					  </tr>
				    </thead>
			      </table>
			   </td>
			</tr>
			<form id="adviceform" name="adviceform">
			<tr>
				<td valign="top" align="left">核查意见：
				 <input type="hidden" id="serialno" name="serialno" />
				<textarea rows="5" cols="80" id="advice" name="advice"></textarea>	
				</td>
			</form>
		</table>   
		 <div style="text-align:center;padding:5px;">  
			   <a id = 'compareHref' href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveAndCommit()">提交</a>
		       <!-- <a id = 'compareHref' href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveAndNotCommit()">保存不提交至分局长审核</a> -->
		 </div>
	</div>
	
	<div id="checkadviceviewwindow" class="easyui-window" data-options="border:false,closed:true,modal:true,title:'核查、审核意见查看',collapsible:false,minimizable:false,maximizable:false,closable:true" 
	style="width:640px;height:370px;">
	    <table id="adviceviewtable" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
			<tr>
			   <td colspan="1">
			        <table id='checkadviceviewtable' class="easyui-datagrid" style="height:315px;width:610px;overflow:scroll;"
					 data-options="iconCls:'icon-edit',nowrap:false">
				    <thead>
					  <tr>
						<th data-options="field:'advice',width:300,align:'center',editor:{type:'validatebox'}">核查意见</th>
						<th data-options="field:'checkcontent',width:300,align:'center',editor:{type:'validatebox'}">审核意见</th>
						<th data-options="field:'checkestateinfo',width:365,align:'left',editor:{type:'validatebox'}">核查审核相关</th>
					  </tr>
				    </thead>
			      </table>
			   </td>
			</tr>
		</table>   
	</div>
	<div id="matchinfowindow" class="easyui-window" data-options="border:false,closed:true,modal:true,title:'比对情况',collapsible:false,minimizable:false,maximizable:false,closable:true" 
	style="width:640px;height:370px;">
	    <table id="matchtable" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
			<tr>
			   <td><span style="color: blue;font-weight: bold;font-size: 12px;">第三方数据</span></td>
			</tr>
			<tr>
			   <td>
			        <table id='sourcematchtable' class="easyui-datagrid" style="height:100px;width:610px;overflow:scroll;"
					 data-options="iconCls:'icon-edit',onLoadSuccess:sourceloadcomplet">
				    <thead>
					  <tr>
						<th data-options="field:'sourcetaxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'sourcetaxpayername',width:220,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'sourceestateserial',width:120,align:'left',editor:{type:'validatebox'}">宗地编号</th>
						<th data-options="field:'sourcedetailaddress',width:320,align:'left',editor:{type:'validatebox'}">详细地址</th>
						<th data-options="field:'sourcelandcertificate',width:200,align:'left',editor:{type:'validatebox'}">土地证号</th>
						<th data-options="field:'sourcearea',width:120,formatter:formatnumber,align:'right',editor:{type:'validatebox'}">面积</th>
						<th data-options="field:'sourceprice ',width:120,formatter:formatnumber,align:'right',editor:{type:'validatebox'}">地价</th>
						<th data-options="field:'sourcedate',width:80,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">土地获得日期</th>
					  </tr>
				    </thead>
			      </table>
			   </td>
			</tr>
			<tr>
			   <td><span style="color: blue;font-weight: bold;font-size: 12px;">采集数据</span></td>
			</tr>
			<tr>
			   <td>
			        <table id='destmatchtable' class="easyui-datagrid" style="height:150px;width:610px;overflow:scroll;"
					 data-options="iconCls:'icon-edit'">
				    <thead>
					  <tr>
						<th data-options="field:'desttaxpayerid',width:100,align:'center',editor:{type:'validatebox'},styler:destgridcolstyle">计算机编码</th>
						<th data-options="field:'desttaxpayername',width:220,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'destestateserial',width:120,align:'left',editor:{type:'validatebox'},styler:destgridcolstyle">宗地编号</th>
						<th data-options="field:'destdetailaddress',width:320,align:'left',editor:{type:'validatebox'},styler:destgridcolstyle">详细地址</th>
						<th data-options="field:'destlandcertificate',width:200,align:'left',editor:{type:'validatebox'},styler:destgridcolstyle">土地证号</th>
						<th data-options="field:'destarea',width:100,formatter:formatnumber,align:'right',editor:{type:'validatebox'},styler:destgridcolstyle">面积</th>
						<th data-options="field:'destprice ',width:100,formatter:formatnumber,align:'right',editor:{type:'validatebox'},styler:destgridcolstyle">地价</th>
						<th data-options="field:'destdate',width:80,align:'center',formatter:formatterDate,editor:{type:'validatebox'},styler:destgridcolstyle">土地获得日期</th>
					  </tr>
				    </thead>
			      </table>
			   </td>
			</tr>
		</table>   
	</div>
</body>
</html>