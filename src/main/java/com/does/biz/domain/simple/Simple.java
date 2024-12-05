package com.does.biz.domain.simple;

import com.does.biz.domain.core.Base;
import lombok.*;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;


@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "SIMPLE")
public class Simple extends Base {
	@Column(name = "NAME")
	private String name;
	
	public void setName(String name) {
		this.name = name;
	}
}
