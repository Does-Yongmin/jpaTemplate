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
			justify-content: space-between;
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
			min-width: 80px;
			max-width: 80px;
		}
		.row-indent {
			margin-left: 92px;
		}

		/* 개인정보 수집 동의 문구 영역 */
		div#privacyTerms{
			width: 100%;
			border: 1px solid #ccc;
			padding: 20px;
			text-align: left;"
		}
	</style>
</head>

<body>
<div id="wrap">
	<img src="<c:out value="${cPath}"/>/assets/images/common/logo-red.png" id="logo">

	<h1>회원가입</h1>

	<div style="margin-top: 60px">
		<form action="<c:out value="${cPath}"/>/account/sign-up" name="workForm" method="post">
			<div class="horizontalGroup">
				<div class="container">
					<div class="row">
						<label class="required" for="emailUsername">
							이메일
						</label>
						<input type="text"		name="emailUsername" id="emailUsername"		required autocomplete="off" placeholder="이메일을 입력해 주세요.">
						<input type="hidden"    name="email">
						@
						<input type="text" 		id="customDomain" placeholder="직접 입력" style="display: none">
						<select id="emailDomain">
							<option>lotte.net</option>
							<option id="customDomainOption">직접 입력</option>
						</select>
						<input type="button"	id="btnEmailAuth" value="인증" disabled>
					</div>
					<div class="row row-indent">
						<input type="text"		name="emailAuthNum" required autocomplete="off" placeholder="인증번호를 입력해 주세요." disabled>
						<input type="button"	id="btnCheckEmailAuthNum" value="확인" disabled>
					</div>
				</div>
				<div class="container">
					<div class="row">
						<label class="required" for="adminName">
							이름
						</label>
						<input type="text"		name="adminName"	id="adminName"	required autocomplete="off" placeholder="이름을 입력해주세요.">
					</div>
					<div class="row row-indent">
						<div style="display: flex; flex-direction: column; align-items: flex-start">
							<div class="ment">이름은 2자 이상, 25자 이하로 입력 가능합니다.</div>
						</div>
					</div>
				</div>
			</div>
			<div class="horizontalGroup">
				<div class="container">
					<div class="row">
						<label class="required" for="adminPw">
							비밀번호
						</label>
						<input type="password"	name="adminPw"	id="adminPw"		required autocomplete="off" placeholder="비밀번호를 입력해주세요.">
						<input type="password"	name="adminPwConfirm"	required autocomplete="off" placeholder="비밀번호를 확인해주세요.">
					</div>
					<div class="row row-indent">
						<div style="display: flex; flex-direction: column; align-items: flex-start">
							<div class="ment">8자리 이상일 경우 영어/숫자/특수문자 3개조합</div>
							<div class="ment">10자리 이상일 경우 영어/숫자/특수문자 중 2개 조합</div>
							<div class="ment">동일 문자, 연속문자 3번 이상 사용 불가</div>
							<div class="ment">회원아이디와 동일한 문자 사용 불가</div>
						</div>
					</div>
				</div>
			</div>
			<div class="horizontalGroup">
				<div class="container">
					<div class="row">
						<label class="required" for="phone">
							전화번호
						</label>
						<input type="text"		name="phone" 	id="phone"	required autocomplete="off" placeholder="전화번호를 입력해 주세요.">
						<input type="button"	id="btnPhoneAuth"	value="인증"		class="" disabled>
					</div>
					<div class="row row-indent">
						<input type="text"		name="phoneAuthNum" required autocomplete="off" placeholder="인증번호를 입력해 주세요." disabled>
						<input type="button"	id="btnCheckPhoneAuthNum" value="확인" disabled>
					</div>
				</div>
				<div class="container">
					<div class="row">
						<label class="required" for="affiliateType">
							관련 회사
						</label>
						<select name="affiliateType" id="affiliateType">
							<option value="" disabled selected>승인담당운영사 선택</option>
							<c:forEach var="affiliateType" items="${affiliateTypes}" varStatus="stat">
								<option value="<c:out value="${affiliateType}"/>"><c:out value="${affiliateType.nameKo}"/></option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>
			<div class="horizontalGroup">
				<div style="width: 90%">
					<div class="row">
						<label class="required" for="privacyTerms">
							개인정보<br>
							수집 동의
						</label>
						<div id="privacyTerms">
							1. 개인정보 수집 및 이용 목적<br>
							- 롯데월드타워·몰 관리자 계정 등록 및 운영<br>

							<br>

							2. 개인정보 수집 항목(필수)<br>
							- 이메일, 이름, 전화번호, 직장 정보(관련 회사)<br>

							<br>

							<span style="color: red; font-weight: bold; text-decoration: underline; font-size: 120%;">
        						3. 개인정보 보유 및 이용기간<br>
								- 롯데월드타워·몰 관리자 계정 탈퇴 시까지<br>
    						</span>

							<br>

							4. 동의 거부권 등에 대한 고지<br>
							- 정보주체는 개인정보의 수집 및 이용 동의를 거부할 권리가 있으나, 이 경우 롯데월드타워·몰 관리자 계정 등록이 제한될 수 있습니다.<br>
						</div>
					</div>
					<div class="row row-indent">
						<input type="checkbox" value="Y" id="privacyConsentYn" name="privacyConsentYn">
						<label for="privacyConsentYn">동의합니다.</label>
					</div>
				</div>
			</div>
			<div>
				<input type="button" onclick="redirect('/');" 	value="취소" class="cancelBtn">
				<input type="button" onclick="handleSubmit(document.workForm)" 	value="등록" class="submitBtn" disabled>
			</div>
		</form>
	</div>

</div>
<%@ include file="/include/profileNotice.jsp" %>

<%--######################## 스크립트 ########################--%>
<script src="<c:out value="${cPath}"/>/assets/js/detail.js" charset="utf-8" type="text/javascript"></script>
<script src="<c:out value="${cPath}"/>/assets/js/account.js" charset="utf-8" type="text/javascript"></script>
<script> // 불필요한 쿼리 셀렉터 방지를 위해 element 들 변수로 선언
	const btnPhoneAuth = document.getElementById('btnPhoneAuth');
	const btnEmailAuth = document.getElementById('btnEmailAuth');
	const emailAuthNumInput = document.querySelector('input[name="emailAuthNum"]');
	const phoneAuthNumInput = document.querySelector('input[name="phoneAuthNum"]');
	const emailUsernameInput = document.querySelector('input[name="emailUsername"]');
	const phoneInput = document.querySelector('input[name="phone"]');
	const emailDomainSelect = document.getElementById('emailDomain');
	const emailHiddenInput = document.querySelector('input[name="email"]');
	const btnCheckPhoneAuthNum = document.getElementById('btnCheckPhoneAuthNum');
	const btnCheckEmailAuthNum = document.getElementById('btnCheckEmailAuthNum');

	// 필수값이 모두 입력되었을때, form submit 활성화
	const submitBtn = document.querySelector('input.submitBtn');
	const adminNameInput = document.querySelector('input[name="adminName"]');
	const adminPwInput = document.querySelector('input[name="adminPw"]');
	const adminPwConfirmInput = document.querySelector('input[name="adminPwConfirm"]');
	const privacyConsentCheckbox = document.querySelector('input[name="privacyConsentYn"]');
	const affiliateTypeSelect = document.getElementById('affiliateType');
	handleSubmitBtnEnable(submitBtn, [
			emailUsernameInput, phoneInput, phoneAuthNumInput, emailAuthNumInput,
			adminNameInput, adminPwInput, adminPwConfirmInput, privacyConsentCheckbox, affiliateTypeSelect
	]);

	function handleSubmit(form){
		// submit 전 사용자가 인증받은 이메일 주소와 다른 이메일로 변경하는지 서버단에서 확인 위해. 값 최신화
		const email = getFullEmail(emailUsernameInput.value);
		emailHiddenInput.value = email;

		submitFormIntoHiddenFrame(form);
	}
</script>
<script type="text/javascript"> // 공통 선언된 함수중 사용하는 것들을 각 페이지에서 확인 할 수 있도록. 여기에서 이벤트 리스너 부탁
	btnPhoneAuth.addEventListener('click', () => {
		phoneAuth(phoneInput.value);

		// 인증번호 입력란 활성화
		phoneAuthNumInput.disabled = false;
		btnCheckPhoneAuthNum.disabled = false;
	});
	btnEmailAuth.addEventListener('click', () => {
		// 이메일을 관리자 계정으로 사용.
		const email = getFullEmail(emailUsernameInput.value);
		// 이메일 양식이 유효한지 체크
		if(!isValidEmail(email)){
			alert('올바른 이메일을 입력해주세요.');
			return
		}

		// form 전송시 완성된 이메일로 발송 될 수 있도록 hidden input 에 세팅
		emailHiddenInput.value = email;
		const adminId = email.substring(0, email.indexOf('@'));

		// 이미 존재하는 계정인지 체크
		existCheckAdminId(adminId, existCallback);

		// 인증번호 입력란 활성화
		emailAuthNumInput.disabled = false;
		btnCheckEmailAuthNum.disabled = false;
	});

	// 이메일 도메인 직접 입력시 option 에 값 세팅
	emailDomainSelect.addEventListener('change', selectEvent => {
		const select = selectEvent.target;

		const customDomainInput = document.getElementById('customDomain');			// 직접 입력란 input
		const customDomainOption = document.getElementById('customDomainOption');	// 직접 입련란 select option

		// 직접 입력란 input 에 값 입력시 직접 입력 select option value 에 반영한다
		customDomainInput.addEventListener('input', inputEvent => {
			if(select.selectedOptions[0].id === customDomainOption.id){
				customDomainOption.value = inputEvent.target.value;
			}
		})

		// 현재 select 에서 선택된 option id 값에 따라 직접 입련란 영역 노출 또는 미노출 처리
		if(select.selectedOptions[0].id === customDomainOption.id){
			customDomainInput.style.display = 'inline-block';
		}else{
			customDomainInput.style.display = 'none';	// 화면에서 사라질때
			customDomainInput.value = '';				// 직접입력란 input value 비움
			customDomainOption.value = '';				// 직접입력란 option value 비움
		}
	})

	// 이미 존재하는 계정인지 true / false 여부를 전달 받는 callback 함수
	function existCallback(isExist){
		if(isExist){
		    alert('이미 존재하는 아이디로 신규 회원가입이 불가합니다.');
			// 이미 존재하는 관리자 계정일 경우 input 초기화
		    emailUsernameInput.value = '';
		}else{
			// 중복된 계정이 없는 경우, 회원가입을 위해 이메일 인증번호 발송
			const email = getFullEmail(emailUsernameInput.value);
			emailAuth(email);
		}
	}

	/*
		이메일 주소를 합쳐서 반환한다.
		유저가 입력한 이메일 유저네임 + 선택한 이메일 도메인 을 합친 전체 이메일 주소 반환
	 */
	function getFullEmail(username){
		const emailDomain = document.getElementById('emailDomain').value;
		if(!username) {
			return null;
		}
		if(!emailDomain){
			return null;
		}

		return username + "@" + emailDomain;
	}
</script>
<script type="text/javascript">
	// 인증번호 버튼 활성화 여부 핸들링
	emailUsernameInput.addEventListener('input', event => {
		handleInputRestrict(event, restrictToEmailUserNameFormat);
		handleElementEnable(event, isValidEmailUserName, [btnEmailAuth])
	});
	phoneInput.addEventListener('input', event => {
		handleInputRestrict(event, restrictToNumbers);
		handleElementEnable(event, isValidPhoneNumber, [btnPhoneAuth])
	});

	// 인증번호 확인
	btnCheckPhoneAuthNum.addEventListener('click', () => {
		checkAuthNum(phoneAuthNumInput.value, 'PHONE');
	})
	btnCheckEmailAuthNum.addEventListener('click', () => {
		checkAuthNum(emailAuthNumInput.value, 'EMAIL');
	})
</script>
</body>
</html>
