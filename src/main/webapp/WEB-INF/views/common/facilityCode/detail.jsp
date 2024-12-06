<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.google.gson.Gson" %>
<%@ include file="/include/uploadForm.jsp" %>
<%@ page import="com.does.biz.primary.domain.common.CommonCodeType" %>
<%@ page import="com.does.biz.primary.domain.common.CommonCodeCategory" %>
<%
	request.setAttribute("codeType", CommonCodeType.values());
	request.setAttribute("codeCategoryTypeL", CommonCodeCategory.L);
	request.setAttribute("codeCategoryTypeM", CommonCodeCategory.M);
	request.setAttribute("codeCategoryTypeS", CommonCodeCategory.S);
	request.setAttribute("codeCategoryType", CommonCodeCategory.values());
	request.setAttribute("colspan", 1);
	out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<%@ include file="/WEB-INF/views/facility/facility/modalList.jsp" %>  <!-- 매장모달 -->
	<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/contentPage.css"/>
	<style type="text/javascript">
		td.allowIPBox input[type=text] {
			width: 115px !important;
		}
	</style>
</head>

<body>
<c:set var="gson" value="<%= new Gson() %>" />
<c:set var="isNew" value="${empty data.seq}" scope="page"/>

<div id="pageTitle">매장 및 시설코드 관리</div>

<ul class="pageGuide">
	<li><span class="red">*</span> 표시는 필수항목입니다.</li>
	<li><span class="red">분류코드는 자동으로 부여</span>됩니다.</li>
	<li><span class="red">한 번 등록된 분류코드는 수정이 불가능</span>하고, 분류명만 수정 가능합니다.</li>
	<li>해당 코드를 기준으로 매장 및 시설을 등록 시 카테고리를 선택할 수 있으며, 이미 <span class="red">특정 코드로 등록된 매장이 있을 시 해당 코드는 삭제가 불가능</span>합니다.</li>
</ul>

<div class="detailBox">
	<form method="post" name="workForm" action="save">
		<input type="hidden" name="seq" value="${fn:escapeXml(data.seq)}"/>
		<input type="hidden" name="pageNum" value="${fn:escapeXml(search.pageNum)}"/>
		<input type="hidden" name="facilityCount" value="${fn:escapeXml(facilityCount)}" />
		<table>
			<tbody>
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">코드구분</th>
				<td>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="codeCategoryL" name="codeCategory" onclick="changeCategory('L')"
							   value="${fn:escapeXml(codeCategoryTypeL)}" checked/>
						<label for="codeCategoryL">대분류</label>

						<input type="radio" id="codeCategoryM" name="codeCategory" onclick="changeCategory('M')"
							   value="${fn:escapeXml(codeCategoryTypeM)}" />
						<label for="codeCategoryM">중분류</label>

						<input type="radio" id="codeCategoryS" name="codeCategory" onclick="changeCategory('S')"
							   value="${fn:escapeXml(codeCategoryTypeS)}" />
						<label for="codeCategoryS">소분류</label>
					</c:if>
					<c:if test="${not isNew}">
						<input type="radio" id="codeCategoryL" name="codeCategory" disabled
							   value="${fn:escapeXml(codeCategoryTypeL)}" ${data.codeCategory eq codeCategoryTypeL ? 'checked' : '' } />
						<label for="codeCategoryL">대분류</label>

						<input type="radio" id="codeCategoryM" name="codeCategory" disabled
							   value="${fn:escapeXml(codeCategoryTypeM)}" ${data.codeCategory eq codeCategoryTypeM ? 'checked' : '' } />
						<label for="codeCategoryM">중분류</label>

						<input type="radio" id="codeCategoryS" name="codeCategory" disabled
							   value="${fn:escapeXml(codeCategoryTypeS)}" ${data.codeCategory eq codeCategoryTypeS ? 'checked' : '' } />
						<label for="codeCategoryS">소분류</label>
					</c:if>
				</td>
			</tr>
			</tbody>

			<tbody id="categories" style="display: none;">
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}" rowspan="3">상위 분류</th>
				<td>
					<input type="hidden" id="codeType" name="codeType" value="${fn:escapeXml(data.codeType)}">
					<input type="hidden" id="selectedHighCodeType" name="selectedHighCodeType" value="${fn:escapeXml(data.selectedHighCodeType)}">
					<%-- 대분류 드롭다운 --%>
					<select id="categoryLarge" style="display: none;" onchange="selectHighCodeType('L');">
						<option value="" disabled selected>대분류</option>
						<c:if test="${isNew and not empty largeCodeTypeList}">
							<c:forEach items="${largeCodeTypeList}" var="item">
								<option value="${fn:escapeXml(item.codeType)}"><c:out value="${item.codeTypeNameKo}"/></option>
							</c:forEach>
						</c:if>

						<c:if test="${not isNew and not empty largeCodeTypeList}">
							<c:forEach items="${largeCodeTypeList}" var="item">
								<c:if test="${not empty data.codeTypeArrays[0] and item.codeType eq data.codeTypeArrays[0]}">
									<option value="${fn:escapeXml(item.codeType)}" disabled selected><c:out value="${item.codeTypeNameKo}"/></option>
								</c:if>
							</c:forEach>
						</c:if>
					</select>
					<%-- // --%>

					<%-- 중분류 드롭다운 --%>
					<select id="categoryMiddle" style="display: none;" onchange="selectHighCodeType('M');">
						<option value="" disabled selected>중분류</option>
						<c:if test="${isNew and not empty middleCodeTypeList}">
							<c:forEach items="${middleCodeTypeList}" var="item">
								<option value="${fn:escapeXml(item.codeType)}"><c:out value="${item.codeTypeNameKo}"/></option>
							</c:forEach>
						</c:if>

						<c:if test="${not isNew and not empty middleCodeTypeList}">
							<c:forEach items="${middleCodeTypeList}" var="item">
								<c:if test="${not empty data.codeTypeArrays[0] and item.codeType.contains(data.codeTypeArrays[0])
										and not empty data.codeTypeArrays[1] and item.codeType.contains(data.codeTypeArrays[1])}">
									<option value="${fn:escapeXml(item.codeType)}" disabled selected><c:out value="${item.codeTypeNameKo}"/></option>
								</c:if>
							</c:forEach>
						</c:if>
					</select>
					<%-- // --%>

					<%-- 소분류 드롭다운 --%>
					<select id="categorySmall" onchange="selectHighCodeType('S');" style="display: none;">
						<option value="" disabled selected>소분류</option>
						<c:if test="${isNew and not empty smallCodeTypeList}">
							<c:forEach items="${smallCodeTypeList}" var="item">
								<option value="${fn:escapeXml(item.codeType)}"><c:out value="${item}"/></option>
							</c:forEach>
						</c:if>

						<c:if test="${not isNew and not empty smallCodeTypeList}">
							<c:forEach items="${smallCodeTypeList}" var="item">
								<c:if test="${not empty data.codeTypeArrays[0] and item.codeType.contains(data.codeTypeArrays[0])
										and not empty data.codeTypeArrays[1] and item.codeType.contains(data.codeTypeArrays[1])
										and not empty data.codeTypeArrays[2] and item.codeType.contains(data.codeTypeArrays[2])}">
									<option value="${fn:escapeXml(item.codeType)}" disabled selected><c:out value="${item.codeTypeNameKo}"/></option>
								</c:if>
							</c:forEach>
						</c:if>
					</select>
					<%-- // --%>
				</td>
			</tr>
			</tbody>

			<tbody>
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">분류명 (국문)</th>
				<td>
					<input type="text" name="codeTypeNameKo" id="codeTypeNameKo" value="${fn:escapeXml(data.codeTypeNameKo)}" class="w300" maxlength="50" autocomplete="off"
						placeholder="분류명을 입력해 주세요. (국문)">
				</td>
			</tr>
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">분류명 (영문)</th>
				<td>
					<input type="text" name="codeTypeNameEn" id="codeTypeNameEn" value="${fn:escapeXml(data.codeTypeNameEn)}" class="w300" maxlength="50" autocomplete="off"
						placeholder="분류명을 입력해 주세요. (영문)">
				</td>
			</tr>
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">분류명 (일문)</th>
				<td>
					<input type="text" name="codeTypeNameJp" id="codeTypeNameJp" value="${fn:escapeXml(data.codeTypeNameJp)}" class="w300" maxlength="50" autocomplete="off"
						placeholder="분류명을 입력해 주세요. (일문)">
				</td>
			</tr>
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">분류명 (중문)</th>
				<td>
					<input type="text" name="codeTypeNameCn" id="codeTypeNameCn" value="${fn:escapeXml(data.codeTypeNameCn)}" class="w300" maxlength="50" autocomplete="off"
						placeholder="분류명을 입력해 주세요. (중문)">
				</td>
			</tr>

			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">사용여부</th>
				<td>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="useY" name="useYn" value="Y" checked/>
						<label for="useY">사용</label>
						<input type="radio" id="useN" name="useYn" value="N"  />
						<label for="useN">미사용</label>
					</c:if>
					<c:if test="${not isNew}">
						<input type="radio" id="useY" name="useYn"
							   value="Y" ${data.useYn == 'Y' ? 'checked' : '' } onclick="checkUsageStatus()" />
						<label for="useY">사용</label>
						<input type="radio" id="useN" name="useYn"
							   value="N" ${data.useYn == 'N' ? 'checked' : '' } onclick="checkUsageStatus()" />
						<label for="useN">미사용</label>

						<a type="button" class="mot3 lightBtn-round" onclick="showModalForDependencyCheck('${fn:escapeXml(data.codeType)}')">등록 매장 확인</a>
					</c:if>
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

<script>
	const facilityCount = ${fn:escapeXml(facilityCount)};
	let isNew = ${fn:escapeXml(isNew)};
	let category = '${fn:escapeXml(data.codeCategory)}';
	let largeCodeTypeList = ${largeCodeTypeList == null ? [] : gson.toJson(largeCodeTypeList)};
	let middleCodeTypeList = ${middleCodeTypeList == null ? [] : gson.toJson(middleCodeTypeList)};
	let smallCodeTypeList = ${smallCodeTypeList == null ? [] : gson.toJson(smallCodeTypeList)};

	let categories = document.getElementById('categories');
	let categoryLarge = document.getElementById('categoryLarge');
	let categoryMiddle = document.getElementById('categoryMiddle');
	let codeCategoryL = document.getElementById('codeCategoryL');
	let codeCategoryM = document.getElementById('codeCategoryM');
	let codeCategoryS = document.getElementById('codeCategoryS');
	let selectedHighCodeType = document.getElementById('selectedHighCodeType');

	window.onload = function() {
		changeCategory(category);
		selectHighCodeType('L');
	};
</script>

<script>	/* 게시글 저장 시 전처리 */
	function goToSave() {
		setSelectedHighCodeTypeForSubmission();
		if (!isValidSelectedHighCodeType()) {
			return;
		}

		enableToCodeTypes();
		submitFormIntoHiddenFrame(document.workForm);
		disableToCodeTypes();
	}
</script>

<script>
	function enableToCodeTypes() {
		codeCategoryL.disabled = false;
		codeCategoryM.disabled = false;
		codeCategoryS.disabled = false;
	}

	function disableToCodeTypes() {
		codeCategoryL.disabled = true;
		codeCategoryM.disabled = true;
		codeCategoryS.disabled = true;
	}

	// 상위 분류 카테고리 Validation
	function isValidSelectedHighCodeType() {
	  	if (category === '${fn:escapeXml(codeCategoryTypeM)}') {
			if (categoryLarge.value === '') {
				alert("대분류가 존재해야 중분류를 선택할 수 있습니다.");
				return false;
			}
		} else if (category === '${fn:escapeXml(codeCategoryTypeS)}') {
			if (categoryMiddle.value === '') {
				alert("중분류가 존재해야 소분류를 선택할 수 있습니다.");
				return false;
			}
		}

		return true;
	}

	// 상위 분류 카테고리 설정
	function setSelectedHighCodeTypeForSubmission() {
		// 선택된 카테고리에 따라 드롭다운 표시
		if (category === '${fn:escapeXml(codeCategoryTypeM)}') {
			selectedHighCodeType.value = categoryLarge.value;
		} else if (category === '${fn:escapeXml(codeCategoryTypeS)}') {
			selectedHighCodeType.value = categoryMiddle.value;
		}
	}

	// 선택한 상위 분류에 따라 하위 분류를 노출
	function selectHighCodeType(category) {
		if (!isNew) {	// 신규 생성이 아닌 경우, 변경할 수 없도록 설정
			return;
		}

		if (category === 'L') {
			// 중분류 드롭다운 초기화
			categoryMiddle.innerHTML = `<option value="" disabled selected>중분류</option>`;
			if (categoryLarge.value) {
				middleCodeTypeList.forEach(item => {
					if (item.codeType.includes(categoryLarge.value)) {
						const option = document.createElement('option');
						option.value = item.codeType;
						option.text = item.codeTypeNameKo;
						categoryMiddle.appendChild(option);
					}
				})
			}
		}
	}

	// 코드 구분 변경
	function changeCategory(selectedCategory) {
		// 기본적으로 상위 카테고리 드롭다운을 숨김
		categories.style.display = 'none';
		categoryLarge.style.display = 'none';
		categoryMiddle.style.display = 'none';

		category = selectedCategory;

		// 선택된 카테고리에 따라 드롭다운 표시
		if (selectedCategory === '${fn:escapeXml(codeCategoryTypeM)}') {
			categories.style.display = 'contents';
			categoryLarge.style.display = 'inline-block';
		} else if (selectedCategory === '${fn:escapeXml(codeCategoryTypeS)}') {
			categories.style.display = 'contents';
			categoryLarge.style.display = 'inline-block';
			categoryMiddle.style.display = 'inline-block';
		}
	}
</script>

<script>
	function checkUsageStatus() {
		if (facilityCount > 0) {
			if (document.getElementById('useN').checked) {
				alert("해당 코드에 등록된 매장 및 시설이 있을 시, 코드 미사용 처리가 불가능합니다.");
				document.getElementById('useY').checked = true;
			}
		} else {
			if (document.getElementById('useN').checked) {
				if (confirm("해당 코드를 미사용 처리하시겠습니까?")) {
					document.getElementById('useN').checked = true;
				} else {
					document.getElementById('useY').checked = true;
				}
			}
		}
	}
</script>

<script>	/* 항목 삭제 */
	const onFail = function () {
		location.reload();
	}

	<c:if test="${not isNew}">
		$("tfoot .leftBtn").deleteArticle("delete", {"seq": '${fn:escapeXml(data.seq)}'}, facilityCount).then(() => {
			location.href = "list";
		})
		.catch(onFail);
	</c:if>
</script>

</body>
</html>