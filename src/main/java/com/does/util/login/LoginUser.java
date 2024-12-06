package com.does.util.login;

public interface LoginUser {


	/**
	 * 미승인 계정 여부        (AdminStatus.R)
	 */
	boolean		isReady();

	/**
	 * 승인 상태 여부         (AdminStatus.Y)
	 */
	boolean		isUse();

	/**
	 * 잠금 상태 여부         (AdminStatus.N)
	 */
	boolean		isLocked();

	/**
	 * 탈퇴 상태 여부         (AdminStatus.W)
	 */
	boolean		isWithdraw();

	/**
	 * 개인정보 삭제 상태 여부 (AdminStatus.D)
	 */
	boolean		isDeleted();



	/////////////////////////////////////////////////

//	/**
//	 * 만료된 계정인지 여부
//	 */
//	boolean		isExpired();

	/**
	 * 계정이 임시 미사용 상태인지 여부
	 */
	boolean		isIdle();


	/**
	 * 임시 계정인지 여부
	 */
	boolean		isTemporal();

//	/**
//	 * 로그인 실패로, 접근이 잠시 차단된 상태인지 여부
//	 */
//	boolean		isAccessLimited();
//	Date		getAccessLimitDate();

	/**
	 * 비밀번호가 만료되었는지 여부
	 */
	boolean		isPwExpired();

	/**
	 * 현재 다중로그인 상태인지 여부
	 */
	boolean		isMultiLogin();

	/**
	 * Empty Object 인지 아닌지 여부
	 */
	boolean		isEmpty();

	/**
	 * 주어진 메뉴ID 에 해당하는 메뉴에 접근권한이 있는지 여부
	 */
	@Deprecated
	boolean		hasAuth(String menuId);		// 접근권한 목록이 Admin 객체에 있을 때 사용했던 코드.

//	/**
//	 * 이 계정에 허용된 IP 목록을 배열로 반환
//	 */
//	String[]	getAllowIps();

}