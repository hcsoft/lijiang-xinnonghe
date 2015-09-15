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
	
	<script type="text/javascript" src="jquery.featureList-1.0.0.js"></script>
	<link rel="stylesheet" href="style.css"/>
	<script language="javascript">
		$(document).ready(function() {

			$.featureList(
				$("#tabs li a"),
				$("#output li"), {
					start_item	:	1
				}
			);
			/*
			// Alternative
			$('#tabs li a').featureList({
				output			:	'#output li',
				start_item		:	1
			});
			*/
		});
	</script>

	
	
<script type="text/javascript">
/**
 * 时间对象的格式化;
 */
Date.prototype.format = function(format,now) {
    /*
     * eg:format="yyyy-MM-dd hh:mm:ss";
     */

    var d = now ? (new Date(Date.parse(now.replace(/-/g,   "/")))) : this;
    var o = {
        "M+" : d.getMonth() + 1, // month
        "d+" : d.getDate(), // day
        "h+" : d.getHours(), // hour
        "m+" : d.getMinutes(), // minute
        "s+" : d.getSeconds(), // second
        "q+" : Math.floor((d.getMonth() + 3) / 3), // quarter
         "N+" : ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"][d.getDay()],
        "S" : d.getMilliseconds()// millisecond
    }

    if (/(y+)/.test(format)) {
        format = format.replace(RegExp.$1, (d.getFullYear() + "").substr(4
                        - RegExp.$1.length));
    }

    for (var k in o) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length == 1
                            ? o[k]
                            : ("00" + o[k]).substr(("" + o[k]).length));
        }
    }
    return format;
}
 
	function querylog(){
		var rows=$('#levydatetype_table').datagrid("getSelected");
		if(null==rows || ""==rows){
			$.messager.alert("提示","请选择征期类型");
		}
		
		var levydatetype=rows["levydatetype"];
		var opts = $('#loginfo').datagrid('options');
		opts.url = '/taxsettlementservice/querylog.do';
		$('#loginfo').datagrid('load',{levydatetype:levydatetype}); 
	}
	
	function taxsettlement(){
		var rows=$('#loginfo').datagrid("getSelected");
		
		$('#settlement_windows').window('open');
		
		var now=new Date(); 
		now.setMonth(now.getMonth()-1,1);//上个月一号
		
		var dt = new Date();  
	    dt.setMonth(dt.getMonth(),1);  //上个月最后一天
	    cdt = new Date(dt.getTime()-1000*60*60*24);  
		
		$('#cleardatebegin').datebox("setValue", now.format("yyyy-MM-dd"));  
		$('#cleardateend').datebox("setValue", cdt.format("yyyy-MM-dd"));  
		
//		$('#settlementgrid').datagrid('loadData',{total:0,rows:[]});
//		$('#taxtypename2').focus();
//		$('#taxtypename2').select();
//		regquery();
//		if(null!=rows['taxpayerid'] && ''!=$.trim(rows['taxpayerid'])){
//			$.messager.alert("提示","已经匹配过的行!");
//			return;
//		}
		
	}
	
	function back(){
		
	}
	
	function regquery(){
		var params = {};
		params.taxpayerid = "";
		params.taxpayername = $('#taxtypename2').val();
		params.orgunifycode = '';
		var opts = $('#settlementgrid').datagrid('options');
		opts.url = '/InitGroundServlet/getreginfo.do';
		$('#settlementgrid').datagrid('load',params); 
	}
	
	function doclean(){
		var rows=$('#settlementgrid').datagrid("getSelected");
		var matchinforows=$('#loginfo').datagrid("getSelected");
		if(undefined!=rows &&  null!=rows ){
			$.messager.confirm('提示', '是否确认清缴?', function(r){
				if (r){
					$.ajax({
						type: 'POST',
				        url: "/taxsettlementservice/taxsettlement.do",
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
				        		//$('#settlement_windows').window('close');
				        		//querylog();
				        	}
				        }
				    });
				}
			});
		}else{
			$.messager.alert("提示","请选择要匹配的行");
		}
	}
	
	$(function(){
		$('#levydatetype_table').datagrid({
		        singleSelect:true,//单行选取  
		        url:'/taxsettlementservice/querylevydatetype.do',
		        columns:[[
							{field:'name',title:'征期类型',width:170},   
							{field:'Levydatetype',title:'分类代码',hidden:'true'}
		        ]],
//		        fitColumns:true,
		        onLoadSuccess:function(data){  
					$(this).datagrid('selectRow',0);//自动选择第一行
					querylog();
			    }, 
		        onClickRow:function(rowIndex, rowData){  
		        	querylog();
			    }  
		}); 
		
		 $('#loginfo').datagrid({
		        rownumbers:true,//行号   
		        fitColumns:true,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[	{field:'clearlogid',title:'日志序号'},   
		                  	{field:'cleartype ',title:'清缴类型'}, 
							{field:'clearyear',title:'清缴年度'},   
							{field:'clearmonth ',title:'清缴月份'},   
							{field:'cleardate',title:'清缴日期'},   
							{field:'state ',title:'状态',width:100}
		                  
		                  ]],
		        onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
//						 $('#loginfo').datagrid('options').url ="";
						 $.messager.alert("提示","无查询结果!");
					}
			      }, 
			      onDblClickRow:function(rowIndex, rowData){
			    	  //matchwindows();
			      } 
			    
		    }); 
		    
		    $('#settlementgrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    onDblClickRow:function(rowIndex, rowData){
			    	doclean();
			    },
			    onLoadSuccess:function(data){  
					$(this).datagrid('selectRow',0);//自动选择第一行
			    }, 
			});
		    
		    $('#settlement_windows').window('maximize');
	})
</script>
</head>

<body class="easyui-layout" >  
    <div data-options="region:'west',title:'',split:true" style="width:185px;">
    	<table id="levydatetype_table"  style="width:175px;">  
		</table> 
    </div>  
    <div data-options="region:'center',title:''" style="padding:5px;">
			<div style="text-align:left;padding:5px;">  
					<div style="background-color: #c9c692;height: 25px;">		
			<!--  				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="querylog()" >查询日志</a>
			-->				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="taxsettlement()" >新增清缴</a>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="back()" >回退</a>
					</div>
			</div>
			<div >
			<table id="loginfo" title="匹配日志"  >  
			</table>  
			</div>
			
			<div id="settlement_windows" class="easyui-window" data-options="closed:true,modal:true,title:'清缴',collapsible:false,minimizable:false,maximizable:false,closable:true">
					<br>			
					<div id="feature_list">
						<ul id="tabs">
							<li>
								<a href="javascript:;">
									<h3>第一步</h3>
									<span>选择所属期</span>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<h3>第二部</h3>
									<span>数据检查</span>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<h3>第三步</h3>
									<span>自动清缴</span>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<h3>第四步</h3>
									<span>人工处理</span>
								</a>
							</li>
						</ul>
						<ul id="output">
							<li>
								<div style="text-align:left;padding:5px;">  
										<div style="background-color: #c9c692;height: 25px;">		
												<span style="font-size: 12px;">&nbsp;税款所属期起<input id="cleardatebegin" type="text"  class="easyui-datebox" required="required"></input>
																				 税款所属期止<input id="cleardateend" type="text" class="easyui-datebox" required="required"></input> </span>&nbsp;
									<!--			<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()" >查询</a>
									-->				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="doclean()" >清缴</a>
										</div>
									</div>
									<table id="settlementgrid" style="width:700px;height:380px"
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
							</li>
							<li>123124215125151
								<a href="#">See project details</a>
							</li>
							<li>312312312312
								<a href="#">See project details</a>
							</li>
						</ul>
			
					</div>
					        		
			</div>
    </div>  
</body> 
</html>