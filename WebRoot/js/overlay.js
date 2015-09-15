
jQuery(function ($) {
	var OVERLAY = {
		container: null,
		init: function () {
			$("#loginId1").click(function (e) {
				if(document.getElementById('random_img') != null){
					changeimg(document.getElementById('random_img'));
				}
				e.preventDefault();	
				
				$("#overlay-modal-content").modal({
					overlayId: 'overlay-overlay',
					containerId: 'overlay-container',
					closeHTML: null,
					minHeight: 80,
					opacity: 65, 
					position: ["8%",],
					overlayClose: true,
					onOpen: OVERLAY.open,
					onClose: OVERLAY.close
				});
			});
		},
		open: function (d) {
			var self = this;
			self.container = d.container[0];
			d.overlay.fadeIn('slow', function () {
				$("#overlay-modal-content", self.container).show();
				var title = $("#overlay-modal-title", self.container);
				title.show();
				d.container.slideDown('slow', function () {
					setTimeout(function () {
						var h = $("#overlay-modal-data", self.container).height()
							+ title.height()
							+ 20; 
						d.container.animate(
							{height: h}, 
							200,
							function () {
								$("div.close", self.container).show();
								$("#overlay-modal-data", self.container).show();
							}
						);
					}, 300);
				});
			})
		},
		close: function (d) {
			var self = this; 
			d.container.animate(
				{top:"-" + (d.container.height() + 20)},
				500,
				function () {
					self.close(); // 
				}
			);
		}
	};

	OVERLAY.init();

});