<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/uploadForm.jsp" %>
<%@ page import="com.does.component.AttachPathResolver" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>

	<style type="text/css">
		#secondCustomInput{
			width: 120px;
		}

		/* default 모든 언어값 별 영역 숨김 처리후 국문만 활성화 */
		.language-target{
			display: none;
		}
		.language-target.language-ko{
			display: block;
		}

		div.thumbnail-container {
			width: 100px; /* 원하는 썸네일의 너비 */
			height: 100px; /* 원하는 썸네일의 높이 */
			overflow: hidden; /* 이미지가 컨테이너를 넘어가지 않도록 함 */
			display: flex;
			align-items: center;
			justify-content: center;
			float: left;
		}
		/* 콘텐츠 이미지 썸네일 */
		img.thumbnail {
			max-width: 100%;
			max-height: 100%;
			object-fit: cover; /* 비율을 유지하며 컨테이너를 채우도록 조절 */
		}

		.file-container {
			margin-left: 110px;
			padding-top: 10px;
		}

		.lang-select a {padding: 10px 20px;border: 1px solid; cursor: pointer; }
		.lang-select a.selected {border: 2px solid #000000; font-weight: bold; box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.5);}
		.required:after {content:" *"; color: red;}
	</style>
</head>

<body>
<c:set var="isNew" value="${empty data.seq}" scope="page"/>

<%-- pageTitle은 Aspect 로 삽입 --%>
<div id="pageTitle"><c:out value="${pageTitle}"/></div>

<ul class="pageGuide">
	<li><span class="red">*</span> 는 필수 항목입니다. 필수 항목을 입력하지 않을 경우, 등록이 완료되지 않습니다.</li>
	<li>노출할 키오스크 종류는 중복 선택이 가능합니다.</li>
	<li>게시 종료 일자를 무기한으로 설정한 경우, 공개 여부를 수정하기 전까지는 계속 노출 됩니다.</li>
</ul>

<div class="detailBox">
	<form method="post" name="workForm" action="save">
		<input type="hidden" name="seq" value="<c:out value="${data.seq}"/>"/>
		<input type="hidden" name="pageNum" value="<c:out value="${search.pageNum}"/>"/>
		<table>
			<tbody>
			<tr>
				<th required>노출 키오스크 종류</th>
				<td colspan="4">
					<c:forEach items="${exposeTypes}" var="type" varStatus="stat">
						<input id="exposeType<c:out value="${stat.index}"/>" type="checkbox" name="exposeTypes" value="<c:out value="${type}"/>" ${data.containsExposeType(type) ? 'checked' : ''}>
						<label for="exposeType<c:out value="${stat.index}"/>"><c:out value="${type.name}"/></label>
					</c:forEach>
				</td>
			</tr>

			<tr>
				<th required>콘텐츠 제목</th>
				<td colspan="4">
					<input id="title" name="title" type="text" maxlength="50" value="<c:out value="${data.title}"/>"/>
				</td>
			</tr>

			<tr>
				<th>제공언어</th>
				<td class="lang-select" colspan="3">
					<a type="button" onclick="chooseLang('KO')" data-lang="KO" class="required selected" >국문</a>
					<a type="button" onclick="chooseLang('EN')" data-lang="EN">영문</a>
					<a type="button" onclick="chooseLang('JP')" data-lang="JP">일문</a>
					<a type="button" onclick="chooseLang('CN')" data-lang="CN">중문</a>
				</td>
			</tr>

			<tr>
				<th class="conditional-required">콘텐츠 업로드</th>
				<td colspan="4">
					<div class="language-target language-ko">
						<div class="thumbnail-container">
							<img class="thumbnail" src="<c:out value="${AttachPathResolver.getOrgUri(data.contentImgKo)}"/>" alt="국문 콘텐츠 이미지 미리보기"/>
						</div>
						<div class="file-container">
							<c:set var="attach" value="${data.contentImgKo}" scope="request"/>
							<jsp:include page="/include/component/fileUpload.jsp">
								<jsp:param name="t_required" value="true"/>
								<jsp:param name="t_ment" value="<%=image(1080, 1531)%>"/>
								<jsp:param name="t_ment" value="<%=fileLimit(10)%>"/>
								<jsp:param name="t_fileName" value="contentImgKo"/>
								<jsp:param name="t_tag" value="CONTENT_IMG_KO"/>
								<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
							</jsp:include>
						</div>
					</div>
					<div class="language-target language-en">
						<div class="thumbnail-container">
							<img class="thumbnail" src="<c:out value="${AttachPathResolver.getOrgUri(data.contentImgEn)}"/>" alt="영문 콘텐츠 이미지 미리보기"/>
						</div>
						<div class="file-container">
							<c:set var="attach" value="${data.contentImgEn}" scope="request"/>
							<jsp:include page="/include/component/fileUpload.jsp">
								<jsp:param name="t_required" value="true"/>
								<jsp:param name="t_ment" value="<%=image(1080, 1531)%>"/>
								<jsp:param name="t_ment" value="<%=fileLimit(10)%>"/>
								<jsp:param name="t_fileName" value="contentImgEn"/>
								<jsp:param name="t_tag" value="CONTENT_IMG_EN"/>
								<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
							</jsp:include>
						</div>
					</div>
					<div class="language-target language-jp">
						<div class="thumbnail-container">
							<img class="thumbnail" src="<c:out value="${AttachPathResolver.getOrgUri(data.contentImgJp)}"/>" alt="일문 콘텐츠 이미지 미리보기"/>
						</div>
						<div class="file-container">
							<c:set var="attach" value="${data.contentImgJp}" scope="request"/>
							<jsp:include page="/include/component/fileUpload.jsp">
								<jsp:param name="t_required" value="true"/>
								<jsp:param name="t_ment" value="<%=image(1080, 1531)%>"/>
								<jsp:param name="t_ment" value="<%=fileLimit(10)%>"/>
								<jsp:param name="t_fileName" value="contentImgJp"/>
								<jsp:param name="t_tag" value="CONTENT_IMG_JP"/>
								<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
							</jsp:include>
						</div>
					</div>
					<div class="language-target language-cn">
						<div class="thumbnail-container">
							<img class="thumbnail" src="<c:out value="${AttachPathResolver.getOrgUri(data.contentImgCn)}"/>" alt="중문 콘텐츠 이미지 미리보기"/>
						</div>
						<div class="file-container">
							<c:set var="attach" value="${data.contentImgCn}" scope="request"/>
							<jsp:include page="/include/component/fileUpload.jsp">
								<jsp:param name="t_required" value="true"/>
								<jsp:param name="t_ment" value="<%=image(1080, 1531)%>"/>
								<jsp:param name="t_ment" value="<%=fileLimit(10)%>"/>
								<jsp:param name="t_fileName" value="contentImgCn"/>
								<jsp:param name="t_tag" value="CONTENT_IMG_CN"/>
								<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
							</jsp:include>
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<th class="conditional-required">이미지 대체 텍스트</th>
				<td colspan="4">
					<div class="language-target language-ko">
						<input type="text" name="contentImgKo.altTxt" value="<c:out value="${data.contentImgKo.altTxt}"/>" placeholder="국문 대체 텍스트를 입력해주세요." maxlength="200"/>
					</div>
					<div class="language-target language-en">
						<input type="text" name="contentImgEn.altTxt" value="<c:out value="${data.contentImgEn.altTxt}"/>" placeholder="영문 대체 텍스트를 입력해주세요." maxlength="200"/>
					</div>
					<div class="language-target language-jp">
						<input type="text" name="contentImgJp.altTxt" value="<c:out value="${data.contentImgJp.altTxt}"/>" placeholder="일문 대체 텍스트를 입력해주세요." maxlength="200"/>
					</div>
					<div class="language-target language-cn">
						<input type="text" name="contentImgCn.altTxt" value="<c:out value="${data.contentImgCn.altTxt}"/>" placeholder="중문 대체 텍스트를 입력해주세요." maxlength="200"/>
					</div>
				</td>
			</tr>

			<tr>
				<th required>콘텐츠 노출 시간</th>
				<td colspan="4">
					<input id="second10" type="radio" name="exposeSecond" value="5" ${data.exposeSecond eq 5 ? 'checked' : ''}/>
					<label for="second10">5초</label>

					<input id="second20" type="radio" name="exposeSecond" value="10" ${data.exposeSecond eq 10 or isNew ? 'checked' : ''}/>
					<label for="second20">10초</label>

					<input id="second30" type="radio" name="exposeSecond" value="20" ${data.exposeSecond eq 20 ? 'checked' : ''}/>
					<label for="second30">20초</label>

					<input id="second60" type="radio" name="exposeSecond" value="30" ${data.exposeSecond eq 30 ? 'checked' : ''}/>
					<label for="second60">30초</label>
				</td>
			</tr>

			<tr>
				<th required>게시 시작 일자</th>
				<td>
					<jsp:include page="/include/component/dateTime.jsp" flush="false">
						<jsp:param name="dateName"	value="psDate"/><jsp:param name="dateValue"	value="${data.postStartDatePretty}"/>
						<jsp:param name="hourName"	value="psHour"/><jsp:param name="hourValue"	value="${data.psHour}"/>
						<jsp:param name="minName"	value="psMin"/> <jsp:param name="minValue"	value="${data.psMin}"/>
					</jsp:include>
				</td>
				<th required>게시 종료 일자</th>
				<td>
					<jsp:include page="/include/component/dateTime.jsp" flush="false">
						<jsp:param name="dateName"	value="peDate"/><jsp:param name="dateValue"	value="${data.infinitePost ? '' : data.postEndDatePretty}"/>
						<jsp:param name="hourName"	value="peHour"/><jsp:param name="hourValue"	value="${data.infinitePost ? '' : data.peHour}"/>
						<jsp:param name="minName"	value="peMin"/> <jsp:param name="minValue"	value="${data.infinitePost ? '' : data.peMin}"/>
					</jsp:include>
					<div>
						<input id="infinitePostCheckBox" type="checkbox" ${data.infinitePost ? 'checked' : ''}/>
						<label for="infinitePostCheckBox">무기한</label>
						<input type="hidden" name="infinitePostYn" value="${data.infinitePost ? 'Y' : 'N'}">
					</div>
				</td>
			</tr>

			<tr>
				<th required>공개여부</th>
				<td colspan="4">
					<input type="radio" name="useYn" value="Y" <c:if test="${empty data.useYn or data.useYn eq 'Y'}">checked</c:if> id="useY"><label for="useY">공개</label>
					<input type="radio" name="useYn" value="N" <c:if test="${data.useYn eq 'N'}">checked</c:if> id="useN"><label for="useN">비공개</label>
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
					<a type="button" href="javascript:goToSave()"
					   class="mot3 rightBtn blueBtn-round">
						<c:if test="${isNew}">등록</c:if>
						<c:if test="${not isNew}">수정</c:if>
					</a>
					<a type="button" href="javascript:goBackToList(undefined, 'seq')" class="mot3 rightBtn grayBtn-round">
						<c:if test="${isNew}">취소</c:if>
						<c:if test="${not isNew}">목록</c:if>
					</a>
				</td>
			</tr>
			</tfoot>
		</table>
	</form>
</div>

<%--######################## 스크립트 ########################--%>
<script src="<c:out value="${cPath}"/>/assets/js/detail.js" charset="utf-8" type="text/javascript"></script>
<script>
	/* 게시글 저장 시 전처리 */
	function goToSave() {
		submitFormIntoHiddenFrame(document.workForm);
	}

	// 이미지 썸네일 영역 기본 이미지 노출
	const imgThumbnailList = document.querySelectorAll('img.thumbnail');
	imgThumbnailList.forEach(img => {
		img.onerror = () => {
			img.onerror = null;
			img.src = '/assets/images/favicon.ico';
		}
	})
</script>
<script> /* 다국어 입력 처리 */
	const languageTargetDivList = document.querySelectorAll('div.language-target');
	const koDivList = document.querySelectorAll('div.language-ko');
	const enDivList = document.querySelectorAll('div.language-en');
	const jpDivList = document.querySelectorAll('div.language-jp');
	const cnDivList = document.querySelectorAll('div.language-cn');
	const conditionalRequiredThList = document.querySelectorAll('th.conditional-required');
	// 최초 페이지 진입시 KO 언어 선택으로 초기화
	chooseLang('KO');
	['KO', 'EN', 'JP', 'CN'].forEach(lang => {
		updateLangBoxColor(lang);
	});

	function chooseLang(language){

		// 언어와 관련된 모든 영역 숨김 처리
		languageTargetDivList.forEach(element => {
			element.style.display = 'none';
		})

		// 선택된 언어의 입력 필드만 표시
		switch (language) {
			case 'KO':
				koDivList.forEach(el => el.style.display = 'block');						// 선택 언어관련 입력란 노출
				conditionalRequiredThList.forEach(el => el.setAttribute('required', ''));	// 국문일 경우 필수값 표시
				break;
			case 'EN':
				enDivList.forEach(el => el.style.display = 'block');
				conditionalRequiredThList.forEach(el => el.removeAttribute('required'));
				break;
			case 'JP':
				jpDivList.forEach(el => el.style.display = 'block');
				conditionalRequiredThList.forEach(el => el.removeAttribute('required'));
				break;
			case 'CN':
				cnDivList.forEach(el => el.style.display = 'block');
				conditionalRequiredThList.forEach(el => el.removeAttribute('required'));
				break;
		}


		const buttons = document.querySelectorAll('.lang-select a');                    // 언어 선택 상태 업데이트
		buttons.forEach(btn => btn.classList.remove('selected'));
		document.querySelector('.lang-select a[data-lang="' + language + '"]').classList.add('selected');
	}


	/*
		언어값 색상 변경시키기 위한 이벤트리스너
	 */
	const altTxtList = document.querySelectorAll('input[name$=altTxt]');
	altTxtList.forEach(altTxt => {
		altTxt.addEventListener('input', function () {
			const currLang      = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
			updateLangBoxColor(currLang);
		});
	})
	const fileList = document.querySelectorAll('input[name$=file]');
	fileList.forEach(file => {
		file.addEventListener('change', function() {
			const currLang      = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
			updateLangBoxColor(currLang);
		})
	})
	function updateLangBoxColor(lang) {
		let langBox;

		let hasFile;
		let hasAltTxt;
		const langLowerCase = lang.toLowerCase();
		const query = '.language-' + langLowerCase + ' input';
		document.querySelectorAll(query).forEach(input => {
			if(input.name.endsWith('altTxt')) hasAltTxt = input.value.trim() !== '';
			if(input.name.endsWith('file') || input.name.endsWith('fileId')) {
				if(hasFile) return; // 이미 파일이 있다고 판단된 경우는 아래 로직 미실행

				if (input.type === 'file') {
					hasFile = input.files.length !== 0;
				} else {
					// 'fileId' 처리
					hasFile = input.value.trim() !== '';
				}
			}
		})

		if (lang === 'KO') {
			langBox = document.querySelector('.lang-select a[data-lang="KO"]');
		} else if (lang === 'EN') {
			langBox = document.querySelector('.lang-select a[data-lang="EN"]');
		} else if (lang === 'JP') {
			langBox = document.querySelector('.lang-select a[data-lang="JP"]');
		} else {
			langBox = document.querySelector('.lang-select a[data-lang="CN"]');
		}


		if (hasFile && hasAltTxt) {
			langBox.style.backgroundColor = '#00BF35';
		} else if (hasFile || hasAltTxt) {
			langBox.style.backgroundColor = '#EB4700';
		} else {
			langBox.style.backgroundColor = '';
		}
	}
</script>
<script> /* 콘텐츠 노출 시간 핸들링 */
	const secondRadioList = document.querySelectorAll('input[name="exposeSecond"]');
</script>
<script> /* 게시 시작 일자, 게시 종료 일자 핸들링 */
	// 게시 종료 일자
	const peDate = document.querySelector('input[name=peDate]');
	const peHour = document.querySelector('select[name=peHour]');
	const peMin = document.querySelector('select[name=peMin]');
	const beforePe = {
		date : '',
		hour : '',
		min : ''
	};

	// 게시 종료 일자 무기한 체크 여부에 따라 hidden input Y 또는 N 값 변경 처리
	// 무기한 버튼 클릭시 게시 종료 일자 부분 변경
	const infinitePostCheckBox = document.getElementById('infinitePostCheckBox');
	const infinitePostYnHiddenInput = document.querySelector('input[name=infinitePostYn]');

	// 최초 페이지 진입시 체크박스 체크 확인
	handleInfiniteCheckBox(infinitePostCheckBox);
	infinitePostCheckBox.addEventListener('click', event => {
		handleInfiniteCheckBox(event.target)
	})
	function handleInfiniteCheckBox(checkbox){
		const isChecked = checkbox.checked;
		if(isChecked){
			peDate.disabled = true;
			peHour.disabled = true;
			peMin.disabled = true;

			// 사용자가 선택했던 값을 변수에 임시 저장
			beforePe.date = peDate.value;
			beforePe.hour = peHour.value;
			beforePe.min = peMin.value;
			peDate.value = '';
			peHour.value = '';
			peMin.value = '';

			infinitePostYnHiddenInput.value = 'Y';
		}else{
			peDate.disabled = false;
			peHour.disabled = false;
			peMin.disabled = false;

			// before 변수에 임시 저장된 값이 있으면 복원
			if(beforePe.date !== '') peDate.value = beforePe.date;
			if(beforePe.hour !== '') peHour.value = beforePe.hour;
			if(beforePe.min !== '') peMin.value = beforePe.min;

			infinitePostYnHiddenInput.value = 'N';
		}
	}
</script>

<script>	/* 항목 삭제 */
	const onFail = function () {
		location.reload();
	}

	<c:if test="${not isNew}">
	$("tfoot .leftBtn").deleteArticle("delete", {"seq": '<c:out value="${data.seq}"/>'}).then(() => {
		location.href = "list"
	}, onFail);
	</c:if>
</script>


</body>
</html>