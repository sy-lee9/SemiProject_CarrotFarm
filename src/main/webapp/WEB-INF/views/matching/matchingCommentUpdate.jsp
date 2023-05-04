<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8eccc3d59df46746494af9204ba90019"></script>
<style>
table, th, td{
		border : 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;
	}
	
</style>
</head>
<body>
	<table>
		<thead>
			<tr>
				<th>${dto.gamePlay}:${dto.gamePlay}</th>
				<th>${dto.gu}</th>
				<th>&#128100 ${dto.matchingNumforSure}/${dto.matchingNum}</th>
				<th>${dto.subject}</th>
				<th>${dto.gameDate}</th>
				<th>&#128100</th>
				<th>${dto.writerId}</th>
			</tr>
		</thead>
		
		
	    <tbody>
	     	<tr>
	     		<td colspan="3">
	     			<div id="map" style="width:200px;height:200px;"></div>
	     		</td>
	     		<td colspan="4">
	     			</br>🏀 경기 일시 : ${dto.gameDate} 
	     			</br>🏀 경기 장소 : ${dto.courtName}
	     			</br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 주소: ${dto.courtAddress}
	     			</br>🏀 모집 인원 :	 &#128100 ${dto.matchingNumforSure}/${dto.matchingNum} 
					<button> 참가자 목록</button>	

	     		
						     			
	     			
	     			</br>🏀 경기 방식 : ${dto.gamePlay} : ${dto.gamePlay}
	     			</br>🏀 ${dto.content}
	     		</td>
	     	</tr>
	     	
	     	<tr>
	     		<th colspan="3">
	     			<button>신청자 목록</button>	
	     		</th>
	     		<th>
	     			<button>모집하기</button>
	     		</th>
	     		<c:if test="${dto.writerId eq loginId }">
		     		<th colspan="3">
		     			<button onclick="location.href='update.go?matchingIdx=${dto.matchingIdx}'">수정하기</button>
		     			<button onclick="location.href='delete.do?matchingIdx=${dto.matchingIdx}'">삭제하기</button>
		     		</th>
	     		</c:if>
	     		<c:if test="${dto.writerId ne loginId }">
		     		
	     		</c:if>
	     		
	     	</tr>
	     	<tr>
	     		<th colspan="7">
		     		<table>
			     		<c:forEach items="${commentList}" var="commentList">
			     			<tr>
			     				<th>${commentList.userId} </th>
			     				<td >${commentList.commentContent}</td>
			     				<td>${commentList.commentWriteTime}</td>
			     				<td>
			     					<c:if test="${commentList.userId eq loginId}">
			     						<a  href="commentUpdate.go?commentIdx=${commentList.commentIdx}&matchingIdx=${dto.matchingIdx}" >수정</a> 
			     						/ 
			     						<a href="commentDelete.do?commentIdx=${commentList.commentIdx}&matchingIdx=${dto.matchingIdx}">삭제</a>
			     					</c:if>
			     					<c:if test="${commentList.userId ne loginId}">
			     						<a href="#">신고</a>
			     					</c:if>
			     					
			     				</td>
			     			</tr>
			     		</c:forEach>
		     		</table>
		     		
		     	</th>
		     	
		     </tr>
		     
		     <tr>

			     <form method="post" action="commentUpdate.do?">
			     		<th >
			     			<input type="text" name="commentIdx" value="${commentDto.commentIdx}" hidden>
			     			<input type="text" name="matchingIdx" value="${dto.matchingIdx}" style= "border:none;" hidden>
			     			<input type="text" name="userId" value="${loginId}" style= "border:none;" readonly>
			     		</th>
			     		<th colspan="5">
			     			<input type="text" name="commentContent" value="${commentDto.commentContent}">
			     		</th>
			     		<th>
			     			<button>작성</button>
			     		</th>
			     </form>
			     			     
		     </tr>
		    </tbody>
		   </table>
		  </body>
		  
	<script>


	
	
	
	
	
	
	
	
	
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(${dto.courtLatitude},${dto.courtLongitude}),
            level: 4
        };

        var map = new kakao.maps.Map(container, options);

        var markerPosition  = new kakao.maps.LatLng(${dto.courtLatitude},${dto.courtLongitude}); 

        var marker = new kakao.maps.Marker({
            position: markerPosition
        });

        marker.setMap(map);
        
        var iwContent = '<div style="padding:5px;">${dto.courtName} </br> ${dto.courtTel}</div>'; 
        var infowindow = new kakao.maps.InfoWindow({
            content : iwContent
        });

        kakao.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map, marker);
        });

    </script>
</html>