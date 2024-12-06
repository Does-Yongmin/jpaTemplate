<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/uploadForm.jsp" %>

<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
    <%@ include file="/include/head.jsp" %>
    <%@ include file="/WEB-INF/views/facility/facility/modalList.jsp" %>  <!-- 매장모달 -->
    <link rel="stylesheet" type="text/css" href="${cPath}/assets/css/contentPage.css"/>
    <style>
        .lang-select a {padding: 10px 20px;border: 1px solid; cursor: pointer; }
        .lang-select a.selected {border: 2px solid #000000; font-weight: bold; box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.5);}
        .required:after {content:" *"; color: red;}
        input:read-only {background-color: #f0f0f0;}
        span.before {font-weight: bold; display:inline-block; border-radius: 5px; width: 60px; text-align: left;}
        .templateAltTxtTd .input-group { display:flex}
    </style>
</head>
<body>
<c:set var="isNew" value="${empty data.seq}" scope="page"/>
<div id="pageTitle"><c:out value="${pageTitle}"/></div>	<%-- pageTitle은 Aspect 로 삽입 --%>
<ul class="pageGuide">
    <li>*는 필수입력항목입니다.</li>
    <li>필수입력항목을 모두 채우지 않으면 등록되지 않고, 국문은 필수로 입력해야 합니다.</li>
    <li>게시글 이미지 , 게시글 영상 중 택 1하여 한가지 포맷으로만 등록 가능합니다.</li>
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
                <td colspan="3">
                    <input type="radio" name="type" value="MAIN_EVENT"    id="type1" onchange="showMainCategory('Y')" <c:if test="${data.type eq 'MAIN_EVENT'}">checked</c:if>/><label for="type1">Main Event</label>
                    <input type="radio" name="type" value="STORE_EVENT"   id="type2" onchange="showMainCategory()" <c:if test="${data.type eq 'STORE_EVENT'}">checked</c:if>/><label for="type2">Store Event</label>
                    <input type="radio" name="type" value="POP_UP"        id="type3" onchange="showMainCategory()" <c:if test="${data.type eq 'POP_UP'}">checked</c:if>/><label for="type3">Pop-up</label>
                    <input type="radio" name="type" value="ENTERTAINMENT" id="type4" onchange="showMainCategory()" <c:if test="${data.type eq 'ENTERTAINMENT'}">checked</c:if>/><label for="type4">Entertainment</label>
                </td>
            </tr>
            <tr id="mainCategory" style="display: none">
                <th required>Main Event 카테고리</th>
                <td colspan="3">
                    <c:forEach var="category" items="${categories}" varStatus="stat">
                        <input type="radio" name="mainCategory" id="category${stat.index}" class="categories" value="<c:out value="${category}"/>"
                               <c:if test="${data.mainCategory eq category}">checked</c:if><c:if test="${empty data and category.value eq '롯타와봄'}">checked</c:if>
                        onclick="selectOnlyOne(this)"/>
                        <label for="category${stat.index}"><c:out value="${category.value}"/></label>
                    </c:forEach>
                </td>
            </tr>
            <tr>
                <th>공지배너여부</th>
                <td id="noticeField" colspan="3">
                    <input type="checkbox" name="noticeYn" value="Y" onchange="toggleNotice()" <c:if test="${data.noticeYn eq 'Y'}">checked</c:if> id="notice"/>
                    <label for="notice">공지 배너</label>
                </td>
            </tr>
            <tr>
                <th required>운영사 선택</th>
                <td colspan="3">
                    <select name="affiliateType">
                        <option value="" ${empty data.affiliateType ? 'selected'  : ''}>운영사를 선택해 주세요.</option>
                        <c:forEach var="affiliateType" items="${affiliateTypes}" varStatus="stat">
                            <option value="<c:out value="${affiliateType}"/>" <c:if test="${data.affiliateType eq affiliateType}">selected</c:if>>
                                <c:out value="${affiliateType.nameKo}"/>
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th>제공언어</th>
                <td class="lang-select" colspan="3">
                    <a type="button"  onclick="chooseLang(this, 'KO')" data-lang = "KO" class="required selected" >국문</a>
                    <a type="button" onclick="chooseLang(this, 'EN')" data-lang = "EN">영문</a>
                    <a type="button" onclick="chooseLang(this, 'JP')" data-lang = "JP">일문</a>
                    <a type="button" onclick="chooseLang(this, 'CN')" data-lang = "CN">중문</a>
                </td>
            </tr>
            <tr>
                <th required>이벤트명</th>
                <td id="eventNmField" colspan="3">
                    <input type="text" id="eventName" value="<c:out value="${data.eventNmKo}" escapeXml="false"/>" style="width: 600px" maxlength="100" autocomplete="off"/>
                </td>
            </tr>
            <tr>
                <th required>이벤트 내용</th>
                <td id="eventContentField" colspan="3">
                    <textarea class="editor" id="eventContent"><c:out value="${data.contentKo}" escapeXml="false"/></textarea>
                </td>
            </tr>
            <tr>
                <th required>장소</th>
                <td colspan="3">
                    <input type="radio" name="locRadio" id="locStore" onchange="toggleLoc(this)"><label for="locStore">매장/시설 등록</label>
                    <input type="radio" name="locRadio" id="locAlt"  onchange="toggleLoc(this)"><label for="locAlt">장소 별도 입력</label>
                    <div id="storeInput" style="display: none">
                        <input type="text" class="w300" name="loc" value="<c:out value="${data.loc}"/>" placeholder="장소를 등록해 주세요." readonly/>
                        <a type="button" class="mot3 lightBtn-round" name="place" onclick="showModal()">장소검색</a>
                    </div>
                    <div id="altInput" style="display: none">
                        <input type="text" name="locAlt" id="locAltInput" value="<c:out value="${data.locAltKo}" escapeXml="false"/>" class="w300" maxlength="30" autocomplete="off" placeholder="장소를 입력해 주세요." />
                    </div>
                    <input type="hidden" name="facilityRelated.facilityLangInfoSeq" value="<c:out value="${data.facilityRelated.facilityLangInfoSeq}"/>" data-type="facilitySeqEvent">
                </td>
            </tr>
            <tr>
                <th required>썸네일 이미지</th>
                <td colspan="3">
                    <c:set var="attach" value="${data.thumbImg}" scope="request"/>
                    <jsp:include page="/include/component/fileUpload.jsp">
                        <jsp:param name="t_required" value="true"/>
                        <jsp:param name="t_ment" value="이미지 파일 권장 사이즈는 <span class='red'>가로 1020px * 세로 1020~1532px</span> 이고, <strong>.jpg,.gif,.png</strong> 파일에 한해 등록이 가능합니다."/>
                        <jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
                        <jsp:param name="t_fileName" value="thumbImg"/>
                        <jsp:param name="t_tag" value="THUMB_IMG"/>
                        <jsp:param name="t_accept" value="<%=imgAccept()%>"/>
                    </jsp:include>
                </td>
            </tr>
            <tr>
                <th required>썸네일 이미지 대체 텍스트</th>
                <td colspan="3">
                    <div class="input-group">
                        <span class="before">국문</span>
                        <input type="text" name="thumbAltTxtKo" id="thumbAltKo" data-lang="KO" value="<c:out value="${data.thumbAltTxtKo}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">영문</span>
                        <input type="text" name="thumbAltTxtEn" id="thumbAltEn" data-lang="EN" value="<c:out value="${data.thumbAltTxtEn}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">일문</span>
                        <input type="text" name="thumbAltTxtJp" id="thumbAltJp" data-lang="JP" value="<c:out value="${data.thumbAltTxtJp}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">중문</span>
                        <input type="text" name="thumbAltTxtCn" id="thumbAltCn" data-lang="CN" value="<c:out value="${data.thumbAltTxtCn}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                </td>
            </tr>
            <tr id="detailImgTr">
                <th id="detailImgTh">게시글 이미지</th>
                <td id="detailImgTd" colspan="3">
                    <c:set var="attach" value="${data.img}" scope="request"/>
                    <jsp:include page="/include/component/fileUpload.jsp">
                        <jsp:param name="t_required" value="false"/>
                        <jsp:param name="t_ment" value="이미지 파일 권장 사이즈는 <span class='red'>1020px * 세로 길이 자율</span> 이고, <strong>.jpg,.gif,.png</strong> 파일에 한해 등록이 가능합니다."/>
                        <jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
                        <jsp:param name="t_fileName" value="img"/>
                        <jsp:param name="t_tag" value="DETAIL_IMG"/>
                        <jsp:param name="t_accept" value="<%=imgAccept()%>"/>
                    </jsp:include>
                </td>
            </tr>
            <tr id="detailImgAltTxtTr">
                <th id="detailImgTxtTh">게시글 이미지 대체 텍스트</th>
                <td id="detailImgTxtTd" colspan="3">
                    <div class="input-group">
                        <span class="before">국문</span>
                        <input type="text" name="imgAltTxtKo" id="detailAltKo" data-lang="KO" value="<c:out value="${data.imgAltTxtKo}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">영문</span>
                        <input type="text" name="imgAltTxtEn" id="detailAltEn" data-lang="EN" value="<c:out value="${data.imgAltTxtEn}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">일문</span>
                        <input type="text" name="imgAltTxtJp" id="detailAltJp" data-lang="JP" value="<c:out value="${data.imgAltTxtJp}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">중문</span>
                        <input type="text" name="imgAltTxtCn" id="detailAltCn" data-lang="CN" value="<c:out value="${data.imgAltTxtCn}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                </td>
            </tr>

            <!-- 미리 하나 넣어놓음 -->
            <tr class="firstMainEventImgRow" style="display: none">
                <th rowspan="2" colspan="1">게시글 이미지
                    <br>
                    <a type="button" onclick="addDetailImg()" class="mot3 whiteBtn-round">추가 +</a>
                </th>
                <th>이미지</th>
                <td colspan="3">
                    <div class="ment">이미지 파일 권장 사이즈는 <span class='red'>1020px * 세로 길이 자율</span> 이고, <strong>.jpg,.gif,.png</strong> 파일에 한해 등록이 가능합니다.</div>
                    <div class="ment">파일 용량은 <span class="red">10MB</span> 까지 등록이 가능합니다.</div>
                    <div class="file_input_div">
                        <input type="hidden" name="imgList[].file.tag" value="DETAIL_IMG">
                        <input type="hidden" name="imgList[].file.fileId" value="">
                        <input type="file" name="imgList[].file.file" accept=".jpg, .gif, .png">
                    </div>
                </td>
            </tr>
            <tr class="firstMainEventImgRow" style="display: none">
                <th>이미지 대체 텍스트</th>
                <td class="templateAltTxtTd">
                    <div class="input-group">
                        <span class="before">국문</span>
                        <input type="text" name="imgList[].fileAltTxtKo" data-lang="KO" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">영문</span>
                        <input type="text" name="imgList[].fileAltTxtEn" data-lang="EN" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">일문</span>
                        <input type="text" name="imgList[].fileAltTxtJp" data-lang="JP" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">중문</span>
                        <input type="text" name="imgList[].fileAltTxtCn" data-lang="CN" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                </td>
            </tr>

            <!-- 게시글 이미지 템플릿 컨테이너 -->
            <tbody id="templateContainer">

            </tbody>

            <tr id="bannerImgTr" style="display: none">
                <th id="bannerImgTh" required>공지 배너 이미지</th>
                <td id="bannerImgTd" colspan="3">
                    <c:set var="attach" value="${data.bannerImg}" scope="request"/>
                    <jsp:include page="/include/component/fileUpload.jsp">
                        <jsp:param name="t_required" value="true"/>
                        <jsp:param name="t_ment" value='<%=imageRecommend(1020, 620, "@2배수 권장")%>'/>
                        <jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
                        <jsp:param name="t_fileName" value="bannerImg"/>
                        <jsp:param name="t_tag" value="BANNER_IMG"/>
                        <jsp:param name="t_accept" value="<%=imgAccept()%>"/>
                    </jsp:include>
                </td>
            </tr>
            <tr id="bannerImgTxtTr" style="display: none">
                <th id="bannerImgTxtTh" required>공지 배너 이미지 대체 텍스트</th>
                <td id="bannerImgTxtTd" colspan="3">
                    <div class="input-group">
                        <span class="before">국문</span>
                        <input type="text" name="bannerAltTxtKo" id="bannerAltKo" data-lang="KO" value="<c:out value="${data.bannerAltTxtKo}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">영문</span>
                        <input type="text" name="bannerAltTxtEn" id="bannerAltEn" data-lang="EN" value="<c:out value="${data.bannerAltTxtEn}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">일문</span>
                        <input type="text" name="bannerAltTxtJp" id="bannerAltJp" data-lang="JP" value="<c:out value="${data.bannerAltTxtJp}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">중문</span>
                        <input type="text" name="bannerAltTxtCn" id="bannerAltCn" data-lang="CN" value="<c:out value="${data.bannerAltTxtCn}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                </td>
            </tr>
            <tr>
                <th>게시글 영상</th>
                <td colspan="3">
                    <c:set var="attach" value="${data.video}" scope="request"/>
                    <jsp:include page="/include/component/fileUpload.jsp">
                        <jsp:param name="t_required" value="false"/>
                        <jsp:param name="t_ment" value="<span class='red'>화면 비율 최소:4:5, 최대값:9:16[또는 수평 전환시 16:9]</span>, <strong>mp4.mov 파일에 한해 등록이 가능합니다.</strong>"/>
                        <jsp:param name="t_ment" value="<%=fileLimit(30)%>"/>
                        <jsp:param name="t_fileName" value="video"/>
                        <jsp:param name="t_tag" value="VIDEO"/>
                        <jsp:param name="t_accept" value="<%=movAccept()%>"/>
                    </jsp:include>
                </td>
            </tr>
            <tr>
                <th>게시글 영상 대체 텍스트</th>
                <td colspan="3">
                    <div class="input-group">
                        <span class="before">국문</span>
                        <input type="text" name="videoAltTxtKo" id="videoAltKo" data-lang="KO" value="<c:out value="${data.videoAltTxtKo}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">영문</span>
                        <input type="text" name="videoAltTxtEn" id="videoAltEn" data-lang="EN" value="<c:out value="${data.videoAltTxtEn}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">일문</span>
                        <input type="text" name="videoAltTxtJp" id="videoAltJp" data-lang="JP" value="<c:out value="${data.videoAltTxtJp}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                    <div class="input-group">
                        <span class="before">중문</span>
                        <input type="text" name="videoAltTxtCn" id="videoAltCn" data-lang="CN" value="<c:out value="${data.videoAltTxtCn}" escapeXml="false"/>" class="w300" maxlength="200" autocomplete="off"/>
                    </div>
                </td>
            </tr>
            <tr>
                <th required>진행일자</th>
                <td id="sDateField" colspan="3">
                    <input type="text" class="date" name="sDate" value="<c:out value="${data.SDatePretty}"/>" autocomplete="off"> ~
                    <input type="text" class="date" name="eDate" value="<c:out value="${data.EDatePretty}"/>" autocomplete="off">
                    <input type="checkbox" name="hideAfterEndYn" value="Y" id="hideAfterEnd" <c:if test="${data.hideAfterEndYn eq 'Y'}">checked</c:if> /><label for="hideAfterEnd">이벤트 종료 시 비공개 노출 처리</label>
                </td>
            </tr>
            <tr>
                <th required>게시 시작 일자</th>
                <td>
                    <jsp:include page="/include/component/dateTime.jsp" flush="false">
                        <jsp:param name="dateName"	value="pSDate"/><jsp:param name="dateValue"	value="${data.PSDatePretty}"/>
                        <jsp:param name="hourName"	value="pSHour"/><jsp:param name="hourValue"	value="${data.PSHour}"/>
                        <jsp:param name="minName"	value="pSMin"/> <jsp:param name="minValue"	value="${data.PSMin}"/>
                    </jsp:include>
                </td>
                <th required>게시 종료 일자</th>
                <td>
                    <jsp:include page="/include/component/dateTime.jsp" flush="false">
                        <jsp:param name="dateName"	value="pEDate"/><jsp:param name="dateValue"	value="${data.PEDatePretty}"/>
                        <jsp:param name="hourName"	value="pEHour"/><jsp:param name="hourValue"	value="${data.PEHour}"/>
                        <jsp:param name="minName"	value="pEMin"/> <jsp:param name="minValue"	value="${data.PEMin}"/>
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
                    <a type="button" href="javascript:goBackToList(undefined, 'seq', 'entryType', 'type')" class="mot3 rightBtn grayBtn-round">목록</a>
                </td>
            </tr>
            </tfoot>
        </table>
    </form>
</div>

<template id="template">
    <tr>
        <th rowspan="2" colspan="1">게시글 이미지
            <br>
            <a type="button" onclick="addDetailImg()" class="mot3 whiteBtn-round">추가 +</a>
            <br class="removeWhenFirst">
            <a type="button" onclick="deleteDetailImg(this)" class="mot3 whiteBtn-round removeWhenFirst">삭제 -</a>
        </th>
        <th>이미지</th>
        <td colspan="3">
            <div class="ment">이미지 파일 권장 사이즈는 <span class='red'>1020px * 세로 길이 자율</span> 이고, <strong>.jpg,.gif,.png</strong> 파일에 한해 등록이 가능합니다.</div>
            <div class="ment">파일 용량은 <span class="red">10MB</span> 까지 등록이 가능합니다.</div>
            <div class="file_input_div">
                <input type="hidden" name="imgList[].file.tag" value="DETAIL_IMG">
                <input type="hidden" name="imgList[].file.fileId" value="">
                <input type="file" name="imgList[].file.file" accept=".jpg, .gif, .png">
            </div>
        </td>
    </tr>
    <tr>
        <th>이미지 대체 텍스트</th>
        <td class="templateAltTxtTd">
            <div class="input-group">
                <span class="before">국문</span>
                <input type="text" name="imgList[].fileAltTxtKo" data-lang="KO" class="w300" maxlength="200" autocomplete="off"/>
            </div>
            <div class="input-group">
                <span class="before">영문</span>
                <input type="text" name="imgList[].fileAltTxtEn" data-lang="EN" class="w300" maxlength="200" autocomplete="off"/>
            </div>
            <div class="input-group">
                <span class="before">일문</span>
                <input type="text" name="imgList[].fileAltTxtJp" data-lang="JP" class="w300" maxlength="200" autocomplete="off"/>
            </div>
            <div class="input-group">
                <span class="before">중문</span>
                <input type="text" name="imgList[].fileAltTxtCn" data-lang="CN" class="w300" maxlength="200" autocomplete="off"/>
            </div>
        </td>
    </tr>
</template>

<%--######################## 스크립트 ########################--%>
<%@ include file="/include/tinyMCE5/editorInit.jsp" %>
<script	src="${cPath}/assets/js/detail.js"	charset="utf-8"		type="text/javascript"></script>
<script src="${cPath}/assets/js/util.js"	charset="utf-8"		type="text/javascript"></script>
<script> <%-- 동적 템플릿 관련 스크립트 --%>
    const container = document.getElementById('templateContainer');
    const temp = document.getElementById('template');
    let tempCnt = 0;

    function addDetailImg() {
        if ((tempCnt+1) > 10) {
            alert('최대 10개까지 등록 가능합니다.');
            return;
        }
        const tmp = temp.content.cloneNode(true);
        if (tempCnt === 0) {
            const delItems = tmp.querySelectorAll('.removeWhenFirst');
            delItems.forEach(item => {
                item.style.display = 'none';
            })
        }

        // 동적으로 생성된 엘리에는 기존 js의 글자수 제한 함수가 안먹어서 새롭게 만든 글자수 카운팅 함수 호출
        const inputs = tmp.querySelectorAll('input[maxlength]');
        inputs.forEach(input => {
            addCharacterCount(input);
        });

        container.append(tmp);
        tempCnt++;
    }

    function addCharacterCount(input) {
        const maxLength = input.getAttribute('maxlength');

        const span = document.createElement('span');
        span.classList.add('length');
        span.textContent = '0/' + maxLength;
        input.parentNode.insertBefore(span, input.nextSibling);

        input.addEventListener('input', function() {
            const currentLength = input.value.length;
            span.textContent = currentLength + '/' + maxLength;

            if (currentLength >= maxLength) {
                input.value = input.value.slice(0, maxLength);  // 초과된 부분 자르고
                span.textContent = maxLength + '/' + maxLength; // 글자 수 갱신
            }
        });
    }

    function deleteDetailImg(el) {
        const currRow = el.closest('tr');

        // 이미지 대체텍스트 row
        const nextRow = currRow.nextElementSibling;

        if (currRow && nextRow) {
            currRow.remove();
            nextRow.remove();
        }

        tempCnt--;
    }

    function setDetailImgName() {
        const rows                  = container.querySelectorAll('tr');
        const mainEventRadio        = document.getElementById('type1');
        const firstMainEventImgRows = document.querySelectorAll('.firstMainEventImgRow');
        const firstRowInputs        = firstMainEventImgRows[0].querySelectorAll('input');
        const secondRowInputs       = firstMainEventImgRows[1].querySelectorAll('input');
        let currentIndex = 0;

        // 기본으로 넣어놓은 메인이벤트의 게시글 이미지가 엘리먼트가 보여지고 있으면
        // name 속성 추가
        if (firstMainEventImgRows[0].style.display !== 'none') {
            firstRowInputs.forEach(input => {
                if (!mainEventRadio.checked) {
                    input.removeAttribute('name');
                } else if(input.name.includes('[]')) {  // 새로 추가한 경우
                    input.name = input.name.replace('[]', '[' + currentIndex + ']');
                } else {                                // 기존에 있던 경우
                    input.name = input.name.replace(/\[\d+]/, '[' + currentIndex + ']');
                }
            });
            secondRowInputs.forEach(input => {
                if (!mainEventRadio.checked) {
                    input.removeAttribute('name');
                } else if (input.name.includes('[]')) { // 새로 추가한 경우
                    input.name = input.name.replace('[]', '[' + currentIndex + ']');
                }
            });
            currentIndex++;
        }
        // 기본으로 넣어놓은 메인이벤트의 게시글 이미지 엘리먼트가 안보여지고 있으면
        // name 속성 제거
        else {
            firstRowInputs.forEach(input => {
                input.removeAttribute('name');
            });
            secondRowInputs.forEach(input => {
                input.removeAttribute('name');
            });
        }

        for (let i = 0; i < rows.length; i += 2) {
            const firstRowInputs  = rows[i].querySelectorAll('input');
            const secondRowInputs = rows[i + 1].querySelectorAll('input');
            firstRowInputs.forEach(input => {
                if (!mainEventRadio.checked) {
                    input.removeAttribute('name');
                } else if(input.name.includes('[]')) {  // 새로 추가한 경우
                    input.name = input.name.replace('[]', '[' + currentIndex + ']');
                } else {                                // 기존에 있던 경우
                    input.name = input.name.replace(/\[\d+]/, '[' + currentIndex + ']');
                }
            });
            secondRowInputs.forEach(input => {
                if (!mainEventRadio.checked) {
                    input.removeAttribute('name');
                } else if (input.name.includes('[]')) { // 새로 추가한 경우
                    input.name = input.name.replace('[]', '[' + currentIndex + ']');
                }
            });
            currentIndex++;
        }
    }
    function unescapeHtml(text) {
        const doc = new DOMParser().parseFromString(text, 'text/html');
        return doc.documentElement.textContent;
    }
</script>
<script> <!-- 서버에서 불러온 동적 템플릿 데이터 -->
    let item;
    let tdElement;
    <c:forEach items="${imgList}" var="img" varStatus="status">
        <c:if test="${img.file != null}">   // file을 삭제했을 수도 있으니 file이 존재하는 경우에만 템플릿 동적 추가
            item = temp.content.cloneNode(true);
            // 첫번째 템플릿인 경우 삭제 숨기기
            if (tempCnt === 0) {
                const delItems = item.querySelectorAll('.removeWhenFirst');
                delItems.forEach(item => {
                    item.style.display = 'none';
                })
            }

            // 대체 텍스트 채워넣기
            item.querySelector('input[name$="fileAltTxtKo"]').value = unescapeHtml('${img.fileAltTxtKo}');
            item.querySelector('input[name$="fileAltTxtEn"]').value = unescapeHtml('${img.fileAltTxtEn}');
            item.querySelector('input[name$="fileAltTxtJp"]').value = unescapeHtml('${img.fileAltTxtJp}');
            item.querySelector('input[name$="fileAltTxtCn"]').value = unescapeHtml('${img.fileAltTxtCn}');


            // 동적 템플릿 내 파일 업로드 컴포넌트를 JSP에서 삽입
            tdElement = item.querySelector('td');
            tdElement.innerHTML = `
                <input type="hidden" name="imgList[${status.index}].seq" value="${img.seq}"/>
                <c:set var="attach" value="${img.file}" scope="request"/>
                <jsp:include page="/include/component/fileUpload.jsp">
                    <jsp:param name="t_ment" value="이미지 파일 권장 사이즈는 <span class='red'>1020px * 세로 길이 자율</span> 이고, <strong>.jpg,.gif,.png</strong> 파일에 한해 등록이 가능합니다."/>
                    <jsp:param name="t_ment" value="<%=fileLimit(5)%>"/>
                    <jsp:param name="t_required" value="false"/>
                    <jsp:param name="t_fileName" value="imgList[].file"/>
                    <jsp:param name="t_tag" value="DETAIL_IMG"/>
                    <jsp:param name="t_accept" value="<%=imgAccept()%>"/>
                </jsp:include>
            `;

            container.append(item);
            tempCnt++;
        </c:if>
    </c:forEach>
</script>
<script>
    function selectOnlyOne(selectedRadio) {
        // 모든 .categories 클래스를 가진 라디오 버튼들을 불러옴
        const radios = document.querySelectorAll('.categories');

        radios.forEach(radio => {
            if (radio !== selectedRadio) {
                radio.checked = false;
            }
        });
    }
</script>
<script>
    // 각 언어에 대한 사용자가 입력한 이벤트명과 이벤트 내용 저장할 변수
    const info = {
        KO: { name: '', content: '', locAlt: ''},
        EN: { name: '', content: '', locAlt: ''},
        JP: { name: '', content: '', locAlt: ''},
        CN: { name: '', content: '', locAlt: ''},
    };

    // DB에서 받아온 이벤트명과 이벤트 내용 저장할 변수
    const eventData = {
        KO: {name: "<c:out value="${data.decodedEventNmKoForJs}" escapeXml="false"/>", content: "<c:out value="${data.decodedContentKoForJs}" escapeXml="false"/>", locAlt: "<c:out value="${data.decodedLocAltKoForJs}" escapeXml="false"/>"},
        EN: {name: "<c:out value="${data.decodedEventNmEnForJs}" escapeXml="false"/>", content: "<c:out value="${data.decodedContentEnForJs}" escapeXml="false"/>", locAlt: "<c:out value="${data.decodedLocAltEnForJs}" escapeXml="false"/>"},
        JP: {name: "<c:out value="${data.decodedEventNmJpForJs}" escapeXml="false"/>", content: "<c:out value="${data.decodedContentJpForJs}" escapeXml="false"/>", locAlt: "<c:out value="${data.decodedLocAltJpForJs}" escapeXml="false"/>"},
        CN: {name: "<c:out value="${data.decodedEventNmCnForJs}" escapeXml="false"/>", content: "<c:out value="${data.decodedContentCnForJs}" escapeXml="false"/>", locAlt: "<c:out value="${data.decodedLocAltCnForJs}" escapeXml="false"/>"}
    };

    // DB에서 받아온 이벤트명과 내용을 info 객체로 옮김
    info.KO.name    = eventData.KO.name || '';
    info.KO.content = eventData.KO.content || '';
    info.KO.locAlt  = eventData.KO.locAlt || '';
    info.EN.name    = eventData.EN.name || '';
    info.EN.content = eventData.EN.content || '';
    info.EN.locAlt  = eventData.EN.locAlt || '';
    info.JP.name    = eventData.JP.name || ''
    info.JP.content = eventData.JP.content || ''
    info.JP.locAlt  = eventData.JP.locAlt || '';
    info.CN.name    = eventData.CN.name || ''
    info.CN.content = eventData.CN.content || ''
    info.CN.locAlt  = eventData.CN.locAlt || '';

    /*
        게시글 대체 텍스트, 배너 데체 텍스트 값 저장할 객체
     */
    const altText = {
        KO: {detail: '', banner: '', video: ''},
        EN: {detail: '', banner: '', video: ''},
        JP: {detail: '', banner: '', video: ''},
        CN: {detail: '', banner: '', video: ''}
    };

    const altTextData = {
        KO: {detail: '<c:out value="${data.decodedImgAltTxtKoForJs}" escapeXml="false"/>', banner: '<c:out value="${data.decodedBannerAltTxtKoForJs}" escapeXml="false"/>',   video: '<c:out value="${data.decodedVideoAltTxtKoForJs}" escapeXml="false"/>'},
        EN: {detail: '<c:out value="${data.decodedImgAltTxtEnForJs}" escapeXml="false"/>', banner: '<c:out value="${data.decodedBannerAltTxtEnForJs}" escapeXml="false"/>',   video: '<c:out value="${data.decodedVideoAltTxtEnForJs}" escapeXml="false"/>'},
        JP: {detail: '<c:out value="${data.decodedImgAltTxtJpForJs}" escapeXml="false"/>', banner: '<c:out value="${data.decodedBannerAltTxtJpForJs}" escapeXml="false"/>',   video: '<c:out value="${data.decodedVideoAltTxtJpForJs}" escapeXml="false"/>'},
        CN: {detail: '<c:out value="${data.decodedImgAltTxtCnForJs}" escapeXml="false"/>', banner: '<c:out value="${data.decodedBannerAltTxtCnForJs}" escapeXml="false"/>',   video: '<c:out value="${data.decodedVideoAltTxtCnForJs}" escapeXml="false"/>'},
    };

    // DB에서 받아온 데이터를 altText 객체로 옮김
    altText.KO.detail = altTextData.KO.detail || '';
    altText.KO.banner = altTextData.KO.banner || '';
    altText.KO.video  = altTextData.KO.video || '';
    altText.EN.detail = altTextData.EN.detail || '';
    altText.EN.banner = altTextData.EN.banner || '';
    altText.EN.video  = altTextData.EN.video || '';
    altText.JP.detail = altTextData.JP.detail || '';
    altText.JP.banner = altTextData.JP.banner || '';
    altText.JP.video  = altTextData.JP.video || '';
    altText.CN.detail = altTextData.CN.detail || '';
    altText.CN.banner = altTextData.CN.banner || '';
    altText.CN.video  = altTextData.CN.video || '';

    const eventName    = document.getElementById('eventName');
    const eventContent = document.getElementById('eventContent');
    const noticeYn     = document.getElementById('notice');
    const langs        = ['KO', 'EN', 'JP', 'CN'];
    const altInputKO   = document.getElementById('detailAltKo');
    const altInputEN   = document.getElementById('detailAltEn');
    const altInputJP   = document.getElementById('detailAltJp');
    const altInputCN   = document.getElementById('detailAltCn');
    const bannerImgTr  = document.getElementById('bannerImgTr');
    const bannerImgTxtTr = document.getElementById('bannerImgTxtTr');
    const bannerAltKo = document.getElementById('bannerAltKo');
    const bannerAltEn = document.getElementById('bannerAltEn');
    const bannerAltJp = document.getElementById('bannerAltJp');
    const bannerAltCn = document.getElementById('bannerAltCn');
    const videoAltKo = document.getElementById('videoAltKo');
    const videoAltEn = document.getElementById('videoAltEn');
    const videoAltJp = document.getElementById('videoAltJp');
    const videoAltCn = document.getElementById('videoAltCn');
    const locAltInput     = document.getElementById('locAltInput');
    /*
        페이지 로드 시 자동 수행 로직들
     */
    toggleNotice();     // 공지 배너인 경우 멘트 + 필수 표시 위해
    showLoc();          // 페이지 로드시 장소 래디오 세팅하고 el 보여주고
    showMainCategory(); // 페이지 로드시 메인 이벤트 카테고리 세팅
    langs.forEach(lang => {
        updateLangBoxColor(lang);
    });

    /*
        언어값 색상 변경시키기 위한 이벤트리스너 (에디터는 editor.js안에)
     */
    eventName.addEventListener('input', function () {
        const currLang      = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[currLang].name = eventName.value;
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
        const name    = info[lang].name;
        const content = info[lang].content;

        if (name && content) {
            langBox.style.backgroundColor = '#00BF35';
        } else if (name || content) {
            langBox.style.backgroundColor = '#EB4700';
        } else {
            langBox.style.backgroundColor = '';
        }
    }

    /*
        서버에 save 날릴때 수행하는 func 모음
    */
    function save() {
        setNoticeYn();          // 공지배너여부
        setHideAfterEndYn();    // 이벤트종료시 비공개여부
        setEventNmContent();    // 모든 언어에 대한 이벤트명, 이벤튼 내용을 폼에 필드로 추가
        setLocName();           // 장소 name 속성 세팅
        setMainCategory();      // Main Event인 경우 메인 이벤트 카테고리에서 선택된 값에 name 속성 세팅
        setDetailImgName();     // Main Event인 경우 게시글 이미지 리스트 name 속성 세팅
        submitFormIntoHiddenFrame(document.workForm);
    }

    function chooseLang(el, lang) {
        const langNm = lang.charAt(0).toUpperCase() + lang.charAt(1).toLowerCase();                   // 현재언어 to Ko, En, Jp, Cn
        const bef    = document.querySelector('.lang-select a.selected').getAttribute('data-lang');   // 이전 선택된 언어

        info[bef].name    = eventName.value;                                            // 이전 언어 이벤트명 value
        info[bef].content = tinymce.get('eventContent').getContent();                   // 이전 언어 이벤트내용 value
        info[bef].locAlt  = locAltInput.value;                                          // 이전 언어 별도장소 value

        const buttons = document.querySelectorAll('.lang-select a');                    // 언어 선택 상태 업데이트
        buttons.forEach(btn => btn.classList.remove('selected'));
        el.classList.add('selected');

        eventName.value   = info[lang].name;                                            // 이벤트명을 info에서 가져와서 넣고
        eventName.name    = 'eventNm' + langNm;                                         // name 속성값도 현재언어로
        tinymce.get('eventContent').setContent(decodeHTML(info[lang].content || ''));   // 이벤트 내용을 info에서 가져와서 넣음 (DB에서 불러오는 경우는 HTML 엔티티로 인코딩 되어 있어 디코딩하고)
        eventContent.name = 'content' + langNm;                                         // name 속성값도 현재언어로
        locAltInput.value = info[lang].locAlt;                                          // 별도장소를 info에서 가져와서 넣고
        locAltInput.name  = 'locAlt' + langNm;                                          // name 속성값도 현재언어로

        setLengthSpan(eventName);                                                       // 글자 수 업데이트
    }

    /*
        인풋 박스 값 저장 및 로드
        스타일 숨김
        name 값 세팅
    */
    function toggleNotice() {
        if (noticeYn.checked) {
            // 저장
            altText["KO"].detail = altInputKO.value;
            altText["EN"].detail = altInputEN.value;
            altText["JP"].detail = altInputJP.value;
            altText["CN"].detail = altInputCN.value;
            // 로드
            bannerAltKo.value = altText["KO"].banner || '';
            bannerAltEn.value = altText["EN"].banner || '';
            bannerAltJp.value = altText["JP"].banner || '';
            bannerAltCn.value = altText["CN"].banner || '';

            bannerImgTr.style.display = '';
            bannerImgTxtTr.style.display = '';

            bannerAltKo.setAttribute('name', 'bannerAltTxtKo');
            bannerAltEn.setAttribute('name', 'bannerAltTxtEn');
            bannerAltJp.setAttribute('name', 'bannerAltTxtJp');
            bannerAltCn.setAttribute('name', 'bannerAltTxtCn');
        } else {
            altText["KO"].banner = bannerAltKo.value;
            altText["EN"].banner = bannerAltEn.value;
            altText["JP"].banner = bannerAltJp.value;
            altText["CN"].banner = bannerAltCn.value;
            altInputKO.value = altText["KO"].detail || '';
            altInputEN.value = altText["EN"].detail || '';
            altInputJP.value = altText["JP"].detail || '';
            altInputCN.value = altText["CN"].detail || '';

            bannerImgTr.style.display = 'none';
            bannerImgTxtTr.style.display = 'none';

            bannerAltKo.removeAttribute('name');
            bannerAltEn.removeAttribute('name');
            bannerAltJp.removeAttribute('name');
            bannerAltCn.removeAttribute('name');
        }
    }

    function showMainCategory(obj) {
        const mainCategoryTr  = document.getElementById('mainCategory');
        const mainEventRadio  = document.getElementById('type1');
        const detailImgTr = document.getElementById('detailImgTr');
        const detailImgAltTxtTr = document.getElementById('detailImgAltTxtTr');
        const addedTemplates = container.querySelectorAll('tr');
        const firstMainEventImgRows = document.querySelectorAll('.firstMainEventImgRow');

        if (obj || mainEventRadio.checked) {
            mainCategoryTr.style.display = '';

            detailImgTr.style.display = 'none';
            detailImgAltTxtTr.style.display = 'none';

            if (tempCnt === 0) {
                firstMainEventImgRows.forEach(e => {
                    e.style.display = '';
                })
                tempCnt += 1;
                // addDetailImg();
            }
            addedTemplates.forEach(template => {
                template.style.display = '';
            });
        }
        else {
            mainCategoryTr.style.display = 'none';

            detailImgTr.style.display = '';
            detailImgAltTxtTr.style.display = '';
            firstMainEventImgRows.forEach(e => {
                e.style.display = 'none';
            })
            addedTemplates.forEach(template => {
                template.style.display = 'none';
            });
        }
    }

    function showLoc() {
        const loc    = document.getElementById('locStore');
        const locAlt = document.getElementById('locAlt');
        <c:choose>
            <c:when test="${not empty data.locAltKo}">
                locAlt.checked = true;
                document.getElementById('altInput').style.display = 'block';
                document.getElementById('storeInput').style.display = 'none';
            </c:when>
            <c:otherwise>
                loc.checked = true;
                document.getElementById('storeInput').style.display = 'block';
                document.getElementById('altInput').style.display = 'none';
            </c:otherwise>
        </c:choose>
    }

    function toggleLoc(el) {
        const store = document.getElementById('storeInput');
        const alt = document.getElementById('altInput');

        if (el.id === 'locStore') {
            store.style.display = 'block';
            alt.style.display = 'none';
        } else {
            alt.style.display = 'block';
            store.style.display = 'none';
        }
    }

    function setLocName() {
        const locStoreRadio    = document.getElementById('locStore');
        const locAltRadio      = document.getElementById('locAlt');
        const locStoreInput    = document.querySelector('#storeInput input');
        const locAltInput      = document.getElementById('locAltInput');
        const eventFacilitySeq = document.querySelector('[data-type="facilitySeqEvent"]');
        const currentLang      = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        const langNm           = currentLang.charAt(0).toUpperCase() + currentLang.slice(1).toLowerCase();

        if (locStoreRadio.checked && !locAltRadio.checked) {            // 매장장소만 선택된 경우
            locStoreInput.setAttribute('name', 'loc');
            eventFacilitySeq.setAttribute('name', 'facilityRelated.facilityLangInfoSeq');

            /*
                별도장소의 name 속성
             */
            document.querySelectorAll('.event-locAlt-hidden-input').forEach(input => input.removeAttribute('name')); // hidden으로 추가된것 name 지우고
            const selectedLangLocAltInput = document.querySelector('input[name="locAlt' + langNm + '"]');            // 현재 선택된 언어의 별도장소도 name 지움
            if (selectedLangLocAltInput) {
                selectedLangLocAltInput.removeAttribute('name');
            }

        } else if (!locStoreRadio.checked && locAltRadio.checked) {      // 별도장소만 선택된 경우
            locStoreInput.removeAttribute('name');
            eventFacilitySeq.removeAttribute('name');

            /*
                별도장소 다국어 input을 hidden으로 추가
             */
            const bef = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
            info[bef].locAlt = locAltInput.value;

            document.querySelectorAll('.event-locAlt-hidden-input').forEach(input => input.remove());

            for (const [lang, data] of Object.entries(info)) {
                const langNm = lang.charAt(0).toUpperCase() + lang.slice(1).toLowerCase();
                if (data.locAlt) {
                    const locAltField = document.createElement('input');
                    locAltField.type = 'hidden';
                    locAltField.name = 'locAlt' + langNm;
                    locAltField.classList.add('event-locAlt-hidden-input');
                    locAltField.value = data.locAlt;
                    document.getElementById('altInput').appendChild(locAltField);
                }
            }

            locAltInput.removeAttribute('name');    // 현재 활성화된 탭의 별도장소 name 속성 제거

        } else {                                    // 매장장소, 별도장소 둘다 선택 안된 경우
            locStoreInput.removeAttribute('name');
            eventFacilitySeq.removeAttribute('name');
            document.querySelectorAll('.event-locAlt-hidden-input').forEach(input => input.removeAttribute('name')); // hidden으로 추가된것 name 지우고
            const selectedLangLocAltInput = document.querySelector('input[name="locAlt' + langNm + '"]');            // 현재 선택된 언어의 별도장소도 name 지움
            if (selectedLangLocAltInput) {
                selectedLangLocAltInput.removeAttribute('name');
            }
        }
    }

    function setMainCategory() {
        const mainEventRadio  = document.getElementById('type1');
        const checkedCategory = document.querySelector('input.categories:checked');

        if (mainEventRadio.checked && checkedCategory) {
            checkedCategory.setAttribute('name', 'mainCategory');
        } else {
            if (checkedCategory) {
                checkedCategory.removeAttribute('name');
            }
        }
    }

    function setNoticeYn() {
        const hidden = document.querySelectorAll('input[name="noticeYn"][type="hidden"]');  // 기존에 생성된 N value 엘리먼트 확인
        if (noticeYn.checked) {
            if (hidden.length > 0) {
                hidden.forEach(el => {
                    el.remove()
                });
            }
        } else {
            if (hidden.length === 0) {
                const el = document.createElement('input');
                el.type = 'hidden';
                el.name = 'noticeYn';
                el.value = 'N';
                document.getElementById('noticeField').appendChild(el);
            } else if (hidden.length > 1) {
                for (let i = 1; i < hidden.length; i++) {
                    hidden[i].remove();
                }
            }

        }
    }

    function setHideAfterEndYn() {
        const hideAfterEndYn = document.getElementById('hideAfterEnd');
        const hidden = document.querySelectorAll('input[name="hideAfterEndYn"][type="hidden"]'); // 기존에 생성된 N value 엘리먼트 확인(중복방지)
        if (hideAfterEndYn.checked) {
            if (hidden.length > 0) {
                hidden.forEach(el => el.remove());
            }
        } else {
            if (hidden.length === 0) {
                const el = document.createElement('input');
                el.type = 'hidden';
                el.name = 'hideAfterEndYn';
                el.value = 'N';
                document.getElementById('sDateField').appendChild(el);
            }
        }
    }

    function setEventNmContent() {
        const bef = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
        info[bef].name    = eventName.value;
        info[bef].content = tinymce.get('eventContent').getContent();

        document.querySelectorAll('.event-hidden-input').forEach(input => input.remove());

        for (const [lang, data] of Object.entries(info)) {
            const langNm = lang.charAt(0).toUpperCase() + lang.slice(1).toLowerCase();
            if (data.name) {
                const nameField = document.createElement('input');
                nameField.type = 'hidden';
                nameField.name = 'eventNm' + langNm;
                nameField.classList.add('event-hidden-input');
                nameField.value = data.name;
                document.getElementById('eventNmField').appendChild(nameField);
            }
            if (data.content) {
                const contentField = document.createElement('input');
                contentField.type = 'hidden';
                contentField.name = 'content' + langNm;
                contentField.classList.add('event-hidden-input');
                contentField.value = data.content;
                document.getElementById('eventContentField').appendChild(contentField);
            }
        }

        eventName.removeAttribute('name');      // 현재 활성화된 탭의 이벤트명  name 속성 제거
        eventContent.removeAttribute('name');   // 현재 활성화된 탭의 이벤트내용 name 속성 제거
    }

    // 글자 수 업데이트 함수
    function setLengthSpan(input) {
        try {
            const $input = $(input);
            let $span = $input.next("span.length");

            // 이미 생성된 span.length가 없다면 새로 추가
            if ($span.length === 0) {
                $span = $("<span class='length'></span>");
                $input.after($span);
            }

            const maxLength = $input.attr("langMaxLength") || $input.attr("maxlength"); // langMaxLength 속성을 우선 사용하고, 없으면 maxlength 사용
            $span.text($input.val().length + "/" + maxLength);
        } catch (err) {
            console.error(err);
        }
    }

    function decodeHTML(html) {
        const txt = document.createElement("textarea");
        txt.innerHTML = html;
        return txt.value;
    }
</script>
<script>    /* 항목 삭제 */
const onFail = function () {
    location.reload();
}

<c:if test="${not isNew}">
$("tfoot .leftBtn").deleteArticle("delete", {"seq": '${data.seq}'}).then(() => {
    location.href = "list"
}, onFail);
</c:if>
</script>
</body>
</html>
