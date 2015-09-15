<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<head>

	<link rel="stylesheet" type="text/css" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" type="text/css" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/bootstrap.css">
	<link rel="stylesheet" href="/css/bootstrap-responsive.min.css">
	<link rel="stylesheet" href="/css/jquery.fileupload-ui.css">
	<link rel="stylesheet" href="/css/jquery.fancybox-1.3.4.css"/>	
	<link rel="stylesheet" type="text/css" href="/demo/demo.css">
	<!--[if lt IE 8]>
		<link rel="stylesheet" type="text/css" href="css/ie.css"/>
	<![endif]-->
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
    <script src="/js/jquery.fileupload-ui.js"></script>
    <script src="/js/locale.js"></script>
    <script src="/js/main.js"></script>	
	<script src="/js/json2.js"></script>	
	<script src="/js/datecommon.js"></script>	
	<script src="/js/jquery.fancybox-1.3.4.pack.js"></script>

    <title>附件管理</title>

</head>
<body>
<body style="overflow:hidden">  
	<div class="easyui-layout" style="width:1200px;height:550px;">
		<div data-options="region:'west',split:false,title:''" style="width:400px;padding-top:20px;">
	
			<div id="tb" style="padding:5px;height:auto">
				<div>
					是否上传: <select id="OnlyShowWaitId" class="easyui-combobox" panelHeight="auto" style="width:100px">
						<option value="1">未上传</option>
						<option value="0">已上传</option>
					</select></br>

					日期起: <input id="dateBeginId" class="easyui-datebox" style="width:90px" data-options="required:false">
					日期止: <input id="dateEndId"   class="easyui-datebox" style="width:90px" data-options="required:false">
					<span id="queryId" class="btn btn-primary" style="width:60px">
								<lable class="icon-search icon-white"></lable>
								<span>查询</span>
					</span>
				</div>
			</div>

			<table id="attachmentListId" class="easyui-datagrid" style="width:500px;height:500px"
					data-options="rownumbers:true,pagination:true,singleSelect:true,url: '/AttachmentService/getAttachmentList.do',toolbar:'#tb'">
				<thead>
					<tr>
						<th data-options="field:'taxpayername',width:100">业务信息</th> 
						<th data-options="field:'businessdate',width:80,formatter:formatter_date">发生日期</th>
						<th data-options="field:'businessname',width:100">业务类型</th> 
						<th data-options="field:'attachmentTypeName',width:100">附件类型</th>
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
					<table role="presentation" class="table table-striped">
						<tbody id="fileListId" class="files" data-toggle="modal-gallery" data-target="#modal-gallery">
						</tbody>
					</table>
				</form>
			</div>


			<div id="modal-gallery" class="modal modal-gallery hide fade" data-filter=":odd">
				<div class="modal-header">
					<a class="close" data-dismiss="modal">&times;</a>
					<h3 class="modal-title"></h3>
				</div>
				<div class="modal-body"><div class="modal-image"></div></div>
				<div class="modal-footer">
					 <a class="btn btn-success modal-download">
						<i class="icon-download icon-white"></i>
						<span>下&nbsp;&nbsp;载</span>
					</a>
					<!--
					<a class="btn btn-success modal-play modal-slideshow" data-slideshow="5000">
						<i class="icon-play icon-white"></i>
						<span>幻灯片</span>
					</a>
					-->
					<a class="btn btn-info modal-prev">
						<i class="icon-arrow-left icon-white"></i>
						<span>上一张</span>
					</a>
					<a class="btn btn-primary modal-next">
						<i class="icon-arrow-right icon-white"></i>
						<span>下一张</span>
					</a>
				</div>
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


<script type="text/javascript">
var attachmentCodeFresh;
var businessCodeFresh;
var businessNumberFresh;
var isDefaultFresh;

$(function(){

		$('#attachmentListId').datagrid({
			rownumbers:true,
			onClickRow:function(index,data){
						var row = $('#attachmentListId').datagrid('getSelected');
						var attachmentCode = row.attachmentcode;
						var businessCode = row.businesscode;
						var businessNumber = row.businessnumber;
						var isDefault = row.isdefault;
						attachmentCodeFresh = attachmentCode;
						businessCodeFresh = businessCode;
						businessNumberFresh = businessNumber;
						isDefaultFresh = isDefault;
						$.ajax({
								   type: "get",
								   url: "/UploadController/getFileList.do",
								   data: {"attachmentCode":attachmentCode,"businessCode":businessCode,"businessNumber":businessNumber,"isDefault":isDefault},
								   dataType: "json",
								   success: function(jsondata){
										$("#fileListId").html(JSON.stringify(jsondata).replace(/\"/g,""));
										$("a[rel=show_group]").fancybox({
											'transitionIn'	: 'elastic',
											'transitionOut'	: 'elastic',
											'titlePosition' : 'over',
											'titleFormat'	: function(title, currentArray, currentIndex, currentOpts) {
												return '<span id="fancybox-title-over">扫描件 ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
											}
										});
								   }
						});
			}
		})			


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

		var p = $('#attachmentListId').datagrid('getPager');  
			$(p).pagination({  
				pageSize: 15,//每页显示的记录条数，默认为10  
				pageList: [15],//可以设置每页记录条数的列表  
				showPageList:false,
				beforePageText: '第',//页数文本框前显示的汉字  
				afterPageText: '页    共 {pages} 页',  
				displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录',  
				onRefresh:function(pageNumber, pageSize){ 
					//alert(pageSize);
				} 
		}); 

		$('#attachmentListId').datagrid('load',{
			OnlyShowWait: "1",beginDate:'',endDate:'',attachmentcode:'',businesscode:'',page:2,rows:1
		});

		$('#dateBeginId').datebox({
			formatter: function(date){ return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();},
			parser: function(date){ return new Date(Date.parse(date.replace(/-/g,"/")));}
		});

		$('#dateEndId').datebox({
			formatter: function(date){ return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();},
			parser: function(date){ return new Date(Date.parse(date.replace(/-/g,"/")));}
		});

		$('#queryId').click(function(){
			var OnlyShowWait =  $('#OnlyShowWaitId').combobox('getValue');	
			var dateBegin = $('#dateBeginId').datebox("getValue");
			var dateEnd = $('#dateEndId').datebox("getValue");
			if(OnlyShowWait == "1"){
				$('#attachmentListId').datagrid('load',{
					OnlyShowWait: "1",beginDate:'',endDate:'',attachmentcode:'',businesscode:'',page:2,rows:1
				});				
			}else{
				$('#attachmentListId').datagrid('load',{
					OnlyShowWait: "0",beginDate:dateBegin,endDate:dateEnd,attachmentcode:'',businesscode:'',page:2,rows:1
				});					
			}
		 });

		$('input[name="files[]"]').click(function(){
			var row = $('#attachmentListId').datagrid('getSelected');
			if(row == null){
				$.messager.alert('提示','请先选择左侧列表中相关业务信息!');
				return;
			}				
		 });




		$('#fileupload').bind('fileuploadsubmit', function (e, data) {
			//var row = $('#attachmentListId').datagrid('getSelected');
			//var attachmentCode = row.attachmentcode;
			//var businessCode = row.businesscode;
			//var businessNumber = row.businessnumber;
			//var isDefault = row.isdefault;
			//alert(isDefault);
			// The example input, doesn't have to be part of the upload form:
			data.formData = {"businessCode": businessCodeFresh,"businessNumber": businessNumberFresh,"attachmentCode": attachmentCodeFresh,"isDefault": isDefaultFresh};

		});



})
		function formatter_date(value,row,index){
			return formatDatebox(value);
		}
	</script>
</body>
</html>