<%@ page import="com.does.biz.primary.domain.kiosk.KioskVO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"	uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 공개 상태인 게시물 조회할 때만 노출 순서 컬럼 보여주기 위함 --%>
<c:set var="isSearchUseY" value="${search.useYn eq 'Y'}"/>
<c:set var="hasExposeTypes" value="${not empty search.exposeTypes}"/>
<table>
    <thead>
        <tr>
            <th style="width:10px;"><input type="checkbox" class="checkAll"/></th>
            <c:if test="${isSearchUseY && hasExposeTypes}">
                <th style="width:30px;">노출 순서</th>
            </c:if>
            <th style="width:150px;">키오스크 종류</th>
            <th>제목</th>
            <th style="width:100px;">제공 언어</th>
            <th style="width:100px;">공개상태</th>
            <th style="width:100px;">등록일</th>
            <th style="width:100px;">등록자</th>
            <th style="width:80px;">수정</th>
        </tr>
        <c:if test='${empty list}'>
            <tr>
                <td colspan="50">No Data.</td>
            </tr>
        </c:if>
    </thead>
    <tbody>
        <c:forEach items="${list}" var="vo" varStatus="status">
            <tr id="<c:out value="${vo.seq}"/>">
                <%-- 공개 상태 리스트에서 순서 변경을 위해 필요한 name 값 seqs --%>
                <input type="hidden" name="seq" value="<c:out value="${vo.seq}"/>"/>
                <td><input type="checkbox" value="<c:out value="${vo.seq}"/>"></td>
                <c:if test="${isSearchUseY && hasExposeTypes}">
                    <td>
                        <c:if test="${vo.use}">
                            <select class="orderNumSelect" data-seq="<c:out value="${vo.seq}"/>">
                                <c:forEach var="i" begin="1" end="${maxOrderNum}" step="1">
                                    <option ${vo.orderNum eq i ? 'selected' : ''}><c:out value="${i}"/></option>
                                </c:forEach>
                            </select>
                        </c:if>
                    </td>
                </c:if>
                <td><c:out value='${vo.getExposeTypeString(" | ")}'/></td>
                <td><c:out value="${vo.title}"/></td>
                <td><c:out value='${vo.getSupportLangString(" | ")}'/></td>
                <td>
                    <select class="show ${vo.use ? 'Y' : 'N'}" data-seq="<c:out value="${vo.seq}"/>">
                        <option value="Y" class="Y" ${vo.use  ? 'selected' : ''}>공개</option>
                        <option value="N" class="N" ${!vo.use ? 'selected' : ''}>비공개</option>
                    </select>
                </td>
                <td><c:out value="${vo.createDatePretty}"/></td>
                <td><c:out value="${vo.creatorMasked}"/></td>
                <td>
                    <span class="click view whiteBtn" data-page-num="<c:out value="${search.pageNum}"/>" data-seq="<c:out value="${vo.seq}"/>">수정</span>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<script>
    const orderNumSelectList = document.querySelectorAll('.orderNumSelect');
    orderNumSelectList.forEach(select => {
        select.addEventListener('change', event => {
            if(confirm('순서를 변경하시겠습니까?')){

                const seq = event.target.dataset.seq;
                const orderNum = event.target.value;
                if(!seq || !orderNum) {
                    alert('순서 변경할 대상을 선택해주세요.');
                    return;
                }

                const form = document.createElement('form');
                const seqInput = document.createElement('input');
                seqInput.type = 'hidden';
                seqInput.name = 'seq';
                seqInput.value = seq;

                const orderNumInput = document.createElement('input');
                orderNumInput.type = 'hidden';
                orderNumInput.name = 'orderNum';
                orderNumInput.value = orderNum;

                /*
                    노출 유형 별로 다른 노출 순서를 적용하기 위해, 파라미터에서 현재 검색 필터에 선택된 값을 가져와서 같이 넘긴다
                 */
                const urlParams = new URLSearchParams(location.search);
                const exposeTypesValue = urlParams.get('exposeTypes');
                if(!exposeTypesValue){
                    alert("노출 유형 선택 후, 순서 변경이 가능합니다.");
                    return;
                }

                const exposeTypesInput = document.createElement('input');
                exposeTypesInput.type = 'hidden';
                exposeTypesInput.name = 'exposeTypes';
                exposeTypesInput.value = exposeTypesValue;

                form.appendChild(seqInput);
                form.appendChild(orderNumInput);
                form.appendChild(exposeTypesInput);

                const formData = new FormData(form);
                fetch('saveOrder', {
                    method : 'POST',
                    body : formData,
                }).then(response => response.json())
                .then(data => {
                    alert(data.msg);

                    if(data.success)
                        location.reload();
                })

            }else location.reload();
        })
    })
</script>
