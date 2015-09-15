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
                <script>
                    String.prototype.trim = function() {
                        return this.replace(/(^\s*)|(\s*$)/g, '');
                    }
                    var locationdata = new Object; //所属乡镇缓存
                    var groundusedata = new Array(); //土地用途缓存
                    var businessdata = new Array();
                    var belongtocountry = new Array();
                    var belongtowns = new Array();
                    var opttype;
                    var businesstype;
                    var taxpayerid;
                    var taxpayername;
                    var landstoreid;
                    var landstoresubid;
                    var targetestateid;
                    var busid;
					var taxempdata = new Object;
                    var business = [{
                        code: '11',
                        name: '土地出让'
                    }];
                    var type;
                    var checkmenu = [{
                        text: '查询',
                        iconCls: 'icon-search',
                        handler: function() {
                            $('#groundcheckquerywindow').window('open');
                        }
                    },
                    {
                        text: '明细查看',
                        id: 'showdetail',
                        iconCls: 'icon-tip',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            if (row) {
                                if (row.bustype == '0') { //土地
                                    $('#groundwindow').window('open');
                                    $('#groundwindow').window('refresh', 'grounddetail.jsp');
                                }
                                if (row.bustype == '1') { //房产
                                    $('#housewindow').window('open');
                                    $('#housewindow').window('refresh', 'housedetail.jsp');
                                }
                            } else {
                                alert("请选择要查看明细的数据！");
                            }
                        }
                    },
                    {
                        text: '导出',
                        iconCls: 'icon-export',
                        handler: function() {
                            $.messager.confirm('提示', '是否确认导出?',
                            function(r) {
                                if (r) {
                                    var param = '';
                                    var fields = $('#groundcheckqueryform').serializeArray();
                                    $.each(fields,
                                    function(i, field) {
                                        if (field.value != '') {
                                            param = param + field.name + '=' + field.value + '&';
                                        }
                                    });
                                    window.open("/GroundCheckServlet/export.do?+'" + param + "'", '', 'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
                                }
                            });
                        }
                    },
                    {
                        text: '税源核实表打印（转出方）',
                        iconCls: 'icon-print',
                        id: 'printout',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            var ptinttaxpayerid;
                            if (row.lessorid.indexOf('T') >= 0) {
                                alert("转出方纳税人为临时纳税人，不能打印税源核实表！");
                                return;
                            }
                            if (row) {
                                $.messager.confirm('提示', '是否确认打印?',
                                function(r) {
                                    if (r) {
                                        var param = 'taxpayerid=' + row.lessorid + '&busid=' + row.busid + '&bustype=' + row.bustype;
                                        window.open('detailprint.jsp?' + param, window, 'dialogWidth=1100px,dialogHeight=600px,scrollbars=1');
                                        refreshBusgrid();
                                    }
                                })
                            } else {
                                alert("请选择需要打印的数据！");
                            }
                        }
                    },
                    {
                        text: '税源核实表打印（转入方）',
                        iconCls: 'icon-print',
                        id: 'printin',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            var ptinttaxpayerid;
                            if (row.lesseesid.indexOf('T') >= 0) {
                                alert("转入方纳税人为临时纳税人，不能打印税源核实表！");
                                return;
                            }
                            if (row) {
                                $.messager.confirm('提示', '是否确认打印?',
                                function(r) {
                                    if (r) {
                                        var param = 'taxpayerid=' + row.lesseesid + '&busid=' + row.busid + '&bustype=' + row.bustype;
                                        window.open('detailprint.jsp?' + param, window, 'dialogWidth=1100px,dialogHeight=600px,scrollbars=1');
                                        refreshBusgrid();
                                    }
                                })
                            } else {
                                alert("请选择需要打印的数据！");
                            }
                        }
                    },
                    {
                        text: '审核',
                        iconCls: 'icon-check',
                        id: 'check',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            var taxflag = '0';
                            if (row) {
                                $.messager.defaults = {
                                    ok: "确定",
                                    cancel: "取消"
                                };
                                        Load();
                                        if (row.bustype == '0') { //土地审核
                                                $.messager.defaults = {
                                                    ok: "是",
                                                    cancel: "否"
                                                };
                                                $.messager.confirm('提示框', '是否纳入征税范围?',
                                                function(r) {
                                                    if (r) {
                                                        taxflag = '1';
                                                    } else {
                                                        taxflag = '0';
                                                    }
                                                    $.ajax({
                                                        type: "post",
                                                        url: "/GroundCheckServlet/check.do",
                                                        data: {
                                                            busid: row.busid,
                                                            estateid: row.estateid,
                                                            landtaxflag: taxflag,
                                                            businesscode: row.businesscode,
                                                            parentbusinessnumber: row.parentbusinessnumber,
                                                            landstoresubid: row.landstoresubid
                                                        },
                                                        dataType: "json",
                                                        success: function(jsondata) {
                                                            //$.messager.alert('返回消息',"审核成功");
                                                            dispalyLoad();
                                                            if(!jsondata.state){
                                                            	$('#showdetail').click();
                                                            	$.messager.alert('提示', jsondata.message);
                                                            }else{
	                                                            $('#groundcheckgrid').datagrid('reload');
	                                                            refreshBusgrid();
	                                                            $('#groundcheckgrid').datagrid('unselectAll');
	                                                            
	                                                            $.messager.defaults = {
	                                                                ok: "确定",
	                                                                cancel: "取消"
	                                                            };
	                                                            $.messager.alert('提示', jsondata.message);
                                                            }
                                                        },
                                                        error: function(data, status, e) {
                                                            $.messager.defaults = {
                                                                ok: "确定",
                                                                cancel: "取消"
                                                            };
                                                            $.messager.alert('返回消息', "审核失败！");
                                                            dispalyLoad();
                                                        }
                                                    });
                                                });
                                        }
                                        if (row.bustype == '1') { //房产审核
                                            if (row.businesscode == '54') { //房产登记
                                                $.ajax({
                                                    type: "post",
                                                    url: "/houseregister/check.do",
                                                    data: {
                                                        key: row.estateid,
                                                        houseregistertype: row.housetype
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        if (jsondata.sucess == true) {
                                                            refreshBusgrid();
                                                            $.messager.alert('提示', '审核成功!');
                                                        } else {
                                                            $.messager.alert('返回消息', jsondata.result + "," + jsondata.message);
                                                        }
                                                        $('#groundcheckgrid').datagrid('reload');
                                                        $('#groundcheckgrid').datagrid('unselectAll');
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', "审核失败！");
                                                        dispalyLoad();
                                                    }
                                                });
                                            }
                                            if (row.businesscode == '53' || row.businesscode == '52' || row.businesscode == '64' || row.businesscode == '62' || row.businesscode == '63') { //非出租
                                                $.ajax({
                                                    type: "post",
                                                    url: "/houseowner/check.do?d=" + new Date(),
                                                    data: {
                                                        key: row.busid,
                                                        businesstype: row.businesscode
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        if (jsondata.sucess == true) {
                                                            refreshBusgrid();
                                                            $.messager.alert('提示', '审核成功!');
                                                        } else {
                                                            $.messager.alert('返回消息', jsondata.result + "," + jsondata.message);
                                                        }
                                                        $('#groundcheckgrid').datagrid('reload');
                                                        $('#groundcheckgrid').datagrid('unselectAll');
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', "审核失败！");
                                                        dispalyLoad();
                                                    }
                                                });
                                            }
                                            if (row.businesscode == '65') { //房产收回
                                                $.ajax({
                                                    type: "post",
                                                    url: "/houserecover/check.do?d=" + new Date(),
                                                    data: {
                                                        key: row.busid,
                                                        businesstype: row.businesscode
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        if (jsondata.sucess == true) {
                                                            refreshBusgrid();
                                                            $.messager.alert('提示', '审核成功!');
                                                        } else {
                                                            $.messager.alert('返回消息', jsondata.result + "," + jsondata.message);
                                                        }
                                                        $('#groundcheckgrid').datagrid('reload');
                                                        $('#groundcheckgrid').datagrid('unselectAll');
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', "审核失败！");
                                                        dispalyLoad();
                                                    }
                                                });
                                            }
                                            if (row.businesscode == '61') {
                                                $.ajax({
                                                    type: "post",
                                                    url: "/houseuse/check.do",
                                                    data: {
                                                        key: row.busid,
                                                        businesstype: row.businesscode
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        if (jsondata.sucess == true) {
                                                            refreshBusgrid();
                                                            $.messager.alert('返回消息', "审核成功");
                                                        } else {
                                                            $.messager.alert('返回消息', jsondata.result + "," + jsondata.message);
                                                        }
                                                        $('#groundcheckgrid').datagrid('reload');
                                                        $('#groundcheckgrid').datagrid('unselectAll');
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', "审核失败！");
                                                        dispalyLoad();
                                                    }
                                                });
                                            }
                                        }
                            } else {
                                alert("请选择需要审核的数据！");
                            }
                        }
                    },
                    {
                        text: '撤销审核',
                        id: 'uncheck',
                        iconCls: 'icon-uncheck',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            if (row) {
                                        Load();
                                        if (row.bustype == '0') { //土地审核
                                            $.ajax({
                                                type: "post",
                                                url: "/GroundCheckServlet/uncheck.do",
                                                data: {
                                                    busid: row.busid,
                                                    estateid: row.estateid,
                                                    businesscode: row.businesscode,
                                                    businessnumber: row.businessnumber,
                                                    parentbusinessnumber: row.parentbusinessnumber,
                                                    landstoresubid: row.landstoresubid
                                                },
                                                dataType: "json",
                                                success: function(jsondata) {
                                                    $.messager.alert('返回消息', jsondata);
                                                    $('#groundcheckgrid').datagrid('reload');
                                                    $('#groundcheckgrid').datagrid('unselectAll');
                                                    refreshBusgrid();
                                                    dispalyLoad();
                                                },
                                                error: function(data, status, e) {
                                                    $.messager.alert('返回消息', "撤销审核失败！");
                                                    dispalyLoad();
                                                }
                                            });
                                        }
                                        if (row.bustype == '1') { //房产审核
                                            if (row.businesscode == '54') { //房产登记
                                                $.ajax({
                                                    type: "post",
                                                    url: "/houseregister/uncheck.do",
                                                    data: {
                                                        key: row.estateid,
                                                        houseregistertype: row.housetype
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        $.messager.alert('返回消息', "撤销审核成功");
                                                        $('#groundcheckgrid').datagrid('reload');
                                                        $('#groundcheckgrid').datagrid('unselectAll');
                                                        refreshBusgrid();
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', "撤销审核失败！");
                                                        dispalyLoad();
                                                    }
                                                });
                                            }
                                            if (row.businesscode == '53' || row.businesscode == '52' || row.businesscode == '64' || row.businesscode == '62' || row.businesscode == '63') { //非出租
                                                $.ajax({
                                                    type: "post",
                                                    url: "/houseowner/uncheck.do?d=" + new Date(),
                                                    data: {
                                                        key: row.busid,
                                                        businesstype: row.businesscode
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        $.messager.alert('返回消息', "撤销审核成功");
                                                        $('#groundcheckgrid').datagrid('reload');
                                                        $('#groundcheckgrid').datagrid('unselectAll');
                                                        refreshBusgrid();
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', "撤销审核失败！");
                                                        dispalyLoad();
                                                    }
                                                });
                                            }
                                            if (row.businesscode == '65') { //房产收回
                                                $.ajax({
                                                    type: "post",
                                                    url: "/houserecover/uncheck.do?d=" + new Date(),
                                                    data: {
                                                        key: row.busid,
                                                        businesstype: row.businesscode
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        $.messager.alert('返回消息', "撤销审核成功");
                                                        $('#groundcheckgrid').datagrid('reload');
                                                        $('#groundcheckgrid').datagrid('unselectAll');
                                                        refreshBusgrid();
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', "撤销审核失败！");
                                                        dispalyLoad();
                                                    }
                                                });
                                            }
                                            if (row.businesscode == '61') {
                                                $.ajax({
                                                    type: "post",
                                                    url: "/houseuse/uncheck.do?d=" + new Date(),
                                                    data: {
                                                        key: row.busid,
                                                        businesstype: row.businesscode
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        $.messager.alert('返回消息', "撤销审核成功");
                                                        $('#groundcheckgrid').datagrid('reload');
                                                        $('#groundcheckgrid').datagrid('unselectAll');
                                                        refreshBusgrid();
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', "撤销审核失败！");
                                                        dispalyLoad();
                                                    }
                                                });
                                            }
                                        }
                            } else {
                                alert("请选择需要取消审核的数据！");
                            }
                        }
                    }];
                    var finalcheckmenu = [{
                        text: '查询',
                        iconCls: 'icon-search',
                        handler: function() {
                            $('#groundcheckquerywindow').window('open');
                        }
                    },
                    {
                        text: '明细查看',
                        iconCls: 'icon-tip',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            if (row) {
                                if (row.bustype == '0') { //土地
                                    $('#groundwindow').window('open');
                                    $('#groundwindow').window('refresh', 'grounddetail.jsp');
                                }
                                if (row.bustype == '1') { //房产
                                    $('#housewindow').window('open');
                                    $('#housewindow').window('refresh', 'housedetail.jsp');
                                }
                            } else {
                                alert("请选择要查看明细的数据！");
                            }
                        }
                    },
                    {
                        text: '导出',
                        iconCls: 'icon-export',
                        handler: function() {
                            $.messager.confirm('提示', '是否确认导出?',
                            function(r) {
                                if (r) {
                                    var param = '';
                                    var fields = $('#groundcheckqueryform').serializeArray();
                                    $.each(fields,
                                    function(i, field) {
                                        if (field.value != '') {
                                            param = param + field.name + '=' + field.value + '&';
                                        }
                                    });
                                    window.open("/GroundCheckServlet/export.do?+'" + param + "'", '', 'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
                                }
                            });
                        }
                    },
                    {
                        text: '终审',
                        iconCls: 'icon-check',
                        id: 'finalcheck',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            var taxflag = '0';
                            if (row) {
                                $.messager.defaults = {
                                    ok: "确定",
                                    cancel: "取消"
                                };
                                        Load();
                                        if (row.bustype == '0') { //土地终审
                                                $.ajax({
                                                    type: "post",
                                                    url: "/GroundUserightServlet/finalCheckGroundBusi.do",
                                                    data: {
                                                        busid: row.busid,
                                                        estateid: row.estateid,
                                                        businesscode: row.businesscode
                                                    },
                                                    dataType: "json",
                                                    success: function(jsondata) {
                                                        $.messager.alert('返回消息', jsondata);
                                                        refreshBusgrid();
                                                        dispalyLoad();
                                                    },
                                                    error: function(data, status, e) {
                                                        $.messager.alert('返回消息', '终审失败!');
                                                        dispalyLoad();
                                                    }
                                                });
                                        }
                                        if (row.bustype == '1') { //房产终审
                                            var url = "";
                                            if (row.businesscode == '54') {
                                                url = "/houseregister/finalcheck.do";
												row.busid = row.estateid;
                                            } else if (row.businesscode == '61' || row.businesscode == '62' || row.businesscode == '63') { //出租 融资租赁 出典
                                                url = "/houseuse/finalcheck.do";
                                            } else {
                                                url = "/houseowner/finalcheck.do";
                                            }
                                            $.ajax({
                                                type: "post",
                                                async: true,
                                                url: url,
                                                data: {
                                                    'key': row.busid,
                                                    "businesstype": row.businesscode
                                                },
                                                dataType: "json",
                                                success: function(jsondata) {
                                                    dispalyLoad();
                                                    if (jsondata.sucess) {
                                                        $.messager.alert('提示消息', jsondata.message, 'info',
                                                        function() {
                                                            refreshBusgrid();
                                                        });
                                                    } else {
                                                        $.messager.alert('错误', jsondata.message, 'error',
                                                        function() {});
                                                    }
                                                }
                                            });

                                        }
                            } else {
                                alert("请选择需要终审的数据！");
                            }
                        }
                    },
                    {
                        text: '撤销终审',
                        id: 'unfinalcheck',
                        iconCls: 'icon-uncheck',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            if (row) {
                                        Load();
                                        if (row.bustype == '0') { //土地
                                            $.ajax({
                                                type: "post",
                                                url: "/GroundUserightServlet/unfinalcheck.do",
                                                data: {
													estateid:row.estateid,
													busid:row.busid,
													businesscode : row.businesscode
												},
                                                dataType: "json",
                                                success: function(jsondata) {
                                                    $.messager.alert('返回消息', jsondata);
                                                    refreshBusgrid();
                                                    dispalyLoad();
                                                },
                                                error: function(data, status, e) {
                                                    dispalyLoad();
                                                    $.messager.alert('返回消息', '撤销终审失败!');
                                                }
                                            });

                                        }
                                        if (row.bustype == '1') { //房产
                                            var url = "";
                                            if (row.businesscode == '54') {
                                                url = "/houseregister/unfinalcheck.do";
												row.busid = row.estateid;
                                            } else if (row.businesscode == '61' || row.businesscode == '62' || row.businesscode == '63') { //出租 融资租赁 出典
                                                url = "/houseuse/unfinalcheck.do";
                                            } else {
                                                url = "/houseowner/unfinalcheck.do";
                                            }
                                            $.ajax({
                                                type: "post",
                                                async: true,
                                                url: url,
                                                data: {
                                                    'key': row.busid,
                                                    "businesstype": row.businesscode
                                                },
                                                dataType: "json",
                                                success: function(jsondata) {
                                                    dispalyLoad();
                                                    if (jsondata.sucess) {
                                                        $.messager.alert('提示消息', jsondata.message, 'info',
                                                        function() {
                                                            refreshBusgrid();
                                                        });
                                                    } else {
                                                        $.messager.alert('错误', jsondata.message, 'error',
                                                        function() {});
                                                    }
                                                }
                                            });
                                        }
                            } else {
                                alert("请选择需要撤销终审的数据！");
                            }
                        }
                    }];
                    var querymenu = [{
                        text: '查询',
                        iconCls: 'icon-search',
                        handler: function() {
                            $('#groundcheckquerywindow').window('open');
                        }
                    },
                    {
                        text: '明细查看',
                        iconCls: 'icon-tip',
                        handler: function() {
                            var row = $('#groundcheckgrid').datagrid('getSelected');
                            if (row) {
                                if (row.bustype == '0') { //土地
                                    $('#groundwindow').window('open');
                                    $('#groundwindow').window('refresh', 'grounddetail.jsp');
                                }
                                if (row.bustype == '1') { //房产
                                    $('#housewindow').window('open');
                                    $('#housewindow').window('refresh', 'housedetail.jsp');
                                }
                            } else {
                                alert("请选择要查看明细的数据！");
                            }
                        }
                    },
                    {
                        text: '导出',
                        iconCls: 'icon-export',
                        handler: function() {
                            $.messager.confirm('提示', '是否确认导出?',
                            function(r) {
                                if (r) {
                                    var param = '';
                                    var fields = $('#groundcheckqueryform').serializeArray();
                                    $.each(fields,
                                    function(i, field) {
                                        if (field.value != '') {
                                            param = param + field.name + '=' + field.value + '&';
                                        }
                                    });
                                    window.open("/GroundCheckServlet/export.do?+'" + param + "'", '', 'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
                                }
                            });
                        }
                    }];
                    $(function() {
                        //取得url参数
                        var paraString = location.search;
                        var paras = paraString.split("&");
                        type = paras[0].substr(paras[0].indexOf("=") + 1);
                        $.ajax({
                            type: "post",
                            async: false,
                            url: "/ComboxService/getComboxs.do",
                            data: {
                                codetablename: 'COD_GROUNDUSECODE'
                            },
                            dataType: "json",
                            success: function(jsondata) {
                                //alert(JSON.stringify(jsondata));
                                groundusedata = jsondata;
                            }
                        });
						$.ajax({
						   type: "post",
							async:false,
						   url: "/ComboxService/getComboxs.do",
						   data: {codetablename:'COD_TAXEMPCODE'},
						   dataType: "json",
						   success: function(jsondata){
							  taxempdata= jsondata;
						   }
						});
                        $.ajax({
                            type: "post",
                            async: false,
                            url: "/InitGroundServlet/getlocationComboxs.do",
                            data: {
                                codetablename: 'COD_BELONGTOCOUNTRYCODE'
                            },
                            dataType: "json",
                            success: function(jsondata) {
                                //alert(JSON.stringify(jsondata));
                                locationdata = jsondata;
                                for (var i = 0; i < jsondata.length; i++) {
                                    if (jsondata[i].key.length == 9) {
                                        var newdetail = {};
                                        newdetail.key = jsondata[i].key;
                                        newdetail.value = jsondata[i].value;
                                        belongtocountry.push(newdetail);
                                    }
                                    if (jsondata[i].key.length == 12) {
                                        var newdetail = {};
                                        newdetail.key = jsondata[i].key;
                                        newdetail.value = jsondata[i].value;
                                        belongtowns.push(newdetail);
                                    }
                                }
                            }
                        });
                        var regex = new RegExp("\"", "g");
                        $.ajax({
                            type: "get",
                            url: "/soption/taxOrgOptionInit.do",
                            data: {
                                "moduleAuth": "15",
                                "emptype": "30"
                            },
                            dataType: "json",
                            success: function(jsondata) {
                                $('#querytaxorgsupcode').combobox({
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
                                                $('#querytaxorgcode').combobox({
                                                    data: jsondata.taxOrgOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                $('#querytaxdeptcode').combobox({
                                                    data: jsondata.taxDeptOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                $('#querytaxmanagercode').combobox({
                                                    data: jsondata.taxEmpOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                //$('#querytaxdeptcode').combobox("clear");
                                                //$('#taxempcode').combobox("clear");

                                                //$('#querytaxdeptcode').combobox({}).combobox('clear');
                                            }
                                        });
                                    }
                                });
                                if (jsondata.taxSupOrgOptionJsonArray.length == 1) {
                                    //alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
                                    $('#querytaxorgsupcode').combobox("setValue", JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
                                    $('#querytaxorgsupcode').combobox("setText", JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
                                }

                                $('#querytaxorgcode').combobox({
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
                                                $('#querytaxdeptcode').combobox({
                                                    data: jsondata.taxDeptOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                $('#querytaxmanagercode').combobox({
                                                    data: jsondata.taxEmpOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                //$('#querytaxdeptcode').combobox("clear");
                                                //$('#taxempcode').combobox("clear");

                                                //$('#querytaxdeptcode').combobox({}).combobox('clear');
                                            }
                                        });
                                    }
                                });
                                if (jsondata.taxOrgOptionJsonArray.length == 1) {
                                    //alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
                                    $('#querytaxorgcode').combobox("setValue", JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
                                    $('#querytaxorgcode').combobox("setText", JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
                                }

                                $('#querytaxdeptcode').combobox({
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
                                                $('#querytaxmanagercode').combobox({
                                                    data: jsondata.taxEmpOptionJsonArray,
                                                    valueField: 'key',
                                                    textField: 'keyvalue'
                                                });
                                                //$('#querytaxdeptcode').combobox("clear");
                                                //$('#taxempcode').combobox("clear");

                                                //$('#querytaxdeptcode').combobox({}).combobox('clear');
                                            }
                                        });
                                    }
                                });
                                if (jsondata.taxDeptOptionJsonArray.length == 1) {
                                    //alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
                                    $('#querytaxdeptcode').combobox("setValue", JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
                                    $('#querytaxdeptcode').combobox("setText", JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
                                }

                                $('#querytaxmanagercode').combobox({
                                    data: jsondata.taxEmpOptionJsonArray,
                                    valueField: 'key',
                                    textField: 'keyvalue'
                                });
                                //分局登录 默认选中
                                var orgclass = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getUserTaxOrgVO().getOrgclass()%>';
                                var taxdeptcode = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
                                var taxempcode = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
                                if (orgclass == '04') {
                                    $('#querytaxdeptcode').combobox("setValue", taxdeptcode);
                                    $('#querytaxmanagercode').combobox("setValue", taxempcode);
                                }
                                if(type=='finalcheck'){
                                	$('#queryoptempcode').val(taxempcode);
                                }
                                //setTimeout("query()", 100); //税收管理员才查询
                                refreshBusgrid();
                            }
                        });
                        $('#groundcheckgrid').datagrid({
                            //fitColumns:'true',
                            maximized: 'true',
                            pagination: true,
                            idField: 'busid',
                            view: $.extend({},
                            $.fn.datagrid.defaults.view, {
                                onAfterRender: function(target) {
                                    $('#groundcheckgrid').datagrid('clearSelections');
                                }
                            }),
                            //toolbar:,
                            onClickRow: function(index) {
                                var row = $('#groundcheckgrid').datagrid('getSelected');
                                $('#edit').linkbutton('enable');
                                $('#cancel').linkbutton('enable');
                                $('#check').linkbutton('enable');
                                $('#uncheck').linkbutton('enable');
                                $('#finalcheck').linkbutton('enable');
                                $('#unfinalcheck').linkbutton('enable');
                                $('#printout').linkbutton('enable');
                                $('#printin').linkbutton('enable');
                                if (row.state == '0') {
                                    $('#uncheck').linkbutton('disable');
                                    $('#printout').linkbutton('disable');
                                    $('#printin').linkbutton('disable');
                                    $('#finalcheck').linkbutton('disable');
                                    $('#unfinalcheck').linkbutton('disable');
                                }
                                if (row.state == '1') {
                                    $('#edit').linkbutton('disable');
                                    $('#cancel').linkbutton('disable');
                                    $('#check').linkbutton('disable');
                                    $('#unfinalcheck').linkbutton('disable');
                                    if (row.lessorid == null || row.lessorid.indexOf('5301') != 0) {
                                        $('#printout').linkbutton('disable');
                                    }
                                    if (row.lesseesid == null || row.lesseesid.indexOf('5301') != 0 || row.businesscode == '61') {
                                        $('#printin').linkbutton('disable');
                                    }
                                }
                                if (row.state == '3') {
                                    $('#edit').linkbutton('disable');
                                    $('#cancel').linkbutton('disable');
                                    $('#check').linkbutton('disable');
                                    $('#uncheck').linkbutton('disable');
                                    $('#finalcheck').linkbutton('disable');
                                    $('#printout').linkbutton('disable');
                                    $('#printin').linkbutton('disable');
                                }
                                if (row.state == '2' || row.state == '9') {
                                    $('#edit').linkbutton('disable');
                                    $('#cancel').linkbutton('disable');
                                    $('#check').linkbutton('disable');
                                    $('#uncheck').linkbutton('disable');
                                    $('#printout').linkbutton('disable');
                                    $('#printin').linkbutton('disable');
                                    $('#finalcheck').linkbutton('disable');
                                    $('#unfinalcheck').linkbutton('disable');
                                }
                            }
                        });
                        if (type == 'check') {
                            $('#groundcheckgrid').datagrid("removeToolbarItem", 0);
							//$("#state").find("option[value='0']").attr("selected","selected");
							$("#state").combobox('setValues','0');
                            $('#groundcheckgrid').datagrid("addToolbarItem", checkmenu);
                        } else if (type == 'finalcheck') {
                            $('#groundcheckgrid').datagrid("removeToolbarItem", 0);
							//$("#state").find("option[value='1']").attr("selected","selected");
							$("#state").combobox('setValues','1');
                            $('#groundcheckgrid').datagrid("addToolbarItem", finalcheckmenu);
                        } else {
                            $('#groundcheckgrid').datagrid("removeToolbarItem", 0);
                            $('#groundcheckgrid').datagrid("addToolbarItem", querymenu);
                        }
                        var p = $('#groundcheckgrid').datagrid('getPager');
                        $(p).pagination({
                            showPageList: false
                        });

                        $.extend($.fn.datagrid.defaults.editors, {
                            uploadfile: {
                                init: function(container, options) {
                                    var editorContainer = $('<div/>');
                                    var button = $("<a href='javascript:void(0)'></a>").linkbutton({
                                        plain: true,
                                        iconCls: "icon-remove"
                                    });
                                    editorContainer.append(button);
                                    editorContainer.appendTo(container);
                                    return button;
                                },
                                getValue: function(target) {
                                    return $(target).text();
                                },
                                setValue: function(target, value) {
                                    $(target).text(value);
                                },
                                resize: function(target, width) {
                                    var span = $(target);
                                    if ($.boxModel == true) {
                                        span.width(width - (span.outerWidth() - span.width()) - 10);
                                    } else {
                                        span.width(width - 10);
                                    }
                                }
                            }
                        });
                        $('#businessgrid').datagrid({
                            fitColumns: false,
                            onClickRow: query,
                            onCheck: query,
                            onUncheck: query,
                            onCheckAll: query,
                            onUncheckAll: query
                        });
						
                    });

                    function refreshBusgrid() {
                        var params = {};
                        var fields = $('#groundcheckqueryform').serializeArray();
                        $.each(fields,
                        function(i, field) {
                            params[field.name] = field.value;
                        });
						if(type == 'check'){
							params.state = '0';
						}
						if(type == 'finalcheck'){
							params.state = '1';
						}
                        //alert(JSON.stringify(params));
                        $.ajax({
                            type: "post",
                            async: false,
                            url: "/GroundCheckServlet/getbusinessinfo.do",
                            data: params,
                            dataType: "json",
                            success: function(jsondata) {
                                businessdata = jsondata;
								query();
                            }
                        });
                        $('#businessgrid').datagrid('loadData', businessdata);
                    }
                    function query() {
                        var params = {};
                        var fields = $('#groundcheckqueryform').serializeArray();
                        $.each(fields,
                        function(i, field) {
                            params[field.name] = field.value;
                        });
                        var businesscode = "";
                        var rows = $('#businessgrid').datagrid('getChecked');
                        if (rows.length > 0) {
                            for (var i = 0; i < rows.length; i++) {
                                businesscode = businesscode + "'" + rows[i].businesscode + "',";
                            }
                        }
                        businesscode = businesscode.substring(0, businesscode.length - 1);
                        params.businesscode = businesscode;
                        $('#groundcheckgrid').datagrid('loadData', {
                            total: 0,
                            rows: []
                        });
                        var opts = $('#groundcheckgrid').datagrid('options');
                        opts.url = '/GroundCheckServlet/getgroundbusinessinfo.do';
                        $('#groundcheckgrid').datagrid('load', params);
                        var p = $('#groundcheckgrid').datagrid('getPager');
                        $(p).pagination({
                            showPageList: false,
                            pageSize: 15
                        });
                        $('#groundcheckgrid').datagrid('unselectAll');
                        $('#groundcheckquerywindow').window('close');

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
                </script>
            </head>
            
            <body>
                <div class="easyui-layout" style="width:100%;height:550px;">
                    <form id="groundstorageform" method="post">
                        <div data-options="region:'west'" id="mainWestDiv" style="height:550px;width:200px;overflow: hidden;">
                            <table id='businessgrid'  style="height:550px;width:200px;overflow: hidden;"
                            data-options="iconCls:'icon-edit',rowStyler:function(x,x){
                            return 'background-color:#fff;';
                            }">
                                <thead>
                                    <tr>
                                        <th data-options="field:'checked',width:50,align:'center',checkbox:true,editor:{type:'checkbox'}">
                                        </th>
                                        <th data-options="field:'businesscode',hidden:true,width:0,align:'center',editor:{type:'validatebox'}">
                                            主键
                                        </th>
                                        <th data-options="field:'businessname',width:125,align:'center',styler: function(value,row,index){
                                        if (row.buscount >0){
                                        return 'background-color:red;';
                                        }
                                        },editor:{type:'validatebox'}">
                                            业务类型
                                        </th>
                                        <th data-options="field:'buscount',width:40,align:'center',styler: function(value,row,index){
                                        if (value >0){
                                        return 'background-color:red;';
                                        }
                                        },editor:{type:'validatebox'}">
                                            待处理记录数
                                        </th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div title="" data-options="region:'center',
                        tools:[{
                        handler:function(){
                        $('#groundcheckgrid').datagrid('reload');
                        }
                        }]">
                            <table id="groundcheckgrid" style="overflow:visible;height:540px;" data-options="iconCls:'icon-edit',singleSelect:true"
                            rownumbers="true">
                                <thead>
                                    <tr>
                                        <!-- <th data-options="checkbox:true"></th> -->
                                        <th data-options="field:'busid',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                        <th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                        <!-- <th data-options="field:' ',width:180,align:'center',editor:{type:'text'}">
                                        </th> -->
                                        <th data-options="field:'estatestate',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                        <th data-options="field:'businesscode',width:100,align:'center',formatter:formatbusiness,editor:{type:'text'}">
                                            业务类型
                                        </th>
                                        <th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">
                                            附件管理
                                        </th>
                                        <th data-options="field:'state',width:100,align:'center',formatter:function(value,row,index){
                                        return value=='0' ? '未审核': (value == '1' || value == '2' ? '已审核' : (value == '3' ? '已终审' :'作废'));
                                        },editor:{type:'validatebox'}">
                                            状态
                                        </th>
                                        <th data-options="field:'printcount',width:100,align:'center',formatter:function(value,row,index){
                                        return value>=0 ? value: '0';
                                        },editor:{type:'validatebox'}">
                                            打印次数
                                        </th>
                                        <th data-options="field:'lessorid',width:100,align:'left',editor:{type:'validatebox'}">
                                            转出方计算机编码
                                        </th>
                                        <th data-options="field:'lessortaxpayername',width:280,align:'left',editor:{type:'validatebox'}">
                                            转出方名称
                                        </th>
                                        <th data-options="field:'lesseesid',width:100,align:'left',editor:{type:'validatebox'}">
                                            转入方计算机编码
                                        </th>
                                        <th data-options="field:'lesseestaxpayername',width:280,align:'left',editor:{type:'validatebox'}">
                                            转入方名称
                                        </th>
                                        <th data-options="field:'purpose',width:50,formatter:formatgrounduse,align:'left',editor:{type:'validatebox'}">
                                            用途
                                        </th>
                                        <th data-options="field:'protocolnumber',width:60,align:'left',editor:{type:'validatebox'}">
                                            协议书号
                                        </th>
                                        <th data-options="field:'holddates',width:100,align:'center',editor:{type:'validatebox'}">
                                            实际转移时间
                                        </th>
                                        <th data-options="field:'landarea',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">
                                            面积
                                        </th>
                                        <th data-options="field:'landamount',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">
                                            转出总价(年租金)
                                        </th>
                                        <th data-options="field:'limitbegins',width:100,align:'center',editor:{type:'validatebox'}">
                                            转出起时间
                                        </th>
                                        <th data-options="field:'limitends',width:100,align:'center',editor:{type:'validatebox'}">
                                            转出止时间
                                        </th>
										<th data-options="field:'optempcode',width:100,align:'center',formatter:function(value,row,index){
											for(var i=0; i<taxempdata.length; i++){
												if (taxempdata[i].key == value) return taxempdata[i].value;
											}
											return value;
										},editor:{type:'validatebox'}">
                                            采集人员
                                        </th>
                                        <!-- <th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th> -->
                                        <th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                        <th data-options="field:'parentbusinessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                        <th data-options="field:'targetestateid',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                        <th data-options="field:'landstoresubid',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                        <th data-options="field:'housetype',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                        <th data-options="field:'taxflag',width:180,align:'center',hidden:true,editor:{type:'text'}">
                                        </th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </form>
                </div>
                <div id="groundcheckquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地、房产业务查询',collapsible:false,minimizable:false,maximizable:false,closable:true"
                style="width:940px;height:300px;">
                    <div class="easyui-panel" title="" style="width:900px;">
                        <form id="groundcheckqueryform" method="post">
                            <table id="narjcxx" width="100%" class="table table-bordered">
                            	<input type="hidden" name="queryoptempcode" id="queryoptempcode"/>
                                <!-- <input type="hidden" name="businesscode" id="businesscode"/>
                                -->
                                <!-- <tr>
                                <td align="right">转出方计算机编码：</td>
                                <td>
                                <input id="querylessorid" class="easyui-validatebox" type="text" style="width:200px" name="querylessorid"/>
                                </td>
                                <td align="right">转出方名称：</td>
                                <td>
                                <input id="querylessortaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querylessortaxpayername"/>
                                </td>
                                </tr> -->
                                <tr>
                                    <td align="right">
                                        计算机编码：
                                    </td>
                                    <td>
                                        <input id="querylesseesid" class="easyui-validatebox" type="text" style="width:250px"
                                        name="querylesseesid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"
                                        />
                                    </td>
                                    <td align="right">
                                        纳税人名称：
                                    </td>
                                    <td>
                                        <input id="querylesseestaxpayername" class="easyui-validatebox" type="text"
                                        style="width:250px" name="querylesseestaxpayername" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        州市地税机关：
                                    </td>
                                    <td>
                                        <input class="easyui-combobox" name="querytaxorgsupcode" style="width:250px"
                                        id="querytaxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200,editable:false"
                                        />
                                    </td>
                                    <td align="right">
                                        县区地税机关：
                                    </td>
                                    <td>
                                        <input class="easyui-combobox" name="querytaxorgcode" style="width:250px"
                                        id="querytaxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200,editable:false"
                                        />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        主管地税部门：
                                    </td>
                                    <td>
                                        <input class="easyui-combobox" name="querytaxdeptcode" style="width:250px"
                                        id="querytaxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200,editable:false"
                                        />
                                    </td>
                                    <td align="right">
                                        税收管理员：
                                    </td>
                                    <td>
                                        <input class="easyui-combobox" name="querytaxmanagercode" style="width:250px"
                                        id="querytaxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200,editable:false"
                                        />
                                    </td>
                                </tr>
                                <!-- <tr>
                                <td align="right">宗地编号：</td>
                                <td>
                                <input id="queryestateserialno" class="easyui-validatebox" type="text" style="width:200px" name="queryestateserialno"/>
                                </td>
                                <td align="right">坐落详细地址：</td>
                                <td>
                                <input id="querydetailaddress" class="easyui-validatebox" type="text" style="width:200px" name="querydetailaddress"/>
                                </td>
                                </tr> -->
                                <tr>
                                    <td align="right">
                                        状态：
                                    </td>
                                    <td>
										<input class="easyui-combobox" name="state" id="state" data-options="
										valueField: 'value',
										textField: 'label',
										data: [{
											label: '全部',
											value: ''
										},{
											label: '未审核',
											value: '0'
										},{
											label: '已审核',
											value: '1'
										},{
											label: '已终审',
											value: '3'
										}]" />


                                        <!-- <select id="state" class="easyui-combobox" name="state" editable="false">
                                            <option value="">全部</option>
                                            <option value="0">未审核</option>
                                            <option value="1">已审核</option>
                                            <option value="3">已终审</option>
                                        </select> -->
                                    </td>
                                    <td align="right">
                                        是否打印：
                                    </td>
                                    <td>
										<input class="easyui-combobox" name="printcount" id="printcount" data-options="
										valueField: 'value',
										textField: 'label',
										data: [{
											label: '全部',
											value: ''
										},{
											label: '未打印',
											value: '0'
										},{
											label: '未打印',
											value: '1'
										}]" />
                                        <!-- <select id="printcount" class="easyui-combobox" name="printcount" editable="false">
                                            <option value="" selected>全部</option>
                                            <option value="0">未打印</option>
                                            <option value="1">已打印</option>
                                        </select> -->
                                    </td>
                                    <!-- <td align="right">业务类型：</td>
                                    <td>
                                    <select id="businesscode" class="easyui-combobox" style="width:200px" name="businesscode" editable="false">
                                    <option value="">全部</option>
                                    <option value="01">土地收储</option>
                                    <option value="11">土地出让</option>
                                    <option value="12">土地划拨</option>
                                    <option value="13">未批先占</option>
                                    <option value="21">土地转让</option>
                                    <option value="22">土地投资联营</option>
                                    <option value="23">土地捐赠</option>
                                    <option value="26">土地划转</option>
                                    <option value="24">土地融资租赁</option>
                                    <option value="25">土地出典</option>
                                    <option value="31">土地出租</option>
                                    </select>
                                    </td> -->
                                </tr>
                                <!-- <tr>
                                <td align="right">实际转移时间：</td>
                                <td colspan="3">
                                <input id="queryholddatebegin" class="easyui-datebox" style="width:200px" name="queryholddatebegin"/>
                                至
                                <input id="queryholddateend" class="easyui-datebox"  style="width:200px" name="queryholddateend"/>
                                </td>
                                </tr> -->
                                <tr>
                                    <td align="right">
                                        采集时间：
                                    </td>
                                    <td colspan="3">
                                        <input id="optdatebegin" class="easyui-datebox" style="width:200px" name="optdatebegin"
                                        />
                                        至
                                        <input id="optdateend" class="easyui-datebox" style="width:200px" name="optdateend"
                                        />
                                    </td>
                                </tr>
                            </table>
                        </form>
                        <div style="text-align:center;padding:5px;">
                            <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" href="###" onclick="query()">
                                查询
                            </a>
                            <!-- <a class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'">查询</a> -->
                        </div>
                    </div>
                </div>
                <!-- <div id="groundstorageeditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true"
                style="width:940px;height:300px;">
                <div class="easyui-panel" title="" style="width:900px;">
                <form id="groundstorageeditform" method="post">
                <table id="narjcxx" width="100%" class="table table-bordered">
                <input id="ownerid"  type="hidden" name="ownerid"/>	
                <tr>
                <td align="right">批复类型：</td>
                <td>
                <input class="easyui-combobox" name="approvetype" id="approvetype" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
                </td>
                <td align="right">批复名称：</td>
                <td>
                <input class="easyui-validatebox" name="name" id="name"/>					
                </td>
                </tr>
                <tr>
                <td align="right">厅级批准文号：</td>
                <td><input id="approvenumber" class="easyui-validatebox" type="text" name="approvenumber"/></td>
                <td align="right">市级批准文号：</td>
                <td>
                <input id="approvenumbercity" class="easyui-validatebox" type="text" name="approvenumbercity"/>
                </td>
                </tr>
                <tr>
                <td align="right">纳税人计算机编码：</td>
                <td>
                <input class="easyui-validatebox" name="taxpayer" id="taxpayer"/>					
                </td>
                <td align="right">纳税人计算机名称：</td>
                <td>
                <input class="easyui-validatebox" name="taxpayername" id="taxpayername"/>					
                </td>
                </tr>
                <tr>
                <td align="right">批复日期：</td>
                <td colspan="3">
                <input id="approvedates" class="easyui-datebox" name="approvedates"/>
                </td>
                </tr>
                </table>
                </form>
                <div style="text-align:center;padding:5px;">
                <a  class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="quereyreg()">税务登记查询</a>
                <a  class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
                </div>
                </div>
                </div> -->
                <!-- <div id="groundstoragedetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复明细',collapsible:false,minimizable:false,maximizable:false,closable:false"
                style="width:800px;height:400px;">
                <table id="groundstoragedetailgrid"></table>
                </div> -->
                <!-- <div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true"
                style="width:620px;height:470px;">
                </div> -->
                <div id="groundbusinesswindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地业务',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false"
                style="width:960px;height:500px;">
                </div>
                <!-- <div id="groundstorageaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true"
                style="width:940px;height:200px;">
                </div> -->
                <div id="groundwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地业务信息',collapsible:false,minimizable:false,maximizable:false,closable:true"
                style="width:940px;height:500px;">
                </div>
                <div id="housewindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产业务信息',collapsible:false,minimizable:false,maximizable:false,closable:true"
                style="width:940px;height:500px;">
                </div>
            </body>
        
        </html>
