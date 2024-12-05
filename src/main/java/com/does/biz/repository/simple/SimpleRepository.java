package com.does.biz.repository.simple;

import com.does.biz.domain.simple.Simple;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SimpleRepository extends JpaRepository<Simple, Long>, SimpleRepositoryCustom {
}
