package com.does.biz.domain.facility;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.commons.text.StringEscapeUtils;

import java.util.List;

/**
 * 매장 및 시설 관리에서 제공언어에 따른 필드 분리를 위한 클래스
 * */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FacilityLangInfoVO {
	private String seq;						// 일련번호
	private String refSeq;					// 부모 테이블의 일련번호
	private int orderNum;					// 정렬 순서. 작을수록 먼저 노출
	
	private String lang;					// 제공언어. 단일 값 (예: "KO")
	private String name;					// 매장 및 시설명
	private String description;				// 소개
	private String tags;					// 태그. 콤마로 구분 (예: "lotte,world")
	private String searchKeywords;			// 검색키워드. 콤마로 구분 (예: "lotte,love")
	
	// 특정 카테고리 (예: F&B) 인 경우에만 사용
	private List<FacilityMenuVO> menuList;		// 메뉴 정보

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public String[] getTagsArrays() {
		return tags == null ? new String[0] : tags.split(",");
	}

	public String[] getSearchKeywordsArrays() {
		return searchKeywords == null ? new String[0] : searchKeywords.split(",");
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public void unescapeStringFields() {
		name = StringEscapeUtils.unescapeHtml4(name);
		description = StringEscapeUtils.unescapeHtml4(description);
		tags = StringEscapeUtils.unescapeHtml4(tags);
		searchKeywords = StringEscapeUtils.unescapeHtml4(searchKeywords);
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
