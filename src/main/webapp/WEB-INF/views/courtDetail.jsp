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
				<th>${courtInfo.courtName}</th>
				<th>
					<c:if test="${courtInfo.courtStar eq ''}">0.0</c:if>
					<c:if test="${courtInfo.courtStar ne ''}">${courtInfo.courtStar}</c:if>
				</th>	
			</tr>
			<tr>
				<th>위치</th>
				<th>${courtInfo.courtAddress}</th>
			</tr>
			<tr>
				<th>실내/외</th>
				<th>
					<c:if test="${courtInfo.courtInOut eq 'out'}">실외</c:if>
					<c:if test="${courtInfo.courtInOut eq 'in'}">실내</c:if>
				</th>
			</tr>
			<tr>
				<th>사용 여부</th>
				<th>${courtInfo.courtState}</th>
			</tr>
		</table>
	</div>
	<div>경기장 리뷰
		<table>
			<c:forEach items="${courtReviewList}" var="courtReview">
			<tr>
				<th>${courtReview.userId}</th>
				<th>${courtReview.courtOneLineReview}</th>				
				<th>☆${courtReview.courtStar}</th>
				<th><a href="courtReviewDelete.do?courtReviewIdx=${courtReview.courtReviewIdx}&courtIdx=${courtInfo.courtIdx}">삭제</a></th>
			</tr>
		</c:forEach>
		</table>
	</div>
	<div>
		사진 모아보기
		<table>
			<c:if test="${reviewPhotoList eq null}">
			</c:if>
			
			<c:if test="${reviewPhotoList ne null}">
				<c:forEach items="${reviewPhotoList}" var="reviewPhotos">
					<tr>
						<td><img width="100" src="/photo/${reviewPhotos.photoName}"/></td>
					</tr>			
				</c:forEach>
			</c:if>
		</table>
				

	</div>
	<hr/>
	<form action="courtReviewWrite.do" method="post" enctype="multipart/form-data">
	<div>
		
		<input type="hidden" name="courtIdx" value="${courtInfo.courtIdx}"/>
		<input type="hidden" name="courtName" value="${courtInfo.courtName}"/>
		<input type="hidden" name="userId" value="test2"/>
		리뷰작성<input type="text" name="courtOneLineReview" style="display: inline-block;"/>
		<input type="file" name="photo" style="display: inline-block;"/>
		<label>별점</label>
		<div class="rating" style="display: inline-block;">
		  <input type="radio" id="star5" name="courtStar" value="5">
		  <label for="star5"></label>
		  <input type="radio" id="star4" name="courtStar" value="4">
		  <label for="star4"></label>
		  <input type="radio" id="star3" name="courtStar" value="3">
		  <label for="star3"></label>
		  <input type="radio" id="star2" name="courtStar" value="2">
		  <label for="star2"></label>
		  <input type="radio" id="star1" name="courtStar" value="1">
		  <label for="star1"></label>
	</div>
		
		<button>작성</button>
	</div>
	</form>
	 
</body>
<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = { 
	    center: new kakao.maps.LatLng(${courtInfo.courtLatitude},${courtInfo.courtLongitude}), // 지도의 중심좌표
	    level: 3 // 지도의 확대 레벨
	};
	
	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	
	//마커가 표시될 위치입니다 
	var markerPosition  = new kakao.maps.LatLng(${courtInfo.courtLatitude},${courtInfo.courtLongitude}); 
	
	//마커를 생성합니다
	var marker = new kakao.maps.Marker({
	position: markerPosition
	});
	
	//마커가 지도 위에 표시되도록 설정합니다
	marker.setMap(map);
	
	//아래 코드는 지도 위의 마커를 제거하는 코드입니다
	//marker.setMap(null); 
	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
</script>
</html>

