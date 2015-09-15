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
	<script src="/js/widgets.js"></script>
	<script src="/js/LodopFuncs.js"></script>
	<div style="display:none;">
    <object  id="LODOP_OB" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width=0 height=0>  
       <embed id="LODOP_EM" type="application/x-print-lodop" width=0 height=0></embed> 
    </object> 
	</div>
    <style type="text/css">
       .tdcls{
           border: 1px solid black;  
           background: #fff;  
           font-size:12px;  
           padding: 3px 3px 3px 8px;  
           color: #4f6b72;  
           
       }
    </style>
    <script>
    var printtype = null;
    function printPrepare(pt){
    	var row = $('#owetaxgrid').datagrid('getSelected');
		if(row == null){
			 if(pt === 1){
				 $.messager.alert('提示消息','请选择需要打印限期缴纳税款通知书的记录!','info');
			 }else if(pt === 0){
				 $.messager.alert('提示消息','请选择需要打印税务文书送达回证的记录!','info');
			 }
			 printtype = null;
			 return;
		}
		printtype = pt;
		
		var no = row.payno;
		var paynum = row.paydaynum ? row.paydaynum : '10';
		$('#printpreparewindow #printnumber').val(no);
		$('#printpreparewindow #payday').val(paynum);
		
    	$('#printpreparewindow').window('open');
    }
    function processPrintInfo(){
    	var row = $('#owetaxgrid').datagrid('getSelected');
    	$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				  url: "/paynoticecontrol/getprintinfo.do?d="+new Date(),
				  data: {'taxpayerid':row.taxpayerid},
				  dataType: "json",
				  success:function(jsondata){
					if(jsondata){     
						jsondata['printnumber'] = '〔'+jsondata.year+'〕'+$('#printpreparewindow #printnumber').val();
						jsondata['payday'] = $('#printpreparewindow #payday').val();
					}
					for(var p in jsondata){
					   var v = jsondata[p];
					   if(!$.isArray(v)){
						   //特殊处理
						    $('#printinfowindow #'+p).text(v);
					   }
					}
					var details = jsondata.details;
					var begininfo = '';
					var totalvalue = 0;
					for(var i = 0;i < details.length;i++){
						var detail = details[i];
						var beginDateObj = CommonUtils.getDate(detail.begindate);
						var endDateObj = CommonUtils.getDate(detail.enddate);
					    begininfo += beginDateObj.toString();
					    begininfo += '至'+endDateObj.toString();
					    begininfo += '所属期间应缴纳的'+detail.taxname;
					    begininfo += detail.owetaxmoney+'元';
					    begininfo += "，";
					    totalvalue += detail.owetaxmoney;
					}
					$('#begininfo').text(begininfo);
					$('#totalvalue').text(totalvalue);
					
					var paydate = new Date(jsondata.year,jsondata.month-1,jsondata.day);
					var daysplit = $('#payday').val();
					var paydateObj = CommonUtils.addDate(paydate,daysplit);
					$('#paydatelimit').text(paydateObj.toString());
					$('#chineseDate').text(converToChineseDate(new Date()));
					var LODOP=getLodop(document.getElementById('LODOP_OB'),document.getElementById('LODOP_EM'));
					LODOP.SET_LICENSES("昆明恒辰科技有限公司","055595969718688748719056235623","","");
			    	LODOP.PRINT_INIT("限期缴纳税款通知书");
			    	LODOP.SET_PRINT_PAGESIZE(1, 0, 0,"A4");
					LODOP.ADD_PRINT_HTM(80,80,'85%','80%',document.getElementById("printinfowindow").innerHTML);
			    	LODOP.PREVIEW();
			    	//插入打印配置信息
			    	$.messager.confirm('打印提示','是否打印成功?',function(r){
			    		var printNumber = $('#printpreparewindow #printnumber').val();
			    		var params = {};
			    		params['taxpayerid'] = row.taxpayerid;
			    		params['noticeno'] = printNumber;
			    	    params['noticedaynum'] = $('#printpreparewindow #payday').val();
			    		if(r){
			    			 $.ajax({
							  type: "get",
							  async:true,
							  cache:false,
							  url: "/paynoticecontrol/printinfo.do?d="+new Date(),
							  data: params,
							  dataType: "text",
							  success:function(jsondata){
								  query();
							  }
					         });
			    		}
			    	});
			    	
				}
		 });
    }
    function processBackPrintInfo(){
    	var row = $('#owetaxgrid').datagrid('getSelected');
    	$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				  url: "/paynoticecontrol/getbackprintinfo.do?d="+new Date(),
				  data: {'taxpayerid':row.taxpayerid},
				  dataType: "json",
				  success:function(jsondata){
					var printnumber = $('#printpreparewindow #printnumber').val();
					var bookname = '《'+jsondata.taxdeptname+'限期缴纳税款通知书》（晋地税'+jsondata.taxdeptnum+'限缴'+'〔'+jsondata.year+'〕'+printnumber+'）';
					var taxpayername = jsondata.taxpayername;
					var sendplace = taxpayername + '财务室';
					$('#printbackdetaildiv #bookname').text(bookname);
					$('#printbackdetaildiv #taxpayername').text(taxpayername);
					$('#printbackdetaildiv #sendplace').text(sendplace);
					var LODOP=getLodop(document.getElementById('LODOP_OB'),document.getElementById('LODOP_EM'));
					LODOP.SET_LICENSES("昆明恒辰科技有限公司","055595969718688748719056235623","","");
			    	LODOP.PRINT_INIT("税务文书送达回证");
			    	LODOP.SET_PRINT_PAGESIZE(1, 0, 0,"A4");
					LODOP.ADD_PRINT_TABLE(80,30,'90%','90%',document.getElementById("printbackdetaildiv").innerHTML);
			    	LODOP.PREVIEW();
				}
		 });
    }
    function printInfo(){
    	var printNumber = $('#printpreparewindow #printnumber').val();
    	var printDay = $('#printpreparewindow #payday').val();
    	
    	if($.trim(printNumber) == ""){
    		$.messager.alert('提示消息','请填写打印的文档号!','info');
    		return;
    	}
    	if ($.trim(printDay) == ""|| printDay>15){
    		$.messager.alert('提示消息','限期缴纳天数不能为空且不能大于15天','info');
    		return;
    	}
		$('#printpreparewindow').window('close');
		if(printtype == 1){
			processPrintInfo();
		}else{
			processBackPrintInfo();
		}
    }

    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
    
    function getPrintStatus(value,row,index){
    	    if(row.payprintnum){
    	    	return "已打印";
    	    }else
    	    	return "未打印";
	}
    
    function ValueProperty(key,value){
    	this.key = key;
    	this.value = value;
    }
	$(function(){
		var managerLink = new OrgLink();
	    managerLink.sendMethod = false;
	    managerLink.loadData();
	    
	    $('#owetaxgrid').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			rowStyler:settings.rowStyle,
			pageList:[15]
			
		});
		var p = $('#owetaxgrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
		$('#owetaxdetailgrid').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			rowStyler:settings.rowStyle,
			pageList:[15]
			
		});
			
		p = $('#owetaxdetailgrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
	   var printstatusary = [new ValueProperty('','所有状态'),new ValueProperty('1','已打印'),new ValueProperty('0','未打印')];
	   
	   $('#printstatus').combobox({
		   valueField:'key',   
           textField:'value',
           data:printstatusary
	   });
	   
	});
	    function query(){
	    	var params = {};
		    var fields =$('#taxqueryform').serializeArray();
		    $.each( fields, function(i, field){
			    params[field.name] = field.value;
		    });
			params['pagesize'] = 15;
			
			params['printtaxnotice'] = params['printstatus'];
		    var opts = $('#owetaxgrid').datagrid('options');
		    opts.url = '/paynoticecontrol/selecttaxnoticeinfo.do?d='+new Date();
		    $('#owetaxgrid').datagrid('load',params); 
			$('#querywindow').window('close');
	    }
		function openQuery(){
			$('#querywindow').window('open');
		}
		function viewDetail(){
			var row = $('#owetaxgrid').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要查看明细的记录!','info');
				 return;
			}
			$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				  url: "/paynoticecontrol/selectdetailinfo.do?d="+new Date(),
				  data: {'taxpayerid':row.taxpayerid},
				  dataType: "json",
				  success:function(jsondata){
					  $('#owetaxdetailgrid').datagrid('loadData',[]);
					  $('#owetaxdetailgrid').datagrid('loadData',jsondata);
				  }
			   });
			$('#detailwindow').window('open');
		}
		function exportExcel(){
			var params = {};
			var fields =$('#taxqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['printtaxnotice'] = params['printstatus'];
			
			params['propNames'] = 'taxpayerid,taxpayername,landtaxamount,landtaxamountactual,landowetaxmoney,housetaxamount,'+
			               'housetaxamountactual,houseowetaxmoney,noticeno,payno,paydaynum,payprintnum,paydate';
			params['colNames'] = '计算机编码,纳税人名称,应缴土地使用税,已缴土地使用税,应补土地使用税,应缴房产税,已缴房产税,应补房产税,'+
                                 '税务事项通知书号,限缴通知书号,限缴天数,限缴打印次数,限缴日期';
			params['modelName']="限期缴纳通知书查询结果";
			
			CommonUtils.downloadFile("/paynoticecontrol/paynoticeexport.do?date="+new Date(),params);
		}
		function converToChineseDate(date) {
		
		    var chinese = ['0', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
		    var y = date.getFullYear().toString();
		    var m = (date.getMonth()+1).toString();
		    var d = date.getDate().toString();
		    var result = "";
		    for (var i = 0; i < y.length; i++) {
		        result += chinese[y.charAt(i)];
		    }
		    result += "年";
		    if (m.length == 2) {
		        if (m.charAt(0) == "1") {
		            result += ("十" + chinese[m.charAt(1)] + "月");
		        }
		    } else {
		        result += (chinese[m.charAt(0)] + "月");
		    } 
		    if (d.length == 2) {
		        result += (chinese[d.charAt(0)] + "十" + chinese[d.charAt(1)] + "日");
		    } else {
		        result += (chinese[d.charAt(0)] + "日");
		    }
		  	
		    return result;
		}
	</script>
</head>
<body>
     <div class="easyui-layout" style="width:100%;height:570px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='owetaxgrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:240,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'ploughtaxamount',hidden:true,width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">耕占税应缴</th>
						<th data-options="field:'ploughtaxamountactual',hidden:true,width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">耕占税实缴</th>
						<th data-options="field:'ploughowetaxmoney',hidden:true,width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">耕占税欠税</th>
						<th data-options="field:'landtaxamount',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴土地使用税</th>
						<th data-options="field:'landtaxamountactual',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">已缴土地使用税</th>
						<th data-options="field:'landowetaxmoney',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应补土地使用税</th>
						<th data-options="field:'housetaxamount',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴房产税</th>
						<th data-options="field:'housetaxamountactual',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">已缴房产税</th>
						<th data-options="field:'houseowetaxmoney',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应补房产税</th>
						<th data-options="field:'payno',width:140,align:'left',editor:{type:'validatebox'}">限缴通知书号</th>
						<th data-options="field:'paydaynum',width:80,align:'center',editor:{type:'validatebox'}">限缴天数</th>
						<th data-options="field:'payprintnum',width:80,hidden:true,align:'center',editor:{type:'validatebox'}">限缴打印次数</th>
						<th data-options="field:'printstatus',width:120,align:'left',formatter:getPrintStatus,editor:{type:'validatebox'}">限缴通知书打印状态</th>
						<th data-options="field:'noticeno',width:140,align:'left',editor:{type:'validatebox'}">税务事项通知书号</th>
						<th data-options="field:'paydate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">限缴日期</th>
						
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="viewDetail()">查看欠税明细</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print',plain:true" onclick="printPrepare(1)">限期缴纳税款通知书打印</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print',plain:true" onclick="printPrepare(0)">税务文书送达回证打印</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportExcel()">导出</a>
			</div>
		</div>
	</div>
    <div id="printbackdetaildiv" style="display: none;letter-spacing:2px;">
        <table id="printbackdetailtable" border=1 width="100%" cellspacing="0" cellpadding="0" style="border-collapse:collapse" bordercolor="#000000">
           <caption style="font-size:22pt;font-family:'宋体';font-weight: bold;padding-bottom:15px;">税务文书送达回证</caption>
               <tr height="140px">
				<td align="center" width="36%">送达文书名称</td>
				<td align="left" width="64%"><span id="bookname" style="color:red;font-family:'仿宋';font-size: 12pt;"></span></td>
			   </tr>
			   <tr height="50px">
				<td align="center">受送达人</td>
				<td align="left"><span id="taxpayername" style="color:red;font-family:'仿宋';font-size: 12pt;"></span></td>
			   </tr>
			   <tr height="50px">
				<td align="center">送达地点</td>
				<td align="left"><span id="sendplace" style="color:red;font-family:'仿宋';font-size: 12pt;"></span></td>
			   </tr>
			   <tr height="80px">
				<td align="center">受送达人签名或盖章</td>
				<td align="center" style="text-align:right;vertical-align:bottom;padding-bottom:12px;padding-right:25px;">
				      年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;
				      &nbsp;&nbsp;&nbsp;&nbsp;时&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分</td>
			    </tr>
			   <tr height="110px">
				<td align="center">代收人代收理由、签名或盖章</td>
				<td align="center" style="text-align:right;vertical-align:bottom;padding-bottom:12px;padding-right:25px;">
				      年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;
				      &nbsp;&nbsp;&nbsp;&nbsp;时&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分</td>
			    </tr>
			   </tr>
			   <tr height="110px">
				<td align="center">受送达人拒收理由</td>
				<td align="center" style="text-align:right;vertical-align:bottom;padding-bottom:12px;padding-right:25px;">
				      年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;
				      &nbsp;&nbsp;&nbsp;&nbsp;时&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分</td>
			    </tr>
			   </tr>
			   <tr height="110px">
				<td align="center">见证人签名或盖章</td>
				<td align="center" style="text-align:right;vertical-align:bottom;padding-bottom:12px;padding-right:25px;">
				      年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;
				      &nbsp;&nbsp;&nbsp;&nbsp;时&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分</td>
			    </tr>
			   </tr>
			   <tr height="100px">
				<td align="center">送达人签名或盖章</td>
				<td align="center" style="text-align:right;vertical-align:bottom;padding-bottom:12px;padding-right:25px;">
				      年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;
				      &nbsp;&nbsp;&nbsp;&nbsp;时&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分</td>
			    </tr>
			   </tr>
			   <tr height="100px">
				<td align="center">填发税务机关</td>
				<td align="center" style="text-align:right;vertical-align:bottom;padding-bottom:12px;padding-right:25px;">
				    年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;
				      &nbsp;&nbsp;&nbsp;&nbsp;时&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分</td>
			    </tr>
			   </tr>
        </table>
    </div>
    
    <div id="printinfowindow" style="display:none;">
	     <div style="letter-spacing:2px;">
	        <div align="center" style="font-size:22pt;font-weight:bold;font-family:宋体;line-height: 40px;"><span id="taxdeptname"></span></spna></div>
	        <div align="center" style="font-size:26pt;font-weight:bold;font-family:宋体;line-height: 45px;">限期缴纳税款通知书</div>
	        <div align="center" style="font-size:16pt;font-family:宋体;line-height: 35px;margin-bottom: 30px;">晋地税<span id="taxdeptnum"></span>限缴<span id="printnumber" style="color:red"></span>号</div>
	        <div align="left" style="font-size:16pt;font-family:仿宋;line-height: 37px;color: red;">
	                            纳税人名称：<span id="taxpayername"></span>
	        </div>
	        <div style="font-size:16pt;font-family:仿宋;text-indent: 45px;line-height:150%;">
	                         根据《中华人民共和国税收征收管理法》第四十条、第三十二条及《中华人民共和国税收征收管理法实施细则》第七十三条的规定，责令你（单位）在接到本通知书之日起<span id="payday"></span>日内向<span id="taxlevname"></span>缴纳<span id="begininfo"></span>合计<span id="totalvalue"></span>元。并从滞纳税款之日起，按日加收滞纳税款万分之五的滞纳金，若逾期不缴纳，将根据《中华人民共和国税收征收管理法》的有关规定处理。
	        </div>
	        <div align="right" style="font-size:16pt;font-family:仿宋;text-indent: 40px;margin-top: 120px;">
	        	
	            <!--  span id="year"></span>年<span id="month"></span>月<span id="day"></span>日  
	               -->  
	            <span id="chineseDate"> 
	        </div>
	     </div>
	</div>
    
	<div id="detailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'欠税明细',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:800px;height:555px;">
	      <div>
			<table id='owetaxdetailgrid' class="easyui-datagrid" style="width:99;height:520px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true">
				<thead>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:240,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxtypename',width:150,align:'left',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',width:150,align:'left',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'levydatedesc',width:240,align:'left',editor:{type:'validatebox'}">征期类型</th>
						<th data-options="field:'taxdatebegin',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">所属期起</th>
						<th data-options="field:'taxdateend',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">所属期止</th>
						<th data-options="field:'owetaxmoney',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">欠税</th>
						<th data-options="field:'paydate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">催缴日期</th>
				</thead>
			</table>
	      </div>
	</div>
	
	<div id="printpreparewindow" class="easyui-window" data-options="closed:true,modal:true,title:'打印设置',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;height:120px;">
	     <div class="easyui-panel" style="width:620px;">
			<form  method="post">
				<table id="narjcxx" width="100%"  cellpadding="10" cellspacing="0">
					<tr>
						<td align="right">限期缴纳通知书号：</td>
						<td>
							<input id="printnumber" class="easyui-validatebox" type="text" name="printnumber"/>
						</td>
						<td align="right">限期缴纳天数：</td>
						<td>
							<input id="payday" class="easyui-numberbox" type="text" name="payday" value="10"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div style="text-align:center;padding:5px;height: 25px;">  
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="printInfo()">打印</a>
	    </div>
	</div>
	
	<div id="querywindow" class="easyui-window" data-options="closed:true,modal:true,title:'查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:760px;height:200px;">
			<form id="taxqueryform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
				  
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
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" style="width:250px" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" style="width:250px"/>
						</td>
					</tr>
					<tr>
						<td align="right">限期缴纳书打印状态：</td>
						<td colspan="3">
							<input class="easyui-combobox" name="printstatus" id="printstatus" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>

					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
	</div>
	
</body>
</html>