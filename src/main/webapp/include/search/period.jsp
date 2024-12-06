<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/taglib.jsp" %>

<input type="text" class="date" name="startDate" value="<c:out value="${search.startDate}"/>" autocomplete="off">
&nbsp;~&nbsp;
<input type="text" class="date" name="endDate"	 value="<c:out value="${search.endDate}"/>"	 autocomplete="off">

<script>
    const periodStartDate = document.querySelector('input[name=startDate]');
    const periodEndDate = document.querySelector('input[name=endDate]');

    /**
     * 날짜가 선택 되었을때 두 input 의 날짜를 비교하여 end 가 start 이전일 수 없도록 제한
     */
    [periodStartDate, periodEndDate].forEach(dateInput => {
        dateInput.addEventListener('dateSelected', () => {
            const startDateStr = periodStartDate.value;
            const endDateStr = periodEndDate.value;

            if(startDateStr && endDateStr){ // 종료일이 시작일보다 이전이 아니어야 하므로 둘 다 값이 있을때만 로직 실행
                let startDate = null;
                let endDate = null;

                // jsp 에서 넣는 부분 때문에, 2024-10-25 / 20241025 이런 2가지 케이스가 있어서 분기 처리
                const regex = /\d{4}-\d{2}-\d{2}/;
                if(regex.test(startDateStr)){
                    startDate = new Date(startDateStr);
                }else{
                    startDate = new Date(
                        parseInt(startDateStr.substring(0, 4)),     // 년
                        parseInt(startDateStr.substring(4, 6)) - 1, // 월
                        parseInt(startDateStr.substring(6, 8))      // 일
                    )
                }

                if(regex.test(endDateStr)){
                    endDate = new Date(endDateStr);
                }else{
                    endDate = new Date(
                        parseInt(endDateStr.substring(0, 4)),
                        parseInt(endDateStr.substring(4, 6)) - 1,
                        parseInt(endDateStr.substring(6, 8))
                    )
                }

                // 종료일이 시작일 이전일 경우 alert
                if(endDate < startDate){
                    alert('기간 검색시 종료일은 시작일 이전일 수 없습니다.');
                    periodEndDate.value = '';
                }
            }
        })
    })
</script>

<%--<c:set var="period"		value="${fn:split('1w,2w,1m,3m,6m,1y', ',')}"/>--%>
<%--<c:set var="prdName"	value="${fn:split('1주,2주,1개월,3개월,6개월,1년', ',')}"/>--%>
<%--<div class="prdBox">--%>
<%--    <c:forEach begin="0" end="${fn:length(period)-1}" step="1" var="i">--%>
<%--        <a href="javascript:searchPeriod('${period[i]}')" class="mot3 lightBtn-round"><c:out value="${prdName[i]}"/></a>--%>
<%--    </c:forEach>--%>
<%--</div>--%>
<%--<script>--%>
<%--    &lt;%&ndash; 날짜 계산 시 윤달/윤년 처리는 안되어있음. &ndash;%&gt;--%>
<%--    function searchPeriod (prd) {--%>
<%--        const num	= parseInt(prd.replace(/[^\d]/g, ""));--%>
<%--        const type	= prd.replace(/\d/g, "");--%>

<%--        const eDate	= new Date();--%>
<%--        const sDate = new Date();--%>

<%--        switch(type) {--%>
<%--            case "w": sDate.setDate(sDate.getDate() - num*7);		break;--%>
<%--            case "m": sDate.setMonth(sDate.getMonth() - num);		break;--%>
<%--            case "y": sDate.setFullYear(sDate.getFullYear() - num);	break;--%>
<%--        }--%>

<%--        document.querySelector("input.date[name=startDate]").value	= dateToYMD(sDate);--%>
<%--        document.querySelector("input.date[name=endDate]").value	= dateToYMD(eDate);--%>
<%--    }--%>
<%--</script>--%>