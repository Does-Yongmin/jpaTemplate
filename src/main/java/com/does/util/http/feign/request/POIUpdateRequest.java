package com.does.util.http.feign.request;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class POIUpdateRequest {
    private String id;                      // POI 아이디
    private List<Language> languages;       // 언어 정보
    private List<Content> contents;         // 컨텐츠 정보

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Language {
        private String code; // 언어 코드
        private String value; // POI 명칭
    }

    @Data
    @Builder
    public static class Content {
        private String id;
        private List<String> categories;
        private List<Field> fields;

        @Data
        @Builder
        public static class Field {
            private String key;
            private List<Language> languages;
        }
    }
}
