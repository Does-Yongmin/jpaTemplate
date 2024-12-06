package com.does.biz.domain.admin.permission;

import com.does.biz.domain.Base;
import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.log.LogTarget;
import com.does.exception.validation.ValidExceptionBack;
import com.does.util.StrUtil;
import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import java.io.Serializable;
import java.util.List;

@Data
public class PermissionGroup extends Base implements LogTarget, Serializable {

	@NotBlank(message = "권한그룹 이름을 입력해주세요.")
	private String	groupName;				// 권한그룹 이름

	private List<@Valid Permission>	permissions;	// 권한그룹이 소유한 권한목록
	private List<Admin>				membersInfo;	// 권한그룹에 소속된 멤버들 정보

	private List<PermissionMember>	members;		// 권한그룹 - 멤버 관계를 form 에서 받아 DB 에 저장

	//////////////////////////////////////////////////////////////////////////////
	public boolean hasPermission(final String menuId, final Level level) {
		return has(permissions)	&& permissions.stream().filter(o -> o.isTheMenu(menuId)).anyMatch(o -> o.hasPermission(level));
	}

	public boolean hasMembersInfo(){
		return has(membersInfo);
	}

	//////////////////////////////////////////////////////////////////////////////
	public boolean isPermissionsValid() {	return has(permissions);	}

	//////////////////////////////////////////////////////////////////////////////
	@Override	public String getTargetId()		{	return groupName;	}
	@Override	public String getTargetName()	{	return groupName;	}


	public void validate(){
		if(StrUtil.isEmpty(groupName)) throw new ValidExceptionBack("그룹 권한 이름을 입력해주세요.");
		if(!isPermissionsValid()) throw new ValidExceptionBack("권한을 추가해주세요.");
	}
}