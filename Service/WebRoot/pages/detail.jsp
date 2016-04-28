<%@page import="com.laf.common.constants.DefaultCode"%>
<%@page language="java" import="com.laf.entity.*"%>
<%@page language="java" import="com.laf.returnEntity.*"%>
<%@page language="java" import="com.laf.service.common.*"%>
<%@page language="java" import="com.laf.util.*"%>
<%@page language="java"
	import="org.springframework.context.ApplicationContext"%>
<%@page language="java"
	import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%!private NoticeService noticeService;
	private String imageServerUrl = ResourceBundle.getBundle("application").getString("remote.imageUrl");

	public void jspInit() {
		ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
		noticeService = (NoticeService) applicationContext.getBean("noticeService");
	}%>

<%
	String strId = request.getParameter("id");
	CompleteNoticeResult completeNoticeResult = null;
	Integer id = null;
		
	if (strId != null) {
		id = Integer.parseInt(strId);
	}
	if (id != null) {

		completeNoticeResult = noticeService.completeNoticeDetailById(id);
	}
%>

<html>
<head>
<title>详情</title>
<meta charset="utf-8" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta property="og:type" content="webpage">
<meta property="og:url" content="http://idev.iwoce.com/laf">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="详情">
<meta name="apple-mobile-web-app-status-bar-style"
	content="black-translucent">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1.0, minimum-scale=1.0" />


<link rel="stylesheet" type="text/css" href="css/style.css"
	media="screen" />

<script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="../js/jquery.slides.js"></script>
<script type="text/javascript" src="../js/jquery.slides.min.js"></script>
<script type="text/javascript"
	src="../js/jquery.banner.revolution.min.js"></script>
<script type="text/javascript" src="../js/banner.js"></script>
<script type="text/javascript" src="../js/app-download.js"></script>
<style type="text/css">
.black_overlay {
	display: none;
	position: absolute;
	top: 0%;
	left: 0%;
	width: 100%;
	height: 100%;
	background-color: black;
	z-index: 1001;
	-moz-opacity: 0.8;
	opacity: .80;
	filter: alpha(opacity = 80);
}
</style>
</head>

<body>
	<div class="black_overlay" onclick="closeGuide();">
		<div
			style="text-align: right; cursor: default; padding-right: 15px; padding-top: 15px;">
			<img src="../images/guide.png" width="80%" />
		</div>
	</div>
	<div>
		<div id="wrapper">
			<div class="fullwidthbanner-container">
				<div class="fullwidthbanner">
					<ul>
						<%
							String[] transitions = {"3dcurtain-horizontal", "3dcurtain-vertical", "papercut", "turnoff", "flyin"};
																							
										for (Image image : completeNoticeResult.getImages()){
											
											String imageUrl = imageServerUrl + "?id=" + image.getRemoteId() + "&scale=!1200x700r&crop=1200x700";
											String transition = transitions[(int)(Math.random() * 5)];
						%>
						<li data-transition=<%=transition%> data-slotamount='15'
							data-masterspeed='300'><img src=<%=imageUrl%> alt="" /></li>
						<%
							}
						%>
					</ul>
				</div>
			</div>
		</div>
		<div>
			<br>
			<%
				Location location = completeNoticeResult.getLocation();
				User user = completeNoticeResult.getUser();
			%>
			<div>
				<p style="text-indent: 2em">
					<font class="titleFont"><%=completeNoticeResult.getTitle()%><br>
					<br>
					</font>
				</p>
			</div>
			<HR class="seperator">
			<br>
			<div>
				<div style="float:left;padding-left:10px">
					<img class="radiusImage" src=<%=user.getHeadImageUrl()%>>
				</div>
				<div style="float:left;margin-top:8px">
					<font class="titleFont">&nbsp;&nbsp;&nbsp;&nbsp;<%=user.getNickname()%></font>
				</div>

				<div style="float:right;margin-top:8px">
					<font class="explanatoryNote" style=""><%=DateTimeUtil.format(completeNoticeResult.getTime())%>&nbsp;&nbsp;<br>
					</font>
				</div>
			</div>
			<br> <br>
			<HR class="seperator">
			<div>
				<br> <font class="locationTitleFont">主要地点：</font> <font
					class="locationAddressFont"><%="【" + location.getName() + "】" + location.getAddress()%><br>
				<br>
				</font>

				<%
					List<Location> locations = completeNoticeResult.getLocations();
						if (locations!= null && locations.size() != DefaultCode.Code_Zero){
				%>
				<font class="locationTitleFont">可能地点：</font>
				<%
					if (locations.size() > DefaultCode.Code_One){
				%>
				<font class="locationTitleFont">(<%=locations.size()%>个)<br>
				<br>
				</font>
				<%
					}
							for (Location possibleLocation : locations) {
				%>
				<font class="locationAddressFont"><%="【" + possibleLocation.getName() + "】" + possibleLocation.getAddress()%><br>
				</font>
				<%
					}
						}
				%>
			</div>
			<div
				style="margin:0 auto;width:150px;padding-top:7px;padding-bottom:7px;border:#cccccc;background:#eeeeee;border-radius:9px;-webkit-border-radius:9px;-moz-border-radius:9px;margin-top:60px;text-align:center;">
				<a href="javascript:downloadApplication();" id="down_load"
					target="_blank"> <font style="font-size:16px">点击安装 APP</font>
				</a>
			</div>
			<div style=" margin-top:20px;text-align:center;">
				<div class="span12" style="text-align:center;">
					<font style="font-size:16px">或者用手机扫描下面的二维码安装</font><br /> <br />
					<img src="../images/appdownload/qrcode_appstore.png" />
				</div>
			</div>
		</div>
	</div>
</body>
</html>