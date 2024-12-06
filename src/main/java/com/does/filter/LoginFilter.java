package com.does.filter;

import com.does.exception.validation.ValidException;
import com.does.exception.validation.ValidExceptionRoot;
import com.does.http.DoesRequest;
import com.does.util.http.DoesSession;
import com.does.util.login.LoginChecker;
import com.does.util.login.LoginUser;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.does.util.ContextPath.contextPath;

@Slf4j
@NoArgsConstructor
public class LoginFilter extends FilterBase {

	private static final String			msgDefault	= "로그인이 필요한 화면 입니다.\\r\\n쿠키 삭제 후 다시 시도해주세요.";
	private static final List<String>	exclude		= new ArrayList<>();

	@Override
	public void init(FilterConfig filterConfig) {
		if( exclude.isEmpty() ) {
			String cPath = contextPath();
			exclude.add(cPath + "/pw/change");        // 비밀번호 변경,
			exclude.add(cPath + "/pw/delay-change");  // 비밀번호 변경 미루기 는 예외 처리
		}
		log.info("Custom Configuration :: Filter :: Login Check set");
	}

	/**
		현재 request 가 로직을 적용해야 하는 uri 인지 여부를 판단하여 반환함
	    exclude 에 선언된 경로를 제외하고는 모두 로직 적용
	 */
	private boolean _isFilterTarget(DoesRequest request) {
		String uri = request.getRequestUri();
		return exclude.stream().noneMatch(uri::contains);
	}

	private void _notLogin(LoginUser admin) throws ValidExceptionRoot {
		if( admin == null || admin.isEmpty() ){
			log.info("로그인한 유저 정보가 없음");
			throw new ValidExceptionRoot(msgDefault);
		}

	}
	private void _ipNotMatch(DoesRequest request, DoesSession session) throws ValidExceptionRoot {
		String curIp	= request.getIp();
		String loginIp	= session.getLoginIp();
		if( ! curIp.equals(loginIp) ){
			log.info("로그인했던 IP와 접근 하는 IP가 불일치함");
			log.info("현재 IP : {}, 로그인 IP : {}", curIp, loginIp);
			throw new ValidExceptionRoot(msgDefault);
		}

	}

	@Override
	public void doFilter(ServletRequest servReq, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		DoesRequest request = new DoesRequest((HttpServletRequest)servReq);
		DoesSession session	= new DoesSession(request.getSession());

		try {
			LoginUser admin = session.getLoginUser();	// 로그인시 저장된 정보

			_notLogin(admin);
			_ipNotMatch(request, session);
			LoginChecker.checkMultiLogin(admin);
			LoginChecker.checkAdminStatus(admin);

			if( _isFilterTarget(request) ) {
				LoginChecker.checkTemporal(admin);
				LoginChecker.checkPwExpired(admin);
			}
		} catch(NullPointerException e) {
			log.info("로그인 filter NPE 발생. 메세지 : {}", e.getMessage());
			forward(servReq, response, msgDefault, ":ROOT");
			return;
		} catch(ValidException e) {
			forward(servReq, response, e.getMessage(), e.getUrl());
			return;
		}

		chain.doFilter(servReq, response);
	}

	@Override
	public void destroy() {}
}