<%@ page import="com.does.component.EnvChecker" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="taglib.jsp" %>
<c:set var="cPath" value="${pageContext.request.contextPath}" scope="application"/>

<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="shortcut icon" type="image/x-icon"	href="<c:out value="${cPath}"/>/assets/images/favicon.ico"/>

<link rel="stylesheet"	type="text/css"			href="<c:out value="${cPath}"/>/assets/css/default.css"/>
<link rel="stylesheet"	type="text/css"			href="<c:out value="${cPath}"/>/assets/vendor/datepicker/jquery-ui.datepicker.1.13.1.min.css"/>			<%-- Date picker --%>
<link rel="stylesheet"	type="text/css"			href="<c:out value="${cPath}"/>/assets/vendor/monthpicker/MonthPicker.min.css"/>							<%-- Month picker --%>
<link rel="stylesheet"	type="text/css"			href="<c:out value="${cPath}"/>/assets/vendor/colorpicker/jquery.minicolors.css"/>						<%-- Color picker --%>
<link rel="stylesheet"	type="text/css"			href="<c:out value="${cPath}"/>/assets/vendor/timepicker/jquery.timepicker.min.css"/>                	<%-- Time picker --%>

<script	charset="utf-8"	type="text/javascript" 	src="<c:out value="${cPath}"/>/assets/vendor/jquery.min.3.3.1.doesMod.js"></script>
<script charset="utf-8"	type="text/javascript" 	src="<c:out value="${cPath}"/>/assets/vendor/datepicker/jquery-ui.datepicker.1.13.1.min.js"></script>	<%-- Date picker --%>
<script charset="utf-8"	type="text/javascript" 	src="<c:out value="${cPath}"/>/assets/vendor/monthpicker/jquery.MonthPicker.alMod.min.js"></script>		<%-- Month picker --%>
<script charset="utf-8"	type="text/javascript" 	src="<c:out value="${cPath}"/>/assets/vendor/colorpicker/jquery.minicolors.min.js"></script>				<%-- Color picker --%>
<script charset="utf-8"	type="text/javascript" 	src="<c:out value="${cPath}"/>/assets/vendor/timepicker/jquery.timepicker.min.js"></script>          	<%-- Time picker --%>

<script charset="utf-8"	type="text/javascript" 	src="<c:out value="${cPath}"/>/assets/js/common/common.js"></script>
<script charset="utf-8"	type="text/javascript" 	src="<c:out value="${cPath}"/>/assets/js/common/loading.js"></script>


<%-- 전화번호, 이메일 인증번호 does local 환경에서 자동채우기 위해 분기 --%>
<%
    boolean isDoesLocal = EnvChecker.isDoesLocal();
    application.setAttribute("isDoesLocal", isDoesLocal);
%>
<script>
    const isDoesLocal = '<c:out value="${isDoesLocal}"/>'; // does, local 환경 분기 처리용
    const cPath = '<c:out value="${cPath}"/>';           // js 파일 분리시. cPath 를 자바스크립트 변수로 불러와서 백틱 처리하기 위함
</script>