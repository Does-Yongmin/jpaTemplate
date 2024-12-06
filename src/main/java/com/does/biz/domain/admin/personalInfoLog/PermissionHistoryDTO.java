package com.does.biz.domain.admin.personalInfoLog;

import com.does.biz.domain.Base;
import com.does.util.StrUtil;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Data
@Builder
@NoArgsConstructor  // 빌더 패턴 mybatis 에서 값 받을때 필수
@AllArgsConstructor
public class PermissionHistoryDTO {

	/**
	 * 개인정보 관리자 권한 이력
	 */

	// DB 조회시 가져오는 데이터
	private String adminId;             // 권한이 변경된 관리자 ID
	private String authorizerId;        // 권한 부여자 ID
	private Date authorizationDate;     // 권한 부여일
	private String permBefore;          // 수정전 권한
	private String permAfter;           // 수정후 권한


	// view 에서 사용하기 위해 Service 에서 추가로 조회하는 데이터
	private String email;               // 관리자 이메일
	private String adminName;             // 관리자 이름
	private String authorizerEmail;     // 권한 부여자 이메일
	private String authorizerNm;        // 권한 이름


	//////////////////////////////////////////////////

	public String getAuthorizationDatePretty(){
		return Base.ymdhms(authorizationDate);
	}

	public String getPermBeforeRemoveDivTags(){
		return removeDivTags(permBefore);
	}
	public String getPermAfterRemoveDivTags(){
		return removeDivTags(permAfter);
	}

	private String removeDivTags(String permStringWithDiv){
		if(StrUtil.isEmpty(permStringWithDiv)) return "";

		Pattern pattern = Pattern.compile("<div>(.*?)</div>");
		Matcher matcher = pattern.matcher(permStringWithDiv);

		List<String> result = new ArrayList<>();

		while (matcher.find()){
			result.add(matcher.group(1));
		}

		return String.join(", ", result);
	}


}
