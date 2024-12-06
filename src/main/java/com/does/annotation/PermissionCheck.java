package com.does.annotation;

import java.lang.annotation.*;

/**
 * value 종류
 * - LIST
 * - VIEW
 * - WRITE
 * - UPDATE
 * - SAVE ( 일련번호 seq 에 따라 ) WRITE 또는 UPDATE 로 구분됨
 * - DELETE
 * - APPROVE
 */

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface PermissionCheck {

	String value() default "";		// 접속을 허용할 최소 권한

	String of() default "";			// 하위 게시판의 경우 상위 게시판의 권한을 따라갈 수 있게 상위게시판의 URL 을 입력.
}