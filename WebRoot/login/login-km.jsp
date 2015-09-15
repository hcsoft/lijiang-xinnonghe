<%@ page contentType="text/html; charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>医疗机构档案管理系统</title>
<script type="text/javascript" src="<%=request.getContextPath()%>/login-js/jquery.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/login-js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/login-js/jquery.tscookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/login-js/jquery.validation.min.js"></script>
<link href="<%=request.getContextPath()%>/login-css/login.css" rel="stylesheet" type="text/css">
<style type="text/css">
body {
	background-color: #666666;
	background-image: url("");
	background-repeat: no-repeat;
	background-position: center top;
	background-attachment: fixed;
	background-clip: border-box;
	background-size: cover;
	background-origin: padding-box;
	width: 100%;
	padding: 0;
}
</style>
</head>
<body style="background-image: url(<%=request.getContextPath()%>/login/bg_1.jpg);">

<div class="bg-dot"></div>
<div class="login-layout">
  <div class="top">
    <h5>昆明市卫生局<em></em></h5>
    <h2>医疗机构档案管理系统</h2>
<!--    <h6>--><!--</h6>-->
  </div>
  <div class="box">
    <form method="post"  action="<%=request.getContextPath()%>/j_spring_security_check">
      <input type="hidden" name="formhash" value="InvdBdNrBmZyhFXEdQuQ8rVoewCbj2N">      <input type="hidden" name="form_submit" value="ok">
      <span>
      <label>帐号</label>
      <input name="j_username" id="j_username" autocomplete="off" type="text" class="input-text" >
      </span> <span>
      <label>密码</label>
      <input name="j_password" id="j_password" class="input-password" autocomplete="off" type="password"  >
      </span> <span>
      <div class="code">
        <div class="arrow"></div>
        <div class="code-img"><img src="/login/random.jsp" name="codeimage" id="random_img" border="0"/></div>
        <a href="JavaScript:void(0);" id="hide" class="close" title="关闭"><i></i></a>
        <a href="JavaScript:void(0);"  id="refreash" class="change" title="刷新"><i></i></a>
         </div>
      <input name="captcha" type="text" required="" class="input-code" id="captcha" placeholder="输入验证" pattern="[A-z0-9]{4}" title="验证码为4个字符" autocomplete="off" value="">
      </span><span>
      <input name="" class="input-button" type="submit" value="登录">
      </span>
      
    </form>
    <div style="float:left;line-height: 25px;"><h6>系统需要使用谷歌浏览器运行</h6></div>
      
      <div style="background: url(/images/gg.gif) 0 5px no-repeat;
  padding-left: 20px;
  float: left;
  font-size: 12px;
  line-height: 25px;
  padding-right: 245px;
  margin-left: 20px;">
	<a href="/download/chrome_installer_552.210.exe">谷歌浏览器下载</a>
	</div>
  </div>
</div>
<div class="bottom">
  <h6> © 恒辰科技有限公司版权所有</h6>
</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
    //Random background image
    var random_bg=Math.floor(Math.random()*4+1);
    var bg='url(/login/bg_'+random_bg+'.jpg)';
    $("body").css("background-image",bg);
    //Hide Show verification code
    $("#hide").click(function(){
        $(".code").fadeOut("slow");
    });
    $("#captcha").focus(function(){
        $(".code").fadeIn("fast");
    });
    //跳出框架在主窗口登录
   if(top.location!=this.location)	top.location=this.location;
    $('#user_name').focus();
    if ($.browser.msie && $.browser.version=="6.0"){
        window.location.href='http://localhost/xingkang/admin/templates/default/ie6update.html';
    }
    $("#captcha").nc_placeholder();
    
    $('#refreash').click(function() {
    	$('#random_img').attr("src", "<%=request.getContextPath()%>/login/random.jsp?times=" + new Date().getTime());
        
    });
});

</script>


<iframe id="TSLOGINI" style="display:none" src=""></iframe></body></html>