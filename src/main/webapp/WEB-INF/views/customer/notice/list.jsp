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

<div id="pageTitle">공지사항 / 관리자 웹 공지사항</div>

<ul class="pageGuide">
	<li>공지사항을 관리할 수 있습니다.</li>
	<li>홈페이지에 노출되는 공지사항 뿐만 아니라 관리웹의 공지사항도 관리 가능합니다.</li>
</ul>

<%-- 검색 --%>
<jsp:include page="/include/search/form.jsp" flush="false">
	<jsp:param name="addFive"      value="true"/>
	<jsp:param name="pageRow"      value="true"/>
	<jsp:param name="searchText"   value="제목/내용"/>
	<jsp:param name="selectEnum"   value="useYn:공개상태"/>
</jsp:include>

<div class="listBox-grid">
    <form method="post" action="saveOrder">
        <%-- 관리자웹 공지사항 --%>
        <table id="admin">
            <thead>
            <tr>
                <td colspan="50">
                    <div class="tableTitle">관리자웹 공지사항</div>
                    <div class="listTotal">전체 <span class="bold gray"><c:out value="${searchAdm.totalCount}"/></span> 건</div>
                </td>
            </tr>
            <tr>
                <th style="width:10px;"><input type="checkbox" class="checkAll"/></th>
                <th style="width:30px;">번호</th>
                <th style="width:150px;">구분</th>
                <th style="width:600px;">제목</th>
                <th style="width:150px;">제공언어</th>
                <th style="width:100px;">공개상태</th>
                <th style="width:100px;">등록일</th>
                <th style="width:100px;">등록자</th>
                <th style="width:80px;">수정</th>
            </tr>
            <c:if test='${empty adminList}'>
                <tr>
                    <td colspan="50">No Data.</td>
                </tr>
            </c:if>
            </thead>
            <tbody>
            <c:forEach items="${adminList}" var="vo" varStatus="status">
                <tr id="<c:out value="${vo.seq}"/>">
                    <input type="hidden" name="seqs" value="<c:out value="${vo.seq}"/>"/>
                    <input type="hidden" name="useYns" value="<c:out value="${vo.useYn}"/>"/>
                    <td><input type="checkbox" value="<c:out value="${vo.seq}"/>"></td>
                    <td><c:out value="${(searchAdm.pageNum - 1) * searchAdm.pageRow + status.index + 1}"/></td>
                    <td><c:out value="${vo.type.value}"/></td>
                    <td><c:out value="${vo.titleKoEllipsis}" escapeXml="false"/></td>
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
                        <span class="click view whiteBtn" data-page-num="<c:out value="${searchAdm.pageNum}"/>" data-seq="<c:out value="${vo.seq}"/>">수정</span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <%--######################## 관리자웹 페이징 ########################--%>
        <div id="pagingAdm">
            <jsp:include page="/WEB-INF/views/customer/notice/pagingAdm.jsp">
                <jsp:param name="formName" value="searchFormAdm"/>
            </jsp:include>
        </div>
        <!-- 홈페이지 공지사항 -->
        <br>
        <br>
        <br>
        <table id="hpg">
            <thead>
            <tr>
                <td colspan="50">
                    <div class="tableTitle">홈페이지 공지사항</div>
                    <div class="listTotal">전체 <span class="bold gray"><c:out value="${searchHpg.totalCount}"/></span> 건</div>
                </td>
            </tr>
            <tr>
                <th style="width:10px;"><input type="checkbox" class="checkAll"/></th>
                <th style="width:30px;">번호</th>
                <th style="width:150px;">구분</th>
                <th style="width: 600px;">제목</th>
                <th style="width:150px;">제공언어</th>
                <th style="width:100px;">공개상태</th>
                <th style="width:100px;">등록일</th>
                <th style="width:100px;">등록자</th>
                <th style="width:80px;">수정</th>
            </tr>
            <c:if test='${empty hpgList}'>
                <tr>
                    <td colspan="50">No Data.</td>
                </tr>
            </c:if>
            </thead>
            <tbody>
            <c:forEach items="${hpgList}" var="vo" varStatus="status">
                <tr id="<c:out value="${vo.seq}"/>">
                    <input type="hidden" name="seqs" value="<c:out value="${vo.seq}"/>"/>
                    <input type="hidden" name="useYns" value="<c:out value="${vo.useYn}"/>"/>
                    <td><input type="checkbox" value="<c:out value="${vo.seq}"/>"></td>
                    <td><c:out value="${(searchHpg.pageNum - 1) * searchHpg.pageRow + status.index + 1}"/></td>
                    <td><c:out value="${vo.type.value}"/></td>
                    <td><c:out value="${vo.titleKoEllipsis}" escapeXml="false"/></td>
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
                        <span class="click view whiteBtn" data-page-num="<c:out value="${searchHpg.pageNum}"/>" data-seq="<c:out value="${vo.seq}"/>">수정</span>
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
    <%--######################## 홈페이지 페이징 ########################--%>
    <div id="pagingHpg">
        <jsp:include page="/WEB-INF/views/customer/notice/pagingHpg.jsp">
            <jsp:param name="formName" value="searchFormHpg"/>
        </jsp:include>
    </div>
</div>

<script src="<c:out value="${cPath}"/>/assets/js/list.js" charset="utf-8" type="text/javascript"></script>
<script>
    const getCheckedVal	= () => {
        const seqs   = $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",");
        const useYns = $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => {
            return $(e).closest("tr").find("input[name='useYns']").val();
        }).join(",");

        return { "seq": seqs, "useYns": useYns};
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
	$(".view", ".listBox-grid").viewDetail("detail", document.searchForm);
	$("tbody .delete", ".listBox-grid").deleteArticle("delete").then(onFail);
</script>

</html>
