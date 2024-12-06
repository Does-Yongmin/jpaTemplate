package com.does.config;

import com.does.filter.LoginFilter;
import com.does.menu.Menu;
import com.does.menu.MenuConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Configuration
public class MvcConfig implements WebMvcConfigurer {

	/**
	 * lucy filter 는 does util 에 설정되어 있음
 	 */


	/**
	 * Login check Filter 등록<br/>
	 * 기존에는 LoginFilter 를 @Component 로 등록하여 사용했으나,
	 * 필터링할 URL 을 지정하고, 다른 필터들과의 설정방식 통일을 위해 LoginFilterConfig 클래스 추가.
 	 */
	@Bean
	@DependsOn(value = "contextPath")
	public FilterRegistrationBean<LoginFilter> loginFilter(){
		List<String> include = new ArrayList<>();
		if( Menu.isMenuEmpty() )
			MenuConfig.init();

		include.add("/lobby");
		include.add("/sitemap");
		include.add("/dashboard");
		include.add("/dashboard/excelDown");
		include.add("/pw/*");
		include.add("/menu/*");
		include.add("/requestAuth/*");
		include.add("/careers/*");
		include.add("/attach/*");
		include.add("/editor/upload/*");
		include.addAll(Menu.getLeafMenu().stream().map(menu -> menu.getContext()+"/*").collect(Collectors.toList()));

		FilterRegistrationBean<LoginFilter> registrationBean = new FilterRegistrationBean<>();
		registrationBean.setFilter(new LoginFilter());
		registrationBean.setOrder(Integer.MIN_VALUE);
		registrationBean.setUrlPatterns(include);

		return registrationBean;
	}
}