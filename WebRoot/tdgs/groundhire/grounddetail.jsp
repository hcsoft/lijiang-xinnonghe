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
			var tdxxrow = $('#groundhiregrid').datagrid('getSelected');
			if(tdxxrow){
				$.ajax({
					   type: "post",
					   url: "/GroundInfoServlet/getnewestateinfo.do",
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
				<div title="土地基础信息"  data-options="" style="overflow:auto;padding:10px;">
					<table id="tdjcxx" width="100%" class="table table-bordered" >
						<tr>
							<td align="right">
								宗地编号：
							</td>
							<td>
								<input id="estateserialno" class="easyui-validatebox" type="text" style="width:200px;" name="estateserialno" readOnly="true" data-options=""></input>
							</td>
							<td align="right">
								土地来源：
							</td>
							<td>
								<input id="landsource" name="landsource" class="easyui-combobox" style="width:200px;" editable='false' readOnly="true" data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDSOURCECODE'" />
							</td>
						</tr>
						<tr>
							<td align="right">
								产权人计算机编码：
							</td>
							<td>
								<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px;" name="taxpayerid" readOnly="true" data-options=""></input>
							</td>
							<td align="right">
								产权人名称：
							</td>
							<td>
								<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px;" name="taxpayername" readOnly="true" data-options=""></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								土地证类型：
							</td>
							<td>
								<input id="landcertificatetype" name="landcertificatetype" style="width:200px;" class="easyui-combobox" editable='false' readOnly="true" data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_LANDCERTIFICATETYPE'" />
							</td>
							<td align="right">
								土地证号：
							</td>
							<td>
								<input id="landcertificate" class="easyui-validatebox"style="width:200px;" type="text" name="landcertificate" readOnly="true" data-options=""></input>
							</td>
							
						</tr>
						<tr>
							<td align="right">
								发证日期：
							</td>
							<td>
								<input id="landcertificatedates" name='landcertificatedates' style="width:200px;" class="easyui-validatebox"  readOnly="true" data-options="" ></input>
							</td>
							<td align="right">
								实际交付土地时间：
							</td>
							<td>
								<input id="holddates" name="holddates" class="easyui-validatebox" style="width:200px;" readOnly="true" data-options=""></input>
							</td>
						</tr>
						<tr>
							
							<td align="right">
								土地等级：
							</td>
							<td>
								<select id="landtaxprice" class="easyui-combobox" style="width:200px;" name="landtaxprice" style="width:200px;" readOnly="true" data-options="" editable="false">
									<option value="3"  selected="true">一等</option>
									<option value="2">二等</option>
									<option value="1">三等</option>
								</select>
							</td>
							<td align="right">
								土地面积来源部门：
							</td>
							<td>
								<input id="landareaapprovalunit" class="easyui-validatebox" style="width:200px;" type="text" name="landareaapprovalunit" readOnly="true" data-options=""></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								使用年限起：
							</td>
							<td>
								<input id="datebegins" name='datebegins' class="easyui-validatebox" style="width:200px;" readOnly="true" data-options=""></input>
							</td>
							<td align="right">
								使用年限止：
							</td>
							<td>
								<input id="dateends" name='dateends' class="easyui-validatebox" style="width:200px;" readOnly="true" data-options=""></input>
							</td>
						</tr>
						<tr>
							<td rowspan="3">土地坐落地</td>
							<td align="right">类型：</td>
							<td colspan="2"><input id="locationtype"
								name="locationtype" class="easyui-combobox" editable='false'
								data-options="
							valueField: 'key',
							textField: 'value',
							required:'true',
							url: '/ComboxService/getComboxs.do?codetablename=COD_LOCATIONTYPE'"
								style="width:400px;" />
							</td>
						</tr>
						<tr>
							<td align="right">所属乡镇：</td>
							<td>
								<input id="belongtocountry" name="belongtocountry" style="width:100px;" class="easyui-combobox" editable='false' data-options="
								valueField: 'key',
								textField: 'value',
								onChange:function(newValue, oldValue){
									if(newValue != ''){
										var newarray = new Array();
										for (var i = 0; i < belongtowns.length; i++) {
											if(belongtowns[i].key.indexOf(newValue)==0){
												var rowdata = {};
												rowdata.key = belongtowns[i].key;
												rowdata.value = belongtowns[i].value;
												newarray.push(rowdata);
											}
										};
										$('#belongtowns').combobox({
											data : newarray,
											valueField:'key',
											textField:'value'
										});
									}
								},
								data:belongtocountry" />
							</td>
							<td colspan="2">
								<input id="belongtowns" name="belongtowns" style="width:200px;" class="easyui-combobox" editable='false' data-options="
								valueField: 'key',
								textField: 'value',
								data:belongtowns" />
							</td>
						</tr>
						<tr>
							<td align="right">详细地址：</td>
							<td colspan="2"><input id="detailaddress"
								class="easyui-validatebox" type="text" name="detailaddress"
								data-options="" style="width:400px;"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
							宗地面积（平方米）：
							</td>
							<td>
								<input id="landarea" class="easyui-numberbox" style="width:200px;" type="text" name="landarea" readOnly="true" data-options="min:0" precision="2" value="0.00" style="text-align:right" ></input>
							</td>
							<td align="right">
							获得土地总价（平方米）：
							</td>
							<td>
								<input id="landmoney" class="easyui-numberbox" style="width:200px;" type="text" name="landmoney" readOnly="true" data-options="min:0" precision="2" value="0.00" style="text-align:right" ></input>
							</td>
						</tr>
					</table>
				</div>
				<!-- <div title="土地面积"  data-options="" style="overflow:auto;padding:10px;">
				<table id="tdmj" width="100%" class="table table-bordered" >
				<tr>
					<td rowspan="4" align="center" style="padding:40px;">
						土地面积
					</td>
					<td width="40%" align="right">
						其中土地使用税免税面积（平方米）：
					</td>
					<td>
						<input id="taxfreearea" class="easyui-numberbox" type="text" precision="2" name="taxfreearea" readOnly="true" data-options="min:0,required:true" value="0.00" style="text-align:right" onBlur="cacultetdmj()" readOnly="true"></input>
					</td>
				</tr>
				<tr>
					<td width="40%" align="right">
						其中减少面积（平方米）：
					</td>
					<td>
						<input id="reducearea" class="easyui-numberbox" type="text" precision="2" name="reducearea" readOnly="true" data-options="min:0,required:true" value="0.00" style="text-align:right" onBlur="cacultetdmj()" readOnly="true"></input>
					</td>
				</tr>
				<tr>
					<td width="40%" align="right">
						其中出租土地约定对方缴纳土地使用税土地面积（平方米）：
					</td>
					<td>
						<input id="hirelandreducearea" class="easyui-numberbox" type="text" precision="2" name="hirelandreducearea" readOnly="true" data-options="min:0,required:true" value="0.00"  style="text-align:right" onBlur="cacultetdmj()" readOnly="true"></input>
					</td>
				</tr>
				<tr>
					<td width="40%" align="right">
						其中出租房产约定对方缴纳土地使用税土地面积（平方米）：
					</td>
					<td>
						<input id="hirehousesreducearea" class="easyui-numberbox" type="text" precision="2" name="hirehousesreducearea"  value="0.00" style="text-align:right" readOnly="true" data-options="min:0,required:true" onBlur="cacultetdmj()" readOnly="true"></input>
					</td>
				</tr>
				<tr>
					<td width="40%" align="right">
						其中土地使用税应税面积（平方米）：
					</td>
					<td>
						<input id="taxarea" class="easyui-numberbox"  type="text" name="taxarea" precision="2" readOnly="true" data-options="min:0,required:true" style="text-align:right" value="0.00" readOnly="true"></input>
					</td>
				</tr>
				</table>
							</div> -->
			<!-- <div title="房产税计税相关信息"  data-options="" style="overflow:auto;padding:10px;">
					<table id="fcsjsxgxx" width="100%" class="table table-bordered">
						<tr>
							<td rowspan="2" align="center" style="padding:10px;">
								土地价格
							</td>
							<td align="right">
								总价（元）：
							</td>
							<td colspan="3">
								<input id="landmoney" class="easyui-numberbox" type="text" precision="2" name="landmoney" readOnly="true" data-options="min:0,required:false" style="text-align:right" onBlur="cacultedj();cacultetdmj()" value="0.00"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								单价(元/平方米)
							</td>
							<td colspan="3">
								<input id="landprice" class="easyui-numberbox" type="text" name="landprice" precision="2" readOnly="true" data-options="min:0,required:false" readOnly="true" precision="2" style="text-align:right" value="0.00"></input>
							</td>
						</tr>
						<tr>
							<td rowspan="5" align="center" style="padding:50px;">
								计入房产原值的地价
							</td>
							<td rowspan="5" align="left" style="padding:50px;">
								<input id="houselandmoney" class="easyui-numberbox" type="text" name="houselandmoney"readOnly="true"  precision="2" value= "0.00" readOnly="true" data-options="min:0,required:false"></input>
							</td>
							<td rowspan="5" align="center" style="padding:50px;">
								土地地价款
							</td>
							<td align="right">
								土地出让金：
							</td>
							<td>
								<input id="landsellcost" class="easyui-numberbox" type="text" name="landsellcost" precision="2" value= "0.00" readOnly="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
							
							
						</tr>
						<tr>
							<td align="right">
								耕地占用税：
							</td>
							<td>
								<input id="landploughtaxcost" class="easyui-numberbox" type="text" name="landploughtaxcost" precision="2" value= "0.00" readOnly="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								契税：
							</td>
							<td>
								<input id="landcontracttaxcost" class="easyui-numberbox" type="text" name="landcontracttaxcost" precision="2" value= "0.00" readOnly="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								土地开发成本：
							</td>
							<td>
								<input id="landdevelopcost" class="easyui-numberbox" type="text" name="landdevelopcost" precision="2" value= "0.00" readOnly="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
							
						</tr>
						<tr>
							<td align="right">
								其他：
							</td>
							<td>
								<input id="landelsecost" class="easyui-numberbox" type="text" name="landelsecost" precision="2"  value= "0.00" readOnly="true" data-options="min:0,required:false" onBlur="cacultehouselandmoney()"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								房产容积率：
							</td>
							<td>
								<input id="plotratio" class="easyui-numberbox" type="text" name="plotratio" precision="2" readOnly="true" value= "0.00" readOnly="true" data-options="min:0,required:false"></input>
							</td>
							<td align="right">
								房产建筑面积：
							</td>
							<td colspan="2">
								<input id="areaofstructure" class="easyui-numberbox" type="text" name="areaofstructure" precision="2" value= "0.00"  readOnly="true" data-options="min:0,required:false" onBlur="caculterjl();cacultehouselandmoney()"></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								计税房产原值：
							</td>
							<td colspan="4">
								<input id="housetaxoriginalvalue" class="easyui-numberbox" type="text" name="housetaxoriginalvalue" precision="2" readOnly="true" data-options="min:0,required:false" value="0.00" readOnly="true"></input>
							</td>
						</tr>
					</table>
				</div> -->
			</div>
	
	<!-- <div  style="width:1000px;height:400px" title=" " readOnly="true" data-options="fit:true,tools:'#abutton',maximized:false">
			<div  id="abutton" style="text-align:center">
				<a href="#" class="icon-save"  plain="true" onclick="savetdxx()"></a>
			</div>
			
		</div>
		</div> -->
		</form>
</body>
  
</html>