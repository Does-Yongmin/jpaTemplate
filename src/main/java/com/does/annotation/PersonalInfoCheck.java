package com.does.annotation;

import com.does.biz.primary.domain.system.personalInfoLog.PersonalInfoLogVO;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface PersonalInfoCheck {

	PersonalInfoLogVO.AccessType accessType() default PersonalInfoLogVO.AccessType.NONE;  // 접근 유형
	String targetTb() default "";		    // 조회 대상 테이블

	String attributeName() default "";      // 조회한 데이터를 model 에서 꺼내올 때 사용할 key 값
}