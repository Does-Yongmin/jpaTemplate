<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
    <%@ include file="/include/head.jsp" %>
    <link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
</head>

<body>

<div id="pageTitle"><c:out value="${pageTitle}"/></div>

<%-- 검색 --%>
<jsp:include page="/include/search/form.jsp" flush="false">
    <jsp:param name="pageRow"      value="true"/>
    <jsp:param name="searchPeriod" value="true"/>
</jsp:include>

<%--구분--%>
<%@ include file="/WEB-INF/views/system/personalInfoLog/tab.jsp" %>

<div class="listBox-grid">
    <table>
        <thead>
        <tr>
            <td colspan="50">
                <div class="listTotal">전체 <span class="bold gray"><c:out value="${search.totalCount}"/></span> 건</div>
            </td>
        </tr>
        <tr>
            <th style="width:30px;">이메일</th>
            <th style="width:150px;">이름</th>
            <th style="width: 150px;">권한</th>
            <th style="width: 150px;">권한 부여일</th>
            <th style="width:100px;">마지막 로그인</th>
        </tr>
        <c:if test='${empty list}'>
            <tr>
                <td colspan="50">No Data.</td>
            </tr>
        </c:if>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="vo" varStatus="status">
            <tr>
                <td><c:out value="${vo.email}"/></td>
                <td><c:out value="${vo.adminName}"/></td>
                <td><c:out value="${vo.groupName}"/></td>
                <td><c:out value="${vo.authorizationDatePretty}"/></td>
                <td><c:out value="${vo.lastLoginDatePretty}"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <%--######################## 페이징 ########################--%>
    <jsp:include page="/include/paging.jsp">
        <jsp:param name="formName" value="searchForm"/>
    </jsp:include>
</div>
</body>

<script src="<c:out value="${cPath}"/>/assets/js/list.js" charset="utf-8" type="text/javascript"></script>
</html>
