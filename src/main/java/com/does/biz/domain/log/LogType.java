package com.does.biz.domain.log;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter @RequiredArgsConstructor
public enum LogType {

	// AS-IS MGRACT 하위 코드
	SIGNUP			("회원가입"			                    , LogGroup.ADMIN_ACTION,false),   // SIGNUP
//	LOGIN_TRY		("로그인 시도"		                    , LogGroup.ADMIN_ACTION,false),   // TLOGIN
	LOGIN_SUCCESS	("로그인 성공"		                    , LogGroup.ADMIN_ACTION,false),   // SLOGIN
	LOGIN_FAIL		("로그인 실패"		                    , LogGroup.ADMIN_ACTION,false),   // FLOGIN
	PW_FIND		    ("비밀번호 찾기"	                    , LogGroup.ADMIN_ACTION,false),   // FINDPW
	PW_CHANGE		("비밀번호 수정"	                    , LogGroup.ADMIN_ACTION,false),   // UPDTPW
	PW_DEFER        ("비밀번호 변경 미룸"                    , LogGroup.ADMIN_ACTION, false),
	APPROVAL		("본인 인증 성공 (인증번호 일치)"          , LogGroup.ADMIN_ACTION,false),   // AUTHEN
	FAIL_APPROVAL   ("본인 인증 실패 (인증번호 불일치)"         , LogGroup.ADMIN_ACTION, false),
	LOCK_PW5	    ("비밀번호 5회 오류 계정 잠금"	        , LogGroup.ADMIN_ACTION,false),   // DAP001
	LOCK_IDLE		("장기 휴면 계정 잠금"	                , LogGroup.ADMIN_ACTION,false),   // DAP002
	UNLOCK          ("계정 잠금 해제"                        , LogGroup.ADMIN_ACTION, false),
	WITHDRAW		("회원탈퇴"		                        , LogGroup.ADMIN_ACTION,false),   // WITDRW
	FAIL_UNLOCK		("본인 인증 실패 (계정 잠금 해제 시도)"    , LogGroup.ADMIN_ACTION,false),   // FALAUTH
	LOGOUT          ("로그아웃"                             , LogGroup.ADMIN_ACTION, false),


	// AS-IS USRCHG 하위 코드
	WITHDRAW_BY_ADMIN	("관리자에 의한 탈퇴"			, LogGroup.ADMIN_CHANGE,false), // WITHDW
	APPROVAL_BY_ADMIN   ("관리자에 의한 승인"			, LogGroup.ADMIN_CHANGE,false), // APR001
	LOCKED_BY_ADMIN	    ("관리자에 의한 계정 잠금"	    , LogGroup.ADMIN_CHANGE,false), // DAP003
	UNLOCKED_BY_ADMIN   ("관리자에 의한 계정 잠금 해제"    , LogGroup.ADMIN_CHANGE, false),
	LOCKED_BY_SYSTEM    ("배치프로세스에 의한 계정 잠금"	, LogGroup.ADMIN_CHANGE,false), // DAP004
	WITHDRAW_BY_SYSTEM  ("배치프로세스에 의한 탈퇴"	    , LogGroup.ADMIN_CHANGE,false), // DAP005
	DELETE_BY_SYSTEM    ("배치프로세스에 의한 개인정보 삭제", LogGroup.ADMIN_CHANGE, false), // DAP006
	AUTH_GRANT		    ("권한 부여"	                , LogGroup.ADMIN_CHANGE,false), // PUTAUTH
	AUTH_REVOKE		    ("권한 삭제"	                , LogGroup.ADMIN_CHANGE,false), // DELAUTH
	PW_RESET_BY_ADMIN   ("관리자에 의한 비밀번호 초기화"	, LogGroup.ADMIN_CHANGE,false), // INITPW
	GROUP_CREATE        ("권한 그룹 생성"                , LogGroup.ADMIN_CHANGE, false),
	GROUP_MODIFY        ("권한 그룹 수정"                , LogGroup.ADMIN_CHANGE, false),
	GROUP_DELETE        ("권한 그룹 삭제"                , LogGroup.ADMIN_CHANGE, false)
	;

	final String	name;	// 이름
	final LogGroup	group;	// 로그 타입이 속한 그룹 ( MGRACT : 관리자 활동, USRCHG : 관리자 변경 )
	final boolean	end;	// select box 에서 밑줄그을 곳인지 표시
}