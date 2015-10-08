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
                         var row = $('#noticeinfogrid').datagrid('getSelected');
						$.ajax({
							type: "post",
							async:false,
							url: "<%=request.getContextPath()%>/Manager/readnotice.do",
							data: {
								id: row.id
							},
							//获取户主信息
							dataType: "json",
							success: function(jsondata) {
								$('#noticeform').form('load', jsondata);
								//$('input[name="taxorgcode"]').val(jsondata.taxorgcode);
								//var t = $('#cc').combotree('tree');
								//var node = $('#cc').tree('find', jsondata.taxorgcode);
								//$('#cc').tree('select',node );
								var temp = jsondata.to_orgcode.split(',');
								$('#cc').combotree('setValues', temp);
							}
						});
                    });
					
                   
                </script>
                <form id="noticeform" method="post">
                    <div title="人员信息" data-options="" style="overflow:auto">
                        <table width="100%" class="table table-bordered">
                            <input id="id" type="hidden" name="id" />
                            <tr>
                                <td align="right">
                                    标题：
                                </td>
                                <td>
                                    <input class="easyui-validatebox" name="title" id="title" style="width:200px;"
                                    data-options="required:true" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    内容：
                                </td>
                                <td>
									<textarea name="content" id="content" class="easyui-validatebox" style="width:200px;height:200px" data-options="required:true"></textarea>
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
                        
                        <div style="text-align:center;padding:5px;height: 25px;">
                            <a id="btn2" class="easyui-linkbutton" icon="icon-cancel" onclick="$('#noticewindow').window('close');">
                                关闭
                            </a>
                        </div>
                    </div>
                </form>
            </body>
        
        </html>
