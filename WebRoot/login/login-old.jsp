<%@ page contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <%@ include file="/common/inc.jsp" %>
        <html xmlns="http://www.w3.org/1999/html">
            
            <head>
                <link href="<%=request.getContextPath()%>/css/modern.css" rel="stylesheet">
                <link href="<%=request.getContextPath()%>/css/modern-responsive.css" rel="stylesheet">
                <link href="<%=request.getContextPath()%>/css/droptiles.css" rel="stylesheet">
                <link href="<%=request.getContextPath()%>/css/login.css" rel="stylesheet" />
                <!--[if lt IE 8]>
                    <link rel="stylesheet" type="text./css" href="css/ie.css" />
                <![endif]-->
                <script src="<%=request.getContextPath()%>/js/jquery-1.8.2.min.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/jquery.easing.1.3.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/overlay.js">
                </script>
                <title>
                    以地控税、以税节地管理系统
                </title>
                <style>
                    body { background-image:url(<%=request.getContextPath()%>/images/77334-1585047735-8.jpg) }
                </style>
                <script>
                    function changeimg(imgidobj) {
                        imgidobj.removeAttribute("src");
                        imgidobj.setAttribute("src", "<%=request.getContextPath()%>/login/random.jsp?times=" + new Date().getTime());
                    }
                    function Resize() {
                        var tiles_area = 0;
                        $(".tile-group").each(function() {
                            tiles_area += $(this).outerWidth() + 60;

                        });

                        $(".tiles").css("width", 0 + tiles_area + 20);

                        $(".page").css({
                            height: $(document).height() - 120,
                            width: $(document).width()
                        });
                    }

                    $(function() {

                        $('#loginId1').animate({
                            opacity: "0.3",
                            left: "-=700"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);
                        $('#login1_subId').animate({
                            opacity: "0.3",
                            left: "-=700"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);

                        $('#loginId2').animate({
                            opacity: "0.3",
                            top: "-=400"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);
                        $('#login2_subId').animate({
                            opacity: "0.3",
                            top: "-=400"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);

                        $('#loginId3').animate({
                            opacity: "0.3",
                            left: "-=400"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);
                        $('#login3_subId').animate({
                            opacity: "0.3",
                            left: "-=400"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);

                        $('#loginId4').animate({
                            opacity: "0.3",
                            right: "-=500"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);
                        $('#login4_subId').animate({
                            opacity: "0.3",
                            right: "-=500"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);

                        $('#loginId5').animate({
                            opacity: "0.3",
                            bottom: "-=500"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);
                        $('#login5_subId').animate({
                            opacity: "0.3",
                            bottom: "-=500"
                        },
                        1700).animate({
                            opacity: "1",
                            left: "=0"
                        },
                        800);

                        Resize();

                        $('#hahaId').click(function() {

                            $('#subDivId').empty();
                            $('#subDivId').html("<div class='tile bg-color-blue icon'><div class='tile-content'><img src='<%=request.getContextPath()%>/images/InternetExplorer128.png'/></div><div class='brand'><span class='name'>Internet Explorer</span></div></div>");

                            //location = "http://www.163.com";
                        });

                        $('#hahaId2').click(function() {

                            $('#subDivId').empty();
                            $('#subDivId').html("<div class='tile icon' onclick='ui.funcings()'><div class='tile-content'><img src='<%=request.getContextPath()%>/images/onenote2013icon.png'/></div><div class='brand'><span class='name'>OneNote 2013</span></div></div>");

                            //location = "http://www.163.com";
                        });
                        //$("#hahaId").click( function() {
                        //	alert("haha");
                        //  });
                    })
                </script>
            </head>
            
            <body class="modern-ui" onresize="Resize()">
                <!-- 登录窗口的模态框 -->
                <div id="overlay-modal-content">
                    <!--<div id="overlay-modal-title"></div>-->
                    <div class="close">
                        <a href="#" class="simplemodal-close">
                            x
                        </a>
                    </div>
                    <div id="overlay-modal-data">
                        <form name="login-form" class="login-form" action="<%=request.getContextPath()%>/j_spring_security_check"
                        method="post">
                            <div class="header">
                                <h1>
                                </h1>
                                <span>
                                    <img src="<%=request.getContextPath()%>/images/109.png">
                                </span>
                            </div>
                            <div class="content">
                                <label class="label">
                                    用户名：
                                </label>
                                <input name="j_username" type="text" class="input username" value='5301240001001
'
                                />
                                </br>
                                <label class="label">
                                    密&nbsp;&nbsp;&nbsp;&nbsp;码：
                                </label>
                                <input name="j_password" type="password" class="input password" value='123'
                                />
                                </br>
                                <label class="label">
                                    校验码：
                                </label>
                                <input name="random" type="random" class="input username" />
                            </div>
                            <div class="footer">
                                <img id="random_img" src="/login/random.jsp" style="padding:5px;" onclick="changeimg(this)">
                                <input type="submit" class="button" value="登录" />
                            </div>
                        </form>
                    </div>
                </div>
                <div class="page secondary fixed-header">
                    <div class="page-region">
                        <div class="page-region-content tiles">
                            <div class="tile-group" style="width: 1022px;margin-left: 50px;">
                                <div class="tile bg-color-orange" id="loginId1" style="left:700px">
                                    <div class="tile-content">
                                        <img src="<%=request.getContextPath()%>/images/MB_0007_Bing.png">
                                    </div>
                                    <div class="brand">
                                        <div class="name">
                                            <font size="3px">
                                                以地控税、以税节地管理系统
                                            </font>
                                        </div>
                                    </div>
                                </div>
                                <div class="tile double bg-color-orange" id="login1_subId" data-role="tile-slider"
                                data-param-period="13000" style="outline:0px;left:700px">
                                    <div class="tile-content">
                                        <h3 style="margin-bottom: 5px;">
                                            新增地籍信息
                                        </h3>
                                        <p>
                                            晋(税)2001区块新增....
                                        </p>
                                        <p>
                                            晋(税)2003区块变更....
                                        </p>
                                        <p>
                                            晋(税)2003区块开发....
                                        </p>
                                        <p>
                                            晋(税)2001区块新增....
                                        </p>
                                        <br/>
                                        <p align="right">
                                            更多>>
                                        </p>
                                    </div>
                                </div>
                                <div class="tile bg-color-blueDark" id="loginId2" style="top:400px">
                                    <div class="tile-content">
                                        <img src="<%=request.getContextPath()%>/images/MB_0009_loading.png">
                                    </div>
                                    <div class="brand">
                                        <div class="name">
                                            <font size="3px">
                                                工作成果管理
                                            </font>
                                        </div>
                                    </div>
                                </div>
                                <div class="tile double bg-color-blueDark" id="login2_subId" data-role="tile-slider"
                                data-param-period="8000" style="outline:0px;top:400px">
                                    <div class="tile-content">
                                        <h3 style="margin-bottom: 5px;">
                                            最新工作成果
                                        </h3>
                                        <p>
                                            晋宁地税一分局开展xxx活动
                                        </p>
                                        <p>
                                            晋宁市获得2012年xxx奖项
                                        </p>
                                        <p>
                                            晋宁地税计会科开展xxx活动
                                        </p>
                                        <p>
                                            晋宁地税规费科开展xxx活动
                                        </p>
                                        <br/>
                                        <p align="right">
                                            更多>>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </body>
        
        </html>
