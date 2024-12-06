package com.does.util.http.feign.response;

import lombok.Getter;

@Getter
public class LotteResponse {

    /**
     * 롯데 API 공통 응답
     */

    private boolean success;    // (필수) true, false
    private String message;     // (필수) 안내 메시지
    private Object data;        // 데이터가 있는 경우만
}
