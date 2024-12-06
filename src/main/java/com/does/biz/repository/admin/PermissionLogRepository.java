package com.does.biz.repository.admin;

import com.does.biz.domain.admin.permissionLog.PermissionLog;
import com.does.biz.repository.DefaultDAO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface PermissionLogRepository extends DefaultDAO<PermissionLog> {

	int		insertAll(List<PermissionLog> list);
	int		deleteLogOver3years();
}