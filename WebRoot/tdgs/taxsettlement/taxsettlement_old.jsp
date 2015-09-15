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
	
	<script src="custom.js"></script>
	<link rel="stylesheet" href="default.css"/>
	<link rel="stylesheet" href="custom.css"/>
	
	
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
	function formatter(value,row,index){
			return new Date(value).format("yyyy-MM-dd h:m:s");
	}
	function formatter1(value,row,index){
			return new Date(value).format("yyyy-MM-dd");
	}
	
	var emplist = new Array();//人员
	var taxcodelist = new Array();//税目
	function getNameByCode(list,code){
		for(var i=0; i<list.length; i++){
			if (list[i].key == code) return list[i].value;
		}
		return code;
	};
 
	function formattertaxcode(value,row,index){
		return getNameByCode(taxcodelist,value);
	}
	
	function formattertaxempcode(value,row,index){
		return getNameByCode(emplist,value);
	}
	
	function querylog(){
		var rows=$('#levydatetype_table').datagrid("getSelected");
		if(null==rows || ""==rows){
			$.messager.alert("提示","请选择征期类型");
		}
		
		var levydatetype=rows["levydatetype"];
		var opts = $('#loginfo').datagrid('options');
		var p = $('#loginfo').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		opts.url = '/taxsettlementservice/querylog.do';
		$('#loginfo').datagrid('load',{levydatetype:levydatetype}); 
	}
	
	function taxsettlement(){
		var rows=$('#levydatetype_table').datagrid("getSelected");

		var now=new Date();
		if(rows.levydatetype==1){
			$('#year_windows').combobox({valueField:'id', textField:'text',editable:false,data :
						[{"id":now.getFullYear()-1,"text":now.getFullYear()-1+'年'},{"id":now.getFullYear(),"text":now.getFullYear()+'年'}]});
			$('#taxdate_show').combobox({valueField:'id', textField:'text',editable:false,data :
					[{"id":1,"text":'一月'},{"id":2,"text":'二月'},{"id":3,"text":'三月'},{"id":4,"text":'四月'},{"id":5,"text":'五月'},{"id":6,"text":'六月'},
					 {"id":7,"text":'七月'},{"id":8,"text":'八月'},{"id":9,"text":'九月'},{"id":10,"text":'十月'},{"id":11,"text":'十一月'},{"id":12,"text":'十二月'}]});
			if((now.getMonth()+1)>1){
				$('#year_windows').combobox("setValue",now.getFullYear());
				$('#taxdate_show').combobox("setValue",now.getMonth());
			}else{
				$('#year_windows').combobox("setValue",now.getFullYear()-1);
				$('#taxdate_show').combobox("setValue",12);
			}
		}else if(rows.levydatetype==2){
			$('#year_windows').combobox({valueField:'id', textField:'text',editable:false,data :
				[{"id":now.getFullYear()-1,"text":now.getFullYear()-1+'年'},{"id":now.getFullYear(),"text":now.getFullYear()+'年'}]});
			$('#taxdate_show').combobox({valueField:'id', textField:'text',editable:false,data :
					[{"id":1,"text":'一季度'},{"id":2,"text":'二季度'},{"id":3,"text":'三季度'},{"id":4,"text":'四季度'}]});
			if((now.getMonth()+1)>9){
				$('#taxdate_show').combobox("setValue",3);
				$('#year_windows').combobox("setValue",now.getFullYear());
			}else if((now.getMonth()+1)>6){
				$('#taxdate_show').combobox("setValue",2);
				$('#year_windows').combobox("setValue",now.getFullYear());
			}else if((now.getMonth()+1)>3){
				$('#taxdate_show').combobox("setValue",1);
				$('#year_windows').combobox("setValue",now.getFullYear());
			}else{
				$('#taxdate_show').combobox("setValue",4);
				$('#year_windows').combobox("setValue",now.getFullYear()-1);
			}
			
		}else if(rows.levydatetype==3){
			$('#year_windows').combobox({valueField:'id', textField:'text',editable:false,data :
				[{"id":now.getFullYear()-1,"text":now.getFullYear()-1+'年'},{"id":now.getFullYear(),"text":now.getFullYear()+'年'}]});
			$('#taxdate_show').combobox({valueField:'id', textField:'text',editable:false,data :
					[{"id":1,"text":'上半年'},{"id":2,"text":'下半年'}]});
			if((now.getMonth()+1)>6){
				$('#taxdate_show').combobox("setValue",1);
				$('#year_windows').combobox("setValue",now.getFullYear());
			}else{
				$('#taxdate_show').combobox("setValue",2);
				$('#year_windows').combobox("setValue",now.getFullYear()-1);
			}
		}else if(rows.levydatetype==4){
			$('#year_windows').combobox({valueField:'id', textField:'text',editable:false,data :
				[{"id":now.getFullYear()-1,"text":now.getFullYear()-1+'年'},{"id":now.getFullYear(),"text":now.getFullYear()+'年'}]});
			$('#year_windows').combobox("setValue",'');
			$('#year_windows').combobox("disable");
			$('#taxdate_show').combobox({valueField:'id', textField:'text',editable:false,data :
					[{"id":now.getFullYear()-1,"text":now.getFullYear()-1+'年'}]});
			$('#taxdate_show').combobox("setValue",now.getFullYear()-1);
		}
			
		$('#settlement_windows').window('open');
		
		//测试时使用
		$('#year_windows').combobox("setValue",2012);
		$('#taxdate_show').combobox("setValue",1);
		
		if(rows.levydatetype==5){
			$('#con1_year').hide();   
			$('#con1_date').hide();   
		}else{
			$('#con1_year').show();   
			$('#con1_date').show(); 
		}
	}
	
	$(function(){
		$('#levydatetype_table').datagrid({
		        singleSelect:true,//单行选取  
		        url:'/taxsettlementservice/querylevydatetype.do',
		        columns:[[
							{field:'name',title:'征期类型',width:170},   
							{field:'levydatetype',title:'分类代码',hidden:'true'}
		        ]],
//		        fitColumns:true,
		        onLoadSuccess:function(data){  
					$(this).datagrid('selectRow',0);//自动选择第一行
					$("#levydatetype_show").val($('#levydatetype_table').datagrid("getSelected").name);
					$("#levydatetype_show").attr('disabled','disabled');
					querylog();
			    }, 
		        onClickRow:function(rowIndex, rowData){  
		        	querylog();
		        	$("#levydatetype_show").val($('#levydatetype_table').datagrid("getSelected").name);
					$("#levydatetype_show").attr('disabled','disabled');
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
							{field:'clearyear',title:'清缴年度'},   
							{field:'clearmonth',title:'清缴月份'},   
							{field:'cleardate',title:'清缴日期',formatter: formatter1},   
							{field:'clearperson',title:'清缴人'},   
							{field:'taxorgsupcode',title:'市级机关'},  
							{field:'taxorgcode',title:'县级机关'},  
							{field:'taxdeptcode',title:'分局机关'},  
							{field:'owingtax',title:'比对欠税'},  
							{field:'differencetax',title:'比对差异',styler:function (value){
								if(value>0)
									return 'color:red;';
							}},  
							{field:'settletax',title:'比对清缴'},  
							{field:'taxsourcesdifference',title:'状态'},  
							{field:'manualowingtax',title:'人工确认欠税 '},  
							{field:'manualsettletax',title:'人工确认清缴'}
		                  ]],
		        onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
//						 $('#loginfo').datagrid('options').url ="";
					//	 $.messager.alert("提示","无查询结果!");
					}
			      }, 
			      onDblClickRow:function(rowIndex, rowData){
			    	  //matchwindows();
			      } 
			    
		    }); 
		 $('#detail_table').datagrid({
		        rownumbers:true,//行号   
		        fitColumns:true,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[	{field:'taxpayerid',title:'计算机编码'},   
							{field:'taxpayername',title:'纳税人名称'},  
							{field:'taxtypecode',title:'税种', formatter:formattertaxcode},  
							{field:'taxcode',title:'税目', formatter:formattertaxcode},  
							{field:'taxamountactual',title:'实缴金额',align:'right'},   
							{field:'taxbegindate',title:'税款起日期',formatter: formatter1},   
							{field:'taxenddate',title:'税款止日期',formatter: formatter1}
		                  ]],
		        onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
						 $.messager.alert("提示","无查询结果!");
					}
			      }, 
			      onDblClickRow:function(rowIndex, rowData){
			    	  //matchwindows();
			      } 
			    
		    });    
		 
		    $('#settlementgrid1').datagrid({
		    	rownumbers:true,
		    	singleSelect:true,
				fitColumns:true,
				maximized:true,
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    columns:[[
							{field:'paytaxid',title:'主键',hidden:'true'}, 
							{field:'taxbillno',title:'税票号',width:125,hidden:'true'},   
							{field:'taxcode',title:'税目',width:80, formatter:formattertaxcode},   
							{field:'taxpayerid',title:'计算机编码',width:110},   
							{field:'taxpayername',title:'纳税人名称',width:130},   
							{field:'taxamountactual',title:'已缴金额',align:'right',width:100},   
							{field:'taxbegindate',title:'税款所属期起',width:100,formatter: formatter1}, 
							{field:'taxenddate',title:'税款所属期止',width:100,formatter: formatter1},
//							{field:'taxmanagercode',title:'税收管理员',width:100, formatter:formattertaxempcode}, 
							{field:'clearlogid',title:'日志ID',hidden:'true'},
							{field:'taxstate',title:'状态',hidden:'true'}
		        ]],
			    onClickRow:settlementgrid_query
			    ,
			    onLoadSuccess:function(data){  
			    	var querytype=$("input[name='querytype']:checked").val();
					if(querytype==3 && data.rows.length<=0){
						$('#manualbutton1').linkbutton('disable'); 
						$('#manualbutton2').linkbutton('disable');
						$.messager.confirm('提示', '已完成清缴,是否关闭当前窗口?', function(r){
							if (r){
								$('#settlement_windows').window('close');
							}
						});
					}
					$(this).datagrid('selectRow',0);//自动选择第一行
					settlementgrid_query(0,data.rows[0]);
			    }, 
			});
		    $('#settlementgrid2').datagrid({
		    	rownumbers:true,
//		    	singleSelect:true,
				fitColumns:true,
				maximized:true,
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    columns:[[
							{field:'subid',title:'主键',hidden:'true'}, 
							{field:'datatype',title:'数据类型',width:125,hidden:'true'},   
							{field:'taxcode',title:'税目',width:80, formatter:formattertaxcode},   
							{field:'taxpayerid',title:'计算机编码',width:110},   
							{field:'taxpayername',title:'纳税人名称',width:130},   
							{field:'taxmoney',title:'应缴金额',align:'right',width:100},   
							{field:'taxbegindate',title:'税款所属期起',width:100,formatter: formatter1}, 
							{field:'taxenddate',title:'税款所属期止',width:100,formatter: formatter1},
							{field:'taxstate',title:'状态',hidden:'true'}
		        ]],
			    onLoadSuccess:function(data){  
//					$(this).datagrid('selectRow',0);//自动选择第一行
			    }, 
			});
		    $('#detail_settlementgrid1').datagrid({
		    	rownumbers:true,
		    	singleSelect:true,
				fitColumns:true,
				maximized:true,
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    columns:[[
							{field:'paytaxid',title:'主键',hidden:'true'}, 
							{field:'taxbillno',title:'税票号',width:125,hidden:'true'},   
							{field:'taxcode',title:'税目',width:80, formatter:formattertaxcode},   
							{field:'taxpayerid',title:'计算机编码',width:110},   
							{field:'taxpayername',title:'纳税人名称',width:130},   
							{field:'taxamountactual',title:'已缴金额',align:'right',width:100},   
							{field:'taxbegindate',title:'税款所属期起',width:100,formatter: formatter1}, 
							{field:'taxenddate',title:'税款所属期止',width:100,formatter: formatter1},
//							{field:'taxmanagercode',title:'税收管理员',width:100, formatter:formattertaxempcode}, 
							{field:'clearlogid',title:'日志ID',hidden:'true'},
							{field:'taxstate',title:'状态',hidden:'true'}
		        ]],
			    onClickRow:detail_settlementgrid_query
			    ,
			    onLoadSuccess:function(data){  
			    	var querytype=$("input[name='detail_querytype']:checked").val();
					$(this).datagrid('selectRow',0);//自动选择第一行
					detail_settlementgrid_query(0,data.rows[0]);
			    }, 
			});
		    $('#detail_settlementgrid2').datagrid({
		    	rownumbers:true,
//		    	singleSelect:true,
				fitColumns:true,
				maximized:true,
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    columns:[[
							{field:'subid',title:'主键',hidden:'true'}, 
							{field:'datatype',title:'数据类型',width:125,hidden:'true'},   
							{field:'taxcode',title:'税目',width:80, formatter:formattertaxcode},   
							{field:'taxpayerid',title:'计算机编码',width:110},   
							{field:'taxpayername',title:'纳税人名称',width:130},   
							{field:'taxmoney',title:'应缴金额',align:'right',width:100},   
							{field:'taxbegindate',title:'税款所属期起',width:100,formatter: formatter1}, 
							{field:'taxenddate',title:'税款所属期止',width:100,formatter: formatter1},
							{field:'taxstate',title:'状态',hidden:'true'}
		        ]],
			    onLoadSuccess:function(data){  
//					$(this).datagrid('selectRow',0);//自动选择第一行
			    }, 
			});
		    $('#proc_settlementgrid1').datagrid({
		    	rownumbers:true,
		    	singleSelect:true,
				fitColumns:true,
				maximized:true,
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    columns:[[
							{field:'paytaxid',title:'主键',hidden:'true'}, 
							{field:'taxbillno',title:'税票号',width:125,hidden:'true'},   
							{field:'taxcode',title:'税目',width:80, formatter:formattertaxcode},   
							{field:'taxpayerid',title:'计算机编码',width:110},   
							{field:'taxpayername',title:'纳税人名称',width:130},   
							{field:'taxamountactual',title:'已缴金额',align:'right',width:100},   
							{field:'taxbegindate',title:'税款所属期起',width:100,formatter: formatter1}, 
							{field:'taxenddate',title:'税款所属期止',width:100,formatter: formatter1},
//							{field:'taxmanagercode',title:'税收管理员',width:100, formatter:formattertaxempcode}, 
							{field:'clearlogid',title:'日志ID',hidden:'true'},
							{field:'taxstate',title:'状态',hidden:'true'}
		        ]],
			    onClickRow:proc_settlementgrid_query
			    ,
			    onLoadSuccess:function(data){  
			    	var querytype=$("input[name='proc_querytype']:checked").val();
					if(querytype==3 && data.rows.length<=0){
						$('#proc_manualbutton1').linkbutton('disable'); 
						$('#proc_manualbutton2').linkbutton('disable');
						$.messager.confirm('提示', '已完成清缴,是否关闭当前窗口?', function(r){
							if (r){
								$('#proc_windows').window('close');
							}
						});
					}
					$(this).datagrid('selectRow',0);//自动选择第一行
					proc_settlementgrid_query(0,data.rows[0]);
					
			    }, 
			});
		    $('#proc_settlementgrid2').datagrid({
		    	rownumbers:true,
//		    	singleSelect:true,
				fitColumns:true,
				maximized:true,
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    columns:[[
							{field:'subid',title:'主键',hidden:'true'}, 
							{field:'datatype',title:'数据类型',width:125,hidden:'true'},   
							{field:'taxcode',title:'税目',width:80, formatter:formattertaxcode},   
							{field:'taxpayerid',title:'计算机编码',width:110},   
							{field:'taxpayername',title:'纳税人名称',width:130},   
							{field:'taxmoney',title:'应缴金额',align:'right',width:100},   
							{field:'taxbegindate',title:'税款所属期起',width:100,formatter: formatter1}, 
							{field:'taxenddate',title:'税款所属期止',width:100,formatter: formatter1},
							{field:'taxstate',title:'状态',hidden:'true'}
		        ]],
			    onLoadSuccess:function(data){  
//					$(this).datagrid('selectRow',0);//自动选择第一行
			    }, 
			});
		    
		    $.ajax({
				   type: "post",
					async:false,
				   url: "/ComboxService/getComboxs.do",
				   data: {codetablename:'COD_TAXEMPCODE'},
				   dataType: "json",
				   success: function(jsondata){
					   emplist= jsondata;
				   }
				});
		    $.ajax({
				   type: "post",
					async:false,
				   url: "/ComboxService/getComboxs.do",
				   data: {codetablename:'COD_TAXCODE'},
				   dataType: "json",
				   success: function(jsondata){
					   taxcodelist= jsondata;
				   }
				});
		    
		    $('#settlement_windows').window({onClose:function(){
		    		donext(0);
		    		querylog();
		    	}});
		    $('#settlement_windows').window('maximize');
	})
	
	function donext(index){
		var conInnerConWidth = $(".innerCon").width();
		var tabHeight = $(".tab a").height();
	    slide(conInnerConWidth, tabHeight, index);
	}
	
	function docheck(){
		//检查
		var rows=$('#levydatetype_table').datagrid("getSelected");
		var now=new Date();
		var year = $('#year_windows').combobox("getValue");
		var selectdate=$('#taxdate_show').combobox("getValue");
		
		if(rows.levydatetype!=4 && year>now.getFullYear()){
			$.messager.alert("提示","所属期年度不能大于当年");
			return;
		}else{
			if(rows.levydatetype==1){
				if(selectdate>(now.getMonth()+1)){
					$.messager.alert("提示","所属期年度不能大于当月");
					return;
				}
			}else if(rows.levydatetype==2){
				if(selectdate*3>(now.getMonth()+1)){
					$.messager.alert("提示","所属期年度不能大于当前季度");
					return;
				}
			}else if(rows.levydatetype==3){
				if(selectdate*6>(now.getMonth()+1)){
					$.messager.alert("提示","所属期年度不能大于当前时间");
					return;
				}
			}
		}
		/**/
		$.ajax({
			type: 'POST',
	        url: "/taxsettlementservice/docheck.do",
	        data: {
	        	levydatetype:rows.levydatetype,
	        	year:year,
	        	selectdate:selectdate},
	       	dataType: "json",
	        success: function (data) {
	        	if(typeof data !='object' ){
	        		$.messager.alert("提示",data);
	        		return;
	        	}
	        	if(data.length<=0){
	        		$.messager.alert("提示","无数据可以清缴!");
//	        		$('#check_next_button').linkbutton('disable');
	        	}
	        	else{
//	        		$('#check_next_button').linkbutton('enable');
	        		$('#check_table').datagrid("loadData",data);
	        		donext(1);
	        	}
	        }
	    });
		
	}
	
	function settlement(){
		
		var rows=$('#levydatetype_table').datagrid("getSelected");
		var year = $('#year_windows').combobox("getValue");
		var selectdate=$('#taxdate_show').combobox("getValue");
		$.ajax({
			type: 'POST',
	        url: "/taxsettlementservice/taxsettlement.do",
	        data: {
	        	levydatetype:rows.levydatetype,
	        	year:year,
	        	selectdate:selectdate},
	       	dataType: "json",
	        success: function (data) {
	        	if(typeof data !='object' ){
	        		$.messager.alert("提示",data);
	        		return;
	        	}
	        	if(data.length<=0){
	        		$.messager.alert("提示","清缴出差!");
//	        		$('#check_next_button').linkbutton('disable');
	        	}
	        	else{
//	        		$('#check_next_button').linkbutton('enable');
	        		$('#taxsettlement_table').datagrid("loadData",data);
	        		//比对差异为0 直接结束此功能
	        		querylog();
	        		donext(2);
	        	}
	        }
	    });
	}
	
	function doback(){
		var rows=$('#loginfo').datagrid("getSelected");
		if(undefined!=rows &&  null!=rows ){
			$.messager.confirm('提示', '是否确认要回退?', function(r){
				if (r){
					$.ajax({
						type: 'POST',
				        url: "/taxsettlementservice/doback.do",
				        data: {clearlogid:rows.clearlogid},
				       	dataType: "json",
				        success: function (data) {
				        		$.messager.alert("提示",data);
				        		querylog();
				        }
				    });
				}
			});
		}else{
			$.messager.alert("提示","请选择要回退的日志!");
		}
	}
	
	function dodeal(querytype){
		
		var rows=$('#taxsettlement_table').datagrid("getRows");
		var p = $('#settlementgrid1').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#settlementgrid1').datagrid('options');
		opts.url = '/taxsettlementservice/dodeal.do';
		
		var clearlogid=(undefined==rows||null==rows ||rows.length<=0 )?$('#loginfo').datagrid("getSelected").clearlogid:rows[0].clearlogid;
		$('#settlementgrid1').datagrid('load',{clearlogid:clearlogid,querytype:querytype}); 
		
		//比对欠税/税源差异
		if(querytype==1){
			$('#settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#settlementgrid2').datagrid('load',{paytaxid:'',querytype:1});
		}
		
		if(querytype==3){
			$('#manualbutton1').linkbutton('enable'); 
			$('#manualbutton2').linkbutton('enable');
			$('#manualbutton3').linkbutton('disable');
		}else if(querytype==2 || querytype==5){
			$('#manualbutton1').linkbutton('disable'); 
			$('#manualbutton2').linkbutton('disable');
			$('#manualbutton3').linkbutton('enable');
		}else{
			$('#manualbutton1').linkbutton('disable'); 
			$('#manualbutton2').linkbutton('disable');
			$('#manualbutton3').linkbutton('disable');
		}
		donext(3);
	}
	
	function settlementgrid_query(rowIndex, rowData){
		if(undefined==rowData || rowData==null){
			$('#settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			return;
		}
			
		var querytype=$("input[name='querytype']:checked").val();
//		alert(querytype);
		if(querytype!='1'){
//			alert(rowData);
	    	$('#settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#settlementgrid2').datagrid('load',{paytaxid:rowData.paytaxid,querytype:''}); 
		}
    }
	
	function detail_settlementgrid_query(rowIndex, rowData){
		if(undefined==rowData || rowData==null){
			$('#detail_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			return;
		}
		var querytype=$("input[name='detail_querytype']:checked").val();
//		alert(querytype);
		if(querytype!='1'){
//			alert(rowData);
	    	$('#detail_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#detail_settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#detail_settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#detail_settlementgrid2').datagrid('load',{paytaxid:rowData.paytaxid,querytype:''}); 
		}
    }
	
	function proc_settlementgrid_query(rowIndex, rowData){
		if(undefined==rowData || rowData==null){
			$('#proc_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			return;
		}
		var querytype=$("input[name='proc_querytype']:checked").val();
//		alert(querytype);
		if(querytype!='1'){
//			alert(rowData);
	    	$('#proc_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#proc_settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#proc_settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#proc_settlementgrid2').datagrid('load',{paytaxid:rowData.paytaxid,querytype:''}); 
		}
    }
	
	function manual(taxstate){
		var querytype=$("input[name='querytype']:checked").val();
		var rows=$('#settlementgrid1').datagrid("getSelected");
		var rows2=$('#settlementgrid2').datagrid("getSelections");
		if(undefined==rows ||  null==rows ){
			$.messager.alert("提示","请选择已税记录!");
			return;
		}
		if(rows2.length<=0){
			$.messager.alert("提示","请选择应纳税记录!");
			return;
		}
		var subid=new Array();
		for(var i=0;i<rows2.length;i++){
			subid.push(rows2[i].subid);
		}
		 
		//alert(subid);
		$.messager.confirm('提示', '是否确认人工'+(taxstate==2?'欠税':taxstate==3?'回退':'清缴')+'?', function(r){
			if (r){
				$.ajax({
					type: 'POST',
			        url: "/taxsettlementservice/manual.do",
			        data: {taxstate:taxstate,paytaxid:rows.paytaxid,subid:subid.toString()},
			       	dataType: "json",
			        success: function (data) {
			        		$.messager.alert("提示",data);
			        		dodeal(querytype);
			        }
			    });
			}
		});
	}
	function proc_manual(taxstate){
		var querytype=$("input[name='proc_querytype']:checked").val();
		var rows=$('#proc_settlementgrid1').datagrid("getSelected");
		var rows2=$('#proc_settlementgrid2').datagrid("getSelections");
		if(undefined==rows ||  null==rows ){
			$.messager.alert("提示","请选择已税记录!");
			return;
		}
		if(rows2.length<=0){
			$.messager.alert("提示","请选择应纳税记录!");
			return;
		}
		var subid=new Array();
		for(var i=0;i<rows2.length;i++){
			subid.push(rows2[i].subid);
		}
		 
		//alert(subid);
		$.messager.confirm('提示', '是否确认人工'+(taxstate==2?'欠税':taxstate==3?'回退':'清缴')+'?', function(r){
			if (r){
				$.ajax({
					type: 'POST',
			        url: "/taxsettlementservice/manual.do",
			        data: {taxstate:taxstate,paytaxid:rows.paytaxid,subid:subid.toString()},
			       	dataType: "json",
			        success: function (data) {
			        		$.messager.alert("提示",data);
			        		proc_dodeal(querytype);
			        }
			    });
			}
		});
	}
	
	function detail_dodeal(querytype){
		
		var p = $('#detail_settlementgrid1').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#detail_settlementgrid1').datagrid('options');
		opts.url = '/taxsettlementservice/dodeal.do';
		
		var clearlogid=$('#loginfo').datagrid("getSelected").clearlogid;
		$('#detail_settlementgrid1').datagrid('load',{clearlogid:clearlogid,querytype:querytype}); 
		
		//比对欠税/税源差异
		if(querytype==1){
			$('#detail_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#detail_settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#detail_settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#detail_settlementgrid2').datagrid('load',{paytaxid:'',querytype:1});
		}
		
	}
	function proc_dodeal(querytype){
		
		var p = $('#proc_settlementgrid1').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#proc_settlementgrid1').datagrid('options');
		opts.url = '/taxsettlementservice/dodeal.do';
		
		var clearlogid=$('#loginfo').datagrid("getSelected").clearlogid;
		$('#proc_settlementgrid1').datagrid('load',{clearlogid:clearlogid,querytype:querytype}); 
		
		//比对欠税/税源差异
		if(querytype==1){
			$('#proc_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#proc_settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#proc_settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#proc_settlementgrid2').datagrid('load',{paytaxid:'',querytype:1});
		}
		
		if(querytype==3){
			$('#proc_manualbutton1').linkbutton('enable'); 
			$('#proc_manualbutton2').linkbutton('enable');
			$('#proc_manualbutton3').linkbutton('disable');
		}else if(querytype==2 || querytype==5){
			$('#proc_manualbutton1').linkbutton('disable'); 
			$('#proc_manualbutton2').linkbutton('disable');
			$('#proc_manualbutton3').linkbutton('enable');
		}else{
			$('#proc_manualbutton1').linkbutton('disable'); 
			$('#proc_manualbutton2').linkbutton('disable');
			$('#proc_manualbutton3').linkbutton('disable');
		}
	}
	function detail(){
		var rows=$('#loginfo').datagrid("getSelected");
		if(undefined!=rows &&  null!=rows ){
			$('#detail_windows').window('open');
			detail_dodeal(3);
		}else{
			$.messager.alert("提示","请选择要查看的日志!");
		}
	}
	function doproc(){
		var rows=$('#loginfo').datagrid("getSelected");
		if(undefined!=rows &&  null!=rows ){
			$('#proc_windows').window('open');
			proc_dodeal(3);
		}else{
			$.messager.alert("提示","请选择要处理的日志!");
		}
		
	}
</script>
</head>

<body class="easyui-layout" onload="ready();">  
    <div data-options="region:'west',title:'',split:true" style="width:185px;">
    	<table id="levydatetype_table"  style="width:175px;">  
		</table> 
    </div>  
    <div data-options="region:'center',title:''" style="padding:5px;">
			<div style="text-align:left;padding:5px;">  
					<div style="background-color: #c9c692;height: 25px;">		
			<!--  				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="querylog()" >查询日志</a>
			-->				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="taxsettlement()" >新增清缴</a>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="doback()" >回退</a>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-viewdetail'" onclick="detail()" >明细</a>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_flag_red'" onclick="doproc()" >差异处理</a>
					</div>
			</div>
			<div >
			<table id="loginfo" title="匹配日志"  >  
			</table>  
			</div>
			
			<div id="settlement_windows" class="easyui-window" data-options="closed:true,modal:true,title:'清缴',collapsible:false,minimizable:false,maximizable:false,closable:true">
					<div class="general feature_tour">
					<div class="wrapper">
					<div class="tab">
						<a id="step1" href="#" class="current">选择所属请</a>
						<a id="step2" href="#">数据检查</a>
						<a id="step3" href="#">自动清缴</a>
						<a id="step4" href="#">差异处理</a>
						
					</div>
					<div class="mask">
					    <div class="maskCon">
					    
					        <div id="con1" class="innerCon">
					        	<table  width="100%"  cellpadding="10" cellspacing="0">
								<tr>
									<td align="right">征期类型:</td>
									<td>
										<input id="levydatetype_show"  type="text" readOnly="true" ></input>					
									</td>
									
								</tr>
								<tr id="con1_year">
									<td align="right">年度：</td>
									<td>
										<select id="year_windows" class="easyui-combobox" name="year_windows" style="width:160px;"/>
									</td>
								</tr>
								<tr id="con1_date">
									<td align="right">所属期：</td>
									<td>
										<select id="taxdate_show" class="easyui-combobox" name="taxdate_show" style="width:160px;"/>
									</td>
								</tr>
								<tr>
									<td >
									</td>
								</tr>
								</table>
								<div style="text-align:center;padding:5px;" >  	
									<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_right'" onclick="docheck()" >下一步</a>
								</div>
							</div>
					        
					        <div id="con2" class="innerCon">
					        	<table id="check_table"  cellpadding="10" cellspacing="0" class="easyui-datagrid" data-options="title:'检查',singleSelect:true,fitColumns:true">
								<thead>
									<tr>
										<th></th>
										<th colspan="2">应纳税汇总</th>
										<th colspan="2">纳税汇总</th>
									</tr>
									<tr>
										<th data-options="field:'taxname',width:150">税目</th>
										<th data-options="field:'taxcode',hidden:true">税目代码</th>
										<th data-options="field:'num',width:100,align:'center'">应纳税户数</th>
										<th data-options="field:'taxamountactual',width:120,align:'right'">应纳税金额</th>
										<th data-options="field:'num1',width:100,align:'center'">纳税户数</th>
										<th data-options="field:'taxamountactual1',width:120,align:'right'">纳税金额</th>
									</tr>
								</thead>
								</table>
								<div style="text-align:center;padding:5px;" >  	
						        	<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_left'" onclick="donext(0)" >上一步</a>
						        	<a id="check_next_button" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_right'" onclick="settlement()" >下一步</a>
					        	</div>
					        </div>
					        
					        <div id="con3" class="innerCon">
					        	<table id="taxsettlement_table" width="100%"  cellpadding="10" cellspacing="0" class="easyui-datagrid" data-options="title:'清缴结果',singleSelect:true,fitColumns:true">
								<thead>
									<tr>
										<th data-options="field:'clearlogid',width:80,hidden:'true'">清缴id</th>
										<th data-options="field:'type',width:80,align:'left'">类型</th>
										<th data-options="field:'num',width:300,align:'center'">户数</th>
										<th data-options="field:'taxamountactual',width:100,align:'right'">金额</th>
									</tr>
								</thead>
								</table>
					        	<div style="text-align:center;padding:5px;" > 
						 			<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_left'" onclick="donext(1)" >上一步</a>
						        	<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_right'" onclick="dodeal(3)" >下一步</a>
					        	</div> 
					        </div>
					        
					        <div id="con4" class="innerCon">
					        		<div style="text-align:left;">  
											<div style="background-color: #c9c692;height: 25px;">		
													<span style="font-size: 12px; color:red; font-weight: bold;">过滤条件：</span>
													<span style="font-size: 12px;"><input type="radio" checked="checked" name="querytype" value="3" onclick="dodeal(3)"/>比对差异</span>&nbsp;
													<span style="font-size: 12px;"><input type="radio"  name="querytype" value="1" onclick="dodeal(1)"/>比对欠税/税源差异</span>&nbsp;
													<span style="font-size: 12px;"><input type="radio"  name="querytype" value="4" onclick="dodeal(4)"/>比对清缴</span>&nbsp;
													<span style="font-size: 12px;"><input type="radio"  name="querytype" value="2" onclick="dodeal(2)"/>人工确认欠税</span>&nbsp;
													<span style="font-size: 12px;"><input type="radio"  name="querytype" value="5" onclick="dodeal(5)"/>人工确认清缴</span>&nbsp;
											</div>
									</div>
					        		<div style="width:950px;height:200px">
										<table id="settlementgrid1" title='已纳税' style="width:950px;height:200px"></table>
									</div>
									<div style="width:950px;height:200px">
										<table id="settlementgrid2" title='应纳税' style="width:950px;height:200px"></table>
									</div>
									<div style="text-align:center;padding:5px;" > 
										<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_left'" onclick="donext(2)" >上一步</a>
										<a id="manualbutton1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_flag_red'" onclick="manual(2)" >人工确认欠税</a>
										<a id="manualbutton2"  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="manual(5)" >人工确认清缴</a>
										<a id="manualbutton3" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="manual(3)" >回退</a>
										<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#settlement_windows').window('close');" >关闭</a>
					        		</div> 
					        </div>
					        
					    </div>
					</div>
				</div>
				</div>
					        		
			</div>
			
			<div id="detail_windows" class="easyui-window" style="width:965px;height:500px"
			 data-options="closed:true,modal:true,title:'明细',collapsible:false,minimizable:false,maximizable:false,closable:true">
				<div style="text-align:left;">  
						<div style="background-color: #c9c692;height: 25px;">		
								<span style="font-size: 12px; color:red; font-weight: bold;">过滤条件：</span>
								<span style="font-size: 12px;"><input type="radio" checked="checked" name="detail_querytype" value="3" onclick="detail_dodeal(3)"/>比对差异</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="detail_querytype" value="1" onclick="detail_dodeal(1)"/>比对欠税/税源差异</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="detail_querytype" value="4" onclick="detail_dodeal(4)"/>比对清缴</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="detail_querytype" value="2" onclick="detail_dodeal(2)"/>人工确认欠税</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="detail_querytype" value="5" onclick="detail_dodeal(5)"/>人工确认清缴</span>&nbsp;
						</div>
				</div>
		      		<div style="width:950px;height:200px">
					<table id="detail_settlementgrid1" title='已纳税' style="width:950px;height:200px"></table>
				</div>
				<div style="width:950px;height:200px">
					<table id="detail_settlementgrid2" title='应纳税' style="width:950px;height:200px"></table>
				</div>
				<div style="text-align:center;padding:5px;" > 
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#detail_windows').window('close');" >关闭</a>
		      	</div> 
	      	</div>
	      	
	      	<div id="proc_windows"  class="easyui-window" style="width:965px;height:500px"
			 data-options="closed:true,modal:true,title:'差异处理',collapsible:false,minimizable:false,maximizable:false,closable:true,onClose:function(){querylog();}">
        		<div style="text-align:left;">  
						<div style="background-color: #c9c692;height: 25px;">		
								<span style="font-size: 12px; color:red; font-weight: bold;">过滤条件：</span>
								<span style="font-size: 12px;"><input type="radio" checked="checked" name="proc_querytype" value="3" onclick="proc_dodeal(3)"/>比对差异</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="proc_querytype" value="1" onclick="proc_dodeal(1)"/>比对欠税/税源差异</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="proc_querytype" value="4" onclick="proc_dodeal(4)"/>比对清缴</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="proc_querytype" value="2" onclick="proc_dodeal(2)"/>人工确认欠税</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="proc_querytype" value="5" onclick="proc_dodeal(5)"/>人工确认清缴</span>&nbsp;
						</div>
				</div>
        		<div style="width:950px;height:200px">
					<table id="proc_settlementgrid1" title='已纳税' style="width:950px;height:200px"></table>
				</div>
				<div style="width:950px;height:200px">
					<table id="proc_settlementgrid2" title='应纳税' style="width:950px;height:200px"></table>
				</div>
				<div style="text-align:center;padding:5px;" > 
					<a id="proc_manualbutton1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_flag_red'" onclick="proc_manual(2)" >人工确认欠税</a>
					<a id="proc_manualbutton2"  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="proc_manual(5)" >人工确认清缴</a>
					<a id="proc_manualbutton3" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="proc_manual(3)" >回退</a>
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#proc_windows').window('close');" >关闭</a>
        		</div> 
        </div>
    </div>  
</body> 
</html>