<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="js/jquery-2.1.4.js" ></script>
  </head>
  
  <body>
    	<table width="400px" height="300px" border="1px solid red">
    		<tr height="20%">
    			<td style="width: 20%">${status}</td>
    			<td style="width: 80%">${content}</td>
    		</tr>
    		<tr>
    			<td colspan="2" style="width: 100%">
    				<textarea style="width: 100%; height:100%" readonly="readonly">${bz}</textarea>
    			</td>
    		</tr>
    	</table>
  </body>
</html>
