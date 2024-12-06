<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/search/enums.jsp" %>
<%@ page import="com.does.biz.primary.domain.facility.BuildingType" %>
<%@ page import="com.does.biz.primary.domain.facility.BusinessHoursType" %>
<%
	request.setAttribute("buildingType", BuildingType.getValuesExcludingEtc());
	request.setAttribute("buildingTypeLWT", BuildingType.LWT);
	request.setAttribute("buildingTypeLWM", BuildingType.LWM);
	request.setAttribute("buildingTypeAVE", BuildingType.AVE);

	request.setAttribute("businessHoursTypeCommon", BusinessHoursType.COMMON);
	request.setAttribute("businessHoursTypeWeekend", BusinessHoursType.WEEKEND);
	request.setAttribute("businessHoursTypeExtra", BusinessHoursType.EXTRA);

	out.clearBuffer();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<%@ include file="/include/head.jsp" %>
	<link rel="stylesheet" type="text/css" href="${fn:escapeXml(cPath)}/assets/css/contentPage.css"/>
</head>

<body>

<div id="pageTitle">영업시간 / 휴점일 관리</div>

<ul class="pageGuide">
	<li>영업시간과 휴점일은 국/영/중/일 4개 사이트에 동시 적용됩니다.</li>
	<li>휴점일은 기준월 변경 3일 전까지 등록 필요합니다. 기존 휴점일 데이터는 쌓이지 않습니다.</li>
</ul>

<%-- 검색 --%>
<jsp:include page="/include/search/form.jsp" flush="false">
	<jsp:param name="pageRow" value="true"/>
	<jsp:param name="searchText" value="운영사명"/>
	<jsp:param name="selectEnum" value="buildingType:건물 위치"/>
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
			<th style="width:150px;">위치</th>
			<th style="width:150px;">운영사명</th>
			<th style="width:50px;">층</th>
			<th style="width:150px;">영업시간</th>
			<th style="width:80px;">대표전화</th>
			<th style="width:80px;">등록일</th>
			<th style="width:50px;">등록자</th>
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
				<input type="hidden" name="buildingType" value="${fn:escapeXml(vo.buildingType)}"/>

				<td><input type="checkbox" value="${fn:escapeXml(vo.seq)}"></td>
				<td><c:out value="${(search.pageNum - 1) * search.pageRow + status.index + 1}"/></td>
				<td><c:out value="${vo.buildingTypeString}"/></td>
				<td><c:out value="${vo.affiliateKoString}"/></td>
				<td><c:out value="${vo.affiliateFloor}"/></td>
				<td>
					<c:if test="${vo.businessHoursType eq businessHoursTypeCommon}">
						<c:out value="${vo.businessHoursCommon}"/>
					</c:if>
					<c:if test="${vo.businessHoursType eq businessHoursTypeWeekend}">
						평일 <c:out value="${vo.businessHoursWeekday}"/>
						<br>
						주말 <c:out value="${vo.businessHoursWeekend}"/>
					</c:if>
					<c:if test="${vo.businessHoursType eq businessHoursTypeExtra}">
						<c:set var="fieldCount" value="0" scope="page"/>

						<c:if test="${not empty vo.businessHoursTextKo}">
							<c:set var="fieldCount" value="${fn:escapeXml(fieldCount + 1)}" scope="page"/>
						</c:if>
						<c:if test="${not empty vo.businessHoursTextEn}">
							<c:set var="fieldCount" value="${fn:escapeXml(fieldCount + 1)}" scope="page"/>
						</c:if>
						<c:if test="${not empty vo.businessHoursTextJp}">
							<c:set var="fieldCount" value="${fn:escapeXml(fieldCount + 1)}" scope="page"/>
						</c:if>
						<c:if test="${not empty vo.businessHoursTextCn}">
							<c:set var="fieldCount" value="${fn:escapeXml(fieldCount + 1)}" scope="page"/>
						</c:if>

						<c:choose>
							<c:when test="${fieldCount > 1}">
								<!-- 항목이 2개 이상일 때, <br> 태그 추가 -->
								<c:if test="${not empty vo.businessHoursTextKo}">
									KO : <c:out value="${vo.businessHoursTextKo}"/><br/>
								</c:if>
								<c:if test="${not empty vo.businessHoursTextEn}">
									EN : <c:out value="${vo.businessHoursTextEn}"/><br/>
								</c:if>
								<c:if test="${not empty vo.businessHoursTextJp}">
									JP : <c:out value="${vo.businessHoursTextJp}"/><br/>
								</c:if>
								<c:if test="${not empty vo.businessHoursTextCn}">
									CN : <c:out value="${vo.businessHoursTextCn}"/><br/>
								</c:if>
							</c:when>
							<c:otherwise>
								<!-- 항목이 1개일 때, <br> 태그 없이 출력 -->
								<c:if test="${not empty vo.businessHoursTextKo}">
									KO : <c:out value="${vo.businessHoursTextKo}"/>
								</c:if>
								<c:if test="${not empty vo.businessHoursTextEn}">
									EN : <c:out value="${vo.businessHoursTextEn}"/>
								</c:if>
								<c:if test="${not empty vo.businessHoursTextJp}">
									JP : <c:out value="${vo.businessHoursTextJp}"/>
								</c:if>
								<c:if test="${not empty vo.businessHoursTextCn}">
									CN : <c:out value="${vo.businessHoursTextCn}"/>
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:if>
				</td>
				<td>
					<c:forEach items="${vo.phoneNumberArrays}" var="phoneNumber" varStatus="status">
						<c:if test="${not empty phoneNumber and phoneNumber != '--' }">
							<c:if test="${phoneNumber.startsWith(' ')}">
								${fn:escapeXml(fn:trim(phoneNumber).split('-')[1])}-${fn:escapeXml(fn:trim(phoneNumber).split('-')[2])}
							</c:if>
							<c:if test="${!phoneNumber.startsWith(' ')}">
								<c:out value="${phoneNumber}"/>
							</c:if>
							<br>
						</c:if>
					</c:forEach>
				</td>
				<td><c:out value="${vo.createDatePretty}"/></td>
				<td><c:out value="${vo.creatorMasked}"/></td>
				<td>
					<span class="click view whiteBtn" data-page-num="${fn:escapeXml(search.pageNum)}" data-seq="${fn:escapeXml(vo.seq)}">수정</span>
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

<script src="${fn:escapeXml(cPath)}/assets/js/list.js" charset="utf-8" type="text/javascript"></script>
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
	const getCheckedVal	= () => {
		return { "seq" : $(".listBox-grid tbody input[type=checkbox]:checked").toArray().map(e => e.value).join(",")}
	};

	$("tfoot .leftBtn", ".listBox-grid").deleteArticle("delete", getCheckedVal).then(() => {location.reload()});
	$(".view", ".listBox-grid").viewDetail("detail", document.searchForm);
	$("tbody .delete", ".listBox-grid").deleteArticle("delete").then(onFail);
</script>

</html>
