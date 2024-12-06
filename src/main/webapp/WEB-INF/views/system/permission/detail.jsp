<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<%@ include file="/include/head.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
		<style>
			div.detailBox table { max-width:1180px; }

			#tableBox { padding:0; }
			#tableBox table { margin:0; }
			#tableBox table th { background-color:#fbfbfb; padding:0; text-align:center; min-width:unset; }
			#tableBox table thead tr:nth-child(2) th { min-width:50px; width:5%; max-width:50px; height:30px; }
			#tableBox table tbody tr.parent td { background-color:lightgray; }
			#tableBox table tbody tr.child td:first-child { padding-left:30px; }
			#tableBox table tbody td:nth-child(n+2) { text-align:center; padding:5px 0; }
			#tableBox table tbody td input[type=checkbox] { display:none; }
			#tableBox table tbody td input[type=checkbox] + label { display:inline-block; width:20px; height:20px; border:2px solid gray; border-radius:4px; margin:0; }
			#tableBox table tbody td input[type=checkbox]:checked + label { border:2px solid #65b865; }
			#tableBox table tbody td input[type=checkbox]:checked + label:after { content:'✔'; color:#65b865; font-size:20px; line-height:20px; width:20px; height:20px; text-align:center;  }

			/* 권한설정 테이블 경계선 스타일 조정 */
			#tableBox table tbody td:first-child { border-left:0; }
			#tableBox table tbody td:last-child { border-right:1px solid lightgray; }
			#tableBox table thead tr:first-child th { border-top:0; max-width:unset; }
			#tableBox table tbody tr:last-child td { border-bottom:0; }

			/* 소속 멤버 스타일 */
			#memberCell { padding:0; }
			#memberCell table { margin-top:5px; }
			#memberCell table td:first-child { border-left:0; }
			#memberCell table tr:last-child td { border-bottom:0; }
			#memberCell table thead th:nth-child(n+3) { min-width:unset; width:5%; padding:0; text-align:center; }
			#memberCell table tbody td:nth-child(n+3) { min-width:unset; width:5%; padding:0; text-align:center; }
		</style>
	</head>
	<body>
		<c:set var="isNew" value="${empty data.seq}" scope="page"/>
		<div id="pageTitle"><c:out value="${pageTitle}"/></div>	<%-- pageTitle은 Aspect 로 삽입 --%>
		<ul class="pageGuide">
			<li>
				권한은 뒤로 갈수록 커집니다.<br/>
				ex) <span class="red">목록 < 상세 < 추가 < 수정 < 삭제 < 승인</span>
			</li>
			<li>
				뒤에 있는 권한은 앞에 있는 권한을 포함합니다.<br/>
				ex) '생성' 권한이 있는 메뉴에 대해서는 '목록조회', '상세조회' 모두 가능
			</li>
			<li>
				<span class="red">'관리자 계정 관리' 의 모든 권한을 부여할 경우, 최고 관리자 권한으로 승격</span>되니 신중하게 부여해 주시기 바랍니다.
			</li>
		</ul>
		<div class="detailBox">
			<form method="post" name="workForm" action="save">
				<input type="hidden" name="seq" value="<c:out value="${data.seq}"/>"/>
				<input type="hidden" name="pageNum" value="<c:out value="${search.pageNum}"/>"/>
				<table>
					<tbody>
						<tr>
							<th required>그룹명</th>
							<td><input type="text"		name="groupName"		maxlength="50" autocomplete="off" required value="<c:out value="${data.groupName}"/>"></td>
						</tr>
						<tr>
							<th required>사용여부</th>
							<td>
								<label><input type="radio" name="useYn" value="Y" <c:if test="${empty data.useYn or data.useYn eq 'Y'}">checked</c:if>> 사용</label>
								<label><input type="radio" name="useYn" value="N" <c:if test="${data.useYn eq 'N'}">checked</c:if>> 미사용</label>
							</td>
						</tr>
						<tr>
							<th required>권한 설정</th>
							<td id="tableBox">
								<table>
									<thead>
										<tr>
											<th rowspan="2">메뉴</th>
											<th colspan="6">권한</th>
										</tr>
										<tr>
											<c:forEach items="${grantLevels}" var="level">
												<th><c:out value="${level.name}"/></th>
											</c:forEach>
										</tr>
									</thead>
									<tbody>
										<tr class="parent">
											<td colspan="7">전체</td>
										</tr>
										<tr class="child">
											<td>전체</td>
											<td>
												<input id="chkbox011" type="checkbox" value="LIST">
												<label for="chkbox011"></label>
											</td>
											<td>
												<input id="chkbox012" type="checkbox" value="VIEW">
												<label for="chkbox012"></label>
											</td>
											<td>
												<input id="chkbox013" type="checkbox" value="WRITE">
												<label for="chkbox013"></label>
											</td>
											<td>
												<input id="chkbox014" type="checkbox" value="UPDATE">
												<label for="chkbox014"></label>
											</td>
											<td>
												<input id="chkbox015" type="checkbox" value="DELETE">
												<label for="chkbox015"></label>
											</td>
											<td>
												<input id="chkbox016" type="checkbox" value="APPROVE">
												<label for="chkbox016"></label>
											</td>
										</tr>
										<c:forEach items="${menus}" var="menu" varStatus="status">
											<tr class="parent">
												<td colspan="7"><c:out value="${menu.name}"/></td>
											</tr>
											<c:forEach items="${menu.child}" var="child" varStatus="childStatus">
												<tr class="child" ${child.id eq 'Z0101' ? 'style="background-color: #FFCCCB "' : ''}>
													<td>
														<input type="hidden" value="<c:out value="${child.id}"/>">
														<c:out value="${child.name}"/>
													</td>
													<c:forEach items="${grantLevels}" var="level" varStatus="levelStatus">
														<c:set var="tmpLabelId" value="chkBox${status.count}${childStatus.count}${levelStatus.count}"/>
														<td>
															<%-- 승인 항목은 특정 메뉴에 대해서만 노출 되도록 분기 처리 --%>
															<c:if test="${level eq 'APPROVE' && level.shouldDisplayApproveOption(child.id)}">
																<input id="<c:out value="${tmpLabelId}"/>" type="checkbox" value="<c:out value="${level}"/>" ${data.hasPermission(child.id, level) ? 'checked' : ''}>
																<label for="<c:out value="${tmpLabelId}"/>"></label>
															</c:if>
															<c:if test="${level ne 'APPROVE'}">
																<input id="<c:out value="${tmpLabelId}"/>" type="checkbox" value="<c:out value="${level}"/>" ${data.hasPermission(child.id, level) ? 'checked' : ''}>
																<label for="<c:out value="${tmpLabelId}"/>"></label>
															</c:if>
														</td>
													</c:forEach>
												</tr>
											</c:forEach>
										</c:forEach>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<th>소속 멤버</th>
							<td id="memberCell">
								<table>
									<thead>
										<tr>
											<th>아이디</th><th>이름</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${data.membersInfo}" var="member" varStatus="status">
											<tr>
												<td><c:out value="${member.adminId}"/></td>
												<td><c:out value="${member.decName}"/></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>

							</td>
						</tr>
						<%@ include file="/include/worker.jsp" %>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="50">
								<c:if test="${not isNew}"><a type="button"  class="mot3 leftBtn lightBtn-round">삭제</a></c:if>
								<a type="button" href="javascript:goSave()" class="mot3 rightBtn blueBtn-round">저장</a>
								<a type="button" href="javascript:goBackToList(undefined, 'seq')" class="mot3 rightBtn grayBtn-round">목록</a>
							</td>
						</tr>
					</tfoot>
				</table>
			</form>
		</div>
		<%--######################## 스크립트 ########################--%>
		<script	src="<c:out value="${cPath}"/>/assets/js/detail.js"			charset="utf-8"	type="text/javascript"></script>
		<script src="<c:out value="${cPath}"/>/assets/js/common/popup.js"	charset="utf-8"	type="text/javascript"></script>

		<script>
			$(document).ready(function() {
				checkGlobalPermissions();

				// 페이지 로딩 시 전체 권한 체크 여부 확인 및 설정
				function checkGlobalPermissions() {
					const permissionTypes = ['LIST', 'VIEW', 'WRITE', 'UPDATE', 'DELETE'];

					permissionTypes.forEach(function (permission) {
						const $globalCheckbox = $("input[type=checkbox][id^=chkbox0][value=" + permission + "]");
						let allChecked = true;

						$("tr.child").each(function () {
							const $row = $(this);
							const $checkbox = $row.find("input[type=checkbox][value=" + permission + "]");

							// 체크박스가 전체일 경우는 제외
							if ($checkbox.attr('id').startsWith('chkbox0')) {
								return;
							}

							if (!$checkbox.prop("checked")) {
								allChecked = false;
							}
						});

						$globalCheckbox.prop("checked", allChecked);
					});
				}
			});
		</script>
		<%-- 권한 선택 시 동작 --%>
		<script>
			function levelChange() {
				const $me		= $(this);							// 선택된 체크박스
				const $tr		= $me.parents("tr:eq(0)");			// 체크박스가 속한 tr 태그
				const tdIdx		= $me.parents("td:eq(0)").index();	// 체크박스가 속한 td 태그
				const checked	= $me.prop("checked");				// 체크 여부
				const value 	= $me.val();
				const target	= (i,e) => (checked && 0 <= i && i < tdIdx) || (!checked && i >= tdIdx);

				// 만약 "전체" 항목에 대한 체크박스라면 (전체는 id가 chkbox0XX)
				if ($me.attr('id').startsWith('chkbox0')) {
					$("input[type=checkbox][value=" + value + "]").prop("checked", checked);

					// "전체" 섹션에서 상위-하위 관계를 적용
					$("tr.child").each(function() {
						const $childTr = $(this);

						// 각 관리 항목의 체크박스를 순회하며 상위-하위 권한 처리
						$childTr.find("td input[type=checkbox]").each(function(index) {
							const $checkbox = $(this);
							const currentIdx = $checkbox.parents("td").index();

							// 현재 체크박스가 상위 권한(=현재 체크한 항목)보다 하위에 있는지 확인
							if (checked && currentIdx <= tdIdx) {
								$checkbox.prop("checked", true);
							} else if (!checked && currentIdx >= tdIdx) {
								$checkbox.prop("checked", false);
							}
						});
					});
				}
				else {
					$tr.find("td input[type=checkbox]")	// 같은 줄의 권한 체크박스들중에서
						.filter(target)					// 체크된 경우 하위권한들도 체크하고, 체크해제된 경우 상위권한들도 체크해제한다.
						.prop("checked", checked);
				}

				$("tr.child").each(function() {
					const $childTr = $(this);
					const $permChild = $childTr.find("input[type=checkbox]:checked:last");
					$childTr.find("td input[name^=permissions]").attr("name", "");  // 다른 input 들의 name은 제거
					if ($permChild.length > 0) {                                    // 체크된 권한이 있으면 name 부여
						$childTr.find("input[type=hidden]").attr("name", "permissions[].menuId");
						$permChild.attr("name", "permissions[].grantLevel");
					}
				});
			}
			const $levels = $("#tableBox tbody tr.child input[type=checkbox]");
			$levels.change(levelChange);
			$levels.filter(":checked").each(levelChange);
		</script>
		<%-- 권한 선택 시 동작 --%>
		<%-- 저장하기 전에 input name 처리 --%>
		<script>
			function goSave() {
				// $memberBox.find("input[name^=members]").each((i,e) => e.name = "members["+i+"].adminSeq");
				$("input[name^=permissions]").parents("tr.child").each((i,e) => {
					$("input[name^=permissions]",e).each((ii,ee) => ee.name = ee.name.replace(/\[\d*]/,"["+ i +"]"));
				});

				// 전체에 해당하는 체크박스는 서버로 보내지 않도록 처리
				$("input[id^=chkbox0]").each((i, e) => {
					$(e).prop("disabled", true);
				});

				submitFormIntoHiddenFrame(document.workForm);
			}
		</script>
		<%-- 저장하기 전에 input name 처리 --%>
		<script>    /* 항목 삭제 */
			const onFail = function () {
				location.reload();
			}

			<c:if test="${not isNew}">
				$("tfoot .leftBtn").deleteArticle("delete", {"seq": '<c:out value="${data.seq}"/>'}).then(() => {
					location.href = "list"
				}, onFail);
			</c:if>
		</script>
	</body>
</html>