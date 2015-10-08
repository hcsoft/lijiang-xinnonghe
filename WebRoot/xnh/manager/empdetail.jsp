<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"
    %>
        <!DOCTYPE html>
        <html>
            
            <head>
                <base target="_self" />
                <title>
                </title>
                <link rel="stylesheet" href="<%=request.getContextPath()%>/themes/sunny/easyui.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/themes/icon.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/css/toolbar.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/css/logout.css"
                />
                <script src="<%=request.getContextPath()%>/js/jquery-1.8.2.min.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/tiles.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/moduleWindow.js">
                </script>
                <script src="<%=request.getContextPath()%>/menus.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/overlay.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/jquery.json-2.2.js">
                </script>
                <script src="<%=request.getContextPath()%>/js/json2.js">
                </script>
                <script src="<%=request.getContextPath()%>/locale/easyui-lang-zh_CN.js">
                </script>
            </head>
            
            <body>
                <script>
				var myrole;
                    $(function() {
						 //alert(opttype);
                        $.ajax({
                            type: "post",
                            async: false,
                            url: "/ComboxService/gettaxorgtree.do",
                            dataType: "json",
                            success: function(jsondata) {
                                orgtree = jsondata;
								$('#cc').combotree({
									data: orgtree,
									valueField: 'id',
									textField: 'text'
								});
                            }
                        });
						
						//alert(opttype);
                        if (opttype == 'modify') {
                            var row = $('#empinfogrid').datagrid('getSelected');
                            $.ajax({
                                type: "post",
								async:false,
                                url: "<%=request.getContextPath()%>/Manager/getemp.do",
                                data: {
                                    taxempcode: row.taxempcode
                                },
                                //获取户主信息
                                dataType: "json",
                                success: function(jsondata) {
                                    $('#empform').form('load', jsondata);
									//$('input[name="taxorgcode"]').val(jsondata.taxorgcode);
									//var t = $('#cc').combotree('tree');
									//var node = $('#cc').tree('find', jsondata.taxorgcode);
									//$('#cc').tree('select',node );
									$('#cc').combotree('setValue', jsondata.taxorgcode);
									myrole = jsondata.roles;;
                                }
                            });
                        }
						$('#rolegrid').datagrid({
                            fitColumns: 'true',
                            maximized: 'true',
                            pagination: false,
							onLoadSuccess:function(data){                    
								if(data){
									$.each(data.rows, function(index, item){
										if(item.checked){
											$('#rolegrid').datagrid('checkRow', index);
										}
									});
								}
							}
                        });
                       
                        $.ajax({
                            type: "post",
                            async: false,
                            url: "/Manager/getrolelist.do",
                            dataType: "json",
                            success: function(jsondata) {
								if(opttype == 'modify' && myrole.length>0){
									for(var i = 0;i < jsondata.length;i++){
										 for(var j = 0;j < myrole.length;j++){
											 if( jsondata[i].role_id==myrole[j].role_id){
												 jsondata[i].checked=true;	
											 }
										 }
									}
								}
								$('#rolegrid').datagrid('loadData', jsondata);
                            }
                        });

                        
                        
                        
                    });
					
                    function save() {
						if(!$('#logincode').validatebox('isValid')){
							$.messager.alert('提示','登录ID不能为空！');
							return;
						}
						if(!$('#taxempname').validatebox('isValid')){
							$.messager.alert('提示','人员名称不能为空！');
							return;
						}
						if(!$('#password').validatebox('isValid')){
							$.messager.alert('提示','密码不能为空！');
							return;
						}
						var temp =$('#cc').combotree('getValue');
						if(temp==null || temp==''){
							$.messager.alert('提示','所属医疗机构不能为空！');
							return;
						}
						var data = {};
                        var params = {};
                        var fields = $('#empform').serializeArray();
                        $.each(fields,
                        function(i, field) {
                            params[field.name] = field.value;
                        });
						var checkedrows = $('#rolegrid').datagrid('getChecked');
						//var names = [];
						//$.each(checkedItems, function(index, item){
						//	names.push(item.role_id);
						//});
						data.userinfo = params;
						data.roles = checkedrows;
						//console.log($.toJSON(params));
                        $.ajax({
                            type: "post",
                            url: "/Manager/saveemp.do",
							contentType: "application/json; charset=utf-8",
                            data: $.toJSON(data),
                            dataType: "json",
                            success: function(jsondata) {
                                $.messager.alert('返回消息', jsondata.message);
								if(jsondata.sucess){
									query();
									$('#orgwindow').window('close');
								}
                            },
                            error: function(data, status, e) {
                                $.messager.alert('返回消息', "保存出错");
                            }
                        });
                    }
                </script>
                <form id="empform" method="post">
                    <div title="人员信息" data-options="" style="overflow:auto">
                        <table width="100%" class="table table-bordered">
                            <input id="taxempcode" type="hidden" name="taxempcode" />
                            <tr>
                                <td align="right">
                                    人员登录ID：
                                </td>
                                <td>
                                    <input class="easyui-validatebox" name="logincode" id="logincode" style="width:200px;"
                                    data-options="required:true" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    人员名称：
                                </td>
                                <td>
                                    <input class="easyui-validatebox" name="taxempname" id="taxempname" style="width:200px;"
                                    data-options="required:true" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    密码：
                                </td>
                                <td>
                                    <input class="easyui-validatebox"  name="password" id="password"
                                    style="width:200px;" data-options="required:true" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    所属医疗机构：
                                </td>
                                <td>
									<input id="cc" name="taxorgcode"/>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    人员属性：
                                </td>
                                <td>
                                    <input type="checkbox" name="normalflag" id="normalflag" value="01" />
                                    一般操作人员
                                    <input type="checkbox" name="doctorflag" id="doctorflag" value="01" />
                                    医生
                                    <input type="checkbox" name="nurseflag" id="nurseflag" value="01" />
                                    护士
                                    <input type="checkbox" name="publicdoctorflag" id="publicdoctorflag" value="01"
                                    />
                                    公卫医师
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    特殊权限：
                                </td>
                                <td>
                                    <input type="checkbox" name="authflag" id="authflag" value="01" />
                                    操作下级机关数据
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    有效标识：
                                </td>
                                <td>
                                    <select id="valid" class="easyui-combobox" name="valid" data-options="required:true"
                                    editable="false">
                                        <option value="01">有效</option>
                                        <option value="00">无效</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <div title="" style="overflow:auto" data-options="
                        tools:[{
                        handler:function(){
                        $('#rolegrid').datagrid('reload');
                        }
                        }]">
                            <table id="rolegrid" data-options="iconCls:'icon-edit',singleSelect:false"
                            rownumbers="true">
                                <thead>
                                    <tr>
                                        <th data-options="field:'role_id',checkbox:'true',width:80,align:'center'">
                                        </th>
                                        <th data-options="field:'role_code',width:120,align:'center',editor:{type:'text'}">
                                            角色
                                        </th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div style="text-align:center;padding:5px;height: 25px;">
                            <a id="btn2" class="easyui-linkbutton" icon="icon-save" onclick="save()">
                                保存
                            </a>
                        </div>
                    </div>
                </form>
            </body>
        
        </html>
