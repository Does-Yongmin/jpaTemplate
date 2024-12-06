<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.stream.Stream" %>
<%@ page import="java.util.function.Function" %>
<%@ include file="/include/taglib.jsp" %>
<%--
	form.jsp 에 'selectEnum' 으로 넘어온 파라미터 중 ':' 로 구분되어 들어오는 값은
	request.setAttribute 의 키값과 enum 의 타이틀이 아래 형태로 조합되어있는 값이다.

	[키값]:[enum을 select로 표현할때의 타이틀]

	예를 들어, selectEnum 이 'memberEnum:회원타입' 이라고 되어있는 경우
	request.getAttribute("memberEnum") 에는 enum.values() 의 결과배열을 얻고,
	그 결과로 표시될 select 태그는 아래와 같이 보이게 된다
	<select name="memberEnum">
		<option value="">회원타입</option>
		<c:forEach items="${values 배열}" var="v">
			<option value="${v}">v.name</option>
		</c:forEach>
	</select>
--%>
<%!
	// 리스트의 stream 에 mapper 를 적용한 결과를 List 로 반환.
	private <T> List<T> _getListFromList(List<String> list, Function<String,T> mapper) {
		return	list.stream()
					.map(mapper)
					.collect(Collectors.toList());
	}
%>
<%
	String[]		selectEnum	= request.getParameterValues("selectEnum");										// form.jsp 로 넘어온 selectEnum 값들
	List<String>	allEnum		= Arrays.asList(selectEnum).stream().collect(Collectors.toList());				// stream 사용을 위해 List로 변환.

	Function<String,String>		func_getEnumName	= s -> s.split(":")[0];										// ':' 구분자 앞에 있는, enum 의 이름을 반환할 function.
	Function<String,Object[]>	func_getEnumValues	= s -> (Object[])request.getAttribute(s);					// enum.values() 를 받아올 function.
	Function<String,String>		func_getEnumTitle	= s -> s.contains(":") ? s.split(":")[1] : null;			// ':' 구분자 뒤에 있는, select 의 타이틀을 반환할 function.

	List<String>	names		= _getListFromList(allEnum	, func_getEnumName);								// enum 들의 이름 목록
	String[]		enumNames	= names.toArray(new String[0]);													// enum 들의 이름목록을 배열로 전환.

	List<Object[]>	enumList	= _getListFromList(names	, func_getEnumValues);								// enum.values() 목록
	String[]		enumTitle	= _getListFromList(allEnum	, func_getEnumTitle).toArray(new String[0]);		// <select> 의 타이틀 목록
	String[]		enumValues	= _getListFromList(names	, request::getParameter).toArray(new String[0]);	// form submit 으로 검색한 조건(select 에서 선택한 값).

	request.setAttribute("enumList"		, enumList);
	request.setAttribute("enumNames"	, enumNames);
	request.setAttribute("enumValues"	, enumValues);
	request.setAttribute("enumTitle"	, enumTitle);
%>

<c:forEach items="${enumList}" var="values" varStatus="i">
	<c:set var="idx" value="${i.index}"/>
	<select class="selectEnum" name="<c:out value="${enumNames[idx]}"/>">
		<option value="">
			<c:catch var="e">
				<c:if test="${not empty enumTitle[idx]}"><c:out value="${enumTitle[idx]}"/></c:if>
				<c:if test="${    empty enumTitle[idx]}">검색조건</c:if>
			</c:catch>
			<c:if test="${e != null}">검색조건</c:if>
		</option>
		<c:forEach items="${values}" var="_enum">
			<option value="<c:out value="${_enum}"/>" ${_enum == enumValues[idx] ? 'selected="selected"' : ''}>
				<c:catch var="e"><c:out value="${_enum.name}"/></c:catch>
				<c:if test="${e != null}"><c:out value="${_enum.name()}"/></c:if>
			</option>
		</c:forEach>
	</select>
</c:forEach>