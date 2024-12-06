package com.does.biz.controller.admin;

import com.does.annotation.PermissionCheck;
import com.does.annotation.PersonalInfoCheck;
import com.does.biz.domain.admin.AdminStatus;
import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.admin.permission.PermissionGroup;
import com.does.biz.domain.admin.personalInfoLog.PersonalInfoLog;
import com.does.biz.service.admin.AdminService;
import com.does.biz.service.admin.LogService;
import com.does.biz.service.admin.permission.PermissionGroupService;
import com.does.exception.ajax.AjaxException;
import com.does.exception.validation.ValidException;
import com.does.exception.validation.ValidExceptionBack;
import com.does.http.DoesRequest;
import com.does.util.SecureRandomUtil;
import com.does.util.StrUtil;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 관리자 관리용 컨트롤러
 */

@Slf4j
@Controller
@SuppressWarnings("all")
@RequestMapping("/system/admin")
public class AdminController {

	@Autowired	private DoesRequest	request;
	@Autowired	private DoesSession session;
	@Autowired	private AdminService adminService;
	@Autowired  private LogService logService;
	@Autowired 	private PermissionGroupService permissionGroupService;


	/*
	    PersonalInfoCheck aspect로 개인정보 있는 메뉴 접근 로깅시 조회된 대상을 model 에서 꺼내오기 위해 attributeName 으로 지정한 값
	 */
	private final String DATA = "data";
	private final String LIST = "list";


	@PersonalInfoCheck(accessType = PersonalInfoLog.AccessType.SELECT_LIST, targetTb = "T_LWT_ADMIN", attributeName = LIST)
	@PermissionCheck("LIST")
	@GetMapping("/list")
	public String list(Model model, Admin search) throws ValidException {
		List<Admin>	list = adminService.findPage(search);
		int	count = adminService.count(search);
		search.setTotalCount(count);

		model.addAttribute("search"	, search);
		model.addAttribute(LIST	, list);    // 개인정보 조회 대상 PersonalInfoCheck 의 target

		// 검색 필터 값
		model.addAttribute("adminStatus", AdminStatus.values());
		model.addAttribute("permissionGroups", permissionGroupService.getAllPermissionGroupMap());
		return "/system/admin/list";
	}

	@PermissionCheck("UPDATE")
	@ResponseBody
	@PostMapping("/resetPw")
	public JSONObject resetPw(Admin vo) {
		JSONObject json = new JSONObject();
		json.put("success", false);

		try {
			String seq = vo.getSeq();
			Admin target = adminService.findOne(seq);
			if (target.hasAdminId()) {
				String adminId = target.getAdminId();

				// 임시 비밀번호로 초기화.
				String newPw = SecureRandomUtil.createRandomWord(10);

				int result = adminService.resetPw(seq, newPw);
				if (result == 1) {
					// 임시 비밀번호 알림톡 발송
					authService.sendMessageNewPw(target.getDecPhone(), newPw);
					json.put("success", true);
					json.put("message", String.format("'%s' 계정의 비밀번호가 초기화되었습니다. 임시 비밀번호 : [%s]", adminId, newPw));
				}
			} else {
				json.put("message", "비밀번호를 초기화할 계정을 다시 확인해주세요.");
			}
		} catch (ValidException e){
			log.error("비밀번호 초기화 중 ValidException 오류 발생", e.getMessage());
			json.put("message", String.format("비밀번호 초기화에 실패했습니다.\r\n실패일시 : %s", new Date()));
		} catch(Exception e) {
			log.error("비밀번호 초기화 중 오류 발생", e.getMessage());
			json.put("message", String.format("비밀번호 초기화에 실패했습니다.\r\n실패일시 : %s", new Date()));
		}

		return json;
	}

	@PersonalInfoCheck(accessType = PersonalInfoLog.AccessType.SELECT_VIEW, targetTb = "T_LWT_ADMIN", attributeName = DATA)
	@PermissionCheck("VIEW")
	@GetMapping("/detail")
	public String detail(Model model, Admin search) throws ValidException {
		String seq = search.getSeq();
		Admin findAdmin = adminService.findOne(seq);
		model.addAttribute("search"		, search);
		model.addAttribute(DATA		, findAdmin); // 개인정보 조회 대상 PersonalInfoCheck 의 target

		// 사용자가 속한 권한 그룹 ( 현재는 관리자와 권한 1대1 매칭인데, 추후 1대N 변경 가능성 고려해서 로직은 유지함 )
		List<PermissionGroup> userPermissionGroupList = adminService.findAllPermissionByAdminSeq(seq);
		if(userPermissionGroupList != null && !userPermissionGroupList.isEmpty()){
			model.addAttribute("userPermissionGroup" 	, userPermissionGroupList.get(0));
		}
		// 전체 권한 그룹 리스트
		model.addAttribute("allPermissionGroupList"		, permissionGroupService.findAll());

		return "/system/admin/detail";
	}


	@PermissionCheck("SAVE")
	@PostMapping("/save")
	public ResponseEntity save(Admin vo,
	                           @RequestParam(required = false, value = "permissionGroupSeq") String permissionGroupSeq
	) throws ValidException {
		AdminStatus adminStatus = vo.getAdminStatus();
		if(adminStatus != AdminStatus.Y && adminStatus != AdminStatus.N)
			throw new ValidExceptionBack("계정 수정시에는 계정 상태값을 승인 또는 잠금 상태로만 설정 가능합니다.");

		int	result = adminService.save(vo);

		// 어드민이 속한 권한 그룹 수정
		if(result == 1){
			updateAdminPermissionGroup(vo, permissionGroupSeq);
		}

		String msg = "저장 되었습니다.";
		String url = "list?pageNum=" + vo.getPageNum();
		return	DoesRequest.alert(msg, url);
	}

	@PermissionCheck("APPROVE")
	@PostMapping("/approve")
	public ResponseEntity approve(Admin vo,
	                              @RequestParam(required = false, value = "permissionGroupSeq") String permissionGroupSeq
	) throws ValidException {
		AdminStatus adminStatus = vo.getAdminStatus();
		if(adminStatus != AdminStatus.Y)
			throw new ValidExceptionBack("계정 승인을 원할경우 권한그룹 선택후, 승인 항목을 체크해주세요.");
		if(StrUtil.isEmpty(permissionGroupSeq))
			throw new ValidExceptionBack("계정 승인시 권한그룹 설정이 필요합니다.");

		int result = adminService.approve(vo);
		String msg = "승인 되었습니다.";

		// 어드민이 속한 권한 그룹 수정
		if(result == 1){
			updateAdminPermissionGroup(vo, permissionGroupSeq);

			// 승인 완료시 해당 관리자에게 알림톡 발송
			try {
				Admin findAdmin = adminService.findOne(vo.getSeq());
				authService.sendMessageAdminApproval(findAdmin.getDecPhone(), findAdmin.getAdminId());
			}catch (ValidException e){
				log.info("관리자 승인완료 알림톡 발송 중 오류 발생 : {}", e.getMessage());
				msg = "승인 완료 되었으나, 승인 완료 알림톡 발송에 실패하였습니다.";
			}
		}

		String url = "list?pageNum=" + vo.getPageNum();
		return	DoesRequest.alert(msg, url);
	}

	/**
	 * old 권한 그룹과 new 권한 그룹을 비교하여, 어드민이 속해야 하는 권한 그룹을 수정한다.
	 * @param admin
	 * @param newPermissionGroupSeqList
	 */
	private void updateAdminPermissionGroup(Admin admin, String permissionGroupSeq){
		List<String> newPermissionGroupSeqList = new ArrayList<>();
		if(!StrUtil.isEmpty(permissionGroupSeq))
			newPermissionGroupSeqList.add(permissionGroupSeq);

		// 기존 권한 그룹
		List<String> oldPermissionGroupSeqList = adminService.findAllPermissionByAdminSeq(admin.getSeq())
				.stream().map(PermissionGroup::getSeq)
				.collect(Collectors.toList());

		// 권한 그룹 삭제 대상 (old 에는 있고, new 에는 없는 경우)
		List<String> removePermissionList = oldPermissionGroupSeqList.stream()
				.filter(oldSeq -> !newPermissionGroupSeqList.contains(oldSeq))
				.collect(Collectors.toList());

		// 권한 그룹 추가 대상 (old 에는 없고, new 에는 있는 경우)
		List<String> addPermissionList = newPermissionGroupSeqList.stream()
				.filter(newSeq -> !oldPermissionGroupSeqList.contains(newSeq))
				.collect(Collectors.toList());

		removePermissionList.forEach(groupSeq -> permissionGroupService.removeMemberFromPermissionGroup(admin, groupSeq));
		addPermissionList.forEach(groupSeq -> permissionGroupService.addMemberToPermissionGroup(admin, groupSeq));
	}

	@PermissionCheck("DELETE")
	@ResponseBody
	@PostMapping("/withdraw")
	public Map<String,Object> withdraw(@RequestParam(value="seq", defaultValue = "") String seqs) throws AjaxException {
		Map<String,Object> result = new HashMap<>();
		try {
			int count = adminService.withdraw(seqs);
			result.put("success", count > 0);
			result.put("msg", count + "개의 계정이 탈퇴 되었습니다.");
		} catch(ValidExceptionBack e) {
			throw new AjaxException(e.getMessage());
		} catch(Exception e) {
			log.error("회원탈퇴 처리중 오류 발생 : {}", e.getMessage());
			throw new AjaxException("탈퇴에 실패했습니다");
		}

		return result;
	}


	//////////////////////////////////////////////////////////////////////////////
	@PermissionCheck("LIST")
	@GetMapping("/chooseMembers")
	public String chooseMembers(Model model, Admin search) throws ValidException {
		// 승인 상태의 관리자만 조회되도록 설정
		search.setAdminStatus(AdminStatus.Y);

		List<Admin>	list	= adminService.findPage(search);
		int				count	= adminService.count(search);
		search.setTotalCount(count);

		model.addAttribute("search"	, search);
		model.addAttribute("list"	, list);
		return "/system/admin/chooseMembers";
	}
}
