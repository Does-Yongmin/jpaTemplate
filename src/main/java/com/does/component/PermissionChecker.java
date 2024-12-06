package com.does.component;

import com.does.biz.domain.admin.permission.Level;
import com.does.biz.domain.admin.permission.PermissionGroup;
import com.does.http.DoesRequest;
import com.does.menu.Menu;
import com.does.util.http.DoesSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class PermissionChecker {

	/**
	 * 컨트롤러 permission check 어노테이션 이 외에
	 * 관리자 권한을 체크하여 UI 변화(권한 있을때만 수정버튼 노출) 시키기 위함
	 */
	private final DoesSession session;
	private final DoesRequest request;


	/**
	 * 현재 request uri 에 level 권한이 있는지 여부 반환
	 * @param level
	 * @return
	 */
	public boolean hasPermissionLevelForCurrentUri(Level level){
		String requestUri = request.getRequestUri();
		Menu currentMenu = Menu.findByUrl(requestUri);
		if(currentMenu == null) return false;

		String menuId = currentMenu.getId();
		PermissionGroup permissionGroup = session.getPermGroup();
		return permissionGroup.hasPermission(menuId, level);
	}
}
