package com.does.aspect;

import com.does.biz.primary.domain.Base;
import com.does.biz.primary.domain.admin.AdminVO;
import com.does.http.DoesRequest;
import com.does.util.http.DoesSession;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Aspect
@Component
@Order(9)
public class WorkerAspect extends AspectBase {

	@Autowired	private DoesSession session;
	@Autowired	private DoesRequest request;

	@Pointcut(" execution(* com.does.biz.primary.service..insert(..))")					public void insert() {}
	@Pointcut(" execution(* com.does.biz.primary.service..update(..))")					public void update() {}
	@Pointcut(" execution(* com.does.biz.primary.service..updateApproveState(..))")		public void approve() {}
	@Pointcut(" execution(* com.does.biz.primary.service..save(..))")					public void save() {}
	@Pointcut(" execution(* com.does.biz.primary.service.POISVC.saveSimple(..))")		public void saveSimple() {}
	@Pointcut("!execution(* com.does.biz.primary.service..LogSVC.insert(..))")			public void notLogInsert(){}

	// 회원 가입에 대해서는 WorkerAspect 가 적용되지 않도록 설정
	@Pointcut("!execution(* com.does.biz.primary.service..AdminSVC.register(..))")		public void notAccountRegister(){}

	@Before("notLogInsert() && notAccountRegister() && ( insert() || update() || save() || approve() || saveSimple())")
	public void setCreatorInfo(JoinPoint jp) {
		Base vo = getTarget(jp, Base.class);

		if( vo != null ) {
			AdminVO worker	= session.getLoginUser();
			String	nameId	= worker.getNameId();
			String	currIp	= request.getIp();

			vo.setCreator(nameId);
			vo.setCreatorIp(currIp);

			vo.setUpdater(nameId);
			vo.setUpdaterIp(currIp);

			vo.setLang(session.getLang());
		}
	}
}