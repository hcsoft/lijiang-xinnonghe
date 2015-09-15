

var ui = {
    splash_screen_zindex: 65000,
    settings_splash_color: 'bg-color-purple',
    settings_splash_icon: 'images/update.png',

    settings_page: "ttt.html",
	funcings_page: "ttt2.html",

    launchApp: function (id, title, url, loaded) {

        ui.currentApp = url;

        var iframe = $('<iframe id="' + ui.app_iframe_id + '" frameborder="no" />')
           .css({
               'position': 'absolute',
               'left': "0",
               'top': "0px",
               'width': '100%',
               'height': '100%',
               'z-index': ui.app_iframe_zindex,
               'visibility': 'hidden',
               'background-color': 'white'
           })
           .appendTo(document.body)
           .attr({ 'src': url })
           .load(function () {
               //ui.hideNavBar();
               loaded();
               $(this).css('visibility', 'visible');
           });


        location.hash = id;
    },



    splashScreen: function (colorClass, icon, complete) {
      //  ui.hideAllIframes();

        return $("<div/>")
            .addClass(colorClass)
            .css({
                'position': 'absolute',
                'left': -($(window).width() / 4) + 'px',
                'top': $(window).height() / 4,
                'width': $(window).width() / 4 + 'px',
                'height': $(window).height() / 4 + 'px',
                'z-index': ui.splash_screen_zindex,
                'opacity': 0.3
            })
            .appendTo(document.body)
            .animate({
                left: '50px',
                top: '50px',
                'width': $(window).width() - 100 + 'px',
                'height': $(window).height() - 100 + 'px',
                'opacity': 1.0
            }, 500, function () {
                $(this).animate({
                    left: '0px',
                    top: '0px',
                    width: '100%',
                    height: '100%'
                }, 500, function () {
                    complete($(this));
                   // ui.restoreAllIframes();
                });
            })
            .append(
                $('<img />')
                    .attr('src', icon)
                    .addClass(ui.splash_screen_icon_class)
                    .css({
                        'position': 'absolute',
                        'left': ($(window).width() - 512) / 2,
                        'top': ($(window).height() - 512) / 2
                    })
            );
    },



    settings: function (pageUrl) {
            ui.splashScreen(ui.settings_splash_color, ui.settings_splash_icon, function (div) {
                ui.launchApp("Settings", "Settings", pageUrl, function () {
                    div.fadeOut();
                });
            });

    },

    funcings: function (pageUrl) {
            ui.splashScreen(ui.settings_splash_color, ui.settings_splash_icon, function (div) {
                ui.launchApp("funcings", "funcings", pageUrl, function () {
                    div.fadeOut();
                });
            });

    }
};



