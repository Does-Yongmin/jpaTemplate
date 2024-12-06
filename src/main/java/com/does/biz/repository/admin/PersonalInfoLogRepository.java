package com.does.biz.repository.admin;

import com.does.biz.domain.admin.personalInfoLog.AccessAdminDTO;
import com.does.biz.domain.admin.personalInfoLog.MenuUsageDTO;
import com.does.biz.domain.admin.personalInfoLog.PermissionHistoryDTO;
import com.does.biz.domain.admin.personalInfoLog.PersonalInfoLog;
import com.does.biz.repository.DefaultDAO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface PersonalInfoLogRepository extends DefaultDAO<PersonalInfoLog> {

	int countPermissionHistory(PersonalInfoLog vo);
	int countMenuUsage(PersonalInfoLog vo);
	int countAccessAdmin(PersonalInfoLog vo);


	//////////////////////////////////////////////////////////////////////////////

	/**
	 * 개인정보 관리자 권한 이력 조회
	 */
	List<PermissionHistoryDTO> findPermissionHistoryList(PersonalInfoLog vo);

	/**
	 * 월별 메뉴 버튼 사용 현황 조회
 	 */
	List<MenuUsageDTO> findMenuUsageList(PersonalInfoLog vo);

	/**
	 * 개인정보 관리자 리스트
	 */
	List<AccessAdminDTO> findAccessAdminList(PersonalInfoLog vo);
}
