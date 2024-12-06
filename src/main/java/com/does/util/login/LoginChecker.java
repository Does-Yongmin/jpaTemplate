package com.does.util.login;

import com.does.exception.validation.ValidException;
import com.does.exception.validation.ValidExceptionRoot;

import java.text.SimpleDateFormat;

public class LoginChecker {

	private static final SimpleDateFormat ymdhms = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");

	public static void checkAdminStatus(LoginUser lu) throws ValidException{
		if(lu.isUse()) return;
		checkReady(lu);             // 계정 미승인 여부 체크
		checkWithdraw(lu);          // 계정 탈퇴 여부 체크
		checkDeleted(lu);           // 계정 개인정보 삭제 여부 체크
	}

	/**
	 * 계정이 미승인 상태인지 확인
	 */
	public static void checkReady			(LoginUser lu) throws ValidExceptionRoot {
		if( lu.isReady() )			throw new ValidExceptionRoot("미승인 계정입니다.\\r\\n관리자 승인후 접근 가능합니다.");
	}
//	/**
//	 * 계정이 잠겨있는지 확인
//	 */
//	public static void checkLocked			(LoginUser lu) throws ValidExceptionRoot {
//		if( lu.isLocked() )			throw new ValidExceptionRoot("잠겨있는 계정입니다.\\r\\n관리자에게 문의해주세요.");
//	}

	/**
	 * 계정이 탈퇴된 상태인지 확인
	 */
	public static void checkWithdraw		(LoginUser lu) throws ValidExceptionRoot {
		if( lu.isWithdraw() )		throw new ValidExceptionRoot("탈퇴된 계정으로 로그인 불가합니다.");
	}
	/**
	 * 계정이 개인정보 삭제된 상태인지 확인
	 */
	public static void checkDeleted	(LoginUser lu) throws ValidExceptionRoot {
		if( lu.isDeleted() )	throw new ValidExceptionRoot("탈퇴된 계정(개인정보 삭제)으로 로그인 불가합니다.");
	}




	////////////////////////////////////////////////////////////////////////////

	/**
	 * 장기 미사용으로 중지된 계정인지 확인.<br/><br/>
	 * "3개월 이상 접속하지 않아 계정사용이 중지되었습니다.<br/>
	 * 관리자에게 문의해주세요."
	 */
	public static void checkIdleOver3Month	(LoginUser lu) throws ValidExceptionRoot {
		if( lu.isIdle() )			throw new ValidExceptionRoot("3개월 이상 접속하지 않아 계정사용이 중지되었습니다.\\r\\n시스템 담당자에게 문의해주세요.");
	}

	/**
	 * 비밀번호 초기화 등으로 인한 임시상태의 계정인지 확인.<br/><br/>
	 * "비밀번호를 변경해주세요."
	 */
	public static void checkTemporal		(LoginUser lu) throws ValidException {
		if( lu.isTemporal() )		throw new ValidException("비밀번호를 변경해주세요.", "/pw/change");
	}

//	/**
//	 * 로그인 연속 실패로, 접속이 임시 차단된 상태인지 확인.<br/><br/>
//	 * "로그인 연속 실패로, {연월일시} 까지 로그인할 수 없습니다."
//	 */
//	public static void checkAccessLimited	(LoginUser lu) throws ValidException {
//		if( lu.isAccessLimited() )	throw new ValidExceptionRoot("로그인 연속 실패로,\\r\\n"+ ymdhms.format(lu.getAccessLimitDate()) +" 까지 로그인할 수 없습니다.");
//	}
	/**
	 * 계정의 비밀번호가 만료되었는지 확인
	 */
	public static void checkPwExpired	(LoginUser lu) throws ValidException {
		if( lu.isPwExpired() )		throw new ValidException("장기간 비밀번호를 변경하지 않고 동일한 비밀번호를 사용 중입니다.\\r\\n안전한 사용을 위해 비밀번호를 변경해 주세요.", "/pw/change");
	}
	/**
	 * 다중 로그인상태인지 확인.<br/><br/>
	 * "다른 기기에서 로그인하여, 현재 기기에서 로그아웃됩니다."
	 */
	public static void checkMultiLogin		(LoginUser lu) throws ValidException {
		if( lu.isMultiLogin() )		throw new ValidException("다른 기기에서 로그인하여, 현재 기기에서 로그아웃됩니다.", "/logout");
	}

}