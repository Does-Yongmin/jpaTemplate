<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<%@ include file="/include/head.jsp" %>
		<link	href="<c:out value="${cPath}"/>/assets/css/sitemap.css"		rel="stylesheet"	type="text/css"/>
		<script	src="<c:out value="${cPath}"/>/assets/js/common/menu.js"		charset="utf-8"		type="text/javascript"></script>
		<script	src="<c:out value="${cPath}"/>/assets/js/sitemap.js"			charset="utf-8"		type="text/javascript"></script>
	</head>
	<body>
		<div id="sitemap"></div>
	</body>
</html>