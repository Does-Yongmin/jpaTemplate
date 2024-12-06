package com.does.config;

import com.does.crypt.SeedCBC;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.io.IOException;

@Slf4j
@Configuration
public class EncryptConfig {

	// 암호화 미사용. 비밀번호만 해싱해서 암호화함
	@PostConstruct
	public void init() throws IOException {
		final String key	= "97f0d456ef6f4fb1";
		final String iv		= "91a42c8e855e422d";
		SeedCBC.init(key, iv);
		log.info("Custom Configuration :: Filter :: Encryptor set");
	}

	/**
	 * 프로젝트마다 랜덤한 key와 iv 를 만들기 위한 함수.<br/>
	 * 프로젝트마다 최초에 key 용으로 한번, iv 용으로 한번씩 호출하면 됨.<br/>
	 * 각 프로젝트마다 최초에 한번씩만 호출하고나면 더이상 사용할 일 없음.<br/>
	 */
//	private static final String makeNewRandomString() {
//		return UUID.randomUUID().toString().replace("-","").substring(0,16);
//	}
//	public static void main(String[] args) {
//		String key = makeNewRandomString();	// key 생성
//		String iv = makeNewRandomString();	// iv 생성
//
//		System.out.println("key = "+ key);	// key 확인
//		System.out.println("iv = "+ iv);	// iv 확인
//
//		SeedCBC.init(key, iv);
//		System.out.println("이름 = "+ SeedCBC.encrypt("최고관리자"));		// 이번에 생성한 key/iv 로 암호화한 결과
//		System.out.println("연락처1 = "+ SeedCBC.encrypt("01000000000"));	// 이번에 생성한 key/iv 로 암호화한 결과
//		System.out.println("연락처2 = "+ SeedCBC.encrypt("02000000"));		// 이번에 생성한 key/iv 로 암호화한 결과
//		System.out.println("이메일 = "+ SeedCBC.encrypt("wlgns@does.kr"));	// 이번에 생성한 key/iv 로 암호화한 결과
//		wlgns();
//	}
//	private static void wlgns() {
//		final String key	= "97f0d456ef6f4fb1";
//		final String iv		= "91a42c8e855e422d";
//		SeedCBC.init(key, iv);
//
//		System.out.println("이름 = "+ SeedCBC.encrypt("송지훈"));		// 이번에 생성한 key/iv 로 암호화한 결과
//		System.out.println("연락처1 = "+ SeedCBC.encrypt("01000000000"));	// 이번에 생성한 key/iv 로 암호화한 결과
//		System.out.println("연락처2 = "+ SeedCBC.encrypt("02000000"));		// 이번에 생성한 key/iv 로 암호화한 결과
//		System.out.println("이메일 = "+ SeedCBC.encrypt("wlgns@does.kr"));	// 이번에 생성한 key/iv 로 암호화한 결과
//		System.out.println("암호 = "+ SHA256.encrypt("does7878!@#"));	// 이번에 생성한 key/iv 로 암호화한 결과
//	}
}