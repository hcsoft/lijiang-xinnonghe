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
	<script src="../house.js"></script>
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
	$.extend($.fn.datagrid.defaults.editors, {
	datebox : {
		init : function(container, options) {
			var input = $('<input type="text">').appendTo(container);
			input.datebox(options);
			return input;
		},
		destroy : function(target) {
			$(target).datebox('destroy');
		},
		getValue : function(target) {
			return $(target).datebox('getValue');//获得旧值
		},
		setValue : function(target, value) {
			console.info(formatDatebox(value));
			$(target).datebox('setValue', formatDatebox(value));//设置新值的日期格式
		},
		resize : function(target, width) {
			$(target).datebox('resize', width);
		}
	}
});
     
	<%
       String businesstype = request.getParameter("businesstype");
	   if(businesstype == null || businesstype.trim().equals("")){
		   businesstype = "64";
	   }
    %>
    
    var bustype = <%=businesstype%>;
    var modename = cacheMap.get(bustype).bustypename;
    //CommonUtils.enableAjaxProgressBar();
    var groundusedata = new Array();
    
    var saveurl;
	var saveparams;
	var saveinfomessage;
	var currenthouseid;
	var chooseTaxpayer_type;
	var editIndex = undefined;
    
    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
    
	$(function(){
		
			$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_GROUNDUSECODE'},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
				  groundusedata= jsondata;
			   }
			});
		
		   var managerLink = new OrgLink();
	       managerLink.sendMethod = false;
	       managerLink.loadData();
		   var firstDay = DateUtils.getYearFirstDay();
		   var lastDay = DateUtils.getCurrentDay();
		   //$('#usedatebegin').datebox('setValue',firstDay);
		   //$('#usedateend').datebox('setValue',lastDay);
		   //530122
		   
		    CommonUtils.getCacheCodeFromTable('COD_HOUSEUSECODE','houseusecode',
			                                 'houseusename','#purpose',"");
		   
		   $('#houseownergrid').datagrid({
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
		   var p = $('#houseownergrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
			$('#houseownerinfoform #businesstype').val(bustype);
			$('#houseownerinfoform #businesscode').val(bustype);
			
			$('#houseownerqueryform #businesstype').val(bustype);
			$('#houseownerqueryform #businesscode').val(bustype);
			setTimeout('query()',100);//页面打开后查询
			$('#modeladdinfo').linkbutton({   
			    text: modename  
			});
			$('#houseownerquerywindow').window({
				title:modename+'查询条件'
			});
			
			$('#query_taxpayerid,#query_taxpayername').bind('keydown',function(event) {  
		          if(event.keyCode==13){  
		        	  chooseTaxpayer('sell');  
		        }  
	         }); 
			
			$('#lesseesid,#lesseestaxpayername').bind('keydown',function(event) {  
		          if(event.keyCode==13){  
		        	  chooseTaxpayer('buy');  
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
			
			$('#rentgrid').datagrid({
					fitColumns:'true',
					maximized:'true',
					toolbar:[{
						text:'新增',
						iconCls:'icon-add',
						handler:function(){
							if (endEditing()){
								endEdits();
								$('#rentgrid').datagrid('appendRow',{
								limitbegin:'',
								limitend:'',
								transmoney:'0.00',
								holddate:''
								});
								editIndex = $('#rentgrid').datagrid('getRows').length-1;  
								$('#rentgrid').datagrid('selectRow', editIndex)  
										.datagrid('beginEdit', editIndex);
							} 
						}
					},{
						text:'修改',
						iconCls:'icon-edit',
						handler:function(){
							if(endEditing()){
								var row = $('#rentgrid').datagrid('getSelected');
								var index = $('#rentgrid').datagrid('getRowIndex',row);
								$('#rentgrid').datagrid('beginEdit',index);
								editIndex = index;
							}
						}
					},{
						text:'删除',
						iconCls:'icon-remove',
						handler:function(){
							var index = $('#rentgrid').datagrid('getRowIndex',$('#rentgrid').datagrid('getSelected'));
							$('#rentgrid').datagrid('deleteRow', index);    
							editIndex = undefined;
						}
					}]
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
					  url: "/houseowner/get.do?d="+new Date(),
					  data: {'key':rowdata.busid,'businesstype':bustype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  var bushousebo = jsondata.result;
							  var basehousebo = bushousebo.baseHouse;
							  if(bushousebo.rentdata != null && bushousebo.rentdata.length>0){
								$('#rentgrid').datagrid('loadData',bushousebo.rentdata);
							  }
							  for(var p in bushousebo){
								   var value = bushousebo[p];
								   if(p.indexOf('date') >=0){
									   value = formatterDate(value);
								   }
								   var input = $('#houseownerinfoform #'+p);
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
							    
							    $('#houseownerinfoform input[data-select="s"]').each(function(){
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
					 $('#houseowneraddwindow').window({title:modename+'信息查看'});
				     $('#houseowneraddwindow').window('open');
				   } 
				   else {
					 $('#ownerOperDiv').show();
					 $('#selectlandtb').show();
					 $('#houseowneraddwindow').window({title:modename+'信息修改'});
				     $('#houseowneraddwindow').window('open');
				   }
				   
				   
	    }
		function query(){
			var params = {};
			var fields =$('#houseownerqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['pagesize'] = 15;
		    var opts = $('#houseownergrid').datagrid('options');
		    opts.url = '/houseowner/select.do?d='+new Date();
		    $('#houseownergrid').datagrid('load',params); 
		    $('#houseownerquerywindow').window('close');
		}
		function openQuery(){
			$('#houseownerquerywindow').window('open');
		}
        //TODO 新增进度条的功能   日期选择  没有事件
		//新增房产所有权转移开始。。。。。 
		function openHouseOwnerAdd(){
			inputreset();
			$('#datagrid_house').datagrid('loadData',{total:0,rows:[]});
			$('#rentgrid').datagrid('loadData',{total:0,rows:[]});
			$('#query_taxpayerid').val('');
			$('#query_taxpayername').val('');
			saveurl=null;
			saveparams=null;
			saveinfomessage=null;
			currenthouseid=null;
			$('#houseownerinfoform #businesstype').val(bustype);
			$('#houseownerinfoform #businesscode').val(bustype);
			$('#ownerOperDiv').show();
			$('#selectlandtb').show();
			$('#houseowneraddwindow').window({title:modename+'信息增加'});
			$('#houseowneraddwindow').window('open');
		}
		function chooseHouseInfo(){
			WidgetUtils.showChooseBaseHouseInfo(function(rowIndex,rowData){
				   if(rowData){
					    rowData['lessorid'] = rowData['taxpayerid'];
					    rowData['lessortaxpayername'] = rowData['taxpayername'];
					    rowData['housearea_s'] = rowData['housearea'];
					    rowData['usedate_s'] = rowData['usedate'];
					    $('#houseownerinfoform input[data-select="s"]').each(function(){
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
		
		function chooseTaxpayer(type){
			var taxpayerid=null;
			var taxpayername=null;
			chooseTaxpayer_type=type;
			if('sell'==chooseTaxpayer_type){
				taxpayerid=$('#query_taxpayerid').val();
				taxpayername=$('#query_taxpayername').val();
			}else{
				taxpayerid=$('#lesseesid').val();
				taxpayername=$('#lesseestaxpayername').val();
			}
				
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
						  if('sell'==chooseTaxpayer_type){
								$('#query_taxpayerid').val(taxpayerlist[0].taxpayerid);
								$('#query_taxpayername').val(taxpayerlist[0].taxpayername);
								housequery();
							}else{
								$('#lesseesid').val(taxpayerlist[0].taxpayerid);
								$('#lesseestaxpayername').val(taxpayerlist[0].taxpayername);
							}
						  
					  }else{
						  WidgetUtils.showChooseTaxpayerInfo(function(rowIndex,rowData){
							  if('sell'==chooseTaxpayer_type){
									$('#query_taxpayerid').val(rowData.taxpayerid);
									$('#query_taxpayername').val(rowData.taxpayername);
									housequery();
								}else{
									$('#lesseesid').val(rowData.taxpayerid);
									$('#lesseestaxpayername').val(rowData.taxpayername);
								}
							});
					  }
				  }
		   });
		}
		function inputreset(){
//			$('#houseownerinfoform').form('clear');
//			$('#houseownerinfoform input').val('');
			$('#houseownerinfoform')[0].reset();
			$('#houseownerinfoform #busid').val('');
			$("input[name='housearea']").val('0.00');
		}
		function validateFormData(){
			var inputAry = $('#houseownerinfoform input[data-validate="p"]');
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
			var fields =$('#houseownerinfoform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});	
			var houserows = $('#datagrid_house').datagrid('getSelected');
			if(!houserows){
				$.messager.alert('警告','请选择房产!');
				return false;
			}
			
			if($('#housearea').val()=='0.00'){
				$.messager.alert('警告',' 出租建筑面积必须大于0');
				return false;
			}
			if($('#housearea').val()>houserows.housearea){
				$.messager.alert('警告','出租的建筑面积不能大于选中的房产面积！');
				return false;
			}
			if (endEditing()){
				endEdits();
			}else{
				return;
			}
			var rentdata = $('#rentgrid').datagrid('getRows');
			if(rentdata.length == 0){
				$.messager.alert('返回消息','请录入出租明细！');
				return;
			}else{
				
			}
			var houseusedate = formatDatebox(houserows.usedate);
			params['lessorid'] = $('#query_taxpayerid').val();
			params['lessortaxpayername'] = $('#query_taxpayername').val();
			params['houseid'] = houserows.houseid;
			params['rentdata'] = rentdata;
			var busid = $('#houseownerinfoform #busid').val();
			saveurl="/houseuse/add.do?d="+new Date();
			if(busid){
				for (var i=0;i<rentdata.length ;i++ )
				{
					var rownum = i+1;
					var row = rentdata[i];
					var begindate = formatDatebox(row.limitbegin);
					var enddate = formatDatebox(row.limitend);
					var holddate = formatDatebox(row.holddate);
					var transmoney = row.transmoney;
					if(!dateValid(begindate)){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行出租时间起有误！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(!dateValid(enddate)){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行出租时间止有误！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(!dateValid(holddate)){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行合同约定付款时间有误！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(begindate<houseusedate){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行出租时间起不能小于房产投入使用时间！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(begindate>=enddate){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行出租时间起不能大于等于出租止时间！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(transmoney<=0){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行租金不能小于等于0！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
				}
				saveurl="/houseuse/update.do?d="+new Date();
			}else{
				for (var i=0;i<rentdata.length ;i++ )
				{
					var rownum = i+1;
					var row = rentdata[i];
					var begindate = row.limitbegin;
					var enddate = row.limitend;
					var holddate = row.holddate;
					var transmoney = row.transmoney;
					if(!dateValid(begindate)){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行出租时间起有误！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(!dateValid(enddate)){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行出租时间止有误！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(!dateValid(holddate)){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行合同约定付款时间有误！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(begindate<houseusedate){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行出租时间起不能小于房产投入使用时间！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(begindate>=enddate){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行出租时间起不能大于等于出租止时间！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
					if(transmoney<=0){
						$.messager.alert('返回消息','出租记录中第'+rownum+'行租金不能小于等于0！');
						$('#rentgrid').datagrid('beginEdit',i);
						return;
					}
				}
			}
			$.ajax({
				type: "post",
				async:true,
				cache:false,
				url: saveurl,
				data: $.toJSON(params),
				dataType: "json",
				contentType: "application/json; charset=utf-8",
				success:function(jsondata){
				if(jsondata.sucess){
					$.messager.alert('提示消息','保存成功','info');
					housequery();
					query();
					inputreset();
					$('#rentgrid').datagrid('loadData',{total:0,rows:[]});
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
    		   row = $('#houseownergrid').datagrid('getSelected');
    	   }
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要修改的'+modename+'信息!','info');
    		   return false;
    	   }
    	   if(row.state == '0'){
    		   detailoper(null,row,false,flag);
    	   }else{
    		   $.messager.alert('提示消息','只有状态为未审核的'+modename+'信息才能修改!','info');
    	   }
       }
	
	  
       function cancelHouse(flag){
    	   var row = null;
    	   if(flag){
    		   row = $('#datagrid_housetrans').datagrid('getSelected');
    	   }else{
    		   row = $('#houseownergrid').datagrid('getSelected');
    	   }
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要删除的'+modename+'信息!','info');
    		   return false;
    	   }
    	   if(row.state != '0'){
    		   $.messager.alert('提示消息','只有状态为未审核的'+modename+'信息才能删除!','info');
    		   return false;
    	   }
    	   
    	   var url = "";
    	   if("61"==bustype || "62"==bustype ||"63"==bustype){//出租 融资租赁 出典
			    url = "/houseuse/cancel.do?d="+new Date();
  		   }else {
  				url = "/houseowner/cancel.do?d="+new Date();
  		   }
    	   $.messager.confirm('确认', '你确认删除当前的'+modename+'信息？', function(r){
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
							  $.messager.alert('提示消息','删除'+modename+'信息成功','info',function(){
								  if(flag){
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
    		   checkmsg = '请选择需要审核的'+modename+'信息!';
    		   confirmmsg = "你确认审核当前的"+modename+"信息？";
    		   url = "/houseowner/check.do?d="+new Date();
    	   }else{
    		   checkmsg = '请选择需要取消审核的'+modename+'信息!';
    		   confirmmsg = "你确认取消审核当前的"+modename+"信息？";
    		   url = "/houseowner/uncheck.do?d="+new Date();
    	   }
    	   var row = $('#houseownergrid').datagrid('getSelected');
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
			var fields =$('#houseownerqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['propNames'] = 'statename,lessorid,lessortaxpayername,lesseesid,lesseestaxpayername,housearea,houseamount,usedate,purpose,protocolnumber';
			params['colNames'] = '审核状态,转出计算机编码,转出纳税人名称,转入计算机编码,转入纳税人名称,转移房产建筑面积(平方米),'+
                                 '转移总价(元),房产转移日期,房产用途,转移协议号';
			params['modelName']=modename;
			
			if("61"==bustype || "62"==bustype ||"63"==bustype){//出租 融资租赁 出典
				CommonUtils.downloadFile("/houseuse/houseownerexport.do?date="+new Date(),params);
			}else {
				CommonUtils.downloadFile("/houseowner/houseownerexport.do?date="+new Date(),params);
			}
		}
		
		function landquery(){
			var params = {};
			params.taxpayerid = $('#lesseesid').val();
			var opts = $('#landinfogrid').datagrid('options');
			opts.url = '/landavoidtaxmanager/selectland.do?d='+new Date()+"&pagesize=15";
			$('#landinfogrid').datagrid('load',params); 
		}
		
		function housequery(houseid){
			var params = {};
			params.taxpayerid = $('#query_taxpayerid').val();
			params.state="1";
			if(houseid){
				params.bushouseid=houseid;
			}
			if("64"==bustype || "52"==bustype ||"53"==bustype){//转让 投资联营 捐赠
				params.ownflag=1;
			}
			if("61"==bustype || "62"==bustype ||"63"==bustype){//出租 融资租赁 出典
				params.ownflag=1;
			}
			var opts = $('#datagrid_house').datagrid('options');
			opts.url = '/housecontrol/selecthouseinfo.do?d='+new Date()+"&pagesize=15";
			$('#datagrid_house').datagrid('load',params); 
			
		}

		
		function finalcheck(checktype){
	    	   var checkmsg = "";
	    	   var confirmmsg = "";
	    	   var url = "";
	    	   if(checktype == '1'){
	    		   checkmsg = '请选择需要审核的'+modename+'信息!';
	    		   confirmmsg = "你确认审核当前的"+modename+"信息？";
	    		   if("61"==bustype || "62"==bustype ||"63"==bustype){//出租 融资租赁 出典
	    			    url = "/houseuse/finalcheck.do?d="+new Date();
		   		   }else {
		   				url = "/houseowner/finalcheck.do?d="+new Date();
		   		   }
	    	   }else{
	    		   checkmsg = '请选择需要取消审核的'+modename+'信息!';
	    		   confirmmsg = "你确认取消审核当前的"+modename+"信息？";
	    		   if("61"==bustype || "62"==bustype ||"63"==bustype){//出租 融资租赁 出典
	    			    url = "/houseuse/unfinalcheck.do?d="+new Date();
		   		   }else {
		   				url = "/houseowner/unfinalcheck.do?d="+new Date();
		   		   }
	    	   }
	    	   var row = $('#houseownergrid').datagrid('getSelected');
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
		
		function formatgrounduse(row){
			for(var i=0; i<groundusedata.length; i++){
				if (groundusedata[i].key == row) return groundusedata[i].value;
			}
			return row;
		}
		function endEditing(){  
			if (editIndex == undefined){return true}  
			if ($('#rentgrid').datagrid('validateRow', editIndex)){
				$('#rentgrid').datagrid('endEdit', editIndex);
				editIndex = undefined;  
				return true;  
			} else {  
				alert('出租信息中有必填字段不能为空！');
				return false;  
			}  
		}
		function endEdits(){
			var rows = $('#rentgrid').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#rentgrid').datagrid('endEdit', i);
			}
			$('#rentgrid').datagrid('acceptChanges');
		}
	</script>
</head>
<body>
     <div class="easyui-layout" style="width:100%;height:570px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='houseownergrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
				        <th data-options="field:'busid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">业务主键</th>
						<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
						<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
					    <th data-options="field:'houseid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">房产主键</th>
						<th data-options="field:'statename',width:80,align:'center',editor:{type:'validatebox'}">审核状态</th>
						<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
						<th data-options="field:'lessorid',width:100,align:'left',editor:{type:'validatebox'}">转出计算机编码</th>
						<th data-options="field:'lessortaxpayername',width:220,align:'left',editor:{type:'validatebox'}">转出纳税人名称</th>
						<th data-options="field:'lesseesid',width:100,align:'left',editor:{type:'validatebox'}">转入计算机编码</th>
						<th data-options="field:'lesseestaxpayername',width:220,align:'left',editor:{type:'validatebox'}">转入纳税人名称</th>
						
						<th data-options="field:'housearea',width:150,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">转移房产建筑面积(平方米)</th>
						<th data-options="field:'houseamount',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">转移总价(元)</th>
						<th data-options="field:'transmoney',width:150,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">租金(元)</th>
						<th data-options="field:'usedate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">房产转移日期</th>
						
						<th data-options="field:'purpose',formatter:formatgrounduse,width:120,align:'left',editor:{type:'validatebox'}">房产用途</th>
						<th data-options="field:'protocolnumber',width:120,align:'left',editor:{type:'validatebox'}">转移协议号</th>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a id="modeladdinfo" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openHouseOwnerAdd()">所有权转移</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openUpdate()">修改</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="cancelHouse()">删除</a>
				<!-- <a href="#" id="finalcheck_button" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="finalcheck('1')">终审</a>
				<a href="#" id="unfinalcheck_button" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="finalcheck('0')">撤销终审</a> -->
				<a class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportExcel()">导出</a>
				<a style="display: none;" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="checkHouse(1)">审核</a>
				<a style="display: none;" class="easyui-linkbutton" data-options="iconCls:'icon-uncheck',plain:true" onclick="checkHouse(0)">取消审核</a>
			</div>
		</div>
	</div>
	<div id="houseowneraddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产所有权转移登记',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:1100px;" data-close="autoclose">
	       <div class="easyui-layout" style="height:530px;">  
	        <div region="north" style="text-align:center;height: 35px;" align="center">  
				 <table align="center" >
				 <tr>
				    <td align="right" id="td_sell_taxpayerid">出租方计算机编码：</td>
					<td>
						<input id="query_taxpayerid" class="easyui-validatebox" name="query_taxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)" />			
					</td>
					<td align="right" id="td_sell_taxpayername">出租方纳税人名称：</td>
					<td>
						<input id="query_taxpayername" class="easyui-validatebox" name="query_taxpayername" data-validate="p"/>	
						<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseTaxpayer('sell')" 
						   style="color: blue;font-weight: bold;">查询</a>				
					</td>
				</tr>
				</table>
		    </div>
		    <div region="center" id="housepanel" title="" data-options="selected:true" 
		    style="overflow:auto;padding:10px;">  
		       <form id="houseownerinfoform" method="post">
		            <input type="hidden" id="businesstype" name="businesstype"/>
		            <input type="hidden" id="businesscode" name="businesscode"/>
		            <input type="hidden" id="busid" name="busid"/>
		             <input type="hidden" id="houseid" name="houseid" data-select="s"/>
				<table id="narjcxx1x" width="100%"  cellpadding="3" cellspacing="0">
					<tr>
						<td align="right" id="td_buy_taxpayerid">承租方计算机编码：</td>
						<td>
							<input class="easyui-validatebox"  id="lesseesid"  name="lesseesid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>				
						</td>
						<td colspan="2" align="">
							<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseTaxpayer('buy')" 
							   style="color: blue;font-weight: bold;">查询</a>
						</td>
					</tr>
					<tr>
						<td align="right" id="td_buy_taxpayername">承租方纳税人名称：</td>
						<td>
							<input class="easyui-validatebox"  id="lesseestaxpayername"  name="lesseestaxpayername" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>			
						</td>
						<td align="right" id="houseareatd1">出租建筑面积(平方米)：</td>
						<td>
							<input class="easyui-numberbox"  id="housearea"  name="housearea" data-options="min:0,precision:2"  value="0.00"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>			
						</td>
					</tr>
					<tr id="tr_use">
						
						<td align="right">房产用途：</td>
						<td>
							<input class="easyui-combobox"  id="purpose"  name="purpose" data-options="panelWidth:260"/>					
						</td>
						<td align="right">转移协议号：</td>
						<td>
							<input id="protocolnumber" class="easyui-validatebox"  name="protocolnumber" />					
						</td>
					</tr>
				</table>
				 <div style="text-align:center;padding:5px;height: 25px;" id="ownerOperDiv">  
					 <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveOwnerHouse()">保存</a>
					 <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="inputreset()">清除所有数据</a>
			    </div>
			    
		    	<table id="rentgrid"   style="overflow:visible"
						data-options="iconCls:'icon-viewdetail',singleSelect:true,pageList:[15],title:''">
						<thead>
								<th data-options="field:'limitbegin',width:200,align:'center',formatter:formatDatebox,editor:{type:'datebox',options:{required:true}}">出租时间起</th>
								<th data-options="field:'limitend',width:200,align:'center',formatter:formatDatebox,editor:{type:'datebox',options:{required:true}}">出租时间止</th>
								<th data-options="field:'transmoney',width:200,align:'right',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">租金(元)</th>
								<th data-options="field:'holddate',width:200,align:'center',formatter:formatDatebox,editor:{type:'datebox',options:{required:true}}">合同约定付款时间</th>
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
							    <th data-options="field:'housecertificate',width:120,align:'left',editor:{type:'validatebox'}">房产权属证号</th>
								<th data-options="field:'housearea',width:150,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">房产建筑面积(平方米)</th>
								<th data-options="field:'belongtownsname',width:100,align:'left',editor:{type:'validatebox'}">所属村委会</th>
								<th data-options="field:'usedate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">投入使用日期</th>
								<th data-options="field:'housetaxoriginalvalue',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">房产原值</th>
								<th data-options="field:'housesourcename',width:120,align:'left',editor:{type:'validatebox'}">房产来源</th>
						</thead>
				</table>
		    </div> 
	    </div>
	</div>
	
	<div id="houseownerquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产所有权转移查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:800px;height:260px;" data-close="autoclose">
			<form id="houseownerqueryform" method="post">
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
						<td align="right" id="outtaxpayerid">转出方计算机编码：</td>
						<td><input id="lessorid" class="easyui-validatebox" type="text" style="width:200px" name="lessorid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/></td>
						<td align="right" id="outtaxpayername">转出方纳税人名称：</td>
						<td>
							<input id="lessortaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="lessortaxpayername"/>
						</td>

					</tr>
					<tr>
						<td align="right" id="intaxpayerid">转入方计算机编码：</td>
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="taxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/></td>
						<td align="right" id="intaxpayername">转入方纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px" name="taxpayername"/>
						</td>

					</tr>
					<tr>
						<td align="right">审核状态：</td>
						<td colspan="3">
							<select id="state" class="easyui-combobox" style="width:200px" name="state" editable="false">
								<option value="">全部</option>
								<option value="0">未审核</option>
								<option value="1" >已审核</option>
								<option value="3">已终审</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">房产转移日期：</td>
						<td colspan="3">
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