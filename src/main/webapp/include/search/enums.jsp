<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%!
	// 공통
	public enum Use {
		Y("사용"),
		N("미사용");

		String name;
		Use(String name)		{	this.name = name;	}
		public String getName()	{	return name;		}
	}

	public enum Show {
		Y("공개"),
		N("비공개");

		String name;
		Show(String name)		{	this.name = name;	}
		public String getName()	{	return name;		}
	}

	// 아래는 관리자에서 사용
	public enum Idle {
		Y("휴면"),
		N("정상");

		String name;
		Idle(String name)		{	this.name = name;	}
		public String getName()	{	return name;		}
	}

	public enum Temp {
		Y("비활성"),
		N("활성");

		String name;
		Temp(String name)		{	this.name = name;	}
		public String getName()	{	return name;		}
	}

	public enum Lock {
		Y("해제"),
		N("잠금");

		String name;
		Lock(String name)		{	this.name = name;	}
		public String getName()	{	return name;		}
	}
%>