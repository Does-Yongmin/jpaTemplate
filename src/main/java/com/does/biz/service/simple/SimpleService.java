package com.does.biz.service.simple;

import com.does.biz.domain.simple.Simple;
import com.does.biz.dto.SimpleDTO;
import com.does.biz.repository.simple.SimpleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

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
	
	@Transactional(readOnly = true)
	public long countAll() {
		return simpleRepository.countAll();
	}
	
	@Transactional(readOnly = true)
	public List<SimpleDTO> findPageByName(String name, int pageNum, int pageSize, String sortDirection) {
		Pageable pageable = initPageable(pageNum, pageSize, "name", sortDirection);
		List<Simple> list = simpleRepository.findPageByName(name, pageable);
		return getListSimpleDTO(list);
	}
	
	@Transactional(readOnly = true)
	public long countByName(String name) {
		return simpleRepository.countByName(name);
	}
	
	@Transactional
	public long create(Simple simple) {
		Long seq = simple.getSeq();

		if (seq == null || !simpleRepository.existsById(seq)) {
			Simple createdEntity = simpleRepository.save(simple);
			return createdEntity.getSeq();
		}
		
		return 0;
	}
	
	@Transactional
	public long update(Simple simple) {
		Long seq = simple.getSeq();
		
		if (seq == null || !simpleRepository.existsById(seq)) {
			return 0;
		}

		Simple oldEntity = simpleRepository.getReferenceById(seq);
		
		// 업데이트 대상 필드만 변경
		oldEntity.setName(simple.getName());
		
		// TODO : 아래 Update 관련 공통 필드들은 Entity Listener 로 변경
		oldEntity.setUpdater(simple.getUpdater());
		oldEntity.setUpdaterIp(simple.getUpdaterIp());
		oldEntity.setUpdateDate(convertToDate(LocalDateTime.now()));
		
		Simple updatedEntity = simpleRepository.save(oldEntity);
		return updatedEntity.getSeq();
	}
	
	@Transactional
	public long save(Simple simple) {
		Long seq = simple.getSeq();
		
		// insert
		if (seq == null || !simpleRepository.existsById(seq)) {
			Simple createdEntity = simpleRepository.save(simple);
			return createdEntity.getSeq();
		}
		
		// update
		Simple oldEntity = simpleRepository.getReferenceById(seq);
		
		// 업데이트 대상 필드만 변경
		oldEntity.setName(simple.getName());
		
		// TODO : 아래 Update 관련 공통 필드들은 Entity Listener 로 변경
		oldEntity.setUpdater(simple.getUpdater());
		oldEntity.setUpdaterIp(simple.getUpdaterIp());
		oldEntity.setUpdateDate(convertToDate(LocalDateTime.now()));
		
		Simple updatedEntity = simpleRepository.save(oldEntity);
		return updatedEntity.getSeq();
	}
	
	@Transactional
	public long delete(Long seq) {
		if (seq == null || !simpleRepository.existsById(seq)) {
			return 0;
		}
		
		simpleRepository.deleteById(seq);
		return 1;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public Pageable initPageable(int page, int size, String sortBy, String sortDirection) {
		if (!"asc".equalsIgnoreCase(sortDirection) && !"desc".equalsIgnoreCase(sortDirection)) {
			sortDirection = "asc";
		}
		
		Sort.Direction direction = Sort.Direction.fromString(sortDirection);

		Sort sort = Sort.by(							// 정렬 우선 순위
			new Sort.Order(direction, sortBy),			// (1) sortBy 로 들어온 field 명
			Sort.Order.desc("createDate")		// (2) createDate
		);
		
		return PageRequest.of(page, size, sort);
	}
	
	private Date convertToDate(LocalDateTime localDateTime) {
		return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
	}
}
