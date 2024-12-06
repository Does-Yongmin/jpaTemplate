package com.does.biz.service.admin;

import com.does.biz.domain.admin.AdminStatus;
import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.log.LogType;
import com.does.biz.domain.log.Log;
import com.does.biz.repository.admin.AdminDAO;
import com.does.biz.repository.admin.LogDAO;
import com.does.http.DoesRequest;
import com.does.util.StrUtil;
import com.does.util.http.DoesSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class LogService {

	@Autowired	private LogDAO		logDAO;
	@Autowired  private AdminService    adminService;
	@Autowired	private AdminDAO	adminDAO;

	@Autowired	private DoesRequest	request;	// 현재 요청
	@Autowired	private DoesSession	session;	// 세션 관련 작업 시 사용.

	//////////////////////////////////////////////////////////////////////////////
	@Transactional(readOnly = true)
	public Log getLastLog(String adminId, LogType logType) {
		Log search = Log.builder().creatorId(adminId).logType(logType).build();
		return logDAO.lastLog(search);
	}

	/**
	 * 가장 마지막 계정 잠금 로그를 가져온다.
	 * 잠긴 대상인 targetId 가 adminId 면서, 잠금 관련 로그중 가장 최신 것 조회
	 *
 	 * @param adminId
	 * @return
	 */
	@Transactional(readOnly = true)
	public Log getLastLockedLog(String adminId){
		Log search = Log.builder().targetId(adminId).build();
		return logDAO.findLastLockedLog(search);
	}

	//////////////////////////////////////////////////////////////////////////////
//	@Transactional(readOnly = true)
//	public int count(Log vo)				{	return logDAO.count(vo);	}
//	@Transactional(readOnly = true)
//	public Log findOne(Log vo)			{	return logDAO.findOne(vo);	}
//	@Transactional(readOnly = true)
//	public List<Log> findPage(Log vo)	{	return logDAO.findPage(vo);	}


	/**
	 * 기존 count, findPage 와 다르게 세션 그룹핑 하지 않고 조회하는 메소드
	 */
	@Transactional(readOnly = true)
	public int countWithoutSessionGrouping(Log vo)              {   return logDAO.countWithoutSessionGrouping(vo); }
	@Transactional(readOnly = true)
	public List<Log> findPageWithoutSessionGrouping(Log vo) {return logDAO.findPageWithoutSessionGrouping(vo);}

	//////////////////////////////////////////////////////////////////////////////
	@Transactional
	public int insert(Log log)			{	return logDAO.insert(log);	}
	@Transactional
	public int insertAll(List<Log> list)	{	return logDAO.insertAll(list);	}

	@Transactional
	public int insertLoginFailLog(Admin worker, String msg) {
		String adminId = worker != null ? worker.getAdminId() : "";
		if(StrUtil.isEmpty(adminId)) return 0;

		Log log = Log.createAdminActionLog(request, session, LogType.LOGIN_FAIL, msg);
		log.setCreatorId(adminId);
		log.setTargetId(adminId);

		// 로그인 실패 로깅
		int		result	= logDAO.insert(log);

		// 로그인 5회 연속 실패 로그가 있는지 조회
		boolean	goLock	= result == 1 && logDAO.loginFailCountInARow(adminId) > 4;
		/*
		    5회 연속 실패면서, 이전에 다른 어드민에 의해 잠겼던 계정이 아닐 경우
		    비밀번호 5회 연속 실패로 인한 잠금 처리

		    다른 어드민이 잠금 처리했는데, 5회 연속 실패하여 본인이 잠금 해제할 수 있는 상태로 변경하는 것 방지
		*/
		if( goLock && !adminService.isLockedByOtherAdmin(adminId) ) insertPw5LockLog(adminId);

		return result;
	}

	/**
	 * 계정 잠금 처리 및 잠금 로깅을 한다.
	 */
	@Transactional
	public void insertPw5LockLog(String adminId){
		// 계정 잠금 처리
		Admin lockAdmin = new Admin();
		lockAdmin.setAdminId(adminId);
		lockAdmin.setAdminStatus(AdminStatus.N);
		adminDAO.updateStatus(lockAdmin);

		// 계정 잠금 로깅
		Log limitLog = Log.createAdminActionLog(request, session, LogType.LOCK_PW5);
		limitLog.setCreatorId(adminId);
		limitLog.setTargetId(adminId);
		logDAO.insert(limitLog);
	}

}