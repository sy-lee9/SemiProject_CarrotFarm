<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=77b263fb5e91c183b524a3d94385df7c&libraries=services"></script>
<style>
	rating {
  display: inline-block;
  position: relative;
  height: 25px;
  line-height: 25px;
  font-size: 25px;
}

.rating input {
  position: absolute;
  left: -9999px;
}

.rating label {
  float: right;
  padding-left: 10px;
  cursor: pointer;
  color: #ccc;
}

.rating label:before {
  content: '★';
}

.rating input:checked ~ label {
  color: #ffc700;
}

.rating:not(:checked) label:hover,
.rating:not(:checked) label:hover ~ label {
  color: #deb217;
}
}
</style>
</head>
<body>
	
	<div id="map" style="width:600px;height:350px;float:left;"></div>
	<div">
		<table>
			<tr>
				<th colspan="2">${courtInfo.courtName}</th>	
			</tr>
			<tr>
				<th>위치</th>
				<th>서울 특별시 금천구 가산동 1-1
			</tr>
			<tr>
				<th>위치</th>
				<th>정보 없음</th>
			</tr>
			<tr>
				<th>실내/외</th>
				<th>정보 없음</th>
			</tr>
			<tr>
				<th>사용 여부</th>
				<th>정보 없음</th>
			</tr>
		</table>
	</div>
	<div>리뷰 공간</div>
	<hr/>
	<div>
		리뷰작성<input type="text" name="courtOneLineReview" style="display: inline-block;"/>
		<input type="file"/ style="display: inline-block;">
		<label>별점을 선택해주세요:</label>
		<div class="rating" style="display: inline-block;">
		  <input type="radio" id="star5" name="rating" value="5">
		  <label for="star5"></label>
		  <input type="radio" id="star4" name="rating" value="4">
		  <label for="star4"></label>
		  <input type="radio" id="star3" name="rating" value="3">
		  <label for="star3"></label>
		  <input type="radio" id="star2" name="rating" value="2">
		  <label for="star2"></label>
		  <input type="radio" id="star1" name="rating" value="1">
		  <label for="star1"></label>
	</div>
		
		<button>작성</button>
	</div>
	 
</body>
<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = { 
	    center: new kakao.maps.LatLng(37.573708,127.04841), // 지도의 중심좌표
	    level: 3 // 지도의 확대 레벨
	};
	
	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	
	//마커가 표시될 위치입니다 
	var markerPosition  = new kakao.maps.LatLng(37.573708,127.04841); 
	
	//마커를 생성합니다
	var marker = new kakao.maps.Marker({
	position: markerPosition
	});
	
	//마커가 지도 위에 표시되도록 설정합니다
	marker.setMap(map);
	
	//아래 코드는 지도 위의 마커를 제거하는 코드입니다
	//marker.setMap(null); 
</script>
</html>

