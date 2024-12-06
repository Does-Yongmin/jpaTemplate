<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.google.gson.Gson" %>
<%@ include file="/include/uploadForm.jsp" %>
<%@ page import="com.does.biz.primary.domain.kv.MainKeyVisualType" %>
<%
	request.setAttribute("kvType", MainKeyVisualType.values());
	request.setAttribute("kvTypeNormal", MainKeyVisualType.NORMAL);
	request.setAttribute("kvTypeEvent", MainKeyVisualType.EVENT);
	request.setAttribute("colspan", 2);
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
<c:set var="gson" value="<%= new Gson() %>" />
<c:set var="isNew" value="${empty data.seq}" scope="page"/>

<div id="pageTitle">메인 KV 관리</div>

<ul class="pageGuide">
	<li><span class="red">*</span> 표시는 필수항목입니다.</li>
	<li><span class="red"><b>국문은 필수</b></span>로 입력해야하며, 다국어는 선택적으로 정보가 기재된 언어만 홈페이지에 노출됩니다.</li>
</ul>

<div class="detailBox">
	<form method="post" name="workForm" action="save">
		<input type="hidden" name="seq" value="${fn:escapeXml(data.seq)}"/>
		<input type="hidden" name="pageNum" value="${fn:escapeXml(search.pageNum)}"/>
		<table>
			<tbody>
			<tr>
				<th required colspan="<c:out value='${colspan}'/>">키비주얼 타입</th>
				<td>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="kvTypeNormal" name="kvType"
							   value="<c:out value='${kvTypeNormal}'/>" />
						<label for="kvTypeNormal">일반</label>

						<input type="radio" id="kvTypeEvent" name="kvType"
							   value="<c:out value='${kvTypeEvent}'/>" checked />
						<label for="kvTypeEvent">이벤트</label>
					</c:if>
					<c:if test="${not isNew}">
						<input type="radio" id="kvTypeNormal" name="kvType"
							   value="<c:out value='${kvTypeNormal}'/>" ${data.kvType eq kvTypeNormal ? 'checked' : '' } />
						<label for="kvTypeNormal">일반</label>

						<input type="radio" id="kvTypeEvent" name="kvType"
							   value="<c:out value='${kvTypeEvent}'/>" ${data.kvType eq kvTypeEvent ? 'checked' : '' } />
						<label for="kvTypeEvent">이벤트</label>
					</c:if>
				</td>
			</tr>

			<tbody id="eventUrl" style="display: none;">
			<tr>
				<th required colspan="<c:out value='${colspan}'/>">연결 이벤트 URL</th>
				<td>
					<input type="text" name="eventUrl" class="w500" value="<c:out value='${data.eventUrl}'/>" autocomplete="off" maxlength="200"
						   placeholder="이벤트 페이지 url 입력">
					<br>
					&nbsp;
					<input type="checkbox" name="blankYn" value="Y" ${data.blankYn eq 'Y' ? 'checked' : ''} id="blankYn"/>
					<label for="blankYn">새 창 열기</label>
				</td>
			</tr>
			</tbody>

			<tbody id="kvSelectedLangs" style="display: none;">
			<tr>
				<th required colspan="<c:out value='${colspan}'/>">제공언어</th>
				<td>
					<input type="hidden" name="kvSelectedLangs">
					<div class="language-tabs">
						<input type="hidden" name="kvSelectedLangKo" id="kvSelectedLangKo" value="KO">
						<input type="hidden" name="kvSelectedLangEn" id="kvSelectedLangEn" value="">
						<input type="hidden" name="kvSelectedLangJp" id="kvSelectedLangJp" value="">
						<input type="hidden" name="kvSelectedLangCn" id="kvSelectedLangCn" value="">
						<a type="button" id="kvSelectedLangKoBtn" class="mot3 langBtn-round active" onclick="selectLanguage('KO')">국문</a>
						<a type="button" id="kvSelectedLangEnBtn" class="mot3 langBtn-round" onclick="selectLanguage('EN')">영문</a>
						<a type="button" id="kvSelectedLangJpBtn" class="mot3 langBtn-round" onclick="selectLanguage('JP')">일문</a>
						<a type="button" id="kvSelectedLangCnBtn" class="mot3 langBtn-round" onclick="selectLanguage('CN')">중문</a>
					</div>
				</td>
			</tr>
			</tbody>

			<tbody id="eventSelectedLangs" style="display: none;">
			<tr>
				<th required colspan="<c:out value='${colspan}'/>">제공언어</th>
				<td>
					<input type="hidden" name="eventSelectedLangs">
					<div class="language-tabs">
						<input type="hidden" name="eventSelectedLangKo" id="eventSelectedLangKo" value="KO">
						<input type="hidden" name="eventSelectedLangEn" id="eventSelectedLangEn" value="">
						<input type="hidden" name="eventSelectedLangJp" id="eventSelectedLangJp" value="">
						<input type="hidden" name="eventSelectedLangCn" id="eventSelectedLangCn" value="">
						<a type="button" id="eventSelectedLangKoBtn" class="mot3 langBtn-round active" onclick="selectLanguage('KO')">국문</a>
						<a type="button" id="eventSelectedLangEnBtn" class="mot3 langBtn-round" onclick="selectLanguage('EN')">영문</a>
						<a type="button" id="eventSelectedLangJpBtn" class="mot3 langBtn-round" onclick="selectLanguage('JP')">일문</a>
						<a type="button" id="eventSelectedLangCnBtn" class="mot3 langBtn-round" onclick="selectLanguage('CN')">중문</a>
					</div>
				</td>
			</tr>
			</tbody>

			<tbody id="kvTitle" style="display: none;">
			<tr>
				<th required colspan="<c:out value='${colspan}'/>">제목</th>
				<td>
					<input type="text" id="kvTitleKo" name="kvTitleKo" class="w500" value="<c:out value='${data.kvTitleKo}'/>" onkeyup="setValidLang();" maxlength="100"
						autocomplete="off" placeholder="키비주얼 제목을 입력해 주세요. (국문)">
					<input type="hidden" id="kvTitleEn" name="kvTitleEn" class="w500" value="<c:out value='${data.kvTitleEn}'/>" onkeyup="setValidLang();" maxlength="100"
						autocomplete="off" placeholder="키비주얼 제목을 입력해 주세요. (영문)">
					<input type="hidden" id="kvTitleJp" name="kvTitleJp" class="w500" value="<c:out value='${data.kvTitleJp}'/>" onkeyup="setValidLang();" maxlength="100"
						autocomplete="off" placeholder="키비주얼 제목을 입력해 주세요. (일문)">
					<input type="hidden" id="kvTitleCn" name="kvTitleCn" class="w500" value="<c:out value='${data.kvTitleCn}'/>" onkeyup="setValidLang();" maxlength="100"
						autocomplete="off" placeholder="키비주얼 제목을 입력해 주세요. (중문)">
				</td>
			</tr>
			</tbody>

			<tbody id="eventTitle" style="display: none;">
			<tr>
				<th required colspan="<c:out value='${colspan}'/>">제목</th>
				<td>
					<input type="text" id="eventTitleKo" name="eventTitleKo" class="w500" value="<c:out value='${data.eventTitleKo}'/>" onkeyup="setValidLang();" maxlength="100"
						autocomplete="off" placeholder="이벤트 제목을 입력해 주세요. (국문)">
					<input type="hidden" id="eventTitleEn" name="eventTitleEn" class="w500" value="<c:out value='${data.eventTitleEn}'/>" onkeyup="setValidLang();" maxlength="100"
						autocomplete="off" placeholder="이벤트 제목을 입력해 주세요. (영문)">
					<input type="hidden" id="eventTitleJp" name="eventTitleJp" class="w500" value="<c:out value='${data.eventTitleJp}'/>" onkeyup="setValidLang();" maxlength="100"
						autocomplete="off" placeholder="이벤트 제목을 입력해 주세요. (일문)">
					<input type="hidden" id="eventTitleCn" name="eventTitleCn" class="w500" value="<c:out value='${data.eventTitleCn}'/>" onkeyup="setValidLang();" maxlength="100"
						autocomplete="off" placeholder="이벤트 제목을 입력해 주세요. (중문)">
				</td>
			</tr>
			</tbody>

			<%-- PC elemnts start --%>
			<tbody id="kvImgP" style="display: none;">
			<tr>
				<th required rowspan="3">PC</th>

				<tr>
					<th required>이미지</th>
					<td>
						<c:set var="attach" value="${data.kvImgP}" scope="request"/>
						<jsp:include page="/include/component/fileUpload.jsp">
							<jsp:param name="t_required" value="true"/>
							<jsp:param name="t_ment" value='<%=imageRecommend(1280, 1080, "@2배수 권장")%>'/>
							<jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
							<jsp:param name="t_fileName" value="kvImgP"/>
							<jsp:param name="t_tag" value="KV_IMG_P"/>
							<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
						</jsp:include>
					</td>
				</tr>
				<tr>
					<th required>이미지 대체 텍스트</th>
					<td>
						<input type="text" id="kvImgAltTxtKoP" name="kvImgAltTxtKoP" class="w500" value="<c:out value='${data.kvImgAltTxtKoP}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (국문)">
						<input type="hidden" id="kvImgAltTxtEnP" name="kvImgAltTxtEnP" class="w500" value="<c:out value='${data.kvImgAltTxtEnP}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (영문)">
						<input type="hidden" id="kvImgAltTxtJpP" name="kvImgAltTxtJpP" class="w500" value="<c:out value='${data.kvImgAltTxtJpP}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (일문)">
						<input type="hidden" id="kvImgAltTxtCnP" name="kvImgAltTxtCnP" class="w500" value="<c:out value='${data.kvImgAltTxtCnP}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (중문)">
					</td>
				</tr>
			</tr>
			</tbody>

			<tbody id="eventImgP" style="display: none;">
			<tr>
				<th required rowspan="3">PC</th>

				<tr>
					<th required>이미지</th>
					<td>
						<c:set var="attach" value="${data.eventImgP}" scope="request"/>
						<jsp:include page="/include/component/fileUpload.jsp">
							<jsp:param name="t_required" value="true"/>
							<jsp:param name="t_ment" value="<%=image(1280, 1080)%>"/>
							<jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
							<jsp:param name="t_fileName" value="eventImgP"/>
							<jsp:param name="t_tag" value="EVENT_IMG_P"/>
							<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
						</jsp:include>
					</td>
				</tr>
				<tr>
					<th required>이미지 대체 텍스트</th>
					<td>
						<input type="text" id="eventImgAltTxtKoP" name="eventImgAltTxtKoP" class="w500" value="<c:out value='${data.eventImgAltTxtKoP}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (국문)">
						<input type="hidden" id="eventImgAltTxtEnP" name="eventImgAltTxtEnP" class="w500" value="<c:out value='${data.eventImgAltTxtEnP}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (영문)">
						<input type="hidden" id="eventImgAltTxtJpP" name="eventImgAltTxtJpP" class="w500" value="<c:out value='${data.eventImgAltTxtJpP}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (일문)">
						<input type="hidden" id="eventImgAltTxtCnP" name="eventImgAltTxtCnP" class="w500" value="<c:out value='${data.eventImgAltTxtCnP}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (중문)">
					</td>
				</tr>
			</tr>
			</tbody>
			<%-- PC elemnts end --%>

			<%-- Mobile elemnts start --%>
			<tbody id="kvImgM" style="display: none;">
			<tr>
				<th required rowspan="3">MO</th>

				<tr>
					<th required>이미지</th>
					<td>
						<c:set var="attach" value="${data.kvImgM}" scope="request"/>
						<jsp:include page="/include/component/fileUpload.jsp">
							<jsp:param name="t_required" value="true"/>
							<jsp:param name="t_ment" value='<%=imageRecommend(390, 390, "@2배수 권장")%>'/>
							<jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
							<jsp:param name="t_fileName" value="kvImgM"/>
							<jsp:param name="t_tag" value="KV_IMG_M"/>
							<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
						</jsp:include>
					</td>
				</tr>
				<tr>
					<th required>이미지 대체 텍스트</th>
					<td>
						<input type="text" id="kvImgAltTxtKoM" name="kvImgAltTxtKoM" class="w500" value="<c:out value='${data.kvImgAltTxtKoM}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (국문)">
						<input type="hidden" id="kvImgAltTxtEnM" name="kvImgAltTxtEnM" class="w500" value="<c:out value='${data.kvImgAltTxtEnM}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (영문)">
						<input type="hidden" id="kvImgAltTxtJpM" name="kvImgAltTxtJpM" class="w500" value="<c:out value='${data.kvImgAltTxtJpM}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (일문)">
						<input type="hidden" id="kvImgAltTxtCnM" name="kvImgAltTxtCnM" class="w500" value="<c:out value='${data.kvImgAltTxtCnM}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (중문)">
					</td>
				</tr>
			</tr>
			</tbody>

			<tbody id="eventImgM" style="display: none;">
			<tr>
				<th required rowspan="3">MO</th>

				<tr>
					<th required>이미지</th>
					<td>
						<c:set var="attach" value="${data.eventImgM}" scope="request"/>
						<jsp:include page="/include/component/fileUpload.jsp">
							<jsp:param name="t_required" value="true"/>
							<jsp:param name="t_ment" value="<%=image(390, 390)%>"/>
							<jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
							<jsp:param name="t_fileName" value="eventImgM"/>
							<jsp:param name="t_tag" value="EVENT_IMG_M"/>
							<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
						</jsp:include>
					</td>
				</tr>
				<tr>
					<th required>이미지 대체 텍스트</th>
					<td>
						<input type="text" id="eventImgAltTxtKoM" name="eventImgAltTxtKoM" class="w500" value="<c:out value='${data.eventImgAltTxtKoM}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (국문)">
						<input type="hidden" id="eventImgAltTxtEnM" name="eventImgAltTxtEnM" class="w500" value="<c:out value='${data.eventImgAltTxtEnM}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (영문)">
						<input type="hidden" id="eventImgAltTxtJpM" name="eventImgAltTxtJpM" class="w500" value="<c:out value='${data.eventImgAltTxtJpM}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (일문)">
						<input type="hidden" id="eventImgAltTxtCnM" name="eventImgAltTxtCnM" class="w500" value="<c:out value='${data.eventImgAltTxtCnM}'/>" onkeyup="setValidLang();" maxlength="200"
							autocomplete="off" placeholder="대체 텍스트를 입력해 주세요. (중문)">
					</td>
				</tr>
			</tr>
			</tbody>
			<%-- Mobile elemnts end --%>

			<tbody>
			<tr>
				<th required rowspan="3">게시 기간</th>

				<tr>
					<th required>게시 시작 일자</th>
					<td>
						<jsp:include page="/include/component/dateTime.jsp" flush="false">
							<jsp:param name="dateName"	value="sDate"/><jsp:param name="dateValue"			value="${fn:escapeXml(data.SDate)}"/>
							<jsp:param name="hourName"	value="sTimeHour"/><jsp:param name="hourValue"		value="${fn:escapeXml(data.STimeHour)}"/>
							<jsp:param name="minName"	value="sTimeMinute"/> <jsp:param name="minValue"	value="${fn:escapeXml(data.STimeMinute)}"/>
						</jsp:include>
					</td>
				</tr>
				<tr>
					<th required>게시 종료 일자</th>
					<td>
						<jsp:include page="/include/component/dateTime.jsp" flush="false">
							<jsp:param name="dateName"	value="eDate"/><jsp:param name="dateValue"			value="${fn:escapeXml(data.EDate)}"/>
							<jsp:param name="hourName"	value="eTimeHour"/><jsp:param name="hourValue"		value="${fn:escapeXml(data.ETimeHour)}"/>
							<jsp:param name="minName"	value="eTimeMinute"/> <jsp:param name="minValue"	value="${fn:escapeXml(data.ETimeMinute)}"/>
						</jsp:include>
						&nbsp;
						<input type="checkbox" name="indefiniteYn" value="Y" ${data.indefiniteYn eq 'Y' ? 'checked' : ''} id="indefiniteYn" />
						<label for="indefiniteYn">무기한</label>
					</td>
				</tr>
			</tr>

			<tr>
				<th required colspan="<c:out value='${colspan}'/>">공개여부</th>
				<td>
					&nbsp;
					<c:if test="${isNew}">
						<input type="radio" id="useY" name="useYn" value="Y" checked/>
						<label for="useY">공개</label>
						<input type="radio" id="useN" name="useYn" value="N"/>
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
	</form>
</div>

<%--######################## 스크립트 ########################--%>
<script src="<c:out value='${cPath}'/>/assets/js/detail.js" charset="utf-8" type="text/javascript"></script>

<script>	/* 게시글 로드 시, 기본 설정 */
	const kvInputs = [
		'kvTitleKo', 'kvTitleEn', 'kvTitleJp', 'kvTitleCn',
		'kvImgAltTxtKoP', 'kvImgAltTxtEnP', 'kvImgAltTxtJpP', 'kvImgAltTxtCnP',
		'kvImgAltTxtKoM', 'kvImgAltTxtEnM', 'kvImgAltTxtJpM', 'kvImgAltTxtCnM'
	];
	const eventInputs = [
		'eventTitleKo', 'eventTitleEn', 'eventTitleJp', 'eventTitleCn',
		'eventImgAltTxtKoP', 'eventImgAltTxtEnP', 'eventImgAltTxtJpP', 'eventImgAltTxtCnP',
		'eventImgAltTxtKoM', 'eventImgAltTxtEnM', 'eventImgAltTxtJpM', 'eventImgAltTxtCnM'
	];
	const kvImgP = document.querySelector('input[name="kvImgP.file"]');
	const kvImgM = document.querySelector('input[name="kvImgM.file"]');
	const eventImgP = document.querySelector('input[name="eventImgP.file"]');
	const eventImgM = document.querySelector('input[name="eventImgM.file"]');
	let isKvImgP = false;
	let isKvImgM = false;
	let isEventImgP = false;
	let isEventImgM = false;

	let kvType = "${fn:escapeXml(data.kvType)}";
	let kvSelectedLangsList = ${data.kvSelectedLangsList == null ? [] : gson.toJson(data.kvSelectedLangsList)};
	let eventSelectedLangsList = ${data.eventSelectedLangsList == null ? [] : gson.toJson(data.eventSelectedLangsList)};

	let kvTypeNormalElement = document.getElementById('kvTypeNormal');
	let kvTypeEventElement = document.getElementById('kvTypeEvent');

	window.onload = function() {
		toggleDisplay();
		toggleIndefinite();
		toggleFields('Ko');

		applyValidationToUploadedImage();
		setValidLang();
		setAutoInputValue();
		setImageChangeListener();

		kvTypeNormalElement.addEventListener('click', () => {
			selectLanguage("KO");
		});
		kvTypeEventElement.addEventListener('click', () => {
			selectLanguage("KO");
		});
	}
</script>

<script>    /* 게시글 저장 시, 전처리 */
	function goToSave() {
		setValidLang();

		combineSelectedLangForSubmission();
		submitFormIntoHiddenFrame(document.workForm);
	}
</script>

<script>	/* 이미지 업로드에 대한 Validation */
	function applyValidationToUploadedImage() {
		const uploadedKvImgP = document.querySelector('input[name="kvImgP.fileId"]');
		const uploadedKvImgM = document.querySelector('input[name="kvImgM.fileId"]');
		const uploadedEventImgP = document.querySelector('input[name="eventImgP.fileId"]');
		const uploadedEventImgM = document.querySelector('input[name="eventImgM.fileId"]');

		if (uploadedKvImgP.value.trim()) {
			isKvImgP = true;
		}
		if (uploadedKvImgM.value.trim()) {
			isKvImgM = true;
		}
		if (uploadedEventImgP.value.trim()) {
			isEventImgP = true;
		}
		if (uploadedEventImgM.value.trim()) {
			isEventImgM = true;
		}
	}

	function setImageChangeListener() {
		kvImgP.addEventListener('change', function() {
			isKvImgP = true;
			setValidLang();
		});
		kvImgM.addEventListener('change', function() {
			isKvImgM = true;
			setValidLang();
		});
		eventImgP.addEventListener('change', function() {
			isEventImgP = true;
			setValidLang();
		});
		eventImgM.addEventListener('change', function() {
			isEventImgM = true;
			setValidLang();
		});
	}
</script>

<script>    /* 제공 언어 관련 */
	function combineSelectedLangForSubmission() {
		let kvSelectedLangs = [];
		let eventSelectedLangs = [];

		if (document.getElementById('kvSelectedLangKo').value) {
			kvSelectedLangs.push('KO');
		}
		if (document.getElementById('kvSelectedLangEn').value) {
			kvSelectedLangs.push('EN');
		}
		if (document.getElementById('kvSelectedLangJp').value) {
			kvSelectedLangs.push('JP');
		}
		if (document.getElementById('kvSelectedLangCn').value) {
				kvSelectedLangs.push('CN');
		}

		if (document.getElementById('eventSelectedLangKo').value) {
			eventSelectedLangs.push('KO');
		}
		if (document.getElementById('eventSelectedLangEn').value) {
			eventSelectedLangs.push('EN');
		}
		if (document.getElementById('eventSelectedLangJp').value) {
			eventSelectedLangs.push('JP');
		}
		if (document.getElementById('eventSelectedLangCn').value) {
			eventSelectedLangs.push('CN');
		}

		document.getElementsByName('kvSelectedLangs')[0].value = kvSelectedLangs.join(',');
		document.getElementsByName('eventSelectedLangs')[0].value = eventSelectedLangs.join(',');
	}

	function selectLanguage(selectedLang) {
		let selectedLangKoString;
		let selectedLangEnString;
		let selectedLangJpString;
		let selectedLangCnString;
		let selectedLangKoBtnString;
		let selectedLangEnBtnString;
		let selectedLangJpBtnString;
		let selectedLangCnBtnString;

		if (kvType === "${fn:escapeXml(kvTypeNormal)}") {
			selectedLangKoString = `kvSelectedLangKo`;
			selectedLangEnString = `kvSelectedLangEn`;
			selectedLangJpString = `kvSelectedLangJp`;
			selectedLangCnString = `kvSelectedLangCn`;
			selectedLangKoBtnString = `kvSelectedLangKoBtn`;
			selectedLangEnBtnString = `kvSelectedLangEnBtn`;
			selectedLangJpBtnString = `kvSelectedLangJpBtn`;
			selectedLangCnBtnString = `kvSelectedLangCnBtn`;
		} else if (kvType === "${fn:escapeXml(kvTypeEvent)}") {
			selectedLangKoString = `eventSelectedLangKo`;
			selectedLangEnString = `eventSelectedLangEn`;
			selectedLangJpString = `eventSelectedLangJp`;
			selectedLangCnString = `eventSelectedLangCn`;
			selectedLangKoBtnString = `eventSelectedLangKoBtn`;
			selectedLangEnBtnString = `eventSelectedLangEnBtn`;
			selectedLangJpBtnString = `eventSelectedLangJpBtn`;
			selectedLangCnBtnString = `eventSelectedLangCnBtn`;
		}

		let selectedLangKoElement = document.getElementById(selectedLangKoString);
		let selectedLangEnElement = document.getElementById(selectedLangEnString);
		let selectedLangJpElement = document.getElementById(selectedLangJpString);
		let selectedLangCnElement = document.getElementById(selectedLangCnString);
		let selectedLangKoBtnElement = document.getElementById(selectedLangKoBtnString);
		let selectedLangEnBtnElement = document.getElementById(selectedLangEnBtnString);
		let selectedLangJpBtnElement = document.getElementById(selectedLangJpBtnString);
		let selectedLangCnBtnElement = document.getElementById(selectedLangCnBtnString);

		selectedLangKoElement.value = "KO";
		selectedLangEnElement.value = "";
		selectedLangJpElement.value = "";
		selectedLangCnElement.value = "";
		selectedLangKoBtnElement.classList.remove("active");
		selectedLangEnBtnElement.classList.remove("active");
		selectedLangJpBtnElement.classList.remove("active");
		selectedLangCnBtnElement.classList.remove("active");

		switch (selectedLang) {
			case 'KO':
				selectedLangKoElement.value = "KO";
				selectedLangKoBtnElement.classList.add("active");
				break;
			case 'EN':
				selectedLangEnElement.value = "EN";
				selectedLangEnBtnElement.classList.add("active");
				break;
			case 'JP':
				selectedLangJpElement.value = "JP";
				selectedLangJpBtnElement.classList.add("active");
				break;
			case 'CN':
				selectedLangCnElement.value = "CN";
				selectedLangCnBtnElement.classList.add("active");
				break;
		}

		toggleDisplay();
		toggleFields(selectedLang);
		setValidLang();
	}

	// 필수 데이터를 검사하여 각 제공언어 버튼에 Validation 표시
	function setValidLang() {
		document.getElementById(`kvSelectedLangKoBtn`).classList.remove("valid");
		document.getElementById(`kvSelectedLangEnBtn`).classList.remove("valid");
		document.getElementById(`kvSelectedLangJpBtn`).classList.remove("valid");
		document.getElementById(`kvSelectedLangCnBtn`).classList.remove("valid");
		document.getElementById(`eventSelectedLangKoBtn`).classList.remove("valid");
		document.getElementById(`eventSelectedLangEnBtn`).classList.remove("valid");
		document.getElementById(`eventSelectedLangJpBtn`).classList.remove("valid");
		document.getElementById(`eventSelectedLangCnBtn`).classList.remove("valid");

		document.getElementById(`kvSelectedLangKoBtn`).classList.remove("invalid");
		document.getElementById(`kvSelectedLangEnBtn`).classList.remove("invalid");
		document.getElementById(`kvSelectedLangJpBtn`).classList.remove("invalid");
		document.getElementById(`kvSelectedLangCnBtn`).classList.remove("invalid");
		document.getElementById(`eventSelectedLangKoBtn`).classList.remove("invalid");
		document.getElementById(`eventSelectedLangEnBtn`).classList.remove("invalid");
		document.getElementById(`eventSelectedLangJpBtn`).classList.remove("invalid");
		document.getElementById(`eventSelectedLangCnBtn`).classList.remove("invalid");

		let isValid = true;
		const languages = ["Ko", "En", "Jp", "Cn"];

		// 필수 데이터를 모두 입력한 경우 valid, 하나라도 조건을 만족하지 않으면 invalid 처리, 비어있으면 empty
		languages.forEach(lang => {
			// 일반 키비주얼일 때
			let kvTitle = document.querySelector(`input[name="kvTitle` + lang + `"]`);
			let kvImgAltTxtP = document.querySelector(`input[name="kvImgAltTxt` + lang + `P"]`);
			let kvImgAltTxtM = document.querySelector(`input[name="kvImgAltTxt` + lang + `M"]`);
			let kvLangBtn = document.getElementById(`kvSelectedLang` + lang + `Btn`);
			let kvLangField = document.getElementById(`kvSelectedLang` + lang);

			const isKvTitleFilled = kvTitle.value.trim() !== "";
			const isKvAltTxtPFilled = kvImgAltTxtP.value.trim() !== ""
			const isKvAltTxtMFilled = kvImgAltTxtM.value.trim() !== "";

			if (isKvTitleFilled && isKvAltTxtPFilled && isKvAltTxtMFilled && isKvImgP && isKvImgM) {
				kvLangBtn.classList.remove("invalid");
				kvLangBtn.classList.add("valid");
				kvLangField.value = lang.toUpperCase();
			} else if (lang !== "Ko" &&
					(!isKvTitleFilled && !isKvAltTxtPFilled && !isKvAltTxtMFilled)) {
				kvLangBtn.classList.remove("invalid");
				kvLangField.value = "";
			} else {
				kvLangBtn.classList.remove("valid");
				kvLangBtn.classList.add("invalid");
				kvLangField.value = lang.toUpperCase();
				isValid = false;
			}

			// 이벤트일 때
			let eventTitle = document.querySelector(`input[name="eventTitle` + lang + `"]`);
			let eventImgAltTxtP = document.querySelector(`input[name="eventImgAltTxt` + lang + `P"]`);
			let eventImgAltTxtM = document.querySelector(`input[name="eventImgAltTxt` + lang + `M"]`);
			let langBtn = document.getElementById(`eventSelectedLang` + lang + `Btn`);
			let langField = document.getElementById(`eventSelectedLang` + lang);

			const isTitleFilled = eventTitle.value.trim() !== "";
			const isAltTxtPFilled = eventImgAltTxtP.value.trim() !== ""
			const isAltTxtMFilled = eventImgAltTxtM.value.trim() !== "";

			if (isTitleFilled && isAltTxtPFilled && isAltTxtMFilled && isEventImgP && isEventImgM) {
				langBtn.classList.remove("invalid");
				langBtn.classList.add("valid");
				langField.value = lang.toUpperCase();
			} else if (lang !== "Ko" &&
					(!isTitleFilled && !isAltTxtPFilled && !isAltTxtMFilled)) {
				langBtn.classList.remove("invalid");
				langField.value = "";
			} else {
				langBtn.classList.remove("valid");
				langBtn.classList.add("invalid");
				langField.value = lang.toUpperCase();
				isValid = false;
			}
		});

		return isValid;
	}

	// 언어 선택에 따른 입력 필드 변경
	function toggleFields(selectedLang) {
		const isNormal = kvType === "${fn:escapeXml(kvTypeNormal)}";
		const isEvent = kvType === "${fn:escapeXml(kvTypeEvent)}";
		const languages = ["Ko", "En", "Jp", "Cn"];
		const transformedLang = selectedLang.slice(0, -1) + selectedLang.slice(-1).toLowerCase();  // 마지막 문자만 소문자로 변환

		document.querySelectorAll('span.length').forEach(function(span) {
			span.style.display = 'none';
		});

		languages.forEach(lang => {
			let kvTitle = `input[name="kvTitle` + lang + `"]`;
			let kvImgAltTxtP = `input[name="kvImgAltTxt` + lang + `P"]`;
			let kvImgAltTxtM = `input[name="kvImgAltTxt` + lang + `M"]`;

			let eventTitle = `input[name="eventTitle` + lang + `"]`;
			let eventImgAltTxtP = `input[name="eventImgAltTxt` + lang + `P"]`;
			let eventImgAltTxtM = `input[name="eventImgAltTxt` + lang + `M"]`;

			let kvTitleElement = document.querySelector(kvTitle);
			let kvImgAltTxtPElement = document.querySelector(kvImgAltTxtP);
			let kvImgAltTxtMElement = document.querySelector(kvImgAltTxtM);

			let eventTitleElement = document.querySelector(eventTitle);
			let eventImgAltTxtPElement = document.querySelector(eventImgAltTxtP);
			let eventImgAltTxtMElement = document.querySelector(eventImgAltTxtM);

			kvTitleElement.type = (lang === transformedLang && isNormal) ? "text" : "hidden";
			kvImgAltTxtPElement.type = (lang === transformedLang && isNormal) ? "text" : "hidden";
			kvImgAltTxtMElement.type = (lang === transformedLang && isNormal) ? "text" : "hidden";

			eventTitleElement.type = (lang === transformedLang && isEvent) ? "text" : "hidden";
			eventImgAltTxtPElement.type = (lang === transformedLang && isEvent) ? "text" : "hidden";
			eventImgAltTxtMElement.type = (lang === transformedLang && isEvent) ? "text" : "hidden";

			if (kvTitleElement.nextElementSibling && kvTitleElement.nextElementSibling.classList.contains('length')) {
				kvTitleElement.nextElementSibling.style.display = (lang === transformedLang) ? 'inline-block' : 'none';
			}
			if (kvImgAltTxtPElement.nextElementSibling && kvImgAltTxtPElement.nextElementSibling.classList.contains('length')) {
				kvImgAltTxtPElement.nextElementSibling.style.display = (lang === transformedLang) ? 'inline-block' : 'none';
			}
			if (kvImgAltTxtMElement.nextElementSibling && kvImgAltTxtMElement.nextElementSibling.classList.contains('length')) {
				kvImgAltTxtMElement.nextElementSibling.style.display = (lang === transformedLang) ? 'inline-block' : 'none';
			}

			if (eventTitleElement.nextElementSibling && eventTitleElement.nextElementSibling.classList.contains('length')) {
				eventTitleElement.nextElementSibling.style.display = (lang === transformedLang) ? 'inline-block' : 'none';
			}
			if (eventImgAltTxtPElement.nextElementSibling && eventImgAltTxtPElement.nextElementSibling.classList.contains('length')) {
				eventImgAltTxtPElement.nextElementSibling.style.display = (lang === transformedLang) ? 'inline-block' : 'none';
			}
			if (eventImgAltTxtMElement.nextElementSibling && eventImgAltTxtMElement.nextElementSibling.classList.contains('length')) {
				eventImgAltTxtMElement.nextElementSibling.style.display = (lang === transformedLang) ? 'inline-block' : 'none';
			}

			const eventUrlInput = document.querySelector(`input[name="eventUrl"]`);
			if (eventUrlInput && eventUrlInput.nextElementSibling && eventUrlInput.nextElementSibling.classList.contains('length')) {
				eventUrlInput.nextElementSibling.style.display = (isEvent) ? 'inline-block' : 'none';
			}
		});
	}
</script>

<script>
	function toggleDisplay() {
		// 키비주얼 타입이 '일반' 인지 '이벤트' 인지에 따라 처리
		const kvTypeNormal = document.getElementById('kvTypeNormal').checked;

		if (kvTypeNormal) {
			document.getElementById('kvSelectedLangs').style.display = 'table-row-group';
			document.getElementById('kvTitle').style.display = 'table-row-group';
			document.getElementById('kvImgP').style.display = 'table-row-group';
			document.getElementById('kvImgM').style.display = 'table-row-group';

			document.getElementById('eventSelectedLangs').style.display = 'none';
			document.getElementById('eventTitle').style.display = 'none';
			document.getElementById('eventImgP').style.display = 'none';
			document.getElementById('eventImgM').style.display = 'none';
			document.getElementById('eventUrl').style.display = 'none';

			kvType = "NORMAL";
		}
		else {
			document.getElementById('kvSelectedLangs').style.display = 'none';
			document.getElementById('kvTitle').style.display = 'none';
			document.getElementById('kvImgP').style.display = 'none';
			document.getElementById('kvImgM').style.display = 'none';

			document.getElementById('eventSelectedLangs').style.display = 'table-row-group';
			document.getElementById('eventTitle').style.display = 'table-row-group';
			document.getElementById('eventImgP').style.display = 'table-row-group';
			document.getElementById('eventImgM').style.display = 'table-row-group';
			document.getElementById('eventUrl').style.display = 'table-row-group';

			kvType = "EVENT";
		}
	}
</script>

<script>
	// 무기한 체크박스 클릭 시 toggleIndefinite 함수 호출
	document.getElementById('indefiniteYn').addEventListener('change', toggleIndefinite);

	// 무기한 체크박스 선택 시 종료 일자 / 시간 비활성화
	function toggleIndefinite() {
		const isChecked = document.getElementById('indefiniteYn').checked;
		const eDate = document.getElementsByName('eDate')[0];
		const eTimeHour = document.getElementsByName('eTimeHour')[0];
		const eTimeMinute = document.getElementsByName('eTimeMinute')[0];

		if (isChecked) {
			eDate.disabled = true;
			eTimeHour.disabled = true;
			eTimeMinute.disabled = true;
			eDate.value = "";
			eTimeHour.value = "";
			eTimeMinute.value = "";
		} else {
			eDate.disabled = false;
			eTimeHour.disabled = false;
			eTimeMinute.disabled = false;
		}
	}
</script>

<script>
	// 사용자가 input 필드에 값 입력시, 저장하지 않아도 바로 value 되도록하는 함수
	function setAutoInputValue() {
		kvInputs.forEach(function (inputId) {
			let inputElem = document.getElementById(inputId);
			if (inputElem) {
				inputElem.addEventListener('input', function () {
					inputElem.setAttribute('value', this.value);
				});
			}
		});

		eventInputs.forEach(function (inputId) {
			let inputElem = document.getElementById(inputId);
			if (inputElem) {
				inputElem.addEventListener('input', function () {
					inputElem.setAttribute('value', this.value);
				});
			}
		});
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