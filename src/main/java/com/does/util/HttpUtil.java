package com.does.util;

import org.springframework.ui.Model;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

public class HttpUtil {

	private static String[] headers =	{
			"X-Forwarded-For",
			"Proxy-Client-IP",
			"WL-Proxy-Client-IP",
			"HTTP_CLIENT_IP",
			"HTTP_X_FORWARDED_FOR",
			"HTTP_X_FORWARDED",
			"HTTP_X_CLUSTER_CLIENT_IP",
			"HTTP_CLIENT_IP",
			"HTTP_FORWARDED_FOR",
			"HTTP_FORWARDED",
			"HTTP_VIA",
			"REMOTE_ADDR"
	};

	/**
	 * 현재 요청에 대한 URI 정보를 조회한다
	 * @return String : 자신의 URL 정보
	 */
	public static String getRequestUri( HttpServletRequest request ) {
		String result = (String)request.getAttribute("javax.servlet.forward.request_uri");
		result = result == null || result.isEmpty() ? request.getRequestURI() : result;
		result = result == null ? "" : result;
		return result;
	}

	/**
	 * Cookie에서  key에 해당하는 value를 추출한다.
	 * @return String : value값
	 */
	public static String getCookieValue( Cookie[] cookies, String cookieName ) {
		String result = null;
		for(int i = 0 ; cookies != null && i < cookies.length ; i++) {
			if( cookies[i].getName().equals( cookieName ) ) {
				result = cookies[i].getValue();
				break;
			}
		}

		return result;
	}

	/**
	 * Cookie에서  key에 해당하는 value를 추출한다.
	 * @param request
	 * @param cookieName
	 * @return
	 */
	public static String getCookieValue( HttpServletRequest request, String cookieName ) {
		return getCookieValue( request.getCookies(), cookieName );
	}

	/**
	 * 사용자의 IP 정보를 불러오는 함수.
	 * @param request
	 * @return
	 */
	public static String getIp( HttpServletRequest request ) {
		String ip = null;
		for(String header : headers)
			ip = ip == null || ip.trim().isEmpty() ? request.getHeader(header) : ip;
		ip = ip == null || ip.trim().isEmpty() ? request.getRemoteAddr() : ip;
		return ip.replaceAll(",.+", "");
	}

	/**
	 * 현재 IP 와 전달받은 IP 를 비교하여 현재 IP 가 전달받은 IP 를 포함하는지를 반환
	 * @param request
	 * @param ip
	 * @return
	 */
	public static boolean hasIp(HttpServletRequest request, String ip ) {
		boolean have = ip == null || ip.trim().isEmpty();	// 허용할 IP 가 설정되어있지 않으면 모든 주소에서의 접속을 허용

		String value;
		for( String header : headers ) {
			if( !have ) {
				value = request.getHeader(header);
				value = value == null ? "" : value;
				have = have || value.contains( ip );
			}
		}
		if( !have ) {
			value = request.getRemoteAddr();
			value = value == null ? "" : value;
			have = have || value.contains( ip );
		}

		return have;
	}

	/**
	 * 컨트롤러에서 사용하는 model 에 alert 메시지와 url 을 설정한다.
	 * @param model
	 * @param msg
	 * @param url
	 */
	public static String alert( Model model, String msg, String url ) {
		model.addAttribute( "message", msg )
			.addAttribute( "url", url );
		return "/common/MessageViewer";
	}
}