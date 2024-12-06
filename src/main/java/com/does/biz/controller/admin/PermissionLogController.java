package com.does.biz.controller.admin;

import com.does.annotation.PermissionCheck;
import com.does.biz.domain.admin.permissionLog.PermissionLog;
import com.does.biz.service.admin.PermissionLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@RequestMapping("/system/access-permission")
@Controller
public class PermissionLogController {

	@Autowired	private PermissionLogService svc;

	@PermissionCheck("LIST")
	@RequestMapping("/list")
	public String list( Model model, PermissionLog search) {
		Integer		total	= svc.count(search);
		List<PermissionLog> list	= svc.findPage(search);

		search.setTotalCount(total);

		model.addAttribute("total"  ,	total);
		model.addAttribute("search" ,	search);
		model.addAttribute("paging" ,	search);
		model.addAttribute("list"   ,	list);
		return "/system/permissionLog/list";
	}

}