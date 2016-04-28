
<%@page language="java" import="com.fileserver.common.utils.MD5Util"%>
<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";

	String privateKey = MD5Util.getMD5Str(
			"&pk="
					+ ResourceBundle.getBundle("application")
							.getString("verify.privateKey"), "utf-8");							
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%-- <head uvk="<%=MD5Util.getMD5Str("&pk=" + privateKey, "utf-8")%>"> --%>
<base href="<%=basePath%>">
<title>Welcome to upload image on file server</title>
<meta http-equiv="Content-Type" content="multipart/form-data; charset=utf-8; boundary=0xKhTmLbOuNdArY-<%=UUID.randomUUID().toString().replace("-", "")%>" />
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">

<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
</head>

<script type="text/javascript">
	function previewImage(source, target) {

		var file = source.files[0];
		var src = window.URL.createObjectURL(file);

		target.src = src;
		target.height = 60;
	}
	
	function uploadimages(){
		
		var form = document.getElementById("form");
		
		var childInputs = form.getElementsByTagName("input");
		var removedChildInputs = new Array();
		
		for (var i=0; i<childInputs.length; i++){
		
			var childInput = childInputs[i];
		
			if (childInput.type == "file" && (childInput.value == null || childInput.value == "")){
		
				removedChildInputs.push(childInput);
			}
		}
		
		for(var i=0; i<removedChildInputs.length; i++){
			
			var childInput = removedChildInputs[i];
			
			form.removeChild(childInput);
		}
		form.submit();
	}
</script>

<body>
	<div style=" margin-top:20px">
		Welcome to upload image on file server. <br>
		<form id="form" style=" margin-top:20px;text-align:left;" enctype="multipart/form-data" action="biupload?uvk=<%=privateKey%>" method=POST>

			square: <input style="Content-Disposition:form-data; Content-Type:image/png" name="square" type="file" onchange="previewImage(this, squareImage)"><img id="squareImage" alt="" src="" style="display: block;"><br> 
			portraite: <input style="Content-Disposition:form-data; Content-Type:image/png" name="portraite" type="file" onchange="previewImage(this,portraiteImage)"><img id="portraiteImage" alt="" src="" style="display: block;"><br> 
			landscape: <input style="Content-Disposition:form-data; Content-Type:image/png" name="landscape" type="file" onchange="previewImage(this,landscapeImage)"><img id="landscapeImage" alt="" src="" style="display: block;"><br> 
			<input type="button" onclick="uploadimages();" value="Send File">
		</form>
	</div>
</body>
</html>
