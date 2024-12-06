<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
	<title>BO Login</title>
	<%@ include file="/include/head.jsp" %>
	<link	href="<c:out value="${cPath}"/>/assets/css/login.css"			rel="stylesheet" type="text/css"/>	<%-- 페이지 특화 스타일 --%>
	<style type="text/css">
		/* 바깥쪽 div에 테두리 추가 */
		.outerContainer {
			border: 2px solid #ccc; /* 테두리 색상과 두께 설정 */
			padding: 10px;          /* 내용물과 테두리 사이의 여백 */
			border-radius: 5px;     /* 테두리의 둥근 모서리 설정 */
			margin-bottom: 20px;    /* 다른 요소와의 간격 */
			margin-top: 20px;
			width: 600px;
		}

		/* 내부 div 사이에 구분선 추가 */
		.outerContainer > div {
			padding: 10px 0; /* 위아래 여백 설정 */
			border-bottom: 1px solid #ccc; /* 구분선 추가 */
		}

		/* 마지막 div 아래에 구분선 제거 */
		.outerContainer > div:last-child {
			border-bottom: none;
		}

		label {
			min-width: 100px;
			max-width: 100px;
		}
		.row-indent {
			margin-left: 30px;
		}

		.container-wrap{
			margin-top: 30px;
			display: flex;
			align-items: center;
			justify-content: center;
		}
	</style>
</head>

<body>
<div id="wrap">
	<img src="<c:out value="${cPath}"/>/assets/images/common/logo-red.png" id="logo">

	<h2>계정이 잠겨 있습니다.</h2>
	<div class="ment" style="margin-top: 10px">관리자님의 계정이 잠겨있습니다. 계정을 잠금 해제하려면 아래 본인 인증을 진행해 주세요.</div>

	<div class="container-wrap">
		<form name="workForm" action="<c:out value="${cPath}"/>/account/unlock">
			<%-- 로그인 시도시 입력한 id 값으로 세팅 --%>
			<input type="hidden"		name="adminId"	 value="<c:out value="${adminId}"/>">

			<div class="outerContainer">
				<div class="container">
					<div class="row">
						<input type="radio" name="authMethod" id="authMethod1" value="PHONE" data-display-target-id="authMethodPhone">
						<label for="authMethod1">
							전화번호로 인증
						</label>
					</div>
					<div class="row row-indent">
						<div class="ment">회원정보에 등록한 전화번호와 입력한 정보가 일치해야 인증번호를 받을 수 있습니다.</div>
					</div>
					<div class="row row-indent">
						<div id="authMethodPhone" class="hidden">
							<input type="text"		name="phone"		required autocomplete="off" placeholder="전화번호를 입력해 주세요.">
							<input type="button"	id="btnPhoneAuth"	value="인증"		class="" disabled>

							<input type="text"		name="phoneAuthNum" required autocomplete="off" placeholder="인증번호를 입력해 주세요." disabled>
						</div>
					</div>
				</div>

				<div class="container">
					<div class="row">
						<input type="radio" name="authMethod" id="authMethod2" value="EMAIL" data-display-target-id="authMethodEmail">
						<label for="authMethod2">
							이메일로 인증
						</label>
					</div>
					<div class="row row-indent">
						<div class="ment">회원정보에 등록한 이메일로 인증번호를 받습니다.</div>
					</div>
					<div class="row row-indent">
						<div id="authMethodEmail" class="hidden">
							<input type="button"	id="btnEmailAuth" value="인증번호 발급"		class="" disabled>
							<input type="text"		name="emailAuthNum" required autocomplete="off" placeholder="인증번호를 입력해 주세요." disabled>
						</div>
					</div>
				</div>
			</div>
			<div>
				<input type="button" onclick="redirect('/')" 	value="취소" class="cancelBtn">
				<input type="button" onclick="submitFormIntoHiddenFrame(document.workForm)"  		value="확인" class="submitBtn" disabled>
			</div>
		</form>
	</div>
</div>
<script src="<c:out value="${cPath}"/>/assets/js/detail.js" charset="utf-8" type="text/javascript"></script>
<script src="<c:out value="${cPath}"/>/assets/js/account.js" charset="utf-8" type="text/javascript"></script>
<script>

</script>
<script type="text/javascript">
	// 불필요한 쿼리 셀렉터 방지를 위해 element 들 변수로 선언
	const btnPhoneAuth = document.getElementById('btnPhoneAuth');
	const btnEmailAuth = document.getElementById('btnEmailAuth');
	const emailAuthNumInput = document.querySelector('input[name="emailAuthNum"]');
	const phoneAuthNumInput = document.querySelector('input[name="phoneAuthNum"]');
	const phoneInput = document.querySelector('input[name="phone"]');
	const adminIdInput = document.querySelector('input[name="adminId"]');

	// 공통 선언된 함수중 사용하는 것들을 각 페이지에서 확인 할 수 있도록. 여기에서 이벤트 리스너 부탁
	btnPhoneAuth.addEventListener('click', () => phoneAuthWithAdminId(phoneInput.value, adminIdInput.value));
	btnEmailAuth.addEventListener('click', () => emailAuthByAdminId(adminIdInput.value));
	// 필수값이 모두 입력되었을때, form submit 활성화
	const submitBtn = document.querySelector('input.submitBtn');
	handleSubmitBtnEnable(submitBtn, [[phoneAuthNumInput, emailAuthNumInput]]);
</script>
<script type="text/javascript">
	const divAuthMethodPhone = document.getElementById('authMethodPhone');
	const divAuthMethodEmail = document.getElementById('authMethodEmail');
	// 인증 방식에 따라 영역 표시 토글링
	document.querySelectorAll('input[name="authMethod"]').forEach(radio => radio.addEventListener('change', toggleAuthMethod));
	function toggleAuthMethod(event){
		// 모든 authMethod 영역을 숨김고, 하위 input 태그를 비활성화
		divAuthMethodPhone.classList.add('hidden');
		divAuthMethodEmail.classList.add('hidden');
		divAuthMethodPhone.querySelectorAll('input').forEach(input => {
			if(input.type === 'text') input.value = '';
			input.disabled = true
		});
		divAuthMethodEmail.querySelectorAll('input').forEach(input => {
			if(input.type === 'text') input.value = '';
			input.disabled = true
		});

		// 현재 선택된 id 값의 authMethod 영역을 보이게 하고, 하위 input 태그를 활성화
		const targetId = event.target.getAttribute('data-display-target-id');
		const targetMethodDiv = document.getElementById(targetId);

		targetMethodDiv.classList.remove('hidden');
		targetMethodDiv.querySelectorAll('input').forEach(input => {
			// 인증 버튼과 인증번호 입력란은 유효성 검증후 활성화 위해 별도 이벤트 리스너로 처리중
			if(input.id === 'btnEmailAuth' || input.name === 'phone') input.disabled = false
		});
	}
</script>
<script type="text/javascript"> // 인증번호 버튼 활성화 여부 핸들링
	btnEmailAuth.addEventListener('click', event => {
		// 비밀번호 찾기는 DB 에 있는 이메일로 발송하기 때문에 이메일 유효성 검증 부분 true 처리
		handleElementEnable(event, (value) => true, [emailAuthNumInput])
	});
	phoneInput.addEventListener('input', event => {
		handleInputRestrict(event, restrictToNumbers);
		handleElementEnable(event, isValidPhoneNumber, [phoneAuthNumInput, btnPhoneAuth])
	});
</script>
</body>
</html>
