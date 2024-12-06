<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"	uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach items="${list}" var="vo">
    <tr>
        <td><c:out value="${vo.poiId}"/></td>
        <td><c:out value="${vo.name}"/></td>
		<td><c:out value="${vo.floorName}"/></td>
    </tr>
</c:forEach>
<c:if test="${empty list}">
    <tr>
		<td colspan="50" style="text-align: center;">검색 결과가 없습니다.</td>
	</tr>
</c:if>
