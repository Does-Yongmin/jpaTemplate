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
<c:set var="isNew" value="${empty data.seq}" scope="page"/>
<div id="pageTitle">고객센터 관리 > 공지사항 / 관리자 웹 공지사항 등록</div>
<ul class="pageGuide">
	<li>*는 필수입력항목입니다.</li>
</ul>
<div class="detailBox">
	<form method="post" name="workForm" action="save">
		<input type="hidden" name="seq" value="<c:out value="${data.seq}"/>"/>
		<input type="hidden" name="pageNum" value="<c:out value="${search.pageNum}"/>"/>
		<table>
			<tbody>
			<tr>
				<th required>구분</th>
				<td>
					<c:forEach var="type" items="${types}" varStatus="stat">
						<input type="radio" name="type" id="type${stat.index}" value="${type}" <c:if test="${data.type eq type}">checked</c:if><c:if test="${empty data and type.value eq '홈페이지 공지'}">checked</c:if>/><label for="type${stat.index}"><c:out value="${type.value}"/></label>
					</c:forEach>
				</td>
			</tr>
			<tr>
				<th>제공언어</th>
				<td class="lang-select">
					<a type="button" onclick="chooseLang(this, 'KO')" data-lang = "KO" class="required selected" >국문</a>
					<a type="button" onclick="chooseLang(this, 'EN')" data-lang = "EN">영문</a>
					<a type="button" onclick="chooseLang(this, 'JP')" data-lang = "JP">일문</a>
					<a type="button" onclick="chooseLang(this, 'CN')" data-lang = "CN">중문</a>
				</td>
			</tr>
			<tr>
				<th required id="titleTh">제목</th>
				<td id="titleField">
					<input type="text" id="title" value="${data.titleKo}" style="width: 700px" maxlength="200" autocomplete="off"/>
				</td>
			</tr>
			<tr>
				<th required id="contentTh">내용</th>
				<td id="contentField">
					<textarea class="editor" id="content"><c:out value="${data.contentKo}" escapeXml="false"/></textarea>
				</td>
			</tr>
			<tr>
				<th>첨부파일 업로드</th>
				<td>
					<c:set var="attach" value="${data.file}" scope="request"/>
					<jsp:include page="/include/component/fileUpload.jsp">
						<jsp:param name="t_required" value="true"/>
						<jsp:param name="t_ment" value="<%=fileLimit(10)%>"/>
						<jsp:param name="t_fileName" value="file"/>
						<jsp:param name="t_tag" value="FILE"/>
						<jsp:param name="t_accept" value="<%=imgAccept()%>"/>
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th required>게시일자</th>
				<td colspan="3">
					<jsp:include page="/include/component/dateTime.jsp" flush="false">
						<jsp:param name="dateName"	value="pDate"/><jsp:param name="dateValue"	value="${data.PDatePretty}"/>
						<jsp:param name="hourName"	value="pHour"/><jsp:param name="hourValue"	value="${data.PHour}"/>
						<jsp:param name="minName"	value="pMin"/> <jsp:param name="minValue"	value="${data.PMin}"/>
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th required>공개여부</th>
				<td colspan="3">
					<input type="radio" name="useYn" value="Y" <c:if test="${empty data.useYn or data.useYn eq 'Y'}">checked</c:if> id="useY"><label for="useY">공개</label>
					<input type="radio" name="useYn" value="N" <c:if test="${data.useYn eq 'N'}">checked</c:if> id="useN"><label for="useN">비공개</label>
				</td>
			</tr>
			<%@ include file="/include/worker.jsp" %>
			</tbody>
			<tfoot>
			<tr>
				<td colspan="50">
					<c:if test="${not isNew}"><a type="button" class="mot3 leftBtn lightBtn-round">삭제</a></c:if>
					<a type="button" href="javascript:save(document.workForm)" class="mot3 rightBtn blueBtn-round">저장</a>
					<a type="button" href="javascript:goBackToList(undefined, 'seq')" class="mot3 rightBtn grayBtn-round">목록</a>
				</td>
			</tr>
			</tfoot>
		</table>
	</form>
</div>

<%--######################## 스크립트 ########################--%>
<%@ include file="/include/tinyMCE5/editorInit.jsp" %>
<script	src="<c:out value="${cPath}"/>/assets/js/detail.js"	charset="utf-8"		type="text/javascript"></script>
<script src="<c:out value="${cPath}"/>/assets/js/util.js"	charset="utf-8"		type="text/javascript"></script>
<script>
	// 각 언어에 대한 사용자가 입력한 값을 저장할 변수
	const info = {
		KO: { title: '', content: ''},
		EN: { title: '', content: ''},
		JP: { title: '', content: ''},
		CN: { title: '', content: ''},
	};
	// DB에서 받아온 데이터를 저장할 변수
	const data = {
		KO: {title: "<c:out value="${data.decodedTitleKoForJs}" escapeXml="false"/>", content: "<c:out value="${data.decodedContentKoForJs}" escapeXml="false"/>"},
		EN: {title: "<c:out value="${data.decodedTitleEnForJs}" escapeXml="false"/>", content: "<c:out value="${data.decodedContentEnForJs}" escapeXml="false"/>"},
		JP: {title: "<c:out value="${data.decodedTitleJpForJs}" escapeXml="false"/>", content: "<c:out value="${data.decodedContentJpForJs}" escapeXml="false"/>"},
		CN: {title: "<c:out value="${data.decodedTitleCnForJs}" escapeXml="false"/>", content: "<c:out value="${data.decodedContentCnForJs}" escapeXml="false"/>"}
	};

	// DB에서 받아온 데이터와 내용을 info 객체로 옮김
	info.KO.title   = data.KO.title || '';
	info.KO.content = data.KO.content || '';
	info.EN.title   = data.EN.title || '';
	info.EN.content = data.EN.content || '';
	info.JP.title   = data.JP.title || '';
	info.JP.content = data.JP.content || '';
	info.CN.title   = data.CN.title || '';
	info.CN.content = data.CN.content || '';

	const title     = document.getElementById('title');
	const content   = document.getElementById('content');
	const titleTh   = document.getElementById('titleTh');
	const contentTh = document.getElementById('contentTh');
	const langs     = ['KO', 'EN', 'JP', 'CN'];

	langs.forEach(lang => {
		updateLangBoxColor(lang);
	});

	title.addEventListener('input', function () {
		const currLang       = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
		info[currLang].title = title.value;
		updateLangBoxColor(currLang);
	});

	// content.addEventListener('input', function () {
	// 	const currLang         = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
	// 	info[currLang].content = content.value;
	// 	updateLangBoxColor(currLang);
	// });

	function updateLangBoxColor(lang) {
		let langBox;
		if (lang === 'KO') {
			langBox = document.querySelector('.lang-select a[data-lang="KO"]');
		} else if (lang === 'EN') {
			langBox = document.querySelector('.lang-select a[data-lang="EN"]');
		} else if (lang === 'JP') {
			langBox = document.querySelector('.lang-select a[data-lang="JP"]');
		} else {
			langBox = document.querySelector('.lang-select a[data-lang="CN"]');
		}
		const title   = info[lang].title;
		const content = info[lang].content;

		if (title && content) {
			langBox.style.backgroundColor = '#00BF35';
		} else if (title || content) {
			langBox.style.backgroundColor = '#EB4700';
		} else {
			langBox.style.backgroundColor = '';
		}
	}

	function setNameAttribute() {
		const bef         = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
		info[bef].title   = title.value;
		info[bef].content = tinymce.get('content').getContent();

		document.querySelectorAll('.hidden-input').forEach(input => input.remove());

		for (const [lang, data] of Object.entries(info)) {
			const langNm = lang.charAt(0).toUpperCase() + lang.slice(1).toLowerCase();
			if (data.title) {
				const temp = document.createElement('input');
				temp.type  = 'hidden';
				temp.name  = 'title' + langNm;
				temp.classList.add('hidden-input');
				temp.value = data.title;
				document.getElementById('titleField').appendChild(temp);
			}
			if (data.content) {
				const temp = document.createElement('input');
				temp.type  = 'hidden';
				temp.name  = 'content' + langNm;
				temp.classList.add('hidden-input');
				temp.value = data.content;
				document.getElementById('contentField').appendChild(temp);
			}
		}

		title.removeAttribute('name');    // 현재 활성화된 탭의 테마명의 name 속성 제거 (name 속성 값 중복으로 발송방지)
		content.removeAttribute('name');  // 현재 활성화된 탭의 소개 텍스트의 name 속성 제거
	}

	function chooseLang(el, lang) {
		const langNm = lang.charAt(0).toUpperCase() + lang.charAt(1).toLowerCase();                   // 현재언어 to CamelCase
		const bef    = document.querySelector('.lang-select a.selected').getAttribute('data-lang');   // 이전 선택된 언어

		info[bef].title   = title.value;                                 // 이전 언어 값 info에 넣고
		info[bef].content = tinymce.get('content').getContent();

		const buttons = document.querySelectorAll('.lang-select a');     // 언어 선택 상태 업데이트
		buttons.forEach(btn => btn.classList.remove('selected'));
		el.classList.add('selected');

		title.value  = info[lang].title;                                           // 현재 el 값을 info에서 가져와서 넣고
		title.name   = 'title' + langNm;                                           // name 속성값도 현재언어로
		tinymce.get('content').setContent(decodeHTML(info[lang].content || ''));   // 에디터 내용을 info에서 가져와서 넣음 (DB에서 불러오는 경우는 HTML 엔티티로 인코딩 되어 있어 디코딩하고)
		content.name = 'content' + langNm;                                         // name 속성값도 현재언어로
	}

	function decodeHTML(html) {
		const txt = document.createElement("textarea");
		txt.innerHTML = html;
		return txt.value;
	}
</script>

<script>
	/*
	서버에 save 날릴때 수행하는 func 모음
 */
	function save() {
		setNameAttribute();
		submitFormIntoHiddenFrame(document.workForm);
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
