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
	
    var currentform = null;
    var currenttype = null;  //0为使用中，1 为自建
     CommonUtils.enableAjaxProgressBar();
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
		   
		   CommonUtils.getCacheCodeFromTable('COD_HOUSESOURCECODE','housesourcecode','housesourcename','#selfhouseinfoform #housesource'," and housesourcecode='01' ");
		   CommonUtils.getCacheCodeFromTable('COD_HOUSECERTIFICATETYPE','housecertificatetypecode',
			                                 'housecertificatetypename','#selfhouseinfoform #housecertificatetype',"and valid='01' ");
		   CommonUtils.getCacheCodeFromTable('COD_GROUNDTYPECODE','groundtypecode',
			                                 'groundtypename','#selfhouseinfoform #productionlevel');
		   //////////////////////countrytown,belongtowns
		   CommonUtils.getCacheCodeFromTable('COD_HOUSESOURCECODE','housesourcecode','housesourcename','#otherhouseinfoform #housesource',
			                                  " and housesourcecode in ('02','03','04','05','06','99') ");
		   CommonUtils.getCacheCodeFromTable('COD_HOUSECERTIFICATETYPE','housecertificatetypecode',
			                                 'housecertificatetypename','#otherhouseinfoform #housecertificatetype',"and valid='01' ");
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
			onDblClickRow:dbclickevent
		   });
		   var p = $('#houseregistergrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});

		   
	});
	    function dbclickevent(rowindex,rowdata){
	    	detailoper(rowindex,rowdata,true)
	    }
	    function detailoper(rowindex,rowdata,hideoperbtn){
	    	       var housetype = rowdata.housetype;
	    	       currenttype = housetype == "1" ? "1" : "0";
	    	       currentform = housetype == "1" ? "selfhouseaddwindow" : "otherhouseaddwindow";
				   $('#'+currentform).form('clear');
				   
				   
				   
				   $.ajax({
					  type: "get",
					  async:false,
					  cache:false,
					  url: "/houseregister/get.do?d="+new Date(),
					  data: {'key':rowdata.houseid,'houseregistertype':currenttype},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  var basehousebo = jsondata.result;
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
							  
							  if(currenttype == "0"){
								  $('#otherhouseinfoform #belongtowns').combobox('setValue',basehousebo.belongtowns);  
							  }
							  if(currenttype=='1'){
								  var estateinfo = jsondata.result.estateList;
							      $('#landinfogrid').datagrid('loadData',estateinfo);
							  }
							  
							  
							  
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
								  
							  });
						  }
					  }
			      });
				   
				   if(currenttype == '1'){
					   
					   if(hideoperbtn) {
						   $('#selectlandtb').hide();
						   $('#selfOperDiv').hide();
						   $('#selfhouseaddwindow').window({title:'自建房、在建竣工房产登记查看'});
				           $('#selfhouseaddwindow').window('open');
					   }
					   else {
						   $('#selectlandtb').show();
						   $('#selfOperDiv').show();
						   $('#selfhouseaddwindow').window({title:'自建房、在建竣工房产登记修改'});
				           $('#selfhouseaddwindow').window('open');
					   }
				       
				   }else if(currenttype == '0'){
					   if(hideoperbtn) {
						   $('#otherOperDiv').hide();
					       $('#otherhouseaddwindow').window({title:'其它房产登记查看'});
				           $('#otherhouseaddwindow').window('open');
					   }
					   else{
						   $('#otherOperDiv').show();
						   $('#otherhouseaddwindow').window({title:'其它房产登记修改'});
				           $('#otherhouseaddwindow').window('open');
					   } 
					   
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

		//新增自建房开始。。。。。 
		function openSelfHouseAdd(){
			$('#selfhouseinfoform #housesource').combobox('setValue','01');
			$('#selfOperDiv').show();
			$('#selectlandtb').show();
			$('#selfhouseaddwindow').window({title:'自建房、在建竣工房产登记新增'});
			$('#selfhouseaddwindow').window('open');
			
		}
		function chooseTaxpayer(){
			WidgetUtils.showChooseTaxpayerInfo(function(rowIndex,rowData){
				$('#'+currentform+' #taxpayerid').val(rowData.taxpayerid);
				$('#'+currentform+' #taxpayername').val(rowData.taxpayername);
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
		function clearAllSelfData(){
			if(currenttype == "0"){
				$('#'+currentform).form('clear');
				return;
			}
			$('#'+currentform).form('clear');
			$('#'+currentform+' #housesource').combobox('setValue','01');
			//删除estate
			var rows = $('#landinfogrid').datagrid('getRows');
			for(var index = rows.length-1;index >= 0;index--){
				$('#landinfogrid').datagrid('deleteRow',index);
			}
		}
		function saveSelfHouse(){
			if(!$('#selfhouseinfoform #taxpayerid').val()){
				$.messager.alert('警告','计算机编码不能为空','info',function(){
					$('#selfhouseinfoform #taxpayerid').focus();
				});
				$('#selfaccordiondiv').accordion('select',0);
				return false;
			}
			if(!$('#selfhouseinfoform #taxpayername').val()){
				$.messager.alert('警告','纳税人名称不能为空','info',function(){
					$('#selfhouseinfoform #taxpayername').focus();
				});
				$('#selfaccordiondiv').accordion('select',0);
				return false;
			}
			var result = validateFormData();
			if(!result)
				return false;
			
			//验证土地信息
			var rows = $('#landinfogrid').datagrid('getRows');
			if(rows.length == 0){
				$.messager.alert('警告','此房产必须选择所关联的土地','info',function(){
				});
				$('#selfaccordiondiv').accordion('select',1);
				return false;
			}
			var estateids = '';
			for(var i = 0;i < rows.length;i++){
				var row = rows[i];
				estateids += row.estateid+',';
			}
			if(estateids)   estateids = estateids.substr(0,estateids.length-1);
			var params = {};
			var fields =$('#selfhouseinfoform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['estateids'] = estateids;
			params['houseregistertype'] = '1';
			
			var houseid = $('#selfhouseinfoform #houseid').val();
			var operurl = "/houseregister/add.do?d="+new Date();
			var infomessage = '新增房产登记成功';
			if(houseid){
				operurl = "/houseregister/update.do?d="+new Date();
				infomessage = '修改房产登记成功';
			}
			$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: operurl,
					  data: params,
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息',infomessage,'info',function(){
								  $('#selfhouseaddwindow').window('close');
								  query();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			   });
		}
		//新增自建房结束
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//新增其他登记开始
		function openOtherAdd(){
			$('#otherOperDiv').show();
			$('#otherhouseaddwindow').window({title:'其它房产登记新增'});
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
			if(!$('#otherhouseinfoform #taxpayerid').val()){
				$.messager.alert('警告','计算机编码不能为空','info',function(){
					$('#otherhouseinfoform #taxpayerid').focus();
				});
				return false;
			}
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
					  type: "get",
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
       function openUpdate(){
    	   var row = $('#houseregistergrid').datagrid('getSelected');
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要修改的房产登记信息!','info');
    		   return false;
    	   }
    	   if(row.state == '0'){
    		   detailoper(null,row,false);
    	   }else{
    		   $.messager.alert('提示消息','只有状态为初始状态的房产所有权转移信息才能修改!','info');
    	   }
       }
       function cancelHouse(){
    	   var row = $('#houseregistergrid').datagrid('getSelected');
    	   if(row == null){
    		   $.messager.alert('提示消息','请选择需要废除的房产登记信息!','info');
    		   return false;
    	   }
    	   var type = row.housetype == "1" ? "1" : "0";
    	   $.messager.confirm('确认', '你确认废除当前的房产登记信息？', function(r){
				if (r){
					$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/houseregister/cancel.do?d="+new Date(),
					  data: {'key':row.houseid,"houseregistertype":type},
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息','废除房产登记信息成功','info',function(){
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
					  type: "get",
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
			params['businesstype'] = '72';
			params['houseregistertype'] = '1';
			
			params['propNames'] = 'statename,taxpayerid,taxpayername,housesourcename,housecertificatetypename,housecertificate,usedate,housearea,'+
			               'buildingcost,devicecost,landprice,plotratio,housetaxoriginalvalue,housetax,houseprice';
			params['colNames'] = '状态,计算机编码,纳税人名称,房产来源,房产证类型,房产证号,投入使用日期,房产建筑面积,房产建筑安装成本,设备价款,'+
                                 '地价款,容积率,房产原值,交易相关税费,房屋价款';
			params['modelName']="房产登记";
			
			CommonUtils.downloadFile("/houseregister/houseregexport.do?date="+new Date(),params);
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
						<th data-options="field:'statename',width:80,align:'center',editor:{type:'validatebox'}">状态</th>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:220,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'housesourcename',width:120,align:'center',editor:{type:'validatebox'}">房产来源</th>
						<th data-options="field:'housecertificatetypename',width:150,align:'center',editor:{type:'validatebox'}">房产证类型</th>
						<th data-options="field:'housecertificate',width:150,align:'center',editor:{type:'validatebox'}">房产证号</th>
						<th data-options="field:'usedate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">投入使用日期</th>
						<th data-options="field:'housearea',width:120,align:'center',editor:{type:'validatebox'}">房产建筑面积</th>
						<th data-options="field:'buildingcost',hidden:true,width:120,align:'center',editor:{type:'validatebox'}">房产建筑安装成本</th>
						<th data-options="field:'devicecost',hidden:true,width:120,align:'center',editor:{type:'validatebox'}">设备价款</th>
						<th data-options="field:'landprice',hidden:true,width:120,align:'center',editor:{type:'validatebox'}">地价款</th>
						<th data-options="field:'plotratio',hidden:true,width:120,align:'center',editor:{type:'validatebox'}">容积率</th>
						
						<th data-options="field:'housetaxoriginalvalue',width:120,align:'center',editor:{type:'validatebox'}">房产原值</th>
						<th data-options="field:'housetax',hidden:true,width:120,align:'center',editor:{type:'validatebox'}">交易相关税费</th>
						<th data-options="field:'houseprice',hidden:true,width:120,align:'center',editor:{type:'validatebox'}">房屋价款</th>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a href="#" style="display:none" class="easyui-linkbutton" data-options="iconCls:'icon-business5',plain:true" onclick="openSelfHouseAdd()">自建房、在建竣工房产登记</a>
				<a href="#" style="display:none" class="easyui-linkbutton" data-options="iconCls:'icon-business1',plain:true" onclick="openOtherAdd()">其它登记</a>
				<a href="#" style="display:none" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openUpdate()">修改</a>
				<a href="#" style="display:none" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="cancelHouse()">废除</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="checkHouse(1)">审核</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-uncheck',plain:true" onclick="checkHouse(0)">取消审核</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportExcel()">导出</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">退出</a>
			</div>
		</div>
	</div>
	<div id="selfhouseaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'自建房、在建竣工房产登记',collapsible:false,
	minimizable:false,maximizable:false,closable:true,onOpen:function(){
         currentform='selfhouseinfoform';
		 currenttype='1';
    }" style="width:815px;height:530px;" data-close="autoclose">
	    <div id="selfaccordiondiv" class="easyui-accordion" style="width:800px;height:460px;">  
		    <div id="housepanel" title="房产信息" data-options="selected:true" 
		    style="overflow:auto;padding:10px;">  
		       <form id="selfhouseinfoform" method="post">
					<input type="hidden"  id="locationtype"  name="locationtype" value="" />	
					<input type="hidden"  id="houseid"  name="houseid" />
				<table id="narjcxx1x" width="100%"  cellpadding="3" cellspacing="0">
					<tr>
					    <td align="right">计算机编码：</td>
						<td>
							<input id="taxpayerid" class="easyui-validatebox" name="taxpayerid"  readonly="true" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" name="taxpayername" readonly="true" data-validate="p"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseTaxpayer()" 
							   style="color: blue;font-weight: bold;">选择纳税人</a>				
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-combobox"  id="housesource"  name="housesource" data-validate="p"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>			
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-numberbox"  id="housearea"  name="housearea" data-options="min:1,precision:2" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
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
						<td align="right">房产建筑安装成本：</td>
						<td>
							<input class="easyui-numberbox"  id="buildingcost"  name="buildingcost" data-options="min:0,precision:2" data-validate="p"/>
						</td>
						<td align="right">设备价款：</td>
						<td>
							<input class="easyui-numberbox"  id="devicecost"  name="devicecost" data-options="min:0,precision:2" data-validate="p"/>
						</td>
					</tr>
					<tr>
						<td align="right">房产证类型：</td>
						<td>
							<input class="easyui-combobox"  id="housecertificatetype"  name="housecertificatetype"/>				
						</td>
						<td align="right">房产证号：</td>
						<td>
							<input id="housecertificate" class="easyui-validatebox" type="text" name="housecertificate"/>					
						</td>
					</tr>
					<tr>
						<td align="right">填发日期：</td>
						<td>
							<input id="housecertificatedate" class="easyui-datebox" type="text" name="housecertificatedate"/>					
						</td>
						<td align="right">产别：</td>
						<td>
							<input class="easyui-combobox"  id="productionlevel"  name="productionlevel"/>					
						</td>
					</tr>
					<tr>
						<td align="right">幢号：</td>
						<td>
							<input id="buildingnumber" class="easyui-validatebox"  name="buildingnumber" />					
						</td>
						<td align="right">房号：</td>
						<td>
							<input class="easyui-validatebox"  id="housenumber"  name="housenumber"/>					
						</td>
					</tr>
					<tr>
						<td align="right">结构：</td>
						<td>
							<input id="housestructure" class="easyui-validatebox"  name="housestructure" />					
						</td>
						<td align="right">房屋总层数：</td>
						<td>
							<input class="easyui-numberbox"  id="sumplynumber"  name="sumplynumber" data-options="min:1" />					
						</td>
					</tr>
					<tr>
						<td align="right">所在层数：</td>
						<td>
							<input class="easyui-numberbox"  id="plynumber"  name="plynumber" data-options="min:1" />					
						</td>
						<td align="right">设计用途：</td>
						<td>
							<input class="easyui-validatebox"  id="designapplication"  name="designapplication" />					
						</td>
					</tr>
					<tr>
					    <td align="right">建房注册号：</td>
						<td>
							<input id="registrationnumber" class="easyui-validatebox" type="text" name="registrationnumber"/>					
						</td>
						<td align="right">权属性质：</td>
						<td>
							<input class="easyui-validatebox"  id="natureofproperty"  name="natureofproperty" />					
						</td>
					</tr>
				</table>
			</form>
		    </div>  
		    <div id="landpanel" title="土地信息" >  
		      <table id='landinfogrid' class="easyui-datagrid" style="width:99;height:407px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[8],toolbar:'#selectlandtb'">
				<thead>
				    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
					<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
					<th data-options="field:'taxpayername',width:215,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
					<th data-options="field:'estateserialno',width:100,align:'left',editor:{type:'validatebox'}"/>宗地编号</th>
					<th data-options="field:'landcertificatetypename',width:175,align:'left',editor:{type:'validatebox'}">土地证类型</th>
					<th data-options="field:'landcertificate',width:175,align:'center',editor:{type:'validatebox'}">土地证号</th>
					<th data-options="field:'locationtypename',width:175,align:'center',editor:{type:'validatebox'}">坐落地类型</th>
					<th data-options="field:'belongtocountryname',width:175,align:'center',editor:{type:'validatebox'}">所属村委会</th>
					<th data-options="field:'detailaddress',width:250,align:'center',editor:{type:'validatebox'}">详细地址</th>
					<th data-options="field:'holddate',width:120,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">交互日期</th>
					<th data-options="field:'landmoney',width:120,align:'center',editor:{type:'validatebox'}">土地总价</th>
					<th data-options="field:'landarea',width:120,align:'center',editor:{type:'validatebox'}">土地面积</th>
					<th data-options="field:'landunitprice',width:120,align:'center',editor:{type:'validatebox'}">土地单价</th>
				</thead>
			</table>
		    </div>  
		</div> 
	    <div style="text-align:center;padding:5px;height: 25px;" id="selfOperDiv">  
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveSelfHouse()">保存</a>
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="clearAllSelfData()">清除所有数据</a>
	    </div>
	</div>
	<div id="selectlandtb" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseLand()">选择土地</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteChoosedLand()">删除</a>
			</div>
		</div>
	<!-- 其他登记的DIV  -->
	<div id="otherhouseaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'其它房产登记',collapsible:false,
	minimizable:false,maximizable:false,closable:true,onOpen:function(){
         currentform='otherhouseinfoform';
		 currenttype='0';
    }" style="width:815px;height:450px;" data-close="autoclose">
		    <div id="housepanel" title="房产信息" data-options="selected:true" 
		    style="overflow:auto;padding:10px;">  
		       <form id="otherhouseinfoform" method="post">
					<input type="hidden"  id="locationtype"  name="locationtype" value="" />	
					<input type="hidden"  id="houseid"  name="houseid" />
				<table id="narjcxx1x" width="100%"  cellpadding="3" cellspacing="0">
					<tr>
					    <td align="right">计算机编码：</td>
						<td>
							<input id="taxpayerid" class="easyui-validatebox" name="taxpayerid"  readonly="true" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" name="taxpayername" readonly="true" data-validate="p"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="chooseTaxpayer()" 
							   style="color: blue;font-weight: bold;">选择纳税人</a>				
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-combobox"  id="housesource"  name="housesource"  data-validate="p"/>	
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>			
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-numberbox"  id="housearea"  name="housearea" data-options="min:1,precision:2" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
						</td>
					</tr>
					<tr>
						<td align="right">房产价款：</td>
						<td>
							<input class="easyui-numberbox"  id="houseprice"  name="houseprice" data-options="min:0,precision:2" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>	
						</td>
						<td align="right">交易相关税费：</td>
						<td>
							<input class="easyui-numberbox"  id="housetax"  name="housetax" data-options="min:0,precision:2" data-validate="p"/>
							<span style="color:red;font-weight: bold;font-size: 12pt">*</span>	
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
					
					<tr>
						<td align="right">房产证类型：</td>
						<td>
							<input class="easyui-combobox"  id="housecertificatetype"  name="housecertificatetype"/>				
						</td>
						<td align="right">设计用途：</td>
						<td>
							<input class="easyui-validatebox"  id="designapplication"  name="designapplication" />					
						</td>
					</tr>
					<tr>
						<td align="right">房产证号：</td>
						<td>
							<input id="housecertificate" class="easyui-validatebox" type="text" name="housecertificate"/>					
						</td>
						<td align="right">填发日期：</td>
						<td>
							<input id="housecertificatedate" class="easyui-datebox" type="text" name="housecertificatedate"/>					
						</td>
					</tr>
					<tr>
						<td align="right">产别：</td>
						<td>
							<input class="easyui-combobox"  id="productionlevel"  name="productionlevel"/>					
						</td>
						<td align="right">幢号：</td>
						<td>
							<input id="buildingnumber" class="easyui-validatebox"  name="buildingnumber" />					
						</td>
					</tr>
					<tr>
						<td align="right">房号：</td>
						<td>
							<input class="easyui-validatebox"  id="housenumber"  name="housenumber"/>					
						</td>
						<td align="right">结构：</td>
						<td>
							<input id="housestructure" class="easyui-validatebox"  name="housestructure" />					
						</td>
					</tr>
					<tr>
						<td align="right">房屋总层数：</td>
						<td>
							<input class="easyui-numberbox"  id="sumplynumber"  name="sumplynumber" data-options="min:1" />					
						</td>
						<td align="right">所在层数：</td>
						<td>
							<input class="easyui-numberbox"  id="plynumber"  name="plynumber" data-options="min:1" />					
						</td>
					</tr>
					<tr>
						<td align="right">建房注册号：</td>
						<td>
							<input id="registrationnumber" class="easyui-validatebox" type="text" name="registrationnumber"/>					
						</td>
						<td align="right">权属性质：</td>
						<td>
							<input class="easyui-validatebox"  id="natureofproperty"  name="natureofproperty" />					
						</td>
					</tr>
				</table>
			</form>
		    </div>  
	    <div style="text-align:center;padding:5px;height: 25px;" id="otherOperDiv">  
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveOtherHouse()">保存</a>
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="clearAllSelfData()">清除所有数据</a>
	    </div>
	</div>
	
	
	<div id="houseregisterquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产登记查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;height:230px;" data-close="autoclose">
			<form id="houseregisterqueryform" method="post">
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
					
					<tr style="display:none;">
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
						<td align="right">详细地址：</td>
						<td><input id="detailaddress" class="easyui-validatebox" type="text" name="detailaddress"/></td>
						<td align="right">房产证号：</td>
						<td>
							<input id="housecertificate" class="easyui-validatebox" type="text" name="housecertificate"/>
						</td>

					</tr>
					<tr>
						<td align="right">投入使用日期：</td>
						<td colspan="5">
							<input id="usedatebegin" class="easyui-datebox" name="usedatebegin"/>
						至
							<input id="usedateend" class="easyui-datebox"  name="usedateend"/>
						</td>
					</tr>
					<tr>
						<td align='right'>状态</td>
						<td colspan='5'>
							<select class='easyui-combobox' name ='state' id='state'>
								<option value=''></option>
								<option value='0'>初始化</option>
								<option value='1'>已审核</option>
								<option value='2'>存在后续业务</option>
								<option value='3'>已终审</option>
							</select>
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