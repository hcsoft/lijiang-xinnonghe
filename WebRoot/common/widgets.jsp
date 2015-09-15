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
	<script src="<%=spath%>/js/common.js"></script>
</head>
<body>
  <!-- 土地基础信息     a-->
  <div id="estateinfowindowxuhongsub_widget">
				<table id="narjcxx" width="100%"  class="table table-bordered">
				    <tr>
						<td align="right">宗地来源：</td>
						<td>
							<input class="easyui-validatebox" type="text" name="landsourcenamexuhong_a" id="landsourcenamexuhong_a"/>		
							<input class="easyui-validatebox" type="hidden" name="landsourcexuhong_a" id="landsourcexuhong_a"/>			
						</td>
						<td align="right">宗地编号：</td>
						<td>
							<input class="easyui-validatebox" type="text" name="estateserialnoxuhong_a" id="estateserialnoxuhong_a"/>					
						</td>
					</tr>
					<tr>
						<td align="right">土地证类型：</td>
						<td>
							<input class="easyui-validatebox" type="text" name="landcertificatetypenamexuhong_a" id="landcertificatetypenamexuhong_a"/>					
						</td>
						<td align="right">土地证号：</td>
						<td>
							<input id="landcertificatexuhong_a" class="easyui-validatebox" type="text" name="landcertificatexuhong_a"/>
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="taxpayeridxuhong_a" class="easyui-validatebox" type="text" name="taxpayeridxuhong_a" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayernamexuhong_a" class="easyui-validatebox" type="text" name="taxpayernamexuhong_a"/>
						</td>
					</tr>
					<tr>
						<td align="right">发证日期：</td>
						<td><input id="landcertificatedatexuhong_a" class="easyui-validatebox" type="text" name="landcertificatedatexuhong_a"/></td>
						<td align="right">获得土地时间：</td>
						<td>
							<input id="holddatexuhong_a" class="easyui-validatebox" type="text" name="holddatexuhong_a"/>
						</td>
					</tr>
					<tr>
						<td align="right">使用起日期：</td>
						<td><input id="datebeginxuhong_a" class="easyui-validatebox" type="text" name="datebeginxuhong_a"/></td>
						<td align="right">使用止日期：</td>
						<td>
							<input id="dateendxuhong_a" class="easyui-validatebox" type="text" name="dateendxuhong_a"/>
						</td>
					</tr>
					<tr>
					    <td align="right">坐落地类型：</td>
						<td>
							<input class="easyui-validatebox" type="text" name="locationtypenamexuhong_a" id="locationtypenamexuhong_a"/>					
						</td>
						<td align="right">所属村委会：</td>
						<td><input id="belongtocountrynamexuhong_a" class="easyui-validatebox" type="text" name="belongtocountrynamexuhong_a"/></td>
					</tr>
					<tr>
					    <td align="right">获得土地总价：</td>
						<td>
							<input class="easyui-validatebox" type="text" name="landmoneyxuhong_a" id="landmoneyxuhong_a" style="text-align: right;"/>					
						</td>
						<td align="right">土地面积：</td>
						<td><input id="landareaxuhong_a" class="easyui-validatebox" type="text" name="landareaxuhong_a" style="text-align: right;"/></td>
					</tr>
					<tr>
					    <td align="right">使用权面积：</td>
						<td>
							<input class="easyui-validatebox" type="text" name="taxareaxuhong_a" id="taxareaxuhong_a" style="text-align: right;"/>					
						</td>
						<td align="right">土地单价：</td>
						<td><input id="landunitpricexuhong_a" class="easyui-validatebox" type="text" name="landunitpricexuhong_a" style="text-align: right;"/></td>
					</tr>
					<tr>
					    <td align="right">土地使用税税率：</td>
						<td>
							<input class="easyui-validatebox" type="text" name="taxratexuhong_a" id="taxratexuhong_a" style="text-align: right;"/>					
						</td>
						<td align="right">容积率：</td>
						<td><input id="plotratioxuhong_a" class="easyui-validatebox" type="text" name="plotratioxuhong_a" style="text-align: right;"/></td>
					</tr>
					<tr>
					    <td align="right">详细地址：</td>
						<td colspan="3">
							<input class="easyui-validatebox" type="text" name="detailaddressxuhong_a" id="detailaddressxuhong_a" style="width:300px;"/>					
						</td>
					</tr>
				</table>
	</div>
	<!-- b -->
	<div id="landstoreinfwindow_widget_b">
	   <div class="easyui-panel">
			<form id="avoidtaxinfoform_widget_b" method="post">
				<fieldset><font color="blue" style="font-weight: bold;">土地批复信息</font>
				<table id="" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayernamexuhong_b" class="easyui-validatebox"  name="taxpayernamexuhong_b" readonly="true"/>					
						</td>
						<td align="right">批复日期：</td>
						<td>
							<input id="approvedatexuhong_b" class="easyui-validatebox" name="approvedatexuhong_b" readonly="true"/>					
						</td>
					</tr>
					<tr>
						<td align="right">批复总面积：</td>
						<td>
							<input id="areatotalxuhong_b" class="easyui-validatebox" name="areatotalxuhong_b" style="text-align: right;"  readonly="true"/>					
						</td>
						<td align="right">农用地面积：</td>
						<td>
							<input id="areaploughxuhong_b" class="easyui-validatebox"  name="areaploughxuhong_b" style="text-align: right;"  readonly="true"/>					
						</td>
					</tr>
					<tr>
						
						<td align="right">建设用地面积：</td>
						<td>
							<input id="areabuildxuhong_b" class="easyui-validatebox" name="areabuildxuhong_b" style="text-align: right;"  readonly="true"/>					
						</td>
						<td align="right">未利用地面积：</td>
						<td>
							<input id="areauselessxuhong_b" class="easyui-validatebox"  name="areauselessxuhong_b" style="text-align: right;"  readonly="true"/>					
						</td>
					</tr>
					<tr>
						<td align="right">耕占税单位税额：</td>
						<td>
							<input id="taxpricexuhong_b" class="easyui-validatebox"  name="taxpricexuhong_b" style="text-align: right;" readonly="true"/>			
						</td>
						<td align="right">批复名称：</td>
						<td>
							<input id="namexuhong_b" class="easyui-validatebox" name="namexuhong_b" readonly="true"/>					
						</td>
					</tr>
				</table>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- c -->
	<!-- 查询土地批复信息 -->
	<div id="commonquerywindowxuhong_widget_c">
		<div id="commonquerywindowxuhong_widget_panel_c" class="easyui-panel" style="width:720px;">
			<form id="commonqueryformxuhong_widget_c" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcodexuhong_c" id="taxorgsupcodexuhong_c" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcodexuhong_c" id="taxorgcodexuhong_c" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcodexuhong_c" id="taxdeptcodexuhong_c" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercodexuhong_c" id="taxmanagercodexuhong_c" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="taxpayeridxuhong_c" class="easyui-validatebox" type="text" name="taxpayeridxuhong_c" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)" style="width:250px"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayernamexuhong_c" class="easyui-validatebox" type="text" name="taxpayernamexuhong_c" style="width:250px"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div style="text-align:center;padding:5px;height: 25px;">  
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" id="commonquerywindowxuhong_widget_a_c">查询</a>
	    </div>
		
	</div>
	
	<!-- 查询土地基础信息的查询条件  以d结尾 -->
	<div id="baseestatequerywindowxuhong_widget_d" class="easyui-window">
		<div class="easyui-panel" style="width:720px;" id="baseestatequerypanelxuhong_widget_d">
			<form id="baseestatequeryformxuhong_widget_d" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcodexuhong_d" id="taxorgsupcodexuhong_d" style="width:250px"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcodexuhong_d" id="taxorgcodexuhong_d" style="width:250px"/>					
						</td>
					</tr>
					
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcodexuhong_d" id="taxdeptcodexuhong_d" style="width:250px"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercodexuhong_d" id="taxmanagercodexuhong_d" style="width:250px"/>					
						</td>
					</tr>
					<tr>
						<td align="right">坐落地类型：</td>
						<td>
							<input class="easyui-combobox" name="locationtypexuhong_d" id="locationtypexuhong_d" style="width:250px"/>					
						</td>
						<td align="right">土地证类型：</td>
						<td>
							<input class="easyui-combobox" name="landcertificatetypexuhong_d" id="landcertificatetypexuhong_d" style="width:250px"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="taxpayerid1" class="easyui-validatebox" type="text" name="taxpayeridxuhong_d" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)" style="width:250px"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername1" class="easyui-validatebox" type="text" name="taxpayernamexuhong_d" style="width:250px"/>
						</td>
					</tr>
					<tr>
						<td align="right">宗地编号：</td>
						<td><input id="estateserialnoxuhong_d" class="easyui-validatebox" type="text" name="estateserialnoxuhong_d" style="width:250px"/></td>
						<td align="right">土地证号：</td>
						<td>
							<input id="landcertificatexuhong_d" class="easyui-validatebox" type="text" name="landcertificatexuhong_d" style="width:250px"/>
						</td>
					</tr>
					<tr>
						<td align="right">所属期：</td>
						<td colspan="5">
							<input id="beginholddatexuhong_d" class="easyui-datebox" name="beginholddatexuhong_d"/>
						至
							<input id="endholddatexuhong_d" class="easyui-datebox"  name="endholddatexuhong_d"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
	    <div style="text-align:center;padding:5px;height: 25px;">  
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" id="baseestatequerypanelxuhong_widget_d_a">查询土地</a>
	    </div>
	</div>
	
	<!-- 查询房产信息的查询条件  以e结尾 -->
	<div id="basehouseinfoquerywindowxuhong_widget_d">
		<div class="easyui-panel" style="width:720px;" id="basehouseinfoquerypanelxuhong_widget_d">
			<form id="basehouseinfoqueryformxuhong_widget_d" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcodexuhong_e" id="taxorgsupcodexuhong_e" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcodexuhong_e" id="taxorgcodexuhong_e" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						
					</tr>
					
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcodexuhong_e" id="taxdeptcodexuhong_e" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercodexuhong_e" id="taxmanagercodexuhong_e" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="taxpayeridxuhong_e" class="easyui-validatebox" type="text" name="taxpayeridxuhong_e" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)" style="width:250px"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayernamexuhong_e" class="easyui-validatebox" type="text" name="taxpayernamexuhong_e" style="width:250px"/>
						</td>

					</tr>
					<tr>
						<td align="right">详细地址：</td>
						<td><input id="detailaddressxuhong_e" class="easyui-validatebox" type="text" name="detailaddressxuhong_e" style="width:250px"/></td>
						<td align="right">房产证号：</td>
						<td>
							<input id="housecertificatexuhong_e" class="easyui-validatebox" type="text" name="housecertificatexuhong_e" style="width:250px"/>
						</td>

					</tr>
					<tr>
						<td align="right">投入使用日期：</td>
						<td colspan="5">
							<input id="usedatebeginxuhong_e" class="easyui-datebox" name="usedatebeginxuhong_e"/>
						至
							<input id="usedateendxuhong_e" class="easyui-datebox"  name="usedateendxuhong_e"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
	    <div style="text-align:center;padding:5px;height: 25px;">  
			 <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" id="basehouseinfoquerypanelxuhong_widget_d_a">查询</a>
	    </div>
	</div>
	<!--  房产基础信息  以f结尾-->
	<div id="basehouseinfowindowxuhongsub_widget">
				<table id="narjcxx1x" width="100%"  class="table table-bordered">
					<tr>
					    <td align="right">计算机编码：</td>
						<td>
							<input id="taxpayerid_xuhongf" class="easyui-validatebox" name="taxpayerid_xuhongf"  readonly="true" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername_xuhongf" class="easyui-validatebox" name="taxpayername_xuhongf" readonly="true"/>	
						</td>
					</tr>
					<tr>
						<td align="right">房产来源：</td>
						<td>
							<input class="easyui-validatebox"  id="housesourcename_xuhongf"  name="housesourcename_xuhongf"/>	
						</td>
						<td align="right">房产建筑面积：</td>
						<td>
							<input class="easyui-validatebox"  id="housearea_xuhongf"  name="housearea_xuhongf" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td align="right">投入使用日期：</td>
						<td>
							<input id="usedate_xuhongf" class="easyui-validatebox" name="usedate_xuhongf"/>	
						</td>
						<td align="right">详细地址：</td>
						<td>
							<input class="easyui-validatebox"  id="detailaddress_xuhongf" name="detailaddress_xuhongf"/>	
						</td>
					</tr>
					<tr>
						<td align="right">所属村委会：</td>
						<td>
							<input class="easyui-validatebox"  id="belongtownsname_xuhongf"  name="belongtownsname_xuhongf"/>	
						</td>
						<td align="right">房产原值：</td>
						<td>
							<input class="easyui-validatebox"  id="housetaxoriginalvalue_xuhongf"  name="housetaxoriginalvalue_xuhongf" style="text-align: right;"/>				
						</td>
					</tr>
					<tr>
						<td align="right">房产证号：</td>
						<td>
							<input id="housecertificate_xuhongf" class="easyui-validatebox" type="text" name="housecertificate_xuhongf"/>					
						</td>
						<td align="right">填发日期：</td>
						<td>
							<input id="housecertificatedate_xuhongf" class="easyui-validatebox" type="text" name="housecertificatedate_xuhongf"/>					
						</td>
					</tr>
					<tr>
						<td align="right">权属性质：</td>
						<td>
							<input class="easyui-validatebox"  id="natureofproperty_xuhongf"  name="natureofproperty_xuhongf" />					
						</td>
						<td align="right">用途：</td>
						<td>
							<input class="easyui-validatebox"  id="designapplication_xuhongf"  name="designapplication_xuhongf" />					
						</td>
					</tr>
				</table>
	</div>
</body>
</html>