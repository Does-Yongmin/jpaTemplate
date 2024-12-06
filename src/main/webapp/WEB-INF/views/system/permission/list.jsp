<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>
<%
	request.setAttribute("useYn", Use.values());
	out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
</head>
<body>
<div id="pageTitle"><c:out value="${pageTitle}"/></div>
<%-- pageTitle은 Aspect 로 삽입 --%>
<ul class="pageGuide">
	<li>'사용상태전환' 버튼 클릭 시 해당 상태로 전환됩니다.</li>
</ul>
<jsp:include page="/include/search/form.jsp" flush="false">
	<jsp:param name="pageRow" value="true"/>
	<jsp:param name="searchText" value="권한그룹명"/>
	<jsp:param name="selectEnum" value="useYn:사용상태"/>
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
			<th style="width: 80px;">번호</th>
			<th>그룹명</th>
			<th style="width:100px;">권한개수</th>
			<th style="width: 70px;">사용상태전환</th>
			<th style="width:180px;">생성일</th>
			<th style="width: 80px;">수정</th>
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
				<td><input type="checkbox" value="<c:out value="${vo.seq}"/>"></td>
				<td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
				<td><c:out value="${vo.groupName}"/></td>
				<td><c:out value="${fn:length(vo.permissions)}"/></td>
				<td>
					<c:if test="${    vo.use}">
						<button type="button" data-seq="<c:out value="${vo.seq}"/>" data-use-yn="N" class="mot3 use changeBtn greenBtn">
							사용
						</button>
					</c:if>
					<c:if test="${not vo.use}">
						<button type="button" data-seq="<c:out value="${vo.seq}"/>" data-use-yn="Y" class="mot3 use changeBtn redBtn">
							미사용
						</button>
					</c:if>
				</td>
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
				<a href="javascript:;" class="mot3 leftBtn lightBtn">삭제</a>
				<a href="javascript:;" class="mot3 rightBtn grayBtn view">등록</a>
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
<script src="<c:out value="${cPath}"/>/assets/js/list.js" charset="utf-8" type="text/javascript"></script>
<script>
	const getCheckedVal = () => {
		return {"seq": $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",")}
	};
	const onSuccess = function (resp) {
		location.reload();
	}
	const onDeleteFail = function (resp){}
	const onFail = function (resp) {
		if(resp.msg){
			alert(resp.msg);
		}
	}

	$("tfoot .leftBtn", ".listBox-grid").deleteArticle("delete", getCheckedVal).then(onSuccess, onDeleteFail);
	$("tbody button.use", ".listBox-grid").clickChangeStatus("changeUse").then(onSuccess, onFail);
	$(".view", ".listBox-grid").viewDetail("detail", document.searchForm);
</script>
</html>