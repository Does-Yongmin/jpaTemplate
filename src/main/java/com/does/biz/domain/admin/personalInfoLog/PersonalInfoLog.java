package com.does.biz.domain.admin.personalInfoLog;

import com.does.biz.domain.Base;
import lombok.*;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
@Builder
public class PersonalInfoLog extends Base {

	/**
	 * 개인정보에 접근 하는 경우 별도 테이블에 로그 적재하기 위한 
	 */

	@Getter @RequiredArgsConstructor
	public enum AccessType{
		NONE(""), // default
		SELECT_LIST("리스트 페이지 조회"),
		SELECT_VIEW("상세 페이지 조회");

		private final String value;
	}

	private String sessionId;		    // 작업자의 세션 ID
	private String creatorId;           // 작업자 계정 ID
	private String targetId;            // 조회 대상 ID (상세 페이지 조회시 저장)
	private String menuId;              // 접근 메뉴 ID
	private AccessType accessType;      // 접근 유형
	private String requestUrl;          // 접근 화면 URL
	private String targetTb;            // 조회 대상 테이블



	// 조회시 사용하는 변수
	private List<String> menuIdList;     // 개인정보 메뉴에 대한 쿼리 조회할 때 사용할 개인정보 메뉴 ID 값

}
