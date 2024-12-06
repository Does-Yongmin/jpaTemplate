package com.does.biz.domain.admin;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum AdminStatus {

	/**
	 * 관리자 계정 상태
	 */
	R("승인 대기"),     // 회원가입 직후로 로그인 불가한 상태(관리자 승인 필요)
	Y("승인"),
	N("계정 잠금"),
	W("탈퇴"),         // 회원탈퇴로 'W' 로 변경된 상태
	D("개인정보 삭제");  // 개인정보 컬럼 모두 '-' 로 변경된 상태

	final String name;

}
