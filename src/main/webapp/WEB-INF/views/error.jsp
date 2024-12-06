<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<style>
		section.section-overflow-hidden { position:absolute; width:99%; top:50%; margin-top:-195px; }
		div.section div.section-header { display:block; text-align:center; }
		div.section-header.header { margin-bottom:0; height:390px; }
		div.section-header.header #headline {margin-bottom:48px;font-size:2.7em;}
		div.section-header.header br { display:block; }
		div.section-header.header p {display:block; margin:0 auto;}
		div.section-header.header p#normalText {font-size: 1.2em;}
		div.section-header.header p#bottomBtn { margin-top:60px; }
		div.section-header.header p#bottomBtn a {text-decoration:none; padding:18px 45px;border-radius:8px;font-size: 15px; color:gray;}
		div.section-header.header p#bottomBtn a#goBack {border:1px solid #e5e5e5;}

		img {width: 300px; height: 100px}
		em {color: #f32121;}
	</style>
</head>
<body>
<div id="wrapper">
	<main id="main">
		<section class="section-overflow-hidden" >
			<div class="section-inner" >
				<div class="container container-boxed">
					<div class="section section_1440">
						<div class="section-header header">
							<h3 id="headline" class="__headline5">
								요청하신 페이지를<br/>
								<em>찾을 수 없습니다.</em>
							</h3>
							<p id="normalText">
								방문하신 페이지는 더 이상 존재하지 않거나 잘못된 접근입니다.<br/>
								확인 후 이용 부탁드립니다.
							</p>
							<p id="bottomBtn">
								<a href="javascript:history.back()" id="goBack">이전 페이지</a>
							</p>
						</div>
					</div>
				</div>
			</div>
		</section>
	</main>
</div>
</body>
</html>
