package com.does.util.http;

import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.Map;

public class ApiUtil {

	/*
	 * 외부 API 호출시 사용하는 유틸리티 클래스
	 */

	private static final WebClient webClient = WebClient.builder().build();

	/**
	 * GET 요청을 보내고 결과를 clazz 타입으로 반환
	 * @param uri
	 * @param clazz
	 * @return
	 * @param <T>
	 */
	public static <T> T get(String uri, Class<T> clazz) {
		return webClient.get()
				.uri(uri)
				.retrieve()
				.bodyToMono(clazz)
				.block();
	}

	/**
	 * GET 요청을 보내고 결과를 clazz 타입 Mono 로 반환
	 * @param uri
	 * @param clazz
	 * @param <T>
	 */
	public static <T> Mono<T> getAsync(String uri, Class<T> clazz) {
		return webClient.get()
				.uri(uri)
				.retrieve()
				.bodyToMono(clazz);
	}



	public static <T> T post(String url, Map<String, Object> body, Class<T> clazz){
		return null;
	}

	public static <T> Mono<T> postAsync(String url, Map<String, Object> body, Class<T> clazz){
		return null;
	}
}
