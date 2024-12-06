package com.does.biz.controller.admin;

import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.log.LogType;
import com.does.biz.domain.log.Log;
import com.does.biz.service.admin.AdminService;
import com.does.biz.service.admin.LogService;
import com.does.exception.validation.ValidException;
import com.does.exception.validation.ValidExceptionBack;
import com.does.http.DoesRequest;
import com.does.util.PwUtil;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.validation.constraints.NotBlank;


/**
 * 비밀번호 변경용 컨트롤러
 */

@Controller
@RequestMapping("/pw")
@Validated
@Slf4j
public class PasswordController {

	@Autowired  private DoesRequest request;
	@Autowired	private DoesSession session;	// 세션 관련 작업 시 사용.
	@Autowired	private AdminService adminService;
	@Autowired  private LogService logService;

	@GetMapping("/change")
	public String changePwView(Model model){
		Admin loginUser = session.getLoginUser();

		// 필수 비밀번호 변경 대상인지 확인
		checkPwChangeRequirement(loginUser);

		model.addAttribute("isPwExpired",   loginUser.isPwExpired());
		model.addAttribute("isTemporal",    loginUser.isTemporal());

		return "/system/admin/changePw";
	}

	@PostMapping("/change")
	public Object changePw(@RequestParam @NotBlank(message = "기존 비밀번호를 입력해주세요") String param1,
	                       @RequestParam @NotBlank(message = "새 비밀번호를 입력해주세요") String param2,
	                       @RequestParam @NotBlank(message = "새 비밀번호 확인을 입력해주세요") String param3) throws ValidExceptionBack {
		Admin loginAdmin	= session.getLoginUser();
		String	adminId		= loginAdmin.getAdminId();

		PwUtil.checkSequential(param2);
		PwUtil.checkRepeated(param2);
		PwUtil.changPWRuleCheck(adminId, param1, param2, param3);
		if(!adminService.hasAdmin(adminId, param1))					throw new ValidExceptionBack("기존 비밀번호가 일치하지 않습니다.");
		if(adminService.isUsedPw(adminId, param2))					throw new ValidExceptionBack("최근 비밀번호 두 개는 사용할 수 없습니다.");
		if(adminService.modifyPwMySelf(loginAdmin.getSeq(), param2) == 1) {
			session.logout();
			return DoesRequest.alert("비밀번호가 수정되었습니다. 다시 로그인해주세요.", ":ROOT");
		} else {
			throw new ValidExceptionBack("비밀번호를 변경하지 못했습니다.");
		}
	}

	/**
	 * 비밀번호 변경 미루기
	 */
	@PostMapping("/delay-change")
	public Object delayChange(){
		Admin loginUser	= session.getLoginUser();

		// 필수로 비밀번호를 변경해야 하는 대상인지 확인한다
		checkPwChangeRequirement(loginUser);

		try {
			// 비밀번호 변경 미룸 로그 저장
			logService.insert(Log.createAdminActionLog(request, session, LogType.PW_DEFER));
		}catch (ValidException e){
			log.error("비밀번호 변경 미루기 중 오류 발생 : {}", e.getMessage());
			return DoesRequest.alert("비밀번호 변경을 정상적으로 미루지 못했습니다.", ":BACK");
		}

		// 비밀번호 변경 미루기후, 로비 화면으로 가기 위해서 expired 를 false 로 처리함
		loginUser.setPwExpired(false);
		return DoesRequest.alert("성공적으로 비밀번호 변경을 미루었습니다.", "/lobby");
	}


	/**
	 * 필수로 비밀번호를 변경해야 하는 대상인지 확인한다
	 */
	private void checkPwChangeRequirement(Admin admin){
		boolean isPwExpired   = admin.isPwExpired();  // 비밀번호 변경일 초과 여부
		boolean isTemporal    = admin.isTemporal();   // 비밀번호 초기화 여부

		// 비밀번호 변경 대상이 아닐 경우 로비로 리다이렉트 처리
		if(!isPwExpired && !isTemporal)
			throw new ValidException("비밀번호 변경 대상이 아닙니다.", "/lobby");
	}
}