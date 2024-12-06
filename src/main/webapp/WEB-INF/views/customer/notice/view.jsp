<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/uploadForm.jsp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
	<style>
		.lang-select a {padding: 10px 20px;border: 1px solid; cursor: pointer;}
		.lang-select a.selected {border: 2px solid #000000; font-weight: bold; box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.5);}
		.required:after {content:" *"; color: red;}
		input:read-only {background-color: #f0f0f0;}
		span.order {font-weight: bold; border-radius: 5px; display: inline-block; width: 20px}
	</style>
</head>
<body>
<div id="pageTitle">관리웹 공지사항</div>
<div class="detailBox">
	<c:if test="${canAccessMenu}">
		<div style="text-align: right;">
			<a type="button" href="/customer/notice/detail?seq=<c:out value="${data.seq}"/>" class="mot3 whiteBtn-round">수정</a>
		</div>
	</c:if>
	<table>
		<tbody>
		<tr>
			<th required id="titleTh">제목</th>
			<td id="titleField"><c:out value="${data.titleKo}" escapeXml="false"/></td>
		</tr>
		<tr>
			<th required id="contentTh">내용</th>
			<td id="contentField"></td>
		</tr>
		<tr>
			<th>첨부파일 업로드</th>
			<td>
				<c:set var="attach" value="${data.file}" scope="request"/>
				<c:if test="${not empty attach.fileId}">
					<a href="<c:out value="${AttachPathResolver.getOrgUri(attach)}"/>" data-type="<c:out value="${attach.fileType}"/>" target="blank" download="<c:out value="${attach.orgName}"/>"><c:out value="${attach.orgName}"/></a>
				</c:if>
			</td>
		</tr>
		<tr>
			<th required>게시일자</th>
			<td colspan="3"><c:out value="${data.PDatePretty}"/></td>
		</tr>
		</tbody>
		<tfoot>
		<tr>
			<td colspan="50">
				<a type="button" href="/main" class="mot3 leftBtn grayBtn-round">목록</a>
			</td>
		</tr>
		</tfoot>
	</table>
</div>

<%--######################## 스크립트 ########################--%>
<script>
	<%-- 내용 unescape 처리 --%>
	const contentField = document.getElementById('contentField');
	const content = "<c:out value="${data.decodedContentKoForJs}" escapeXml="false"/>";
	contentField.innerHTML = content;

	function decodeHTML(html) {
		const txt = document.createElement("textarea");
		txt.innerHTML = html;
		return txt.value;
	}
</script>
</body>
</html>
