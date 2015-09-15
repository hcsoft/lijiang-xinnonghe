<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>

    <link href="/css/modern.css" rel="stylesheet">
    <link href="/css/modern-responsive.css" rel="stylesheet">
    <link href="/css/droptiles.css" rel="stylesheet">
	<link href="/css/login.css" rel="stylesheet"/>

	<!--[if lt IE 8]>
		<link rel="stylesheet" type="text/css" href="css/ie.css"/>
	<![endif]-->
    <script src="/js/jquery-1.8.2.min.js"></script>
    <script src="/js/jquery.mousewheel.min.js"></script>
	<script src="/js/dropdown.js"></script>
    <script src="/js/Combined.js"></script>
    <script src="/js/tile-slider.js"></script>
	<script src="/js/jquery.easing.1.3.js"></script>

    
    <title>多系统入口界面</title>

    <style>
        body {
            background-image:url(/images/77334-1585047735-8.jpg)  
        }
    </style>

    <script>
function changeimg(imgidobj) {
	imgidobj.removeAttribute("src");
	imgidobj.setAttribute("src","/login/random.jsp?times="+new Date().getTime());
}
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

$('#loginId1').animate({opacity: "0.3", left: "-=700"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;
$('#login1_subId').animate({opacity: "0.3", left: "-=700"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;

$('#loginId2').animate({opacity: "0.3", top: "-=400"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;
$('#login2_subId').animate({opacity: "0.3", top: "-=400"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;

$('#loginId3').animate({opacity: "0.3", left: "-=400"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;
$('#login3_subId').animate({opacity: "0.3", left: "-=400"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;

$('#loginId4').animate({opacity: "0.3", right: "-=500"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;
$('#login4_subId').animate({opacity: "0.3", right: "-=500"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;

$('#loginId5').animate({opacity: "0.3", bottom: "-=500"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;
$('#login5_subId').animate({opacity: "0.3", bottom: "-=500"}, 1700).animate({opacity: "1", left: "=0"}, 800) ;

			$('#loginId1').click(function(){	
			  if ($(".drop").is(':hidden')) {
				$(".drop").slideDown().animate({height:'250px'},{queue:false, duration:600, easing: 'easeOutBounce'}),
				$('#link').removeClass('signin').addClass('signinclick');
			  }
			  else {
				$('.drop').slideUp(),
				$('#link').removeClass('signinclick').addClass('signin');
			  }
			  return false;
			});
		
            Resize();

$('#hahaId').click(function(){
			
		$('#subDivId').empty();
		$('#subDivId').html("<div class='tile bg-color-blue icon'><div class='tile-content'><img src='/images/InternetExplorer128.png'/></div><div class='brand'><span class='name'>Internet Explorer</span></div></div>");	  

			  //location = "http://www.163.com";
 });

$('#hahaId2').click(function(){
			
		$('#subDivId').empty();
		$('#subDivId').html("<div class='tile icon' onclick='ui.funcings()'><div class='tile-content'><img src='/images/onenote2013icon.png'/></div><div class='brand'><span class='name'>OneNote 2013</span></div></div>");	  
	  
			  //location = "http://www.163.com";
 });
		  //$("#hahaId").click( function() {
		//	alert("haha");
		//  });
        })
       
    </script>
</head>
<body class="modern-ui" onresize="Resize()">


    
    <div id="login"> 
        <form class="drop" action="/springSecurity/j_spring_security_check" method="post">
            <label for="name">用户名:</label>
            <input type="text" name="j_username" class="required"/></br>
            <label for="password">密  码:</label>
            <input type="password" name="j_password" /></br>
            <label for="password">校验码:</label>
            <input type="random" name="random" />
            <img src="/login/random.jsp" style="padding:15px;" onclick="changeimg(this)"><input type="submit" class="submit" value="登录"/>
        </form>
    </div> 


<div class="page secondary fixed-header">


    <div class="page-region">
        <div class="page-region-content tiles">
            <div class="tile-group" style="width: 1022px;margin-left: 50px;">


                <div class="tile bg-color-orange" id="loginId1" style="left:700px">
                    <div class="tile-content">
                        <img src="/images/MB_0007_Bing.png">
                    </div>
                    <div class="brand">
                        <div class="name"><font size="3px">土地管税系统</font></div>
                    </div>                   
                </div>
                <div class="tile double bg-color-orange" id="login1_subId" data-role="tile-slider" data-param-period="13000" style="outline:0px;left:700px">
                    <div class="tile-content">
                        <h3 style="margin-bottom: 5px;">新增地籍信息</h3>
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
                    <div class="brand">
                        <span class="name"></span>
                    </div>
                    
                     <div class="tile-content">
                        <p>
                            晋(税)2003区块变更....
                        </p>
                        <p>
                            晋(税)2003区块开发....
                        </p>
                        <p>
                            晋(税)2003区块变更....
                        </p>
                        <p>
                            晋(税)2003区块开发....
                        </p>
						<br/>
						<br/>
						<br/>
                        <p align="right">
                            更多>>
                        </p>
                    </div>                      
                    
                </div>

            




                <div class="tile bg-color-blueDark" id="loginId2" style="top:400px">
                    <div class="tile-content">
                        <img src="/images/MB_0009_loading.png">
                    </div>
                    <div class="brand">
                        <div class="name"><font size="3px">工作成果管理</font></div>
                    </div>                   
                </div>               
                <div class="tile double bg-color-blueDark"  id="login2_subId" data-role="tile-slider" data-param-period="8000" style="outline:0px;top:400px">
                    <div class="tile-content">
                        <h3 style="margin-bottom: 5px;">最新工作成果</h3>
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
                    <div class="brand">
                        <span class="name"></span>
                    </div>
                    
                     <div class="tile-content">
                        <h3 style="margin-bottom: 5px;">最新工作成果</h3>
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


                <div class="tile bg-color-green" id="loginId3" style="left:400px">
                    <div class="tile-content">
                        <img src="/images/MB_0002_office.png">
                    </div>
                    <div class="brand">
                        <div class="name"><font size="3px">重要通知公告</font></div>
                    </div>                   
                </div>   
                <div class="tile double bg-color-green" id="login3_subId" data-role="tile-slider" data-param-period="17000" style="outline:0px;left:400px">
                    <div class="tile-content">
                        <h3 style="margin-bottom: 5px;">最新公告</h3>
                        <p>
                            晋宁磷化集团2013年房产税欠税公告
                        </p>
                        <p>
                            ...........
                        </p>

						</br>
                        <p align="right">
                            更多>>
                        </p>
                    </div>
                    <div class="brand">
                        <span class="name"></span>
                    </div>
                    
                     <div class="tile-content">
                        <p>
                            晋宁地税xxx系统升级改造
                        </p>
                        <p>
                            晋宁地税土地管税于2013-06-30开始试运行
                        </p>                    
						</br>
						</br>
						</br>
                        <p align="right">
                            更多>>
                        </p>
                    </div>                      
                    
                </div>



                <div class="tile bg-color-pink" id="loginId4" style="right:500px">
                    <div class="tile-content">
                        <img src="/images/MB_0013_APP-info.png">
                    </div>
                    <div class="brand">
                        <div class="name"><font size="3px">MIS2.0系统</font></div>
                    </div>                   
                </div>   
                <div class="tile double bg-color-pink" id="login4_subId" data-role="tile-slider" data-param-period="20000" style="right:500px">
                    <div class="tile-content">
                        <h3 style="margin-bottom: 5px;">纳税人公告</h3>
                        <p>
                            晋宁县磷化集团职工医院已缴房产税xxx
                        </p>
                        <p>
                            纳税人530100001003减免税申请提交
                        </p>
                        <p>
                            纳税人530100001125补缴税款.......
                        </p>
                        <p>
                            ...............
                        </p>

						</br>
                        <p align="right">
                            更多>>
                        </p>
                    </div>
                    <div class="brand">
                        <span class="name"></span>
                    </div>
                    
                     <div class="tile-content">
                        <p>
                            晋宁县磷化集团职工医院已缴房产税xxx
                        </p>
                        <p>
                            纳税人530100001003减免税申请提交
                        </p>
                        <p>
                            纳税人530100001125补缴税款.......
                        </p>
                        <p>
                            ...............
                        </p>

						</br>
                        <p align="right">
                            更多>>
                        </p>
                    </div>                      
                    
                </div>

                <div class="tile bg-color-purple" id="loginId5" style="bottom:500px">
                    <div class="tile-content">
                        <img src="/images/MB_0003_Computer.png">
                    </div>
                    <div class="brand">
                        <div class="name"><font size="3px">晋宁税务资讯</font></div>
                    </div>                   
                </div>   
                <div class="tile double bg-color-purple" id="login5_subId" data-role="tile-slider" data-param-period="12000" style="bottom:500px">
                    <div class="tile-content">
                        <h3 style="margin-bottom: 5px;">税务资讯</h3>
                        <p>
                            晋宁一季度经济工作基本实现开门红 
                        </p>
                        <p>
                            北京中天行房车基地有望落户晋宁
                        </p>
                        <p>
                            云磷集团“835”项目建设进入收尾阶段 
                        </p>
                        <p>
                            国际陆港已有项目试运营 
                        </p>
                        <br/>
						<p align="right">
                            更多>>
                        </p>
                    </div>
                    <div class="brand">
                        <span class="name"></span>
                    </div>
                    
                     <div class="tile-content">
                        <p>
                            晋宁工业园区污水截流步入正轨 
                        </p>
                        <p>
                            五个基地地形图测绘通过验收
                        </p>
                        <p>
                            云磷集团“835”项目建设进入收尾阶段 
                        </p>
                        <p>
                            晋宁东南亚国际陆港今年力推公铁联运
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