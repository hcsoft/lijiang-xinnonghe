
function formatterDate(value,row,index){
			return formatDatebox(value);
	}

//设置easyui的下拉框和日期选择框的默认属性
$.fn.combobox.defaults.editable = false;
$.fn.datebox.defaults.editable = true;
$.fn.datagrid.defaults.pageSize =15;



/**
 * 四级联动  如果要选中
 */
function OrgLink(_modelAuth,_emptype,_orgsupcode,_orgcode,_deptcode,_managercode){
	
	this.taxorgsupcode = "taxorgsupcode";
	this.taxorgcode = "taxorgcode";
	this.async = false;
	this.taxdeptcode = "taxdeptcode";
	this.taxmanagercode = "taxmanagercode";
	this.modelAuth = "15";
	this.emptype = "30";
	
	if(_orgsupcode){
		this.taxorgsupcode = _orgsupcode;
	}
	if(_orgcode){
		this.taxorgcode = _orgcode;
	}
	if(_deptcode){
		this.taxdeptcode = _deptcode;
	}
	if(_managercode){
		this.taxmanagercode = _managercode;
	}
	if(_modelAuth){
		this.modelAuth = _modelAuth;
	}
	if(_emptype){
		this.emptype = _emptype;
	}
}
OrgLink.prototype.toString = function(){
	var str = "taxorgsupcode="+this.taxorgsupcode+',taxorgcode='+this.taxorgcode+
	          ",taxdeptcode="+this.taxdeptcode+",managercode="+this.taxmanagercode+
	          ",modelAuth="+this.modelAuth+",emptype="+this.emptype;
	return str;
}
OrgLink.prototype.loadData = function(){
	var regex = new RegExp("\"","g");  
	var orgsupcode = this.taxorgsupcode;
	var orgcode = this.taxorgcode;
	var deptcode = this.taxdeptcode;
	var managercode = this.taxmanagercode;
	var _modelAuth = this.modelAuth;
	var _emptype = this.emptype;
	
	var m = false;   
	if(this.sendMethod != undefined){
		m = this.sendMethod;
	}	
	var orgsupFunction = function(newValue, oldValue){
		    
		    $('#'+deptcode).combobox({
									data : [{key:'',value:'---请选择主管地税部门---',keyvalue:'---请选择主管地税部门---'}],
			                        valueField:'key',
			                        textField:'keyvalue'
								  });
			$('#'+managercode).combobox({
									data : [{key:'',value:'-----请选择税收管理员-----',keyvalue:'-----请选择税收管理员-----'}],
			                        valueField:'key',
			                        textField:'keyvalue'
								  });
			 
            $.ajax({
					  type: "get",
					  async:m,
					  cache:false,
					  url: "/soption/taxOrgOptionBySup.do",
					  data: {"taxSuperOrgCode":newValue},
					  dataType: "json",
					  success:function(jsondata){
						  var orgLen = jsondata.taxOrgOptionJsonArray.length;
						   if(orgLen > 1){
							   if(jsondata.taxOrgOptionJsonArray[0].key == ""){
								   jsondata.taxOrgOptionJsonArray[0].value = "-----请选择区县机关-----";
							       jsondata.taxOrgOptionJsonArray[0].keyvalue = "-----请选择区县机关-----";
							   }else{
								 //  var data = {key:'',value:'-----请选择区县机关-----',keyvalue:'-----请选择区县机关-----'};
							     //  jsondata.taxOrgOptionJsonArray = [data].concat(jsondata.taxOrgOptionJsonArray);
							   }
						   }else if(orgLen == 1){
							   if(jsondata.taxOrgOptionJsonArray[0].key == ""){
								   jsondata.taxOrgOptionJsonArray[0].value = "-----请选择区县机关-----";
							       jsondata.taxOrgOptionJsonArray[0].keyvalue = "-----请选择区县机关-----";
							   }
						   }else if(orgLen == 0){
							  // var data = {key:'',value:'-----请选择区县机关-----',keyvalue:'-----请选择区县机关-----'};
							  // jsondata.taxOrgOptionJsonArray = [data].concat(jsondata.taxOrgOptionJsonArray);
						   }
						   if(jsondata.taxOrgOptionJsonArray.length > 1){
							   $('#'+orgcode).combobox({
								data : jsondata.taxOrgOptionJsonArray,
		                        valueField:'key',
		                        textField:'keyvalue',
		                        onChange:orgFunction
							   });
						   }
						   else{
							   $('#'+orgcode).combobox({
								data : jsondata.taxOrgOptionJsonArray,
		                        valueField:'key',
		                        textField:'keyvalue'
							   });
						   }
							if(jsondata.taxOrgOptionJsonArray.length == 1){
								$('#'+orgcode).combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
								$('#'+orgcode).combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
							}
					  }
				  });
	}
	var orgFunction = function(newValue, oldValue){
		    $('#'+managercode).combobox({
									data : [{key:'',value:'-----请选择税收管理员-----',keyvalue:'-----请选择税收管理员-----'}],
			                        valueField:'key',
			                        textField:'keyvalue'
								  });
            $.ajax({
					  type: "get",
					  async:m,
					  cache:false,
					  url: "/soption/taxDeptOptionByOrg.do",
					  data: {"taxOrgCode":newValue},
					  dataType: "json",
					  success:function(jsondata){
						  var deptLen = jsondata.taxDeptOptionJsonArray.length;
						   if(deptLen > 1){
							   if(jsondata.taxDeptOptionJsonArray[0].key == ''){
								   jsondata.taxDeptOptionJsonArray[0].value = '---请选择主管地税部门---';
								   jsondata.taxDeptOptionJsonArray[0].keyvalue = '---请选择主管地税部门---';
							   }else{
								   // var data = {key:'',value:'---请选择主管地税部门---',keyvalue:'---请选择主管地税部门---'};
							       // jsondata.taxDeptOptionJsonArray = [data].concat(jsondata.taxDeptOptionJsonArray);
							   }
						   }else if(deptLen == 1){
							   if(jsondata.taxDeptOptionJsonArray[0].key == ''){
								   jsondata.taxDeptOptionJsonArray[0].value = '---请选择主管地税部门---';
								   jsondata.taxDeptOptionJsonArray[0].keyvalue = '---请选择主管地税部门---';
							   }
						   }
						   else if(deptLen == 0){
							  //  var data = {key:'',value:'---请选择主管地税部门---',keyvalue:'---请选择主管地税部门---'};
							  //  jsondata.taxDeptOptionJsonArray = [data].concat(jsondata.taxDeptOptionJsonArray);
						   }
						   if(jsondata.taxDeptOptionJsonArray.length > 1){
							   $('#'+deptcode).combobox({
									data : jsondata.taxDeptOptionJsonArray,
			                        valueField:'key',
			                        textField:'keyvalue',
			                        onChange:deptFunction
							   });
						   }
						   else{
							   $('#'+deptcode).combobox({
								data : jsondata.taxDeptOptionJsonArray,
		                        valueField:'key',
		                        textField:'keyvalue'
							  });
						   }
							if(jsondata.taxDeptOptionJsonArray.length == 1){
								$('#'+deptcode).combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
								$('#'+deptcode).combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
							}
					 }
				  });
	}
	var deptFunction = function(newValue, oldValue){
            $.ajax({
					  type: "get",
					  async:m,
					  cache:false,
					  url: "/soption/getTaxEmpByOrgCode.do",
					  data: {"taxDeptCode":newValue,"emptype":_emptype},
					  dataType: "json",
					  success:function(jsondata){
						    var managerLen = jsondata.taxEmpOptionJsonArray.length;
							if(managerLen > 1){
								if(jsondata.taxEmpOptionJsonArray[0].key == ''){
								   jsondata.taxEmpOptionJsonArray[0].value = '---请选择税收管理员---';
								   jsondata.taxEmpOptionJsonArray[0].keyvalue = '---请选择税收管理员---';
							    }else{
							    //   var data = {key:'',value:'-----请选择税收管理员-----',keyvalue:'-----请选择税收管理员-----'};
							    //   jsondata.taxEmpOptionJsonArray = [data].concat(jsondata.taxEmpOptionJsonArray);
							    }
							}else if(managerLen == 1){
								if(jsondata.taxEmpOptionJsonArray[0].key == ''){
								   jsondata.taxEmpOptionJsonArray[0].value = '---请选择税收管理员---';
								   jsondata.taxEmpOptionJsonArray[0].keyvalue = '---请选择税收管理员---';
							    }
							} else if(managerLen == 0){
								//var data = {key:'',value:'-----请选择税收管理员-----',keyvalue:'-----请选择税收管理员-----'};
							  // jsondata.taxEmpOptionJsonArray.push(data);
							}
						   $('#'+managercode).combobox({
								data : jsondata.taxEmpOptionJsonArray,
		                        valueField:'key',
		                        textField:'keyvalue'
							});
					  }
				  });
	}
	
		$.ajax({
			   type: "get",
			   async:m,
			   cache:false,
			   url: "/soption/taxOrgOptionInit.do?d="+new Date(),
			   data: {"moduleAuth":_modelAuth,"emptype":_emptype},
			   dataType: "json",
			   success: function(jsondata){
				    //州市级机关
				   var supLen = jsondata.taxSupOrgOptionJsonArray.length;
				   if(supLen > 1){
					   if(jsondata.taxSupOrgOptionJsonArray[0].key == ""){
						   jsondata.taxSupOrgOptionJsonArray[0].value = "-----请选择州市机关-----";
					       jsondata.taxSupOrgOptionJsonArray[0].keyvalue = "-----请选择州市机关-----";
					   }else{
						 //  var newData = {key:"",value:"-----请选择州市机关-----",keyvalue:"-----请选择州市机关-----"};
						 //  jsondata.taxSupOrgOptionJsonArray = [newData].concat(jsondata.taxSupOrgOptionJsonArray);
					   }
				   }else if(supLen == 1){
					   if(jsondata.taxSupOrgOptionJsonArray[0].key == ""){
						   jsondata.taxSupOrgOptionJsonArray[0].value = "-----请选择州市机关-----";
					       jsondata.taxSupOrgOptionJsonArray[0].keyvalue = "-----请选择州市机关-----";
					   }
				   }else if(supLen == 0){
					  // var newData = {key:"",value:"-----请选择州市机关-----",keyvalue:"-----请选择州市机关-----"};
					  // jsondata.taxSupOrgOptionJsonArray = [newData].concat(jsondata.taxSupOrgOptionJsonArray);
				   }
				   if(jsondata.taxSupOrgOptionJsonArray.length > 1){
					   $('#'+orgsupcode).combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onChange:orgsupFunction
					   });
				   }
				   else{
					   $('#'+orgsupcode).combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					   });
				   }
				    if(jsondata.taxSupOrgOptionJsonArray.length == 1){  
						$('#'+orgsupcode).combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#'+orgsupcode).combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
				    }
				    //县级机关
				   var orgLen = jsondata.taxOrgOptionJsonArray.length;
				   if(orgLen > 1){
					   if(jsondata.taxOrgOptionJsonArray[0].key == ""){
						   jsondata.taxOrgOptionJsonArray[0].value = "-----请选择区县机关-----";
					       jsondata.taxOrgOptionJsonArray[0].keyvalue = "-----请选择区县机关-----";
					   }else{
						 //  var data = {key:'',value:'-----请选择区县机关-----',keyvalue:'-----请选择区县机关-----'};
					     //  jsondata.taxOrgOptionJsonArray = [data].concat(jsondata.taxOrgOptionJsonArray);
					   }
				   }else if(orgLen ==1){
					   if(jsondata.taxOrgOptionJsonArray[0].key == ""){
						   jsondata.taxOrgOptionJsonArray[0].value = "-----请选择区县机关-----";
					       jsondata.taxOrgOptionJsonArray[0].keyvalue = "-----请选择区县机关-----";
					   }
				   }else if(orgLen == 0){
					  // var data = {key:'',value:'-----请选择区县机关-----',keyvalue:'-----请选择区县机关-----'};
					  // jsondata.taxOrgOptionJsonArray = [data].concat(jsondata.taxOrgOptionJsonArray);
				   }
				   if(jsondata.taxOrgOptionJsonArray.length > 1){
					   $('#'+orgcode).combobox({
						data : jsondata.taxOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
                        onChange:orgFunction
					   });
				   }
				   else{
					   $('#'+orgcode).combobox({
						data : jsondata.taxOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					   });
				   }
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						$('#'+orgcode).combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#'+orgcode).combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}
					///主管税务机关
				   var deptLen = jsondata.taxDeptOptionJsonArray.length;
				   if(deptLen > 1){
					   if(jsondata.taxDeptOptionJsonArray[0].key == ''){
						   jsondata.taxDeptOptionJsonArray[0].value = '---请选择主管地税部门---';
						   jsondata.taxDeptOptionJsonArray[0].keyvalue = '---请选择主管地税部门---';
					   }else{
						 //   var data = {key:'',value:'---请选择主管地税部门---',keyvalue:'---请选择主管地税部门---'};
					    //    jsondata.taxDeptOptionJsonArray = [data].concat(jsondata.taxDeptOptionJsonArray);
					   }
					   
				   }else if(deptLen == 1){
					   if(jsondata.taxDeptOptionJsonArray[0].key == ''){
						   jsondata.taxDeptOptionJsonArray[0].value = '---请选择主管地税部门---';
						   jsondata.taxDeptOptionJsonArray[0].keyvalue = '---请选择主管地税部门---';
					   }
				   }else if(deptLen == 0){
					  //  var data = {key:'',value:'---请选择主管地税部门---',keyvalue:'---请选择主管地税部门---'};
					  //  jsondata.taxDeptOptionJsonArray = [data].concat(jsondata.taxDeptOptionJsonArray);
				   }
				   if(jsondata.taxDeptOptionJsonArray.length > 1){
					   $('#'+deptcode).combobox({
							data : jsondata.taxDeptOptionJsonArray,
	                        valueField:'key',
	                        textField:'keyvalue',
	                        onChange:deptFunction
					   });
				   }
				   else{
					   $('#'+deptcode).combobox({
						data : jsondata.taxDeptOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					  });
				   }
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						$('#'+deptcode).combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#'+deptcode).combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}
				   //登录代码
					var managerLen = jsondata.taxEmpOptionJsonArray.length;
					if(managerLen > 1){
						if(jsondata.taxEmpOptionJsonArray[0].key == ''){
						   jsondata.taxEmpOptionJsonArray[0].value = '---请选择税收管理员---';
						   jsondata.taxEmpOptionJsonArray[0].keyvalue = '---请选择税收管理员---';
					    }else{
					     //  var data = {key:'',value:'-----请选择税收管理员-----',keyvalue:'-----请选择税收管理员-----'};
					     //  jsondata.taxEmpOptionJsonArray = [data].concat(jsondata.taxEmpOptionJsonArray);
					    }
					}else if(managerLen == 1){
						if(jsondata.taxEmpOptionJsonArray[0].key == ''){
						   jsondata.taxEmpOptionJsonArray[0].value = '---请选择税收管理员---';
						   jsondata.taxEmpOptionJsonArray[0].keyvalue = '---请选择税收管理员---';
					    }
					}else if(managerLen == 0){
					  // var data = {key:'',value:'-----请选择税收管理员-----',keyvalue:'-----请选择税收管理员-----'};
					  // jsondata.taxEmpOptionJsonArray.push(data);
					}
				   $('#'+managercode).combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});

				   var loginTaxdeptcode = jsondata.currentUserInfo.taxorgcode;
				   var loginTaxempcode = jsondata.currentUserInfo.taxempcode;
				   if(jsondata.taxDeptOptionJsonArray.length > 1){
					   for(var i = 0;i < jsondata.taxDeptOptionJsonArray.length;i++){
						   if(loginTaxdeptcode == jsondata.taxDeptOptionJsonArray[i].key){
							   $('#'+deptcode).combobox("setValue",loginTaxdeptcode);
							   break;
						   }
				       }
				   }
				   if(jsondata.taxEmpOptionJsonArray.length > 1){
					   for(var i = 0;i < jsondata.taxEmpOptionJsonArray.length;i++){
						   if(loginTaxempcode == jsondata.taxEmpOptionJsonArray[i].key){
							   $('#'+managercode).combobox("setValue",loginTaxempcode);
							   break;
						   }
				       }
				   }
	           }
	   });	
}
/*
 * 税目   taxtypecode 11,22,33  ,''表示所有
 * gettaxcode true,false
*/
function TaxLink(taxtypeid,taxtypecode,gettaxcode,taxid){
	this.taxtypeid = taxtypeid;
    this.taxtypecode = taxtypecode;
    this.gettaxcode = gettaxcode;
    this.taxid = taxid;
}
var taxLinkMap;
TaxLink.prototype.loadData = function(){
	var typecode = this.taxtypecode;
	var istaxcode = this.gettaxcode;
	var typeid = this.taxtypeid;
	var id = this.taxid;
	var m = true;
	if(this.sendMethod){
		m = this.sendMethod;
	}
	taxLinkMap = new Map();
	$.ajax({
					  type: "get",
					  async:m,
					  cache:false,
					  url: "/ComboxService/gettaxcomboxs.do?d="+new Date(),
					  data: {"taxcode":typecode,"gettaxcode":true},
					  dataType: "json",
					  success:function(jsondata){
						  var emptyTaxtype = {key:'',value:'------请选择税目------'};
						  var emptyItem = [emptyTaxtype];
						  var keyAry = emptyItem.concat(jsondata.key);
						  if(istaxcode == true && id){
							  
							  var emptyTax = {key:'',value:'------请选择税种------'};
							  $('#'+id).combobox({
										data : [emptyTax],
				                        valueField:'key',
				                        textField:'value'
								     });

							  taxLinkMap.push('',[emptyTax]);
							  for(var i = 0;i < jsondata.key.length;i++){
								  taxLinkMap.push(jsondata.key[i].key,jsondata.value[i]);
							  }
							  
							  $('#'+typeid).combobox({
								data : keyAry,
		                        valueField:'key',
		                        textField:'value',
		                        onChange:function(newValue,oldValue){
								     var valueData = taxLinkMap.get(newValue);
								     if(newValue != ''){
								    	 valueData = [emptyTax].concat(valueData);
								     }
								     $('#'+id).combobox({
										data : valueData,
				                        valueField:'key',
				                        textField:'value'
								     });
		                        }
						      });
						  }else{
							  $('#'+typeid).combobox({
								data : keyAry,
		                        valueField:'key',
		                        textField:'value'
						      });
						  }
						  
						  
					  }
				  });
}
var settings = {
	rowStyle:function(index,row){
	            if(row.taxpayerid && row.taxpayerid == '总计'){
	            	return 'background-color:#2E79BA;';
	            }else{
	            	if(index %2 == 0){
			            return 'background-color:#FFF0F0;';
				    }else{
				        return 'background-color:#F0F0FF;';
				    }
	            }
			 }
}
function Map(){
	this.keyAry = new Array();
	this.valueAry = new Array();
}
Map.prototype.size = function(){
	return this.keyAry.length;
}
Map.prototype.push = function(key,value){
	var have = false;
	for(var i = 0;i < this.keyAry.length;i++){
		if(key == this.keyAry[i]){
			have = true;
			this.valueAry[i] = value;
			break;
		}
	}
	if(!have){
		this.keyAry.push(key);
	    this.valueAry.push(value);
	}
}
Map.prototype.get = function(key){
	for(var i = 0;i < this.keyAry.length;i++){
		if(key == this.keyAry[i]){
			return this.valueAry[i];
		}
	}
	return null;
}
Map.prototype.contains = function(key){
	for(var i = 0;i < this.keyAry.length;i++){
		if(key == this.keyAry[i]){
			return true;
		}
	}
	return false;
}
Map.prototype.keys = function(){
	return this.keyAry;
}
Map.prototype.values = function(){
	return this.valueAry;
}


//公用的方法
var CommonUtils = (function(){
	var obj = {
		getDate:function(dateValue){
		   var d = new Date(dateValue);
		   return {
			   year:d.getFullYear(),
			   month:d.getMonth()+1,
			   day:d.getDate(),
			   toString:function(){
			      return this.year+'年'+this.month+'月'+this.day+'日';
			   },
		       toStandStr:function(){
				  return this.year+'-'+this.month+'-'+this.day; 
		       }
		   };
		},
		addDate:function(date,day){
			var dateValue = date.valueOf();
			dateValue = dateValue+day*24*60*60*1000;
			return CommonUtils.getDate(dateValue);
		},
		downloadFile : function(url,params){   //params form表单
		    var form=$("<form>");//定义一个form表单
				form.attr("style","display:none");
				form.attr("target","");
				form.attr("method","post");
				form.attr("action",url);
				$("body").append(form);
				for(var p in params){
				    var input1=$("<input>");
				    input1.attr("type","hidden");
				    input1.attr("name",p);
				    input1.attr("value",params[p]);
				    //将表单放置在web中
				    form.append(input1);
				}		
				form.submit();//表单提交 
		},
		validateForm:function(inputAry){ 
			for(var i = 0;i < inputAry.length;i++){
				var input = $(inputAry[i]);
				if(input && input.val() == ""){
					var text = input.parent().prev().text();
					if(text){
						text = text.substring(0,text.length-1);
						if(input.hasClass("easyui-validatebox") || input.hasClass("easyui-numberbox")){
							$.messager.alert("提示消息",text+'不能为空!','info');
							input.focus();
							return false;
						}else if(input.hasClass("easyui-combobox") || input.hasClass("easyui-datebox")){
							var selectValue = input.combobox('getValue');
							if(selectValue == ""){
								$.messager.alert("提示消息","请选择"+text+"!",'info');
								input.focus();
								return false;
							}
						}
					}
				}
			}
			return true;
		},
		/*获取任意一张缓存表的信息*/
		getCacheCode:function(tablename,selectfield){
			$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/ComboxService/getComboxs.do?d="+new Date(),
					  data: {"codetablename":tablename},
					  dataType: "json",
					  success:function(jsondata){
						  $('#'+selectfield).combobox({
						       data : jsondata,
                               valueField:'key',
                               textField:'value'
					      });
					  }
			});
		},
		getCacheCodeFromTable:function(tablename,key,value,selectfield,where,allselect){
			if(!where)
				where = '';
			$.ajax({
					  type: "get",
					  async:false,
					  cache:false,
					  url: "/ComboxService/getComboxsFromTable.do?d="+new Date(),
					  data: {"codetablename":tablename,"key":key,"value":value,"where":where},
					  dataType: "json",
					  success:function(jsondata){
						  var data = [{key:'',value:'------请选择------'}];
						  if(allselect){
							  jsondata = data.concat(jsondata);
						  }
						  $(selectfield).combobox('clear');
						  $(selectfield).combobox({
						       data : jsondata,
                               valueField:'key',
                               textField:'value'
					      });
					  }
			});
		},
		/*获取坐落地类型*/
		getLocationType:function(locationtype){
			$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/ComboxService/getComboxs.do?d="+new Date(),
					  data: {"codetablename":"COD_LOCATIONTYPE"},
					  dataType: "json",
					  success:function(jsondata){
						  if(jsondata.length > 0){
							  jsondata[0].value = '--请选择坐落地类型--';
						  }
						  $('#'+locationtype).combobox({
						       data : jsondata,
                               valueField:'key',
                               textField:'value'
					      });
					  }
			});
		},
		/*获取土地证类型*/
		getLandCertificateType:function(landcertificatetype){
			$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/ComboxService/getComboxs.do?d="+new Date(),
					  data: {"codetablename":"COD_LANDCERTIFICATETYPE"},
					  dataType: "json",
					  success:function(jsondata){
						  if(jsondata.length > 0){
							  jsondata[0].value = '--请选择土地证类型--';
						  }
						  $('#'+landcertificatetype).combobox({
						       data : jsondata,
                               valueField:'key',
                               textField:'value'
					      });
					  }
			});
		},
		/*获取减免类型*/
		getDerateType:function(deratetype){
			$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/ComboxService/getComboxs.do?d="+new Date(),
					  data: {"codetablename":"COD_DERATETYPECODE"},
					  dataType: "json",
					  success:function(jsondata){
						  if(jsondata.length > 0){
							  jsondata[0].value = '--请选择减免类型--';
						  }
						  $('#'+deratetype).combobox({
						       data : jsondata,
                               valueField:'key',
                               textField:'value'
					      });
						  $('#'+deratetype).combobox('select',"");
						  
					  }
			});
		},
		/*获取县、市、省级机关*/
		getCurrentOrgInfo:function(orgselect){
			 $.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/ComboxService/getLoginDeptInfo.do?d="+new Date(),
					  data: {},
					  dataType: "json",
					  success:function(jsondata){
						  $('#'+orgselect).combobox({
						       data : jsondata,
                               valueField:'key',
                               textField:'value'
					      });
					  }
			});
		},
		//会与$.load方法冲突
		enableAjaxProgressBar:function(){
			function openProcess(){
				var value = $('#processDialog').progressbar('getValue');
				if (value < 100){
					value += Math.floor(Math.random() * 10);
					$('#processDialog').progressbar('setValue', value);
				}
				if(value == 100){
					$('#processDialog').progressbar('setValue', 0);
				}
			}
			 //备份jquery的ajax方法  
		    var _ajax=$.ajax;  
		    //重写jquery的ajax方法  
		    $.ajax=function(opt){  
		    	var timerId = null;
		    	if(opt.processbar){
		    		//创建进度条
		    		var divid = "processDialog";
		    		var div = document.getElementById(divid);
		    		if(div){
		    			$(div).progressbar('setValue',0);
		    		}
				    else{
				    	div = document.createElement("div");
		    		    div.id = divid;
		    		    div.className = "easyui-window easyui-progressbar";	    
					    div.style.width = "300px";
					    div.style.height= "45px";
						document.body.appendChild(div);
						$(div).progressbar({
							value:0
						});
						$(div).window(
					       {
					    	closed:true,modal:true,collapsible:true,noheader:true,border:false
					       }
					    );
						var oParent = $('#'+divid).parent();
						oParent.css('padding','0');
						oParent.css('border-width','0');   //设置样式，让其更好看
				    }
					$(div).window('open');
					timerId = setInterval(openProcess,200);
		    		
		    	}
		        //备份opt中error和success方法  
		        var fn = {  
		            error:function(XMLHttpRequest, textStatus, errorThrown){},  
		            success:function(data, textStatus){}  
		        }  
		        if(opt.error){  
		            fn.error=opt.error;  
		        }  
		        if(opt.success){  
		            fn.success=opt.success;  
		        }  
		        var closeFun = function(processbar,timerId){
		        	if(processbar && timerId){
		        		$('#processDialog').window('close');
		        		clearInterval(timerId);	
		        	}
		        }
		        //扩展增强处理  
		        var _opt = $.extend(opt,{  
		            error:function(XMLHttpRequest, textStatus, errorThrown){  
		                //错误后关闭进度条，然后处理error事件
		        	    closeFun(opt.processbar,timerId);
		                fn.error(XMLHttpRequest, textStatus, errorThrown);  
		            },  
		            success:function(data, textStatus){  
		                //成功关闭进度条，然后处理success事件 
		            	closeFun(opt.processbar,timerId);
		                fn.success(data,textStatus);  
		            }  
		        });  
		        _ajax(_opt);
		      }
		}
	};
	return obj;
}());

var DateUtils = (function(){
	 var obj = {
		 getYearFirstDay:function(){
		     var date=new Date();
			 var year = date.getUTCFullYear();
			 return year+'-01-01';
		 },
		 getDay:function(date){
			 var year = date.getFullYear();
			 var month = date.getMonth()+1;
			 var strmonth = month+'';
			 if(strmonth.length == 1){
				 strmonth = '0'+strmonth;
			 }
			 var day = date.getDate();
			 var newday = day+'';
			 if(newday.length == 1){
				 newday = '0'+newday;
			 }
			 return year+'-'+strmonth+'-'+newday;
		 },
		 getCurrentDay:function(){
			 var date=new Date();
			 var year = date.getUTCFullYear();
			 var month = date.getUTCMonth()+1;
			 var strmonth = month+'';
			 if(strmonth.length == 1){
				 strmonth = '0'+strmonth;
			 }
			 var day = date.getUTCDate();
			 var newday = day+'';
			 if(newday.length == 1){
				 newday = '0'+newday;
			 }
			 return year+'-'+strmonth+'-'+newday;
		 },
		 getMonthFirstDay:function(){
			 var date=new Date();
			 var year = date.getUTCFullYear();
			 var month = date.getUTCMonth()+1;
			 var strmonth = month+'';
			 if(strmonth.length == 1){
				 strmonth = '0'+strmonth;
			 }
			 return year+'-'+strmonth+'-01';
		 },
		 getMonthLastDay:function ()
		 {
			 var date=new Date();
			 var year = date.getUTCFullYear();
			 var month = date.getUTCMonth()+1;
			 var strmonth = month+'';
			 if(strmonth.length == 1){
				 strmonth = '0'+strmonth;
			 }
			 var d=new Date(date.getYear(),date.getMonth()+1,1);
			 var newdate=new Date(d-86400000);
			 var day = newdate.getUTCDate(); 
			 return year+'-'+strmonth+'-'+day;
		 }
	 }
	 return obj;
})();

//数组
Array.prototype.contains = function(element){
	for(var i = 0;i < this.length;i++){
		if(this[i] == element){
			return true;
		}
	}
	return false;
} 
function uploadbutton(value,row,index){
		return "<a href=javascript:void(0) onclick=\"attachment(\'1\',\'"+row.user_id+"\')\">附件管理</a>";
	}

function attachment(businesscode,businessnumber){
	window.open('/attachmentutil.jsp?businessnumber='+businessnumber+'&businesscode='+businesscode, '附件',
							   'top=100,left=250,width=930,height=400,toolbar=no,menubar=no,location=no');
}

//计算机编码拼号
function checkNumber(DigitString, totalLength, decimalLength,isPositive)
  {
	  var re = "";

	  if(isPositive == "true" || isPositive == true)
	  {
		  if(isNaN(DigitString*1) || DigitString*1<0)
			  return false;
	  }
	  if(isPositive == "false" || isPositive == false)
	  {
		  if(isNaN(DigitString*1) || DigitString*1>=0)
			  return false;
	  }


	  if (decimalLength!=null && decimalLength != 0)
	  {  
		  re = re+"\\.[\\d]{1,"+ decimalLength +"}"
	  }

	  if (totalLength == null)
	  {   
		  re= "\\d*"+re;
	  }
	  else
	  {  
		  var intergerLength = totalLength;
		  if (decimalLength!=null)
		  {  
			  intergerLength = totalLength-decimalLength;
		  }
		  re="([\\d]{0,"+ intergerLength +"}"+re+"|[\\d]{0,"+intergerLength+"})";
	  }
	  re = new RegExp("^"+re+"$","g");

	  if(re.exec(DigitString) == null)
	  {
		  return false;
	  }
	 
	  return true;
  }


function spelltaxpayerid(obj){
		var rightstr ='530124';
		var taxpayerid = obj.value;
		if(taxpayerid.length==13 || taxpayerid.length==14){
				return;
		}
		if(!checkNumber(taxpayerid.substring(1),12,0,true)){
			alert("计算机编码不正确，请重新输入");
			obj.value="";
			return;
		}
		var len = taxpayerid.length;
		var strlen = 13-len;
		if(strlen>=6){
			for(var i=0; i<(7-len);i++){
			taxpayerid = "0" + taxpayerid;
			}
			obj.value = rightstr+taxpayerid;
		}else{
			rightstr = rightstr.substring(0,strlen);
			obj.value = rightstr+taxpayerid;
		}
	}

//格式化金额
function formatnumber(num){
	if(num==null){
		num = 0;
	}
	num = new Number(num);
	num = String(num.toFixed(2));
    return num;
}

$.extend($.fn.datagrid.methods, {
	addToolbarItem : function (jq, items) {
		return jq.each(function () {
			var dpanel = $(this).datagrid('getPanel');
			var toolbar = dpanel.children("div.datagrid-toolbar");
			if (!toolbar.length) {
				toolbar = $("<div class=\"datagrid-toolbar\"><table cellspacing=\"0\" cellpadding=\"0\"><tr></tr></table></div>").prependTo(dpanel);
				$(this).datagrid('resize');
			}
			var tr = toolbar.find("tr");
			for (var i = 0; i < items.length; i++) {
				var btn = items[i];
				if (btn == "-") {
					$("<td><div class=\"datagrid-btn-separator\"></div></td>").appendTo(tr);
				} else {
					var td = $("<td></td>").appendTo(tr);
					var b = $("<a href=\"javascript:void(0)\"></a>").appendTo(td);
					b[0].onclick = eval(btn.handler || function () {});
					b.linkbutton($.extend({}, btn, {
							plain : true
						}));
				}
			}
		});
	},
	removeToolbarItem : function (jq, param) {
		return jq.each(function () {
			var dpanel = $(this).datagrid('getPanel');
			var toolbar = dpanel.children("div.datagrid-toolbar");
			var cbtn = null;
			if (typeof param == "number") {
				cbtn = toolbar.find("td").eq(param).find('span.l-btn-text');
			} else if (typeof param == "string") {
				cbtn = toolbar.find("span.l-btn-text:contains('" + param + "')");
			}
			if (cbtn && cbtn.length > 0) {
				cbtn.closest('td').remove();
				cbtn = null;
			}
		});
	}
});

function dateValid(value){
	var DATE_FORMAT =/^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/;
	if(value==''){
		return false;
	}
	if(!DATE_FORMAT.test(value)){
		return false;	
	}else{
		return true;
	}
}
