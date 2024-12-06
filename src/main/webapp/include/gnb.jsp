<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<style>
  span.last-info {
    margin-left: 10px;
    margin-right: 10px;
  }

  span.last-info:first-child {
    margin-left: 0; /* 첫 번째 요소의 왼쪽 마진 제거 */
  }

  span.last-info:last-child {
    margin-right: 0; /* 마지막 요소의 오른쪽 마진 제거 */
  }
</style>

<div id="gnb">
	<div id="logo">
		<a target="contentFrame" href="/main"><img src="<c:out value="${cPath}"/>/assets/images/common/logo-white.png"/></a>
	</div>
  <div class="info-wrap">
    <div id="info">
      안녕하세요. <span><c:out value="${loginUser.nameId}" default="관리자"/></span>님
      <!-- <span>페이지 관리중입니다.</span> -->
      <div id="lastLog">
        <span class="last-info">
          최종접속일시 : <c:out value="${lastLogin.createDatePretty}" default="0000.00.00 00:00:00"/>
        </span>
        |
        <span class="last-info">
          최종접속IP : <c:out value="${lastLogin.creatorIp}" default="000.000.000.000"/>
        </span>
        |
        <span class="last-info">
          비밀번호 마지막 수정
          <span style="color:red;">
            <c:out value="${daysSinceLastPwChange}" default="0000.00.00 00:00:00"/>일
          </span>
          경과
        </span>
      </div>
    </div>
    <div id="box">
      <c:if test="${not empty permGroupList and fn:length(permGroupList) >= 1}">
        <span>권한그룹 : <c:out value="${permGroupList.get(0).groupName}"/></span>
      </c:if>
      <a target="contentFrame" href="<c:out value="${cPath}"/>/myInfo/detail"		title="로그인 계정정보 수정 페이지로 이동">개인정보 수정</a>
      <a  href="javascript:logout()" title="로그아웃">로그아웃</a>
    </div>
  </div>
</div>
<script	src="<c:out value="${cPath}"/>/assets/js/gnb.js"	charset="utf-8"		type="text/javascript"></script>
<script>
  const logout = () => {
    if(confirm('로그아웃 하시겠습니까?')){
      top.location.href = "<c:out value="${cPath}"/>/logout";
    }else{
      // 로그아웃 취소 선택시 로딩바 무효 위해 iframe 부분만 페이지 리로드
      const frame = document.getElementById('contentFrame');
      if(frame){
        frame.contentWindow.location.reload();
      }
    }
  }
</script>