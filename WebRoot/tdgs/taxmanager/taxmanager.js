function formatterDate(value,row,index){
			return formatDatebox(value);
}
/*
根据税种提供列的信息
*/
var TaxSourceUtils = (function(){
	        //定义不同税源的列信息
	
	        var checkCol =  {'field':'checked','width':50,'align':'center','checkbox':true,'editor':{type:'checkbox'}};
	        var taxflagCol = {'field':'taxflagname','width':100,'align':'center','editor':{'type':'validatebox'},'title':'应纳税状态'};
	        
	        var sourceIdCol = {'field':'serialno','width':0,hidden:true,'align':'center','editor':{'type':'validatebox'},'title':'主键'};
	        
	        var estateserialnoCol = {'field':'estateserialno','width':100,'align':'center','editor':{'type':'validatebox'},'title':'宗地编号'};
	        var taxpayeridCol = {'field':'taxpayerid','width':100,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'计算机编码','orgcol':'taxpayername'};
			var taxpayernameCol = {'field':'taxpayername','width':200,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'纳税人名称'};
			var landtaxpriceCol = {'field':'taxrate','width':150,'align':'center','editor':{'type':'validatebox'},'title':'土地使用税单位税额'};
			var landareaCol = {'field':'landarea','width':150,'align':'center','editor':{'type':'validatebox'},'title':'计税面积'};
			var taxdatebeginCol = {'field':'taxdatebegin','width':150,'align':'center','formatter':formatterDate,'editor':{'type':'validatebox'},'title':'计税起日期'};
			var taxdateendCol = {'field':'taxdateend','width':150,'align':'center','formatter':formatterDate,'editor':{'type':'validatebox'},'title':'计税止日期'};
			var transmoneyCol = {'field':'transmoney','width':150,'align':'center','editor':{'type':'validatebox'},'title':'租金'};
			var deratetypeCol = {'field':'deratetype','width':150,'align':'center','editor':{'type':'validatebox'},'title':'减免（减少）类型'};
			var deratereasonCol = {'field':'deratereason','width':150,'align':'center','editor':{'type':'validatebox'},'title':'减免（减少）原因'};
			
			
			var landAry = [checkCol,taxflagCol,sourceIdCol,estateserialnoCol,taxpayeridCol,taxpayernameCol,landtaxpriceCol,landareaCol,
				           transmoneyCol,taxdatebeginCol,taxdateendCol,deratetypeCol,deratereasonCol];
		
			var checkHouseCol =  {'field':'checked','width':50,'align':'center','checkbox':true,'editor':{type:'checkbox'}};
			var taxflagHouseCol = {'field':'taxflagname','width':100,'align':'center','editor':{'type':'validatebox'},'title':'应纳税状态'};
			var sourceIdHouseCol = {'field':'serialno','width':0,hidden:true,'align':'center','editor':{'type':'validatebox'},'title':'主键'};
			
			var estateserialnoHouseCol = {'field':'estateserialno','width':100,'align':'center','editor':{'type':'validatebox'},'title':'宗地编号'};
	        var taxpayeridHouseCol = {'field':'taxpayerid','width':100,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'计算机编码','orgcol':'taxpayername'};
			var taxpayernameHouseCol = {'field':'taxpayername','width':200,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'纳税人名称'};
			var taxdatebeginHouseCol = {'field':'taxdatebegin','width':150,'align':'center','formatter':formatterDate,'editor':{'type':'validatebox'},'title':'计税起日期'};
			var taxdateendHouseCol = {'field':'taxdateend','width':150,'align':'center','formatter':formatterDate,'editor':{'type':'validatebox'},'title':'计税止日期'};
			var deratetypeHouseCol = {'field':'deratetype','width':150,'align':'center','editor':{'type':'validatebox'},'title':'减免（减少）类型'};
			var deratereasonHouseCol = {'field':'deratereason','width':150,'align':'center','editor':{'type':'validatebox'},'title':'减免（减少）原因'};
			var housetaxoriginalvalueCol = {'field':'housetaxoriginalvalue','width':150,'align':'center','editor':{'type':'validatebox'},'title':'计税原值'};
			var houselandmoneyCol = {'field':'houselandmoney','width':150,'align':'center','editor':{'type':'validatebox'},'title':'分摊土地价款'};
			var rateoftaxableCol = {'field':'rateoftaxable','width':150,'align':'center','editor':{'type':'validatebox'},'title':'余值扣除率'};
			var houseresidualvalueCol = {'field':'houseresidualvalue','width':150,'align':'center','editor':{'type':'validatebox'},'title':'房产原值'};
			var transmoneyHouseCol = {'field':'transmoney','width':150,'align':'center','editor':{'type':'validatebox'},'title':'年租金'};
			var houseareaCol = {'field':'housearea','width':150,'align':'center','editor':{'type':'validatebox'},'title':'房产建筑面积'};
			
			var houseAry = [checkHouseCol,taxflagHouseCol,sourceIdHouseCol,estateserialnoHouseCol,taxpayeridHouseCol,taxpayernameHouseCol,housetaxoriginalvalueCol,houselandmoneyCol,
				           rateoftaxableCol,houseresidualvalueCol,transmoneyHouseCol,houseareaCol,taxdatebeginHouseCol,taxdateendHouseCol,
				           deratetypeHouseCol,deratereasonHouseCol];
			
			 var checkPloughCol =  {'field':'checked','width':50,'align':'center','checkbox':true,'editor':{type:'checkbox'}};
			 var taxflagPloughCol = {'field':'taxflagname','width':100,'align':'center','editor':{'type':'validatebox'},'title':'应纳税状态'};
			 var sourceIdPloughCol = {'field':'serialno','width':0,hidden:true,'align':'center','editor':{'type':'validatebox'},'title':'主键'};
			 
			var ploughtaxareaCol = {'field':'ploughtaxarea','width':150,'align':'center','editor':{'type':'validatebox'},'title':'计税面积'};
			var taxpayeridPloughCol = {'field':'taxpayerid','width':200,'hidden':true,'align':'center','editor':{'type':'validatebox'},'title':'计算机编码','orgcol':'taxpayername'};
			var taxpayernamePloughCol = {'field':'taxpayername','width':240,'hidden':false,'align':'center','editor':{'type':'validatebox'},'title':'纳税人名称'};
			
			var deratetypePloughCol = {'field':'deratetype','width':200,'align':'center','editor':{'type':'validatebox'},'title':'减免（减少）类型'};
			var deratereasonPloughCol = {'field':'deratereason','width':200,'align':'center','editor':{'type':'validatebox'},'title':'减免（减少）原因'};
			
			var ploughAry = [checkPloughCol,taxflagPloughCol,sourceIdPloughCol,taxpayeridPloughCol,taxpayernamePloughCol,ploughtaxareaCol,deratetypePloughCol,deratereasonPloughCol];
			
			return {
				getColumnConfig:function(type){  //land,house,plough
				    if(type == 'LAND'){
				    	return landAry;
				    }else if(type == 'HOUSE'){
				    	return houseAry;
				    }else if(type == 'PLOUGH'){
				    	return ploughAry;
				    }else{
				    	throw '不支持此类型【'+type+'】的税种！';
				    }
				}
			};
			
}());

