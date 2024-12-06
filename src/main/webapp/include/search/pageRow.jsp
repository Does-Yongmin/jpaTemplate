<%@ page import="com.does.util.StrUtil" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/taglib.jsp" %>
<%--<select name="pageRow" onchange="this.closest('form').submit()">--%>
<%
	/**
	 * 한 페이지에 검색이 여러개일 경우, 각각 페이징하기 위해
	 * 파라미터로 searchVO 이름을 전달 받아 searchVO 를 치환한다.
	 *
	 * 별도로 파라미터 미전달시 기존과 동일하게 동작
	 *
	 * param name 	: searchVOName
	 * param value 	: {model 에 주입한 searchVO attribute 명} (ex:noticeSearch)
	 */
	String searchVOName = request.getParameter("searchVOName");
	if(!StrUtil.isEmpty(searchVOName)){
		Object searchVO = request.getAttribute(searchVOName);	// searchVOName 으로 model 에 주입한 searchVO 가져오기
		if(searchVO != null){
			request.setAttribute("search", searchVO);			// 해당 searchVO 로 search 를 치환
		}
	}
%>

<select name="pageRow">
	<%--5 추가시 해당 페이지에서 param 전송--%>
	<c:if test="${param.addFive == 'true'}">
		<option value="5" ${search.pageRow == '5' ? 'selected="selected"' : ''}>5</option>
	</c:if>
	<c:forEach items="${fn:split('10,20,50,100', ',')}" var="i">
		<option value="<c:out value="${i}"/>" ${i == search.pageRow ? 'selected="selected"' : ''}><c:out value="${i}"/></option>
	</c:forEach>
</select>