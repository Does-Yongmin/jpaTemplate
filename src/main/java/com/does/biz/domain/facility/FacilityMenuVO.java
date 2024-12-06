package com.does.biz.domain.facility;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.commons.text.StringEscapeUtils;

/**
 * 매장 및 시설 정보에서 카테고리 F&B 인 경우 필요한 메뉴 정보 클래스
 * */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FacilityMenu {
	private String seq;			// 일련번호
	private String refSeq;		// 부모 테이블의 일련번호
	private int orderNum;		// 정렬 순서. 작을수록 먼저 노출
	
	private String name;		// 메뉴명
	private int price;			// 가격
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public void unescapeStringFields() {
		name = StringEscapeUtils.unescapeHtml4(name);
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
