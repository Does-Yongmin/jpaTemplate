<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<%@ include file="/include/head.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
	</head>
	<body>
		<div id="pageTitle">승인 상태 관리자 조회</div>	<%-- pageTitle은 Aspect 로 삽입 --%>
		<jsp:include page="/include/search/form.jsp" flush="false">
			<jsp:param name="pageRow"		value="true"/>
			<jsp:param name="searchText"	value="아이디"/>
		</jsp:include>
		<div class="listBox">
			<table>
				<thead>
					<tr>
						<td colspan="50">
							<div class="listTotal">전체 <span class="bold gray"><c:out value="${search.totalCount}"/></span> 건</div>
						</td>
					</tr>
					<tr>
						<th style="width: 40px;"><input type="checkbox" class="checkAll"/></th>
						<th style="width: 50px;">번호</th>
						<th style="width:150px;">이름</th>
						<th>아이디</th>
						<th>이메일</th>
						<th style="width:100px;">계정 상태</th>
					</tr>
					<c:if test='${empty list}'>
						<tr><td colspan="50">No Data.</td></tr>
					</c:if>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="vo" varStatus="status">
						<tr>
							<td><input type="checkbox" data-seq="<c:out value="${vo.seq}"/>" data-name="<c:out value="${vo.decName}"/>" data-id="<c:out value="${vo.adminId}"/>"></td>
							<td><c:out value="${search.idx - status.index}"/></td>
							<td><c:out value="${vo.decName}"/></td>
							<td><c:out value="${vo.adminId}"/></td>
							<td><c:out value="${vo.decEmail}"/></td>
							<td class="${vo.use ? 'Y': 'N'}"><c:out value="${vo.adminStatus.name}"/></td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="50">
							<a href="javascript:passInfo();" class="mot3 rightBtn blueBtn-round">선택</a>
							<a type="button" href="javascript:goBackToList(undefined, 'seq')" class="mot3 rightBtn grayBtn-round">목록</a>
						</td>
					</tr>
				</tfoot>
			</table>
			<%--######################## 페이징 ########################--%>
			<jsp:include page="/include/paging.jsp">
				<jsp:param name="formName" value="searchForm"/>
			</jsp:include>
		</div>
	</body>
.	<script	src="<c:out value="${cPath}"/>/assets/js/list.js"	charset="utf-8"		type="text/javascript"></script>
	<script>
		function passInfo() {
			const data = $("tbody input[type=checkbox]:checked").toArray().map((e, i) => $(e).data());
			parent.takeInfo(data);
			parent.closePopup();
		}
	</script>
</html>