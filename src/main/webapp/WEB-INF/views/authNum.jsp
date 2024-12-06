<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<title>BO Login</title>
		<%@ include file="/include/head.jsp" %>
		<link	href="<c:out value="${cPath}"/>/assets/css/login.css"			rel="stylesheet" type="text/css"/>	<%-- 페이지 특화 스타일 --%>
	</head>

	<body>
		<div id="wrap">
			<img src="<c:out value="${cPath}"/>/assets/images/common/logo-red.png" id="logo">

			<h2 style="margin-top: 10px; margin-bottom: 10px">2차 인증</h2>
			<spring:eval var="activeProfile" expression="@environment.getProperty('spring.profiles.active')"/>
			<c:if test="${activeProfile == 'does' or activeProfile == 'local'}">
				<div class="ment">개발환경에서만 인증번호가 자동으로 입력됩니다.</div>
			</c:if>
			<div class="ment">
				인증번호가 발급되었습니다. <span style="color:red">(<c:out value="${issuedMessage}"/>)</span>
			</div>

			<form action="<c:out value="${cPath}"/>/authenticate" method="post" name="authForm">
				<div>
					<input type="text"		name="authNum" required autocomplete="off" placeholder="인증번호" value="<c:out value="${authNum}"/>">
					<span id="remainingText"></span><span style="color:red;" id="remainingTime"></span>
				</div>
				<div style="margin-top: 10px; margin-bottom: 10px">
					발송된 인증번호를 입력해주세요.
				</div>
				<div>
					<input type="submit" value="인증" class="submitBtn">
					<input type="button" value="인증번호 재발급" class="submitBtn hidden" id="reissueButton"/>
				</div>
			</form>
		</div>


		<%--######################## 스크립트 ########################--%>
		<script src="<c:out value="${cPath}"/>/assets/js/detail.js" charset="utf-8" type="text/javascript"></script>
		<script src="<c:out value="${cPath}"/>/assets/js/account.js" charset="utf-8" type="text/javascript"></script>
		<script type="text/javascript">
			// 필수값이 모두 입력되었을때, form submit 활성화
			const submitBtn = document.querySelector('input.submitBtn');
			const authNumInput = document.querySelector('input[name="authNum"]');
			handleSubmitBtnEnable(submitBtn, [authNumInput]);
		</script>
		<script type="text/javascript">
			// 인증번호 발송 시간 표시
			const remainingTextSpan = document.getElementById('remainingText');
			const remainingTimeSpan = document.getElementById('remainingTime');
			const authNumExpirationTimeMillis = Number('<c:out value="${authNumExpirationTimeMillis}"/>');
			// 시간 만료시 interval 해제를 위한 변수
			let intervalId = null;

			// 서버로 부터 만료시간을 전달 받았을때만 실행
			if(authNumExpirationTimeMillis){
				intervalId = setInterval(() => {
					updateTimeRemaining(authNumExpirationTimeMillis);
				}, 1000);
			}

			// 만료시간까지 현재시간부터 얼만큼의 시간이 남았는지 계산하여 view 변화
			function updateTimeRemaining(expirationTimeMillis){
				const currentTime 		= new Date();
				const expirationTime 	= new Date(expirationTimeMillis);

				// 남은시간 계산
				const timeDiff = expirationTime - currentTime;

				// 시간이 만료 되었을 때
				if(timeDiff < 0){
					remainingTextSpan.textContent = '만료';
					submitBtn.disabled = true; // 인증버튼 비활성화

					if(intervalId)	clearInterval(intervalId); // interval 메모리 해제

					alert('인증번호가 만료되었습니다.');
					revealReissueAndHiddenSubmit(); // 인증번호 재발급 버튼 노출
					return;
				}

				const seconds = Math.floor(timeDiff / 1000);
				const minutes = Math.floor(seconds / 60);
				const displayMinutes = String(minutes % 60).padStart(2, '0');
				const displaySeconds = String(seconds % 60).padStart(2, '0');

				const timeRemaining = `\${displayMinutes}:\${displaySeconds}`;
				remainingTextSpan.textContent = '만료시간 : ';
				remainingTimeSpan.textContent = timeRemaining;
			}
		</script>
		<script>
			const reissueButton = document.getElementById('reissueButton');
			reissueButton.addEventListener('click', () => {
				if(confirm('인증번호를 재발급 받으시겠습니까?')){
					const form = document.createElement('form');
					form.method = 'POST';
					form.action = '/reissue-auth-num';

					document.body.append(form);
					form.submit();
				}
			})

			function revealReissueAndHiddenSubmit(){
				submitBtn.classList.add('hidden');
				reissueButton.classList.remove('hidden');
			}
		</script>
	</body>
</html>
