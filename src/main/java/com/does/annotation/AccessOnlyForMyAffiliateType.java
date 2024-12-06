package com.does.annotation;

import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface AccessOnlyForMyAffiliateType {

	/**
	 * 자신의 운영사 데이터만 접근 가능하도록 제한하기 위한 어노테이션
	 */

	Class value(); // 현재 검색하는 search 의 VO 입력
}