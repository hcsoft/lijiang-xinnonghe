/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.39
 * Generated at: 2015-07-15 02:54:15 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.xnh.user;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class userdetail_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("\t\r\n");
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
      out.write("\r\n");
      out.write("\t\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<script>\r\n");
      out.write("\t$(function(){\r\n");
      out.write("\t\t//alert(opttype);\r\n");
      out.write("\t\tif(opttype=='modify'){\r\n");
      out.write("\t\t\tvar row = $('#userinfogrid').datagrid('getSelected');\r\n");
      out.write("\t\t\tapprovetype = row.approvetype;\r\n");
      out.write("\t\t\t$('#laststep').hide();\r\n");
      out.write("\t\t\t$.ajax({\r\n");
      out.write("\t\t\t   type: \"post\",\r\n");
      out.write("\t\t\t   url: \"");
      out.print(request.getContextPath());
      out.write("/Userinfo/getUnioninfo.do\",\r\n");
      out.write("\t\t\t   data: {user_id:row.user_id},//获取户主信息\r\n");
      out.write("\t\t\t   dataType: \"json\",\r\n");
      out.write("\t\t\t   success: function(jsondata){\r\n");
      out.write("\t\t\t\t\t$('#sotremainform').form('load',jsondata);\r\n");
      out.write("\t\t\t\t\t$('#uniondetailgrid').datagrid('loadData',jsondata.memberlist);\r\n");
      out.write("\t\t\t   }\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t$('#uniondetailgrid').datagrid({\r\n");
      out.write("\t\t\t\tsingleSelect:'true',\r\n");
      out.write("\t\t\t\tfitColumns:'true',\r\n");
      out.write("\t\t\t\trownumbers:'true',\r\n");
      out.write("\t\t\t\ttoolbar:[{\r\n");
      out.write("\t\t\t\t\ttext:'新建',\r\n");
      out.write("\t\t\t\t\ticonCls:'icon-add',\r\n");
      out.write("\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\tif (endEditing()){\r\n");
      out.write("\t\t\t\t\t\t\t$('#uniondetailgrid').datagrid('endEdit', editIndex);\r\n");
      out.write("\t\t\t\t\t\t\t$('#uniondetailgrid').datagrid('appendRow',{\r\n");
      out.write("\t\t\t\t\t\t\t\tuser_id:'',\r\n");
      out.write("\t\t\t\t\t\t\t\tuser_name:'',\r\n");
      out.write("\t\t\t\t\t\t\t\tgender:'01',\r\n");
      out.write("\t\t\t\t\t\t\t\tage:'',\r\n");
      out.write("\t\t\t\t\t\t\t\tleader_relation:''\r\n");
      out.write("\t\t\t\t\t\t\t});\r\n");
      out.write("\t\t\t\t\t\t\teditIndex = $('#uniondetailgrid').datagrid('getRows').length-1;  \r\n");
      out.write("\t\t\t\t\t\t\t$('#uniondetailgrid').datagrid('selectRow', editIndex)  \r\n");
      out.write("\t\t\t\t\t\t\t\t\t.datagrid('beginEdit', editIndex);\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t},{\r\n");
      out.write("\t\t\t\t\ttext:'修改',\r\n");
      out.write("\t\t\t\t\ticonCls:'icon-edit',\r\n");
      out.write("\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\tif(endEditing()){\r\n");
      out.write("\t\t\t\t\t\t\tvar row = $('#uniondetailgrid').datagrid('getSelected');\r\n");
      out.write("\t\t\t\t\t\t\tvar index = $('#uniondetailgrid').datagrid('getRowIndex',row);\r\n");
      out.write("\t\t\t\t\t\t\t$('#uniondetailgrid').datagrid('beginEdit',index);\r\n");
      out.write("\t\t\t\t\t\t\teditIndex = index;\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t},{\r\n");
      out.write("\t\t\t\t\ttext:'删除',\r\n");
      out.write("\t\t\t\t\ticonCls:'icon-remove',\r\n");
      out.write("\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\tvar index = $('#uniondetailgrid').datagrid('getRowIndex',$('#uniondetailgrid').datagrid('getSelected'));\r\n");
      out.write("\t\t\t\t\t\t//alert(index);\r\n");
      out.write("\t\t\t\t\t\tif(index >=0){\r\n");
      out.write("\t\t\t\t\t\t\t$('#uniondetailgrid').datagrid('deleteRow', index);    \r\n");
      out.write("\t\t\t\t\t\t\teditIndex = undefined;\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t},{\r\n");
      out.write("\t\t\t\t\ttext:'保存',\r\n");
      out.write("\t\t\t\t\ticonCls:'icon-save',\r\n");
      out.write("\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\tif(!$('#user_name').validatebox('isValid')){\r\n");
      out.write("\t\t\t\t\t\t\t$.messager.alert('提示','户主名称不能为空！');\r\n");
      out.write("\t\t\t\t\t\t\treturn;\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\tif(!$('#union_id').validatebox('isValid')){\r\n");
      out.write("\t\t\t\t\t\t\t$.messager.alert('提示','合作医疗证号不能为空！');\r\n");
      out.write("\t\t\t\t\t\t\treturn;\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\tif(!$('#card_id').validatebox('isValid')){\r\n");
      out.write("\t\t\t\t\t\t\t$.messager.alert('提示','卡号不能为空！');\r\n");
      out.write("\t\t\t\t\t\t\treturn;\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\tif(!$('#age').validatebox('isValid')){\r\n");
      out.write("\t\t\t\t\t\t\t$.messager.alert('提示','年龄不能为空！');\r\n");
      out.write("\t\t\t\t\t\t\treturn;\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\tvar effectRow = new Object();\r\n");
      out.write("\t\t\t\t\t\tif(endEditing()){\r\n");
      out.write("\t\t\t\t\t\t\tvar data = $('#uniondetailgrid').datagrid('getChanges');\r\n");
      out.write("\t\t\t\t\t\t\t//var row = $('#userinfogrid').datagrid('getSelected');\r\n");
      out.write("\t\t\t\t\t\t\tif (data.length) {\r\n");
      out.write("\t\t\t\t\t\t\t\tvar inserted = $('#uniondetailgrid').datagrid('getChanges', \"inserted\");\r\n");
      out.write("\t\t\t\t\t\t\t\tvar deleted = $('#uniondetailgrid').datagrid('getChanges', \"deleted\");\r\n");
      out.write("\t\t\t\t\t\t\t\tvar updated = $('#uniondetailgrid').datagrid('getChanges', \"updated\");\r\n");
      out.write("\t\t\t\t\t\t\t\t//alert(\"inserted=\"+inserted.length+\"---deleted=\"+deleted.length+\"-----updated=\"+updated.length);\r\n");
      out.write("\t\t\t\t\t\t\t\tendEdits();\r\n");
      out.write("\t\t\t\t\t\t\t\tif (inserted.length) {\r\n");
      out.write("\t\t\t\t\t\t\t\t\teffectRow.inserted = inserted;\r\n");
      out.write("\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t\tif (deleted.length) {\r\n");
      out.write("\t\t\t\t\t\t\t\t\teffectRow.deleted = deleted;\r\n");
      out.write("\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t\tif (updated.length) {\r\n");
      out.write("\t\t\t\t\t\t\t\t\teffectRow.updated = updated;\r\n");
      out.write("\t\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\tvar params = {};\r\n");
      out.write("\t\t\t\t\t\tvar fields =$('#sotremainform').serializeArray();\r\n");
      out.write("\t\t\t\t\t\t$.each( fields, function(i, field){\r\n");
      out.write("\t\t\t\t\t\t\tparams[field.name] = field.value;\r\n");
      out.write("\t\t\t\t\t\t});\r\n");
      out.write("\t\t\t\t\t\teffectRow.maininfo = params;\r\n");
      out.write("\t\t\t\t\t\t//alert(JSON.stringify(effectRow));\r\n");
      out.write("\t\t\t\t\t\t$.ajax({\r\n");
      out.write("\t\t\t\t\t\t\t   type: \"post\",\r\n");
      out.write("\t\t\t\t\t\t\t   url: \"");
      out.print(request.getContextPath());
      out.write("/Userinfo/saveUnioninfo.do\",\r\n");
      out.write("\t\t\t\t\t\t\t   data: $.toJSON(effectRow),\r\n");
      out.write("\t\t\t\t\t\t\t   contentType: \"application/json; charset=utf-8\",\r\n");
      out.write("\t\t\t\t\t\t\t   dataType: \"json\",\r\n");
      out.write("\t\t\t\t\t\t\t   success: function(jsondata){\r\n");
      out.write("\t\t\t\t\t\t\t\t   $('#userinfogrid').datagrid('reload');\r\n");
      out.write("\t\t\t\t\t\t\t\t   $('#sotremainform').form('load',jsondata);\r\n");
      out.write("\t\t\t\t\t\t\t\t   $('#uniondetailgrid').datagrid('loadData',jsondata.memberlist);\r\n");
      out.write("\t\t\t\t\t\t\t\t   //refreshLandstoredetail();\r\n");
      out.write("\t\t\t\t\t\t\t\t   $.messager.alert('返回消息','保存成功');\r\n");
      out.write("\t\t\t\t\t\t\t\t   $('#groundstorewindow').window('close');\r\n");
      out.write("\t\t\t\t\t\t\t   },\r\n");
      out.write("\t\t\t\t\t\t\t\terror:function (data, status, e){   \r\n");
      out.write("\t\t\t\t\t\t\t\t\t $.messager.alert('返回消息',\"保存出错\");   \r\n");
      out.write("\t\t\t\t\t\t\t\t} \r\n");
      out.write("\t\t\t\t\t   });\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t}],\r\n");
      out.write("\t\t\t\tonClickRow:function(index){\r\n");
      out.write("\t\t\t\t\tif(editIndex == undefined){\r\n");
      out.write("\t\t\t\t\t\t$('#uniondetailgrid').datagrid('selectRow', index);\r\n");
      out.write("\t\t\t\t\t}else{\r\n");
      out.write("\t\t\t\t\t\tif (editIndex != index){  \r\n");
      out.write("\t\t\t\t\t\t\tif (endEditing()){  \r\n");
      out.write("\t\t\t\t\t\t\t\t$('#uniondetailgrid').datagrid('selectRow', index);  \r\n");
      out.write("\t\t\t\t\t\t\t}else{\r\n");
      out.write("\t\t\t\t\t\t\t\t$('#uniondetailgrid').datagrid('unselectRow', index);  \r\n");
      out.write("\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\tfunction openregwindow(){\r\n");
      out.write("\t\t//alert('aaa');\r\n");
      out.write("\t\t$('#reginfowindow').window('open');//打开新录入窗口\r\n");
      out.write("\t\t$('#reginfowindow').window('refresh', 'reginfo.jsp');\r\n");
      out.write("\t}\r\n");
      out.write("\r\n");
      out.write("\t$.extend($.fn.validatebox.defaults.rules, {   \r\n");
      out.write("\t\tdatecheck: {   \r\n");
      out.write("\t\t\tvalidator: function(value){ \r\n");
      out.write("\t\t\t\treturn /^((((1[6-9]|[2-9]\\d)\\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\\d|3[01]))|(((1[6-9]|[2-9]\\d)\\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\\d|30))|(((1[6-9]|[2-9]\\d)\\d{2})-0?2-(0?[1-9]|1\\d|2[0-8]))|(((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);\r\n");
      out.write("\t\t\t},   \r\n");
      out.write("\t\t\tmessage: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  \r\n");
      out.write("\t\t}   \r\n");
      out.write("\t});\r\n");
      out.write("\t\r\n");
      out.write("\tfunction next(obj){\r\n");
      out.write("\t\tif(event.keyCode==13){ \r\n");
      out.write("\t\t\t//alert($('#user_name').length);\r\n");
      out.write("\t\t\t$('#user_name')[0].focus();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\tvar genderdata = [{label:'01',name:'男'},{label:'02',name:'女'}];\r\n");
      out.write("\tfunction formatgender(row){\r\n");
      out.write("\t\tfor(var i=0; i<genderdata.length; i++){\r\n");
      out.write("\t\t\tif (genderdata[i].label == row) return genderdata[i].name;\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\treturn row;\r\n");
      out.write("\t}\r\n");
      out.write("\t</script>\r\n");
      out.write("\t<form id=\"sotremainform\" method=\"post\">\r\n");
      out.write("\t\t<div title=\"登记信息\" data-options=\"\" style=\"overflow:auto\">\r\n");
      out.write("\t\t\t<table  width=\"100%\" class=\"table table-bordered\">\r\n");
      out.write("\t\t\t\t\t<input id=\"user_id\"  type=\"hidden\" name=\"user_id\"/>\t\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">合作医疗证号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"union_id\" id=\"union_id\" style=\"width:200px;\" data-options=\"required:true\"/>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">卡号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"card_id\" id=\"card_id\" style=\"width:200px;\" onkeydown=\"next(this);\" data-options=\"required:true\"/>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">户主名称：</td>\r\n");
      out.write("\t\t\t\t\t\t<td><input id=\"user_name\" class=\"easyui-validatebox\" type=\"text\" style=\"width:200px;\" name=\"user_name\" data-options=\"required:true\"/></td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">性别：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<select id=\"gender\" class=\"easyui-combobox\" name=\"gender\" style=\"width:200px;\" data-options=\"required:true\" editable=\"false\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<option value=\"01\">男</option>\r\n");
      out.write("\t\t\t\t\t\t\t\t<option value=\"02\">女</option>\r\n");
      out.write("\t\t\t\t\t\t\t</select>\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">年龄：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-numberbox\" name=\"age\" id=\"age\" style=\"width:200px;\" data-options=\"min:0,precision:0,required:true\"/>\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">联系电话：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"telephone\" id=\"telephone\" style=\"width:200px;\" data-options=\"required:false\"/>\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">身份证号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"idnumber\" id=\"aidnumberge\" style=\"width:200px;\" data-options=\"required:false\"/>\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">地址：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"address\" id=\"address\" style=\"width:200px;\" data-options=\"required:false\"/>\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t</table>\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</form>\r\n");
      out.write("\t\t<div title=\"\" style=\"overflow:auto\" data-options=\"\r\n");
      out.write("\t\t\t\t\t\ttools:[{\r\n");
      out.write("\t\t\t\t\t\t\thandler:function(){\r\n");
      out.write("\t\t\t\t\t\t\t\t$('#uniondetailgrid').datagrid('reload');\r\n");
      out.write("\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t}]\">\r\n");
      out.write("\t\t\t\t\t<table id=\"uniondetailgrid\" \r\n");
      out.write("\t\t\t\t\tdata-options=\"iconCls:'icon-edit',singleSelect:true\" rownumbers=\"true\"> \r\n");
      out.write("\t\t\t\t\t\t<thead>\r\n");
      out.write("\t\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'user_id',width:80,align:'center',hidden:'true'\"></th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'user_name',width:120,align:'center',editor:{type:'text',options:{required:false}}\">人员名称</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'gender',width:50,align:'center',formatter:formatgender,editor:{type:'combobox',options:{valueField:'label',textField: 'name',data:genderdata}}\">性别</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'age',width:50,align:'center',editor:{type:'numberbox',options:{precision:0,min:0,required:true}}\">年龄</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'leader_relation',width:150,align:'center',editor:{type:'text',options:{required:false}}\">与户主关系</th>\r\n");
      out.write("\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t</thead>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\r\n");
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
