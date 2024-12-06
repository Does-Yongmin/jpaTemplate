<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"	uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 페이지네이션 -->
<c:if test="${search.totalPage >= 1}">
    <link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/paging.css" />
    <div id="paging" align="center">
        <table>
            <tr>
                <%-- prev arrow --%>
                <c:if test="${search.pageStartNum > 1}">
                    <td class="firstLast first page" data-page-num="1" title="First page"></td>
                </c:if>
                <td class="prevNext prev page" data-page-num="${fn:escapeXml(search.prevPageGroup)}" title="Previous page group"></td>

                <%-- page number --%>
                <c:forEach var="i" begin="${search.pageStartNum}" end="${search.pageEndNum}" step="1">
                    <td class="page${search.pageNum eq i ? ' now' : ''}" data-page-num="${fn:escapeXml(i)}"><c:out value="${i}"/></td>
                </c:forEach>

                <%-- next arrow --%>
                <td class="prevNext next page" data-page-num="${fn:escapeXml(search.nextPageGroup)}" title="Next page group"></td>
                <c:if test="${search.pageEndNum < search.totalPage}">
                    <td class="firstLast last page" data-page-num="${fn:escapeXml(search.totalPage)}" title="Last page"></td>
                </c:if>
            </tr>
        </table>
    </div>
</c:if>