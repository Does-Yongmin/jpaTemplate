<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/taglib.jsp" %>
<%@ page import="com.does.biz.primary.domain.log.LogType" %>
<%
	LogType[]  types = LogType.values();
	request.setAttribute("types", types);
%>

<select name="logType">
	<option value="">작업종류</option>
	<option disabled>--------------</option>
	<c:forEach items="${types}" var="type" varStatus="stat">
		<option value="<c:out value="${type}"/>" ${search.logType == type ? 'selected="selected"' : ''}><c:out value="${type.name}"/></option>
		<c:if test="${type.end}"><option disabled>--------------</option></c:if>
	</c:forEach>
</select>