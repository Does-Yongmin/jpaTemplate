<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"	uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach items="${list}" var="vo">
    <tr>
        <td>
            <c:if test="${not empty largeCodeTypeList and not empty vo.codeTypeArraysInnerCategoryArrays[0][0]}">
                <c:forEach items="${largeCodeTypeList}" var="large">
                    <c:if test="${large.codeType.startsWith(vo.codeTypeArraysInnerCategoryArrays[0][0])}">
                        ${fn:escapeXml(large.codeTypeNameKo)}
                    </c:if>
                </c:forEach>
            </c:if>
        </td>
        <td>
            <c:if test="${not empty middleCodeTypeList and not empty vo.codeTypeArraysInnerCategoryArrays[0][1]}">
                <c:forEach items="${middleCodeTypeList}" var="middle">
                    <c:if test="${middle.codeType.startsWith(vo.codeTypeArraysInnerCategoryArrays[0][0])
								and middle.codeType.substring(4).startsWith(vo.codeTypeArraysInnerCategoryArrays[0][1])}">
                        ${fn:escapeXml(middle.codeTypeNameKo)}
                    </c:if>
                </c:forEach>
            </c:if>
        </td>
        <td>
            <c:if test="${not empty smallCodeTypeList and not empty vo.codeTypeArraysInnerCategoryArrays[0][2]}">
                <c:forEach items="${smallCodeTypeList}" var="small">
                    <c:if test="${small.codeType.startsWith(vo.codeTypeArraysInnerCategoryArrays[0][0])
									and small.codeType.substring(4).startsWith(vo.codeTypeArraysInnerCategoryArrays[0][1])
									and small.codeType.substring(8).startsWith(vo.codeTypeArraysInnerCategoryArrays[0][2])}">
                        ${fn:escapeXml(small.codeTypeNameKo)}
                    </c:if>
                </c:forEach>
            </c:if>
        </td>
        <td data-seq="${fn:escapeXml(vo.facilityLangInfoKo.seq)}"><c:out value="${vo.facilityLangInfoKo.name}"/></td>
		<td><c:out value="${vo.buildingTypeString}"/></td>
		<td>
			<c:forEach var="floor" items="${vo.affiliateFloorArrays}" varStatus="status">
				${fn:escapeXml(floor)}<c:if test="${!status.last}">, </c:if>
			</c:forEach>
		</td>
    </tr>
</c:forEach>
<c:if test="${empty list}">
    <tr>
		<td colspan="50" style="text-align: center;">검색 결과가 없습니다.</td>
	</tr>
</c:if>