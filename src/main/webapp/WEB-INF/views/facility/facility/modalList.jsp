<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    .modal {
        display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%;
        overflow: auto; background-color: rgba(0, 0, 0, 0.5); justify-content: center; align-items: center;
    }
    .modal-content {
        background-color: #f2f2f2; padding: 20px; border: none; width: 90%; max-width: 1200px; height: 90%;
        max-height: 100%; border-radius: 10px; overflow-y: auto; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); position: relative;
    }
    .modal-content h3 {
        margin-top: 30px; padding: 10px 20px; background-color: #666; color: white; position: relative;
    }

    .modal-guide {margin: 15px 0;padding-left: 5px; /* 글머리기호랑 문구 사이 여백 */font-size: 14px;color: #333;line-height: 1.5;}
    .modal-guide li {list-style-type: disc;margin-left: 20px;}
    .modal-guide li b {color : #F37321;}

    .modal .close {position: absolute;top: 10px;right: 20px;color: #aaa;font-size: 28px;font-weight: bold;cursor: pointer;}
    .modal .close:hover, .modal .close:focus {color: black;text-decoration: none;cursor: pointer;}

    .modal .search-bar {margin: 20px auto;display: flex;align-items: center;justify-content: center;}
    .modal .search-bar input[type="text"] {align-items: center;width: 60%;padding: 10px;border: 1px solid #ccc;border-radius: 5px;margin-right: 10px;}
    .modal .search-bar button {padding: 10px 20px;background-color: #666;color: white;border: none;border-radius: 5px;cursor: pointer;}
    .modal .search-bar button:hover {background-color: #444;}

    .modal-table {width: 100%;border-collapse: collapse;margin-top: 20px;}
    .modal-table th, .modal-table td {padding: 12px;text-align: left;border-bottom: 1px solid #ddd;}
    .modal-table th {background-color: #666;color: white;}
    .modal-table td {
        max-width: 250px;
        background-color: white;
        white-space: normal;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .modal-table tr {cursor: pointer;}
    .modal-table tbody tr:hover {font-weight: bold; color: blue;}

    .modal-pagination {display: flex;justify-content: center;margin-top: 20px;}
    .modal-pagination #paging tr:hover {background-color: #f2f2f2;}
</style>

<div id="storeModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>

        <h3>등록 매장 조회</h3>
        <div class="modal-guide">
            <li>매장 검색으로 원하는 매장을 찾으세요.</li>
            <li>선택하고 싶은 매장을 눌러 매장 선택을 완료하세요.</li>
            <li>매장 선택은 <b>한번에 최대 1개</b>까지만 가능합니다.</li>
        </div>
        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="매장 및 시설명을 입력하세요">
            <button type="button" onclick="searchFacilities(initCodeTypes)">검색</button>
            <button type="button" onclick="searchFacilities(initCodeTypes, 'Y', true)" style="margin-left: 2px;">전체 검색</button>
        </div>
        <table class="modal-table">
            <thead>
            <tr>
                <th style="width: 15%;">대분류</th>
                <th style="width: 15%;">중분류</th>
                <th style="width: 15%;">소분류</th>
                <th style="width: 30%;">매장 및 시설명</th>
                <th style="width: 15%;">건물</th>
                <th style="width: 10%;">층</th>
            </tr>
            </thead>
            <tbody id="modal-table-body">
                <%@include file="modalListContent.jsp" %>
            </tbody>
        </table>
        <div class="modal-pagination">
            <%@include file="modalListPaging.jsp" %>
        </div>
    </div>
</div>

<script>
    const modal = document.getElementById('storeModal');
    let initCodeTypes = '';
    let selectedOrder;  // 현재 선택된 el의 seq

    // 모달 바깥 클릭 시 모달 창 닫음
    window.onclick = function(event) {
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }

    // Enter 검색
    document.getElementById('searchInput').addEventListener('keydown', function(event) {
        if (event.key === 'Enter') {
            searchFacilities(initCodeTypes);
        }
    });

    function closeModal() {
        modal.style.display = "none";
    }

    // 일반적으로 '등록 매장 확인 및 선택' 에 사용하는 메소드
    function showModal(order) {
        if (order) {
            selectedOrder = order;
        }

        initCodeTypes = 'L000M001,L001M006';
        searchFacilities(initCodeTypes);

        modal.style.display = "flex";
    }

    // [매장 및 시설코드 관리] 메뉴에서 '등록 매장 확인 (readonly)' 으로 사용하는 메소드
    function showModalForDependencyCheck(codeType) {
        initCodeTypes = codeType;
        searchFacilities(codeType, 'all', true);

        const modalGuide = document.querySelector('.modal-guide');
        const searchBar = document.querySelector('.search-bar');
        modalGuide.style.display = codeType ? 'none' : 'block';
        searchBar.style.display = codeType ? 'none' : 'block';

        modal.style.display = "flex";
    }

    /**
     * 매장 및 시설 API
     * codeType : 카테고리
     * approve : 매장 승인 여부 ('Y', 'N', '')
     * allFlag : 전체 검색 여부 (true, false)
     * page : 페이지 번호
    * */
    function searchFacilities(codeType, approve, allFlag, page) {
        let codeTypeValue = codeType == null ? '' : codeType;
        let approveYnValue = approve === 'all' ? '' : 'Y';
        let searchText = document.getElementById('searchInput').value || '';
        if (allFlag) {
            searchText = '';
            document.getElementById('searchInput').value = '';
        }
        let pageNum = page || 1;

        fetch(`/facility/facility/modal-list-content?searchText=` + encodeURIComponent(searchText) + '&codeType=' + codeTypeValue + '&approveYn=' + approveYnValue + '&pageNum=' + pageNum)
            .then(response => response.text())
            .then(data => {
                document.getElementById('modal-table-body').innerHTML = data;

                const rows = document.querySelectorAll('#modal-table-body tr');
                rows.forEach(row => {
                    row.addEventListener('click', function() {
                        const smallCodeType = this.querySelector('td:nth-child(3)')?.innerText;                // 소분류
                        const facilityName  = this.querySelector('td:nth-child(4)')?.innerText;                // 매장 및 시설명
                        const seq           = this.querySelector('td:nth-child(4)')?.getAttribute('data-seq'); // 매장 및 시설명 seq
                        const buildingType  = this.querySelector('td:nth-child(5)')?.innerText;                // 건물
                        const floorInfo     = this.querySelector('td:nth-child(6)')?.innerText;                // 층

                        if (facilityName && seq && buildingType && floorInfo) {
                            selectFacility(smallCodeType, facilityName, buildingType, floorInfo, seq); // 선택된 매장 처리
                        }
                    });
                });
            })
            .catch(error => {
                console.error('Error fetching facility data:', error);
            });

        fetch('/facility/facility/modal-list-paging?searchText=' + encodeURIComponent(searchText) + '&codeType=' + codeTypeValue + '&approveYn=' + approveYnValue + '&pageNum=' + pageNum)
            .then(response => response.text())
            .then(data => {
                document.querySelector('.modal-pagination').innerHTML = data;

                const paginationLinks = document.querySelectorAll('.modal-pagination .page');
                paginationLinks.forEach(link => {
                    link.addEventListener('click', function() {
                        const pageNum = this.getAttribute('data-page-num');
                        searchFacilities(codeType, approve, allFlag, pageNum);      // 페이지 번호로 다시 검색
                    });
                });

                // 현재 페이지 스타일
                updateCurrentPageStyle(pageNum);
            })
            .catch(error => {
                console.error('Error fetching facility data:', error);
            });
    }

    function updateCurrentPageStyle(currentPage) {
        // 기존의 now 제거
        const bef = document.querySelector('.page.now');
        if (bef) bef.classList.remove('now');

        // 현재 페이지 번호에 now 추가
        const after = document.querySelector('td.page:not(.prev):not(.next):not(.now)[data-page-num="' + currentPage + '"]');
        if (after) after.classList.add('now');
    }

    function selectFacility(smallType, facilityName, buildingType, floorInfo, seq) {
        const loc              = document.querySelector('#storeInput input');                                           // 이벤트 장소
        const eventFacilitySeq = document.querySelector('[data-type="facilitySeqEvent"]');                              // 이벤트 매장 및 시설 LANG 테이블 일련번호
        const facility         = document.querySelector('[data-type="facilityName"][data-seq="' + selectedOrder +'"]'); // 쇼핑/맛가이드 매장 및 시설 이름
        const facilitySeq      = document.querySelector('[data-type="facilitySeq"][data-seq="' + selectedOrder +'"]');  // 쇼핑/맛가이드 매장 및 시설 LANG 테이블 일련번호
        if (loc) {
            loc.value              = buildingType + " " + floorInfo;
            eventFacilitySeq.value = seq;
        }
        if (facility) {
            const facilityNamesEl = document.querySelectorAll('[data-type="facilityName"]');
            let   alreadyExist    = false;
            for (let el of facilityNamesEl) {
                if (el.value === facilityName) {
                    alreadyExist = true;
                    break;
                }
            }
            if (alreadyExist) {
                alert("[" + facilityName + "]" + " 이미 등록된 매장입니다");
                return;
            }
            facility.value      = facilityName;
            facilitySeq.value   = seq;
        }
        closeModal();
    }

    function deleteFacility(order) {
        if (order) {
            selectedOrder = order;
        }
        const facility      = document.querySelector('[data-type="facilityName"][data-seq="' + selectedOrder +'"]');   // 쇼핑/맛가이드 매장 및 시설 이름
        const facilitySeq   = document.querySelector('[data-type="facilitySeq"][data-seq="' + selectedOrder +'"]');    // 쇼핑/맛가이드 매장 및 시설 LANG 테이블 일련번호

        if (facility && facilitySeq) {
            facility.value      = '';
            facilitySeq.value   = '';
        }
    }
</script>