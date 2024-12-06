package com.does.biz.controller.admin;

import com.does.annotation.PermissionCheck;
import com.does.biz.domain.admin.personalInfoLog.AccessAdminDTO;
import com.does.biz.domain.admin.personalInfoLog.MenuUsageDTO;
import com.does.biz.domain.admin.personalInfoLog.PermissionHistoryDTO;
import com.does.biz.domain.admin.personalInfoLog.PersonalInfoLog;
import com.does.biz.service.admin.PersonalInfoLogService;
import com.does.menu.Menu;
import com.does.util.StrUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@RequestMapping("/system/personal-info")
@Controller
public class PersonalInfoLogController {

	@Autowired
	private PersonalInfoLogService svc;

	/*
		개인정보 관리자 권한 이력
	 */
	@PermissionCheck("LIST")
	@GetMapping("/permission-history")
	public String list(Model model, PersonalInfoLog search){
		// 날짜 검색 비어있을 경우 이번달 검색
		initSearchDateIfEmpty(search);
		// 개인정보 메뉴에 대한 조회를 위해 파라미터 설정
		setPersonalInfoMenuIdInSearch(search);

		search.setTotalCount(svc.countPermissionHistory(search));
		List<PermissionHistoryDTO> list = svc.findPermissionHistoryList(search);

		model.addAttribute("list", list);
		model.addAttribute("search", search);

		return "/system/personalInfoLog/permissionHistory";
	}

	/*
		월별 메뉴 버튼 사용 현황
	 */
	@PermissionCheck("LIST")
	@GetMapping("/monthly-menu-usage")
	public String monthlyMenuUsage(Model model, PersonalInfoLog search){
		// 날짜 검색 비어있을 경우 이번달 검색
		initSearchDateIfEmpty(search);

		search.setTotalCount(svc.countMenuUsage(search));
		List<MenuUsageDTO> list = svc.findMenuUsageList(search);

		model.addAttribute("list", list);
		model.addAttribute("search", search);

		return "/system/personalInfoLog/menuUsage";
	}

	/*
		개인정보 관리자 리스트
	 */
	@PermissionCheck("LIST")
	@GetMapping("/access-admin")
	public String accessAdmin(Model model, PersonalInfoLog search){
		// 날짜 검색 비어있을 경우 이번달 검색
		initSearchDateIfEmpty(search);
		// 개인정보 메뉴에 대한 조회를 위해 파라미터 설정
		setPersonalInfoMenuIdInSearch(search);

		search.setTotalCount(svc.countAccessAdmin(search));
		List<AccessAdminDTO> list = svc.findAccessAdminList(search);

		model.addAttribute("list", list);
		model.addAttribute("search", search);

		return "/system/personalInfoLog/accessAdmin";
	}

	private void setPersonalInfoMenuIdInSearch(PersonalInfoLog search){
		/*
		    개인정보가 있는 메뉴에 접근 권한이 있는 관리자 리스트를 조회하기 위해
		    menu 중 개인정보 대상 메뉴 id 를 가져옴
		 */
		List<Menu> personalInfoMenuList = Menu.getPersonalInfoMenuList();
		List<String> menuIdList = personalInfoMenuList.stream().map(Menu::getId).collect(Collectors.toList());
		search.setMenuIdList(menuIdList);
	}


	/**
	 * 기본값으로 이번달 데이터를 검색하기 위해 파라미터를 세팅한다.
	 */
	private void initSearchDateIfEmpty(PersonalInfoLog search){
		String startDate = search.getStartDate();
		String endDate = search.getEndDate();

		// 날짜 검색이 모두 비어있을 경우 이번달 검색하는 걸로 세팅
		if(StrUtil.isEmpty(startDate) && StrUtil.isEmpty(endDate)){
			LocalDate today = LocalDate.now(ZoneId.of("Asia/Seoul"));
			LocalDate firstDateThisMonth = today.withDayOfMonth(1); // 이번달 첫 째날
			LocalDate lastDateThisMont = today.withDayOfMonth(today.lengthOfMonth()); // 이번달 마지막 날

			// String 으로 변환
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			String firstDateStr = firstDateThisMonth.format(formatter);
			String lastDateStr = lastDateThisMont.format(formatter);

			// 이번달 검색을 위해 할당
			search.setStartDate(firstDateStr);
			search.setEndDate(lastDateStr);
		}
	}

}