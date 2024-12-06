<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/taglib.jsp" %>

<c:set var="hasDate"	value="${not empty param.dateName}"/>
<c:set var="hasHour"	value="${not empty param.hourName}"/>
<c:set var="hasMin"		value="${not empty param.minName}"/>
<c:if test="${hasDate}">
	<input type="text" class="date" name="${fn:escapeXml(param.dateName)}"	value="${fn:escapeXml(param.dateValue)}" autocomplete="off">
</c:if>
<c:if test="${hasHour}">
<%--	<c:if test="${hasDate}">&nbsp;</c:if>--%>
	<select name="${fn:escapeXml(param.hourName)}">
		<c:forEach begin="0" end="23" step="1" var="i">
			<option value="${fn:escapeXml(i)}" ${i == param.hourValue ? 'selected="selected"' : ''}><c:out value="${i < 10 ? '0':''}${fn:escapeXml(i)}시"/></option>
		</c:forEach>
	</select>
</c:if>
<c:if test="${hasMin}">
<%--	<c:if test="${hasHour}">&nbsp;:&nbsp;</c:if>--%>
	<select name="${fn:escapeXml(param.minName)}">
		<c:forEach begin="0" end="55" step="5" var="i">
			<option value="${fn:escapeXml(i)}" ${i == param.minValue ? 'selected="selected"' : ''}><c:out value="${i < 10 ? '0':''}${fn:escapeXml(i)}분"/></option>
		</c:forEach>
	</select>
</c:if>