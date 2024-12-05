package com.does.biz.repository.simple;

import com.does.biz.domain.simple.Simple;
import com.querydsl.jpa.JPQLQuery;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.support.QuerydslRepositorySupport;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.does.biz.domain.simple.QSimple.simple;

@Repository
public class SimpleRepositoryImpl extends QuerydslRepositorySupport implements SimpleRepositoryCustom {
	public SimpleRepositoryImpl() {
		super(Simple.class);
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	@Override
	public List<Simple> findAll() {
		return from(simple).fetch();
	}
	
	@Override
	public long countAll() {
		return from(simple).fetchCount();
	}
	
	@Override
	public List<Simple> findPageByName(String name, Pageable pageable) {
		JPQLQuery<Simple> query = from(simple).where(simple.name.eq(name));
		JPQLQuery<Simple> pagedQuery = getQuerydsl().applyPagination(pageable, query);
		return pagedQuery.fetch();
	}
	
	@Override
	public long countByName(String name) {
		return from(simple).where(simple.name.eq(name)).fetchCount();
	}
}
