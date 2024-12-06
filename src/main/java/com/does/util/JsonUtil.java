package com.does.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class JsonUtil {

	public static String getPrettyJsonString(Object obj) {
		try {
			ObjectMapper mapper = new ObjectMapper();
			mapper.enable(SerializationFeature.INDENT_OUTPUT);
			JsonNode jsonNode = mapper.convertValue(obj, JsonNode.class);
			return mapper.writerWithDefaultPrettyPrinter().writeValueAsString(jsonNode);
		} catch (JsonProcessingException e) {
			log.debug(e.getMessage());
			return null;
		}
	}
	
	public static void printPrettyJsonString(Object obj) {
		String result = getPrettyJsonString(obj);
		log.info("\n{}", result);
	}
}
