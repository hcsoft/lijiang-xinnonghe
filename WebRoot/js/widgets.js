

//部件的方法
var WidgetUtils = (function(){
	//定义私有方法
	function createWindow(divid,winwidth,winheight,wintitle){
		var oDiv = document.getElementById(divid);
		if(oDiv)
			return $(oDiv);
		var div = document.createElement("div");
	    div.id = divid;
	    div.className = "easyui-window";	    
	    div.style.width = winwidth+"px";
	    div.style.height= winheight+"px";
		document.body.appendChild(div);
		$(div).window(
	       {
	    	closed:true,modal:true,title:wintitle,collapsible:false,
	    	minimizable:false,maximizable:false,closable:true
	       }
	    );
		return $(div);
	}
	function formatterDateInner(value,row,index){
			return formatDatebox(value);
	}
    /**
     * fn为function，fn(params)
     * @param {Object} fn
     * @return {TypeName} 
     */
	function showCommonQueryHelp(fn){
		    var oDiv = document.getElementById('commonquerywindowxuhong');
			if(oDiv){
				$(oDiv).window('open');
				return;
			}
		    var commonQueryDiv = document.createElement("div");
		    commonQueryDiv.id = "commonquerywindowxuhong";
		    $(commonQueryDiv).load('/common/widgets.jsp #commonquerywindowxuhong_widget_c',null,function(text){
		    	$(commonQueryDiv).window(
			       {
			    	closed:true,modal:true,title:'查询条件',collapsible:false,
			    	minimizable:false,maximizable:false,closable:true
			       }
			    );
		    	var panel = document.getElementById("commonquerywindowxuhong_widget_panel_c");
		    	$(panel).panel({});
		    	var oa = document.getElementById("commonquerywindowxuhong_widget_a_c");
		    	oa.onclick = function(){
		    		var params = {};
					var fields =$('#commonqueryformxuhong_widget_c').serializeArray();  
					$.each(fields, function(i, field){
						params[field.name] = field.value;
					});
					var newParams = {};
					for(var p in params){
						var newP = p.substring(0,p.length-8);
						newParams[newP] = params[p];
					}
					if(fn){
						fn(newParams);
					}
					$(commonQueryDiv).window('close');
		    	};
		    	$(oa).linkbutton({
			    	text:"查询",
			    	iconCls:'icon-search'
			    });
		    	$('#taxorgsupcodexuhong_c').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxorgcodexuhong_c').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxdeptcodexuhong_c').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxmanagercodexuhong_c').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxpayeridxuhong_c').validatebox({});
		    	$('#taxpayernamexuhong_c').validatebox({});
		    	var landLink = new OrgLink("15","30",'taxorgsupcodexuhong_c','taxorgcodexuhong_c','taxdeptcodexuhong_c','taxmanagercodexuhong_c');
                landLink.sendMethod = false;
                landLink.loadData();
		    	$(commonQueryDiv).window('open');
		    });
	}
	function showEstateQueryHelp(fn){
		    var oDiv = document.getElementById('estatequeryhelpwindowxuhong_d');
			if(oDiv){
				$(oDiv).window('open');
				return;
			}
		    var commonQueryDiv = document.createElement("div");
		    commonQueryDiv.id = "estatequeryhelpwindowxuhong_d";
		    $(commonQueryDiv).load('/common/widgets.jsp #baseestatequerywindowxuhong_widget_d',null,function(text){
		    	$(commonQueryDiv).window(
			       {
			    	closed:true,modal:true,title:'查询条件',collapsible:false,
			    	minimizable:false,maximizable:false,closable:true
			       }
			    );
		    	var panel = document.getElementById("baseestatequerypanelxuhong_widget_d");
		    	$(panel).panel({});
		    	var oa = document.getElementById("baseestatequerypanelxuhong_widget_d_a");
		    	oa.onclick = function(){
		    		var params = {};
					var fields =$('#baseestatequeryformxuhong_widget_d').serializeArray();  
					$.each(fields, function(i, field){
						params[field.name] = field.value;
					});
					var newParams = {};
					for(var p in params){
						var newP = p.substring(0,p.length-8);
						newParams[newP] = params[p];
					}
					if(fn){
						fn(newParams);
					}
					$(commonQueryDiv).window('close');
		    	};
		    	$(oa).linkbutton({
			    	text:"查询",
			    	iconCls:'icon-search'
			    });
		    	$('#taxorgsupcodexuhong_d').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxorgcodexuhong_d').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxdeptcodexuhong_d').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxmanagercodexuhong_d').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#locationtypexuhong_d').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#landcertificatetypexuhong_d').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	
		    	$('#taxpayeridxuhong_d').validatebox({});
		    	$('#taxpayernamexuhong_d').validatebox({});
		    	$('#estateserialnoxuhong_d').validatebox({});
		    	$('#landcertificatexuhong_d').validatebox({});
		    	
		    	$('#beginholddatexuhong_d').datebox({});
		    	$('#endholddatexuhong_d').datebox({});
		    	
		    	CommonUtils.getLocationType("locationtypexuhong_d");
		    	CommonUtils.getLandCertificateType('landcertificatetypexuhong_d');
		    	
		    	var landLink = new OrgLink("15","30",'taxorgsupcodexuhong_d','taxorgcodexuhong_d','taxdeptcodexuhong_d','taxmanagercodexuhong_d');
                landLink.sendMethod = false;
                landLink.loadData();
		    	$(commonQueryDiv).window('open');
		    });
	}
	function showHouseInfoQueryHelp(fn){
		    var oDiv = document.getElementById('basehouseinfoqueryhelpwindowxuhong_d');
			if(oDiv){
				$(oDiv).window('open');
				return;
			}
		    var commonQueryDiv = document.createElement("div");
		    commonQueryDiv.id = "basehouseinfoqueryhelpwindowxuhong_d";
		    $(commonQueryDiv).load('/common/widgets.jsp #basehouseinfoquerywindowxuhong_widget_d',null,function(text){
		    	$(commonQueryDiv).window(
			       {
			    	closed:true,modal:true,title:'查询条件',collapsible:false,
			    	minimizable:false,maximizable:false,closable:true
			       }
			    );
		    	var panel = document.getElementById("basehouseinfoquerypanelxuhong_widget_d");
		    	$(panel).panel({});
		    	var oa = document.getElementById("basehouseinfoquerypanelxuhong_widget_d_a");
		    	oa.onclick = function(){
		    		var params = {};
					var fields =$('#basehouseinfoqueryformxuhong_widget_d').serializeArray();  
					$.each(fields, function(i, field){
						params[field.name] = field.value;
					});
					var newParams = {};
					for(var p in params){
						var newP = p.substring(0,p.length-8);
						newParams[newP] = params[p];
					}
					if(fn){
						fn(newParams);
					}
					$(commonQueryDiv).window('close');
		    	};
		    	$(oa).linkbutton({
			    	text:"查询",
			    	iconCls:'icon-search'
			    });
		    	$('#taxorgsupcodexuhong_e').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxorgcodexuhong_e').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxdeptcodexuhong_e').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	$('#taxmanagercodexuhong_e').combobox({disabled:false,panelWidth:300,panelHeight:200});
		    	
		    	$('#taxpayeridxuhong_e').validatebox({});
		    	$('#taxpayernamexuhong_e').validatebox({});
		    	$('#detailaddressxuhong_e').validatebox({});
		    	$('#housecertificatexuhong_e').validatebox({});
		    	
		    	$('#usedatebeginxuhong_e').datebox({});
		    	$('#usedateendxuhong_e').datebox({});
		    	

		    	
		    	var landLink = new OrgLink("15","30",'taxorgsupcodexuhong_e','taxorgcodexuhong_e','taxdeptcodexuhong_e','taxmanagercodexuhong_e');
                landLink.sendMethod = false;
                landLink.loadData();
		    	$(commonQueryDiv).window('open');
		    });
	}
	var obj = {
		showCommonQuery:function(fn){
		    showCommonQueryHelp(fn);
		},
		showCommonQueryCondition:function(){
			var params = {};
			var fields =$('#commonqueryformxuhong_widget_c').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			var newParams = {};
			for(var p in params){
				var newP = p.substring(0,p.length-8);
				newParams[newP] = params[p];
			}
			return newParams;
		},
		showLandStroeInfo:function(landstoreid){
			var oDiv = createWindow('landstoreinfowindowxuhong_b',660,400,'批复信息');
		    oDiv.load('/common/widgets.jsp #landstoreinfwindow_widget_b',null,function(text){
		    	
		    	$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/ploughavoidtaxmanager/selectsingleplough.do?d="+new Date(),
					  data: {"ploughid":landstoreid},
					  dataType: "json",
					  success:function(jsondata){
						  if(jsondata.sucess){
							  var landbo = jsondata.result;
							  for(var p in landbo){
								  var value = landbo[p];
								  if(p.indexOf('date') >= 0){
									  value = formatterDateInner(value);
								  }
								  $('#'+p+'xuhong_b').val(value);
							  }
							  $('#landstoreinfowindowxuhong_b').window('open');
						  }else{
							  $.messager.alert('错误','获取土地批复信息失败！','error');
						  }
					  }
			   });
		    
		    });
		},
		//显示选择批复信息,fn(rowindex,rowdata)
		showChooseLandStore:function(fn){
		    var oDiv = document.getElementById('changelandstorewindowxuhong_c');
			if(oDiv){
				$(oDiv).window('open');
				return;
			}
		    var landStoreDiv = createWindow('changelandstorewindowxuhong_c',820,440,'选择土地批复信息(双击选择)');
		    var toolDiv = document.createElement("div");
		    toolDiv.id = "choosedetailtbxuhong_c";
		    toolDiv.style.height="25px";
		    
		    var oA = document.createElement("a");
		    oA.onclick = function(){
		    	showCommonQueryHelp(function(params){
		    		var opts = $(table).datagrid('options');
				    opts.url = '/ploughavoidtaxmanager/selectplough.do?d='+new Date()+"&pagesize=10";
				    $(table).datagrid('load',params); 
		    	});
		    };
		    $(oA).linkbutton({
		    	text:"查询",
				id:"storequery",
		    	iconCls:'icon-search',
		    	plain:true
		    });
		    toolDiv.appendChild(oA);
		    var oFont = document.createElement("font");
		    oFont.color="red";
		    oFont.style.fontWeight="bold";
		    oFont.innerText = "      双击选择";
		    toolDiv.appendChild(oFont);
		    landStoreDiv.append(toolDiv);
		    
		    var tableDiv = document.createElement("div");
		    var table = document.createElement("table");
		    table.style.width="780px";
		    table.style.height="380px";
		    table.style.overflow = "scroll";
		    tableDiv.appendChild(table);
		    $(table).datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				iconCls:'icon-edit',
				singleSelect:true,
				rowStyler:settings.rowStyle,
				pageList:[10],
				columns:[[   
			        //{field:'checked',width:50,align:'center',checkbox:true,editor:{type:'checkbox'},title:'选择'},   
			        {field:'landstoreid',hidden:true,width:50,align:'center',editor:{type:'validatebox'},title:'主键'},   
					{field:'name',width:100,align:'left',editor:{type:'validatebox'},title:'批复名称'},
			        {field:'taxpayer',width:100,align:'left',editor:{type:'validatebox'},title:'计算机编码'},
			        {field:'taxpayername',width:230,align:'left',editor:{type:'validatebox'},title:'纳税人名称'},
			        {field:'approvedate',width:100,align:'left',formatter:formatterDateInner,editor:{type:'validatebox'},title:'批复日期'},
					{field:'areatotal',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'批复总面积'},
					{field:'areasell',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'已出让面积'},
					{field:'areaplough',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'农用地面积'},
					//{field:'areaploughfreetax',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'农用地免税面积'},
					{field:'areabuild',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'建设用地面积'},
					{field:'areauseless',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'未利用地面积'},
					//{field:'areaploughtaxpay',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'已缴纳耕地占用税面积'},
					//{field:'areaploughtax',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'耕地占用税应税面积'},
					{field:'taxprice',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'耕地占用税单位税额'}
					//{field:'district',width:100,align:'left',editor:{type:'validatebox'},title:'行政区'},
					//{field:'name',width:175,align:'left',editor:{type:'validatebox'},title:'项目名称'}
			    ]],
			    onDblClickRow:function(rowIndex,rowData){
		    	    if(fn){
						openAdd();
		    	    	fn(rowIndex,rowData);
		    	    }
		    	    landStoreDiv.window('close');
			    },
				onOpen:function(){
					//$('#storequery').click();
				}
			});
		    var p = $(table).datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
			 });
		    landStoreDiv.append($(tableDiv));
		    landStoreDiv.window('open');
		    var paramsArg = {};
		   // paramsArg['pagesize'] = 10;
			var opts = $(table).datagrid('options');
		    opts.url = '/ploughavoidtaxmanager/selectplough.do?d='+new Date()+"&pagesize=10";
		    $(table).datagrid('load',paramsArg); 
		    
		},
		//根据estateid显示土地信息
		showEstate:function(estateid){
		    var estateDiv = createWindow('estateinfowindowxuhong',660,500,'土地信息');
		    estateDiv.load('/common/widgets.jsp #estateinfowindowxuhongsub_widget',null,function(text){
		    	$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/landavoidtaxmanager/selectsingleland.do?d="+new Date(),
					  data: {"estateid":estateid},
					  dataType: "json",
					  success:function(jsondata){
						  if(jsondata.sucess){
							  var landbo = jsondata.result;
							  for(var p in landbo){
								  var value = landbo[p];
								  if(p.indexOf('date') >= 0){
									  value = formatterDateInner(value);
								  }
								  $('#'+p+'xuhong_a').val(value);
							  }
							  $('#estateinfowindowxuhong').window('open');
						  }else{
							  $.messager.alert('错误','获取土地信息失败！','error');
						  }
					  }
			   });
		    });
		    
		},
		showBaseHouse:function(houseid){
		    var houseDiv = createWindow('basehouseinfowindowxuhong',660,350,'房产信息');
		    houseDiv.load('/common/widgets.jsp #basehouseinfowindowxuhongsub_widget',null,function(text){
		    	$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/houseregister/get.do?d="+new Date(),
					  data: {"key":houseid,"houseregistertype":"1"},
					  dataType: "json",
					  success:function(jsondata){
						  if(jsondata.sucess){
							  var housebo = jsondata.result;
							  for(var p in housebo){
								  var value = housebo[p];
								  if(p.indexOf('date') >= 0){
									  value = formatterDateInner(value);
								  }
								  $('#'+p+'_xuhongf').val(value);
							  }
							  $('#basehouseinfowindowxuhong').window('open');
						  }else{
							  $.messager.alert('错误','获取房产信息失败！','error');
						  }
					  }
			   });
		    });
		    
		},
		showChooseBaseEstate:function(fn){
			var oDiv = document.getElementById('chooseestatewindowxuhong_d');
			if(oDiv){
				$(oDiv).window('open');
				return;
			}
		    var landStoreDiv = createWindow('chooseestatewindowxuhong_d',800,450,'选择土地(双击选择)');
		    var toolDiv = document.createElement("div");
		    toolDiv.id = "chooseestatedetailtbxuhong_d";
		    toolDiv.style.height="25px";
		    
		    var oA = document.createElement("a");
		    oA.onclick = function(){
		    	showEstateQueryHelp(function(params){
		    		var opts = $(table).datagrid('options');
				    opts.url = '/landavoidtaxmanager/selectland.do?d='+new Date()+"&pagesize=10";
				    $(table).datagrid('load',params); 
		    	});
		    };
		    $(oA).linkbutton({
		    	text:"查询",
				id:"landquery",
		    	iconCls:'icon-search',
		    	plain:true
		    });
		    toolDiv.appendChild(oA);
		    var oFont = document.createElement("font");
		    oFont.color="red";
		    oFont.style.fontWeight="bold";
		    oFont.innerText = "      双击选择";
		    toolDiv.appendChild(oFont);
		    landStoreDiv.append(toolDiv);
		    
		    var tableDiv = document.createElement("div");
		    var table = document.createElement("table");
		    table.style.width="780px";
		    table.style.height="380px";
		    table.style.overflow = "scroll";
		    tableDiv.appendChild(table);
		    $(table).datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				iconCls:'icon-edit',
				singleSelect:true,
				selectOnCheck:true,
				rowStyler:settings.rowStyle,
				pageList:[10],
				columns:[[   
					{field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'},title:'主键'},
					{field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'},title:'计算机编码'},
					{field:'taxpayername',width:230,align:'left',editor:{type:'validatebox'},title:'纳税人名称'},
					{field:'estateserialno',width:100,align:'left',editor:{type:'validatebox'},title:'宗地编号'},
					{field:'landcertificatetypename',width:175,align:'left',editor:{type:'validatebox'},title:'土地证类型'},
					{field:'landcertificate',width:175,align:'left',editor:{type:'validatebox'},title:'土地证号'},
					{field:'locationtypename',width:175,align:'left',editor:{type:'validatebox'},title:'坐落地类型'},
					{field:'belongtocountryname',width:175,align:'left',editor:{type:'validatebox'},title:'所属村委会'},
					{field:'detailaddress',width:250,align:'left',editor:{type:'validatebox'},title:'详细地址'},
					{field:'holddate',width:120,align:'left',formatter:formatterDate,editor:{type:'validatebox'},title:'交付日期'},
					{field:'landmoney',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'土地总价'},
					{field:'landarea',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'土地面积'},
					{field:'landunitprice',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'},title:'土地单价'}
			    ]],
			    onDblClickRow:function(rowIndex,rowData){
		    	    if(fn){
						openAdd();
		    	    	fn(rowIndex,rowData);
		    	    }
		    	    landStoreDiv.window('close');
			    }
			});
		    var p = $(table).datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
			 });
		    landStoreDiv.append($(tableDiv));
		    landStoreDiv.window('open');
		    var paramsArg = {};
		   // paramsArg['pagesize'] = 10;
			var opts = $(table).datagrid('options');
		    opts.url = '/landavoidtaxmanager/selectland.do?d='+new Date()+"&pagesize=10";
		    $(table).datagrid('load',paramsArg); 
		},
		showChooseTaxpayerInfo:function(fn){
			var oDiv = document.getElementById('choosetaxpayerwindowxuhong_d');
			if(oDiv){
				$(oDiv).window('open');
				return;
			}
		    var taxpayerDiv = createWindow('choosetaxpayerwindowxuhong_d',700,430,'选择纳税人(双击选择)');
		    var toolDiv = document.createElement("div");
		    toolDiv.id = "choosetaxpayerdetailtbxuhong_d";
		    toolDiv.style.height="25px";
		    
		    var oA = document.createElement("a");
		    oA.onclick = function(){
		    	showCommonQueryHelp(function(params){
		    		var opts = $(table).datagrid('options');
				    opts.url = '/housecontrol/selecttaxpayer.do?d='+new Date()+"&pagesize=10";
				    $(table).datagrid('load',params); 
		    	});
		    };
		    $(oA).linkbutton({
		    	text:"查询",
		    	iconCls:'icon-search',
		    	plain:true
		    });
		    toolDiv.appendChild(oA);
		    var oFont = document.createElement("font");
		    oFont.color="red";
		    oFont.style.fontWeight="bold";
		    oFont.innerText = "      双击选择";
		    toolDiv.appendChild(oFont);
		    taxpayerDiv.append(toolDiv);
		    
		    var tableDiv = document.createElement("div");
		    var table = document.createElement("table");
		    table.style.width="680px";
		    table.style.height="360px";
		    table.style.overflow = "scroll";
		    tableDiv.appendChild(table);
		    $(table).datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				iconCls:'icon-edit',
				singleSelect:true,
				rowStyler:settings.rowStyle,
				pageList:[10],
				columns:[[   
					{field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'},title:'计算机编码'},
					{field:'taxpayername',width:230,align:'left',editor:{type:'validatebox'},title:'纳税人名称'},
					{field:'taxcerno',width:110,align:'left',editor:{type:'validatebox'},title:'纳税人识别号'},
					{field:'legalpersonname',width:175,align:'left',editor:{type:'validatebox'},title:'法人代表'},
					{field:'busimanageaddr',width:175,align:'left',editor:{type:'validatebox'},title:'企业地址'},
			    ]],
			    onDblClickRow:function(rowIndex,rowData){
		    	    if(fn){
		    	    	fn(rowIndex,rowData);
		    	    }
		    	    taxpayerDiv.window('close');
			    }
			});
		    var p = $(table).datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
			 });
		    taxpayerDiv.append($(tableDiv));
		    taxpayerDiv.window('open');
		    var paramsArg = {};
		   // paramsArg['pagesize'] = 10;
			var opts = $(table).datagrid('options');
		    opts.url = '/housecontrol/selecttaxpayer.do?d='+new Date()+"&pagesize=10";
		    $(table).datagrid('load',paramsArg); 
		},
		showChooseBaseHouseInfo:function(fn,querycondition){
			var oDiv = document.getElementById('choosebasehouseinfowindowxuhong_d');
			if(oDiv){
				var url = '/housecontrol/selecthouseinfo.do?d='+new Date()+"&pagesize=10";
			    for(var p in querycondition){
			    	url = url + '&'+p+'='+querycondition[p];
			    }
			    $('#houseinfoselecttable').datagrid('loadData',[]);
				var opts = $('#houseinfoselecttable').datagrid('options');
			    opts.url = url;
			    $('#houseinfoselecttable').datagrid('load',paramsArg); 
				$(oDiv).window('open');
				return;
			}
		    var taxpayerDiv = createWindow('choosebasehouseinfowindowxuhong_d',700,430,'选择房产(双击选择)');
		    var toolDiv = document.createElement("div");
		    toolDiv.id = "choosebasehouseinfowindowxuhong_d";
		    toolDiv.style.height="25px";
		    
		    var oA = document.createElement("a");
		    oA.onclick = function(){
		    	showHouseInfoQueryHelp(function(params){
		    		for(var p in querycondition){
		    	       params[p]= querycondition[p];
		            }
		    		var opts = $(table).datagrid('options');
				    opts.url = '/housecontrol/selecthouseinfo.do?d='+new Date()+"&pagesize=10";
				    $(table).datagrid('load',params); 
		    	});
		    };
		    $(oA).linkbutton({
		    	text:"查询",
		    	iconCls:'icon-search',
				id:'housequery',
		    	plain:true
		    });
		    toolDiv.appendChild(oA);
		    var oFont = document.createElement("font");
		    oFont.color="red";
		    oFont.style.fontWeight="bold";
		    oFont.innerText = "      双击选择";
		    toolDiv.appendChild(oFont);
		    taxpayerDiv.append(toolDiv);
		    
		    var tableDiv = document.createElement("div");
		    var table = document.createElement("table");
		    table.id = "houseinfoselecttable";
		    table.style.width="680px";
		    table.style.height="360px";
		    table.style.overflow = "scroll";
		    tableDiv.appendChild(table);
		    $(table).datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				iconCls:'icon-edit',
				singleSelect:true,
				rowStyler:settings.rowStyle,
				pageList:[10],
				columns:[[   
				    {field:'houseid',hidden:true,width:100,align:'center',editor:{type:'validatebox'},title:'主键'},
					{field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'},title:'计算机编码'},
					{field:'taxpayername',width:210,align:'left',editor:{type:'validatebox'},title:'纳税人名称'},
					{field:'usedate',width:120,align:'center',formatter:formatterDate,editor:{type:'validatebox'},title:'投入使用日期'},
					{field:'housearea',width:110,align:'left',editor:{type:'validatebox'},title:'房产建筑面积'},
					{field:'housetaxoriginalvalue',width:175,align:'left',editor:{type:'validatebox'},title:'房产原值'},
					{field:'housesourcename',width:155,align:'left',editor:{type:'validatebox'},title:'房产来源'},
					{field:'housecertificate',width:125,align:'left',editor:{type:'validatebox'},title:'房产证号'}
			    ]],
			    onDblClickRow:function(rowIndex,rowData){
		    	    if(fn){
						openAdd();
		    	    	fn(rowIndex,rowData);
		    	    }
		    	    taxpayerDiv.window('close');
			    }
			});
		    var p = $(table).datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
			 });
		    taxpayerDiv.append($(tableDiv));
		    taxpayerDiv.window('open');
		    var paramsArg = {};
		    var url = '/housecontrol/selecthouseinfo.do?d='+new Date()+"&pagesize=10";
		    for(var p in querycondition){
		    	url = url + '&'+p+'='+querycondition[p];
		    }
		    $(table).datagrid('loadData',[]);
		    //alert(paramsArg['ownflag']+"="+paramsArg['state']+"="+paramsArg['valid']);
			var opts = $(table).datagrid('options');
		    opts.url = url;
		    $(table).datagrid('load',paramsArg); 
		}
	};
	return obj;
}());
