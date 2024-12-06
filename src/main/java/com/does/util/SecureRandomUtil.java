package com.does.util;

import java.security.SecureRandom;

public class SecureRandomUtil {

	/**
	 * 난수 생성시 사용하는 Util
	 */

	private static SecureRandom random = new SecureRandom();
	// 생성자 사용 방지
	private SecureRandomUtil(){}


	// Random 클래스의 nextInt 사용 대체
	public static int nextInt()         {   return random.nextInt();        }
	public static int nextInt(int bound){	return random.nextInt(bound);   }



	/*
	 * 인증번호 생성 (6자리)
	 */
	public static String createAuthNum(){
		// 6자리 인증번호 생성
		int min = 0;
		int max = 999999;

		int authNum = random.nextInt(max - min + 1) + min;

		// 6자리로 포맷팅
		return String.format("%06d", authNum);
	}


	/*
	 * 10자리의 영문 대소문자, 숫자 단어를 생성하여 반환
	 */
	public static String createRandomWord(int length){
		final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

		StringBuilder word = new StringBuilder(length);

		for (int i = 0; i < length; i++) {
			int index = random.nextInt(CHARACTERS.length());
			word.append(CHARACTERS.charAt(index));
		}

		return word.toString();
	}

}
