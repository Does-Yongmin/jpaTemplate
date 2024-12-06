package com.does.biz.repository.admin;

import com.does.biz.domain.log.Log;
import com.does.biz.repository.DefaultDAO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface LogRepository extends DefaultDAO<Log> {

	Log	lastLog(Log vo);
	Log   findLastLockedLog(Log vo);
	int		loginFailCountInARow(String creatorId);

	int		insertAll(List<Log> list);
	int		deleteLogOver5years();

	/**
	 * 기존 코드와 다르게 session group by 없이 조회하는 쿼리
	 */
	int     countWithoutSessionGrouping(Log vo);
	List<Log> findPageWithoutSessionGrouping(Log vo);
}