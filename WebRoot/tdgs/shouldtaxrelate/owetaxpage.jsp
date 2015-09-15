<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<base target="_self"/>
	<title>欠税信息查询</title>
	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
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
    <script>
    
    $.fn.combo.defaults.editable = false;
    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
    function getYearAry(beginYear){
    	var temp = beginYear;
    	var currentYear = new Date().getFullYear();
    	var result = [];
    	while(temp <= currentYear){
    		result.push({key:temp,value:temp});
    		temp += 1;
    	}
    	return result;
    }
   // OrgLink(_modelAuth,_emptype,_orgsupcode,_orgcode,_deptcode,_managercode)
	$(function(){
		var managerLink = new OrgLink();
	    managerLink.sendMethod = false;
	    managerLink.loadData();
	    
	    $('#queryform #taxyear').combobox({
	    	data:getYearAry(2008),
	    	valueField:'key',
	    	textField:'value'
	    });
	    
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
			pageList:[10]
			
		});
		var p = $('#owetaxdetailgrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
	});
	  function getWhereCondition(){
		    var params = {};
		    var fields =$('#queryform').serializeArray();
		    $.each( fields, function(i, field){
			    params[field.name] = field.value;
		    });
            var whereCondition = '';
	    	var otherCondition = '';
	    	
	    	if(params.taxorgsupcode){
	    		whereCondition += " and taxorgsupcode = '"+params.taxorgsupcode+"' ";
	    	}
	    	if(params.taxorgcode){
	    		whereCondition += " and taxorgcode = '"+params.taxorgcode+"' ";
	    	}
	    	if(params.taxdeptcode){
	    		whereCondition += " and taxdeptcode = '"+params.taxdeptcode+"' ";
	    	}
	    	if(params.taxmanagercode){
	    		whereCondition += " and taxmanagercode = '"+params.taxmanagercode+"' ";
	    	}
	    	if(params.taxpayerid){
	    		whereCondition += " and taxpayerid = '"+params.taxpayerid+"' ";
	    	}
	    	if(params.taxpayername){
	    		whereCondition += " and taxpayername like '%"+params.taxpayername+"%' ";
	    	}
	    	var taxtypecodes = $('#taxtypesel').combo('getValue');
	    	var taxcodes = $('#taxsel').combo('getValue');
	    	if(taxtypecodes){
	    		whereCondition += " and taxtypecode in ("+taxtypecodes+") ";
	    	}
	    	if(taxcodes){
	    		whereCondition += " and taxcode in ("+taxcodes+") ";
	    	}
	    	if(params.taxyear){
	    		whereCondition += " and taxyear = '"+params.taxyear+"' ";
	    	}
	    	///////////
	    	if(params.minowetax){
	    		otherCondition += ' and owetaxmoney >= '+params.minowetax;
	    	}
	    	if(params.maxowetax){
	    		otherCondition += ' and owetaxmoney <= '+params.maxowetax;
	    	}
	    	return {'whereCondition':whereCondition,'otherCondition':otherCondition};
	    }
	    function query(){
	    	var params = getWhereCondition();
	    	var opts = $('#owetaxgrid').datagrid('options');
			opts.url = '/owetax/owetaxmaininfo.do?d='+new Date();
			$('#owetaxgrid').datagrid('load',params); 
			var p = $('#owetaxgrid').datagrid('getPager');  
	    	$('#querydiv').window('close');
	    }
		function openQuery(){
			$('#querydiv').window('open');
		}
		function viewOweDetail(value,row,index){
			  var result =  "<a href='#' onclick=viewDetail('"+row.taxpayerid+"','"+row.taxyear+"','"+row.taxtypecode+"','"+row.taxcode+"')>欠税明细</a>";
			  if(row.taxpayerid == '总计') //最后一行
				  return '';
			  return result;
		}
		function viewDetail(taxpayerid,taxyear,taxtypecode,taxcode){
			var whereCondition = ' and 1=1 ';
			whereCondition += " and taxpayerid = '"+taxpayerid+"' ";
			whereCondition += " and taxyear = '"+taxyear+"' ";
			whereCondition += " and taxtypecode = '"+taxtypecode+"' ";
			whereCondition += " and taxcode = '"+taxcode+"' ";	
			console.log(whereCondition+'========');
			$('#owetaxdetailgrid').datagrid('loadData',[]);
			$('#detailwindow').window('open');
			
			var params = {'whereCondition':whereCondition};
			
	    	var opts = $('#owetaxdetailgrid').datagrid('options');
			opts.url = '/owetax/owetaxsubinfo.do?d='+new Date();
			$('#owetaxdetailgrid').datagrid('load',params); 
			var p = $('#owetaxdetailgrid').datagrid('getPager');  
		}
	</script>
</head>
<body>
     <div class="easyui-layout" style="width:100%;height:570px;" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='owetaxgrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
				        <th data-options="field:'oper',formatter:viewOweDetail,width:100,align:'center',editor:{type:'validatebox'}">查看欠税明细</th>
						<th data-options="field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:240,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxyear',hidden:false,width:150,align:'center',editor:{type:'validatebox'}">税款所属年度</th>
						<th data-options="field:'taxtypename',hidden:false,width:150,align:'left',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',hidden:false,width:150,align:'left',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'shouldtaxmoney',width:150,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴金额</th>
						<th data-options="field:'alreadyshouldtaxmoney',width:150,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">已缴金额</th>
						<th data-options="field:'owetaxmoney',width:150,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">欠税金额</th>

				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
			</div>
		</div>
	</div>
	
	<div id="detailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'欠税明细',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:800px;height:530px;">
	      <div>
			<table id='owetaxdetailgrid' class="easyui-datagrid" style="width:99;height:483px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true">
				<thead>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:240,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxtypename',width:150,align:'left',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',width:150,align:'left',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'levydatetypename',width:240,align:'left',editor:{type:'validatebox'}">征期类型</th>
						<th data-options="field:'taxbegindate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">所属期起</th>
						<th data-options="field:'taxenddate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">所属期止</th>
						<th data-options="field:'shouldtaxmoney',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴金额</th>
						<th data-options="field:'alreadyshouldtaxmoney',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">已缴金额</th>
						<th data-options="field:'owetaxmoney',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">欠税金额</th>
				</thead>
			</table>
	      </div>
	</div>
	
	<div id="querydiv" class="easyui-window" data-options="closed:true,modal:true,title:'欠税查询条件',collapsible:false,
	   minimizable:false,maximizable:false,closable:true" style="width:720px;">
			<form id="queryform" method="post">
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
					
					
					<tr>
						<td align="right">税款所属年度：</td>
						<td colspan="1">
							<input id="taxyear" class="easyui-combobox" name="taxyear" style="width: 150px;"/>
							
						</td>
						<td colspan="2">
						   欠税金额：
							<input id="minowetax" class="easyui-numberbox" name="mintax" style="width: 100px;"/>
						至
							<input id="maxowetax" class="easyui-numberbox"  name="maxtax" style="width:100px;"/>
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