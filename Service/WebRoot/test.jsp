<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="js/jquery-2.1.4.js" ></script>
	<script type="text/javascript" src="js/json2.js" ></script>
	<script type="text/javascript" src="js/jquery.json-2.4.min.js" ></script>
<script type="text/javascript">
		$(function(){
			var number;
			$("#interfaceNumbers").change(function(){
				var interfaceNumber = $("#interfaceNumbers").val();
				$.ajax({
                     url:'getParamsString',
                     type:'post',
                     dataType:'json',
                     data:{'interfaceNumber': interfaceNumber},
                     success:function(data){
                     	var item;
                     	$.each(data.array,function(index){
                     		$.each(data.array[index],function(key,value){
	                     		item = "<tr>" + 
	                     		"<td align='"+"right"+"'>" + value + "：" + "</td>"
	                     		+"<td align='"+"left"+"'><input type='text' class='count' required='true' name='" +value+"' /></td>"
	                     		+"<tr>"
	                     		$("#tab").append(item);
	                     	});
                        }); 
                        $("#tab").append("<input type='hidden' name='number' value='" + data.number +"' />")
                     },
                     error:function(){
                         //失败调用该函数
                         alert('系统出错');
                     }
                 })
			});
			
			var params='';
			var tomd5='';
			$("#countParams").click(function(){
				var interfaceNumber = $("#interfaceNumbers").val();
				var uuid = $("#uuid").val();
				tomd5 += 'm=' + interfaceNumber + '.1.0|';
				tomd5 += 'sid='+ uuid + '|';
				tomd5 += 'p=';
				params += '{';
                $(".count").each(function(){
                    params += '"' + $(this).attr('name') + '"';
                    params += ':';
                    params += '"' + $(this).val() + '"';
                    params += ',';
                });
                if(params.length>1){
                	params = params.substring(0, params.length-1);
                }
                
                params += '}';
                tomd5 += params;
                $.ajax({
                     url:'getUvk?tomd5=' + tomd5,
                     type:'post',
                     success:function(data){
                     	$("#uvk").val(data);
                		$("#md5").text(data);
                		params="";
                		tomd5="";
                     },
                     error:function(){
                         //失败调用该函数
                         alert('系统出错');
                     }
                 })
			});
			
			var allParams={};
			$("#sub").click(function(){
				var uvk = $("#uvk").val();
				var interfaceNumber = $("#interfaceNumbers").val();
				var uuid = $("#uuid").val();
				allParams.m = interfaceNumber;
				allParams.sid = uuid;
				allParams.uvk = uvk;
				var param = {};
				
                $(".count").each(function(){
                    var name = $(this).attr('name');
                    var value = $(this).val();
                    param[name] = value;
                 //   param += "\"" + $(this).attr('name') + "\"";
                   // param += ":";
                   // param += "\"" + $(this).val() + "\"";
                  //  param += ","; 
                });
  //              param = param.substring(0, param.length-1);
  				allParams.p = $.toJSON(param);
				//allParams += '"p":' +  $.toJSON(param) ;

				//表单赋值
				$("#m").val(allParams.m + ".1.0");
				$("#p").val(allParams.p);
				$("#sid").val(allParams.sid);
				$("#uvk1").val(allParams.uvk);

				$("form").submit(function(e){
				    alert(e);
				  });
				
			});
		});
	</script>
  </head>
  
  <body>
  	<div align="center">
  	
    	<table id="tab" >
    		<tr>
    			<td width="150px" align="right">接口版本号(M)：</td>
    			<td>
    				<select id="interfaceNumbers" name="interfaceNumbers">
    					<option value="">请选择</option>
    					<c:forEach items="${interfaceNumbers}" var="interfaceNumber" varStatus="k">
    						<option value="${interfaceNumber}" name="interfaceNumber">${interfaceNumber}</option>
    					</c:forEach>
    				</select>
    			</td>
    		</tr>
    		<tr>
    			<td align="right">SessionID(sid)：</td>
    			<td><input type="text" name="uuid" id="uuid" required="true" /></td>
    		</tr>
    		<tr>
    			<td align="right">MD5密钥(uvk)：</td>
    			<td>
    				<span id="md5"></span>
    				<input type="hidden" name="uvk" id="uvk" maxlength="1000"/>
    			</td>
    		</tr>
    		<tr>
    			<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;业务参数(p) 传入数据的格式为{key:value}</td>
    		</tr>
    	</table>
    	
<!--    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
<!--    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
		<br />
		<br />
    	<input id="countParams" type="button" value="计算uvk" />
    	
    <form  action="/weixun/server" method="post" >
  		<input type=" " name="m" id="m"  style="display:none;">
  		<input type="text" name="sid" id="sid" style="display:none;">
  		<input type="text" name="p" id="p" style="display:none;">
  		<input type="text" name="uvk" id="uvk1" style="display:none;">
		<br />
  		<input id="sub" type="submit" value="提交" >
  	</form>
    	
    	<br />
    	<br />
    
    </div>
  </body>
</html>
