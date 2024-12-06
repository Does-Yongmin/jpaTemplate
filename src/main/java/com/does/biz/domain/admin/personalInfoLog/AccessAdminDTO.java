package com.does.biz.domain.admin.personalInfoLog;

import com.does.biz.domain.Base;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@Builder
@NoArgsConstructor  // 빌더 패턴 mybatis 에서 값 받을때 필수
@AllArgsConstructor
public class AccessAdminDTO{


	/**
	 * 개인정보 관리자 리스트
	 */

	// DB 조회시 가져오는 데이터
	private String adminId;             // 관리자 id
	private String groupName;           // 권한 그룹명
	private Date lastLoginDate;         // 마지막 로그인
	private Date authorizationDate;   // 권한 부여일


	// view 에서 사용하기 위해 Service 단에서 추가 조회 하는 데이터
	private String email;               // 관리자 이메일
	private String adminName;             // 관리자 이름


	//////////////////////////////////////////////////

	public String getAuthorizationDatePretty() {return Base.ymdhms(authorizationDate);}
	public String getLastLoginDatePretty(){
		return Base.ymdhms(lastLoginDate);
	}
}
