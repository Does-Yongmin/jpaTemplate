package com.does.util;


import com.does.biz.domain.Base;
import com.does.biz.domain.Lang;
import com.does.util.http.DoesSession;

import java.util.Enumeration;
import java.util.Vector;

public class SessionUtil {

	private static final String LANG_KEY = "auth_lang";
	/**
	 * Session Key의 value 획득
	 * </pre>
	 * @param key
	 * @param session
	 * @return
	 */
	public static Object get( DoesSession session, String key ) {
		return session.getAttribute( key );
	}

	/**
	 * Session에 Key, value 형태로 저장하고, 이전에 저장되어있던 value 를 반환
	 * @param key
	 * @param value
	 * @param session
	 * @return
	 * 기존에 저장되어있던 value
	 */
	public static Object put( DoesSession session, String key, Object value ) {
		Object old = session.getAttribute( key );
		session.setAttribute( key, value );
		return old;
	}

	/**
	 * Session Key의 value 삭제하고 기존에 있던 value 를 반환
	 * @param key
	 * @param session
	 * @return
	 * - 기존에 있던 value 를 반환
	 */
	public static Object remove( DoesSession session, String key ) {
		Object old = session.getAttribute( key );
		session.removeAttribute( key );
		return old;
	}

	/**
	 * Session에 저장되어 있는 모든 Key 삭제후 저장되어있던 모든 value 들을 배열로 반환
	 * @param session
	 * @return
	 * - 저장되어있던 모든 value 들을 배열로 반환
	 */
	public static Object[] removeAllFrom(DoesSession session) {
		Enumeration<String>	names	= session.session().getAttributeNames();
		Vector<Object>		v		= new Vector<Object>();
		String				name	= null;
		while ( names.hasMoreElements() ) {
			name = names.nextElement();
			v.add( remove( session, name ) );
		}
		return v.toArray();
	}

	public static void setLang(DoesSession session, Base lang ) {
		put(session, LANG_KEY, lang);
	}
	public static Lang getLang(DoesSession session ) {
		return (Lang) get(session, LANG_KEY);
	}
}