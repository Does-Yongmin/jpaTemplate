<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<%@ include file="/include/head.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
		<style>
			/* 로그테이블 스타일 */
			#logTable { margin-top:60px; }
			#logTable th { background-color:#fbfbfb; }
			#logTable td { text-align:center; }
			#logTable td:nth-child(3) { text-align:left; }

			/* 정보 수정 시, 정렬을 위한 태그 스타일 */
			comp { display:block; }
			comp bef { display:inline-block; min-width:150px; }
			comp aft:before { content:' →  '; font-size:15px; font-weight:bold; }
		</style>
	</head>
	<body>
		<div id="pageTitle"><c:out value="${pageTitle}"/></div>	<%-- pageTitle은 Aspect 로 삽입 --%>
		<ul class="pageGuide">
			<li>활동로그는 작업한 시간을 기준으로 내림차순으로 정렬되어있습니다.</li>
			<li>계정 삭제 로그는 계정삭제(시작) > 권한취소 > 계정삭제(완료) 순으로 이뤄집니다.</li>
			<li>권한 승인 로그는 권한승인(검토의견) > 권한 부여/취소 > 권한승인(완료) 순으로 이뤄집니다.</li>
		</ul>
		<div class="detailBox">
			<input type="hidden" name="pageNum" value="<c:out value="${search.pageNum}"/>"/>
			<table>																			<%-- 상세내용 - 작업자 간편정보 --%>
				<tbody>
					<tr>
						<th width="100">작업자</th><td colspan="3"><c:out value="${data.creatorNameId}"/></td>
					</tr>
				</tbody>
			</table>
			<table id="logTable">
				<thead>
					<tr>
						<td colspan="50"><div class="tableTitle">작업상세</div></td>
					</tr>
					<tr>
						<th style="width:80px;">
							<jsp:include page="/include/search/logType.jsp"		flush="false"/>
						</th>
						<th style="width:160px;">작업대상</th>
						<th width="*">작업(메시지) 내용</th>
						<th style="width:180px;">작업일시</th>
						<th style="width:120px;">작업자 IP</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${data.children}" var="vo">
						<tr>
							<td class="workType <c:out value="${vo.logType}"/>"><c:out value="${vo.logType.name}"/></td>
							<td><c:out value="${vo.targetId}"/></td>
							<td><pre><c:out value="${vo.detail}"/></pre></td>
							<td><c:out value="${vo.createDatePretty}"/></td>
							<td><c:out value="${vo.creatorIp}"/></td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="50">
							<a type="button" href="javascript:goBackToList(undefined, 'gid','uid')" class="mot3 rightBtn grayBtn-round">목록</a>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		<%--######################## 스크립트 ########################--%>
		<script	src="<c:out value="${cPath}"/>/assets/js/detail.js"	charset="utf-8"		type="text/javascript"></script>
		<script>
			const $td	= $("#logTable tbody tr td.workType");
			function _change() {						<%-- sorting 시 해당 항목을 빨간색으로 표시 --%>
				var val		= this.value,
					initCss	= {"color":"inherit", "font-weight":"inherit"},
					markCss	= {"color":"red"	, "font-weight":"bold"};

				if( val == "" )							<%-- marking 하려는 항목이 없는 경우 --%>
					$td.css(initCss);					<%-- marking 해제 --%>
				else {									<%-- 선택된 항목이 있으면 --%>
					$td.filter("."+ val).css(markCss);	<%-- 해당되는 항목들을 bold red 로 marking 하고 --%>
					$td.not("."+val).css(initCss);		<%-- 그 외 항목들은 marking 해제 --%>
				}
			}
			$("select[name=logType]").change(_change);
		</script>
	</body>
</html>