/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.39
 * Generated at: 2015-07-15 03:10:08 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.xnh.userquery;

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
      out.write("\t\r\n");
      out.write("</head>\r\n");
      out.write("<body class=\"easyui-layout\">  \r\n");
      out.write("<script>\r\n");
      out.write("\t$(function(){\r\n");
      out.write("\t\t$('#uniondetailgrid').datagrid({\r\n");
      out.write("\t\t\tsingleSelect:'true',\r\n");
      out.write("\t\t\tfitColumns:'true',\r\n");
      out.write("\t\t\trownumbers:'true'\r\n");
      out.write("\t\t});\r\n");
      out.write("\t});\r\n");
      out.write("\t\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\tfunction query(){\r\n");
      out.write("\t\tvar params = {};\r\n");
      out.write("\t\tvar fields =$('#userqueryform').serializeArray();\r\n");
      out.write("\t\t$.each( fields, function(i, field){\r\n");
      out.write("\t\t\tparams[field.name] = field.value;\r\n");
      out.write("\t\t}); \r\n");
      out.write("\t\t$.ajax({\r\n");
      out.write("\t\t   type: \"post\",\r\n");
      out.write("\t\t   url: \"");
      out.print(request.getContextPath());
      out.write("/Userinfo/getUnioninfo2.do\",\r\n");
      out.write("\t\t   data: params,\r\n");
      out.write("\t\t   dataType: \"json\",\r\n");
      out.write("\t\t   success: function(jsondata){\r\n");
      out.write("\t\t\t\t$('#sotremainform').form('load',jsondata);\r\n");
      out.write("\t\t\t\t$('#uniondetailgrid').datagrid('loadData',jsondata.memberlist);\r\n");
      out.write("\t\t   }\r\n");
      out.write("\t\t});\r\n");
      out.write("\t}\r\n");
      out.write("\tvar genderdata = [{label:'01',name:'男'},{label:'02',name:'女'}];\r\n");
      out.write("\tfunction formatgender(row){\r\n");
      out.write("\t\tfor(var i=0; i<genderdata.length; i++){\r\n");
      out.write("\t\t\tif (genderdata[i].label == row) return genderdata[i].name;\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\treturn row;\r\n");
      out.write("\t}\r\n");
      out.write("\t</script>\r\n");
      out.write("\t<div class=\"easyui-panel\" title=\"\" >\r\n");
      out.write("\t<form id=\"userqueryform\" method=\"post\">\r\n");
      out.write("\t\t\t\t<table id=\"narjcxx\" width=\"100%\"  class=\"table table-bordered\">\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">合作医疗证号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input id=\"union_id\" class=\"easyui-validatebox\" type=\"text\" style=\"width:200px\" name=\"union_id\" />\r\n");
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
      out.write("\t</form>\r\n");
      out.write("\t<form id=\"sotremainform\" method=\"post\">\r\n");
      out.write("\t\t<div title=\"登记信息\" data-options=\"\" style=\"overflow:auto\">\r\n");
      out.write("\t\t\t<table  width=\"100%\" class=\"table table-bordered\">\r\n");
      out.write("\t\t\t\t\t<input id=\"user_id\"  type=\"hidden\" name=\"user_id\"/>\t\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">合作医疗证号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"union_id\" id=\"union_id\" style=\"width:200px;\" data-options=\"required:false\"/>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">卡号：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-validatebox\" name=\"card_id\" id=\"card_id\" style=\"width:200px;\" onkeydown=\"next(this);\" data-options=\"required:false\"/>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">户主名称：</td>\r\n");
      out.write("\t\t\t\t\t\t<td><input id=\"user_name\" class=\"easyui-validatebox\" type=\"text\" style=\"width:200px;\" name=\"user_name\" data-options=\"required:false\"/></td>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">性别：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<select id=\"gender\" class=\"easyui-combobox\" name=\"gender\" style=\"width:200px;\" data-options=\"required:false\" editable=\"false\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<option value=\"01\">男</option>\r\n");
      out.write("\t\t\t\t\t\t\t\t<option value=\"02\">女</option>\r\n");
      out.write("\t\t\t\t\t\t\t</select>\r\n");
      out.write("\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t<td align=\"right\">年龄：</td>\r\n");
      out.write("\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<input class=\"easyui-numberbox\" name=\"age\" id=\"age\" style=\"width:200px;\" data-options=\"min:0,precision:0,required:false\"/>\t\t\t\t\r\n");
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
      out.write("\t\t\t\t\t\t\">\r\n");
      out.write("\t\t\t\t\t<table id=\"uniondetailgrid\" class=\"easyui-datagrid\"\r\n");
      out.write("\t\t\t\t\tdata-options=\"iconCls:'icon-edit',singleSelect:true\" rownumbers=\"true\"> \r\n");
      out.write("\t\t\t\t\t\t<thead>\r\n");
      out.write("\t\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'user_id',width:80,align:'center',hidden:'true'\"></th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'user_name',width:120,align:'center',editor:{type:'text',options:{required:false}}\">人员名称</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'gender',width:50,align:'center',formatter:formatgender,editor:{type:'combobox',options:{valueField:'label',textField: 'name',data:genderdata}}\">性别</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'age',width:50,align:'center',editor:{type:'numberbox',options:{precision:0,min:0,required:false}}\">年龄</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th data-options=\"field:'leader_relation',width:150,align:'center',editor:{type:'text',options:{required:false}}\">与户主关系</th>\r\n");
      out.write("\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t</thead>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
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