package com.does.biz.controller;

import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.admin.permission.PermissionGroup;
import com.does.biz.service.admin.AdminService;
import com.does.exception.ajax.AjaxException;
import com.does.exception.validation.ValidException;
import com.does.exception.validation.ValidExceptionBack;
import com.does.exception.validation.ValidExceptionRoot;
import com.does.http.DoesRequest;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 관리자 본인 계정정보 관리용 컨트롤러
 */

@Slf4j
@Controller
@SuppressWarnings("all")
@RequestMapping("/myInfo")
public class MyInfoCTR {

	@Autowired	private DoesRequest	request;
	@Autowired	private DoesSession session;
	@Autowired  private AdminService adminService;

	@GetMapping("/detail")
	public String detail(Model model) throws ValidException {
		Admin	loginUser = session.getLoginUser();
		if(loginUser == null) throw new ValidExceptionRoot("로그인이 필요합니다"); // 로그인 하지 않은 상태에서 myinfo 페이지 접근 제한

		// 로그인 되어 있는 adminId 로 개인정보 재조회
		Admin data = adminService.findOneById(loginUser.getAdminId());

		// 권한은 재로그인시 적용됨
		List<PermissionGroup> premissionGroupList = session.getPermGroupList();

		model.addAttribute("data"	, data);
		model.addAttribute("premissionGroupList", premissionGroupList);

		return "/myInfo/detail";
	}


	/**
	 * 마이페이지 회원 탈퇴
	 *
	 * AdminCTR 경로는 권한이 있어야만 접근 가능하기 때문에
	 * 자신의 계정을 탈퇴하는 것은 myInfoCTR 에 놓음
	 */
	@ResponseBody
	@PostMapping("/withdraw")
	public Map<String,Object> withdraw() throws AjaxException {
		Map<String,Object> result = new HashMap<>();
		try {
			boolean isSuccess = adminService.withdrawMySelf() == 1; // 1개의 계정 탈퇴시 성공
			result.put("success", isSuccess);

			if(isSuccess){
				result.put("msg", "정상적으로 회원탈퇴 되었습니다.");
				session.invalidate();   // 세션 만료 처리
			}else result.put("msg", "회원탈퇴에 실패했습니다. 잠시 후 다시 시도해주세요.");

		} catch(ValidExceptionBack e) {
			throw new AjaxException(e.getMessage());
		} catch(Exception e) {
			throw new AjaxException("탈퇴에 실패했습니다");
		}

		return result;
	}
}