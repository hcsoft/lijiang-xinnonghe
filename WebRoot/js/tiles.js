function updatenum(){
	$.each($(".todo"),function(){
		var div = $(this);
		$.ajax({
		   type: "get",
		   url: div.attr("todourl"),
		   data: {},
		   dataType: "json",
		   success: function(jsondata){
			   div.children("a").html(jsondata.num);
			   if(jsondata.num && jsondata.num >0){
					div.css("display","block");
				}else{
					div.css("display","none");
				}
		   }});			
	});
}
var tiles = function (selfId,parentId,isDouble,bgColor,tileType,imgSrc,brandName,brandCount,badgeColor,tileHtml,todoUrl,todoMenuid) {
	//$("" + parentId + "").empty();
	var moduleDiv=$("<div></div>"); 
	moduleDiv.attr('id',selfId);
	//moduleDiv.attr();
	moduleDiv.addClass("tile");
	moduleDiv.addClass(tileType);
	if(isDouble == "yes"){
		moduleDiv.addClass("double");
	}
	if(bgColor != null && bgColor != ""){
		moduleDiv.addClass(bgColor);
	}
	$("" + parentId + "").append(moduleDiv);

	var subDiv=$("<div></div>"); 
	subDiv.addClass("tile-content");
	if(tileHtml != null && tileHtml != ""){
		subDiv.append(tileHtml);
		moduleDiv.removeClass(tileType);
	}else{
		subDiv.append("<img src='" + imgSrc + "'/>");
	}
	

	moduleDiv.append(subDiv);

	if(brandName != null && brandName != ""){
		var subDiv=$("<div></div>"); 
		subDiv.addClass("brand");
		var spanDiv=$("<span></span>"); 
		spanDiv.addClass("name");	
		spanDiv.text(brandName);
		subDiv.append(spanDiv);

		if(brandCount != null && brandCount != ""){
			spanDiv=$("<span></span>"); 
			spanDiv.addClass("badge");	
			spanDiv.addClass(badgeColor);
			spanDiv.text(brandCount);
			subDiv.append(spanDiv);
		}
		moduleDiv.append(subDiv);	
		
	}
	//----增加待办事项提醒的div----
	if(todoUrl && todoUrl.trim()  && window.todo_menu[todoMenuid]){
		$.ajax({
			   type: "get",
			   url: todoUrl,
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				   var num = jsondata.num;
				   var params = jsondata.params?$.param(jsondata.params):null;
				   var todoDiv=$("<div></div>"); 
					todoDiv.addClass("todo");
					todoDiv.attr("todourl",todoUrl);
					todoDiv.attr("todomenuid",todoMenuid);
					todoDiv.attr("todoparams",params);
					var linkDiv=$('<a>'+num+'</a>'); 
					if(num && num >0){
						todoDiv.css("display","block");
					}else{
						todoDiv.css("display","none");
					}
					todoDiv.append(linkDiv);
					moduleDiv.append(todoDiv);	
					todoDiv.bind('click',{params:params},function(event){
						var modurl = window.todo_menu[todoMenuid].menuUrl;
						if(params){
							if(modurl.indexOf("?")>0){
								modurl = modurl+"&"+ params;
							}else{
								modurl = modurl+"?"+ params;
							}
						}
						moduleWindow.open({
							id: "module_" +  window.todo_menu[todoMenuid].resource_id + "_Id",
							title: window.todo_menu[todoMenuid].brandName,
							width: 1200,
							height: 580,
							icon:  window.todo_menu[todoMenuid].menuIcon,
							minimizable: true,
							maximized:true,
							//data: {name: 'Tom', age: 18}, //传递给iframe的数据
							content:  modurl,
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
						return false;
					});
			   }
		});
		
	}
	//----增加待办事项提醒的div 结束----
	
	//moduleDiv.animate({left:'40px'});
	moduleDiv.animate({opacity: "0.3", left: "+=50"}, 1000).animate({opacity: "1", left: "=0"}, 800) ;
	//moduleDiv.one('click', ee);
	return moduleDiv;
	//$("#mainFuncId").html(this.contensDiv);
	//alert($("" + parentId + "").html());
	//alert($("" + parentId + "").html());

}


