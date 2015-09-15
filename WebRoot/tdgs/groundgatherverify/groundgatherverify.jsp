<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<link rel="stylesheet" href="<%=spath%>/css/tablen.css"/>
	<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
    <script src="<%=spath%>/js/tiles.js"></script>
    <script src="<%=spath%>/js/moduleWindow.js"></script>
	<script src="<%=spath%>/menus.js"></script>
	
	<script src="<%=spath%>/js/jquery.simplemodal.js"></script>
	<script src="<%=spath%>/js/overlay.js"></script>
	<script src="<%=spath%>/js/jquery.json-2.2.js"></script>
	<script src="<%=spath%>/js/json2.js"></script>
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>

	<script>
	var locationdata = new Object;//所属乡镇缓存
	var levydatetypedata = new Object;//征期类型
	var orgdata = new Object;//机关
	var empdata = new Object;//人员
	var statedata  =  new Object;//比对状态
	var opttype;//操作类型0:撤销审核,1:审核
	var showtype;//用作明细查看和修改的区分 0:明细查看,1:修改
	var belongtocountry = new Array();
	var belongtowns = new Array();
	var statedata = new Object;//状态
	//var belongtodata = new Object;
	
			var menu2 = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundgathercheckquerywindow').window('open');
					}
				},{
					text:'确认征税范围',
					iconCls:'icon-check',
					handler:function(){
						var rows=$('#groundgathercheckgrid').datagrid("getSelected");
						if(null==rows || ""==rows){
							$.messager.alert("提示","请选择记录!");
						}else{
							
							var all_finally = rows.all_finally;
							if (all_finally=='1'){
								$.messager.alert("提示","该纳税人的土地已全部终审!");
								return;
							}
							$('#landdetail_windows').window('open');
							$('#landdetail_windows').window('center');							
							$('#landdetailgrid').datagrid('loadData',{total:0,rows:[]});
							var opts = $('#landdetailgrid').datagrid('options');
							opts.url = '/GroundGatherVerifyPrintServlet/getlanddetail.do';
							$('#landdetailgrid').datagrid('load',{taxpayerid:rows.taxpayerid}); 
						}
					}
				}
				
				,{
					text:'打印税源核实表',
					iconCls:'icon-print',
					handler:function(){
						var rows=$('#groundgathercheckgrid').datagrid("getSelected");
						if(null==rows || ""==rows){
							$.messager.alert("提示","请选择记录!");
						}else{
						
							var v = rows.verify_state;
							var m = rows.print_state;
							var fs =  rows.finally_lands+0;
							if(fs>0){
								$.messager.alert("提示","存在终审状态的土地，请先撤销终审后再执行打印操作!");
								return;
							}
							if(v==0){
								$.messager.alert("提示","请先执行土地确认操作后在进行打印!");
								return;
							}
							//开始打印
							//var rows=$('#groundgatherprintgrid').datagrid("getChecked");
							var taxpayerid =rows.taxpayerid;
							//alert(taxpayerid);
							$.messager.confirm('提示', '是否确认打印?', function(r){
								if (r){
									/**
									var estateid="";
									for(var i=0;i<$('#groundgatherprintgrid').datagrid("getData").rows.length;i++){
										estateid=estateid+"estateid="+$('#groundgatherprintgrid').datagrid("getData").rows[i].estateid+"&";
									}
									//未选中
									rows=$('#groundgatherprintgrid').datagrid("getChecked");
									var estateid1="";
									for(var i=0;i<$('#groundgatherprintgrid').datagrid("getData").rows.length;i++){
										var falg=0;
										for(var j=0;j<rows.length;j++){
											if($('#groundgatherprintgrid').datagrid("getData").rows[i].estateid==rows[j].estateid)
												falg++;
										}
										if(falg==0){
											estateid1=estateid1+"estateid1="+$('#groundgatherprintgrid').datagrid("getData").rows[i].estateid+"&";
										}
									}
									*/
									var param='taxpayerid='+taxpayerid;
							        window.showModalDialog('detailprint.jsp?'+param, window,'dialogWidth=1100px,dialogHeight=600px,scrollbars=1');
							        $('#groundgathercheckgrid').datagrid('reload');
								}
							});
						//}
							
							
							
							
							//打印结束
							
							
							
						}
					}
				}
				/*
				,{
					id:'check',
					text:'审核',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#groundgathercheckgrid').datagrid('getSelected');
						var intotaxscopeflag;
						if(row){
							if(row.state =='0'){
								$.messager.alert('提示消息',"该记录未提交，不能进行审核！");
								return;
							}
							if(row.state =='3'){
								$.messager.alert('提示消息',"该记录已审核！");
								return;
							}
							if(row.isuse =='1'){
								$.messager.alert('提示消息',"该记录有后续业务发生，不能审核！");
								return;
							}
							$.messager.confirm('提示框', '确认审核？',function(r){
								if(r){
							//		intotaxscopeflag = '1';
							//	}else{
							//		intotaxscopeflag ='0';
							//	}
									$.ajax({
									   type: "post",
									   url: "/GroundGatherCheckServlet/checkgatherinfo.do",
									   data: {estateid:row.estateid,opttype:1,intotaxscopeflag:'1'},
									   dataType: "json",
									   success: function(jsondata){
										  $.messager.alert('返回消息',jsondata);
										  $('#groundgathercheckgrid').datagrid('reload');
									   }
									});
								}
							});
						}else{
							$.messager.alert('提示消息',"请选择需要审核的记录！");
							return;
						}
					}
				},{
					id:'cancelcheck',
					text:'撤销审核',
					iconCls:'icon-uncheck',
					handler:function(){
						var row = $('#groundgathercheckgrid').datagrid('getSelected');
						if(row){
							if(row.state =='0'){
								$.messager.alert('提示消息',"该记录未提交，不能撤销审核！");
								return;
							}
							if(row.isuse =='1'){
								$.messager.alert('提示消息',"该记录有后续业务发生，不能撤销审核！");
								return;
							}
							$.ajax({
							   type: "post",
							   url: "/GroundGatherCheckServlet/checkgatherinfo.do",
							   data: {estateid:row.estateid,opttype:0,intotaxscopeflag:''},
							   dataType: "json",
							   success: function(jsondata){
								  $.messager.alert('返回消息',jsondata);
								  $('#groundgathercheckgrid').datagrid('reload');
							   }
							});
						}else{
							$.messager.alert('提示消息',"请选择需要撤销审核的记录！");
							return;
						}
					}
				}
				*/
				];
	Date.prototype.format = function(format,now) {
	    /*
	     * eg:format="yyyy-MM-dd hh:mm:ss";
	     */
	
	    var d = now ? (new Date(Date.parse(now.replace(/-/g,   "/")))) : this;
	    var o = {
	        "M+" : d.getMonth() + 1, // month
	        "d+" : d.getDate(), // day
	        "h+" : d.getHours(), // hour
	        "m+" : d.getMinutes(), // minute
	        "s+" : d.getSeconds(), // second
	        "q+" : Math.floor((d.getMonth() + 3) / 3), // quarter
	         "N+" : ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"][d.getDay()],
	        "S" : d.getMilliseconds()// millisecond
	    }
	
	    if (/(y+)/.test(format)) {
	        format = format.replace(RegExp.$1, (d.getFullYear() + "").substr(4
	                        - RegExp.$1.length));
	    }
	
	    for (var k in o) {
	        if (new RegExp("(" + k + ")").test(format)) {
	            format = format.replace(RegExp.$1, RegExp.$1.length == 1
	                            ? o[k]
	                            : ("00" + o[k]).substr(("" + o[k]).length));
	        }
	    }
	    return format;
	}
	
	function dateformatter(value,row,index){
		return new Date(value).format("yyyy-MM-dd");
	}
	
	$(function(){
		//$.extend($.messager.confirms,{  
		//	ok:"a",  
		//	cancel:"b"  
		//});
		
		$.ajax({
			   type: "post",
				async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				  //locationdata= jsondata;
				  for (var i = 0; i < jsondata.length; i++) {
					if(jsondata[i].key.length==9){
						var newdetail={};
						newdetail.key=jsondata[i].key;
						newdetail.value=jsondata[i].value;
						belongtocountry.push(newdetail);
					}
					if(jsondata[i].key.length==12){
						var newdetail={};
						newdetail.key=jsondata[i].key;
						newdetail.value=jsondata[i].value;
						belongtowns.push(newdetail);
					}
				}
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/TransferGroundServlet/getlevydatetypeComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				  levydatetypedata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXORGCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  orgdata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXEMPCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  empdata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_COMPARESTATE'},
			   dataType: "json",
			   success: function(jsondata){
				  statedata= jsondata;
			   }
			});
		var regex = new RegExp("\"","g");  
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#taxorgsupcode').combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							//$.messager.alert('返回消息',n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//$.messager.alert('返回消息',JSON.stringify(jsondata));
									   $('#taxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#taxorgcode').combobox({
						data : jsondata.taxOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/taxDeptOptionByOrg.do",
								   data: {"taxOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',jsondata.taxOrgOptionJsonArray[0].keyvalue);
						$('#taxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#taxdeptcode').combobox({
						data : jsondata.taxDeptOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/getTaxEmpByOrgCode.do",
								   data: {"taxDeptCode":n.key,"emptype":"30"},
								   dataType: "json",
								   success: function(jsondata){	
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}
					

				   $('#taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
				   	//分局登录 默认选中
				    var orgclass='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getUserTaxOrgVO().getOrgclass()%>';
					var taxdeptcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
					var taxempcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
					if(orgclass=='04'){
						$('#taxdeptcode').combobox("setValue",taxdeptcode);
						$('#taxmanagercode').combobox("setValue",taxempcode);
					}
//					query();
					var p = $('#groundgathercheckgrid').datagrid('getPager');  
					$(p).pagination({   
						showPageList:false,
						pageSize: 15
					});
//					var opts = $('#groundgathercheckgrid').datagrid('options');
//					opts.url = '/GroundGatherCheckServlet/getgathergroundinfo.do?taxorgsupcode=&taxorgcode&taxdeptcode='+taxdeptcode+'&taxmanagercode='+taxempcode;
	           }
	   });
			
			$('#groundgathercheckgrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				iconCls:'icon-edit',
				singleSelect:true,
				idField:'estateid',
				rownumbers:true,
				idField:'landstoreid',
				view:viewed,
				//toolbar:menu1,
				onClickRow:function(index){
					var row = $('#groundgathercheckgrid').datagrid('getSelected');
					//alert(row.state);
					$('#edit').linkbutton('enable');
					$('#check').linkbutton('enable');
					$('#cancelcheck').linkbutton('enable');
					$('#finalcheck').linkbutton('enable');
					$('#cancelfinalcheck').linkbutton('enable');
					$('#checktable').linkbutton('enable');
					if(row.state=='0'){//未提交
						$('#check').linkbutton('disable');
						$('#finalcheck').linkbutton('disable');
						$('#cancelcheck').linkbutton('disable');
						$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='1'){//未审核
						$('#finalcheck').linkbutton('disable');
						$('#cancelcheck').linkbutton('disable');
						$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='3'){//已审核
						$('#edit').linkbutton('disable');
						$('#check').linkbutton('disable');
						if(<security:authentication property='principal.taxorgcode'/>=='5301240006' || <security:authentication property='principal.taxorgcode'/>=='5301240008' ||<security:authentication property='principal.taxorgcode'/>=='5301240009'){
							$('#finalcheck').linkbutton('enable');
							$('#cancelfinalcheck').linkbutton('disable');
						}else{
							$('#finalcheck').linkbutton('disable');
							$('#cancelfinalcheck').linkbutton('disable');
						}
						//$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='5'){//已终审
						$('#edit').linkbutton('disable');
						$('#check').linkbutton('disable');
						//$('#finalcheck').linkbutton('disable');
						$('#cancelcheck').linkbutton('disable');
						$('#checktable').linkbutton('disable');
						if(<security:authentication property='principal.taxorgcode'/>=='5301240006' || <security:authentication property='principal.taxorgcode'/>=='5301240008' ||<security:authentication property='principal.taxorgcode'/>=='5301240009'){
							$('#finalcheck').linkbutton('disable');
							$('#cancelfinalcheck').linkbutton('enable');
						}else{
							$('#finalcheck').linkbutton('disable');
							$('#cancelfinalcheck').linkbutton('disable');
						}
					}
					
					//selectindex = index;
					//selectid = row.landstoreid;
				}, 
				/**
			     onDblClickRow:function(rowIndex, rowData){
			    	  showdetail();
				},
				*/
				onLoadSuccess:function(data){
					var p = $('#groundgathercheckgrid').datagrid('getPager');  
					$(p).pagination({   
						showPageList:false,
						pageSize: 15,
						displayMsg:'总户数:'+data.countpayer+'户,显示{from}到{to}, 共{total}条记录'
					});
				}
			});
			//onAfterRender
			
			$('#grounddetailwindow').window({
				onClose:function(){
					$('#grounddetailwindow').window('refresh', '../blank.jsp');
					if(showtype =='1'){
						query();
					}
				}
			});
			
			$('#landdetailgrid').datagrid({
		        rownumbers:false,//行号   
		        fitColumns:true,
				height:350,
				//checkOnSelect:true,
				//selectOnCheck:true,
		        loadMsg:'数据装载中......',    
		        singleSelect:false,//单行选取  
			    toolbar:[
			    	/**
			    	{
					text:'打印确认表',
					iconCls:'icon-search',
					handler:function(){
						var row=$('#groundgathercheckgrid').datagrid("getSelected");
						var rows=$('#landdetailgrid').datagrid("getChecked");
							$.messager.confirm('提示', '是否确认打印?', function(r){
								if (r){
									var estateid="";
									for(var i=0;i<$('#landdetailgrid').datagrid("getData").rows.length;i++){
										estateid=estateid+"estateid="+$('#landdetailgrid').datagrid("getData").rows[i].estateid+"&";
									}
									//未选中
									rows=$('#landdetailgrid').datagrid("getChecked");
									var estateid1="";
									for(var i=0;i<$('#landdetailgrid').datagrid("getData").rows.length;i++){
										var falg=0;
										for(var j=0;j<rows.length;j++){
											if($('#landdetailgrid').datagrid("getData").rows[i].estateid==rows[j].estateid)
												falg++;
										}
										if(falg==0){
											estateid1=estateid1+"estateid1="+$('#landdetailgrid').datagrid("getData").rows[i].estateid+"&";
										}
									}
									var param=estateid+estateid1+'&taxpayerid='+row.taxpayerid;
							        window.showModalDialog('detailprint.jsp?'+param, window,'dialogWidth=1100px,dialogHeight=600px,scrollbars=1');
								}
							});
					}
			    } ,
			    **/
			    {text:'确认征税范围',
					iconCls:'icon-check',
					handler:function(){
						var row=$('#groundgathercheckgrid').datagrid("getSelected");
						var rows=$('#landdetailgrid').datagrid("getChecked");
							$.messager.confirm('提示', '是否确认征税范围?', function(r){
								if (r){
									var estateid="";
									for(var i=0;i<$('#landdetailgrid').datagrid("getData").rows.length;i++){
										estateid=estateid+"estateid="+$('#landdetailgrid').datagrid("getData").rows[i].estateid+"&";
									}
									//未选中
									rows=$('#landdetailgrid').datagrid("getChecked");
									
									var estateid1="";
									for(var i=0;i<$('#landdetailgrid').datagrid("getData").rows.length;i++){
										var falg=0;
										for(var j=0;j<rows.length;j++){
											if($('#landdetailgrid').datagrid("getData").rows[i].estateid==rows[j].estateid)
												falg++;
										}
										if(falg==0){
											estateid1=estateid1+"estateid1="+$('#landdetailgrid').datagrid("getData").rows[i].estateid+"&";
										}
									}
									//alert(estateid+" --- "+estateid1);
									var param=estateid+estateid1+'&taxpayerid='+row.taxpayerid;
									
									
									var checked_row = $('#landdetailgrid').datagrid("getChecked");
									var all_row = $('#landdetailgrid').datagrid("getRows");
									var verify_data = {taxpayerid:row.taxpayerid,'checked_row':checked_row,'all_row':all_row};
									Load();
									$('#landdetail_windows').window('close');
									$.ajax({
									   type: "post",
									   url: "/GroundGatherVerifyPrintServlet/verifytax.do",
									   data: $.toJSON(verify_data),
									   contentType: "application/json; charset=utf-8",
									   dataType: "json",
									   success: function(jsondata){
										  $.messager.alert('返回消息','确认成功!');		
										  /**重新加载**/
										  $('#groundgathercheckgrid').datagrid('reload');
										  	dispalyLoad();							 
									   }
									});
								}
							});
					}
			    }
			    
			    ,{text:'关闭',
					iconCls:'icon-cancel',
					handler:function(){
						$('#landdetail_windows').window('close');
					}
			    }],
			    view:$.extend({},$.fn.datagrid.defaults.view,{
					onAfterRender: function(target){
										$('#landdetailgrid').datagrid('checkAll');//页面重新加载时取消所有选中行
						} 
					}),
		        columns:[[
								  /**		
								  {title:'是否确认',field:'landtaxflag',width:100,
								  formatter:function(value,row,index){
									  var v ;
									  if(value=='1'){
									 	 v = "<input name=\'verify_c\' type=\'checkbox\' checked onclick=\'test2(this,\'+index+\')\'/>";
									  }else{
									  	v = "<input name=\'verify_c\' type=\'checkbox\' onclick=\'test2(this,\'+index+\')\'/>";
									  }	
									  	return v;
									  }
								  },
								  */
								  {title:'',width:100,checkbox:'true'},
								  {field:'estateid',title:'土地计算机编码',width:100,hidden:'true'},   
		    			          {field:'belongtowns',title:'所属乡镇',width:100,formatter:function(value){ 
		    			        	  value=value.substring(0,9);
		    			        	  for(var i=0; i<belongtocountry.length; i++){
		    			      			if (belongtocountry[i].key == value) return belongtocountry[i].value;
		    			      		  }
		    			        	  return value;}
								  },   
		    			          {field:'x',title:'土地证号',width:135}, 
		    			          {field:'detailaddress',title:'详细地址',width:180},
		    			          {field:'holddate',title:'取得土地时间',width:100,formatter:dateformatter}, 
		    			          {field:'landarea',title:'宗地面积',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxarea',title:'应税土地面积',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}}
		    			      ]],
		    	
		    });
			
			$('#groundgathercheckgrid').datagrid({toolbar:menu2});
			
			//$('#check').linkbutton('disable'); 
			//$('#cancelcheck').linkbutton('disable'); 
		});
		var viewed = $.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
								$('#groundgathercheckgrid').datagrid('clearSelections');//页面重新加载时取消所有选中行
								} 
				});
		function query(){
			$('#groundgathercheckgrid').datagrid('loadData',{total:0,rows:[],countpayer:0});
			var params = {};
			var param='';
			var fields =$('#groundgathercheckqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
				param=param+field.name+'='+field.value+'&';
			}); 
			//alert($.toJSON(params));
			var p = $('#groundgathercheckgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#groundgathercheckgrid').datagrid('options');
			opts.url = '/GroundGatherVerifyPrintServlet/getgathergroundinfo.do';
			$('#groundgathercheckgrid').datagrid('load',params); 
			//$.messager.alert('返回消息',"1");
			$('#groundgathercheckquerywindow').window('close');
			
		}

	function showdetail(){
			var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');//获取土地信息选中行
			if(tdxxrow){
				showtype ='0';
				$('#grounddetailwindow').window('open');//打开新录入窗口
				$('#grounddetailwindow').window('refresh', '../grounddetail/groundallinfo.jsp');
			}else{
				$.messager.alert('返回消息',"请选择需要查看的土地信息！");
			}
		}	
	
	function format(row){
		for(var i=0; i<belongtocountry.length; i++){
			if (belongtocountry[i].key == row) return belongtocountry[i].value;
		}
		return row;
	};
	function formatorg(row){
		for(var i=0; i<orgdata.length; i++){
			if (orgdata[i].key == row) return orgdata[i].value;
		}
		return row;
	};
	function formatemp(row){
		for(var i=0; i<empdata.length; i++){
			if (empdata[i].key == row) return empdata[i].value;
		}
		return row;
	};
	function formatstate(row){
		for(var i=0; i<statedata.length; i++){
			if (statedata[i].key == row) return statedata[i].value;
		}
		return row;
	}
	function Load() {  
    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");  
    $("<div class=\"datagrid-mask-msg\"></div>").html("正在操作，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
	}  
  	function test2(obj,index){
  		if(obj.checked){
  			$('#landdetailgrid').datagrid('unselectRow',index);
  		}else{
  			$('#landdetailgrid').datagrid('selectRow',index);
  		}
  	}
//hidden Load   
function dispalyLoad() {  
    $(".datagrid-mask").remove();  
    $(".datagrid-mask-msg").remove();  
} 
	</script>
</head>
<body>
	<form id="groundtransferform" method="post">
		<div title="税源信息" data-options="
						tools:[{
							handler:function(){
								$('#groundgathercheckgrid').datagrid('reload');
							}
						}]">
					
						<table id="groundgathercheckgrid" style="overflow:auto" 
						> 
							<thead>
								<tr>
									
									<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<!-- <th data-options="field:'estateserial',width:100,align:'center',editor:{type:'combobox'}">宗地编号</th> -->
									<th data-options="field:'all_lands',width:200,align:'center',editor:{type:'validatebox'}">宗地总数</th>
									<th data-options="field:'verify_lands',width:200,align:'center',editor:{type:'validatebox'}">已确认征税范围宗地数量</th>
									<th data-options="field:'noverify_lands',width:200,align:'center',editor:{type:'validatebox'}">未确认征税范围宗地数量</th>
									<th data-options="field:'finally_lands',hidden:true,width:200,align:'center',editor:{type:'validatebox'}">终审宗地数量</th>
									<th data-options="field:'all_finally',hidden:true,width:200,align:'center',editor:{type:'validatebox'}"></th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="groundgathercheckquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'税源信息查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:918px;height:175px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundgathercheckqueryform" method="post">
				<table id="narjcxx" class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
					</tr>
					<tr>
						
						<td align="right">计算机编码：</td>
						<td><input id="querytaxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayerid"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="querytaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayername"/>
						</td>
						
					</tr>
					
				</table>
			</form>
			<div style="text-align:center;padding:1px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	<div id="grounddetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地明细信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:960px;height:500px;">
	</div>
	<div id="groundbusinesswindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地业务',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div>
	<div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
	
	<div id="landdetail_windows" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true">
			<div align="left"><font color="red">说明 :  选中项生成应纳税,未选中项不生成应纳税、并且在税源核实表中应纳税为0.</font></div>
			<table id="landdetailgrid" style="width:750px"></table>
	</div>
</body>
</html>