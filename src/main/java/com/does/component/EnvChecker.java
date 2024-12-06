package com.does.component;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class EnvChecker {

	@Value("${spring.profiles.active}")
	private String activeProfile;
	private static String staticActiveProfile;

	@PostConstruct
	public void init() {
		staticActiveProfile = activeProfile;
	}

	public static boolean isDoesLocal(){
		return isDoes() || isLocal();
	}

	/////

	public static boolean isLocal() {
		return "local".equals(staticActiveProfile);
	}

	public static boolean isDoes(){
		return "does".equals(staticActiveProfile);
	}

	public static boolean isDev() {
		return "dev".equals(staticActiveProfile);
	}

	public static boolean isProd() {
		return "prod".equals(staticActiveProfile);
	}
}
