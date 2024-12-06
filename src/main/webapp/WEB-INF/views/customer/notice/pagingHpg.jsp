<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"	uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${searchHpg.totalPage > 1}">
	<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/paging.css" />			<%-- 페이지 특화 스타일 --%>
	<div id="paging" align="center">
		<table>
			<tr>
				<c:if test="${searchHpg.pageStartNum > 1}"><td class="firstLast first page" data-page-num="1" title="First page"></td></c:if>
				<td class="prevNext prev page" data-page-num="<c:out value="${searchHpg.prevPageGroup}"/>" title="Previous page group"></td>
				<c:forEach var="i" begin="${searchHpg.pageStartNum}" end="${searchHpg.pageEndNum}" step="1">
					<td class="page${searchHpg.pageNum eq i ? ' now' : ''}" data-page-num="<c:out value="${i}"/>"><c:out value="${i}"/></td>
				</c:forEach>
				<td class="prevNext next page" data-page-num="<c:out value="${searchHpg.nextPageGroup}"/>" title="Next page group"></td>
				<c:if test="${searchHpg.pageEndNum < searchHpg.totalPage}"><td class="firstLast last page" data-page-num="<c:out value="${searchHpg.totalPage}"/>" title="Last page"></td></c:if>
			</tr>
		</table>
	</div>
	<script>
		window.addEventListener("click", (e) => {
			const $target	= $(e.target);
			const isPaging	= $target.hasClass("page") && $target.parents("#pagingHpg").length > 0
			if( isPaging ) {
				const form	= '<c:out value="${formName}" default="searchFormHpg" escapeXml="true"/>';
				const $form	= $("form[name="+ form +"]");
				const pageRow = $('select[name="pageRow"]').val();	// 현재 pageRow 선택된 값 가져옴

				const json	= $.extend($form.toJSON(), $target.data(), { searchYn: 'Y', pageRow: pageRow });

				// 어떤 영역 페이징 하는지 확인 위해
				json.pagingType = 'hpg';

				const query	= Object.entries(json).filter(e => e[1]).map(e => e.map(s => encodeURIComponent(s)).join("=")).join("&");
				location.href = location.href.replace(/(\?.*|#.*)/gi, "") + "?" + query;
			}
		});
	</script>
</c:if>