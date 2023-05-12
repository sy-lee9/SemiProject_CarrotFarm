<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>  
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=77b263fb5e91c183b524a3d94385df7c&libraries=services"></script>

<!-- <script src="resources/js/jquery.twbsPagination.js" type="text/javascript"></script> -->
<script src="./resources/js/twbsPagination.js" type="text/javascript"></script>
<style>
	table, th, td{
      border : 1px solid black;
      border-collapse: collapse;
      padding : 5px 10px;
   }
</style>
</head>
<body>
	<button onclick="window.open('courtTipOff.go','경기장 제보','width=400px,height=400px')">경기장 제보</button>
	<select name="gu" id="gu" onchange="courtSort('gu')">
		<option value="none">위치</option>
		<option value="서울특별시">서울</option>
		<c:forEach items="${guList}" var="gu">
			console.log(${gu.gu});
			<option value="${gu.gu}">${gu.gu}</option>
		</c:forEach>
      </select>
      <select name="inOut" id="inOut" onchange="courtSort('inOut')">
      	<option value="none">실내/외</option>
      	<option value="in">실내</option>
      	<option value="out">실외</option>
      </select>
	<div id="map" style="width:500px;height:400px;float:left;"></div>
	<input id="searchCourt" type="text" name="searchCourt" placeholder="경기장 검색">
	<button type="button" onclick="courtSort('courtSearch')">검색</button>
	
	<div>
	<table id="courtList">
		<thead>
		<tr>
			<td colspan="6" id="paging">	
				<!-- 	플러그인 사용	(twbsPagination)	-->
				<div class="container">									
					<nav aria-label="Page navigation" style="text-align:center">
						<ul class="pagination" id="pagination"></ul>
					</nav>					
				</div>
			</td>
		</tr>
		</thead>
		<tbody>
			<c:forEach items="${courtList}" var="court" varStatus="status" end="9">
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
		</tbody>
	</table>
	</div>
</body>
<script>
	paging("${totalPages}");
	var showPage = 1;
	var address="${address}";
	/*$('.test').change(function(){
		address = $(this).val();
		var inOut = $('#inOut').val();
		console.log(inOut);
		$.ajax({
			type:'get',
			url:'courtList.ajax',
			data:{"gu":address,
				  "inOut":inOut
			},
			dataType:'json',
			success:function(data){
				console.log(data);
				console.log(data.courtList.length);
				for(var i=0;i<markers.length;i++){
					markers[i].setMap(null);
				}
				console.log(data.courtList);
				markerDraw(data.courtList);
				courtListDraw(data.courtList);
				mapGeocoder(address);
			},
			error:function(e){
				console.log(e);
			}
		});	
	});*/
	
	function courtSort(type,page1=1){
		// 위치 , 실내 , 검색어 + type -> gu inout search -> if(type != 'search') {search=""}
		address = $('#gu').val();
		var inOut = $('#inOut').val();
		var searchCourt =$('#searchCourt').val();
		showPage=page1;
		console.log(address);
		console.log(inOut);
		
		$.ajax({
			type:'get',
			url:'courtList.ajax',
			data:{"gu":address,
				  "inOut":inOut,
				  "searchCourt":searchCourt,
				  "type":type,
				  "page":showPage
			},
			dataType:'json',
			success:function(data){
				console.log(data);
				console.log(data.courtList.length);
				for(var i=0;i<markers.length;i++){
					markers[i].setMap(null);
				}
				console.log(data.courtList);
				markerDraw(data.courtList);
				courtListDraw(data.courtList);
				mapGeocoder(address);
			    infowindow.close();
			    
			    $('#pagination').twbsPagination('destroy');
			    //데이터가 없을 때
			    if(data.totalList==0){
			    	alert("검색결과가 없습니다.");
			    	return;
			    }
			    
			    $('#pagination').twbsPagination({
					startPage:showPage,	//시작페이지
					totalPages:Math.ceil(data.totalList/10),//총 페이지 수
					visiblePages:5, //보여줄 페이지 [1][2][3][4][5]
					onPageClick:function(event,page){// 페이지 클릭시 동작되는 함수(콜백)
						if(page != showPage){
							showPage = page;	
							courtSort(type,showPage);
						}	
					}
				});
			    
			    
			    
			},
			error:function(e){
				console.log(e);
			}
		});	
	};
	
	//paging plugin
	function paging(totalList, type = ""){
		$('#pagination').twbsPagination({
			startPage:showPage,	//시작페이지
			totalPages:Math.ceil(totalList/10),//총 페이지 수
			visiblePages:5, //보여줄 페이지 [1][2][3][4][5]
			onPageClick:function(event,page){// 페이지 클릭시 동작되는 함수(콜백)
			console.log(page);
				if(page != showPage){
					showPage = page;	
					
					if(type == "") {
						// 리스트 + 페이징 함수 변경
						$.ajax({
							type:'get',
							url:'courtPage.ajax',
							data:{"page":page
							},
							dataType:'json',
							success:function(data){
								console.log(data.courtList);
								courtListDraw(data.courtList);
							},
							error:function(e){
								console.log(e);
							}
						});				
						
					}else{
						
					}
					
					
					
				}	
			}
		});	
	}
										
		
		
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
    markers.push(marker);

    // 인포윈도우로 장소에 대한 설명을 표시합니다
    	infowindow = new kakao.maps.InfoWindow({
        content: '<div class="test" style="width:150px;text-align:center;padding:6px 0;">선택지역</div>'
    });
    infowindow.open(map, marker);

    // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
    map.setCenter(coords);
} 
});
	var markers=[];
	var position=[];
	var infowindow='';
	<c:forEach items="${courtList}" var="item">
		position.push({
			 content :'${item.courtName}', latlng: new kakao.maps.LatLng(${item.courtLatitude}, ${item.courtLongitude})});
	</c:forEach>
	for(var i=0; i<position.length;i++){
		

		// 마커를 생성합니다
		var marker = new kakao.maps.Marker({
		     map: map, // 마커를 표시할 지도
		     position: position[i].latlng, // 마커를 표시할 위치 
		});
		markers.push(marker);
		console.log(markers[i]);
	       
	    var infowindow = new kakao.maps.InfoWindow({
	        content: position[i].content // 인포윈도우에 표시할 내용
	    });
	    kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
	    kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
	}
	function makeOverListener(map, marker, infowindow) {
	    return function() {
	        infowindow.open(map, marker);
	    };
	}
	function makeOutListener(infowindow) {
	    return function() {
	        infowindow.close();
	    };
	}
	
	function markerDraw(list){
		markers=[];
		position=[];
		list.forEach(function(item,idx){
			console.log(item.courtLatitude);
		position.push({
			 content :item.courtName, 
			 latlng: new kakao.maps.LatLng(item.courtLatitude, item.courtLongitude)
			 });
		});
		for(var i=0; i<position.length;i++){
			// 마커를 생성합니다
			var marker = new kakao.maps.Marker({
		    	map: map, // 마커를 표시할 지도
		     	position: position[i].latlng, // 마커를 표시할 위치 
			});
			markers.push(marker);
			console.log(markers[i]);
	    var infowindow = new kakao.maps.InfoWindow({
	        content: position[i].content // 인포윈도우에 표시할 내용
	    });
	    kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
	    kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
		}
		function makeOverListener(map, marker, infowindow) {
	    	return function() {
	        	infowindow.open(map, marker);
	    	};
		}
		function makeOutListener(infowindow) {
	    	return function() {
	        	infowindow.close();
	    	};
		}
	}
	function courtListDraw(list){
		$('#courtList tbody').empty();
		var content = '';
		list.forEach(function(item,index){
			content += '<tr>';
			content += '<th>'+item.courtState+'</th>';
			content+='<th>'+item.gu+'</th>';
			if(item.courtInOut=='out'){
				content +='<th>실외</th>';
			}else{
				content +='<th>실내</th>';
			}
			content +='<th id="courtName"><a href="courtDetail.do?courtIdx='+item.courtIdx+'">'+item.courtName+'</a></th>';
			content +='<th>'+item.courtAddress+'</th>';
			content +='<th>'+item.courtStar+'</th>';
		});
		$('#courtList tbody').append(content);
	}
	function mapGeocoder(address){
		var geocoder = new kakao.maps.services.Geocoder();
		geocoder.addressSearch(address, function(result, status) {
			 if (status === kakao.maps.services.Status.OK) {
			
			var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
		    var marker = new kakao.maps.Marker({
		        map: map,
		        position: coords
		    });
		    markers.push(marker);
		    	infowindow = new kakao.maps.InfoWindow({
		        content: '<div style="width:150px;text-align:center;padding:6px 0;">선택지역</div>'
		    });
		    infowindow.open(map, marker);
		    map.setCenter(coords);
		} 
		});
	}
</script>
</html>
	
	