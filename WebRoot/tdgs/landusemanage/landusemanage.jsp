<%@ page contentType="text/html; charset=UTF-8"%>

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
<script type="text/javascript">
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
	$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	}); 
	
	var landsourcedata = new Object;//宗地来源
	var busdata = new Object;//业务类型
	function getNameByCode(list,code){
		for(var i=0; i<list.length; i++){
			if (list[i].key == code) return list[i].value;
		}
		return code;
	};
	
	function landinfoquery(){
		
		if(!$('#holddatebegin').datebox('isValid')){
			$.messager.alert('返回消息','使用权转移时间起校验有误！');
			return;
		}
		if(!$('#holddateend').datebox('isValid')){
			$.messager.alert('返回消息','使用权转移时间止校验有误！');
			return;
		}
		
		$('#landinfo').datagrid('loadData',{total:0,rows:[]});
		var p = $('#landinfo').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#landinfo').datagrid('options');
		opts.url = '/landusemanageservice/landinfoquery.do';
		$('#landinfo').datagrid('load',{taxorgsupcode:$('#taxorgsupcode').combobox("getValue"),
			  taxorgcode:$('#taxorgcode').combobox("getValue"),
			  taxdeptcode:$('#taxdeptcode').combobox("getValue"),
			  taxmanagercode:$('#taxmanagercode').combobox("getValue"),
			  taxpayerid:$("#taxpayerid").val(),
			  taxpayername:$("#taxpayername").val(),
			  taxpayerid_bus:$("#taxpayerid_bus").val(),
			  taxpayername_bus:$("#taxpayername_bus").val(),
			  holddatebegin:$('#holddatebegin').datebox('getValue'),
			  holddateend:$('#holddateend').datebox('getValue')}); 
		
		$('#query_windows').window('close');
	}
	
	function detailwindow(){
		var rows=$('#landinfo').datagrid("getSelected");
		if(undefined==rows ||  null==rows ){
			$.messager.alert("提示","请选择房产信息!");
			return;
		}
		$('#detail_windows').window('open');
		landbusquery();
	}
	
	function landbusquery(){
		var rows=$('#landinfo').datagrid("getSelected");
		if(undefined==rows ||  null==rows ){
			$.messager.alert("提示","请选择房产信息!");
			return;
		}
		
		$('#detailgrid').datagrid('loadData',{total:0,rows:[]});
		var p = $('#detailgrid').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 10
		});
		var opts = $('#detailgrid').datagrid('options');
		opts.url = '/landusemanageservice/landbusquery.do';
		$('#detailgrid').datagrid('load',{estateid:rows.estateid}); 
		
	}
	
	
	
	function inputwindow(businesscode){
		var rows=$('#landinfo').datagrid("getSelected");
		if(undefined==rows ||  null==rows ){
			$.messager.alert("提示","请选择房产信息!");
			return;
		}
		
		var bus_rows=$('#detailgrid').datagrid("getSelected");
		if(businesscode==32){//转租
			if(undefined==bus_rows ||  null==bus_rows ){
				$.messager.alert("提示","请选择要转租的使用权转移信息!");
				return;
			}
			var num=0;
			for(var i=0;i<$('#detailgrid').datagrid("getData").total;i++){
				if($('#detailgrid').datagrid("getData").rows[i].businesstype=="31" || 
						$('#detailgrid').datagrid("getData").rows[i].businesstype=="32"){
					num=num++;
				}
	    	}
			if(num==0){
				$.messager.alert("提示","需要有出租或转租信息才能进行转租!");
				return;
			}
		}
		
		if(businesscode==31 || businesscode==32){//出租 转租
			$('#input_money_title').text("年租金");
			if(businesscode==31)
				$('#input_area_title').text("约定缴纳土地使用税面积");
			else if(businesscode==32)
				$('#input_area_title').text("约定缴纳土地使用税面积");
		}
		else{
			$('#input_money_title').text("转移总价");
			$('#input_area_title').text("转移面积");
		}
		
		$('#input_taxpayerid').val('');
    	$('#input_taxpayername').val('');
    	$('#input_area').numberbox('setValue','');
    	$('#input_money').numberbox('setValue','');
    	$('#input_holddate').datebox('setValue','');
    	$('#input_taxdatebegin').datebox('setValue','');
    	$('#input_taxdateend').datebox('setValue','');
    	$('#input_protocolnumber').val('');
    	$('#input_remark').val('');
    	$('#input_purpose').combobox('setValue','');
    	
    	var usearea=rows.taxarea;
    	var busarea=0;
    	
//    	$('#detailgrid').datagrid("getData").total
    	for(var i=0;i<$('#detailgrid').datagrid("getData").total;i++){
    		busarea=busarea+$('#detailgrid').datagrid("getData").rows[i].landtaxarea;
    	}
    	
    	if(businesscode==32){//转租
    		usearea=bus_rows.landtaxarea;
    		$('#input_busid').val(bus_rows.busid);
    	}else{
    		usearea=usearea-busarea;
    		$('#input_busid').val('');
    	}
    	
    	if(usearea<=0){
    		$.messager.alert("提示","没有可转移的面积!");
			return;
    	}
    	
    	$('#input_usearea').numberbox('setValue',usearea);
		
//		$('#input_taxdatebegin').datebox('setValue',new Date().format("yyyy-MM-dd"));
		
		$('#input_businesscode').val(businesscode);
		
		$('#input_windows').window('open');
	}
	
	function regwindow(){
		$('#reg_windows').window('open');
	}
	
	function regquery(){
		var params = {};
		params.taxpayerid = $('#query_taxpayerid').val();
		params.taxpayername = $('#query_taxtypename').val();
		params.orgunifycode = '';
		var p = $('#reginfogrid').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 10
		});
		var opts = $('#reginfogrid').datagrid('options');
		opts.url = '/InitGroundServlet/getreginfo.do';
		$('#reginfogrid').datagrid('load',params); 
	}
	
	function reginput(){
		var rows=$('#reginfogrid').datagrid("getSelected");
		$('#input_taxpayerid').val(rows.taxpayerid);
		$('#input_taxpayername').val(rows.taxpayername);
		$('#reg_windows').window('close');
	}
	
	
	function landbussave(){
		if(null==$('#input_taxpayerid').val() || ''==$('#input_taxpayerid').val()){
			$.messager.alert("提示","计算机编码不允许为空");
			return;
		}
		if(!$('#input_purpose').combobox('isValid')){
			$.messager.alert("提示","土地用途不允许为空");
			return;
		}
		if(null==$('#input_money').numberbox('getValue')|| ''==$('#input_money').numberbox('getValue')){
			$.messager.alert("提示","金额不允许为空");
			return;
		}	
		if(null==$('#input_area').numberbox('getValue') || ''==$('#input_area').numberbox('getValue')){
			$.messager.alert("提示","面积不允许为空");
			return;
		}
		input_holddate
		
		if(null==$('#input_holddate').datebox('getValue') || ''==$('#input_holddate').datebox('getValue')){
			$.messager.alert("提示","获得土地时间不允许为空");
			return;
		}
		if(null==$('#input_taxdatebegin').datebox('getValue') || ''==$('#input_taxdatebegin').datebox('getValue')){
			$.messager.alert("提示","使用时间起不允许为空");
			return;
		}
		if(null==$('#input_taxdateend').datebox('getValue') || ''==$('#input_taxdateend').datebox('getValue')){
			$.messager.alert("提示","使用时间止不允许为空");
			return;
		}
		if(!$('#input_holddate').datebox('isValid')){
			$.messager.alert("提示","时间起校验有误！");
			return;
		}
		if(!$('#input_taxdatebegin').datebox('isValid')){
			$.messager.alert("提示","时间起校验有误！");
			return;
		}
		if(!$('#input_taxdateend').datebox('isValid')){
			$.messager.alert("提示","时间止校验有误！");
			return;
		}
		
		if($('#input_holddate').datebox('getValue')>new Date().format("yyyy-MM-dd")){
			$.messager.alert("提示","获得土地时间止不允许大于当前日期");
			return;
		}
		if($('#input_taxdateend').datebox('getValue')<new Date().format("yyyy-MM-dd")){
			$.messager.alert("提示","使用时间止不允许小于当前日期");
			return;
		}
		if($('#input_taxdatebegin').datebox('getValue')>$('#input_taxdateend').datebox('getValue')){
			$.messager.alert("提示","使用时间起不允许大于时间止");
			return;
		}
		if($('#input_area').numberbox('getValue')>$('#input_usearea').numberbox('getValue')){
			$.messager.alert("提示","面积不允许大于可用面积");
			return;
		}
		
		$.messager.confirm('提示', '是否确保存?', function(r){
			if (r){
				$.ajax({
					type: 'POST',
			        url: "/landusemanageservice/landbussave.do",
			        data: {
				        	businesscode:$('#input_businesscode').val(),
				        	busid:$('#input_busid').val(),
				        	estateid:$('#landinfo').datagrid("getSelected").estateid,
				        	taxpayerid:$('#input_taxpayerid').val(),
				        	taxpayername:$('#input_taxpayername').val(),
				        	landtaxarea:$('#input_area').numberbox('getValue'),
				        	landamount:$('#input_money').numberbox('getValue'),
				        	holddate:$('#input_holddate').datebox('getValue'),
				        	limitbegin:$('#input_taxdatebegin').datebox('getValue'),
				        	limitend:$('#input_taxdateend').datebox('getValue'),
				        	protocolnumber:$('#input_protocolnumber').val(),
				        	purpose:$('#input_purpose').combobox('getValue'),
				        	remark:$('#input_remark').val()
			        	},
			       	dataType: "json",
			        success: function (data) {
			        		$.messager.alert("提示",data);
			        		landbusquery();
			        		$('#input_windows').window('close');
			        }
			    });
			}
		});
	}
	
	
	function busremove(){
		var bus_rows=$('#detailgrid').datagrid("getSelected");
		if(undefined==bus_rows ||  null==bus_rows ){
			$.messager.alert("提示","请选择要撤销的使用权转移信息!");
			return;
		}
		if(bus_rows.state!=0){
			$.messager.alert("提示","请先撤销审核!");
			return;
		}
		$.messager.confirm('提示', '是否确认撤销业务?', function(r){
			if (r){
				$.ajax({
					type: 'POST',
			        url: "/landusemanageservice/landbusremove.do",
			        data: {
				        	busid:bus_rows.busid
			        	},
			       	dataType: "json",
			        success: function (data) {
			        		$.messager.alert("提示",data);
			        		landbusquery();
			        }
			    });
			}
		});
		
	}
	
	function taxsourcesave(){
		var bus_rows=$('#detailgrid').datagrid("getSelected");
		if(undefined==bus_rows ||  null==bus_rows ){
			$.messager.alert("提示","请选择要审核的使用权转移信息!");
			return;
		}
		if(bus_rows.state!=0){
			$.messager.alert("提示","使用权转移信息已审核过!");
			return;
		}
		$.messager.confirm('提示', '是否确认审核?', function(r){
			if (r){
					$.messager.confirm('提示', '是否生成应纳税?', function(r){
							var taxflag;
							if (r){
									taxflag='1';
								}else{
									taxflag='0';	
								}
							$.ajax({
								type: 'POST',
						        url: "/landusemanageservice/taxsourcesave.do",
						        data: {
							        	busid:bus_rows.busid,
							        	taxflag:taxflag
						        	},
						       	dataType: "json",
						        success: function (data) {
						        		$.messager.alert("提示",data);
						        		landbusquery();
						        }
						    });
				  	});
				}
			});
		
	}
	
	function taxsourceremove(){
		var bus_rows=$('#detailgrid').datagrid("getSelected");
		if(undefined==bus_rows ||  null==bus_rows ){
			$.messager.alert("提示","请选择要撤销的使用权转移信息!");
			return;
		}
		if(bus_rows.state==2){
			$.messager.alert("提示","有后续业务发生不允许撤销审核!");
			return;
		}
		$.messager.confirm('提示', '是否确认撤销业务?', function(r){
			if (r){
				$.ajax({
					type: 'POST',
			        url: "/landusemanageservice/taxsourceremove.do",
			        data: {
				        	busid:bus_rows.busid
			        	},
			       	dataType: "json",
			        success: function (data) {
			        		$.messager.alert("提示",data);
			        		landbusquery();
			        }
			    });
			}
		});
	}
	
	$(function(){
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
	           }
	   });
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_GROUNDSOURCECODE'},
			   dataType: "json",
			   success: function(jsondata){
				   landsourcedata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_BUSINESS'},
			   dataType: "json",
			   success: function(jsondata){
				   busdata = jsondata;
			   }
			});
		
		 $('#landinfo').datagrid({
		        rownumbers:false,//行号   
		        fitColumns:true,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    toolbar:[{
						text:'查询',
						iconCls:'icon-search',
						handler:function(){
								$('#query_windows').window('open');
							}
			           },{
							text:'使用权转移信息',
							iconCls:'icon-viewdetail',
							handler:function(){
								detailwindow();
							}
						}
					],
		        columns:[[
		    			          {field:'estateid',title:'土地主键',hidden:'true'},   
		    			          {field:'landsource',title:'宗地来源',width:90, formatter:function(value){return getNameByCode(landsourcedata,value);}},   
		    			          {field:'estateserialno',title:'宗地编号',width:100},
		    			          {field:'landcertificate',title:'土地证号',width:100},   
		    			          {field:'detailaddress',title:'坐落地详细地址',width:180},  
		    			          {field:'taxpayerid',title:'土地使用人计算机编码',width:90},
		    			          {field:'taxpayername',title:'土地使用人名称',width:150},
		    			          {field:'holddate',title:'实际交付时间',width:90}, 
		    			          {field:'taxarea',title:'使用权面积',width:80,align:'right',formatter:function(value){ return Number(value).toFixed(2);}}
		    			         
		    			      ]],
		        onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
//						 $('#landinfo').datagrid('options').url ="";
//						 $.messager.alert("提示","无查询结果!");
					}
			      }, 
			      onDblClickRow:function(rowIndex, rowData){
			    	  detailwindow();
			      } 
			    
		    }); 
		 $('#detailgrid').datagrid({
		        rownumbers:true,//行号   
		        fitColumns:true,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    toolbar:[{
							text:'土地融资租赁',
							iconCls:'icon-business1',
							handler:function(){
								inputwindow(24);
							}
						}
			           ,{
							text:'土地出典',
							iconCls:'icon-business2',
							handler:function(){
								inputwindow(25);
							}
						}
			           ,{
							text:'土地出租',
							iconCls:'icon-business3',
							handler:function(){
								inputwindow(31);
							}
						},{
							text:'土地转租',
							iconCls:'icon-business4',
							handler:function(){
								inputwindow(32);
							}
						},{
							text:'使用权转移撤销',
							iconCls:'icon-remove',
							handler:function(){
								busremove();
							}
						},{
							text:'土地使用权转移审核',
							iconCls:'icon-check',
							handler:function(){
								//是否生成应税
								taxsourcesave();
							}
						},{
							text:'撤销审核',
							iconCls:'icon-uncheck',
							handler:function(){
								//删除 税源 应税
								taxsourceremove();
							}
						},{
							text:'关闭',
							iconCls:'icon-cancel',
							handler:function(){
								$('#detail_windows').window('close');
							}
						}
					],
		        columns:[[
								  {field:'busid',title:'业务主键',hidden:'true'},
		    			          {field:'estateid',title:'土地主键',hidden:'true'},   
		    			          {field:'businesstype',title:'业务类型',width:80,formatter:function(value){return getNameByCode(busdata,value);}},
		    			          {field:'state',title:'状态',width:80, formatter:function(value){return value==0?"未审核":"已审核";}},
		    			          {field:'lessorid',title:'转出方计算机编码',width:110},
		    			          {field:'lessortaxpayername',title:'转出方名称',width:150},
		    			          {field:'lesseesid',title:'转入方计算机编码',width:110},
		    			          {field:'lesseestaxpayername',title:'转入方名称',width:150},
		    			          {field:'landtaxarea',title:'转移计税面积',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'landamount',title:'转移总价/年租金',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'limitbegin',title:'使用时间起',width:90},
		    			          {field:'limitend',title:'使用时间止',width:80,align:'right'}
		    			         
		    			      ]],
		        onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
//						 $('#landinfo').datagrid('options').url ="";
//						 $.messager.alert("提示","无查询结果!");
					}
			      }, 
			      onDblClickRow:function(rowIndex, rowData){
//			    	  matchwindows();
			      } 
			    
		    }); 
		 
		 $('#reginfogrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:{  
			        pageSize: 10,
					showPageList:false
			    },
			    onDblClickRow:function(rowIndex, rowData){
			    	reginput();
			    },
			    onLoadSuccess:function(data){  
					$(this).datagrid('selectRow',0);//自动选择第一行
			    }
			});
	    $('#reginfogrid').datagrid('getPager').pagination({  
	    	pageSize: 10,
			showPageList:false
		});
	})
</script>
</head>

<body class="easyui-layout">   
    <div data-options="region:'center',title:''" style="padding:3px;">
			<div>
			<table id="landinfo" title="土地基础信息"  >  
			</table>  
			</div>
			<div id="query_windows" class="easyui-window" data-options="closed:true,modal:true,title:'查询条件',collapsible:false,minimizable:false,maximizable:false,closable:true">
					<div style="text-align:center;padding:5px;">  
					<table  class="table table-bordered">
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
							<td align="right">土地使用人计算机编码 ：</td>
							<td>
								<input  name="taxpayerid"  id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px"/>					
							</td>
							<td align="right">土地使用人纳税人名称 ：</td>
							<td>
								<input  name="taxpayername"  id="taxpayername" class="easyui-validatebox" type="text" style="width:200px"/>					
							</td>
						</tr>
						<tr>
							<td align="right">承受方计算机编码 ：</td>
							<td>
								<input name="taxpayerid_bus"  id="taxpayerid_bus" class="easyui-validatebox" type="text" style="width:200px" />	
							</td>
							<td align="right">土承受方纳税人名称 ：</td>
							<td>
								<input name="taxpayername_bus" id="taxpayername_bus" class="easyui-validatebox" type="text" style="width:200px" />					
							</td>
						</tr>
						<tr>
							<td align="right">使用权转移时间起 ：</td>
							<td>
								<input type="text" id="holddatebegin" name="input_taxdatebegin" class="easyui-datebox" style="width:200px" data-options="validType:'datecheck'"/>				

							</td>
							<td align="right">使用权转移时间止 ：</td>
							<td>
								<input type="text" id="holddateend" name="input_taxdatebegin" class="easyui-datebox" style="width:200px" data-options="validType:'datecheck'"/>				
							</td>
						</tr>
					</table>
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="landinfoquery()" >查询</a>
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#query_windows').window('close');" >关闭</a>
					</div>
				</div>
				<div id="detail_windows" class="easyui-window" data-options="closed:true,modal:true,title:'使用权转移信息',collapsible:false,minimizable:false,maximizable:false,closable:true">
						<table id="detailgrid" style="width:900px;height:380px"></table>
				</div>
				<div id="input_windows" class="easyui-window" data-options="closed:true,modal:true,title:'土地使用权管理',collapsible:false,minimizable:false,maximizable:false,closable:true">
					<div style="text-align:center;padding:5px;">  
					<table  class="table table-bordered">
						<tr>
							<td></td>
							<td>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regwindow()" >纳税人查询</a>				
							</td>
						</tr>
						<tr>
							<td align="right">承受方计算机编码 ：</td>
							<td>
								<input  name="input_taxpayerid"  id="input_taxpayerid" readOnly="true" class="easyui-validatebox" type="text" style="width:200px" data-options="required:true"/>
							</td>
						</tr>
						<tr>
							<td align="right">承受方纳税人名称 ：</td>
							<td>
								<input  name="input_taxpayername"  id="input_taxpayername" readOnly="true" class="easyui-validatebox" type="text" style="width:200px" data-options="required:true"/>	
								<input  name="input_businesscode"  id="input_businesscode" class="easyui-validatebox" type="hidden" style="width:200px"/>	
								<input  name="input_busid"  id="input_busid" class="easyui-validatebox" type="hidden" style="width:200px"/>
										
							</td>
						</tr>
						<tr>
							<td align="right">协议书号：</td>
							<td>
								<input  name="input_protocolnumber"  id="input_protocolnumber"  class="easyui-validatebox" type="text" style="width:200px"/>	
							</td>
						</tr>
						<tr>
							<td align="right">用途：</td>
							<td>
								<input id="input_purpose" name="input_purpose" style="width:200px;" class="easyui-combobox" editable='false' data-options="
									valueField: 'key',
									textField: 'value',
									required:'true',
									url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDUSECODE'" />	
							</td>
						</tr>
						<tr>
							<td align="right" id="input_money_title" >转移总价：</td>
							<td>
								<input  name="input_money"  id="input_money" class="easyui-numberbox" data-options="min:0,precision:2,required:true" type="text" style="width:200px"/>			
							</td>
						</tr>
						<tr>
							<td align="right" id="input_area_title">转移面积：</td>
							<td>
								<input  name="input_area"  id="input_area" class="easyui-numberbox" data-options="min:1,precision:2,required:true" type="text" style="width:200px"/>				
							</td>
						</tr>
						<tr>
							<td align="right">可用面积：</td>
							<td>
								<input  name="input_usearea"  id="input_usearea" class="easyui-numberbox" readOnly="true" data-options="min:0,precision:2" type="text" style="width:200px"/>				
							</td>
						</tr>
						<tr>
							<td align="right">获得土地时间：</td>
							<td>
								<input type="text" id="input_holddate" name="input_holddate" class="easyui-datebox" style="width:200px" data-options="required:true,validType:'datecheck'"/>				
							</td>
						</tr>
						<tr>
							<td align="right">使用时间起：</td>
							<td>
								<input type="text" id="input_taxdatebegin" name="input_taxdatebegin" class="easyui-datebox" style="width:200px" data-options="required:true,validType:'datecheck'"/>				
							</td>
						</tr>
						<tr>
							<td align="right">使用时间止：</td>
							<td>
								<input type="text" id="input_taxdateend" name="input_taxdateend" class="easyui-datebox" style="width:200px" data-options="required:true,validType:'datecheck'"/>
							</td>
						</tr>
						<tr>
							<td align="right">备注：</td>
							<td>
								<textarea id="input_remark" cols="40" rows="3" class="easyui-validatebox" style="width:200px"></textarea>
							</td>
						</tr>
					</table>
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="landbussave()" >保存</a>
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#input_windows').window('close');" >关闭</a>
					</div>
				</div>
				<div id="reg_windows" class="easyui-window" data-options="closed:true,modal:true,title:'手工匹配',collapsible:false,minimizable:false,maximizable:false,closable:true">
						<div style="text-align:left;padding:5px;">  
							<div style="background-color: #c9c692;height: 25px;">		
									<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
									<span style="font-size: 12px;">
									计算机编码<input  type="text" style="width:120px" id="query_taxpayerid" name="query_taxpayerid"/></span>
									纳税人名称<input  type="text" style="width:120px" id="query_taxtypename" name="query_taxtypename"/></span>
									<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
									<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()" >查询</a>
									<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="reginput()" >确定</a>
							</div>
						</div>
						<table id="reginfogrid" style="width:700px;height:320px"
						data-options="iconCls:'icon-edit',singleSelect:true,fitColumns:true" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'taxpayerid',width:120,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'taxdeptcode',width:200,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:120,align:'center',editor:{type:'validatebox'}">税收管理员</th>
								</tr>
							</thead>
						</table>
				</div>
    </div>  
</body> 
</html>