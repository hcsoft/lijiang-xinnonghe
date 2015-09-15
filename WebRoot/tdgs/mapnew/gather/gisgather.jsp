<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"
    %>
        <!DOCTYPE html>
        <html>
            
            <head>
                <base target="_self" />
                <title>
                </title>
                <link rel="stylesheet" href="/themes/sunny/easyui.css">
                <link rel="stylesheet" href="/themes/icon.css">
                <link rel="stylesheet" href="/css/toolbar.css">
                <link rel="stylesheet" href="/css/logout.css" />
                <link rel="stylesheet" href="/css/tablen.css" />
                <script src="/js/jquery-1.8.2.min.js">
                </script>
                <script src="/js/jquery.easyui.min.js">
                </script>
                <script src="/js/tiles.js">
                </script>
                <script src="/js/moduleWindow.js">
                </script>
                <script src="/menus.js">
                </script>
                <script src="/js/jquery.simplemodal.js">
                </script>
                <script src="/js/overlay.js">
                </script>
                <script src="/js/jquery.json-2.2.js">
                </script>
                <script src="/js/json2.js">
                </script>
                <script src="/locale/easyui-lang-zh_CN.js">
                </script>
                <script src="/js/uploadmodal.js">
                </script>
                <script src="/js/common.js">
                </script>
				<script src="/js/datecommon.js"></script>
                <script src="/supergis/SuperMap.Include.js">
                </script>
                <script src="/supergis/SuperMap-7.0.1-11323.js">
                </script>
                <script src="/supergis/Lang/zh-CN.js">
                </script>
				<script src="/js/newmap.js">
                </script>
                <script>
                    //var host = document.location.toString().match(/file:\/\//) ? "http://localhost:8090": 'http://' + document.location.host;
                    opt ='opt';
                    String.prototype.trim = function() {
                        return this.replace(/(^\s*)|(\s*$)/g, '');
                    }
                    var locationdata = new Object; //所属乡镇缓存
                    var groundusedata = new Array(); //土地用途缓存
                    var businessdata = new Array();
                    var belongtocountry = new Array();
                    var belongtowns = new Array();
                    var optmenu = [{
                        text: '查询',
                        iconCls: 'icon-search',
                        handler: function() {
                            $('#querywindow').window('open');
                        }
                    }];
                    $(function() {
                       /*-- $('#queryform #taxrate').combobox({
                            data: [{
                                key: '',
                                value: '--请选择土地等级--'
                            },
                            {
                                key: '3',
                                value: '一等'
                            },
                            {
                                key: '2',
                                value: '二等'
                            },
                            {
                                key: '1',
                                value: '三等'
                            }],
                            valueField: 'key',
                            textField: 'value'
                        }); --*/
						var managerLink = new OrgLink();
						managerLink.sendMethod = false;
						managerLink.loadData();
                        $('#queryform #countrytown').combobox({
                            onSelect: function(data) {
                                CommonUtils.getCacheCodeFromTable('COD_DISTRICT', 'id', 'name', '#queryform #belongtowns', " and parentid = '" + data.key + "' ", true);
                            }
                        });
                        CommonUtils.getCacheCodeFromTable('COD_DISTRICT', 'id', 'name', '#queryform #countrytown', " and parentid = '530122' ", true);

                        CommonUtils.getCacheCodeFromTable('COD_LOCATIONTYPE', 'locationtypecode', 'locationtypename', '#queryform #locationtype', " ", true);
                        CommonUtils.getCacheCodeFromTable('COD_LANDCERTIFICATETYPE', 'landcertificatetypecode', 'landcertificatetypename', '#queryform #landcertificatetype', " ", true);

                        $('#isrelation').combobox({
                            data: [{
                                key: '',
                                keyvalue: '所有'
                            },
                            {
                                key: '0',
                                keyvalue: '未关联'
                            },
                            {
                                key: '1',
                                keyvalue: '已关联'
                            }],
                            valueField: 'key',
                            textField: 'keyvalue'
                        });
                        

                        $('#landinfogrid').datagrid({
                            fitColumns: false,
                            maximized: 'true',
                            pagination: true,
                            singleSelect: true,
                            toolbar: optmenu,
                            rowStyler: rowbackcolor,
							columns:[[
								{field:'layerid',hidden:true,width:18},
								{field:'belongtowns',hidden:true,width:18},
								{field:'estateid',hidden:true,width:18},
								{field:'estateserialno',title:'宗地编号',width:80,align:'center'},
								{field:'landcertificate',title:'土地证号',width:120,align:'center'},
								{field:'taxpayerid',title:'计算机编码',width:120,align:'center'},
								{field:'taxpayername',title:'纳税人名称',width:120,align:'center'},
								{field:'locationtypename',title:'坐落地类型',width:120,align:'center'},
								{field:'belongtocountryname',title:'所属村委会',width:120,align:'center'},
								{field:'holddate',title:'交付日期',formatter:formatterDate,width:120,align:'center'},
								{field:'landarea',title:'土地面积(平方米)',width:120,align:'center'},
								{field:'landmoney',title:'土地总价(元)',width:120,align:'center'}
							]],
							onClickRow:function(rowindex,rowData){
							   var selectObjectId = rowData.layerid;
							   if(selectObjectId != null && selectObjectId != ''){
								 focusLand(selectObjectId);
							   }
							   //map.setCenter(new SuperMap.LonLat(1, 1), 4);
							   //getFeaturesByIDs(1);
							   //selectPoint(1);
							}
                        });
                        var p = $('#landinfogrid').datagrid('getPager');
                        $(p).pagination({
                            showPageList: false,
                            pageSize: 15
                        });
                        mapInit('mapdiv');
						
						//query();
                        //getFeaturesByIDs();
                    });


                    
                    

                    
					
                    /*-- function getFeaturesByIDs(smId) {
                        vectorLayerpiece.removeAllFeatures();
                        var id = new Array();
                        id.push(smId);
                        var getFeaturesByIDsParameters, getFeaturesByIDsService;
                        getFeaturesByIDsParameters = new SuperMap.REST.GetFeaturesByIDsParameters({
                            returnContent: true,
                            datasetNames: ["World:Countries"],
                            fromIndex: 0,
                            toIndex: -1,
                            IDs: id
                        });
                        getFeaturesByIDsService = new SuperMap.REST.GetFeaturesByIDsService(url2, {
                            eventListeners: {
                                "processCompleted": processCompleted2,
                                "processFailed": processFailed2
                            }
                        });
                        getFeaturesByIDsService.processAsync(getFeaturesByIDsParameters);
                    }
                    function processCompleted2(getFeaturesEventArgs) {
                        var i, len, features, feature, result = getFeaturesEventArgs.result;
                        if (result && result.features) {
                            features = result.features
                            for (i = 0, len = features.length; i < len; i++) {
                                feature = features[i];
                                feature.style = style;
                                vectorLayerpiece.addFeatures(feature);
                            }
                        }
                    }
                    function processFailed2(e) {
                        alert(e.error.errorMsg);
                    } --*/
                    
                    //function onFeatureSelect(feature) {
                    //    alert('选中');
                    //}
                    function query(i) {
                        //markerLayer.removeAllFeatures();
                        //var bounds = map.getExtent();
                        //var feature = new SuperMap.Feature.Vector();
                        //feature.geometry = bounds.toGeometry();
                        // feature.style = style;
                        // markerLayer.addFeatures(feature);
                        
						//alert($('#taxorgsupcode').combo('getValue'));
                        var params = {};
                        var fields = $('#queryform').serializeArray();
                        $.each(fields,
                        function(i, field) {
                            params[field.name] = field.value;
                        });
                        $('#landinfogrid').datagrid('loadData', {
                            total: 0,
                            rows: []
                        });
                        var opts = $('#landinfogrid').datagrid('options');
						opts.url = '/landavoidtaxmanager/selectland.do';
                        $('#landinfogrid').datagrid('load', params);
                        var p = $('#landinfogrid').datagrid('getPager');
                        $(p).pagination({
                            showPageList: false,
                            pageSize: 15
                        });
                        $('#landinfogrid').datagrid('unselectAll');
                        $('#querywindow').window('close');
						//显示地图
						if(i==0){
							querymapinfo();
						}
						//alert('d1='+d1+'\n'+'d2='+d2+'\n'+'d3='+d3+'\n'+'d4='+d4+'\n'+'d5='+d5+'\n'+'d6='+d6+'\n');
                    }
					
                   
                    
                    //激活编辑地物
                    function editselectedFeature() {
                        vectorLayerpiece.removeAllFeatures();
                        if (ids == null) {
                            alert("请先选择地物");
                        } else {
                            //modifyFeature.activate();
                        }

                    }
                    
                    function format(row) {
                        for (var i = 0; i < locationdata.length; i++) {
                            if (locationdata[i].key == row) return locationdata[i].value;
                        }
                        return row;
                    }
                    function formatgrounduse(row) {
                        for (var i = 0; i < groundusedata.length; i++) {
                            if (groundusedata[i].key == row) return groundusedata[i].value;
                        }
                        return row;
                    }

                    function formatbusiness(row) {
                        for (var i = 0; i < businessdata.length; i++) {
                            if (businessdata[i].businesscode == row) return businessdata[i].businessname;
                        }
                        return row;
                    }
					function formatterDate(value,row,index){
							return formatDatebox(value);
					  }
                    //function quereyreg(){
                    //	$('#reginfowindow').window('open');//打开新录入窗口
                    //	$('#reginfowindow').window('refresh', 'reginfo.jsp');
                    //}
                    function Load() {
                        $("<div class=\"datagrid-mask\"></div>").css({
                            display: "block",
                            width: "100%",
                            height: $(window).height()
                        }).appendTo("body");
                        $("<div class=\"datagrid-mask-msg\"></div>").html("正在操作，请稍候。。。").appendTo("body").css({
                            display: "block",
                            left: ($(document.body).outerWidth(true) - 190) / 2,
                            top: ($(window).height() - 45) / 2
                        });
                    }

                    //hidden Load   
                    function dispalyLoad() {
                        $(".datagrid-mask").remove();
                        $(".datagrid-mask-msg").remove();
                    }
                    function rowbackcolor(index, row) {
                        if ($.trim(row.layerid)) {
                            return 'background-color:#CCFFFF;';
                        }
                    }
					/*-- function deleteSelectedFeature() {
						vectorLayerpiece.removeAllFeatures();
						if (ids == null) {
							alert("请先选择地块！");
						} else {
							var editFeatureParameter, editFeatureService;
							editFeatureParameter = new SuperMap.REST.EditFeaturesParameters({
								IDs: ids,
								editType: SuperMap.REST.EditType.DELETE
							});
							editFeatureService = new SuperMap.REST.EditFeaturesService(url2, {
								eventListeners: {
									"processCompleted": deleteFeaturesProcessCompleted,
									"processFailed": processFailed
								}
							});
							editFeatureService.processAsync(editFeatureParameter);
						}
					
					}
					//删除地物完成
					function deleteFeaturesProcessCompleted(editFeaturesEventArgs) {
						if (editFeaturesEventArgs.result.resourceInfo.succeed) {
							alert("删除地物成功");
							//重新加载图层
							vectorLayer.removeAllFeatures();
							map.removeLayer(layer, true);
							layer = new SuperMap.Layer.TiledDynamicRESTLayer("京津", url1, {
								transparent: true,
								cacheEnabled: false
							},
							{
								maxResolution: "auto"
							});
							layer.events.on({
								"layerInitialized": reloadLayer
							});
						} else {
							alert("删除地物失败");
						}
					} --*/
					function selectland(){
						drawPoint.activate();
					}
					
					var taxsourceobjectid = null;//点sumid
					var tdgyid = null; //面id
					var realationvalue = null;
					//relation 0 第一次关联   1 查看关联信息   2 第二次关联
					function showEstateInfo(relation,pointsmid,tdgysmid){
						realationvalue = relation;
						taxsourceobjectid = pointsmid;
						tdgyid = tdgysmid;
						queryCoreEstate(relation,pointsmid);
						if(relation == 1){ //查看关联的税源信息
							$('#operLandDiv').hide();
						}else{  //选择土地进行关联
							$('#operLandDiv').show();
						}
						$('#landInfoDiv').window('open');
					}
					//查询关联信息
					function queryCoreEstate(relation,taxobjectid){
						var params = {};
						if(relation == 1){
							params['layerid'] = taxobjectid;
						}else{
							params['taxpayerid']= $('#landInfoDiv #taxpayerid').val();
							params['taxpayername'] = $('#landInfoDiv #taxpayername').val();
						}
						params['pagesize'] = '10';
					   var opts = $('#landInfoRelationTable').datagrid('options');
					   opts.url = '/landavoidtaxmanager/selectland.do?d='+new Date();
					   $('#landInfoRelationTable').datagrid('load',params); 
					   var p = $('#landInfoRelationTable').datagrid('getPager');  
					   $(p).pagination({  
								showPageList:false
					   });
					}
					//关联
					function relationEstate(){
						var row = $('#landInfoRelationTable').datagrid('getSelected');
						if(row == null){
							 $.messager.alert('提示消息','请选择需要关联的土地记录!','info');
							 return;
						}
						if(!taxsourceobjectid){
							$.messager.alert('提示消息','请选择需要关联的税源信息!','info');
							 return;
						}
						$.messager.confirm('税源关联','您确认关联当前土地吗？',function(r){   
							if (r){   
								//alert(taxsourceobjectid+'-----------'+tdgyid);
								//return;
								var params = {};
								params['tdgyobjectid'] = tdgyid;
								//var xzqdm = attrss.行政区代码;
								params['villagecode'] = row.belongtowns;
								if(!params['tdgyobjectid']){
									$.messager.alert('提示消息','此税源点找不到相应的地块信息!','info');
									return;
								}
								//if(!params['villagecode']){
								//	$.messager.alert('提示消息','此税源点找不到相应的村委会信息!','info');
								//	return;
								//}
								params['taxsourceobjectid'] = taxsourceobjectid;
								params['first'] = realationvalue == 0 ? '1' : '0';
								params['estateid'] = row.estateid;
								params['estateserialno'] = row.estateserialno;
								$.messager.progress();
								$.ajax({
									   type: "post",
									   url: "/Relation/newHandRelation.do",
									   data: params,
									   dataType: "json",
									   success: function(jsondata){
										   $.messager.progress('close');
										   if(jsondata.sucess){
												$.messager.alert('提示','税源关联成功!','info',function(){
													$('#landInfoDiv').window('close');
													closeInfoWin();
													var pointfeatures = pointvectorlayer.getFeaturesByAttribute('SMID',parseInt(taxsourceobjectid).toString());
													var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID', parseInt(tdgyid).toString());
													pointvectorlayer.removeFeatures(pointfeatures);
													vectorlayer.removeFeatures(tdgyfeatures);
													querymapinfoonly(taxsourceobjectid,tdgyid)
													query(1);
												});
										   }else{
											   $.messager.alert('提示','税源关联失败!');
										   }
									   }
							   });
							}   
						});  
					}
					function deleteRelationEstate(taxsourceobjectid,tdgysmid){
						$.messager.confirm('税源关联','您确认删除当前关联的土地信息吗？',function(r){   
							if(r){ 
								var params = {};
								params['tdgyobjectid'] = tdgysmid;
								params['taxsourceobjectid'] = taxsourceobjectid;
								$.messager.progress();
									$.ajax({
										   type: "post",
										   url: "/Relation/newDeleteRelation.do",
										   data: params,
										   dataType: "json",
										   success: function(jsondata){
											   $.messager.progress('close');
											   if(jsondata.sucess){
													$.messager.alert('提示','税源关联删除成功!','info',function(){
														//重新渲染feature
														var pointfeatures = pointvectorlayer.getFeaturesByAttribute('SMID',parseInt(taxsourceobjectid).toString());
														var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID', parseInt(tdgysmid).toString());
														pointvectorlayer.removeFeatures(pointfeatures);
														vectorlayer.removeFeatures(tdgyfeatures);
														closeInfoWin();
														querymapinfoonly(taxsourceobjectid,tdgysmid)
														query(1);
													});
											   }else{
												   $.messager.alert('提示','税源关联删除失败!');
											   }
										   }
								   });
							}
						});
					}
				function addland(){
					var row = $('#landinfogrid').datagrid('getSelected');
					if(row == null){
						$.messager.alert('提示消息','请选择需要添加地块的信息！','info');
						return;
					}
					if(row.layerid != null && row.layerid != '' && row.layerid != ' '){
						$.messager.alert('提示消息','该地块已进行关联!','info');
						return;
					}
					//vectorlayer.removeAllFeatures();
					drawPolygon.activate();
				}
				function deleteland(pointsmid,tdgysmid){
					$.messager.confirm('删除地块','您确认删除的地块信息吗？',function(r){   
						if(r){
							var editFeatureParameter,
							editFeatureService;
							editFeatureParameter = new SuperMap.REST.EditFeaturesParameters({
								IDs: [tdgysmid],
								//features:[selectmarker.pointfeature],
								editType: SuperMap.REST.EditType.DELETE,
								returnContent:true
							});
							editFeatureService = new SuperMap.REST.EditFeaturesService(tdgydataseturl, {
								eventListeners: {
									"processCompleted": function(editFeaturesEventArgs){
										var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID',parseInt(tdgysmid).toString());
										if(tdgyfeatures.length>0){
											vectorlayer.removeFeatures(tdgyfeatures);
										}
									},
									"processFailed": processFailed
								}
							});
							editFeatureService.processAsync(editFeatureParameter);

							editFeatureParameter = new SuperMap.REST.EditFeaturesParameters({
								IDs: [pointsmid],
								//features:[selectmarker.tdgyfeature],
								editType: SuperMap.REST.EditType.DELETE,
								returnContent:true
							});
							editFeatureService = new SuperMap.REST.EditFeaturesService(taxpayerinfodataseturl, {
								eventListeners: {
									"processCompleted": function(editFeaturesEventArgs){
										var pointfeatures = pointvectorlayer.getFeaturesByAttribute('SMID',parseInt(pointsmid).toString());
										if(pointfeatures.length>0){
											pointvectorlayer.removeFeatures(pointfeatures);
										}
										closeInfoWin();
										$.messager.alert('提示','删除地块成功!');
									},
									"processFailed": processFailed
								}
							});
							editFeatureService.processAsync(editFeatureParameter);
						}
					});
					
				}
				function onFeatureSelect(feature) {
					closeInfoWin();
					var contentHTML='';
						if(feature.attributes.ISRELATION =='01'){//已关联，绿色
							contentHTML = "<div style='width:160px;font-size:1em; opacity: 0.8; overflow-y:hidden;'><div><b><a style='pading:1px;' href='javascript:showEstateInfo(1,"+feature.attributes.SMID+")'>查看此地块关联的税源信息</a></b>"+
										"<br/><b><a style='pading:1px;' href='javascript:deleteRelationEstate("+feature.attributes.SMID+","+feature.attributes.TDGYID+")'>删除此地块关联的税源信息</a></b>"+
										"<br/><b><a style='pading:1px;' href='javascript:showEstateInfo(2,"+feature.attributes.SMID+","+feature.attributes.TDGYID+")'>二次关联</a></b></div>";
						}else{
							contentHTML = "<div style='width:130px;font-size:1em; opacity: 0.8; overflow-y:hidden;'><div><b><a href='javascript:showEstateInfo(0,"+feature.attributes.SMID+","+feature.attributes.TDGYID+")'>税源关联</a></b><br/><b><a href='javascript:deleteland("+feature.attributes.SMID+","+feature.attributes.TDGYID+")'>删除地块</a></b></div></div>";
						}
					var tdgysmid = parseInt(feature.attributes.TDGYID).toString();
					var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID',parseInt(tdgysmid).toString());
					if(tdgyfeatures.length>0){
						vectorlayer.removeFeatures(tdgyfeatures);
						if(tdgyfeatures[0].attributes.ISRELATION =='01'){
							tdgyfeatures[0].style = selectstyle01;
						}else{
							tdgyfeatures[0].style = selectstyle00;
						}
						//tdgyfeatures[0].style.strokeWidth = 2;
						vectorlayer.addFeatures(tdgyfeatures[0]);
						//vectorlayer.redraw();
						//var icon = new SuperMap.Icon("/theme/images/marker.png", size, offset);
						var popup = new SuperMap.Popup.FramedCloud("popwin", feature.geometry.getBounds().getCenterLonLat(), null, contentHTML, null, true, null, true);
						infowin = popup;
						map.addPopup(popup);
					}
				}

				function onFeatureUnselect(feature) {
					closeInfoWin();
					var tdgysmid = parseInt(feature.attributes.TDGYID).toString();
					var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID',parseInt(tdgysmid).toString());
					if(tdgyfeatures.length>0){
						vectorlayer.removeFeatures(tdgyfeatures);
						if(tdgyfeatures[0].attributes.ISRELATION =='01'){
							tdgyfeatures[0].style = style01;
						}else{
							tdgyfeatures[0].style = style00;
						}
						vectorlayer.addFeatures(tdgyfeatures[0]);
					}
					
				}
				var focusLand = function(layerid){
					//var sumid = parseInt(layerid);
					var g = null;
					var point = null;
					var pointfeature;
					if(layerid){
						var pointfeatures = pointvectorlayer.getFeaturesByAttribute('SMID',parseInt(layerid).toString());
						if(pointfeatures.length>0){
							closeInfoWin();
							var contentHTML='';
							if(pointfeatures[0].attributes.ISRELATION =='01'){//已关联，绿色
								contentHTML = "<div style='width:160px;font-size:1em; opacity: 0.8; overflow-y:hidden;'><div><b><a style='pading:1px;' href='javascript:showEstateInfo(1,"+pointfeatures[0].attributes.SMID+")'>查看此地块关联的税源信息</a></b>"+
												"<br/><b><a style='pading:1px;' href='javascript:deleteRelationEstate("+pointfeatures[0].attributes.SMID+","+pointfeatures[0].attributes.TDGYID+")'>删除此地块关联的税源信息</a></b>"+
												"<br/><b><a style='pading:1px;' href='javascript:showEstateInfo(2,"+pointfeatures[0].attributes.SMID+")'>二次关联</a></b></div>";
							}else{
								contentHTML = "<div style='width:130px;font-size:1em; opacity: 0.8; overflow-y:hidden;'><div><b><a href='javascript:showEstateInfo(0,"+pointfeatures[0].attributes.SMID+","+pointfeatures[0].attributes.TDGYID+")'>税源关联</a></b><br/><b><a href='javascript:deleteland("+pointfeatures[0].attributes.SMID+","+pointfeatures[0].attributes.TDGYID+")'>删除地块</a></b></div></div>";
							}
							var popup = new SuperMap.Popup.FramedCloud("popwin",new SuperMap.LonLat(pointfeatures[0].geometry.x , pointfeatures[0].geometry.y), null, contentHTML, null, true, null, true);
							infowin = popup;
							map.addPopup(popup);
							//var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID',parseInt(pointfeatures[0].attributes.TDGYID).toString());
							//if(tdgyfeatures.length>0){
							//	vectorlayer.removeFeatures();
							//	tdgyfeatures[0].style = style;
							//	vectorlayer.addFeatures(tdgyfeatures[0]);
							//}
							map.setCenter(new SuperMap.LonLat(pointfeatures[0].geometry.x , pointfeatures[0].geometry.y), 6);
						}
						
					}
				}
				
                </script>
            </head>
            
            <body>
                <div class="easyui-layout" style="width:100%;height:580px;">
                    <div data-options="region:'west'" id="mainWestDiv" style="height:500px;width:600px;overflow: hidden;">
                        <table id='landinfogrid' style="height:580px;width:100;">
                            <thead>
                                <!-- <tr>
                                									<th data-options="field:'layerid',hidden:true,width:50,align:'center',value:'1',editor:{type:'validatebox'}"></th>
                                									<th data-options="field:'belongtowns',hidden:true,width:50,align:'center',value:'1',editor:{type:'validatebox'}"></th>
                                    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">
                                        主键
                                    </th>
                                    <th data-options="field:'estateserialno',width:120,align:'center',editor:{type:'validatebox'}">
                                        宗地编号
                                    </th>
                                    <th data-options="field:'landcertificate',width:120,align:'center',editor:{type:'validatebox'}">
                                        土地证号
                                    </th>
                                    <th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">
                                        计算机编码
                                    </th>
                                    <th data-options="field:'taxpayername',width:175,align:'left',editor:{type:'validatebox'}">
                                        纳税人名称
                                    </th>
                                    <th data-options="field:'locationtypename',width:175,align:'center',editor:{type:'validatebox'}">
                                        坐落地类型
                                    </th>
                                    <th data-options="field:'belongtocountryname',width:175,align:'center',editor:{type:'validatebox'}">
                                        所属村委会
                                    </th>
                                    <th data-options="field:'holddate',width:120,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">
                                        交付日期
                                    </th>
                                    <th data-options="field:'landarea',width:120,align:'center',editor:{type:'validatebox'}">
                                        土地面积
                                    </th>
                                    <th data-options="field:'landmoney',width:120,align:'center',editor:{type:'validatebox'}">
                                        土地总价
                                    </th>
                                </tr> -->
                            </thead>
                        </table>
                    </div>
                    <div id="mapdiv1" data-options="region:'center'">
						<!-- <div id="tabdiv" class="easyui-tabs" style="width:99;height:567px;"> -->
			    <div title="GIS数据">
			        <div id = "shiliang">
			        <!-- <a id="landInfoId" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'">地块信息</a> -->
			        <a id="drawLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="addland();">增加地块</a>
					<a id="canceldrawLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cancel'" onclick="javascript:drawPolygon.deactivate();">取消增加地块</a>
					<a id="changemap" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'" onclick="changemap();">切换卫星图</a>
					<!-- <a id="selectLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-business1'" onclick="selectland();">选择地块</a>
					<a id="deleteLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cancel'" onclick="deleteSelectedFeature()">删除地块</a> -->
			        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font style="color: red;font-weight: bold;">绿色已关联，蓝色未关联</font>
			        </div>
					<div id = "weixing" style="display:none">
			        <!-- <a id="landInfoId" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'">地块信息</a> -->
			        <a id="drawLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="addland();">增加地块</a>
					<a id="canceldrawLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cancel'" onclick="javascript:drawPolygon.deactivate();">取消增加地块</a>
					<a id="changemap" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'" onclick="changemap();">切换矢量图</a>
					<!-- <a id="selectLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-business1'" onclick="selectland();">选择地块</a>
					<a id="deleteLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cancel'" onclick="deleteSelectedFeature()">删除地块</a> -->
			        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font style="color: red;font-weight: bold;">绿色已关联，蓝色未关联</font>
			        </div>
					<div id="mapdiv" style="position:absolute;left:0px;right:0px;width:700px;height:580px;">
                     </div> 
			    </div>
			    <!-- <div title="地块坐标">  
			        <table id='coordinateTable' class="easyui-datagrid" style="height:400px;width:99;overflow: hidden;"
			    					      data-options="singleSelect:true,rownumbers:true,toolbar:'#coordinatetoolbar'">
			    						<thead>
			    							<tr>
			    								<th data-options="field:'x',width:200,align:'center',editor:{type:'validatebox'}">X坐标</th>
			    								<th data-options="field:'y',width:200,align:'center',editor:{type:'validatebox'}">Y坐标</th>
			    							</tr>
			    					   </thead>
			       </table>
			       <div id="coordinatetoolbar" style="width:99; height:25px; padding:1px;border:1px solid #ddd;overflow:hidden">	
			    					    <a class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openAddCoordinate()">添加坐标</a>	   
			    					    <a class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="editCoordinate()">编辑坐标</a>	
			    					    <a class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteCoordinate()">删除坐标</a>	  
			    					    <a class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="addCoordinateComplete()">完成坐标</a>
			    					    <font color="red">所有坐标操作需点击完成坐标操作才生效</font>
			    				  </div>
			    </div>
			    		  </div> -->
                        
                    </div>
                </div>
                <div id="querywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地查询条件',collapsible:false,
                minimizable:false,maximizable:false,closable:true" style="width:700px;">
                    <form id="queryform" method="post">
                        <table id="narjcxx" width="100%" class="table table-bordered">
                            <tr>
                                <td align="right">
                                    州市地税机关：
                                </td>
                                <td>
                                    <input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode"
                                    data-options="disabled:false,panelWidth:300,panelHeight:200" />
                                </td>
                                <td align="right">
                                    县区地税机关：
                                </td>
                                <td>
                                    <input class="easyui-combobox" name="taxorgcode" id="taxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200"
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    主管地税部门：
                                </td>
                                <td>
                                    <input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"
                                    />
                                </td>
                                <td align="right">
                                    税收管理员：
                                </td>
                                <td>
                                    <input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode"
                                    data-options="disabled:false,panelWidth:300,panelHeight:200" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    计算机编码：
                                </td>
                                <td>
                                    <input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid"
                                    />
                                </td>
                                <td align="right">
                                    纳税人名称：
                                </td>
                                <td>
                                    <input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername"
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    房产所属乡镇：
                                </td>
                                <td>
                                    <input class="easyui-combobox" id="countrytown" name="countrytown" data-validate="p"
                                    />
                                </td>
                                <td align="right">
                                    所属村委会：
                                </td>
                                <td>
                                    <input class="easyui-combobox" id="belongtowns" name="belongtowns" data-options="disabled:false,panelWidth:200,panelHeight:200"
                                    data-validate="p" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    坐落地类型：
                                </td>
                                <td>
                                    <input class="easyui-combobox" name="locationtype" id="locationtype" />
                                </td>
                                <td align="right">
                                    土地证类型：
                                </td>
                                <td>
                                    <input class="easyui-combobox" name="landcertificatetype" id="landcertificatetype"
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    交付日期：
                                </td>
                                <td colspan="3">
                                    <input id="beginholddate" class="easyui-datebox" name="beginholddate"
                                    style="width: 150px;" />
                                    至
                                    <input id="endholddate" class="easyui-datebox" name="endholddate" style="width:150px;"
                                    />
                                    地块关联情况：
                                    <input class="easyui-combobox" name="isrelation" id="isrelation" style="width: 100px;"
                                    />
                                </td>
                            </tr>
                        </table>
                    </form>
                    <div style="text-align:center;padding:5px;height: 25px;">
                        <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query(0)">
                            查询
                        </a>
                    </div>
                </div>
				<div id="landInfoDiv" class="easyui-window" title="土地信息查询" data-options="iconCls:'icon-save',closed:true,modal:true,collapsible:true" 
				 style="width:540px;padding:5px;top:40px;left:10px;">
					计算机编码：<input type="text" id="taxpayerid" style="width:120px;"/>&nbsp;
					纳税人名称：<input type="text" id="taxpayername" style="width:200px;"/>&nbsp;
					<div align="center" id="operLandDiv">
					 <a class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-search'" onclick="queryCoreEstate()">查询</a>&nbsp;&nbsp;
					 <a class="easyui-linkbutton" iconCls="icon-add" onclick="relationEstate()">关联</a>&nbsp;&nbsp;
					</div>
					<table id="landInfoRelationTable" class="easyui-datagrid" style="width:510px;height:330px;padding:5px;overflow:scroll;"
							data-options="iconCls:'icon-edit',pagination:true,pageList:[10],singleSelect:true,
													rowStyler: function(index,row){
														if (row.layerid != null && $.trim(row.layerid) != ''){
															return 'background-color:red;color:#fff;font-weight:bold;';
														}
													}
							">
						<thead>
							<tr>
								<th data-options="field:'ckxxx',checkbox:true"></th>
								<th data-options="field:'estateid',hidden:true,width:100">计算机编码</th>
								<th data-options="field:'taxpayerid',width:100">计算机编码</th>
								<th data-options="field:'taxpayername',width:200">纳税人名称</th>
								<th data-options="field:'estateserialno',width:120">宗地编号</th>
								<th data-options="field:'landarea',width:100">土地面积(平方米)</th>
								<th data-options="field:'detailaddress',width:200">地址</th>
								<th data-options="field:'belongtowns',hidden:'true',width:200">所属村委会</th>
							</tr>
						</thead>
					</table>
				</div>
            </body>
        
        </html>
