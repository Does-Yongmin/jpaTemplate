package com.does.util.http;

import com.does.biz.domain.core.Lang;
import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.admin.permission.PermissionGroup;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.List;

@Component
@Slf4j
public class DoesSession {

	@Autowired private HttpSession session;
	
	@Value("${server.servlet.session.timeout}")
	private String sessionTimeout;

	public static final String KEY_LOGIN_ADMIN	= "loginUser";				// 현재 로그인한 사용자 정보
	private static final String KEY_LOGIN_IP	= "loginIp";				// 현재 로그인한 사용자가 로그인할 당시의 IP
	private static final String KEY_CURR_LANG	= "current_language";		// 현재 로그인한 사용자가 사용할 언어값
	private static final String KEY_GROUP_LIST	= "permGroupList";			// 현재 로그인한 사용자가 소속된 권한그룹 목록
	private static final String KEY_GROUP		= "permGroup";				// 현재 로그인한 사용자가 선택한 권한그룹

	public DoesSession(HttpSession session)	{	this.session = session;	}

	//###################################################### HttpSession 클래스에서 필요한 함수들 재정의
	public String	getId()									{	return session == null ? null : session.getId();			}
	public Object	getAttribute(String key)				{	return session == null ? null : session.getAttribute(key);	}
	public void		setAttribute(String key, Object object)	{	if( session != null ) session.setAttribute(key, object);	}
	public void		removeAttribute(String key)				{	if( session != null ) session.removeAttribute(key);			}
	public void		invalidate()							{	if( session != null ) session.invalidate();					}

	//###################################################### 로그인 사용자의 로그인/아웃 여부를 처리
	public void	setLoginUser(Admin admin)	{
		session.setAttribute(KEY_LOGIN_ADMIN, admin);
		session.setMaxInactiveInterval(convertToSeconds(sessionTimeout));
	}
	private int convertToSeconds(String timeout) {
		if (timeout.endsWith("s")) {
			int seconds = Integer.parseInt(timeout.replace("s", ""));
			return seconds * 1; 				// 초 -> 밀리초 변환
		} else if (timeout.endsWith("m")) {
			int minutes = Integer.parseInt(timeout.replace("m", ""));
			return minutes * 60; 				// 분 -> 밀리초 변환
		} else if (timeout.endsWith("h")) {
			int hours = Integer.parseInt(timeout.replace("h", ""));
			return hours * 60 * 60; 			// 시간 -> 밀리초 변환
		}

		return 30 * 60;		// 기본값 : 30분
	}
	public Admin	getLoginUser()			{	return (Admin)session.getAttribute(KEY_LOGIN_ADMIN);	}
	public void		logout()				{
		try {
			Collections.list(session.getAttributeNames()).stream().forEach(session::removeAttribute);
		} catch (IllegalStateException e){
			log.error("로그아웃 처리중 유효하지 않은 세션 참조 오류 발생 : {}", e.getMessage());
		} catch( Exception e ) {
			log.error("로그아웃 처리중 오류 발생 : {}", e.getMessage());
		}
	}

	//###################################################### 현재 로그인한 사용자가 로그인 당시 사용한 IP 정보를 처리
	public void		setLoginIp(String ip)	{	session.setAttribute(KEY_LOGIN_IP, ip);				}
	public String	getLoginIp()			{	return (String)session.getAttribute(KEY_LOGIN_IP);	}

	//###################################################### 현재 가지고 있는 session 을 반환
	public HttpSession session() {	return session;	}

	//###################################################### 현재 관리중인 언어 정보 저장/반환
	public void setLang(Lang lang)	{	session.setAttribute(KEY_CURR_LANG, lang);	}
	public Lang getLang()			{	return (Lang)session.getAttribute(KEY_CURR_LANG);	}

	//###################################################### 현재 선택한 권한그룹 및 소속된 권한그룹 목록
	public void setPermGroupList(List<PermissionGroup> list)	{	session.setAttribute(KEY_GROUP_LIST, list);	}
	public List<PermissionGroup> getPermGroupList()			{	return (List<PermissionGroup>)session.getAttribute(KEY_GROUP_LIST);	}
	public void setPermGroup(PermissionGroup group)			{	session.setAttribute(KEY_GROUP, group);	}
	public PermissionGroup getPermGroup()						{	return (PermissionGroup)session.getAttribute(KEY_GROUP);	}


}