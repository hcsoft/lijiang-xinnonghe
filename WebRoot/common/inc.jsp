<%@page import="com.szgr.common.PropertyConfigurer.PropertyConfigurerAcesse"%>
<%
	response.setHeader("Content-Type", "text/html");
	//no cache
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    
    //cache
    //response.setHeader("Cache-Control", "max-age="+(12*60*60)+", must-revalidate");
    //response.setDateHeader("Date", System.currentTimeMillis());
    //response.setDateHeader("Expires", System.currentTimeMillis()+12*60*60*1000);
    
    //apache
	//http://154.20.158.4:7001/jnds_rest/services/jnds/MapServer
    String spath = "";
	String mapServerPath = (String) PropertyConfigurerAcesse
			.getContextProperty("mapServerPath");
	//System.out.println("------" + mapServerPath + "-----------");
	//String mapServerPath = "http://localhost:8001/jnds_rest/services/jnds";
	//String mapServerPath = "http://154.20.158.4:7001/jnds_rest/services";
    

%>