<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>
<%@ page import="com.does.biz.primary.domain.common.CommonCodeType" %>
<%
	request.setAttribute("codeType", CommonCodeType.values());
	out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/contentPage.css"/>
</head>

<body>

<div id="pageTitle">공통코드 관리</div>

<ul class="pageGuide">
<%--	<li></li>--%>
</ul>

<%-- 검색 --%>
<jsp:include page="/include/search/form.jsp" flush="false">
	<jsp:param name="pageRow" value="true"/>
	<jsp:param name="searchText" value="분류코드 / 분류명"/>
	<jsp:param name="selectEnum" value="codeType:분류코드 선택"/>
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
			<th style="width:10px;"><input type="checkbox" class="checkAll"/></th>
			<th style="width:30px;">번호</th>
			<th style="width:150px;">분류코드</th>
			<th style="width:150px;">분류명</th>
			<th style="width:50px;">코드아이디</th>
			<th style="width:150px;">코드명</th>
			<th style="width:50px;">수정</th>
		</tr>
		<c:if test='${empty list}'>
			<tr>
				<td colspan="50">No Data.</td>
			</tr>
		</c:if>
		</thead>
		<tbody>
		<c:forEach items="${list}" var="vo" varStatus="status">
			<tr id="${fn:escapeXml(vo.seq)}">
				<input type="hidden" name="seq" value="${fn:escapeXml(vo.seq)}"/>
				<td><input type="checkbox" value="${fn:escapeXml(vo.seq)}"></td>
				<td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
				<td><c:out value="${vo.codeType}"/></td>
				<td><c:out value="${vo.codeTypeName}"/></td>
				<td><c:out value="${vo.codeId}"/></td>
				<td><c:out value="${vo.codeNameKo}"/></td>
				<td>
					<span class="click view whiteBtn" data-seq="${fn:escapeXml(vo.seq)}">수정</span>
				</td>
			</tr>
		</c:forEach>
		</tbody>

		<tfoot>
		<tr>
			<td colspan="50">
				<c:if test="${not isNew}">
					<a type="button" class="mot3 leftBtn lightBtn-round delBtn">삭제</a>
				</c:if>
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

<script src="${fn:escapeXml(cPath)}/assets/js/list.js" charset="utf-8" type="text/javascript"></script>
<script>
	const getCheckedVal	= () => {
		return { "seq" : $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",")}
	};

	const onSuccess = function () {
		$(this).addClass("Y N").removeClass(this.value);
		location.reload();
	}
	const onFail = function () {
		location.reload();
	}
	const onFailMsg = function (resp) {
		alert(resp.msg);
		location.reload();
	}

	$("tfoot .leftBtn", ".listBox-grid").deleteArticle("delete", getCheckedVal).then(() => {location.reload()});
	$(".view", ".listBox-grid").viewDetail("detail", document.searchForm);
	$("tbody .delete", ".listBox-grid").deleteArticle("delete").then(onFail);
</script>

</html>
