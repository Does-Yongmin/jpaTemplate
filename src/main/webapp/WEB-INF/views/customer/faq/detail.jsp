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
    </style>
</head>
<body>
<c:set var="isNew" value="${empty data.seq}" scope="page"/>
<div id="pageTitle">자주묻는 질문 관리 등록</div>
<ul class="pageGuide">
    <li>*는 필수입력항목입니다.</li>
</ul>
<div class="detailBox">
    <form method="post" name="workForm" action="save">
        <input type="hidden" name="seq" value="<c:out value="${data.seq}"/>"/>
        <input type="hidden" name="pageNum" value="<c:out value="${search.pageNum}"/>"/>
        <input type="hidden" name="entryType" value="<c:out value="${search.entryType}"/>"/>
        <table>
            <tbody>
            <tr>
                <th required>구분</th>
                <td>
                    <c:forEach var="type" items="${types}" varStatus="stat">
                        <input type="radio" name="type" id="type<c:out value="${stat.index}"/>" value="<c:out value="${type}"/>" <c:if test="${data.type eq type}">checked</c:if><c:if test="${empty data and type.value eq '시설안내'}">checked</c:if>/><label for="type<c:out value="${stat.index}"/>"><c:out value="${type.value}"/></label>
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
                <th required>질문</th>
                <td id="inqField">
                    <input type="text" id="inq" name="inqKo" value="<c:out value="${data.inqKo}" escapeXml="false"/>" style="width: 500px" maxlength="200" autocomplete="off"/>
                </td>
            </tr>
            <tr>
                <th required>답변</th>
                <td id="resField">
                    <textarea name="resKo" id="res" maxlength="1000" autocomplete="off" style="height: 200px"><c:out value="${data.resKo}" escapeXml="false"/></textarea>
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
                    <a type="button" href="javascript:goBackToList(undefined, 'seq', 'entryType', 'type')" class="mot3 rightBtn grayBtn-round">목록</a>
                </td>
            </tr>
            </tfoot>
        </table>
    </form>
</div>

<%--######################## 스크립트 ########################--%>
<script	src="<c:out value="${cPath}"/>/assets/js/detail.js"	charset="utf-8"		type="text/javascript"></script>
<script src="<c:out value="${cPath}"/>/assets/js/util.js"	charset="utf-8"		type="text/javascript"></script>
<script>
    // 각 언어에 대한 사용자가 입력한 값을 저장할 변수
    const info = {
        KO: { inq: '', res: ''},
        EN: { inq: '', res: ''},
        JP: { inq: '', res: ''},
        CN: { inq: '', res: ''},
    };
    // DB에서 받아온 데이터를 저장할 변수
    const data = {
        KO: {inq: "<c:out value="${data.decodedInqKoForJs}" escapeXml="false"/>", res: "<c:out value="${data.decodedResKoForJs}" escapeXml="false"/>"},
        EN: {inq: "<c:out value="${data.decodedInqEnForJs}" escapeXml="false"/>", res: "<c:out value="${data.decodedResEnForJs}" escapeXml="false"/>"},
        JP: {inq: "<c:out value="${data.decodedInqJpForJs}" escapeXml="false"/>", res: "<c:out value="${data.decodedResJpForJs}" escapeXml="false"/>"},
        CN: {inq: "<c:out value="${data.decodedInqCnForJs}" escapeXml="false"/>", res: "<c:out value="${data.decodedResCnForJs}" escapeXml="false"/>"}
    };

    // DB에서 받아온 데이터와 내용을 info 객체로 옮김
    info.KO.inq = data.KO.inq || '';
    info.KO.res = data.KO.res || '';
    info.EN.inq = data.EN.inq || '';
    info.EN.res = data.EN.res || '';
    info.JP.inq = data.JP.inq || '';
    info.JP.res = data.JP.res || '';
    info.CN.inq = data.CN.inq || '';
    info.CN.res = data.CN.res || '';

    const inq       = document.getElementById('inq');
    const res       = document.getElementById('res');
    const langs     = ['KO', 'EN', 'JP', 'CN'];

    langs.forEach(lang => {
        updateLangBoxColor(lang);
    });

    inq.addEventListener('input', function () {
        const currLang     = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[currLang].inq = inq.value;
        updateLangBoxColor(currLang);
    });
    res.addEventListener('input', function () {
        const currLang     = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[currLang].res = res.value;
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
        const inq = info[lang].inq;
        const res = info[lang].res;

        if (inq && res) {
            langBox.style.backgroundColor = '#00BF35';
        } else if (inq || res) {
            langBox.style.backgroundColor = '#EB4700';
        } else {
            langBox.style.backgroundColor = '';
        }
    }

    function setNameAttribute() {
        const bef     = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[bef].inq = inq.value;
        info[bef].res = res.value;

        document.querySelectorAll('.hidden-input').forEach(input => input.remove());

        for (const [lang, data] of Object.entries(info)) {
            const langNm = lang.charAt(0).toUpperCase() + lang.slice(1).toLowerCase();
            if (data.inq) {
                const temp = document.createElement('input');
                temp.type  = 'hidden';
                temp.name  = 'inq' + langNm;
                temp.classList.add('hidden-input');
                temp.value = data.inq;
                document.getElementById('inqField').appendChild(temp);
            }
            if (data.res) {
                const temp = document.createElement('input');
                temp.type  = 'hidden';
                temp.name  = 'res' + langNm;
                temp.classList.add('hidden-input');
                temp.value = data.res;
                document.getElementById('resField').appendChild(temp);
            }
        }

        inq.removeAttribute('name');  // 현재 활성화된 탭의 name 속성 제거 (name 속성 값 중복으로 발송방지)
        res.removeAttribute('name');
    }

    function chooseLang(el, lang) {
        const langNm = lang.charAt(0).toUpperCase() + lang.charAt(1).toLowerCase();                   // 현재언어 to CamelCase
        const bef    = document.querySelector('.lang-select a.selected').getAttribute('data-lang');   // 이전 선택된 언어

        info[bef].inq = inq.value;
        info[bef].res = res.value;

        const buttons = document.querySelectorAll('.lang-select a');     // 언어 선택 상태 업데이트
        buttons.forEach(btn => btn.classList.remove('selected'));
        el.classList.add('selected');

        inq.value = info[lang].inq;                                      // 현재 el 값을 info에서 가져와서 넣고
        inq.name  = 'inq' + langNm;                                      // name 속성값도 현재언어로
        res.value = info[lang].res;
        res.name  = 'res' + langNm;
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
