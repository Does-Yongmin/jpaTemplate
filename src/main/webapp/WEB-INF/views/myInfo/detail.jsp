<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<%@ include file="/include/head.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/default.css"/>
		<style type="text/css">
			.horizontalGroup{
				display: flex;
				justify-content: space-between;
				margin: 10px 10px;
				padding: 20px 20px;
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
			/* 각 .row를 Flexbox로 설정하여 자식 요소들을 수평으로 배치 */
			.row {
				display: flex;
				align-items: center; /* 자식 요소를 세로 중앙 정렬 */
				margin-bottom: 10px; /* 행 간의 여백 */
			}
			.row-indent {
				margin-left: 93px;
			}

			/* input 입력 영역과 select 선택 영역 가로 크기 설정 */
			input[type=text], input[type=password], select{
				width: 200px;

				margin-left: 5px;
				margin-right: 5px;
			}

			.ment 				{color:gray;font-size: 12px;font-weight:lighter;}
			.ment:before 		{content:"* ";vertical-align:middle;}

			/* Button 기존에 input 셀렉터로 참조하는 것 class 별로 변경함 */
			.cancelBtn 			{ background-color:white; color:#808080; margin : 20px 10px; border:1px solid grey; width:240px; height:40px; border-radius: 10px;}
			.submitBtn 			{ background-color:red; color:#ffffff; 	margin : 20px 10px; border:1px solid red; 	width:240px; height:40px; border-radius: 10px;}
			.submitBtn:hover	{ background-color:black; color:#ffffff; border:1px solid black; }
			.submitBtn:disabled {
				cursor: not-allowed;
				background-color:white; color:#808080; 	border:1px solid red; 	width:240px; height:40px; border-radius: 10px;
			}
		</style>

		<style>
			/* 레이어 팝업 기본 스타일 */
			.popup-layer {
				position: fixed; /* 스크롤해도 고정된 위치에 표시 */
				top: 50%; /* 화면 중앙에 위치 */
				left: 50%;
				transform: translate(-50%, -50%); /* 정확히 중앙에 맞추기 위한 변환 */
				background-color: white; /* 팝업 배경색 */
				padding: 20px; /* 내부 여백 */
				border: 1px solid #ccc; /* 테두리 */
				border-radius: 20px;
				box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
				z-index: 1000; /* 다른 요소보다 위에 위치 */
			}

			/* 팝업 뒤의 반투명 배경 */
			.popup-overlay {
				position: fixed;
				top: 0;
				left: 0;
				width: 100%;
				height: 100%;
				background-color: rgba(0, 0, 0, 0.5); /* 반투명 검은색 배경 */
				z-index: 999; /* 팝업보다 낮지만, 다른 콘텐츠보다는 위에 위치 */
			}
		</style>
	</head>
	<body>
		<div id="pageTitle"><c:out value="${pageTitle}"/></div>	<%-- pageTitle은 Aspect 로 삽입 --%>
		<div class="detailBox">
			<input type="hidden" name="seq" value="<c:out value="${data.seq}"/>"/>
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
					<th>비밀번호</th>
					<td>
						<a type="button" href="javascript:openPopupByTargetId('popupLayerPw')" class="mot3 lightBtn-round">변경</a>
						<div class="ment">
							비밀번호 마지막 수정
							<span style="color:red;">
								<c:out value="${daysSinceLastPwChange}" default="0000.00.00 00:00:00"/>일
							</span>
							경과
						</div>
					</td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>
						<span class=""><c:out value="${data.decPhone}"/></span>
						<a type="button" href="javascript:openPopupByTargetId('popupLayerPhone')" class="mot3 lightBtn-round">변경</a>
					</td>
				</tr>
				<tr>
					<th>회원권한</th>
					<td>
						<c:forEach var="permissionGroup" items="${premissionGroupList}">
							<div><c:out value="${permissionGroup.groupName}"/></div>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<th>소속회사명</th>
					<td><c:out value="${data.affiliateType.nameKo}"/></td>
				</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="50">
							<a type="button" class="mot3 leftBtn lightBtn-round">회원탈퇴</a>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>


		<!-- ////////////////////////////////////////////////////////////////////////////// -->
		<!-- 팝업 오버레이 -->
		<div class="popup-overlay hidden" id="popupOverlay"></div>
		<!-- 팝업 내용 -->
		<div class="popup-layer hidden" id="popupLayerPw">
			<form name="pwChangeForm" action="<c:out value="${cPath}"/>/pw/change">
				<div class="horizontalGroup">
					<div class="container">
						<div class="row">
							<h2 style="margin: 5px 0">비밀번호 변경</h2>
						</div>
						<div class="row">
							<label class="required" for="param1">
								현재 비밀번호
							</label>
							<input type="password"	name="param1"	id="param1"		required autocomplete="off" placeholder="현재 비밀번호를 입력해주세요.">
						</div>
						<div class="row">
							<label class="required" for="param2">
								새 비밀번호
							</label>
							<input type="password"	name="param2"	id="param2"		required autocomplete="off" placeholder="새 비밀번호를 입력해주세요.">
						</div>
						<div class="row row-indent">
							<input type="password"	name="param3"					required autocomplete="off" placeholder="새 비밀번호를 다시 한번 입력해주세요.">
						</div>
						<div class="row row-indent">
							<div style="display: flex; flex-direction: column; align-items: flex-start">
								<div class="ment">8자리 이상일 경우 영어/숫자/특수문자 3개조합</div>
								<div class="ment">10자리 이상일 경우 영어/숫자/특수문자 중 2개 조합</div>
								<div class="ment">동일 문자, 연속문자 3번 이상 사용 불가</div>
								<div class="ment">회원아이디와 동일한 문자 사용 불가</div>
							</div>
						</div>
						<div class="row">
							<input type="button" onclick="closePopupByTargetId('popupLayerPw')" 									value="취소" class="cancelBtn">
							<input type="button" onclick="handleSubmitWithPopup(document.pwChangeForm, 'popupLayerPw')"  		value="변경" class="submitBtn" id="pwChangeSubmitBtn" disabled>
						</div>
					</div>
				</div>
			</form>
		</div>
		<div class="popup-layer hidden" id="popupLayerPhone">
			<form name="phoneChangeForm" action="<c:out value="${cPath}"/>/account/change-phone">
				<div class="horizontalGroup">
					<div class="container">
						<div class="row">
							<h2 style="margin: 5px 0">전화번호 변경</h2>
						</div>
						<div class="row">
							<label class="required" for="phone">
								전화번호
							</label>
							<input type="text"		name="phone" 	id="phone"	required autocomplete="off" placeholder="전화번호를 입력해 주세요.">
							<input type="button"	id="btnPhoneAuth"	value="인증"		class="" disabled>
						</div>
						<div class="row row-indent">
							<input type="text"		name="phoneAuthNum" required autocomplete="off" placeholder="인증번호를 입력해 주세요." disabled>
						</div>
						<div class="row">
							<input type="button" onclick="closePopupByTargetId('popupLayerPhone')" 									value="취소" class="cancelBtn">
							<input type="button" onclick="handleSubmitWithPopup(document.phoneChangeForm, 'popupLayerPhone')"  		value="변경" class="submitBtn" id="phoneChangeSubmitBtn" disabled>
						</div>
					</div>
				</div>
			</form>
		</div>

		<!-- ////////////////////////////////////////////////////////////////////////////// -->
		<script	src="<c:out value="${cPath}"/>/assets/js/detail.js"	charset="utf-8"		type="text/javascript"></script>
		<script src="<c:out value="${cPath}"/>/assets/js/account.js" charset="utf-8" type="text/javascript"></script>
		<script type="text/javascript">
			// 불필요한 쿼리 셀렉터 방지를 위해 element 들 변수로 선언
			const btnPhoneAuth = document.getElementById('btnPhoneAuth');
			const phoneAuthNumInput = document.querySelector('input[name="phoneAuthNum"]');
			const phoneInput = document.querySelector('input[name="phone"]');

			// 공통 선언된 함수중 사용하는 것들을 각 페이지에서 확인 할 수 있도록. 여기에서 이벤트 리스너 부탁
			document.getElementById('btnPhoneAuth').addEventListener('click', () => phoneAuth(phoneInput.value));

			// 필수값이 모두 입력되었을때, form submit 활성화
			const pwChangeSubmitBtn = document.getElementById('pwChangeSubmitBtn');
			const param1 = document.querySelector('input[name="param1"]');
			const param2 = document.querySelector('input[name="param2"]');
			const param3 = document.querySelector('input[name="param3"]');
			handleSubmitBtnEnable(pwChangeSubmitBtn, [param1, param2, param3]);

			const phoneChangeSubmitBtn = document.getElementById('phoneChangeSubmitBtn');
			handleSubmitBtnEnable(phoneChangeSubmitBtn, [phoneInput, phoneAuthNumInput]);
		</script>
		<script> // 팝업 여닫기

			/**
			 * form 을 제출하고 팝업을 닫는다
			 * @param form
			 * @param targetId 닫으려는 popup id 값
			 */
			function handleSubmitWithPopup(form, targetId){
				submitFormIntoHiddenFrame(form);
				closePopupByTargetId(targetId);

				// 팝업 레이어 입력 부분 값 비우기
				form.querySelectorAll('input[type="text"],input[type="password"]').forEach(input => input.value = '')
			}

			const popupOverlay = document.getElementById('popupOverlay');

			/**
			 * 팝업을 연다
			 * @param targetId 열려는 popup id 값
			 */
			function openPopupByTargetId(targetId){
				// 전달된 팝업 ID가 없을 경우 함수 종료
				if(!targetId) return

				// 팝업 레이어 선택 후, 노출 처리
				const popupLayer = document.getElementById(targetId);
				popupLayer.classList.remove('hidden');


				// 팝업 오버레이 노출 처리
				popupOverlay.classList.remove('hidden');
			}

			/**
			 * 팝업을 닫는다
			 * @param targetId 닫으려는 popup id 값
			 */
			function closePopupByTargetId(targetId){
				// 전달된 팝업 ID가 없을 경우 함수 종료
				if(!targetId) return

				// 팝업 레이어 선택 후, 숨김 처리
				const popupLayer = document.getElementById(targetId);
				popupLayer.classList.add('hidden');
				// 팝업 레이어 입력 부분 값 비우기
				popupLayer.querySelectorAll('input[type="text"],input[type="password"]').forEach(input => input.value = '')

				// 팝업 오버레이 미노출 처리
				popupOverlay.classList.add('hidden');
			}
		</script>
		<script type="text/javascript">
			// 인증번호 버튼 활성화 여부 핸들링
			phoneInput.addEventListener('input', event => {
				handleInputRestrict(event, restrictToNumbers);
				handleElementEnable(event, isValidPhoneNumber, [phoneAuthNumInput, btnPhoneAuth])
			});
		</script>
		<script>	/* 항목 삭제 */
			const onFail = function () {
				location.reload();
			}

			$("tfoot .leftBtn").deleteArticle("withdraw", {"seq": '<c:out value="${data.seq}"/>'}).then(() => {
				// onSuccess 시 콜백 부분
				top.location.href = "/"; // 최상위 프레임을 '/' 로 이동시킴
			}, onFail);
		</script>
	</body>
</html>