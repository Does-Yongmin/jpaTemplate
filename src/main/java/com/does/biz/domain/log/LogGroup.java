package com.does.biz.domain.log;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter @RequiredArgsConstructor
public enum LogGroup {

	ADMIN_ACTION	("관리자 활동"), // MGRACT : 관리자 활동에 의해 쌓이는 로그 그룹
	ADMIN_CHANGE	("관리자 변경"), // USRCHG : 관리자/시스템에 의해 상태가 변경될 때 쌓이는 로그 그룹
	;

	final String	name;	// 이름
}