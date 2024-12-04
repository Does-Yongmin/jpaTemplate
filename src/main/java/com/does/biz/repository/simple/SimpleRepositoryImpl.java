package com.does.biz.repository.simple;

import com.does.biz.domain.simple.QSimple;
import com.does.biz.domain.simple.Simple;
import com.querydsl.jpa.impl.JPAQueryFactory;
import org.springframework.data.jpa.repository.support.QuerydslRepositorySupport;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@Repository
public class SimpleRepositoryImpl extends QuerydslRepositorySupport implements SimpleRepositoryCustom {
	private final JPAQueryFactory queryFactory;
	
	public SimpleRepositoryImpl(EntityManager entityManager) {
		super(Simple.class); 		// Entity Path를 전달.
		this.queryFactory = new JPAQueryFactory(entityManager);
	}
	
	@Override
	public List<Simple> findAll() {
		QSimple simple = QSimple.simple;
		return queryFactory.selectFrom(simple).fetch();
	}
}
