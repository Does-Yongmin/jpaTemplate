package com.does.biz.service.admin;

import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.admin.personalInfoLog.AccessAdminDTO;
import com.does.biz.domain.admin.personalInfoLog.MenuUsageDTO;
import com.does.biz.domain.admin.personalInfoLog.PermissionHistoryDTO;
import com.does.biz.domain.admin.personalInfoLog.PersonalInfoLog;
import com.does.biz.repository.admin.PersonalInfoLogDAO;
import com.does.menu.Menu;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;


@Service
@RequiredArgsConstructor
public class PersonalInfoLogService {

	private final PersonalInfoLogDAO dao;
	private final AdminService           adminService;


	public int countAccessAdmin(PersonalInfoLog vo)      {	return dao.countAccessAdmin(vo);	        }
	public int countMenuUsage(PersonalInfoLog vo)        {	return dao.countMenuUsage(vo);	            }
	public int countPermissionHistory(PersonalInfoLog vo){	return dao.countPermissionHistory(vo);      }


	/**
	 * 개인정보 관리자 권한 이력
	 */
	@Transactional(readOnly = true)
	public List<PermissionHistoryDTO> findPermissionHistoryList(PersonalInfoLog vo){
		List<PermissionHistoryDTO> list = dao.findPermissionHistoryList(vo);
		if(list == null) new ArrayList<>();

		list.forEach(permissionHistoryDTO -> {
			// 권한이 변경된 대상 어드민 조회
			Admin findAdmin = adminService.findOneById(permissionHistoryDTO.getAdminId());
			// 권한 부여자 조회
			Admin findAuthorizer = adminService.findOneById(permissionHistoryDTO.getAuthorizerId());

			if(findAdmin == null || findAdmin.isDeleted()){
				permissionHistoryDTO.setEmail("[삭제된 사용자] " + permissionHistoryDTO.getAdminId());
				permissionHistoryDTO.setAdminName("[삭제된 사용자] " + permissionHistoryDTO.getAdminId());
			}else{
				permissionHistoryDTO.setEmail(findAdmin.getDecEmail());
				permissionHistoryDTO.setAdminName(findAdmin.getDecName());
			}

			if(findAuthorizer == null || findAuthorizer.isDeleted()){
				permissionHistoryDTO.setAuthorizerEmail("[삭제된 사용자] " + permissionHistoryDTO.getAuthorizerId());
				permissionHistoryDTO.setAuthorizerNm("[삭제된 사용자] " + permissionHistoryDTO.getAuthorizerId());
			}else{
				permissionHistoryDTO.setAuthorizerEmail(findAuthorizer.getDecEmail());
				permissionHistoryDTO.setAuthorizerNm(findAuthorizer.getDecName());
			}
		});

		return list;
	}

	/**
	 * 월별 메뉴 버튼 사용 현황 조회
	 */
	@Transactional(readOnly = true)
	public List<MenuUsageDTO> findMenuUsageList(PersonalInfoLog vo){
		List<MenuUsageDTO> list = dao.findMenuUsageList(vo);
		if(list == null) new ArrayList<>();

		list.forEach(menuUsageDTO -> {
			// worker id 로 해당하는 어드민 조회
			Admin findAdmin = adminService.findOneById(menuUsageDTO.getAdminId());
			// menu id 로 해당하는 메뉴 조회
			Menu findMenu = Menu.findById(menuUsageDTO.getMenuId());

			if(findAdmin == null || findAdmin.isDeleted()){
				menuUsageDTO.setEmail("[삭제된 사용자] " + menuUsageDTO.getAdminId());
				menuUsageDTO.setAdminName("[삭제된 사용자] " + menuUsageDTO.getAdminId());
			}else{
				menuUsageDTO.setEmail(findAdmin.getDecEmail());
				menuUsageDTO.setAdminName(findAdmin.getDecName());
			}

			menuUsageDTO.setMenuName(findMenu.getName());
		});

		return list;
	}

	/**
	 * 개인정보 관리자 리스트
	 */
	@Transactional(readOnly = true)
	public List<AccessAdminDTO> findAccessAdminList(PersonalInfoLog vo){
		List<AccessAdminDTO> list = dao.findAccessAdminList(vo);
		if(list == null) new ArrayList<>();

		list.forEach(accessAdminDTO -> {
			Admin findAdmin = adminService.findOneById(accessAdminDTO.getAdminId());

			if(findAdmin == null || findAdmin.isDeleted()){
				accessAdminDTO.setAdminName("[삭제된 사용자] " + accessAdminDTO.getAdminId());
				accessAdminDTO.setEmail("[삭제된 사용자] " + accessAdminDTO.getAdminId());
			}else{
				accessAdminDTO.setAdminName(findAdmin.getDecName());
				accessAdminDTO.setEmail(findAdmin.getDecEmail());
			}
		});

		return list;
	}



	/**
	 * 개인정보 페이지에 접근한 이력을 담은 로그를 저장한다
	 */
	@Transactional(rollbackFor = Exception.class)
	public int save(PersonalInfoLog vo) throws Exception {
		return dao.insert(vo);
	}
}
