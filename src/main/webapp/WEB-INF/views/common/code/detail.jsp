<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/uploadForm.jsp" %>
<%@ page import="com.does.biz.primary.domain.common.CommonCodeType" %>
<%
	request.setAttribute("commonCodeTypes", CommonCodeType.values());
	request.setAttribute("colspan", 1);
	out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/contentPage.css"/>
	<style type="text/javascript">
		td.allowIPBox input[type=text] {
			width: 115px !important;
		}
	</style>
</head>

<body>
<c:set var="isNew" value="${empty data.seq}" scope="page"/>

<div id="pageTitle">공통코드 관리</div>

<ul class="pageGuide">
	<li><span class="red">*</span> 표시는 필수항목입니다.</li>
	<li><span class="red">코드 아이디는 자동으로 생성됩니다.</span></li>
</ul>

<div class="detailBox">
	<form method="post" name="workForm" action="save">
		<input type="hidden" name="seq" value="${fn:escapeXml(data.seq)}"/>
		<input type="hidden" name="pageNum" value="${fn:escapeXml(search.pageNum)}"/>
		<table>
			<tbody>
			<tr>
				<th required>분류</th>
				<td colspan="2">
					<select name="codeType" id="codeTypeSelect" onchange="updateCodeType()" ${isNew ? '' : 'disabled'}>
						<option value="" disabled selected>코드분류 선택</option>
						<c:forEach items="${commonCodeTypes}" var="item">
							<option value="${fn:escapeXml(item)}" data-name="${fn:escapeXml(item.name)}" ${data.codeType == item ? 'selected':''}><c:out value="${item} (${item.name})"/></option>
						</c:forEach>
					</select>
					<input type="text" name="codeType" id="codeType" value="${fn:escapeXml(data.codeType)}" class="w150" autocomplete="off" disabled>
				<td>
			</tr>

			<tr>
				<th required>코드 분류명</th>
				<td>
					<input type="text" name="codeTypeName" id="codeTypeName" value="${fn:escapeXml(data.codeTypeName)}" class="w500" autocomplete="off" disabled>
				</td>
			</tr>

			<tr>
				<th required>코드 아이디</th>
				<td>
					<input type="text" name="codeId" id="codeId" value="${fn:escapeXml(data.codeId)}" class="w500" autocomplete="off" disabled>
				</td>
			</tr>

			<tr>
				<th>코드 설명</th>
				<td>
					<input type="text" name="codeDescription" id="codeDescription" value="${fn:escapeXml(data.codeDescription)}" class="w500" maxlength="50" autocomplete="off" placeholder="코드 설명을 입력해주세요.">
				</td>
			</tr>

			<tr>
				<th required>코드명 (국문)</th>
				<td>
					<input type="text" name="codeNameKo" id="codeNameKo" value="${fn:escapeXml(data.codeNameKo)}" class="w500" maxlength="50" autocomplete="off" placeholder="코드명을 입력해주세요. (국문)">
				</td>
			</tr>
			<tr>
				<th>코드명 (영문)</th>
				<td>
					<input type="text" name="codeNameEn" id="codeNameEn" value="${fn:escapeXml(data.codeNameEn)}" class="w500" maxlength="50" autocomplete="off" placeholder="코드명을 입력해주세요. (영문)">
				</td>
			</tr>
			<tr>
				<th>코드명 (일문)</th>
				<td>
					<input type="text" name="codeNameJp" id="codeNameJp" value="${fn:escapeXml(data.codeNameJp)}" class="w500" maxlength="50" autocomplete="off" placeholder="코드명을 입력해주세요. (일문)">
				</td>
			</tr>
			<tr>
				<th>코드명 (중문)</th>
				<td>
					<input type="text" name="codeNameCn" id="codeNameCn" value="${fn:escapeXml(data.codeNameCn)}" class="w500" maxlength="50" autocomplete="off" placeholder="코드명을 입력해주세요. (중문)">
				</td>
			</tr>

			<c:if test="${not isNew}">
				<%@ include file="/include/worker.jsp" %>
			</c:if>
			</tbody>

			<tfoot>
			<tr>
				<td colspan="50">
					<c:if test="${not isNew}">
						<a type="button" class="mot3 leftBtn lightBtn-round">삭제</a>
					</c:if>
					<a type="button" href="javascript:goToSave()" class="mot3 rightBtn blueBtn-round">
						저장
					</a>
					<a type="button" href="javascript:goBackToList(undefined, 'seq')" class="mot3 rightBtn grayBtn-round">
						목록
					</a>
				</td>
			</tr>
			</tfoot>
		</table>
	</form>
</div>

<%--######################## 스크립트 ########################--%>
<script src="${fn:escapeXml(cPath)}/assets/js/detail.js" charset="utf-8" type="text/javascript"></script>

<script>	/* 코드분류 출력 */
	function updateCodeType() {
		let select = document.getElementById("codeTypeSelect");
		let selectedOption = select.options[select.selectedIndex];
		let selectedValue = selectedOption.value;
		let selectedName = selectedOption.getAttribute('data-name');

		document.getElementById("codeType").value = selectedValue;
		document.getElementById("codeTypeName").value = selectedName;
	}
</script>

<script>	/* 게시글 저장 시 전처리 */
	function goToSave() {
		document.getElementById("codeTypeName").disabled = false;
		submitFormIntoHiddenFrame(document.workForm);
		document.getElementById("codeTypeName").disabled = true;
	}
</script>

<script>	/* 항목 삭제 */
	const onFail = function () {
		location.reload();
	}

	<c:if test="${not isNew}">
		$("tfoot .leftBtn").deleteArticle("delete", {"seq": '${fn:escapeXml(data.seq)}'}).then(() => {
			location.href = "list"
		}, onFail);
	</c:if>
</script>

</body>
</html>