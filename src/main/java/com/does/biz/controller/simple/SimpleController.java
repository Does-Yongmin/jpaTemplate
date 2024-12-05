package com.does.biz.controller.simple;

import com.does.biz.domain.simple.Simple;
import com.does.biz.dto.SimpleDTO;
import com.does.biz.service.simple.SimpleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping("/api/v1/simple")
@RestController
@RequiredArgsConstructor
public class SimpleController {
	private final SimpleService simpleService;
	
	@GetMapping("/all")
	public ResponseEntity<Object> all() {
		List<SimpleDTO> list = simpleService.findAll();
		Map<String, Object> response = new HashMap<>();
		response.put("list", list);
		
		return ResponseEntity.status(HttpStatus.OK).body(response);
	}
	
	@GetMapping("/list")
	public ResponseEntity<Object> list(@RequestParam(value = "name", defaultValue = "") String name,
											 @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
											 @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
											 @RequestParam(value = "sortDirection", defaultValue = "asc") String sortDirection) {
		List<SimpleDTO> list = simpleService.findPageByName(name, pageNum, pageSize, sortDirection);
		long count = simpleService.countByName(name);
		
		Map<String, Object> response = new HashMap<>();
		response.put("count", count);
		response.put("list", list);
		
		return ResponseEntity.status(HttpStatus.OK).body(response);
	}
	
	@PostMapping("/update")
	public ResponseEntity<Map<String, Boolean>> update(@RequestBody @Valid Simple simple) {
		long result = simpleService.update(simple);
		Map<String, Boolean> response = new HashMap<>();
		response.put("success", result != 0);
		
		return ResponseEntity.status(HttpStatus.OK).body(response);
	}
	
	@PostMapping("/create")
	public ResponseEntity<Map<String, Boolean>> create(@RequestBody @Valid Simple simple) {
		long result = simpleService.create(simple);
		Map<String, Boolean> response = new HashMap<>();
		response.put("success", result != 0);
		
		return ResponseEntity.status(HttpStatus.OK).body(response);
	}
	
	@DeleteMapping("/delete")
	public ResponseEntity<Map<String, Boolean>> delete(@RequestParam(value = "seq") Long seq) {
		long result = simpleService.delete(seq);
		Map<String, Boolean> response = new HashMap<>();
		response.put("success", result != 0);
		
		return ResponseEntity.status(HttpStatus.OK).body(response);
	}
}
