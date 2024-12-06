<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
    <%@ include file="/include/head.jsp" %>
    <link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
</head>

<body>

<div id="pageTitle">맛 가이드 관리 <span style="color: #d14a4a;">*현재 미운영되고 있는 메뉴입니다.</span></div>

<ul class="pageGuide">
    <li>맛가이드 테마를 관리할 수 있습니다.<b>최소 2개 이상의 테마 등록이 필요</b>합니다.</li>
    <li>게시글은 <b>맛가이드 테마 영역</b>에 등록 이미지와 함께 노출됩니다.</li>
    <li>글 순서는 드래그하여 변경할 수 있으며, <b>변경 후 반드시 하단의 '순서저장' 버튼을 눌러야 합니다.</b></li>
</ul>

<%-- 검색 --%>
<jsp:include page="/include/search/form.jsp" flush="false">
    <jsp:param name="pageRow"      value="true"/>
    <jsp:param name="searchText"   value="테마명/키워드"/>
</jsp:include>

<div class="listBox-grid">
    <form method="post" action="saveOrder">
        <table>
            <thead>
            <tr>
                <td colspan="50">
                    <div class="listTotal">전체 <span class="bold gray"><c:out value="${search.totalCount}"/></span> 건</div>
                </td>
            </tr>
            <tr>
                <th style="width:10px;"><input type="checkbox" class="checkAll"/></th>
                <th style="width:30px;">번호</th>
                <th>제목</th>
                <th style="width: 150px;">제공 언어</th>
                <th style="width:100px;">공개상태</th>
                <th style="width:100px;">등록일</th>
                <th style="width:100px;">등록자</th>
                <th style="width:80px;">수정</th>
            </tr>
            <c:if test='${empty list}'>
                <tr>
                    <td colspan="50">No Data.</td>
                </tr>
            </c:if>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="vo" varStatus="status">
                <tr id="<c:out value="${vo.seq}"/>">
                    <input type="hidden" name="seqs" value="<c:out value="${vo.seq}"/>"/>
                    <td><input type="checkbox" value="<c:out value="${vo.seq}"/>"></td>
                    <td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
                    <td><c:out value="${vo.themeNmKoEllipsis}" escapeXml="false"/></td>
                    <td><c:out value='${vo.getSupportLangString(" | ")}'/></td>
                    <td>
                        <select class="show ${vo.use ? 'Y' : 'N'}" data-seq="<c:out value="${vo.seq}"/>">
                            <option value="Y" class="Y" ${vo.use  ? 'selected' : ''}>공개</option>
                            <option value="N" class="N" ${!vo.use ? 'selected' : ''}>비공개</option>
                        </select>
                    </td>
                    <td><c:out value="${vo.createDateYmd}"/></td>
                    <td><c:out value="${vo.creatorMasked}"/></td>
                    <td>
                        <span class="click view whiteBtn" data-page-num="<c:out value="${search.pageNum}"/>" data-seq="<c:out value="${vo.seq}"/>">수정</span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
            <tfoot>
            <tr>
                <td colspan="50">
                    <c:if test="${not isNew}">
                        <a type="button" class="mot3 leftBtn lightBtn-round delBtn">삭제</a>
                    </c:if>
                    <a href="javascript:;" class="mot3 rightBtn grayBtn view">등록</a>
                    <input type="submit" class="mot3 rightBtn grayBtn"  style="margin-right: 5px;" value="순서 저장"/>
                </td>
            </tr>
            </tfoot>
        </table>
    </form>
    <%--######################## 페이징 ########################--%>
    <jsp:include page="/include/paging.jsp">
        <jsp:param name="formName" value="searchForm"/>
    </jsp:include>
</div>
</body>

<script src="<c:out value="${cPath}"/>/assets/js/list.js" charset="utf-8" type="text/javascript"></script>
<script src="<c:out value="${cPath}"/>/assets/vendor/jquery.tablednd.js" charset="utf-8" type="text/javascript"></script>
<script>
    const getCheckedVal	= () => {
        return { "seq" : $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",")}
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
    $("tbody select.notice", ".listBox-grid").changeStatus("changeStatus", "noticeYn").then(onSuccess, onFailMsg);
    $("tbody select.show",   ".listBox-grid").changeStatus("changeStatus", "useYn").then(onSuccess, onFailMsg);
    $("tfoot .leftBtn", ".listBox-grid").deleteArticle("delete", getCheckedVal).then(() => {location.reload()});
    $(".view", ".listBox-grid").viewDetail("detail", document.searchForm);
    $("tbody .delete", ".listBox-grid").deleteArticle("delete").then(onFail);
    $("table tbody", ".listBox-grid").tableDnD({
        onDrop: function () {
            alert("순서 변경은 하단 순서 저장 버튼을 눌러야 적용됩니다.");
        }
    });
</script>

</html>
