
	var uploadModal = {
		container: null,
		init: function (eventId,businessCode,businessNumber) {
			$("#" + eventId).click(function (e) {
			//	e.preventDefault();	
				var frame = "<iframe width='1000px' height='550px' src='/upload.jsp?businessCode=" + businessCode + "&businessNumber=" + businessNumber + "' frameborder='no' border='0' marginwidth='0' marginheight='0' scrolling='yes' allowtransparency='yes'></iframe>";
				
				var option = {
					zIndex: 10000,
					overlayId: 'upload-overlay',
					containerId: 'upload-container',
					closeHTML: "<div style='display:block;position: absolute;top: 0px;right: 0px;width: 30px;height: 30px;cursor: pointer;z-index: 1103;'><img src='/images/fancy_close.png'/></div>",
					minHeight: 80,
					minWidth: "1000px",
					opacity: 65, 
					position: ["4%",],
					escClose: true,
					overlayClose: true,
					//onOpen: uploadModal.open,
					onClose: uploadModal.close
				};
				$.modal(frame,option);
			});
		},
		open: function (d) {
			var self = this;
			self.container = d.container[0];
			$("#simplemodal-data").css('display','block');
			d.overlay.fadeIn('slow');
			d.container.slideDown(1000);
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
