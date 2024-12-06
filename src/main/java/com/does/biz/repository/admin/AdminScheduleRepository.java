package com.does.biz.repository.admin;

import com.does.biz.domain.admin.Admin;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface AdminScheduleRepository {

	List<Admin> findAccountsAfter30DaysOfLastLogin();
	List<Admin> findAccountsAfter30DaysOfSignup();
	List<Admin> findAccountsAfter60DaysOfLock();
	List<Admin> findAccountsAfter365DaysOfWithdrawal();

}