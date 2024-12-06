package com.does.aspect;

import com.does.biz.primary.domain.admin.AdminStatus;
import com.does.biz.primary.domain.admin.AdminVO;
import com.does.biz.primary.domain.log.LogType;
import com.does.biz.primary.domain.log.LogVO;
import com.does.biz.primary.domain.system.permission.PermissionGroupVO;
import com.does.biz.primary.domain.system.permission.PermissionMemberVO;
import com.does.biz.primary.domain.system.permission.PermissionVO;
import com.does.biz.primary.domain.system.permissionLog.PermissionLogVO;
import com.does.biz.primary.service.login.Login2FactorSVC;
import com.does.biz.primary.service.system.AdminSVC;
import com.does.biz.primary.service.system.LogSVC;
import com.does.biz.primary.service.system.PermissionLogSVC;
import com.does.biz.primary.service.system.permission.PermissionGroupSVC;
import com.does.exception.validation.ValidException;
import com.does.exception.validation.ValidExceptionBack;
import com.does.http.DoesRequest;
import com.does.util.StrUtil;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

@Aspect
@Component
@SuppressWarnings("all")
@Order(10)
@Slf4j
public class AdminAspect extends AspectBase {

	@Autowired	private DoesRequest request;	// 현재 요청
	@Autowired	private DoesSession session;	// 세션 관련 작업 시 사용.

	@Autowired	private LogSVC				logSVC;
	@Autowired	private AdminSVC			adminSVC;
	@Autowired	private PermissionGroupSVC	permGroupSVC;
	@Autowired	private PermissionLogSVC	permLogSVC;
	@Autowired  private Login2FactorSVC     login2FactorSVC;

	private AdminVO _getTargetAdmin(JoinPoint jp) {
		return getTarget(jp, AdminVO.class);
	}

	//////////////////////////////////////////////////////////////////////////////

	/**
	 * 회원가입 로깅
	 */
	@Around("execution(* com..AdminSVC.register(..))")
	public Object logSignUp(ProceedingJoinPoint pjp) throws Throwable{
		Object result = pjp.proceed();

		AdminVO admin = _getTargetAdmin(pjp);
		LogVO logVO = LogVO.createAdminActionLogNoLogin(request, session, LogType.SIGNUP, admin, admin);
		logSVC.insert(logVO);

		return result;
	}

	/**
	 * 로그인 성공 로깅
	 */
	@Around("@annotation(com.does.annotation.LoginLog)")
	public Object logLoginComplete(ProceedingJoinPoint pjp)	throws Throwable {
		Object result = null;

		try {
			result = pjp.proceed();												// 로그인 작업이 완료되면,
			logSVC.insert(LogVO.createAdminActionLog(request, session, LogType.LOGIN_SUCCESS)); // 로그인 로그 추가
		} catch (ValidException e) {													// 로그인 중 예외가 발생한 경우,
			AdminVO user		= session.getLoginUser();						// 세션에 로그인 정보가 있는지 확인 후
			boolean loginAnyway	=	user != null &&
									(user.isTemporal() || user.isPwExpired());	// 임시계정이거나 비밀번호가 만기된 경우면
			if( loginAnyway )													// 어쟀든 로그인이 완료된 것이라고 보고
				logSVC.insert(LogVO.createAdminActionLog(request, session, LogType.LOGIN_SUCCESS));	// 로그인 기록을 남기고 비밀번호 변경 페이지로 이동.

			throw e;
		} catch (Exception e){
			log.error("로그인 성공 로깅중 오류 발생 : {}", e.getMessage());
			throw new ValidExceptionBack("로그인 중 오류가 발생했습니다. 잠시후 다시 시도해주세요.");
		}

		return result;
	}

	/**
	 * 로그아웃 로깅
	 */
	@Before("execution(* com..LogoutCTR.logout(..))")
	public void logLogout(JoinPoint jp) {
		LogVO logVO = LogVO.createAdminActionLog(request, session, LogType.LOGOUT); // 로그아웃 작업 전에, 세션에 있을 로그인 정보를 사용하여 로그 정보 준비.

		try {
			if (logVO != null && logVO.getCreatorId() == null) {
				return;			// 이미 세션이 만료된 경우에 로그아웃 버튼을 누른 경우, SQL 에러 발생하지않도록 처리
			}
			logSVC.insert(logVO); // 로그를 추가하면서 에러가 발생하더라도 로그아웃은 정상적으로 진행되어야 하므로 try 로 wrapping.
		}catch (ValidException e){
			log.error("로그아웃 로깅중 ValidException 에러 발생 : {}", e.getMessage());
		}catch(Exception e) {
			log.error("로그아웃 로깅중 에러 발생 : {}", e.getMessage());      	/* Maybe session isn't valid due to session timeout or other issues. */
		}
	}

	/**
	 * 본인 인증 성공 여부 로깅
	 *
	 * 세션에서 로그인한 정보를 조회하고, 없으면 로그인시 입력한 id 값을 이용하여 현재 작업중인 admin 정보를 가져온다.
	 */
	@Around("execution(* com..AuthSVC.checkAuthNum(..))")
	public Object logCheckAuthNum(ProceedingJoinPoint pjp) throws Throwable{
		Object result = null;
		AdminVO findAdmin = session.getLoginUser();
		if(findAdmin == null){
			String tmpAdminId = login2FactorSVC.getTmpAdminIdInSession();   // 로그인시 입력한 id 를 세션에서 가져온다.
			if(!StrUtil.isEmpty(tmpAdminId)) findAdmin = adminSVC.findOneById(tmpAdminId);
		}

		try {
			result = pjp.proceed();

			if(findAdmin != null){
				// 본인 인증 성공 (인증번호 일치)
				LogVO successLog = LogVO.createAdminActionLogNoLogin(request, session, LogType.APPROVAL, findAdmin, findAdmin);
				logSVC.insert(successLog);
			}
		}catch (ValidException e){

			if(findAdmin != null){
				// 본인 인증 실패 (인증번호 불일치)
				LogVO failLog = LogVO.createAdminActionLogNoLogin(request, session, LogType.FAIL_APPROVAL, findAdmin, findAdmin);
				logSVC.insert(failLog);
			}
			throw e;
		}

		return result;
	}

	//////////////////////////////////////////////////////////////////////////////

	/**
	 * 관리자에 의한 잠금 해제 로깅
	 */
	@Around("execution(* com..AdminSVC.unlock(..))")
	public Object logUnlock(ProceedingJoinPoint pjp) throws Throwable{
		Object result = null;
		AdminVO target = _getTargetAdmin(pjp);
		LogVO logVO = LogVO.createAdminChangeLog(request, session, LogType.UNLOCKED_BY_ADMIN, target);

		result = pjp.proceed();
		logSVC.insert(logVO);

		return result;
	}

	/**
	 * 본인 계정 잠금 해제 로깅
	 */
	@Around("execution(* com..AdminSVC..unlockMySelf(..))")
	public Object logUnlockMySelf(ProceedingJoinPoint pjp) throws Throwable{
		Object result = null;

		AdminVO myself = _getTargetAdmin(pjp);
		LogVO logVO = LogVO.createAdminActionLogNoLogin(request, session, LogType.UNLOCK, myself, myself);

		result = pjp.proceed();
		logSVC.insert(logVO);

		return result;
	}

	/**
	 * 본인 계정 잠금 해제 실패 로깅
	 */
	@Around("execution(* com..AccountCTR..unlock(..))")
	public Object logFailUnlockMySelf(ProceedingJoinPoint pjp) throws Throwable{
		Object result = null;

		String adminId = getTarget(pjp, String.class);
		AdminVO myself = adminSVC.findOneById(adminId);

		try {
			result = pjp.proceed();
		}catch (ValidException e){
			log.info("계정 잠금 해제 실패 : {}", e.getMessage());
			if(myself != null){
				LogVO logVO = LogVO.createAdminActionLogNoLogin(request, session, LogType.FAIL_UNLOCK, myself, myself);
				logSVC.insert(logVO);
			}
			throw e;
		}

		return result;
	}

	/**
	 * 관리자에 의한 계정 탈퇴 로깅
	 */
	@Around("execution(* com..AdminSVC.withdraw(..))")
	public Object logWithdraw(ProceedingJoinPoint pjp) throws Throwable{
		Object result = null;

		String[]		seqs	= getTarget(pjp, String.class).split(",");	// 탈퇴할 계정들의 seq 값
		List<AdminVO>	targets	= null;								// 계정 탈퇴 전, 탈퇴대상 계정들 정보를 백업할 목록
		List<LogVO> logList = new ArrayList<>();
		if( seqs != null ) {
			targets = Arrays.stream(seqs)
					.filter(seq -> seq != null && !seq.isEmpty())	// 일련번호가 제대로 있는 항목에 대해
					.map(seq -> adminSVC.findOne(seq))				// 계정 정보를 검색하고
					.filter(o -> o != null)							// null 이 아닌 항목들만 남겨서
					.collect(Collectors.toList());					// 리스트로 저장.
		}

		if(targets != null){
			targets.stream().forEach(admin -> {
				logList.add(LogVO.createAdminChangeLog(request, session, LogType.WITHDRAW_BY_ADMIN, admin));
			});

			// 회원 탈퇴에 따라 부여되었던 권한 제거 로깅
			removeAdminPermissionsOnWithdraw(targets);
		}

		result = pjp.proceed();
		logSVC.insertAll(logList);

		return result;
	}

	/**
	 * 본인 계정 회원 탈퇴 로깅
	 */
	@Around("execution(* com..AdminSVC.withdrawMySelf(..))")
	public Object logWithdrawMySelf(ProceedingJoinPoint pjp) throws Throwable{
		Object result = null;
		LogVO logVO = LogVO.createAdminActionLog(request, session, LogType.WITHDRAW);

		// 회원 탈퇴에 따라 부여되었던 권한 제거 로깅
		AdminVO myself = session.getLoginUser();
		if(myself == null) throw new ValidExceptionBack("로그인 정보가 없습니다.");

		removeAdminPermissionsOnWithdraw(Collections.singletonList(myself));

		result = pjp.proceed();
		logSVC.insert(logVO);

		return result;
	}

	//////////////////////////////////////////////////////////////////////

	@Around("execution(* com..AdminSVC.save(..))")
	public Object logSave(ProceedingJoinPoint pjp) throws Throwable{
		Object result = null;
		// 현재 수정되는 어드민의 상태값을 가져온다
		AdminVO target = _getTargetAdmin(pjp);
		AdminStatus status = target.getAdminStatus();

		// 기존 DB 에서 어드민 상태값 확인을 위한 조회
		AdminVO before = adminSVC.findOne(target.getSeq());

		result = pjp.proceed();

		LogType logType = null;
		switch (status){
			case Y: // 계정 승인(잠금) 상태
				if(before.isLocked())   logType = LogType.UNLOCKED_BY_ADMIN; // 기존 계정의 경우 잠금 해제 로깅
				break;
			case N: // 계정 잠금 상태
				if(before.isUse())      logType = LogType.LOCKED_BY_ADMIN;
				break;
		}

		if(logType != null){
			LogVO logVO = LogVO.createAdminChangeLog(request, session, logType, target);
			logSVC.insert(logVO);
		}

		return result;
	}

	@Around("execution(* com..AdminSVC.approve(..))")
	public Object logApprove(ProceedingJoinPoint pjp) throws Throwable{
		Object result = null;
		// 현재 수정되는 어드민의 상태값을 가져온다
		AdminVO target = _getTargetAdmin(pjp);
		AdminStatus status = target.getAdminStatus();

		result = pjp.proceed();

		// 관리자 승인 로깅
		LogVO logVO = LogVO.createAdminChangeLog(request, session, LogType.APPROVAL_BY_ADMIN, target);
		logSVC.insert(logVO);

		return result;
	}

	/**
	 * 비밀번호 찾기로 본인 게정 비밀번호 초기화시 로깅
	 */
	@Around("execution(* com..AdminSVC.resetPwMySelf(..))")
	public Object logResetPwMySelf(ProceedingJoinPoint pjp) throws Throwable{
		Object result = pjp.proceed();

		String seq = getTarget(pjp, String.class);
		AdminVO findAdmin = adminSVC.findOne(seq);

		/*
		    비밀번호 찾기는 로그인 상태가 아니기 때문에 세션에서 worker 정보를 가져올 수 없음.
		    따라서 worker 와 target 을 모두 seq 로 조회한 어드민으로 넘겨줌
		 */
		LogVO logVO = LogVO.createAdminActionLogNoLogin(request, session, LogType.PW_FIND, findAdmin, findAdmin);
		logSVC.insert(logVO);

		return result;
	}

	/**
	 * 관리자에 의한 비밀번호 초기화시 로깅
	 */
	@Around("execution(* com..AdminSVC.resetPw(..))")
	public Object logResetPw(ProceedingJoinPoint pjp) throws Throwable{
		Object result = pjp.proceed();

		// 비밀번호를 초기화 당한 대상
		String seq = getTarget(pjp, String.class);
		AdminVO target = adminSVC.findOne(seq);

		LogVO logVO = LogVO.createAdminChangeLog(request, session, LogType.PW_RESET_BY_ADMIN, target);
		logSVC.insert(logVO);

		return result;
	}

	/**
	 * 본인 계정 비밀번호 변경 로깅
	 */
	@Around("execution(* com..AdminSVC.modifyPwMySelf(..))")
	public Object logModifyPwMySelf(ProceedingJoinPoint pjp) throws Throwable{
		Object result = pjp.proceed();

		LogVO logVO = LogVO.createAdminActionLog(request, session, LogType.PW_CHANGE);
		logSVC.insert(logVO);

		return result;
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////

	private void removeAdminPermissionsOnWithdraw(List<AdminVO> targets){
		if( targets != null ) {
			List<LogVO> logs = targets.stream()
					.map(target -> {					// 삭제 완료 후, 삭제된 권한목록도 함께 표시.
						List<PermissionGroupVO> permBeforeList	= adminSVC.findAllPermissionByAdminId(target.getAdminId());	// 기존에 이 관리자가 소속되어있던 권한그룹 목록
						List<LogVO> _logs = _getPermissionDiffLogs(permBeforeList, null, target);						// LogVO 로 전환

						// 해당 권한 그룹에서 탈퇴한 어드민 삭제
						permBeforeList.stream().forEach(perm -> {
							String groupSeq = perm.getSeq();
							permGroupSVC.removeMemberFromPermissionGroup(target, groupSeq);
						});

						return _logs;
					})
					.flatMap(List::stream)
					.collect(Collectors.toList());
			// 회원 탈퇴되는 관리자가 이전에 가지고 있던 권한이 없는 경우가 있을 수도 있어서 체크
			if(logs != null && logs.size() > 0){
				logSVC.insertAll(logs);
			}

			List<PermissionLogVO> permLogs = targets.stream()
					.map(before -> {					// 삭제 완료 후, 삭제된 권한목록도 함께 표시.
						List<PermissionGroupVO> permBeforeList	= adminSVC.findAllPermissionByAdminId(before.getAdminId());	// 기존에 이 관리자가 소속되어있던 권한그룹 목록
						String permissionBefore = permBeforeList.stream().map(group -> "<div>"+ group.getGroupName() +"</div>").collect(Collectors.joining());
						return new PermissionLogVO(request, session, before, permissionBefore, "(계정 삭제)");
					})
					.collect(Collectors.toList());
			// 회원 탈퇴되는 관리자가 이전에 가지고 있던 권한이 없는 경우가 있을 수도 있어서 체크
			if(permLogs != null && permLogs.size() > 0){
				permLogSVC.insertAll(permLogs);
			}
		}
	}

	private String _compareResult(String before, String after) {
		before	= before == null ? "" : before;
		after	= after  == null ? "" : after;
		return before.equals(after) ? "" : String.format("<comp><bef>%s</bef><aft>%s</aft></comp>", before, after);
	}
	private String diffInfo(AdminVO before, AdminVO after) {
		List<String> diff = new ArrayList<>();
		diff.add(_compareResult( before.getDecName()		, after.getDecName() ));
		diff.add(_compareResult( before.getDecEmail()		, after.getDecEmail() ));
		diff.add(_compareResult( before.getUseYn()			, after.getUseYn() ));
		diff.add(_compareResult( before.getIdleYn()			, after.getIdleYn() ));
		diff.add(_compareResult( before.getTempYn()			, after.getTempYn() ));
		diff.add(_compareResult( before.getDecPhone()		, after.getDecPhone() ));

		return diff.stream().filter(s -> !s.isEmpty()).collect(Collectors.joining());
	}


	private List<LogVO> _getPermissionDiffLogs(List<PermissionGroupVO> before, List<PermissionGroupVO> after, AdminVO target) {
		List<LogVO> result = new ArrayList<>();
		if( before != null || after != null ) {
			Function<PermissionGroupVO, LogVO> grantFunc  = (p) -> { return LogVO.createAdminChangeLog(request, session, LogType.AUTH_GRANT,  target, "권한그룹에 추가"); };
			Function<PermissionGroupVO, LogVO> revokeFunc = (p) -> { return LogVO.createAdminChangeLog(request, session, LogType.AUTH_REVOKE, target, "권한그룹에서 삭제"); };

				 if( before == null )	result =  after.stream().map(grantFunc).collect(Collectors.toList());	// 이번에 생성되는 권한그룹이면 after 를 반환
			else if( after == null )	result = before.stream().map(revokeFunc).collect(Collectors.toList());	// 이번에 삭제되는 권한그룹이면 before 를 반환
			else {																								// 그외에 그룹권한 목록에 변화가 있으면
				List<LogVO> deleted = before.stream().filter(p1 -> after.stream().noneMatch(p2 -> p1.getSeq().equals(p2.getSeq()))).map(revokeFunc).collect(Collectors.toList());
				List<LogVO> created = after.stream().filter(p1 -> before.stream().noneMatch(p2 -> p1.getSeq().equals(p2.getSeq()))).map(grantFunc).collect(Collectors.toList());
				result.addAll(deleted);
				result.addAll(created);
			}
		}

		return result;
	}

	//////////////////////////////////////////////////////////////////////////////

	/**
	 * 관리자 관리에서 권한 그룹 추가시 로깅
	 */
	@Transactional
	@Around("execution(* com..PermissionGroupSVC.addMemberToPermissionGroup(..))")
	public Object logForAddMemberToPermissionGroup(ProceedingJoinPoint pjp) throws Throwable{
		AdminVO adminVO = _getTargetAdmin(pjp);
		String groupSeq = getTarget(pjp, String.class);

		try {
			saveAuthGrantLog(adminVO.getSeq(), groupSeq);
		}catch (ValidException e){
			log.error("관리자 관리에서 권한 그룹 추가중 ValidException 오류 발생 : {}", e.getMessage());
		}catch (Exception e){
			log.error("관리자 관리에서 권한 그룹 추가중 오류 발생 : {}", e.getMessage());
		}


		return pjp.proceed();
	}

	/**
	 * 관리자 관리에서 권한 그룹 제거시 로깅
	 */
	@Transactional
	@Around("execution(* com..PermissionGroupSVC.removeMemberFromPermissionGroup(..))")
	public Object logForRemoveMemberToPermissionGroup(ProceedingJoinPoint pjp) throws Throwable{
		AdminVO adminVO = _getTargetAdmin(pjp);
		String groupSeq = getTarget(pjp, String.class);

		try {
			saveAuthRevokeLog(adminVO.getSeq(), groupSeq);
		}catch (ValidException e){
			log.error("관리자 관리에서 권한 그룹 제거중 ValidException 오류 발생 : {}", e.getMessage());
		}catch (Exception e){
			log.error("관리자 관리에서 권한 그룹 제거중 오류 발생 : {}", e.getMessage());
		}

		return pjp.proceed();
	}


	/**
	 * 그룹 권한 수정 로깅
	 */
	@Transactional
	@Around("execution(* com..PermissionGroupSVC.save(..))")
	public Object logForPermissionGroupSave(ProceedingJoinPoint pjp)		throws Throwable {
		try {
			PermissionGroupVO target = getTarget(pjp, PermissionGroupVO.class);

			_saveAdminLogBeforePermissionChange(target);
			_savePermissionLogBeforePermissionChange(target);
		} catch (ValidException e){
			log.info("그룹 권한 수정중 ValidException 오류 발생 : {}", e.getMessage());
		} catch(Exception e) {
			log.info("그룹 권한 수정중 오류 발생 : {}", e.getMessage());
		}

		Object result = pjp.proceed();
		return result;
	}

	/**
	 * 그룹 권한 삭제 로깅
	 */
	@Transactional
	@Around("execution(* com..PermissionGroupSVC.delete(..))")
	public Object logForPermissionGroupdelete(ProceedingJoinPoint pjp)		throws Throwable {
		try {
			List<String> targetSeqList = getTarget(pjp, List.class);
			targetSeqList.forEach(seq -> {
				PermissionGroupVO target = permGroupSVC.findOne(seq);
				_savePermissionLogBeforePermissionChange(target);

				LogVO logVO = LogVO.createAdminChangeLog(request, session, LogType.GROUP_DELETE, target);
				logSVC.insert(logVO);
			});
		} catch (ValidException e){
			log.info("그룹 권한 삭제중 ValidException 오류 발생 : {}", e.getMessage());
		} catch(Exception e) {
			log.info("그룹 권한 삭제중 오류 발생 : {}", e.getMessage());
		}

		Object result = pjp.proceed();
		return result;
	}
	private void _saveAdminLogBeforePermissionChange(PermissionGroupVO target) {
		boolean				isNew	= target.isNew();

		List<PermissionVO>	permissionsAfter = target.getPermissions();
		if( isNew ) {
			List<LogVO> logs = permissionsAfter.stream().map(p -> {
				return LogVO.createAdminChangeLog(request, session, LogType.GROUP_CREATE, p, p.getTargetName() +":"+ p.getGrantLevel().getName());
			}).collect(Collectors.toList());
			logSVC.insertAll(logs);
		} else {
			PermissionGroupVO	before	= permGroupSVC.findOne(target.getSeq());
			String nameBefore = before.getGroupName();
			String nameAfter = target.getGroupName();
			if( !nameBefore.equals(nameAfter) ) {
				LogVO log = LogVO.createAdminChangeLog(request, session, LogType.GROUP_MODIFY, before, nameAfter + "로 그룹명 변경");
				logSVC.insert(log);
			}

			List<PermissionVO>	permissionsBefore = before.getPermissions();
			List<String> deleted = permissionsBefore.stream()
													.filter(p1 -> permissionsAfter.stream().noneMatch(p2 -> p1.getMenuId().equals(p2.getMenuId())))
													.map(p -> p.getTargetName()+":"+p.getGrantLevel().getName())
													.collect(Collectors.toList());
			List<String> beforeModified = permissionsBefore.stream()
													.filter(p1 -> permissionsAfter.stream().anyMatch(p2 -> p1.getMenuId().equals(p2.getMenuId()) && p1.getGrantLevel() != p2.getGrantLevel()))
													.map(p -> p.getTargetName()+":"+p.getGrantLevel().getName())
													.collect(Collectors.toList());
			List<String> afterModified = permissionsAfter.stream()
													.filter(p1 -> permissionsBefore.stream().anyMatch(p2 -> p1.getMenuId().equals(p2.getMenuId()) && p1.getGrantLevel() != p2.getGrantLevel()))
													.map(p -> p.getTargetName()+":"+p.getGrantLevel().getName())
													.collect(Collectors.toList());
			List<String> created = permissionsAfter.stream()
													.filter(p1 -> permissionsBefore.stream().noneMatch(p2 -> p1.getMenuId().equals(p2.getMenuId())))
													.map(p -> p.getTargetName()+":"+p.getGrantLevel().getName())
													.collect(Collectors.toList());

			String detail = "";
			detail += deleted.stream().map(s -> _compareResult(s, null)).collect(Collectors.joining());
			for (int i = 0, size = beforeModified.size(); i < size; i++) {
				String _before = beforeModified.get(i);
				String _after = afterModified.get(i);
				detail += _compareResult(_before, _after);
			}
			detail += created.stream().map(s -> _compareResult(null, s)).collect(Collectors.joining());
			detail = detail.trim().isEmpty() ? "메뉴 접근권한에 변경 없음." : detail;

			List<LogVO> logs = new ArrayList<>();
			logs.add(LogVO.createAdminChangeLog(request, session, LogType.GROUP_MODIFY, target, detail));
			logSVC.insertAll(logs);
		}
	}
	private void _savePermissionLogBeforePermissionChange(PermissionGroupVO target) {
		String targetGroupSeq = target.getSeq();
		PermissionGroupVO before = permGroupSVC.findOne(targetGroupSeq);
		List<AdminVO> memberInfo = before == null ? new ArrayList<>() : before.getMembersInfo();
		memberInfo = memberInfo == null ? new ArrayList<>() : memberInfo;

		List<PermissionMemberVO> membersAfter = target.getMembers() == null ? new ArrayList<>() : target.getMembers();
		List<PermissionMemberVO> membersBefore = memberInfo.stream().map(a -> { PermissionMemberVO member = new PermissionMemberVO(); member.setGroupSeq(targetGroupSeq); member.setAdminSeq(a.getSeq()); return member; }).collect(Collectors.toList());

		List<PermissionMemberVO> deleted = membersBefore.stream().filter(p1 -> membersAfter.stream().noneMatch(p2 -> p1.getAdminSeq().equals(p2.getAdminSeq()))).collect(Collectors.toList());

		deleted.stream().forEach(p -> {
			saveAuthRevokeLog(p.getAdminSeq(), targetGroupSeq);
		});

	}


	/**
	 * 권한 삭제 이력 로깅
	 * @param adminSeq
	 * @param groupSeq
	 */
	private void saveAuthRevokeLog(String adminSeq, String groupSeq){
		// 퍼미션 변경 로깅
		AdminVO admin = adminSVC.findOne(adminSeq);
		List<PermissionGroupVO> currDataInDB = adminSVC.findAllPermissionByAdminSeq(adminSeq);
		String detailBefore = currDataInDB.stream().map(currData -> "<div>"+ currData.getGroupName() +"</div>").collect(Collectors.joining());
		currDataInDB = currDataInDB.stream().filter(currData -> !currData.getSeq().equals(groupSeq)).collect(Collectors.toList());
		String detailAfter = currDataInDB.stream().map(currData -> "<div>"+ currData.getGroupName() +"</div>").collect(Collectors.joining());
		PermissionLogVO permLog = new PermissionLogVO(request, session, admin, detailBefore, detailAfter);
		permLogSVC.insert(permLog);

		// 관리자 로그 로깅
		LogVO revokeLog = LogVO.createAdminChangeLog(request, session, LogType.AUTH_REVOKE, admin);
		revokeLog.setRefPermissionLog(permLog.getSeq());  // 연관된 퍼미션 로그의 seq
		logSVC.insert(revokeLog);
	}


	/**
	 * 권한 부여 이력 로깅 (관리자 계정 관리에서 권한 부여시)
	 *
	 * @param adminSeq
	 * @param groupSeq
	 */
	private void saveAuthGrantLog(String adminSeq, String groupSeq){
		// 퍼미션 변경 로깅
		AdminVO admin = adminSVC.findOne(adminSeq);
		List<PermissionGroupVO> currDataInDB = adminSVC.findAllPermissionByAdminSeq(adminSeq);
		String detailBefore = currDataInDB.stream().map(currData -> "<div>"+ currData.getGroupName() +"</div>").collect(Collectors.joining());
		currDataInDB.add(permGroupSVC.findOne(groupSeq));
		String detailAfter = currDataInDB.stream().map(currData -> "<div>"+ currData.getGroupName() +"</div>").collect(Collectors.joining());
		PermissionLogVO permLog = new PermissionLogVO(request, session, admin, detailBefore, detailAfter);
		permLogSVC.insert(permLog);

		// 관리자 로그 로깅
		LogVO grantLog = LogVO.createAdminChangeLog(request, session, LogType.AUTH_GRANT, admin);
		grantLog.setRefPermissionLog(permLog.getSeq());    // 연관된 퍼미션 로그의 seq
		logSVC.insert(grantLog);
	}


}