package com.does.util.http.feign;

import com.does.config.FeignConfig;
import com.does.util.http.feign.request.MailRequest;
import com.does.util.http.feign.request.MessageRequest;
import com.does.util.http.feign.response.LotteResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


/**
 * LWT Server FeignClient Interface
 */
@FeignClient(name = "apiClient", url = "${lwt.url}", configuration = FeignConfig.class)
public interface LotteApiClient {

    /**
     * @consumes Client -> Server 요청 본문 데이터 형식 지정
     * @produces Server -> Client 전송 응답 데이터 형식 지정
     *
     */

    // 메일 발송 API
    @PostMapping(value = "/sendMail",
            consumes = "application/json; charset=UTF-8",
            produces = "application/json; charset=UTF-8")
    LotteResponse sendMail(@RequestBody MailRequest request);

    // 카카오 알림톡 발송 API
    @PostMapping(value = "/sendMessage",
            consumes = "application/json; charset=UTF-8",
            produces = "application/json; charset=UTF-8")
    LotteResponse sendMessage(@RequestBody MessageRequest request);
}
