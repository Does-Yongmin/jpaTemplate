package com.does.biz.service.admin.permission;

import com.does.biz.domain.admin.Admin;
import com.does.biz.domain.admin.permission.PermissionGroup;
import com.does.biz.domain.admin.permission.PermissionMember;
import com.does.biz.domain.admin.permission.Permission;
import com.does.biz.repository.admin.permission.PermissionGroupDAO;
import com.does.exception.validation.ValidExceptionBack;
import com.does.util.StrUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Supplier;

@Service
public class PermissionGroupService {

	@Autowired	private PermissionGroupDAO	dao;

	//////////////////////////////////////////////////////////////////////////////
	@Transactional(readOnly = true)
	public int count(PermissionGroup vo) {
		return dao.count(vo);
	}

	//////////////////////////////////////////////////////////////////////////////
	@Transactional(readOnly = true)
	public PermissionGroup findOne(String seq) {
		return dao.findOneBySeq(seq);
	}

	@Transactional(readOnly = true)
	public PermissionGroup findByGroupName(String groupName) { return dao.findByGroupName(groupName); }

	@Transactional(readOnly = true)
	public List<PermissionGroup> findPage(PermissionGroup search) {
		return dao.findPage(search);
	}

	@Transactional(readOnly = true)
	public List<PermissionGroup> findAll(){
		PermissionGroup search = new PermissionGroup();
		return dao.findAll(search);
	}

	//////////////////////////////////////////////////////////////////////////////
	@Transactional
	public int save(PermissionGroup vo) throws ValidExceptionBack {
		boolean	isNew	= vo.isNew();

		/*
			그룹명으로 조회시 이미 존재하는 그룹이면서 아래 조건중 하나라도 해당될 경우, 등록 불가 처리
			1. 새로 추가할때
			2. 조회한 그룹과 현재 수정하는 그룹이 다를 때 (seq 로 판단)
		 */
		PermissionGroup findGroup = dao.findByGroupName(vo.getGroupName());
		if (findGroup != null && (isNew || !Objects.equals(findGroup.getSeq(), vo.getSeq()))) {
			throw new ValidExceptionBack("이미 존재하는 그룹명입니다.");
		}

		int result = isNew ? dao.insert(vo) : dao.update(vo);
		if( result > 0 ) {
			_savePermission	(vo, isNew);
		}

		return result;
	}

	/**
	 * 이미 존재하는 그룹명인지 확인한다
	 */
	@Transactional(readOnly = true)
	public boolean isExistGroupName(String groupName){
		PermissionGroup search = new PermissionGroup();
		search.setGroupName(groupName);

		return count(search) > 0;
	}

	/**
	 * 권한 그룹에 어드민 추가
	 * @param admin
	 * @param groupSeq
	 */
	@Transactional
	public void addMemberToPermissionGroup(Admin admin, String groupSeq) throws ValidExceptionBack{
		if(StrUtil.isEmpty(admin.getSeq())) throw new ValidExceptionBack("권한 그룹에 추가할 관리자 정보가 없습니다.");
		if(StrUtil.isEmpty(groupSeq)) throw new ValidExceptionBack("권한 그룹 정보가 없습니다.");

		PermissionMember member = new PermissionMember();
		member.setAdminSeq(admin.getSeq());
		member.setGroupSeq(groupSeq);

		dao.insertMember(member);
	}

	/**
	 * 권한 그룹에서 어드민 제거
	 * @param admin
	 * @param groupSeq
	 */
	@Transactional
	public void removeMemberFromPermissionGroup(Admin admin, String groupSeq) throws ValidExceptionBack{
		if(StrUtil.isEmpty(admin.getSeq())) throw new ValidExceptionBack("권한 그룹에서 삭제할 관리자 정보가 없습니다.");
		if(StrUtil.isEmpty(groupSeq)) throw new ValidExceptionBack("권한 그룹 정보가 없습니다.");

		PermissionMember member = new PermissionMember();
		member.setAdminSeq(admin.getSeq());
		member.setGroupSeq(groupSeq);

		dao.deleteMember(member);
	}

	private void _savePermission(PermissionGroup vo, boolean	isNew) {
		final String groupSeq = vo.getSeq();
		if( !isNew )	dao.deleteAllPermission(groupSeq);

		List<Permission> permissions = vo.getPermissions();
		permissions.forEach(p -> {
			p.setGroupSeq(groupSeq);
			dao.insertPermission(p);
		});
	}

	//////////////////////////////////////////////////////////////////////////////
	private <T> int _updateStatus(Supplier<T> constructor, Consumer<T> keySetter, Consumer<T> ynSetter, Function<T, Integer> updater) {
		T param = constructor.get();
		keySetter.accept(param);
		ynSetter.accept(param);

		return updater.apply(param);
	}
	@Transactional
	public int changeUseYn(PermissionGroup vo) {
		return _updateStatus(
				PermissionGroup::new,
				o -> o.setSeq(vo.getSeq()),
				o -> o.setUseYn(vo.isUse()),
				dao::updateStatus
		);
	}

	//////////////////////////////////////////////////////////////////////////////
	@Transactional
	public int delete(List<String> seqList) throws ValidExceptionBack {
		int result = dao.deleteInSeqs(seqList);	// 대상들 삭제
		if( result > 0 ) {
			seqList.forEach(dao::deleteAllPermission);
			seqList.forEach(dao::deleteAllMember);
		}

		return result;
	}

	/**
	 * 그룹 권한에 속해있는 관리자가 있는지 여부 반환
	 */
	@Transactional(readOnly = true)
	public boolean hasMemberInGroup(List<String> seqList) throws ValidExceptionBack{
		return seqList.stream().anyMatch(s -> {
			PermissionGroup findPermission = dao.findOneBySeq(s);
			return findPermission != null && findPermission.hasMembersInfo();
		});
	}

	/**
	 * 현재 등록된 모든 PermissionGroup 을 map 에 담아서 반환한다.
	 * {
	 *     seq : groupName
	 * }
	 */
	@Transactional(readOnly = true)
	public Map<String, String> getAllPermissionGroupMap(){
		Map<String, String> result = new HashMap<>();
		List<PermissionGroup> permissionGroupList = findAll();

		permissionGroupList.forEach(group -> {
			String seq = group.getSeq();
			String groupName = group.getGroupName();

			result.put(seq, groupName);
		});

		return result;
	}
}
