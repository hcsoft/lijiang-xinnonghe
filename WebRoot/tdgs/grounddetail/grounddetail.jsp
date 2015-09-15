<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

	<title>Complex Layout - jQuery EasyUI Demo</title>

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
</head>   
<body>
<script>
	$(function(){
		refreshestate();
	});
	
	function refreshestate(){
			var tdxxrow = $('#groundtransfergrid').datagrid('getSelected');
			if(tdxxrow){
				$.ajax({
					   type: "post",
					   url: "/GroundInfoServlet/getestateinfo.do",
					   data: {estateid:tdxxrow.estateid},
					   dataType: "json",
					   success: function(jsondata){
						   //alert(jsondata);
						  $('#grounddetailform').form('load',jsondata);
					   }
					});
			}
		//}
	}

	</script>
	<form id="grounddetailform" method="post">
			
				
	<div id="accord" class="easyui-accordion" style="overflow;width:900px;height:400px;">
				<div title="土地基本信息"  data-options="" style="overflow:auto;padding:10px;">
					<table id="tdjcxx" width="100%" class="table table-bordered" >
						<tr>
							<td align="right">
								土地自编号：
							</td>
							<td>
								<input id="selfnumber" class="easyui-validatebox" type="text" style="width:200px;" name="selfnumber" disabled="true" data-options="required:true"></input>
							</td>
							<td align="right">
								土地来源：
							</td>
							<td>
								<input id="landsource" name="landsource" class="easyui-combobox" style="width:200px;" editable='false' disabled="true" data-options="
								required:true,
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDSOURCECODE'" />
							</td>
						</tr>
						<tr>
							<td align="right">
								土地证类型：
							</td>
							<td>
								<input id="landcertificatetype" name="landcertificatetype" style="width:200px;" class="easyui-combobox" editable='false' disabled="true" data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_LANDCERTIFICATETYPE'" />
							</td>
							<td align="right">
								土地证号：
							</td>
							<td>
								<input id="landcertificate" class="easyui-validatebox"style="width:200px;" type="text" name="landcertificate" disabled="true" data-options="required:false"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								发证日期：
							</td>
							<td>
								<input id="landcertificatedates" name='landcertificatedates' style="width:200px;" class="easyui-validatebox"  disabled="true" data-options="validType:['datecheck']" ></input>
							</td>
							<td align="right">
								协议书号：
							</td>
							<td>
								<input id="protocolnumber" class="easyui-validatebox" style="width:200px;" type="text" name="protocolnumber" disabled="true" data-options="required:false"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								交付土地时间：
							</td>
							<td>
								<input id="holddates" name="holddates" class="easyui-validatebox" style="width:200px;" disabled="true" data-options="validType:['datecheck'],required:true"></input>
							</td>
							<td align="right">
								土地使用税税额：
							</td>
							<td>
								<select id="landtaxprice" class="easyui-combobox" style="width:200px;" name="landtaxprice" style="width:200px;" disabled="true" data-options="required:true" editable="false">
									<option value="1"  selected="true">1元/年.平方米</option>
									<option value="2">2元/年.平方米</option>
									<option value="3">3元/年.平方米</option>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right">
								申报征期类型：
							</td>
							<td>
								<input id="taxperiod" name="taxperiod" style="width:200px;" class="easyui-combobox" editable='false' disabled="true" data-options="
								valueField: 'key',
								textField: 'value',
								data:levydatetypedata" />
							</td>
							<td align="right">
								土地面积来源部门：
							</td>
							<td>
								<input id="landareaapprovalunit" class="easyui-validatebox" style="width:200px;" type="text" name="landareaapprovalunit" disabled="true" data-options="required:false"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								使用年限起：
							</td>
							<td>
								<input id="limitbegins" name='limitbegins' class="easyui-validatebox" style="width:200px;" disabled="true" data-options="validType:['datecheck','isAfter[\'#limitends\']']"></input>
							</td>
							<td align="right">
								使用年限止：
							</td>
							<td>
								<input id="limitends" name='limitends' class="easyui-validatebox" style="width:200px;" disabled="true" data-options="validType:'datecheck'"></input>
							</td>
						</tr>
						<tr>
							<td rowspan="3" align="center" style="padding:20px;">
								土地坐落地
							</td>
							<td align="right">
								类型：
							</td>
							<td colspan="3">
								<input id="locationtype" name="locationtype" class="easyui-combobox" style="width:330px;" editable='false' disabled="true" data-options="
								valueField: 'key',
								textField: 'value',
								required:'true',
								url: '/ComboxService/getComboxs.do?codetablename=COD_LOCATIONTYPE'" />
							</td>
						</tr>
						<tr>
							<td align="right">
								所属乡镇：
							</td>
							<td colspan="3">
								<input id="belongtowns" name="belongtowns" class="easyui-combobox" style="width:330px;" editable='false' disabled="true" data-options="
								valueField: 'key',
								textField: 'value',
								required:'true',
								data:locationdata" />
							</td>
						</tr>
						<tr>
							<td align="right">
								详细地址：
							</td>
							<td colspan="3">
								<input id="detailaddress" class="easyui-validatebox" type="text" style="width:330px;" name="detailaddress" disabled="true" data-options="required:true"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
							土地总面积（平方米）：
							</td>
							<td colspan="4">
								<input id="landarea" class="easyui-numberbox" style="width:200px;" type="text" name="landarea" disabled="true" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" onBlur="cacultetdmj();cacultedj();caculterjl();cacultehouselandmoney()"></input>
							</td>
						</tr>
					</table>
				</div>
				<div title="土地面积"  data-options="" style="overflow:auto;padding:10px;">
				<table id="tdmj" width="100%" class="table table-bordered" >
				<tr>
					<td rowspan="4" align="center" style="padding:40px;">
						土地面积
					</td>
					<td width="40%" align="right">
						其中土地使用税免税面积（平方米）：
					</td>
					<td>
						<input id="taxfreearea" class="easyui-numberbox" type="text" precision="2" name="taxfreearea" disabled="true" data-options="min:0,required:true" value="0.00" style="text-align:right" onBlur="cacultetdmj()" disabled="true"></input>
					</td>
				</tr>
				<tr>
					<td width="40%" align="right">
						其中减少面积（平方米）：
					</td>
					<td>
						<input id="reducearea" class="easyui-numberbox" type="text" precision="2" name="reducearea" disabled="true" data-options="min:0,required:true" value="0.00" style="text-align:right" onBlur="cacultetdmj()" disabled="true"></input>
					</td>
				</tr>
				<tr>
					<td width="40%" align="right">
						其中出租土地约定对方缴纳土地使用税土地面积（平方米）：
					</td>
					<td>
						<input id="hirelandreducearea" class="easyui-numberbox" type="text" precision="2" name="hirelandreducearea" disabled="true" data-options="min:0,required:true" value="0.00"  style="text-align:right" onBlur="cacultetdmj()" disabled="true"></input>
					</td>
				</tr>
				<tr>
					<td width="40%" align="right">
						其中出租房产约定对方缴纳土地使用税土地面积（平方米）：
					</td>
					<td>
						<input id="hirehousesreducearea" class="easyui-numberbox" type="text" precision="2" name="hirehousesreducearea"  value="0.00" style="text-align:right" disabled="true" data-options="min:0,required:true" onBlur="cacultetdmj()" disabled="true"></input>
					</td>
				</tr>
				<tr>
					<td width="40%" align="right">
						其中土地使用税应税面积（平方米）：
					</td>
					<td>
						<input id="taxarea" class="easyui-numberbox"  type="text" name="taxarea" precision="2" disabled="true" data-options="min:0,required:true" style="text-align:right" value="0.00" disabled="true"></input>
					</td>
				</tr>
				</table>
			</div>
			<div title="房产税计税相关信息"  data-options="" style="overflow:auto;padding:10px;">
					<table id="fcsjsxgxx" width="100%" class="table table-bordered">
						<tr>
							<td rowspan="2" align="center" style="padding:10px;">
								土地价格
							</td>
							<td align="right">
								总价（元）：
							</td>
							<td colspan="3">
								<input id="landmoney" class="easyui-numberbox" type="text" precision="2" name="landmoney" disabled="true" data-options="min:0,required:false" style="text-align:right" onBlur="cacultedj();cacultetdmj()" value="0.00"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								单价(元/平方米)
							</td>
							<td colspan="3">
								<input id="landprice" class="easyui-numberbox" type="text" name="landprice" precision="2" disabled="true" data-options="min:0,required:false" disabled="true" precision="2" style="text-align:right" value="0.00"></input>
							</td>
						</tr>
						<tr>
							<td rowspan="5" align="center" style="padding:50px;">
								计入房产原值的地价
							</td>
							<td rowspan="5" align="left" style="padding:50px;">
								<input id="houselandmoney" class="easyui-numberbox" type="text" name="houselandmoney"disabled="true"  precision="2" value= "0.00" disabled="true" data-options="min:0,required:false"></input>
							</td>
							<td rowspan="5" align="center" style="padding:50px;">
								土地地价款
							</td>
							<td align="right">
								土地出让金：
							</td>
							<td>
								<input id="landsellcost" class="easyui-numberbox" type="text" name="landsellcost" precision="2" value= "0.00" disabled="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
							
							
						</tr>
						<tr>
							<td align="right">
								耕地占用税：
							</td>
							<td>
								<input id="landploughtaxcost" class="easyui-numberbox" type="text" name="landploughtaxcost" precision="2" value= "0.00" disabled="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								契税：
							</td>
							<td>
								<input id="landcontracttaxcost" class="easyui-numberbox" type="text" name="landcontracttaxcost" precision="2" value= "0.00" disabled="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								土地开发成本：
							</td>
							<td>
								<input id="landdevelopcost" class="easyui-numberbox" type="text" name="landdevelopcost" precision="2" value= "0.00" disabled="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
							
						</tr>
						<tr>
							<td align="right">
								其他：
							</td>
							<td>
								<input id="landelsecost" class="easyui-numberbox" type="text" name="landelsecost" precision="2"  value= "0.00" disabled="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								房产容积率：
							</td>
							<td>
								<input id="plotratio" class="easyui-numberbox" type="text" name="plotratio" precision="2" disabled="true" value= "0.00" disabled="true" data-options="min:0,required:false"></input>
							</td>
							<td align="right">
								房产建筑面积：
							</td>
							<td colspan="2">
								<input id="areaofstructure" class="easyui-numberbox" type="text" name="areaofstructure" precision="2" value= "0.00"  disabled="true" data-options="min:0,required:false" onBlur="caculterjl();cacultehouselandmoney()"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								计税房产原值：
							</td>
							<td colspan="4">
								<input id="housetaxoriginalvalue" class="easyui-numberbox" type="text" name="housetaxoriginalvalue" precision="2" disabled="true" data-options="min:0,required:false" value="0.00" disabled="true"></input>
							</td>
						</tr>
					</table>
				</div>
			</div>
	
	<!-- <div  style="width:1000px;height:400px" title=" " disabled="true" data-options="fit:true,tools:'#abutton',maximized:false">
			<div  id="abutton" style="text-align:center">
				<a href="#" class="icon-save"  plain="true" onclick="savetdxx()"></a>
			</div>
			
		</div>
		</div> -->
		</form>
</body>
  
</html>