package com.does.biz.domain.log;

import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.core.Base;
import com.does.http.DoesRequest;
import com.does.util.http.DoesSession;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.does.crypt.SeedCBC.decrypt;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class Log extends Base {

	private String	sessionId;		// 작업자의 세션ID
	private String	creatorId;		// 작업자 계정ID
	private String	creatorName;		// 작업자 이름
	private String	targetId;		// 작업 대상 일련번호 또는 아이디( 다른 계정 또는 메뉴? )
	private String	targetName;		// 작업 대상 이름
	private String	detail;			// 작업 상세

	private LogGroup    logGroup;         // 로그 타입 그룹
	private LogType	    logType;	      // 로그 타입
	private String      refPermissionLog; // 권한 부여, 제거 작업시 관련 로그 seq

	private List<Log> children;	// sessionId 로 묶인 로그 목록들( 사용자가 로그인 후 활동한 모든 내역 목록 )

	//////////////////////////////////////////////////////////////////////////////
	public Log(DoesRequest request, DoesSession session, LogType type, Admin worker, LogTarget target, String msg) {
		String ip = request != null ? request.getIp() : "SYSTEM";
		sessionId = session != null ? session.getId() : "SYSTEM";

//		setCreatorIp(ip);
		logType		= type;
		logGroup    = type.getGroup();  // 로그 타입이 속한 그룹
		detail      = msg;

		// 작업자 정보
		if(worker != null){
			setCreatorId(worker.getAdminId());
			setCreatorName(worker.getAdminName());
		}

		// 대상 정보
		if(target != null){
			setTargetId(target.getTargetId());
			setTargetName(target.getTargetName());
		}
	}

	/**
	 * 어드민 본인의 액션 로그 생성
	 * worker : 본인 (현재 세션에 로그인 된 어드민)
	 * target : 본인 (현재 세션에 로그인 된 어드민)
	 *
	 * @param request
	 * @param session
	 * @param type
	 * @param msg
	 * @return
	 */
	public static Log createAdminActionLog(DoesRequest request, DoesSession session, LogType type, String msg){
		Admin mySelf = session.getLoginUser();
		return new Log(request, session, type, mySelf, mySelf, msg);
	}
	public static Log createAdminActionLog(DoesRequest request, DoesSession session, LogType type){
		return createAdminActionLog(request, session, type, null);
	}
	/**
	 *  로그인 하지 않았을 경우, session 에 사용자 정보가 없어서, worker, target 모두 파라미터로 넘겨 받아야 함
	 */
	public static Log createAdminActionLogNoLogin(DoesRequest request, DoesSession session, LogType type, Admin worker, LogTarget target){
		return new Log(request, session, type, worker, target, null);
	}

	/**
	 * 다른 어드민에 의한 어드민 변경 로그 생성
	 * worker : 작업 어드민 (현재 세션에 로그인 된 어드민)
	 * target : 대상 (어드민 또는 권한)
	 * 
	 * @param request
	 * @param session
	 * @param type
	 * @param target
	 * @param msg
	 * @return
	 */
	public static Log createAdminChangeLog(DoesRequest request, DoesSession session, LogType type, LogTarget target, String msg){
		Admin worker = session.getLoginUser();
		return new Log(request, session, type, worker, target, msg);
	}
	public static Log createAdminChangeLog(DoesRequest request, DoesSession session, LogType type, LogTarget target){
		return createAdminChangeLog(request, session, type, target, null);
	}

	/**
	 * 시스템에 의한 어드민 변경 로그 생성
	 * worker : SYSTEM
	 * target : 대상 어드민
	 * @param type
	 * @param target
	 * @return
	 */
	public static Log createAdminChangeLogBySystem(LogType type, LogTarget target){
		Admin worker = new Admin();
//		worker.setAdminId("SYSTEM");
//		worker.setAdminName("SYSTEM");

		return new Log(null, null, type, worker, target, null);
	}


	//////////////////////////////////////////////////////////////////////////////
	public String getDecCreatorName() {	return decrypt(creatorName);	}
	public String getDecTargetName() {	return decrypt(targetName);	}

	//////////////////////////////////////////////////////////////////////////////
	// List 페이지에서 상세페이지로 이동할 때 받을 파라미터명 wrapper
	public void setGid(String sessionId)	{	this.sessionId	= sessionId;	}
	public void setUid(String adminId)		{	this.creatorId	= adminId;		}

	//////////////////////////////////////////////////////////////////////////////
 	public String getAllLogTypes()	{
		return	Optional.ofNullable(children)
						.map(l -> {
							Collections.reverse(l);
							return l.stream()
									.map(child -> child.getLogType().getName())
									.distinct()
									.collect(Collectors.joining(", "));
						})
						.orElse("");
	}
	public String getCreatorNameId()	{	return ! has(creatorId) ? "" : String.format("%s(%s)", getDecCreatorName(), creatorId);	}
	public String getTargetNameId()	{	return ! has(targetId) ? "" : String.format("%s(%s)", getDecTargetName(), targetId);	}

}