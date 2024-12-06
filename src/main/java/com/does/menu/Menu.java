package com.does.menu;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.*;
import java.util.stream.Collectors;

import static com.does.util.ContextPath.contextPath;

@NoArgsConstructor
public class Menu {

			String		id;
	@Getter	String		name;
			String      context;
			String		path;
	@Setter	Menu		parent;
	@Setter @Getter	boolean personalInfoMenu = false;    // 개인정보가 있는 메뉴인지 담고 있는 값 (관리자 계정 관리)
	@Setter @Getter boolean masterAdminFlagMenu = false; // flag 가 true 인 메뉴의 권한 가지고 있는 경우 최고 관리자로 판단 (관리자 계정 관리)
	@Setter @Getter boolean approveMenu = false;         // 현재 메뉴에 승인 항목이 필요한지 여부 (관리자 계정 관리, 매장 및 시설 관리)

	@Setter @Getter	List<Menu>	child;

	public Menu(String id, String name, String context, String path)	{
		this.id			= id;
		this.name		= name;
		this.context	= context;
		this.path		= path;
	}
	public Menu(String id, String name, String context)					{	this(id, name, context, null);	}

	/////////////////////////////////////////////////////////////////////////////////
	public Menu addChild(Menu newChild)	{
		newChild.setParent(this);
		if( child == null )	child = new ArrayList<>();
		child.add( newChild );
		return this;
	}
	public boolean isLeaf()				{	return child == null || child.isEmpty();			}
	public String getBreadcrum()		{	return parent == null ? name : String.format("%s > %s", parent.getBreadcrum(), name);	}
	public String getId()				{	return parent == null ? id : parent.getId() + id;	}
	public String getContext()			{	return String.format("/%s/%s", parent == null ? contextPath() : parent.getContext(), context).replaceAll("/+", "/");	}
	public String getAbsolutePath()		{	return String.format("/%s/%s", getContext(), path).replaceAll("/+", "/").replace("/null", "");	}

	/////////////////////////////////////////////////////////////////////////////////
	@Getter private static List<Menu>		allMenu;	// 전체 메뉴 목록을 보관할 리스트
	@Getter private static List<Menu>		leafMenu;	// 클릭 시 이동할 수 있는 단말메뉴들 목록을 보관할 리스트
			private static Map<String,Menu>	menuMap;	// 단말메뉴들을 ID 로 바로 찾기 위한 메뉴맵

	public static void setAllMenu(List<Menu> list) {
		if( allMenu == null ) {
			allMenu		= list;
			menuMap		= new LinkedHashMap<>();
			leafMenu	= new ArrayList<>();
			Queue<Menu> queue = new ArrayDeque<>();
			for(Menu menu : allMenu) {
				queue.offer(menu);
				while(!queue.isEmpty()) {
					Menu now = queue.poll();
					if( now.isLeaf() ) {
						menuMap.put(now.getId(), now);
						leafMenu.add(now);
					} else {
						List<Menu> children = now.getChild();
						queue.addAll(children);
					}
				}
			}
			allMenu = Collections.unmodifiableList(allMenu);
		}
	}
	public static List<Menu> getAllMenu() {
		return allMenu.stream().map(Menu::copy).collect(Collectors.toList());
	}

	public static Menu findById(String id)			{	return menuMap.get(id);							}
	public static Menu findByUrl(String url)		{
		return url == null || url.isEmpty()	? null
											: leafMenu.stream().filter(menu -> url.startsWith(menu.getContext())).findFirst().orElse(null);
	}

	/**
	 * 개인정보 메뉴 리스트 반환
	 */
	public static List<Menu> getPersonalInfoMenuList(){
		return leafMenu.stream().filter(Menu::isPersonalInfoMenu).collect(Collectors.toList());
	}

	/**
	 * 최고 관리자 대상인지 판단할 수 있는 메뉴 리스트 반환
	 */
	public static List<Menu> getMasterAdminFlagMenuList(){
		return leafMenu.stream().filter(Menu::isMasterAdminFlagMenu).collect(Collectors.toList());
	}

	/**
	 * 승인 항목이 필요한 메뉴 리스트 반환
	 */
	public static List<Menu> getApproveMenuList(){
		return leafMenu.stream().filter(Menu::isApproveMenu).collect(Collectors.toList());
	}

	public static boolean hasThisMenu(String id)	{	return menuMap.get(id) != null;					}
	public static boolean isMenuEmpty()				{	return allMenu == null || allMenu.isEmpty();	}

	public Menu copy() {
		Menu newMenu = new Menu(id, name, context, path);
		newMenu.setParent(parent);
		if( child != null ) {
			child.stream().map(Menu::copy).forEachOrdered(newMenu::addChild);
		}

		return newMenu;
	}
}