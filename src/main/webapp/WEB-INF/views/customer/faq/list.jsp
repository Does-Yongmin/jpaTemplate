<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    public enum Show {
        Y("공개"),
        N("비공개");

        String name;
        Show(String name)		{	this.name = name;	}
        public String getName()	{	return name;		}
    }
%>
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

<div id="pageTitle">자주묻는 질문 관리</div>

<ul class="pageGuide">
    <li>고객문의에 노출되는 자주묻는질문을 관리할 수 있습니다.</li>
</ul>

<%-- 검색 --%>
<jsp:include page="/include/search/form.jsp" flush="false">
    <jsp:param name="pageRow"      value="true"/>
    <jsp:param name="searchText"   value="질문/답변"/>
    <jsp:param name="selectEnum"   value="useYn:공개상태"/>
</jsp:include>

<%--구분--%>
<jsp:include page="/include/type.jsp">
    <jsp:param name="displayType" value="value"/>
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
                <th style="width:150px;">구분</th>
                <th style="width:600px;">질문</th>
                <th style="width:150px;">제공언어</th>
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
                    <td><c:out value="${vo.type.value}"/></td>
                    <td><c:out value="${vo.inqKo}" escapeXml="false"/></td>
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
    $("tbody select.show",   ".listBox-grid").changeStatus("changeStatus", "useYn").then(onSuccess, onFailMsg);
    $("tfoot .leftBtn", ".listBox-grid").deleteArticle("delete", getCheckedVal).then(() => {location.reload()});
    $(".view", ".listBox-grid").viewDetail("detail", document.searchForm, "typeInput");
    $("tbody .delete", ".listBox-grid").deleteArticle("delete").then(onFail);
</script>

</html>
