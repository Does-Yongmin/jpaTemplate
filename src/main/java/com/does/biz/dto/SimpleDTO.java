package com.does.biz.dto;

import com.does.biz.domain.simple.Simple;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
public class SimpleDTO {
	private String name;
	
	public static SimpleDTO convertToDTO(Simple vo) {
		if (vo == null)
			return null;
		
		return SimpleDTO.builder()
			.name(vo.getName())
			.build();
	}
	
	public static List<SimpleDTO> getListSimpleDTO(List<Simple> list) {
		return list.stream()
			.map(SimpleDTO::convertToDTO)
			.collect(Collectors.toList());
	}
	
	public static SimpleDTO getSimpleDTO(Simple vo) {
		return convertToDTO(vo);
	}
}
