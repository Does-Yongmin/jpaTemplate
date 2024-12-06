<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page import="com.does.biz.primary.domain.facility.BuildingType" %>
<%@ page import="com.does.biz.primary.domain.affiliate.AffiliateFloorType" %>
<%@ include file="/include/search/enums.jsp" %>
<%
	request.setAttribute("buildingType", BuildingType.values());
	List<String> floorNames = Arrays.stream(AffiliateFloorType.values())
			.map(AffiliateFloorType::getDisplayName)
			.collect(Collectors.toList());
	request.setAttribute("affiliateFloors", floorNames);

	out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/contentPage.css"/>
</head>

<body>
<c:set var="gson" value="<%= new Gson() %>" />

<div id="pageTitle">매장 및 시설 관리</div>

<ul class="pageGuide">
	<li>매장 및 시설을 등록 및 관리할 수 있습니다.</li>
	<li>매장의 <span class="red"><b>카테고리는 매장 및 시설 코드 관리 메뉴</b></span>에서 관리할 수 있습니다.</li>
</ul>

<%-- '승인 매장' / '승인 대기' 버튼 --%>
<div style="display: flex;">
	<form method="get" name="workFormForApproveY" action="list">
		<div>
			<input type="hidden" name="approveYn" value="Y"/>
			<button type="button" id="approveBtnY" class="mot3 ${not empty approve and approve == 'Y' ? 'blackBtn-round' : 'whiteBtn-round'}"
					onclick="document.workFormForApproveY.submit();">
				승인 매장
			</button>
		</div>
	</form>

	<form method="get" name="workFormForApproveN" action="list">
		<div>
			<input type="hidden" name="approveYn" value="N"/>
			<button type="button" id="approveBtnN" class="mot3 ${not empty approve and approve == 'N' ? 'blackBtn-round' : 'whiteBtn-round'}"
					onclick="document.workFormForApproveN.submit();">
				승인 대기
			</button>
		</div>
	</form>
</div>
<%-- // --%>

<%-- 검색 --%>
<jsp:include page="/include/search/formForFacility.jsp" flush="false">
	<jsp:param name="approve" 					value="${fn:escapeXml(approve)}"/>
	<jsp:param name="pageRow" 					value="true"/>
	<jsp:param name="selectEnumBuildingType" 	value="buildingType"/>
	<jsp:param name="selectListFloor" 			value="affiliateFloors"/>
	<jsp:param name="selectList" 				value="largeCodeTypeList"/>
	<jsp:param name="selectList" 				value="middleCodeTypeList"/>
	<jsp:param name="selectList" 				value="smallCodeTypeList"/>
	<jsp:param name="selectEnumUseYn" 			value="useYn"/>
	<jsp:param name="searchText" 				value="검색어를 입력해 주세요."/>
</jsp:include>

<div class="listBox-grid">
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
			<th style="width:80px;">건물위치</th>
			<th style="width:80px;">층</th>
			<th style="width:80px;">매장 및 시설명</th>
			<th style="width:80px;">제공언어</th>
			<th style="width:80px;">대분류</th>
			<th style="width:80px;">중분류</th>
			<th style="width:80px;">소분류</th>
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
			<tr id="${fn:escapeXml(vo.seq)}">
				<input type="hidden" name="seq" value="${fn:escapeXml(vo.seq)}"/>
				<td><input type="checkbox" value="${fn:escapeXml(vo.seq)}"></td>
				<td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
				<td><c:out value="${vo.buildingTypeString}"/></td>
				<td>
					<c:forEach var="floor" items="${vo.affiliateFloorArrays}" varStatus="status">
						<c:out value="${floor}"/><c:if test="${!status.last}">, </c:if>
					</c:forEach>
				</td>
				<td><c:out value="${vo.facilityLangInfoKo.name}"/></td>
				<td>
					<c:choose>
						<c:when test="${not empty vo.facilityLangInfoKo.name}">
							국문
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${not empty vo.facilityLangInfoEn.name}">
							<c:if test="${not empty vo.facilityLangInfoKo.name}"> | </c:if>
							영문
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${not empty vo.facilityLangInfoJp.name}">
							<c:if test="${not empty vo.facilityLangInfoKo.name
										or not empty vo.facilityLangInfoEn.name}"> | </c:if>
							일문
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${not empty vo.facilityLangInfoCn.name}">
							<c:if test="${not empty vo.facilityLangInfoKo.name
										or not empty vo.facilityLangInfoEn.name
										or not empty vo.facilityLangInfoJp.name}"> | </c:if>
							중문
						</c:when>
					</c:choose>
				</td>
				<td>
					<c:if test="${not empty largeCodeTypeList and not empty vo.codeTypeArraysInnerCategoryArrays[0][0]}">
						<c:forEach items="${largeCodeTypeList}" var="large">
							<c:if test="${large.codeType.startsWith(vo.codeTypeArraysInnerCategoryArrays[0][0])}">
								${fn:escapeXml(large.codeTypeNameKo)}
							</c:if>
						</c:forEach>
					</c:if>
				</td>
				<td>
					<c:if test="${not empty middleCodeTypeList and not empty vo.codeTypeArraysInnerCategoryArrays[0][1]}">
						<c:forEach items="${middleCodeTypeList}" var="middle">
							<c:if test="${middle.codeType.startsWith(vo.codeTypeArraysInnerCategoryArrays[0][0])
											and middle.codeType.substring(4).startsWith(vo.codeTypeArraysInnerCategoryArrays[0][1])}">
								${fn:escapeXml(middle.codeTypeNameKo)}
							</c:if>
						</c:forEach>
					</c:if>
				</td>
				<td>
					<c:if test="${not empty smallCodeTypeList and not empty vo.codeTypeArraysInnerCategoryArrays[0][2]}">
						<c:forEach items="${smallCodeTypeList}" var="small">
							<c:if test="${small.codeType.startsWith(vo.codeTypeArraysInnerCategoryArrays[0][0])
											and small.codeType.substring(4).startsWith(vo.codeTypeArraysInnerCategoryArrays[0][1])
											and small.codeType.substring(8).startsWith(vo.codeTypeArraysInnerCategoryArrays[0][2])}">
								${fn:escapeXml(small.codeTypeNameKo)}
							</c:if>
						</c:forEach>
					</c:if>
				</td>
				<td>
					<span class="click view whiteBtn" data-page-num="${fn:escapeXml(search.pageNum)}" data-seq="${fn:escapeXml(vo.seq)}">수정</span>
				</td>
			</tr>
		</c:forEach>
		</tbody>

		<tfoot>
		<tr>
			<td colspan="50">
				<a type="button" class="mot3 leftBtn lightBtn-round delBtn">삭제</a>
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

<script src="${fn:escapeXml(cPath)}/assets/js/list.js" charset="utf-8" type="text/javascript"></script>

<script>
	let largeCodeTypeList = ${largeCodeTypeList == null ? [] : gson.toJson(largeCodeTypeList)};
	let middleCodeTypeList = ${middleCodeTypeList == null ? [] : gson.toJson(middleCodeTypeList)};
	let smallCodeTypeList = ${smallCodeTypeList == null ? [] : gson.toJson(smallCodeTypeList)};
</script>

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

	$("tfoot .leftBtn", ".listBox-grid").deleteArticle("delete", getCheckedVal).then(() => {location.reload()});
	$(".view", ".listBox-grid").viewDetail("detail", document.searchForm);
	$("tbody .delete", ".listBox-grid").deleteArticle("delete").then(onFail);
</script>

</html>
