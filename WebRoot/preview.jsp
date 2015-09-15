<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String url = request.getParameter("url") == null ? ""
			: request.getParameter("url");
String filename = request.getParameter("filename") == null ? ""
			: request.getParameter("filename");
		filename=new String(filename.getBytes(
							"iso-8859-1"), "utf-8");	
String ftp_path = request.getParameter("ftp_path") == null ? ""
			: request.getParameter("ftp_path");
			System.out.println("*******************url**********"+filename);
String type =  request.getParameter("type") == null ? ""
			: request.getParameter("type");
 %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tabs Tools - jQuery EasyUI Demo</title>
    <link rel="stylesheet" type="text/css" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" type="text/css" href="/themes/icon.css">
    <script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/pdfobject.js"></script>
</head>
<body>
<div id="fancybox-content" align = "center" style="border-width: 10px; width: auto; height: auto;">

</div>
  <script type="text/javascript">
      window.onload = function (){
      		var url = "/<%=url%>?getfile=<%=filename%>&ftp_path=<%=ftp_path%>";
      		if('<%=type%>' == 'pdf'){
      		//alert(url+"/UploadServletUtil?getfile=doc.pdf&ftp_path=11/2014-03/1B23");
             var success = new PDFObject({ url: url }).embed();
             }
             else{
             	createIMG(url);
             }
      };
      function createIMG(url){
 	 		var img = new Image();
 			img.src = url;
  			$("#fancybox-content").append(img);
      }
      
    </script>
</body>
</html>