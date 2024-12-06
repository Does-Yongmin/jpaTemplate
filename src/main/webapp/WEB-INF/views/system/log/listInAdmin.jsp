<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
	<style>
		<%-- 다른 페이지의 iframe 으로 들어갈때 body padding 없애야 사이즈 맞음 --%>
		body{
			padding: 50px 0px 0px 0px;
		}
	</style>
</head>
<div class="listBox-grid">
	<table>
		<thead>
		<tr>
			<td colspan="50">
				<div style="position:absolute; left:0; bottom:5px; color:black; font-weight:bold; padding:0 0 10px; font-size:24px">관리자 활동</div>
				<div class="listTotal">전체 <span class="bold gray"><c:out value="${search.totalCount}"/></span> 건</div>
			</td>
		</tr>
		<tr>
			<th>활동내역</th>
			<th>작업자</th>
			<th>작업 대상</th>
			<th>일시</th>
		</tr>
		<c:if test='${empty list}'>
			<tr><td colspan="50">No Data.</td></tr>
		</c:if>
		</thead>
		<tbody>
		<c:forEach items="${list}" var="log" varStatus="status">
			<tr>
				<td><c:out value="${log.logType.name}"/></td>
				<td><c:out value="${log.creatorNameId}"/></td>
				<td><c:out value="${log.targetNameId}"/></td>
				<td><c:out value="${log.createDatePretty}"/></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<%--######################## 관리자 활동 로그 페이징 ########################--%>
	<c:if test="${search.totalPage > 1}">
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/paging.css" />			<%-- 페이지 특화 스타일 --%>
		<div id="paging" align="center">
			<table>
				<tr>
					<c:if test="${search.pageStartNum > 1}"><td class="firstLast first page" data-page-num="1" title="First page"></td></c:if>
					<td class="prevNext prev page" data-page-num="<c:out value="${search.prevPageGroup}"/>" title="Previous page group"></td>
					<c:forEach var="i" begin="${search.pageStartNum}" end="${search.pageEndNum}" step="1">
						<td class="page${search.pageNum eq i ? ' now' : ''}" data-page-num="<c:out value="${i}"/>"><c:out value="${i}"/></td>
					</c:forEach>
					<td class="prevNext next page" data-page-num="<c:out value="${search.nextPageGroup}"/>" title="Next page group"></td>
					<c:if test="${search.pageEndNum < search.totalPage}"><td class="firstLast last page" data-page-num="<c:out value="${search.totalPage}"/>" title="Last page"></td></c:if>
				</tr>
			</table>
		</div>
		<script>
			window.addEventListener("click", (e) => {
				const $target	= $(e.target);
				const isPaging	= $target.hasClass("page") && $target.parents("#paging").length > 0
				if( isPaging ) {
					// 현재 iframe 을 호출하는 admin detail 에서 추가한 쿼리 파라미터 searchText 추출 (adminId 값)
					const params = new URLSearchParams(location.search);
					const adminId = params.get('searchText');

					// 다음 쿼리 파라미터에도 어드민 아이디가 포함되도록 함
					const json	= $target.data();
					if(adminId){
						json.searchText = adminId;
					}

					const query	= Object.entries(json).filter(e => e[1]).map(e => e.map(s => encodeURIComponent(s)).join("=")).join("&");
					location.href = location.href.replace(/(\?.*|#.*)/gi, "") + "?" + query;
				}
			});
		</script>
	</c:if>
</div>