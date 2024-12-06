package com.does.config;

import feign.Request;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
@Slf4j
public class FeignConfig {

    /**
     * Feign 클라이언트 요청의 타임아웃 설정을 구성하는 {@link Request.Options}의 새 인스턴스 생성
     * ConnectTimeout 서버 연결 되기까지 제한시간
     * ReadTimeout    서버 응답 받기까지 제한시간
     * 이 설정에 따라 {@link feign.FeignException} 예외 발생.
     */
    @Bean(name = "defaultRequestInterceptor")
    public Request.Options requestOptions() {
        return new Request.Options(3000, TimeUnit.MILLISECONDS, 3000, TimeUnit.MILLISECONDS, true);
    }
}
