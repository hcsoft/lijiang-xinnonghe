<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">

<head>

	<link rel="stylesheet" type="text/css" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" type="text/css" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/bootstrap.css">
	<link rel="stylesheet" href="/css/bootstrap-responsive.min.css">
	<link rel="stylesheet" href="/css/jquery.fileupload-ui.css">
	<link rel="stylesheet" href="/css/jquery.fancybox-1.3.4.css"/>	
	<!--[if lt IE 8]>
		<link rel="stylesheet" type="text/css" href="css/ie.css"/>
	<![endif]-->
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.1.3.js"></script>

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
	<script src="/js/jquery.fancybox-1.3.4.pack.js"></script>
	
    <title>附件上传</title>


    <script>


$(function(){
	var paraString = location.search;     
	var paras = paraString.split("&");   
	var businessCode = paras[0].substr(paras[0].indexOf("=") + 1);   
	var businessNumber = paras[1].substr(paras[1].indexOf("=") + 1); 
	//alert(businessCode);
	//alert(businessNumber);

	$('#attachmentListId').datagrid('load',{
		businessCode: businessCode
	});

	$('#attachmentListId').datagrid('loaded');


	$("#filterId").click(function() {
			if ($("#filterId").attr("checked")) {

				$('#attachmentListId').datagrid({
					loadFilter: function(data){
						var filterRows = new Array();
						for(var i = 0;i < data.rows.length;i++){
							var row = data.rows[i];
							if(row.isdefault == "1"){
								filterRows.push(row);
							}
						}
						var filterJson = {"total":filterRows.length,"rows":filterRows};
						return filterJson;
					}
				});
	


			}else{
				$('#attachmentListId').datagrid({
					loadFilter: function(data){
						return data;
					}
				});
			}

			 
	});

	$('#attachmentListId').datagrid({
		onClickRow:function(index,data){
					var row = $('#attachmentListId').datagrid('getSelected');
					var attachmentCode = row.attachmentcode;
					var isDefault = row.isdefault;
					//alert(row.attachmentcode);
					//alert(businessNumber);
					$.ajax({
							   type: "get",
							   url: "/UploadController/getFileList.do",
							   data: {"attachmentCode":attachmentCode,"businessCode":businessCode,"businessNumber":businessNumber,"isDefault":isDefault},
							   dataType: "json",
							   success: function(jsondata){
									$("#fileListId").html(JSON.stringify(jsondata).replace(/\"/g,""));
									//alert(JSON.stringify(jsondata));
									$("a[rel=show_group]").fancybox({
										'transitionIn'		: 'elastic',
										'transitionOut'		: 'elastic',
										'titlePosition' 	: 'over',
										'titleFormat'		: function(title, currentArray, currentIndex, currentOpts) {
											return '<span id="fancybox-title-over">扫描件 ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
										}
									});

							   }
					});
		}
	})


/*
	$.ajax({
	           type: "get",
	           url: "/UploadController/getFileList.do",
	           data: {parm1:"111", parm2:"222"},
	           dataType: "json",
	           success: function(jsondata){
				    $("#fileListId").html(JSON.stringify(jsondata).replace(/\"/g,""));
					//alert(JSON.stringify(jsondata));
	           }
	});

*/

	$('#fileupload').bind('fileuploadsubmit', function (e, data) {
		var row = $('#attachmentListId').datagrid('getSelected');
		var isDefault = row.isdefault;
		var attachmentCode = row.attachmentcode;
		//alert(isDefault);
		// The example input, doesn't have to be part of the upload form:
		data.formData = {"businessCode": businessCode,"businessNumber": businessNumber,"attachmentCode": attachmentCode,"isDefault": isDefault};

	});

	$('#fileupload').bind('fileuploadcompleted', function (e, data) {
			$("a[rel=show_group]").fancybox({
				'transitionIn'		: 'elastic',
				'transitionOut'		: 'elastic',
				'titlePosition' 	: 'over',
				'titleFormat'		: function(title, currentArray, currentIndex, currentOpts) {
					return '<span id="fancybox-title-over">扫描件 ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
				}
			});
		
		});


	$('input[name="files[]"]').click(function(){
		var row = $('#attachmentListId').datagrid('getSelected');
		if(row == null){
			$.messager.alert('提示','请先选择左侧列表的附件类型!');
			return;
		}				
	 });

});



    </script>
</head>
<body>
<body style="overflow:hidden">  


	<div class="easyui-layout" style="width:1000px;height:550px;">

	

			

		<div data-options="region:'west',split:false,title:''" style="width:200px;padding-top:20px;">
	

			<input id="filterId" type="checkbox"/>仅显示必传附件
			<table id="attachmentListId" class="easyui-datagrid" style="width:200px;height:auto"
					data-options="striped:true,rownumbers:true,fitColumns:true,singleSelect:true,url: '/UploadController/getAttachmentCodes.do'">
				<thead>
					<tr>
						<th data-options="field:'attachmentcode',width:50">附件代码</th> 
						<th data-options="field:'attachmentname',width:50">附件类型</th>
					</tr>
				</thead>
			</table>
		</div>

		<div data-options="region:'center',title:'',iconCls:'icon-ok'" style="width:800px;padding-left:10px;">

			<div class="container" style="width:780px;">
				<form id="fileupload" action="UploadServlet" method="POST" enctype="multipart/form-data">
					<div class="row fileupload-buttonbar">
						<div class="span7">
							<span class="btn btn-success fileinput-button" style="width:80px">
								<i class="icon-plus icon-white"></i>
								<span>增加</span>
								<input type="file" name="files[]" multiple accept="image/png, image/gif, image/jpg, image/jpeg">
							</span>
							<span class="btn btn-primary start" style="width:80px">
								<i class="icon-upload icon-white"></i>
								<span>开始</span>
							</span>
							<span class="btn btn-warning cancel" style="width:80px">
								<i class="icon-ban-circle icon-white"></i>
								<span>终止</span>
							</span>
							<span class="btn btn-danger delete" style="width:80px">
								<i class="icon-trash icon-white"></i>
								<span>删除</span>
							</span>
							<input type="checkbox" class="toggle">
						</div>
						<div class="span5 fileupload-progress fade">
							<div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
								<div class="bar" style="width:0%;"></div>
							</div>
							<div class="progress-extended">&nbsp;</div>
						</div>
					</div>
					<div class="fileupload-loading"></div>
					<br>
					<table role="presentation" class="table table-striped"><tbody id="fileListId" class="files"></tbody></table>
				</form>



			</div>

			

        <script id="template-upload" type="text/x-tmpl">
            {% for (var i=0, file; file=o.files[i]; i++) { %}
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
				<td class="preview">
					<a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}">下载</a>
				</td>
				{% if (file.error) { %}
				<td class="preview">
					<a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}">下载</a>
				</td>
				<td class="name"><span>{%=file.name%}</span></td>
				<td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
				
				{% } else { %}
				<td class="preview">{% if (file.thumbnail_url) { %}
					<a href="{%=file.url%}" title="{%=file.name%}" rel="show_group"><img src="{%=file.thumbnail_url%}"></a>
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
					<input type="checkbox" name="delete" value="1">
				</td>
			</tr>
			{% } %}
		</script>





		</div>


</div>




</body>
</html>