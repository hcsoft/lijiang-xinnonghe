
var moduleWindow = {
 

open : function(opts){
 		var win;
 		var defaults = {
 			width: 1000,
     		height: 400,
     		minimizable: true,
     		maximizable: true,
     		collapsible: false,
     		resizable: true,
     		isFrame: true,
     		self: false, 
     		data: null,
     		content: '',
     		onLoad: null,
			onOpen: function(){
 			    
				var menuBars = $("#box").find("div");
				var menuBarsLen = menuBars.length;
				var moduleButtonsHtml = "<a href='javascript:miniModuleWindow(\"" + this.id + "\")' class='l-btn' id=''><span class='l-btn-left'><span class='l-btn-text'>最小化</span></span></a>";
				moduleButtonsHtml = moduleButtonsHtml + "<a href='javascript:closeModuleWindow(\"" + this.id + "\")' class='l-btn' id=''><span class='l-btn-left'><span class='l-btn-text'>退出</span></span></a>";
				
				for(var i=0;i<menuBarsLen;i++){
					var menuBar = menuBars[i];
										//alert(this.id + "---" + menuBar.id);
					var switchBarId = menuBar.id.substring(0,menuBar.id.length - 1);
					//moduleButtonsHtml = moduleButtonsHtml + "<a href='javascript:switchModule(\"" + this.id + "\",\"" + switchBarId + "\")' class='l-btn' id=''><img src='" + opts.icon + "' width='15px' height='15px' style='padding-top:3px'/>&nbsp;<span style='padding-bottom:10px'>" + menuBar.title + "</span></a>";
					moduleButtonsHtml = moduleButtonsHtml + "<a href='javascript:switchModule(\"" + this.id + "\",\"" + switchBarId + "\")' class='l-btn' id=''><span class='l-btn-left'><span class='l-btn-text'>" + menuBar.title + "</span></span></a>";
					//alert($("#" + menuBar.id + "").html());
				}
				//alert(moduleButtonsHtml);
				//var moduleButtonsHtml = "<a href='javascript:void(0)' class='l-btn' id=''><span class='l-btn-left'><span class='l-btn-text'>bbb</span></span></a>";
				$('.dialog-button').html(moduleButtonsHtml);
				//$('.dialog-button').css('height', '100px');
				//$('.dialog-toolbar td').each(function(i){
					//$(this).empty();
					//$(this).width("10px");
					//$(this).html("<button style='width:10px'>aaaa</button>");
					//$(this).width("10px");

				//})
				
			},
     		onClose: function(){
				var menuBars = $("#box").find("div");
				var menuBarsLen = menuBars.length;
				
				var beginIndex = 0;
				for(var i=0;i<menuBarsLen;i++){
					var menuBar = menuBars[i];
					
					if(menuBar.id == this.id + "_"){
					//	beginIndex++;日你奶奶，老子搞晕了哦
					//	alert(menuBar);
						$("#" + menuBar.id).remove();

						var menuBars = $("#box").find("div");
						var menuBarsLen = menuBars.length;
												//	alert(menuBarsLen + "===" + beginIndex);

						for(var j=i;j<menuBarsLen;j++){//应该是个双重循环啊，哈哈，终于反应过来了
							var menuBar = menuBars[j];
							//	alert(menuBar);
								$("#" + menuBar.id).animate({opacity: "0.6", left: "-=70"}, 800) ;
								//alert($("#box").html());
							//	alert(menuBars[i].html());
								//menuBars[i+1].css("left",location.left + 5 + "px"); 
								//menuBars[i+1].animate({opacity: "0.6", left: "-=110"}, 800) ;
						//	continue;
						}

						//alert($("#box").html());
					//	continue;
					//	alert(menuBars[i].html());
						//menuBars[i+1].css("left",location.left + 5 + "px"); 
						//menuBars[i+1].animate({opacity: "0.6", left: "-=110"}, 800) ;
					}

				}

     			win.dialog('destroy');

     		},
     		onMinimize: function(){
				var menuBars = $("#box").find("div");
				var menuBarsLen = menuBars.length;

				for(var i=0;i<menuBarsLen;i++){
					var menuBar = menuBars[i];
					//alert(menuBar.id);
					if(menuBar.id == this.id + "_"){
						return;
					}
				}

				var leftPix = (menuBarsLen) * 70;
				//alert(menuBars.length);
				//return;
				//var ddd = $("<div style='position:fixed;bottom:0px;left:600px;height: 100px; width: 110px'></div>"); 
				//var ddd = $("<div style='position:fixed;bottom:0px;left:600px;height: 100px; width: 110px;cursor:hand'></div>"); 
				var ddd = $("<div style='position:fixed;bottom:0px;left:600px;height: 60px; width: 70px;cursor:pointer'><img src='" + opts.icon
					+ "'/></div>"); 
				ddd.attr('id',opts.id + "_");
				ddd.attr('title',opts.title);
				//ddd.text(opts.title);
				ddd.bind('click', function(e){
					//alert(win.html());
					//if(opened){
					//	win.window('close');
					//}else{
						win.window('open');
					//}
					

					//this.toggle();
				});
				$("#box").append(ddd);
				var t = 600 - leftPix;
     			ddd.show().animate({opacity: "0.6", left: "-=" + t + ""}, 800) ;
     		}
 		};
 		
 		var options = $.extend({}, defaults, opts);
 		
 		var _doc, _top = (function(w){
 			try{
 				_doc = w['top'].document;
 				_doc.getElementsByTagName;
 			}catch(e){
 				_doc = w.document; 
 				return w;
 			}
 			
 			if(options.self || _doc.getElementsByTagName('frameset').length >0){
 				_doc = w.document; 
 				return w;
 			}
 			
 			return w['top'];
 		})(window);
 		
 		
 		var winId;
 		if(options.id){
 			winId = options.id;
 			delete options.id;
 			
 			if($('#'+winId + "_").length>0){
				setTimeout(function(){ $('#'+winId + "_").fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100); },200); 
				//$('#'+winId).window('open');
				//$('#'+winId).animate({top:'40px'});;
				//alert(_top.$('<div>', {id: winId}));
 				return;
 			}

			var menuBars = $("#box").find("div");
			var menuBarsLen = menuBars.length;	
			if(menuBarsLen >= 4){
				return;
			}

 		} 		
 		var isUrl = /^url:/.test(options.content);
 		if(isUrl){
 			var localObj = window.location;
			var contextPath = localObj.pathname.split("/")[1];
 			var url = options.content.substr(4, options.content.length);
 			if(options.isFrame){  
 				var iframe = $('<iframe></iframe>')   //定义变量，作用于整个函数的作用域
 				            .attr('height', '99%')
 				            .attr('width', '100%')
 				            .attr('marginheight', '0')
 				            .attr('marginwidth', '0')
 				            .attr('frameborder','0');
 				
 				setTimeout(function(){
 					iframe.attr('src', url);
 				}, 1);
 				
 				
 				var _this = this;
 				var frameOnLoad = function(){
 					
 					_this.content = iframe.get(0).contentWindow;
 					
 					/////  谷歌浏览器的窗口问题，href的处理方式不一样  xuhong add 2013-10-28
 					var iframeWindow = iframe.get(0).contentWindow;
 					if(iframeWindow && iframeWindow.$){
 						//修改a的href及退出加上事件
 						iframeWindow.$("a").each(function(){
 							var hrefAttr =  iframeWindow.$(this).attr('href');
 							if(hrefAttr == '#'){
 								$(this).removeAttr('href');
 							}
 							var aText = iframeWindow.$(this).text();
 							var aText = iframeWindow.$.trim(aText);
 						    if('退出' == aText){
 						    	$(this).bind('click',function(e){
 						    		$('#'+winId).panel('close');
 						    	});
 						    }
 						});
 						var bindKeyDownEvent = false;
 						//按esc自动关闭当前打开的div
 						iframeWindow.$('.easyui-window').each(function(){
 							if(iframeWindow.$(this).attr('data-close') == 'autoclose'){
 								iframeWindow.$(this).window({
	 								onOpen:function(){
	 								   iframeWindow.openDiv = this.id;
	 								},
	 								onClose:function(){
	 								   iframeWindow.openDiv = null;
	 								}
 							   });
 							   bindKeyDownEvent = true;
 							}
 						});
 						if(bindKeyDownEvent){
 							
 							iframeWindow.$(iframeWindow.document.body).bind('keydown',function(e){
                                    //在谷歌浏览器中不会有问题，在IE下有问题
 									if(iframeWindow.openDiv && e.target == iframeWindow.document.body &&  e.keyCode == 27){
 										iframeWindow.$('#'+iframeWindow.openDiv).window('close');
 										iframeWindow.openDiv = null;
 									}
 						    });
 						}
 					}
 					///////////////////////////////////////////////////////////////
 					options.onLoad && options.onLoad.call(_this, {
 						data: options.data,
 						close: function(){
 							win.dialog('close');
 						}
 					});
 				}
 				
 				delete options.content;
 			}else{
 				options.href = url;
 			}
 		}
 		
 		var warpHandler = function(handler){
 			var args = {data: options.data, close: function(){win.dialog('close')}};
 			if(typeof handler =='function'){
 				return function(){
 					handler(args);
 				}
 			}
 			
 			if(typeof handler == 'string' && options.isFrame){
 				return function(){
 					iframe.get(0).contentWindow[handler](args);
 				}
 			}
 		}
 		
 		if(options.toolbar && $.isArray(options.toolbar)){
 			for(var i in options.toolbar){
 				options.toolbar[i].handler = warpHandler(options.toolbar[i].handler);
 			}
 		}
 		
 		if(options.buttons && $.isArray(options.buttons)){
 			for(var i in options.buttons){
 				options.buttons[i].handler = warpHandler(options.buttons[i].handler);
 			}
 		}
 		/*
 		console.log('---------------------------------------');
 		for(var p in options){
 			console.log(p+':'+options[p]);
 		}
 		console.log('----------------------------------------------');
 		*/

 		if(options.isFrame && iframe){
 			iframe.bind('load', frameOnLoad);
 			win = _top.$('<div>', {id: winId}).append(iframe).dialog(options);
 		}else{
 			win = _top.$('<div>', {id: winId}).dialog(options);
 		}
 		
 	}


}

function switchModule(this_id,p_id){
	$("#" + this_id + "").panel('minimize');
	$("#" + p_id + "").window('open');
}

function miniModuleWindow(this_id){
	$("#" + this_id + "").panel('minimize');
}

function closeModuleWindow(this_id){
	$("#" + this_id + "").panel('close');
}

