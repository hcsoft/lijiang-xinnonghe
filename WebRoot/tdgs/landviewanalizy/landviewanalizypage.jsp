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
	<script src="<%=spath%>/js/datagrid-detailview.js"></script>
    
   
</head>
<body>
      <script>
	function formatterDate(value,row,index){
			return formatDatebox(value);
    }
	
    var managerLink = new OrgLink();
    managerLink.sendMethod = true;

	$(function(){
		    managerLink.loadData();
		    $('#queryform #countrytown').combobox({
			   onSelect:function(data){
			      CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#queryform #belongtowns'," and parentid = '"+data.key+"' ",true);
			   }
		   });
		   CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#queryform #countrytown'," and parentid = '530122' ",true);
		    //获取坐落地类型
		    /*
		    $('#mainWestDiv').bind('mouseover',function(e){
		    	alert(e);
		    });
		    */
		    $.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/ComboxService/getComboxs.do?d="+new Date(),
					  data: {"codetablename":"COD_LOCATIONTYPE"},
					  dataType: "json",
					  success:function(jsondata){
						  $('#locationtype').combobox({
						       data : jsondata,
                               valueField:'key',
                               textField:'keyvalue'
					      });
					  }
			});

			$('#estategrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				onClickRow:getInfo,
				onLoadSuccess:function(data){
				    var rows = $('#estategrid').datagrid('getRows');
			        if(rows.length > 0){
			        	$('#estategrid').datagrid('selectRow',0);
			        	var row = $('#estategrid').datagrid('getSelected');
			        	getInfo(0,row);
			        }
				}
			});
				 
			p = $('#estategrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			$('#estategrid').datagrid('selectRow',0); 
			
			var firstDay = DateUtils.getYearFirstDay();
			var lastDay = DateUtils.getCurrentDay();
		     $('#beginholddate').datebox('setValue',firstDay);
		     $('#endholddate').datebox('setValue',lastDay);
		     
		});
	  
	    function getCondition(){
	    	    var params = {};
			    var fields =$('#queryform').serializeArray();
			    $.each( fields, function(i, field){
				    params[field.name] = field.value;
			    });
			    return params;
	    }
	    function clearData(){
	    	$('#taxsourcemaingrid').datagrid('loadData',[]);
			$('#housetaxsourcemaingrid').datagrid('loadData',[]);
			$('#shouldtaxmaingrid').datagrid('loadData',[]);
			$('#shouldtaxmaingrid1').datagrid('loadData',[]);
	    }
		function query(){
			clearData();
			var params = getCondition();
			params['businesstype'] = '1';
			var opts = $('#estategrid').datagrid('options');
			opts.url = '/viewanalizy/selectanalizysource.do?d='+new Date();
			$('#estategrid').datagrid('load',params); 
			var p = $('#estategrid').datagrid('getPager');  
			
			
			$(p).pagination({   
				showPageList:false
			});
			$('#querywindow').window('close');			
		}
		function openQuery(){
			$('#querywindow').window('open');
		}
		
		function getInfo(rowIndex,row){
           clearData();
		   var paramsArg = {};
		   paramsArg['businesstype'] = '1';
		   paramsArg['estateid'] = row.estateid;
		   
		   var opts = $('#taxsourcemaingrid').datagrid('options');
		   opts.url = '/viewanalizy/selectlandtaxsource.do?d='+new Date();
		   $('#taxsourcemaingrid').datagrid('load',paramsArg); 
		   
		   var opts = $('#housetaxsourcemaingrid').datagrid('options');
		   opts.url = '/viewanalizy/selecthousetaxsource.do?d='+new Date();
		   $('#housetaxsourcemaingrid').datagrid('load',paramsArg);
		   
		   opts = $('#shouldtaxmaingrid').datagrid('options');
		   opts.url = '/viewanalizy/selectshouldtaxyeartax.do?d='+new Date();
		   $('#shouldtaxmaingrid').datagrid('load',paramsArg); 
		   
		   opts = $('#shouldtaxmaingrid1').datagrid('options');
		   opts.url = '/viewanalizy/selectshouldtaxyeartaxpayer.do?d='+new Date();
		   $('#shouldtaxmaingrid1').datagrid('load',paramsArg); 
		   
		   $('#taxsourcemaingrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true
			});
				 
			p = $('#taxsourcemaingrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			
			$('#housetaxsourcemaingrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true
			});
				 
			p = $('#housetaxsourcemaingrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
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
		var expandGrid = null;
		var expandIndex = null;
		$(function(){
			$('#tabpanelDiv').tabs({
				onSelect:function(title,index){
				     if(index == 2){
				    	 
				     }
				}
			});
			$('#shouldtaxdetailDiv').window({
				onClose:function(){
				   if(expandGrid != null && expandIndex != null){
					   expandGrid.datagrid('collapseRow',expandIndex);
					   expandGrid = null;
		               expandIndex = null;
				   }
				}
			});
			//初始化应纳税情况
			$('#shouldtaxmaingrid').datagrid(
			   {
				   view:detailview,
				   detailFormatter:function(index,row){
                      return "<div style='padding:2px;' ><table id='ddvv-" + index + "' class='easyui-datagrid'>" +
                      "</table></div>";
                   },
                   onLoadSuccess:function(data){
                	  
                   },
                   onExpandRow: function(index,row){
                	   if(row.state == 99){
                		   return;
                	   }
                	   expandGrid = $('#shouldtaxmaingrid');
                	   $('#shouldtaxdetailgrid').datagrid('loadData',[]);
                	   expandIndex = index;
                	   $('#shouldtaxdetailDiv').window('open');
                	  var whereCondition = " and taxtypecode = '"+row.taxtypecode+"' and taxcode = '"+row.taxcode+"' and taxyear = '"+row.year+"' ";
                	  var estateRow = $('#estategrid').datagrid('getSelected');
                	  if(estateRow != null){
                		  var estateid = estateRow.estateid;
                		  var params = {};
                		  params['businesstype'] = '1';
                		  params['whereCondition'] = whereCondition;
						  params['estateid'] = estateid;
						  
						  var opts = $('#shouldtaxdetailgrid').datagrid('options');
						  opts.url = '/viewanalizy/selectshouldtaxdetail.do?d='+new Date();
						  $('#shouldtaxdetailgrid').datagrid('load',params); 
                	  }
                      $('#shouldtaxmaingrid').datagrid('fixDetailRowHeight',index);
                   }
			   }	
		    );
                	 
			/////////////////////////////////////////////////////////////
			$('#shouldtaxmaingrid1').datagrid(
			   {
				   view:detailview,
				   detailFormatter:function(index,row){
                      return '<div style="padding:2px;" ><table id="dddvv-' + index + '"></table></div>';
                   },
                   onExpandRow: function(index,row){
                	   if(row.state == 99){
                		   return;
                	   }
                	   $('#shouldtaxdetailgrid').datagrid('loadData',[]);
                	   expandGrid = $('#shouldtaxmaingrid1');
                	   expandIndex = index;
                	   $('#shouldtaxdetailDiv').window('open');
                	  var whereCondition = " and taxpayerid = '"+row.taxpayerid+"'  and taxyear = '"+row.year+"' ";
                	  var estateRow = $('#estategrid').datagrid('getSelected');
                	  if(estateRow != null){
                		  var estateid = estateRow.estateid;
                		  var params = {};
                		  params['businesstype'] = '1';
                		  params['whereCondition'] = whereCondition;
						  params['estateid'] = estateid;
						  var opts = $('#shouldtaxdetailgrid').datagrid('options');
						  opts.url = '/viewanalizy/selectshouldtaxdetail.do?d='+new Date();
						  $('#shouldtaxdetailgrid').datagrid('load',params); 
						 
                	  }
                   }
			   }	
		    );
		});
	</script>
     <div class="easyui-layout" style="width:100%;height:580px;" data-options="split:true" id="layoutDiv" >
	     <div class="easyui-tabs" data-options="region:'center'" id="tabpanelDiv">
				<div title="土地税源信息" style="padding:10px">
					 <table id='taxsourcemaingrid' class="easyui-datagrid" style="height:500px;overflow: hidden;"
					      data-options="iconCls:'icon-edit',singleSelect:true">
						<thead>
							<tr>
								<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
								<th data-options="field:'taxpayername',width:230,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
								<th data-options="field:'taxrate',width:100,align:'center',editor:{type:'validatebox'}">单位税额</th>
								<th data-options="field:'landarea',width:100,align:'center',editor:{type:'validatebox'}">计税面积</th>
								<th data-options="field:'taxdatebegin',width:100,align:'center',editor:{type:'validatebox'},formatter:formatterDate">计税起日期</th>
								<th data-options="field:'taxdateend',width:100,align:'center',editor:{type:'validatebox'},formatter:formatterDate">计税止日期</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="房产税源信息" style="padding:10px">
					 <table id='housetaxsourcemaingrid' class="easyui-datagrid" style="height:500px;overflow: hidden;"
					      data-options="iconCls:'icon-edit',singleSelect:true">
						<thead>
							<tr>
								<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
								<th data-options="field:'taxpayername',width:230,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
								<th data-options="field:'housetaxoriginalvalue',width:100,align:'center',editor:{type:'validatebox'}">计税原值</th>
								<th data-options="field:'houselandmoney',width:100,align:'center',editor:{type:'validatebox'}">分摊土地价款</th>
								<th data-options="field:'houseresidualvalue',width:100,align:'center',editor:{type:'validatebox'}">房产余值</th>
								<th data-options="field:'transmoney',width:100,align:'center',editor:{type:'validatebox'}">年租金</th>
								<th data-options="field:'housearea',width:100,align:'center',editor:{type:'validatebox'}">房产建筑面积</th>
								<th data-options="field:'taxdatebegin',width:100,align:'center',editor:{type:'validatebox'},formatter:formatterDate">计税起日期</th>
								<th data-options="field:'taxdateend',width:100,align:'center',editor:{type:'validatebox'},formatter:formatterDate">计税止日期</th>
							</tr>
						</thead>
					</table>
				</div>
				
				<div title="应纳税信息(按年份，税种、税目)" style="padding:10px">
					<table id='shouldtaxmaingrid' class="easyui-datagrid" style="height:500px;overflow: hidden;"
					      data-options="iconCls:'icon-edit',singleSelect:true">
						<thead>
							<tr>
								<th data-options="field:'year',width:100,align:'center',editor:{type:'validatebox'}">年份</th>
								<th data-options="field:'taxtypename',width:160,align:'center',editor:{type:'validatebox'}">税种</th>
								<th data-options="field:'taxname',width:160,align:'center',editor:{type:'validatebox'}">税目</th>
								<th data-options="field:'taxamount',width:100,align:'center',editor:{type:'validatebox'}">应缴金额</th>
								<th data-options="field:'taxamountactual',width:100,align:'center',editor:{type:'validatebox'}">已缴金额</th>
								<th data-options="field:'owetaxamount',width:100,align:'center',editor:{type:'validatebox'}">欠税金额</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="应纳税信息(按年份，纳税人)" style="padding:10px">
					<table id='shouldtaxmaingrid1' class="easyui-datagrid" style="height:500px;overflow: hidden;"
					      data-options="iconCls:'icon-edit',singleSelect:true">
						<thead>
							<tr>
								<th data-options="field:'year',width:100,align:'center',editor:{type:'validatebox'}">年份</th>
								<th data-options="field:'taxpayerid',width:120,align:'center',editor:{type:'validatebox'}">计算机编码</th>
								<th data-options="field:'taxpayername',width:240,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
								<th data-options="field:'taxamount',width:100,align:'center',editor:{type:'validatebox'}">应缴金额</th>
								<th data-options="field:'taxamountactual',width:100,align:'center',editor:{type:'validatebox'}">已缴金额</th>
								<th data-options="field:'owetaxamount',width:100,align:'center',editor:{type:'validatebox'}">欠税金额</th>
							</tr>
						</thead>
					</table>
				</div>
	    </div>
	   
	    <div data-options="region:'west'" id="mainWestDiv" style="height:553px;width:400px;overflow: hidden;" id="groupDiv" >
	        <table id='estategrid' class="easyui-datagrid" style="height:553px;width:400px;overflow: hidden;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15],
					 onMouseOver:function(e,rowindex,rowData){
					    //设置数据
					    if(rowData){
							    $('#landinfoform input[data-validate=\'p\']').each(function(){
							    	var id = this.id;
							    	
							    	var value = rowData[id];
							    	if(id == 'holddate'){
							    	   value=formatterDate(value);
							    	}
							    	$(this).val(value);
							    });
						}
					    //
					    var landinfowindowHeight = 175;
					    var leftPos = $(e.target).offset().left;
					    var topPos = $(e.target).offset().top+40;
					    var windowHeight = $(window).height();
					    if(topPos+landinfowindowHeight <= windowHeight){
					       $('#landinfowindow').parent().css('left',leftPos+'px').css('top',topPos+'px');
					       $('#landinfowindow').parent().show();
					    }
					    else{
					       var newTop = topPos-40-landinfowindowHeight-40;
					       $('#landinfowindow').parent().css('left',leftPos+'px').css('top',newTop+'px');
					       $('#landinfowindow').parent().show();
					    }
					    
					    
					 },
					 onMouseOut:function(){
					     $('#landinfowindow').parent().hide();
					 }
					 ">
				<thead>
					<tr>
					    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
						<th data-options="field:'estateserialno',width:120,align:'center',editor:{type:'validatebox'}">宗地编号</th>
						<th data-options="field:'landcertificate',width:120,align:'center',editor:{type:'validatebox'}">土地证号</th>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:175,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'locationtypename',width:175,align:'center',editor:{type:'validatebox'}">坐落地类型</th>
						<th data-options="field:'belongtownname',width:175,align:'center',editor:{type:'validatebox'}">所属村委会</th>
						<th data-options="field:'holddate',width:175,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">交付日期</th>
						<th data-options="field:'landarea',width:175,align:'center',editor:{type:'validatebox'}">土地面积</th>
						<th data-options="field:'landunitprice',width:175,align:'center',editor:{type:'validatebox'}">土地单价</th>
					</tr>
				</thead>
			</table>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询土地</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">退出</a>
			</div>
		</div>
	</div>
	<div id="querywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;height:230px;">
			<form id="queryform" method="post">
				<table id="narjcxx" width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
				  
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
					
					<tr style="display: none;">
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
						<td align="right">房产所属乡镇：</td>
						<td>
							<input class="easyui-combobox"  id="countrytown"  name="countrytown" data-validate="p"/>			
						</td>
						<td align="right">所属村委会：</td>
						<td>
							<input class="easyui-combobox"  id="belongtowns"  name="belongtowns" data-options="disabled:false,panelWidth:200,panelHeight:200" data-validate="p"/>	
						</td>
					</tr>
					
					<tr>
						<td align="right">坐落地类型：</td>
						<td colspan="3">
							<input class="easyui-combobox" name="locationtype" id="locationtype" data-options="disabled:false,panelWidth:200,panelHeight:200"/>					
						</td>
						
					</tr>
					
					<tr>
						<td align="right">交付日期：</td>
						<td colspan="5">
							<input id="beginholddate" class="easyui-datebox" name="beginholddate"/>
						至
							<input id="endholddate" class="easyui-datebox"  name="endholddate"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
	</div>
	<div id="shouldtaxdetailDiv" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税明细',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:960px;height:450px;" > 
	    <table id='shouldtaxdetailgrid' class="easyui-datagrid" style="height:412px;width:942px;overflow: hidden;"
					data-options="iconCls:'icon-edit',singleSelect:true">
				<thead>
					<tr>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:230,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxtypename',width:110,align:'left',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',width:110,align:'left',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'begindate',width:80,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">计税起日期</th>
						<th data-options="field:'enddate',width:80,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">计税止日期</th>
						<th data-options="field:'subtaxamount',width:80,align:'left',editor:{type:'validatebox'}">应缴金额</th>
						<th data-options="field:'subtaxamountactual',width:80,align:'left',editor:{type:'validatebox'}">实缴金额</th>
						<th data-options="field:'subowetaxamount',width:80,align:'center',editor:{type:'validatebox'}">欠税金额</th>
						<th data-options="field:'levydatetypename',hidden:true,width:80,align:'left',editor:{type:'validatebox'}">征期类型</th>
						<th data-options="field:'derateflagname',width:80,align:'left',editor:{type:'validatebox'}">类型</th>
						
					</tr>
				</thead>
		</table>
	</div>
	
	<div id="landinfowindow" class="easyui-window" data-options="noheader:true,closed:true,collapsible:false,minimizable:false,maximizable:false,closable:false" 
	style="width:250px;height:180px;">
			<form id="landinfoform" method="post">
				<table id="landinfotb" width="100%"  cellpadding="0" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse;">
					<tr>
						<td align="right">纳税人名称：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayername" id="taxpayername" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">坐落地类型：</td>
						<td>
							<input class="easyui-validatebox" name="locationtypename" id="locationtypename" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">所属村委会：</td>
						<td>
							<input class="easyui-validatebox" name="belongtownname" id="belongtownname" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">交付日期：</td>
						<td>
							<input class="easyui-validatebox" name="holddate" id="holddate" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">土地面积：</td>
						<td>
							<input class="easyui-validatebox" name="landarea" id="landarea" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">土地单价：</td>
						<td>
							<input class="easyui-validatebox" name="landunitprice" id="landunitprice" data-validate="p"/>					
						</td>
					</tr>
					
				</table>
			</form>
	</div>
	
	  
</body>
</html>