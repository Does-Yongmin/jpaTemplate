package com.does.biz.service.simple;

import com.does.biz.domain.simple.Simple;
import com.does.biz.dto.SimpleDTO;
import com.does.biz.repository.simple.SimpleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

import static com.does.biz.dto.SimpleDTO.convertToDTO;
import static com.does.biz.dto.SimpleDTO.getListSimpleDTO;

@Service
@RequiredArgsConstructor
public class SimpleService {
	private final SimpleRepository simpleRepository;
	
	@Transactional(readOnly = true)
	public List<SimpleDTO> findAll() {
		List<Simple> list = simpleRepository.findAll();
		return getListSimpleDTO(list);
	}
}
