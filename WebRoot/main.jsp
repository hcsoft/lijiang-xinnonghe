<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%
	response.setHeader("Content-Type", "text/html");
	//no cache
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <link href="./css/modern.css" rel="stylesheet">
    <link href="./css/modern-responsive.css" rel="stylesheet">
    <link href="./css/droptiles.css" rel="stylesheet">
	<link rel="stylesheet" href="./themes/sunny/easyui.css">
	<link rel="stylesheet" href="./themes/icon.css">
	<link rel="stylesheet" href="./css/toolbar.css">
	<link rel="stylesheet" href="./css/logout.css"/>
	<script src="./js/jquery-1.8.2.min.js"></script>
	<script src="./js/jquery.easyui.min.js"></script>
	<!-- <script src="./js/dropdown.js"></script> -->
    <script src="./js/tiles.js"></script>
    <script src="./js/moduleWindow.js"></script>
	<!-- <script src="/menus.js"></script> -->
	
	<script src="./js/jquery.simplemodal.js"></script>
	<script src="./js/overlay.js"></script>
	<script src="./js/jquery.json-2.2.js"></script>

    
    <title>新农合证卡管理系统</title>

    <style>
        body {
            background-image:url(<%=request.getContextPath()%>/images/InBloom.jpg)  
        }
		div[data-liffect="zoomIn"] > div {
			opacity: 0;
			position: relative;
			animation: zoomIn 1000ms ease both;
			animation-play-state: paused;
		}

		div[data-liffect="zoomIn"].play > div {
			animation-play-state: running;
		}


		@keyframes zoomIn {
			0% { opacity: 0; transform: scale(1.5); }
			100% { opacity: 1; transform: scale(1); }
		}
    </style>

    <script>

$(function(){
		var agentScreen = [{"scWidth":"1920","scHeight":"1080","uiReigon1Width":"1100px","uiReigon2Width":"562px","tileSize":"100"},{"scWidth":"1680","scHeight":"1050","uiReigon1Width":"1000px","uiReigon2Width":"462px","tileSize":"100"},{"scWidth":"1600","scHeight":"900","uiReigon1Width":"900px","uiReigon2Width":"562px","tileSize":"100"},{"scWidth":"1440","scHeight":"900","uiReigon1Width":"750px","uiReigon2Width":"562px","tileSize":"100"},{"scWidth":"1400","scHeight":"1050","uiReigon1Width":"700px","uiReigon2Width":"562px","tileSize":"100"},{"scWidth":"1366","scHeight":"768","uiReigon1Width":"802px","uiReigon2Width":"362px","tileSize":"100"},{"scWidth":"1360","scHeight":"768","uiReigon1Width":"802px","uiReigon2Width":"362px","tileSize":"100"},{"scWidth":"1280","scHeight":"768","uiReigon1Width":"752px","uiReigon2Width":"362px","tileSize":"100"},{"scWidth":"1280","scHeight":"720","uiReigon1Width":"762px","uiReigon2Width":"362px","tileSize":"100"},{"scWidth":"1280","scHeight":"600","uiReigon1Width":"762px","uiReigon2Width":"362px","tileSize":"80"},{"scWidth":"1024","scHeight":"768","uiReigon1Width":"552px","uiReigon2Width":"362px","tileSize":"80"}];
		var screenWidth = screen.width;
		var screenHeight = screen.height;
		//alert(screenWidth);
		//alert(screenHeight);
		var uiReigon1Width,uiReigon2Width,tileSize;
		for(var i in agentScreen){
			if(screenWidth == agentScreen[i].scWidth && screenHeight == agentScreen[i].scHeight){
				uiReigon1Width = agentScreen[i].uiReigon1Width;
				uiReigon2Width = agentScreen[i].uiReigon2Width;
				tileSize = agentScreen[i].tileSize;
			}
			//alert(agentScreen[i].scWidth + "---" + agentScreen[i].scHeight);
		}
		//alert(uiReigon1Width + "---" + uiReigon2Width + "---" + tileSize);
		$("div.tile-group:first").width(uiReigon1Width);
		$("div.tile-group:last").width(uiReigon2Width);
		$.ajax({
			   type: "get",
			   async:false,
			   url: "<%=request.getContextPath()%>/FuncMenuServlet/getTodoMenu.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
			       window.todo_menu = {};
			       for(var i = 0 ;i <jsondata.length;i++){
				    window.todo_menu[jsondata[i].resource_id] = jsondata[i];
			       }
			   }
		});
		$.ajax({
			   type: "get",
			   url: "<%=request.getContextPath()%>/FuncMenuServlet/getFuncMenu.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(jsondata.funcMenuJson);
				   //var t = '[{"a":"1","b":"2"},{"ca":"3","d":"4"}]';
						// '[{"name":"John"},{"name":"John"}]'
				   //alert(t.length);
				   //alert(jQuery.parseJSON(t));
				   var z = '[{"selfId":"mainId1","parentId":"#mainFuncId","isDouble":"no","bgColor":"bg-color-red","tileType":"icon","imgSrc":"<%=request.getContextPath()%>/images/Calendar.png","brandName":"电子地图","brandCount":"","badgeColor":"","tileHtml":"","submenus":[{"selfId":"","parentId":"#subFuncId","isDouble":"no","bgColor":"bg-color-pinkDark","tileType":"icon","imgSrc":"<%=request.getContextPath()%>/images/MB_0015_currency-e-j.png","brandName":"地块税收监控","brandCount":"","badgeColor":"","tileHtml":"","menuIcon":"<%=request.getContextPath()%>/images/MB_0015_currency-e-j.png","menuUrl":"url:/map/basic2.html"},{"selfId":"","parentId":"#subFuncId","isDouble":"no","bgColor":"bg-color-pinkDark","tileType":"icon","imgSrc":"<%=request.getContextPath()%>/images/MB_0012_COMPAS2.png","brandName":"土地房产监控","brandCount":"","badgeColor":"","tileHtml":"","menuIcon":"<%=request.getContextPath()%>/images/MB_0012_COMPAS2.png","menuUrl":"url:/map/basic3.html"}]}]';
					//alert(jQuery.parseJSON(z));
					regex = new RegExp("null","g");  
					//$inputValue = $inputValue.replace(regex, "");  
					var menus = jQuery.parseJSON(jsondata.funcMenuJson.replace(regex, ""));
					//alert(menus);
					var localObj = window.location;
					var contextPath = "/"+localObj.pathname.split("/")[1]; 
					for (var i in menus) {
						new tiles(menus[i].selfId,menus[i].parentId,menus[i].isDouble,menus[i].bgColor,menus[i].tileType,menus[i].imgSrc,menus[i].brandName,menus[i].brandCount,menus[i].badgeColor,menus[i].tileHtml,menus[i].todoUrl,menus[i].todoMenuid).bind('click',{index: i},  function(event){
							var brothernodes = $(this).siblings();
							for(var j = 0;j < brothernodes.length;j++){
								$(brothernodes[j]).fadeTo('fast',0.35);
							}
							 $(this).fadeTo('fast',1);
							var i = event.data.index;
							var submenus = menus[event.data.index].submenus;
							$('#subFuncId').empty();
							for (var j in submenus) {
								new tiles(submenus[j].selfId,submenus[j].parentId,submenus[j].isDouble,submenus[j].bgColor,submenus[j].tileType,submenus[j].imgSrc,submenus[j].brandName,submenus[j].brandCount,submenus[j].badgeColor,submenus[j].tileHtml,submenus[j].todoUrl,submenus[j].todoMenuid).bind('click',{index: j},  function(event){
									var j = event.data.index;
									moduleWindow.open({
										id: "module_" + submenus[j].resource_id + "_" + "Id",
										title: submenus[j].brandName,
										width: 1200,
										height: 580,
										icon: submenus[j].menuIcon,
										minimizable: true,
										maximized:true,
										//data: {name: 'Tom', age: 18}, //传递给iframe的数据
										content: submenus[j].menuUrl,
										onLoad: function(dialog){
											if(this.content && this.content.doInit){//判断弹出窗体iframe中的doInit方法是否存在
												this.content.doInit(dialog);//调用并将参数传入，此处当然也可以传入其他内容
											}
										},
										onBeforeClose:function(dialog){
											updatenum();
										}
										,buttons: []
										//,buttons: [{"text":"aaa",handler:function(){}},{"text":"bbb",handler:function(){}}]
									});

								});
							
								$("div.tile-group:last > div").width(tileSize+"px").height(tileSize+"px");
								$('div.tile-group:last > div').each(function(i){

									$(this).width(tileSize).width(tileSize+"px").height(tileSize+"px");
									$("div[data-liffect]").addClass("play")

								})

							}

						});
					
					}
					//alert($("div.tile-group:first > div").length);
					$('div.tile-group:first > div').each(function(i){

						//alert($(this).attr("class"));
						if($(this).attr("class").indexOf("double") >= 0){
							$(this).width((tileSize * 2 + 10)+"px").height(tileSize);
						}else{
							$(this).width(tileSize).height(tileSize);
						}
						$("div[data-liffect]").addClass("play");
						
					})
					

	           }
	   });

		//var items=[];
		//$("div.tile-group:first > div").width(tileSize).height(tileSize);
		


})


    </script>
</head>
<body class="modern-ui" style="overflow:hidden">

		<!-- 退出窗口的模态框 -->
		<div id="overlay-modal-content">
			<!--<div id="overlay-modal-title"></div>-->
			<div class="close"><a href="#" class="simplemodal-close">x</a></div>
			<div id="overlay-modal-data">
				<form name="login-form" class="login-form" action="<%=request.getContextPath()%>/j_spring_security_logout" method="post">
					<div class="header">
						<h1></h1>
						<span><img src="<%=request.getContextPath()%>/images/109.png"></span>
					</div>
					<div class="content">
						<label class="label">确实要退出系统吗?</label>
					</div>
					<div class="footer">
						<input type="submit" class="button" value="退出系统"/>
					</div>
				</form>
			</div>
		</div>

        <div class="navbar" >
            <div class="navbar-inner">

                    <div>
                        <ul class="nav">
                            <li><a class="active" href="#"><security:authentication property='principal.orgName'/></a></li>
							<li><a class="active" href="#"><security:authentication property='principal.taxempname'/></a></li>
                            <li style="float:right;padding:0 0 5px 0"><a class="active" id="loginId1">退出</a></li>
                        </ul>
                    </div>
            </div>
        </div>
<div class="page secondary fixed-header">


    <div class="page-region">
        <div class="page-region-content tiles">
            <div data-liffect="zoomIn" class="tile-group" id="mainFuncId">


            </div>




            <div data-liffect="zoomIn" class="tile-group" id="subFuncId">


            </div>






        </div>
    </div>
</div>
<div id="box"> 

</div>  
</body>
</html>
