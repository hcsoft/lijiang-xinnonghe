<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

<title>Complex Layout - jQuery EasyUI Demo</title>

<link rel="stylesheet" href="<%=spath%>/themes/default/easyui.css">
<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
<link rel="stylesheet" href="<%=spath%>/css/logout.css" />
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
var estateid;
		$(function() {
			//$(ed.target).bind('keyup', function(){
			//	$('.icon-save1').css('background','#FFFF00');
			//$('.icon-save1').bind('click',function() 
			//	{ 
			//		alert('aaa');
			//		//savetdxx(); 
			//	}
			//);
			var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');
			if (showtype == '0') {
				$('#btn').hide();
			}
			if(tdxxrow.landsource=='03'){
				$('#tdjcxx td:eq(38)').html('年租金（元） ：');
				$("#landmoney").unbind();
				$('#landsellcost').attr('disabled',true);
				$('#landploughtaxcost').attr('disabled',true);
				$('#landcontracttaxcost').attr('disabled',true);
				$('#landdevelopcost').attr('disabled',true);
				$('#landelsecost').attr('disabled',true);
				//$("#landmoney").unbind("blur", cacultetdmj);
			}
			//alert(tdxxrow.landsource);
			//if(tdxxrow.landsource!='03' && tdxxrow.landsource!='05'){
			//alert('aaa');
			//	$('#norentuseflag').html("");
			//	$('#norentuseflag').remove();
			//	$('#estateserial').attr("colspan",'3');

			//}
			refreshestate();
			$('#tab').tabs({
			onSelect:function(title){
				var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');
				estateid = tdxxrow.estateid;
				var tab = $('#tab').tabs('getSelected');
				if(tab.panel('options').title=='减免信息'){
					if($('#jmxx').length >0 || $('#tdczfxx').length >0 || $('#zjfcxx').length >0 || $('#fcjcxx').length >0){
						if($('#jmxx').length >0){
							var detailindex = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
							$('#jmxx').datagrid('endEdit', detailindex);
							if($('#jmxx').datagrid('getChanges').length>0){
								alert('减免信息未保存！');
								return;
							}
						}
						if($('#tdczfxx').length >0){
							var detailindex = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
							$('#tdczfxx').datagrid('endEdit', detailindex);
							if($('#tdczfxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "土地承租方信息");
								return;
							}
						}
						if($('#zjfcxx').length >0){
							var detailindex = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
							$('#zjfcxx').datagrid('endEdit', detailindex);
							if($('#zjfcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "在建房产信息");
								return;
							}
						}
						if($('#fcjcxx').length >0){
							var detailindex = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
							$('#fcjcxx').datagrid('endEdit', detailindex);
							if($('#fcjcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "房产基础信息");
								return;
							}
						}
					}
					$('#tab').tabs('update', {
						tab: tab,
						options: {
							href: '../grounddetail/b.jsp'
						}
					});
				}
				if(tab.panel('options').title=='土地承租方信息'){
					if($('#jmxx').length >0 || $('#tdczfxx').length >0 || $('#zjfcxx').length >0 || $('#fcjcxx').length >0){
						if($('#jmxx').length >0){
							var detailindex = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
							$('#jmxx').datagrid('endEdit', detailindex);
							if($('#jmxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "减免信息");
								return;
							}
						}
						if($('#tdczfxx').length >0){
							var detailindex = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
							$('#tdczfxx').datagrid('endEdit', detailindex);
							if($('#tdczfxx').datagrid('getChanges').length>0){
								alert('土地承租方信息未保存！');
								return;
							}
						}
						if($('#zjfcxx').length >0){
							var detailindex = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
							$('#zjfcxx').datagrid('endEdit', detailindex);
							if($('#zjfcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "在建房产信息");
								return;
							}
						}
						if($('#fcjcxx').length >0){
							var detailindex = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
							$('#fcjcxx').datagrid('endEdit', detailindex);
							if($('#fcjcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "房产基础信息");
								return;
							}
						}
					}
					$('#tab').tabs('update', {
						tab: tab,
						options: {
							href: '../grounddetail/c.jsp'
						}
					});
				}
				if(tab.panel('options').title=='土地转租方信息'){
					if($('#jmxx').length >0 || $('#tdczfxx').length >0 || $('#zjfcxx').length >0 || $('#fcjcxx').length >0){
						if($('#jmxx').length >0){
							var detailindex = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
							$('#jmxx').datagrid('endEdit', detailindex);
							if($('#jmxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "减免信息");
								return;
							}
						}
						if($('#tdczfxx').length >0){
							var detailindex = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
							$('#tdczfxx').datagrid('endEdit', detailindex);
							if($('#tdczfxx').datagrid('getChanges').length>0){
								alert('土地转租方信息未保存！');
								return;
							}
						}
						if($('#zjfcxx').length >0){
							var detailindex = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
							$('#zjfcxx').datagrid('endEdit', detailindex);
							if($('#zjfcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "在建房产信息");
								return;
							}
						}
						if($('#fcjcxx').length >0){
							var detailindex = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
							$('#fcjcxx').datagrid('endEdit', detailindex);
							if($('#fcjcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "房产基础信息");
								return;
							}
						}
					}
					$('#tab').tabs('update', {
						tab: tab,
						options: {
							href: '../grounddetail/c-1.jsp'  // the new content URL
						}
					});
					
				}
				if(tab.panel('options').title=='土地减少信息'){
					if($('#jmxx').length >0 || $('#tdczfxx').length >0 || $('#zjfcxx').length >0 || $('#fcjcxx').length >0){
						if($('#jmxx').length >0){
							var detailindex = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
							$('#jmxx').datagrid('endEdit', detailindex);
							if($('#jmxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "减免信息");
								return;
							}
						}
						if($('#tdczfxx').length >0){
							var detailindex = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
							$('#tdczfxx').datagrid('endEdit', detailindex);
							if($('#tdczfxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "土地承租方信息");
								return;
							}
						}
						if($('#zjfcxx').length >0){
							var detailindex = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
							$('#zjfcxx').datagrid('endEdit', detailindex);
							if($('#zjfcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "在建房产信息");
								return;
							}
						}
						if($('#fcjcxx').length >0){
							var detailindex = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
							$('#fcjcxx').datagrid('endEdit', detailindex);
							if($('#fcjcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "房产基础信息");
								return;
							}
						}
					}
					$('#tab').tabs('update', {
						tab: tab,
						options: {
							href: '../grounddetail/d.jsp'
						}
					});
				}
				if(tab.panel('options').title=='土地基础信息'){
					if($('#jmxx').length >0 || $('#tdczfxx').length >0 || $('#zjfcxx').length >0 || $('#fcjcxx').length >0){
						if($('#jmxx').length >0){
							var detailindex = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
							$('#jmxx').datagrid('endEdit', detailindex);
							if($('#jmxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "减免信息");
								return;
							}
						}
						if($('#tdczfxx').length >0){
							var detailindex = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
							$('#tdczfxx').datagrid('endEdit', detailindex);
							if($('#tdczfxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "土地承租方信息");
								return;
							}
						}
						if($('#zjfcxx').length >0){
							var detailindex = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
							$('#zjfcxx').datagrid('endEdit', detailindex);
							if($('#zjfcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "在建房产信息");
								return;
							}
						}
						if($('#fcjcxx').length >0){
							var detailindex = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
							$('#fcjcxx').datagrid('endEdit', detailindex);
							if($('#fcjcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "房产基础信息");
								return;
							}
						}
					}
					//$('#tab').tabs('update', {
					//	tab: tab,
					//	options: {
					//		href: '../grounddetail/groundallinfo.jsp'
					//	}
					//});
				}
				if(tab.panel('options').title=='在建房产信息'){
					if($('#jmxx').length >0 || $('#tdczfxx').length >0 || $('#zjfcxx').length >0 || $('#fcjcxx').length >0){
						if($('#jmxx').length >0){
							var detailindex = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
							$('#jmxx').datagrid('endEdit', detailindex);
							if($('#jmxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "减免信息");
								return;
							}
						}
						if($('#tdczfxx').length >0){
							var detailindex = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
							$('#tdczfxx').datagrid('endEdit', detailindex);
							if($('#tdczfxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "土地承租方信息");
								return;
							}
						}
						if($('#zjfcxx').length >0){
							var detailindex = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
							$('#zjfcxx').datagrid('endEdit', detailindex);
							if($('#zjfcxx').datagrid('getChanges').length>0){
								alert("在建房产信息未保存！");
								return;
							}
						}
						if($('#fcjcxx').length >0){
							var detailindex = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
							$('#fcjcxx').datagrid('endEdit', detailindex);
							if($('#fcjcxx').datagrid('getChanges').length>0){
								$('#tab').tabs('select', "房产基础信息");
								return;
							}
						}
					}
					$('#tab').tabs('update', {
						tab: tab,
						options: {
							href: '../grounddetail/e.jsp'
						}
					});
				}
				if(tab.panel('options').title=='房产基础信息'){
					if(tdxxrow.landsource=='03'){
						if($('#jmxx').length >0 || $('#tdczfxx').length >0 || $('#zjfcxx').length >0 || $('#fcjcxx').length >0){
							if($('#jmxx').length >0){
								var detailindex = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
								$('#jmxx').datagrid('endEdit', detailindex);
								if($('#jmxx').datagrid('getChanges').length>0){
									$('#tab').tabs('select', "减免信息");
									return;
								}
							}
							if($('#tdczfxx').length >0){
								var detailindex = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
								$('#tdczfxx').datagrid('endEdit', detailindex);
								if($('#tdczfxx').datagrid('getChanges').length>0){
									$('#tab').tabs('select', "土地承租方信息");
									return;
								}
							}
							if($('#zjfcxx').length >0){
								var detailindex = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
								$('#zjfcxx').datagrid('endEdit', detailindex);
								if($('#zjfcxx').datagrid('getChanges').length>0){
									$('#tab').tabs('select', "在建房产信息");
									return;
								}
							}
							if($('#fcjcxx').length >0){
								var detailindex = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
								$('#fcjcxx').datagrid('endEdit', detailindex);
								if($('#fcjcxx').datagrid('getChanges').length>0){
									alert("房产基础信息未保存！");
									return;
								}
							}
						}
						$('#tab').tabs('update', {
							tab: tab,
							options: {
								href: '../grounddetail/f-1.jsp'  // the new content URL
							}
						});
					}else{
						if($('#jmxx').length >0 || $('#tdczfxx').length >0 || $('#zjfcxx').length >0 || $('#fcjcxx').length >0){
							if($('#jmxx').length >0){
								var detailindex = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
								$('#jmxx').datagrid('endEdit', detailindex);
								if($('#jmxx').datagrid('getChanges').length>0){
									$('#tab').tabs('select', "减免信息");
									return;
								}
							}
							if($('#tdczfxx').length >0){
								var detailindex = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
								$('#tdczfxx').datagrid('endEdit', detailindex);
								if($('#tdczfxx').datagrid('getChanges').length>0){
									$('#tab').tabs('select', "土地承租方信息");
									return;
								}
							}
							if($('#zjfcxx').length >0){
								var detailindex = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
								$('#zjfcxx').datagrid('endEdit', detailindex);
								if($('#zjfcxx').datagrid('getChanges').length>0){
									$('#tab').tabs('select', "在建房产信息");
									return;
								}
							}
							if($('#fcjcxx').length >0){
								var detailindex = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
								$('#fcjcxx').datagrid('endEdit', detailindex);
								if($('#fcjcxx').datagrid('getChanges').length>0){
									alert("房产基础信息未保存！");
									return;
								}
							}
						}
						$('#tab').tabs('update', {
							tab: tab,
							options: {
								href: '../grounddetail/f.jsp'  // the new content URL
							}
						});
						
					}
				}
			}
		});
			// $("input").focus();
		});

		function refreshestate() {
			//if(opttype=='edit'){
			var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');
			if (tdxxrow) {
				$.ajax({
					type : "post",
					url : "/GroundInfoServlet/getestateinfo.do",
					data : {
						estateid : tdxxrow.estateid
					},//fe2cca196b9cc4eb002be72a2e8673a7
					dataType : "json",
					success : function(jsondata) {
						$('#grounddetailform').form('load',
								jsondata);
						//alert('aaaa');
						//alert(jsondata.coreestatebvo);
						//$('#detailaddress').val(tdxxrow.groundaddress);
						//$('#detailaddress').val(tdxxrow.groundaddress);
					}
				});
			}
			//}
		}

		//计算土地应税面积
		function cacultetdmj() {
			var landarea = $('#landarea').val();
			if (isNaN(landarea) || landarea < 0) {
				landarea = 0;
			}
			var taxfreearea = $('#taxfreearea').val();
			if (isNaN(taxfreearea) || taxfreearea < 0) {
				taxfreearea = 0;
			}
			var reducearea = $('#reducearea').val();
			if (isNaN(reducearea) || reducearea < 0) {
				reducearea = 0;
			}
			var hirelandreducearea = $('#hirelandreducearea').val();
			if (isNaN(hirelandreducearea) || hirelandreducearea < 0) {
				hirelandreducearea = 0;
			}
			var hirehousesreducearea = $('#hirehousesreducearea').val();
			if (isNaN(hirehousesreducearea) || hirehousesreducearea < 0) {
				hirehousesreducearea = 0;
			}
			//alert(hirehousesreducearea);
			var taxarea = parseFloat(landarea) - parseFloat(taxfreearea)
					- parseFloat(reducearea) - parseFloat(hirelandreducearea)
					- parseFloat(hirehousesreducearea);
			$('#taxarea').val(taxarea.toFixed(2));
		}
		//计算土地单价
		function cacultedj() {
			var landarea = $('#landarea').val();
			var landmoney = $('#landmoney').val();
			if (parseFloat(landarea) > 0) {
				var landprice = parseFloat(landmoney) / parseFloat(landarea);
				$('#landprice').val(landprice.toFixed(2));
			} else {
				$('#landprice').val("0.00");
			}
		}
		//计算计入计入房产原值的地价
		function cacultehouselandmoney() {
			var plotratio = $('#plotratio').val();
			var areaofstructure = $('#areaofstructure').val();
			var landarea = $('#landarea').val();
			var landsellcost = $('#landsellcost').val();
			var landploughtaxcost = $('#landploughtaxcost').val();
			var landcontracttaxcost = $('#landcontracttaxcost').val();
			var landdevelopcost = $('#landdevelopcost').val();
			var landelsecost = $('#landelsecost').val();
			var houselandmoney = 0.00;
			var sum5 = parseFloat(landsellcost) + parseFloat(landploughtaxcost)
					+ parseFloat(landcontracttaxcost)
					+ parseFloat(landdevelopcost) + parseFloat(landelsecost);
			$('#landmoney').val(sum5);
			if (plotratio > 0.5) {
				houselandmoney = parseFloat(landsellcost)
						+ parseFloat(landploughtaxcost)
						+ parseFloat(landcontracttaxcost)
						+ parseFloat(landdevelopcost)
						+ parseFloat(landelsecost)
				$('#houselandmoney').val(houselandmoney.toFixed(2));
			} else {
				if (parseFloat(landarea) > 0) {
					houselandmoney = (areaofstructure * 2 / landarea)
							* (parseFloat(landsellcost)
									+ parseFloat(landploughtaxcost)
									+ parseFloat(landcontracttaxcost)
									+ parseFloat(landdevelopcost) + parseFloat(landelsecost))
					$('#houselandmoney').val(houselandmoney.toFixed(2));

				} else {
					$('#houselandmoney').val("0.00");
				}

			}
		}
		//计算容积率
		function caculterjl() {
			var areaofstructure = $('#areaofstructure').val();
			var landarea = $('#landarea').val();
			if (parseFloat(landarea) > 0) {
				var plotratio = areaofstructure / landarea;
				$('#plotratio').val(plotratio.toFixed(2));
			} else {
				$('#plotratio').val("0.00");
			}
		}

		function comparetdj() {
			var landsellcost = $('#landsellcost').val();
			var landploughtaxcost = $('#landploughtaxcost').val();
			var landcontracttaxcost = $('#landcontracttaxcost').val();
			var landdevelopcost = $('#landdevelopcost').val();
			var landelsecost = $('#landelsecost').val();
			var landmoney = $('#landmoney').val();
			var sum5 = parseFloat(landsellcost) + parseFloat(landploughtaxcost)
					+ parseFloat(landcontracttaxcost)
					+ parseFloat(landdevelopcost) + parseFloat(landelsecost);
			if (sum5 < landmoney) {
				alert('土地地价款必须大于土地总价');
				return false;
			}
			return true;
		}
		//提交
		function savetdxx() {
			if (!$('#selfnumber').validatebox('isValid')) {
				$('#accord').accordion('select', 0);
				alert('土地自编号不能为空！');
				$('#selfnumber')[0].focus();
				return;
			}
			if (!$('#landsource').combo('isValid')) {
				//alert($('#landsource')[0].value);
				$('#accord').accordion('select', 0);
				alert('土地来源不能为空！');
				$('.combo :text')[0].focus();
				return;
			}
			if (!$('#landcertificate').validatebox('isValid')) {
				$('#accord').accordion('select', 0);
				alert('土地证号不能为空！');
				$('#landcertificate')[0].focus();
				return;
			}
			if (!$('#landcertificatedates').datebox('isValid')) {
				$('#accord').accordion('select', 0);
				alert('发证日期不能为空或校验有误！');
				$('.datebox :text')[0].focus();
				return;
			}
			if (!$('#holddates').datebox('isValid')) {
				$('#accord').accordion('select', 0);
				alert('交付土地时间不能为空或校验有误！');
				$('.datebox :text')[1].focus();
				return;
			}
			if (!$('#limitbegins').datebox('isValid')) {
				$('#accord').accordion('select', 0);
				alert('使用年限起校验有误！');
				$('.datebox :text')[2].focus();
				return;
			}
			if (!$('#limitends').datebox('isValid')) {
				$('#accord').accordion('select', 0);
				alert('使用年限止校验有误！');
				$('.datebox :text')[3].focus();
				return;
			}
			if (!$('#locationtype').combo('isValid')) {
				$('#accord').accordion('select', 0);
				alert('土地坐落地类型不能为空！');
				$('.combo :text')[8].focus();
				return;
			}
			if (!$('#belongtowns').combo('isValid')) {
				$('#accord').accordion('select', 0);
				alert('所属乡镇不能为空！');
				$('.combo :text')[9].focus();
				return;
			}
			if (!$('#detailaddress').validatebox('isValid')) {
				$('#accord').accordion('select', 0);
				alert('详细地址不能为空！');
				$('#detailaddress')[0].focus();
				return;
			}
			if (!$('#landarea').validatebox('isValid')) {
				$('#accord').accordion('select', 0);
				alert('土地总面积不能为空！');
				$('#landarea')[0].focus();
				return;
			}
			//if(!comparetdj()){
			//	return;
			//}
			var params = {};
			var fields = $('#grounddetailform').serializeArray(); //自动序列化表单元素为JSON对象
			$.each(fields, function(i, field) {
				params[field.name] = field.value;
			});
			params.landprice = $('#landprice').val();
			params.houselandmoney = $('#houselandmoney').val();
			params.plotratio = $('#plotratio').val();
			params.taxarea = $('#taxarea').val();
			var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');
			params.estateid = tdxxrow.estateid;
			params.taxpayerid = tdxxrow.taxpayerid;
			params.taxpayername = tdxxrow.taxpayername;
			params.landmoney = $('#landmoney').val();
			//params.gathertype ='01';//所有方填写
			//alert(params);
			//console.log(params);
			//alert(params['landmoney']);
			//alert($('#landmoney').val());
			//$('#landmoney').enable();
			//alert($.toJSON(params));
			//return;
			//submitinfo.coreestatebvo=params;
			//alert(JSON.stringify(params));
			//alert(JSON.stringify(submitinfo));
			$.ajax({
				type : "post",
				url : "/GroundInfoServlet/saveestateinfo.do",
				data : params,
				dataType : "json",
				success : function(jsondata) {
					//$('#addtdxxform').form('clear');
					//$('#addtdxxwindow').window('close');
					alert("保存成功");
					//refreshestate();
					//refreshinitpage();
					//$('#btn').linkbutton('disable');
					//$('#addtdxxwindow').window('close');
					//alert($('#taxpayerid').val());
					//$('#groundgathercheckgrid').datagrid('reload');
					//$('#groundgathercheckgrid').datagrid('load',
					//	url:"/InitBaseInfoServlet/gettmpground.do",
					//	{taxpayerid: $('#taxpayerid').val()}
					//);
					//refreshgroundgathercheckgrid();
					//$('#groundgathercheckgrid').datagrid('load',{taxpayerid: $('#taxpayerid').val()}); 
				},
				error : function(data, status, e) {
					alert("保存出错");
				}
			});
			//}
		}

		$
				.extend(
						$.fn.validatebox.defaults.rules,
						{
							datecheck : {
								validator : function(value) {
									return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/
											.test(value);
								},
								message : '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'
							}
						});

		$.extend($.fn.validatebox.defaults.rules, {
			isAfter : {
				validator : function(value, param) {
					var dateA = $.fn.datebox.defaults.parser(value);
					var dateB = $.fn.datebox.defaults.parser($(param[0])
							.datebox('getValue'));
					//alert(dateA+"------"+dateB);
					return dateA < dateB;
				},
				message : '使用年限起不能大于使用年限止！'
			}
		});
		//data-options="validType:['datecheck','isAfter[\'#holddates\']']"
	</script>
	
	<form id="grounddetailform" method="post">

		<div id="tab" class="easyui-tabs" style="height:440px;width:930px">
			<div title="土地基础信息" href="">
			<div style="padding:3px 5px;">
				<a href="#" id="btn" class="easyui-linkbutton" icon="icon-save"
					plain="true" onclick="savetdxx()">保存</a> 
				<!-- <a href="#" id="btn2"
					class="easyui-linkbutton" icon="icon-cancel" plain="true"
					onclick="$('#addtdxxwindow').window('close');">关闭</a> -->
			</div>
				<div id="accord" class="easyui-accordion"
					style="overflow;width:900px;height:360px;">
					<div title="土地基本信息" data-options=""
						style="overflow:auto;padding:10px;">
						<table id="tdjcxx" width="100%" class="table table-bordered">
							<tr>
								<td align="right">土地自编号：</td>
								<td><input id="selfnumber" class="easyui-validatebox"
									type="text" name="selfnumber" data-options="required:true"
									style="width:200px;"></input>
								</td>
								<td align="right">土地来源：</td>
								<td><input id="landsource" name="landsource" disabled="true"
									class="easyui-combobox" editable='false'
									data-options="
						onChange:function(newValue,oldValue){
										if(newValue=='05' || newValue=='03'){
											$('#landcertificatetype').combobox('disable');
											$('#landcertificatetype').combobox('setValue','');
											$('#landcertificate').attr('disabled',true);
											$('#landcertificatedates').datebox('disable');
											$('#landcertificatedates').datebox('setValue','');
											//$()取得土地时间：
										}else{
											$('#landcertificatetype').combobox('enable');
											$('#landcertificatetype').combobox('setValue','');
											$('#landcertificate').attr('disabled',false);
											$('#landcertificatedates').datebox('enable');
											$('#landcertificatedates').datebox('setValue','');
										}
										if(newValue=='05'){
											$('#tdjcxx td:eq(12)').html('实际占用土地时间');//实际占用土地时间
										}else{
											$('#tdjcxx td:eq(12)').html('交付土地时间');
										}
									},
						required:true,
						valueField: 'key',
						textField: 'value',
						url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDSOURCECODE'"
							style="width:200px;" />
								</td>


								<!-- <td>
						土地来源：
					</td>
					<td colspan="2">
						<input id="landsource" name="landsource" class="easyui-combobox"  editable='false' data-options="
						onChange:function(newValue,oldValue){
										if(newValue=='05'){
											$('#landcertificatetype').combobox('disable');
											$('#landcertificatetype').combobox('setValue','');
											$('#landcertificate').attr('disabled','true');
											$('#landcertificatedates').datebox('disable');
											$('#landcertificatedates').datebox('setValue','');
											//$()取得土地时间：
										}else{
											$('#landcertificatetype').combobox('enable');
											$('#landcertificatetype').combobox('setValue','');
											$('#landcertificate').attr('disabled','false');
											$('#landcertificatedates').datebox('enable');
											$('#landcertificatedates').datebox('setValue','');
										}
									},
						valueField: 'value',
						textField: 'text',
						url: '/ComboxService/getComboxs.do?voName=CodGroundsourcecodeVO&code=groundsourcecode&name=groundsourcename'" />
					</td> -->
							</tr>
							<tr>
								<td align="right">土地证类型：</td>
								<td><input id="landcertificatetype"
									name="landcertificatetype" class="easyui-combobox"
									editable='false'
									data-options="
						onChange:function(newValue,oldValue){
										if(newValue!='' && newValue!=null){//必须填写发证日期
											$('#landcertificate').validatebox({required:true});
											$('#landcertificatedates').combo({required:true});
										}else{
											$('#landcertificate').validatebox({required:false});
											$('#landcertificatedates').combo({required:false});
										}
									},
						valueField: 'key',
						textField: 'value',
						url: '/ComboxService/getComboxs.do?codetablename=COD_LANDCERTIFICATETYPE'"
									style="width:200px;" />
								</td>
								<td align="right">土地证号：</td>
								<td><input id="landcertificate" class="easyui-validatebox"
									type="text" name="landcertificate"
									data-options="required:false" style="width:200px;"></input>
								</td>
							</tr>
							<tr>
								<td align="right">发证日期：</td>
								<td><input id="landcertificatedates"
									name='landcertificatedates' class="easyui-datebox"
									data-options="validType:['datecheck']" style="width:200px;"></input>
								</td>
								<td align="right">协议书号：</td>
								<td><input id="protocolnumber" class="easyui-validatebox"
									type="text" name="protocolnumber" data-options="required:false"
									style="width:200px;"></input>
								</td>
							</tr>
							<tr>
								<td align="right">交付土地时间：</td>
								<td><input id="holddates" name="holddates"
									class="easyui-datebox"
									data-options="validType:['datecheck'],required:true"
									style="width:200px;"></input>
								</td>
								<td align="right">土地使用税税额：</td>
								<td><select id="landtaxprice" class="easyui-combobox"
									name="landtaxprice" style="width:200px;"
									data-options="required:true" editable="false">
										<option value="3" selected="true">3元/年.平方米</option>
										<option value="2">2元/年.平方米</option>
								</select>
								</td>
							</tr>
							<tr>
								<td align="right">申报征期类型：</td>
								<td>
								<select id="taxperiod" class="easyui-combobox" name="taxperiod" style="width:200px;" data-options="required:true,panelWidth:300" editable="false">
									<option value="21" selected="true">按月申报缴纳，于当月1日至10日内</option>
									<option value="22">按季申报缴纳，于本季度1日至40日内</option>
									<option value="07">按半年申报缴纳，于本期120日内</option>
									<option value="10">按年申报缴纳，于本年120日内</option>
								</select>
								</td>
								<td align="right">土地面积来源部门：</td>
								<td><input id="landareaapprovalunit"
									class="easyui-validatebox" type="text"
									name="landareaapprovalunit" data-options="required:false"
									style="width:200px;"></input>
								</td>
							</tr>
							<tr>
								<td align="right">使用年限起：</td>
								<td><input id="limitbegins" name='limitbegins'
									class="easyui-datebox"
									data-options="validType:['datecheck','isAfter[\'#limitends\']']"
									style="width:200px;"></input>
								</td>
								<td align="right">使用年限止：</td>
								<td><input id="limitends" name='limitends'
									class="easyui-datebox" data-options="validType:'datecheck'"
									style="width:200px;"></input>
								</td>
							</tr>
							<tr>
								<td align="right">宗地编号：</td>
								<td><input id="estateserial" name='estateserial'
									class="easyui-validatebox" data-options="" style="width:200px;"></input>
								</td>
								<td align="right">是否单一承租土地：</td>
								<td><select id="onlyhiregroundflag" class="easyui-combobox"
									name="onlyhiregroundflag" style="width:200px;" data-options="required:true,
									onChange:function(newValue,oldValue){
										var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');
										if(tdxxrow.landsource=='03'){
											if(newValue =='0'){
												$('#landmoney').attr('disabled',true);
												$('#landmoney').val('0.00');
											}else{
												$('#landmoney').attr('disabled',false);
											}
										}
									}" editable="false">
										<option value="0">否</option>
										<option value="1">是</option>
								</select>
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
									<input id="belongtowns" name="belongtowns" style="width:300px;" class="easyui-combobox" editable='false' data-options="
									valueField: 'key',
									textField: 'value',
									required:'true',
									data:belongtowns" />
								</td>
							</tr>
							<tr>
								<td align="right">详细地址：</td>
								<td colspan="2"><input id="detailaddress"
									class="easyui-validatebox" type="text" name="detailaddress"
									data-options="required:true" style="width:400px;"></input>
								</td>
							</tr>
							<tr>
								<td align="right">土地总面积（平方米）：</td>
								<td><input id="landarea" class="easyui-numberbox"
									type="text" name="landarea" data-options="min:0,required:true"
									precision="2" value="0.00"
									style="text-align:right;width:200px;"
									onBlur="cacultetdmj();cacultedj();caculterjl();cacultehouselandmoney()"></input>
								</td>
								<td align="right">获得土地总价（元）：</td>
								<td><input id="landmoney" class="easyui-numberbox"
									type="text" precision="2" name="landmoney"
									data-options="min:0,required:false"
									style="text-align:right;width:200px;"
									onBlur="cacultedj();cacultetdmj()" value="0.00" disabled="true"></input>
								</td>
							</tr>
							<tr>
								<td align="right">出租方计算机编码：</td>
								<td><input id="sourcetaxpayerid" class="easyui-validatebox"
									type="text" name="sourcetaxpayerid" style="width:200px;"></input>
								</td>
								<td align="right">出租方名称：</td>
								<td><input id="sourcetaxpayername"
									class="easyui-validatebox" type="text"
									name="sourcetaxpayername" style="width:200px;"></input>
								</td>
							</tr>
						</table>
					</div>
					<div title="备注信息" data-options=""
						style="overflow:auto;padding:10px;">
						<table id="bzxx" width="100%" class="table table-bordered">
							<tr>
								<td width="25%" height="25"><div align="right">备注：</div></td>
								<td width="75%" height="25"><textarea id="remark"
										class="easyui-validatebox" style="width:500px;height:200px"
										name="remark"></textarea></td>
							</tr>
						</table>
					</div>
					<div title="土地面积" data-options=""
						style="overflow:auto;padding:10px;">
						<table id="tdmj" width="100%" class="table table-bordered">
							<tr>
								<td rowspan="5" align="center">土地面积</td>
								<td width="40%" align="right">其中土地使用税免税面积（平方米）：</td>
								<td><input id="taxfreearea" class="easyui-numberbox"
									type="text" precision="2" name="taxfreearea"
									data-options="min:0,required:true" value="0.00"
									style="text-align:right;width:400px;" onBlur="cacultetdmj()"
									disabled="true"></input>
								</td>
							</tr>
							<tr>
								<td width="40%" align="right">其中减少面积（平方米）：</td>
								<td><input id="reducearea" class="easyui-numberbox"
									type="text" precision="2" name="reducearea"
									data-options="min:0,required:true" value="0.00"
									style="text-align:right;width:400px;" onBlur="cacultetdmj()"
									disabled="true"></input>
								</td>
							</tr>
							<tr>
								<td width="40%" align="right">其中出租土地约定对方缴纳土地使用税土地面积（平方米）：</td>
								<td><input id="hirelandreducearea" class="easyui-numberbox"
									type="text" precision="2" name="hirelandreducearea"
									data-options="min:0,required:true" value="0.00"
									style="text-align:right;width:400px;" onBlur="cacultetdmj()"
									disabled="true"></input>
								</td>
							</tr>
							<tr>
								<td width="40%" align="right">其中出租房产约定对方缴纳土地使用税土地面积（平方米）：</td>
								<td><input id="hirehousesreducearea"
									class="easyui-numberbox" type="text" precision="2"
									name="hirehousesreducearea" value="0.00"
									style="text-align:right;width:400px;"
									data-options="min:0,required:true" onBlur="cacultetdmj()"
									disabled="true"></input>
								</td>
							</tr>
							<tr>
								<td width="40%" align="right">其中土地使用税应税面积（平方米）：</td>
								<td><input id="taxarea" class="easyui-numberbox"
									type="text" name="taxarea" precision="2"
									data-options="min:0,required:true"
									style="text-align:right;width:400px;" value="0.00"
									disabled="true"></input>
								</td>
							</tr>
						</table>
					</div>
					<div title="房产税计税相关信息" data-options=""
						style="overflow:auto;padding:10px;">
						<table id="fcsjsxgxx" width="100%" class="table table-bordered">
							<tr>
								<td align="right">获得土地单价(元/平方米)：</td>
								<td><input id="landprice" class="easyui-numberbox"
									type="text" name="landprice" precision="2"
									data-options="min:0,required:false" disabled="true"
									precision="2" style="text-align:right" value="0.00"></input>
								</td>
								<td align="right">房产建筑面积：</td>
								<td colspan="2"><input id="areaofstructure"
									class="easyui-numberbox" type="text" name="areaofstructure"
									precision="2" value="0.00" disabled="true"
									data-options="min:0,required:false"
									onBlur="caculterjl();cacultehouselandmoney()"
									style="text-align:right"></input>
								</td>
							</tr>
							<tr>
								<td rowspan="3" align="center">土地地价款</td>
								<td align="right">土地出让金：</td>
								<td><input id="landsellcost" class="easyui-numberbox"
									type="text" name="landsellcost" precision="2" value="0.00"
									data-options="min:0,required:false"
									onBlur="cacultehouselandmoney();cacultedj()" style="text-align:right"></input>
								</td>
								<td align="right">耕地占用税：</td>
								<td><input id="landploughtaxcost" class="easyui-numberbox"
									type="text" name="landploughtaxcost" precision="2" value="0.00"
									data-options="min:0,required:false"
									onBlur="cacultehouselandmoney();cacultedj()" style="text-align:right"></input>
								</td>

							</tr>
							<tr>
								<td align="right">契税：</td>
								<td><input id="landcontracttaxcost"
									class="easyui-numberbox" type="text" name="landcontracttaxcost"
									precision="2" value="0.00" data-options="min:0,required:false"
									onBlur="cacultehouselandmoney();cacultedj()" style="text-align:right"></input>
								</td>
								<td align="right">土地开发成本：</td>
								<td><input id="landdevelopcost" class="easyui-numberbox"
									type="text" name="landdevelopcost" precision="2" value="0.00"
									data-options="min:0,required:false"
									onBlur="cacultehouselandmoney();cacultedj()" style="text-align:right"></input>
								</td>

							</tr>
							<tr>
								<td align="right">其他：</td>
								<td colspan="3"><input id="landelsecost"
									class="easyui-numberbox" type="text" name="landelsecost"
									precision="2" value="0.00" data-options="min:0,required:false"
									onBlur="cacultehouselandmoney();cacultedj()" style="text-align:right"></input>
								</td>
							</tr>
							<tr>
								<td align="right">计入房产原值的地价：</td>
								<td><input id="houselandmoney" class="easyui-numberbox"
									type="text" name="houselandmoney" disabled="true" precision="2"
									value="0.00" data-options="min:0,required:false"
									style="text-align:right"></input>
								</td>
								<td align="right">宗地容积率：</td>
								<td colspan="2"><input id="plotratio"
									class="easyui-numberbox" type="text" name="plotratio"
									precision="2" disabled="true" value="0.00"
									data-options="min:0,required:false" style="text-align:right"></input>
								</td>
							</tr>
							<tr>
								<td align="right">计税房产原值：</td>
								<td colspan="4"><input id="housetaxoriginalvalue"
									class="easyui-numberbox" type="text"
									name="housetaxoriginalvalue" precision="2"
									data-options="min:0,required:false" value="0.00"
									disabled="true" style="text-align:right"></input>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<div title="房产基础信息" closable="false" href=""></div>
			<div title="减免信息" href=""></div>
			<div title="土地承租方信息" closable="false" href=""></div>
			<div title="土地减少信息" closable="false" href=""></div>
			<div title="在建房产信息" closable="false" href=""></div>
		</div>

		<!-- <div  style="width:1000px;height:400px" title=" " data-options="fit:true,tools:'#abutton',maximized:false">
			<div  id="abutton" style="text-align:center">
				<a href="#" class="icon-save"  plain="true" onclick="savetdxx()"></a>
			</div>
			
		</div>
		</div> -->
	</form>
</body>

</html>