<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    .type-search-bar {font-size: 0;}
    .type-box {display: inline-block; padding: 10px 20px; border-radius: 4px; background-color: #EEEEEE; cursor: pointer; font-size: 16px; color: grey; vertical-align: top;}
    .type-box:hover {background-color: #e9e9e9;}
    .type-box.selected {font-weight: bold; color: black;}
</style>

<%--구분--%>
<div class="type-search-bar">
    <form name="typeForm" action="">
        <div class="type-box" data-action="permission-history" onclick="submit(this)">개인정보 관리자 권한 이력</div>
        <div class="type-box" data-action="monthly-menu-usage" onclick="submit(this)">월별 메뉴 버튼 사용 현황</div>
        <div class="type-box" data-action="access-admin"       onclick="submit(this)">개인정보 관리자 리스트</div>
    </form>
</div>

<script>
    function submit(el) {
        const action = el.getAttribute('data-action');
        document.typeForm.action = action;
        document.typeForm.submit();
    }

    /*
        현재 선택된 tab 에 따라 css 활성화.
        다른 변수명과 겹치지 않게 하기 위해 즉시실행함수로 선언
     */
    (() => {
        const lastPath = location.pathname.split('/').pop();
        const query = 'div[data-action="' + lastPath + '"]';
        const element = document.querySelector(query);
        element.classList.add('selected');
    })();
</script>
