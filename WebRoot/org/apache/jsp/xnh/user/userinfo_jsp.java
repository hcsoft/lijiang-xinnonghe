/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.39
 * Generated at: 2015-07-15 06:30:48 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.xnh.user;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class userinfo_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("\r\n");
      out.write("<!DOCTYPE html>\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("\t<base target=\"_self\"/>\r\n");
      out.write("\t<title></title>\r\n");
      out.write("\r\n");
      out.write("\t<link rel=\"stylesheet\" href=\"");
      out.print(request.getContextPath());
      out.write("/themes/sunny/easyui.css\">\r\n");
      out.write("\t<link rel=\"stylesheet\" href=\"");
      out.print(request.getContextPath());
      out.write("/themes/icon.css\">\r\n");
      out.write("\t<link rel=\"stylesheet\" href=\"");
      out.print(request.getContextPath());
      out.write("/css/toolbar.css\">\r\n");
      out.write("\t<link rel=\"stylesheet\" href=\"");
      out.print(request.getContextPath());
      out.write("/css/logout.css\"/>\r\n");
      out.write("\t<link rel=\"stylesheet\" href=\"");
      out.print(request.getContextPath());
      out.write("/css/tablen.css\"/>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/jquery-1.8.2.min.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/jquery.easyui.min.js\"></script>\r\n");
      out.write("    <script src=\"");
      out.print(request.getContextPath());
      out.write("/js/tiles.js\"></script>\r\n");
      out.write("    <script src=\"");
      out.print(request.getContextPath());
      out.write("/js/moduleWindow.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/menus.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/common.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/jquery.simplemodal.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/overlay.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/jquery.json-2.2.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/json2.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/locale/easyui-lang-zh_CN.js\"></script>\r\n");
      out.write("\t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/jquery.simplemodal.js\"></script>\r\n");
      out.write("   \t<script src=\"");
      out.print(request.getContextPath());
      out.write("/js/uploadmodal.js\"></script> \r\n");
      out.write("\r\n");
      out.write("\t<script>\r\n");
      out.write("\tvar selectindex = undefined;\r\n");
      out.write("\tvar selectid = undefined;\r\n");
      out.write("\tvar editIndex = undefined;\r\n");
      out.write("\tvar locationdata = new Object;\r\n");
      out.write("\tvar approvetype;//批复类型\r\n");
      out.write("\tvar opttype;//操作类型\r\n");
      out.write("\tvar businesscode;\r\n");
      out.write("\tvar businessnumber;\r\n");
      out.write("\tvar datatype;//0：期初数据整理 1：日常业务 2：补录批复\r\n");
      out.write("\tvar belongtocountry = new Array();\r\n");
      out.write("\tvar belongtowns = new Array();\r\n");
      out.write("\t$(function(){\r\n");
      out.write("\t\tvar paraString = location.search;     \r\n");
      out.write("\t\tvar paras = paraString.split(\"&\");   \r\n");
      out.write("\t\tdatatype = paras[0].substr(paras[0].indexOf(\"=\") + 1); \r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\t$('#userinfogrid').datagrid({\r\n");
      out.write("\t\t\t\tfitColumns:'true',\r\n");
      out.write("\t\t\t\tmaximized:'true',\r\n");
      out.write("\t\t\t\tpagination:true,\r\n");
      out.write("\t\t\t\tview:viewed,\r\n");
      out.write("\t\t\t\ttoolbar:[{\r\n");
      out.write("\t\t\t\t\ttext:'查询',\r\n");
      out.write("\t\t\t\t\ticonCls:'icon-search',\r\n");
      out.write("\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\t$('#userquerywindow').window('open');\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t},{\r\n");
      out.write("\t\t\t\t\ttext:'新增',\r\n");
      out.write("\t\t\t\t\ticonCls:'icon-add',\r\n");
      out.write("\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\topttype='add';\r\n");
      out.write("\t\t\t\t\t\t$('#userwindow').window('open');\r\n");
      out.write("\t\t\t\t\t\t$('#userwindow').window('refresh', 'userdetail.jsp');\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t},{\r\n");
      out.write("\t\t\t\t\ttext:'修改',\r\n");
      out.write("\t\t\t\t\ticonCls:'icon-edit',\r\n");
      out.write("\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\tvar row = $('#userinfogrid').datagrid('getSelected');\r\n");
      out.write("\t\t\t\t\t\tif(row && selectindex != undefined){\r\n");
      out.write("\t\t\t\t\t\t\topttype='modify';\r\n");
      out.write("\t\t\t\t\t\t\t$('#userwindow').window('open');\r\n");
      out.write("\t\t\t\t\t\t\t$('#userwindow').window('refresh', 'userdetail.jsp');\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t},{\r\n");
      out.write("\t\t\t\t\ttext:'删除',\r\n");
      out.write("\t\t\t\t\ticonCls:'icon-cancel',\r\n");
      out.write("\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\tvar row = $('#userinfogrid').datagrid('getSelected');\r\n");
      out.write("\t\t\t\t\t\tif(row && selectindex != undefined){\r\n");
      out.write("\t\t\t\t\t\t\t$.messager.confirm('提示框', '你确定要删除吗?',function(r){\r\n");
      out.write("\t\t\t\t\t\t\t\tif(r){\r\n");
      out.write("\t\t\t\t\t\t\t\t\t$.ajax({\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\ttype: \"post\",\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\turl: \"");
      out.print(request.getContextPath());
      out.write("/Userinfo/deleteuser.do\",\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tdata: {user_id:row.user_id},\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tdataType: \"json\",\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tsuccess: function(jsondata){\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t$.messager.alert('返回消息',\"删除成功\");\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t$('#userinfogrid').datagrid('reload');\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\tselectindex = undefined;\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t//$('#userinfogrid').datagrid('selectRow',selectindex);\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t\t\t});\r\n");
      out.write("\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t})\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t}],\r\n");
      out.write("\t\t\t\tonClickRow:function(index){\r\n");
      out.write("\t\t\t\t\tvar row = $('#userinfogrid').datagrid('getSelected');\r\n");
      out.write("\t\t\t\t\tselectindex = index;\r\n");
      out.write("\t\t\t\t\tselectid = row.landstoreid;\r\n");
      out.write("\t\t\t\t},\r\n");
      out.write("\t\t\t\tonClickCell: function (rowIndex, field, value) {\r\n");
      out.write("\t\t\t\t\tif(field==\"file\"){\r\n");
      out.write("\t\t\t\t\t\t$('#userinfogrid').datagrid('selectRow',rowIndex);\r\n");
      out.write("\t\t\t\t\t\tvar row = $('#userinfogrid').datagrid('getSelected');\r\n");
      out.write("\t\t\t\t\t\tbusinesscode = row.businesscode;\r\n");
      out.write("\t\t\t\t\t\tbusinessnumber = row.businessnumber;\r\n");
      out.write("\t\t\t\t\t\t//alert(businesscode+\"-----\"+businessnumber);\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tvar p = $('#userinfogrid').datagrid('getPager');  \r\n");
      out.write("\t\t\t\t$(p).pagination({  \r\n");
      out.write("\t\t\t\t\tshowPageList:false,\r\n");
      out.write("\t\t\t\t\tpageSize: 15\r\n");
      out.write("\t\t\t\t});\r\n");
      out.write("\r\n");
      out.write("\t\t\t$.extend($.fn.datagrid.defaults.editors, {\r\n");
      out.write("\t\t\t\t\t\t\tuploadfile: {\r\n");
      out.write("\t\t\t\t\t\t\tinit: function(container, options)\r\n");
      out.write("\t\t\t\t\t\t\t\t{\r\n");
      out.write("\t\t\t\t\t\t\t\t\tvar editorContainer = $('<div/>');\r\n");
      out.write("\t\t\t\t\t\t\t\t\tvar button = $(\"<a href='javascript:void(0)'></a>\")\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t .linkbutton({plain:true, iconCls:\"icon-remove\"});\r\n");
      out.write("\t\t\t\t\t\t\t\t\teditorContainer.append(button);\r\n");
      out.write("\t\t\t\t\t\t\t\t\teditorContainer.appendTo(container);\r\n");
      out.write("\t\t\t\t\t\t\t\t\treturn button;\r\n");
      out.write("\t\t\t\t\t\t\t\t},\r\n");
      out.write("\t\t\t\t\t\t\tgetValue: function(target)\r\n");
      out.write("\t\t\t\t\t\t\t\t{\r\n");
      out.write("\t\t\t\t\t\t\t\t\treturn $(target).text();\r\n");
      out.write("\t\t\t\t\t\t\t\t},\r\n");
      out.write("\t\t\t\t\t\t\tsetValue: function(target, value)\r\n");
      out.write("\t\t\t\t\t\t\t\t{\r\n");
      out.write("\t\t\t\t\t\t\t\t\t$(target).text(value);\r\n");
      out.write("\t\t\t\t\t\t\t\t},\r\n");
      out.write("\t\t\t\t\t\t\tresize: function(target, width)  \r\n");
      out.write("\t\t\t\t\t\t\t\t {  \r\n");
      out.write("\t\t\t\t\t\t\t\t\tvar span = $(target);  \r\n");
      out.write("\t\t\t\t\t\t\t\t\tif ($.boxModel == true){  \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tspan.width(width - (span.outerWidth() - span.width()) - 10);  \r\n");
      out.write("\t\t\t\t\t\t\t\t\t} else {  \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tspan.width(width - 10);  \r\n");
      out.write("\t\t\t\t\t\t\t\t\t}  \r\n");
      out.write("\t\t\t\t\t\t\t\t}\t\r\n");
      out.write("\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t});\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t});\r\n");
      out.write("\tvar viewed = $.extend({},$.fn.datagrid.defaults.view,{\r\n");
      out.write("\t\t\t\tonAfterRender: function(target){\r\n");
      out.write("\t\t\t\t\t\t\t\t$('#userinfogrid').datagrid('unselectAll');\r\n");
      out.write("\t\t\t\t\t\t\t} \r\n");
      out.write("\t\t\t\t});\r\n");
      out.write("\t\r\n");
      out.write("\r\n");
      out.write("\t\tfunction query(){\r\n");
      out.write("\t\t\tvar params = {};\r\n");
      out.write("\t\t\tvar fields =$('#userqueryform').serializeArray();\r\n");
      out.write("\t\t\t$.each( fields, function(i, field){\r\n");
      out.write("\t\t\t\tparams[field.name] = field.value;\r\n");
      out.write("\t\t\t}); \r\n");
      out.write("\t\t\t//$('#userinfogrid').datagrid({\r\n");
      out.write("\t\t\t//\turl:'/InitGroundServlet/getlandstoreinfo.do'\r\n");
      out.write("\t\t\t//});\r\n");
      out.write("\t\t\tparams.datatype=datatype;\r\n");
      out.write("\t\t\t$('#userinfogrid').datagrid('loadData',{total:0,rows:[]});\r\n");
      out.write("\t\t\tvar opts = $('#userinfogrid').datagrid('options');\r\n");
      out.write("\t\t\topts.url = '");
      out.print(request.getContextPath());
      out.write("/Userinfo/getuserinfo.do';\r\n");
      out.write("\t\t\t$('#userinfogrid').datagrid('load',params); \r\n");
      out.write("\t\t\tvar p = $('#userinfogrid').datagrid('getPager');  \r\n");
      out.write("\t\t\t$(p).pagination({   \r\n");
      out.write("\t\t\t\tshowPageList:false,\r\n");
      out.write("\t\t\t\tpageSize: 15\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t\t$('#userquerywindow').window('close');\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t}\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\t</script>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("\t<form id=\"groundstorageform\" method=\"post\">\r\n");
      out.write("\t\t<div title=\"登记信息\" data-options=\"\r\n");
      out.write("\t\t\t\t\t\ttools:[{\r\n");
      out.write("\t\t\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\t\t\t$('#userinfogrid').datagrid('reload');\r\n");
      out.write("\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t}]\">\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t<table id=\"userinfogrid\" style=\"overflow:auto\" \r\n");
      out.write("\t\t\t\t\t\tdata-options=\"iconCls:'icon-edit',singleSelect:true,idField:'itemid'\" rownumbers=\"true\"> \r\n");
      out.write("\t\t\t\t\t\t\t<thead>\r\n");
      out.write("\t\t\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<th data-options=\"field:'user_id',width:180,align:'center',hidden:true,editor:{type:'text'}\"></th>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<th data-options=\"field:'union_id',width:80,align:'left',editor:{type:'validatebox'}\">合作医疗证号</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<th data-options=\"field:'card_id',width:80,align:'left',editor:{type:'validatebox'}\">卡号</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<th data-options=\"field:'user_name',width:200,align:'left',editor:{type:'validatebox'}\">人员名称</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<th data-options=\"field:'gender',width:100,align:'left',formatter:function(value,row,index){\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tif(value=='01'){\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\treturn '男';\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tif(value=='02'){\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\treturn '女';\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t\t\t},\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\teditor:{type:'validatebox'}\">性别</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<th data-options=\"field:'age',width:60,align:'center',editor:{type:'validatebox'}\">年龄</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
      out.write("<th data-options=\"field:'valid',width:100,align:'left',formatter:function(value,row,index){\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tif(value=='01'){\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\treturn '有效';\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tif(value=='00'){\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\treturn '无效';\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t\t\t},\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\teditor:{type:'validatebox'}\">有效标识</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t\t</thead>\r\n");
      out.write("\t\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t</form>\r\n");
      out.write("\t<div id=\"userquerywindow\" class=\"easyui-window\" data-options=\"closed:true,modal:true,title:'登记信息查询',collapsible:false,minimizable:false,maximizable:false,closable:true\" style=\"width:940px;height:150px;\">\r\n");
      out.write("\t\t<div class=\"easyui-panel\" title=\"\" style=\"width:900px;\">\r\n");
      out.write("\t\t\t<form id=\"userqueryform\" method=\"post\">\r\n");
      out.write("\t\t\t\t<table id=\"narjcxx\" width=\"100%\"  class=\"table table-bordered\">\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">合作医疗证号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input id=\"user_id\" class=\"easyui-validatebox\" type=\"text\" style=\"width:200px\" name=\"user_id\" />\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">卡号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input id=\"card_id\" class=\"easyui-validatebox\" type=\"text\" style=\"width:200px\" name=\"card_id\"/>\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t</table>\r\n");
      out.write("\t\t\t</form>\r\n");
      out.write("\t\t\t<div style=\"text-align:center;padding:5px;\">  \r\n");
      out.write("\t\t\t\t\t<a href=\"###\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"query()\">查询</a>\r\n");
      out.write("\t\t\t\t\t<!-- <a href=\"#\" class=\"easyui-linkbutton\" id=\"aaa\" data-options=\"iconCls:'icon-search'\" >查询</a> -->\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<!-- <div id=\"groundstorageeditwindow\" class=\"easyui-window\" data-options=\"closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true\" style=\"width:940px;height:300px;\">\r\n");
      out.write("\t\t<div class=\"easyui-panel\" title=\"\" style=\"width:900px;\">\r\n");
      out.write("\t\t\t<form id=\"groundstorageeditform\" method=\"post\">\r\n");
      out.write("\t\t\t\t<table id=\"narjcxx\" width=\"100%\" class=\"table table-bordered\">\r\n");
      out.write("\t\t\t\t\t<input id=\"landstoreid\"  type=\"hidden\" name=\"landstoreid\"/>\t\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">批复类型：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-combobox\" name=\"approvetype\" id=\"approvetype\" data-options=\"disabled:false,panelWidth:300,panelHeight:200\"/>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">批复名称：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"name\" id=\"name\"/>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">厅级批准文号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td><input id=\"approvenumber\" class=\"easyui-validatebox\" type=\"text\" name=\"approvenumber\"/></td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">市级批准文号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input id=\"approvenumbercity\" class=\"easyui-validatebox\" type=\"text\" name=\"approvenumbercity\"/>\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">纳税人计算机编码：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"taxpayer\" id=\"taxpayer\"/>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">纳税人计算机名称：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"taxpayername\" id=\"taxpayername\"/>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">批复日期：</td>\r\n");
      out.write("\t\t\t\t\t\t<td colspan=\"3\">\r\n");
      out.write("\t\t\t\t\t\t\t<input id=\"approvedates\" class=\"easyui-datebox\" name=\"approvedates\"/>\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t</table>\r\n");
      out.write("\t\t\t</form>\r\n");
      out.write("\t\t\t<div style=\"text-align:center;padding:5px;\">\r\n");
      out.write("\t\t\t\t<a href=\"#\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-search'\" onclick=\"quereyreg()\">税务登记查询</a>\r\n");
      out.write("\t\t\t\t<a href=\"#\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-save'\" onclick=\"save()\">保存</a>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div> -->\r\n");
      out.write("\t<!-- <div id=\"groundstoragedetailwindow\" class=\"easyui-window\" data-options=\"closed:true,modal:true,title:'土地收储批复明细',collapsible:false,minimizable:false,maximizable:false,closable:false\" style=\"width:800px;height:400px;\">\r\n");
      out.write("\t<table id=\"uniondetailgrid\"></table>\r\n");
      out.write("\t</div> -->\r\n");
      out.write("\t<div id=\"reginfowindow\" class=\"easyui-window\" data-options=\"closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true\" style=\"width:620px;height:470px;\">\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div id=\"userwindow\" class=\"easyui-window\" data-options=\"closed:true,modal:true,title:'新农合卡登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false\" style=\"width:1000px;height:500px;\">\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<!-- <div id=\"groundstorageaddwindow\" class=\"easyui-window\" data-options=\"closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true\" style=\"width:940px;height:200px;\">\r\n");
      out.write("\t</div> -->\r\n");
      out.write("\t<!-- <div id=\"addtdxxwindow\" class=\"easyui-window\" data-options=\"closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true\" style=\"width:940px;height:500px;\">\r\n");
      out.write("\t</div> -->\r\n");
      out.write("\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
