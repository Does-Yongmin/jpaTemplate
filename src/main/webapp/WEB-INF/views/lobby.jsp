<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
	<head lang="ko">
		<title>BO Sitemap</title>
		<%@ include file="/include/head.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/gnb.css"/>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/lnb.css"/>
		<link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/lobby.css"/>
	</head>
	<body>
		<%@ include file="/include/profileNotice.jsp" %>
		<%@ include file="/include/gnb.jsp" %>
		<section>
			<%@ include file="/include/lnb.jsp" %>
			<iframe id="contentFrame" name="contentFrame" src="/main"></iframe>
		</section>
	</body>

<script>
	const sessionCheckInterval = 600000;	// 세션 체크 시간 기본 10분으로 설정

	function checkSession() {
		$.ajax({
			url:'/session-check',
			success : function(data) {
			},
			error : function(xhr, status, error) {
				console.log('Session is expired.');
				alert('세션이 만료되었습니다. 다시 로그인 해주세요');
				window.location.href = '<c:out value="${cPath}"/>/';
			}
		});
	}

	setInterval(checkSession, sessionCheckInterval);
</script>
</html>

