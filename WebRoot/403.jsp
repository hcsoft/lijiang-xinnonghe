<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="utf-8">


    <link href="/css/modern.css" rel="stylesheet">
    <link href="/css/modern-responsive.css" rel="stylesheet">

    <script src="/js/jquery-1.8.2.min.js"></script>
    <script src="/js/tile-slider.js"></script>


    
    <title>禁止访问</title>

    <style>
        body {
            background: #1d1d1d;
        }
    </style>

    <script>

        function Resize(){
            var tiles_area = 0;
            $(".tile-group").each(function(){
                tiles_area += $(this).outerWidth() + 60;

            });

            $(".tiles").css("width", 0 + tiles_area + 20);

            $(".page").css({
                height: $(document).height() - 120,
                width: $(document).width()
            });
        }

        function AddMouseWheel(){
            $("body").mousewheel(function(event, delta){
                var scroll_value = delta * 50;
                if (jQuery.browser.webkit) {
                    this.scrollLeft -= scroll_value;

                } else {
                    document.documentElement.scrollLeft -= scroll_value;
                }
                return false;
            });
        }

        $(function(){
		
            Resize();

        })
    </script>
</head>
<body class="modern-ui" onresize="Resize()">




<div class="page secondary fixed-header">


    <div class="page-region">
        <div class="page-region-content tiles" style="padding-left: 100px;padding-top: 50px;">
            <div class="tile-group">


                <div class="tile double bg-color-blueDark">
                    <div class="tile-content">
                        <img src="/images/403.png" class="place-left"/>
                        <h3 style="margin-bottom: 5px;">禁止访问</h3>
                        <p>
                            不好意思，你没有权限访问此页面，请与系统管理员联系.
                        </p>
                        <h5>jnds@xxxxxxxx.com</h5>

                    </div>
                    <div class="brand">
                        <span class="name">tel:12345678901</span>
                    </div>
                </div>



            </div>








        </div>
    </div>
</div>

</body>
</html>