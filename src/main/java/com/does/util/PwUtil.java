package com.does.util;

import com.does.exception.validation.ValidExceptionBack;

import java.util.Calendar;
import java.util.Date;

public class PwUtil extends PwdRule{

	/**
	 * 비밀번호가 연속된 문자로 이루어져 있는치 체크
	 */
	public static void checkSequential(String password){
		if(hasSequentialWord(password, 3)) throw new ValidExceptionBack("비밀번호 문자 구성 제약조건을 확인해주세요.");
	}

	/**
	 * 비밀번호가 동일 문자가 연속되어 있는지 체크
	 */
	public static void checkRepeated(String password){
		if(hasRepeatedChar(password, 3)) throw new ValidExceptionBack("비밀번호 문자 구성 제약조건을 확인해주세요.");
	}


	/**
	 * 주어진 날짜 이후 지정된 일수가 경과했는지 확인하여 비밀번호 만료 여부를 반환
	 */
	public static boolean isPwExpiredAfterDays(Date lastPwChangeDate, int days)		{
		boolean expired = false;

		if( lastPwChangeDate != null ) {
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DAY_OF_MONTH, -days);
			Date daysAgo	= cal.getTime();			// days 일 전 날짜 정보.
			expired = lastPwChangeDate.before(daysAgo);	// 마지막 비번 변경일이 days 일 이전이면 true
		}
		return expired;
	}


	/**
	 * 연속된 문자가 오름차순 또는 내림차순으로 N개 이상인지 확인
	 */
	public static boolean hasSequentialWord(String password, int N) {
		int o = 0;
		int d = 0;
		int p = 0;
		int n = 0;

		for(int i=0; i< password.length(); i++) {
			char tempVal = password.charAt(i);
			if(i > 0 && (p = o - tempVal) > -2 && (n = p == d ? n + 1 :0) > N -3) {
				return true;
			}
			d = p;
			o = tempVal;
		}
		return false;
	}

	/**
	 * 동일한 문자가 연속으로 N번 이상 나타나는지 확인
	 */
	public static boolean hasRepeatedChar(String password, int N) {
		int repeatCount = 1;

		for (int i = 0; i < password.length() - 1; i++) {
			// 현재 문자와 다음 문자가 같은지 확인
			if (password.charAt(i) == password.charAt(i + 1)) {
				repeatCount++;

				// 동일한 문자가 N번 이상 연속되면 true 반환
				if (repeatCount >= N) {
					return true;
				}
			} else {
				// 반복이 끊기면 카운트 초기화
				repeatCount = 1;
			}
		}
		return false;
	}
}
