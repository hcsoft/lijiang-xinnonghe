<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    
    <title>timeOut</title>
    
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<style type="text/css">
div{
margin:0px auto;
color:red;
}
</style>
  </head>
  
  <body>
    <div>对不起！会话超时！</div><a href="<%=request.getContextPath()%>/login/login.jsp">登录页面</a><span style="margin: 0px 20px;"></span><a href="<%=request.getContextPath()%>/j_spring_security_logout">退出系统</a>
  </body>
</html>
