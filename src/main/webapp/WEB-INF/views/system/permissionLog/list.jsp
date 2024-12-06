<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<%@ include file="/include/head.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
	</head>
	<body>
		<div id="pageTitle"><c:out value="${pageTitle}"/></div>	<%-- pageTitle은 Aspect 로 삽입 --%>
		<ul class="pageGuide">
			<li>3년 이상된 접근권한변경로그는 자동으로 삭제됩니다.</li>
		</ul>
		<jsp:include page="/include/search/form.jsp" flush="false">
			<jsp:param name="pageRow"		value="true"/>
			<jsp:param name="searchText"	value="권한변경 계정, 권한부여자 계정, 수정 전후 권한"/>
			<jsp:param name="searchPeriod"	value="true"/>
		</jsp:include>
		<div class="listBox-grid">
			<table>
				<thead>
					<tr>
						<td colspan="50">
							<div class="listTotal">전체 <span class="bold gray"><c:out value="${search.totalCount}"/></span> 건</div>
						</td>
					</tr>
					<tr>
						<th style="width:80px;">번호</th>
						<th style="width:160px;">권한변경 계정</th>
						<th>수정 전 권한</th>
						<th>수정 후 권한</th>
						<th style="width:160px;">권한부여자 계정</th>
						<th style="width:160px;">권한부여자 IP</th>
						<th style="width:160px;">작업일</th>
					</tr>
					<c:if test='${empty list}'>
						<tr><td colspan="50">No Data.</td></tr>
					</c:if>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="vo" varStatus="status">
						<tr>
							<td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
							<td><c:out value="${vo.targetId}"/></td>
							<td><c:out value="${vo.permBefore}"/></td>
							<td><c:out value="${vo.permAfter}"/></td>
							<td><c:out value="${vo.creatorId}"/></td>
							<td><c:out value="${vo.creatorIp}"/></td>
							<td><c:out value="${vo.createDatePretty}"/></td>
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
	<script	src="<c:out value="${cPath}"/>/assets/js/list.js"	charset="utf-8"		type="text/javascript"></script>
</html>