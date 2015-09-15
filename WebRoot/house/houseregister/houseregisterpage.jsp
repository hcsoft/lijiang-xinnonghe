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
    var estateinfo;
    var currentform = null;
    var currenttype = null;  //0为使用中，1 为自建
   // CommonUtils.enableAjaxProgressBar();
    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
    
    function sethousesourcecode(self){
    	if(self){
    		CommonUtils.getCacheCodeFromTable('COD_HOUSESOURCECODE','housesourcecode','housesourcename','#housesource'," and housesourcecode='01' ");
			$('#housesource').combobox('select','01');
    	}else{
    		CommonUtils.getCacheCodeFromTable('COD_HOUSESOURCECODE','housesourcecode','housesourcename','#housesource',
                    " and housesourcecode in ('02','03','04','05','06','99','07') ");
    	}
    }
    
    
	$(function(){
		   var managerLink = new OrgLink();
	       managerLink.sendMethod = false;
	       managerLink.loadData();
			
			//分局登录 默认选中
			var orgclass='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getUserTaxOrgVO().getOrgclass()%>';
			var taxdeptcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
			var taxempcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
			//if(orgclass=='04'){
			//	$('#taxdeptcode').combobox("setValue",taxdeptcode);
			//	$('#taxmanagercode').combobox("setValue",taxempcode);
			//}
			
		   var firstDay = DateUtils.getYearFirstDay();
		   var lastDay = DateUtils.getCurrentDay();
		   //$('#usedatebegin').datebox('setValue',firstDay);
		   //$('#usedateend').datebox('setValue',lastDay);
		   
		   
		   //530122
		   sethousesourcecode(true);
		   //////////////////////countrytown,belongtowns
		   CommonUtils.getCacheCodeFromTable('COD_HOUSECERTIFICATETYPE','housecertificatetypecode',
			                                 'housecertificatetypename','#otherhouseinfoform #housecertificatetype',"and valid='01' ");
		   CommonUtils.getCacheCodeFromTable('COD_HOUSEUSECODE','houseusecode',
			                                 'houseusename','#otherhouseinfoform #purpose');
		   CommonUtils.getCacheCodeFromTable('COD_GROUNDTYPECODE','groundtypecode',
			                                 'groundtypename','#otherhouseinfoform #productionlevel');
		   $('#otherhouseinfoform #countrytown').combobox({
			   onSelect:function(data){
			      CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#otherhouseinfoform #belongtowns'," and parentid = '"+data.key+"' ");
			   }
		   });
		   CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#otherhouseinfoform #countrytown'," and parentid = '530122' ");
		   
		   
		   $('#houseregistergrid').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			rowStyler:settings.rowStyle,
			pageList:[15],
			onDblClickRow:function(){openUpdate(false);},
			onClickRow:function(rowIndex, rowData){
				if(rowData.states == '1'){
					$('#finalcheck_button').linkbutton('enable'); 
					$('#unfinalcheck_button').linkbutton('disable'); 
				}else if(rowData.states == '3'){
					$('#finalcheck_button').linkbutton('disable'); 
					$('#unfinalcheck_button').linkbutton('enable'); 
				}else{
					$('#finalcheck_button').linkbutton('disable'); 
					$('#unfinalcheck_button').linkbutton('disable'); 
				}
			}
		   });
		   var p = $('#houseregistergrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});

			
			
			$("input[name='querytype']").on("click", function(event){
				var querytype=$("input[name='querytype']:checked").val();
				
			 	if("1"==querytype){
					$('#tr_other').hide();
					$('#tr_build').show();
					$('#housetaxtd1').show();
					$('#housetaxtd2').show();
					$('#tr1').show();
					$('#tr2').show();
					$('#tr3').show();
					$('#tr4').show();
					$('#tr5').show();
					$('#tr6').show();
					$('#tr7').hide();
					$('#tr8').hide();
					$('#purposetr').hide();
					$('#housepricetd1').html('房产价款(元)：');
					$('#housepricetd2').attr('colspan','1');
					sethousesourcecode(true);
				}else{
					$('#tr_other').show();
					$('#tr_build').hide();
					$('#purposetr').hide();
					sethousesourcecode(false);
				}
			});
			
				   
			
			$('#datagrid_house').datagrid({
				toolbar: '#gridtoolbar',
				fitColumns:false,
				maximized:'true',
				pagination:true,
				rowStyler:settings.rowStyle,
				pageList:[15],
				onDblClickRow:function(){openUpdate(true);}
			});
			var p = $('#datagrid_house').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			
			$('#taxpayerid,#taxpayername').bind('keydown',function(event) {  
		          if(event.keyCode==13){  
		        	  chooseTaxpayer();  
		        }  
	         }); 
			
			
			$('#west_datagrid_landinfo').datagrid({
				view:$.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
									//$('#west_datagrid_landinfo').datagrid('selectRow',0);
									if(estateinfo){
										for(var i = 0;i < $('#west_datagrid_landinfo').datagrid('getData').rows.length;i++){
											 for(var j = 0;j < estateinfo.length;j++){
												 if( $('#west_datagrid_landinfo').datagrid('getData').rows[i].estateid==estateinfo[j].estateid){
													 $('#west_datagrid_landinfo').datagrid('selectRow',i);	
												 }
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
			var p = $('#west_datagrid_landinfo').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			$('#purposetr').hide();
			setTimeout("query()",100);
	});
	    function dbclickevent(rowindex,rowdata){
	    	detailoper(rowindex,rowdata,false)
	    }
	    function detailoper(rowindex,rowdata,hideoperbtn,flag){
	    	       var housetype = rowdata.housetype;
	    	       currenttype = housetype == "1" ? "1" : "0";
	    	       currentform = "otherhouseaddwindow";
	    	       estateinfo=null;
				   $('#'+currentform).form('clear');
				   inputreset();
				   
				   $.ajax({
					  type: "post",
					  async:false,
					  cache:false,
					  url: "/houseregister/get.do?d="+new Date(),
					  data: {'key':rowdata.houseid,'houseregistertype':currenttype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  var basehousebo = jsondata.result;
							  
							  if(basehousebo.housetype=='1'){
								  $("input[name='querytype'][value='1']").attr("checked",true);
								  $('#tr_other').hide();
								  $('#tr_build').show();
								  sethousesourcecode(true);
							  }else{
								  $("input[name='querytype'][value='0']").attr("checked",true);
								  $('#tr_other').show();
								  $('#tr_build').hide();
								  sethousesourcecode(false);
							  }
							  
							  var countrytown = basehousebo.countrytown;
							  CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#otherhouseinfoform #belongtowns'," and parentid = '"+countrytown+"' ");
							  for(var p in basehousebo){
								   var value = basehousebo[p];
								   if(p.indexOf('date') >=0){
									   value = formatterDate(value);
								   }
								   var input = $('#'+currentform+' #'+p);
								   if(!input)
									   continue;
								   if(input.hasClass("easyui-validatebox")){
										input.val(value);
								   }else if(input.hasClass("easyui-numberbox")){
									    input.numberbox('setValue',value);
								   }
								   else if(input.hasClass("easyui-datebox")){
										input.datebox('setValue',value);
								   }
								   else if(input.hasClass("easyui-combobox")){
										input.combobox('setValue',value);
								   }else{
									   input.val(value);
								   }
							  }
							  
							  estateinfo = jsondata.result.estateList;
							  
							  landquery();
							  if(!flag)
							 	 housequery();
//							  $('#otherhouseinfoform #belongtowns').combobox('setValue',basehousebo.belongtowns);  
							  
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){});
						  }
					  }
			      });
				   if(hideoperbtn) {
					   $('#otherOperDiv').hide();
				       $('#otherhouseaddwindow').window({title:'房产登记查看'});
			           $('#otherhouseaddwindow').window('open');
				   }
				   else{
					   $('#otherOperDiv').show();
					   $('#otherhouseaddwindow').window({title:'房产登记修改'});
			           $('#otherhouseaddwindow').window('open');
				   } 
				   
	    }
		function query(){
			var params = {};
			var fields =$('#houseregisterqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['pagesize'] = 15;
			params['businesstype'] = '54';
			params['houseregistertype'] = '1';
		    var opts = $('#houseregistergrid').datagrid('options');
		    opts.url = '/houseregister/select.do?d='+new Date();
		    $('#houseregistergrid').datagrid('load',params); 
		    $('#houseregisterquerywindow').window('close');
		}
		function openQuery(){
			$('#houseregisterquerywindow').window('open');
		}

		function chooseTaxpayer(){
			$.ajax({
				  type: "post",
				  async:true,
				  cache:false,
				  url: '/housecontrol/selecttaxpayer.do?d='+new Date()+"&pagesize=15",
				  data: {"taxpayerid":$('#'+currentform+' #taxpayerid').val(),"taxpayername":$('#'+currentform+' #taxpayername').val()},
				  dataType: "json",
				  success:function(jsondata){
					  var taxpayerlist = jsondata.rows;
					  if(taxpayerlist.length==0){
						  $.messager.alert('消息','查无记录！');
					  }
					  else if(taxpayerlist.length==1){
						  $('#'+currentform+' #taxpayerid').val(taxpayerlist[0].taxpayerid);
						  $('#'+currentform+' #taxpayername').val(taxpayerlist[0].taxpayername);
						  landquery();
						  housequery();
					  }else{
						  WidgetUtils.showChooseTaxpayerInfo(function(rowIndex,rowData){
								$('#'+currentform+' #taxpayerid').val(rowData.taxpayerid);
								$('#'+currentform+' #taxpayername').val(rowData.taxpayername);
								landquery();
								housequery();
							});
					  }
				  }
		   });
		}
		function delegateLandStore(rowIndex,rowData){
			if(rowData){
				$('#landinfogrid').datagrid('appendRow',rowData); 
			}
		}
		function chooseLand(){
			WidgetUtils.showChooseBaseEstate(delegateLandStore);
		}
		function deleteChoosedLand(){
			var row = $('#landinfogrid').datagrid('getSelected');
			if(row == null)
				return;
			var rowIndex = $('#landinfogrid').datagrid('getRowIndex',row);
			$('#landinfogrid').datagrid('deleteRow',rowIndex);
		}
		
		//新增自建房结束
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//新增其他登记开始
		function openOtherAdd(){
			inputreset();
			$('#west_datagrid_landinfo').datagrid('loadData',{total:0,rows:[]});
			$('#west_datagrid_landinfo').datagrid('clearSelections');
			$('#datagrid_house').datagrid('loadData',{total:0,rows:[]});
			$('#otherhouseaddwindow #taxpayerid').val('');
			$('#otherhouseaddwindow #taxpayername').val('');
			$("input[name='querytype'][value='1']").attr("checked",true);
			currentform = "otherhouseaddwindow";
			$('#otherOperDiv').show();
			$('#otherhouseaddwindow').window({title:'新增房产登记'});
			if(self){
				$('#housesource').combobox('select','01');
			}
			$('#otherhouseaddwindow').window('open');
		}
		function validateFormData(){
			var inputAry = $('#'+currentform+' input[data-validate="p"]');
			result = CommonUtils.validateForm(inputAry);
			if(!result){
				return false;
			}
			return true;
		}
		
		function saveOtherHouse(){
			if(!$('#otherhouseinfoform #taxpayername').val()){
				$.messager.alert('警告','纳税人名称不能为空','info',function(){
					$('#otherhouseinfoform #taxpayername').focus();
				});
				return false;
			}
			var result = validateFormData();
			if(!result)
				return false;

			var params = {};
			var fields =$('#otherhouseinfoform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['houseregistertype'] = '0';
			
			var houseid = $('#otherhouseinfoform #houseid').val();
			var operurl = "/houseregister/add.do?d="+new Date();
			var infomessage = '新增房产登记成功';
			if(houseid){
				operurl = "/houseregister/update.do?d="+new Date();
				infomessage = '修改房产登记成功';
			}
			
			$.ajax({
					  type: "post",
					  async:true,
					  cache:false,
					  url: operurl,
					  data: params,
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息',infomessage,'info',function(){
								  $('#otherhouseaddwindow').window('close');
								  query();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			   });
		}
       //新增其它登记结束
       //修改房产登记开始
       function openUpdate(flag){
    	   var row = null;
    	   if(flag){
    		   row = $('#datagrid_house').datagrid('getSelected');
    	   }else{
    		   row = $('#houseregistergrid').datagrid('getSelected');
    	   }
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要修改的房产登记信息!','info');
    		   return false;
    	   }
    	   if(row.states == '0'){
    		   detailoper(null,row,false,flag);
    	   }else{
    		   $.messager.alert('提示消息','只有状态为未审核的信息才能修改!','info');
    	   }
    	   
       }
       function cancelHouse(flag){
    	   var row = null;
    	   if(flag){
    		   row = $('#datagrid_house').datagrid('getSelected');
    	   }else{
    		   row = $('#houseregistergrid').datagrid('getSelected');
    	   }
    	   
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要删除的房产登记信息!','info');
    		   return false;
    	   }
    	   
    	   if(row.states != '0'){
    		   $.messager.alert('提示消息','只有状态为未审核的信息才能删除!','info');
    		   return false;
    	   }
    	   
    	   var type = row.housetype == "1" ? "1" : "0";
    	   $.messager.confirm('确认', '你确认删除当前的房产登记信息？', function(r){
				if (r){
					$.ajax({
					  type: "post",
					  async:true,
					  cache:false,
					  url: "/houseregister/cancel.do?d="+new Date(),
					  data: {'key':row.houseid,"houseregistertype":type},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $('#west_datagrid_landinfo').datagrid('clearSelections');
							  estateinfo=null;
							  $.messager.alert('提示消息','删除房产登记信息成功','info',function(){
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
    		   checkmsg = '请选择需要审核的房产登记信息!';
    		   confirmmsg = "你确认审核当前的房产登记信息？";
    		   url = "/houseregister/check.do?d="+new Date();
    	   }else{
    		   checkmsg = '请选择需要取消审核的房产登记信息!';
    		   confirmmsg = "你确认取消审核当前的房产登记信息？";
    		   url = "/houseregister/uncheck.do?d="+new Date();
    	   }
    	   var row = $('#houseregistergrid').datagrid('getSelected');
    	   if(row == null){
    		   $.messager.alert('提示消息',checkmsg,'info');
    		   return false;
    	   }
    	   var type = row.housetype == "1" ? "1" : "0";
    	   $.messager.confirm('确认', confirmmsg, function(r){
				if (r){
					$.ajax({
					  type: "post",
					  async:true,
					  cache:false,
					  processbar:true,
					  url: url,
					  data: {'key':row.houseid,"houseregistertype":type},
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
			var fields =$('#houseregisterqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['businesstype'] = '54';
			params['houseregistertype'] = '1';
			
			params['propNames'] = 'statename,taxpayerid,taxpayername,housesourcename,housecertificatetypename,housecertificate,usedate,housearea,'+
			               'buildingcost,devicecost,landprice,plotratio,housetaxoriginalvalue,housetax,houseprice';
			params['colNames'] = '审核状态,计算机编码,纳税人名称,房产来源,房产权属类型,房产权属证号,投入使用日期,房产建筑面积(平方米),房产建筑安装成本(元),设备价款(元),'+
                                 '地价款,容积率,房产原值,交易相关税费,房屋价款';
			params['modelName']="房产登记";
			
			CommonUtils.downloadFile("/houseregister/houseregexport.do?date="+new Date(),params);
		}
		function landquery(){
			var params = {};
			params.taxpayerid = $('#'+currentform+' #taxpayerid').val();
			var opts = $('#west_datagrid_landinfo').datagrid('options');
			opts.url = '/houseregister/queryland.do?d='+new Date()+"&pagesize=15";
			$('#west_datagrid_landinfo').datagrid('load',params); 
		}
		
		function housequery(){
			var params = {};
			params.taxpayerid = $('#'+currentform+' #taxpayerid').val();
			params['businesstype'] = '54';
			params['houseregistertype'] = '1';
			var opts = $('#datagrid_house').datagrid('options');
			opts.url = '/houseregister/select.do?d='+new Date()+"&pagesize=15";
			$('#datagrid_house').datagrid('load',params); 
		}
		
		function saveHouse(){
			if(!$('#'+currentform+' #taxpayername').val()){
				$.messager.alert('警告','纳税人名称不能为空','info',function(){
					$('#'+currentform+' #taxpayername').focus();
				});
				return false;
			}
			var params = {};
			var fields =$('#otherhouseinfoform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			if(params.housesource != '07'){
				//验证土地信息
				var rows = $('#west_datagrid_landinfo').datagrid('getSelections');
				if(rows.length<=0){
					$.messager.alert('警告','新增房产必须选择所关联的土地','info',function(){
					});
					return false;
				}else{
					var estateids = '';
					for(var i = 0;i < rows.length;i++){
						var row = rows[i];
						estateids += row.estateid+',';
					}
					if(estateids){
						estateids = estateids.substr(0,estateids.length-1);
					}
				}
			}
			
			var result = validateFormData();
			if(!result)
				return false;
			
			var querytype=$("input[name='querytype']:checked").val();
			if("1"==querytype){
				if($('#buildingcost').val()=='0.00'){
					$.messager.alert('警告','房产建筑安装成本必须大于0');
					return false;
				}
			}else{
				if($('#houseprice').val()=='0.00'){
					$.messager.alert('警告','房产价款必须大于0');
					return false;
				}
			}
			

			

			
			
			
			params['taxpayerid'] = $('#'+currentform+' #taxpayerid').val();
			params['taxpayername'] = $('#'+currentform+' #taxpayername').val();
			params['housetype'] = querytype;
			
			if("1"==querytype){
				params['houseregistertype'] = '1';
			}else{
				params['houseregistertype'] = '0';
			}
			params['estateids'] = estateids;
			
			var houseid = $('#otherhouseinfoform #houseid').val();
			var operurl = "/houseregister/add.do?d="+new Date();
			var infomessage = '新增房产登记成功';
			if(houseid){
				operurl = "/houseregister/update.do?d="+new Date();
				infomessage = '修改房产登记成功';
			}
			
			$.ajax({
					  type: "post",
					  async:true,
					  cache:false,
					  url: operurl,
					  data: params,
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息',infomessage,'info',function(){
								  if(!houseid){
									  chooseTaxpayer();
									  inputreset();
								  }
								  query();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			   });
		}
		
		function inputreset(){
			$('#otherhouseinfoform input').val('');
			$('#otherhouseinfoform')[0].reset();
			$("input[name='houseprice']").val('0.00');
			$("input[name='housetax']").val('0.00');
			$("input[name='buildingcost']").val('0.00');
			$("input[name='devicecost']").val('0.00');
		}
		
		
		function finalcheck(checktype){
		   var confirmmsg = "";
    	   var url = "";
    	   if(checktype == '1'){
    		   checkmsg = '请选择需要审核的房产登记信息!';
    		   confirmmsg = "你确认审核当前的房产登记信息？";
    		   url = "/houseregister/finalcheck.do?d="+new Date();
    	   }else{
    		   checkmsg = '请选择需要取消审核的房产登记信息!';
    		   confirmmsg = "你确认取消审核当前的房产登记信息？";
    		   url = "/houseregister/unfinalcheck.do?d="+new Date();
    	   }
	   	   var row = $('#houseregistergrid').datagrid('getSelected');
	 	   if(row == null){
	 		   $.messager.alert('提示消息',checkmsg,'info');
	 		   return false;
	 	   }
	 	   $.messager.confirm('确认', confirmmsg, function(r){
					if (r){
						$.ajax({
						  type: "post",
						  async:true,
						  cache:false,
						  processbar:true,
						  url: url,
						  data: {'key':row.houseid},
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
		function querylessor() {
		var params = {};
		params.taxpayerid = $('#lessorid').val();
		params.taxpayername = '';
		$.ajax({
			type: "post",
			url: "/GroundUserightServlet/getreginfo1.do",
			data: params,
			dataType: "json",
			success: function(jsondata){
			
				if (jsondata.total==1){ 
					$('#lessortaxpayername').val(jsondata.rows[0].taxpayername);
					
				}
				if (jsondata.total==0){
					$.messager.alert('返回消息',"不存在该纳税人!");
					$('#taxpayername').val('');
					$('#taxpayerid').val('');
				
				}
			} 
		});
	}
	</script>
</head>
<body>
     <div class="easyui-layout" style="width:100%;height:570px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='houseregistergrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
					    <th data-options="field:'houseid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
						<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
						<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
						<th data-options="field:'statename',width:80,align:'center',editor:{type:'validatebox'}">审核状态</th>
						<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
						<th data-options="field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:220,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'housesourcename',width:120,align:'left',editor:{type:'validatebox'}">房产来源</th>
						<th data-options="field:'housecertificatetypename',width:150,align:'left',editor:{type:'validatebox'}">房产权属类型</th>
						<th data-options="field:'housecertificate',width:150,align:'left',editor:{type:'validatebox'}">房产权属证号</th>
						<th data-options="field:'usedate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">投入使用日期</th>
						<th data-options="field:'housearea',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">房产建筑面积(平方米)</th>
						<th data-options="field:'buildingcost',hidden:true,width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">房产建筑安装成本(元)</th>
						<th data-options="field:'devicecost',hidden:true,width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">设备价款(元)</th>
						<th data-options="field:'landprice',hidden:true,width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">地价款</th>
						<th data-options="field:'plotratio',hidden:true,width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">容积率</th>
						
						<th data-options="field:'housetaxoriginalvalue',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">房产原值</th>
						<th data-options="field:'housetax',hidden:true,width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">交易相关税费(元)</th>
						<th data-options="field:'houseprice',hidden:true,width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">房屋价款(元)</th>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openOtherAdd()">新增登记</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openUpdate()">修改</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="cancelHouse()">删除</a>
				<!-- <a href="#" id="finalcheck_button" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="finalcheck('1')">终审</a>
				<a href="#" id="unfinalcheck_button" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="finalcheck('0')">撤销终审</a> -->
				<a class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportExcel()">导出</a>
				<a href="#" style="display:none" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="checkHouse(1)">审核</a>
				<a href="#" style="display:none" class="easyui-linkbutton" data-options="iconCls:'icon-uncheck',plain:true" onclick="checkHouse(0)">取消审核</a>
			</div>
		</div>
	</div>
	<!-- 其他登记的DIV  -->
	<div id="otherhouseaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'其它房产登记',collapsible:false,
	minimizable:false,maximizable:false,closable:true,onOpen:function(){
         currentform='otherhouseinfoform';
		 currenttype='0';
    }" style="width:1150px;" data-close="autoclose">
    	<div class="easyui-layout" style="height:530px;">
	    	<div region="north" style="text-align:center;height: 35px;" align="center">  
				 <table align="center" >
				 <tr>
				 	<td align="right"><span style=" color:red; font-weight: bold;">登记类型：</span></td>
				 	<td ><input type="radio" style="vertical-align: middle;margin-top: 0px;" checked="checked" name="querytype" value="1"/>自建房产登记
				 		 <input type="radio"  style="vertical-align: middle;margin-top: 0px;" name="querytype" value="0" />其它房产登记&nbsp;&nbsp;&nbsp;
				 	</td>
				    <td align="right">计算机编码：</td>
					<td>
						<input id="taxpayerid" class="easyui-validatebox" name="taxpayerid"  onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>			
					</td>
					<td align="right">纳税人名称：</td>
					<td>
						<input id="taxpayername" class="easyui-validatebox" name="taxpayername" data-validate="p"/>	
						<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseTaxpayer()" 
						   style="color: blue;font-weight: bold;">查询</a>				
					</td>
				</tr>
				</table>
		    </div>
		    <div  region="west" title="" style="width:420px;">
		    	<table id="west_datagrid_landinfo" class="easyui-datagrid" style="width:418px;height:490px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:false,pageList:[15]">
					<thead>
						    <th data-options="checkbox:true"></th>
						    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
							<th data-options="field:'estateserialno',width:100,align:'left',editor:{type:'validatebox'}">宗地编号</th>
							<th data-options="field:'landcertificate',width:120,align:'left',editor:{type:'validatebox'}">土地证号</th>
							<th data-options="field:'belongtocountryname',width:100,align:'left',editor:{type:'validatebox'}">所属村委会</th>
							<th data-options="field:'detailaddress',width:200,align:'left',editor:{type:'validatebox'}">详细地址</th>
							<th data-options="field:'landarea',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">土地面积(平方米)</th>
							<th data-options="field:'landmoney',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">土地总价(元)</th>
					</thead>
				</table>
			</div> 
		    <div id="housepanel" title="" data-options="selected:true" region="center"
		    style="overflow:auto;padding:10px;height:500px;">  
		       <form id="otherhouseinfoform" method="post">
					<input type="hidden"  id="locationtype"  name="locationtype" value="" />	
					<input type="hidden"  id="houseid"  name="houseid" />
				<table id="narjcxx1x" width="100%"  cellpadding="3" cellspacing="0">
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-combobox"  id="housesource"  name="housesource"  
							data-options="onChange:function(newValue, oldValue){
								if(newValue=='07'){//承租
									$('#housetaxtd1').hide();
									$('#housetaxtd2').hide();
									$('#tr1').hide();
									$('#tr2').hide();
									$('#tr3').hide();
									$('#tr4').hide();
									$('#tr5').hide();
									$('#tr6').hide();
									$('#tr7').show();
									$('#tr8').show();
									$('#housepricetd1').html('年租金(元)：');
									$('#houseareatd1').html('承租房产建筑面积(平方米)：');
									$('#housepricetd2').attr('colspan','3');
									$('#purposetr').show();
								}else{
									$('#housetaxtd1').show();
									$('#housetaxtd2').show();
									$('#tr1').show();
									$('#tr2').show();
									$('#tr3').show();
									$('#tr4').show();
									$('#tr5').show();
									$('#tr6').show();
									$('#tr7').hide();
									$('#tr8').hide();
									$('#purposetr').hide();
									$('#housepricetd1').html('房产价款(元)：');
									$('#houseareatd1').html('房产建筑面积(平方米)：');
									$('#housepricetd2').attr('colspan','1');
								}
							}" data-validate="p"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>			
						</td>
						<td align="right" id="houseareatd1">房产建筑面积(平方米)：</td>
						<td>
							<input class="easyui-numberbox"  id="housearea"  name="housearea" data-options="min:1,precision:2" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
						</td>
					</tr>
					<tr id="tr_other" style="display:none">
						<td align="right" id="housepricetd1" >房产价款(元)：</td>
						<td id="housepricetd2">
							<input class="easyui-numberbox"  id="houseprice"  name="houseprice" data-options="min:0,precision:2" value="0.00"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>	
						</td>
						<td align="right" id="housetaxtd1">交易相关税费(元)：</td>
						<td id="housetaxtd2">
							<input class="easyui-numberbox"  id="housetax"  name="housetax" data-options="min:0,precision:2" value="0.00"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>	
						</td>
					</tr>
					<tr id="tr_build" >
						<td align="right">房产建筑安装成本(元)：</td>
						<td>
							<input class="easyui-numberbox"  id="buildingcost"  name="buildingcost" data-options="min:0,precision:2"  value="0.00"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
						</td>
						<td align="right">设备价款(元)：</td>
						<td>
							<input class="easyui-numberbox"  id="devicecost"  name="devicecost" data-options="min:0,precision:2"  value="0.00"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
						</td>
					</tr>
					<tr id="purposetr">
						<td align="right" >房屋类型：</td>
						<td colspan="3">
							<input class="easyui-combobox"  id="purpose"  name="purpose"/>
						</td>
					</tr>
					<tr>
						<td align="right">投入使用日期：</td>
						<td>
							<input id="usedate" class="easyui-datebox" name="usedate" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
						</td>
						<td align="right">详细地址：</td>
						<td>
							<input class="easyui-validatebox"  id="detailaddress"  name="detailaddress" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
						</td>
					</tr>
					<tr>
						<td align="right">所属乡（镇、街道办）：</td>
						<td>
							<input class="easyui-combobox"  id="countrytown"  name="countrytown" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>				
						</td>
						<td align="right">所属村（居）委会：</td>
						<td>
							<input class="easyui-combobox"  id="belongtowns"  name="belongtowns" data-options="disabled:false,panelWidth:200,panelHeight:200" data-validate="p"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
						</td>
					</tr>
					<tr id="tr1">
						<td align="right">房产权属类型：</td>
						<td>
							<input class="easyui-combobox"  id="housecertificatetype"  name="housecertificatetype"/>				
						</td>
						<td align="right">设计用途：</td>
						<td>
							<input class="easyui-validatebox"  id="designapplication"  name="designapplication" />					
						</td>
					</tr>
					<tr id="tr2">
						<td align="right">房产权属证号：</td>
						<td>
							<input id="housecertificate" class="easyui-validatebox" type="text" name="housecertificate"/>					
						</td>
						<td align="right">填发日期：</td>
						<td>
							<input id="housecertificatedate" class="easyui-datebox" type="text" name="housecertificatedate"/>					
						</td>
					</tr>
					<tr id="tr3">
						<td align="right">产别：</td>
						<td>
							<input class="easyui-combobox"  id="productionlevel"  name="productionlevel"/>					
						</td>
						<td align="right">幢号：</td>
						<td>
							<input id="buildingnumber" class="easyui-validatebox"  name="buildingnumber" />					
						</td>
					</tr>
					<tr id="tr4">
						<td align="right">房号：</td>
						<td>
							<input class="easyui-validatebox"  id="housenumber"  name="housenumber"/>					
						</td>
						<td align="right">结构：</td>
						<td>
							<input id="housestructure" class="easyui-validatebox"  name="housestructure" />					
						</td>
					</tr>
					<tr id="tr5">
						<td align="right">房屋总层数：</td>
						<td>
							<input class="easyui-numberbox"  id="sumplynumber"  name="sumplynumber" data-options="min:1" />					
						</td>
						<td align="right">所在层数：</td>
						<td>
							<input class="easyui-numberbox"  id="plynumber"  name="plynumber" data-options="min:1" />					
						</td>
					</tr>
					<tr id="tr6">
						<td align="right">建房注册号：</td>
						<td>
							<input id="registrationnumber" class="easyui-validatebox" type="text" name="registrationnumber"/>					
						</td>
						<td align="right">权属性质：</td>
						<td>
							<input class="easyui-validatebox"  id="natureofproperty"  name="natureofproperty" />					
						</td>
					</tr>
					<tr id="tr7">
						<td align="right">出租方计算机编码：</td>
						<td>
							<input class="easyui-validatebox"  id="lessorid"  name="lessorid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
							<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="querylessor()">查询</a>
						</td>
						<td align="right">出租方名称：</td>
						<td>
							<input id="lessortaxpayername" class="easyui-validatebox"  name="lessortaxpayername" />					
						</td>
					</tr>
					<tr id="tr8">
						<td align="right">出租方联系人：</td>
						<td>
							<input class="easyui-validatebox"  id="lessorcontact"  name="lessorcontact"/>					
						</td>
						<td align="right">出租方联系方式：</td>
						<td>
							<input id="lessortel" class="easyui-validatebox"  name="lessortel" />					
						</td>
					</tr>
					</div>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;" id="otherOperDiv">  
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveHouse()">保存</a>
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="inputreset()">清除所有数据</a>
	    	</div>
	    	<div id="gridtoolbar" style="height:25px;display:none">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openUpdate(true)">修改</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="cancelHouse(true)">删除</a>
			</div>
	    	<table id="datagrid_house"  class="easyui-datagrid" style="overflow: scroll;"
					data-options="iconCls:'icon-viewdetail',singleSelect:true,pageList:[15],title:'房产信息'">
					<thead>
							<th data-options="checkbox:true"></th>
							<th data-options="field:'houseid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
							<th data-options="field:'statename',width:100,align:'center',editor:{type:'validatebox'}">审核状态</th>
							<th data-options="field:'housesourcename',width:80,align:'left',editor:{type:'validatebox'}">房产来源</th>
							<th data-options="field:'housearea',width:90,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">建筑面积</th>
							<th data-options="field:'housecertificate',width:100,align:'left',editor:{type:'validatebox'}">房产权属证号</th>
							<th data-options="field:'usedate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">投入使用时间</th>
							<th data-options="field:'housetaxoriginalvalue',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">房产原值</th>
					</thead>
				</table>
		    </div> 
		    
	   </div>
	</div>
	
	
	<div id="houseregisterquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产登记查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:800px;height:260px;" data-close="autoclose">
			<form id="houseregisterqueryform" method="post">
				<table id="narjcxx" width="100%"   class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode"  style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
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
						<td align="right">计算机编码：</td>
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="taxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px" name="taxpayername"/>
						</td>

					</tr>
					<tr>
						<td align="right">详细地址：</td>
						<td><input id="detailaddress" class="easyui-validatebox" type="text" style="width:200px" name="detailaddress"/></td>
						<td align="right">房产权属证号：</td>
						<td>
							<input id="housecertificate" class="easyui-validatebox" type="text" style="width:200px" name="housecertificate"/>
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
						<td align="right">投入使用日期：</td>
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