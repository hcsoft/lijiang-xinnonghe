<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ include file="/common/inc.jsp" %>
        <!DOCTYPE html>
        
        <head>
            <title>
                土地视角分析
            </title>
            <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.4/3.4/js/dojo/dijit/themes/claro/claro.css"
            />
            <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.7/3.7/js/esri/css/esri.css"
            />
            <link rel="stylesheet" href="/themes/sunny/easyui.css">
            <link rel="stylesheet" href="/themes/icon.css">
            <link rel="stylesheet" type="text/css" href="/css/tablen.css">
            <link rel="stylesheet" href="/css/spectrum.css">
            <script src="/js/jquery-1.8.2.min.js">
            </script>
            <script src="/js/jquery.easyui.min.js">
            </script>
            <script src="/js/jquery.json-2.2.js">
            </script>
            <script src="/js/easyui-lang-zh_CN.js">
            </script>
            <script src="/js/spectrum.js">
            </script>
            <script src="/js/datecommon.js">
            </script>
            <script src="/js/common.js">
            </script>
            <script src="/js/widgets.js">
            </script>
            <script src="../config.js">
            </script>
            <script>
                var dojoConfig = {
                    parseOnLoad: true
                };
            </script>
            <script src="<%=spath%>/arcgis_js_api/library/3.7/3.7/init.js">
            </script>
            <script src="/js/mapcommon.js">
            </script>
            <style type="text/css">
                .dialogopen{ background-color: red; }
            </style>
            <script>
                //注意此页面的元素不要和viewland.jsp和viewhouse.jsp的元素冲突
                esri.config.defaults.io.proxyUrl = "proxy.jsp";
                var arcgisMap = null;
                var map = null;

                var OwnTaxPayerObjectIds = null;
                var OwnTdgyObjectIds = null;
                function getTdgyQuery(callback) {
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
                            if (callback) {
                                callback({
                                    'tdgyobjectids': tdgyobjectids,
                                    'owntdgyobjectids': tdgyownary.join(','),
                                    'taxpayerobjectids': taxpayerobjectids,
                                    'owntaxpayerobjectids': taxpayerownary.join(',')
                                });
                            }
                        }
                    });
                }
                var INITIAL = true;
                function initMap() {
                    getTdgyQuery(function(params) {
                        OwnTaxPayerObjectIds = params.owntaxpayerobjectids;
                        OwnTdgyObjectIds = params.owntdgyobjectids;
                        arcgisMap = new ArcgisMap({
                            mapdiv: 'map',
                            visiblelayer: [ArcgisMap.taxpayerlayerid, ArcgisMap.tdgylayerid, ArcgisMap.forestlayerid, ArcgisMap.villagelayerid, ArcgisMap.townlayerid],
                            loadingdiv: 'loadingImg',
                            load: initToolbar,
                            tdgyclick: mapLandClick,
                            taxpayerclick: taxPayerLayerClick,
                            layerloaded: function() {
                                var tdgyLayer = arcgisMap.getTdgyLayer();
                                var taxpayerLayer = arcgisMap.getTaxpayerLayer();
                                if (INITIAL) {
                                    if (params.tdgyobjectids) {
                                        tdgyLayer.setDefinitionExpression(" OBJECTID in (" + params.tdgyobjectids + ") ");
                                        //refresh方法不用调
                                        //tdgyLayer.refresh();
                                    } else {
                                        tdgyLayer.setDefinitionExpression(" OBJECTID < 0 ");
                                    }
                                    if (params.taxpayerobjectids) {
                                        taxpayerLayer.setDefinitionExpression(" OBJECTID in (" + params.taxpayerobjectids + ")  ");
                                    } else {
                                        taxpayerLayer.setDefinitionExpression(" OBJECTID < 0 ");
                                    }
                                    INITIAL = false;
                                }
                                console.log(OwnTdgyObjectIds + "===" + OwnTaxPayerObjectIds);
                                dojo.connect(tdgyLayer, "onUpdateStart",
                                function() {
                                    if (OwnTdgyObjectIds) {
                                        var q = new esri.tasks.Query();
                                        q.where = " OBJECTID in (" + OwnTdgyObjectIds + ")";
                                        tdgyLayer.selectFeatures(q, esri.layers.FeatureLayer.SELECTION_NEW,
                                        function(features) {

});
                                        OwnTdgyObjectIds = null;
                                    }
                                });
                                dojo.connect(taxpayerLayer, "onUpdateStart",
                                function() {
                                    if (OwnTaxPayerObjectIds) {
                                        var q = new esri.tasks.Query();
                                        q.where = " OBJECTID in (" + OwnTaxPayerObjectIds + ")";
                                        taxpayerLayer.selectFeatures(q, esri.layers.FeatureLayer.SELECTION_NEW,
                                        function(features) {

});
                                        OwnTaxPayerObjectIds = null;
                                    }
                                });
                            }
                        });
                        map = arcgisMap.map;
                    });
                }
                function showEstateInfo(estateid) {
                    $('#landinfowindow').window({
                        href: "viewland.jsp?d=" + new Date(),
                        onLoad: function() {
                            afterLandLoaded(estateid);
                        }
                    });
                    //查看土地的基本信息
                    $('#landinfowindow').window('open');
                }
                function showMapEstate(evt, zdbh, actualArea) {
                    var currentObj = arcgisMap;
                    if (evt.graphic.attributes.ISRELATION == "00") {
                        currentObj.map.infoWindow.resize(250, 100);
                        currentObj.map.infoWindow.setTitle('土地信息');
                        var content = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
                        content += "<tr><td> <b>此块土地无权属人</b></td></tr>";
                        content += '</table>';
                        currentObj.map.infoWindow.setContent(content);
                        currentObj.map.infoWindow.show(evt.screenPoint, currentObj.map.getInfoWindowAnchor(evt.screenPoint));
                    } else if (evt.graphic.attributes.ISRELATION == "01" && zdbh) {
                        $.ajax({
                            type: "post",
                            async: false,
                            url: "/landavoidtaxmanager/selectlandlist.do",
                            data: {
                                'estateserialno': zdbh
                            },
                            dataType: "json",
                            success: function(jsondata) {
                                if (jsondata && jsondata.length > 0) {
                                    var title = "土地信息";
                                    var content = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
                                    content += "<tr><th>查看土地信息</th><th>权属人</th><th>宗地编号</th><th>交付日期</th><th>土地面积</th><th>土地总价</th><th>实际面积(平方米)</th></tr>";
                                    //content +="<tr><td colspan='6'><a href='xx()'>删除此地块</a></td></tr>";
                                    for (var i = 0; i < jsondata.length; i++) {
                                        var land = jsondata[i];
                                        content += "<tr><td><a href=\"javascript:showEstateInfo('" + land.estateid + "')\">土地详细信息</a></td><td>" + land.taxpayername + "</td><td>" + land.estateserialno + "</td>" + "<td>" + ArcgisMap.formatterDate(land.holddate) + "</td>" + "<td>" + land.landarea + "</td><td>" + land.landmoney + "</td><td>" + actualArea + "</td></tr>";
                                    }
                                    content += '</table>';
                                    currentObj.map.infoWindow.resize(600, 300);
                                    currentObj.map.infoWindow.setTitle(title);
                                    currentObj.map.infoWindow.setContent(content);
                                    currentObj.map.infoWindow.show(evt.screenPoint, currentObj.map.getInfoWindowAnchor(evt.screenPoint));
                                } else {
                                    currentObj.map.infoWindow.resize(250, 100);
                                    currentObj.map.infoWindow.setTitle('土地信息');
                                    var content = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
                                    content += "<tr><td> <b>此块土地无权属人</b></td></tr>";
                                    content += '</table>';
                                    currentObj.map.infoWindow.setContent(content);
                                    currentObj.map.infoWindow.show(evt.screenPoint, currentObj.map.getInfoWindowAnchor(evt.screenPoint));
                                }
                            }
                        });
                    }
                }
                function taxPayerLayerClick(evt) {
                    var currenObjectId = evt.graphic.attributes.TDGYID;
                    var currentObj = this;
                    var g = currentObj.focusLand(false, currenObjectId, null);
                    if (g) {
                        var zdbh = g.attributes.ZDBH;
                        var actualArea = g.attributes.ACTUALAREA;
                        actualArea = parseFloat(actualArea).toFixed(3);
                        showMapEstate(evt, zdbh, actualArea);
                    }
                }
                function mapLandClick(evt) {
                    var currenObjectId = evt.graphic.attributes.OBJECTID;
                    var currentObj = this;
                    currentObj.focusLand(false, evt, evt.graphic);
                    var zdbh = evt.graphic.attributes.ZDBH;
                    var actualArea = evt.graphic.attributes.ACTUALAREA;
                    actualArea = parseFloat(actualArea).toFixed(3);
                    showMapEstate(evt, zdbh, actualArea);
                }

                var tb = null;
                function initToolbar() {
                    tb = new esri.toolbars.Draw(map);
                    dojo.connect(tb, "onDrawEnd", addGraphic);
                    dojo.connect(dojo.byId("mesureArea"), "click",
                    function() {
                        ArcgisMap.DRAW = true;
                        map.infoWindow.hide();
                        map.graphics.clear();
                        tb.activate(esri.toolbars.Draw.POLYGON);
                    });
                }
                function addGraphic(geometry) {
                    tb.deactivate();
                    map.graphics.clear();
                    map.graphics.add(new esri.Graphic(geometry, ArcgisMap.getHighlightSymbol()));
                    ArcgisMap.calculateAreaAndLength(geometry,
                    function(areas, lengths) {
                        var area = areas[0].toFixed(3);
                        var length = lengths[0].toFixed(3);
                        var unitArea = (areas[0] * 0.0015).toFixed(3); //亩
                        $.messager.alert('提示消息', '所画地块的面积为' + area + '平方米，' + unitArea + '亩!', 'info',
                        function() {
                            map.graphics.clear();
                        });
                    });
                }
                dojo.ready(initMap);
            </script>
            <script type="text/javascript">
                function formatterDate(value, row, index) {
                    return formatDatebox(value);
                }
                $(function() {

                    var managerLink = new OrgLink();
                    managerLink.sendMethod = false;
                    managerLink.loadData();

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
                    var params = getCondition();
                    $('#landInfoTable').datagrid({
                        fitColumns: false,
                        maximized: 'true',
                        pagination: true,
                        pageList: [15],
                        queryParams: params,
                        singleSelect: true,
                        url: '/viewanalizy/getlandcontainstax.do',
                        rowStyler: rowbackcolor,
                        onDblClickRow: landDbClick,
                        onClickRow: landClick
                    });
                    var p = $('#landInfoTable').datagrid('getPager');
                    $(p).pagination({
                        showPageList: false
                    });
                    $(p).pagination({
                        showPageList: false
                    });

                });
                function landClick(rowIndex, rowData) {
                    $.ajax({
                        type: "post",
                        async: true,
                        url: "/gisgather/gettdgylayerobjectid.do",
                        data: {
                            'estateid': rowData.estateid
                        },
                        dataType: "json",
                        success: function(jsondata) {
                            var g = arcgisMap.focusLand(true, jsondata.result);
                            var evt = {};
                            evt.graphic = g;
                            evt.screenPoint = new esri.geometry.Point(g.attributes.X, g.attributes.Y);
                            var zdbh = evt.graphic.attributes.ZDBH;
                            var actualArea = evt.graphic.attributes.ACTUALAREA;
                            actualArea = parseFloat(actualArea).toFixed(3);
                            showMapEstate(evt, zdbh, actualArea);
                        }
                    });
                }
                function landDbClick(rowIndex, rowData) {
                    $('#landinfowindow').window({
                        href: "viewland.jsp?d=" + new Date(),
                        onLoad: function() {
                            afterLandLoaded(rowData.estateid);
                        }
                    });
                    //查看土地的基本信息
                    $('#landinfowindow').window('open');
                    // window.showModalDialog('viewland.jsp',rowData.estateid,"center:yes;dialogHeight:580px;dialogWidth:1050px;");
                }
                function openQueryLand() {
                    $('#landquerydiv').window('open');
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
                function queryLand() {
                    map.infoWindow.hide();
                    var params = getCondition();
                    var opts = $('#landInfoTable').datagrid('options');
                    opts.url = '/viewanalizy/getlandcontainstax.do?d=' + new Date();
                    $('#landInfoTable').datagrid('load', params);
                    var p = $('#landInfoTable').datagrid('getPager');
                    $(p).pagination({
                        showPageList: false
                    });
                    $('#landquerydiv').window('close');
                    queryMap();
                }
                function queryMap() {
                    map.infoWindow.hide();
                    map.graphics.clear();
                    var tdgyLayer = arcgisMap.getTdgyLayer();
                    var taxpayerLayer = arcgisMap.getTaxpayerLayer();
                    var q = new esri.tasks.Query();
                    q.where = " OBJECTID < 0 ";
                    tdgyLayer.selectFeatures(q, esri.layers.FeatureLayer.SELECTION_NEW,
                    function(features) {

});
                    q = new esri.tasks.Query();
                    q.where = " OBJECTID < 0 ";
                    taxpayerLayer.selectFeatures(q, esri.layers.FeatureLayer.SELECTION_NEW,
                    function(features) {

});

                    getTdgyQuery(function(params) {
                        OwnTaxPayerObjectIds = params.owntaxpayerobjectids;
                        OwnTdgyObjectIds = params.owntdgyobjectids;
                        if (params.tdgyobjectids) {
                            tdgyLayer.setDefinitionExpression(" OBJECTID in (" + params.tdgyobjectids + ") ");
                        } else {
                            tdgyLayer.setDefinitionExpression(" OBJECTID < 0 ");
                        }
                        if (params.taxpayerobjectids) {
                            taxpayerLayer.setDefinitionExpression(" OBJECTID in (" + params.taxpayerobjectids + ")  ");
                        } else {
                            taxpayerLayer.setDefinitionExpression(" OBJECTID < 0 ");
                        }
                    });
                }
                function displayland(otype) {
                    if (otype == 1) {
                        $('#landinfodiv').show();
                        $('#mapdiv').hide();
                        $('#landinfodiv').css('float', 'none');
                        $('#landinfodiv').css('width', '100%');
                        $('#landInfoTable').datagrid({

});
                        var p = $('#landInfoTable').datagrid('getPager');
                        $(p).pagination({
                            showPageList: false
                        });

                    } else if (otype == 2) {
                        $('#landinfodiv').hide();
                        $('#mapdiv').show();
                        $('#mapdiv').css('float', 'none');
                        $('#mapdiv').css('width', '100%');
                        map.resize(true);
                        map.reposition();
                        //arcgisMap.navToolbar.zoomToFullExtent();

                        /*
		  $('#map').remove();
		  var newMapDiv = $("<div id='map' style='width:100%;height:625px; border:0px solid #000;'>");
		  $('#mapdiv').append(newMapDiv);
		  initMap();
		  */
                    } else if (otype == 3) {
                        $('#landinfodiv').css('float', 'left');
                        $('#landinfodiv').css('width', '37%');
                        $('#mapdiv').css('float', 'right');
                        $('#mapdiv').css('width', '63%');
                        $('#landinfodiv').show();
                        $('#mapdiv').show();
                        $('#landInfoTable').datagrid({

});
                        var p = $('#landInfoTable').datagrid('getPager');
                        $(p).pagination({
                            showPageList: false
                        });
                        map.resize(true);
                        map.reposition();
                        //arcgisMap.navToolbar.zoomToFullExtent();

                        // var point = new esri.geometry.Point(34554239.202,2726900.476,new esri.SpatialReference({wkid:2358}));
                        //34554239.202,2723900.476
                        // map.centerAt(point);
                    }
                }
                function rowbackcolor(index, row) {
                    if ($.trim(row.layerid)) {
                        return 'background-color:#CCFFFF;';
                    }
                }
            </script>
        </head>
        
        <body style="overflow:hidden">
            <div class="easyui-layout" style="width:100%;height:660px;" id="layoutDiv">
                <div data-options="region:'north',border:false" style="width:99; height:25px; padding:1px;border:1px solid #ddd;overflow:hidden">
                    <a id="queryLand" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'"
                    onclick="openQueryLand()">
                        查询土地
                    </a>
                    <a href="javascript:arcgisMap.navToolbar.zoomToFullExtent();" class="easyui-linkbutton"
                    data-options="plain:true,iconCls:'icon-globeLarge'">
                        全图范围
                    </a>
                    <a id="mesureArea" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'">
                        测算面积
                    </a>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <b>
                        展现方式：
                    </b>
                    <input type="radio" id="displaytype" name="displaytype" value="1" onclick="displayland(1)"
                    />
                    列表展现
                    <input type="radio" id="displaytype" name="displaytype" value="2" onclick="displayland(2)"
                    />
                    地图展现
                    <input type="radio" id="displaytype" name="displaytype" value="3" checked="checked"
                    onclick="displayland(3)" />
                    列表地图综合展现 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <font style="color: red;font-weight: bold;">
                        欠税红色、不欠绿色、未关联蓝色
                    </font>
                </div>
                <div id="centerdiv" data-options="region:'center'" style="width:100; height:625px;">
                    <div id="landinfodiv" style="width:37%; height:625px;float:left;">
                        <table id='landInfoTable' style="height:570px;width:100;overflow: hidden;">
                            <thead>
                                <tr>
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
                                    <th data-options="field:'holddate',width:120,align:'center',formatter:ArcgisMap.formatterDate,editor:{type:'validatebox'}">
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
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div id="mapdiv" style="width:63%; height:625px;float:right;">
                        <div id="map" style="width:100%;height:625px; border:0px solid #000;">
                        </div>
                    </div>
                </div>
            </div>
            <img id="loadingImg" src="/images/loading.gif" style="position:absolute; right:702px; top:256px; z-index:100;"
            />
            <div id="landquerydiv" class="easyui-window" data-options="closed:true,modal:true,title:'土地查询条件',collapsible:false,
            minimizable:false,maximizable:false,closable:true" style="width:640px;">
                <form id="queryform" method="post">
                    <table id="narjcxx" width="100%" cellpadding="3" cellspacing="0" border="1"
                    bordercolor="#FCD209" style="border-collapse:collapse">
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
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                    onclick="queryLand()">
                        查询
                    </a>
                </div>
            </div>
            <!-- 房产信息 ----------------------------------------------------------------------------------------------->
            <div id="landinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地相关信息',collapsible:false,
            minimizable:false,maximizable:false,closable:true,href:'viewland.jsp'" style="width:1050px;height:540px;">
            </div>
        </body>
        
        </html>
        <script>
        </script>
