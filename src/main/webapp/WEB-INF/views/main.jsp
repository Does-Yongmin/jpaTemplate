<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
    <%@ include file="/include/head.jsp" %>
    <link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
    <style type="text/css">
        .container {
            display: grid;
            grid-template-columns: 1fr 1fr; /* 2등분으로 나누기 */
            gap: 10px;
            margin-bottom: 50px;
        }
        .inner-container{
            padding: 10px;
        }

        .card-title {
            font-size:20px;
            font-weight:bold;
            margin-bottom: 10px;
        }

        .card-container{
            display: grid;
            grid-template-columns: 1fr 1fr; /* 2개의 열로 나누기 */
            gap: 10px;
        }

        .card-quick-menu{
            font-size: 20px;
            font-weight:500;
            color:#CECECE;
            background-color:#231f20;
            text-align: center;
            border: 1px solid black;
            padding: 10px;
            border-radius: 7px;
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card-dashboard{
            position: relative;
            border: 1px solid black;
            border-radius: 7px;
            height: 250px;
        }

        .dashboard-title {
            font-size: 30px;
            font-weight: bold;
            position: absolute;
            top: 20px; /* 상단 여백 */
            left: 20px; /* 좌측 여백 */
            margin: 5px;
        }

        .dashboard-description{
            margin-top: 70px; /* 위쪽에 여백을 추가 */
            margin-left: 25px;
            font-size: 13px;
        }

        .dashboard-count {
            color: #0080ff;
            font-size: 30px;
            position: absolute;
            bottom: 20px; /* 하단 여백 */
            right: 20px; /* 우측 여백 */
            font-weight: bold; /* 숫자 강조 */
            margin: 5px;
        }

        .card-container > a,
        td > a
        {
            all: unset; /* 모든 기본 스타일을 제거 */
            text-decoration: none; /* 밑줄 제거 */
            color: inherit; /* 부모 요소의 색상 상속 */
            cursor: pointer; /* 커서 모양을 클릭 가능한 링크로 유지 */
        }
    </style>
</head>

<body>

<!-- 마스터 관리자 일때만 대시보드 노출 -->
<c:choose>
    <c:when test="${isMasterAdmin}">
        <div class="container">
            <div class="inner-container">
                <div class="card-title">대시보드</div>
                <div class="card-container">
                    <a href="/system/admin/list?adminStatus=R">
                        <div class="card-dashboard">
                            <div class="dashboard-title">미승인 사용자</div>
                            <div class="dashboard-description">가입 30일 이내</div>
                            <div class="dashboard-count"><c:out value="${countReadyAdmin}"/>명</div>
                        </div>
                    </a>
                    <a href="/facility/facility/list?approveYn=N">
                        <div class="card-dashboard">
                            <div class="dashboard-title">미승인 매장</div>
                            <div class="dashboard-count"><c:out value="${countReadyFacility}"/>건</div>
                        </div>
                    </a>
                </div>
            </div>
            <div class="inner-container">
                <div class="card-title">빠른 메뉴</div>
                <div class="card-container">
                    <a href="/kv/main-kv/list">
                        <div class="card-quick-menu">KV 관리</div>
                    </a>
                    <a href="/facility/facility/list?approveYn=Y">
                        <div class="card-quick-menu">매장 및 시설 관리</div>
                    </a>
                    <a href="/event/event/list">
                        <div class="card-quick-menu">이벤트 관리</div>
                    </a>
                    <a href="/kiosk/kiosk/list">
                        <div class="card-quick-menu">키오스크 콘텐츠 관리</div>
                    </a>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="container">
            <div class="inner-container">
                <div class="card-title">빠른 메뉴</div>
                <div class="card-container">
                    <a href="/kv/main-kv/list">
                        <div class="card-quick-menu">KV 관리</div>
                    </a>
                    <a href="/facility/facility/list?approveYn=Y">
                        <div class="card-quick-menu">매장 및 시설 관리</div>
                    </a>
                    <a href="/event/event/list">
                        <div class="card-quick-menu">이벤트 관리</div>
                    </a>
                    <a href="/kiosk/kiosk/list">
                        <div class="card-quick-menu">키오스크 콘텐츠 관리</div>
                    </a>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<div class="listBox-grid">
    <%-- 관리자웹 공지사항 --%>
    <table id="notice-table">
        <thead>
        <tr>
            <td colspan="50">
                <div>
                    <div style="font-size:20px; font-weight:bold; user-select:none; position:absolute; left:0; bottom:20px;">
                        관리자웹 공지사항
                    </div>
                    <div style="position:absolute; left:160px; bottom:10px;">
                        페이지당 행 개수 :
                        <jsp:include page="/include/search/pageRow.jsp"	flush="false">
                            <jsp:param name="addFive" value="true"/>
                            <jsp:param name="searchVOName" value="noticeSearch"/>
                        </jsp:include>
                    </div>
                </div>
                <div>
                    <div class="listTotal">
                        <a class="click view whiteBtn-round" href="/customer/notice/list">더보기 ></a>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <th style="width:600px;">제목</th>
            <th style="width:100px;">등록일</th>
            <th style="width:100px;">등록자</th>
            <th style="width:80px;">수정</th>
        </tr>
        <c:if test='${empty noticeList}'>
            <tr>
                <td colspan="50">No Data.</td>
            </tr>
        </c:if>
        </thead>
        <tbody>
        <c:forEach items="${noticeList}" var="vo" varStatus="status">
            <tr id="<c:out value="${vo.seq}"/>">
                <td><a href="/customer/notice/view?seq=<c:out value="${vo.seq}"/>"><c:out value="${vo.titleKoEllipsis}" escapeXml="false"/></a></td>
                <td><c:out value="${vo.createDateYmd}"/></td>
                <td><c:out value="${vo.creatorMasked}"/></td>
                <td>
                    <span class="click view whiteBtn" data-seq="<c:out value="${vo.seq}"/>">수정</span>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <form name="searchForm" action="/main" method="get">
        <input type="hidden" name="pageRow" value="<c:out value="${noticeSearch.pageRow}"/>"/>
    </form>
    <%--######################## 관리자웹 페이징 ########################--%>
    <div id="pagingAdm">
        <jsp:include page="/include/paging.jsp">
            <jsp:param name="searchVOName" value="noticeSearch"/>
            <jsp:param name="formName" value="searchForm"/>
        </jsp:include>
    </div>
</div>
</body>

<script src="<c:out value="${cPath}"/>/assets/js/list.js" charset="utf-8" type="text/javascript"></script>
<script>
    const onSuccess = function () {
        $(this).addClass("Y N").removeClass(this.value);
        location.reload();
    }
    const onFail = function () {
        location.reload();
    }
    const onFailMsg = function (resp) {
        alert(resp.msg);
        location.reload();
    }

    $("#notice-table tbody select.show",   ".listBox-grid").changeStatus("/customer/notice/changeStatus", "useYn").then(onSuccess, onFailMsg);
    $("#notice-table .view", ".listBox-grid").viewDetail("/customer/notice/detail", document.createElement('form'));
</script>
<script>
    // 페이지당 행개수 변경시 자동으로 submit 처리
    const selectPageRow = document.querySelector('select[name=pageRow]');
    selectPageRow.addEventListener('change', e => {
        // select 에서 선택한 페이지당 행개수를 input 에 세팅후 submit
        const value = e.target.value;
        const pageRow = document.searchForm.querySelector('input[name="pageRow"]');

        pageRow.value = value;

        document.searchForm.submit();
    })
</script>

</html>
