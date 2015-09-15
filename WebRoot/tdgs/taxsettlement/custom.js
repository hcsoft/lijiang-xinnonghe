function ready(){
	
	$(".checkBox").toggle(
		function(){
			$(this).css("background-position","bottom");
			$(this).attr("rel","checked");
		},
		function(){
			$(this).css("background-position","top");
			$(this).attr("rel","");
		}
	);
	
	
	var conInnerConWidth = $(".innerCon").width();
	var conSize = $(".innerCon").size();
	var tabHeight = $(".tab a").height();
	if(!window.cur) window.cur=0;
	
	$(".tab a").click(function(){
//		var index = $(".tab a").index(this);
//	    slide(conInnerConWidth, tabHeight, index);
		return false;
	});
	
	$(".prev").click(function(){
	   if(window.cur>0) slide(conInnerConWidth, tabHeight, window.cur-1);
		return false;
	});
	
	$(".next").click(function(){
	   if(window.cur<conSize-1) slide(conInnerConWidth, tabHeight, window.cur+1);
		return false;
	});
	
	$(".faq ul a").click(function(){
		var index = $(".faq ul a").index($(this));
		$('html, body').animate({scrollTop: $(".details h1").eq(index).offset().top-15}, 1500);
		return false;
	});
	
	
	$("a[href=#]").live('click', function(event){
		return false;
	});
	
	$(".top a").click(function(){
		$('html, body').animate({scrollTop:0}, 1500);
	});
	
	
	$(".signUp_hosted").click(function(){
		$("#overlay").show();
	});
	
	$("#closeBox").click(function(){
		$("#overlay").hide();
	});
	
	$(".feature_tour .tab, .feature_tour .nav").addClass("vv");
}

//////////////////////////////////////
function slide(conInnerConWidth, tabHeight, index){
	$(".tab a").removeClass("current");
	$(".tab a").eq(index).addClass("current");
	$(".tab").css("background-position","0 -"+index*tabHeight+"px");
	$(".maskCon").animate({marginLeft:-index*conInnerConWidth+"px"});
	window.cur = index;
}

