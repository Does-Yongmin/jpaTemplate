package com.does.schedule;

import com.does.biz.domain.admin.AdminStatus;
import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.log.LogType;
import com.does.biz.domain.log.Log;
import com.does.biz.repository.admin.AdminScheduleDAO;
import com.does.biz.service.admin.AdminService;
import com.does.biz.service.admin.LogService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Slf4j
@RequiredArgsConstructor
public class AdminSchedule {

	private final AdminScheduleDAO dao;
	private final AdminService adminService;
	private final LogService logService;

	/**
	 * 마지막 로그인 이후 30일이 지난 계정 잠금 처리
	 */
	@Scheduled(cron = "0 1 0 * * ?") // 매일 00:01 분 실행
	public void lockAccountsAfter30DaysOfLastLogin(){
		List<Admin> list = dao.findAccountsAfter30DaysOfLastLogin();
		if(list == null || list.isEmpty()) return;

		list.forEach(admin -> {
			Admin vo = new Admin();
			vo.setSeq(admin.getSeq());
			vo.setAdminStatus(AdminStatus.N);
			// 어드민 잠금 처리
			adminService.saveBySystem(vo);

			// 시스템에 의한 잠금 로깅
			logService.insert(Log.createAdminChangeLogBySystem(LogType.LOCKED_BY_SYSTEM, admin));
		});
	}

	/**
	 * 회원가입 후 30일 동안 로그인 이력이 없는 계정 잠금 처리
	 */
	@Scheduled(cron = "0 5 0 * * ?")
	public void lockAccountsAfter30DaysOfSignup(){
		List<Admin> list = dao.findAccountsAfter30DaysOfSignup();
		if(list == null || list.isEmpty()) return;

		list.forEach(admin -> {
			Admin vo = new Admin();
			vo.setSeq(admin.getSeq());
			vo.setAdminStatus(AdminStatus.N);
			// 어드민 잠금 처리
			adminService.saveBySystem(vo);

			// 시스템에 의한 잠금 로깅
			logService.insert(Log.createAdminChangeLogBySystem(LogType.LOCKED_BY_SYSTEM, admin));
		});

	}

	/**
	 * 계정 잠금처리후 60일 경과시 탈퇴 처리
	 */
	@Scheduled(cron = "0 10 0 * * ?")
	public void withdrawAccountsAfter60DaysOfLock(){
		List<Admin> list = dao.findAccountsAfter60DaysOfLock();
		if(list == null || list.isEmpty()) return;

		list.forEach(admin -> {
			Admin vo = new Admin();
			vo.setSeq(admin.getSeq());
			vo.setAdminStatus(AdminStatus.W);
			// 어드민 탈퇴 처리
			adminService.saveBySystem(vo);

			// 시스템에 의한 탈퇴 처리 로깅
			logService.insert(Log.createAdminChangeLogBySystem(LogType.WITHDRAW_BY_SYSTEM, admin));
		});
	}

	/**
	 * 계정 탈퇴처리 후 N일 경과시 개인정보 삭제 처리 (개인정보 컬럼 '-' 처리)
	 */
	@Scheduled(cron = "0 15 0 * * ?")
	public void deletePersonalDataAfter365DaysOfWithdrawal(){
		List<Admin> list = dao.findAccountsAfter365DaysOfWithdrawal();
		if(list == null || list.isEmpty()) return;

		list.forEach(admin -> {
			Admin vo = new Admin();
			vo.setSeq(admin.getSeq());
			vo.setAdminStatus(AdminStatus.D);
			// 어드민 개인정보 삭제 처리
			adminService.saveBySystem(vo);
			adminService.deletePersonalDataBySeq(vo);

			// 시스템에 의한 개인정보 삭제 처리 로깅
			logService.insert(Log.createAdminChangeLogBySystem(LogType.DELETE_BY_SYSTEM, admin));
		});

	}

}
