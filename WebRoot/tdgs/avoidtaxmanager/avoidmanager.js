
var AvoidManager = {
	loadPage:function(){
	    var managerLink = new OrgLink();
	    managerLink.sendMethod = false;
	    managerLink.loadData();
	    
	    CommonUtils.getCacheCodeFromTable("COD_DERATETYPECODE","deratetypecode","deratetypename","#reduceclass");
	    CommonUtils.getCurrentOrgInfo('approveunit');
	    $('#avoidtaxgrid').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			rowStyler:settings.rowStyle,
			pageList:[15]
		});
		var p = $('#avoidtaxgrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
		/* 
		   var firstDay = DateUtils.getYearFirstDay();
			var lastDay = DateUtils.getCurrentDay();
		     $('#begindate').datebox('setValue',firstDay);
		     $('#enddate').datebox('setValue',lastDay);
		     */
	},
	queryAvoidTax:function(taxtypecode){
		    var params = {};
			var fields =$('#avoidtaxqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			if(taxtypecode)
			   params['taxtypecode'] = taxtypecode;
			params['pagesize'] = 15;
		   var opts = $('#avoidtaxgrid').datagrid('options');
		   opts.url = '/avoidtaxmanager/allavoidtax.do?d='+new Date();
		   $('#avoidtaxgrid').datagrid('load',params); 
		   $('#avoidtaxquerywindow').window('close');
	},
	queryAvoidtaxinfosub: function (taxtypecode){
		     var params = {};
		    var estateid =document.getElementById('estateid').value;
		    if(estateid==null || estateid==""){
		    	return;
		    }
			if(taxtypecode)
			   params['taxtypecode'] = taxtypecode;
			params['estateid'] = estateid;
			params['pagesize'] = 5;
		   var opts = $('#avoidtaxgridsub').datagrid('options');
		   opts.url = '/avoidtaxmanager/allavoidtax.do?d='+new Date();
		   $('#avoidtaxgridsub').datagrid('load',params); 
		}
	,
	deleteAvoidTax:function(){
		var row = $('#avoidtaxgrid').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要删除的减免税记录!','info');
				 return;
			}
			else{
				$.messager.confirm('删除此减免税','确认删除此减免税记录吗？',function(r){   
				    if(r){   
				    	var reduceid = row.taxreduceid;
						var state = row.state;
						 $.ajax({
							  type: "get",
							  async:false,
							  cache:false,
							  url: "/avoidtaxmanager/deleteavoidtax.do?d="+new Date(),
							  data: {"taxreduceid":reduceid},
							  dataType: "json",
							  success:function(jsondata){
								  if(jsondata.sucess){
									  $.messager.alert('提示消息','删除减免税记录成功!','info',function(){
										  query();
									  });
								  }else{
									  $.messager.alert('提示消息',jsondata.message,'info');
								  }
							  }
					   });
				    }   
				});  
				
			}
	},
	deleteAvoidTaxInfo:function(){
		var row = $('#avoidtaxgridsub').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要删除的减免税记录!','info');
				 return;
			}
			else{
				$.messager.confirm('删除此减免税','确认删除此减免税记录吗？',function(r){   
				    if(r){   
				    	var reduceid = row.taxreduceid;
						var state = row.state;
						 $.ajax({
							  type: "get",
							  async:false,
							  cache:false,
							  url: "/avoidtaxmanager/deleteavoidtax.do?d="+new Date(),
							  data: {"taxreduceid":reduceid},
							  dataType: "json",
							  success:function(jsondata){
								  if(jsondata.sucess){
									  $.messager.alert('提示消息','删除减免税记录成功!','info',function(){
										  queryInfo();
									  });
								  }else{
									  $.messager.alert('提示消息',jsondata.message,'info');
								  }
							  }
					   });
				    }   
				});  
				
			}
	}
}