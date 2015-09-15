<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <link href="<%=spath%>/css/modern.css" rel="stylesheet">
    <link href="<%=spath%>/css/modern-responsive.css" rel="stylesheet">
    <link href="<%=spath%>/css/droptiles.css" rel="stylesheet">
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

    
    <title>土地管税信息系统</title>

    <style>
        body {
            background-image:url(<%=spath%>/images/InBloom.jpg)  
        }
    </style>

    <script>

$(function(){
	$("#zzz").bind('click',function(){
		//alert($('#taxorgsupcode').combobox("getValue"));
		//alert($('#taxorgcode').combobox("getValue"));
		//alert($('#taxdeptcode').combobox("getValue"));
		//alert($('#taxmanagercode').combobox("getValue"));
var data = {"inserted":[{"leaseagreementno":"234","leasetaxpayerid":"23432","leasetaxpayername":"434","ispaygroundtax":"00","leasearea":"","agreeleasearea":"0.00","monthrent":"0.00","yearrent":"0.00","leasedatebegin":"","leasedateend":""},{"leaseagreementno":"234","leasetaxpayerid":"23432","leasetaxpayername":"434","ispaygroundtax":"00","leasearea":"","agreeleasearea":"0.00","monthrent":"0.00","yearrent":"0.00","leasedatebegin":"","leasedateend":""},{"leaseagreementno":"234","leasetaxpayerid":"23432","leasetaxpayername":"434","ispaygroundtax":"00","leasearea":"","agreeleasearea":"0.00","monthrent":"0.00","yearrent":"0.00","leasedatebegin":"","leasedateend":""}]};

		$.ajax({
	           type: "post",
	           url: "/TestServlet/test5.do",
	           data: $.toJSON(data),
	           contentType: "application/json; charset=utf-8",
	           dataType: "json",
	           success: function(jsondata){
					alert(jsondata);
	           }
	   });

	})

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
							//alert(n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//alert(JSON.stringify(jsondata.taxOrgOptionJsonArray));
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
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
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
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
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
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}



				   $('#taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
					//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray));
					
					//alert(JSON.stringify(jsondata.taxOrgOption));
					//alert(JSON.stringify(jsondata.taxDeptOption));
					//alert(JSON.stringify(jsondata.taxEmpOption));


					//alert(jsondata.funcMenuJson);
	           }
	   });
		//var items=[];
		



})


    </script>
</head>
<body>
	<h2>四级联动示例</h2>
	<div class="demo-info">
		<div class="demo-tip icon-tip"></div>
		<div>四级联动示例</div>
	</div>
	<div style="margin:10px 0;"></div>
	<div class="easyui-panel" title="" style="width:800px">
		<div style="padding:10px 0 10px 60px">
	    <form id="saveForm" method="post">
	    	<table>
	    		<tr>

	    			<td align="right">州市地税机关:</td>
	    			<td>
						<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" data-options="
									disabled:false,
									panelWidth: 300,
									panelHeight: 400
								">					
					</td>

	    			<td align="right">区县地税机关:</td>
	    			<td>
						<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" data-options="
									disabled:false,
									panelWidth: 300,
									panelHeight: 400
								">					
					</td>
	    		</tr>

	    		<tr>

	    			<td align="right">主管地税部门:</td>
	    			<td>
						<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="
									disabled:false,
									panelWidth: 300,
									panelHeight: 400
								">					
					</td>

	    			<td align="right">税收管理员:</td>
	    			<td>
						<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" data-options="
									disabled:false,
									panelWidth: 300,
									panelHeight: 400
								">					
					</td>
	    		</tr>

	    	</table>
	    </form>
	    </div>
	    <div style="text-align:center;padding:5px">
	    	<a href="javascript:void(0)" class="easyui-linkbutton" id="zzz">保存</a>
	    </div>
	</div>

</body>
</html>