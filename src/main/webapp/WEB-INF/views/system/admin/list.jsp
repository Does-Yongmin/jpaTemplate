<%@ page import="com.does.biz.primary.domain.admin.AdminStatus" %>
<%@ page import="com.does.biz.primary.domain.affiliate.AffiliateType" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<%@ include file="/include/head.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
	</head>
	<body>
		<div id="pageTitle"><c:out value="${pageTitle}"/></div>	<%-- pageTitle은 Aspect 로 삽입 --%>
		<ul class="pageGuide">
			<li>관리자 계정을 관리할 수 있습니다.</li>
			<li>본인의 계정 상태는 변경할 수 없습니다.</li>
		</ul>
		<jsp:include page="/include/search/form.jsp" flush="false">
			<jsp:param name="pageRow"			value="true"/>
			<jsp:param name="selectEnum" 		value="affiliateType:회사명"/>
			<jsp:param name="selectEnum" 		value="adminStatus:계정상태"/>
			<jsp:param name="selectMap"			value="permissionGroups:권한"/>
			<jsp:param name="searchText"		value="이메일 또는 아이디, 성함을 입력해주세요."/>
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
						<th style="width: 40px;"><input type="checkbox" class="checkAll"/></th>
						<th style="width: 50px;">번호</th>
						<th>이메일</th>
						<th style="width:150px;">이름</th>
						<th>회사명</th>
						<th>계정상태</th>
						<th style="width:150px;">최초 가입일</th>
						<th style="width: 80px;">수정</th>
					</tr>
					<c:if test='${empty list}'>
						<tr><td colspan="50">No Data.</td></tr>
					</c:if>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="vo" varStatus="status">
						<tr>
							<td>
								<%-- 계정이 탈퇴, 개인정보 삭제가 아닌 경우만 체크박스 노출 --%>
								<c:if test="${!vo.deactivated}">
									<input type="checkbox" value="<c:out value="${vo.seq}"/>">
								</c:if>
							</td>
							<td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
							<td><c:out value="${vo.emailMasked}"/></td>
							<td><c:out value="${vo.nameMasked}"/></td>
							<td><c:out value="${vo.affiliateType.nameKo}"/></td>
							<td><c:out value="${vo.adminStatus.name}"/></td>
							<td><c:out value="${vo.createDatePretty}"/></td>
							<td>
								<span class="click view whiteBtn" data-page-num="<c:out value="${search.pageNum}"/>" data-seq="<c:out value="${vo.seq}"/>">수정</span>
							</td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="50">
							<a href="javascript:;" class="mot3 leftBtn lightBtn">탈퇴</a>
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
	<script	src="<c:out value="${cPath}"/>/assets/js/list.js"	charset="utf-8"		type="text/javascript"></script>
	<script>
		const getCheckedVal	= () => { return { "seq" : $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",")} };
		const onSuccess		= function(resp) { $(this).addClass("Y N").removeClass(this.value); }
		const onFail		= function(resp) { alert(resp.msg); }

		$("tbody select.use"	, ".listBox-grid").changeStatus("changeUse", "useYn").then(onSuccess, onFail);
		$("tbody select.idle"	, ".listBox-grid").changeStatus("changeIdle", "idleYn").then(onSuccess, onFail);
		$("tbody select.temp"	, ".listBox-grid").changeStatus("changeTemp", "tempYn").then(onSuccess, onFail);
		$(".view"				, ".listBox-grid").viewDetail("detail", document.searchForm);

		// 계정 탈퇴
		$("tfoot .leftBtn"		, ".listBox-grid").deleteArticle("withdraw", getCheckedVal).then(() => {location.reload()});
	</script>
</html>
