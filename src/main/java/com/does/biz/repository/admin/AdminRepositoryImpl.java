package com.does.biz.repository.admin;

import com.does.biz.domain.admin.Admin;
import org.springframework.data.jpa.repository.support.QuerydslRepositorySupport;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class AdminRepositoryImpl extends QuerydslRepositorySupport implements AdminRepositoryCustom {
	public AdminRepositoryImpl() {
		super(Admin.class);
	}
	
	@Override
	public int updatePw(Admin vo) {
		return 0;
	}
	
	@Override
	public int updatePhone(Admin vo) {
		return 0;
	}
	
	@Override
	public int checkLastPw(Admin vo) {
		return 0;
	}
	
	@Override
	public List<PermissionGroup> findAllPermissionByAdminId(String adminId) {
		return null;
	}
	
	@Override
	public List<PermissionGroup> findAllPermissionByAdminSeq(String adminId) {
		return null;
	}
	
	@Override
	public int withdrawBySeq(String seq) {
		return 0;
	}
	
	@Override
	public int withdrawInSeqs(List<String> seqs) {
		return 0;
	}
	
	@Override
	public int deletePersonalDataBySeq(String seq) {
		return 0;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
