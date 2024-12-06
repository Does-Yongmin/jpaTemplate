package com.does.biz.controller;

import com.does.biz.domain.Search;
import com.does.biz.domain.admin.AdminStatus;
import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.customer.Notice;
import com.does.biz.domain.facility.Facility;
import com.does.biz.domain.admin.permission.Level;
import com.does.biz.domain.admin.permission.PermissionGroup;
import com.does.biz.repository.customer.NoticeDAO;
import com.does.biz.service.facility.FacilityService;
import com.does.biz.service.admin.AdminService;
import com.does.http.DoesRequest;
import com.does.menu.Menu;
import com.does.util.http.DoesSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

import static com.does.biz.domain.customer.Notice.Type.ADMIN_WEB;

/**
 * 게시판이 아닌, 사이트 운영에 필요한 URL 들의 맵핑을 위한 컨트롤러.
 */

@Controller
@RequiredArgsConstructor
public class UrlCTR {

	private final DoesRequest request;
	private final DoesSession session;
	private final AdminService adminService;
	private final FacilityService facilityService;
	private final NoticeDAO noticeDAO;

	@RequestMapping("/")
	public Object index()	{
		return "/index";
	}
	
	@RequestMapping("/lobby")
	public Object lobby(Model model) {
		return "/lobby";
	}

	
	/**
	 * 관리자 메인 대시보드
	 */
	@GetMapping("/main")
	public String main(Model model, @ModelAttribute("noticeSearch") Notice noticeSearch){
		/*
			현재 관리자가 최고 관리자인지 판단.
			최고 관리자일 경우에만 대시보드 노출
		 */
		List<Menu> masterAdminFlagMenuList = Menu.getMasterAdminFlagMenuList();
		PermissionGroup myPermissionGroup = session.getPermGroup();
		boolean isMasterAdmin = false;
		if(masterAdminFlagMenuList != null && myPermissionGroup != null){
			isMasterAdmin = masterAdminFlagMenuList.stream().anyMatch(menu -> {
				return myPermissionGroup.hasPermission(menu.getId(), Level.APPROVE);
			});
		}
		model.addAttribute("isMasterAdmin", isMasterAdmin);
		if(isMasterAdmin){
			/*
				미승인 사용자 수
			 */
			Admin adminSearch = new Admin();
			adminSearch.setAdminStatus(AdminStatus.R);
			int countReadyAdmin = adminService.count(adminSearch);
			model.addAttribute("countReadyAdmin", countReadyAdmin);

			/*
				미승인 매장 수
			 */
			Facility facilitySearch = Facility.builder().approveYn("N").build();
			int countReadyFacility = facilityService.count(facilitySearch);
			model.addAttribute("countReadyFacility", countReadyFacility);
		}

		/*
			관리자 공지 불러오기
		 */
		setDefaultPageRow(noticeSearch, 5);
		noticeSearch.setUseYn("Y");
		noticeSearch.setType(ADMIN_WEB);
		noticeSearch.setTotalCount(noticeDAO.count(noticeSearch));
		List<Notice> noticeList = noticeDAO.findRecentNotices(noticeSearch);
		model.addAttribute("noticeList", noticeList);

		return "/main";
	}

	/*
		기본 pageRow 를 10 말고 다른 값으로 설정
		첫 호출(사용자가 페이지당 행개수 안바꿨을때)시에는 defaultRow 값으로 세팅
	 */
	public void setDefaultPageRow(Search search, int defaultRow){
		String pageRowStr = request.getParameter("pageRow");
		String pageNumStr = request.getParameter("pageNum");

		if(pageRowStr == null && pageNumStr == null) search.setPageRow(defaultRow);
	}

}