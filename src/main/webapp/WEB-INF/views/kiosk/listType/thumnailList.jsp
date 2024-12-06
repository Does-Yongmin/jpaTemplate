<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"	uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.does.component.AttachPathResolver" %>
<%@ page import="com.does.biz.primary.domain.kiosk.KioskVO" %>
<%@ page import="java.util.List" %>

<style>
    .thumbnail-list-container {
        display: flex;
        /*justify-content: space-between; !* 자식 요소를 양쪽 끝에 배치 *!*/
        flex-wrap: wrap;
        margin: 5px auto;
    }
    .card {
        width: 19%;
        background-color: #fff;
        padding: 10px;
        margin: 5px 5px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center;
        box-sizing: border-box;
    }
    .top-container {
        position: absolute;
        z-index: 10;
        top: 5px;
        left: 5px;
        width: 95%;
        padding: 5px 5px;
        display: flex;               /* Flexbox 레이아웃 사용 */
        justify-content: space-between; /* 자식 요소를 양쪽 끝에 배치 */
        align-items: center;         /* 세로 중앙 정렬 */
        margin: 0px;
    }
    .content-container {
        display: flex;
        flex-direction: column; /* Stack children vertically */
        align-items: flex-start; /* Align children to the left */
        padding: 10px;
        background-color: #fff;
    }

    .content-support-lang,
    .content-title,
    .content-extra-info,
    .tag-container {
        width: 100%; /* Ensure each child takes full width of the container */
        text-align: left; /* Align text to the left */
    }

    .tag-container {
        display: flex;           /* Flexbox 레이아웃 사용 */
        gap: 5px;               /* 각 chip 사이의 간격 */
        padding: 10px 0px;           /* 컨테이너의 내부 여백 */
    }
    .chip {
        display: inline-block;
        padding: 5px 12px;
        font-size: 12px;
        color: black; /* 글자색을 검은색으로 설정 */
        background-color: rgba(255, 255, 255, 0.82);
        border: 1px solid black; /* 테두리를 검은색으로 설정 */
        border-radius: 50px; /* 모서리를 둥글게 설정 */
        text-align: center;
        white-space: nowrap; /* 텍스트가 줄 바꿈되지 않도록 설정 */
    }
    .green{
        color: white;
        background-color: green;
        border: 1px solid green;
    }

    .content-support-lang{
        font-size: 14px;
    }
    .content-extra-info{
        font-size: 14px;
        color: grey;
    }
    .content-title {
        font-size: 18px;
        font-weight: bold;
        margin: 5px 0;
        text-overflow: ellipsis;    /* 넘치는 텍스트를 '...'으로 표시 */
        overflow: hidden;           /* 넘치는 부분을 숨김 */
        white-space: nowrap;        /* 텍스트를 한 줄로 유지 */
        width: 100%;                /* 너비를 부모 요소에 맞게 설정 */
    }

    /* 캐러셀 */
    /* 캐러셀 */
    .carousel {
        position: relative;
        width: 100%;
        max-width: 800px;
        margin: 10px auto;
        overflow: hidden;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        z-index: 1;
    }

    .carousel-inner {
        display: flex;
        transition: transform 0.5s ease;
        width: 100%; /* 전체 너비를 100%로 설정 */
    }

    .carousel-item {
        flex: 0 0 100%; /* 각 아이템이 100% 너비를 차지하도록 설정 */
        height: 300px; /* 고정된 높이 (필요에 따라 조정) */
        overflow: hidden; /* 넘치는 이미지를 숨김 */
        position: relative; /* 자식 요소의 절대 위치 지정 */
        box-sizing: border-box; /* 패딩과 테두리를 요소의 전체 너비와 높이에 포함 */
    }

    .carousel-item img {
        position: absolute; /* 이미지의 위치를 절대적으로 설정 */
        top: 50%;           /* 이미지의 상단을 부모 요소의 중간으로 설정 */
        left: 50%;          /* 이미지의 좌측을 부모 요소의 중간으로 설정 */
        width: 100%;        /* 이미지 너비를 부모 요소에 맞춤 */
        height: 100%;       /* 이미지 높이를 부모 요소에 맞춤 */
        object-fit: cover;  /* 비율을 유지하며 부모 요소를 덮음 */
        object-position: center; /* 이미지를 중앙에 위치 */
        transform: translate(-50%, -50%); /* 이미지의 중앙을 부모 요소의 중앙에 맞춤 */
    }

    /* 버튼 컨테이너 및 버튼 */
    .carousel-button-container {
        position: absolute;
        top: 90%;
        width: 100%;
        display: flex;
        justify-content: space-between;
        transform: translateY(-50%);
        z-index: 10;
    }

    .carousel-button {
        background-color: rgba(0,0,0,0.5);
        color: #fff;
        border: none;
        padding: 10px;
        cursor: pointer;
    }

    .carousel-prev {
        left: 10px;
    }

    .carousel-next {
        right: 10px;
    }
</style>

<div class="thumbnail-list-container">
    <c:forEach items="${list}" var="vo" varStatus="status">
        <!-- 카드 영역 -->
        <div class="card">
            <input type="hidden" name="seq" value="<c:out value="${vo.seq}"/>"/>
            <div class="carousel" id="carousel<c:out value="${status.index}"/>">
                <div class="top-container">
                    <input type="checkbox" value="<c:out value="${vo.seq}"/>">
                    <div class="chip ${vo.use ? 'green' : ''}"><c:out value="${vo.use ? '공개중' : '비공개'}"/></div>
                </div>
                <div class="carousel-inner view" data-page-num="<c:out value="${search.pageNum}"/>" data-seq="<c:out value="${vo.seq}"/>">
                    <c:if test="${not empty vo.contentImgKo}">
                        <div class="carousel-item">
                            <img src="<c:out value="${AttachPathResolver.getOrgUri(vo.contentImgKo)}"/>" alt="<c:out value="${vo.contentImgKo.altTxt}"/>">
                        </div>
                    </c:if>
                    <c:if test="${not empty vo.contentImgEn}">
                        <div class="carousel-item">
                            <img src="<c:out value="${AttachPathResolver.getOrgUri(vo.contentImgEn)}"/>" alt="<c:out value="${vo.contentImgEn.altTxt}"/>">
                        </div>
                    </c:if>
                    <c:if test="${not empty vo.contentImgJp}">
                        <div class="carousel-item">
                            <img src="<c:out value="${AttachPathResolver.getOrgUri(vo.contentImgJp)}"/>" alt="<c:out value="${vo.contentImgJp.altTxt}"/>">
                        </div>
                    </c:if>
                    <c:if test="${not empty vo.contentImgCn}">
                        <div class="carousel-item">
                            <img src="<c:out value="${AttachPathResolver.getOrgUri(vo.contentImgCn)}"/>" alt="<c:out value="${vo.contentImgCn.altTxt}"/>">
                        </div>
                    </c:if>
                </div>
                <%-- 등록된 이미지가 1개 이상일 경우에만 캐러셀 전환 버튼 표시 --%>
                <c:if test="${vo.countContentImages() > 1}">
                    <div class="carousel-button-container">
                        <button class="carousel-button carousel-prev" onclick="prevSlide('carousel<c:out value="${status.index}"/>')">&#10094;</button>
                        <button class="carousel-button carousel-next" onclick="nextSlide('carousel<c:out value="${status.index}"/>')">&#10095;</button>
                    </div>
                </c:if>
            </div>
            <div class="content-container">
                <div class="content-support-lang"><c:out value='[${vo.getSupportLangString(" | ")}]'/></div>
                <div class="content-title"><c:out value="${vo.title}"/></div>
                <div class="content-extra-info"><c:out value="${vo.exposeSecond}초 | ${vo.postStartDatePretty} ~ ${vo.postEndDatePretty}"/></div>
                <div class="tag-container">
                    <c:forEach items="${vo.exposeTypes}" var="exposeType">
                        <div class="chip"><c:out value="${exposeType.name}"/></div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<script>
    // 캐러셀 상태를 저장할 객체
    const carouselState = {};
    // 각 캐러셀 초기화
    document.addEventListener('DOMContentLoaded', () => {
        const carousels = document.querySelectorAll('.carousel');
        carousels.forEach(carousel => {
            const id = carousel.id;
            initCarousel(id);
        });
    });

    function initCarousel(carouselId) {
        const queryItem = '#' + carouselId + ' .carousel-item';
        const slides = document.querySelectorAll(queryItem);
        const totalSlides = slides.length;
        carouselState[carouselId] = {
            currentIndex: 0,
            totalSlides: totalSlides,
        };

        // 처음 상태를 표시
        showSlide(carouselId, carouselState[carouselId].currentIndex);
    }

    function showSlide(carouselId, index) {
        const state = carouselState[carouselId];
        const totalSlides = state.totalSlides;

        if (index >= totalSlides) {
            state.currentIndex = 0;
        } else if (index < 0) {
            state.currentIndex = totalSlides - 1;
        } else {
            state.currentIndex = index;
        }

        const offset = -state.currentIndex * 100;
        const queryInner = '#' + carouselId + ' .carousel-inner';
        document.querySelector(queryInner).style.transform = 'translateX(' + offset + '%)';
    }

    function nextSlide(carouselId) {
        const state = carouselState[carouselId];
        showSlide(carouselId, state.currentIndex + 1);
    }

    function prevSlide(carouselId) {
        const state = carouselState[carouselId];
        showSlide(carouselId, state.currentIndex - 1);
    }
</script>