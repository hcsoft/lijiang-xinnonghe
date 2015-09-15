package com.szgr.framework.authority;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

import com.szgr.framework.interfaces.stringbased.json.JsonSerilizer;

/**
 * Ȩ�޿��������
 *
 */
public class AuthorAuthenticationEntryPoint extends LoginUrlAuthenticationEntryPoint{

	
	public void commence(HttpServletRequest request,
			HttpServletResponse response, AuthenticationException authException)
			throws IOException, ServletException {
		// TODO Auto-generated method stub
		System.out.println("��ǰ��¼��Ա����·��:" + request.getRequestURI());
		if(!checkAjaxRequest(request.getRequestURI())){
			super.commence(request, response, authException);
		}else{
			  response.setContentType("text/x-json;charset=utf-8");
		      response.getOutputStream().write(createReturnJson("�Բ������Ѿ��˳�ϵͳ����ϵͳ��̨�����쳣�������µ�¼����������ܷ��ʣ��������Ա��ϵ��").getBytes("utf-8"));
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
