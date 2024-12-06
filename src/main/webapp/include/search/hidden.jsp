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
	String[]		hiddenInput = request.getParameterValues("hiddenInput");									// form.jsp 로 넘어온 selectEnum 값들
	List<String>	allInput	= Arrays.asList(hiddenInput).stream().collect(Collectors.toList());				// stream 사용을 위해 List로 변환.

	Function<String,String>		func_getName	= s -> s.split(":")[0];										// ':' 구분자 앞에 있는, enum 의 이름을 반환할 function.
	Function<String,String>		func_getValue	= s -> s.contains(":") && !s.endsWith(":") ? s.split(":")[1] : null;			// ':' 구분자 뒤에 있는, select 의 타이틀을 반환할 function.

	String[]	names		= _getListFromList(allInput, func_getName).toArray(new String[0]);				// enum 들의 이름 목록
	String[]	values		= _getListFromList(allInput	, func_getValue).toArray(new String[0]);	// form submit 으로 검색한 조건(select 에서 선택한 값).

	request.setAttribute("names"	, names);
	request.setAttribute("values"	, values);
%>

<c:forEach items="${names}" var="name" varStatus="i">
	<input type="hidden" name="<c:out value="${name}"/>" value="<c:out value="${values[i.index]}"/>">
</c:forEach>