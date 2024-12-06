<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>
<%
    request.setAttribute("useYn", Show.values());
    out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
    <head lang="ko">
        <%@ include file="/include/head.jsp" %>
        <link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
        <style type="text/css">
            div.button-group button{
                background-color: transparent !important; /* 백그라운드 컬러 지정된거 현재 페이지에서는 제거 */
                margin-left: 5px;
                margin-right: 5px;
            }
            div.button-group{
                margin: 5px 5px;
            }

            .leftBtn { float:left; border-radius: 7px }
            .rightBtn { float:right; border-radius: 7px }
        </style>
    </head>

    <body>
        <div id="pageTitle"><c:out value="${pageTitle}"/></div>

        <ul class="pageGuide">
            <li>키오스크 컨텐츠를 관리할 수 있습니다.</li>
            <li>키오스크 게시글은 쇼핑몰/타워, 면세 키오스크의 <span style="color: red;">공지 배너의 형태로</span> 노출 됩니다.</li>
            <li>게시글의 키오스크 종류에 따른 노출 여부는 수정을 통해 변경이 가능합니다.</li>
            <li>게시글의 키오스크 종류에 따른 <span style="color:red">노출 순서는 키오스크 종류별 공개 상태 게시물 검색후 리스트로 보기에서 지정 가능합니다.</span></li>
        </ul>

        <%-- 검색 --%>
        <jsp:include page="/include/search/form.jsp" flush="false">
            <jsp:param name="pageRow"       value="true"/>
            <jsp:param name="searchPeriod"  value="true"/>
            <jsp:param name="selectEnum"    value="exposeTypes:키오스크 종류"/>
            <jsp:param name="selectEnum"    value="useYn:공개상태"/>
            <jsp:param name="searchText"    value="제목"/>
        </jsp:include>

        <div class="listBox-grid">
            <div style="display: flex; align-items: center; margin-bottom: 10px">
                <div class="button-group">
                    <button onclick="handleListType('THUMBNAIL');">
                        <img src="/assets/images/common/icon/ico_selected-thumbnail-list.svg" alt="썸네일 아이콘" style="vertical-align: middle; margin-right: 5px;">
                        썸네일로 보기
                    </button>

                    <button onclick="handleListType('TABLE');">
                        <img src="/assets/images/common/icon/ico_selected-table-list.svg" alt="리스트 아이콘" style="vertical-align: middle; margin-right: 5px;">
                        리스트로 보기
                    </button>
                </div>
                <div>전체 <span class="bold gray"><c:out value="${search.totalCount}"/></span> 건</div>
            </div>
            <div class="list-type hidden table-list">
                <jsp:include page="/WEB-INF/views/kiosk/listType/tableList.jsp" flush="false"/>
            </div>
            <div class="list-type hidden thumbnail-list">
                <jsp:include page="/WEB-INF/views/kiosk/listType/thumnailList.jsp" flush="false"/>
            </div>
            <div class="button-group">
                <a type="button" class="mot3 leftBtn lightBtn-round delBtn">삭제</a>
                <a href="javascript:;" class="mot3 rightBtn grayBtn view">등록</a>
            </div>

            <%--######################## 페이징 ########################--%>
            <jsp:include page="/include/paging.jsp">
                <jsp:param name="formName" value="searchForm"/>
            </jsp:include>
        </div>
    </body>

    <script src="<c:out value="${cPath}"/>/assets/js/list.js" charset="utf-8" type="text/javascript"></script>
    <script>
        const getCheckedVal	= () => {
            const viewType = localStorage.getItem(KIOSK_LIST_TYPE_KEY);

            let seq = "";
            if(viewType === 'TABLE'){ seq = $(".table-list tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",");}
            if(viewType === 'THUMBNAIL'){
                seq = Array.from(document.querySelectorAll('input[type=checkbox]:checked')).map(input => input.value).join(',');
            }

            return { "seq" : seq}
        };
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

        $("tbody select.show", ".listBox-grid").changeStatus("changeStatus", "useYn").then(onSuccess, onFailMsg);
        $(".view"			 , ".listBox-grid").viewDetail("detail", document.searchForm);
        $(".button-group .delBtn"	, ".listBox-grid").deleteArticle("delete", getCheckedVal).then(() => {location.reload()});
    </script>
    <script>
        const listTypeDivs = document.querySelectorAll('div.list-type');
        const thumbnailListDivs = document.querySelectorAll('.thumbnail-list');
        const tableListDivs = document.querySelectorAll('.table-list');
        const KIOSK_LIST_TYPE_KEY = 'KIOSK_LIST_TYPE';

        document.addEventListener('DOMContentLoaded', () => {
            // localStorage 에서 이전에 보고 있던 리스트 뷰 타입 가져오기
            const viewType = localStorage.getItem(KIOSK_LIST_TYPE_KEY);

            if(viewType) handleListType(viewType);  // 선택된 뷰 타입이 있었다면 해당 뷰타입으로 제공
            else handleListType('TABLE');           // 없을 경우 기본적으로 테이블 뷰타입으로 제공
        })

        /**
         * 선택한 리스트 뷰 타입에 따라 해당 레이아웃을 노출한다.
         * 사용자가 보던 리스트 뷰 방식을 localStorage 에 저장하여 이후에도 동일한 뷰 타입을 노출 시키도록 한다
         *
         * 1. 썸네일로 보기
         * 2. 리스트로 보기
         * @param listType
         */
        function handleListType(listType){
            if(listType !== 'THUMBNAIL' && listType !== 'TABLE') {
                alert('제공할 수 없는 리스트 타입입니다.');
                return;
            }

            listTypeDivs.forEach(div => {
                div.classList.add('hidden');
            })

            // 선택된 리스트 타입 노출
            if(listType === 'THUMBNAIL')    {
                thumbnailListDivs.forEach(div => {
                    div.classList.remove('hidden');
                })
            }
            if(listType === 'TABLE') {
                tableListDivs.forEach(div => {
                    div.classList.remove('hidden');
                })
            }
            // localStorage 에 현재 리스트 뷰 타입 저장
            localStorage.setItem(KIOSK_LIST_TYPE_KEY, listType);
        }
    </script>
</html>
