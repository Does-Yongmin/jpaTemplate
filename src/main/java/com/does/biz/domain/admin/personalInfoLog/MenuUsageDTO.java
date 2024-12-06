package com.does.biz.domain.admin.personalInfoLog;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor  // 빌더 패턴 mybatis 에서 값 받을때 필수
@AllArgsConstructor
public class MenuUsageDTO {

	/**
	 * 월별 메뉴 버튼 사용 현황
	 */

	// DB 조회시 가져오는 데이터
	private String adminId;     // 관리자 id
	private String menuId;      // 메뉴 id
	private Long accessCount;   // 조회수


	// view 에서 사용하기 위해 Service 에서 추가로 조회하는 데이터
	private String email;       // 관리자 이메일
	private String adminName;     // 관리자 이름
	private String menuName;    // 화면명

}
