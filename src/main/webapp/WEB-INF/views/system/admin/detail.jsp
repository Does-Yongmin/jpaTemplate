<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.does.biz.primary.domain.admin.AdminStatus" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<%@ include file="/include/head.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
	</head>
	<body>
		<c:set var="isNew" value="${empty data.seq}" scope="page"/>
		<div id="pageTitle"><c:out value="${pageTitle}"/></div>	<%-- pageTitle은 Aspect 로 삽입 --%>
		<ul class="pageGuide">
			<li>관리자 계정을 관리할 수 있습니다.</li>
			<li>관리자 회원 승인 시, 그룹 권한을 부여해야 합니다.</li>
		</ul>
		<div class="detailBox">
			<c:if test="${!data.deactivated}">
				<div style="text-align: right;">
					<a type="button" href="javascript:void(0);" onclick="resetPw();" class="mot3 whiteBtn-round">비밀번호 초기화</a>
				</div>
			</c:if>
			<form method="post" name="workForm" action="${data.ready ? 'approve' : 'save'}">
				<input type="hidden" name="seq" value="<c:out value="${data.seq}"/>"/>
				<input type="hidden" name="pageNum" value="<c:out value="${search.pageNum}"/>"/>

				<%-- 상세 페이지에서 상태 수정 로깅 남길때 사용할 adminId, adminName --%>
				<input type="hidden" name="adminId" value="<c:out value="${data.adminId}"/>">
				<input type="hidden" name="adminName" value="<c:out value="${data.adminName}"/>">
				<table>
					<tbody>
						<tr>
							<th>이메일</th>
							<td><c:out value="${data.decEmail}"/></td>
						</tr>
						<tr>
							<th>이름</th>
							<td><c:out value="${data.decName}"/></td>
						</tr>
						<tr>
							<th>회사명</th>
							<td><c:out value="${data.affiliateType.nameKo}"/></td>
						</tr>
						<tr>
							<th>휴대전화</th>
							<td><c:out value="${data.decPhone}"/></td>
						</tr>
						<tr>
							<th>최종 접속일</th>
							<td><c:out value="${data.lastLoginPretty}"/></td>
						</tr>
						<tr>
							<th>최종 비밀번호 변경일</th>
							<td><c:out value="${data.lastPwChangePretty}"/></td>
						</tr>
						<tr>
							<th>권한그룹</th>
							<td>
								<%-- 계정이 탈퇴, 개인정보 삭제가 아닐 경우만 권한그룹 영역 노출 --%>
								<c:if test="${!data.deactivated}">
									<select name="permissionGroupSeq">
										<option value="">선택</option>
										<c:forEach var="permissionGroup" items="${allPermissionGroupList}">
											<option value="<c:out value="${permissionGroup.seq}"/>" ${permissionGroup.seq eq userPermissionGroup.seq ? 'selected' : ''}><c:out value="${permissionGroup.groupName}"/></option>
										</c:forEach>
									</select>
								</c:if>
							</td>
						</tr>
						<tr>
							<th>회원 계정 상태</th>
							<td><c:out value="${data.adminStatus.name}"/></td>
						</tr>
						<%-- 회원 승인 상태 영역은 미승인 상태인 계정에만 노출 --%>
						<c:if test="${data.ready}">
							<tr>
								<th>회원 승인 상태</th>
								<td>
									<label>
										<input type="radio" name="adminStatus" value="Y">
										승인
									</label>
									<label>
										<input type="radio" name="adminStatus" value="R" checked="checked">
										미승인
									</label>
								</td>
							</tr>
						</c:if>
						<%-- 계정 잠금 영역은 승인 or 잠금 상태인 계정에만 노출 --%>
						<c:if test="${data.use or data.locked}">
							<th>계정 잠금</th>
							<td>
								<select name="adminStatus" class="use ${data.use ? 'Y' : 'N'}">
									<option value="Y" class="Y"${ data.use ? 'selected' : ''}>해제</option>
									<option value="N" class="N"${!data.use ? 'selected' : ''}>잠금</option>
								</select>
							</td>
						</c:if>
						<%@ include file="/include/worker.jsp" %>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="50">
								<%-- 계정이 탈퇴, 개인정보 삭제가 아닐 경우만 탈퇴 버튼 노출 --%>
								<c:if test="${!data.deactivated}">
									<a type="button" class="mot3 leftBtn lightBtn-round">탈퇴</a>
									<a type="button" href="javascript:submitFormIntoHiddenFrame(document.workForm)" class="mot3 rightBtn blueBtn-round"><c:out value="${data.ready ? '승인' : '저장'}"/></a>
								</c:if>
								<a type="button" href="javascript:goBackToList(undefined, 'seq')" class="mot3 rightBtn grayBtn-round">목록</a>
							</td>
						</tr>
					</tfoot>
				</table>
			</form>
		</div>

		<%--######################## 관리자 활동로그 ########################--%>
		<%-- iframe 호출시 파라미터 searchText로 adminId 를 전달한다 --%>
		<iframe id="contentFrame" name="contentFrame" src="/system/log/list-in-admin?searchText=<c:out value="${data.adminId}"/>" width="100%" height="800" scrolling="no"></iframe>

		<%--######################## 스크립트 ########################--%>
		<script	src="<c:out value="${cPath}"/>/assets/js/detail.js"	charset="utf-8"		type="text/javascript"></script>
		<script src="<c:out value="${cPath}"/>/assets/js/util.js"	charset="utf-8"		type="text/javascript"></script>
		<script>
			// 권한 그룹이 없을 경우 승인 상태 체크 불가 처리
			const adminStatusYnRadio = document.querySelectorAll('input[name="adminStatus"]');
			if(adminStatusYnRadio){ // 미승인 상태인 계정에만 해당 라디오 영역이 노출 되기 때문에 영역이 존재하는지 체크
				adminStatusYnRadio.forEach(radio => {
					radio.addEventListener('change', () => {
						// 선택한 권한 그룹 가져옴
						const permissionGroupSeq = document.querySelector('select[name="permissionGroupSeq"]').value;

						// 승인 상태 체크시 권한 그룹이 없을 경우 경고창 띄우고, 강제 N 값 체크
						if(radio.value === 'Y' && permissionGroupSeq == ''){
							alert('해당 계정에 권한이 부여되지 않았습니다.\r\n권한 부여 후 승인처리가 가능합니다.');
							document.querySelector('input[name="adminStatus"][value="R"]').checked = true;
						}
					});
				});
			}
		</script>
		<script> // 비밀번호 초기화
			function resetPw(){
				const seq = document.querySelector('input[name="seq"]').value;
				if(!seq)
					alert('비밀번호를 초기화할 대상이 없습니다.');

				if(confirm("비밀번호를 초기화 하시겠습니까?")){
					const formData = new FormData();
					formData.append('seq', seq);

					fetch("<c:out value="${cPath}"/>/system/admin/resetPw", {
						method: 'POST',
						body: formData
					})
					.then(response => response.json())
					.then(data => {
						alert(data.message);
					});
				}
			}
		</script>

		<script>	/* 항목 삭제 */
			const onFail = function () {
				location.reload();
			}

			$("tfoot .leftBtn").deleteArticle("withdraw", {"seq": '<c:out value="${data.seq}"/>'}).then(() => {
				location.href = "list"
			}, onFail);
		</script>
	</body>
</html>
