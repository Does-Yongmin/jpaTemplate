package com.does.aspect;

import com.does.component.AttachPathResolver;
import com.does.http.DoesRequest;
import com.does.menu.Menu;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.context.annotation.DependsOn;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.List;


@DependsOn("menuConfig")
@Aspect
@Component
@Order(10)
@RequiredArgsConstructor
public class PageAspect extends AspectBase {

	private final AttachPathResolver attachPathResolver;

	private static final List<Menu> pageTitleList = new ArrayList<>();

	@PostConstruct
	public void initPageTitleMap() {
		if( pageTitleList.isEmpty() ) {
			pageTitleList.add(new Menu(null, "DASHBOARD"	, "/dashboard"));
//			pageTitleList.add(new Menu(null, "SITEMAP"		, "/sitemap"));
			pageTitleList.add(new Menu(null, "개인정보 수정"		, "/myInfo/detail"));
			pageTitleList.add(new Menu(null, "비밀번호 변경"	, "/pw/change"));
			pageTitleList.addAll(Menu.getLeafMenu());
		}
	}

	/**
	 *  URI를 사용해 각 페이지들의 페이지 타이틀을 찾아 request 속성으로 저장.
	 */
	@AfterReturning("@within(org.springframework.stereotype.Controller)")
	public void setHtmlPageTitle(JoinPoint jp) {
		DoesRequest request = new DoesRequest(getRequest(jp));
		String		uri		= request.getRequestUri();
		String		title	= pageTitleList.stream()
											.filter(m -> uri.contains(m.getContext()))
											.findFirst()
											.map(Menu::getBreadcrum).orElse("");
		request.setAttribute("pageTitle", title);
	}


	/**
	 *  jeus 에서는 class static method 를 EL 문법에서 호출 불가하여.
	 *  request 로 컴포넌트를 전달하여 method 사용하기 위함
	 */
	@AfterReturning("@within(org.springframework.stereotype.Controller)")
	public void setAttachPathResolver(JoinPoint jp) {
		DoesRequest request = new DoesRequest(getRequest(jp));
		request.setAttribute("AttachPathResolver", attachPathResolver);
	}
}