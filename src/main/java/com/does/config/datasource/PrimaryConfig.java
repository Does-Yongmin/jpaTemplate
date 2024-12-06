package com.does.config.datasource;

import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Slf4j
@Configuration
@MapperScan(value = "com.does.biz.repository", sqlSessionFactoryRef = "primarySqlSessionFactory")
@EnableTransactionManagement
public class PrimaryConfig {

	@Value("${spring.profiles.active}")
	private String activeProfile;
	
//	@Value("${spring.primary.datasource.jndi-name}")
//	private String jndiName;

	@Bean("primaryDatasource")
	@ConfigurationProperties(prefix="spring.primary.datasource")
	public DataSource datasource() {
//		return Arrays.asList("does", "stg", "prod").stream().anyMatch(activeProfile::equals) ? (new JndiDataSourceLookup()).getDataSource(jndiName)
//		: DataSourceBuilder.create().build();

		return DataSourceBuilder.create().build();
	}

	@Bean("primarySqlSessionFactory")
	public SqlSessionFactory sqlSessionFactory(@Qualifier("primaryDatasource") DataSource ds, ApplicationContext context) throws Exception {
		SqlSessionFactoryBean ssfBean = new SqlSessionFactoryBean();
		ssfBean.setDataSource(ds);
		ssfBean.setTypeAliasesPackage("com.does");
		ssfBean.setConfigLocation(context.getResource("classpath:mybatis/mybatis-config.xml"));
		ssfBean.setMapperLocations(context.getResources("classpath:mybatis/primary/**/*.xml"));
		return ssfBean.getObject();
	}

	@Bean("primarySqlSessionTemplate")
	public SqlSessionTemplate sqlSessionTemplate(@Qualifier("primarySqlSessionFactory") SqlSessionFactory ssf) {
		SqlSessionTemplate template = new SqlSessionTemplate(ssf);
		log.info("Custom Configuration :: Datasource :: Primary set");
		return template;
	}

	@Bean("primaryTransactionManager")
	PlatformTransactionManager transactionManager() {
		DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
		transactionManager.setDataSource(datasource());
		return transactionManager;
	}
}