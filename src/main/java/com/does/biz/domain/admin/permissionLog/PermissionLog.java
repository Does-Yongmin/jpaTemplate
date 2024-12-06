package com.does.biz.domain.admin.permissionLog;

import com.does.biz.domain.Base;
import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.log.LogTarget;
import com.does.http.DoesRequest;
import com.does.util.http.DoesSession;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PermissionLog extends Base {

	private String	creatorId;		// 권한수정자 계정
	private String	targetId;		// 권한이 변경된 계정
	private String	permBefore;		// 수정 전 권한
	private String	permAfter;		// 수정 후 권한

	//////////////////////////////////////////////////////////////////////////////
	public PermissionLog(DoesRequest request, DoesSession session, LogTarget target, String before, String after) {
		setCreatorIp(request.getIp());
		this.permBefore = before;
		this.permAfter = after;

		Admin worker = session.getLoginUser();
		if( worker != null )	setCreatorId(worker.getAdminId());
		if( target != null )	setTargetId(target.getTargetId());
	}
}