<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=77b263fb5e91c183b524a3d94385df7c&libraries=services"></script>
<style>
	table, th, td{
      border : 1px solid black;
      border-collapse: collapse;
      padding : 5px 10px;
   }
</style>
</head>
<body>
	<div id="map" style="width:500px;height:400px;float:left;"></div>
	<form action="courtNameSearch.do">
		<input type="text" name="searchCourt" placeholder="경기장 검색">
		<button id="searchButton">검색</button>
	</form>
	<div>
	<table>
		<c:forEach items="${courtList}" var="court">
			<tr>
				<th>${court.courtState}</th>
				<th>${court.gu}</th>				
				<th>
					<c:if test="${court.courtInOut eq 'out'}">실외</c:if>
					<c:if test="${court.courtInOut eq 'in'}">실내</c:if>
				</th>
				<th id="courtName"><a href="courtDetail.do?courtIdx=${court.courtIdx}">${court.courtName}</a></th>
				<th>${court.courtAddress}</th>
				<th>☆${court.courtStar}</th>
			</tr>
		</c:forEach>
	</table>
	</div>
</body>
<script>
	console.log("${address}");
	mapPrint("${address}");
	function mapPrint(address){
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = {
	    center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	    level: 6 // 지도의 확대 레벨
	};  

	//지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 

	//주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();
	
	//주소로 좌표를 검색합니다
	geocoder.addressSearch(address, function(result, status) {
	
	// 정상적으로 검색이 완료됐으면 
	 if (status === kakao.maps.services.Status.OK) {
	
	    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

    // 결과값으로 받은 위치를 마커로 표시합니다
    var marker = new kakao.maps.Marker({
        map: map,
        position: coords
    });

    // 인포윈도우로 장소에 대한 설명을 표시합니다
    var infowindow = new kakao.maps.InfoWindow({
        content: '<div style="width:150px;text-align:center;padding:6px 0;">선호지역</div>'
    });
    infowindow.open(map, marker);

    // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
    map.setCenter(coords);
} 
});
	var position=[];
	<c:forEach items="${courtList}" var="item">
		position.push({
			 title :'${item.courtName}', latlng: new kakao.maps.LatLng(${item.courtLatitude}, ${item.courtLongitude})});
	</c:forEach>
	for(var i=0; i<position.length;i++){
		
	    
	    // 마커를 생성합니다
	    var marker = new kakao.maps.Marker({
	        map: map, // 마커를 표시할 지도
	        position: position[i].latlng, // 마커를 표시할 위치
	        title : position[i].title // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다 
	    });
	}
	}	
	$('#searchButton').click(function(){
	      //검색어 확인 
	      var searchText = $('#searchInput').val();
	      console.log(searchText);
	      
	      $('tr').each(function() {
	         var courtName = $(this).find('#courtName').text();
	         if (subject.includes(searchText)){
	            $(this).show();
	         } else {
	              $(this).hide();
	          }
	      });
	   });
	
	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
	
</script>
</html>
	
	