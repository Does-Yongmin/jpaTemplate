package com.does.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by DOES-JIHUN on 2020-09-24.
 */
public class StrUtil {

	public static boolean isEmpty( String src ) {
		return	src == null ||
				src.trim().isEmpty() ||
				src.trim().equalsIgnoreCase("null");
	}
	public static boolean hasVal(String src) {
		return	!isEmpty(src);
	}
	public static String nvl( String src, String replace ) {
		return isEmpty(src) ? replace : src;
	}

	/**
	 * 주어진 인자의 마지막 글자가 한글인지 판단.
	 * @param param
	 * @return 마지막 글자가 한글이면 true.
	 */
	public static final boolean isKorean(String param) {
		char last = param.charAt(param.length()-1);			// 가장 마지막 글자.
		return 0xAC00 <= last && last <=0xD7A3;
	}

	/**
	 * 주어진 인자의 마지막 글자가 종성이 있는지를 판단.
	 * @param param
	 * @return 종성이 있으면 true.
	 */
	public static final boolean hasLastCons(String param) {
		char last = param.charAt(param.length()-1);			// 가장 마지막 글자.
		return (last - 0xAC00) % 28 > 0;
	}

	public static final String getJosaForOf(String param) {
		return isKorean(param)	? (hasLastCons(param) ? "을" : "를") : " 항목을";
	}
	public static final String getJosaIsOf(String param) {
		return isKorean(param)	? (hasLastCons(param) ? "은" : "는") : " 항목은";
	}
	public static final String getJosaGaOf(String param) {
		return isKorean(param)	? (hasLastCons(param) ? "이" : "가") : " 항목이";
	}

	public static String xssTagEvent( Object target ) {
		String src = target == null ? "" : target.toString();
		src = nvl( src, "" );
		if( !src.isEmpty() ) {
			String blackList =	"onopen,oncontextmenu,onfilterchange,onmouseout,onresume," +
								"onabort,oncontrolselect,onfinish,onmouseover,onreverse," +
								"onactivate,oncontrolselected,onfocus,onmouseup,onrowdelete," +
								"onactive,oncopycommand,onfocusin,onmousewheel,onrowenter," +
								"onafterprint,oncut,onfocusout,onmove,onrowexit," +
								"onafterupdate,oncutcommand,onfrop,onmoveend,onrowinserted," +
								"onbefore,ondataavailable,onhashchange,onmovestart,onrowsenter," +
								"onbeforeactivate,ondatasetchanged,onhelp,onoffline,onrowsinserted," +
								"onbeforecopy,ondatasetcomplete,oninput,ononline,onscroll," +
								"onbeforecut,ondblclick,onkeydown,onoutofsync,onseek," +
								"onbeforedeactivate,ondeactivate,onkeypress,onpaste,onselect," +
								"onbeforeeditfocus,ondrag,onkeyup,onpause,onselectionchange," +
								"onbeforepaste,ondragdrop,onlayoutcomplete,onpopstate,onselectstart," +
								"onbeforeprint,ondragend,onload,onprogress,onstart," +
								"onbeforeunload,ondragenter,onlosecapture,onpropertychange,onstop," +
								"onbeforeupdate,ondragleave,onmediacomplete,onreadystatechange,onstorage," +
								"onbegin,ondragover,onmediaerror,onredo,onsubmit," +
								"onblur,ondragstart,onmessage,onrepeat,onsyncrestored," +
								"onbounce,ondrop,onmousedown,onreset,ontimeerror," +
								"oncellchange,onend,onmouseenter,onresize,ontrackchange," +
								"onchange,onerror,onmouseleave,onresizeend,onundo," +
								"onclick,onerrorupdate,onmousemove,onresizestart,onunload," +
								"onurlflip,seeksegmenttime,oncanplay,oncanplaythrough,oncopy," +
								"ondurationchange,onpagehide,onsearch,ontimeupdate,onvolumechange," +
								"onended,onpageshow,onseeked,ontouchcancel,onwaiting," +
								"oninvalid,onplay,onseeking,ontouchend,onwheel," +
								"onloadeddata,onplaying,onshow,ontouchmove,onloadedmetadata," +
								"onratechange,onstalled,ontouchstart".toLowerCase();

			String[] arr = blackList.split(",");
			for(String s : arr) {
				while(src.contains(s)) {
					src = src.replaceAll("(?i)" + s, "");
				}
			}
		}
		return src;
	}

	/**
	 * 주어진 문자열에서 XSS 공격을 의심할 수 있는 문자열을 모두 제거.
	 * @param target
	 * @return XSS 공격에 사용될 수 있는 문자열이 제거된 문자열.
	 */
	public static String xssScript( Object target ) {
		String src = target == null ? "" : target.toString();
		src = nvl( src, "" );
		if( !src.isEmpty() ) {
			String blackList = "alert,append,applet,base,bgsound,binding,blink,charset,cookie,create,document,embed,eval,expression,frame,frameset,iframe,ilayer,innerHTML,javascript,layer,link,meta,msgbox,object,refresh,script,string,unescape,vbscript,void,xml,%73%63%72%69%70%74";

			String[] arr = blackList.split(",");
			for(String s : arr) {
				while(src.contains(s)) {
					src = src.replaceAll("(?i)" + s, "");
				}
			}
			src = xssTagEvent(src);
		}
		return src;
	}

	public static String xssReplaceAll( Object target ) {
		String src = target == null ? "" : target.toString();
		src = nvl( src, "" );
		if( !src.isEmpty() ) {
			String blackListTag = "menu,source,xml,col,abbr,colgroup,html,menuitem,textarea,address,datalist,iframe,meter,tfoot,applet,del,ilayer,object,thead,article,details,img,optgroup,time,aside,dfn,input,option,track,audio,dialog,map,output,var,base,div,prompt,param,video,bdo,embed,samp,progress,frameset,bgsound,fieldset,script,sub,alert,blink,figcaption,section,summary,link,blockquote,figure,select,sup,cite,button,form,small,table,code,caption,frame,log,tbody,meta,confirm";
			String blackListEvent = "onopen,oncontextmenu,onfilterchange,onmouseout,onresume," +
					"onabort,oncontrolselect,onfinish,onmouseover,onreverse," +
					"onactivate,oncontrolselected,onfocus,onmouseup,onrowdelete," +
					"onactive,oncopycommand,onfocusin,onmousewheel,onrowenter," +
					"onafterprint,oncut,onfocusout,onmove,onrowexit," +
					"onafterupdate,oncutcommand,onfrop,onmoveend,onrowinserted," +
					"onbefore,ondataavailable,onhashchange,onmovestart,onrowsenter," +
					"onbeforeactivate,ondatasetchanged,onhelp,onoffline,onrowsinserted," +
					"onbeforecopy,ondatasetcomplete,oninput,ononline,onscroll," +
					"onbeforecut,ondblclick,onkeydown,onoutofsync,onseek," +
					"onbeforedeactivate,ondeactivate,onkeypress,onpaste,onselect," +
					"onbeforeeditfocus,ondrag,onkeyup,onpause,onselectionchange," +
					"onbeforepaste,ondragdrop,onlayoutcomplete,onpopstate,onselectstart," +
					"onbeforeprint,ondragend,onload,onprogress,onstart," +
					"onbeforeunload,ondragenter,onlosecapture,onpropertychange,onstop," +
					"onbeforeupdate,ondragleave,onmediacomplete,onreadystatechange,onstorage," +
					"onbegin,ondragover,onmediaerror,onredo,onsubmit," +
					"onblur,ondragstart,onmessage,onrepeat,onsyncrestored," +
					"onbounce,ondrop,onmousedown,onreset,ontimeerror," +
					"oncellchange,onend,onmouseenter,onresize,ontrackchange," +
					"onchange,onerror,onmouseleave,onresizeend,onundo," +
					"onclick,onerrorupdate,onmousemove,onresizestart,onunload," +
					"onurlflip,seeksegmenttime,oncanplay,oncanplaythrough,oncopy," +
					"ondurationchange,onpagehide,onsearch,ontimeupdate,onvolumechange," +
					"onended,onpageshow,onseeked,ontouchcancel,onwaiting," +
					"oninvalid,onplay,onseeking,ontouchend,onwheel," +
					"onloadeddata,onplaying,onshow,ontouchmove,onloadedmetadata," +
					"onratechange,onstalled,ontouchstart";

			String[] arr = blackListTag.split(",");
			for(String s : arr) {
				while(src.contains(s)) {
					src = src.replaceAll("(?i)" + s, "");
				}
			}

			String[] eventArr = blackListEvent.split(",");
			for(String s : eventArr) {
				while(src.contains(s)) {
					src = src.replaceAll("(?i)" + s, "");
				}
			}
		}
		return src;
	}

	/**
	 * 인자로 받은 문자열에 대하여 xss 공격을 방지할 수 있도록 특정 문자열을 제거하는 함수.
	 * @author DOES_SONG
	 * @param target - 일반 또는 인코딩된 문자열
	 * @return xss 공격에 사용될 수 있는 문자열을 제거한 문자열
	 */
	public static String xss( Object target ) {
		String src = target == null ? "" : target.toString();
		// xssScript 적용시 일상적으로 사용하는 영문도 "" 로 바뀌어서 xssTagEvent만 적용
		src = xssTagEvent(src);
		src	= src.replaceAll("(\'|'|%27)"	, "&#39;")
				.replaceAll("(\"|%22)"		, "&#34;")
				.replaceAll("(<|%3C|&#60;)"	, "&lt;")
				.replaceAll("(>|%3E|&#62;)"	, "&gt;");

		return src;
	}

	public static String masking(String src) {
		src = nvl( src, "" );

		Pattern pat = Pattern.compile("(.{3})(.*)@(.+)");			// 이메일 표현 정규식
		Matcher mat = pat.matcher( src );
		if( mat.find() ) {											// 이메일로 판단되면
			String gr2 = mat.group( 2 ).replaceAll( ".", "*" );		// 이메일 아이디 부분을 맨 팝 3글자를 빼고 모두 * 로 변환
			return String.format("%s%s@%s", mat.group(1), gr2, mat.group(3));
		}


		pat = Pattern.compile("^\\d+$");							// 연락처 표현 정규식
		mat = pat.matcher( src );
		if( mat.find() ) {											// 연락처 번호로 판단되면
			String[][] tel_pat = {
					{ "^(01\\d)\\d{4}(\\d{4})$", "$1-****-$2" },
					{ "^(01\\d)\\d{3}(\\d{4})$", "$1-***-$2" },
					{ "^(07\\d)\\d{4}(\\d{4})$", "$1-****-$2" },
					{ "^(\\d{2})\\d{4}(\\d{4})$", "$1-****-$2" },
					{ "^(\\d{2})\\d{3}(\\d{4})$", "$1-***-$2" },
					{ "^(\\d{3})\\d{3}(\\d{4})$", "$1-***-$2" },
					{ "^(\\d{3})\\d{4}(\\d{4})$", "$1-****-$2" } };
			for( String[] arr : tel_pat ) {
				src = src.replaceAll( arr[0], arr[1] );				// 각 연락처 형식에 따라 마스킹 처리
			}
			return src;
		}


		String[] name_pat = {
				"^(.)(.)$",             // ID/이름 2자리 : a*
				"^(.)(.{1,3})(.)$",		// ID/이름 3~5자리: a*c, a**d, a***e
				"^(..)(...+)(.)$",		// ID/이름 6자리 이상 : ab***f
		};
		for(String s : name_pat) {
			pat = Pattern.compile(s);
			mat = pat.matcher( src );
			if (mat.find()) {
				if (mat.groupCount() == 2) {
					// 그룹이 2개일 때 (이름이 2글자)
					src = mat.group(1) + "*";
				} else if (mat.groupCount() == 3) {
					// 그룹이 3개일 때 (이름이 3글자 이상)
					src = mat.group(1) + mat.group(2).replaceAll(".", "*") + mat.group(3);
				}
				break;  // 패턴 매칭 후 종료
			}
		}
		return src;
	}

	public static String crlf2br(String src) {
		src = src == null ? "" : src;
		return src.replaceAll("\\r", "").replaceAll("\\n", "<br/>");
	}

	public static String overflowHidden(String src) {
		src = src == null ? "" : src;
		if (src.length() > 30) return src.substring(0, 30) + "...";
		else return src;
	}
}