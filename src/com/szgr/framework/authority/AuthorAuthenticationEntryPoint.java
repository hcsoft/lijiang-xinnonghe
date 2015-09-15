package com.szgr.framework.authority;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

import com.szgr.framework.interfaces.stringbased.json.JsonSerilizer;

/**
 * 权限控制切入点
 *
 */
public class AuthorAuthenticationEntryPoint extends LoginUrlAuthenticationEntryPoint{

	
	public void commence(HttpServletRequest request,
			HttpServletResponse response, AuthenticationException authException)
			throws IOException, ServletException {
		// TODO Auto-generated method stub
		System.out.println("当前登录人员访问路径:" + request.getRequestURI());
		if(!checkAjaxRequest(request.getRequestURI())){
			super.commence(request, response, authException);
		}else{
			  response.setContentType("text/x-json;charset=utf-8");
		      response.getOutputStream().write(createReturnJson("对不起！您已经退出系统或者系统后台出现异常，请重新登录，如果还不能访问，请与管理员联系！").getBytes("utf-8"));
		      response.getOutputStream().flush();
		}
	}
	
	public static String createReturnJson(String message) {
		String returnString = "";
		try {
			returnString = new JsonSerilizer().serialise(message);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return returnString;
	}
	
	public static boolean checkAjaxRequest(String urlString) {
		String tempUrlString = urlString;
		tempUrlString = tempUrlString.substring(0, tempUrlString
				.lastIndexOf("?") == -1 ? tempUrlString.length()
				: tempUrlString.lastIndexOf("?"));
		//System.out.println(tempUrlString);
		if (tempUrlString.endsWith(".do")) {
			return true;
		}
		return false;
	}

}
