<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>  
<%@ include file="/common/inc.jsp"%>
<html>  
<head>  
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />  
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />  
<link rel="stylesheet" type="text/css" href="<%=spath%>/themes/sunny/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=spath%>/themes/icon.css">
<script type="text/javascript" src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
<script type="text/javascript" src="<%=spath%>/js/jquery.easyui.min.1.3.js"></script>
<script type="text/javascript" src="<%=spath%>/js/datagrid-groupview.js"></script>  
<script src="<%=spath%>/js/moduleWindow.js"></script>

<title>Hello, World</title>  
<style type="text/css">  
html{height:100%}  
body{height:100%;margin:0px;padding:0px}  
#container{height:100%}  
a.theforever_knight1:visited {color:orange;}
#l-map{height:100%;width:78%;float:left;border-right:2px solid #bcbcbc;}
</style>  
<script type="text/javascript" src="http://api.map.baidu.com/api?v=1.5&ak=10fd14046e11c2285e97009ff7cc6a0f"></script>

<script type="text/javascript">

function gotoDetail1(){

							moduleWindow.open({
							id: "moduleTTT1",
							title: "税种税收情况",
							width: 1000,
							height: 580,
							icon: "",
							minimizable: false,
							//data: {name: 'Tom', age: 18}, //传递给iframe的数据
							content: "url:D:\\projects\\szgr\\WebRoot\\map\\datagrid1.html",
							onLoad: function(dialog){
								if(this.content && this.content.doInit){//判断弹出窗体iframe中的doInit方法是否存在
									this.content.doInit(dialog);//调用并将参数传入，此处当然也可以传入其他内容
								}
							}
						});

}


function gotoDetail2(){

							moduleWindow.open({
							id: "moduleTTT2",
							title: "纳税人税收情况",
							width: 1000,
							height: 580,
							icon: "",
							minimizable: false,
							//data: {name: 'Tom', age: 18}, //传递给iframe的数据
							content: "url:D:\\projects\\szgr\\WebRoot\\map\\datagrid2.html",
							onLoad: function(dialog){
								if(this.content && this.content.doInit){//判断弹出窗体iframe中的doInit方法是否存在
									this.content.doInit(dialog);//调用并将参数传入，此处当然也可以传入其他内容
								}
							}
						});

}

function gotoDetail(){

							moduleWindow.open({
							id: "moduleTTT",
							title: "土地明细信息",
							width: 1000,
							height: 580,
							icon: "",
							minimizable: false,
							//data: {name: 'Tom', age: 18}, //传递给iframe的数据
							content: "url:D:\\projects\\szgr\\WebRoot\\map\\cjb-2.html",
							onLoad: function(dialog){
								if(this.content && this.content.doInit){//判断弹出窗体iframe中的doInit方法是否存在
									this.content.doInit(dialog);//调用并将参数传入，此处当然也可以传入其他内容
								}
							}
						});

}


$(function(){


			$('#landId').datagrid({
				rowStyler:function(index,row,css){
					if (row.landid == "L_001"){
						return 'color:green;';
					}
					if (row.landid == "L_002"){
						return 'color:red;';
					}
					if (row.landid == "L_003" && (row.fcid == "F_007")){
						return 'color:green;';
					}
					if (row.landid == "L_003" && (row.fcid == "F_008")){
						return 'color:red;;';
					}
				}
			});


		$('#title_L_001').live("click",function(){

				var map = new BMap.Map("container");  
				map.addControl(new BMap.NavigationControl()); 
				map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
				map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
				map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦
				var polyline13 = new BMap.Polygon([    
					new BMap.Point(102.759356,24.710305),
					new BMap.Point(102.761413,24.710461),
					new BMap.Point(102.761404,24.709378),
					new BMap.Point(102.761359,24.708836),
					new BMap.Point(102.759562,24.708738),
					new BMap.Point(102.759383,24.710272),
					new BMap.Point(102.759347,24.710305)
				 ],    
				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline13.addEventListener("mouseover", function(){
				  polyline13.setFillOpacity("0.8")
				});
				polyline13.addEventListener("mouseout", function(){
				  polyline13.setFillOpacity("0.4")
				});

				map.addOverlay(polyline13);    

				var polyline12 = new BMap.Polygon([    
					new BMap.Point(102.76135,24.708836),
					new BMap.Point(102.763398,24.708828),
					new BMap.Point(102.763299,24.70699),
					new BMap.Point(102.763218,24.706021),
					new BMap.Point(102.763156,24.705463),
					new BMap.Point(102.76144,24.705906),
					new BMap.Point(102.76135,24.707523),
					new BMap.Point(102.761368,24.708812),
					new BMap.Point(102.761368,24.708812),
					new BMap.Point(102.761368,24.708812)
				 ],    
				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);  
				polyline12.addEventListener("mouseover", function(){
				  polyline12.setFillOpacity("0.8")
				});
				polyline12.addEventListener("mouseout", function(){
				  polyline12.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline12); 


				var polyline = new BMap.Polygon([    
					new BMap.Point(102.754478,24.713145),
					new BMap.Point(102.755583,24.713095),
					new BMap.Point(102.75676,24.713309),
					new BMap.Point(102.757442,24.713489),
					new BMap.Point(102.75755,24.712283),
					new BMap.Point(102.757658,24.711585),
					new BMap.Point(102.756454,24.711446),
					new BMap.Point(102.756445,24.709509),
					new BMap.Point(102.756544,24.707983),
					new BMap.Point(102.756544,24.707425),
					new BMap.Point(102.756122,24.707531),
					new BMap.Point(102.755691,24.707704),
					new BMap.Point(102.755502,24.708885),
					new BMap.Point(102.755053,24.710453),
					new BMap.Point(102.754864,24.71129),
					new BMap.Point(102.754622,24.712275),
					new BMap.Point(102.754442,24.71298),
					new BMap.Point(102.754442,24.71298),
					new BMap.Point(102.754442,24.71298)
				 ],    
				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				//map.addOverlay(polyline); 

				var polyline10 = new BMap.Polygon([    
					new BMap.Point(102.756427,24.711471),
					new BMap.Point(102.757658,24.711585),
					new BMap.Point(102.758987,24.711684),
					new BMap.Point(102.759392,24.709427),
					new BMap.Point(102.75949,24.708295),
					new BMap.Point(102.759625,24.707031),
					new BMap.Point(102.759661,24.706407),
					new BMap.Point(102.758493,24.706809),
					new BMap.Point(102.756535,24.707433),
					new BMap.Point(102.756508,24.708885),
					new BMap.Point(102.756445,24.709189),
					new BMap.Point(102.756454,24.710404),
					new BMap.Point(102.756454,24.711454)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#ff7f00",fillOpacity:0.4}    
				);  
				polyline10.addEventListener("mouseover", function(){
				  polyline10.setFillOpacity("0.8")
				});
				polyline10.addEventListener("mouseout", function(){
				  polyline10.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline10); 

				var polyline9 = new BMap.Polygon([    
					new BMap.Point(102.759535,24.708721),
					new BMap.Point(102.761368,24.708787),
					new BMap.Point(102.76135,24.707474),
					new BMap.Point(102.759661,24.707474),
					new BMap.Point(102.759499,24.708738)

				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				polyline9.addEventListener("mouseover", function(){
				  polyline9.setFillOpacity("0.8")
				});
				polyline9.addEventListener("mouseout", function(){
				  polyline9.setFillOpacity("0.4")
				});

				map.addOverlay(polyline9); 

				var polyline8 = new BMap.Polygon([    
					new BMap.Point(102.759652,24.707474),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761341,24.706563),
					new BMap.Point(102.761377,24.705964),
					new BMap.Point(102.760425,24.70612),
					new BMap.Point(102.759778,24.706374),
					new BMap.Point(102.759769,24.707023),
					new BMap.Point(102.759688,24.707433),
					new BMap.Point(102.759643,24.707499)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline8.addEventListener("mouseover", function(){
				  polyline8.setFillOpacity("0.8")
				});
				polyline8.addEventListener("mouseout", function(){
				  polyline8.setFillOpacity("0.4")
				});

				map.addOverlay(polyline8); 

				var polyline7 = new BMap.Polygon([    
					new BMap.Point(102.761431,24.710461),
					new BMap.Point(102.763398,24.710527),
					new BMap.Point(102.763479,24.710404),
					new BMap.Point(102.763407,24.708877),
					new BMap.Point(102.761745,24.708877),
					new BMap.Point(102.761368,24.708894),
					new BMap.Point(102.761449,24.710428),
					new BMap.Point(102.761431,24.710478)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#ff7f00",fillOpacity:0.4}    
				);   
				polyline7.addEventListener("mouseover", function(){
				  polyline7.setFillOpacity("0.8")
				});
				polyline7.addEventListener("mouseout", function(){
				  polyline7.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline7); 


				var polyline6 = new BMap.Polygon([    
					new BMap.Point(102.754855,24.711282),
					new BMap.Point(102.756436,24.711454),
					new BMap.Point(102.756454,24.710379),
					new BMap.Point(102.756454,24.709862),
					new BMap.Point(102.755322,24.709649),
					new BMap.Point(102.754864,24.711241),
					new BMap.Point(102.754846,24.711298)
				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				polyline6.addEventListener("mouseover", function(){
				  polyline6.setFillOpacity("0.8")
				});
				polyline6.addEventListener("mouseout", function(){
				  polyline6.setFillOpacity("0.4")
				});

				map.addOverlay(polyline6); 


				var polyline5 = new BMap.Polygon([    
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.755601,24.708451),
					new BMap.Point(102.755718,24.70772),
					new BMap.Point(102.756149,24.707523),
					new BMap.Point(102.756553,24.707474),
					new BMap.Point(102.756535,24.708327),
					new BMap.Point(102.75649,24.709017),
					new BMap.Point(102.756427,24.709214),
					new BMap.Point(102.756454,24.709813),
					new BMap.Point(102.756409,24.709878)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#FF7F00",fillOpacity:0.4}    
				);    
				polyline5.addEventListener("mouseover", function(){
				  polyline5.setFillOpacity("0.8")
				});
				polyline5.addEventListener("mouseout", function(){
				  polyline5.setFillOpacity("0.4")
				});

				map.addOverlay(polyline5); 

				var polyline4 = new BMap.Polygon([    
					new BMap.Point(102.759284,24.711717),
					new BMap.Point(102.760407,24.711914),
					new BMap.Point(102.760488,24.710888),
					new BMap.Point(102.75985,24.710839),
					new BMap.Point(102.759787,24.710576),
					new BMap.Point(102.759814,24.710338),
					new BMap.Point(102.759347,24.710305),
					new BMap.Point(102.759185,24.711577),
					new BMap.Point(102.759266,24.711717)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#FF7F00",fillOpacity:0.4}    
				);  
				polyline4.addEventListener("mouseover", function(){
				  polyline4.setFillOpacity("0.8")
				});
				polyline4.addEventListener("mouseout", function(){
				  polyline4.setFillOpacity("0.4")
				});
				

				map.addOverlay(polyline4); 

				var polyline3 = new BMap.Polygon([    
					new BMap.Point(102.764853,24.708278),
					new BMap.Point(102.766803,24.708016),
					new BMap.Point(102.766138,24.706998),
					new BMap.Point(102.765365,24.707572),
					new BMap.Point(102.76453,24.707531),
					new BMap.Point(102.764835,24.708278)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline3.addEventListener("mouseover", function(){
				  polyline3.setFillOpacity("0.8")
				});
				polyline3.addEventListener("mouseout", function(){
				  polyline3.setFillOpacity("0.4")
				});

				map.addOverlay(polyline3); 


				var polyline2 = new BMap.Polygon([    
					new BMap.Point(102.757766,24.7063),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759958,24.704626),
					new BMap.Point(102.757622,24.704634),
					new BMap.Point(102.756894,24.705841),
					new BMap.Point(102.757487,24.7063),
					new BMap.Point(102.757757,24.706309)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    

				polyline2.addEventListener("mouseover", function(){
				  polyline2.setFillOpacity("0.8")
				});
				polyline2.addEventListener("mouseout", function(){
				  polyline2.setFillOpacity("0.4")
				});


				map.addOverlay(polyline2); 

				var polyline1 = new BMap.Polygon([    
					new BMap.Point(102.762051,24.7047),
					new BMap.Point(102.764548,24.704372),
					new BMap.Point(102.763838,24.703264),
					new BMap.Point(102.761997,24.702771),
					new BMap.Point(102.762527,24.70374),
					new BMap.Point(102.761224,24.703822),
					new BMap.Point(102.761233,24.704495),
					new BMap.Point(102.762042,24.7047)
				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				
				polyline1.addEventListener("mouseover", function(){
				  polyline1.setFillOpacity("0.8")
				});
				polyline1.addEventListener("mouseout", function(){
				  polyline1.setFillOpacity("0.4")
				});

				map.addOverlay(polyline1); 



				var point = new BMap.Point(102.761853,24.708377);  
				var marker = new BMap.Marker(point);        // 创建标注    
				//
				map.addOverlay(marker);
				map.centerAndZoom(point, 17); 
				map.panTo(point);

				var sContent =
				"<h4 style='margin:0 0 5px 0;padding:0.2em 0'>晋宁金辰房地产开发有限公司</h4>" + 
				"<div><a href='javascript:gotoDetail1()' class='easyui-linkbutton' data-options='iconCls:icon-add'>税种税收情况</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:gotoDetail2()' class='easyui-linkbutton' data-options='iconCls:icon-add'>纳税人税收情况</a></div><br>" + 
				"<img style='float:right;margin:4px' id='imgDemo' src='4100964_154455301237_2.jpg' width='499' height='154' title='晋宁县xx地块'/>" + 

				"<table>" + 
					"<tr><td>" +

						"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>" +
						"<table>" +
						"<tr><td align=right>所有方名称&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b><a href='javascript:gotoDetail()' class='theforever_knight1'>晋宁金辰房地产开发有限公司</a></b></font></td></tr>" + 
						"<tr><td align=right>土地来源&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>出让</b></font></td></tr>" + 
						"<tr><td align=right>土地面积&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>53086.35平方米</b></font></td></tr>" + 
						"<tr><td align=right>房屋建筑面积&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>10000</b></font></td></tr>" + 
						"<tr><td align=right>使用年限&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>2010-01-01至2030-01-01</b></font></td></tr>" + 
						"<tr><td align=right>耕占税应缴信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>单价:26&nbsp;&nbsp;&nbsp;&nbsp;面积:1000&nbsp;&nbsp;&nbsp;&nbsp;税额:26000&nbsp;&nbsp;&nbsp;&nbsp;已缴清:&nbsp;&nbsp;&nbsp;<input type='checkbox' checked/></b></font></td></tr>" + 
						"<tr><td align=right>土地使用税应缴信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>单价:3&nbsp;&nbsp;&nbsp;&nbsp;面积:2000&nbsp;&nbsp;&nbsp;&nbsp;税额:6000&nbsp;&nbsp;&nbsp;&nbsp;已缴清:&nbsp;&nbsp;&nbsp;<input type='checkbox'/></b></font></td></tr>" + 
						"<tr><td align=right>房产税应缴信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>原值:500000&nbsp;&nbsp;&nbsp;&nbsp;税率:0.12&nbsp;&nbsp;&nbsp;&nbsp;税额:42000&nbsp;&nbsp;&nbsp;&nbsp;已缴清:&nbsp;&nbsp;&nbsp;<input type='checkbox'/></b></font></td></tr>" + 
						"<tr><td align=right>其他税款总额信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>单价:26&nbsp;&nbsp;&nbsp;&nbsp;面积:1000&nbsp;&nbsp;&nbsp;&nbsp;税额:26000&nbsp;&nbsp;&nbsp;&nbsp;已缴清:&nbsp;&nbsp;&nbsp;<input type='checkbox' checked/></b></font></td></tr>" + 
						"</table></p>" + 

					"</td>" +
					
				"</tr>" +
				"</table>" +

				"</div>";
				var infoWindow = new BMap.InfoWindow(sContent); 
				marker.addEventListener("click", function(){          
				   this.openInfoWindow(infoWindow);
				   //图片加载完毕重绘infowindow
				   document.getElementById('imgDemo').onload = function (){
					   infoWindow.redraw();
				   }
				});

		});
		$('#title_L_002').live("click",function(){
			
				var map = new BMap.Map("container");  
				map.addControl(new BMap.NavigationControl()); 
				map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
				map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
				map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦

								var polyline13 = new BMap.Polygon([    
					new BMap.Point(102.759356,24.710305),
					new BMap.Point(102.761413,24.710461),
					new BMap.Point(102.761404,24.709378),
					new BMap.Point(102.761359,24.708836),
					new BMap.Point(102.759562,24.708738),
					new BMap.Point(102.759383,24.710272),
					new BMap.Point(102.759347,24.710305)
				 ],    
				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline13.addEventListener("mouseover", function(){
				  polyline13.setFillOpacity("0.8")
				});
				polyline13.addEventListener("mouseout", function(){
				  polyline13.setFillOpacity("0.4")
				});

				map.addOverlay(polyline13);    

				var polyline12 = new BMap.Polygon([    
					new BMap.Point(102.76135,24.708836),
					new BMap.Point(102.763398,24.708828),
					new BMap.Point(102.763299,24.70699),
					new BMap.Point(102.763218,24.706021),
					new BMap.Point(102.763156,24.705463),
					new BMap.Point(102.76144,24.705906),
					new BMap.Point(102.76135,24.707523),
					new BMap.Point(102.761368,24.708812),
					new BMap.Point(102.761368,24.708812),
					new BMap.Point(102.761368,24.708812)
				 ],    
				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);  
				polyline12.addEventListener("mouseover", function(){
				  polyline12.setFillOpacity("0.8")
				});
				polyline12.addEventListener("mouseout", function(){
				  polyline12.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline12); 


				var polyline = new BMap.Polygon([    
					new BMap.Point(102.754478,24.713145),
					new BMap.Point(102.755583,24.713095),
					new BMap.Point(102.75676,24.713309),
					new BMap.Point(102.757442,24.713489),
					new BMap.Point(102.75755,24.712283),
					new BMap.Point(102.757658,24.711585),
					new BMap.Point(102.756454,24.711446),
					new BMap.Point(102.756445,24.709509),
					new BMap.Point(102.756544,24.707983),
					new BMap.Point(102.756544,24.707425),
					new BMap.Point(102.756122,24.707531),
					new BMap.Point(102.755691,24.707704),
					new BMap.Point(102.755502,24.708885),
					new BMap.Point(102.755053,24.710453),
					new BMap.Point(102.754864,24.71129),
					new BMap.Point(102.754622,24.712275),
					new BMap.Point(102.754442,24.71298),
					new BMap.Point(102.754442,24.71298),
					new BMap.Point(102.754442,24.71298)
				 ],    
				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				//map.addOverlay(polyline); 

				var polyline10 = new BMap.Polygon([    
					new BMap.Point(102.756427,24.711471),
					new BMap.Point(102.757658,24.711585),
					new BMap.Point(102.758987,24.711684),
					new BMap.Point(102.759392,24.709427),
					new BMap.Point(102.75949,24.708295),
					new BMap.Point(102.759625,24.707031),
					new BMap.Point(102.759661,24.706407),
					new BMap.Point(102.758493,24.706809),
					new BMap.Point(102.756535,24.707433),
					new BMap.Point(102.756508,24.708885),
					new BMap.Point(102.756445,24.709189),
					new BMap.Point(102.756454,24.710404),
					new BMap.Point(102.756454,24.711454)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#ff7f00",fillOpacity:0.4}    
				);  
				polyline10.addEventListener("mouseover", function(){
				  polyline10.setFillOpacity("0.8")
				});
				polyline10.addEventListener("mouseout", function(){
				  polyline10.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline10); 

				var polyline9 = new BMap.Polygon([    
					new BMap.Point(102.759535,24.708721),
					new BMap.Point(102.761368,24.708787),
					new BMap.Point(102.76135,24.707474),
					new BMap.Point(102.759661,24.707474),
					new BMap.Point(102.759499,24.708738)

				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				polyline9.addEventListener("mouseover", function(){
				  polyline9.setFillOpacity("0.8")
				});
				polyline9.addEventListener("mouseout", function(){
				  polyline9.setFillOpacity("0.4")
				});

				map.addOverlay(polyline9); 

				var polyline8 = new BMap.Polygon([    
					new BMap.Point(102.759652,24.707474),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761341,24.706563),
					new BMap.Point(102.761377,24.705964),
					new BMap.Point(102.760425,24.70612),
					new BMap.Point(102.759778,24.706374),
					new BMap.Point(102.759769,24.707023),
					new BMap.Point(102.759688,24.707433),
					new BMap.Point(102.759643,24.707499)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline8.addEventListener("mouseover", function(){
				  polyline8.setFillOpacity("0.8")
				});
				polyline8.addEventListener("mouseout", function(){
				  polyline8.setFillOpacity("0.4")
				});

				map.addOverlay(polyline8); 

				var polyline7 = new BMap.Polygon([    
					new BMap.Point(102.761431,24.710461),
					new BMap.Point(102.763398,24.710527),
					new BMap.Point(102.763479,24.710404),
					new BMap.Point(102.763407,24.708877),
					new BMap.Point(102.761745,24.708877),
					new BMap.Point(102.761368,24.708894),
					new BMap.Point(102.761449,24.710428),
					new BMap.Point(102.761431,24.710478)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#ff7f00",fillOpacity:0.4}    
				);   
				polyline7.addEventListener("mouseover", function(){
				  polyline7.setFillOpacity("0.8")
				});
				polyline7.addEventListener("mouseout", function(){
				  polyline7.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline7); 


				var polyline6 = new BMap.Polygon([    
					new BMap.Point(102.754855,24.711282),
					new BMap.Point(102.756436,24.711454),
					new BMap.Point(102.756454,24.710379),
					new BMap.Point(102.756454,24.709862),
					new BMap.Point(102.755322,24.709649),
					new BMap.Point(102.754864,24.711241),
					new BMap.Point(102.754846,24.711298)
				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				polyline6.addEventListener("mouseover", function(){
				  polyline6.setFillOpacity("0.8")
				});
				polyline6.addEventListener("mouseout", function(){
				  polyline6.setFillOpacity("0.4")
				});

				map.addOverlay(polyline6); 


				var polyline5 = new BMap.Polygon([    
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.755601,24.708451),
					new BMap.Point(102.755718,24.70772),
					new BMap.Point(102.756149,24.707523),
					new BMap.Point(102.756553,24.707474),
					new BMap.Point(102.756535,24.708327),
					new BMap.Point(102.75649,24.709017),
					new BMap.Point(102.756427,24.709214),
					new BMap.Point(102.756454,24.709813),
					new BMap.Point(102.756409,24.709878)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#FF7F00",fillOpacity:0.4}    
				);    
				polyline5.addEventListener("mouseover", function(){
				  polyline5.setFillOpacity("0.8")
				});
				polyline5.addEventListener("mouseout", function(){
				  polyline5.setFillOpacity("0.4")
				});

				map.addOverlay(polyline5); 

				var polyline4 = new BMap.Polygon([    
					new BMap.Point(102.759284,24.711717),
					new BMap.Point(102.760407,24.711914),
					new BMap.Point(102.760488,24.710888),
					new BMap.Point(102.75985,24.710839),
					new BMap.Point(102.759787,24.710576),
					new BMap.Point(102.759814,24.710338),
					new BMap.Point(102.759347,24.710305),
					new BMap.Point(102.759185,24.711577),
					new BMap.Point(102.759266,24.711717)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#FF7F00",fillOpacity:0.4}    
				);  
				polyline4.addEventListener("mouseover", function(){
				  polyline4.setFillOpacity("0.8")
				});
				polyline4.addEventListener("mouseout", function(){
				  polyline4.setFillOpacity("0.4")
				});
				

				map.addOverlay(polyline4); 

				var polyline3 = new BMap.Polygon([    
					new BMap.Point(102.764853,24.708278),
					new BMap.Point(102.766803,24.708016),
					new BMap.Point(102.766138,24.706998),
					new BMap.Point(102.765365,24.707572),
					new BMap.Point(102.76453,24.707531),
					new BMap.Point(102.764835,24.708278)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline3.addEventListener("mouseover", function(){
				  polyline3.setFillOpacity("0.8")
				});
				polyline3.addEventListener("mouseout", function(){
				  polyline3.setFillOpacity("0.4")
				});

				map.addOverlay(polyline3); 


				var polyline2 = new BMap.Polygon([    
					new BMap.Point(102.757766,24.7063),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759958,24.704626),
					new BMap.Point(102.757622,24.704634),
					new BMap.Point(102.756894,24.705841),
					new BMap.Point(102.757487,24.7063),
					new BMap.Point(102.757757,24.706309)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    

				polyline2.addEventListener("mouseover", function(){
				  polyline2.setFillOpacity("0.8")
				});
				polyline2.addEventListener("mouseout", function(){
				  polyline2.setFillOpacity("0.4")
				});


				map.addOverlay(polyline2); 

				var polyline1 = new BMap.Polygon([    
					new BMap.Point(102.762051,24.7047),
					new BMap.Point(102.764548,24.704372),
					new BMap.Point(102.763838,24.703264),
					new BMap.Point(102.761997,24.702771),
					new BMap.Point(102.762527,24.70374),
					new BMap.Point(102.761224,24.703822),
					new BMap.Point(102.761233,24.704495),
					new BMap.Point(102.762042,24.7047)
				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				
				polyline1.addEventListener("mouseover", function(){
				  polyline1.setFillOpacity("0.8")
				});
				polyline1.addEventListener("mouseout", function(){
				  polyline1.setFillOpacity("0.4")
				});

				map.addOverlay(polyline1); 


				var point = new BMap.Point(102.760465,24.709563);  
				var marker = new BMap.Marker(point);        // 创建标注    
				
				map.addOverlay(marker);
				map.centerAndZoom(point, 17); 
				map.panTo(point);


		});

		$('#title_L_003').live("click",function(){
			
				var map = new BMap.Map("container");  
				map.addControl(new BMap.NavigationControl()); 
				map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
				map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
				map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦

 
 				var polyline13 = new BMap.Polygon([    
					new BMap.Point(102.759356,24.710305),
					new BMap.Point(102.761413,24.710461),
					new BMap.Point(102.761404,24.709378),
					new BMap.Point(102.761359,24.708836),
					new BMap.Point(102.759562,24.708738),
					new BMap.Point(102.759383,24.710272),
					new BMap.Point(102.759347,24.710305)
				 ],    
				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline13.addEventListener("mouseover", function(){
				  polyline13.setFillOpacity("0.8")
				});
				polyline13.addEventListener("mouseout", function(){
				  polyline13.setFillOpacity("0.4")
				});

				map.addOverlay(polyline13);    

				var polyline12 = new BMap.Polygon([    
					new BMap.Point(102.76135,24.708836),
					new BMap.Point(102.763398,24.708828),
					new BMap.Point(102.763299,24.70699),
					new BMap.Point(102.763218,24.706021),
					new BMap.Point(102.763156,24.705463),
					new BMap.Point(102.76144,24.705906),
					new BMap.Point(102.76135,24.707523),
					new BMap.Point(102.761368,24.708812),
					new BMap.Point(102.761368,24.708812),
					new BMap.Point(102.761368,24.708812)
				 ],    
				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);  
				polyline12.addEventListener("mouseover", function(){
				  polyline12.setFillOpacity("0.8")
				});
				polyline12.addEventListener("mouseout", function(){
				  polyline12.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline12); 


				var polyline = new BMap.Polygon([    
					new BMap.Point(102.754478,24.713145),
					new BMap.Point(102.755583,24.713095),
					new BMap.Point(102.75676,24.713309),
					new BMap.Point(102.757442,24.713489),
					new BMap.Point(102.75755,24.712283),
					new BMap.Point(102.757658,24.711585),
					new BMap.Point(102.756454,24.711446),
					new BMap.Point(102.756445,24.709509),
					new BMap.Point(102.756544,24.707983),
					new BMap.Point(102.756544,24.707425),
					new BMap.Point(102.756122,24.707531),
					new BMap.Point(102.755691,24.707704),
					new BMap.Point(102.755502,24.708885),
					new BMap.Point(102.755053,24.710453),
					new BMap.Point(102.754864,24.71129),
					new BMap.Point(102.754622,24.712275),
					new BMap.Point(102.754442,24.71298),
					new BMap.Point(102.754442,24.71298),
					new BMap.Point(102.754442,24.71298)
				 ],    
				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				//map.addOverlay(polyline); 

				var polyline10 = new BMap.Polygon([    
					new BMap.Point(102.756427,24.711471),
					new BMap.Point(102.757658,24.711585),
					new BMap.Point(102.758987,24.711684),
					new BMap.Point(102.759392,24.709427),
					new BMap.Point(102.75949,24.708295),
					new BMap.Point(102.759625,24.707031),
					new BMap.Point(102.759661,24.706407),
					new BMap.Point(102.758493,24.706809),
					new BMap.Point(102.756535,24.707433),
					new BMap.Point(102.756508,24.708885),
					new BMap.Point(102.756445,24.709189),
					new BMap.Point(102.756454,24.710404),
					new BMap.Point(102.756454,24.711454)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#ff7f00",fillOpacity:0.4}    
				);  
				polyline10.addEventListener("mouseover", function(){
				  polyline10.setFillOpacity("0.8")
				});
				polyline10.addEventListener("mouseout", function(){
				  polyline10.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline10); 

				var polyline9 = new BMap.Polygon([    
					new BMap.Point(102.759535,24.708721),
					new BMap.Point(102.761368,24.708787),
					new BMap.Point(102.76135,24.707474),
					new BMap.Point(102.759661,24.707474),
					new BMap.Point(102.759499,24.708738)

				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				polyline9.addEventListener("mouseover", function(){
				  polyline9.setFillOpacity("0.8")
				});
				polyline9.addEventListener("mouseout", function(){
				  polyline9.setFillOpacity("0.4")
				});

				map.addOverlay(polyline9); 

				var polyline8 = new BMap.Polygon([    
					new BMap.Point(102.759652,24.707474),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761341,24.706563),
					new BMap.Point(102.761377,24.705964),
					new BMap.Point(102.760425,24.70612),
					new BMap.Point(102.759778,24.706374),
					new BMap.Point(102.759769,24.707023),
					new BMap.Point(102.759688,24.707433),
					new BMap.Point(102.759643,24.707499)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline8.addEventListener("mouseover", function(){
				  polyline8.setFillOpacity("0.8")
				});
				polyline8.addEventListener("mouseout", function(){
				  polyline8.setFillOpacity("0.4")
				});

				map.addOverlay(polyline8); 

				var polyline7 = new BMap.Polygon([    
					new BMap.Point(102.761431,24.710461),
					new BMap.Point(102.763398,24.710527),
					new BMap.Point(102.763479,24.710404),
					new BMap.Point(102.763407,24.708877),
					new BMap.Point(102.761745,24.708877),
					new BMap.Point(102.761368,24.708894),
					new BMap.Point(102.761449,24.710428),
					new BMap.Point(102.761431,24.710478)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#ff7f00",fillOpacity:0.4}    
				);   
				polyline7.addEventListener("mouseover", function(){
				  polyline7.setFillOpacity("0.8")
				});
				polyline7.addEventListener("mouseout", function(){
				  polyline7.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline7); 


				var polyline6 = new BMap.Polygon([    
					new BMap.Point(102.754855,24.711282),
					new BMap.Point(102.756436,24.711454),
					new BMap.Point(102.756454,24.710379),
					new BMap.Point(102.756454,24.709862),
					new BMap.Point(102.755322,24.709649),
					new BMap.Point(102.754864,24.711241),
					new BMap.Point(102.754846,24.711298)
				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				polyline6.addEventListener("mouseover", function(){
				  polyline6.setFillOpacity("0.8")
				});
				polyline6.addEventListener("mouseout", function(){
				  polyline6.setFillOpacity("0.4")
				});

				map.addOverlay(polyline6); 


				var polyline5 = new BMap.Polygon([    
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.755601,24.708451),
					new BMap.Point(102.755718,24.70772),
					new BMap.Point(102.756149,24.707523),
					new BMap.Point(102.756553,24.707474),
					new BMap.Point(102.756535,24.708327),
					new BMap.Point(102.75649,24.709017),
					new BMap.Point(102.756427,24.709214),
					new BMap.Point(102.756454,24.709813),
					new BMap.Point(102.756409,24.709878)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#FF7F00",fillOpacity:0.4}    
				);    
				polyline5.addEventListener("mouseover", function(){
				  polyline5.setFillOpacity("0.8")
				});
				polyline5.addEventListener("mouseout", function(){
				  polyline5.setFillOpacity("0.4")
				});

				map.addOverlay(polyline5); 

				var polyline4 = new BMap.Polygon([    
					new BMap.Point(102.759284,24.711717),
					new BMap.Point(102.760407,24.711914),
					new BMap.Point(102.760488,24.710888),
					new BMap.Point(102.75985,24.710839),
					new BMap.Point(102.759787,24.710576),
					new BMap.Point(102.759814,24.710338),
					new BMap.Point(102.759347,24.710305),
					new BMap.Point(102.759185,24.711577),
					new BMap.Point(102.759266,24.711717)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#FF7F00",fillOpacity:0.4}    
				);  
				polyline4.addEventListener("mouseover", function(){
				  polyline4.setFillOpacity("0.8")
				});
				polyline4.addEventListener("mouseout", function(){
				  polyline4.setFillOpacity("0.4")
				});
				

				map.addOverlay(polyline4); 

				var polyline3 = new BMap.Polygon([    
					new BMap.Point(102.764853,24.708278),
					new BMap.Point(102.766803,24.708016),
					new BMap.Point(102.766138,24.706998),
					new BMap.Point(102.765365,24.707572),
					new BMap.Point(102.76453,24.707531),
					new BMap.Point(102.764835,24.708278)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline3.addEventListener("mouseover", function(){
				  polyline3.setFillOpacity("0.8")
				});
				polyline3.addEventListener("mouseout", function(){
				  polyline3.setFillOpacity("0.4")
				});

				map.addOverlay(polyline3); 


				var polyline2 = new BMap.Polygon([    
					new BMap.Point(102.757766,24.7063),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759958,24.704626),
					new BMap.Point(102.757622,24.704634),
					new BMap.Point(102.756894,24.705841),
					new BMap.Point(102.757487,24.7063),
					new BMap.Point(102.757757,24.706309)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    

				polyline2.addEventListener("mouseover", function(){
				  polyline2.setFillOpacity("0.8")
				});
				polyline2.addEventListener("mouseout", function(){
				  polyline2.setFillOpacity("0.4")
				});


				map.addOverlay(polyline2); 

				var polyline1 = new BMap.Polygon([    
					new BMap.Point(102.762051,24.7047),
					new BMap.Point(102.764548,24.704372),
					new BMap.Point(102.763838,24.703264),
					new BMap.Point(102.761997,24.702771),
					new BMap.Point(102.762527,24.70374),
					new BMap.Point(102.761224,24.703822),
					new BMap.Point(102.761233,24.704495),
					new BMap.Point(102.762042,24.7047)
				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				
				polyline1.addEventListener("mouseover", function(){
				  polyline1.setFillOpacity("0.8")
				});
				polyline1.addEventListener("mouseout", function(){
				  polyline1.setFillOpacity("0.4")
				});

				map.addOverlay(polyline1); 

				var point = new BMap.Point(102.757411,24.709546);  
				var marker = new BMap.Marker(point);        // 创建标注    
				
				map.addOverlay(marker);
				map.centerAndZoom(point, 17); 
				map.panTo(point);


		});

		$('#landId').datagrid( {

			  onClickRow:function(rowIndex,rowData){

				if(rowData.fcid == "F_001"){
				
					var map = new BMap.Map("container");  
					map.addControl(new BMap.NavigationControl()); 
					map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
					map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
					map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦
					var polyline = new BMap.Polygon([    
						new BMap.Point(102.76135,24.708836),
						new BMap.Point(102.763398,24.708828),
						new BMap.Point(102.763299,24.70699),
						new BMap.Point(102.763218,24.706021),
						new BMap.Point(102.763156,24.705463),
						new BMap.Point(102.76144,24.705906),
						new BMap.Point(102.76135,24.707523),
						new BMap.Point(102.761368,24.708812),
						new BMap.Point(102.761368,24.708812),
						new BMap.Point(102.761368,24.708812)
					 ],    
					 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
					);    
					polyline.addEventListener("mouseover", function(){
					  polyline.setFillOpacity("0.8")
					});
					polyline.addEventListener("mouseout", function(){
					  polyline.setFillOpacity("0.4")
					});

					map.addOverlay(polyline);      
					var point = new BMap.Point(102.762365,24.707417);  
					var marker = new BMap.Marker(point);        // 创建标注    
					
					map.addOverlay(marker);
					map.centerAndZoom(point, 17); 
					map.panTo(point);
					var sContent =
					"<h4 style='margin:0 0 5px 0;padding:0.2em 0'>晋宁金辰房地产开发有限公司</h4>" + 
					"<img style='float:right;margin:4px' id='imgDemo' src='01300000057455119927737139802.jpg' width='209' height='124' title='晋宁县磷化集团职工医院'/>" + 
					"<p style='margin:0;line-height:1.5;font-size:14px;text-indent:2em'>晋宁金辰房地产开发有限公司<br>位于昆明市晋宁县..................<br>..................</p><br><br><br><br><br><br>" + 

					"<table style='width:500px'>" + 
						"<tr><td>" +

							"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>" +
							"<table>" +
							"<tr><td align=right>使用方名称&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b><a href='javascript:gotoDetail()' class='theforever_knight1'>晋宁金辰房地产开发有限公司</a></b></font></td></tr>" + 
							"<tr><td align=right>房产来源&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>自用</b></font></td></tr>" + 
							"<tr><td align=right>所有方信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>晋宁县磷化集团</b></font></td></tr>" + 
							"<tr><td align=right>房屋建筑面积&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>10000</b></font></td></tr>" + 
							"<tr><td align=right>使用面积&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>10000</b></font></td></tr>" + 
							"<tr><td align=right>土地使用税应缴信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>单价:3&nbsp;&nbsp;&nbsp;&nbsp;面积:2000&nbsp;&nbsp;&nbsp;&nbsp;税额:6000&nbsp;&nbsp;&nbsp;&nbsp;已缴清:&nbsp;&nbsp;&nbsp;<input type='checkbox'/></b></font></td></tr>" + 
							"<tr><td align=right>房产税应缴信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>原值:500000&nbsp;&nbsp;&nbsp;&nbsp;税率:0.12&nbsp;&nbsp;&nbsp;&nbsp;税额:42000&nbsp;&nbsp;&nbsp;&nbsp;已缴清:&nbsp;&nbsp;&nbsp;<input type='checkbox'/></b></font></td></tr>" + 
							"<tr><td align=right>其他税款总额信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td><font color='orange'><b>单价:26&nbsp;&nbsp;&nbsp;&nbsp;面积:1000&nbsp;&nbsp;&nbsp;&nbsp;税额:26000&nbsp;&nbsp;&nbsp;&nbsp;已缴清:&nbsp;&nbsp;&nbsp;<input type='checkbox' checked/></b></font></td></tr>" + 
							"</table></p>" + 

						"</td>" +
						
					"</tr>" +
					"</table>" +

					"</div>";
					var infoWindow = new BMap.InfoWindow(sContent); 
					marker.addEventListener("click", function(){          
					   this.openInfoWindow(infoWindow);
					   //图片加载完毕重绘infowindow
					   document.getElementById('imgDemo').onload = function (){
						   infoWindow.redraw();
					   }
					});
				}

				if(rowData.fcid == "F_002"){
				//alert(rowData.fcid);
					var map = new BMap.Map("container");  
					map.addControl(new BMap.NavigationControl()); 
					map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
					map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
					map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦
					var polyline = new BMap.Polygon([    
						new BMap.Point(102.761422,24.710412),
						new BMap.Point(102.76338,24.710494),
						new BMap.Point(102.763308,24.70882),
						new BMap.Point(102.76135,24.708853),
						new BMap.Point(102.761476,24.71033)
					 ],    
					 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
					);    
					polyline.addEventListener("mouseover", function(){
					  polyline.setFillOpacity("0.8")
					});
					polyline.addEventListener("mouseout", function(){
					  polyline.setFillOpacity("0.4")
					});

					map.addOverlay(polyline);     
					var point = new BMap.Point(102.762464,24.709624);
					var marker = new BMap.Marker(point);        // 创建标注    
					
					map.addOverlay(marker);
					map.centerAndZoom(point, 17); 
					map.panTo(point);
					var sContent =
					"<h4 style='margin:0 0 5px 0;padding:0.2em 0'>和煦阳光</h4>" + 
					"<img style='float:right;margin:4px' id='imgDemo' src='jingtong.jpg' width='139' height='104' title='和煦阳光'/>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>和煦阳光小区位于昆明市晋宁县.........</p><br><br><br><br><br><br>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>房产用途:住宅</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>投入使用时间:2011-02-03</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>详细地址:xxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>所属乡镇:xxxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>房产建筑面积:xxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>房产原值:xxxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>建筑安装成本:xxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>是否单独地下建筑:工业</p>" + 
					"</div>";
					var infoWindow = new BMap.InfoWindow(sContent); 
					marker.addEventListener("click", function(){          
					   this.openInfoWindow(infoWindow);
					   //图片加载完毕重绘infowindow
					   document.getElementById('imgDemo').onload = function (){
						   infoWindow.redraw();
					   }
					});

				}
				if(rowData.fcid == "F_003"){
				//alert(rowData.fcid);
					var map = new BMap.Map("container");  
					map.addControl(new BMap.NavigationControl()); 
					map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
					map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
					map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦
					var polyline = new BMap.Polygon([    
						new BMap.Point(102.759392,24.710264),
						new BMap.Point(102.761404,24.710412),
						new BMap.Point(102.761386,24.70882),
						new BMap.Point(102.759589,24.708705),
						new BMap.Point(102.759338,24.710264)
					 ],    
					 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5}    
					);    
					map.addOverlay(polyline);    
					var point = new BMap.Point(102.760506,24.709509);
					var marker = new BMap.Marker(point);        // 创建标注   
					
					map.addOverlay(marker);
					map.centerAndZoom(point, 17); 
					map.panTo(point);
					var sContent =
					"<h4 style='margin:0 0 5px 0;padding:0.2em 0'>迎新小区</h4>" + 
					"<img style='float:right;margin:4px' id='imgDemo' src='time.jpg' width='139' height='104' title='迎新小区'/>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>迎新小区小区位于昆明市晋宁县.........</p><br><br><br><br><br><br>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>房产用途:住宅</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>投入使用时间:2011-02-03</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>详细地址:xxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>所属乡镇:xxxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>房产建筑面积:xxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>房产原值:xxxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>建筑安装成本:xxxxxxxxx</p>" + 
					"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>是否单独地下建筑:工业</p>" + 
					"</div>";
					var infoWindow = new BMap.InfoWindow(sContent); 
					marker.addEventListener("click", function(){          
					   this.openInfoWindow(infoWindow);
					   //图片加载完毕重绘infowindow
					   document.getElementById('imgDemo').onload = function (){
						   infoWindow.redraw();
					   }
					});
				}
				if(rowData.fcid == "F_004"){
				//alert(rowData.fcid);
					var map = new BMap.Map("container");  
					map.addControl(new BMap.NavigationControl()); 
					map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
					map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
					map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦
					var polyline = new BMap.Polygon([    
						new BMap.Point(102.759356,24.710305),
						new BMap.Point(102.761413,24.710461),
						new BMap.Point(102.761404,24.709378),
						new BMap.Point(102.761359,24.708836),
						new BMap.Point(102.759562,24.708738),
						new BMap.Point(102.759383,24.710272),
						new BMap.Point(102.759347,24.710305)
					 ],    
					 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5}    
					);    
					map.addOverlay(polyline);    
					var point = new BMap.Point(102.760465,24.709563);
					var marker = new BMap.Marker(point);        // 创建标注   
					
					map.addOverlay(marker);
					map.centerAndZoom(point, 17); 
					map.panTo(point);
				}
				if(rowData.fcid == "F_005"){
				//alert(rowData.fcid);
					var map = new BMap.Map("container");  
					map.addControl(new BMap.NavigationControl()); 
					map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
					map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
					map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦
					var polyline = new BMap.Polygon([    
						new BMap.Point(102.754631,24.712201),
						new BMap.Point(102.755313,24.712496),
						new BMap.Point(102.756445,24.712349),
						new BMap.Point(102.756454,24.711429),
						new BMap.Point(102.754918,24.711274),
						new BMap.Point(102.754685,24.712176),
						new BMap.Point(102.754631,24.712201)
					 ],    
					 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5}    
					);    
					map.addOverlay(polyline);    
					var point = new BMap.Point(102.755628,24.711856);
					var marker = new BMap.Marker(point);        // 创建标注   
					
					map.addOverlay(marker);
					map.centerAndZoom(point, 17); 
					map.panTo(point);
				}

				//alert(rowData.landid);
			  },
			  onDblClickRow :function(rowIndex,rowData){
			  // alert("222");
			  } 
			  
			  });	
	}
)
</script>

</head>  
   
<body>  
	<div class="easyui-layout" style="width:1300px;height:600px;">
		<div data-options="region:'west',split:true" title="土地信息" style="width:350px;">
	
			
			<table id="landId" class="easyui-datagrid"
					data-options="  
						url:'datagrid_data1.json',
						singleSelect:true,  
						collapsible:true,  
						rownumbers:true,  
						fitColumns:true,  
						view:groupview,  
						groupField:'landid',  
						groupFormatter:function(value,rows){  
							if(value == 'L_001'){
								return '<div id=title_' + value + '><font color=green>编号:' + rows[0].landid + '&nbsp;&nbsp;&nbsp;&nbsp;地址:' + rows[0].landposition + '&nbsp;&nbsp;&nbsp;&nbsp;获取时间:' + rows[0].landdate + '</font></div>';  
							}
							if(value == 'L_002'){
								return '<div id=title_' + value + '><font color=red>编号:' + rows[0].landid + '&nbsp;&nbsp;&nbsp;&nbsp;地址:' + rows[0].landposition + '&nbsp;&nbsp;&nbsp;&nbsp;获取时间:' + rows[0].landdate + '</font></div>';  
							}
							if(value == 'L_003'){
								return '<div id=title_' + value + '><font color=orange>编号:' + rows[0].landid + '&nbsp;&nbsp;&nbsp;&nbsp;地址:' + rows[0].landposition + '&nbsp;&nbsp;&nbsp;&nbsp;获取时间:' + rows[0].landdate + '</font></div>';  
							}
						}  
					">  
				<thead>  
					<tr>  
						<th data-options="field:'fcid',width:80">房产编号</th>  
						<th data-options="field:'fcposition',width:100">房产座落位置</th>  
						<th data-options="field:'fcdate',width:80,align:'right'">投入使用时间</th>  
					</tr>  
				</thead>  
			</table>  
			
			
		</div>

		<div data-options="region:'center',title:'土地位置',iconCls:'icon-ok'" style="width:900px;">
			<div id="container"></div>
		</div>
</div>
<script type="text/javascript"> 




var map = new BMap.Map("container");    
var point = new BMap.Point(102.75393,24.712152);    
map.centerAndZoom(point, 17);  // 编写自定义函数，创建标注   
map.addControl(new BMap.NavigationControl()); 

map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT})); 
map.setCurrentCity("晋宁");   //由于有3D图，需要设置城市哦





				var polyline13 = new BMap.Polygon([    
					new BMap.Point(102.759356,24.710305),
					new BMap.Point(102.761413,24.710461),
					new BMap.Point(102.761404,24.709378),
					new BMap.Point(102.761359,24.708836),
					new BMap.Point(102.759562,24.708738),
					new BMap.Point(102.759383,24.710272),
					new BMap.Point(102.759347,24.710305)
				 ],    
				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline13.addEventListener("mouseover", function(){
				  polyline13.setFillOpacity("0.8")
				});
				polyline13.addEventListener("mouseout", function(){
				  polyline13.setFillOpacity("0.4")
				});

				map.addOverlay(polyline13);    

				var polyline12 = new BMap.Polygon([    
					new BMap.Point(102.76135,24.708836),
					new BMap.Point(102.763398,24.708828),
					new BMap.Point(102.763299,24.70699),
					new BMap.Point(102.763218,24.706021),
					new BMap.Point(102.763156,24.705463),
					new BMap.Point(102.76144,24.705906),
					new BMap.Point(102.76135,24.707523),
					new BMap.Point(102.761368,24.708812),
					new BMap.Point(102.761368,24.708812),
					new BMap.Point(102.761368,24.708812)
				 ],    
				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);  
				polyline12.addEventListener("mouseover", function(){
				  polyline12.setFillOpacity("0.8")
				});
				polyline12.addEventListener("mouseout", function(){
				  polyline12.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline12); 


				var polyline = new BMap.Polygon([    
					new BMap.Point(102.754478,24.713145),
					new BMap.Point(102.755583,24.713095),
					new BMap.Point(102.75676,24.713309),
					new BMap.Point(102.757442,24.713489),
					new BMap.Point(102.75755,24.712283),
					new BMap.Point(102.757658,24.711585),
					new BMap.Point(102.756454,24.711446),
					new BMap.Point(102.756445,24.709509),
					new BMap.Point(102.756544,24.707983),
					new BMap.Point(102.756544,24.707425),
					new BMap.Point(102.756122,24.707531),
					new BMap.Point(102.755691,24.707704),
					new BMap.Point(102.755502,24.708885),
					new BMap.Point(102.755053,24.710453),
					new BMap.Point(102.754864,24.71129),
					new BMap.Point(102.754622,24.712275),
					new BMap.Point(102.754442,24.71298),
					new BMap.Point(102.754442,24.71298),
					new BMap.Point(102.754442,24.71298)
				 ],    
				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				//map.addOverlay(polyline); 

				var polyline10 = new BMap.Polygon([    
					new BMap.Point(102.756427,24.711471),
					new BMap.Point(102.757658,24.711585),
					new BMap.Point(102.758987,24.711684),
					new BMap.Point(102.759392,24.709427),
					new BMap.Point(102.75949,24.708295),
					new BMap.Point(102.759625,24.707031),
					new BMap.Point(102.759661,24.706407),
					new BMap.Point(102.758493,24.706809),
					new BMap.Point(102.756535,24.707433),
					new BMap.Point(102.756508,24.708885),
					new BMap.Point(102.756445,24.709189),
					new BMap.Point(102.756454,24.710404),
					new BMap.Point(102.756454,24.711454)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#ff7f00",fillOpacity:0.4}    
				);  
				polyline10.addEventListener("mouseover", function(){
				  polyline10.setFillOpacity("0.8")
				});
				polyline10.addEventListener("mouseout", function(){
				  polyline10.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline10); 

				var polyline9 = new BMap.Polygon([    
					new BMap.Point(102.759535,24.708721),
					new BMap.Point(102.761368,24.708787),
					new BMap.Point(102.76135,24.707474),
					new BMap.Point(102.759661,24.707474),
					new BMap.Point(102.759499,24.708738)

				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				polyline9.addEventListener("mouseover", function(){
				  polyline9.setFillOpacity("0.8")
				});
				polyline9.addEventListener("mouseout", function(){
				  polyline9.setFillOpacity("0.4")
				});

				map.addOverlay(polyline9); 

				var polyline8 = new BMap.Polygon([    
					new BMap.Point(102.759652,24.707474),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761296,24.707499),
					new BMap.Point(102.761341,24.706563),
					new BMap.Point(102.761377,24.705964),
					new BMap.Point(102.760425,24.70612),
					new BMap.Point(102.759778,24.706374),
					new BMap.Point(102.759769,24.707023),
					new BMap.Point(102.759688,24.707433),
					new BMap.Point(102.759643,24.707499)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline8.addEventListener("mouseover", function(){
				  polyline8.setFillOpacity("0.8")
				});
				polyline8.addEventListener("mouseout", function(){
				  polyline8.setFillOpacity("0.4")
				});

				map.addOverlay(polyline8); 

				var polyline7 = new BMap.Polygon([    
					new BMap.Point(102.761431,24.710461),
					new BMap.Point(102.763398,24.710527),
					new BMap.Point(102.763479,24.710404),
					new BMap.Point(102.763407,24.708877),
					new BMap.Point(102.761745,24.708877),
					new BMap.Point(102.761368,24.708894),
					new BMap.Point(102.761449,24.710428),
					new BMap.Point(102.761431,24.710478)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#ff7f00",fillOpacity:0.4}    
				);   
				polyline7.addEventListener("mouseover", function(){
				  polyline7.setFillOpacity("0.8")
				});
				polyline7.addEventListener("mouseout", function(){
				  polyline7.setFillOpacity("0.4")
				});
				
				map.addOverlay(polyline7); 


				var polyline6 = new BMap.Polygon([    
					new BMap.Point(102.754855,24.711282),
					new BMap.Point(102.756436,24.711454),
					new BMap.Point(102.756454,24.710379),
					new BMap.Point(102.756454,24.709862),
					new BMap.Point(102.755322,24.709649),
					new BMap.Point(102.754864,24.711241),
					new BMap.Point(102.754846,24.711298)
				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				polyline6.addEventListener("mouseover", function(){
				  polyline6.setFillOpacity("0.8")
				});
				polyline6.addEventListener("mouseout", function(){
				  polyline6.setFillOpacity("0.4")
				});

				map.addOverlay(polyline6); 


				var polyline5 = new BMap.Polygon([    
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.75534,24.709608),
					new BMap.Point(102.755601,24.708451),
					new BMap.Point(102.755718,24.70772),
					new BMap.Point(102.756149,24.707523),
					new BMap.Point(102.756553,24.707474),
					new BMap.Point(102.756535,24.708327),
					new BMap.Point(102.75649,24.709017),
					new BMap.Point(102.756427,24.709214),
					new BMap.Point(102.756454,24.709813),
					new BMap.Point(102.756409,24.709878)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#FF7F00",fillOpacity:0.4}    
				);    
				polyline5.addEventListener("mouseover", function(){
				  polyline5.setFillOpacity("0.8")
				});
				polyline5.addEventListener("mouseout", function(){
				  polyline5.setFillOpacity("0.4")
				});

				map.addOverlay(polyline5); 

				var polyline4 = new BMap.Polygon([    
					new BMap.Point(102.759284,24.711717),
					new BMap.Point(102.760407,24.711914),
					new BMap.Point(102.760488,24.710888),
					new BMap.Point(102.75985,24.710839),
					new BMap.Point(102.759787,24.710576),
					new BMap.Point(102.759814,24.710338),
					new BMap.Point(102.759347,24.710305),
					new BMap.Point(102.759185,24.711577),
					new BMap.Point(102.759266,24.711717)
				 ],    

				 {strokeColor:"#FF7F00", strokeWeight:6, strokeOpacity:0.5,fillColor:"#FF7F00",fillOpacity:0.4}    
				);  
				polyline4.addEventListener("mouseover", function(){
				  polyline4.setFillOpacity("0.8")
				});
				polyline4.addEventListener("mouseout", function(){
				  polyline4.setFillOpacity("0.4")
				});
				

				map.addOverlay(polyline4); 

				var polyline3 = new BMap.Polygon([    
					new BMap.Point(102.764853,24.708278),
					new BMap.Point(102.766803,24.708016),
					new BMap.Point(102.766138,24.706998),
					new BMap.Point(102.765365,24.707572),
					new BMap.Point(102.76453,24.707531),
					new BMap.Point(102.764835,24.708278)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    
				polyline3.addEventListener("mouseover", function(){
				  polyline3.setFillOpacity("0.8")
				});
				polyline3.addEventListener("mouseout", function(){
				  polyline3.setFillOpacity("0.4")
				});

				map.addOverlay(polyline3); 


				var polyline2 = new BMap.Polygon([    
					new BMap.Point(102.757766,24.7063),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759922,24.705652),
					new BMap.Point(102.759958,24.704626),
					new BMap.Point(102.757622,24.704634),
					new BMap.Point(102.756894,24.705841),
					new BMap.Point(102.757487,24.7063),
					new BMap.Point(102.757757,24.706309)
				 ],    

				 {strokeColor:"red", strokeWeight:6, strokeOpacity:0.5,fillColor:"red",fillOpacity:0.4}    
				);    

				polyline2.addEventListener("mouseover", function(){
				  polyline2.setFillOpacity("0.8")
				});
				polyline2.addEventListener("mouseout", function(){
				  polyline2.setFillOpacity("0.4")
				});


				map.addOverlay(polyline2); 

				var polyline1 = new BMap.Polygon([    
					new BMap.Point(102.762051,24.7047),
					new BMap.Point(102.764548,24.704372),
					new BMap.Point(102.763838,24.703264),
					new BMap.Point(102.761997,24.702771),
					new BMap.Point(102.762527,24.70374),
					new BMap.Point(102.761224,24.703822),
					new BMap.Point(102.761233,24.704495),
					new BMap.Point(102.762042,24.7047)
				 ],    

				 {strokeColor:"green", strokeWeight:6, strokeOpacity:0.5,fillColor:"green",fillOpacity:0.4}    
				);    
				
				polyline1.addEventListener("mouseover", function(){
				  polyline1.setFillOpacity("0.8")
				});
				polyline1.addEventListener("mouseout", function(){
				  polyline1.setFillOpacity("0.4")
				});

				map.addOverlay(polyline1); 



</script>  
</body>  
</html>  