//需要引入common.js

function ModelInfo(bustype,bustypename){
	this.bustype = bustype;
	this.bustypename = bustypename;
}
var cacheMap = new Map();
cacheMap.push("51",new ModelInfo("51","房产销售"));
cacheMap.push("52",new ModelInfo("52","房产投资联营"));
cacheMap.push("53",new ModelInfo("53","房产捐赠"));
cacheMap.push("61",new ModelInfo("61","房产出租"));
cacheMap.push("62",new ModelInfo("62","房产融资租赁"));
cacheMap.push("63",new ModelInfo("63","房产出典"));
cacheMap.push("64",new ModelInfo("51","房产转让"));
