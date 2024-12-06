package com.does.aspect;

import com.does.annotation.PersonalInfoCheck;
import com.does.biz.primary.domain.admin.AdminVO;
import com.does.biz.primary.domain.system.personalInfoLog.PersonalInfoLogVO;
import com.does.biz.primary.service.system.PersonalInfoLogSVC;
import com.does.exception.validation.ValidExceptionBack;
import com.does.http.DoesRequest;
import com.does.menu.Menu;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;

import java.lang.reflect.Method;

@Aspect
@Component
@SuppressWarnings("all")
@Order(11)
@Slf4j
public class PersonalInfoLogAspect extends AspectBase {

	@Autowired	private DoesRequest request;	// 현재 요청
	@Autowired	private DoesSession session;	// 세션 관련 작업 시 사용.

	@Autowired  private PersonalInfoLogSVC personalInfoLogSVC;

	private AdminVO _getTargetAdmin(JoinPoint jp) {
		return getTarget(jp, AdminVO.class);
	}


	/**
	 * PersonalInfoCheck 어노테이션이 붙어있는 개인정보가 있는 메뉴 접근시 로그 적재
	 *
	 * list, detail 페이지 조회시 해당 컨트롤러에서 model 에 넣는 조회된 값을 찾아서 로깅함
	 */
	@Around("@annotation(com.does.annotation.PersonalInfoCheck)")
	public Object logPersonalInfoLog(ProceedingJoinPoint pjp) throws Throwable {
		Object result = null;

		MethodSignature signature   = (MethodSignature) pjp.getSignature();
		Method method			    = signature.getMethod();
		PersonalInfoCheck annotation  = method.getAnnotation(PersonalInfoCheck.class);	// 메소드에 선언된 Annotation 을 불러옴

		PersonalInfoLogVO.AccessType accessType = annotation.accessType();
		AdminVO worker       = session.getLoginUser();
		String requestUri    = request.getRequestUri();
		String menuUri       = requestUri.substring(0, requestUri.lastIndexOf("/"));  // 현재 uri 중 메뉴 uri 만 가져온다. (detail, list 등 제외)
		Menu menu            = Menu.findByUrl(menuUri);                                   // 메뉴 uri 로 메뉴를 찾음
		String attributeName = annotation.attributeName();  // 조회된 대상을 model 에서 꺼내올때 필요한 attributeName 값

		result = pjp.proceed();  // 컨트롤러를 동작 시킴 (컨트롤러가 model 에 조회된 값을 넣으면 여기서 해당 값을 가져오기 위해)

		Model model = getModel(pjp.getArgs());  // 컨트롤러의 argument 중 model 을 가져옴
		if(model == null) { // model 이 없을 경우, 현재 로직으로는 처리 불가. 별도 개발 필요
			throw new RuntimeException("PersonalInfoCheck 어노테이션 적용을 위해서는 해당 컨트롤러 메소드가 Model 을 가지고 있어야 함");
		}

		String targetId = "";
		if(accessType == PersonalInfoLogVO.AccessType.SELECT_VIEW){    // 상세 조회일 경우
			AdminVO target = (AdminVO) model.getAttribute(attributeName);

			try {
				targetId = target.getAdminId();
			}catch (NullPointerException e){
				/*
				    target 이 null 인 경우는 의도적으로 없는 seq 로 관리자를 조회하는 경우인데, 
				    리스트 페이지에서는 실제 있는 관리자의 seq 를 내려주므로, 정상적이지 않은 상황
				 */
				log.info("비정상적인 관리자 계정 관리 계정 상세 접근 : {}", e.getMessage());
				throw new ValidExceptionBack("비정상적인 접근 시도입니다.");
			}
		}

		PersonalInfoLogVO logVO = PersonalInfoLogVO.builder()
										.sessionId(session.getId())
										.accessType(accessType)
										.targetTb(annotation.targetTb())
										.creatorId(worker.getAdminId())
										.targetId(targetId)
										.menuId(menu.getId())
										.requestUrl(requestUri)
										.build();

		personalInfoLogSVC.save(logVO);

		return result;
	}

	/**
	 * 컨트롤러의 파라미터중 model 객체를 찾아서 반환
	 */
	private Model getModel(Object[] pjpArgs){
		Model model = null;

		for (Object arg : pjpArgs) {
			if (arg instanceof Model) {
				model = (Model) arg;
				break;
			}
		}

		return model;
	}


}
