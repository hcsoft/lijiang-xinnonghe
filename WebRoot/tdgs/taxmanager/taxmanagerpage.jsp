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
	<script src="taxmanager.js"></script>		
<script src="<%=spath%>/js/datagrid-detailview.js"></script>

    <script>
	
    var managerLink = new OrgLink();
    managerLink.sendMethod = true;
    
    function TypeInfo(taxtypecode,taxtypename){
    	this.taxtypecode = taxtypecode;
    	this.taxtypename = taxtypename;
    }
 
	$(function(){
		    managerLink.loadData();
		    
		    $('#groundstoragegrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				rowStyler:settings.rowStyle,
				pageList:[15]
				
			});
			
			var p = $('#groundstoragegrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
		
			$('#paramgrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:false,
				onClickRow:query
			});
				 
			p = $('#paramgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			$('#paramgrid').datagrid('loadData',[
				 new TypeInfo("LAND","土地使用税"),
				 new TypeInfo("HOUSE","房产税"),
				 new TypeInfo("PLOUGH","耕占税")
				 ]); 
			$('#paramgrid').datagrid('selectRow',0); 
			
			var firstDay = DateUtils.getYearFirstDay();
			var lastDay = DateUtils.getCurrentDay();
		     $('#begindate').datebox('setValue',firstDay);
		     $('#enddate').datebox('setValue',lastDay);
			
		});
	  
	    function getCondition(){
	    	    
	    	    var params = {};
			    var fields =$('#taxqueryform').serializeArray();
			    $.each( fields, function(i, field){
				    params[field.name] = field.value;
			    });
			    var row = $('#paramgrid').datagrid('getSelected');
			    if(row == null){
			    	$.messager.alert('提示消息','请先选择税种!','info');
			    	return null;
			    }
			    params['taxtype'] = row.taxtypecode;
			    return params;
	    }
		function query(){
			var params = getCondition();
			if(params == null){
				return null;
			}
			$('#groundstoragegrid').datagrid('loadData',[]);
			//opts.columns 是数组中再有数组[[col1,col2]]
			var columnAry = new Array();
			var colAry = TaxSourceUtils.getColumnConfig(params['taxtype']);
			columnAry.push(colAry);
			
			
			
			
			//var opts = $('#groundstoragegrid').datagrid('options');
			//opts.url = '/taxmanager/selecttaxsource.do?d='+new Date();
			//$('#groundstoragegrid').datagrid('load',params); 
			
			$('#groundstoragegrid').datagrid({
				columns:columnAry,
				url:'/taxmanager/selecttaxsource.do?d='+new Date(),
				queryParams:params,
				view:detailview,
				   detailFormatter:function(index,row){
                      return '<div style="padding:2px;"><table id="'+params['taxtype']+'-' + index + '"></table></div>';
                   },
                   onExpandRow: function(index,row){
                	   $('#'+params['taxtype']+'-'+index).datagrid({
                       fitColumns:true,
                       singleSelect:true,
                       rownumbers:true,
                       loadMsg:'正在处理，请稍候......',
                       height:'auto',
                       columns:[[
                          {field:'taxpayerid',title:'计算机编码',width:100,align:'center'},
                          {field:'taxpayername',title:'纳税人名称',width:130,align:'left'},
                          {field:'taxtypename',title:'税种',width:100,align:'center'},
                          {field:'taxname',title:'税目',width:100,align:'center'},
                          {field:'begindate',title:'计税起日期',width:100,align:'center',formatter:formatterDate},
                          {field:'enddate',title:'计税止日期',width:100,align:'center',formatter:formatterDate},
                          {field:'subtaxamount',title:'应缴金额',width:100,align:'center'},
                          {field:'subtaxamountactual',title:'实缴金额',width:100,align:'center'},
                         //  {field:'levydatetypename',title:'征期类型',width:100,align:'center'},
                           {field:'derateflagname',title:'类型',width:100,align:'center'}
                        ]],
                       onResize:function(){
                            $('#groundstoragegrid').datagrid('fixDetailRowHeight',index);
                        },
                        onLoadSuccess:function(){
                           setTimeout(function(){
                               $('#groundstoragegrid').datagrid('fixDetailRowHeight',index);
                           },0);
                       }
	                  });
                	   if(row.serialno){
	                	   var paramsArg = {};
					       paramsArg['sourceid'] = row.serialno;
						   var opts = $('#'+params['taxtype']+'-'+index).datagrid('options');
						   opts.url = '/taxmanager/selectshouldtax.do?d='+new Date();
						   $('#'+params['taxtype']+'-'+index).datagrid('load',paramsArg); 
			           }
					    /*
                	  if(row.serialno){
                		  $.ajax({
									  type: "get",
									  async:true,
									  cache:false,
									  url: "/taxmanager/selectshouldtax.do?d="+new Date(),
									  data: {"sourceid":row.serialno},
									  dataType: "json",
									  success:function(jsondata){
										  $('#'+params['taxtype']+'-'+index).datagrid('loadData',jsondata);
									  }
					      });
                	  }
					    */
                      $('#groundstoragegrid').datagrid('fixDetailRowHeight',index);
                      
                   }
			});
			
			
	
			var p = $('#groundstoragegrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
			
			$('#groundstoragequerywindow').window('close');			
			return new Object;
		}
		function openQuery(){
			$('#groundstoragequerywindow').window('open');
		}
		
        function getTaxSourceRow(index){
            var rows = $('#groundstoragegrid').datagrid('getRows');
            for(var i = 0 ;i < rows.length;i++){
            	if(i == index){
            		return rows[i];
            	}
            }
            return null;
        }
		function getParams(){
			//税种
			var row = $('#paramgrid').datagrid('getSelected');
			if(row == null){
			    $.messager.alert('提示消息','请先选择税种!','info');
			    return null;
			}
			
			var oCk = $("#layoutDiv").find("input[type='checkbox']");
			var sourceid = '';
			for(var i = 1 ; i < oCk.length;i++){
				 if(oCk[i].checked){
					 var sourceRow = getTaxSourceRow(i-1);
					 sourceid += ','+sourceRow.serialno;
				 }
			}
			if(sourceid == ''){
				 $.messager.alert('提示消息','请先选择税源!','info');
				 return null;
			}
			
			sourceid = sourceid.substring(1);
			var taxtype = row.taxtypecode;
			return {
				sourceid:sourceid,
				taxtype:taxtype
			};
		}
		
		function generateTax(){
			var params = getParams();
			if(params == null)
				return;
			$.messager.confirm('生成应纳税','您确认要生成选中税源的应纳税吗？',function(r){
	   			if(r){
	   				$.ajax({
					   type: "get",
					   async:false,
					   url: "/taxmanager/generatetax.do?date="+new Date(),
					   data:params,
					   dataType: "json",
					   success: function(jsondata){
						   if(jsondata.sucess){
							   query();
						   }else{
							   $.messager.alert('错误','根据税源生成应纳税失败！','error');
						   }
					   }
			       });
	   			}
			});
			
		}
		function cancelTax(){
			var params = getParams();
			if(params == null)
				return;
			$.messager.confirm('撤销应纳税','您确认要撤销选中税源的应纳税吗？',function(r){
	   			if(r){
	   				$.ajax({
					   type: "get",
					   async:false,
					   url: "/taxmanager/canceltax.do?date="+new Date(),
					   data:params,
					   dataType: "json",
					   success: function(jsondata){
						   if(jsondata.sucess){
							   query();
						   }else{
							   $.messager.alert('错误','根据税源撤销应纳税失败！','error');
						   }
					   }
			       });
	   			}
			});
		}
		
		function exit(){
			var oIframes = parent.$("iframe");
			var currentUrl = "/tdgs/taxmanager/taxmanagerpage.jsp";
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
     <div class="easyui-layout" style="width:100%;height:570px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='groundstoragegrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:false,pageList:[15]">
				<thead>
					
				</thead>
			</table>
		    </form>
	    </div>
	    <div data-options="region:'west'" id="mainWestDiv" style="height:560px;width:180px;overflow: hidden;" id="groupDiv" >
	        <table id='paramgrid' class="easyui-datagrid" style="height:560px;width:180px;overflow: hidden;"
					data-options="iconCls:'icon-edit',singleSelect:true">
				<thead>
					<tr>
					    <th data-options="field:'taxtypecode',hidden:true,width:50,align:'center',editor:{type:'validatebox'}"></th>
						<th data-options="field:'taxtypename',width:175,align:'center',editor:{type:'validatebox'}">税源</th>
					</tr>
				</thead>
			</table>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="generateTax()">生成应纳税</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="cancelTax()">撤销应纳税</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true" onclick="exit();">退出</a>
			</div>
		</div>
	</div>
	
	
	<div id="groundstoragequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'税源查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;height:200px;">
			<form id="taxqueryform" method="post">
				<table id="narjcxx" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
				  
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
						<td align="right">所属期：</td>
						<td colspan="5">
							<input id="begindate" class="easyui-datebox" name="begindate"/>
						至
							<input id="enddate" class="easyui-datebox"  name="enddate"/>
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