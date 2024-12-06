<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/taglib.jsp" %>
<%---
	searchUnit Syntex
	<tr>
		<th>검색 유닛의 이름</th>
		<td>검색에 사용할 html 요소</td>
	</tr>

	${search}		: 검색값을 담고 있는 java 객체
	${pageRow}		: 행 개수 검색 여부. 10, 20, 50, 100
	${searchShow}	: 게시 상태 검색( 전체,Y,N )
	${searchPeriod}	: 기간 검색. YYYY.MM.DD ~ YYYY.MM.DD
	${searchText}	: 텍스트 검색을 할 경우, 검색대상.
--%>
<form name="searchForm" novalidate autocomplete="off">
	<c:if test="${not empty param.hiddenInput}">
		<jsp:include page="hidden.jsp" flush="false"/>
	</c:if>
    <table class="searchBox">
        <tbody>
			<input type="hidden" name="searchYn" value="Y"/>
			<c:if test="${not empty param.pageRow}">
				<tr>
					<th>페이지당 행 개수</th>
					<td><jsp:include page="pageRow.jsp"	flush="false"/></td>
				</tr>
			</c:if>
			<c:if test="${not empty param.selectEnum or not empty param.logType or not empty param.selectArray or not empty param.selectMap}">
				<tr>
					<th>구분</th>
					<td colspan="10">
						<c:if test="${not empty param.selectEnum}">		<jsp:include page="selectEnum.jsp"	flush="false"/></c:if>
						<c:if test="${not empty param.selectArray}">	<jsp:include page="selectArray.jsp"	flush="false"/></c:if>
						<c:if test="${not empty param.selectMap}">		<jsp:include page="selectMap.jsp"	flush="false"/></c:if>
						<c:if test="${not empty param.logType}">		<jsp:include page="logType.jsp"		flush="false"/></c:if>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty param.searchShow}">
				<tr>
					<th>게시상태</th>
					<td colspan="10"><jsp:include page="showHide.jsp" flush="false"/></td>
				</tr>
			</c:if>
			<c:if test="${not empty param.searchPeriod}">
				<tr>
					<th>기간</th>
					<td colspan="10"><jsp:include page="period.jsp"	flush="false"/></td>
				</tr>
			</c:if>
			<c:if test="${not empty param.searchText}">
				<tr>
					<th>검색어</th>
					<td><jsp:include page="searchText.jsp"	flush="false"/></td>
				</tr>
			</c:if>
        </tbody>

        <tfoot>
        <tr>
            <td colspan="2">
                <input type="submit" value="검색" class="mot3 blueBtn-round"/>
                <input type="reset"	value="초기화" class="mot3 grayBtn-round"/>
            </td>
        </tr>
        </tfoot>
    </table>

    <script>	<%-- 초기화 버튼 클릭 --%>
    document.searchForm.addEventListener("reset", function(ev) {
        ev.preventDefault();
        const table = this.querySelector("table.searchBox");
        table.querySelectorAll("select option").forEach((e,i) => e.selected=false);
        table.querySelectorAll("input[type=radio]").forEach((e,i) => e.checked=false);
        table.querySelectorAll("input[type=checkbox]").forEach((e,i) => e.checked=false);
        table.querySelectorAll("input[type=text]").forEach((e,i) => e.value="");
		$("input, select", this).each( (i,e) => e.name = !e.value ? "" : e.name );
        document.searchForm.submit();
    });
    </script>	<%-- 초기화 버튼 클릭 --%>

    <script>	<%-- 검색 버튼 클릭 시 값이 없는 항목들은 submit 되지 않도록. --%>
    document.searchForm.addEventListener("submit", function(ev) {
        showLoading();

		const typeInputEl = document.getElementById('typeInput');
		if (typeInputEl && typeInputEl.value !== '') {
			const hiddenTypeInput = document.createElement('input');
			hiddenTypeInput.type = 'hidden';
			hiddenTypeInput.name = 'type';
			hiddenTypeInput.value = typeInputEl.value;
			this.appendChild(hiddenTypeInput);
		}

        $("input, select", this).each( (i,e) => e.name = !e.value ? "" : e.name );
    });
    </script>	<%-- 검색 버튼 클릭 시 값이 없는 항목들은 submit 되지 않도록. --%>
</form>