<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

<title>Complex Layout - jQuery EasyUI Demo</title>

<link rel="stylesheet" href="/themes/sunny/easyui.css">
<link rel="stylesheet" href="/themes/icon.css">
<link rel="stylesheet" href="/css/toolbar.css">
<link rel="stylesheet" href="/css/logout.css"/>
<link rel="stylesheet" href="/css/tablen.css"/>
<script src="/js/jquery-1.8.2.min.js"></script>
<script src="/js/jquery.easyui.min.js"></script>
<script src="/js/tiles.js"></script>
<script src="/js/moduleWindow.js"></script>
<script src="/menus.js"></script>

<script src="/js/jquery.simplemodal.js"></script>
<script src="/js/overlay.js"></script>
<script src="/js/jquery.json-2.2.js"></script>
<script src="/js/json2.js"></script>
<script src="/locale/easyui-lang-zh_CN.js"></script>
<script src="/js/FusionCharts.js"></script>
<script>
var taxdata = new Object;
var taxtypecodedata = new Array();
var taxcodedata = new Array();
var opttype;
$(function(){
	//取得url参数
	var paraString = location.search;     
	var paras = paraString.split("&");   
	opttype = paras[0].substr(paras[0].indexOf("=") + 1); 
	if(opttype=='1'){
		$('#content').combobox('setValue','1');
		$('#type').combobox('setValue','2');
		$('#querybutton').hide();
	}
	if(opttype=='2'){
		$('#content').combobox('setValue','1');
		$('#type').combobox('setValue','1');
		$('#querybutton').hide();
	}
	if(opttype=='3'){
		$('#content').combobox('setValue','2');
		$('#type').combobox('setValue','2');
		$('#querybutton').hide();
	}
	if(opttype=='4'){
		$('#content').combobox('setValue','2');
		$('#type').combobox('setValue','1');
		$('#querybutton').hide();
	}
	$.ajax({
	   type: "post",
		async:false,
	   url: "/ComboxService/getComboxs.do",
	   data: {codetablename:'COD_TAXCODE'},
	   dataType: "json",
	   success: function(jsondata){
		   for (var i = 0; i < jsondata.length; i++) {
			  if((jsondata[i].key.substring(0,2) =='20' || jsondata[i].key.substring(0,2) =='12' || jsondata[i].key.substring(0,2) =='10') &&(jsondata[i].key.indexOf("98")<0 && jsondata[i].key.indexOf("99")<0)){
				  if(jsondata[i].key.length==2){
					var data = {}; 
					data.key=jsondata[i].key;
					data.value=jsondata[i].value;
					taxtypecodedata.push(data);
				  }else{
					var data = {}; 
					data.key=jsondata[i].key;
					data.value=jsondata[i].value;
					taxcodedata.push(data);
				  }
			   }
		  }
		$('#taxtypecode').combobox({   
			data:taxtypecodedata,   
			valueField:'key',   
			textField:'value'  
		});
		$('#taxcode').combobox({   
			data:taxcodedata,   
			valueField:'key',   
			textField:'value'  
		});
		  taxdata= jsondata;
	   }
	});
	var regex = new RegExp("\"","g");  
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#taxorgsupcode').combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							//$.messager.alert('返回消息',n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//$.messager.alert('返回消息',JSON.stringify(jsondata));
									   $('#taxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#taxorgcode').combobox({
						data : jsondata.taxOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/taxDeptOptionByOrg.do",
								   data: {"taxOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#taxdeptcode').combobox({
						data : jsondata.taxDeptOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/getTaxEmpByOrgCode.do",
								   data: {"taxDeptCode":n.key,"emptype":"30"},
								   dataType: "json",
								   success: function(jsondata){	
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}



				   $('#taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
					//分局登录 默认选中
					var orgclass='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getUserTaxOrgVO().getOrgclass()%>';
					var taxdeptcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
					var taxempcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
					if(orgclass=='04'){
						$('#taxdeptcode').combobox("setValue",taxdeptcode);
						query();//税收管理员才查询
					}
					
	           }
	   });
	
})
	
function openQuery(){
	$('#querywindow').window('open');
}
function query(){
	var params = {};
	var fields =$('#queryform').serializeArray();
	$.each( fields, function(i, field){
		params[field.name] = field.value;
	}); 
	$.ajax({
	   type: "post",
	   url: "/testcolumnchartServlet/gettaxinfo.do",
	   data:params,
	   dataType: "text",
	   success: function(data){
		   //var a='1234&&&567890&&&abcdef&&&ghijkl';
		   var b = data.split('&&&');
		   //for (var i=0; i<b.length; i++)
		  // {
			//   alert(b[i]);
		  // }
		   //alert(data.substring(0,data.indexOf('&&&')));
		   //alert(data.substring(data.indexOf('&&&')+3,data.length-1));
		   //if (GALLERY_RENDERER && GALLERY_RENDERER.search(/javascript|flash/i)==0)  FusionCharts.setCurrentRenderer(GALLERY_RENDERER);
			//alert($('#content').val());
			if($('#content').combo('getValue')=='1'){
				var myChart1 = new FusionCharts("../../charts/MSLine.swf", "myChart1", "900", "460");
				myChart1.setXMLData(b[0]);
				myChart1.render("chartdiv1");
				var chart1 = new FusionCharts("../../charts/Cylinder.swf", "chart1", "400", "430");
				chart1.setXMLData(b[1]);
				chart1.render("cylinderdiv1");
				var myChart2 = new FusionCharts("../../charts/MSLine.swf", "myChart2", "900", "460");
				myChart2.setXMLData(b[2]);
				myChart2.render("chartdiv2");
				var chart2 = new FusionCharts("../../charts/Cylinder.swf", "chart2", "400", "430");
				chart2.setXMLData(b[3]);
				chart2.render("cylinderdiv2");
				var myChart3 = new FusionCharts("../../charts/MSLine.swf", "myChart3", "900", "460");
				myChart3.setXMLData(b[4]);
				myChart3.render("chartdiv3");
				var chart3 = new FusionCharts("../../charts/Cylinder.swf", "chart3", "400", "430");
				chart3.setXMLData(b[5]);
				chart3.render("cylinderdiv3");
				var myChart4 = new FusionCharts("../../charts/MSLine.swf", "myChart4", "900", "460");
				myChart4.setXMLData(b[6]);
				myChart4.render("chartdiv4");
				var chart4 = new FusionCharts("../../charts/Cylinder.swf", "chart4", "400", "430");
				chart4.setXMLData(b[7]);
				chart4.render("cylinderdiv4");
			}
			if($('#content').combo('getValue')=='2'){
				var myChart1 = new FusionCharts("../../charts/MSLine.swf", "ChartId1", "900", "460");
				myChart1.setXMLData(b[8]);
				myChart1.render("chartdiv1");
				var chart1 = new FusionCharts();
				chart1.setXMLData();
				chart1.render("cylinderdiv1");
				var myChart2 = new FusionCharts();
				myChart2.setXMLData();
				myChart2.render("chartdiv2");
				var chart2 = new FusionCharts();
				chart2.setXMLData();
				chart2.render("cylinderdiv2");
				var myChart3 = new FusionCharts();
				myChart3.setXMLData();
				myChart3.render("chartdiv3");
				var chart3 = new FusionCharts();
				chart3.setXMLData();
				chart3.render("cylinderdiv3");
				var myChart4 = new FusionCharts();
				myChart4.setXMLData();
				myChart4.render("chartdiv4");
				var chart4 = new FusionCharts();
				chart4.setXMLData();
				chart4.render("cylinderdiv4");
			}
	   }
	});
	$('#querywindow').window('close');
	
}


</script>
</head>
<body class="easyui-layout">
	<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" id="querybutton">
		<div style="height:25px;">
			<a  class="easyui-linkbutton"  data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
		</div>
	</div>

<div id="chartContent" style="width:100%;height:100%;overflow:auto">
	<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center"  >
		<tr> 
			<td  class="text">
				<div id="chartdiv1" ></div>
			</td>
			<td  class="text" >
				<div id="cylinderdiv1"></div>
			</td>
		</tr>
		<tr> 
			<td  class="text"> 
				<div id="chartdiv2" ></div>
			</td>
			<td  class="text">
				<div id="cylinderdiv2"></div>
			</td>
		</tr>
		<tr> 
			<td  class="text"> 
				<div id="chartdiv3" ></div>
			</td>
			<td  class="text">
				<div id="cylinderdiv3"></div>
			</td>
		</tr>
		<tr> 
			<td  class="text"> 
				<div id="chartdiv4" ></div>
			</td>
			<td  class="text">
				<div id="cylinderdiv4"></div>
			</td>
		</tr>
		<tr> 
			<td  class="text"> 
				<div id="chartdiv5" ></div>
			</td>
			<td  class="text">
				<div id="cylinderdiv5"></div>
			</td>
		</tr>
	</table>
</div>
	<!-- <div id="chartdiv" align="center"></div> -->
	<div id="querywindow" class="easyui-window" data-options="closed:true,modal:true,title:'查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
	<div class="easyui-panel" title="" style="width:900px;">
		<form id="queryform" method="post">
			<table id="quertable" width="100%"  class="table table-bordered">
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
					<td align="right">计算机编码：</td>
					<td>
						<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="taxpayerid"/>
					</td>
					<td align="right">纳税人名称：</td>
					<td>
						<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px" name="taxpayername"/>
					</td>
				</tr>
				<tr>
					<td align="right">展现类型：</td>
					<td>
						<select id="type" class="easyui-combobox" name="type" style="width:200px;" data-options="required:true" editable="false">
							<option value="1" >按年</option>
							<option value="2" selected="true">按月</option>
						</select>
					</td>
					<td align="right">展现内容：</td>
					<td>
						<select id="content" class="easyui-combobox" name="content" style="width:200px;" data-options="required:true" editable="false">
							<option value="1" selected="true">税款情况</option>
							<option value="2">土地面积情况</option>
						</select>
					</td>
					<!-- <td align="right">税种：</td>
					<td>
						<input id="taxtypecode" name="taxtypecode" style="width:200px;" class="easyui-combobox" editable='false' data-options="
							onChange:function(newValue, oldValue){
							if(newValue != ''){
								var newarray = new Array();
								for (var i = 0; i < taxcodedata.length; i++) {
									if(taxcodedata[i].key.indexOf(newValue)==0){
										var rowdata = {};
										rowdata.key = taxcodedata[i].key;
										rowdata.value = taxcodedata[i].value;
										newarray.push(rowdata);
									}
								};
								$('#taxcode').combobox({
									data : newarray,
									valueField:'key',
									textField:'value'
								});
							}
						}" />
					</td>
					<td align="right">税目：</td>
					<td>
						<input id="taxcode" name="taxcode" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						data:taxcodedata" />				
					</td> -->
				</tr>
				<tr>
					<td align="right">所属年度：</td>
					<td colspan="3">
						<input id="yearbegin" class="easyui-validatebox" type="text" style="width:200px" value ="2012" name="yearbegin"/>
						<input id="yearend" class="easyui-validatebox" type="text" style="width:200px" value ="2014" name="yearend"/>
					</td>
				</tr>
			</table>
		</form>
		<div style="text-align:center;padding:5px;">  
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
		</div>
	</div>
</body>

</html>