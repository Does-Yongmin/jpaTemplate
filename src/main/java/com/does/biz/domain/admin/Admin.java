package com.does.biz.domain.admin;

import com.does.biz.domain.core.Base;
import com.does.biz.domain.log.LogTarget;
import com.does.util.StrUtil;
import com.does.util.http.DoesSession;
import com.does.util.login.LoginUser;
import lombok.*;
import lombok.extern.slf4j.Slf4j;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;
import javax.validation.constraints.AssertTrue;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Builder(builderClassName = "AdminBuilder")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ADMIN")
public class Admin extends Base implements LoginUser, LogTarget, HttpSessionBindingListener, Serializable {

	private String adminId;				// 관리자 아이디
	private String adminPw;				// 관리자 비밀번호
	private String adminPwSalt;        	// 관리자 비밀번호 해싱 솔트값
	@NotBlank(message = "이름을 입력해주세요.")
	@Size(max = 50, message = "이름 글자수 제한을 확인해주세요.")
	private String adminName;			// 관리자 이름

	@Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", message = "유효하지 않은 이메일 주소입니다.")
	@NotBlank(message = "이메일을 입력해주세요.")
	@Size(max = 50, message = "이메일 글자수 제한을 확인해주세요.")
	private String email;				// 관리자 이메일
	@Size(max = 50, message = "연락처 글자수 제한을 확인해주세요.")
	private String phone;				// 연락처

	private AdminStatus adminStatus;    // 관리자 계정 상태
	private String tempYn;				// 관리자 계정 임시상태 여부 (비밀번호 초기화)
	private	String idleYn;				// 관리자 계정 휴면상태 여부 (장기 미접속)
	private String emailAuthYn;        	// 이메일 인증 여부
	private String phoneAuthYn;        	// 휴대폰 인증 여부
	private String privacyConsentYn;   	// 개인정보처리방침 동의 여부
	private Date   privacyConsentDate; 	// 개인정보처리방침 동의 일자
	private String lastPw1;				// 예전에 사용한 비밀번호1
	private String lastPw2;				// 예전에 사용한 비밀번호2
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private String  permissionGroups;   // 소속된 권한 조회용 변수
	private Date	lastLoginDate;		// 관리자 관리 목록 페이지에서 각 계정들의 최종 로그인 일시를 보여주기 위한 변수.
	private Date	lastPwChangeDate;	// 로그인 시 마지막 비밀번호 변경 날짜를 체크하기 위한 변수.
	private boolean pwExpired;         	// 로그인 시 비밀번호 만료 여부 체크 위한 변수
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public void setTempYn(String tempYn)	{	this.tempYn = setYn(tempYn);	}
	public void setTempYn(boolean tempYn)	{	this.tempYn = setYn(tempYn);	}
	public void setIdleYn(String idleYn)	{	this.idleYn = setYn(idleYn);	}
	public void setIdleYn(boolean idleYn)	{	this.idleYn = setYn(idleYn);	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public String getEncPW()		{	return hashing(adminPw);	}

	public String getDecName()		{	return decrypt(adminName);	}
	public String getDecPhone()	    {	return decrypt(phone);		}
	public String getDecEmail()		{	return decrypt(email);		}

	public String getNameMasked()   {
		return StrUtil.masking(getDecName());
	}
	public String getEmailMasked()  {
		return StrUtil.masking(getDecEmail());
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public String getLastLoginPretty()		{	return ymdhms(lastLoginDate);	}
	public String getLastPwChangePretty() {	return ymdhms(lastPwChangeDate);	}
	public String getNameId()			{	return String.format("%s(%s)", getDecName(), adminId);	}
	public boolean hasAdminId()			{	return has(adminId);	}
	public boolean hasAdminPw()			{	return has(adminPw);	}
	public boolean hasAdminName()       {   return has(adminName);  }
	public boolean isTemporal()			{	return isY(tempYn);		}
	public boolean isIdle()				{	return isY(idleYn);		}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	@AssertTrue(message = "아이디는 4자 이상 입력해주세요.")
	public boolean isValidAdminIdLength() {	return !isNew() || adminId != null && adminId.length() >= 4;	}
	@AssertTrue(message = "아이디는 숫자, 영문, 점(.), 밑줄(_)만 사용 가능합니다.")
	public boolean isValidAdminIdLetter() {	return !isNew() || adminId != null && adminId.equals(adminId.replaceAll("[^\\w_\\.]", ""));	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	@Setter
	private boolean multiLogin;
	@Override	public boolean isMultiLogin()		{	return multiLogin;		}
	@Override	public boolean isEmpty()			{	return !has(adminId) && !has(adminName) && !has(email);	}
	@Override	public boolean hasAuth(String menuId) {
		return true;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	@Override	public String getTargetId()		{ return adminId; }
	@Override	public String getTargetName()	{ return getDecName(); }
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private static final Map<String, DoesSession> map = new HashMap<>();

	@Override
	public void valueBound(HttpSessionBindingEvent arg0) {
		DoesSession already = map.get(adminId);
		DoesSession current = new DoesSession(arg0.getSession());

		if (already != null) {					// 현재 로그인한 계정과 동일한 ID 를 가진 계정이 로그인되어있는데,
			String pastId = already.getId();
			String currId = current.getId();
			if (!currId.equals(pastId)) {		// 그 계정의 세션이 현재 세션과 다른 세션인 경우
				try {
					Admin admin = already.getLoginUser();
					admin.setMultiLogin(true);	// 그 계정을 '중복로그인' 상태로 지정, 그 세션의 LoginFilter 에서 세션 종료처리.
				}
				catch (RuntimeException e) {
					log.error("Old Session has been invalidated", e);
				}
			}
		}

		map.put(adminId, current);
	}

	@Override
	public void valueUnbound(HttpSessionBindingEvent arg0) {
		map.remove(adminId);
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * 기존 useYn (Y, N) 이 아닌 AdminStatus (R, Y, N, W, D) 를 사용하기 때문에
	 * 동일한 로직 적용 위해 override 함
 	 */
	@Override public boolean isUse()		{ return adminStatus == AdminStatus.Y; }

	@Override public boolean isLocked()		{ return adminStatus == AdminStatus.N; }
	@Override public boolean isReady()		{ return adminStatus == AdminStatus.R; }

    @Override public boolean isWithdraw()	{ return adminStatus == AdminStatus.W; }
	@Override public boolean isDeleted()	{ return adminStatus == AdminStatus.D; }

	/**
	 * 사용 불가 상태의 계정 (W: 탈퇴, D: 개인정보 삭제)
	 */
	public boolean isDeactivated()      	{ return isWithdraw() || isDeleted(); }
}
