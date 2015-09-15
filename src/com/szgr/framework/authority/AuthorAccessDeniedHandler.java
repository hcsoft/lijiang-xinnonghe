package com.szgr.framework.authority;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandlerImpl;

/**
 * ������Ȩ�޵���Դ��ִ�еľ��
 * 
 */
public class AuthorAccessDeniedHandler extends AccessDeniedHandlerImpl {

	
	public void handle(HttpServletRequest request,
			HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException,
			ServletException {
		// System.out.println(request.getRequestURI());

//		super.handle(request, response, accessDeniedException);
		System.out.println(request.getRequestURI() + ":------------ûȨ��");
		RequestDispatcher dispatcher = request.getRequestDispatcher("/403.jsp");
		dispatcher.forward(request, response);// ��������forward
	}

}
