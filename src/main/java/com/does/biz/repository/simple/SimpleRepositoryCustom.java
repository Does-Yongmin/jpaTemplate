package com.does.biz.repository.simple;

import com.does.biz.domain.simple.Simple;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface SimpleRepositoryCustom {
	List<Simple> findAll();
	long countAll();
	List<Simple> findPageByName(String name, Pageable pageable);
	long countByName(String name);

}
