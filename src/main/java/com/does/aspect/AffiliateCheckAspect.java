package com.does.aspect;

import com.does.annotation.AccessOnlyForMyAffiliateType;
import com.does.biz.primary.domain.admin.AdminVO;
import com.does.biz.primary.domain.affiliate.AffiliateType;
import com.does.biz.primary.domain.affiliate.Affiliated;
import com.does.biz.primary.domain.system.permission.Level;
import com.does.biz.primary.domain.system.permission.PermissionGroupVO;
import com.does.exception.validation.ValidExceptionBack;
import com.does.menu.Menu;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.List;

@Aspect
@Component
@Slf4j
public class AffiliateCheckAspect extends AspectBase {

	@Autowired	private DoesSession session;

	@Before("@annotation(com.does.annotation.AccessOnlyForMyAffiliateType)")
	public void setAffiliateTypeInSearch(JoinPoint jp) throws ValidExceptionBack {
		MethodSignature	signature = (MethodSignature)jp.getSignature();
		Method method = signature.getMethod();
		AccessOnlyForMyAffiliateType annotation = method.getAnnotation(AccessOnlyForMyAffiliateType.class);	// 메소드에 선언된 Annotation 을 불러옴

		/*
		    현재 로그인한 사용자의 운영사 타입을 가져온 후, search 변수에 세팅하여
		    쿼리 조회시, 자신의 운영사 데이터만 불러오도록 제한
		 */
		AdminVO mySelf = session.getLoginUser();
		AffiliateType myAffiliateType = mySelf.getAffiliateType();

		/*
			현재 관리자가 최고 관리자인지 판단.
			최고 관리자일 경우, 운영사 모두 조회 가능
		 */
		List<Menu> masterAdminFlagMenuList = Menu.getMasterAdminFlagMenuList();
		PermissionGroupVO myPermissionGroup = session.getPermGroup();

		boolean isMasterAdmin = masterAdminFlagMenuList.stream().anyMatch(menu -> {
			return myPermissionGroup.hasPermission(menu.getId(), Level.APPROVE);
		});

		// 최고 관리자가 아닐 경우, 자신의 운영사 데이터만 조회 가능
		if(!isMasterAdmin){
			Class clazz = annotation.value();
			Affiliated search = (Affiliated) getTarget(jp, clazz);
			search.setAffiliateType(myAffiliateType);
		}
	}
}