<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<title>BO Login</title>
		<%@ include file="/include/head.jsp" %>
		<link	href="<c:out value="${cPath}"/>/assets/css/login.css"			rel="stylesheet" type="text/css"/>	<%-- 페이지 특화 스타일 --%>
		<style type="text/css">
			#loginWrap{
				position: absolute;
				top : 30%;
				left: 43%;
				width: 300px;
			}

			.rememberId{
				text-align: left;
				margin-left: 43px;
			}

			.submitBtn{
				padding-top: 5px;
				margin-top: 5px;
			}
		</style>
	</head>

	<body>
		<div id="wrap">
			<div id="loginWrap">
				<img src="<c:out value="${cPath}"/>/assets/images/common/logo-red.png" id="logo">

				<div>롯데월드타워몰 웹사이트 관리자</div>

				<form action="<c:out value="${cPath}"/>/login" method="post" name="loginForm" onsubmit="return rememberAdminId()">
					<div>
						<img src="<c:out value="${cPath}"/>/assets/images/login/id.png"><input type="text"		name="id" required autocomplete="off" placeholder="이메일 또는 아이디">
					</div>
					<div>
						<img src="<c:out value="${cPath}"/>/assets/images/login/pw.png"><input type="password"	name="pw" required autocomplete="off" placeholder="비밀번호">
					</div>
					<div class="rememberId">
						<input type="checkbox" id="rememberAdminIdCheckbox">
						<label for="rememberAdminIdCheckbox">아이디 저장</label>
					</div>
					<div>
						<input type="submit" value="LOGIN" class="submitBtn">
					</div>
				</form>

				<div id="accountFunc">
					<a href="<c:out value="${cPath}"/>/account/sign-up">회원가입</a>
					<a href="<c:out value="${cPath}"/>/account/find-pw">비밀번호 찾기</a>
					<a href="https://www.lottepnd.com/partner_privacy.do" target="_blank"><span style="text-decoration: underline;">개인정보처리방침</span></a>
				</div>
			</div>
		</div>

		<%--######################## 스크립트 ########################--%>
		<script>
			document.loginForm.id.focus();
			document.loginForm.addEventListener("submit", showLoading);
		</script>
		<script>
			/**
			 * 페이지 로드시 사용자의 아이디 저장 여부를 localstorage 에서 가져와서 세팅한다
			 */
			document.addEventListener('DOMContentLoaded', () => {
				// localstorage 에 저장된 문자열 true false 값을 가져와서 체크박스 상태 변경
				const isRememberChecked = localStorage.getItem('isRememberChecked') === "true";
				document.getElementById('rememberAdminIdCheckbox').checked = isRememberChecked;

				if(isRememberChecked){ // 아이디 저장 체크시
					const adminId = localStorage.getItem('rememberAdminId');
					if(adminId){
						document.querySelector('input[name=id]').value = adminId;

						// 아이디 저장 체크 및 저장된 adminId 가 있을 경우 비밀번호 입력란 focus
						document.querySelector('input[name=pw]').focus();
					}
				}
			})

			/**
			 * 사용자의 아이디 저장 여부를 localstorage 에 저장한다
			 */
			const rememberAdminId = () => {
				const isRememberChecked = document.getElementById('rememberAdminIdCheckbox').checked;
				localStorage.setItem('isRememberChecked', isRememberChecked);

				if(isRememberChecked){
					const adminId = document.querySelector('input[name=id]').value;
					if(adminId){
						localStorage.setItem('rememberAdminId', adminId);
					}
				}

				// submit 은 아이디저장 여부와 상관없이 항상 제출
				return true;
			}
		</script>
	</body>
</html>