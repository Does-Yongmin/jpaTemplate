<%@ page import="com.does.util.StrUtil" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"	uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	/**
	 * 한 페이지에 검색이 여러개일 경우, 각각 페이징하기 위해
	 * 파라미터로 searchVO 이름을 전달 받아 searchVO 를 치환한다.
	 *
	 * 별도로 파라미터 미전달시 기존과 동일하게 동작
	 *
	 * param name 	: searchVOName
	 * param value 	: {model 에 주입한 searchVO attribute 명} (ex:noticeSearch)
	 */
	String searchVOName = request.getParameter("searchVOName");
	if(!StrUtil.isEmpty(searchVOName)){
		Object searchVO = request.getAttribute(searchVOName);	// searchVOName 으로 model 에 주입한 searchVO 가져오기
		if(searchVO != null){
			request.setAttribute("search", searchVO);			// 해당 searchVO 로 search 를 치환
		}
	}
%>

<c:if test="${search.totalPage >= 1}">
	<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/paging.css" />			<%-- 페이지 특화 스타일 --%>
	<div id="paging" align="center">
		<table>
			<tr>
				<%-- prev arrow --%>
				<c:if test="${search.pageStartNum > 1}">
					<td class="firstLast first page" data-page-num="1" title="First page"></td>
				</c:if>

				<td class="prevNext prev page" data-page-num="${fn:escapeXml(search.prevPageGroup)}" title="Previous page group"></td>

				<%-- page number --%>
				<c:forEach var="i" begin="${search.pageStartNum}" end="${search.pageEndNum}" step="1">
					<td class="page${search.pageNum eq i ? ' now' : ''}" data-page-num="${fn:escapeXml(i)}"><c:out value="${i}"/></td>
				</c:forEach>

				<%-- next arrow --%>
				<td class="prevNext next page" data-page-num="${fn:escapeXml(search.nextPageGroup)}" title="Next page group"></td>

				<c:if test="${search.pageEndNum < search.totalPage}">
					<td class="firstLast last page" data-page-num="${fn:escapeXml(search.totalPage)}" title="Last page"></td>
				</c:if>
			</tr>
		</table>
	</div>
	<script>
		window.addEventListener("click", (e) => {
			const $target	= $(e.target);
			const isPaging	= $target.hasClass("page") && $target.parents("#paging").length > 0
			if( isPaging ) {
				const form	= '<c:out value="${formName}" default="searchForm" escapeXml="true"/>';
				const $form	= $("form[name="+ form +"]");
				let json	= $.extend($form.toJSON(), $target.data());

				const typeInputEl = document.getElementById('typeInput');
				if (typeInputEl) {
					const typeInput = typeInputEl.value;
					if (typeInput) {
						json = $.extend(json, { type: typeInput });
					}
				}

				const query	= Object.entries(json).filter(e => e[1]).map(e => e.map(s => encodeURIComponent(s)).join("=")).join("&");
				location.href = location.href.replace(/(\?.*|#.*)/gi, "") + "?" + query;
			}
		});
	</script>
</c:if>