package com.does.biz.service.admin;

import com.does.biz.domain.admin.permissionLog.PermissionLog;
import com.does.biz.repository.admin.PermissionLogDAO;
import com.does.http.DoesRequest;
import com.does.util.http.DoesSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PermissionLogService {

	@Autowired	private PermissionLogDAO	PermissionLogDAO;

	@Autowired	private DoesRequest	request;	// 현재 요청
	@Autowired	private DoesSession	session;	// 세션 관련 작업 시 사용.

	//////////////////////////////////////////////////////////////////////////////
	@Transactional(readOnly = true)
	public int count(PermissionLog vo)				{	return PermissionLogDAO.count(vo);	}
	@Transactional(readOnly = true)
	public List<PermissionLog> findPage(PermissionLog vo)	{	return PermissionLogDAO.findPage(vo);	}

	//////////////////////////////////////////////////////////////////////////////
	@Transactional
	public int insert(PermissionLog PermissionLog)	{	return PermissionLogDAO.insert(PermissionLog);	}
	@Transactional
	public int insertAll(List<PermissionLog> list)	{	return PermissionLogDAO.insertAll(list);	}
}