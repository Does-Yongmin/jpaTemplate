package com.does.biz.repository.admin.permission;

import com.does.biz.domain.admin.permission.PermissionGroup;
import com.does.biz.domain.admin.permission.PermissionMember;
import com.does.biz.domain.admin.permission.Permission;
import com.does.biz.repository.DefaultDAO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface PermissionGroupRepository extends DefaultDAO<PermissionGroup> {

	PermissionGroup findByGroupName(String groupName); // 그룹명으로 조회

	int insertPermission(Permission permission);	    // 단일 메뉴에 대한 접근권한 삽입
	int deleteAllPermission(String groupSeq);			// 해당 그룹에 속한 모든 접근권한 삭제.

	int insertMember(PermissionMember permission);	// 권한 그룹에 속한 멤버 삽입
	int deleteMember(PermissionMember permission);    // 권한 그룹에 속한 멤버 삭제


	int deleteAllMember(String groupSeq);				// 해당 그룹에 속한 모든 멤버 삭제.


}