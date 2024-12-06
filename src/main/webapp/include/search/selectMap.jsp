<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.stream.Stream" %>
<%@ page import="java.util.function.Function" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/include/taglib.jsp" %>
<%

	String[] selectMap = request.getParameterValues("selectMap");
	List<Map<Object, Object>> mapList = new ArrayList<>();
	List<String> mapNames = new ArrayList<>();
	List<String> mapTitle = new ArrayList<>();
	List<String> mapValues = new ArrayList<>();

	for(String s : selectMap){
		String attributeName = s.split(":")[0];
		String searchTitle = s.split(":")[1];

		mapList.add((Map<Object, Object>) request.getAttribute(attributeName));
		mapNames.add(attributeName);
		mapTitle.add(searchTitle);
		mapValues.add(request.getParameter(attributeName));
	}

	request.setAttribute("mapList", mapList);
	request.setAttribute("mapNames", mapNames);
	request.setAttribute("mapValues", mapValues);
	request.setAttribute("mapTitle", mapTitle);
%>

<c:forEach items="${mapList}" var="values" varStatus="i">
	<c:set var="idx" value="${i.index}"/>
	<select class="selectEnum" name='<c:out value="${mapNames[idx]}"/>'>
		<option value="">
			<c:catch var="e">
				<c:if test="${not empty mapTitle[idx]}"><c:out value="${mapTitle[idx]}"/></c:if>
				<c:if test="${    empty mapTitle[idx]}">검색조건</c:if>
			</c:catch>
			<c:if test="${e != null}">검색조건</c:if>
		</option>
		<c:forEach items="${values.entrySet()}" var="_entry">
			<option value='<c:out value="${_entry.key}"/>' ${_entry.key == mapValues[idx] ? 'selected="selected"' : ''}>
				<c:catch var="e"><c:out value="${_entry.value}"/></c:catch>
				<c:if test="${e != null}"><c:out value="${_entry.value}"/></c:if>
			</option>
		</c:forEach>
	</select>
</c:forEach>