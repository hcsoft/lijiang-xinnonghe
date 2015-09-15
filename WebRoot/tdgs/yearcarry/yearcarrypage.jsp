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

    <link rel="stylesheet" href="custom.css"/>
    <script>
	
    function slide(conInnerConWidth, tabHeight, index){
		$(".tab a").removeClass("current");
		$(".tab a").eq(index).addClass("current");
		$(".tab").css("background-position","0 -"+index*tabHeight+"px");
		$(".maskCon").animate({marginLeft:-index*conInnerConWidth+"px"});
		window.cur = index;
    }
    
	$(function(){
		  
		    
			
	});
	    
	function addCarryWindow(){
		$('#carryWindow').window('open');
	}
	function donext(index){
		var conInnerConWidth = $(".innerCon").width();
		var tabHeight = $(".tab a").height();
	    slide(conInnerConWidth, tabHeight, index);
    }
	function exit(){
		var oIframes = parent.$("iframe");
		var currentUrl = "/tdgs/yearcarry/yearcarrypage.jsp";
		for(var i = 0;i < oIframes.length;i++){
			var oSrc =  oIframes.get(i).src;
			if(oSrc.indexOf(currentUrl) != -1){
				var oDiv = $(oIframes.get(i)).parent().parent().parent();
				var oId = oDiv[0].id;
			    parent.$('#'+oId).dialog('close');
			}
		}
	}
		
		
	</script>
</head>
<body>
    <div id="carryDiv">
		<table id='carrygrid' class="easyui-datagrid" style="width:1320px;height:560px;overflow: scroll;"
				data-options="iconCls:'icon-edit',toolbar:'#tb',pageList:[15],rowStyler:settings.rowStyle">
			<thead>
				<tr>
				    <th data-options="field:'modelid',width:50,align:'center',checkbox:true,editor:{type:'checkbox'}"></th>
				    <th data-options="field:'modelname',width:120,align:'center',editor:{type:'validatebox'}">模板名称</th>
					<th data-options="field:'taxorgsupname',width:120,align:'center',editor:{type:'validatebox'}">市级机关</th>
					<th data-options="field:'taxorgname',width:120,align:'center',editor:{type:'validatebox'}">县级机关</th>
					<th data-options="field:'taxempname',width:120,align:'center',editor:{type:'validatebox'}">录入人</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="height:auto">
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="addCarryWindow()">新增结转</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openEdit()">修改</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteModel()">删除</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true" onclick="exit();">退出</a>
			</div>
		</div>
	</div>
	<div id="carryWindow" class="easyui-window" data-options="closed:true,modal:true,title:'年度结转',collapsible:false,minimizable:false,maximizable:false,closable:true">
					<div class="general feature_tour" >
					<div class="wrapper">
					<div class="tab">
						<a id="step1" href="#" class="current">选择结转年份</a>
						<a id="step2" href="#">数据准备</a>
						<a id="step3" href="#">自动结转</a>
						<a id="step4" href="#">结转结果查看</a>
						
					</div>
					<div class="mask">
					    <div class="maskCon">
					    
					        <div id="con1" class="innerCon">
					            <div style="margin-left: 180px;">
					        	<table  width="100%"  cellpadding="10" cellspacing="0">
								<tr id="con1_year">
									<td align="right">结转年度：</td>
									<td>
										<select id="carrayear" class="easyui-combobox" name="year_windows" style="width:160px;"/>
									</td>
								</tr>
								<tr id="con1_date">
									<td align="right">所属期：</td>
									<td>
										<select id="taxdate_show" class="easyui-combobox" name="taxdate_show" style="width:160px;"/>
									</td>
								</tr>
								</table>
								</div>
								<div style="text-align:center;padding-top: 10px;" >  	
									<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_right'" onclick="donext(1)" >下一步</a>
								</div>
								
							</div>
					        
					        <div id="con2" class="innerCon">
					        	<table id="check_table"  cellpadding="10" cellspacing="0" class="easyui-datagrid" data-options="title:'检查',singleSelect:true,fitColumns:true">
								<thead>
									<tr>
										<th></th>
										<th colspan="2">应纳税汇总</th>
										<th colspan="2">纳税汇总</th>
									</tr>
									<tr>
										<th data-options="field:'taxname',width:150">税目</th>
										<th data-options="field:'taxcode',hidden:true">税目代码</th>
										<th data-options="field:'num',width:100,align:'center'">应纳税户数</th>
										<th data-options="field:'taxamountactual',width:120,align:'right'">应纳税金额</th>
										<th data-options="field:'num1',width:100,align:'center'">纳税户数</th>
										<th data-options="field:'taxamountactual1',width:120,align:'right'">纳税金额</th>
									</tr>
								</thead>
								</table>
								<div style="text-align:center;padding:5px;" >  	
						        	<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_left'" onclick="donext(0)" >上一步</a>
						        	<a id="check_next_button" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_right'" onclick="donext(2)" >下一步</a>
					        	</div>
					        </div>
					        
					        <div id="con3" class="innerCon">
					        	<table id="taxsettlement_table" width="100%"  cellpadding="10" cellspacing="0" class="easyui-datagrid" data-options="title:'清缴结果',singleSelect:true,fitColumns:true">
								<thead>
									<tr>
										<th data-options="field:'clearlogid',width:80,hidden:'true'">清缴id</th>
										<th data-options="field:'type',width:80,align:'left'">类型</th>
										<th data-options="field:'num',width:300,align:'center'">户数</th>
										<th data-options="field:'taxamountactual',width:100,align:'right'">金额</th>
									</tr>
								</thead>
								</table>
					        	<div style="text-align:center;padding:5px;" > 
						 			<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_left'" onclick="donext(1)" >上一步</a>
						        	<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_right'" onclick="donext(3)" >下一步</a>
					        	</div> 
					        </div>
					        
					        <div id="con4" class="innerCon">
					        		<div style="text-align:left;">  
											<div style="background-color: #c9c692;height: 25px;">		
													<span style="font-size: 12px; color:red; font-weight: bold;">过滤条件：</span>
													<span style="font-size: 12px;"><input type="radio" checked="checked" name="querytype" value="3" onclick="dodeal(3)"/>比对差异</span>&nbsp;
													<span style="font-size: 12px;"><input type="radio"  name="querytype" value="1" onclick="dodeal(1)"/>比对欠税/税源差异</span>&nbsp;
													<span style="font-size: 12px;"><input type="radio"  name="querytype" value="4" onclick="dodeal(4)"/>比对清缴</span>&nbsp;
													<span style="font-size: 12px;"><input type="radio"  name="querytype" value="2" onclick="dodeal(2)"/>人工确认欠税</span>&nbsp;
													<span style="font-size: 12px;"><input type="radio"  name="querytype" value="5" onclick="dodeal(5)"/>人工确认清缴</span>&nbsp;
											</div>
									</div>
					        		<div style="width:950px;height:200px">
										<table id="settlementgrid1" title='已纳税' style="width:950px;height:200px"></table>
									</div>
									<div style="width:950px;height:200px">
										<table id="settlementgrid2" title='应纳税' style="width:950px;height:200px"></table>
									</div>
									<div style="text-align:center;padding:5px;" > 
										<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_left'" onclick="donext(2)" >上一步</a>
										<a id="manualbutton1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_flag_red'" onclick="manual(2)" >人工确认欠税</a>
										<a id="manualbutton2"  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="manual(5)" >人工确认清缴</a>
										<a id="manualbutton3" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="manual(3)" >回退</a>
										<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#settlement_windows').window('close');" >关闭</a>
					        		</div> 
					        </div>
					        
					    </div>
					</div>
				</div>
				</div> 		
			</div>
</body>
</html>