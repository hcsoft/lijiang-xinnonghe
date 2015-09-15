<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title>测试华表</title>
<script type="text/javascript">
    function loginCell()
    {
     document.getElementById("DCellWeb1").Login("成都信泰科技有限公司","","13100105668","3520-1655-0102-3005");
    }
</script>
</head>
<body>
<table class="t2" border="1" align="center" height="100%" width="960">
	<tr height="24">
		<td>
		   <object id="DCellWeb1" style="left: 0px; width: 900px; top: 0px; height: 900px" codebase="http://192.168.0.111:7001/cellplug/cellweb5.cab"
                classid="clsid:3F166327-8030-4881-8BD2-EA25350E574A" >
                <param name="_Version" value="65536" />
                <param name="_ExtentX" value="10266" />
                <param name="_ExtentY" value="7011" />
                <param name="_StockProps" value="0" />
            </object>
		</td>
	</tr>	
	<tr height="24">
		<td>
			<input type="button" value="提交" onclick="comit2server()"/>
		</td>
	</tr>

	
</table>

</body>
</html>
