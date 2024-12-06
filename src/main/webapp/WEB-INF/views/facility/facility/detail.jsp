<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page import="com.does.biz.primary.domain.facility.BuildingType" %>
<%@ page import="com.does.biz.primary.domain.affiliate.AffiliateFloorType" %>
<%@ page import="com.does.biz.primary.domain.facility.BusinessHoursType" %>
<%@ page import="com.does.biz.primary.domain.facility.BusinessHoursVO" %>
<%@ include file="/include/uploadForm.jsp" %>
<%
	request.setAttribute("buildingType", BuildingType.values());
	request.setAttribute("buildingTypeLWT", BuildingType.LWT);
	request.setAttribute("buildingTypeLWM", BuildingType.LWM);
	request.setAttribute("buildingTypeAVE", BuildingType.AVE);
	request.setAttribute("buildingTypeETC", BuildingType.ETC);

	request.setAttribute("businessHoursTypeCommon", BusinessHoursType.COMMON);
	request.setAttribute("businessHoursTypeWeekend", BusinessHoursType.WEEKEND);
	request.setAttribute("businessHoursTypeExtra", BusinessHoursType.EXTRA);

	List<String> floorNames = Arrays.stream(AffiliateFloorType.values())
		.map(AffiliateFloorType::getDisplayName)
		.collect(Collectors.toList());
	request.setAttribute("affiliateFloors", floorNames);
	request.setAttribute("areaCodes", BusinessHoursVO.AREA_CODES);
	request.setAttribute("weeks", BusinessHoursVO.weeks);
	request.setAttribute("days", BusinessHoursVO.days);

	request.setAttribute("colspan", 2);
	out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<%@ include file="/WEB-INF/views/facility/facility/modalListPOI.jsp" %>
	<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/contentPage.css"/>
	<style>
		.detailBox table tbody th {
			min-width: 24% !important;
			max-width: 24% !important;
			width: 24% !important;
		}
		#detailBoxDouble table tbody th {
			min-width: 12% !important;
			max-width: 12% !important;
			width: 12% !important;
		}
	</style>
</head>

<body>
<c:set var="gson" value="<%= new Gson() %>" />
<c:set var="isNew" value="${empty data.seq}" scope="page"/>

<div id="pageTitle">매장 및 시설 관리</div>

<ul class="pageGuide">
	<li><span class="red">*</span>는 필수 입력 항목입니다. 필수 항목을 입력하지 않을 경우, 등록이 완료되지 않습니다.</li>
	<li>국문은 필수로 입력해야하며, 다국어는 선택적으로 정보가 기재된 언어만 홈페이지에 노출됩니다.</li>
</ul>

<%-- 매장 승인 버튼 --%>
<c:if test="${not isNew and data.approveYn != 'Y' and not empty data.poiId}">
	<form method="post" name="workFormForApprove" action="approve">
		<div>
			<input type="hidden" name="seq" value="${fn:escapeXml(data.seq)}" />
			<input type="hidden" name="approveYn" value="Y" />
			<button type="button" class="mot3 blueBtn-round" onclick="submitFormIntoHiddenFrame(document.workFormForApprove);">
				승인
			</button>
		</div>
	</form>
</c:if>
<%--// --%>

<form method="post" name="workForm" action="save">
	<div class="detailBox">
		<input type="hidden" name="seq" value="${fn:escapeXml(data.seq)}"/>
		<input type="hidden" name="pageNum" value="${fn:escapeXml(search.pageNum)}"/>
		<input type="hidden" name="approveYn" value="${fn:escapeXml(search.approveYn)}"/>

		<table>
			<tbody>
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">건물 위치</th>
				<td>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="buildingTypeLWT" name="buildingType"
							   value="${fn:escapeXml(buildingTypeLWT)}" checked/>
						<label for="buildingTypeLWT">롯데월드타워</label>

						<input type="radio" id="buildingTypeLWM" name="buildingType"
							   value="${fn:escapeXml(buildingTypeLWM)}"/>
						<label for="buildingTypeLWM">롯데월드몰</label>

						<input type="radio" id="buildingTypeAVE" name="buildingType"
							   value="${fn:escapeXml(buildingTypeAVE)}"/>
						<label for="buildingTypeAVE">에비뉴엘</label>

						<input type="radio" id="buildingTypeETC" name="buildingType"
							   value="${fn:escapeXml(buildingTypeETC)}"/>
						<label for="buildingTypeETC">기타</label>
					</c:if>

					<c:if test="${not isNew}">
						<input type="radio" id="buildingTypeLWT" name="buildingType"
							   value="${fn:escapeXml(buildingTypeLWT)}" ${data.buildingType eq buildingTypeLWT ? 'checked' : '' } />
						<label for="buildingTypeLWT">롯데월드타워</label>

						<input type="radio" id="buildingTypeLWM" name="buildingType"
							   value="${fn:escapeXml(buildingTypeLWM)}" ${data.buildingType eq buildingTypeLWM ? 'checked' : '' } />
						<label for="buildingTypeLWM">롯데월드몰</label>

						<input type="radio" id="buildingTypeAVE" name="buildingType"
							   value="${fn:escapeXml(buildingTypeAVE)}" ${data.buildingType eq buildingTypeAVE ? 'checked' : '' } />
						<label for="buildingTypeAVE">에비뉴엘</label>

						<input type="radio" id="buildingTypeETC" name="buildingType"
							   value="${fn:escapeXml(buildingTypeETC)}" ${data.buildingType eq buildingTypeETC ? 'checked' : '' } />
						<label for="buildingTypeETC">기타</label>
					</c:if>
				</td>
			</tr>

			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">운영사</th>
				<td>
					<select name="affiliate">
						<option value="" disabled selected>운영사를 선택해 주세요.</option>
						<c:forEach items="${affiliates}" var="item">
							<option value="${fn:escapeXml(item)}" ${data.affiliate == item ? 'selected':''}><c:out value="${item.nameKo}"/></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			</tbody>

			<tbody>
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">층 정보</th>
				<td>
					<input type="hidden" id="affiliateFloor" name="affiliateFloor" value="${fn:escapeXml(data.affiliateFloor)}">
					<input type="hidden" id="poiId" name="poiId" value="${fn:escapeXml(data.poiId)}">

					<div id="floorContainer">
						<%-- 비어있을 때 --%>
						<c:if test="${empty data.affiliateFloorArrays}">
							<div class="floorRow">
								<div id="floor0">
									<select name="floorSelect">
										<option value="" disabled selected>층을 선택해 주세요.</option>
										<c:forEach items="${affiliateFloors}" var="item">
											<option value="${fn:escapeXml(item)}"><c:out value="${item}"/></option>
										</c:forEach>
									</select>
									<div style="display: inline-flex">
										<label style="font-size: 14px;"><b>다비오 위치 ID</b></label>
										<input type="text" name="poiSelect0" class="w200" onclick="clearInputForPOI(this)"
											   autocomplete="off" readonly style="background-color: #f0f0f0; color: #999; border: 1px solid #ddd;">
										<input type="hidden" name="poiSelectFloorName0" class="w200">
									</div>

									<a type="button" name="poiSelectBtn0" class="mot3 lightBtn-round" onclick="addPOI(this, 0)">+</a>
								</div>
							</div>
						</c:if>
						<c:if test="${not empty data.affiliateFloorArrays}">
							<c:forEach var="floor" items="${data.affiliateFloorArrays}" varStatus="status">
								<div class="floorRow">
									<div id="floor${fn:escapeXml(status.index)}">
										<select name="floorSelect">
											<option value="" disabled selected>층을 선택해 주세요.</option>
											<c:forEach items="${affiliateFloors}" var="item">
												<option value="${fn:escapeXml(item)}" ${floor == item ? 'selected':''}><c:out value="${item}"/></option>
											</c:forEach>
										</select>
										<div style="display: inline-flex">
											<label style="font-size: 14px;"><b>다비오 위치 ID</b></label>
											<input type="text" name="poiSelect${fn:escapeXml(status.index)}" class="w200" onclick="clearInputForPOI(this)"
												   value="${fn:escapeXml(data.poiIdArrays[status.index])}"
												   autocomplete="off" readonly style="background-color: #f0f0f0; color: #999; border: 1px solid #ddd;">
											<input type="hidden" name="poiSelectFloorName${fn:escapeXml(status.index)}" class="w200" value="${fn:escapeXml(floor)}">
										</div>

										<a type="button" name="poiSelectBtn${fn:escapeXml(status.index)}" class="mot3 lightBtn-round" onclick="addPOI(this, ${fn:escapeXml(status.index)})">+</a>

										<c:if test="${status.index != 0}">
											<button type="button" class="mot3 whiteBtn-round" onclick="removeFloorField(this)">-</button>
										</c:if>
									</div>
								</div>
							</c:forEach>
						</c:if>
					</div>

					<br id="floorAddBtnBr">
					<%-- 추가 버튼 --%>
					<a type="button" id="floorAddBtn" href="javascript:void(0);" onclick="addFloorField();" class="mot3 whiteBtn-round">추가 +</a>
					<%-- // --%>
				</td>
			</tr>
			</tbody>

			<tbody id="categories">
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}" rowspan="3">카테고리</th>
				<td>
					<input type="hidden" id="codeType" name="codeType" value="${fn:escapeXml(data.codeType)}">
					<input type="hidden" id="specificCodeTypeNameKo" name="specificCodeTypeNameKo" value="${fn:escapeXml(data.specificCodeTypeNameKo)}">

					<div id="categoryContainer">
						<%-- 비어있을 때 --%>
						<c:if test="${empty data.codeTypeArraysInnerCategoryArrays}">
							<div class="categoryRow">
								<%-- 대분류 드롭다운 --%>
								<select id="categoryLarge0" name="categoryLarge[0]" onchange="selectHighCodeType(this, 'L', 0);">
									<option value="" disabled selected>대분류</option>
									<c:if test="${not empty largeCodeTypeList}">
										<c:forEach items="${largeCodeTypeList}" var="item">
											<option value="${fn:escapeXml(item.codeType)}"><c:out value="${item.codeTypeNameKo}"/></option>
										</c:forEach>
									</c:if>
								</select>
								<%-- // --%>

								<%-- 중분류 드롭다운 --%>
								<select id="categoryMiddle0" name="categoryMiddle[0]" onchange="selectHighCodeType(this, 'M', 0);">
									<option value="" disabled selected>중분류</option>
								</select>
								<%-- // --%>

								<%-- 소분류 드롭다운 --%>
								<select id="categorySmall0" name="categorySmall[0]" onchange="selectHighCodeType(this, 'S', 0);">
									<option value="" disabled selected>소분류</option>
								</select>
								<%-- // --%>

							</div>
						</c:if>

						<c:if test="${not empty data.codeTypeArraysInnerCategoryArrays}">
						<c:forEach var="row" items="${data.codeTypeArraysInnerCategoryArrays}" varStatus="status">
							<input type="hidden" id="nowCodeType${fn:escapeXml(status.index)}" value="${fn:escapeXml(data.codeTypeArrays[status.index])}">
							<div class="categoryRow">
								<%-- 대분류 드롭다운 --%>
								<select id="categoryLarge${fn:escapeXml(status.index)}" name="categoryLarge[${fn:escapeXml(status.index)}]" onchange="selectHighCodeType(this, 'L', ${fn:escapeXml(status.index)});">
									<option value="" disabled selected>대분류</option>
									<c:if test="${not empty largeCodeTypeList}">
										<c:forEach items="${largeCodeTypeList}" var="item">
											<c:if test="${status.index == 0 or (item.codeTypeNameKo.equals('매장') or item.codeTypeNameKo.equals('F&B'))}">
												<c:choose>
													<c:when test="${not empty row[0] and item.codeType eq row[0]}">
														<option value="${fn:escapeXml(item.codeType)}" selected><c:out value="${item.codeTypeNameKo}"/></option>
													</c:when>
													<c:otherwise>
														<option value="${fn:escapeXml(item.codeType)}"><c:out value="${item.codeTypeNameKo}"/></option>
													</c:otherwise>
												</c:choose>
											</c:if>
										</c:forEach>
									</c:if>
								</select>
								<%-- // --%>

								<%-- 중분류 드롭다운 --%>
								<select id="categoryMiddle${fn:escapeXml(status.index)}" name="categoryMiddle[${fn:escapeXml(status.index)}]" onchange="selectHighCodeType(this, 'M', ${fn:escapeXml(status.index)});" ${empty row[0] ? 'disabled' : ''}>
									<option value="" disabled selected>중분류</option>
									<c:if test="${not empty middleCodeTypeList}">
										<c:forEach items="${middleCodeTypeList}" var="item">
											<c:if test="${not empty row[0] and not empty row[1] and item.codeType.startsWith(row[0])}">
												<c:choose>
													<c:when test="${item.codeType.substring(4).startsWith(row[1])}">
														<option value="${fn:escapeXml(item.codeType)}" selected><c:out value="${item.codeTypeNameKo}"/></option>
													</c:when>
													<c:otherwise>
														<option value="${fn:escapeXml(item.codeType)}"><c:out value="${item.codeTypeNameKo}"/></option>
													</c:otherwise>
												</c:choose>
											</c:if>
										</c:forEach>
									</c:if>
								</select>
								<%-- // --%>

								<%-- 소분류 드롭다운 --%>
								<select id="categorySmall${fn:escapeXml(status.index)}" name="categorySmall[${fn:escapeXml(status.index)}]" onchange="selectHighCodeType(this, 'S', ${fn:escapeXml(status.index)});" ${empty row[0] or empty row[1] ? 'disabled' : ''}>
									<option value="" disabled selected>소분류</option>
									<c:if test="${not empty smallCodeTypeList}">
										<c:forEach items="${smallCodeTypeList}" var="item">
											<c:if test="${not empty row[0] and not empty row[1] and not empty row[2] and item.codeType.startsWith(row[0]) and item.codeType.substring(4).startsWith(row[1])}">
												<c:choose>
													<c:when test="${item.codeType.substring(8).startsWith(row[2])}">
														<option value="${fn:escapeXml(item.codeType)}" selected><c:out value="${item.codeTypeNameKo}"/></option>
													</c:when>
													<c:otherwise>
														<option value="${fn:escapeXml(item.codeType)}"><c:out value="${item.codeTypeNameKo}"/></option>
													</c:otherwise>
												</c:choose>
											</c:if>
										</c:forEach>
									</c:if>
								</select>
								<%-- // --%>

								<c:if test="${status.index != 0}">
									<button type="button" id="categoryRemoveBtn" onclick="removeCategoryField(this)" class="mot3 whiteBtn-round" style="margin-left: 5px; margin-top: 0px;">-</button>
								</c:if>
							</div>
						</c:forEach>
						</c:if>
					<%-- // --%>
					</div>

					<div id="messageForFnBCategory" class="ment">
						F&B 매장 등록 시 중분류를 기타로 설정 부탁드립니다.
					</div>

					<br id="categoryAddBtnBr">
					<%-- 추가 버튼 --%>
					<a type="button" id="categoryAddBtn" href="javascript:void(0);" onclick="addCategoryField();" class="mot3 whiteBtn-round">추가 +</a>
					<%-- // --%>
				</td>
			</tr>
			</tbody>
		</table>

		<br>
		<br>
		<div class="pageSubTitle">매장 정보 등록</div>
		<style>
			/* 매장 소개 스타일 */
			textarea {
				width: 650px !important;
				min-width: 650px !important;
				max-width: 650px !important;
				height: 80px !important;
			}
		</style>

		<table style="margin-top: 15px;">
			<tbody id="selectedLangs">
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">제공언어</th>
				<td>
					<div class="language-tabs">
						<a type="button" id="selectedLangBtnKO" class="mot3 langBtn-round active"
						   onclick="selectLanguage('KO')">국문</a>
						<a type="button" id="selectedLangBtnEN" class="mot3 langBtn-round"
						   onclick="selectLanguage('EN')">영문</a>
						<a type="button" id="selectedLangBtnJP" class="mot3 langBtn-round"
						   onclick="selectLanguage('JP')">일문</a>
						<a type="button" id="selectedLangBtnCN" class="mot3 langBtn-round"
						   onclick="selectLanguage('CN')">중문</a>
					</div>
				</td>
			</tr>
			</tbody>

			<tbody>
			<!-- 언어별 데이터 (hidden 필드로 초기화 및 저장) -->
			<input type="hidden" id="seqFacilityLangInfoKo" name="facilityLangInfoKo.seq" value="${fn:escapeXml(data.facilityLangInfoKo.seq)}">
			<input type="hidden" id="seqFacilityLangInfoEn" name="facilityLangInfoEn.seq" value="${fn:escapeXml(data.facilityLangInfoEn.seq)}">
			<input type="hidden" id="seqFacilityLangInfoJp" name="facilityLangInfoJp.seq" value="${fn:escapeXml(data.facilityLangInfoJp.seq)}">
			<input type="hidden" id="seqFacilityLangInfoCn" name="facilityLangInfoCn.seq" value="${fn:escapeXml(data.facilityLangInfoCn.seq)}">

			<!-- 제공언어에 따라 변환될 입력 폼 -->
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">매장 및 시설명</th>
				<td>
					<input type="text" id="facilityNameKO" name="facilityLangInfoKo.name" onkeyup="setValidLang()"
						   value="${fn:escapeXml(data.facilityLangInfoKo.name)}" class="w300" autocomplete="off" maxlength="100"
						   placeholder="매장 및 시설명을 입력해 주세요. (국문)">
					<input type="text" id="facilityNameEN" name="facilityLangInfoEn.name" onkeyup="setValidLang()"
						   value="${fn:escapeXml(data.facilityLangInfoEn.name)}" class="w300" autocomplete="off" style="display:none;" maxlength="100"
						   placeholder="매장 및 시설명을 입력해 주세요. (영문)">
					<input type="text" id="facilityNameJP" name="facilityLangInfoJp.name" onkeyup="setValidLang()"
						   value="${fn:escapeXml(data.facilityLangInfoJp.name)}" class="w300" autocomplete="off" style="display:none;" maxlength="100"
						   placeholder="매장 및 시설명을 입력해 주세요. (일문)">
					<input type="text" id="facilityNameCN" name="facilityLangInfoCn.name" onkeyup="setValidLang()"
						   value="${fn:escapeXml(data.facilityLangInfoCn.name)}" class="w300" autocomplete="off" style="display:none;" maxlength="100"
						   placeholder="매장 및 시설명을 입력해 주세요. (중문)">
				</td>
			</tr>

			<tr>
				<th colspan="${fn:escapeXml(colspan)}">소개</th>
				<td>
            		<textarea id="descriptionKO" name="facilityLangInfoKo.description" onkeyup="setValidLang()" maxlength="3000"
							  placeholder="매장 및 시설에 대한 소개를 입력해 주세요. (국문)"><c:out value="${data.facilityLangInfoKo.description}"/></textarea>
					<textarea id="descriptionEN" name="facilityLangInfoEn.description" onkeyup="setValidLang()" style="display:none;" maxlength="3000"
							  placeholder="매장 및 시설에 대한 소개를 입력해 주세요. (영문)"><c:out value="${data.facilityLangInfoEn.description}"/></textarea>
					<textarea id="descriptionJP" name="facilityLangInfoJp.description" onkeyup="setValidLang()" style="display:none;" maxlength="3000"
							  placeholder="매장 및 시설에 대한 소개를 입력해 주세요. (일문)"><c:out value="${data.facilityLangInfoJp.description}"/></textarea>
					<textarea id="descriptionCN" name="facilityLangInfoCn.description" onkeyup="setValidLang()" style="display:none;" maxlength="3000"
							  placeholder="매장 및 시설에 대한 소개를 입력해 주세요. (중문)"><c:out value="${data.facilityLangInfoCn.description}"/></textarea>
				</td>
			</tr>

			<tbody id="thumbImgs" style="display: none;">
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">대표 썸네일 이미지 (공통)</th>
				<td>
					<input type="hidden" id="thumbImg.seq" name="thumbImg.seq" class="w300" value="${fn:escapeXml(data.thumbImg.seq)}">
					<c:set var="attach" value="${data.thumbImg.file}" scope="request"/>
					<jsp:include page="/include/component/fileUpload.jsp">
						<jsp:param name="t_required" value="false"/>
						<jsp:param name="t_ment" value="<%=image(1020, 1020)%>"/>
						<jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
						<jsp:param name="t_fileName" value="thumbImg.file"/>
						<jsp:param name="t_tag" value="THUMB_IMG"/>
						<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">대표 썸네일 이미지 대체 텍스트</th>
				<td>
					<input type="text" id="thumbImg.fileAltTxtKO" name="thumbImg.fileAltTxtKo" class="w300" maxlength="200" onkeyup="setValidLang()"
						   value="${fn:escapeXml(data.thumbImg.fileAltTxtKo)}" autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (국문)">
					<input type="text" id="thumbImg.fileAltTxtEN" name="thumbImg.fileAltTxtEn" class="w300" maxlength="200" onkeyup="setValidLang()"
						   value="${fn:escapeXml(data.thumbImg.fileAltTxtEn)}" autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (영문)">
					<input type="text" id="thumbImg.fileAltTxtJP" name="thumbImg.fileAltTxtJp" class="w300" maxlength="200" onkeyup="setValidLang()"
						   value="${fn:escapeXml(data.thumbImg.fileAltTxtJp)}" autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (일문)">
					<input type="text" id="thumbImg.fileAltTxtCN" name="thumbImg.fileAltTxtCn" class="w300" maxlength="200" onkeyup="setValidLang()"
						   value="${fn:escapeXml(data.thumbImg.fileAltTxtCn)}" autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (중문)">
				</td>
			</tr>
			</tbody>

			<tr>
				<th colspan="${fn:escapeXml(colspan)}">태그</th>
				<td>
					<input type="text" id="tagsKO" name="facilityLangInfoKo.tags" onkeyup="setValidLang()" maxlength="100"
						   value="${fn:escapeXml(data.facilityLangInfoKo.tags)}" class="w300" autocomplete="off"
						   placeholder="매장 및 시설에 대한 소개 태그를 입력해 주세요. (국문)">
					<input type="text" id="tagsEN" name="facilityLangInfoEn.tags" onkeyup="setValidLang()" style="display:none;" maxlength="100"
						   value="${fn:escapeXml(data.facilityLangInfoEn.tags)}" class="w300" autocomplete="off"
						   placeholder="매장 및 시설에 대한 소개 태그를 입력해 주세요. (영문)">
					<input type="text" id="tagsJP" name="facilityLangInfoJp.tags" onkeyup="setValidLang()" style="display:none;" maxlength="100"
						   value="${fn:escapeXml(data.facilityLangInfoJp.tags)}" class="w300" autocomplete="off"
						   placeholder="매장 및 시설에 대한 소개 태그를 입력해 주세요. (일문)">
					<input type="text" id="tagsCN" name="facilityLangInfoCn.tags" onkeyup="setValidLang()" style="display:none;" maxlength="100"
						   value="${fn:escapeXml(data.facilityLangInfoCn.tags)}" class="w300" autocomplete="off"
						   placeholder="매장 및 시설에 대한 소개 태그를 입력해 주세요. (중문)">
					<div style="color:gray; font-size: 12px;"> * 콤마로 구분하여 최대 3개까지 입력 가능합니다.</div>
				</td>
			</tr>
			</tbody>

			<tbody id="searchKeyword">
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">검색 키워드</th>
				<td>
					<input type="text" id="searchKeywordsKO" name="facilityLangInfoKo.searchKeywords" onkeyup="setValidLang()" maxlength="100"
						   value="${fn:escapeXml(data.facilityLangInfoKo.searchKeywords)}" class="w300" autocomplete="off"
						   placeholder="검색 키워드를 입력해 주세요. (국문)">
					<input type="text" id="searchKeywordsEN" name="facilityLangInfoEn.searchKeywords" onkeyup="setValidLang()" style="display:none;" maxlength="100"
						   value="${fn:escapeXml(data.facilityLangInfoEn.searchKeywords)}" class="w300" autocomplete="off"
						   placeholder="검색 키워드를 입력해 주세요. (영문)">
					<input type="text" id="searchKeywordsJP" name="facilityLangInfoJp.searchKeywords" onkeyup="setValidLang()" style="display:none;" maxlength="100"
						   value="${fn:escapeXml(data.facilityLangInfoJp.searchKeywords)}" class="w300" autocomplete="off"
						   placeholder="검색 키워드를 입력해 주세요. (일문)">
					<input type="text" id="searchKeywordsCN" name="facilityLangInfoCn.searchKeywords" onkeyup="setValidLang()" style="display:none;" maxlength="100"
						   value="${fn:escapeXml(data.facilityLangInfoCn.searchKeywords)}" class="w300" autocomplete="off"
						   placeholder="검색 키워드를 입력해 주세요. (중문)">
					<div style="color:gray; font-size: 12px;"> * 콤마로 구분하여 최대 5개까지 입력 가능합니다.</div>
				</td>
			</tr>
			</tbody>

			<!-- 'F&B - 기타' 카테고리에서만 메뉴 입력 폼 활성화 -->
			<tbody id="menus" style="display: none;">
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">메뉴</th>
				<td>
					<div class="menuForm menuFormKO" id="menuFormKO">
						<c:forEach var="menu" items="${data.facilityLangInfoKo.menuList}" varStatus="status">
							<div id="menuFormKO${fn:escapeXml(status.index)}">
								<input type="text" id="menuNameKO${fn:escapeXml(status.index)}" name="facilityLangInfoKo.menuList[${fn:escapeXml(status.index)}].name" maxlength="50"
									   value="${fn:escapeXml(menu.name)}" class="w300" autocomplete="off" onkeyup="setValidLang()"
									   placeholder="메뉴명을 입력해 주세요. (국문)">
								<input type="text" id="menuPriceKO${fn:escapeXml(status.index)}" name="facilityLangInfoKo.menuList[${fn:escapeXml(status.index)}].price"
									   value="${fn:escapeXml(menu.price)}" class="w150" autocomplete="off" onkeyup="setValidLang()" style="margin-left: 7.5px;"
									   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
												if (this.value.length > 9) this.value = this.value.slice(0, 9);"
									   placeholder="가격을 입력해 주세요.">
								<c:if test="${status.index != 0}">
									<button type="button" class="mot3 whiteBtn-round" onclick="removeMenuField(this)">-</button>
								</c:if>
							</div>
						</c:forEach>
						<c:if test="${empty data.facilityLangInfoKo.menuList}">
							<div id="menuFormKO0">
								<input type="text" id="menuNameKO0" name="facilityLangInfoKo.menuList[0].name" maxlength="50"
									   class="w300" autocomplete="off" onkeyup="setValidLang()"
									   placeholder="메뉴명을 입력해 주세요. (국문)">
								<input type="text" id="menuPriceKO0" name="facilityLangInfoKo.menuList[0].price"
									   class="w150" autocomplete="off" onkeyup="setValidLang()" style="margin-left: 7.5px;"
									   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
												if (this.value.length > 9) this.value = this.value.slice(0, 9);"
									   placeholder="가격을 입력해 주세요.">
							</div>
						</c:if>
					</div>

					<div class="menuForm menuFormEN" id="menuFormEN">
						<c:forEach var="menu" items="${data.facilityLangInfoEn.menuList}" varStatus="status">
							<div id="menuFormEN${fn:escapeXml(status.index)}">
								<input type="text" id="menuNameEN${fn:escapeXml(status.index)}" name="facilityLangInfoEn.menuList[${fn:escapeXml(status.index)}].name" maxlength="50"
									   value="${fn:escapeXml(menu.name)}" class="w300" autocomplete="off" onkeyup="setValidLang()"
									   placeholder="메뉴명을 입력해 주세요. (영문)">
								<input type="text" id="menuPriceEN${fn:escapeXml(status.index)}" name="facilityLangInfoEn.menuList[${fn:escapeXml(status.index)}].price"
									   value="${fn:escapeXml(menu.price)}" class="w150" autocomplete="off" onkeyup="setValidLang()" style="margin-left: 7.5px;"
									   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
												if (this.value.length > 9) this.value = this.value.slice(0, 9);"
									   placeholder="가격을 입력해 주세요.">
								<c:if test="${status.index != 0}">
									<button type="button" class="mot3 whiteBtn-round" onclick="removeMenuField(this)">-</button>
								</c:if>
							</div>
						</c:forEach>
						<c:if test="${empty data.facilityLangInfoEn.menuList}">
							<div id="menuFormEN0">
								<input type="text" id="menuNameEN0" name="facilityLangInfoEn.menuList[0].name" maxlength="50"
									   class="w300" autocomplete="off" onkeyup="setValidLang()"
									   placeholder="메뉴명을 입력해 주세요. (영문)">
								<input type="text" id="menuPriceEN0" name="facilityLangInfoEn.menuList[0].price"
									   class="w150" autocomplete="off" onkeyup="setValidLang()" style="margin-left: 7.5px;"
									   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
												if (this.value.length > 9) this.value = this.value.slice(0, 9);"
									   placeholder="가격을 입력해 주세요.">
							</div>
						</c:if>
					</div>

					<div class="menuForm menuFormJP" id="menuFormJP">
						<c:forEach var="menu" items="${data.facilityLangInfoJp.menuList}" varStatus="status">
							<div id="menuFormJP${fn:escapeXml(status.index)}">
								<input type="text" id="menuNameJP${fn:escapeXml(status.index)}" name="facilityLangInfoJp.menuList[${fn:escapeXml(status.index)}].name" maxlength="50"
									   value="${fn:escapeXml(menu.name)}" class="w300" autocomplete="off" onkeyup="setValidLang()"
									   placeholder="메뉴명을 입력해 주세요. (일문)">
								<input type="text" id="menuPriceJP${fn:escapeXml(status.index)}" name="facilityLangInfoJp.menuList[${fn:escapeXml(status.index)}].price"
									   value="${fn:escapeXml(menu.price)}" class="w150" autocomplete="off" onkeyup="setValidLang()" style="margin-left: 7.5px;"
									   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
												if (this.value.length > 9) this.value = this.value.slice(0, 9);"
									   placeholder="가격을 입력해 주세요.">
								<c:if test="${status.index != 0}">
									<button type="button" class="mot3 whiteBtn-round" onclick="removeMenuField(this)">-</button>
								</c:if>
							</div>
						</c:forEach>
						<c:if test="${empty data.facilityLangInfoJp.menuList}">
							<div id="menuFormJP0">
								<input type="text" id="menuNameJP0" name="facilityLangInfoJp.menuList[0].name" maxlength="50"
									   class="w300" autocomplete="off" onkeyup="setValidLang()"
									   placeholder="메뉴명을 입력해 주세요. (일문)">
								<input type="text" id="menuPriceJP0" name="facilityLangInfoJp.menuList[0].price"
									   class="w150" autocomplete="off" onkeyup="setValidLang()" style="margin-left: 7.5px;"
									   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
												if (this.value.length > 9) this.value = this.value.slice(0, 9);"
									   placeholder="가격을 입력해 주세요.">
							</div>
						</c:if>
					</div>

					<div class="menuForm menuFormCN" id="menuFormCN">
						<c:forEach var="menu" items="${data.facilityLangInfoCn.menuList}" varStatus="status">
							<div id="menuFormCN${fn:escapeXml(status.index)}">
								<input type="text" id="menuNameCN${fn:escapeXml(status.index)}" name="facilityLangInfoCn.menuList[${fn:escapeXml(status.index)}].name" maxlength="50"
									   value="${fn:escapeXml(menu.name)}" class="w300" autocomplete="off" onkeyup="setValidLang()"
									   placeholder="메뉴명을 입력해 주세요. (중문)">
								<input type="text" id="menuPriceCN${fn:escapeXml(status.index)}" name="facilityLangInfoCn.menuList[${fn:escapeXml(status.index)}].price"
									   value="${fn:escapeXml(menu.price)}" class="w150" autocomplete="off" onkeyup="setValidLang()" style="margin-left: 7.5px;"
									   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
												if (this.value.length > 9) this.value = this.value.slice(0, 9);"
									   placeholder="가격을 입력해 주세요.">
								<c:if test="${status.index != 0}">
									<button type="button" class="mot3 whiteBtn-round" onclick="removeMenuField(this)">-</button>
								</c:if>
							</div>
						</c:forEach>
						<c:if test="${empty data.facilityLangInfoCn.menuList}">
							<div id="menuFormCN0">
								<input type="text" id="menuNameCN0" name="facilityLangInfoCn.menuList[0].name" maxlength="50"
									   class="w300" autocomplete="off" onkeyup="setValidLang()"
									   placeholder="메뉴명을 입력해 주세요. (중문)">
								<input type="text" id="menuPriceCN0" name="facilityLangInfoCn.menuList[0].price"
									   class="w150" autocomplete="off" onkeyup="setValidLang()" style="margin-left: 7.5px;"
									   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
												if (this.value.length > 9) this.value = this.value.slice(0, 9);"
									   placeholder="가격을 입력해 주세요.">
							</div>
						</c:if>
					</div>

					<br>
					<%-- 추가 버튼 --%>
					<a type="button" href="javascript:void(0);" onclick="addMenuField();" class="mot3 whiteBtn-round">추가 +</a>
					<%-- // --%>
				</td>
			</tr>
			</tbody>
		</table>
	</div>

	<br>
	<br>
	<div class="pageSubTitle">추가 정보</div>

	<div class="detailBox" id="detailBoxDouble">
		<table style="margin-top: 15px;">
			<tbody id="businessHour">
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">영업시간</th>
				<td>
					&nbsp;
					<%-- 영업시간 ('공통' 에 라디오 버튼) --%>
					<input type="hidden" name="businessHoursTypeCommon">
					<c:if test="${isNew}">
						<input type="radio" id="businessHoursTypeCommon" name="businessHoursType"
							   value="${fn:escapeXml(businessHoursTypeCommon)}" checked/>
					</c:if>
					<c:if test="${not isNew}">
						<input type="radio" id="businessHoursTypeCommon" name="businessHoursType"
							   value="${fn:escapeXml(businessHoursTypeCommon)}" ${not empty data.businessHoursType and data.businessHoursType eq businessHoursTypeCommon ? 'checked' : '' } />
					</c:if>
					<label for="businessHoursTypeCommon">공통</label>
					<%-- // --%>

					<br>

					<%-- 영업시간 ('공통' 에 대한 레이아웃) --%>
					<div id="businessHoursTypeCommonLayout">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<jsp:include page="/include/component/dateTime.jsp" flush="false">
							<jsp:param name="hourName"	value="businessHoursCommonSH"/><jsp:param name="hourValue"	value="${data.BHCommonSH}"/>
							<jsp:param name="minName"	value="businessHoursCommonSM"/><jsp:param name="minValue"	value="${data.BHCommonSM}"/>
						</jsp:include>
						~
						<jsp:include page="/include/component/dateTime.jsp" flush="false">
							<jsp:param name="hourName"	value="businessHoursCommonEH"/><jsp:param name="hourValue"	value="${data.BHCommonEH}"/>
							<jsp:param name="minName"	value="businessHoursCommonEM"/><jsp:param name="minValue"	value="${data.BHCommonEM}"/>
						</jsp:include>
					</div>
					<%-- // --%>

					<br>

					&nbsp;
					<%-- 영업시간 ('평일 / 주말' 에 라디오 버튼) --%>
					<input type="hidden" name="businessHoursTypeWeekend">
					<input type="radio" id="businessHoursTypeWeekend" name="businessHoursType"
						   value="${fn:escapeXml(businessHoursTypeWeekend)}" ${not empty data.businessHoursType and data.businessHoursType eq businessHoursTypeWeekend ? 'checked' : '' } />
					<label for="businessHoursTypeWeekend">평일 / 주말</label>
					<%-- // --%>

					<br>

					<%-- 영업시간 ('평일 / 주말' 에 대한 레이아웃) --%>
					<div id="businessHoursTypeWeekendLayout">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a style="color:gray; font-size: 13px; line-height: 40px;">평일</a>
						<jsp:include page="/include/component/dateTime.jsp" flush="false">
							<jsp:param name="hourName"	value="businessHoursWeekdaySH"/><jsp:param name="hourValue"	value="${data.BHWeekdaySH}"/>
							<jsp:param name="minName"	value="businessHoursWeekdaySM"/><jsp:param name="minValue"	value="${data.BHWeekdaySM}"/>
						</jsp:include>
						~
						<jsp:include page="/include/component/dateTime.jsp" flush="false">
							<jsp:param name="hourName"	value="businessHoursWeekdayEH"/><jsp:param name="hourValue"	value="${data.BHWeekdayEH}"/>
							<jsp:param name="minName"	value="businessHoursWeekdayEM"/><jsp:param name="minValue"	value="${data.BHWeekdayEM}"/>
						</jsp:include>

						<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a style="color:gray; font-size: 13px; line-height: 40px;">주말</a>
						<jsp:include page="/include/component/dateTime.jsp" flush="false">
							<jsp:param name="hourName"	value="businessHoursWeekendSH"/><jsp:param name="hourValue"	value="${data.BHWeekendSH}"/>
							<jsp:param name="minName"	value="businessHoursWeekendSM"/><jsp:param name="minValue"	value="${data.BHWeekendSM}"/>
						</jsp:include>
						~
						<jsp:include page="/include/component/dateTime.jsp" flush="false">
							<jsp:param name="hourName"	value="businessHoursWeekendEH"/><jsp:param name="hourValue"	value="${data.BHWeekendEH}"/>
							<jsp:param name="minName"	value="businessHoursWeekendEM"/><jsp:param name="minValue"	value="${data.BHWeekendEM}"/>
						</jsp:include>
					</div>
					<%-- // --%>

					<br>

					&nbsp;
					<%-- 영업시간 ('별도 입력' 에 라디오 버튼) --%>
					<input type="hidden" name="businessHoursTypeExtra">
					<input type="radio" id="businessHoursTypeExtra" name="businessHoursType"
						   value="${fn:escapeXml(businessHoursTypeExtra)}" ${not empty data.businessHoursType and data.businessHoursType eq businessHoursTypeExtra ? 'checked' : '' } />
					<label for="businessHoursTypeExtra">별도 입력</label>
					<%-- // --%>

					<br>

					<%-- 영업시간 ('별도 입력' 에 대한 레이아웃) --%>
					<div id="businessHoursTypeExtraLayout">
						<div class="language-extra-tabs" style="padding-bottom: 4px;">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a type="button" class="mot3 lightBtn-round active" onclick="selectLanguageExtra('KO')">국문</a>
							<a type="button" class="mot3 lightBtn-round" onclick="selectLanguageExtra('EN')">영문</a>
							<a type="button" class="mot3 lightBtn-round" onclick="selectLanguageExtra('JP')">일문</a>
							<a type="button" class="mot3 lightBtn-round" onclick="selectLanguageExtra('CN')">중문</a>
						</div>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

						<input type="text" class="w450" id="businessHoursTextKo" name="businessHoursTextKo" maxlength="50"
							   value="${fn:escapeXml(data.businessHoursTextKo)}" autocomplate="off"
							   placeholder="(국문) 영업시간을 입력해 주세요. 시간은 00:00 ~ 00:00 형태로 입력해 주세요." style="display: inline-block;">
						<input type="text" class="w450" id="businessHoursTextEn" name="businessHoursTextEn" maxlength="50"
							   value="${fn:escapeXml(data.businessHoursTextEn)}" autocomplate="off"
							   placeholder="(영문) 영업시간을 입력해 주세요. 시간은 00:00 ~ 00:00 형태로 입력해 주세요." style="display: none;">
						<input type="text" class="w450" id="businessHoursTextJp" name="businessHoursTextJp" maxlength="50"
							   value="${fn:escapeXml(data.businessHoursTextJp)}" autocomplate="off"
							   placeholder="(일문) 영업시간을 입력해 주세요. 시간은 00:00 ~ 00:00 형태로 입력해 주세요." style="display: none;">
						<input type="text" class="w450" id="businessHoursTextCn" name="businessHoursTextCn" maxlength="50"
							   value="${fn:escapeXml(data.businessHoursTextCn)}" autocomplate="off"
							   placeholder="(중문) 영업시간을 입력해 주세요. 시간은 00:00 ~ 00:00 형태로 입력해 주세요." style="display: none;">
					</div>
					<%-- // --%>
				</td>
			</tr>

			<tr>
				<th colspan="${fn:escapeXml(colspan)}">대표전화</th>
				<td>
					<%-- 전화번호에 대한 레이아웃 --%>
					<div id="phoneNumberFrame">
						<input type="hidden" id="phoneNumber" name="phoneNumber" value="${fn:escapeXml(data.phoneNumber)}">
						<div id="phoneNumberContainer">
							<c:choose>
								<c:when test="${empty data.phoneNumberArrays}">
									<select name="phoneNumberPart1" class="phoneNumberElement0 w50" onchange="togglePhoneNumberInput(this)">
										<option value="" disabled selected>지역번호를 선택해주세요.</option>
										<option value="phoneNumberCustomSelect">직접 입력</option>
										<c:forEach items="${areaCodes}" var="item">
											<option value="${fn:escapeXml(item)}"><c:out value="${item}"/></option>
										</c:forEach>
									</select>

									<input type="text" name="phoneNumberPart1" class="phoneNumberElement0 w150" style="display:none;" placeholder="지역번호를 입력해주세요."
										   oninput="formatPhoneNumber1(this);">

									<a class="phoneNumberElement0">-</a>
									<input type="text" name="phoneNumberPart2" class="phoneNumberElement0 w50" autocomplete="off" placeholder="중간번호"
										   oninput="formatPhoneNumber2(this);">
									<a class="phoneNumberElement0">-</a>
									<input type="text" name="phoneNumberPart3" class="phoneNumberElement0 w50" autocomplete="off" placeholder="끝번호"
										   oninput="formatPhoneNumber3(this);">

									<br class="phoneNumberElement0">
								</c:when>
								<c:otherwise>
									<c:forEach items="${data.phoneNumberArrays}" var="nowPhoneNumber" varStatus="status">
										<c:set var="phoneNumberParts" value="${fn:split(nowPhoneNumber, '-')}"/>

										<select name="phoneNumberPart1" class="phoneNumberElement${fn:escapeXml(status.index)} w50" onchange="togglePhoneNumberInput(this)">
											<option value="" disabled selected>지역번호를 선택해주세요.</option>
											<option value="phoneNumberCustomSelect">직접 입력</option>
											<c:forEach items="${areaCodes}" var="item">
												<option value="${fn:escapeXml(item)}"
													${fn:length(phoneNumberParts) == 2 && item == ' ' ? 'selected' : ''}
													${fn:length(phoneNumberParts) == 3 && phoneNumberParts[0] == item ? 'selected' : ''}>
														${fn:escapeXml(item)}
												</option>
											</c:forEach>
										</select>

										<input type="text" name="phoneNumberPart1" class="phoneNumberElement${fn:escapeXml(status.index)} w150" style="display:none;" placeholder="지역번호를 입력해주세요."
												value="${fn:length(phoneNumberParts) == 3 ? phoneNumberParts[0] : ''}"
												oninput="formatPhoneNumber1(this);">

										<a class="phoneNumberElement${fn:escapeXml(status.index)}">-</a>
										<input type="text" name="phoneNumberPart2" class="phoneNumberElement${fn:escapeXml(status.index)} w50" autocomplete="off" placeholder="중간번호"
											   value="${fn:length(phoneNumberParts) == 2 ? phoneNumberParts[0] : fn:length(phoneNumberParts) == 3 ? phoneNumberParts[1] : ''}"
											   oninput="formatPhoneNumber2(this);">
										<a class="phoneNumberElement${fn:escapeXml(status.index)}">-</a>
										<input type="text" name="phoneNumberPart3" class="phoneNumberElement${fn:escapeXml(status.index)} w50" autocomplete="off" placeholder="끝번호"
											   value="${fn:length(phoneNumberParts) == 2 ? phoneNumberParts[1] : fn:length(phoneNumberParts) == 3 ? phoneNumberParts[2] : ''}"
											   oninput="formatPhoneNumber3(this);">

										<c:if test="${status.index != 0}">
											<a type="button" href="javascript:void(0);" class="phoneNumberElement${fn:escapeXml(status.index)} mot3 whiteBtn-round"
											   style="margin-left: 2px;"
											   onclick="removeElements(this, 'phoneNumberElement', basePhoneNumberElementsLength, dynamicPhoneNumberElementsLength);">-</a>
										</c:if>

										<br class="phoneNumberElement${fn:escapeXml(status.index)}">
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</div>
					</div>

					<br>
					<a type="button" href="javascript:void(0);" onclick="addPhoneNumberElements();" class="mot3 whiteBtn-round">추가 +</a>
					<%-- // --%>
				</td>
			</tr>

			<%-- 동적 컴포넌트 - 상세 이미지 --%>
            <tbody id="cardFrame">
			<c:choose>
				<c:when test="${empty data.detailImgList or data.detailImgList.size() < 1}">
					<tr class="imgType imgCard0">
						<input type="hidden" name="detailImgList[0].seq" value=""/>
						<th rowspan="2" colspan="${fn:escapeXml(colspan - 1)}">상세 이미지
							<br><br>
							<a type="button" href="javascript:addCard('imgType');" class="mot3 whiteBtn-round">추가 +</a>
						</th>

						<th>이미지</th>
						<td name="detailImgList[0].file">
							<div class="ment">이미지 파일 권장 사이즈는 <span class="red">1020px * 566px</span> 이고, <strong> .jpg, .gif, .png</strong> 파일에 한해 등록이 가능합니다.</div>
							<div class="ment">파일 용량은 <span class="red">5MB</span> 까지 등록이 가능합니다.</div>
							<div class="file_input_div">
								<input type="hidden" name="detailImgList[0].file.tag" value="DETAIL_IMG">
								<input type="hidden" name="detailImgList[0].file.fileId" value="">
								<input type="file" name="detailImgList[0].file.file" accept=".jpg, .gif, .png">
							</div>
						</td>
					</tr>

					<tr class="imgType imgCard0">
						<th>이미지 대체 텍스트</th>
						<td>
							<input type="text" name="detailImgList[0].fileAltTxtKo" class="w300" maxlength="200" style="display: inline-block"
								    autocomplete="off"
								   placeholder="대체 텍스트를 입력해 주세요. (국문)">
							<br>
							<input type="text" name="detailImgList[0].fileAltTxtEn" class="w300" maxlength="200" style="display: inline-block"
								    autocomplete="off"
								   placeholder="대체 텍스트를 입력해 주세요. (영문)">
							<br>
							<input type="text" name="detailImgList[0].fileAltTxtJp" class="w300" maxlength="200" style="display: inline-block"
								    autocomplete="off"
								   placeholder="대체 텍스트를 입력해 주세요. (일문)">
							<br>
							<input type="text" name="detailImgList[0].fileAltTxtCn" class="w300" maxlength="200" style="display: inline-block"
								    autocomplete="off"
								   placeholder="대체 텍스트를 입력해 주세요. (중문)">
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${data.detailImgList}" var="img" varStatus="status">
						<tr class="imgType imgCard${fn:escapeXml(status.index)}">
							<input type="hidden" name="detailImgList[${fn:escapeXml(status.index)}].seq" value="${fn:escapeXml(img.seq)}"/>
							<th rowspan="2" colspan="${fn:escapeXml(colspan - 1)}"><br>상세 이미지
								<br><br>
								<a type="button" href="javascript:addCard('imgType');" class="mot3 whiteBtn-round">추가 +</a>
								<c:if test="${status.index > 0}">
									<br>
									<a type="button" href="#" onclick="deleteCard(this, 'img', event);"
									   class="mot3 whiteBtn-round">삭제 -</a>
								</c:if>
								<br><br>
							</th>

							<th>이미지</th>
							<td name="detailImgList[${fn:escapeXml(status.index)}].file">
								<c:set var="attach" value="${img.file}" scope="request"/>
								<jsp:include page="/include/component/fileUpload.jsp">
									<jsp:param name="t_ment" value="<%=image(1020, 566)%>"/>
									<jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
									<jsp:param name="t_required" value="false"/>
									<jsp:param name="t_fileName" value="detailImgList[${fn:escapeXml(status.index)}].file"/>
									<jsp:param name="t_tag" value="DETAIL_IMG"/>
									<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
								</jsp:include>
							</td>
						</tr>

						<tr class="imgType imgCard${fn:escapeXml(status.index)}">
							<th>이미지 대체 텍스트</th>
							<td>
								<input type="text" name="detailImgList[${fn:escapeXml(status.index)}].fileAltTxtKo" class="w300" maxlength="200" style="display: inline-block"
									   value="${fn:escapeXml(img.fileAltTxtKo)}" autocomplete="off"
									   placeholder="대체 텍스트를 입력해 주세요. (국문)">
								<br>
								<input type="text" name="detailImgList[${fn:escapeXml(status.index)}].fileAltTxtEn" class="w300" maxlength="200" style="display: inline-block"
									   value="${fn:escapeXml(img.fileAltTxtEn)}" autocomplete="off"
									   placeholder="대체 텍스트를 입력해 주세요. (영문)">
								<br>
								<input type="text" name="detailImgList[${fn:escapeXml(status.index)}].fileAltTxtJp" class="w300" maxlength="200" style="display: inline-block"
									   value="${fn:escapeXml(img.fileAltTxtJp)}" autocomplete="off"
									   placeholder="대체 텍스트를 입력해 주세요. (일문)">
								<br>
								<input type="text" name="detailImgList[${fn:escapeXml(status.index)}].fileAltTxtCn" class="w300" maxlength="200" style="display: inline-block"
									   value="${fn:escapeXml(img.fileAltTxtCn)}" autocomplete="off"
									   placeholder="대체 텍스트를 입력해 주세요. (중문)">
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
			</tbody>

            <tbody>
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">홈페이지</th>
				<td>
					<input type="text" id="pageUrl" name="pageUrl" value="${fn:escapeXml(data.pageUrl)}" class="w300" maxlength="100"
						   autocomplete="off"
						   placeholder="해당 매장 및 시설의 홈페이지 URL 을 입력해 주세요.">
				</td>
			</tr>

			<tr>
				<th colspan="${fn:escapeXml(colspan)}">MIMS<br>브랜드코드</th>
				<td>
					<input type="text" id="mimsBrandCode" name="mimsBrandCode" value="${fn:escapeXml(data.mimsBrandCode)}"
						   class="w300" maxlength="50" autocomplete="off"
						   placeholder="MIMS 브랜드코드를 입력해 주세요. (50자 이내)">
				</td>
			</tr>
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">영통<br>브랜드코드</th>
				<td>
					<input type="text" id="ltdsBrandCode" name="ltdsBrandCode"
						   value="${fn:escapeXml(data.ltdsBrandCode)}" class="w300" maxlength="7" autocomplete="off"
						   placeholder="영통 브랜드코드를 입력해 주세요. (7자리)">
				</td>
			</tr>
			<tr>
				<th colspan="${fn:escapeXml(colspan)}">영통<br>품번코드</th>
				<td>
					<input type="text" id="ltdsItemCode" name="ltdsItemCode"
						   value="${fn:escapeXml(data.ltdsItemCode)}" class="w300" maxlength="50" autocomplete="off"
						   placeholder="영통 품번코드를 입력해 주세요. (50자 이내)">
				</td>
			</tr>

			<tr>
				<th required colspan="${fn:escapeXml(colspan)}">공개여부</th>
				<td>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="useY" name="useYn" value="Y" checked/>
						<label for="useY">공개</label>
						<input type="radio" id="useN" name="useYn" value="N" />
						<label for="useN">비공개</label>
					</c:if>
					<c:if test="${not isNew}">
						<input type="radio" id="useY" name="useYn"
							   value="Y" ${data.useYn == 'Y' ? 'checked' : '' } />
						<label for="useY">공개</label>
						<input type="radio" id="useN" name="useYn"
							   value="N" ${data.useYn == 'N' ? 'checked' : '' } />
						<label for="useN">비공개</label>
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
	</div>

</form>

<%--######################## 스크립트 ########################--%>
<script src="${fn:escapeXml(cPath)}/assets/js/detail.js" charset="utf-8" type="text/javascript"></script>

<script>
	let largeCodeTypeList = ${largeCodeTypeList == null ? [] : gson.toJson(largeCodeTypeList)};
	let middleCodeTypeList = ${middleCodeTypeList == null ? [] : gson.toJson(middleCodeTypeList)};
	let smallCodeTypeList = ${smallCodeTypeList == null ? [] : gson.toJson(smallCodeTypeList)};
	let floorList = ${affiliateFloors == null ? [] : gson.toJson(affiliateFloors)};

	let categories = document.getElementById('categories');

	const thumbImg = document.querySelector('input[name="thumbImg.file.file"]');
	let isThumbImg = false;

	// 최초 페이지 로딩 시
	window.onload = function() {
		setImageChangeListener();
		applyValidationToUploadedImage();
		selectLanguageExtra('KO');
		selectLanguage('KO');
		checkCategoryForMenus();
		checkCategoryForShopAndFnB();
		convertToEmptyMenuPrice();
		setDefaultBusinessHoursForCommon('10', '30', '22', '0');	// 영업시간 (공통) 의 기본값 설정
		initializePhoneNumberFields();
	};
</script>

<script>	/* 게시글 저장 시 전처리 */
	function goToSave() {
		if (!saveCodeType()) {
			return;
		}
		if (!isValidMenu()) {
			return;
		}

		convertToNumberMenuPrice();
		combineFloorAndPOIForSubmission();
		combineBusinessHoursTextForSubmission();
		combinePhoneNumbersForSubmission();
		submitFormIntoHiddenFrame(document.workForm);
		convertToEmptyMenuPrice();
	}
</script>

<script>
	function setDefaultBusinessHoursForCommon(startHour, startMin, endHour, endMin) {
		let SH = document.querySelector('select[name="businessHoursCommonSH"]');
		let SM = document.querySelector('select[name="businessHoursCommonSM"]');
		let EH = document.querySelector('select[name="businessHoursCommonEH"]');
		let EM = document.querySelector('select[name="businessHoursCommonEM"]');

		if (SH?.value === '0' && SM?.value === '0' && EH?.value === '0' && EM?.value === '0') {
			document.querySelector('select[name="businessHoursCommonSH"]').value = startHour;
			document.querySelector('select[name="businessHoursCommonSM"]').value = startMin;
			document.querySelector('select[name="businessHoursCommonEH"]').value = endHour;
			document.querySelector('select[name="businessHoursCommonEM"]').value = endMin;
		}
	}
</script>

<script>	/* 이미지 업로드에 대한 Validation */
	function applyValidationToUploadedImage() {
		const uploadedThumbImg = document.querySelector('input[name="thumbImg.file.fileId"]');
		if (uploadedThumbImg.value.trim()) {
			isThumbImg = true;
		}
	}

	function setImageChangeListener() {
		thumbImg.addEventListener('change', function() {
			isThumbImg = true;
			setValidLang();
		});
	}
</script>

<script>
	function convertToEmptyMenuPrice() {
		const priceInputs = document.querySelectorAll('input[id^=menuPrice]');
		for (let i = 0; i < priceInputs.length; i++) {
			const price = priceInputs[i];
			if (price.value === '0') {
				price.value = '';
			}
		}
	}

	function convertToNumberMenuPrice() {
		const priceInputs = document.querySelectorAll('input[id^=menuPrice]');
		for (let i = 0; i < priceInputs.length; i++) {
			const price = priceInputs[i];
			if (price.value === '') {
				price.value = '0';
			}
		}
	}

	function isValidMenu() {
		const languages = ['KO', 'EN', 'JP', 'CN'];

		for (const lang of languages) {
			const menuInputs = document.querySelectorAll(`input[id^=menuName` + lang + `]`);
			const priceInputs = document.querySelectorAll(`input[id^=menuPrice` + lang + `]`);

			for (let i = 0; i < menuInputs.length; i++) {
				const menu = menuInputs[i];
				const price = priceInputs[i];

				// 첫 번째 메뉴의 경우, 모두 입력하지 않거나 모두 입력해야 유효
				if (i === 0) {
					if (menu.value.trim() === '' && price.value.trim() !== '') {
						alert('메뉴명을 입력해주세요. (' + lang + ')');
						return false;
					}
				}

				if (i > 0) {
					if (menu.value.trim() === '') {
						alert('메뉴명을 입력해주세요. (' + lang + ')');
						return false;
					}
				}
			}
		}

		return true;
	}

	function isFiledMenuName(lang) {
		const menuInputs = document.querySelectorAll(`input[id^=menuName` + lang + `]`);
		for (let i = 0; i < menuInputs.length; i++) {
			if (menuInputs[i].value) {
				return true;
			}
		}

		return false;
	}
</script>

<script>
	function combineFloorAndPOIForSubmission() {
		let floorSelects = document.getElementsByName('floorSelect');
		let selectedFloors = [];
		let poiSelects = document.querySelectorAll('input[type="text"][name^="poiSelect"]');
		let selectedPois = [];
		let poiSelectFloorNames = document.querySelectorAll('input[type="hidden"][name^="poiSelectFloorName"]');

		for (let i = 0, j = 0; i < floorSelects.length; i++) {
			let selectedFloorValue = floorSelects[i].value;
			if (selectedFloorValue) {
				selectedFloors.push(selectedFloorValue);

				if (j < poiSelects.length) {
					let selectedPoiValue = poiSelects[j].value;
					let selectedPoiFloorNameValue = poiSelectFloorNames[j].value;
					if (selectedPoiFloorNameValue === selectedFloorValue) {
						selectedPois.push(selectedPoiValue);
						j++;
						continue;
					}
				}

				selectedPois.push('');
				j++;
			}
		}

		document.getElementById('affiliateFloor').value = selectedFloors.join(',');
		document.getElementById('poiId').value = selectedPois.join(',');
	}
</script>

<script>	/* 층정보 (+ 다비오 POI ID) 폼 추가 삭제 관련 */
	let floorIndex = 1; 		// 층정보 인덱스 초기값
	let maxFloorCount = 3;

	function clearInputForPOI(inputElement) {
    	inputElement.value = '';
	}

	function addFloorField() {
		floorIndex = getIndexFloorFields() + 1;
		if (floorIndex >= maxFloorCount) {
			alert("층 정보는 최대 " + maxFloorCount + "개까지만 추가할 수 있습니다.");
			return;
		}

		let container = document.getElementById('floorContainer');
		let row = document.createElement('div');
		row.classList.add('floorRow');

		let floorOptions = generateOptionsForFloor(floorList);

		row.innerHTML = `
            <div id="floor` + floorIndex + `">
                <select name="floorSelect">
                    <option value="" disabled selected>층을 선택해 주세요.</option>
                    ` + floorOptions + `
                </select>
                <div style="display: inline-flex">
                    <label style="font-size: 14px;"><b>다비오 위치 ID</b></label>
                    <input type="text" name="poiSelect` + floorIndex + `" class="w200" autocomplete="off" onclick="clearInputForPOI(this)" readonly style="background-color: #f0f0f0; color: #999; border: 1px solid #ddd;">
					<input type="hidden" name="poiSelectFloorName` + floorIndex + `" class="w200">
                </div>

				<a type="button" name="poiSelectBtn` + floorIndex + `" class="mot3 lightBtn-round" onclick="addPOI(this, ` + floorIndex + `)">+</a>
                <button type="button" class="mot3 whiteBtn-round" onclick="removeFloorField(this)">-</button>
            </div>
        `;

		container.appendChild(row);
		floorIndex++;
	}

	function removeFloorFields() {
		let floorContainer = document.getElementById('floorContainer');
		if (floorContainer.children.length > 0) {
			let rows = floorContainer.getElementsByClassName('floorRow');
			if (rows.length > 1) {
				for (let i = 1; i < rows.length; i++) {
					rows[i].remove();
					adjustIndexFloorFields();
					i = 0;
				}
			}
		}
	}

	function removeFloorField(button) {
		let container = document.getElementById('floorContainer');
		if (container.children.length > 0) {
			let row = button.parentNode.parentNode;
			row.remove();
			adjustIndexFloorFields();
		}
	}

	function getIndexFloorFields() {
		let container = document.getElementById('floorContainer');
		let rows = container.getElementsByClassName('floorRow');
		return rows.length - 1;
	}

	function adjustIndexFloorFields() {
		let container = document.getElementById('floorContainer');
		let rows = container.getElementsByClassName('floorRow');

		for (let i = 0; i < rows.length; i++) {
			let floor = rows[i].querySelector('div[id^="floor"]');
			let poi = rows[i].querySelector('input[name^="poiSelect"]');
			let poiFloorName = rows[i].querySelector('input[name^="poiSelectFloorName"]');
			let addPoiButton = rows[i].querySelector('a[name^="poiSelectBtn"]');

			floor.id = 'floor' + i;
			poi.name = 'poiSelect' + i;
			poiFloorName.name = 'poiSelectFloorName' + i;
			addPoiButton.name = 'poiSelectBtn' + i;
       	 	addPoiButton.setAttribute('onclick', 'addPOI(this, ' + i + ')');
		}
	}

	function generateOptionsForFloor(itemList) {
		return itemList.map(function (item) {
			return `<option value="` + item + `">` + item + `</option>`;
		}).join('');
	}
</script>

<script>	/* 카테고리 폼 추가 삭제 관련 */
	let categoryIndex = 1; 		// 카테고리 인덱스 초기값
	let maxCategoryCount = 3;

	function includeCategoryShopAndFnB(codeTypeList) {
		return codeTypeList.filter(item => item.codeType.includes('L000') || item.codeType.includes('L001'));
	}

	function addCategoryField() {
		categoryIndex = getIndexCategoryFields() + 1;
		if (categoryIndex >= maxCategoryCount) {
			alert("카테고리는 최대 " + maxCategoryCount + "개까지만 추가할 수 있습니다.");
			return;
		}

		let container = document.getElementById('categoryContainer');
		let newCategoryRow = document.createElement('div');
		newCategoryRow.classList.add('categoryRow');

		let largeOptions = generateOptionsForCategory(includeCategoryShopAndFnB(largeCodeTypeList));
		let middleOptions = generateOptionsForCategory(includeCategoryShopAndFnB(middleCodeTypeList));
		let smallOptions = generateOptionsForCategory(includeCategoryShopAndFnB(smallCodeTypeList));

		let newCategoryHTML = `
				<select id="categoryLarge` + categoryIndex + `" name="categoryLarge[` + categoryIndex + `]" onchange="selectHighCodeType(this, 'L', ` + categoryIndex + `);">
					<option value="" disabled selected>대분류</option>
					`+ largeOptions + `
				</select>

				<select id="categoryMiddle` + categoryIndex + `" name="categoryMiddle[` + categoryIndex + `]" onchange="selectHighCodeType(this, 'M', ` + categoryIndex + `);">
					<option value="" disabled selected>중분류</option>
				</select>

				<select id="categorySmall` + categoryIndex + `" name="categorySmall[` + categoryIndex + `]" onchange="selectHighCodeType(this, 'S', ` + categoryIndex + `);">
					<option value="" disabled selected>소분류</option>
				</select>

        		<button type="button" onclick="removeCategoryField(this)" class="mot3 whiteBtn-round" style="margin-left: 5px; margin-top: 0px;">-</button>
			`;

		newCategoryRow.innerHTML = newCategoryHTML;
		container.appendChild(newCategoryRow);
		categoryIndex++;
	}

	function removeCategoryFields() {
		let categoryContainer = document.getElementById('categoryContainer');
		if (categoryContainer.children.length > 0) {
			let categoryRows = categoryContainer.getElementsByClassName('categoryRow');
			if (categoryRows.length > 1) {
				for (let i = 1; i < categoryRows.length; i++) {
					categoryRows[i].remove();
					adjustIndexCategoryFields();
					i = 0;
				}
			}
		}
	}

	function removeCategoryField(button) {
		let categoryContainer = document.getElementById('categoryContainer');
		if (categoryContainer.children.length > 0) {
			let categoryRow = button.parentNode;
			categoryRow.remove();
			adjustIndexCategoryFields();
		}
	}

	function getIndexCategoryFields() {
		let container = document.getElementById('categoryContainer');
		let categoryRows = container.getElementsByClassName('categoryRow');
		return categoryRows.length - 1;
	}

	function adjustIndexCategoryFields() {
		let container = document.getElementById('categoryContainer');
		let categoryRows = container.getElementsByClassName('categoryRow');

		for (let i = 0; i < categoryRows.length; i++) {
			let categoryLarge = categoryRows[i].querySelector('[id^="categoryLarge"]');
			let categoryMiddle = categoryRows[i].querySelector('[id^="categoryMiddle"]');
			let categorySmall = categoryRows[i].querySelector('[id^="categorySmall"]');

			categoryLarge.id = 'categoryLarge' + i;
			categoryMiddle.id = 'categoryMiddle' + i;
			categorySmall.id = 'categorySmall' + i;

			categoryLarge.name = 'categoryLarge[' + i + ']';
			categoryMiddle.name = 'categoryMiddle[' + i + ']';
			categorySmall.name = 'categorySmall[' + i + ']';

			categoryLarge.setAttribute('onchange', `selectHighCodeType(this, 'L', ` + i + `);`);
			categoryMiddle.setAttribute('onchange', `selectHighCodeType(this, 'M', ` + i + `);`);
			categorySmall.setAttribute('onchange', `selectHighCodeType(this, 'S', ` + i + `);`);
		}
	}

	function containsFnB(select, index) {
		let selectedOption = select.options[select.selectedIndex];
		let selectedIndex = select.id.match(/\d+/)[0];

		if (selectedOption && selectedIndex === String(index)) {
			if (selectedOption.text.includes('F&B')) {
				return true;
			}
		}

		return false;
	}

	function containsShopAndFnB(select, index) {
		let selectedOption = select.options[select.selectedIndex];
		let selectedIndex = select.id.match(/\d+/)[0];

		if (selectedOption && selectedIndex === String(index)) {
			if (isCategoryShopAndFnBByName(selectedOption.text)) {
				return true;
			}
		}

		return false;
	}

	function checkCategoryForThumbImgs() {
		let categoryLargeSelects = document.querySelectorAll('select[id^="categoryLarge"]');

		unselectLanguageThumbImg();

		for (let i = 0; i < categoryLargeSelects.length; i++) {
			if (!containsShopAndFnB(categoryLargeSelects[i], i)) {
				return false;
			}
		}

		selectLanguageThumbImg();
		return true;
	}

	function addMessageForFnBCategory(element) {
		const messageDiv = document.createElement('div');
		messageDiv.textContent = "F&B 매장 선택 등록 시, 중분류를 '기타' 로 설정 부탁드립니다.";
		messageDiv.style.fontStyle = 'bold';
		messageDiv.id = 'msgForFnBCategory';

		element.parentNode.appendChild(messageDiv);
	}

	function clearMessageForFnBCategory() {
		const messageDiv = document.getElementById('msgForFnBCategory');
		if (messageDiv) {
			messageDiv.remove();
		}
	}

	function checkCategoryForMenus() {
		let categoryLargeSelects = document.querySelectorAll('select[id^="categoryLarge"]');
		let categoryMiddleSelects = document.querySelectorAll('select[id^="categoryMiddle"]');
		let categorySmallSelects = document.querySelectorAll('select[id^="categorySmall"]');

		unselectLanguageMenu();
		// clearMessageForFnBCategory();

		for (let i = 0; i < categoryLargeSelects.length; i++) {
			if (containsFnB(categoryLargeSelects[i], i)) {
				selectLanguageMenu(selectedLang);
				// addMessageForFnBCategory(categoryLargeSelects[i]);
			}
		}

		for (let i = 0; i < categoryMiddleSelects.length; i++) {
			if (containsFnB(categoryMiddleSelects[i], i)) {
				selectLanguageMenu(selectedLang);
			}
		}

		for (let i = 0; i < categorySmallSelects.length; i++) {
			if (containsFnB(categorySmallSelects[i], i)) {
				selectLanguageMenu(selectedLang);
			}
		}
	}

	function checkCategoryForMenu(index) {
		let categoryLargeSelect = document.getElementById('categoryLarge' + index);
		let categoryMiddleSelect = document.getElementById('categoryMiddle' + index);
		let categorySmallSelect = document.getElementById('categorySmall' + index);

		unselectLanguageMenu();

		if (containsFnB(categoryLargeSelect, index)) {
			selectLanguageMenu(selectedLang);
		}

		if (containsFnB(categoryMiddleSelect, index)) {
			selectLanguageMenu(selectedLang);
		}

		if (containsFnB(categorySmallSelect, index)) {
			selectLanguageMenu(selectedLang);
		}
	}

	function generateOptionsForCategory(itemList) {
		return itemList.map(function (item) {
			return `<option value="` + item.codeType + `">` + item.codeTypeNameKo + `</option>`;
		}).join('');
	}

	// '매장' 또는 'F&B' 카테고리인지 확인하는 함수 (이름으로 확인. 예: "매장")
	function isCategoryShopAndFnBByName(codeTypeNameKo) {
		return !!(codeTypeNameKo.includes('매장') || codeTypeNameKo.includes('F&B'));
	}

	// '매장' 또는 'F&B' 카테고리인지 확인하는 함수 (코드 타입으로 확인. 예: "L000")
	function isCategoryShopAndFnBByCodeType(codeType) {
		return !!(codeType.includes('L000') || codeType.includes('L001'));
	}

	function selectHighCodeType(element, category, index) {
		if (category === 'L') {
			// 중분류 셀렉트박스 활성화 및 데이터 추가 & 소분류는 disable 처리
			let middleSelect = document.getElementById('categoryMiddle' + index);
			middleSelect.disabled = true;
			middleSelect.innerHTML = `<option value="" disabled selected>중분류</option>`;
			middleSelect.disabled = false;
			if (element.value) {
                middleSelect.innerHTML += generateOptionsForCategory(middleCodeTypeList.filter(item => item.codeType.startsWith(element.value)));
            }

			let smallSelect = document.getElementById('categorySmall' + index);
			smallSelect.innerHTML = `<option value="" disabled selected>소분류</option>`;
		}

		if (category === 'M') {
			// 소분류 셀렉트박스 활성화 및 데이터 추가
			let smallSelect = document.getElementById('categorySmall' + index);
			smallSelect.disabled = true;
			smallSelect.innerHTML = `<option value="" disabled selected>소분류</option>`;
			smallSelect.disabled = false;
			if (element.value) {
                smallSelect.innerHTML += generateOptionsForCategory(smallCodeTypeList.filter(item => item.codeType.startsWith(element.value)));
            }
		}

		checkCategoryForMenus();
		checkCategoryForShopAndFnB();

		setValidLang();
	}

	// 카테고리가 '매장', 'F&B' 에 해당하는 경우, 사용
	function checkCategoryForShopAndFnB() {
		if (checkCategoryForThumbImgs()) {
			// 카테고리 추가 버튼 elment
			let categoryAddBtnBrElement = document.getElementById('categoryAddBtnBr');
			let categoryAddBtnElement = document.getElementById('categoryAddBtn');
			categoryAddBtnBrElement.style.display = 'inline-block';
			categoryAddBtnElement.style.display = 'inline-block';

			// 층정보 추가 버튼 elment
			let floorAddBtnBrElement = document.getElementById('floorAddBtnBr');
			let floorAddBtnElement = document.getElementById('floorAddBtn');
			floorAddBtnBrElement.style.display = 'inline-block';
			floorAddBtnElement.style.display = 'inline-block';
		} else {
			let categoryAddBtnBrElement = document.getElementById('categoryAddBtnBr');
			let categoryAddBtnElement = document.getElementById('categoryAddBtn');
			categoryAddBtnBrElement.style.display = 'none';
			categoryAddBtnElement.style.display = 'none';

			let floorAddBtnBrElement = document.getElementById('floorAddBtnBr');
			let floorAddBtnElement = document.getElementById('floorAddBtn');
			floorAddBtnBrElement.style.display = 'none';
			floorAddBtnElement.style.display = 'none';

			removeCategoryFields();
			removeFloorFields();
		}
	}

	function saveCodeType() {
		let container = document.getElementById('categoryContainer');
		let categoryRows = container.getElementsByClassName('categoryRow');

		let codeTypeValues = [];
		let specificCodeTypeNameKoList = [];
		let codeTypeNameKo = '';

		let nowRowIndex = 0;
		for (let row of categoryRows) {
			let largeSelect = row.querySelector('[id^="categoryLarge"]');
			let middleSelect = row.querySelector('[id^="categoryMiddle"]');
			let smallSelect = row.querySelector('[id^="categorySmall"]');

			const middleSelectedText = middleSelect.selectedOptions[0].textContent;
			if (middleSelect.options.length > 1 && middleSelectedText === '중분류') {
				alert('중분류를 선택해주세요.');
				return false;
			}

			const smallSelectedText = smallSelect.selectedOptions[0].textContent;
			if (smallSelect.options.length > 1 && smallSelectedText === '소분류') {
				alert('소분류를 선택해주세요.');
				return false;
			}

			let codeTypeValue = '';
			if (largeSelect.value && middleSelect.value && smallSelect.value) {
				codeTypeValue = smallSelect.value;
				codeTypeValues.push(codeTypeValue);
				codeTypeNameKo = setSpecificCodeTypeNameKo(largeSelect.selectedOptions[0].innerText);
			} else if (largeSelect.value && middleSelect.value) {
				codeTypeValue = middleSelect.value;
				codeTypeValues.push(codeTypeValue);
				codeTypeNameKo = setSpecificCodeTypeNameKo(largeSelect.selectedOptions[0].innerText);
			} else if (largeSelect.value) {
				codeTypeValue = largeSelect.value;
				codeTypeValues.push(codeTypeValue);
				codeTypeNameKo = setSpecificCodeTypeNameKo(largeSelect.selectedOptions[0].innerText);
			}

			specificCodeTypeNameKoList.push(codeTypeNameKo);

			nowRowIndex++;
		}

		document.getElementById('codeType').value = codeTypeValues.join(',');
		document.getElementById('specificCodeTypeNameKo').value = specificCodeTypeNameKoList.join(',');
		return true;
	}

	// 특정 카테고리인 경우, Validation 처리를 위해 국문명을 저장
	function setSpecificCodeTypeNameKo(codeTypeNameKo) {
		if (codeTypeNameKo.includes('매장') || codeTypeNameKo.includes('F&B')) {
			return codeTypeNameKo;
		}
	}
</script>

<script>
	function combineBusinessHoursTextForSubmission() {
		let radioButton = document.getElementById('businessHoursTypeExtra');
		if (!radioButton.checked) {
			return;
		}

		let businessHoursTextKoElement = document.getElementById('businessHoursTextKo');
		let businessHoursTextEnElement = document.getElementById('businessHoursTextEn');
		let businessHoursTextJpElement = document.getElementById('businessHoursTextJp');
		let businessHoursTextCnElement = document.getElementById('businessHoursTextCn');

		// 여기에 추가적으로 필요한 처리가 있다면 추가
		let businessHoursTextKo = businessHoursTextKoElement.value.trim();
		let businessHoursTextEn = businessHoursTextEnElement.value.trim();
		let businessHoursTextJp = businessHoursTextJpElement.value.trim();
		let businessHoursTextCn = businessHoursTextCnElement.value.trim();

		businessHoursTextKo = businessHoursTextKo ? businessHoursTextKo : null;
		businessHoursTextEn = businessHoursTextEn ? businessHoursTextEn : null;
		businessHoursTextJp = businessHoursTextJp ? businessHoursTextJp : null;
		businessHoursTextCn = businessHoursTextCn ? businessHoursTextCn : null;

		businessHoursTextKoElement.value = businessHoursTextKo;
		businessHoursTextEnElement.value = businessHoursTextEn;
		businessHoursTextJpElement.value = businessHoursTextJp;
		businessHoursTextCnElement.value = businessHoursTextCn;
	}
</script>

<script>	/* 다국어 영업 시간 (businessHoursType) 관련 */
	let selectedLanguage = 'KO';

	function selectLanguageExtra(language) {
		selectedLanguage = language;

		// 선택된 언어와 관련된 입력 필드 및 인접한 span.length 를 모두 숨김
		let inputField;
		switch (selectedLanguage) {
			case 'KO':
				inputField = document.getElementById('businessHoursTextKo');
				break;
			case 'EN':
				inputField = document.getElementById('businessHoursTextEn');
				break;
			case 'JP':
				inputField = document.getElementById('businessHoursTextJp');
				break;
			case 'CN':
				inputField = document.getElementById('businessHoursTextCn');
				break;
		}

		if (inputField) {
			// 모든 언어 입력 필드를 숨기기
			['Ko', 'En', 'Jp', 'Cn'].forEach(function (lang) {
				let field = document.getElementById('businessHoursText' + lang);
				if (field) {
					field.style.display = 'none';
					let span = field.nextElementSibling;
					if (span && span.classList.contains('length')) {
						span.style.display = 'none';
					}
				}
			});

			// 선택된 언어의 입력 필드만 표시
			inputField.style.display = 'inline-block';
			let lengthSpan = inputField.nextElementSibling;
			if (lengthSpan && lengthSpan.classList.contains('length')) {
				lengthSpan.style.display = 'inline-block';
			}
		}

		// 버튼 상태 업데이트
		document.querySelectorAll('.language-extra-tabs a').forEach(function(btn) {
			btn.classList.remove('active');
		});
		document.querySelector('.language-extra-tabs a[onclick="selectLanguageExtra(\'' + language + '\')"]').classList.add('active');
	}

	function switchBusinessHoursType(value) {
		if (value === '${fn:escapeXml(businessHoursTypeCommon)}') {
			document.querySelectorAll('.businessHoursTypeCommon').forEach(function (element) {
				element.disabled = false;
			});
			document.querySelectorAll('.businessHoursTypeWeekend').forEach(function (element) {
				element.disabled = true;
			});
			document.querySelectorAll('.businessHoursTypeExtra').forEach(function (element) {
				element.disabled = true;
			});
		} else if (value === '${fn:escapeXml(businessHoursTypeWeekend)}') {
			document.querySelectorAll('.businessHoursTypeWeekend').forEach(function (element) {
				element.disabled = false;
			});
			document.querySelectorAll('.businessHoursTypeCommon').forEach(function (element) {
				element.disabled = true;
			});
			document.querySelectorAll('.businessHoursTypeExtra').forEach(function (element) {
				element.disabled = true;
			});
		} else if (value === '${fn:escapeXml(businessHoursTypeExtra)}') {
			document.querySelectorAll('.businessHoursTypeExtra').forEach(function (element) {
				element.disabled = false;
			});
			document.querySelectorAll('.businessHoursTypeCommon').forEach(function (element) {
				element.disabled = true;
			});
			document.querySelectorAll('.businessHoursTypeWeekend').forEach(function (element) {
				element.disabled = true;
			});
		}
	}

	// 각 항목을 클릭하면 실행
	document.querySelectorAll('input[type="radio"][name="businessHoursType"]').forEach(function (radio) {
		radio.addEventListener('change', function () {
			switchBusinessHoursType(radio.value);
		});
	});

	// detail 페이지 로딩 후 실행
	document.querySelectorAll('input[type="radio"][name="businessHoursType"]').forEach(function (radio) {
		if (radio.checked) {
			switchBusinessHoursType(radio.value);
		}
	});
</script>

<script>
	function initializePhoneNumberFields() {
		const phoneSelects = document.querySelectorAll('select[name="phoneNumberPart1"]');
		const phoneSelects2 = document.querySelectorAll('input[name="phoneNumberPart2"]');
		const phoneSelects3 = document.querySelectorAll('input[name="phoneNumberPart3"]');
		const phoneInputs = document.querySelectorAll('input[name="phoneNumberPart1"]');

		phoneSelects.forEach((select, index) => {
			const selectedOption = select.options[select.selectedIndex];

        	if (phoneSelects2[index] && phoneSelects2[index].value && phoneSelects3[index] && phoneSelects3[index].value
					&& (!selectedOption || selectedOption.value === "" || selectedOption.value === "phoneNumberCustomSelect"))	{
				select.style.display = 'none';
				phoneInputs[index].style.display = 'inline';
			} else {
				select.style.display = 'inline';
				phoneInputs[index].style.display = 'none';
			}
		});
	}

    function togglePhoneNumberInput(selectElement) {
		const elementIndex = selectElement.className.match(/phoneNumberElement(\d+)/)[1];
		const inputElement = document.querySelector(`input[name="phoneNumberPart1"].phoneNumberElement` + elementIndex);

		if (selectElement.value === "phoneNumberCustomSelect") {
			selectElement.style.display = "none";
			inputElement.style.display = "inline";
		} else {
			selectElement.style.display = "inline";
			inputElement.style.display = "none";
		}
    }
</script>

<script>	/* 전화번호 형식 유효성 검사 관련 함수 */
	// 숫자를 제외한 다른 문자를 허용하지 않음
	const formatPhoneNumber1 = (target) => {
		if (target.value.length > 3) {
			target.value = target.value.substring(0, 3);
		}
		target.value = target.value.replace(/[^0-9]/g, '');
	};
	const formatPhoneNumber2 = (target) => {
		if (target.value.length > 4) {
			target.value = target.value.substring(0, 4);
		}
		target.value = target.value.replace(/[^0-9]/g, '');
	};
	const formatPhoneNumber3 = (target) => {
		if (target.value.length > 4) {
			target.value = target.value.substring(0, 4);
		}
		target.value = target.value.replace(/[^0-9]/g, '');
	};

	function combinePhoneNumbersForSubmission() {
		const phoneNumbersPart1 = document.querySelectorAll('select[name="phoneNumberPart1"]');
		const phoneNumbersPart1ForCustom = document.querySelectorAll('input[name="phoneNumberPart1"]');

		const phoneNumbersPart2 = document.querySelectorAll('input[name="phoneNumberPart2"]');
		const phoneNumbersPart3 = document.querySelectorAll('input[name="phoneNumberPart3"]');

		const phoneNumbersArrays = [];

		for (let i = 0; i < phoneNumbersPart1.length; i++) {
			let part1;
			if (phoneNumbersPart1[i].style.display === "none") {
				part1 = phoneNumbersPart1ForCustom[i].value;
			} else {
				part1 = phoneNumbersPart1[i].value;
			}

			const part2 = phoneNumbersPart2[i].value;
			const part3 = phoneNumbersPart3[i].value;

			if (part1 === ' ') {
				phoneNumbersArrays.push(part2 + '-' + part3);
				continue;
			}

			phoneNumbersArrays.push(part1 + '-' + part2 + '-' + part3);
		}

		document.getElementById('phoneNumber').value = phoneNumbersArrays.join(',');
	}
</script>

<script>    /* 동적 컴포넌트 (예: 추가, 삭제 버튼을 통해 개수가 변화하는 UI) 와 관련된 함수 */
	let basePhoneNumberElementsLength = 6;			// 반드시 1개는 존재해서 삭제가 불가능한 컴포넌트들의 개수 (ex: phoneNumberElement0)
	let dynamicPhoneNumberElementsLength = 8;		// 동적 컴포넌트를 1번 추가시 생성되는 컴포넌트들의 개수 (ex: phoneNumberElement1, phoneNumberElement2, ...)
	let maxPhoneNumberCount = 2;

	/**
	 *  동적 컴포넌트 구분을 위한 ID (= index) 를 재부여하는 함수
	 *  사용) 추가, 삭제 함수를 호출 시 마지막에 호출
	 *  */
	function adjustElementsIndex(className, baseElementsLength, maxGroupCount) {
		let elements = document.querySelectorAll('[class*=' + className + ']');
		let newIndex = 1;
		let nowGroupCount = 0;

		if (elements.length - baseElementsLength <= 0) {
			return;
		}

		for (let i = baseElementsLength; i < elements.length; i++) {
			let classNames = elements[i].className.split(" ");

			for (let j = 0; j < classNames.length; j++) {
				const nowClassName = classNames[j];

				if (nowClassName.includes(className)) {
					if (nowGroupCount === maxGroupCount) {
						nowGroupCount = 0;
						newIndex++;
					}

					elements[i].classList.remove(nowClassName);
					elements[i].classList.add(className + newIndex);
					nowGroupCount++;
				}
			}
		}
	}

	// 동적 컴포넌트를 삭제하는 함수
	function removeElements(element, elementClassName, baseElementsLength, dynamicElementsLength) {
		let index = '';
		for (let i = 0; i < element.classList.length; i++) {
			if (element.classList[i].startsWith(elementClassName)) {
				index = element.classList[i].replace(elementClassName, '');
				break;
			}
		}

		let elementIndexString = '' + elementClassName + index;
		let elementsToRemove = document.querySelectorAll('[class*=' + elementIndexString + ']');
		for (let i = 0; i < elementsToRemove.length; i++) {
			elementsToRemove[i].remove();
		}

		adjustElementsIndex(elementClassName, baseElementsLength, dynamicElementsLength);
	}


	// 전화번호 : 레이아웃 생성 및 삭제
	function addPhoneNumberElements() {
		let existingElements = document.querySelectorAll('[class*="phoneNumberElement"]');
		let newIndex = Math.floor((existingElements.length - basePhoneNumberElementsLength) / dynamicPhoneNumberElementsLength) + 1;
		if (newIndex >= maxPhoneNumberCount) {
			alert("대표 전화는 최대 " + maxPhoneNumberCount + "개까지만 추가할 수 있습니다.");
			return;
		}

		const parentContainer = document.getElementById('phoneNumberFrame');
		const container = document.getElementById('phoneNumberContainer');

		const areaCodeSelect = document.createElement('select');
		areaCodeSelect.setAttribute('name', 'phoneNumberPart1');
		areaCodeSelect.setAttribute('class', `phoneNumberElement${newIndex} w50`);
		areaCodeSelect.setAttribute('onchange', `togglePhoneNumberInput(this)`);
		areaCodeSelect.innerHTML = document.querySelector('select[name="phoneNumberPart1"]').innerHTML; // 기존의 select 옵션 복사
		areaCodeSelect.value = " ";

		const areaCodeInput = document.createElement('input');
		areaCodeInput.setAttribute('type', 'text');
		areaCodeInput.setAttribute('name', 'phoneNumberPart1');
		areaCodeInput.setAttribute('class', `phoneNumberElement${newIndex} w150`);
		areaCodeInput.setAttribute('style', "display: none;");
		areaCodeInput.setAttribute('autocomplete', 'off');
		areaCodeInput.setAttribute('placeholder', '지역번호를 입력해주세요.');
		areaCodeInput.setAttribute('oninput', 'formatPhoneNumber1(this);');

		const dash1 = document.createElement('a');
		dash1.setAttribute('class', `phoneNumberElement${newIndex}`);
		dash1.setAttribute('style', "margin-left: 3px; margin-right: 4px;");
		dash1.innerHTML = '-';

		const middleNumberInput = document.createElement('input');
		middleNumberInput.setAttribute('type', 'text');
		middleNumberInput.setAttribute('name', 'phoneNumberPart2');
		middleNumberInput.setAttribute('class', `phoneNumberElement${newIndex} w50`);
		middleNumberInput.setAttribute('autocomplete', 'off');
		middleNumberInput.setAttribute('placeholder', '중간번호');
		middleNumberInput.setAttribute('oninput', 'formatPhoneNumber2(this);');

		const dash2 = document.createElement('a');
		dash2.setAttribute('class', `phoneNumberElement${newIndex}`);
		dash2.setAttribute('style', "margin-left: 3px; margin-right: 4px;");
		dash2.innerHTML = '-';

		const endNumberInput = document.createElement('input');
		endNumberInput.setAttribute('type', 'text');
		endNumberInput.setAttribute('name', 'phoneNumberPart3');
		endNumberInput.setAttribute('class', `phoneNumberElement${newIndex} w50`);
		endNumberInput.setAttribute('autocomplete', 'off');
		endNumberInput.setAttribute('placeholder', '끝번호');
		endNumberInput.setAttribute('oninput', 'formatPhoneNumber3(this);');

		const removeButton = document.createElement('a');
		removeButton.setAttribute('type', 'button');
		removeButton.setAttribute('href', 'javascript:void(0);');
		removeButton.setAttribute('class', `phoneNumberElement${newIndex} mot3 whiteBtn-round`);
		removeButton.setAttribute('style', 'margin-left: 5px; margin-top: 0px;');
		removeButton.setAttribute('onclick', `removeElements(this, ` + `'phoneNumberElement', ` + basePhoneNumberElementsLength + ', ' + dynamicPhoneNumberElementsLength + `);`);
		removeButton.innerHTML = '-';

		const br = document.createElement('br');
		br.className = 'phoneNumberElement' + newIndex;

		container.appendChild(areaCodeSelect);
		container.appendChild(areaCodeInput);
		container.appendChild(dash1);
		container.appendChild(middleNumberInput);
		container.appendChild(dash2);
		container.appendChild(endNumberInput);
		container.appendChild(removeButton);
		container.appendChild(br);

		parentContainer.appendChild(container);

		adjustElementsIndex("phoneNumberElement", basePhoneNumberElementsLength, dynamicPhoneNumberElementsLength);
	}
</script>

<script>	/* 이미지 업로드에 대한 Validation */
	function applyValidationToUploadedImage() {
		const uploadedThumbImg = document.querySelector('input[name="thumbImg.file.fileId"]');
		if (uploadedThumbImg.value.trim()) {
			isThumbImg = true;
		}
	}

	function setImageChangeListener() {
		thumbImg.addEventListener('change', function() {
			isThumbImg = true;
			setValidLang();
		});
	}
</script>

<script>	/* 제공 언어 폼 관련 */
	const languages = ['KO', 'EN', 'JP', 'CN'];
	let selectedLang = 'KO';

	function selectLanguage(lang) {
		// 모든 언어 필드를 숨기기
		languages.forEach(function (lang) {
			let facilityName = document.getElementById('facilityName' + lang);
			let description = document.getElementById('description' + lang);
			let thumbImgAltTxt = document.getElementById('thumbImg.fileAltTxt' + lang);
			let tags = document.getElementById('tags' + lang);
			let keywords = document.getElementById('searchKeywords' + lang);
			let menus = document.getElementById('menuForm' + lang);

			facilityName.style.display = 'none';
			description.style.display = 'none';
			thumbImgAltTxt.style.display = 'none';
			tags.style.display = 'none';
			keywords.style.display = 'none';
			menus.style.display = 'none';

			// <span class="length"> 태그가 있으면 hidden
			if (facilityName.nextElementSibling && facilityName.nextElementSibling.classList.contains('length')) {
				facilityName.nextElementSibling.style.display = 'none';
			}
			if (description.nextElementSibling && description.nextElementSibling.classList.contains('length')) {
				description.nextElementSibling.style.display = 'none';
			}
			if (thumbImgAltTxt.nextElementSibling && thumbImgAltTxt.nextElementSibling.classList.contains('length')) {
				thumbImgAltTxt.nextElementSibling.style.display = 'none';
			}
			if (tags.nextElementSibling && tags.nextElementSibling.classList.contains('length')) {
				tags.nextElementSibling.style.display = 'none';
			}
			if (keywords.nextElementSibling && keywords.nextElementSibling.classList.contains('length')) {
				keywords.nextElementSibling.style.display = 'none';
			}
			let lengthSpans = menus.querySelectorAll('.length');
			for (let i = 0; i < lengthSpans.length; i++) {
				lengthSpans[i].style.display = 'none';
			}
		});

		// 선택된 언어 필드만 보이게 하기
		let facilityName = document.getElementById('facilityName' + lang);
		let description = document.getElementById('description' + lang);
		let thumbImgAltTxt = document.getElementById('thumbImg.fileAltTxt' + lang);
		let tags = document.getElementById('tags' + lang);
		let keywords = document.getElementById('searchKeywords' + lang);
		let menus = document.getElementById('menuForm' + lang);

		facilityName.style.display = 'inline-block';
		description.style.display = 'inline-block';
		thumbImgAltTxt.style.display = 'inline-block';
		tags.style.display = 'inline-block';
		keywords.style.display = 'inline-block';
		menus.style.display = 'inline-block';

		// <span class="length"> 태그가 있으면 노출
		if (facilityName.nextElementSibling && facilityName.nextElementSibling.classList.contains('length')) {
			facilityName.nextElementSibling.style.display = 'inline-block';
		}
		if (description.nextElementSibling && description.nextElementSibling.classList.contains('length')) {
			description.nextElementSibling.style.display = 'inline-block';
		}
		if (thumbImgAltTxt.nextElementSibling && thumbImgAltTxt.nextElementSibling.classList.contains('length')) {
			thumbImgAltTxt.nextElementSibling.style.display = 'inline-block';
		}
		if (tags.nextElementSibling && tags.nextElementSibling.classList.contains('length')) {
			tags.nextElementSibling.style.display = 'inline-block';
		}
		if (keywords.nextElementSibling && keywords.nextElementSibling.classList.contains('length')) {
			keywords.nextElementSibling.style.display = 'inline-block';
		}
		let lengthSpans = menus.querySelectorAll('.length');
		for (let i = 0; i < lengthSpans.length; i++) {
			lengthSpans[i].style.display = 'inline-block';
		}

		// 현재, 국문만 검색 키워드 기능 제공
		let searchKeywordFrame = document.getElementById('searchKeyword');
		if (lang === 'KO') {
			searchKeywordFrame.style.display = 'table-row-group';
		} else {
			searchKeywordFrame.style.display = 'none';
		}

		// 선택된 언어 버튼의 스타일 업데이트 (선택된 버튼 강조)
		let buttons = document.querySelectorAll('.langBtn-round');
		buttons.forEach(function (btn) {
			btn.classList.remove('active');
		});
		document.getElementById('selectedLangBtn' + lang).classList.add('active');

		setValidLang();
		selectedLang = lang;
	}

	// 필수 데이터를 검사하여 각 제공언어 버튼에 Validation 표시
	function setValidLang() {
		document.getElementById(`selectedLangBtnKO`).classList.remove("valid");
		document.getElementById(`selectedLangBtnEN`).classList.remove("valid");
		document.getElementById(`selectedLangBtnJP`).classList.remove("valid");
		document.getElementById(`selectedLangBtnCN`).classList.remove("valid");

		document.getElementById(`selectedLangBtnKO`).classList.remove("invalid");
		document.getElementById(`selectedLangBtnEN`).classList.remove("invalid");
		document.getElementById(`selectedLangBtnJP`).classList.remove("invalid");
		document.getElementById(`selectedLangBtnCN`).classList.remove("invalid");

		// 필수 데이터를 모두 입력한 경우 valid, 하나라도 조건을 만족하지 않으면 invalid 처리, 비어있으면 empty
		let isValid = true;
		languages.forEach(lang => {
			let facilityName = document.getElementById('facilityName' + lang);
			let description = document.getElementById('description' + lang);
			let tags = document.getElementById('tags' + lang);
			let keywords = document.getElementById('searchKeywords' + lang);
			let thumbImgAltTxt = document.getElementById('thumbImg.fileAltTxt' + lang);

			let langBtn = document.getElementById(`selectedLangBtn` + lang);

			const isFacilityNameFilled = facilityName.value.trim() !== "";
			const isDescriptionFilled = description.value.trim() !== "";
			const isTagsFilled = tags.value.trim() !== "";
			const isKeywordsFilled = keywords.value.trim() !== "";
			const isThumbImgAltTxt = thumbImgAltTxt.value.trim() !== "";
			const isMenusFilled = isFiledMenuName(lang);

			if ((isThumbImg && !isThumbImgAltTxt) || (!isThumbImg && isThumbImgAltTxt)) {
				langBtn.classList.remove("valid");
				langBtn.classList.add("invalid");
				isValid = false;
			} else if (lang === "KO") {				// 현재, 국문 ("KO") 의 경우 '매장 및 시설명' 필수 Validation 존재
				if (isFacilityNameFilled) {
					langBtn.classList.remove("invalid");
					langBtn.classList.add("valid");
				} else {
					langBtn.classList.remove("valid");
					langBtn.classList.add("invalid");
					isValid = false;
				}
			} else {								// 다른 언어의 경우, 필수 입력 데이터가 모두 입력된 경우나 모두 입력되지 않은 경우만 유효
				if (isFacilityNameFilled) {
					langBtn.classList.remove("invalid");
					langBtn.classList.add("valid");
				} else if (!isFacilityNameFilled && (isDescriptionFilled || isTagsFilled || isThumbImgAltTxt || isMenusFilled)) {
					langBtn.classList.remove("valid");
					langBtn.classList.add("invalid");
					isValid = false;
				} else {
					langBtn.classList.remove("invalid");
				}
			}
		});

		return isValid;
	}
</script>

<script>    /* String -> Date */
	function convertStringToDate(element) {
		let elementDateString = element.value;
		let resultDate = new Date(null);

		if (elementDateString) {
			resultDate = new Date(elementDateString + '');
		}

		element.value = resultDate;
	}
</script>

<script>    /* 상세 이미지 관련*/
	const imgGroupCount = 2;
	const maxImgCount = 5;
	const detailImgListName = 'detailImgList';

	function getCardIndex(type) {
		let cardTypeName = type + "Card";       // 예) imgCard, videoCard, docCard
		let cards = document.querySelectorAll("[class*=" + cardTypeName + "]");
		let maxIndex = 0;

		cards.forEach(function (card) {
			let classNames = card.className.split(" ");
			classNames.forEach(function (className) {
				if (className.includes(cardTypeName)) {
					let index = parseInt(className.replace(cardTypeName, ""));
					if (!isNaN(index) && index > maxIndex) {
						maxIndex = index;
					}
				}
			});
		});

		return maxIndex;
	}

	function adjustCardIndexes(type) {
		let cardTypeName = type + "Card";
		let cards = document.querySelectorAll("tr[class*=" + cardTypeName + "]");
		let newIndex = 0;
		let groupCount = 0;

		cards.forEach(function (card) {
			let classNames = card.className.split(" ");
			classNames.forEach(function (className) {
				if (className.includes(cardTypeName)) {
					if (groupCount === imgGroupCount) {
						groupCount = 0;
						newIndex++;
					}

					card.classList.remove(className);
					card.classList.add("" + cardTypeName + "" + newIndex);
					groupCount++;
				}

				let cardListNames = card.querySelectorAll('input[name^=' + detailImgListName + ']');
				if (cardListNames.length > 0) {
					cardListNames.forEach(function (cardListName) {
						cardListName.name = cardListName.name.replace(/\d+/, newIndex);
					});
				}
			});
		});
	}

	function createImgCard(imgCardIndex) {
		let imgAcceptValue = ".jpg, .gif, .png";

		// 전체를 innerHTML 형태로 기존 element 에 더할 경우, 저장되지 않은 데이터가 날라가므로 appendChild 형태로 더할 수 있도록 element 생성
		let imgCardTr = document.createElement('tr');
		imgCardTr.className = 'imgType imgCard' + imgCardIndex;
		imgCardTr.innerHTML = `
                <input type="hidden" name="detailImgList[` + imgCardIndex + `].seq" value="">
                <th rowspan="2" colspan="1"><br>상세 이미지
                    <br><br>
                    <a type="button" href="javascript:addCard('imgType');" class="mot3 whiteBtn-round">추가 +</a>
                    <br>
                    <a type="button" href="#" onclick="deleteCard(this, 'img', event);" class="mot3 whiteBtn-round">삭제 -</a>
					<br><br>
                </th>

                <th>이미지</th>
                <td name="detailImgList[` + imgCardIndex + `].file">
                    <div class="ment">이미지 파일 권장 사이즈는 <span class="red">1020px * 566px</span> 이고, <strong> .jpg, .gif, .png</strong> 파일에 한해 등록이 가능합니다.</div>
                    <div class="ment">파일 용량은 <span class="red">5MB</span> 까지 등록이 가능합니다.</div>
                    <div class="file_input_div">
                        <input type="hidden" name="detailImgList[` + imgCardIndex + `].file.tag" value="DETAIL_IMG">
                        <input type="hidden" name="detailImgList[` + imgCardIndex + `].file.fileId" value="">
                        <input type="file" name="detailImgList[` + imgCardIndex + `].file.file" accept=".jpg, .gif, .png">
                    </div>
                </td>`

		let imgTextCardTr = document.createElement('tr');
		imgTextCardTr.className = 'imgType imgCard' + imgCardIndex;
		imgTextCardTr.innerHTML = `
				<th>이미지 대체 텍스트</th>
				<td>
					<input type="text" name="detailImgList[` + imgCardIndex + `].fileAltTxtKo" maxlength="200" class="w300" autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (국문)">
					<span class="length">0/200</span>
					<br>
					<input type="text" name="detailImgList[` + imgCardIndex + `].fileAltTxtEn" maxlength="200" class="w300" autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (영문)"/>
					<span class="length">0/200</span>
					<br>
					<input type="text" name="detailImgList[` + imgCardIndex + `].fileAltTxtJp" maxlength="200" class="w300" autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (일문)"/>
					<span class="length">0/200</span>
					<br>
					<input type="text" name="detailImgList[` + imgCardIndex + `].fileAltTxtCn" maxlength="200" class="w300" autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (중문)"/>
					<span class="length">0/200</span>
				</td>`;

		document.getElementById('cardFrame').appendChild(imgCardTr);
		document.getElementById('cardFrame').appendChild(imgTextCardTr);

	}

	function addCard(contentsType) {
		if (contentsType === 'imgType') {
			if (getCardIndex('img') + 1 >= maxImgCount) {
				alert("상세 이미지는 최대 " + maxImgCount + "개까지만 추가할 수 있습니다.");
				return;
			}

			createImgCard(getCardIndex('img') + 1);
			adjustCardIndexes('img');
		}
	}

	function deleteCard(node, type, event) {
		if (event) {
			event.preventDefault();
		}

		let nowIndex;
		let cardTypeName = type + "Card";
		let cardTh = node.parentNode;
		let cardRow = cardTh.parentNode;
		let classNames = cardRow.className.split(" ");

		classNames.forEach(function (className) {
			if (className.includes(cardTypeName)) {
				let index = parseInt(className.replace(cardTypeName, ""));
				if (!isNaN(index)) {
					nowIndex = index;
				}
			}
		});

		let cardClassName = cardTypeName + nowIndex;
		let cardElements = document.getElementsByClassName(cardClassName);

		for (let i = 0; i < cardElements.length; i++) {
			cardElements[i].remove();
			i = -1;
		}

		adjustCardIndexes(type);
	}
</script>

<script>	/* 대표 썸네일 이미지 컴포넌트 관련 */
	function selectLanguageThumbImg() {
		document.getElementById('thumbImgs').style.display = 'table-row-group';
	}

	function unselectLanguageThumbImg() {
		document.getElementById('thumbImgs').style.display = 'none';
	}
</script>

<script>	/* 메뉴 컴포넌트 관련 */
	let maxMenuCount = 10;

	function selectLanguageMenu(lang) {
		document.getElementById('menus').style.display = 'table-row-group';

		// 모든 언어의 메뉴 폼을 숨김 처리
		document.querySelectorAll('.menuForm').forEach(function(el) {
			el.style.display = 'none';
		});

		// 선택한 언어의 메뉴 폼을 보여줌
		document.querySelectorAll('.menuForm' + lang).forEach(function(el) {
			el.style.display = 'block';
		});
	}

	function unselectLanguageMenu() {
		document.getElementById('menus').style.display = 'none';
		document.querySelectorAll('.menuForm').forEach(function(el) {
			el.style.display = 'none';
		});
	}

	function addMenuField() {
		let fieldLang = 'Ko';
		let langKorString = '국문';

		if (selectedLang === 'EN') {
			fieldLang = 'En';
			langKorString = '영문';
		} else if (selectedLang === 'JP') {
			fieldLang = 'Jp';
			langKorString = '일문';
		} else if (selectedLang === 'CN') {
			fieldLang = 'Cn';
			langKorString = '중문';
		}

		let menuContainer = document.getElementsByClassName('menuForm' + selectedLang)[0];
		let index = menuContainer.getElementsByTagName('input').length / 2;
		if (index >= maxMenuCount) {
			alert("메뉴는 최대 " + maxMenuCount + "개까지만 추가할 수 있습니다.");
			return;
		}

		// 메뉴 항목을 감쌀 div 생성
		let menuItemDiv = document.createElement('div');
		menuItemDiv.id = 'menuForm' + selectedLang + index;

		// 메뉴명 입력 필드 생성
		let menuNameInput = document.createElement('input');
		menuNameInput.type = 'text';
		menuNameInput.id = 'menuName' + selectedLang + '' + index;
		menuNameInput.name = 'facilityLangInfo' + fieldLang + '.menuList[' + index + '].name';
		menuNameInput.maxLength = 50;
		menuNameInput.classList.add('w300');
		menuNameInput.placeholder = '메뉴명을 입력해 주세요. (' + langKorString + ')';
		menuNameInput.setAttribute('autocomplete', 'off');
		menuNameInput.setAttribute('onkeyup', 'setValidLang()');

		let menuNameSpan = document.createElement("span");
		menuNameSpan.classList.add("length");
		menuNameSpan.innerText = "0/50";

		// 가격 입력 필드 생성
		let priceInput = document.createElement('input');
		priceInput.type = 'text';
		priceInput.id = 'menuPrice' + selectedLang + '' + index;
		priceInput.name = 'facilityLangInfo' + fieldLang + '.menuList[' + index + '].price';
		priceInput.classList.add('w150');
		priceInput.placeholder = '가격을 입력해 주세요.';
		priceInput.style = 'margin-left: 10.5px;';
		priceInput.setAttribute('autocomplete', 'off');
		priceInput.setAttribute('onkeyup', 'setValidLang()');
		priceInput.setAttribute('oninput', "this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\\..*)\\./g, '$1'); if (this.value.length > 9) this.value = this.value.slice(0, 9);");

		// let priceSpan = document.createElement("span");
		// priceSpan.classList.add("length");
		// priceSpan.innerText = "0/10";

		// 삭제 버튼 생성
		let removeButton = document.createElement('button');
		removeButton.type = 'button';
		removeButton.textContent = '-';
		removeButton.setAttribute('class', 'mot3 whiteBtn-round');
		removeButton.style = 'margin-left: 3px; margin-top: 1px;';
		removeButton.onclick = function () {
			removeMenuField(this);
		};

		menuItemDiv.appendChild(menuNameInput);
		menuItemDiv.appendChild(menuNameSpan);

		menuItemDiv.appendChild(priceInput);
		// menuItemDiv.appendChild(priceSpan);

		menuItemDiv.appendChild(removeButton);

		menuContainer.appendChild(menuItemDiv);
	}

	// 메뉴 항목 삭제 함수
	function removeMenuField(element) {
		let container = element.parentNode;
		if (container) {
			container.remove();
			adjustIndexMenuFields();
		}
	}

	function adjustIndexMenuFields() {
		let fieldLang = 'Ko';
		if (selectedLang === 'EN') {
			fieldLang = 'En';
		} else if (selectedLang === 'JP') {
			fieldLang = 'Jp';
		} else if (selectedLang === 'CN') {
			fieldLang = 'Cn';
		}

		// 현재 선택된 언어의 메뉴 컨테이너를 가져옴
		let menuContainer = document.getElementsByClassName('menuForm' + selectedLang)[0];
		let menuItems = menuContainer.getElementsByTagName('div'); // 메뉴 항목을 감싸는 div 목록

		// 메뉴 항목들을 순회하며 인덱스를 재조정
		for (let i = 0; i < menuItems.length; i++) {
			let menuItemDiv = menuItems[i];
			let menuNameInput = menuItemDiv.getElementsByTagName('input')[0]; // 메뉴명 입력 필드
			let priceInput = menuItemDiv.getElementsByTagName('input')[1]; // 가격 입력 필드

			menuNameInput.name = 'facilityLangInfo' + fieldLang + '.menuList[' + i + '].name';
			menuNameInput.id = 'menuName' + selectedLang + i;

			priceInput.name = 'facilityLangInfo' + fieldLang + '.menuList[' + i + '].price';
			priceInput.id = 'menuPrice' + selectedLang + i;

			menuItemDiv.id = 'menuForm' + selectedLang + i;
		}
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