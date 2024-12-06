package com.does.biz.repository.admin;

import com.does.biz.domain.admin.Admin;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdminRepositoryCustom {

	int updatePw(Admin vo);
	int updatePhone(Admin vo);

	//////////////////////////////////////////////////////////////////////////////
	int checkLastPw(Admin vo);

	//////////////////////////////////////////////////////////////////////////////
	List<PermissionGroup> findAllPermissionByAdminId(String adminId);
	List<PermissionGroup> findAllPermissionByAdminSeq(String adminId);

	//////////////////////////////////////////////////////////////////////////////

	/**
	 * 계정 탈퇴 처리 (W)
 	 */
	int withdrawBySeq(String seq);
	int withdrawInSeqs(List<String> seqs);

	/**
	 * 개인정보 삭제
	 */
	int deletePersonalDataBySeq(String seq);

}