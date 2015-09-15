<%@ page contentType="text/html; charset=UTF-8"%>

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
<script type="text/javascript">

	function querymatchinfo(id){
		var rows=$('#importtype_table').datagrid("getSelected");
		if(null==rows || ""==rows){
			$.messager.alert("提示","请选择匹配类型");
		}
		
//		var importkey=null!=id?id:$('#importlog').datagrid("getSelected")["id"]; 
		var sn=rows["sn"];
		var matchtype=$("input[name='matchtype']:checked").val();
		if(matchtype==1)
			$('#match').linkbutton({text:'修改匹配'});
		else
			$('#match').linkbutton({text:'手工匹配'});
	
	//	var opts=$('#matchinfo').datagrid('options');
	//	opts.loadFilter=function(data){return data;};//返回结果集第二个元素做datagrid数据
	//	opts.loader=DatagridLoader;
		
		$.ajax({
			type: 'POST',
	        url: "/datamatchservice/querymatchinfocolumns.do",
	        data: {
				importkey:'',
				sn:sn,
		 		matchtype:matchtype,
		 		taxtypename:$("#taxtypename").val()
	        	},
	       	dataType: "json",
	        success: function (data) {
				$('#matchinfo').datagrid({columns:[data.columns]});
	//			$('#matchinfo').datagrid("loadData",data);
				$('#matchinfo').datagrid('options').url = '/datamatchservice/querymatchinfo.do';
				$('#matchinfo').datagrid('getPager').pagination({ 
					pageSize: 15,
					showPageList:false
				});
	        }
	    });
		
		var employdate=$('#query_employdate').datebox('getValue');
		var area=$('#query_area').val();
		var getmoney= $('#query_getmoney').val();
		var linkphone=$('#query_linkphone').val();
		
		$('#matchinfo').datagrid('load',{
			importkey:'',
			sn:sn,
	 		matchtype:matchtype,
	 		taxtypename:$("#taxtypename").val(),
	 		employdate:employdate,
	 		area:area,
	 		getmoney:getmoney,
	 		linkphone:linkphone}
		); 
	}
	
	function matchwindows(){
		var rows=$('#matchinfo').datagrid("getSelected");
		
//		if(rows['exportstate']==1){
//			$.messager.alert("提示","已导入正式表不可再匹配!");
//			return;
//		}
		
		if(undefined!=rows &&  null!=rows ){
			$('#taxtypename2').val(rows['importtaxpayername']);
			$('#match_windows').window('open');
			$('#reginfogrid').datagrid('loadData',{total:0,rows:[]});
			$('#taxtypename2').focus();
			$('#taxtypename2').select();
			regquery();
			if(null!=rows['taxpayerid'] && ''!=$.trim(rows['taxpayerid'])){
				$.messager.alert("提示","已经匹配过的行!");
	//			return;
			}
		}else{
			$.messager.alert("提示","请选择要匹配的行");
		}
	}
	function regquery(){
		var params = {};
		params.taxpayerid = "";
		params.taxpayername = $('#taxtypename2').val();
		params.orgunifycode = '';
		var opts = $('#reginfogrid').datagrid('options');
		opts.url = '/InitGroundServlet/getreginfo.do';
		$('#reginfogrid').datagrid('load',params); 
	}
	
	function match(){
		var rows=$('#reginfogrid').datagrid("getSelected");
		var matchinforows=$('#matchinfo').datagrid("getSelected");
		if(undefined!=rows &&  null!=rows ){
			$.messager.confirm('提示', '是否确认['+rows['taxpayerid']+']与['+matchinforows['importtaxpayername']+']匹配?', function(r){
				if (r){
					$.ajax({
						type: 'POST',
				        url: "/datamatchservice/match.do",
				        data: {
				        	tablename:matchinforows['tablename'],
							pk:matchinforows['pk'],
					 		pkvalue:matchinforows[matchinforows['pk']],
					 		taxpayerid:rows['taxpayerid'],
					 		taxpayername:rows['taxpayername'],
					 		importtaxpayername:matchinforows['importtaxpayername']},
				       	dataType: "json",
				        success: function (data) {
				        	if(data=='0')
				        		$.messager.alert("提示","匹配失败!");
				        	else{
				        		$.messager.alert("提示","匹配成功!");
				        		$('#match_windows').window('close');
				        		querymatchinfo();
				        	}
				        }
				    });
				}
			});
		}else{
			$.messager.alert("提示","请选择要匹配的行");
		}
	}
	
	function match_editewindows(){
		if($('#importtype_table').datagrid("getSelected").sn!=4)
			return;
		
		var rows=$('#matchinfo').datagrid("getSelected");
		
		if(undefined!=rows &&  null!=rows ){
			$('#employdate').datebox('setValue', rows['employdate']);
			$('#area').val(rows['area']);
			$('#getmoney').val(rows['getmoney']);
			$('#employdate').focus();
			
			$('#match_edite_windows').window('open');
		}else{
			$.messager.alert("提示","请选择要修改的行");
		}
	}
	
	function match_edite_save(){
		$.messager.confirm('提示', '是否确认保存?', function(r){
			if (r){
				$.ajax({
					type: 'POST',
			        url: "/datamatchservice/matchedite.do",
			        data: {
			        	employland:$('#matchinfo').datagrid("getSelected").employland,
			        	area:$('#area').val(),
			        	getmoney:$('#getmoney').val(),
			        	employdate:$('#employdate').datebox('getValue')},
			       	dataType: "json",
			        success: function (data) {
				        		$('#match_edite_windows').window('close');
				        		$.messager.alert("提示",data);
				        		querymatchinfo();
			        		}
			    });
			}
		});
	}
	
	function match_querywindows(){
		
		if($('#importtype_table').datagrid("getSelected").sn!=4){
			querymatchinfo();
		}
		else{
			$('#query_employdate').datebox('setValue', '');
			$('#query_area').val('');
			$('#query_getmoney').val('');
			$('#query_linkphone').val('');
			$('#query_employdate').focus();
			
			$('#match_query_windows').window('open');
		}
	}
	
	function match_query(){
		querymatchinfo();
		$('#match_query_windows').window('close');
	}
	
	
	$(function(){
		$('#importtype_table').datagrid({
		        singleSelect:true,//单行选取  
		        url:'/dataimportservice/queryimporttype.do',
		        columns:[[
							{field:'modulename',title:'名称'},   
							{field:'sn',title:'分类代码',hidden:'true'}
		        ]],
		        fitColumns:true,
		        onLoadSuccess:function(data){  
					$(this).datagrid('selectRow',0);//自动选择第一行
					querymatchinfo();
			    }, 
		        onClickRow:function(rowIndex, rowData){  
		        	querymatchinfo();
			    }  
		}); 
		
		 $('#matchinfo').datagrid({
		        rownumbers:true,//行号   
		        fitColumns:true,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[]],
		        onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
//						 $('#matchinfo').datagrid('options').url ="";
//						 $.messager.alert("提示","无查询结果!");
					}
			      }, 
			      onDblClickRow:function(rowIndex, rowData){
			    	  matchwindows();
			      } 
			    
		    }); 
		    
		    $('#reginfogrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    onDblClickRow:function(rowIndex, rowData){
			    	match();
			    },
			    onLoadSuccess:function(data){  
					$(this).datagrid('selectRow',0);//自动选择第一行
			    }
			});
		    $('#reginfogrid').datagrid('getPager').pagination({  
		    	pageSize: 15,
				showPageList:false
			});
	})
</script>
</head>

<body class="easyui-layout">  
    <div data-options="region:'west',title:'匹配类型',split:true" style="width:185px;">
    	<table id="importtype_table"  style="width:175px;">  
		</table> 
    </div>  
    <div data-options="region:'center',title:''" style="padding:5px;">
			<div style="text-align:left;padding:5px;">  
					<div style="background-color: #c9c692;height: 25px;">		
							<span style="font-size: 12px; color:red; font-weight: bold;">过滤条件：</span>
							<span style="font-size: 12px;"><input type="radio" checked="checked" name="matchtype" value="0" onclick="querymatchinfo()"/>未匹配</span>&nbsp;
							<span style="font-size: 12px;"><input type="radio"  name="matchtype" value="1" onclick="querymatchinfo()"/>已匹配</span>&nbsp;
							<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
							<span style="font-size: 12px;">纳税人名称<input type="text" id="taxtypename" name="taxtypename" style="width:100px"/></span>&nbsp;
							<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="match_querywindows()" >查询</a>
							<a id="match" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="matchwindows()" >手工匹配</a>
							<a id="match_edite" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-check'" onclick="match_editewindows()" >修改</a>
					</div>
			</div>
			<div >
			<table id="matchinfo" title="匹配信息"  >  
			</table>  
			</div>
			
			<div id="match_windows" class="easyui-window" data-options="closed:true,modal:true,title:'手工匹配',collapsible:false,minimizable:false,maximizable:false,closable:true">
						<div style="text-align:left;padding:5px;">  
							<div style="background-color: #c9c692;height: 25px;">		
									<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
									<span style="font-size: 12px;">纳税人名称<input  type="text" style="width:250px" id="taxtypename2" name="taxtypename2"/></span>&nbsp;
									<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
									<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()" >查询</a>
									<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="match()" >匹配</a>
							</div>
						</div>
						<table id="reginfogrid" style="width:700px;height:380px"
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:300,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'taxdeptcode',width:100,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:80,align:'center',editor:{type:'validatebox'}">税收管理员</th>
								</tr>
							</thead>
						</table>
			</div>
			<div id="match_edite_windows" class="easyui-window" data-options="closed:true,modal:true,title:'导入信息修改',collapsible:false,minimizable:false,maximizable:false,closable:true">
				<div style="text-align:center;padding:5px;">  
				<table id="narjcxx" class="table table-bordered">
					<tr>
						<td align="right">实际占用日期 ：</td>
						<td>
							<input id="employdate" class="easyui-datebox" type="text" style="width:200px" name="employdate" 
							 required="required" />					
						</td>
					</tr>
					<tr>
						<td align="right">占地面积(平方米)：</td>
						<td>
							<input id="area" class="easyui-validatebox" type="text" style="width:200px" name="area"/>					
						</td>
					</tr>
					<tr>
						<td align="right">预计土地价格(万元)：</td>
						<td>
							<input id="getmoney" class="easyui-validatebox" type="text" style="width:200px" name="getmoney"/>					
						</td>
					</tr>
				</table>
				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="match_edite_save()" >保存</a>
				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#match_edite_windows').window('close');" >取消</a>
				</div>
			</div>
			<div id="match_query_windows" class="easyui-window" data-options="closed:true,modal:true,title:'导入信息修改',collapsible:false,minimizable:false,maximizable:false,closable:true">
				<div style="text-align:center;padding:5px;">  
				<table id="narjcxx" class="table table-bordered">
					<tr>
						<td align="right">实际占用日期 ：</td>
						<td>
							<input id="query_employdate" class="easyui-datebox" type="text" style="width:200px" name="query_employdate" />					
						</td>
					</tr>
					<tr>
						<td align="right">占地面积(平方米)：</td>
						<td>
							<input id="query_area" class="easyui-validatebox" type="text" style="width:200px" name="query_area"/>					
						</td>
					</tr>
					<tr>
						<td align="right">预计土地价格(万元)：</td>
						<td>
							<input id="query_getmoney" class="easyui-validatebox" type="text" style="width:200px" name="query_getmoney"/>					
						</td>
					</tr>
					<tr>
						<td align="right">联系电话：</td>
						<td>
							<input id="query_linkphone" class="easyui-validatebox" type="text" style="width:200px" name="query_linkphone"/>					
						</td>
					</tr>
				</table>
				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="match_query()" >查询</a>
				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#match_query_windows').window('close');" >取消</a>
				</div>
			</div>
    </div>  
</body> 
</html>