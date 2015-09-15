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
	$(function(){
		$('#belongtowns').val(belongtocountrycode);
		$('#maxgroundarea').html('可出让土地面积'+maxgroundarea+'平方米');
	});
	
	

	//计算土地应税面积
	function cacultetdmj(){
			var landarea= $('#landarea').val();
			if(isNaN(landarea) || landarea <0){
				landarea = 0;
			}
			var taxfreearea= $('#taxfreearea').val();
			if(isNaN(taxfreearea) || taxfreearea <0){
				taxfreearea = 0;
			}
			var reducearea= $('#reducearea').val();
			if(isNaN(reducearea) || reducearea <0){
				reducearea = 0;
			}
			var hirelandreducearea= $('#hirelandreducearea').val();
			if(isNaN(hirelandreducearea) || hirelandreducearea <0){
				hirelandreducearea = 0;
			}
			var hirehousesreducearea= $('#hirehousesreducearea').val();
			if(isNaN(hirehousesreducearea) || hirehousesreducearea <0){
				hirehousesreducearea = 0;
			}
			//$.messager.alert('返回消息',hirehousesreducearea);
			var taxarea = parseFloat(landarea)-parseFloat(taxfreearea)-parseFloat(reducearea)-parseFloat(hirelandreducearea)-parseFloat(hirehousesreducearea);
			$('#taxarea').val(taxarea.toFixed(2));
	}
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
	//计算计入计入房产原值的地价
	function cacultehouselandmoney(){
		var plotratio = $('#plotratio').val();
		var areaofstructure =  $('#areaofstructure').val();
		var landarea = $('#landarea').val();
		var landsellcost = $('#landsellcost').val();
		var landploughtaxcost = $('#landploughtaxcost').val();
		var landcontracttaxcost = $('#landcontracttaxcost').val();
		var landdevelopcost = $('#landdevelopcost').val();
		var landelsecost = $('#landelsecost').val();
		var houselandmoney = 0.00;
		if(plotratio>0.5){
			houselandmoney = parseFloat(landsellcost) + parseFloat(landploughtaxcost) + parseFloat(landcontracttaxcost) + parseFloat(landdevelopcost) + parseFloat(landelsecost)
			$('#houselandmoney').val(houselandmoney.toFixed(2));
		}else{
			if(parseFloat(landarea)>0){
				houselandmoney = (areaofstructure*2/landarea)*(parseFloat(landsellcost) + parseFloat(landploughtaxcost) + parseFloat(landcontracttaxcost) + parseFloat(landdevelopcost) + parseFloat(landelsecost))
				$('#houselandmoney').val(houselandmoney.toFixed(2));
				
			}else{
				 $('#houselandmoney').val("0.00");
			}
			 
		}
	}
	//计算容积率
	function caculterjl(){
		var areaofstructure = $('#areaofstructure').val();
		var landarea = $('#landarea').val();
		if(parseFloat(landarea)>0){
			var plotratio = areaofstructure/landarea;
			$('#plotratio').val(plotratio.toFixed(2));
		}else{
			$('#plotratio').val("0.00");
		}
	}
	
	function comparetdj(){
		var landsellcost = $('#landsellcost').val();
		var landploughtaxcost = $('#landploughtaxcost').val();
		var landcontracttaxcost = $('#landcontracttaxcost').val();
		var landdevelopcost = $('#landdevelopcost').val();
		var landelsecost = $('#landelsecost').val();
		var landmoney = $('#landmoney').val();
		var sum5 = parseFloat(landsellcost) + parseFloat(landploughtaxcost) + parseFloat(landcontracttaxcost) + parseFloat(landdevelopcost) + parseFloat(landelsecost);
		if(sum5<landmoney){
			$.messager.alert('返回消息','土地地价款必须大于土地总价');
			return false;
		}
		return true;
	}
	//提交
	function savetdxx(){
			//$.messager.alert('返回消息',$('.combo :text').length);
			//if(!$('#landcertificatetype').combo('isValid')){
			//	$.messager.alert('返回消息','土地证类型不能为空！');
			//	$('.combo :text')[5].focus();
			//	return;
			//}
			//if(!$('#landcertificate').validatebox('isValid')){
			//	$.messager.alert('返回消息','土地证号不能为空！');
			//	$('#landcertificate')[0].focus();
			//	return;
			//}
			//if(!$('#landcertificatedates').datebox('isValid')){
			//	$.messager.alert('返回消息','发证日期不能为空或校验有误！');
			//	$('.datebox :text')[0].focus();
			//	return;
			//}
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
			if(!$('#taxperiod').combo('isValid')){
				$.messager.alert('返回消息','土地使用税征期类型不能为空！');
				$('.combo :text')[12].focus();
				return;
			}
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
				$('.combo :text')[15].focus();
				return;
			}
			if(!$('#belongtowns').combo('isValid')){
				$.messager.alert('返回消息','所属乡镇不能为空！');
				$('.combo :text')[16].focus();
				return;
			}
			if(!$('#detailaddress').validatebox('isValid')){
				$.messager.alert('返回消息','详细地址不能为空！');
				$('#detailaddress')[0].focus();
				return;
			}
			if(!$('#landarea').validatebox('isValid')){
				$.messager.alert('返回消息','出让土地面积不能为空！');
				$('#landarea')[0].focus();
				return;
			}else{
				var landarea = $('#landarea').val();
				if(landarea>maxgroundarea){
					$.messager.alert('返回消息','出让土地面积不能大于最大可出让土地面积！');
					$('#landarea')[0].focus();
					return;
				}
				if(landarea == 0){
					$.messager.alert('返回消息','出让土地面积必须大于0！');
					$('#landarea')[0].focus();
					return;
				}
			}
			//if(!comparetdj()){
			//	return;
			//}
			var params = {};
			var fields =$('#groundsellform').serializeArray(); //自动序列化表单元素为JSON对象
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//params.landprice = $('#landprice').val();
			//params.houselandmoney = $('#houselandmoney').val();
			//params.plotratio = $('#plotratio').val();
			//params.taxarea = $('#taxarea').val();
			var groundinfo = $('#groundtransfergrid').datagrid('getSelected');
			params.businesstype = businesstype;
			params.estateid = groundinfo.estateid;
			params.landstoreid = groundinfo.landstoreid;
			params.landstorsubid = landstoresubid;
			params.taxpayerid = taxpayerid;
			params.taxpayername = taxpayername;
			params.landsource = '01';
			//params
			//params.gathertype ='01';//所有方填写
			//$.messager.alert('返回消息',$.toJSON(params));
			//return;
			//submitinfo.coreestatebvo=params;
			//$.messager.alert('返回消息',JSON.stringify(params));
			//$.messager.alert('返回消息',JSON.stringify(submitinfo));
			$.ajax({
					   type: "post",
					   url: "/TransferGroundServlet/savegroundtransferinfo.do",
					   data: params,
					   dataType: "json",
					   success: function(jsondata){
							//$('#addtdxxform').form('clear');
							//$('#addtdxxwindow').window('close');
							$.messager.alert('返回消息',"保存成功");
							//refreshestate();
							$('#groundtransfergrid').datagrid('reload');
							$('#groundbusinesswindow').window('close');
							//$('#btn1').linkbutton('disable');
							//$('#btn2').linkbutton('disable');
							//$.messager.alert('返回消息',$('#taxpayerid').val());
							//$('#groundtransfergrid').datagrid('reload');
							//$('#groundtransfergrid').datagrid('load',
							//	url:"/InitBaseInfoServlet/gettmpground.do",
							//	{taxpayerid: $('#taxpayerid').val()}
							//);
							//refreshTdxxgrid();
							//$('#groundtransfergrid').datagrid('load',{taxpayerid: $('#taxpayerid').val()}); 
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
	function quereyreg(){
		$('#reginfowindow').window('open');//打开新录入窗口
		$('#reginfowindow').window('refresh', 'reginfo.jsp');
	}
	</script>
	<div style="background:#f4f4f4;padding:3px 5px;">
		<a href="#" id="btn1" class="easyui-linkbutton" icon="icon-undo" plain="true" onclick="last()">上一步</a>
		<a href="#" id="btn2" class="easyui-linkbutton" icon="icon-save" plain="true" onclick="savetdxx()">保存</a>
	</div>
	<div class="easyui-panel" title="" style="overflow:auto;padding:10px">
	<form id="groundsellform" method="post">
		
			<table id="tdjcxx" class="table table-bordered" >
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
				<tr>
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
					<td align="right">
						受让方是否免税单位：
					</td>
					<td>
						<select id="freetax" class="easyui-combobox" name="freetax" style="width:200px;" data-options="required:true" editable="false">
							<option value="0">否</option>
							<option value="1">是</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">
						土地使用税税额：
					</td>
					<td>
						<select id="landtaxprice" class="easyui-combobox" name="landtaxprice" style="width:200px;" data-options="required:true" editable="false">
							<option value="1"  selected="true">1元/年.平方米</option>
							<option value="2">2元/年.平方米</option>
							<option value="3">3元/年.平方米</option>
						</select>
					</td>
					<td align="right">
						土地使用税申报征期类型：
					</td>
					<td>
						<input id="taxperiod" name="taxperiod" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:true,
						required:'true',panelWidth:300,panelHeight:200,
						data:levydatetypedata" />
					</td>
					
				</tr>
				<tr>
					<td align="right">
						使用年限起：
					</td>
					<td>
						<input id="limitbegins" name='limitbegins' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck','isAfter[\'#limitends\']']"></input>
					</td>
					<td align="right">
						使用年限止：
					</td>
					<td>
						<input id="limitends" name='limitends' class="easyui-datebox" style="width:200px;" data-options="validType:'datecheck'"></input>
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
					<td align="right">
						所属乡镇：
					</td>
					<td colspan="3">
						<input id="belongtowns" name="belongtowns" style="width:400px;" class="easyui-combobox" editable='false' data-options="
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
						<input id="detailaddress" class="easyui-validatebox" style="width:400px;" type="text" name="detailaddress" data-options="required:true"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
					出让总价（元）：
					</td>
					<td>
						<input id="landmoney" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landmoney" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
					<td align="right">
					出让土地面积（平方米）：
					</td>
					<td>
						<input id="landarea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landarea" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
					</td>
					
				</tr>
			</table>
		
		</form>
		
		</div>
</body>
  
</html>