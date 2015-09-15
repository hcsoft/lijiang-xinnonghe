<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<head>

	<link rel="stylesheet" type="text/css" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" type="text/css" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/bootstrap_pagination_change.css">
	<link rel="stylesheet" href="/css/bootstrap-responsive.min.css">
	<link rel="stylesheet" href="/css/jquery.fileupload-ui.css">
	<link rel="stylesheet" href="/css/jquery.fancybox-1.3.4.css"/>	
	<!--[if lt IE 8]>
		<link rel="stylesheet" type="text/css" href="css/ie.css"/>
	<![endif]-->
	<script src="/js/jquery-1.8.2.js"></script>
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




<body style="overflow:hidden">  
	<div class="easyui-layout" style="width:1200px;height:620px;">
		<div data-options="region:'north'" style="width:1198px;height:350px;">
			
				
					<div style='padding:5px;'>                                            
						项目名称: <input id="name" type='text' name='name' style="width:120px" >
						纳税人名称: <input id="taxpayername" type='text' name='taxpayername'  style="width:120px" >
						日期起: <input id="dateBeginId" class="easyui-datebox" style="width:90px" data-options="required:false">
						日期止: <input id="dateEndId"   class="easyui-datebox" style="width:90px" data-options="required:false">
						业务类型：<input class="easyui-combobox" name="businesscode" id="businesscode" style="width:200px" editable='false' data-options="
									valueField:'key',
									textField: 'value',
									url:'/InitGroundServlet/getBusinesscode.do?codetablename=COD_BUSINESS'
								"/>
						<a  href="#" class="easyui-linkbutton" data-options="" onclick="query()" >查询</a>
					</div>
				
				
				<div style="width:1198px;">
					<table id='businessList' style="width:1196px"></table>
				</div>
				 
		</div>
		
		<div data-options="region:'center'" style="width:550px;height:330">
			<table id='attachmentgrid' title='附件列表' style="width:548px;height:330"></table>
		</div>
		
		<div data-options="region:'east',title:'提示：请先选择相应的业务',iconCls:'icon-ok'" style="width:650px;height:330px">

			<div class="container" style="width:648px;">
				<form id="fileupload" action="UploadServletUtil" method="POST" enctype="multipart/form-data">
					<div  class="row fileupload-buttonbar">
						<b id = 'descr'></b>
						<div  class="span7">
							<span class="btn btn-success fileinput-button" style="width:80px">
								<i class="icon-plus icon-white"></i>
								<span>增加</span>
								<input id='atta_upload' disabled type="file" name="files[]"  multiple accept="image/png, image/gif, image/jpg, image/jpeg">
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
						
						<!-- div class="span5 fileupload-progress fade">
							<div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
								<div class="bar" style="width:0%;"></div>
							</div>
							<div class="progress-extended">&nbsp;</div>
						</div-->
						
						<div class="fileupload-progress">
						    <div class="progress">
						        <div class="bar" style="width:0%;"></div>
						    </div>
						    <div class="progress-extended"></div>
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
		
		$('#businessList').datagrid({
			rownumbers:true,
			singleSelect:true,
			pagination:{  
		        pageSize: 10,
				showPageList:false
		    },
		 	columns:[[	
				{field:'projectname',title:'业务信息',align:'center',width:300}, 
				{field:'input_taxpayername',title:'转入方',align:'center',width:300}, 
				{field:'output_taxpayername',title:'转出方',align:'center',width:300}, 
				{field:'tableclass',title:'业务表名',align:'center',hidden:'true',width:300}, 
				{field:'businessdate',title:'发生日期',align:'center',width:100},
				{field:'businessname',title:'业务类型',align:'center',width:100},
				{field:'businesscode',title:'业务类型代码',align:'center',hidden:true},  
				{field:'businessnumber',title:'业务编号',align:'center',hidden:true}   
	        ]],
	        onLoadSuccess:function(data){
	        	//清空附件区域
				$("#fileListId").html('');  
	        	//页面涮新后,上传按钮不能使用
	        	$('.fileinput-button').css('background','#bbffaa');
				$('#atta_upload').attr('disabled','disabled');
	        
			},
			onClickRow: queryAttachments,
			onSelect:function(rowIndex, rowData){
				var descr1 ;	
				if (rowData.projectname){
					descr1 = rowData.projectname;
				}else{
					descr1 = '';
				}
				var input ;
				if (rowData.input_taxpayername){
					input = rowData.input_taxpayername
				}else{
					input = '';
				}
				var output;
				if (rowData.output_taxpayername){
					output = rowData.output_taxpayername
				}else{
					output = '';
				}
				var descr2;
				if (descr1!=''){
					descr2 = descr1;
				}else{
					descr2 = input+"->"+output;
				}
				$('#descr').html("上传对应业务信息："+descr2+"");
				
				//$('#atta_upload').removeAttr('disabled');
				
				//清空附件区域
				$("#fileListId").html('');
				//选择相关的业务后,上传按钮可以使用
				$('.fileinput-button').css('background','');
				$('#atta_upload').removeAttr('disabled');
			}
		});		
		var p = $('#businessList').datagrid('getPager');  
		$(p).pagination({  
			pageSize: 10,//每页显示的记录条数，默认为10  
			showPageList:false
		}); 
		
		$('#attachmentgrid').datagrid({
				rownumbers:true,
				pagination:{  
			        pageSize: 3,
					showPageList:false
			    },
			    columns:[[	
							{field:'attachmentid',title:'附件主键',hidden:'true',align:'center',width:80}, 
							{field:'attachmentname',title:'附件名称',align:'center'}, 
							{field:'busidates',title:'业务发生时间',align:'center'}, 
							{field:'businessnumber',title:'附件编号',width:70,align:'center'},   
		        ]],
		       onClickRow: showAttachment
		});
		var ppp = $('#attachmentgrid').datagrid('getPager');  
		$(ppp).pagination({  
			pageSize: 15,//每页显示的记录条数，默认为10  
			showPageList:false
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
			$('#attachmentgrid').datagrid('reload');
		});
		
		$('#dateBeginId').datebox({
			formatter: function(date){ return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();},
			parser: function(date){ return new Date(Date.parse(date.replace(/-/g,"/")));}
		});
		$('#dateEndId').datebox({
			formatter: function(date){ return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();},
			parser: function(date){ return new Date(Date.parse(date.replace(/-/g,"/")));}
		});
		
		$('input[name="files[]"]').click(function(){
			var row = $('#businessList').datagrid('getSelected');
			/*
			var uploadtype = $("input[type='radio']:checked").val(); 
			
			if (uploadtype!=1){
				$.messager.alert('提示','请先选择相关业务信息!');
				return;	
			}
			if(row == null){
				$.messager.alert('提示','请先选择左侧列表中相关业务信息!');
				return;
			}			
			*/	
		 });
		$('#fileupload').bind('fileuploadsubmit', function (e, data) {
			var row = $('#businessList').datagrid('getSelected');
			var businessCode = row.businesscode;
			var businessNumber = row.businessnumber;
			data.formData = {"businessCode": businessCode,"businessNumber": businessNumber};
			// The example input, doesn't have to be part of the upload form:
			//data.formData = {"businessCode": businessCodeFresh,"businessNumber": businessNumberFresh,"attachmentCode": attachmentCodeFresh,"isDefault": isDefaultFresh,'utype':utype};
		});
		/*
		初始化上传按钮不能用
		*/
		$('.fileinput-button').css('background','#bbffaa');
		$('#atta_upload').attr('disabled','disabled');
})
		function formatter_date(value,row,index){
			return formatDatebox(value);
		}
		//土地批复原件复印件    法人身份证复印件
		function changeA(value){
			$('#atta_upload').removeAttr('disabled');
			if (value==1){
				$.messager.alert('提示','上传类型为土地批复原件复印件!');
				$('#utype').val('01');
			}else if (value==2){
				$.messager.alert('提示','上传类型为企业营业执照复印件!');
				$('#utype').val('02');
			}else if (value==3){
				$.messager.alert('提示','上传类型为法人身份证复印件!');
				$('#utype').val('01');
			}
		}
		function query(){
			var params = {};
			params.name = $('#name').val();
			params.taxpayername = $('#taxpayername').val();
			params.beginDate = $('#dateBeginId').datebox("getValue");
			params.endDate = $('#dateEndId').datebox("getValue");
			params.businesscode = $('#businesscode').combobox("getValue");
			$('#businessList').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#businessList').datagrid('options');
			opts.url = '/AttachmentService/getResourceList.do';
			$('#businessList').datagrid('load',params); 
			var p = $('#businessList').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 10
			});
			/*
				初始化上传按钮不能用
			*/
			$('.fileinput-button').css('background','#bbffaa');
			$('#atta_upload').attr('disabled','disabled');
		}
		
	   function queryAttachments(){
			var row = $('#businessList').datagrid('getSelected');
			var businessnumber = row.businessnumber;
			var tableclass = row.tableclass;
			var params = {};
			/*
			businessnumber = '4C0'
			tableclass = 'BUS_ESTATE';
			*/
			params.businessnumber = businessnumber;
			params.tableclass = tableclass;
			
			$('#attachmentgrid').datagrid('loadData',{total:0,rows:[]});
			//attachmentgrid
	   		var opts = $('#attachmentgrid').datagrid('options');
			opts.url = '/ProjectServlet/queryBusEstates.do';
			$('#attachmentgrid').datagrid('load',params);
		
			var p = $('#attachmentgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
	   }
	 
	   function showAttachment (){
	   		var row  = $('#attachmentgrid').datagrid('getSelected');
	   		var attachmentid = row.attachmentid;
	   		$.ajax({
			   type: "get",
			   url: "/UploadControllerUtil/getFileList.do",
			   data:{"attachmentid":attachmentid,"businessCode":'',"businessNumber":''},
			   dataType: "json",
			   success:function(jsondata){
					$("#fileListId").html(JSON.stringify(jsondata).replace(/\"/g,""));
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
			$('#attachmentgrid').datagrid('unselectAll');
	   }
		
</script>


</body>


</html>