<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<title>BO Login</title>
		<%@ include file="/include/head.jsp" %>
		<link	href="<c:out value="${cPath}"/>/assets/css/login.css"			rel="stylesheet" type="text/css"/>	<%-- 페이지 특화 스타일 --%>
		<style type="text/css">
			.horizontalGroup{
				display: flex;
				justify-content: center;
				margin-top: 10px;
				margin-bottom: 10px;
			}

			/* .container는 Flexbox를 사용하여 자식 요소들을 세로로 배치 */
			.container {
				display: flex;
				flex-direction: column; /* 자식 요소를 세로로 배치 */
				min-width: 500px;
			}

			/* label 크기에 비례하여 row-indent div margin-left 적용중 */
			label {
				min-width: 120px;
				max-width: 120px;
			}

			/* input 입력 영역과 select 선택 영역 가로 크기 설정 */
			input[type=text], input[type=password], select{
				width: 200px;

				margin-left: 5px;
				margin-right: 5px;
			}
		</style>
	</head>

	<body>
		<div id="wrap">
			<img src="<c:out value="${cPath}"/>/assets/images/common/logo-red.png" id="logo">

			<h2 style="margin: 20px 20px">관리자님 비밀번호를 변경해주세요.</h2>
			<div>
				<p>관리자님의 아이디는 비밀번호 변경 안내 대상입니다</p>
				<%-- 비밀번호 초기화 필요 원인에 따라 다른 문구 노출 --%>
				<c:choose>
					<c:when test="${isTemporal}"><p>비밀번호 초기화 이후에는 비밀번호 변경이 필요합니다.</p></c:when>
					<c:when test="${isPwExpired}"><p>개인정보보호를 위해 90일 이상 비밀번호를 변경하지 않은 경우 비밀번호 변경을 안내하고 있습니다.</p></c:when>
				</c:choose>
			</div>

			<div style="margin-top: 60px">
				<form action="<c:out value="${cPath}"/>/pw/change" method="post" name="workForm">
					<div class="horizontalGroup">
						<div class="container">
							<div class="row">
								<label class="required" for="param1">
									현재 비밀번호
								</label>
								<input type="password"	name="param1"	id="param1"		required autocomplete="off" placeholder="비밀번호를 입력해주세요.">
							</div>
							<div class="row">
								<label class="required" for="param2">
									신규 비밀번호
								</label>
								<input type="password"	name="param2"	id="param2"		required autocomplete="off" placeholder="신규 비밀번호를 입력해주세요.">
							</div>
							<div class="row">
								<label class="required" for="param3">
									신규 비밀번호 확인
								</label>
								<input type="password"	name="param3"	id="param3"		required autocomplete="off" placeholder="신규 비밀번호를 재입력해주세요.">
							</div>
							<div class="row" style="margin-top: 20px">
								<div style="display: flex; flex-direction: column; align-items: flex-start">
									<div class="ment"><span class="red">8자리 이상일 경우 영어/숫자/특수문자 3개조합</span></div>
									<div class="ment"><span class="red">10자리 이상일 경우 영어/숫자/특수문자 중 2개 조합</span></div>
									<div class="ment"><span class="red">동일 문자, 연속문자 3번 이상 사용 불가</span></div>
									<div class="ment"><span class="red">회원아이디와 동일한 문자 사용 불가</span></div>
								</div>
							</div>
						</div>
					</div>
					<div>
						<input type="button" onclick="handleSubmit(document.workForm)" 	value="확인" class="submitBtn" id="pwChangeSubmitBtn" disabled>
						<%-- 비밀번호 변경 90일 초과시에만 다음에 변경 버튼 노출 --%>
						<c:if test="${isPwExpired}">
							<input type="button" onclick="delayChange()" 	value="다음에 변경" class="cancelBtn">
						</c:if>
					</div>
				</form>
			</div>
		</div>
		<script src="<c:out value="${cPath}"/>/assets/js/detail.js" charset="utf-8" type="text/javascript"></script>
		<script src="<c:out value="${cPath}"/>/assets/js/account.js" charset="utf-8" type="text/javascript"></script>
		<script type="text/javascript">
			// 필수값이 모두 입력되었을때, form submit 활성화
			const pwChangeSubmitBtn = document.getElementById('pwChangeSubmitBtn');
			const param1 = document.querySelector('input[name="param1"]');
			const param2 = document.querySelector('input[name="param2"]');
			const param3 = document.querySelector('input[name="param3"]');
			handleSubmitBtnEnable(pwChangeSubmitBtn, [param1, param2, param3]);

			function handleSubmit(form){
				submitFormIntoHiddenFrame(form);
			}
		</script>
		<script>
			function delayChange(){
				if(confirm('비밀번호 변경을 미루시겠습니까?')){
					const form = document.createElement('form');
					form.method = 'POST';
					form.action = '/pw/delay-change'

					document.body.appendChild(form);
					form.submit();
				}
			}
		</script>
	</body>
</html>