<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/include/taglib.jsp" %>

<form name="searchForm" novalidate autocomplete="off">
	<c:if test="${not empty param.hiddenInput}">
		<jsp:include page="hidden.jsp" flush="false"/>
	</c:if>
    <table class="searchBox">
        <tbody>
            <input type="hidden" id="affiliateFloor" name="affiliateFloor" value="<c:out value="${search.affiliateFloor}"/>">
            <input type="hidden" id="codeType" name="codeType" value="<c:out value="${search.codeType}"/>">

            <c:if test="${not empty param.approve}">
                <input type="hidden" name="approveYn" value="<c:out value="${search.approveYn}"/>">
            </c:if>

            <c:if test="${not empty param.pageRow}">
                <tr>
                    <th>페이지당 행 개수</th>
					<td colspan="10">
					    <jsp:include page="pageRow.jsp" flush="false"/>
					</td>
                </tr>
            </c:if>
			<c:if test="${not empty param.selectEnumBuildingType}">
				<tr>
					<th>건물 위치</th>
					<td colspan="10">
                        <select name="buildingType">
                            <option value="">전체</option>
                            <c:forEach items="${buildingType}" var="type">
                                <option value="<c:out value="${type}"/>" ${search.buildingType == type ? 'selected' : ''}><c:out value="${type.name}"/></option>
                            </c:forEach>
                        </select>
					</td>
				</tr>
			</c:if>
            <c:if test="${not empty param.selectListFloor}">
                <tr>
                    <th>층</th>
					<td colspan="10">
                        <c:if test="${empty search.affiliateFloorArrays}">
                            <select name="floorSelect">
                                <option value="">층</option>
                                <c:forEach items="${affiliateFloors}" var="floor">
                                    <option value="<c:out value="${floor}"/>"><c:out value="${floor}"/></option>
                                </c:forEach>
                            </select>
                        </c:if>
                        <c:if test="${not empty search.affiliateFloorArrays}">
                            <select name="floorSelect">
                                <option value="">층</option>
                                <c:forEach items="${affiliateFloors}" var="floor">
                                    <c:forEach var="selectedFloor" items="${search.affiliateFloorArrays}" varStatus="status">
                                        <option value="<c:out value="${floor}"/>" ${selectedFloor == floor ? 'selected':''}><c:out value="${floor}"/></option>
                                    </c:forEach>
                                </c:forEach>
                            </select>
                        </c:if>
                    </td>
                </tr>
			</c:if>
            <c:if test="${not empty param.selectList}">
				<tr>
					<th>카테고리</th>
					<td colspan="10">
                        <%-- 대분류 드롭다운 --%>
                        <select id="categoryLarge" onchange="selectHighCodeType(this, 'L');">
                            <option value="">대분류</option>
                            <c:if test="${not empty largeCodeTypeList}">
                                <c:forEach items="${largeCodeTypeList}" var="item">
                                    <c:if test="${not empty search.codeTypeArraysInnerCategoryArrays}">
                                        <c:forEach var="row" items="${search.codeTypeArraysInnerCategoryArrays}" varStatus="status">
                                            <c:if test="${not empty row[0] and item.codeType eq row[0]}">
                                                <option value="<c:out value="${item.codeType}"/>" selected><c:out value="${item.codeTypeNameKo}"/></option>
                                            </c:if>
                                            <c:if test="${not empty row[0] and item.codeType != row[0]}">
                                                <option value="<c:out value="${item.codeType}"/>"><c:out value="${item.codeTypeNameKo}"/></option>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${empty search.codeTypeArraysInnerCategoryArrays}">
                                        <option value="<c:out value="${item.codeType}"/>"><c:out value="${item.codeTypeNameKo}"/></option>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </select>
                        <%-- // --%>

                        <%-- 중분류 드롭다운 --%>
                        <select id="categoryMiddle" onchange="selectHighCodeType(this, 'M');">
                            <option value="">중분류</option>
                            <c:if test="${not empty middleCodeTypeList}">
                                <c:forEach items="${middleCodeTypeList}" var="item">
                                    <c:if test="${not empty search.codeTypeArraysInnerCategoryArrays}">
                                        <c:forEach var="row" items="${search.codeTypeArraysInnerCategoryArrays}" varStatus="status">
                                            <c:if test="${not empty row[0] and item.codeType.startsWith(row[0])}">
												<c:choose>
													<c:when test="${not empty row[1] and item.codeType.substring(4).startsWith(row[1])}">
														<option value="<c:out value="${item.codeType}"/>" selected><c:out value="${item.codeTypeNameKo}"/></option>
													</c:when>
													<c:otherwise>
														<option value="<c:out value="${item.codeType}"/>"><c:out value="${item.codeTypeNameKo}"/></option>
													</c:otherwise>
												</c:choose>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </select>
                        <%-- // --%>

                        <%-- 소분류 드롭다운 --%>
                        <select id="categorySmall" onchange="selectHighCodeType(this, 'S');">
                            <option value="">소분류</option>
                            <c:if test="${not empty smallCodeTypeList}">
                                <c:forEach items="${smallCodeTypeList}" var="item">
                                    <c:if test="${not empty search.codeTypeArraysInnerCategoryArrays}">
                                        <c:forEach var="row" items="${search.codeTypeArraysInnerCategoryArrays}" varStatus="status">
											<c:if test="${not empty row[0] and not empty row[1] and item.codeType.startsWith(row[0]) and item.codeType.substring(4).startsWith(row[1])}">
												<c:choose>
													<c:when test="${not empty row[2] and item.codeType.substring(8).startsWith(row[2])}">
														<option value="<c:out value="${item.codeType}"/>" selected><c:out value="${item.codeTypeNameKo}"/></option>
													</c:when>
													<c:otherwise>
														<option value='<c:out value="${item.codeType}"/>'><c:out value="${item.codeTypeNameKo}"/></option>
													</c:otherwise>
												</c:choose>
											</c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </select>
                        <%-- // --%>

					</td>
				</tr>
			</c:if>
            <c:if test="${not empty param.selectEnumUseYn}">
				<tr>
					<th>공개여부</th>
					<td colspan="10">
                        <select name="useYn">
                            <option value="">전체</option>
                            <option value="Y" ${search.useYn == 'Y' ? 'selected' : ''}>공개</option>
                            <option value="N" ${search.useYn == 'N' ? 'selected' : ''}>비공개</option>
                        </select>
					</td>
				</tr>
			</c:if>
            <c:if test="${not empty param.searchText}">
				<tr>
					<th>검색어</th>
					<td><jsp:include page="searchText.jsp"	flush="false"/></td>
				</tr>
			</c:if>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="2">
                    <input type="submit" value="검색" class="mot3 blueBtn-round"/>
                    <input type="reset" value="초기화" class="mot3 grayBtn-round"/>
                </td>
            </tr>
        </tfoot>
    </table>

<script>    /* 초기화 버튼 클릭 */
    document.searchForm.addEventListener("reset", function (ev) {
        ev.preventDefault();
        const table = this.querySelector("table.searchBox");
        table.querySelectorAll("select option").forEach((e, i) => e.selected = false);
        table.querySelectorAll("input[type=radio]").forEach((e, i) => e.checked = false);
        table.querySelectorAll("input[type=checkbox]").forEach((e, i) => e.checked = false);
        table.querySelectorAll("input[type=text]").forEach((e, i) => e.value = "");
        $("input, select", this).each((i, e) => e.name = !e.value ? "" : e.name);

        document.getElementById('codeType').value = '';
        document.getElementById('affiliateFloor').value = '';

        document.searchForm.submit();
    });
</script>

<script>    /* 검색 버튼 클릭 */
    document.searchForm.addEventListener("submit", function (ev) {
        ev.preventDefault();
        showLoading();

        saveCodeType();
        combineFloorForSubmission();

        // 필요한 경우 값이 없는 항목은 제출되지 않도록
        $("input, select", this).each((i, e) => e.name = !e.value ? "" : e.name);

        // 최종적으로 폼 제출
        this.submit();
    });
</script>

<script>    /* 검색 조건 관련 */
    function combineFloorForSubmission() {
        let floorSelects = document.getElementsByName('floorSelect');
        let selectedFloors = [];

        for (let i = 0; i < floorSelects.length; i++) {
            let selectedValue = floorSelects[i].value;
            if (selectedValue) {
                selectedFloors.push(selectedValue);
            }
        }

        document.getElementById('affiliateFloor').value = selectedFloors.join(',');
    }

    function saveCodeType() {
        let largeSelect = document.getElementById('categoryLarge');
        let middleSelect = document.getElementById('categoryMiddle');
        let smallSelect = document.getElementById('categorySmall');

        let codeTypeValue = '';
        if (largeSelect.value && middleSelect.value && smallSelect.value) {
            codeTypeValue = smallSelect.value;
        } else if (largeSelect.value && middleSelect.value) {
            codeTypeValue = middleSelect.value;
        } else if (largeSelect.value) {
            codeTypeValue = largeSelect.value;
        }

		document.getElementById('codeType').value = codeTypeValue;
	}

    function generateOptionsForCategory(itemList) {
        return itemList.map(function (item) {
            return `<option value="` + item.codeType + `">` + item.codeTypeNameKo + `</option>`;
        }).join('');
    }

    function selectHighCodeType(element, category) {
        if (category === 'L') {
            // 중분류 셀렉트박스 활성화 및 데이터 추가
            let middleSelect = document.getElementById('categoryMiddle');
            middleSelect.disabled = true;
            middleSelect.innerHTML = `<option value="" disabled selected>중분류</option>`;
            middleSelect.disabled = false;
            if (element.value) {
                middleSelect.innerHTML += generateOptionsForCategory(middleCodeTypeList.filter(item => item.codeType.startsWith(element.value)));
            }

			let smallSelect = document.getElementById('categorySmall');
			smallSelect.innerHTML = `<option value="" disabled selected>소분류</option>`;
        }

        if (category === 'M') {
            // 소분류 셀렉트박스 활성화 및 데이터 추가
            let smallSelect = document.getElementById('categorySmall');
            smallSelect.disabled = true;
            smallSelect.innerHTML = `<option value="" disabled selected>소분류</option>`;
            smallSelect.disabled = false;
            if (element.value) {
                smallSelect.innerHTML += generateOptionsForCategory(smallCodeTypeList.filter(item => item.codeType.startsWith(element.value)));
            }
        }
    }
</script>
</form>