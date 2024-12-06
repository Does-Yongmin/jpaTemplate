package com.does.biz.controller.admin;

import com.does.biz.domain.log.Log;
import com.does.biz.service.admin.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@RequestMapping("/system/log")
@Controller
public class LogController {

	@Autowired	private LogService svc;

	/**
	 * 관리자 계정 관리 하단 관리자 활동로그 리스트 제공
	 *
	 * searchText 로 adminId 를 전달 받아 해당 관리자와 관련된 로그들을 DB 에서 조회함
	 */
	@RequestMapping("/list-in-admin")
	public String listInAdmin(Model model, Log search){
		int		    total	= svc.countWithoutSessionGrouping(search);
		List<Log> list	= svc.findPageWithoutSessionGrouping(search);

		search.setTotalCount(total);

		model.addAttribute("search" ,	search);
		model.addAttribute("paging" ,	search);
		model.addAttribute("list"   ,	list);

		return "/system/log/listInAdmin";
	}


}