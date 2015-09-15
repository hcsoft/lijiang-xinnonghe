    $(function(){
      $('.flexslider').flexslider({
        animation: "slide",
        animationLoop: false,
        itemWidth: 420,
		minItems: 3,
		maxItems: 3
      });
	
	});
		   
		   $(function() {
				var window_w 					= $(window).width();
				var window_h 					= $(window).height();
				var $pc_panel = $('#pc_panel');
				var $pc_wrapper					= $('#pc_wrapper');
				var $pc_content					= $('#pc_content');
				var $pc_slider					= $('#pc_slider');
				var $pc_reference 				= $('#pc_reference');
				
				var maxWidth,maxHeight,marginL;
				
				buildPanel();
				
				function buildPanel(){
					$pc_panel.css({'height': window_h + 'px'});
					hidePanel();
					try{
						$pc_slider.slider('destroy');
					}catch(e){}


				}


				function hidePanel(){
					$pc_panel.css({
						'right'	: -window_w + 'px',
						'top'	: '350px'
					}).show();
					try{
						slideTop();
					}catch(e){}
					$pc_slider.hide();
					$pc_panel.find('.collapse')
					.addClass('expand')
					.removeClass('collapse');
				}
				
				function slideTop(){
					var total_scroll = $pc_content.height()-maxHeight;
					$pc_wrapper.scrollTop(0);
				}
				
				$("#zzz").bind('click',function(){

							$pc_panel.stop().animate({'right':'0px'},1000);

							//buildPanel();

				});

				$pc_panel.find('.expand').bind('click',function(){
					var $this = $(this);
					$pc_wrapper.hide();
					$pc_panel.stop().animate({'top':'0px'},500,function(){
						$pc_wrapper.show();
						slideTop();
						$pc_slider.show();
						$this.addClass('collapse').removeClass('expand');
					});
				})

				$pc_panel.find('.collapse').live('click',function(){
					var $this = $(this);
					$pc_wrapper.hide();
					$pc_slider.hide();
					$pc_panel.stop().animate({'top':'350px'},500,function(){
						$pc_wrapper.show();
						$this.addClass('expand').removeClass('collapse');
					});
				});
			
				$pc_panel.find('.close').bind('click',function(){
					//$pc_panel.remove();
					//$(window).unbind('scroll').unbind('resize');
					//$pc_panel.stop().animate({'left':'500px'},1000);
					hidePanel();
				});

                $pc_wrapper.find('.pc_item').hover(
						function(){
							$(this).addClass('selected');
						},
						function(){
							$(this).removeClass('selected');
						}
					).bind('click',function(){
					//window.open($(this).find('.pc_more').html());
				});			

                $pc_wrapper.find('.pc_item1').hover(
						function(){
							$(this).addClass('selected');
						},
						function(){
							$(this).removeClass('selected');
						}
					).bind('click',function(){
					//window.open($(this).find('.pc_more').html());
				});

                $pc_wrapper.find('.pc_item2').hover(
						function(){
							$(this).addClass('selected');
						},
						function(){
							$(this).removeClass('selected');
						}
					).bind('click',function(){
					//window.open($(this).find('.pc_more').html());
				});


                $pc_wrapper.find('.pc_item3').hover(
						function(){
							$(this).addClass('selected');
						},
						function(){
							$(this).removeClass('selected');
						}
					).bind('click',function(){
					//window.open($(this).find('.pc_more').html());
				});


			});