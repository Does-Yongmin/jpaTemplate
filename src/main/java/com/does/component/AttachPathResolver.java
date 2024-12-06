package com.does.component;

import com.does.file.Attach;
import com.does.util.StrUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class AttachPathResolver {

	/**
	 * Attach 경로를 반환하는 컴포넌트
	 *
	 * 프로젝트별 파일 경로 prefix 를 value 로 주입받기 위해 component 로 선언
	 */

	@Value("${upload.root.uri}")
	private String rootUri;
	private static String staticRootUri;

	@PostConstruct
	public void init() {
		staticRootUri = rootUri;
	}

	public static String getOrgUri(Attach att) {
		String uri = null;
		if (att != null) {
			String path = att.getUriPath();
			String name = att.getNewName();
			
			path = path == null ? "" : path;
			if (path.isEmpty())                          uri = "";
			else if (path.startsWith("/datas"))			 uri = String.format("%s", path);
			else if (!StrUtil.isEmpty(staticRootUri))    uri = String.format("%s%s/%s", staticRootUri, path, name);
			else                                         uri = String.format("%s/%s", path, name);
		}
		
		return uri;
	}

}
