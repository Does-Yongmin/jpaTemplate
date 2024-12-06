package com.does.biz.service.admin;

import com.does.biz.domain.admin.AdminStatus;
import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.log.LogType;
import com.does.biz.domain.log.Log;
import com.does.biz.domain.admin.permission.PermissionGroup;
import com.does.biz.repository.admin.AdminDAO;
import com.does.biz.repository.admin.LogDAO;
import com.does.crypt.SHA256;
import com.does.crypt.SeedCBC;
import com.does.exception.validation.ValidException;
import com.does.exception.validation.ValidExceptionBack;
import com.does.util.PwUtil;
import com.does.util.StrUtil;
import com.does.util.http.DoesSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

@Service
@Slf4j
public class AdminService {

	@Autowired	private DoesSession session;	// 세션 관련 작업 시 사용.

	@Autowired	private AdminDAO	dao;
	@Autowired  private LogDAO      logDAO;

	//////////////////////////////////////////////////////////////////////////////
	@Transactional(readOnly = true)
	public int count(Admin vo) {
		return dao.count(vo);
	}

	//////////////////////////////////////////////////////////////////////////////
	@Transactional(readOnly = true)
	public Admin findOneByIdPw(String adminId, String adminPw) throws ValidExceptionBack {
		if( adminId == null || adminId.isEmpty() )	throw new ValidExceptionBack("아이디 또는 비밀번호를 입력해주세요.");
		if( adminPw == null || adminPw.isEmpty() )	throw new ValidExceptionBack("아이디 또는 비밀번호를 입력해주세요.");

		Admin search = Admin.builder().adminId(adminId).adminPw(adminPw).build();
		return dao.findOne(search);
	}
	@Transactional(readOnly = true)
	public Admin findOneByIdPw(Admin search) throws ValidExceptionBack {
		if( !search.hasAdminId() || !search.hasAdminPw() )	throw new ValidExceptionBack("아이디 또는 비밀번호를 입력해주세요.");
		return dao.findOne(search);
	}

	// 관리자 ID로 조회
	@Transactional(readOnly = true)
	public Admin findOneById(String adminId) {
		Admin search = Admin.builder().adminId(adminId).build();
		return dao.findOne(search);
	}

	@Transactional(readOnly = true)
	public Admin findOne(String seq) {
		return dao.findOneBySeq(seq);
	}

	@Transactional(readOnly = true)
	public boolean hasAdmin(String adminId) {
		return hasAdmin(adminId, null);
	}
	@Transactional(readOnly = true)
	public boolean hasAdmin(String adminId, String adminPw) {
		Admin search = StrUtil.isEmpty(adminPw) ? Admin.builder().adminId(adminId).build()
												  : createAdminWithHashedPw(adminId, adminPw);

		return dao.count(search) > 0;
	}

	@Transactional(readOnly = true)
	public List<Admin> findPage(Admin search) {
		return dao.findPage(search);
	}

	@Transactional(readOnly = true)
	public boolean isUsedPw(String adminId, String pw) {
		Admin search = createAdminWithHashedPw(adminId, pw);
		return dao.checkLastPw(search) > 0;
	}

	@Transactional(readOnly = true)
	public boolean isRegisteredPhone(String phone){
		Admin search = Admin.builder().phone(SeedCBC.encrypt(phone)).build();
		return dao.count(search) >= 1;
	}

	//////////////////////////////////////////////////////////////////////////////
	@Transactional(readOnly = true)
	public List<PermissionGroup> findAllPermissionByAdminId(String adminId) {
		return dao.findAllPermissionByAdminId(adminId);
	}
	@Transactional(readOnly = true)
	public List<PermissionGroup> findAllPermissionByAdminSeq(String adminSeq) {
		return dao.findAllPermissionByAdminSeq(adminSeq);
	}

	//////////////////////////////////////////////////////////////////////////////
	/**
	 * 관리자 상태 업데이트 (상세 페이지에서 업데이트 하는 값 : 계정 잠금, 회원 승인 상태)
	 * @param vo
	 */
	@Transactional
	public int save(Admin vo) throws ValidExceptionBack {
		return dao.updateStatus(vo);
	}

	/**
	 * 관리자 계정 승인 처리
	 */
	@Transactional
	public int approve(Admin vo) throws ValidExceptionBack{
		vo.setAdminStatus(AdminStatus.Y); // 승인 처리시에 설정할 수 있는 계정 상태값은 Y 로 제한
		return dao.updateStatus(vo);
	}

	/**
	 * 시스템에 의해 상태값이 변경하는 것은 스케줄러에서 로깅하기 위해 메소드 분리
	 */
	@Transactional
	public int saveBySystem(Admin vo) throws ValidExceptionBack {
		return dao.updateStatus(vo);
	}

	/**
	 * 관리자 생성 (회원가입을 통해 생성됨)
	 * @param vo
	 * @param confirm
	 * @return
	 * @throws ValidExceptionBack
	 */
	@Transactional
	public int register(Admin vo, String confirm) throws ValidExceptionBack {
		String adminId	= vo.hasAdminId() ? vo.getAdminId() : "";
		String adminName = vo.hasAdminName() ? vo.getAdminName() : "";

		final String	_a_id		= adminId.replaceAll("\\s", "").toLowerCase();
		final String[]	notAllow	= {"admin", "adm", "manager", "administrator"};
		final boolean	admExist	= hasAdmin(adminId);
		final boolean	badKeyword	= !admExist && Arrays.stream(notAllow).anyMatch(_a_id::contains);
		final boolean   invalidAdminNameLength = adminName.length() < 2 || adminName.length() > 25;
		final boolean   isRegisteredPhone = isRegisteredPhone(vo.getPhone());

		if(admExist)	throw new ValidExceptionBack("이미 사용중인 아이디입니다.");
		if(badKeyword)	throw new ValidExceptionBack("특정 키워드가 포함된 아이디는 사용할 수 없습니다.");
		if(invalidAdminNameLength) throw new ValidExceptionBack("이름은 2자 이상, 25자 이하로 입력 가능합니다.");
		if(isRegisteredPhone) throw new ValidExceptionBack("이미 등록된 전화번호는 사용할 수 없습니다.");

		PwUtil.checkSequential(vo.getAdminPw());
		PwUtil.checkRepeated(vo.getAdminPw());
		PwUtil.newUserPWRuleCheck(adminId, vo.getAdminPw(), confirm);

		// 비밀번호 해싱 솔트값 설정
		initPwWithSalt(vo);

		return dao.insert(vo);
	}

	/**
	 * 비밀번호, 솔트값 초기화
	 * @param vo
	 * @throws ValidExceptionBack
	 */
	private void initPwWithSalt(Admin vo) {
		String salt = SHA256.makeRandomSalt();
		String plainPw = vo.getAdminPw();

		if(StrUtil.isEmpty(salt) || StrUtil.isEmpty(plainPw))	{
			log.error("Failed to set pw with salt. cause plainPw or salt is empty.");
			throw new ValidExceptionBack("비밀번호 설정에 실패했습니다.");
		}

		vo.setAdminPwSalt(salt);
		vo.setAdminPw(SHA256.encrypt(plainPw, salt));
	}
	/**
	 * 아이디와 비밀번호로 Admin 객체를 생성하여 반환한다.
	 * @param id
	 * @param pw
	 * @return
	 */
	@Transactional(readOnly = true)
	public Admin createAdminWithHashedPw(String id, String pw){
		/*
		    아이디로 조회하여 salt값을 가져온다.
		    조회 되는 계정이 없을 경우, 이 후 로깅 로직을 태우기 위해 아이디와 비밀번호만 담아서 반환한다.
		 */
		Admin findAdmin = findOneById(id);
		if(findAdmin == null) {
			return Admin.builder().adminId(id).adminPw(pw).build();
		}

		String hashedPw = SHA256.encrypt(pw, findAdmin.getAdminPwSalt());
		return Admin.builder().adminId(id).adminPw(hashedPw).build();
	}

	/**
	 * 전화번호 업데이트
	 */
	@Transactional
	public int modifyPhone(String seq, String phone){
		Admin user = new Admin();
		user.setSeq(seq);
		user.setPhone(phone);
		user.setPhoneAuthYn("Y");

		return dao.updatePhone(user);
	}

	/////////////////////////////////////////////////////////////////////
	/**
	 * (공통 사용) 비밀번호 업데이트
	 */
	@Transactional
	public int updatePw(String seq, String newPwd, boolean isTemp){
		Admin user = new Admin();
		user.setSeq(seq);
		user.setAdminPw(newPwd);
		user.setTempYn(isTemp);

		// 변경된 비밀번호에 솔트 해싱 적용
		initPwWithSalt(user);

		return dao.updatePw(user);
	}

	/**
	 * 본인 계정 비밀번호 변경.
	 */
	@Transactional
	public int modifyPwMySelf(String seq, String newPwd) {
		return updatePw(seq, newPwd, false);
	}

	/**
	 * 본인 계정 비밀번호 찾기로 초기화
	 */
	@Transactional
	public int resetPwMySelf(String seq, String newPwd) {
		return updatePw(seq, newPwd, true);
	}

	/**
	 * 관리자에 의한 패스워드 초기화
	 */
	@Transactional
	public int resetPw(String seq, String newPwd){
		return updatePw(seq, newPwd, true);
	}
	/////////////////////////////////////////////////////////////////////


	/**
	 * 관리자에 의한 계정 잠금 해제
	 */
	@Transactional
	public int unlock(Admin admin) throws ValidException{
		admin.setAdminStatus(AdminStatus.Y);
		return dao.updateStatus(admin);
	}

	/**
	 * 본인 계정 잠금 해제 처리 (잠겨 있는 계정의 경우 세션에 로그인 정보가 없기 때문에 파라미터로 전달 받음)
	 */
	@Transactional
	public int unlockMySelf(Admin admin) throws ValidException{
		admin.setAdminStatus(AdminStatus.Y);
		return dao.updateStatus(admin);
	}

	/////////////////////////////////////////////////////////////////////


	/**
	 * 관리자에 의한 계정 탈퇴 처리
	 *
	 * @param seqs  탈퇴 처리할 계정들의 seq 배열
	 * @return
	 * @throws ValidExceptionBack
	 */
	@Transactional
	public int withdraw(String seqs) throws ValidExceptionBack {
		if( seqs == null || seqs.isEmpty() )	throw new ValidExceptionBack("탈퇴할 계정을 선택해주세요.");

		final String	loginSeq = session.getLoginUser().getSeq();			// 현재 로그인한 계정
		final String[]	seqsArr	 = seqs.split(",");					// 탈퇴 대상 배열
		final boolean	noSeqs	 = seqsArr == null || seqsArr.length == 0;	// 탈퇴할 대상이 있는지 확인
		List<String>	seqList	 = noSeqs ? null : Arrays.asList(seqsArr);	// 탈퇴 대상 배열을 리스트로 변환.
		final boolean	isSelf	 = !noSeqs && seqList.stream().anyMatch(loginSeq::equals);

		if( noSeqs )	throw new ValidExceptionBack("탈퇴할 계정을 선택해주세요.");
		if( isSelf )	throw new ValidExceptionBack("본인의 계정은 마이페이지에서 회원 탈퇴로만 삭제 가능합니다.");

		int result = dao.withdrawInSeqs(seqList);	// 계정들 탈퇴

		return result;
	}

	/**
	 * 본인 계정 탈퇴 처리 (세션에서 seq 값을 가져와 탈퇴 처리)
	 */
	@Transactional
	public int withdrawMySelf() throws ValidExceptionBack{
		final String	loginSeq = session.getLoginUser().getSeq();			// 현재 로그인한 계정
		if( loginSeq == null || loginSeq.isEmpty() )	throw new ValidExceptionBack("로그인 정보가 없습니다.");

		return dao.withdrawBySeq(loginSeq);
	}

	/**
	 * 개인정보 삭제 처리
	 */
	@Transactional
	public int deletePersonalDataBySeq(Admin vo) throws ValidExceptionBack{
		return dao.deletePersonalDataBySeq(vo.getSeq());
	}


	/**
	 * 현재 어드민이 잠금 처리된 어드민일 경우,
	 * 다른 어드민에 의해 잠금 처리된것인지 여부를 반환한다.
	 */
	@Transactional(readOnly = true)
	public boolean isLockedByOtherAdmin(String adminId) throws ValidException {
		Admin findAdmin = findOneById(adminId);

		if(findAdmin != null && findAdmin.isLocked()){
			Log search = Log.builder().targetId(adminId).build();
			Log lockedLog = logDAO.findLastLockedLog(search);
			if(lockedLog != null){
				// 다른 관리자에 의해 계정이 잠긴 경우.
				return lockedLog.getLogType() == LogType.LOCKED_BY_ADMIN;
			}
		}

		return false;
	}
}