package com.does.config.resource;

import com.does.component.EnvChecker;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@Profile({"dev", "prod"})
public class LotteResourceConfig implements WebMvcConfigurer {

	/**
	 * 이미지 경로 요청은 모두 was 에서 처리
	 *
	 * dev : dev was 쪽에 이미지 업로드 되어 있음
	 * prod : prod was 에 NAS 가 마운트 되어 있음
	 */


	@Value("${upload.root.path}")
	private String rootPath;

	@Value("${upload.root.uri}")
	private String rootUri;

	private final String devPrefix = "D:/";
	private final String prodPrefix = "S:/";

	private final String asIsFactoryUri = "/datas/factory";
	private final String asIsKioskUri = "/datas/subsidiary";

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler(rootUri + "/**")
				.addResourceLocations("file:" + rootPath + "/");

		// dev 환경 경로로 기본 세팅
		String asIsFactoryPath = devPrefix + asIsFactoryUri;
		String asIsKioskPath = devPrefix + asIsKioskUri;

		if(EnvChecker.isProd()){ // 운영 환경일때
			asIsFactoryPath = prodPrefix + asIsFactoryUri;
			asIsKioskPath = prodPrefix + asIsKioskUri;
		}

		registry.addResourceHandler(asIsFactoryUri + "/**")
				.addResourceLocations("file:" + asIsFactoryPath + "/");

		registry.addResourceHandler(asIsKioskUri + "/**")
				.addResourceLocations("file:" + asIsKioskPath + "/");
	}
}
