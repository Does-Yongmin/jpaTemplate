package com.does.menu;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Configuration
public class MenuConfig {

    @PostConstruct
    public static void init() {
        List<Menu> list = new ArrayList<>();
        
        // #############################################################################################################
        list.add(new Menu("A09", "KV 관리", "/kv")
            .addChild(new Menu("01", "메인 KV 관리", "/main-kv", "/list"))
        );

        // #############################################################################################################
        // 개인정보 메뉴 설정 (Z0101)
        Menu adminMenu = new Menu("01", "관리자 계정 관리"		, "/admin"			    , "/list");
        adminMenu.setPersonalInfoMenu(true);    // 개인정보 대상 메뉴로 설정
        adminMenu.setMasterAdminFlagMenu(true); // 이 메뉴 권한을 가진 유저를 최고 관리자로 판단하도록 설정
        adminMenu.setApproveMenu(true);         // '승인' 이라는 권한이 있어야 하는 메뉴

        list.add(new Menu("Z01", "관리자 관리", "/system")
            .addChild(adminMenu)
            .addChild(new Menu("02", "그룹 권한 관리"		, "/permission-group"	, "/list"))
            .addChild(new Menu("03", "개인정보 운영현황"		, "/personal-info"		, "/permission-history"))
        );


        Menu.setAllMenu(list);
        log.info("Custom Configuration :: Menu :: All menu set");
    }
}