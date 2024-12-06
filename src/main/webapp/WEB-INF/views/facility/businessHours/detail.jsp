<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/uploadForm.jsp" %>
<%@ page import="com.does.biz.primary.domain.facility.BuildingType" %>
<%@ page import="com.does.biz.primary.domain.affiliate.AffiliateFloorType" %>
<%@ page import="com.does.biz.primary.domain.facility.BusinessHoursType" %>
<%@ page import="com.does.biz.primary.domain.facility.BusinessHoursVO" %>
<%
	request.setAttribute("buildingType", BuildingType.getValuesExcludingEtc());
	request.setAttribute("buildingTypeLWT", BuildingType.LWT);
	request.setAttribute("buildingTypeLWM", BuildingType.LWM);
	request.setAttribute("buildingTypeAVE", BuildingType.AVE);

	request.setAttribute("businessHoursTypeCommon", BusinessHoursType.COMMON);
	request.setAttribute("businessHoursTypeWeekend", BusinessHoursType.WEEKEND);
	request.setAttribute("businessHoursTypeExtra", BusinessHoursType.EXTRA);

	request.setAttribute("affiliateFloors", AffiliateFloorType.values());
	request.setAttribute("areaCodes", BusinessHoursVO.AREA_CODES);
	request.setAttribute("weeks", BusinessHoursVO.weeks);
	request.setAttribute("days", BusinessHoursVO.days);
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

<div id="pageTitle">영업시간 / 휴점일 관리</div>

<ul class="pageGuide">
	<li><span class="red">*</span> 표시는 필수항목입니다.</li>
	<li>기존 휴점일 데이터는 쌓이지 않습니다.</li>
</ul>

<div class="detailBox">
	<form method="post" name="workForm" action="save">
		<input type="hidden" name="seq" value="${fn:escapeXml(data.seq)}"/>
		<input type="hidden" name="pageNum" value="${fn:escapeXml(search.pageNum)}"/>
		<table>
			<tbody>
			<tr>
				<th required>건물 위치</th>
				<td>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="buildingTypeLWT" name="buildingType"
							   value="${fn:escapeXml(buildingTypeLWT)}" checked/>
						<label for="buildingTypeLWT">롯데월드타워</label>

						<input type="radio" id="buildingTypeLWM" name="buildingType"
							   value="${fn:escapeXml(buildingTypeLWM)}" />
						<label for="buildingTypeLWM">롯데월드몰</label>

						<input type="radio" id="buildingTypeAVE" name="buildingType"
							   value="${fn:escapeXml(buildingTypeAVE)}" />
						<label for="buildingTypeAVE">에비뉴엘</label>
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
					</c:if>
				</td>
			</tr>

			<tr>
				<th required>운영사 선택</th>
				<td colspan="2">
					<select name="affiliate">
						<option value="" disabled selected>운영사를 선택해 주세요.</option>
						<c:forEach items="${affiliates}" var="item">
							<option value="${fn:escapeXml(item)}" ${data.affiliate == item ? 'selected':''}><c:out value="${item.nameKo}"/></option>
						</c:forEach>
					</select>
					<input type="text" class="w250" id="affiliateFloor" name="affiliateFloor" value="${fn:escapeXml(data.affiliateFloor)}" maxlength="12" style="display: inline-block;"
							placeholder="0F 혹은 0F ~ 0F 형태로 입력해주세요.">
					</select>
				</td>
			</tr>

			<tr>
				<th>대표전화</th>
				<td colspan="3">
					<%-- 대표전화에 대한 레이아웃 --%>
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
										<c:set var="phoneNumberParts" value="${fn:split(nowPhoneNumber, '-')}" />

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

			<tr>
				<th required>영업시간</th>
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
							<input type="hidden" name="businessHoursCommonSH">
							<input type="hidden" name="businessHoursCommonSM">
							<input type="hidden" name="businessHoursCommonEH">
							<input type="hidden" name="businessHoursCommonEM">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<jsp:include page="/include/component/dateTime.jsp" flush="false">
								<jsp:param name="hourName"	value="businessHoursCommonSH"/><jsp:param name="hourValue"		value="${data.BHCommonSH}"/>
								<jsp:param name="minName"	value="businessHoursCommonSM"/> <jsp:param name="minValue"	value="${data.BHCommonSM}"/>
							</jsp:include>
							~
							<jsp:include page="/include/component/dateTime.jsp" flush="false">
								<jsp:param name="hourName"	value="businessHoursCommonEH"/><jsp:param name="hourValue"		value="${data.BHCommonEH}"/>
								<jsp:param name="minName"	value="businessHoursCommonEM"/> <jsp:param name="minValue"	value="${data.BHCommonEM}"/>
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
							<input type="hidden" name="businessHoursWeekdaySH">
							<input type="hidden" name="businessHoursWeekdaySM">
							<input type="hidden" name="businessHoursWeekdayEH">
							<input type="hidden" name="businessHoursWeekdayEM">
							<input type="hidden" name="businessHoursWeekendSH">
							<input type="hidden" name="businessHoursWeekendSM">
							<input type="hidden" name="businessHoursWeekendEH">
							<input type="hidden" name="businessHoursWeekendEM">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a style="color:gray; font-size: 13px; line-height: 40px;">평일</a>
							<jsp:include page="/include/component/dateTime.jsp" flush="false">
								<jsp:param name="hourName"	value="businessHoursWeekdaySH"/><jsp:param name="hourValue"	value="${data.BHWeekdaySH}"/>
								<jsp:param name="minName"	value="businessHoursWeekdaySM"/><jsp:param name="minValue"	value="${data.BHWeekdaySM}"/>
							</jsp:include>
							~
							<jsp:include page="/include/component/dateTime.jsp" flush="false">
								<jsp:param name="hourName"	value="businessHoursWeekdayEH"/><jsp:param name="hourValue"	value="${data.BHWeekdayEH}"/>
								<jsp:param name="minName"	value="businessHoursWeekdayEM"/> <jsp:param name="minValue"	value="${data.BHWeekdayEM}"/>
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
							<div class="language-tabs" style="padding-bottom: 4px;">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<a type="button" class="mot3 lightBtn-round active" onclick="selectLanguage('KO')">국문</a>
								<a type="button" class="mot3 lightBtn-round" onclick="selectLanguage('EN')">영문</a>
								<a type="button" class="mot3 lightBtn-round" onclick="selectLanguage('JP')">일문</a>
								<a type="button" class="mot3 lightBtn-round" onclick="selectLanguage('CN')">중문</a>
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
				<th>휴점일</th>
				<td>
					<%-- 휴점일 ('해당 없음' 에 대한 라디오 버튼) --%>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="closedRangeEmpty" name="closedRangeYn" value="X" checked/>
					</c:if>
					<c:if test="${not isNew}">
						<input type="radio" id="closedRangeEmpty" name="closedRangeYn" value="X"
							${data.closedRangeYn eq 'X' ? 'checked' : '' } />
					</c:if>
					<label for="closedRangeEmpty">해당 없음</label>
					<%-- // --%>

					<br>

					<%-- 휴점일 ('월 기준 설정' 에 대한 라디오 버튼) --%>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="closedRangeN" name="closedRangeYn" value="N" />
					</c:if>
					<c:if test="${not isNew}">
						<input type="radio" id="closedRangeN" name="closedRangeYn" value="N" ${data.closedRangeYn eq 'N' ? 'checked' : '' } />
					</c:if>
					<label for="closedRangeN">월 기준 설정</label>
					<%-- // --%>

					<%-- 휴점일 ('월 기준 설정' 에 대한 레이아웃) --%>
					<div id="closedDateWeeksAndDaysFrame">
						<input type="hidden" id="closedDateWeeksAndDays" name="closedDateWeeksAndDays">
						<div id="closedDateWeeksAndDaysContainer">
							<a class="closedDateElement0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
							<c:choose>
								<c:when test="${empty data.closedDateWeeksAndDaysArrays}">
									<select class="closedDateElement0" name="closedDateWeek">
										<option value="" disabled selected>주</option>
										<c:forEach items="${weeks}" var="item">
											<option value="${fn:escapeXml(item)}"><c:out value="${item}"/></option>
										</c:forEach>
									</select>
									<select class="closedDateElement0" name="closedDateDay">
										<option value="" disabled selected>요일</option>
										<c:forEach items="${days}" var="item">
											<option value="${fn:escapeXml(item)}"><c:out value="${item}"/></option>
										</c:forEach>
									</select>
								</c:when>
								<c:otherwise>
								<c:forEach items="${data.closedDateWeeksAndDaysArrays}" var="myWeekAndDay" varStatus="status">
									<c:if test="${status.index != 0}">
										<br class="closedDateElement${fn:escapeXml(status.index)}">
										<a class="closedDateElement${fn:escapeXml(status.index)}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
									</c:if>
									<select class="closedDateElement${fn:escapeXml(status.index)}" name="closedDateWeek">
										<option value="" disabled selected>주</option>
										<c:forEach items="${weeks}" var="item">
											<option value="${fn:escapeXml(item)}" ${myWeekAndDay.split(" ")[0] == item ? 'selected' : ''}><c:out value="${item}"/></option>
										</c:forEach>
									</select>
									<select class="closedDateElement${fn:escapeXml(status.index)}" name="closedDateDay">
										<option value="" disabled selected>요일</option>
										<c:forEach items="${days}" var="item">
											<option value="${fn:escapeXml(item)}" ${myWeekAndDay.split(" ")[1] == item ? 'selected' : ''}><c:out value="${item}"/></option>
										</c:forEach>
									</select>
									<c:if test="${status.index != 0}">
										<a type="button" href="javascript:void(0);" class="closedDateElement${fn:escapeXml(status.index)} mot3 whiteBtn-round" style="margin-left: 1px; margin-top: 2px;"
										   onclick="removeElements(this, 'closedDateElement', baseClosedDateElementsLength, dynamicClosedDateElementsLength);">-</a>
									</c:if>
								</c:forEach>
								</c:otherwise>
							</c:choose>
						</div>
					</div>

					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a type="button" href="javascript:void(0);" onclick="addClosedDateElements();" class="mot3 whiteBtn-round">추가 +</a>
					<%-- // --%>

					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${isNew}">
						<input type="checkbox" id="closedRepeatYn" name="closedRepeatYn" value="N" />
					</c:if>
					<c:if test="${not isNew}">
						<input type="checkbox" id="closedRepeatYn" name="closedRepeatYn" value="Y" ${data.closedRepeatYn eq 'Y' ? ' checked' : ''} />
					</c:if>
					<label for="closedRepeatYn">매월 반복</label>
					<br>
					<div class="mentDynamic">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						* 매월 반복을 선택 시, 선택한 일정으로 매달 휴점일이 자동 노출됩니다.</div>
					<br>

					<%-- 휴점일 ('기간 설정' 에 대한 라디오 버튼) --%>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="closedRangeY" name="closedRangeYn" value="Y" />
					</c:if>
					<c:if test="${not isNew}">
						<input type="radio" id="closedRangeY" name="closedRangeYn" value="Y" ${data.closedRangeYn eq 'Y' ? 'checked' : '' } />
					</c:if>
					<label for="closedRangeY">기간 설정</label>
					<%-- // --%>

					<br>

					<%-- 휴점일 ('기간 설정' 에 대한 레이아웃) --%>
					<div id="closedDateRangeFrame">
						<input type="hidden" id="closedStartAndEndDates" name="closedStartAndEndDates">
						<div id="closedDateRangeContainer">
							<a class="closedRangeElement0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
							<c:choose>
								<c:when test="${empty data.closedStartAndEndDatesArrays}">
									<input type="text" class="closedRangeElement0 date" name="closedStartDate" required autocomplete="off"/>
									<a class="closedRangeElement0">~</a>
									<input type="text" class="closedRangeElement0 date" name="closedEndDate" required autocomplete="off"/>
								</c:when>
								<c:otherwise>
									<c:forEach items="${data.closedStartAndEndDatesArrays}" var="myRangeDates" varStatus="status">
										<c:if test="${status.index != 0}">
											<br class="closedRangeElement${fn:escapeXml(status.index)}">
											<a class="closedRangeElement${fn:escapeXml(status.index)}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
										</c:if>

										<input type="text" class="closedRangeElement${fn:escapeXml(status.index)} date" name="closedStartDate"
											   value="${fn:escapeXml(myRangeDates.split(" ")[0])}" required autocomplete="off"/>
										<a class="closedRangeElement${fn:escapeXml(status.index)}">~</a>
										<input type="text" class="closedRangeElement${fn:escapeXml(status.index)} date" name="closedEndDate"
											   value="${fn:escapeXml(myRangeDates.split(" ")[1])}" required autocomplete="off"/>

										<c:if test="${status.index != 0}">
											<a type="button" href="javascript:void(0);" class="closedRangeElement${fn:escapeXml(status.index)} mot3 whiteBtn-round" style="margin-left: 2px; margin-top: 2px;"
											   onclick="removeElements(this, 'closedRangeElement', baseClosedRangeElementsLength, dynamicClosedRangeElementsLength);">-</a>
										</c:if>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</div>
					</div>

					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a type="button" href="javascript:void(0);" onclick="addClosedRangeElements();" class="mot3 whiteBtn-round">추가 +</a>
					<%-- // --%>
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

<script>	/* 메인 */
	window.onload = function() {
		addClosedRangeElementInSpan();
		selectLanguage('KO');
		setDefaultBusinessHoursForCommon('10', '30', '22', '0');	// 영업시간 (공통) 의 기본값 설정
		initializePhoneNumberFields();
	};
</script>

<script>	/* 게시글 저장 시 전처리 */
	function goToSave() {
		combinePhoneNumbersForSubmission();
		combineBusinessHoursCommonAndWeekForSubmission();
		combineBusinessHoursTextForSubmission();
		combineClosedDateWeeksAndDaysForSubmission();
		combineClosedStartAndEndDatesForSubmission();

		submitFormIntoHiddenFrame(document.workForm);
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

<script>
	function combineBusinessHoursCommonAndWeekForSubmission() {
		const businessHoursCommonSH = document.querySelector('select[name="businessHoursCommonSH"]');
		const businessHoursCommonSM = document.querySelector('select[name="businessHoursCommonSM"]');
		const businessHoursCommonEH = document.querySelector('select[name="businessHoursCommonEH"]');
		const businessHoursCommonEM = document.querySelector('select[name="businessHoursCommonEM"]');

		const businessHoursWeekdaySH = document.querySelector('select[name="businessHoursWeekdaySH"]');
		const businessHoursWeekdaySM = document.querySelector('select[name="businessHoursWeekdaySM"]');
		const businessHoursWeekdayEH = document.querySelector('select[name="businessHoursWeekdayEH"]');
		const businessHoursWeekdayEM = document.querySelector('select[name="businessHoursWeekdayEM"]');

		const businessHoursWeekendSH = document.querySelector('select[name="businessHoursWeekendSH"]');
		const businessHoursWeekendSM = document.querySelector('select[name="businessHoursWeekendSM"]');
		const businessHoursWeekendEH = document.querySelector('select[name="businessHoursWeekendEH"]');
		const businessHoursWeekendEM = document.querySelector('select[name="businessHoursWeekendEM"]');

		// 공통 영업 시간 (Common)
		document.querySelector('input[name="businessHoursCommonSH"]').value = parseInt(businessHoursCommonSH.value, 10) || 0;
		document.querySelector('input[name="businessHoursCommonSM"]').value = parseInt(businessHoursCommonSM.value, 10) || 0;
		document.querySelector('input[name="businessHoursCommonEH"]').value = parseInt(businessHoursCommonEH.value, 10) || 0;
		document.querySelector('input[name="businessHoursCommonEM"]').value = parseInt(businessHoursCommonEM.value, 10) || 0;

		// 평일 영업 시간 (Weekday)
		document.querySelector('input[name="businessHoursWeekdaySH"]').value = parseInt(businessHoursWeekdaySH.value, 10) || 0;
		document.querySelector('input[name="businessHoursWeekdaySM"]').value = parseInt(businessHoursWeekdaySM.value, 10) || 0;
		document.querySelector('input[name="businessHoursWeekdayEH"]').value = parseInt(businessHoursWeekdayEH.value, 10) || 0;
		document.querySelector('input[name="businessHoursWeekdayEM"]').value = parseInt(businessHoursWeekdayEM.value, 10) || 0;

		// 주말 영업 시간 (Weekend)
		document.querySelector('input[name="businessHoursWeekendSH"]').value = parseInt(businessHoursWeekendSH.value, 10) || 0;
		document.querySelector('input[name="businessHoursWeekendSM"]').value = parseInt(businessHoursWeekendSM.value, 10) || 0;
		document.querySelector('input[name="businessHoursWeekendEH"]').value = parseInt(businessHoursWeekendEH.value, 10) || 0;
		document.querySelector('input[name="businessHoursWeekendEM"]').value = parseInt(businessHoursWeekendEM.value, 10) || 0;

	}

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

<script>
	function combineClosedDateWeeksAndDaysForSubmission() {
		const closedDateWeekSelects = document.querySelectorAll('select[name="closedDateWeek"]');
		const closedDateDaySelects = document.querySelectorAll('select[name="closedDateDay"]');

		const closedDateWeeksAndDaysArrays = [];

		for (let i = 0; i < closedDateWeekSelects.length; i++) {
			const selectedWeek = closedDateWeekSelects[i].value;
			const selectedDay = closedDateDaySelects[i].value;

			if (selectedWeek && selectedDay) {
				closedDateWeeksAndDaysArrays.push(selectedWeek + ' ' + selectedDay);
			}
		}

		document.getElementById('closedDateWeeksAndDays').value = closedDateWeeksAndDaysArrays.join(',');
	}
</script>

<script>
	function combineClosedStartAndEndDatesForSubmission() {
		const closedStartDateSelects = document.querySelectorAll('input[name="closedStartDate"]');
		const closedEndDateSelects = document.querySelectorAll('input[name="closedEndDate"]');

		const closedStartAndEndDatesArrays = [];

		for (let i = 0; i < closedStartDateSelects.length; i++) {
			const startDate = closedStartDateSelects[i].value;
			const endDate = closedEndDateSelects[i].value;

			if (startDate && endDate) {
				closedStartAndEndDatesArrays.push(startDate + ' ' + endDate);
			}
		}

		document.getElementById('closedStartAndEndDates').value = closedStartAndEndDatesArrays.join(',');
	}
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

<script>	/* 동적 컴포넌트 (예: 추가, 삭제 버튼을 통해 개수가 변화하는 UI) 와 관련된 함수 */
	let baseClosedRangeElementsLength = 6;			// 반드시 1개는 존재해서 삭제가 불가능한 컴포넌트들의 개수 (ex: closedRangeElement0)
	let dynamicClosedRangeElementsLength = 8;		// 동적 컴포넌트를 1번 추가시 생성되는 컴포넌트들의 개수 (ex: closedRangeElement1, closedRangeElement2, ...)
	let baseClosedDateElementsLength = 3;			// 반드시 1개는 존재해서 삭제가 불가능한 컴포넌트들의 개수 (ex: closedDateElement0)
	let dynamicClosedDateElementsLength = 5;		// 동적 컴포넌트를 1번 추가시 생성되는 컴포넌트들의 개수 (ex: closedDateElement1, closedDateElement2, ...)
	let basePhoneNumberElementsLength = 6;			// 반드시 1개는 존재해서 삭제가 불가능한 컴포넌트들의 개수 (ex: phoneNumberElement0)
	let dynamicPhoneNumberElementsLength = 8;		// 동적 컴포넌트를 1번 추가시 생성되는 컴포넌트들의 개수 (ex: phoneNumberElement1, phoneNumberElement2, ...)

	let maxClosedRangeCount = 5;
	let maxClosedDateCount = 5;
	let maxPhoneNumberCount = 2;

	/**
	 *  동적 컴포넌트 중에 캘린더를 사용한다면, 해당 컴포넌트의 ID 클래스 부여를 위한 함수
	 *  사용) 페이지 로딩시, 호출
	*  */
	function addClosedRangeElementInSpan() {
		let existingElements = document.querySelectorAll('span[class=dateIcon]');

		for (let i = 0; i < existingElements.length; i++) {
			existingElements[i].className ='closedRangeElement' + Math.floor(i / 2) + ' dateIcon';
		}
	}

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

	/**
	 *  동적 컴포넌트를 삭제하는 함수
	 *  */
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

	/* 전화번호 : 레이아웃 생성 및 삭제 */
	function addPhoneNumberElements() {
		let existingElements = document.querySelectorAll('[class*="phoneNumberElement"]');
		let newIndex = Math.floor((existingElements.length - basePhoneNumberElementsLength) / dynamicPhoneNumberElementsLength) + 1;
		if (newIndex >= maxPhoneNumberCount) {
			alert("대표전화는 최대 " + maxPhoneNumberCount + "개까지만 추가할 수 있습니다.");
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


	/* 휴점일 : 월 기준 설정에 대한 레이아웃 생성 및 삭제 */
	function addClosedDateElements() {
		let existingElements = document.querySelectorAll('[class*="closedDateElement"]');
		let newIndex = Math.floor((existingElements.length - baseClosedDateElementsLength) / dynamicClosedDateElementsLength) + 1;
		if (newIndex >= maxClosedDateCount) {
			alert("휴점일 (월 기준 설정) 은 최대 " + maxClosedDateCount + "개까지만 추가할 수 있습니다.");
			return;
		}

		const parentContainer = document.getElementById('closedDateWeeksAndDaysFrame');
		const container = document.getElementById('closedDateWeeksAndDaysContainer');

		const br = document.createElement('br');
		br.className = 'closedDateElement' + newIndex;

		const a = document.createElement('a');
		a.className = 'closedDateElement' + newIndex;
		a.innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
		a.style = "margin-left: 1px;";

		const weekSelect = document.createElement('select');
		weekSelect.className = 'closedDateElement' + newIndex;
		weekSelect.name = "closedDateWeek";
		weekSelect.innerHTML = `
                <option value="" disabled selected>주</option>
                <c:forEach items="${weeks}" var="item">
                    <option value="${fn:escapeXml(item)}"><c:out value="${item}"/></option>
                </c:forEach>
            `;

		const daySelect = document.createElement('select');
		daySelect.className = 'closedDateElement' + newIndex;
		daySelect.name = "closedDateDay";
		daySelect.style = "margin-left: 3px;";
		daySelect.innerHTML = `
                <option value="" disabled selected>요일</option>
                <c:forEach items="${days}" var="item">
                    <option value="${fn:escapeXml(item)}"><c:out value="${item}"/></option>
                </c:forEach>
            `;

		const removeBtn = document.createElement('a');
		removeBtn.className = 'closedDateElement' + newIndex + ' mot3 whiteBtn-round';
		removeBtn.type = "button";
		removeBtn.style = "margin-left: 5px; margin-top: 2px;";
		removeBtn.href = "javascript:void(0);";
		removeBtn.onclick = function() {
			removeElements(this, 'closedDateElement', baseClosedDateElementsLength, dynamicClosedDateElementsLength);
		};
		removeBtn.innerText = "-";

		container.appendChild(br);
  		container.appendChild(a);
		container.appendChild(weekSelect);
		container.appendChild(daySelect);
		container.appendChild(removeBtn);

		parentContainer.appendChild(container);

		adjustElementsIndex("closedDateElement", baseClosedDateElementsLength, dynamicClosedDateElementsLength);
	}

	/* 휴점일 : 기간 설정에 대한 레이아웃 생성 및 삭제 */
	function addClosedRangeElements() {
		const dayName = ["일", "월", "화", "수", "목", "금", "토"];
    	const monthName = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];
    	const format = 'yy-mm-dd';

		let existingElements = document.querySelectorAll('[class*="closedRangeElement"]');
		let newIndex = Math.floor((existingElements.length - baseClosedRangeElementsLength) / dynamicClosedRangeElementsLength) + 1;
		if (newIndex >= maxClosedRangeCount) {
			alert("휴점일 (기간 설정) 은 최대 " + maxClosedRangeCount + "개까지만 추가할 수 있습니다.");
			return;
		}

		const parentContainer = document.getElementById('closedDateRangeFrame');
		const container = document.getElementById('closedDateRangeContainer');

		const br = document.createElement('br');
		br.className = 'closedRangeElement' + newIndex;

		const a1 = document.createElement('a');
		a1.className = 'closedRangeElement' + newIndex;
		a1.innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
		a1.style = "margin-left: 1px;";

		const span1 = document.createElement('span');
		span1.className = 'closedRangeElement' + newIndex + ' dateIcon';

		const startInput = document.createElement('input');
		startInput.type = "text";
		startInput.className = 'closedRangeElement' + newIndex + ' date';
		startInput.name = "closedStartDate";
		startInput.autocomplete = "off";
		$(startInput)
			.attr({readonly: "readonly", maxlength: 10, nospan: ""})
			.datepicker({
				changeYear: true,
				changeMonth: true,
				showMonthAfterYear: true,
				showOtherMonths: true,
				yearRange: '-50:+3',
				altFormat: format,
				dateFormat: format,
				dayNamesShort: dayName,
				dayNamesMin: dayName,
				monthNames: monthName,
				monthNamesShort: monthName,
				defaultDate: +0
			});

		const a2 = document.createElement('a');
		a2.className = 'closedRangeElement' + newIndex;
		a2.innerHTML = '~';
		a2.style = "margin-left: 4px; margin-right: 3px;";

		const span2 = document.createElement('span');
		span2.className = 'closedRangeElement' + newIndex + ' dateIcon';

		const endInput = document.createElement('input');
		endInput.type = "text";
		endInput.className = 'closedRangeElement' + newIndex + ' date';
		endInput.name = "closedEndDate";
		endInput.autocomplete = "off";
		$(endInput)
			.attr({readonly: "readonly", maxlength: 10, nospan: ""})
			.datepicker({
				changeYear: true,
				changeMonth: true,
				showMonthAfterYear: true,
				showOtherMonths: true,
				yearRange: '-50:+3',
				altFormat: format,
				dateFormat: format,
				dayNamesShort: dayName,
				dayNamesMin: dayName,
				monthNames: monthName,
				monthNamesShort: monthName,
				defaultDate: +0
			});

		const removeBtn = document.createElement('a');
		removeBtn.className = 'closedRangeElement' + newIndex + ' mot3 whiteBtn-round';
		removeBtn.type = "button";
		removeBtn.style = "margin-left: 5px; margin-top: 2px;";
		removeBtn.href = "javascript:void(0);";
		removeBtn.onclick = function() {
			removeElements(this, 'closedRangeElement', baseClosedRangeElementsLength, dynamicClosedRangeElementsLength);
		};
		removeBtn.innerText = "-";

		container.appendChild(br);
		container.appendChild(a1);
		container.appendChild(span1);
		container.appendChild(startInput);
		container.appendChild(a2);
		container.appendChild(span2);
		container.appendChild(endInput);
		container.appendChild(removeBtn);

		parentContainer.appendChild(container);

		adjustElementsIndex("closedRangeElement", baseClosedRangeElementsLength, dynamicClosedRangeElementsLength);
	}
</script>

<script>	/* 다국어 영업 시간 (businessHoursType) 관련 */
	let selectedLanguage = 'KO';

	function selectLanguage(language) {
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
		document.querySelectorAll('.language-tabs a').forEach(function(btn) {
			btn.classList.remove('active');
		});
		document.querySelector('.language-tabs a[onclick="selectLanguage(\'' + language + '\')"]').classList.add('active');
	}
</script>

<script>	/* 영업 시간 (businessHoursType) 팝업 타입 전환 */
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

<script>	/* 허용 IP 추가/삭제 */
	const $box = $(".allowIPBox");
	const $input = $box.find(".input_btn").eq(0).clone();

	function nextTabIndex() {
		return $("[tabindex]").map((i, e) => parseInt(e.getAttribute("tabindex")))
			.toArray()
			.reduce((acc, val) => acc >= val ? acc : val) + 1;
	}

	function ipAdd() {
		const $new = $input.clone();
		$new.find("input")
			.attr("tabindex", nextTabIndex())
			.val("");
		$new.find("a")
			.on("click", ipDel)
			.removeAttr("href")
			.text("삭제");
		$new.appendTo($box);
	}

	function ipDel() {
		$(this).parent().remove();
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