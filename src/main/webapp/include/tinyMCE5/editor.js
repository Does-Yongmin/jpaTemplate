if (jQuery) {
	const plugins = [
						'lists', 'advlist',									// 툴바에 '목록' 기능 추가. 거기에 목록스타일 추가 (검은점, 빈 점, 네모 등)
						'link', 'autolink',									// 사용자가 에디터에서 url 을 직접 타이핑할 경우 url 을 감지하여 링크로 자동변환
						'image', 'media',
						'searchreplace',									// Ctrl + f 로 검색/교체하는 기능
						'table',											// 표 추가 기능
						'code',												// 소스보기 추가 기능
						'wordcount'											// 본문 단어 카운트 기능
	].join(' ');
	const toolbar = [
						/*'formatselect',*/ /*'fontselect',*/ 				// 문단, 폰트
						'fontsizeselect',									// 폰트사이즈
						'forecolor backcolor',								// 글자색, 글자배경색
						'bold italic underline strikethrough',				// 볼드, 이탤릭, 밑줄, 취소선
						'alignjustify alignleft aligncenter alignright',	// 균등정렬, 좌측, 가운데, 우측정렬
						'bullist numlist',									// 무순서 목록, 순서 목록
						'superscript subscript',							// 윗첨자, 아랫첨자
						/* 'outdent indent', */								// 내어쓰기, 들여쓰기
						/* 'table', */										// 표
						/* 'image media', */								// 이미지, 동영상
						'link code' 										// 링크, 소스보기
	].join(' | ');

	const _fontSizes = function() {
		const result = [];
		// 8px 부터 32px 까지 1px 간격으로 폰트 크기 지정
		for (let i = 0, font = 8; font <= 32; i++, font += 1) {
			result[i] = font + 'px';
		}
		return result.join(' ');
	}

	$.tinymce5 = function(selector, _data) {
		function _onInputChange(cb) {
			const file		= this.files[0];
			const reader	= new FileReader();

			reader.onload	= function () {
				const formData = new FormData();
				formData.append('file', file);

				const request = new getRequest();
				request.open('POST', _data.uploadUri || '/editor/upload', true);
				request.addEventListener('load', function() {
					let json = JSON.parse(this.responseText);
					if( json.success )	cb(json.uri, { title : json.name, alt : json.name });
					else				alert(json.msg);
				});
				request.onreadystatechange = () => request.status !== 200 ? alert('파일 타입 / 용량 제한을 확인해주세요.') : '';
				request.send(formData);
			};
			reader.readAsDataURL(file);
		}
		function _afterFilePick(cb, value, meta) {
			// cb	 : 에디터에 url 로 요소 추가.
			// value : 빈 값.
			// meta	 : 툴바에서 클릭된 기능 타입. { filetype: 'image', fieldname: 'src'} 또는 { filetype: 'media', fieldname: 'source'}
			const input		= document.createElement('input');
			input.type		= 'file';
			input.name		= 'file';
			input.onchange	= function() { _onInputChange.call(this, cb); };

			if( meta.filetype === 'image' )	input.accept = '.jpg, .jpeg, .gif, .png';
			if( meta.filetype === 'media' ) input.accept = '.mp4, .quicktime';

			input.click();
		}

		tinymce.init({
			selector				: selector,		// 에디터 적용할 요소
			min_height				: 300,
			max_height				: 1000,
			menubar					: false,		// File, Edit, View 등 메뉴바 표시 여부
			branding				: false,		// 에디터 우 하단에 TinyMCE 로고 보여줄지 여부
			paste_as_text			: true,			// 복붙했을 때 xml 등 스타일도 복사해서 붙여넣는 Powerpaste 기능을 사용할지 여부
			plugins					: plugins,
			toolbar					: toolbar,
			fontsize_formats		: _fontSizes(),
			image_title				: true,			// 이미지에 title 속성 추가할지 여부
			file_picker_types		: 'image media',
			content_css				: _data.contentCss || '/include/tinyMCE5/boilerplate.css',
			file_picker_callback	: _afterFilePick,
			relative_urls			: false,
			// remove_script_host		: false,
			content_style			: "body { font-family: Helvetica, Arial, sans-serif; font-size: 14px; }",
			setup: function (editor) {
				/*
					에디터 내용에 대해 색깔을 업데이트 하기 위한 함수 따로 반복 사용으로 따로 뺌
				 */
				const updateContent = function () {
					const lang = document.querySelector('.lang-select a.selected').getAttribute('data-lang');
					const now = editor.getContent(); // 현재 에디터에 입력되어 있는 내용

					if (lang && info && info[lang]) {
						info[lang].content = now;
						updateLangBoxColor(lang);
					} else if (lang && info && now === '') {
						info[lang].content = now;
						updateLangBoxColor(lang);
					}
				};
				editor.on('init', function () {
					// 기본 스타일 설정
					editor.getBody().style.fontSize = '14px';
				});
				// 에디터의 내용이 변경시 이벤트
				editor.on('input', function () {
					updateContent();
				});
				// backspace or delete 이벤트 (ctrl+a -> backspace 로 한번에 지운 경우 에도 동작하도록)
				// updateContent를 에디터 내용이 완전히 업데이트가 되고 나서 수행하기 위해 setTimeout
				editor.on('keydown', function (e) {
					if (e.keyCode === 8 || e.keyCode === 46) {
						setTimeout(updateContent, 0);
					}
				});
				// 'cut' 이벤트 - 내용 잘라내기
				editor.on('cut', function () {
					setTimeout(updateContent, 0);
				});
			}
		});
	}
}