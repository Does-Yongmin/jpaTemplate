package com.does.biz.domain.core;

import lombok.Getter;

import javax.persistence.*;
import java.util.Date;

@MappedSuperclass
@Getter
public abstract class Base {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "SEQ")
	protected Long seq;
	
	@Column(name = "USE_YN")
	protected String useYn;
	
	@Column(name = "CREATE_DATE")
	protected Date createDate;
	
	@Column(name = "CREATEOR")
	protected String creator;
	
	@Column(name = "CREATEOR_IP")
	protected String creatorIp;
	
	@Column(name = "UPDATE_DATE")
	protected Date updateDate;
	
	@Column(name = "UPDATER")
	protected String updater;
	
	@Column(name = "UPDATER_IP")
	protected String updaterIp;
	
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	
	public void setUpdater(String updater) {
		this.updater = updater;
	}
	
	public void setUpdaterIp(String updaterIp) {
		this.updaterIp = updaterIp;
	}
}