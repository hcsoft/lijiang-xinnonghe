/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.39
 * Generated at: 2015-08-25 06:10:28 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.login;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class login_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\r\n");
      out.write("\r\n");
      out.write("<title>新农合证卡管理系统</title>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/login-js/jquery.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/login-js/common.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/login-js/jquery.tscookie.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/login-js/jquery.validation.min.js\"></script>\r\n");
      out.write("<link href=\"");
      out.print(request.getContextPath());
      out.write("/login-css/login.css\" rel=\"stylesheet\" type=\"text/css\">\r\n");
      out.write("<style type=\"text/css\">\r\n");
      out.write("body {\r\n");
      out.write("\tbackground-color: #666666;\r\n");
      out.write("\tbackground-image: url(\"\");\r\n");
      out.write("\tbackground-repeat: no-repeat;\r\n");
      out.write("\tbackground-position: center top;\r\n");
      out.write("\tbackground-attachment: fixed;\r\n");
      out.write("\tbackground-clip: border-box;\r\n");
      out.write("\tbackground-size: cover;\r\n");
      out.write("\tbackground-origin: padding-box;\r\n");
      out.write("\twidth: 100%;\r\n");
      out.write("\tpadding: 0;\r\n");
      out.write("}\r\n");
      out.write("</style>\r\n");
      out.write("</head>\r\n");
      out.write("<body style=\"background-image: url(");
      out.print(request.getContextPath());
      out.write("/login/bg_1.jpg);\">\r\n");
      out.write("\r\n");
      out.write("<div class=\"bg-dot\"></div>\r\n");
      out.write("<div class=\"login-layout\">\r\n");
      out.write("  <div class=\"top\">\r\n");
      out.write("    <h5>丽江市玉龙纳西族自治县卫生局<em></em></h5>\r\n");
      out.write("    <h2>新农合证卡管理系统</h2>\r\n");
      out.write("<!--    <h6>--><!--</h6>-->\r\n");
      out.write("  </div>\r\n");
      out.write("  <div class=\"box\">\r\n");
      out.write("    <form method=\"post\"  action=\"");
      out.print(request.getContextPath());
      out.write("/j_spring_security_check\">\r\n");
      out.write("      <input type=\"hidden\" name=\"formhash\" value=\"InvdBdNrBmZyhFXEdQuQ8rVoewCbj2N\">      <input type=\"hidden\" name=\"form_submit\" value=\"ok\">\r\n");
      out.write("      <span>\r\n");
      out.write("      <label>帐号</label>\r\n");
      out.write("      <input name=\"j_username\" id=\"j_username\" autocomplete=\"off\" type=\"text\" class=\"input-text\" >\r\n");
      out.write("      </span> <span>\r\n");
      out.write("      <label>密码</label>\r\n");
      out.write("      <input name=\"j_password\" id=\"j_password\" class=\"input-password\" autocomplete=\"off\" type=\"password\"  >\r\n");
      out.write("      </span> <span>\r\n");
      out.write("      <div class=\"code\">\r\n");
      out.write("        <div class=\"arrow\"></div>\r\n");
      out.write("        <div class=\"code-img\"><img src=\"/login/random.jsp\" name=\"codeimage\" id=\"random_img\" border=\"0\"/></div>\r\n");
      out.write("        <a href=\"JavaScript:void(0);\" id=\"hide\" class=\"close\" title=\"关闭\"><i></i></a>\r\n");
      out.write("        <a href=\"JavaScript:void(0);\"  id=\"refreash\" class=\"change\" title=\"刷新\"><i></i></a>\r\n");
      out.write("         </div>\r\n");
      out.write("      <input name=\"captcha\" type=\"text\" required=\"\" class=\"input-code\" id=\"captcha\" placeholder=\"输入验证\" pattern=\"[A-z0-9]{4}\" title=\"验证码为4个字符\" autocomplete=\"off\" value=\"\">\r\n");
      out.write("      </span><span>\r\n");
      out.write("      <input name=\"\" class=\"input-button\" type=\"submit\" value=\"登录\">\r\n");
      out.write("      </span>\r\n");
      out.write("      \r\n");
      out.write("    </form>\r\n");
      out.write("    <div style=\"float:left;line-height: 25px;\"><h6>系统需要使用谷歌浏览器运行</h6></div>\r\n");
      out.write("      \r\n");
      out.write("      <div style=\"background: url(images/gg.gif) 0 5px no-repeat;\r\n");
      out.write("  padding-left: 20px;\r\n");
      out.write("  float: left;\r\n");
      out.write("  font-size: 12px;\r\n");
      out.write("  line-height: 25px;\r\n");
      out.write("  padding-right: 245px;\r\n");
      out.write("  margin-left: 20px;\">\r\n");
      out.write("\t<a href=\"/download/chrome_installer_552.210.exe\">谷歌浏览器下载</a>\r\n");
      out.write("\t</div>\r\n");
      out.write("  </div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"bottom\">\r\n");
      out.write("  <h6> © 恒辰科技有限公司版权所有</h6>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("$(document).ready(function(){\r\n");
      out.write("    //Random background image\r\n");
      out.write("    var random_bg=Math.floor(Math.random()*4+1);\r\n");
      out.write("    var bg='url(/login/bg_'+random_bg+'.jpg)';\r\n");
      out.write("    $(\"body\").css(\"background-image\",bg);\r\n");
      out.write("    //Hide Show verification code\r\n");
      out.write("    $(\"#hide\").click(function(){\r\n");
      out.write("        $(\".code\").fadeOut(\"slow\");\r\n");
      out.write("    });\r\n");
      out.write("    $(\"#captcha\").focus(function(){\r\n");
      out.write("        $(\".code\").fadeIn(\"fast\");\r\n");
      out.write("    });\r\n");
      out.write("    //跳出框架在主窗口登录\r\n");
      out.write("   if(top.location!=this.location)\ttop.location=this.location;\r\n");
      out.write("    $('#user_name').focus();\r\n");
      out.write("    if ($.browser.msie && $.browser.version==\"6.0\"){\r\n");
      out.write("        window.location.href='http://localhost/xingkang/admin/templates/default/ie6update.html';\r\n");
      out.write("    }\r\n");
      out.write("    $(\"#captcha\").nc_placeholder();\r\n");
      out.write("    \r\n");
      out.write("    $('#refreash').click(function() {\r\n");
      out.write("    \t$('#random_img').attr(\"src\", \"");
      out.print(request.getContextPath());
      out.write("/login/random.jsp?times=\" + new Date().getTime());\r\n");
      out.write("        \r\n");
      out.write("    });\r\n");
      out.write("});\r\n");
      out.write("\r\n");
      out.write("</script>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<iframe id=\"TSLOGINI\" style=\"display:none\" src=\"\"></iframe></body></html>");
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
