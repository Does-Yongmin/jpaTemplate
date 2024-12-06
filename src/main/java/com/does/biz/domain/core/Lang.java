package com.does.biz.domain.core;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.Arrays;
import java.util.Locale;
import java.util.stream.Stream;

@Getter
@RequiredArgsConstructor
public enum Lang {
	KO("국문", "ko"),
	EN("영문", "en"),
	JA("일문", "ja"),
	ZH("중문", "zh")
	;

	final String nameKo;      // 관리자에서 Lang enum 을 국문형식으로 보여주기 위한 함수.
	final String languageCode;
	Locale locale;
	String prefix;            // URL 에서 언어별 prefix 값 호출을 통일하기 위한 함수.

	Lang(String nameKo, String languageCode, String prefix) {
		this.nameKo = nameKo;
		this.languageCode = languageCode;
		this.locale = new Locale(languageCode);
		this.prefix = prefix;
	}

	// Lang enum 을 key mapper 로 사용하기 위한 함수
	public Lang getThis() {
		return this;
	}

	public static Stream<Lang> stream() {
		return Arrays.stream(Lang.values());
	}
}