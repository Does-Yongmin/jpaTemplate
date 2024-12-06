<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .type-search-bar {font-size: 0; border: 1px solid #D9D9D9; display: inline-block;}
    .type-box {
        display: inline-block;
        padding: 10px 20px;
        border: 1px solid #D9D9D9;
        cursor: pointer;
        font-size: 16px;
        color: #999999;
        vertical-align: top;
        background-color: #FFFFFF;
    }
    .type-box:hover {
        background-color: #F5F5F5;
    }
    .type-box.selected {
        color: #FFFFFF;
        background-color: #333333;
    }
</style>


<div class="type-search-bar">
    <form name="typeForm">
        <input type="hidden" id="typeInput" name="type" value="<c:out value="${search.type}"/>">
        <div class="type-box ${empty search.type ? 'selected' : ''}" data-type="ALL" onclick="submit(this)">전체</div>
        <c:forEach var="type" items="${types}">
            <c:choose>
                <c:when test="${param.displayType == 'name'}">  <!-- Enum 상수명 노출 -->
                    <div class="type-box ${search.type == type.name() ? 'selected' : ''}" data-type="<c:out value="${type.name()}"/>" onclick="submit(this)">
                            <c:out value="${type.name()}"/>
                    </div>
                </c:when>
                <c:otherwise>                                  <!-- 한글 값 노출 -->
                    <div class="type-box ${search.type == type.name() ? 'selected' : ''}" data-type="<c:out value="${type.name()}"/>" onclick="submit(this)">
                            <c:out value="${type.value}"/>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </form>
</div>

<script>
    function submit(el) {
        const type = el.getAttribute('data-type');
        const name = document.getElementById('typeInput');
        name.value = type;
        if (type === 'ALL') {
            name.value = '';
        }
        document.forms['typeForm'].submit();
    }
</script>




