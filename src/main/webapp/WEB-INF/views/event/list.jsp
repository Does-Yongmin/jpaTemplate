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
</head>

<body>

<div id="pageTitle">이벤트 관리</div>

<ul class="pageGuide">
    <li>이벤트 메뉴를 관리할 수 있습니다.</li>
    <li>공지상태(공개상태)는 즉시 변경되며, 공지는 <b>최대 10개</b> 등록 가능합니다.</li>
    <li><b>공지에 등록된 게시물은 미공지로 변경 후 삭제 가능</b>합니다.</li>
    <li>공지에 게시글은 메인홈페이지의 <b>이벤트 메뉴의 상단 공지배너</b>에 썸네일과 함께 노출됩니다.</li>
</ul>

<%-- 공지 배너 이벤트 --%>
<div class="listBox-grid">
    <form method="post" action="saveOrder">
        <table id="open">
            <thead>
            <tr>
                <td colspan="50">
                    <div class="tableTitle">공지 배너 이벤트</div>
                    <div class="listTotal">전체 <span class="bold gray"><c:out value="${searchY.totalCount}"/></span> 건</div>
                </td>
            </tr>
            <tr>
                <th style="width:10px;"><input type="checkbox" class="checkAll"/></th>
                <th style="width:30px;">번호</th>
                <th style="width:150px;">구분</th>
                <th>제목</th>
                <th style="width: 150px;">제공언어</th>
                <th style="width:100px;">공지상태</th>
                <th style="width:100px;">공개상태</th>
                <th style="width:100px;">게시상태</th>
                <th style="width:100px;">등록일</th>
                <th style="width:100px;">등록자</th>
                <th style="width:80px;">수정</th>
            </tr>
            <c:if test='${empty noticeY}'>
                <tr>
                    <td colspan="50">No Data.</td>
                </tr>
            </c:if>
            </thead>
            <tbody>
            <c:forEach items="${noticeY}" var="vo" varStatus="status">
                <tr id="<c:out value="${vo.seq}"/>">
                    <input type="hidden" name="seqs" value="<c:out value="${vo.seq}"/>"/>
                    <input type="hidden" name="noticeYns" value="<c:out value="${vo.noticeYn}"/>"/>
                    <td><input type="checkbox" value="<c:out value="${vo.seq}"/>"></td>
                    <td><c:out value="${(searchY.pageNum - 1) * 10 + status.index + 1}"/></td>
                    <td><c:out value="${vo.type.value}"/></td>
                    <td><c:out value="${vo.eventNmKo}" escapeXml="false"/></td>
                    <td><c:out value='${vo.getSupportLangString(" | ")}'/></td>
                    <td>
                        <select class="notice ${vo.notice ? 'Y' : 'N'}" data-seq="<c:out value="${vo.seq}"/>">
                            <option value="Y" class="Y" ${vo.notice  ? 'selected' : ''}>공지</option>
                            <option value="N" class="N" ${!vo.notice ? 'selected' : ''}>미공지</option>
                        </select>
                    </td>
                    <td>
                        <select class="show ${vo.use ? 'Y' : 'N'}" data-seq="<c:out value="${vo.seq}"/>">
                            <option value="Y" class="Y" ${vo.use  ? 'selected' : ''}>공개</option>
                            <option value="N" class="N" ${!vo.use ? 'selected' : ''}>비공개</option>
                        </select>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${vo.visibleYn == 'Y'}">
                                <span style="color: white; background-color: green; padding: 4px 8px; border-radius: 4px;">게시중</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: white; background-color: #ff0000; padding: 4px 8px; border-radius: 4px;">미게시</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><c:out value="${vo.createDateYmd}"/></td>
                    <td><c:out value="${vo.creatorMasked}"/></td>
                    <td>
                        <span class="click view whiteBtn" data-page-num="<c:out value="${searchY.pageNum}"/>" data-seq="<c:out value="${vo.seq}"/>">수정</span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
            <tfoot>
            <tr>
                <td colspan="50">
                    <input type="submit" class="mot3 rightBtn grayBtn" value="순서 저장"/>
                </td>
            </tr>
            </tfoot>
        </table>
    </form>
    <div>
        <br>
    </div>
</div>

<%-- 검색 --%>
<jsp:include page="/include/search/form.jsp" flush="false">
    <jsp:param name="pageRow"      value="true"/>
    <jsp:param name="selectEnum"   value="useYn:공개상태"/>
    <jsp:param name="searchText"   value="이벤트명/내용"/>
    <jsp:param name="searchPeriod" value="true"/>
</jsp:include>

<%--구분--%>
<jsp:include page="/include/type.jsp">
    <jsp:param name="displayType" value="name"/>
</jsp:include>

<%--일반(비공지) 이벤트--%>
<div class="listBox-grid">
    <table>
        <thead>
        <tr>
            <td colspan="50">
                <div class="tableTitle">일반 이벤트</div>
                <div class="listTotal">전체 <span class="bold gray"><c:out value="${search.totalCount}"/></span> 건</div>
            </td>
        </tr>
        <tr>
            <th style="width:10px;"><input type="checkbox" class="checkAll"/></th>
            <th style="width:30px;">번호</th>
            <th style="width:150px;">구분</th>
            <th>제목</th>
            <th style="width: 150px;">제공언어</th>
            <th style="width:100px;">공지상태</th>
            <th style="width:100px;">공개상태</th>
            <th style="width:100px;">게시상태</th>
            <th style="width:100px;">등록일</th>
            <th style="width:100px;">등록자</th>
            <th style="width:80px;">수정</th>
        </tr>
        <c:if test='${empty noticeN}'>
            <tr>
                <td colspan="50">No Data.</td>
            </tr>
        </c:if>
        </thead>
        <tbody>
        <c:forEach items="${noticeN}" var="vo" varStatus="status">
            <tr id="<c:out value="${vo.seq}"/>">
                <input type="hidden" name="seq"       value="<c:out value="${vo.seq}"/>"/>
                <input type="hidden" name="noticeYns" value="<c:out value="${vo.noticeYn}"/>"/>
                <td><input type="checkbox" value="<c:out value="${vo.seq}"/>"></td>
                <td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
                <td><c:out value="${vo.type.value}"/></td>
                <td><c:out value="${vo.eventNmKo}" escapeXml="false"/></td>
                <td><c:out value='${vo.getSupportLangString(" | ")}'/></td>
                <td>
                    <select class="notice ${vo.notice ? 'Y' : 'N'}" data-seq="<c:out value="${vo.seq}"/>">
                        <option value="Y" class="Y" ${vo.notice  ? 'selected' : ''}>공지</option>
                        <option value="N" class="N" ${!vo.notice ? 'selected' : ''}>미공지</option>
                    </select>
                </td>
                <td>
                    <select class="show ${vo.use ? 'Y' : 'N'}" data-seq="<c:out value="${vo.seq}"/>">
                        <option value="Y" class="Y" ${vo.use  ? 'selected' : ''}>공개</option>
                        <option value="N" class="N" ${!vo.use ? 'selected' : ''}>비공개</option>
                    </select>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${vo.visibleYn == 'Y'}">
                            <span style="color: white; background-color: green; padding: 4px 8px; border-radius: 4px;">게시중</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: white; background-color: #ff0000; padding: 4px 8px; border-radius: 4px;">미게시</span>
                        </c:otherwise>
                    </c:choose>
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
            </td>
        </tr>
        </tfoot>
    </table>

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
        const seqs      = $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",");
        const noticeYns = $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => {
            return $(e).closest("tr").find("input[name='noticeYns']").val();
        }).join(",");

        return { "seq": seqs, "noticeYns": noticeYns};
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
    $(".view", ".listBox-grid").viewDetail("detail", document.searchForm, "typeInput");
    $("tbody .delete", ".listBox-grid").deleteArticle("delete").then(onFail);
    $("table#open tbody", ".listBox-grid").tableDnD({
        onDrop: function () {
            alert("순서 변경은 하단 순서 저장 버튼을 눌러야 적용됩니다.");
        }
    });
</script>

</html>
