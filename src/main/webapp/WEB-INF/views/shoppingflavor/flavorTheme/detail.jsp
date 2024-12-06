<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/uploadForm.jsp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
    <%@ include file="/include/head.jsp" %>
    <%@ include file="/WEB-INF/views/facility/facility/modalList.jsp" %>  <!-- 매장모달 -->
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
<div id="pageTitle">맛가이드 > 맛가이드 테마 등록</div>
<ul class="pageGuide">
    <li>*는 필수입력항목입니다.</li>
    <li>등록 매장은 <b>최대 4개</b>까지 등록 가능하며 등록된 매장 한해 검색하여 선택가능합니다.</li>
    <li>등록 <b>매장을 변경하려면, '검색'버튼</b>을 다시 눌러 매장을 선택해 주세요.</li>
</ul>

<div class="detailBox">
    <form method="post" name="workForm" action="save">
        <input type="hidden" name="seq" value="<c:out value="${data.seq}"/>"/>
        <input type="hidden" name="pageNum" value="<c:out value="${search.pageNum}"/>"/>
        <table>
            <tbody>
            <tr>
                <th>제공언어</th>
                <td colspan="3" class="lang-select">
                    <a type="button" onclick="chooseLang(this, 'KO')" data-lang = "KO" class="required selected" >국문</a>
                    <a type="button" onclick="chooseLang(this, 'EN')" data-lang = "EN" class="required">영문</a>
                    <a type="button" onclick="chooseLang(this, 'JP')" data-lang = "JP" class="required">일문</a>
                    <a type="button" onclick="chooseLang(this, 'CN')" data-lang = "CN" class="required">중문</a>
                </td>
            </tr>
            <tr>
                <th required id="nmTh">테마명</th>
                <td colspan="3" id="themeNmField">
                    <input type="text" id="themeName" value="<c:out value="${data.themeNmKo}" escapeXml="false"/>" style="width: 600px" maxlength="100" autocomplete="off"/>
                </td>
            </tr>
            <tr>
                <th required id="introTh">테마 소개 텍스트</th>
                <td colspan="3" id="themeIntroField">
                    <input type="text" id="themeIntro" value="<c:out value="${data.themeIntroKo}" escapeXml="false"/>" style="width: 600px" maxlength="100" placeholder="테마를 소개하는 텍스트를 입력해주세요." autocomplete="off"/>
                </td>
            </tr>
            <tr>
                <th>대표 테마 키워드</th> <td id="themeRepField"><input type="text" id="repKey" value="<c:out value="${data.themeRepKeyKo}" escapeXml="false"/>" maxlength="30" style="width: 600px"  placeholder="테마를 소개하는 대표 키워드를 영문으로 입력해주세요." autocomplete="off"/></td>
                <th>서브 테마 키워드</th> <td id="themeSubField"><input type="text" id="subKey" value="<c:out value="${data.themeSubKeyKo}" escapeXml="false"/>" maxlength="30" style="width: 600px"  placeholder="테마를 소개하는 텍스트를 입력해주세요." autocomplete="off"/></td>
            </tr>
            <tr>
                <th required>대표 썸네일 이미지</th>
                <td>
                    <c:set var="attach" value="${data.thumbImg}" scope="request"/>
                    <jsp:include page="/include/component/fileUpload.jsp">
                        <jsp:param name="t_required" value="true"/>
                        <jsp:param name="t_ment" value="<%=imageCntLimit(1760, 1120, 1)%>"/>
                        <jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
                        <jsp:param name="t_fileName" value="thumbImg"/>
                        <jsp:param name="t_tag" value="THUMB_IMG"/>
                        <jsp:param name="t_accept" value="<%=imgAccept()%>"/>
                    </jsp:include>
                </td>
            </tr>
            <tr>
                <th required>이미지 대체 텍스트</th>
                <td colspan="3" id="thumbImgAltTxtField">
                    <input type="text" name="thumbImgAltTxtKo" id="thumbImgAltTxt" value="<c:out value="${data.thumbImgAltTxtKo}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                </td>
            </tr>
            <tr>
                <th required>매장 등록</th>
                <td colspan="3">
                    <div id="sortable-container">
                        <div class="draggable" draggable="true">
                            <span class="order">1</span>
                            <input type="text" class="w250" name="facilityList[].name" value="${data.facilityList[0] != null ? data.facilityList[0].name : ''}" data-type="facilityName" data-seq="1" readonly/>
                            <input type="hidden" name="facilityList[].facilityLangInfoSeq" value="${data.facilityList[0] != null ? data.facilityList[0].facilityLangInfoSeq : ''}" data-type="facilitySeq" data-seq="1"/>
                            <a type="button" class="mot3 lightBtn-round" onclick="showModal(1)">검색</a>
                            <a type="button" class="mot3 lightBtn-round" onclick="deleteFacility(1)">삭제</a>
                        </div>
                        <div class="draggable" draggable="true">
                            <span class="order">2</span>
                            <input type="text" class="w250" name="facilityList[].name" value="${data.facilityList[1] != null ? data.facilityList[1].name : ''}" data-type="facilityName" data-seq="2" readonly/>
                            <input type="hidden" name="facilityList[].facilityLangInfoSeq" value="${data.facilityList[1] != null ? data.facilityList[1].facilityLangInfoSeq : ''}" data-type="facilitySeq" data-seq="2"/>
                            <a type="button" class="mot3 lightBtn-round" onclick="showModal(2)">검색</a>
                            <a type="button" class="mot3 lightBtn-round" onclick="deleteFacility(2)">삭제</a>
                        </div>
                        <div class="draggable" draggable="true">
                            <span class="order">3</span>
                            <input type="text" class="w250" name="facilityList[].name" value="${data.facilityList[2] != null ? data.facilityList[2].name : ''}" data-type="facilityName" data-seq="3" readonly/>
                            <input type="hidden" name="facilityList[].facilityLangInfoSeq" value="${data.facilityList[2] != null ? data.facilityList[2].facilityLangInfoSeq : ''}" data-type="facilitySeq" data-seq="3"/>
                            <a type="button" class="mot3 lightBtn-round" onclick="showModal(3)">검색</a>
                            <a type="button" class="mot3 lightBtn-round" onclick="deleteFacility(3)">삭제</a>
                        </div>
                        <div class="draggable" draggable="true">
                            <span class="order">4</span>
                            <input type="text" class="w250" name="facilityList[].name" value="${data.facilityList[3] != null ? data.facilityList[3].name : ''}" data-type="facilityName" data-seq="4" readonly/>
                            <input type="hidden" name="facilityList[].facilityLangInfoSeq" value="${data.facilityList[3] != null ? data.facilityList[3].facilityLangInfoSeq : ''}" data-type="facilitySeq" data-seq="4"/>
                            <a type="button" class="mot3 lightBtn-round" onclick="showModal(4)">검색</a>
                            <a type="button" class="mot3 lightBtn-round" onclick="deleteFacility(4)">삭제</a>
                        </div>
                    </div>
                    <div class="ment">
                        등록 매장의 노출 순서는 드래그앤 드랍으로 변경 가능합니다.
                    </div>
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
<script	src="<c:out value="${cPath}"/>/assets/js/detail.js"	charset="utf-8"		type="text/javascript"></script>
<script src="<c:out value="${cPath}"/>/assets/js/util.js"	charset="utf-8"		type="text/javascript"></script>
<script>    // HTML5 Drag and Drop API
    document.addEventListener('DOMContentLoaded', function() {
        const container = document.getElementById('sortable-container');
        let dragged = null;

        // 드래그 시작 시
        container.addEventListener('dragstart', function(event) {
            dragged = event.target;                                                                // 드래그 중인 요소 찾고
            if (dragged.querySelector('input[data-type="facilityName"]').value === "") {           // 드래그 중인 요소의 매장 및 시설명이 비어있다면
            event.preventDefault();                                                                // 드래그 중지 하고
                return;                                                                            // return
            }

            event.target.style.opacity = 0.5;                // 투명도 조정
            event.target.style.border  = '2px dashed #000';  // 드래그 중 테두리 변경
        });

        // 드래그 종료 시
        container.addEventListener('dragend', function(event) {
            event.target.style.opacity = '';  // 드래그 종료 후 투명도 원복
            event.target.style.border  = '';  // 테두리 원복
        });

        // 드래그된 요소가 다른 요소 위로 올라왔을 때
        container.addEventListener('dragover', function(event) {
            event.preventDefault();  // 기본 동작 방지 (드롭 가능하게 함)
        });

        // 요소를 드롭할 때
        container.addEventListener('drop', function(event) {
            event.preventDefault();

            const dropped      = event.target.closest('.draggable');    // 드롭된 요소
            const draggedInput = dragged.querySelector('input[data-type="facilityName"]').value;
            const droppedInput = dropped.querySelector('input[data-type="facilityName"]').value;

            if (dropped && dragged !== dropped) {
                if (droppedInput !== "") {  // 드롭된 el의 값이 비어있지 않다면
                    // 매장 및 시설명 값 교환
                    dragged.querySelector('input[data-type="facilityName"]').value = droppedInput;
                    dropped.querySelector('input[data-type="facilityName"]').value = draggedInput;

                    // facilityLangInfoSeq 값 교환
                    const tmpFacilitySeq = dragged.querySelector('input[data-type="facilitySeq"]').value;
                    dragged.querySelector('input[data-type="facilitySeq"]').value = dropped.querySelector('input[data-type="facilitySeq"]').value;
                    dropped.querySelector('input[data-type="facilitySeq"]').value = tmpFacilitySeq;

                    // data-seq 값 교환
                    const tmpSeq = dragged.querySelector('.order').innerText;
                    dragged.setAttribute('data-seq', dropped.querySelector('.order').innerText);
                    dropped.setAttribute('data-seq', tmpSeq);
                }
            }
        });
    });
</script>
<script>
    // 각 언어에 대한 사용자가 입력한 값을 저장할 변수
    const info = {
        KO: { name: '', intro: '', repKey: '', subKey: '', thumbImgAltTxt: ''},
        EN: { name: '', intro: '', repKey: '', subKey: '', thumbImgAltTxt: ''},
        JP: { name: '', intro: '', repKey: '', subKey: '', thumbImgAltTxt: ''},
        CN: { name: '', intro: '', repKey: '', subKey: '', thumbImgAltTxt: ''},
    };
    // DB에서 받아온 데이터를 저장할 변수
    const themeData = {
        KO: {name: "<c:out value="${data.decodedThemeNmKo}" escapeXml="false"/>", intro: "<c:out value="${data.decodedThemeIntroKo}" escapeXml="false"/>", repKey: "<c:out value="${data.decodedThemeRepKeyKo}" escapeXml="false"/>", subKey: "<c:out value="${data.decodedThemeSubKeyKo}" escapeXml="false"/>", thumbImgAltTxt: "<c:out value="${data.decodedThumbImgAltTxtKo}" escapeXml="false"/>"},
        EN: {name: "<c:out value="${data.decodedThemeNmEn}" escapeXml="false"/>", intro: "<c:out value="${data.decodedThemeIntroEn}" escapeXml="false"/>", repKey: "<c:out value="${data.decodedThemeRepKeyEn}" escapeXml="false"/>", subKey: "<c:out value="${data.decodedThemeSubKeyEn}" escapeXml="false"/>", thumbImgAltTxt: "<c:out value="${data.decodedThumbImgAltTxtEn}" escapeXml="false"/>"},
        JP: {name: "<c:out value="${data.decodedThemeNmJp}" escapeXml="false"/>", intro: "<c:out value="${data.decodedThemeIntroJp}" escapeXml="false"/>", repKey: "<c:out value="${data.decodedThemeRepKeyJp}" escapeXml="false"/>", subKey: "<c:out value="${data.decodedThemeSubKeyJp}" escapeXml="false"/>", thumbImgAltTxt: "<c:out value="${data.decodedThumbImgAltTxtJp}" escapeXml="false"/>"},
        CN: {name: "<c:out value="${data.decodedThemeNmCn}" escapeXml="false"/>", intro: "<c:out value="${data.decodedThemeIntroCn}" escapeXml="false"/>", repKey: "<c:out value="${data.decodedThemeRepKeyCn}" escapeXml="false"/>", subKey: "<c:out value="${data.decodedThemeSubKeyCn}" escapeXml="false"/>", thumbImgAltTxt: "<c:out value="${data.decodedThumbImgAltTxtCn}" escapeXml="false"/>"}
    };

    // DB에서 받아온 데이터와 내용을 info 객체로 옮김
    info.KO.name   = themeData.KO.name || '';
    info.KO.intro  = themeData.KO.intro || '';
    info.KO.repKey = themeData.KO.repKey || '';
    info.KO.subKey = themeData.KO.subKey || '';
    info.KO.thumbImgAltTxt = themeData.KO.thumbImgAltTxt || '';
    info.EN.name   = themeData.EN.name || '';
    info.EN.intro  = themeData.EN.intro || '';
    info.EN.repKey = themeData.EN.repKey || '';
    info.EN.subKey = themeData.EN.subKey || '';
    info.EN.thumbImgAltTxt = themeData.EN.thumbImgAltTxt || '';
    info.JP.name   = themeData.JP.name || '';
    info.JP.intro  = themeData.JP.intro || '';
    info.JP.repKey = themeData.JP.repKey || '';
    info.JP.subKey = themeData.JP.subKey || '';
    info.JP.thumbImgAltTxt = themeData.JP.thumbImgAltTxt || '';
    info.CN.name   = themeData.CN.name || '';
    info.CN.intro  = themeData.CN.intro || '';
    info.CN.repKey = themeData.CN.repKey || '';
    info.CN.subKey = themeData.CN.subKey || '';
    info.CN.thumbImgAltTxt = themeData.CN.thumbImgAltTxt || '';

    const themeName  = document.getElementById('themeName');
    const themeIntro = document.getElementById('themeIntro');
    const repKey     = document.getElementById('repKey');
    const subKey     = document.getElementById('subKey');
    const thumbImgAltTxt = document.getElementById('thumbImgAltTxt');
    const nmTh       = document.getElementById('nmTh');
    const introTh    = document.getElementById('introTh');
    const langs      = ['KO', 'EN', 'JP', 'CN'];

    langs.forEach(lang => {
        updateLangBoxColor(lang);
    });

    themeName.addEventListener('input', function () {
        const currLang      = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[currLang].name = themeName.value;
        updateLangBoxColor(currLang);
    });

    themeIntro.addEventListener('input', function () {
        const currLang       = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[currLang].intro = themeIntro.value;
        updateLangBoxColor(currLang);
    });

    thumbImgAltTxt.addEventListener('input', function () {
        const currLang       = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[currLang].thumbImgAltTxt = thumbImgAltTxt.value;
        updateLangBoxColor(currLang);
    });

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
        const name           = info[lang].name;
        const intro          = info[lang].intro;
        const thumbImgAltTxt = info[lang].thumbImgAltTxt;

        if (name && intro && thumbImgAltTxt) {
            langBox.style.backgroundColor = '#00BF35';
        } else if (name || intro || thumbImgAltTxt) {
            langBox.style.backgroundColor = '#EB4700';
        } else {
            langBox.style.backgroundColor = '';
        }
    }

    function setFacilityNameAttribute() {
        const facilityNames        = document.querySelectorAll('input[data-type="facilityName"]');
        const facilityLangInfoSeqs = document.querySelectorAll('input[data-type="facilitySeq"]');

        let index = 0;
        facilityNames.forEach((facilityName, idx) => {
            const facilityLangInfoSeq = facilityLangInfoSeqs[idx];

            if (facilityName.value.trim() !== "") {
                facilityName.setAttribute('name', 'facilityList[' + index + '].name');
                facilityLangInfoSeq.setAttribute('name', 'facilityList[' + index + '].facilityLangInfoSeq');
                index++;
            } else {
                facilityName.removeAttribute('name');
                facilityLangInfoSeq.removeAttribute('name');
            }
        });
    }

    function setNameAttribute() {
        const bef        = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[bef].name   = themeName.value;
        info[bef].intro  = themeIntro.value;
        info[bef].repKey = repKey.value;
        info[bef].subKey = subKey.value;
        info[bef].thumbImgAltTxt = thumbImgAltTxt.value;

        document.querySelectorAll('.hidden-input').forEach(input => input.remove());

        for (const [lang, data] of Object.entries(info)) {
            const langNm = lang.charAt(0).toUpperCase() + lang.slice(1).toLowerCase();
            if (data.name) {
                const nameField = document.createElement('input');
                nameField.type  = 'hidden';
                nameField.name  = 'themeNm' + langNm;
                nameField.classList.add('hidden-input');
                nameField.value = data.name;
                document.getElementById('themeNmField').appendChild(nameField);
            }
            if (data.intro) {
                const introField = document.createElement('input');
                introField.type  = 'hidden';
                introField.name  = 'themeIntro' + langNm;
                introField.classList.add('hidden-input');
                introField.value = data.intro;
                document.getElementById('themeIntroField').appendChild(introField);
            }
            if (data.repKey) {
                const repField = document.createElement('input');
                repField.type  = 'hidden';
                repField.name  = 'themeRepKey' + langNm;
                repField.classList.add('hidden-input');
                repField.value = data.repKey;
                document.getElementById('themeRepField').appendChild(repField);
            }
            if (data.subKey) {
                const subField = document.createElement('input');
                subField.type  = 'hidden';
                subField.name  = 'themeSubKey' + langNm;
                subField.classList.add('hidden-input');
                subField.value = data.subKey;
                document.getElementById('themeSubField').appendChild(subField);
            }
            if (data.thumbImgAltTxt) {
                const thumbImgAltTxtField = document.createElement('input');
                thumbImgAltTxtField.type  = 'hidden';
                thumbImgAltTxtField.name  = 'thumbImgAltTxt' + langNm;
                thumbImgAltTxtField.classList.add('hidden-input');
                thumbImgAltTxtField.value = data.thumbImgAltTxt;
                document.getElementById('thumbImgAltTxtField').appendChild(thumbImgAltTxtField);
            }
        }

        /*
            현재 활성화된 탭의 변동 엘리먼트의 name 속성 제거 (ame 속성 값 중복 전송방지)
         */
        themeName.removeAttribute('name');
        themeIntro.removeAttribute('name');
        repKey.removeAttribute('name');
        subKey.removeAttribute('name');
        thumbImgAltTxt.removeAttribute('name');
    }

    function chooseLang(el, lang) {
        const langNm = lang.charAt(0).toUpperCase() + lang.charAt(1).toLowerCase();                   // 현재언어 to CamelCase
        const bef    = document.querySelector('.lang-select a.selected').getAttribute('data-lang');   // 이전 선택된 언어

        /*
            이전 언어 값 저장해놓기
         */
        info[bef].name   = themeName.value;
        info[bef].intro  = themeIntro.value;
        info[bef].repKey = repKey.value;
        info[bef].subKey = subKey.value;
        info[bef].thumbImgAltTxt = thumbImgAltTxt.value;

        /*
            언어 선택 상태 업데이트
         */
        const buttons = document.querySelectorAll('.lang-select a');
        buttons.forEach(btn => btn.classList.remove('selected'));
        el.classList.add('selected');

        /*
            변동 el value 저장된거에서 넣고, name 속성값도 현재언어로
         */
        themeName.value  = info[lang].name;
        themeName.name   = 'themeNm' + langNm;
        themeIntro.value = info[lang].intro;
        themeIntro.name  = 'themeIntro' + langNm;
        repKey.value     = info[lang].repKey;
        repKey.name      = 'themeRepKey' + langNm;
        subKey.value     = info[lang].subKey;
        subKey.name      = 'themeSubKey' + langNm;
        thumbImgAltTxt.value = info[lang].thumbImgAltTxt;
        thumbImgAltTxt.name  = 'thumbImgAltTxt' + langNm;
    }
</script>
<script>
    /*
    서버에 save 날릴때 수행하는 func 모음
 */
    function save() {
        setNameAttribute();
        setFacilityNameAttribute();
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
