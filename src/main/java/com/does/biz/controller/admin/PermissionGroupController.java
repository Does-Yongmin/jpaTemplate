package com.does.biz.controller.admin;

import com.does.annotation.PermissionCheck;
import com.does.biz.domain.admin.permission.Level;
import com.does.biz.domain.admin.permission.PermissionGroup;
import com.does.biz.service.admin.AdminService;
import com.does.biz.service.admin.permission.PermissionGroupService;
import com.does.exception.ajax.AjaxException;
import com.does.exception.validation.ValidExceptionBack;
import com.does.http.DoesRequest;
import com.does.menu.Menu;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@SuppressWarnings("all")
@RequestMapping("/system/permission-group")
public class PermissionGroupController {

	@Autowired	private DoesSession			session;
	@Autowired	private PermissionGroupService	svc;
	@Autowired  private AdminService            adminService;

	@PermissionCheck("LIST")
	@GetMapping("/list")
	public String list(Model model, PermissionGroup search) {
		int						total	= svc.count(search);
		List<PermissionGroup>	list	= svc.findPage(search);

		search.setTotalCount(total);

		model.addAttribute("total"	, total);
		model.addAttribute("search"	, search);
		model.addAttribute("paging"	, search);
		model.addAttribute("list"	, list);

		return "/system/permission/list";
	}

	@PermissionCheck("UPDATE")
	@ResponseBody
	@PostMapping("/changeUse")
	public Map<String,Object> changeState(PermissionGroup vo) throws AjaxException {
		Map<String,Object> result = new HashMap<>();
		try {
			int count = svc.changeUseYn(vo);
			result.put("success", count == 1);
		} catch(ValidExceptionBack e) {
			log.error("/system/permission-group/changeUse :: Exception", e);
			throw new AjaxException("상태 변경에 실패했습니다.");
		}
		return result;
	}

	@PermissionCheck("VIEW")
	@GetMapping("/detail")
	public String detail(Model model, PermissionGroup search) throws ValidExceptionBack {
		PermissionGroup	result	= svc.findOne(search.getSeq());

		model.addAttribute("search"			, search);
		model.addAttribute("data"			, result);
		model.addAttribute("menus"			, Menu.getAllMenu());
		model.addAttribute("grantLevels"	, Level.values());
		return "/system/permission/detail";
	}

	@PermissionCheck("SAVE")
	@PostMapping("/save")
	public ResponseEntity save(@Valid PermissionGroup vo) throws ValidExceptionBack {
		vo.validate();

		int		result	= svc.save(vo);
		String	msg		= "저장되었습니다.";
		String url 		= "list?pageNum=" + vo.getPageNum();
		return	DoesRequest.alert(msg, url);
	}

	@PermissionCheck("DELETE")
	@ResponseBody
	@PostMapping("/delete")
	public Map<String,Object> delete(@RequestParam(value="seq", defaultValue = "") String seqs) throws AjaxException {
		Map<String,Object> result = new HashMap<>();
		try {
			String msg = "삭제할 대상을 선택해주세요.";
			if( seqs == null || seqs.isEmpty() )	throw new ValidExceptionBack(msg);

			final String[]	seqsArr	 = seqs.split(",");					// 삭제 대상 배열
			final boolean	noSeqs	 = seqsArr == null || seqsArr.length == 0;	// 삭제할 대상이 있는지 확인
			List<String>	seqList	 = noSeqs ? null : Arrays.asList(seqsArr);	// 삭제 대상 배열을 리스트로 변환.

			if( noSeqs )	throw new ValidExceptionBack(msg);

			// 그룹에 속해 있는 관리자가 있을 경우, 권한 그룹 삭제 불가 (관리자 모두 제거후 권한 그룹 삭제 가능)
			if(svc.hasMemberInGroup(seqList))
				throw new ValidExceptionBack("권한그룹에 속해있는 관리자가 있을 경우, 삭제가 불가능합니다.");

			// 그룹 권한 삭제
			int count = svc.delete(seqList);
			result.put("success", count > 0);
			result.put("msg", count + "개의 권한이 삭제되었습니다.");
		} catch(ValidExceptionBack e) {
			throw new AjaxException(e.getMessage());
		} catch(Exception e) {
			throw new AjaxException("삭제에 실패했습니다");
		}
		return result;
	}
}