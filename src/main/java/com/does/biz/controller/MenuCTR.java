package com.does.biz.controller;

import com.does.biz.domain.admin.permission.Permission;
import com.does.menu.Menu;
import com.does.util.http.DoesSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

/**
 * 메뉴목록을 API 형식으로 호출할 때 사용하는 컨트롤러.
 */

@RestController
@RequestMapping("/menu")
public class MenuCTR {

	@Autowired	private DoesSession			session;

	@GetMapping("/sitemap")
	public List<Menu> sitemapMenuList()	{
		return _availableMenu();
	}

	@GetMapping("/lnb")
	public List<Menu> lnbMenuList()	{
		return _availableMenu();
	}


	private List<Menu> _availableMenu() {
		List<Permission> permissions = session.getPermGroup().getPermissions();
		List<String> menuIds = permissions.stream()
										.map(Permission::getMenuId)
										.collect(Collectors.toList());

		Predicate<Menu> allowedMenu		= menu -> menuIds.contains(menu.getId());
		Predicate<Menu> childNotEmpty	= menu -> {
			List<Menu> child = menu.getChild().stream().filter(allowedMenu).collect(Collectors.toList());
			menu.setChild(child);
			return ! child.isEmpty();
		};

		return Menu.getAllMenu().stream()
				.filter(childNotEmpty)
				.collect(Collectors.toList());
	}
}