package com.does.aspect;

import com.does.annotation.PermissionCheck;
import com.does.biz.primary.domain.Base;
import com.does.biz.primary.domain.system.permission.Level;
import com.does.biz.primary.domain.system.permission.PermissionGroupVO;
import com.does.exception.ajax.AjaxException;
import com.does.exception.validation.ValidExceptionBack;
import com.does.http.DoesRequest;
import com.does.menu.Menu;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.Arrays;

@Aspect
@Component
@Slf4j
@Order(1)
public class PermissionCheckAspect extends AspectBase {

	@Autowired	private DoesSession session;
	@Autowired	private DoesRequest request;

	@Before("@annotation(com.does.annotation.PermissionCheck)")
	public void permissionCheck(JoinPoint jp) throws ValidExceptionBack, AjaxException {
		MethodSignature	signature		= (MethodSignature)jp.getSignature();
		Method			method			= signature.getMethod();
		PermissionCheck	annotation		= method.getAnnotation(PermissionCheck.class);	// 멤버 함수에 선언된 Annotation 을 불러옴
		String			levelStr		= annotation.value();							// 어노테이션에 선언된 최소 요구권한
		Level			level			= Level.LIST;									// 최소 요구권한의 기본값은 '목록 조회 권한'

		try {
			level = Level.valueOf(levelStr);							// 어노테이션에 선언된 최소 요구권한 문자열을 enum 으로 변경.
		} catch(IllegalArgumentException e) {											// enum 에 없는 값일 때,
			if( "SAVE".equals(levelStr) ) {								// SAVE 는 insert/update 가 함께 있으므로, 이 경우
				Base		vo		= getTarget(jp, Base.class);
				boolean		isNew	= vo != null && vo.isNew();			// 해당 글이 신규인지 수정인지 확인후
				level = isNew ? Level.WRITE : Level.UPDATE;				// 체크해야 할 권한 레벨을 조정한다.
			}
		} catch (Exception e){
			log.error("권한 체크중 오류 발생 : {}", e.getMessage());
			throw new ValidExceptionBack("권한 체크중 오류 발생으로 잠시 후 다시 시도해주세요.");
		}

		PermissionGroupVO permGroup = session.getPermGroup();			// 현재 로그인한 사용자가 사용중인 권한그룹.
		if( permGroup != null ) {										// 세션이 종료되었거나 권한그룹이 없는 경우는 다른 filter 에서 처리하고, 그 외의 경우
			String	nowUrl	= request.getRequestUri();					// 현재 접속한 URL 을 찾고
			Menu	menu	= Menu.findByUrl(nowUrl);					// 그 URL 에 해당하는 메뉴를 확인.
			if( menu == null ) {										// Menu에 등록된 메뉴가 아닌 경우
				String contextOfParent = annotation.of();				// 현재 보고있는 페이지의 상위메뉴가 있는지 보고
				menu = Menu.findByUrl(contextOfParent);					// 상위메뉴를 찾아 해당메뉴의 권한을 대신 확인한다.
			}

			if( menu != null && ! permGroup.hasPermission(menu.getId(), level) ) {	// 해당 메뉴에 대한 권한이 없으면
				Class[] clazz = method.getExceptionTypes();
				boolean isAjax = Arrays.asList(clazz).stream().anyMatch(cls -> cls == AjaxException.class);

				String msg = "권한이 불충분합니다.";
				if( isAjax )	throw new AjaxException(msg);
				else			throw new ValidExceptionBack(msg);		// 예외 발생
			}
		}
	}
}