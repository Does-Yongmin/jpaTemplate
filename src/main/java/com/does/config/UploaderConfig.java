package com.does.config;

import com.does.file.upload.LocalUploader;
import com.does.file.upload.Uploader;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
public class UploaderConfig {

	@Bean
	@Profile("local")
	public Uploader localProfileUploader() {
		return new LocalUploader();
	}

	@Bean
	@Profile("!local")
	public Uploader otherProfileUploader() {
		return new LocalUploader();
	}
}