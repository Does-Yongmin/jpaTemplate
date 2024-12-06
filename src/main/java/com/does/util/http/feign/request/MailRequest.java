package com.does.util.http.feign.request;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)  // Allows Only Non-Null field To Json Serialization
public class MailRequest {

    /**
     * 롯데 메일 발송 API 요청 클래스
     *
     * URI : /sendMail
     * METHOD : POST
     */

    private String key;         // (필수) API KEY
    @Builder.Default private String sender     = "lwt_noreply@lotte.net";   // (필수) 발신자(@lotte.net 도메인만 가능), 홈페이지 경우 lwt_noreply@lotten.net 일반적으로 사용
    @Builder.Default private String senderName = "롯데월드몰";                // 보낼 이름, 파라미터 없으면 디폴트 '롯데월드몰'
    private String receiver;    // (필수) 수신자
    private String title;       // (필수) 메일 제목
    private String contents;    // (필수) 메일 내용, 대체로 html 양식

}
