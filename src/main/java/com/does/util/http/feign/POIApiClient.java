package com.does.util.http.feign;

import com.does.config.POIFeignConfig;
import com.does.util.http.feign.request.POIUpdateRequest;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;


/**
 * Dabeeo POI API FeignClient Interface
 */
@FeignClient(name = "poiApiClient", url = "https://poi-api4.dabeeostudio.com", configuration = POIFeignConfig.class)
public interface POIApiClient {

    // POI 층별 조회 API
    @GetMapping(value = "/v1/poi/{floodId}/{page}",
            consumes = "application/json; charset=UTF-8",
            produces = "application/json; charset=UTF-8")
    JsonNode getPOIListByFloorIdAndPage(@PathVariable("floodId") String floodId,
                                        @PathVariable("page") int page,
                                        @RequestParam(required = false, value = "limit", defaultValue = "10") Integer limit,
                                        @RequestParam(required = false, value = "contentName") String contentName,
                                        @RequestParam(required = false, value = "categories") String categories);

    // POI 수정 API (주의 : 운영 환경일 때만, 실제 다비오 POI 를 수정하도록)
    @PutMapping(value = "/v1/poi",
            consumes = "application/json; charset=UTF-8",
            produces = "application/json; charset=UTF-8")
    JsonNode updatePOI(@RequestBody POIUpdateRequest request);
}
