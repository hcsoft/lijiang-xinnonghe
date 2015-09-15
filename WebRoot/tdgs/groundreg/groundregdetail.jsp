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
	<link rel="stylesheet" href="<%=spath%>/css/tablen.css"/>
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
var locationdata;
	$(function(){
		if(opttype=='edit'){
			//alert(landstoresubid);
			$.ajax({
				type: "post",
				async:false,
				url: "/GroundInfoServlet/getnewestateinfo.do",
				data: {estateid:targetestateid},
				dataType: "json",
				success: function(jsondata){
					$('#groundselldetailform').form('load',jsondata);
					landarea = jsondata.landarea;
				}
			});
			$.ajax({
				type: "post",
				url: "/GroundSellServlet/getsotresubinfo.do",
				data: {landstoresubid:landstoresubid},
				dataType: "json",
				success: function(jsondata){
					landstoreid = jsondata.landstoreid;
					maxgroundarea = parseFloat(jsondata.areatotal)-parseFloat(jsondata.areasell)+parseFloat(landarea);
					$('#maxgroundarea').html('可使用土地面积'+maxgroundarea+'平方米');
				}
			});
			
		}else{
			$('#belongtowns').val(belongtowns);
			$('#detailaddress').val(detailaddress);
			$('#maxgroundarea').html('可使用土地面积'+maxgroundarea+'平方米');
		}
	});
	
	
	//计算土地单价
	function cacultedj(){
		var landarea = $('#landarea').val();
		var landmoney = $('#landmoney').val();
		if(parseFloat(landarea)>0){
			var landprice = parseFloat(landmoney)/parseFloat(landarea);
			$('#landprice').val( landprice.toFixed(2));
		}else{
			$('#landprice').val("0.00");
		}
	}
	
	
	//提交
	function savetdxx(){
			if(!$('#holddates').datebox('isValid')){
				$.messager.alert('返回消息','交付土地时间不能为空或校验有误！');
				$('.datebox :text')[1].focus();
				return;
			}
			if(!$('#purpose').combo('isValid')){
				$.messager.alert('返回消息','土地用途不能为空！');
				$('.combo :text')[9].focus();
				return;
			}
			//if(!$('#taxperiod').combo('isValid')){
			//	$.messager.alert('返回消息','土地使用税征期类型不能为空！');
			//	$('.combo :text')[12].focus();
			//	return;
			//}
			if(!$('#limitbegins').datebox('isValid')){
				$.messager.alert('返回消息','使用年限起校验有误！');
				$('.datebox :text')[2].focus();
				return;
			}
			if(!$('#limitends').datebox('isValid')){
				$.messager.alert('返回消息','使用年限止校验有误！');
				$('.datebox :text')[3].focus();
				return;
			}
			if(!$('#locationtype').combo('isValid')){
				$.messager.alert('返回消息','土地坐落地类型不能为空！');
				$('.combo :text')[14].focus();
				return;
			}
			if(!$('#belongtowns').combo('isValid')){
				$.messager.alert('返回消息','所属乡镇不能为空！');
				$('.combo :text')[15].focus();
				return;
			}
			if(!$('#detailaddress').validatebox('isValid')){
				$.messager.alert('返回消息','详细地址不能为空！');
				$('#detailaddress')[0].focus();
				return;
			}
			if(!$('#landarea').validatebox('isValid')){
				$.messager.alert('返回消息','土地面积不能为空！');
				$('#landarea')[0].focus();
				return;
			}else{
				var landarea = $('#landarea').val();
				if(landarea>maxgroundarea){
					$.messager.alert('返回消息','土地面积不能大于最大可使用土地面积！');
					$('#landarea')[0].focus();
					return;
				}
				if(landarea == 0){
					$.messager.alert('返回消息','土地面积必须大于0！');
					$('#landarea')[0].focus();
					return;
				}
			}
			//if(!comparetdj()){
			//	return;
			//}
			var params = {};
			var fields =$('#groundselldetailform').serializeArray(); //自动序列化表单元素为JSON对象
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//params.landprice = $('#landprice').val();
			//params.houselandmoney = $('#houselandmoney').val();
			//params.plotratio = $('#plotratio').val();
			//params.taxarea = $('#taxarea').val();
			//var groundinfo = $('#groundsellgrid').datagrid('getSelected');
			//params.businesstype = businesstype;
			//params.estateid = groundinfo.estateid;
			params.targetestateid = targetestateid;
			params.busid = busid;
			params.businesstype = businesstype;
			params.opttype = opttype;
			params.landstoreid = landstoreid;
			params.landstorsubid = landstoresubid;
			params.taxpayerid = taxpayerid;
			params.taxpayername = taxpayername;
			params.landsource = '01';
			$.ajax({
					   type: "post",
					   url: "/GroundSellServlet/savegroundsell.do",
					   data: params,
					   dataType: "json",
					   success: function(jsondata){
							//$('#addtdxxform').form('clear');
							//$('#addtdxxwindow').window('close');
							$.messager.alert('返回消息',"保存成功");
							if(opttype=='edit'){
								$('#querylesseesid').val(taxpayerid);
								businessquery();
								//$('#groundcheckgrid').datagrid('reload');
							}else{
								$('#querylesseesid').val(taxpayerid);
								businessquery();
								//$('#groundsellgrid').datagrid('reload');
							}
							$('#groundsellwindow').window('close');
							$('#groundbusinesswindow').window('close');
					   },
					error:function (data, status, e){   
						 $.messager.alert('返回消息',"保存出错");   
					   }   
			});
		//}
	}
	



	$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	}); 

	$.extend($.fn.validatebox.defaults.rules, {
	isAfter: {
		validator: function(value, param){
			var dateA = $.fn.datebox.defaults.parser(value);
			var dateB = $.fn.datebox.defaults.parser($(param[0]).datebox('getValue'));
			//$.messager.alert('返回消息',dateA+"------"+dateB);
			return dateA<dateB;
			},
		 message: '使用年限起不能大于使用年限止！'
		}
	});
//data-options="validType:['datecheck','isAfter[\'#holddates\']']"


	
	function last(){
		$('#groundbusinesswindow').window('refresh', 'reginfo.jsp');
	}
	</script>
	<!-- <div style="background:#f4f4f4;padding:3px 5px;">
		<a  id="btn1" class="easyui-linkbutton" icon="icon-undo" plain="true" onclick="last()">上一步</a>
		
	</div> -->
	<div class="easyui-panel" title="" style="overflow:auto;padding:10px">
	<form id="groundselldetailform" method="post">
		
			<table id="tdjcxx" class="table table-bordered" >
				<tr>
					<td align="right">
						计算机编码：
					</td>
					<td>
						<input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" style="width:200px;" data-options="required:false"></input>
					</td>
					<td align="right">
						纳税人名称：
					</td>
					<td align="left">
						<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" style="width:200px;" data-options="required:true"></input>
					</td>
					<a  id="btn2" class="easyui-linkbutton" icon="icon-save" plain="true" onclick="queryreg()">登记查询</a>
				</tr>
				<tr>
					<td align="right">
						土地来源：
					</td>
					<td>
						<input id="landsource" name="landsource" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
						url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDSOURCECODE'" />
					</td>
					<td align="right">
						土地用途：
					</td>
					<td>
						<input id="purpose" name="purpose" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
						url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDUSECODE'" />
					</td>
				</tr>
				<tr>
					<td align="right">
						土地证类型：
					</td>
					<td>
						<input id="landcertificatetype" name="landcertificatetype" class="easyui-combobox" style="width:200px;" editable='false' data-options="
						required:false,
						valueField: 'key',
						textField: 'value',
						url: '/ComboxService/getComboxs.do?codetablename=COD_LANDCERTIFICATETYPE'" />
					</td>
					<td align="right">
						土地证号：
					</td>
					<td align="left">
						<input id="landcertificate" class="easyui-validatebox" type="text" name="landcertificate" style="width:200px;" data-options="required:false"></input>
					</td>
					
				</tr>
				<tr>
					<td align="right">
						发证日期：
					</td>
					<td>
						<input id="landcertificatedates" name='landcertificatedates' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck'],required:false" ></input>
					</td>
					<td align="right">
						交付土地时间：
					</td>
					<td>
						<input id="holddates" name="holddates" class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck'],required:true"></input>
					</td>
				</tr>
				<!-- <tr>
					<td align="right">
						图号：
					</td>
					<td align="left">
						<input id="pictureno" class="easyui-validatebox" type="text" name="pictureno" style="width:200px;" data-options="required:false"></input>
					</td>
					
					<td align="right">
						受让方是否免税单位：
					</td>
					<td>
						<select id="freetax" class="easyui-combobox" name="freetax" style="width:200px;" data-options="required:true" editable="false">
							<option value="0">否</option>
							<option value="1">是</option>
						</select>
					</td>
				</tr> -->
				<tr>
					<!-- <td align="right">
						土地使用税税额：
					</td>
					<td>
						<select id="landtaxprice" class="easyui-combobox" name="landtaxprice" style="width:200px;" data-options="required:true" editable="false">
							<option value="2" selected="true">2元/年.平方米</option>
							<option value="3">3元/年.平方米</option>
						</select>
					</td> -->
					<!-- <td align="right">
						土地使用税申报征期类型：
					</td>
					<td>
						<select id="taxperiod" class="easyui-combobox" name="taxperiod" style="width:200px;" data-options="required:true,panelWidth:300" editable="false">
							<option value="21" selected="true">按月申报缴纳，于当月1日至10日内</option>
							<option value="22">按季申报缴纳，于本季度1日至40日内</option>
							<option value="07">按半年申报缴纳，于本期120日内</option>
							<option value="10">按年申报缴纳，于本年120日内</option>
						</select>
					</td> -->
					<td align="right">
						使用年限起：
					</td>
					<td>
						<input id="datebegins" name='datebegins' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck','isAfter[\'#limitends\']']"></input>
					</td>

					<td align="right">
						使用年限止：
					</td>
					<td>
						<input id="dateends" name='dateends' class="easyui-datebox" style="width:200px;" data-options="validType:'datecheck'"></input>
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
						<input id="locationtype" name="locationtype" style="width:400px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
						url: '/ComboxService/getComboxs.do?codetablename=COD_LOCATIONTYPE'" />
					</td>
				</tr>
				<tr>
					<td align="right">所属村（居）委会：</td>
					<td>
						<input id="belongtocountry" name="belongtocountry" style="width:100px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
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
						required:'true',
						data:belongtowns" />
					</td>
				</tr>
				<tr>
					<td align="right">
						详细地址：
					</td>
					<td colspan="3">
						<input id="detailaddress" class="easyui-validatebox" style="width:400px;" type="text" name="detailaddress" data-options="required:true"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
					土地总价/年租金（元）：
					</td>
					<td>
						<input id="landmoney" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landmoney" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
					<td align="right">
					土地面积（平方米）：
					</td>
					<td>
						<input id="landarea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landarea" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
					</td>
					
				</tr>
				
			</table>
			<div style="text-align:center;padding:5px;height: 25px;" >
				<a  id="btn2" class="easyui-linkbutton" icon="icon-save"  onclick="savetdxx()">保存</a>
			</div>
		</form>
		
		</div>
</body>
  
</html>