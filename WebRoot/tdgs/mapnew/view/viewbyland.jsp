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
                <script src="/js/jquery.simplemodal.js">
                </script>
                <script src="/js/uploadmodal.js">
                </script>
                <script src="/js/common.js">
                </script>
                <script src="/supergis/SuperMap.Include.js">
                </script>
                <script src="/supergis/SuperMap-7.0.1-11323.js">
                </script>
                <script src="/supergis/Lang/zh-CN.js">
                </script>
                <script src="/js/datecommon.js">
                </script>
                <script src="/js/common.js">
                </script>
                <script src="/js/newmap.js">
                </script>
                <script>
                    //opttype = 'query';
                    String.prototype.trim = function() {
                        return this.replace(/(^\s*)|(\s*$)/g, '');
                    }
                    var locationdata = new Object; //所属乡镇缓存
                    var groundusedata = new Array(); //土地用途缓存
                    var businessdata = new Array();
                    var belongtocountry = new Array();
                    var belongtowns = new Array();
					var lastpointsmid = '';
					var lasttdgysmid ='';
                    var optmenu = [{
                        text: '查询',
                        iconCls: 'icon-search',
                        handler: function() {
                            $('#querywindow').window('open');
                        }
                    }];
                    $(function() {
                        $('#queryform #taxrate').combobox({
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
                        });
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
                        var regex = new RegExp("\"", "g");
                        $.ajax({
                            type: "get",
							async : false,
                            url: "/soption/taxOrgOptionInit.do",
                            data: {
                                "moduleAuth": "15",
                                "emptype": "30"
                            },
                            dataType: "json",
                            success: function(jsondata) {
                                $('#taxorgsupcode').combobox({
                                    data: jsondata.taxSupOrgOptionJsonArray,
                                    valueField: 'key',
                                    textField: 'keyvalue',
                                    onSelect: function(n, o) {
                                        //alert(n.key);
                                        $.ajax({
                                            type: "get",
                                            url: "/soption/taxOrgOptionBySup.do",
                                            data: {
                                                "taxSuperOrgCode": n.key
                                            },
                                            dataType: "json",
                                            success: function(jsondata) {
                                                //alert(JSON.stringify(jsondata));
                                                $('#taxorgcode').combobox({
                                                    data: jsondata.taxOrgOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                $('#taxdeptcode').combobox({
                                                    data: jsondata.taxDeptOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                $('#taxmanagercode').combobox({
                                                    data: jsondata.taxEmpOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                //$('#taxdeptcode').combobox("clear");
                                                //$('#taxempcode').combobox("clear");

                                                //$('#taxdeptcode').combobox({}).combobox('clear');
                                            }
                                        });
                                    }
                                });
                                if (jsondata.taxSupOrgOptionJsonArray.length == 1) {
                                    //alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
                                    $('#taxorgsupcode').combobox("setValue", JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
                                    $('#taxorgsupcode').combobox("setText", JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
                                }

                                $('#taxorgcode').combobox({
                                    data: jsondata.taxOrgOptionJsonArray,
                                    valueField: 'key',
                                    textField: 'keyvalue',
                                    onSelect: function(n, o) {
                                        $.ajax({
                                            type: "get",
                                            url: "/soption/taxDeptOptionByOrg.do",
                                            data: {
                                                "taxOrgCode": n.key
                                            },
                                            dataType: "json",
                                            success: function(jsondata) {
                                                $('#taxdeptcode').combobox({
                                                    data: jsondata.taxDeptOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                $('#taxmanagercode').combobox({
                                                    data: jsondata.taxEmpOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                //$('#taxdeptcode').combobox("clear");
                                                //$('#taxempcode').combobox("clear");

                                                //$('#taxdeptcode').combobox({}).combobox('clear');
                                            }
                                        });
                                    }
                                });
                                if (jsondata.taxOrgOptionJsonArray.length == 1) {
                                    //alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
                                    $('#taxorgcode').combobox("setValue", JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
                                    $('#taxorgcode').combobox("setText", JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
                                }

                                $('#taxdeptcode').combobox({
                                    data: jsondata.taxDeptOptionJsonArray,
                                    valueField: 'key',
                                    textField: 'keyvalue',
                                    onSelect: function(n, o) {
                                        $.ajax({
                                            type: "get",
                                            url: "/soption/getTaxEmpByOrgCode.do",
                                            data: {
                                                "taxDeptCode": n.key,
                                                "emptype": "30"
                                            },
                                            dataType: "json",
                                            success: function(jsondata) {
                                                $('#taxmanagercode').combobox({
                                                    data: jsondata.taxEmpOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                //$('#taxdeptcode').combobox("clear");
                                                //$('#taxempcode').combobox("clear");

                                                //$('#taxdeptcode').combobox({}).combobox('clear');
                                            }
                                        });
                                    }
                                });
                                if (jsondata.taxDeptOptionJsonArray.length == 1) {
                                    //alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
                                    $('#taxdeptcode').combobox("setValue", JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
                                    $('#taxdeptcode').combobox("setText", JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
                                }

                                $('#taxmanagercode').combobox({
                                    data: jsondata.taxEmpOptionJsonArray,
                                    valueField: 'key',
                                    textField: 'keyvalue'
                                });
                                //分局登录 默认选中
                                var orgclass = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getUserTaxOrgVO().getOrgclass()%>';
                                var taxdeptcode = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
                                var taxempcode = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
                                if (orgclass == '04') {
                                    $('#taxdeptcode').combobox("setValue", taxdeptcode);
                                    $('#taxmanagercode').combobox("setValue", taxempcode)
                                }
                            }
                        });
                        $('#landinfogrid').datagrid({
                            fitColumns: false,
                            maximized: 'true',
                            pagination: true,
							columns:[[
								{field:'estateid',hidden:true,width:18},
								{field:'estateserialno',title:'宗地编号',width:80,align:'center'},
								{field:'landcertificate',title:'土地证号',width:120,align:'center'},
								{field:'taxpayerid',title:'计算机编码',width:120,align:'center'},
								{field:'taxpayername',title:'纳税人名称',width:120,align:'center'},
								{field:'locationtypename',title:'坐落地类型',width:120,align:'center'},
								{field:'belongtocountryname',title:'所属村委会',width:120,align:'center'},
								{field:'holddate',title:'交付日期',formatter:formatterDate,width:120,align:'center'},
								{field:'landarea',title:'土地面积(平方米)',width:120,align:'center'},
								{field:'landmoney',title:'土地总价(元)',width:120,align:'center'},
								{field:'shouldtaxmoney',title:'应缴金额',width:120,align:'center'},
								{field:'alreadyshouldtaxmoney',title:'已缴金额',width:120,align:'center'},
								{field:'owetaxmoney',title:'欠税金额',width:120,align:'center'}
							]],
                            singleSelect: true,
                            toolbar: optmenu,
                            rowStyler: rowbackcolor,
							onClickRow:function(rowindex,rowData){
							   var selectObjectId = rowData.layerid;
							   if(selectObjectId != null && selectObjectId != ''){
								 focusLand(selectObjectId);
							   }
							}
                        });
                        var p = $('#landinfogrid').datagrid('getPager');
                        $(p).pagination({
                            showPageList: false,
                            pageSize: 15
                        });
                        mapInit('mapdiv');
                        //getFeaturesByIDs();
                    });
                    

                    function query() {
                        getTdgyQuery();

                        //markerLayer.removeAllFeatures();
                        //var bounds = map.getExtent();
                        //var feature = new SuperMap.Feature.Vector();
                        //feature.geometry = bounds.toGeometry();
                        // feature.style = style;
                        // markerLayer.addFeatures(feature);

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
                        opts.url = '/viewanalizy/getlandcontainstax.do';
                        $('#landinfogrid').datagrid('load', params);
                        var p = $('#landinfogrid').datagrid('getPager');
                        $(p).pagination({
                            showPageList: false,
                            pageSize: 15
                        });
                        $('#landinfogrid').datagrid('unselectAll');
                        $('#querywindow').window('close');

                    }
                    function getCondition() {
                        var params = {};
                        var fields = $('#queryform').serializeArray();
                        $.each(fields,
                        function(i, field) {
                            params[field.name] = field.value;
                        });
                        var otherCondition = '';
                        if (params.mintax) {
                            otherCondition += ' and shouldtaxmoney >= ' + params.mintax;
                        }
                        if (params.maxtax) {
                            otherCondition += ' and shouldtaxmoney <= ' + params.mintax;
                        }
                        params['otherCondition'] = otherCondition;
                        return params;
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
                    function getTdgyQuery() {
                        var params = getCondition();
                        var tdgyobjectids = ""; //宗地编号
                        var taxpayerobjectids = "";
                        var tdgyownary = [];
                        var taxpayerownary = [];
                        params['isrelation'] = '1';
                        $.ajax({
                            type: "post",
                            async: true,
                            url: "/viewanalizy/getlandlist.do",
                            data: params,
                            dataType: "json",
                            success: function(jsondata) {
								vectorlayer.removeAllFeatures();
								pointvectorlayer.removeAllFeatures();
								if(jsondata.length>0){
									for (var i = 0; i < jsondata.length; i++) {
										if (jsondata[i].tdgyobjectids) {
											tdgyobjectids += jsondata[i].tdgyobjectids + ",";
											if (jsondata[i].ownstatus == '1') {
												tdgyownary.push(jsondata[i].tdgyobjectids);
											}
										}
										if (jsondata[i].taxpayerobjectids) {
											taxpayerobjectids += jsondata[i].taxpayerobjectids + ",";
											if (jsondata[i].ownstatus == '1') {
												taxpayerownary.push(jsondata[i].taxpayerobjectids);
											}
										}
									}
									if (tdgyobjectids) {
										tdgyobjectids = tdgyobjectids.substring(0, tdgyobjectids.length - 1);
									}
									if (taxpayerobjectids) {
										taxpayerobjectids = taxpayerobjectids.substring(0, taxpayerobjectids.length - 1);
									}
									querymapinfoonly(taxpayerobjectids, tdgyobjectids);
								}
							}
                        });
                    }
                    function onFeatureSelect(feature) {
						closeInfoWin();
                        var tdgysmid = parseInt(feature.attributes.TDGYID).toString();
                        var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID', tdgysmid);
                        if (tdgyfeatures.length > 0) {
                            vectorlayer.removeFeatures(tdgyfeatures[0]);
                            if(tdgyfeatures[0].attributes.ISRELATION =='01'){
								tdgyfeatures[0].style = selectstyle01;
							}else{
								tdgyfeatures[0].style = selectstyle00;
							}
                            vectorlayer.addFeatures(tdgyfeatures[0]);
                            //vectorlayer.redraw();
                            //var icon = new SuperMap.Icon("/theme/images/marker.png", size, offset);
                        }
                        var contentHTML = '';
                        if (feature.attributes.ISRELATION == '01' && feature.attributes.ZDBH != '' && feature.attributes.ZDBH != null) {
                            $.ajax({
                                type: "post",
                                async: false,
                                url: "/landavoidtaxmanager/selectlandlist.do",
                                data: {
                                    'estateserialno': feature.attributes.ZDBH
                                },
                                dataType: "json",
                                success: function(jsondata) {
                                    if (jsondata && jsondata.length > 0) {
                                        //var title = "土地信息";
                                        contentHTML = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
                                        contentHTML += "<tr><th>查看土地信息</th><th>权属人</th><th>宗地编号</th><th>交付日期</th><th>土地面积(平方米)</th><th>土地总价(元)</th><th>实际面积(平方米)</th></tr>";
                                        //content +="<tr><td colspan='6'><a href='xx()'>删除此地块</a></td></tr>";
                                        for (var i = 0; i < jsondata.length; i++) {
                                            var land = jsondata[i];
                                            contentHTML += "<tr><td><a href=\"javascript:showEstateInfo('" + land.estateid + "')\">土地详细信息</a></td><td>" + land.taxpayername + "</td><td>" + land.estateserialno + "</td>" + "<td>" + formatterDate(land.holddate) + "</td>" + "<td>" + land.landarea + "</td><td>" + land.landmoney + "</td><td>" + parseFloat(tdgyfeatures[0].attributes.SMAREA).toFixed(3) + "</td></tr>";
                                        }
                                        contentHTML += '</table>';
                                        //currentObj.map.infoWindow.resize(600,300);
                                        //currentObj.map.infoWindow.setTitle(title);
                                        //currentObj.map.infoWindow.setContent(content);
                                        //currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
                                    } else {
                                        //currentObj.map.infoWindow.resize(250,100);
                                        //currentObj.map.infoWindow.setTitle('土地信息');
                                        contentHTML = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
                                        contentHTML += "<tr><td> <b>此块土地无权属人</b></td></tr>";
                                        contentHTML += '</table>';
                                        //currentObj.map.infoWindow.setContent(content);
                                        //currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
                                    }
                                }
                            });
                        }

                        //feature.attributes.TDGYID

                        var popup = new SuperMap.Popup.FramedCloud("popwin", feature.geometry.getBounds().getCenterLonLat(), null, contentHTML, null, true, null, true);
						popup.setBackgroundColor("#000000");
                        infowin = popup;
                        map.addPopup(popup);
                    }

                    function onFeatureUnselect(feature) {
                        closeInfoWin();
                        var tdgysmid = parseInt(feature.attributes.TDGYID).toString();
                        var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID', tdgysmid);
                        if (tdgyfeatures.length > 0) {
                            vectorlayer.removeFeatures(tdgyfeatures[0]);
                            if (tdgyfeatures[0].attributes.ISRELATION == '01') {
                                tdgyfeatures[0].style = style01;
                            } else {
                                tdgyfeatures[0].style = style00;
                            }
                            vectorlayer.addFeatures(tdgyfeatures[0]);
                        }

                    }
					function showEstateInfo(estateid){
						$('#landinfowindow').window({
						   href : "viewland.jsp?d="+new Date(),
						   onLoad:function(){
							  afterLandLoaded(estateid);
						   }
					   });
					   //查看土地的基本信息
					   $('#landinfowindow').window('open');
					}
					var focusLand = function(layerid){
						//var sumid = parseInt(layerid);
						var g = null;
						var point = null;
						var pointfeature;
						if(lastpointsmid != '' && lasttdgysmid != ''){
							querymapinfoonly(lastpointsmid, lasttdgysmid);
						}
						if(layerid){
							var pointfeatures = pointvectorlayer.getFeaturesByAttribute('SMID',parseInt(layerid).toString());
							if(pointfeatures.length>0){
								closeInfoWin();
								var tdgysmid = parseInt(pointfeatures[0].attributes.TDGYID).toString();
								var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID', tdgysmid);
								if (tdgyfeatures.length > 0) {
									vectorlayer.removeFeatures(tdgyfeatures[0]);
									if(tdgyfeatures[0].attributes.ISRELATION =='01'){
										tdgyfeatures[0].style = selectstyle01;
									}else{
										tdgyfeatures[0].style = selectstyle00;
									}
									vectorlayer.addFeatures(tdgyfeatures[0]);
								}
								lastpointsmid = layerid;
								lasttdgysmid = tdgysmid;
								$.ajax({
									type: "post",
									async: false,
									url: "/landavoidtaxmanager/selectlandlist.do",
									data: {
										'estateserialno': pointfeatures[0].attributes.ZDBH
									},
									dataType: "json",
									success: function(jsondata) {
										if (jsondata && jsondata.length > 0) {
											//var title = "土地信息";
											contentHTML = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
											contentHTML += "<tr><th>查看土地信息</th><th>权属人</th><th>宗地编号</th><th>交付日期</th><th>土地面积(平方米)</th><th>土地总价(元)</th><th>实际面积(平方米)</th></tr>";
											//content +="<tr><td colspan='6'><a href='xx()'>删除此地块</a></td></tr>";
											for (var i = 0; i < jsondata.length; i++) {
												var land = jsondata[i];
												contentHTML += "<tr><td><a href=\"javascript:showEstateInfo('" + land.estateid + "')\">土地详细信息</a></td><td>" + land.taxpayername + "</td><td>" + land.estateserialno + "</td>" + "<td>" + formatterDate(land.holddate) + "</td>" + "<td>" + land.landarea + "</td><td>" + land.landmoney + "</td><td>" + parseFloat(tdgyfeatures[0].attributes.SMAREA).toFixed(3) + "</td></tr>";
											}
											contentHTML += '</table>';
										} else {
											contentHTML = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
											contentHTML += "<tr><td> <b>此块土地无权属人</b></td></tr>";
											contentHTML += '</table>';
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
								});
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
                                    <th data-options="field:'holddate',width:120,align:'center',editor:{type:'validatebox'}">
                                        交付日期
                                    </th>
                                    <th data-options="field:'landarea',width:120,align:'center',editor:{type:'validatebox'}">
                                        土地面积
                                    </th>
                                    <th data-options="field:'landmoney',width:120,align:'center',editor:{type:'validatebox'}">
                                        土地总价
                                    </th>
                                    <th data-options="field:'shouldtaxmoney',width:120,align:'center',editor:{type:'validatebox'}">
                                        应缴金额
                                    </th>
                                    <th data-options="field:'alreadyshouldtaxmoney',width:120,align:'center',editor:{type:'validatebox'}">
                                        已缴金额
                                    </th>
                                    <th data-options="field:'owetaxmoney',width:120,align:'center',editor:{type:'validatebox'}">
                                        欠税金额
                                    </th>
                                </tr> -->
                            </thead>
                        </table>
                    </div>
                    <div id="mapdiv1" data-options="region:'center'">
						<div id = "shiliang">
						<a id="changemap" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'" onclick="changemap();">切换卫星图</a>
						</div>
						<div id = "weixing" style="display:none">
						<a id="changemap" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'" onclick="changemap();">切换矢量图</a>
						</div>
                        <div id="mapdiv" style="position:absolute;left:0px;right:0px;width:700px;height:580px;">
                        </div>
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
                                    所属乡镇：
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
                                    土地证号：
                                </td>
                                <td>
                                    <input class="easyui-validatebox" name="landcertificate" id="landcertificate"
                                    />
                                </td>
                                <td align="right">
                                    宗地编号：
                                </td>
                                <td>
                                    <input class="easyui-validatebox" name="estateserialno" id="estateserialno"
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    土地用途：
                                </td>
                                <td>
                                    <input class="easyui-validatebox" name="purpose" id="purpose" />
                                </td>
                                <td align="right">
                                    土地等级：
                                </td>
                                <td>
                                    <input class="easyui-combobox" name="taxrate" id="taxrate" />
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
                            <tr>
                                <td align="right">
                                    土地面积：
                                </td>
                                <td colspan="3">
                                    <input id="minarea" class="easyui-numberbox" name="minarea" style="width: 150px;"
                                    />
                                    至
                                    <input id="maxarea" class="easyui-numberbox" name="maxarea" style="width:150px;"
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    应纳税：
                                </td>
                                <td colspan="3">
                                    <input id="mintax" class="easyui-numberbox" name="mintax" style="width: 150px;"
                                    />
                                    至
                                    <input id="maxtax" class="easyui-numberbox" name="maxtax" style="width:150px;"
                                    />
                                </td>
                            </tr>
                        </table>
                    </form>
                    <div style="text-align:center;padding:5px;height: 25px;">
                        <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">
                            查询
                        </a>
                    </div>
                </div>
				<div id="landinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地相关信息',collapsible:false,
				   minimizable:false,maximizable:false,closable:true,href:'viewland.jsp'" style="width:1050px;height:540px;">
				</div>
            </body>
        
        </html>
