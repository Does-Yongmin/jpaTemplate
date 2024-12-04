package com.does.biz.domain.core;

import javax.persistence.*;
import java.util.Date;

@MappedSuperclass
public abstract class Base {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "SEQ")
	private Long seq;
	
	@Column(name = "USE_YN")
	private	String useYn;
	
	@Column(name = "CREATE_DATE")
	private Date createDate;
	
	@Column(name = "CREATEOR")
	private	String creator;
	
	@Column(name = "CREATEOR_IP")
	private String creatorIp;
	
	@Column(name = "UPDATE_DATE")
	private	Date updateDate;
	
	@Column(name = "UPDATER")
	private	String updater;
	
	@Column(name = "UPDATER_IP")
	private	String updaterIp;
}