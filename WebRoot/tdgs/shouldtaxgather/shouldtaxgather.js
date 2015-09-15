function addViewDetailButton(value,row,index){
	if(row.state === 1)
		return "<input type='button' value='查看明细' onclick='queryDetail("+index+")'/>";
}
var ShouldTaxUtils = (function(){
	        //定义列的相关信息，使得应纳税统计能够动态生成列
	        var colMap = new Map();
			var taxpayeridCol = {'field':'taxpayerid','width':100,'hidden':true,'align':'left','editor':{'type':'validatebox'},'title':'计算机编码','orgcol':'taxpayername'};
			var taxpayernameCol = {'field':'taxpayername','width':200,'hidden':false,'align':'left','editor':{'type':'validatebox'},'title':'纳税人名称'};
			var taxtypecodeCol = {'field':'taxtypecode','width':100,'hidden':true,'align':'left','editor':{'type':'validatebox'},'title':'税种代码','orgcol':'taxtypename'};
			var taxtypenameCol = {'field':'taxtypename','width':160,'hidden':false,'align':'left','editor':{'type':'validatebox'},'title':'税种'};

			var taxcodeCol = {'field':'taxcode','width':100,'hidden':true,'align':'left','editor':{'type':'validatebox'},'title':'税目代码','orgcol':'taxname'};
			var taxnameCol = {'field':'taxname','width':120,'hidden':false,'align':'left','editor':{'type':'validatebox'},'title':'税目'};
			var taxorgcodeCol = {'field':'taxorgcode','width':100,'hidden':true,'align':'left','editor':{'type':'validatebox'},'title':'区县税务机关代码','orgcol':'taxorgname'};
			var taxorgnameCol = {'field':'taxorgname','width':200,'hidden':false,'align':'left','editor':{'type':'validatebox'},'title':'区县税务机关'};

            var taxdeptcodeCol = {'field':'taxdeptcode','width':100,'hidden':true,'align':'left','editor':{'type':'validatebox'},'title':'主管税务机关代码','orgcol':'taxdeptname'};
			var taxdeptnameCol = {'field':'taxdeptname','width':200,'hidden':false,'align':'left','editor':{'type':'validatebox'},'title':'主管税务机关'};
			var taxmanagercodeCol = {'field':'taxmanagercode','width':100,'hidden':true,'align':'left','editor':{'type':'validatebox'},'title':'税收管理员代码','orgcol':'taxmanagername'};
			var taxmanagernameCol = {'field':'taxmanagername','width':120,'hidden':false,'align':'left','editor':{'type':'validatebox'},'title':'税收管理员'};

            var taxyearCol = {'field':'taxyear','width':100,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'所属期年份'};
			var taxyearmonthCol = {'field':'taxyearmonth','width':100,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'所属期月份'};
			var shouldtaxmoneyCol = {'field':'shouldtaxmoney','width':100,'hidden':false,'align':'right','formatter':formatnumber,'editor':{'type':'validatebox'},'title':'应缴金额'};
			var avoidtaxmoneyCol = {'field':'avoidtaxmoney','width':100,'hidden':false,'align':'right','formatter':formatnumber,'editor':{'type':'validatebox'},'title':'减免金额'};
			var owetaxmoneyCol = {'field':'owetaxmoney','hidden':false,'width':100,'align':'right','formatter':formatnumber,'editor':{'type':'validatebox'},'title':'欠税金额'};
			var alreadyshouldtaxmoneyCol = {'field':'alreadyshouldtaxmoney','hidden':false,'width':100,'align':'right','formatter':formatnumber,'editor':{'type':'validatebox'},'title':'实缴金额'};
			var stayinspecttaxmoneyCol = {'field':'stayinspecttaxmoney','hidden':true,'width':100,'align':'left','editor':{'type':'validatebox'},'title':'待核查'};
            var viewDetailCol = {'field':'viewdetail','hidden':false,'width':120,'align':'center','formatter':addViewDetailButton,'title':'操作'};
            
			colMap.push(taxpayeridCol.field,taxpayeridCol);
			colMap.push(taxpayernameCol.field,taxpayernameCol);
			colMap.push(taxtypecodeCol.field,taxtypecodeCol);
			colMap.push(taxtypenameCol.field,taxtypenameCol);

			colMap.push(taxcodeCol.field,taxcodeCol);
			colMap.push(taxnameCol.field,taxnameCol);
			colMap.push(taxorgcodeCol.field,taxorgcodeCol);
			colMap.push(taxorgnameCol.field,taxorgnameCol);
			
			colMap.push(taxdeptcodeCol.field,taxdeptcodeCol);
			colMap.push(taxdeptnameCol.field,taxdeptnameCol);
			colMap.push(taxmanagercodeCol.field,taxmanagercodeCol);
			colMap.push(taxmanagernameCol.field,taxmanagernameCol);

			colMap.push(taxyearCol.field,taxyearCol);
			colMap.push(taxyearmonthCol.field,taxyearmonthCol);
			colMap.push(shouldtaxmoneyCol.field,shouldtaxmoneyCol);
			colMap.push(avoidtaxmoneyCol.field,avoidtaxmoneyCol);
			colMap.push(owetaxmoneyCol.field,owetaxmoneyCol);
			colMap.push(alreadyshouldtaxmoneyCol.field,alreadyshouldtaxmoneyCol);
			colMap.push(stayinspecttaxmoneyCol.field,stayinspecttaxmoneyCol);
			colMap.push(viewDetailCol.field,viewDetailCol);
			
	    	
	    	var obj = {
	    		getDisplayColumnFieldAry:function(/* array[string] */ary,/*是否加上统计列*/addtotalCol){   //根据ary获取需要展现的列的属性
			    	var result = new Array();
			    	for(var i = 0;i < ary.length;i++){
			    		var field = ary[i];
			    		
			    		var value = colMap.get(field);
			    		if(value == null){
			    			//$.messager.alert('提示消息','属性配置没有找到!','info');
			    		}
			    		if(value && value.hidden === false){
			    			result.push(field);
			    		}
			    	}
			    	if(addtotalCol){
			    		var tempStr = result.join(",");
			    		if(tempStr.indexOf("shouldtaxmoney") == -1 && tempStr.indexOf("viewdetail") == -1 ){
			    		    tempStr += ',shouldtaxmoney,avoidtaxmoney,alreadyshouldtaxmoney,owetaxmoney';
//			    		    tempStr += ',shouldtaxmoney,avoidtaxmoney,owetaxmoney,alreadyshouldtaxmoney,stayinspecttaxmoney';
			    	    }
			    		result = tempStr.split(',');
			    	}
			    	return result;
			    },
			    getDisplayColumnInfoAry:function(/*array[jquery column info]*/ ary){  //根据ary获取所有需要展现的列,在页面上要展现的列
			    	var tempAry = this.getDisplayColumnFieldAry(ary);
			    	var tempStr = tempAry.join(",");
			    	
			    	if(tempStr.indexOf("shouldtaxmoney") == -1 && tempStr.indexOf("viewdetail") == -1 ){
			    		tempStr += ',shouldtaxmoney,avoidtaxmoney,alreadyshouldtaxmoney,owetaxmoney,viewdetail';
//			    		tempStr += ',shouldtaxmoney,avoidtaxmoney,owetaxmoney,alreadyshouldtaxmoney,stayinspecttaxmoney,viewdetail';
			    	}
			    	tempAry =  tempStr.split(",");
			    	var result = new Array();
			    	for(var i = 0;i < tempAry.length;i++){
			    		var prop = tempAry[i];
			    		var colInfo = colMap.get(prop);
			    		if(colInfo){
			    			result.push(colInfo);
			    		}
			    	}
			    	return result;
			    },
			    getExportMapping:function(ary){           //根据ary获取导出至excel的对应对象
			    	
			    	var keyAry = this.getDisplayColumnFieldAry(ary,true);
			    	var valueAry = new Array();
			    	for(var i = 0; i < keyAry.length;i++){
			    		var key = keyAry[i];
			    		var valueCol = colMap.get(key);
			    		var valueField = valueCol.title;
			    		valueAry.push(valueField);
			    	}
			    	return {
			    		property:keyAry.join(","),
			    		display:valueAry.join(",")
			    	     };
			    },
			    getNewGroupStr:function(groupStr,subtotalStr){  //groupStr = taxpayerid,taxpayername,taxtypecode,taxtypename;
			    	                                            //subtotalStr = taxtypecode,taxtypename
			    	                                            //return taxtypecode,taxtypename,taxpayerid,taxpayername
			    	if(jQuery.trim(subtotalStr) == ''){
			    		return groupStr;
			    	}
			    	if(groupStr.indexOf(subtotalStr) == 0){
			    		return groupStr;
			    	}
			    	var groupAry = groupStr ? groupStr.split(","):new Array();
			    	var subtotalAry = subtotalStr ? subtotalStr.split(","):new Array();
			    	
			    	var tempAry = new Array();
					for(var i = 0;i < subtotalAry.length;i++){
						tempAry.push(subtotalAry[i]);
					}
					for(var i = 0;i < groupAry.length;i++){
						var gStr = groupAry[i];
						var have = false;
						for(var j = 0;j < subtotalAry.length;j++){
							var sStr = subtotalAry[j];
							if(gStr == sStr){
								have = true;
								break;
							}
						}
						if(!have){
							tempAry.push(gStr);
						}
					}
					return tempAry.join(",");
			    },
			    getHiddenColumn : function(ary){
			    	var result = false ||  new Array();
			    	for(var i = 0;i < ary.length;i++){
			    		var field = ary[i];
			    		var colInfo = colMap.get(field);
			    		if(colInfo.hidden == true || field == "taxyear" || field == "taxyearmonth"){
			    			result.push(field);
			    		}
			    	}
			    	return result;
			    },
			    getDetailExprtMap:function(){
			    	//var key  = "formula,regularvalue,formulavalue,result,estateserial,holddate,landarea,taxfreearea,taxpayername,taxorgname,taxdeptname,taxmanagername,taxtypename,taxname,datatypename,taxmoney,taxbegindate,taxenddate,levydatedesc,paydate,cleardate";
			    	//var value = "公式,参与公式计算的值,公式计算值,公式计算的结果,宗地编号,土地获取日期,土地面积,减免面积,纳税人名称,区县税务机关,主管税务机关,专管员,税种,税目,状态,金额,所属期起,所属期止,征期类型,催缴日期,清缴日期";
			        var key  = "taxpayerid,taxpayername,taxtypename,taxname,taxorgname,taxdeptname,taxmanagername,taxbegindate,taxenddate,shouldtaxmoney,alreadyshouldtaxmoney,derateflagname,levydatetypename";
			    	var value = "计算机编码,纳税人名称,税种,税目,区县税务机关,主管税务机关,税收管理员,计税起日期,计税止日期,应缴金额,已缴金额,状态,征期类型";
			    	
			    	return {propertyCols:key,dislpayCols:value};
			    },
			    downloadFile:function(url,params){
			    	
			    },
			    test : function(){
			    	var col = colMap.get("taxpayername");
			    }
			    
	    	};
	    	return obj;
			
}());
ShouldTaxUtils.test();
