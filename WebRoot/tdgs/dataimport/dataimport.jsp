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
	<script src="/js/common.js"></script>
<link href="ajaxfileupload.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="ajaxfileupload.js"></script>
<script type="text/javascript">
var empdata = new Object;//人员
var orgdata = new Object;//机关
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

 	function formatterDate(value,row,index){
		return new Date(value).format("yyyy-MM-dd h:m:s");
	}
 	function formatterDate1(value,row,index){
		return new Date(value).format("yyyy-MM-dd");
	}
	function formatemp(row){
		for(var i=0; i<empdata.length; i++){
			if (empdata[i].key == row) return empdata[i].value;
		}
		return row;
	};
	function formatorg(row){
		for(var i=0; i<orgdata.length; i++){
			if (orgdata[i].key == row) return orgdata[i].value;
		}
		return row;
	};
	function uploadcheck(){
		var rows=$('#importtype_table').datagrid("getSelected");
		if(null==rows || ""==rows){
			$.messager.alert("提示","请选择导入类型");
		}else{
			$("#fileToUpload").click();
			//$.messager.alert("提示","导入类型为："+$('#importtype_table').datagrid("getSelected")["modulename"],"",function(){
			//	$("#fileToUpload").click();
			//});
		}
	}
	
	function ajaxFileUpload()
	{
		var importtype=$('#importtype_table').datagrid("getSelected")["sn"];
		
		var filename=$("#fileToUpload").val();
		if(filename==undefined||$.trim(filename)==""){  
			$.messager.alert("提示","请选择上传文件！");
			return;
		}else{  
		       var fileTArr=filename.toLowerCase().split(".");  
		       var filetype=fileTArr[fileTArr.length-1];  
		       if(filetype!="xls"){
		    	  $.messager.alert("提示","上传文件必须为Excel文件(.xls)！");  
		    	  return;
		       }
		}
		//alert('aaa');
		Load();
		$.ajaxFileUpload
		(
			{
				url:'/dataimportservice/excelimport.do?importtype='+importtype,
				secureuri:false,
				fileElementId:'fileToUpload',
				dataType: 'json',
				success: function (data, status)
				{
					$.messager.alert("提示",data);
					queryimportlog();
					dispalyLoad();
				},
				error: function (data, status, e)
				{
					$.messager.alert("提示",data+" "+e);
					dispalyLoad();
				}
			}
		)
		return false;
	}
	
	function removeimport(){
		var rows=$('#importlog').datagrid("getSelected");
		if(rows){
			if(rows.comparestate=='1'){
				$.messager.alert("提示","该导入文件已进行比对，不允许删除！");
				return;
			}else if(rows.manualmatchcount>0){
				$.messager.confirm("提示","该文件已有人工匹配记录，是否确认要删除导入日志为："+rows["id"]+" 的数据？",function(r){
					if(r){
						$.ajax({
							 type: 'POST',
							 url: "/dataimportservice/deleteimport.do" ,
							 data: {importlogid:rows["id"]},
							 dataType: "json",
							 success: function(data){
								 if("删除数据成功!"==data)
									queryimportlog();
								 $.messager.alert("提示",data);
							 } 
						});
					}
				});
			}else{
				$.messager.confirm("提示","是否确认要删除导入日志为："+rows["id"]+" 的数据？",function(r){
					if(r){
						$.ajax({
							 type: 'POST',
							 url: "/dataimportservice/deleteimport.do" ,
							 data: {importlogid:rows["id"]},
							 dataType: "json",
							 success: function(data){
								 if("删除数据成功!"==data)
									queryimportlog();
								 $.messager.alert("提示",data);
							 } 
						});
					}
				});
			}
		}else{
			$.messager.alert("提示","请选择要删除的文件记录！");
			return
		}
	}
	
	function queryimportlog(){
		var importtype=$('#importtype_table').datagrid("getSelected")["sn"];
		$.ajax({
		     type: 'POST',
		     url: "/dataimportservice/queryimportlog.do" ,
		     data: {importtype:importtype},
		     dataType: "json",
		     success: function(data){
		    	 $('#importlog').datagrid("loadData",data.rows);
		     } 
		});
	}

	
	function showmore(id){
		$('#showmore_win').window('open');
		$('#showmore_id').val(id);
		querymatchinfo(id);
	}
	
	function taxpayernamecellstyle(value,row,index){
	       if ($.trim(row['taxpayername'])!=''
	       		&& row['importtaxpayername'] != row['taxpayername']){
	    	 return 'color:red;';
	    }
		
	}
	
	function querymatchinfo(id){
		var rows=$('#importtype_table').datagrid("getSelected");
		if(null==rows || ""==rows){
			$.messager.alert("提示","请选择匹配类型");
		}
		
		var importkey=null!=id?id:$('#importlog').datagrid("getSelected")["id"]; 
		var sn=rows["sn"];
		var matchtype=$("input[name='matchtype']:checked").val();
		if(matchtype==1)
			$('#match').linkbutton({text:'修改匹配'});
		else
			$('#match').linkbutton({text:'手工匹配'});

//		var opts=$('#matchinfo').datagrid('options');
//		opts.loadFilter=function(data){return data;};//返回结果集第二个元素做datagrid数据
//		opts.loader=DatagridLoader;
		
		$.ajax({
			type: 'POST',
            url: "/datamatchservice/querymatchinfocolumns.do",
            data: {
				importkey:importkey,
				sn:sn,
    	 		matchtype:matchtype,
    	 		taxtypename:$("#taxtypename").val()},
           	dataType: "json",
            success: function (data) {
            	
           		for(var i=0;i<data.columns.length;i++){
	           		if(data.columns[i].field=='taxpayername' || data.columns[i].field=='importtaxpayername' ){
           				data.columns[i]['styler']=taxpayernamecellstyle;
            		}
					if(data.columns[i].field.toLowerCase()=='selldate'){
						data.columns[i].field='holddate';
					}
					if(data.columns[i].field.toLowerCase()=='employdate' || data.columns[i].field.toLowerCase()=='providedate'){
						data.columns[i].field='holddate';
					}
					if(data.columns[i].field.toLowerCase()=='linkphone'){
						data.columns[i].field='telephone';
					}
					if(data.columns[i].align != null && data.columns[i].align.toLowerCase()=='right'){
						data.columns[i].formatter=formatnumber;
					}
            	}
            	data.columns.push({"field":"taxorgsupcode","title":"州市地税机关","hidden":"","align":"","sortable":"","formatter":formatorg});
				data.columns.push({"field":"taxorgcode","title":"县区地税机关","hidden":"","align":"","sortable":"","formatter":formatorg});
				data.columns.push({"field":"taxdeptcode","title":"主管地税部门","hidden":"","align":"","sortable":"","formatter":formatorg});
				data.columns.push({"field":"taxmanagercode","title":"税收管理员","hidden":"","align":"","sortable":"","formatter":formatemp});
				$('#matchinfo').datagrid({columns:[data.columns]});
//				$('#matchinfo').datagrid("loadData",data);
				$('#matchinfo').datagrid({
					toolbar:[{
						text:'导出',
						iconCls:'icon-export',
						handler:function(){
							$.messager.confirm('提示', '是否确认导出?', function(r){
								if (r){
									var param='importkey='+$('#showmore_id').val()+'&sn='+sn;
									window.open("/datamatchservice/export.do?"+param, '',
									   'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
								}
							});
						}
					}]
				});
				$('#matchinfo').datagrid('options').url = '/datamatchservice/querymatchinfo.do';
				$('#matchinfo').datagrid('getPager').pagination({   
					showPageList:false,
					pageSize: 15
				});
            }
        });
		
		$('#matchinfo').datagrid('load',{
			importkey:importkey,
			sn:sn,
	 		matchtype:matchtype,
	 		taxtypename:$("#taxtypename").val()}
		); 
	}
	
	function matchwindows(){
		var rows=$('#matchinfo').datagrid("getSelected");
		if(undefined!=rows &&  null!=rows ){
			$('#taxtypename2').val(rows['importtaxpayername']);
			$('#match_windows').window('open');
			$('#reginfogrid').datagrid('loadData',{total:0,rows:[]});
			$('#taxtypename2').focus();
			$('#taxtypename2').select();
			
			if(null!=rows['taxpayerid'] && ''!=$.trim(rows['taxpayerid'])){
				$.messager.alert("提示","已经匹配过的行!");
//				return;
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
	
	function wtitetable(){
		var rows=$('#importlog').datagrid("getSelected");
		if(null==rows || ""==rows){
			$.messager.alert("提示","请选择导入日志");
		}else{
			if(rows['sumcount']!=rows['matecount']){
				$.messager.alert("提示","所有数据匹配完才能导入正式表!");
				return;
			}
			$.messager.confirm("提示","是否要把导入日志为："+rows["id"]+" 的数据写入正式表？",function(r){
				if(r){
					$.ajax({
					     type: 'POST',
					     url: "/dataimportservice/writetable.do" ,
					     data: {importlogid:rows["id"]},
					     dataType: "json",
					     success: function(data){
					    	 if("写入正式表成功!"==data)
					    	 	queryimportlog();
					    	 $.messager.alert("提示",data);
					     } 
					});
				}
			});
		}
		
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
	$(function(){
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_TAXEMPCODE'},
		   dataType: "json",
		   success: function(jsondata){
			  empdata= jsondata;
		   }
		});
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_TAXORGCODE'},
		   dataType: "json",
		   success: function(jsondata){
			  orgdata= jsondata;
		   }
		});
		$('#importlog').datagrid({  
			fitColumns:false,
			singleSelect:true,
			rownumbers:true,
			columns:[[
			          {field:'id',title:'导入序号',width:250,align:'center',formatter: function(value,row,index){
			        	  return "<a href='javascript:void(0)' class='easyui-linkbutton'  onclick=showmore('"+value+"')>"+value+"</a>";
			        	  /*
			        	  var buttonstr="";
			        	  return "<a href='#' class='easyui-linkbutton  l-btn'  onclick=showmore('"+value+"')>"+
			        	  "<span class='l-btn-left'><span>匹配</span></span></a>"+
			        	  "<a href='#' class='easyui-linkbutton  l-btn' alt='查看明细'  onclick=showmore('"+value+"')>"+
			        	  "<span class='l-btn-left'><span>明细</span></span></a>"+
			        	  "<a href='#' class='easyui-linkbutton l-btn'  onclick=';'>"+
			        	  "<span class='l-btn-left'><span>写入</span></span></a>"+
			        	  "<a href='#' class='easyui-linkbutton l-btn'  onclick='removeimport();'>"+
			        	  "<span class='l-btn-left'><span>删除</span></span></a>";*/
		          		}
			          },   
			          //{field:'modulename',title:'名称',width:150,align:'center'},   
			          {field:'filename',title:'文件名',width:235,align:'center'},   
			          {field:'optdate',title:'导入时间',width:110,align:'center',formatter:formatterDate1
			          },
			          {field:'optempcode',title:'导入人员',width:110,formatter:formatemp,align:'center'},   
			          {field:'sumcount',title:'导入行数',width:70,align:'center'},
			          {field:'automatchcount',title:'自动匹配行数',width:100,align:'center'},
					  {field:'manualmatchcount',title:'手工匹配行数',width:100,align:'center'},
			          {field:'comparestate',title:'比对状态',formatter:function(row,value,index){
						  if(value=='1'){
							  return '已比对';
						  }else{
							   return '未比对';
						  }
					  },width:90,align:'center'}
			      ]]   
		});
		
		 $('#importtype_table').datagrid({
				fitColumns:'true',
		        singleSelect:true,//单行选取  
		        url:'/dataimportservice/queryimporttype.do',
		        columns:[[
							{field:'modulename',width:50,align:'center',title:'导入类型'},   
							{field:'sn',title:'分类代码',hidden:'true'}
		        ]],
		        fitColumns:true,
		        onLoadSuccess:function(data){  
					$(this).datagrid('selectRow',0);//自动选择第一行
					queryimportlog();
			    }, 
		        onClickRow:function(rowIndex, rowData){  
					queryimportlog();//选中行查询日志
			    }  
		}); 
		
	    $('#matchinfo').datagrid({
	        rownumbers:true,//行号   
	        //fitColumns:true,
	        loadMsg:'数据装载中......',    
	        singleSelect:true,//单行选取  
	        pagination:{  
		        pageSize: 10 
		    },
	        columns:[[]],
	        onLoadSuccess:function(data){
				if(data.total== undefined || data.total==0){
//					 $('#matchinfo').datagrid('options').url ="";
					 $.messager.alert("提示","无查询结果!");
				}
		      }, 
		      onDblClickRow:function(rowIndex, rowData){
//		    	  matchwindows();
		      } 
		    
	    }); 
	    
	    $('#reginfogrid').datagrid({
			fitColumns:'true',
			maximized:'true',
			pagination:{  
		        pageSize: 15
		    },
			toolbar:[{
				text:'确定',
				iconCls:'icon-search',
				handler:function(){
					var reg = $('#reginfogrid').datagrid('getSelected');
					$('#taxpayer').val(reg.taxpayerid);
					$('#taxpayername').val(reg.taxpayername);
					$('#reginfowindow').window('close');
				}
			}]
		});
	    $('#reginfogrid').datagrid('getPager').pagination({   
			showPageList:false,
			pageSize: 15
		});
	})
</script>
</head>

<body class="easyui-layout">  
    <div data-options="region:'west',title:'',split:true" style="width:185px;">
    	<table id="importtype_table"  style="width:175px;">  
		</table> 
    </div>  
    <div data-options="region:'center',title:''" style="padding:5px;">
    	<div style="text-align:left;padding:5px;">  
					<input id="fileToUpload" type="file" size="45" name="fileToUpload" class="input" style="display:none" onchange="return ajaxFileUpload();">
					<a id="add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-import'" onclick="uploadcheck();" >导入文件</a>
			<!---->	<a id="delete" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="removeimport();">删除</a>
					<!-- <a id="importformaltable" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="wtitetable()" >写入正式表</a>   -->
		</div>
		<!--<div class="easyui-tabs"> -->
			<div title="导入日志" >
				<table id="importlog" title="" class="easyui-datagrid" style="overflow:visible;height:500px;">  
				</table>  
			</div>
	<!--		<div title="导入日志历史" data-options="closable:false" style="padding:20px;display:none;">  
	        	<table id="importlog_history" title="" class="easyui-datagrid" >  
				    <thead>  
				        <tr>  
				            <th data-options="field:'id'">导入序号</th>  
				            <th data-options="field:'optdate',width:110">导入时间</th>
				            <th data-options="field:'filename',width:255">文件名</th>
				            <th data-options="field:'modulename',width:185">名称</th>  
				            <th data-options="field:'optempcode',width:110">导入人</th>
				            <th data-options="field:'sumcount',width:90">导入行数</th>
				        </tr>  
				    </thead>  
				</table>  
	    	</div> 
    	</div>-->
    </div>  
    <div id="showmore_win" class="easyui-window" style="width:950px;height:520px;" 
	data-options="closed:true,modal:true,title:'导入详细数据',collapsible:false,minimizable:false,maximizable:false,closable:true">
		<input type="hidden" id="showmore_id">
<!-- 		<div style="text-align:left;padding:5px;">  
					<div style="background-color: #c9c692;height: 25px;">		
							<span style="font-size: 12px; color:red; font-weight: bold;">过滤条件：</span>
							<span style="font-size: 12px;"><input type="radio" checked="checked" name="matchtype" value="0" onclick="querymatchinfo()"/>未匹配</span>&nbsp;
							<span style="font-size: 12px;"><input type="radio"  name="matchtype" value="1" onclick="querymatchinfo()"/>已匹配</span>&nbsp;
							<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
							<span style="font-size: 12px;">纳税人名称<input type="text" id="taxtypename" name="taxtypename"/></span>&nbsp;
							<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
							<a id="match" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="matchwindows()" >手工匹配</a>
					</div>
				</div>--> 
		<table id="matchinfo" title=""  style="width:930px;height:460px;overflow:auto;" >  
		</table>
	</div>
	
	<div id="match_windows" class="easyui-window" data-options="closed:true,modal:true,title:'手工匹配',collapsible:false,minimizable:false,maximizable:false,closable:true">
				<div style="text-align:left;padding:5px;">
					<div style="background-color: #c9c692;height: 25px;">
							<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
							<span style="font-size: 12px;">纳税人名称<input  type="text" style="width:250px" id="taxtypename2" name="taxtypename2"/></span>&nbsp;
							<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
							<a id="match" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()" >查询</a>
							<a id="match" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="match()" >匹配</a>
					</div>
				</div>
				<table id="reginfogrid" style="width:650px;height:420px"
				data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
					<thead>
						<tr>
							<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
							<th data-options="field:'taxpayername',width:300,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
							<th data-options="field:'taxdeptcode',width:100,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
							<th data-options="field:'taxmanagercode',width:80,align:'center',editor:{type:'validatebox'}">税收管理员</th>
						</tr>
					</thead>
				</table>
	</div>
	
</body> 
</html>