package com.does.biz.domain.admin.permission;

import com.does.biz.domain.log.LogTarget;
import com.does.menu.Menu;
import lombok.Data;

import javax.validation.constraints.AssertTrue;
import java.io.Serializable;

@Data
//public class Permission implements LogTarget {
public class Permission implements LogTarget, Serializable {

	private String	groupSeq;	// 권한그룹 일련번호
	private String	menuId;		// 권한이 부여된 메뉴 ID
	private Level grantLevel;	// 권한레벨 ( LIST:목록조회, VIEW:상세조회, WRITE:신규생성, UPDATE:업데이트, DELETE:글 삭제 )

	//////////////////////////////////////////////////////////////////////////////
	/**
	 * 이 권한이, 주어진 메뉴에 대한 권한인지 여부를 반환.
	 */
	public boolean isTheMenu(String menuId)		{	return this.menuId != null && this.menuId.equals(menuId);		}
	public boolean hasPermission(Level level)	{	return this.grantLevel != null && this.grantLevel.has(level);	}

	//////////////////////////////////////////////////////////////////////////////
	@AssertTrue(message = "권한을 추가해주세요.")
	public boolean isPermissionsValid() {	return menuId != null && !menuId.isEmpty() && grantLevel != null;	}

	//////////////////////////////////////////////////////////////////////////////
	@Override
	public String getTargetId() {
		return menuId;
	}

	@Override
	public String getTargetName() {
		return Menu.findById(menuId).getName();
	}
}