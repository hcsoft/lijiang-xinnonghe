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
     
    
    var bustype = '65';
    
    var saveurl;
	var saveparams;
	var saveinfomessage;
	var currenthouseid;
    
    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
    
	$(function(){
		
		   var managerLink = new OrgLink();
	       managerLink.sendMethod = false;
	       managerLink.loadData();
		   var firstDay = DateUtils.getYearFirstDay();
		   var lastDay = DateUtils.getCurrentDay();
		   $('#usedatebegin').datebox('setValue',firstDay);
		   $('#usedateend').datebox('setValue',lastDay);
		   //530122
		   
		    CommonUtils.getCacheCodeFromTable('COD_HOUSEUSECODE','houseusecode',
			                                 'houseusename','#purpose',"");
		   
		   $('#houserecovergrid').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			rowStyler:settings.rowStyle,
			pageList:[15],
			onDblClickRow:function(){openUpdate(false);},
			onClickRow:function(rowIndex, rowData){
				if(rowData.state == '1'){
					$('#finalcheck_button').linkbutton('enable'); 
					$('#unfinalcheck_button').linkbutton('disable'); 
				}else if(rowData.state == '3'){
					$('#finalcheck_button').linkbutton('disable'); 
					$('#unfinalcheck_button').linkbutton('enable'); 
				}else{
					$('#finalcheck_button').linkbutton('disable'); 
					$('#unfinalcheck_button').linkbutton('disable'); 
				}
			}
		   });
		   var p = $('#houserecovergrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
			$('#houserecoverinfoform #businesstype').val(bustype);
			$('#houserecoverinfoform #businesscode').val(bustype);
			
			$('#houserecoverqueryform #businesstype').val(bustype);
			$('#houserecoverqueryform #businesscode').val(bustype);
			
			$('#modeladdinfo').linkbutton({   
			    text: "房产收回"  
			});
			$('#houserecoverquerywindow').window({
				title:"房产收回"+'查询条件'
			});
			
			$('#query_taxpayerid,#query_taxpayername').bind('keydown',function(event) {  
		          if(event.keyCode==13){  
		        	  chooseTaxpayer();  
		        }  
	         }); 
			
		
			
			$('#datagrid_house').datagrid({
				view:$.extend({},$.fn.datagrid.defaults.view,{
					onAfterRender: function(target){
										if(currenthouseid){
											for(var i = 0;i < $('#datagrid_house').datagrid('getData').rows.length;i++){
												 if( $('#datagrid_house').datagrid('getData').rows[i].houseid==currenthouseid){
													 $('#datagrid_house').datagrid('selectRow',i);	
												 }
											}
										}
									} 
				}),
				fitColumns:false,
				maximized:'true',
				pagination:true,
				rowStyler:settings.rowStyle,
				pageList:[15]
			});
			var p = $('#datagrid_house').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
			$('#datagrid_housetrans').datagrid({
				toolbar: '#datagrid_house_toolbar',
				onDblClickRow:function(){openUpdate(true);},
				fitColumns:false,
				maximized:'true',
				pagination:true,
				title:"房产收回"+"信息",
				rowStyler:settings.rowStyle,
				pageList:[15]
			});
			var p = $('#datagrid_housetrans').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
			$('#landinfogrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				rowStyler:settings.rowStyle,
				pageList:[15]
			});
			var p = $('#landinfogrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
			
	    });
	    function dbclickevent(rowindex,rowdata){
	    	detailoper(rowindex,rowdata,false)
	    }
	    function detailoper(rowindex,rowdata,hideoperbtn,flag){
	    		   inputreset();
				   $.ajax({
					  type: "post",
					  async:true,
					  cache:false,
					  url: "/houserecover/get.do?d="+new Date(),
					  data: {'key':rowdata.busid,'businesstype':bustype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  var bushousebo = jsondata.result;
							  var basehousebo = bushousebo.baseHouse;
							  for(var p in bushousebo){
								   var value = bushousebo[p];
								   if(p.indexOf('date') >=0){
									   value = formatterDate(value);
								   }
								   var input = $('#houserecoverinfoform #'+p);
								   if(!input)
									   continue;
								   if(input.hasClass("easyui-validatebox")){
										input.val(value);
								   }else if(input.hasClass("easyui-numberbox")){
									    input.numberbox('setValue',value);
								   }
								   else if(input.hasClass("easyui-datebox")){
										input.datebox('setValue',new Date(value).format("yyyy-MM-dd"));
								   }
								   else if(input.hasClass("easyui-combobox")){
										input.combobox('setValue',value);
								   }else{
									   input.val(value);
								   }
							  }
							    currenthouseid=bushousebo.houseid;
							    
							  
							    basehousebo['lessorid'] = basehousebo['taxpayerid'];
							    basehousebo['lessortaxpayername'] = basehousebo['taxpayername'];
							    basehousebo['housearea_s'] = basehousebo['housearea'];
							    basehousebo['usedate_s'] = basehousebo['usedate'];
							    
							    $('#query_taxpayerid').val(bushousebo.lessorid);
							    $('#query_taxpayername').val(bushousebo.lessortaxpayername);
							    
							    $('#houserecoverinfoform input[data-select="s"]').each(function(){
							    	var id = this.id;
							    	if(id){
							    		if(id in basehousebo){
							    			var value = basehousebo[id];
							    			if(id.indexOf('date') >= 0){
							    				value = formatterDate(value);
							    			}
							    			$(this).val(value);
							    		}
							    	}
							    });
							    housequery(bushousebo.houseid);
							    if(!flag){
							    	housetransferquery();
							    }
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
								  
							  });
						  }
					  }
			      });
				   if(hideoperbtn) {
					 $('#ownerOperDiv').hide();  
					 $('#selectlandtb').hide();
					 $('#houserecoveraddwindow').window({title:"房产收回"+'信息查看'});
				     $('#houserecoveraddwindow').window('open');
				   } 
				   else {
					 $('#ownerOperDiv').show();
					 $('#selectlandtb').show();
					 $('#houserecoveraddwindow').window({title:"房产收回"+'信息修改'});
				     $('#houserecoveraddwindow').window('open');
				   }
				   
				   
	    }
		function query(){
			var params = {};
			var fields =$('#houserecoverqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['pagesize'] = 15;
		    var opts = $('#houserecovergrid').datagrid('options');
		    opts.url = '/houserecover/select.do?d='+new Date();
		    $('#houserecovergrid').datagrid('load',params); 
		    $('#houserecoverquerywindow').window('close');
		}
		function openQuery(){
			$('#houserecoverquerywindow').window('open');
		}
        //TODO 新增进度条的功能   日期选择  没有事件
		//新增房产所有权转移开始。。。。。 
		function openHouseCoverAdd(){
			inputreset();
			$('#datagrid_house').datagrid('loadData',{total:0,rows:[]});
			$('#query_taxpayerid').val('');
			$('#query_taxpayername').val('');
			saveurl=null;
			saveparams=null;
			saveinfomessage=null;
			currenthouseid=null;
			$('#houserecoverinfoform #businesstype').val(bustype);
			$('#houserecoverinfoform #businesscode').val(bustype);
			$('#ownerOperDiv').show();
			$('#selectlandtb').show();
			$('#houserecoveraddwindow').window({title:"房产收回"+'信息增加'});
			$('#houserecoveraddwindow').window('open');
		}
		function chooseHouseInfo(){
			WidgetUtils.showChooseBaseHouseInfo(function(rowIndex,rowData){
				   if(rowData){
					    rowData['lessorid'] = rowData['taxpayerid'];
					    rowData['lessortaxpayername'] = rowData['taxpayername'];
					    rowData['housearea_s'] = rowData['housearea'];
					    rowData['usedate_s'] = rowData['usedate'];
					    $('#houserecoverinfoform input[data-select="s"]').each(function(){
					    	var id = this.id;
					    	if(id){
					    		if(id in rowData){
					    			var value = rowData[id];
					    			if(id.indexOf('date') >= 0){
					    				value = formatterDate(value);
					    			}
					    			$(this).val(value);
					    		}
					    	}
					    });
			      }
			},{
			    ownflag:'1',
			    state:'1',
			    valid:'1'
			});
		}
		function chooseLand(){
			WidgetUtils.showChooseBaseEstate(function(rowIndex,rowData){
				$('#landinfogrid').datagrid('appendRow',rowData);
			});
		}
		function deleteChoosedLand(){
			var row = $('#landinfogrid').datagrid('getSelected');
			if(row == null)
				return;
			var rowIndex = $('#landinfogrid').datagrid('getRowIndex',row);
			$('#landinfogrid').datagrid('deleteRow',rowIndex);
		}
		function chooseTaxpayer(){
			var taxpayerid=$('#query_taxpayerid').val();
			var taxpayername=$('#query_taxpayername').val();
				
			$.ajax({
				  type: "post",
				  async:true,
				  cache:false,
				  url: '/housecontrol/selecttaxpayer.do?d='+new Date()+"&pagesize=15",
				  data: {"taxpayerid":taxpayerid,"taxpayername":taxpayername},
				  dataType: "json",
				  success:function(jsondata){
					  var taxpayerlist = jsondata.rows;
					  if(taxpayerlist.length==0){
						  $.messager.alert('消息','查无记录！');
					  }
					  else if(taxpayerlist.length==1){
							$('#query_taxpayerid').val(taxpayerlist[0].taxpayerid);
							$('#query_taxpayername').val(taxpayerlist[0].taxpayername);
							housequery();
							housetransferquery();
					  }else{
						  WidgetUtils.showChooseTaxpayerInfo(function(rowIndex,rowData){
								$('#query_taxpayerid').val(rowData.taxpayerid);
								$('#query_taxpayername').val(rowData.taxpayername);
								housequery();
								housetransferquery();
							});
					  }
				  }
		   });
		}
		function inputreset(){
//			$('#houserecoverinfoform').form('clear');
//			$('#houserecoverinfoform input').val('');
			$('#houserecoverinfoform')[0].reset();
			$("input[name='housearea']").val('0.00');
			$("input[name='houseamount']").val('0.00');
			$("input[name='houseamount']").val('0.00');
			$("input[name='transmoney']").val('0.00');
		}
		function validateFormData(){
			var inputAry = $('#houserecoverinfoform input[data-validate="p"]');
			result = CommonUtils.validateForm(inputAry);
			if(!result){
				return false;
			}
			return true;
		}
		function saveOwnerHouse(){
			var result = validateFormData();
			if(!result)
				return false;
			var params = {};
			var fields =$('#houserecoverinfoform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});	
			
			if($('#housearea').val()=='0.00'){
				$.messager.alert('警告','收回建筑面积必须大于0');
				return false;
			}
		    
		    if($('#usedate').datebox('getValue')==''){
				$.messager.alert('警告','实际收回日期不能为空！');
				return false;
			}
			
			var houserows = $('#datagrid_house').datagrid('getSelected');
			if(!houserows){
				$.messager.alert('警告','请选择房产!');
				return false;
			}
			params['businesstype']=bustype;
			params['lessorid'] = $('#query_taxpayerid').val();
			params['lessortaxpayername'] = $('#query_taxpayername').val();
			params['houseid'] = houserows.houseid;
			
			var busid = $('#houserecoverinfoform #busid').val();
			var operurl = "/houserecover/add.do?d="+new Date();
			var infomessage = '新增'+"房产收回"+'信息成功';
			if(busid){
				operurl = "/houserecover/update.do?d="+new Date();
				infomessage = '修改'+"房产收回"+'信息成功';
			}
			saveurl=operurl;
			saveparams=params;
			saveinfomessage=infomessage;
			
			
			landquery();
			$('#landinfowindow').window('open');
			
		}
		function dosave(){
			var rows = $('#landinfogrid').datagrid('getSelections');
			if(undefined==rows ||  null==rows ){
				$.messager.alert('警告','新增房产必须选择所关联的土地','info',function(){
				});
				return false;
			}
			if(rows.length > 0){
                 var estateids = '';
				 for(var i = 0;i < rows.length;i++){
						var row = rows[i];
						estateids += row.estateid+',';
				 }
				 if(estateids)   estateids = estateids.substr(0,estateids.length-1);
				 saveparams['estateids'] = estateids;
			}
			$.ajax({
				  type: "post",
				  async:true,
				  cache:false,
				  url: saveurl,
				  data: saveparams,
				  dataType: "json",
				  success:function(jsondata){
					   if(jsondata.sucess){
						  $.messager.alert('提示消息',saveinfomessage,'info');
						  if($('#houserecoverinfoform #busid').val()){
//							  chooseTaxpayer();
//							  inputreset();
						  }else{
							  housequery();
							  housetransferquery();
						  }
						  query();
					  }else{
						  $.messager.alert('错误',jsondata.message,'error');
					  }
					  $('#landinfowindow').window('close');
					  $('#landinfogrid').datagrid('loadData',{total:0,rows:[]});
				  }
		   });
		}
		//新增自建房结束
		
       //修改房产开始
       function openUpdate(flag){
    	   if(flag){
    		   row = $('#datagrid_housetrans').datagrid('getSelected');
    	   }else{
    		   row = $('#houserecovergrid').datagrid('getSelected');
    	   }
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要修改的'+"房产收回"+'信息!','info');
    		   return false;
    	   }
    	   if(row.state == '0'){
    		   detailoper(null,row,false,flag);
    	   }else{
    		   $.messager.alert('提示消息','只有状态为未审核的'+"房产收回"+'信息才能修改!','info');
    	   }
       }
	
	  
       function cancelHouse(flag){
    	   var row = null;
    	   if(flag){
    		   row = $('#datagrid_housetrans').datagrid('getSelected');
    	   }else{
    		   row = $('#houserecovergrid').datagrid('getSelected');
    	   }
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要删除的'+"房产收回"+'信息!','info');
    		   return false;
    	   }
    	   if(row.state != '0'){
    		   $.messager.alert('提示消息','只有状态为未审核的'+"房产收回"+'信息才能删除!','info');
    		   return false;
    	   }
    	   var url = "/houserecover/cancel.do?d="+new Date();
    	   
    	   $.messager.confirm('确认', '你确认删除当前的'+"房产收回"+'信息？', function(r){
				if (r){
					$.ajax({
					  type: "post",
					  async:true,
					  cache:false,
					  url: url,
					  data: {'key':row.busid,"businesstype":bustype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $('#datagrid_house').datagrid('clearSelections');
							  currenthouseid=null;
							  $.messager.alert('提示消息','删除'+"房产收回"+'信息成功','info',function(){
								  if(flag){
									  housetransferquery();
									  housequery();
								  }
								  query();
								  inputreset();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			        });
				}
			});
       }
       function checkHouse(checktype){
    	   var checkmsg = "";
    	   var confirmmsg = "";
    	   var url = "";
    	   if(checktype == '1'){
    		   checkmsg = '请选择需要审核的'+"房产收回"+'信息!';
    		   confirmmsg = "你确认审核当前的"+"房产收回"+"信息？";
    		   url = "/houserecover/check.do?d="+new Date();
    	   }else{
    		   checkmsg = '请选择需要取消审核的'+"房产收回"+'信息!';
    		   confirmmsg = "你确认取消审核当前的"+"房产收回"+"信息？";
    		   url = "/houserecover/uncheck.do?d="+new Date();
    	   }
    	   var row = $('#houserecovergrid').datagrid('getSelected');
    	   if(row == null){
    		   $.messager.alert('提示消息',checkmsg,'info');
    		   return false;
    	   }
    	   $.messager.confirm('确认', confirmmsg, function(r){
				if (r){
					$.ajax({
					  type: "post",
					  processbar:true,
					  async:true,
					  cache:false,
					  url: url,
					  data: {'key':row.busid,"businesstype":bustype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息',jsondata.message,'info',function(){
								  query();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			        });
				}
			});
       }
		function exportExcel(){
			var params = {};
			var fields =$('#houserecoverqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['propNames'] = 'statename,lessorid,lessortaxpayername,lesseesid,lesseestaxpayername,housearea,houseamount,usedate,purpose,protocolnumber';
			params['colNames'] = '状态,转出计算机编码,转出纳税人名称,转入计算机编码,转入纳税人名称,转移房产建筑面积,'+
                                 '转移总价,房产转移日期,房产用途,转移协议号';
			params['modelName']="房产收回";
			
			CommonUtils.downloadFile("/houserecover/houserecoverexport.do?date="+new Date(),params);
		}
		
		function landquery(){
			var params = {};
			params.taxpayerid = $('#query_taxpayerid').val();
			var opts = $('#landinfogrid').datagrid('options');
			opts.url = '/landavoidtaxmanager/selectland.do?d='+new Date()+"&pagesize=15";
			$('#landinfogrid').datagrid('load',params); 
		}
		
		function housequery(houseid){
			var params = {};
			params.taxpayerid = $('#query_taxpayerid').val();
			params.state="1";
			if(houseid)
				params.bushouseid=houseid;
			params.ownflag=1;
			var opts = $('#datagrid_house').datagrid('options');
			opts.url = '/housecontrol/selecthouseinfo.do?d='+new Date()+"&pagesize=15";
			$('#datagrid_house').datagrid('load',params); 
			
		}
		
		function housetransferquery(){
			var params = {};
			params.lessorid = $('#query_taxpayerid').val();
			params.businesstype=bustype;
			var opts = $('#datagrid_housetrans').datagrid('options');
			opts.url = '/houserecover/select.do?d='+new Date()+"&pagesize=15";
			$('#datagrid_housetrans').datagrid('load',params); 
			
		}
		
		function finalcheck(checktype){
	    	   var checkmsg = "";
	    	   var confirmmsg = "";
	    	   var url = "";
	    	   if(checktype == '1'){
	    		   checkmsg = '请选择需要终审的'+"房产收回"+'信息!';
	    		   confirmmsg = "你确认终审当前的"+"房产收回"+"信息？";
		   		   url = "/houserecover/finalcheck.do?d="+new Date();
	    	   }else{
	    		   checkmsg = '请选择需要取消终审的'+"房产收回"+'信息!';
	    		   confirmmsg = "你确认取消终审当前的"+"房产收回"+"信息？";
	    		   url = "/houserecover/unfinalcheck.do?d="+new Date();
	    	   }
	    	   var row = $('#houserecovergrid').datagrid('getSelected');
	    	   if(row == null){
	    		   $.messager.alert('提示消息',checkmsg,'info');
	    		   return false;
	    	   }
	    	   $.messager.confirm('确认', confirmmsg, function(r){
					if (r){
						$.ajax({
						  type: "post",
						  processbar:true,
						  async:true,
						  cache:false,
						  url: url,
						  data: {'key':row.busid,"businesstype":bustype},
						  dataType: "json",
						  success:function(jsondata){
							   if(jsondata.sucess){
								  $.messager.alert('提示消息',jsondata.message,'info',function(){
									  query();
								  });
							  }else{
								  $.messager.alert('错误',jsondata.message,'error',function(){
								  });
							  }
						  }
				        });
					}
				});
	       }
		
	</script>
</head>
<body>
     <div class="easyui-layout" style="width:100%;height:570px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='houserecovergrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
				        <th data-options="field:'busid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">业务主键</th>
						<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
						<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
						<th data-options="field:'houseid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">房产主键</th>
						<th data-options="field:'statename',width:80,align:'center',editor:{type:'validatebox'}">状态</th>
						<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
						<th data-options="field:'lessorid',width:100,align:'center',editor:{type:'validatebox'}">产权人计算机编码</th>
						<th data-options="field:'lessortaxpayername',width:220,align:'left',editor:{type:'validatebox'}">产权人名称</th>
						<th data-options="field:'housearea',width:120,align:'center',editor:{type:'validatebox'}">减少的房产建筑面积</th>
						<th data-options="field:'usedate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">实际收回日期</th>
						<th data-options="field:'remark',width:120,align:'center',editor:{type:'validatebox'}">收回原因</th>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a id="modeladdinfo" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openHouseCoverAdd()">所有权转移</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openUpdate()">修改</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="cancelHouse()">删除</a>
				<a href="#" id="finalcheck_button" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="finalcheck('1')">终审</a>
				<a href="#" id="unfinalcheck_button" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="finalcheck('0')">撤销终审</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportExcel()">导出</a>
				<a style="display: none;" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="checkHouse(1)">审核</a>
				<a style="display: none;" class="easyui-linkbutton" data-options="iconCls:'icon-uncheck',plain:true" onclick="checkHouse(0)">取消审核</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">退出</a>
			</div>
		</div>
	</div>
	<div id="houserecoveraddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产所有权转移登记',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:1050px;" data-close="autoclose">
	       <div class="easyui-layout" style="height:530px;">  
	        <div region="north" style="text-align:center;height: 35px;" align="center">  
				 <table align="center" >
				 <tr>
				    <td align="right">计算机编码：</td>
					<td>
						<input id="query_taxpayerid" class="easyui-validatebox" name="query_taxpayerid"  />			
					</td>
					<td align="right">纳税人名称：</td>
					<td>
						<input id="query_taxpayername" class="easyui-validatebox" name="query_taxpayername" data-validate="p"/>	
						<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseTaxpayer()" 
						   style="color: blue;font-weight: bold;">查询</a>				
					</td>
				</tr>
				</table>
		    </div>
		    <div region="center" id="housepanel" title="" data-options="selected:true" 
		    style="overflow:auto;padding:10px;">  
		       <form id="houserecoverinfoform" method="post">
		            <input type="hidden" id="businesstype" name="businesstype"/>
		            <input type="hidden" id="businesscode" name="businesscode"/>
		            <input type="hidden" id="busid" name="busid"/>
		             <input type="hidden" id="houseid" name="houseid" data-select="s"/>
				<table id="narjcxx1x" width="100%"  cellpadding="3" cellspacing="0">
					<tr >
						<td align="right">实际收回时间：</td>
						<td>
							<input id="usedate" class="easyui-datebox" name="usedate" />	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>				
						</td>
						<td align="right">收回转移建筑面积：</td>
						<td>
							<input class="easyui-numberbox"  id="housearea"  name="housearea" data-options="min:0,precision:2"  value="0.00"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>			
						</td>
					</tr>
					<tr id="tr_use">
						<td align="right">收回原因：</td>
						<td>
							<input class="easyui-validatebox" id="remark"  name="remark" />	
						</td>
						<td align="right"></td>
						<td>
						</td>
					</tr>
				</table>
				 <div style="text-align:center;padding:5px;height: 25px;" id="ownerOperDiv">  
					 <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveOwnerHouse()">保存</a>
					 <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="inputreset()">清除所有数据</a>
			    </div>
			    <div id="datagrid_house_toolbar" style="height:25px;display:none">
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openUpdate(true)">修改</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="cancelHouse(true)">删除</a>
				</div>
		    	<table id="datagrid_housetrans"  class="easyui-datagrid" style="overflow: scroll;"
						data-options="iconCls:'icon-viewdetail',singleSelect:true,pageList:[15],title:'房产转让信息'">
						<thead>
								<th data-options="checkbox:true"></th>
								<th data-options="field:'busid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">业务主键</th>
							    <th data-options="field:'houseid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">房产主键</th>
								<th data-options="field:'statename',width:80,align:'center',editor:{type:'validatebox'}">状态</th>
								<th data-options="field:'lessorid',width:100,align:'center',editor:{type:'validatebox'}">产权人计算机编码</th>
								<th data-options="field:'lessortaxpayername',width:150,align:'left',editor:{type:'validatebox'}">产权人名称</th>
								<th data-options="field:'housearea',width:120,align:'center',editor:{type:'validatebox'}">减少的房产建筑面积</th>
								<th data-options="field:'usedate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">实际收回日期</th>
								<th data-options="field:'remark',width:160,align:'center',editor:{type:'validatebox'}">收回原因</th>
						</thead>
				</table>
			</form>
		    </div>  
		    <div region="west" style="width:420px;" id="landpanel" title="" >  
				<table id="datagrid_house"  class="easyui-datagrid" style="width:418px;height:490px;overflow: scroll;"
						data-options="iconCls:'icon-viewdetail',singleSelect:true,pageList:[15]">
						<thead>
								<th data-options="checkbox:true"></th>
								<th data-options="field:'busid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">业务主键</th>
							    <th data-options="field:'houseid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">房产主键</th>
							    <th data-options="field:'housecertificate',width:120,align:'center',editor:{type:'validatebox'}">房产证号</th>
								<th data-options="field:'housearea',width:120,align:'center',editor:{type:'validatebox'}">房产建筑面积</th>
								<th data-options="field:'houseamount',width:150,align:'center',editor:{type:'validatebox'}">房产总价</th>
								<th data-options="field:'usedate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">投入使用日期</th>
								<th data-options="field:'housetaxoriginalvalue',width:120,align:'center',editor:{type:'validatebox'}">房产原值</th>
								<th data-options="field:'housesourcename',width:120,align:'center',editor:{type:'validatebox'}">房产来源</th>
						</thead>
				</table>
		    </div> 
	    </div>
	</div>
	<div id="landinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'选择关联的土地信息',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;" data-close="autoclose">
		<table id='landinfogrid' class="easyui-datagrid" style="height:490px;overflow: scroll;"
				data-options="iconCls:'icon-edit',singleSelect:false,pageList:[15],toolbar:'#landinfogrid_toolbar'">
			<thead>
			    <th data-options="checkbox:true"></th>
			    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
				<th data-options="field:'estateserialno',width:80,align:'center',editor:{type:'validatebox'}">宗地编号</th>
				<th data-options="field:'landcertificate',width:120,align:'center',editor:{type:'validatebox'}">土地证号</th>
				<th data-options="field:'belongtocountryname',width:100,align:'center',editor:{type:'validatebox'}">所属村委会</th>
				<th data-options="field:'detailaddress',width:135,align:'center',editor:{type:'validatebox'}">详细地址</th>
				<th data-options="field:'landarea',width:100,align:'center',editor:{type:'validatebox'}">土地面积</th>
				<th data-options="field:'landmoney',width:100,align:'center',editor:{type:'validatebox'}">土地总价</th>
			</thead>
		</table>
		<div id="landinfogrid_toolbar" style="height:25px;display:none">
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="dosave()">保存</a>
		</div>
	</div>
	
	<div id="houserecoverquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产所有权转移查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:800px;height:260px;" data-close="autoclose">
			<form id="houserecoverqueryform" method="post">
			   <input type="hidden" id="businesstype" name="businesstype"/>
			   <input type="hidden" id="businesscode" name="businesscode"/>
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">产权人计算机编码：</td>
						<td><input id="lessorid" class="easyui-validatebox" type="text" style="width:200px" name="lessorid"/></td>
						<td align="right">产权人名称：</td>
						<td>
							<input id="lessortaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="lessortaxpayername"/>
						</td>

					</tr>
					<tr>
						<td align="right">状态：</td>
						<td colspan="3">
							<select id="state" class="easyui-combobox" style="width:200px" name="state" editable="false">
								<option value="">全部</option>
								<option value="0">未审核</option>
								<option value="1" selected>已审核</option>
								<option value="3">已终审</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">实际收回日期：</td>
						<td colspan="5">
							<input id="usedatebegin" class="easyui-datebox" name="usedatebegin"/>
						至
							<input id="usedateend" class="easyui-datebox"  name="usedateend"/>
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