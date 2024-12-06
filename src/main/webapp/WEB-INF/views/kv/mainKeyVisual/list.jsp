<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.does.biz.primary.domain.kv.MainKeyVisualType" %>
<%
	request.setAttribute("kvType", MainKeyVisualType.values());
	request.setAttribute("kvTypeNormal", MainKeyVisualType.NORMAL);
	request.setAttribute("kvTypeEvent", MainKeyVisualType.EVENT);
	out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/contentPage.css"/>
</head>

<body>
<c:set var="gson" value="<%= new Gson() %>" />

<div id="pageTitle">메인 KV 관리</div>

<ul class="pageGuide">
	<li>공개 상태 변경은 <span class="red"><b>즉시 반영</b></span>되며, <span class="red"><b>공개상태에서는 게시물 삭제가 불가합니다.</b></span></li>
	<li>노출 순서는 콘텐츠를 Drag & Drop 으로 변경이 가능하며, <span class="red"><b>변경 후 하단의 '순서 변경' 버튼</b></span>을 눌러야 변경 사항이 반영됩니다.</li>
	<li>공개 키비주얼은 비공개 전환로 전환 후에만 삭제할 수 있으며, <span class="red"><b>최소 1개의 게시물이 등록</b></span>되어있어야 합니다.</li>
	<li>공개 상태의 게시물은 <span class="red"><b>최대 10개</b></span>까지 등록 가능합니다.</li>
</ul>

<%-- 공개 키비주얼 --%>
<div class="listBox-grid">
	<form method="post" action="saveOrder">
		<table id="open">
			<thead>
			<tr>
				<td colspan="50">
					<div class="tableTitle">공개 키비주얼</div>
					<div class="listTotal">전체 <span class="bold gray"><c:out value="${countUseY}"/></span> 건</div>
				</td>
			</tr>
			<tr>
				<th style="width:30px;">번호</th>
				<th style="width:30px;">구분</th>
				<th style="width:200px;">제목</th>
				<th style="width:200px;">제공언어</th>
				<th style="width:80px;">미리보기</th>
				<th style="width:50px;">공개상태</th>
				<th style="width:80px;">등록일</th>
				<th style="width:50px;">등록자</th>
				<th style="width:50px;">수정</th>
			</tr>
			<c:if test='${empty listY}'>
				<tr>
					<td colspan="50">No Data.</td>
				</tr>
			</c:if>
			</thead>
			<tbody>
			<c:forEach items="${listY}" var="vo" varStatus="status">
				<tr id="${fn:escapeXml(vo.seq)}">
					<input type="hidden" name="seqs" value="${fn:escapeXml(vo.seq)}"/>
					<td><c:out value="${status.count}"/></td>
					<td><c:out value="${vo.kvType.name}"/></td>
					<td>
						<c:if test="${vo.kvType eq kvTypeEvent}">
							<c:out value="${vo.eventTitleKo}"/>
						</c:if>
						<c:if test="${vo.kvType eq kvTypeNormal}">
							<c:out value="${vo.kvTitleKo}"/>
						</c:if>
					</td>
					<td>
						<c:if test="${vo.kvType eq kvTypeNormal}">
							<c:forEach var="lang" items="${vo.kvSelectedLangsList}" varStatus="status">
								<c:choose>
									<c:when test="${lang == 'KO'}">국문</c:when>
									<c:when test="${lang == 'EN'}">영문</c:when>
									<c:when test="${lang == 'JP'}">일문</c:when>
									<c:when test="${lang == 'CN'}">중문</c:when>
								</c:choose>
								<c:if test="${!status.last}"> | </c:if>
							</c:forEach>
						</c:if>
						<c:if test="${vo.kvType eq kvTypeEvent}">
							<c:forEach var="lang" items="${vo.eventSelectedLangsList}" varStatus="status">
								<c:choose>
									<c:when test="${lang == 'KO'}">국문</c:when>
									<c:when test="${lang == 'EN'}">영문</c:when>
									<c:when test="${lang == 'JP'}">일문</c:when>
									<c:when test="${lang == 'CN'}">중문</c:when>
								</c:choose>
								<c:if test="${!status.last}"> | </c:if>
							</c:forEach>
						</c:if>
					</td>

					<td>
						<spring:eval var="baseFrontUrl" expression="@environment.getProperty('site.front.url')"/>
						<c:set var="frontUrl" value="${fn:escapeXml(baseFrontUrl)}/preview.do"/>
						<span class="whiteBtn" data-seq="${fn:escapeXml(vo.seq)}" onclick="showPreview('${fn:escapeXml(frontUrl)}')">미리보기</span>
					</td>
					<td>
						<select class="use ${vo.use ? 'Y' : 'N'}" data-seq="${fn:escapeXml(vo.seq)}">
							<option value="Y" class="Y" ${vo.use ? 'selected' : ''}>공개</option>
							<option value="N" class="N" ${!vo.use ? 'selected' : ''}>비공개</option>
						</select>
					</td>
					<td><c:out value="${vo.createDatePretty}"/></td>
					<td><c:out value="${vo.creatorMasked}"/></td>
					<td>
						<span class="click view whiteBtn" data-seq="${fn:escapeXml(vo.seq)}">수정</span>
					</td>
				</tr>
			</c:forEach>
			</tbody>
			<tfoot>
			<tr>
				<td colspan="50">
					<input type="submit" class="mot3 rightBtn grayBtn" value="순서 저장"/>
				</td>
			</tr>
			</tfoot>
		</table>
	</form>
	<div>
		<br>
	</div>
</div>

<%-- 검색 --%>
<jsp:include page="/include/search/form.jsp" flush="false">
	<jsp:param name="pageRow" value="true"/>
	<jsp:param name="searchText" value="제목"/>
	<jsp:param name="selectEnum" value="kvType:구분"/>
</jsp:include>

<%-- 비공개 키비주얼 --%>
<div class="listBox-grid">
	<form method="post" action="save">
		<table id="close">
			<thead>
			<tr>
				<td colspan="50">
					<div class="tableTitle">비공개 키비주얼</div>
					<div class="listTotal">전체 <span class="bold gray"><c:out value="${countUseN}"/></span> 건</div>
				</td>
			</tr>
			<tr>
				<th style="width:10px;"><input type="checkbox" class="checkAll"/></th>
				<th style="width:30px;">번호</th>
				<th style="width:30px;">구분</th>
				<th style="width:200px;">제목</th>
				<th style="width:200px;">제공언어</th>
				<th style="width:80px;">미리보기</th>
				<th style="width:50px;">공개상태</th>
				<th style="width:80px;">등록일</th>
				<th style="width:50px;">등록자</th>
				<th style="width:50px;">수정</th>
			</tr>
			<c:if test='${empty listN}'>
				<tr>
					<td colspan="50">No Data.</td>
				</tr>
			</c:if>
			</thead>
			<tbody>
			<c:forEach items="${listN}" var="vo" varStatus="status">
				<tr>
					<input type="hidden" name="seqs" value="${fn:escapeXml(vo.seq)}"/>
					<td><input type="checkbox" value="${fn:escapeXml(vo.seq)}"></td>
					<td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
					<td><c:out value="${vo.kvType.name}"/></td>
					<td>
						<c:if test="${vo.kvType eq kvTypeEvent}">
							<c:out value="${vo.eventTitleKo}"/>
						</c:if>
						<c:if test="${vo.kvType eq kvTypeNormal}">
							<c:out value="${vo.kvTitleKo}"/>
						</c:if>
					</td>
					<td>
						<c:if test="${vo.kvType eq kvTypeNormal}">
							<c:forEach var="lang" items="${vo.kvSelectedLangsList}" varStatus="status">
								<c:choose>
									<c:when test="${lang == 'KO'}">국문</c:when>
									<c:when test="${lang == 'EN'}">영문</c:when>
									<c:when test="${lang == 'JP'}">일문</c:when>
									<c:when test="${lang == 'CN'}">중문</c:when>
								</c:choose>
								<c:if test="${!status.last}"> | </c:if>
							</c:forEach>
						</c:if>
						<c:if test="${vo.kvType eq kvTypeEvent}">
							<c:forEach var="lang" items="${vo.eventSelectedLangsList}" varStatus="status">
								<c:choose>
									<c:when test="${lang == 'KO'}">국문</c:when>
									<c:when test="${lang == 'EN'}">영문</c:when>
									<c:when test="${lang == 'JP'}">일문</c:when>
									<c:when test="${lang == 'CN'}">중문</c:when>
								</c:choose>
								<c:if test="${!status.last}"> | </c:if>
							</c:forEach>
						</c:if>
					</td>
					<td>
						<spring:eval var="baseFrontUrl" expression="@environment.getProperty('site.front.url')"/>
						<c:set var="frontUrl" value="${fn:escapeXml(baseFrontUrl)}/preview.do"/>
						<span class="whiteBtn" data-seq="${fn:escapeXml(vo.seq)}" onclick="showPreview('${fn:escapeXml(frontUrl)}')">미리보기</span>
					</td>
					<td>
						<select class="use ${vo.use ? 'Y' : 'N'}" data-seq="${fn:escapeXml(vo.seq)}">
							<option value="Y" class="Y" ${vo.use ? 'selected' : ''}>공개</option>
							<option value="N" class="N" ${!vo.use ? 'selected' : ''}>비공개</option>
						</select>
					</td>
					<td><c:out value="${vo.createDatePretty}"/></td>
					<td><c:out value="${vo.creatorMasked}"/></td>
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
					<a type="button" href="javascript:;" class="mot3 rightBtn grayBtn view">등록</a>
				</td>
			</tr>
			</tfoot>
		</table>
	</form>

	<%--######################## 페이징 ########################--%>
	<jsp:include page="/include/paging.jsp">
		<jsp:param name="formName" value="searchForm"/>
	</jsp:include>
</div>
</body>

<script src="${fn:escapeXml(cPath)}/assets/js/list.js" 				charset="utf-8" type="text/javascript"></script>
<script src="${fn:escapeXml(cPath)}/assets/vendor/jquery.tablednd.js" charset="utf-8" type="text/javascript"></script>

<script>	/* 순서 저장 버튼 클릭 시, confirm */
	window.onload = function() {
		document.querySelector('form[action="saveOrder"]').addEventListener('submit', function(event) {
			if (!confirm('변경된 순서를 저장하시겠습니까?')) {
				event.preventDefault();
			}
		});
	};
</script>

<script> /* 미리보기 */
	function showPreview(url) {
		let newWindow = window.open(url, '_blank');

		if (!newWindow || newWindow.closed || typeof newWindow.closed == 'undefined') {
			alert('팝업이 차단되었습니다. 팝업 차단을 해제해주세요.');
		}
	}
</script>

<script>
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
	const getCheckedVal	= () => {
		return { "seq" : $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",")}
	};

	$(".view", ".listBox-grid").viewDetail("detail", document.searchForm);

	$("table#open .use", ".listBox-grid").changeStatus("changeUse", "useYn").then(onSuccess, onFailMsg);
	$("table#open .delete", ".listBox-grid").deleteArticle("delete").then(onFail);
	$("table#open tbody", ".listBox-grid").tableDnD({
		onDrop: function () {
			alert("순서 변경은 하단 순서 저장 버튼을 눌러야 적용됩니다.");
		}
	});

	$("tfoot .leftBtn", ".listBox-grid").deleteArticle("delete", getCheckedVal).then(() => {location.reload()});
	$("table#close select.use", ".listBox-grid").changeStatus("changeUse", "useYn").then(onSuccess, onFailMsg);
</script>

</html>
