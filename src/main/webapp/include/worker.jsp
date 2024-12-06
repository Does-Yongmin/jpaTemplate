<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%
    /*
        관리자 공통 가이드 반영

        system 메뉴일 경우, 최초 '등록' 일시
        일반 메뉴일 경우, 최초 '게시' 일시
     */
	boolean isSystemMenu = false;

    String currentUri = request.getRequestURI();
	isSystemMenu = currentUri.contains("system");

	request.setAttribute("isSystemMenu", isSystemMenu);
%>

<!-- WORKER START -->
<c:set var="hasCreator" value="${!empty data.createDate and !empty data.creator}" scope="page"/>
<c:set var="hasUpdater" value="${!empty data.updateDate and !empty data.updater}" scope="page"/>
<c:if test="${hasCreator or hasUpdater}">
    <c:if test='${hasCreator}'>
        <tr class="workerRow">
            <th colspan="<c:out value='${colspan}'/>">최초 ${isSystemMenu ? '등록' : '게시'}일시 | 담당자</th>
            <td colspan="50"><span class="workDate">&nbsp;<c:out value='${data.createDatePretty}'/></span>&nbsp;<c:out value='${data.creatorMasked}'/></td>
        </tr>
    </c:if>
    <c:if test='${hasUpdater}'>
        <tr class="workerRow">
            <th colspan="<c:out value='${colspan}'/>">최종 수정일시 | 담당자</th>
            <td colspan="50"><span class="workDate">&nbsp;<c:out value='${data.updateDatePretty}'/></span>&nbsp;<c:out value='${data.updaterMasked}'/></td>
        </tr>
    </c:if>
</c:if>
<!-- WORKER END -->