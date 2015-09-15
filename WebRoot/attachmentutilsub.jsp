<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
	String descr = request.getParameter("descr") == null ? "" : request
			.getParameter("descr");
	String attachmentcode = request.getParameter("attachmentcode") == null ? ""
			: request.getParameter("attachmentcode");
	String attachmentname = request.getParameter("attachmentname") == null ? ""
			: request.getParameter("attachmentname");
	attachmentname	=new String(attachmentname.getBytes(
						"ISO8859-1"), "utf-8");
	String businessnumber = request.getParameter("businessnumber") == null ? ""
			: request.getParameter("businessnumber");
	String businesscode = request.getParameter("businesscode") == null ? ""
			: request.getParameter("businesscode");
%>
<!DOCTYPE html>
<head>

	<link rel="stylesheet" type="text/css" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" type="text/css" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/bootstrap_pagination_change.css">
	<link rel="stylesheet" href="/css/bootstrap-responsive.min.css">
	<link rel="stylesheet" href="/css/jquery.fileupload-ui.css">
	<link rel="stylesheet" href="/css/jquery.fancybox-1.3.4.css" />

	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/jquery.ui.widget.js"></script>
	<script src="/js/tmpl.min.js"></script>
	<script src="/js/load-image.min.js"></script>
	<script src="/js/canvas-to-blob.min.js"></script>
	<script src="/js/bootstrap.min.js"></script>
	<script src="/js/jquery.iframe-transport.js"></script>
	<script src="/js/jquery.fileupload.js" charset="utf-8"></script>
	<script src="/js/jquery.fileupload-fp.js"></script>
	<script src="/js/jquery.fileupload-ui-init.js"></script>
	<script src="/js/locale.js"></script>
	<script src="/js/main.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/js/datecommon.js"></script>
	<script src="/js/jquery.fancybox-1.3.4.pack.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>

	<title>附件管理</title>

</head>
<body style="overflow: hidden">
	<div class="easyui-layout" style="width: 1200px; height: 620px;">
		<div id="tabs" class="easyui-layout" data-options="region:'center'"
			style="height: 440px; width: 930px">
			<div class="container" style="width: 648px;">
				<form id="fileupload" action="UploadServletUtil" method="POST"
					enctype="multipart/form-data">
					<div class="row fileupload-buttonbar">
						<b id='descr'><%=descr%></b>
						<div class="span7">
							<b>附件名称（大小限制：10M）：<input id="filename" type='text' name='filename'
									style="width: 400px">
							</b>
							<span class="btn btn-success fileinput-button"
								style="width: 80px"> <i class="icon-plus icon-white"></i>
								<span>选择附件</span> <input id='atta_upload' type="file"
									name="files[]"> </span>
						</div>
						<div class="span5 fileupload-progress fade">
							<div class="progress progress-success progress-striped active"
								role="progressbar" aria-valuemin="0" aria-valuemax="100">
								<div class="bar" style="width: 0%;"></div>
							</div>
							<div class="progress-extended">
								&nbsp;
							</div>
						</div>
					</div>
					<div class="fileupload-loading"></div>
					<br>
					<table role="presentation" class="table table-striped">
						<tbody id="fileListId" class="files" data-toggle="modal-gallery"
							data-target="#modal-gallery">
						</tbody>
					</table>
				</form>
			</div>

			<div id="modal-gallery" class="modal modal-gallery hide fade"
				data-filter=":odd">
				<div class="modal-header">
					<a class="close" data-dismiss="modal">&times;</a>
					<h3 class="modal-title"></h3>
				</div>
				<div class="modal-body">
					<div class="modal-image"></div>
				</div>
				<div class="modal-footer">
					<a class="btn btn-success modal-download"> <i
						class="icon-download icon-white"></i> <span>下&nbsp;&nbsp;载</span>
					</a>

					<a class="btn btn-info modal-prev"> <i
						class="icon-arrow-left icon-white"></i> <span>上一张</span> </a>
					<a class="btn btn-primary modal-next"> <i
						class="icon-arrow-right icon-white"></i> <span>下一张</span> </a>
				</div>
			</div>
			<script id="template-upload" type="text/x-tmpl">
            {% removeRow(); for (var i=0, file; file=o.files[i]; i++) {setFileName(file.name);%}
				<tr class="template-upload fade">
					<td class="preview"><span class="fade"></span></td>
					<td class="name"><span>{%=file.name%}</span></td>
					<td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
					{% if (file.error) { %}
					{% } else if (o.files.valid && !i) { %}
					<td>
						<div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar" style="width:0%;"></div></div>
					</td>
					<td class="start">{% if (!o.options.autoUpload) { %}
						<button class="btn btn-primary">
							<i class="icon-upload icon-white"></i>
							<span>开始</span>
						</button>
						{% } %}</td>
					{% } else { %}
					{% } %}
					<td class="cancel">{% if (!i) { %}
						<button class="btn btn-warning">
							<i class="icon-ban-circle icon-white"></i>
							<span>终止</span>
						</button>
						{% } %}</td>
				</tr>
				{% } %}
		</script>


			<script id="template-download" type="text/x-tmpl">
			{% for (var i=0, file; file=o.files[i]; i++) { %}
			<tr class="template-download fade">
				{% if (file.error) { %}
				<td class="name"><span>{%=file.name%}</span></td>
				<td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
				{% } else { %}
				<td class="preview">{% if (file.thumbnail_url) { var imgname = getImg(file.thumbnail_url); %} 
					<a href="{%=file.url%}" title="{%=file.name%}" rel="show_group"><img src="{%=imgname%}"></a>
					{% } %}</td>
				<td class="name">
					<a href="{%=file.url%}" title="{%=file.name%}" rel="{%=file.thumbnail_url&&'gallery'%}" download="{%=file.name%}">{%=file.name%}</a>
				</td>
				<td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
				{% } %}
				<td class="delete">
					<button class="btn btn-danger" data-type="{%=file.delete_type%}" data-url="{%=file.delete_url%}"{% if (file.delete_with_credentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %} >
						<i class="icon-trash icon-white"></i>
						<span>删除</span>
					</button>
				</td>
			</tr>
			{% } %}
		</script>



			<script type="text/javascript">
	$('#fileupload').bind('fileuploadcompleted', function (e, data) {
			opener.showAttachment('<%=attachmentcode%>','<%=businessnumber%>');
			closeme();
			//$('#attachmentgrid').datagrid('reload');
		});
		
		$('#fileupload').bind('fileuploadsubmit', function (e, data) {
			
			var filename = $('#filename')[0].value;
			data.formData = {"businessCode":'<%=businesscode%>',"businessNumber": '<%=businessnumber%>',"attachmentCode":'<%=attachmentcode%>',"attachmentName":'<%=attachmentname%>',"filename":filename};
			// The example input, doesn't have to be part of the upload form:
			//data.formData = {"businessCode": businessCodeFresh,"businessNumber": businessNumberFresh,"attachmentCode": attachmentCodeFresh,"isDefault": isDefaultFresh,'utype':utype};
		});
		
		function setFileName(filename){
			var dsds= $('#filename');
			$('#filename')[0].value=filename.substring(0,filename.indexOf('.'));
		}
  function showAttachment (attachmentcode,businessnumber){
	   		//var row  = $('#attachmentgrid').datagrid('getSelected');
	   		//var attachmentid = row.attachmentid;
	   		$.ajax({
			   type: "get",
			   url: "/ProjectServlet/queryBusEstates.do",
			   data:{"attachmentcode":attachmentcode,"businessnumber":businessnumber},
			   dataType: "json",
			   success:function(jsondata){
			   		$("#fileListId_"+'<%=attachmentcode%>').html(JSON.stringify(jsondata).replace(/\"/g,""));
					$("a[rel=show_group]").fancybox({
						'transitionIn'	: 'elastic',
						'transitionOut'	: 'elastic',
						'titlePosition' : 'over',
						'titleFormat'	: function(title, currentArray, currentIndex, currentOpts) {
							return '<span id="fancybox-title-over">扫描件 ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
						}
					});
				//	$('#atta_upload').attr('disabled','disabled');
			   }
			});
	   }
	 function getImg(fileName){
	   		var imgname = fileName;
	   	 	if(fileName.indexOf(".xls")!=-1 || fileName.indexOf(".xlsx")!=-1){
				  imgname = "/images/excel.png";
			  }else if(fileName.indexOf(".jpg")!=-1){
				  imgname = "/images/image.png";
			  }else if(fileName.indexOf(".doc")!=-1 || fileName.indexOf(".docx")!=-1){
				  imgname = "/images/word.png";
			  }else if(fileName.indexOf(".pdf")!=-1){
				  imgname = "/images/pdf.png";
			  }
			  return imgname;
	   } 
	   function closeme(){ 
	   	self.close() ;
	   	var browserName=navigator.appName;
	    if (browserName=="Netscape") 
	    { window.open('','_self',''); 
	   	 window.close();
	     }
	      else if (browserName=="Microsoft Internet Explorer") 
	      { window.opener = "whocares"; window.close(); } 
	  } 
	  function removeRow()
	  {
	  	
	     var tab = document.getElementById("fileListId"); 
	     if(tab.rows.length>0){ 
            //根据id获得将要删除行的对象  
            tab.deleteRow(0);  
            }
	  }    
	      
</script>
		</div>
	</div>
</body>


</html>