package com.does.biz.controller.simple;

import com.does.biz.domain.simple.Simple;
import com.does.biz.dto.SimpleDTO;
import com.does.biz.service.simple.SimpleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequestMapping("/api/v1/simple")
@RequiredArgsConstructor
@RestController
public class SimpleController {
	private final SimpleService simpleService;
	
	@GetMapping("/all")
	public ResponseEntity<Object> selectUserList() {
		List<SimpleDTO> userEntityList = simpleService.findAll();
		return new ResponseEntity<>(userEntityList, HttpStatus.OK);
	}
}
