if (jQuery) {
	const plugins = [].join(' ');
	const toolbar = [
		'forecolor backcolor',								// 글자색, 글자배경색
		'bold italic underline strikethrough'				// 볼드, 이탤릭, 밑줄, 취소선
	].join(' | ');

	$.tinymce5Smaller = function(selector, _data) {
		tinymce.init({
			selector				: selector,		// 에디터 적용할 요소
			min_height				: 150,
			max_height				: 150,
			menubar					: false,		// File, Edit, View 등 메뉴바 표시 여부
			branding				: false,		// 에디터 우 하단에 TinyMCE 로고 보여줄지 여부
			paste_as_text			: false,		// 복붙했을 때 xml 등 스타일도 복사해서 붙여넣는 Powerpaste 기능을 사용할지 여부
			plugins					: plugins,
			toolbar					: toolbar,
			content_css				: _data.contentCss || '/include/tinyMCE5/boilerplate.css',
			relative_urls			: false,
			content_style			: 'body { font-family: Helvetica, Arial, sans-serif; }'
		});
	}
}