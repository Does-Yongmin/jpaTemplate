<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<spring:eval expression="@environment.getProperty('spring.profiles.active')" var="ap"/>
<c:set var="isProd" value="${empty ap}"/>
<c:set var="isProd" value="${isProd or fn:contains(ap,'prod')}"/>
<c:set var="isProd" value="${isProd or fn:contains(ap,'prd')}"/>
<c:set var="isProd" value="${isProd or fn:contains(ap,'live')}"/>
<c:if test="${not isProd}">
	<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/profileNotice.css"/>
	<div id="profileNotice" class="mot3">
		<c:forEach begin="1" end="1" var="i">
			<span>'<c:out value="${ap}"/>' profile 환경입니다.</span>
		</c:forEach>
	</div>
</c:if>