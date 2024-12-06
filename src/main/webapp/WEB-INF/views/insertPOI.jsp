<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head lang="ko">
    <%@ include file="/include/head.jsp" %>
    <spring:eval var="clientId" expression="@environment.getProperty('map.dabeeo.client.id')" />
    <spring:eval var="clientSecret" expression="@environment.getProperty('map.dabeeo.client.secret')" />
    <spring:eval var="serverCode" expression="@environment.getProperty('map.dabeeo.server.code')" />
    <link rel="stylesheet" type="text/css" href="<c:out value="${cPath}"/>/assets/css/contentPage.css"/>
    <script type="text/javascript" src="https://api-assets.dabeeomaps.com/upload/library/dabeeomaps-4.0-latest.js"></script>
</head>
<body>
    다비오 Insert 를 위한 임시 페이지
</body>

<script>
    // 다비오 맵 관련 인스턴스 (어플리케이션 기준 반드시 1번만 호출해서 사용)
    const dabeeoMaps = new dabeeo.Maps();

    // 다비오 맵 API 인증
    const clientId = '${clientId}';
    const clientSecret = '${clientSecret}';
    const serverCode = '${serverCode}';

    // 다비오 맵 관련
    let mapContainer = document.getElementById('map');
    let mapOption;
    let mapData;
    let map;

    // POI 관련
    let poiMap = new Map();													// key : title, value : { id, position, categoryCode, floorId, floorName }
    let floorMap = new Map();												// key : id, value : { title, lang, defaultYn, buildingId }
    let defaultFloorId = "cca30325-d77b-414f-b984-ba15d5620261";
    let nowFloorId = null;
    let categoryShopCode = 'ceaab9d1-8c88-42bf-867b-a4fcd57f5a76';			// 일반매장
    let categoryFacilitiesCode = 'c194a252-f85b-4cb5-b92a-51d5d737705b';	// 편의시설
    let categoryEntranceCode = 'befad429-05fb-4a57-ab24-d3e346af8c4b';		// 입구

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // 메인
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    document.addEventListener('DOMContentLoaded', function() {
        dabeeoMapInit();
    });

    async function getMapData() {
        mapData = await dabeeoMaps.getMapData({
            clientId: clientId,
            clientSecret: clientSecret,
            serverType: serverCode
        });
    }

    async function dabeeoMapInit() {
        await getMapData();				// 맵 생성 및 기본 설정
        await initFloors();				// 모든 층 정보 저장
        nowFloorId = defaultFloorId;
        await initPOI(nowFloorId); 		// 모든 POI 정보 저장
    }

    // 모든 층 정보 가져오기
    async function initFloors() {
        let floors = mapData.dataFloor.getFloors();
        for (let i = 0; i < floors.length; i++) {
            let floor = floors[i];
            if (floor.defaultYn === true) {
                defaultFloorId = floor.id;
            }

            // 각 층의 이름 배열을 순회하며 이름과 언어를 매핑
            for (let j = 0; j < floor.name.length; j++) {
                let text = floor.name[j].text;
                let lang = floor.name[j].lang;

                if (!floorMap[floor.id]) {
                    floorMap[floor.id] = {
                        title: text,
                        lang: lang,
                        defaultYn: floor.defaultYn,
                        buildingId: floor.buildingId
                    };
                }
            }
        }
    }

    function sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    // POI 정보 가져오기
    async function initPOI(nowFloorId) {
        let pois = mapData.dataPoi.getPois();						// 지도의 모든 POI 정보 가져오기

        console.log(pois);
        console.log("poi insert start...")

        // POI 정보 저장
        for (const poi of pois) {
            let category = Array.isArray(poi.categoryCode) && poi.categoryCode.length > 0 ? poi.categoryCode[0] : null;
            await savePOI(poi, category);
            await sleep(50);
        }

        console.log("all poi inserted.")
    }

    async function savePOI(poi, category) {
        let poiId = poi.id;
        let categoryId = category;
        let floorId = poi.floorId;

        let name = poi.title;
        let nameEn = '';
        let nameJp = '';
        let nameCn = '';
        let displayType = poi.displayType;
        let floorName = floorMap[poi.floorId].title;

        let xCoord = poi.position.x.toString();
        let yCoord = poi.position.y.toString();

        poi.titleByLanguages.forEach(item => {
            if (item.lang === 'ko') {
                name = item.text;
            } else if (item.lang === 'en') {
                nameEn = item.text;
            } else if (item.lang === 'ja') {
                nameJp = item.text;
            } else if (item.lang === 'zh') {
                nameCn = item.text;
            }
        });

        // Create POI object
        let poiObject = {
            poiId: poiId,
            categoryId: categoryId,
            floorId: floorId,

            name: name,
            nameEn: nameEn,
            nameJp: nameJp,
            nameCn: nameCn,
            displayType: displayType,
            floorName: floorName,
            xcoord: xCoord,
            ycoord: yCoord
        };

        // Send the POI data to the server
        await sendPOIData(poiObject);
    }

    // Send POI data via AJAX
    async function sendPOIData(poiObject) {
        fetch('/poi/save', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(poiObject),
        })
            .then(response => {
                if (response.ok) {
                    // alert('POI saved successfully');
                } else {
                    alert('Failed to save POI');
                }
            })
            .catch(error => {
                console.error('Error saving POI:', error);
            });
    }

</script>

</html>
