<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
	//String username = com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempname();
	String businessnumber = request.getParameter("businessnumber") == null ? ""
			: request.getParameter("businessnumber");
	String businesscode = request.getParameter("businesscode") == null ? ""
			: request.getParameter("businesscode");
%>
<!DOCTYPE html>
<head>


	<link rel="stylesheet" href="/css/bootstrap_pagination_change.css">
	<link rel="stylesheet" href="/css/bootstrap-responsive.min.css">
	<link rel="stylesheet" href="/css/jquery.fileupload-ui.css">
	<link rel="stylesheet" href="/css/jquery.fancybox-1.3.4.css" />
	<link rel="stylesheet" type="text/css" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" type="text/css" href="/themes/icon.css">
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
	<script src="/js/jquery.fileupload-ui-init.js"></script>
	<script src="/js/locale.js"></script>
	<script src="/js/main.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/js/datecommon.js"></script>
	<script src="/js/jquery.fancybox-1.3.4.pack.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>
	<script src="/pdfobject.js"></script>

	<title>附件管理</title>

</head>




<body style="overflow: hidden">
	<div class="easyui-layout" style="width: 1200px; height: 620px;">
		<!-- 
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
		
		<div  style="width:1198px;">
			<table id='businessList1' style="width:1198px"></table>
		</div>
		</div>
				 -->
		<!-- 
		
		<div data-options="region:'center'" style="width:550px;height:330">
			<table id='attachmentgrid' title='附件列表' style="width:548px;height:330"></table>
		</div>
		 -->
		<div id="tabs" class="easyui-tabs" data-options="tools:'#tab-tools'"
			style="height: 440px; width: 930px">
			<div title="基本类型" href="" id="00">
				<div class="container" style="width: 648px;">
					<div class="row fileupload-buttonbar">
						<div class="span7">
							<span class="btn btn-success fileinput-button"
								style="width: 80px"> <i class="icon-plus icon-white"></i>
								<span>增加</span> <input id='atta_upload' disabled type="button"
									name="files[]" onclick="openSub()"> </span><b id='descr'></b>
						</div>
					</div>

					<div class="fileupload-loading"></div>
					<br>
					<table role="presentation" class="table table-striped">
						<tbody id="fileListId" class="files" data-toggle="modal-gallery"
							data-target="#modal-gallery">
						</tbody>
					</table>

				</div>
			</div>
		</div>
		<div id="tab-tools">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				data-options="plain:true,iconCls:'icon-add'"
				onclick="$('#w').window('open')"></a>
			<a href="javascript:void(0)" class="easyui-linkbutton"
				data-options="plain:true,iconCls:'icon-remove'"
				onclick="removePanel()"></a>
		</div>
	</div>

	<div id="w" class="easyui-window" title="请输入附件类型名称"
		data-options="iconCls:'icon-add',closed:true,draggable:false,minimizable:false,maximizable:false"
		style="width: 400px; height: 100px; padding: 10px;">
		<div style="text-align: center; padding: 5px">
			附件名称：
			<td align='center'>
				<input id="zdyname" value="" type="text" />
			</td>
			<a href="javascript:void(0)" class="easyui-linkbutton"
				onclick="addZDYNewType()">确定</a>
		</div>
	</div>


	<script type="text/javascript">
var attachmentCodeFresh;
var businessCodeFresh;
var businessNumberFresh;
var isDefaultFresh;

var businessnumber_v = '';
var businesscode_v = '';
var attachmentcode_v = '00';
var attachmentname_v = '基本类型';
var tabindex_v= "00";
var zdyacode = 0; 
var validID = []; 

$(function(){
/**
		$('#businessList1').datagrid({
			rownumbers:true,
			singleSelect:true,
			pagination:{  
		        pageSize: 10,
				showPageList:false
		    },
		 	columns:[[	
				{field:'projectname',title:'业务信息',align:'center',width:300,
				formatter:function(val,record){
					return '<div align=\'left\'>'+val+'</div>'	
				}
				}, 
				/*
				{field:'input_taxpayername',title:'转入方',align:'center',width:300}, 
				{field:'output_taxpayername',title:'转出方',align:'center',width:300}, 
				
				{field:'tableclass',title:'业务表名',align:'center',hidden:'true',width:300}, 
				{field:'businessdate',title:'发生日期',align:'center',width:80},
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
				$('#descr').html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上传对应业务信息："+descr2+"");
				
				//$('#atta_upload').removeAttr('disabled');
				
				//清空附件区域
				$("#fileListId").html('');
				//选择相关的业务后,上传按钮可以使用
				$('.fileinput-button').css('background','');
				$('#atta_upload').removeAttr('disabled');
			}
		});		
		
		
		var p = $('#businessList1').datagrid('getPager');  
		$(p).pagination({  
			pageSize: 10,//每页显示的记录条数，默认为10  
			showPageList:false
		}); 
		**/
		/**
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
		**/
		$('#fileupload').bind('fileuploadcompleted', function (e, data) {
			$("a[rel=show_group]").fancybox({
				'transitionIn'		: 'elastic',
				'transitionOut'		: 'elastic',
				'titlePosition' 	: 'over',
				'titleFormat'		: function(title, currentArray, currentIndex, currentOpts) {
					return '<span id="fancybox-title-over">扫描件 ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
				}
			});
			//$('#attachmentgrid').datagrid('reload');
		});
		/**
		$('#dateBeginId').datebox({
			formatter: function(date){ return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();},
			parser: function(date){ return new Date(Date.parse(date.replace(/-/g,"/")));}
		});
		$('#dateEndId').datebox({
			formatter: function(date){ return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();},
			parser: function(date){ return new Date(Date.parse(date.replace(/-/g,"/")));}
		});
		**/
		$('#fileupload').bind('fileuploadsubmit', function (e, data) {
			var row = $('#businessList1').datagrid('getSelected');
			var businessCode = row.businesscode;
			var businessNumber = row.businessnumber;
			data.formData = {"businessCode": businessCode,"businessNumber": businessNumber,"attachmentCode":attachmentcode_v};
			// The example input, doesn't have to be part of the upload form:
			//data.formData = {"businessCode": businessCodeFresh,"businessNumber": businessNumberFresh,"attachmentCode": attachmentCodeFresh,"isDefault": isDefaultFresh,'utype':utype};
		});
		
		$('#tabs').tabs({   
      		border:false,   
      		onSelect:function(title){ 
      		var pp = $('#tabs').tabs('getSelected');  
      		attachmentcode_v =  pp[0].id;
      		attachmentname_v = title;
      		var tabs = $("#tabs").tabs("tabs");  
			var length = tabs.length;  
			for(var i = 0; i <= length; i++) {  
				if(tabindex_v==tabs[i][0].id){
					pp[0].innerHTML = tabs[i][0].innerHTML;
					tabs[i][0].innerHTML = '';
					break;
				}
	   		}
      		//var row = $('#businessList1').datagrid('getSelected');
      	//	var sads = $('#tabs').tabs('getTab','基本类型'[0]);
      		//alert($('#tabs').tabs('getTab','基本类型')[0].outerHTML);
      	//	pp[0].innerHTML = $('#tabs').tabs('getTab','基本类型')[0].outerHTML;
      	//	 $('#tabs').tabs('getTab','基本类型')[0].innerHTML='';
      		showAttachment(attachmentcode_v,'<%=businessnumber%>');
      		tabindex_v = pp[0].id;
	   		
          	//alert(title+' is selected');   
      	}});   
		/*
		初始化上传按钮不能用
		*/
		$('#atta_upload').removeAttr('disabled');
		queryAttachments();
		//$('.fileinput-button').css('background','#bbffaa');
		//$('#atta_upload').attr('disabled','disabled');
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
			$('#businessList1').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#businessList1').datagrid('options');
			opts.url = '/AttachmentService/getResourceList.do';
			$('#businessList1').datagrid('load',params); 
			var p = $('#businessList1').datagrid('getPager');  
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
			//var row = $('#businessList1').datagrid('getSelected');
			var businessnumber = '<%=businessnumber%>';
			var businesscode = '<%=businesscode%>';
			//var tableclass = row.tableclass;
			var params = {};
			/*
			businessnumber = '4C0'
			tableclass = 'BUS_ESTATE';
			*/
			params.businessnumber = businessnumber;
			params.businesscode = businesscode;
			//params.tableclass = tableclass;
			businesscode_v = businesscode;
			businessnumber_v = businessnumber;
			showAttachmentType(params);
			/**
			$('#attachmentgrid').datagrid('loadData',{total:0,rows:[]});
			//attachmentgrid
	   		var opts = $('#attachmentgrid').datagrid('options');
			opts.url = '/ProjectServlet/queryBusEstates.do';
			$('#attachmentgrid').datagrid('load',params);
		
			var p = $('#attachmentgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});**/
	   }
	   
	   function showAttachment(attachmentcode,businessnumber){
	   		//var row  = $('#attachmentgrid').datagrid('getSelected');
	   		//var attachmentid = row.attachmentid;
	   		$.ajax({
			   type: "get",
			   url: "/attachmentServlet/querybusestates.do",
			   data:{"attachmentcode":attachmentcode,"businessnumber":businessnumber},
			   dataType: "json",
			   success:function(jsondata){
			   		$("#fileListId").html(JSON.stringify(jsondata).replace(/\"/g,""));
			   		/**
					$("a[rel=show_group]").fancybox({
						'transitionIn'	: 'elastic',
						'transitionOut'	: 'elastic',
						'titlePosition' : 'over',
						'titleFormat'	: function(title, currentArray, currentIndex, currentOpts) {
							return '<span id="fancybox-title-over">扫描件 ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
						}
					});**/
				//	$('#atta_upload').attr('disabled','disabled');
			   }
			});
			//$('#attachmentgrid').datagrid('unselectAll');
	   }
	   
	   function deleteAttachment(attachmentcode,businessnumber,url){
	   		//var row  = $('#attachmentgrid').datagrid('getSelected');
	   		//var attachmentid = row.attachmentid;
	   		$.ajax({
			   type: "get",
			   url: url,
			   //data:{"attachmentcode":attachmentcode,"businessnumber":businessnumber},
			   dataType: "json",
			   success:function(jsondata){
				//	$('#atta_upload').attr('disabled','disabled');
					showAttachment(attachmentcode,businessnumber);
			   }
			});
			//$('#attachmentgrid').datagrid('unselectAll');
	   }
	   
	   
	   
	   function showAttachmentType (params){
	   		dellTabs();
	   		//var row  = $('#attachmentgrid').datagrid('getSelected');
	   		//var attachmentid = row.attachmentid;
	   		//var descr = $('#descr')[0].innerText;
	   		//descr($('#descr')[0].innerText);
	   		$.ajax({
			   type: "get",
			   url: "/attachmentServlet/queryBusEstatesType.do",
			   data:{"businesscode":params.businesscode,"businessnumber":params.businessnumber},
			   dataType: "json",
			   success:function(jsondata){
			   		if(jsondata.attachmentType.length>0){
				   		for(var i = 0;i < jsondata.attachmentType.length;i++){
				   			addNewType(jsondata.attachmentType[i],params.businessnumber);
				   			if(jsondata.attachmentType[i].valid=='00'){
				   				zdyacode = parseInt(jsondata.attachmentType[i].attachmentcode);
				   			}else if(jsondata.attachmentType[i].valid=='01'){
				   				validID.push(jsondata.attachmentType[i].attachmentcode);
				   			}
				   		}
					}
					showAttachment(attachmentcode_v,params.businessnumber,params.businesscode);
				//	$('#atta_upload').attr('disabled','disabled');
			   }
			});
			//$('#attachmentgrid').datagrid('unselectAll');
	   }
	   
	   function dellTabs(){
	   		var tabs = $("#tabs").tabs("tabs");  
			var length = tabs.length;  
			for(var i = 1; i <= length; i++) {  
			    $("#tabs").tabs("close", 1);  
			}   
	   }
	   
	   function addNewType(battachmentType,businessnumber,businesscode){
	   		$('#tabs').tabs('add',{
	   			id:battachmentType.attachmentcode,
				title:battachmentType.attachmentname,
				//href:'attachmentutilsub.jsp?descr='+descr+'&businessnumber='+businessnumber+'&attachmentcode='+battachmentType.attachmentcode+'&businesscode='+businesscode,
				content:'',
				valid : battachmentType.valid,
				closable:false,
				selected:false
			});
	   }
	   function addZDYNewType(){
	   		var name = $('#zdyname')[0].value;
	   		if(name ==''){
	   			$.messager.alert('提示','请输入附件类型名称!');
	   			return;
	   		}
	   		zdyacode++;
	   		$('#tabs').tabs('add',{
	   			id:zdyacode,
				title:name,
				//href:'attachmentutilsub.jsp?descr='+descr+'&businessnumber='+businessnumber+'&attachmentcode='+battachmentType.attachmentcode+'&businesscode='+businesscode,
				content:'',
				valid : '00',
				closable:false,
				selected:true
			});
			attachmentname_v = name;
			$('#w').window('close')
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
	   
	   function openSub(){
	   	var param = 'attachmentname='+attachmentname_v+'&attachmentcode='+attachmentcode_v+'&businesscode='+businesscode_v+'&businessnumber='+businessnumber_v;
	   	window.open("attachmentutilsub.jsp?"+param+"", '附件添加窗口',
						           'top=100,left=250,width=800,height=400,toolbar=no,menubar=no,location=no');
	   }
	    
	   function getDate(){
	   		//var df=new DateFormat();
	   		//df.applyPattern("yyyy-MM-dd");
	   		var date  = new Date();
	   		return date.toJSON().substring(0,10);
	   }
		
        function removePanel(){
        	$.messager.confirm('提示', '是否确认删除?', function(r){
				if (r){
					var tab = $('#tabs').tabs('getSelected');
		            if(tab[0].id=="00"){
		            	$.messager.alert('提示','附件基本类型不能删除!');
		            	return ;
		            }
		             if(jQuery.inArray(tab[0].id,validID) > -1){
		            	$.messager.alert('提示','附件配置类型不能删除!');
		            	return;
		            }
		            if (tab){
		            	var index = $('#tabs').tabs('getTabIndex', tab);
		            	alert(tab[0].id);
		            	deleteZDYComm('<%=businessnumber%>',tab[0].id);
			      		$('#tabs').tabs('select','基本类型');
			      		//showAttachment('00','<%=businessnumber%>');
		                $('#tabs').tabs('close', index);
		                
		            }
				}
			});
        }
        
        function deleteZDYComm(businessnumber,attachmentcode){
        	$.ajax({
			   type: "get",
			   url: "/ProjectServlet/deleteAttachmentZdy.do",
			   data:{"attachmentcode":attachmentcode,"businessnumber":businessnumber},
			   dataType: "json",
			   success:function(jsondata){
			   	
			   }
			});
        }
        function preview(type,url,filename,ftp_path){
		  	 	window.open("preview.jsp?type="+type+"&url="+url+"&filename="+filename+"&ftp_path="+ftp_path, '附件预览窗口',
							           'top=100,left=250,width=800,height=400,toolbar=no,menubar=no,location=no');
        }
        
</script>
</body>


</html>