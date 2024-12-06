package com.does.biz.domain.admin.permission;

import com.does.menu.Menu;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 권한레벨
 * LIST < VIEW < WRITE < UPDATE < DELETE < APPROVE
 * WRITE 권한이 있을 경우, 자동으로 LIST/VIEW 권한도 가지게됨
 */

@Getter @RequiredArgsConstructor
public enum Level {

	LIST	("목록"),
	VIEW	("상세"),
	WRITE	("추가"),
	UPDATE	("수정"),
	DELETE	("삭제"),
	APPROVE  ("승인")
	;

	private final String name;

	public boolean has(Level level) {
		return this.ordinal() >= level.ordinal();
	}

	/**
	 * 그룹 권한 관리에서 메뉴 별로 승인 항목을 노출해야하는지 여부를 확인한다.
	 */
	public boolean shouldDisplayApproveOption(String menuId){
		List<Menu> approveMenuList = Menu.getApproveMenuList();
		List<String> approveMenuIdList = approveMenuList.stream().map(Menu::getId).collect(Collectors.toList());

		return approveMenuIdList.contains(menuId);
	}
}