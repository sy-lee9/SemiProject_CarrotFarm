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
	
#playerListPopup, #gameApplyListPopup,#gameInviteListPopup {
        display: none;
        position: fixed;
        top: 10%;
        left: 40%;
        width: 200px;
        height: 300px;
        background-color: white;
        border: 1px solid black;
        z-index: 9999;
        
      }
      
     #scroll{}
     

	h3 {
	text-align:center;
	}
	
	#closePlayerListBtn, #closeGameApplyListBtn, #closeGameInviteListBtn{
		margin:auto;
        display:block;
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
	     		<th colspan="2">
	     			<div id="map" style="width:200px;height:200px;"></div>
	     		</th>
	     		<td colspan="5">
	     			</br>🏀 경기 일시 : ${dto.gameDate} 
	     			</br>🏀 경기 장소 : ${dto.courtName}
	     			</br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 주소: ${dto.courtAddress}
	     			</br>🏀 모집 인원 :	 &#128100 ${dto.matchingNumforSure}/${dto.matchingNum} 
	     			<button id="playerList">참가자 목록</button>
				    </br>🏀 경기 방식 : ${dto.gamePlay} : ${dto.gamePlay}
	     			</br>🏀 ${dto.content}
	     		</td>
	     	</tr>
   		
	     	<div id="playerListPopup">
				<h3>참가자 목록</h3>
				<hr>
				<ul>
					<c:forEach items="${playerList}" var="playerList">
						<li> ${playerList.userId} 
						<c:if test="${dto.writerId eq loginId }">
							<c:if test="${dto.writerId ne playerList.userId }">
								<button onclick="location.href='playerDelete?userId=${playerList.userId}&matchingIdx=${dto.matchingIdx}'">취소</button>
							</c:if>
						</c:if>
						</br>
						</li>
					</c:forEach>
				</ul>
				<button id="closePlayerListBtn">닫기</button>
			</div>
			
			
				    
	     	<tr>
	     		<!--matchigState가 matching 상태일 시  -->
	     		<c:if test="${dto.matchigState eq 'matching'}">
	     			<th colspan="2">
	     				<button id="gameApplyList">신청자 목록</button>
	     				<c:if test="${dto.writerId eq loginId }">
	     				<button id="gameInviteList">초대하기</button>
	     				</c:if>	
	     			</th>
	     		
		     		<c:if test="${dto.writerId eq loginId }">
			     		<th colspan="2">
		     				<button onclick="location.href='matchigStateUpdate?matchingIdx=${dto.matchingIdx}&matchigState=${dto.matchigState}'">모집종료</button>
		     			</th>
		     		</c:if>
		     		
		     		<c:if test="${dto.writerId ne loginId }">
			     		<th>
		     				<button onclick="location.href='applyGame?matchingIdx=${dto.matchingIdx}'">신청하기</button>
		     			</th>
		     		</c:if>
	     		</c:if>
	     		
	     		<div id="gameApplyListPopup">
					<h3>신청자 목록</h3>
					<hr>
					<ul>
						<c:forEach items="${gameApplyList}" var="gameApplyList">
							<li> ${gameApplyList.userId} 
							<c:if test="${dto.writerId eq loginId }">
								<button onclick="location.href='gameApplyAccept?userId=${gameApplyList.userId}&matchingIdx=${dto.matchingIdx}'">수락</button> / 
								<button onclick="location.href='gameApplyReject?userId=${gameApplyList.userId}&matchingIdx=${dto.matchingIdx}'">거절</button>
							</c:if>
							</br>
							</li>
						</c:forEach>
					</ul>
					<button id="closeGameApplyListBtn">닫기</button>
				</div>
				
				<div id="gameInviteListPopup">
					<h3>초대하기</h3>
					<hr>
					<div id="scroll" style="height: 200px; overflow: auto;">
						<ul>
							<c:if test="${gameInviteList !=null}">
								<p>초대한 회원</p>
								<c:forEach items="${gameInviteList}" var="gameInviteList">
									<li> 
									${gameInviteList.userId}
									<button id="inviteBtn_${gameInviteList.userId}" onclick="cancelInvite('${gameInviteList.userId}', '${dto.matchingIdx}')">취소</button>
									</li>
								</c:forEach>
							</c:if>
							<hr>
							<c:forEach items="${userList}" var="userList">
								<li> 
									${userList.userId}
									<button id="inviteBtn_${userList.userId}" onclick="inviteUser('${userList.userId}', '${dto.matchingIdx}')">초대</button>
								</li>
							</c:forEach>
						</ul>
					</div>
					<button id="closeGameInviteListBtn">닫기</button>
				</div>
			
	     		
	     		<!--matchigState가 finish 상태일 시  -->
	     		<c:if test="${dto.matchigState eq 'finish'}">
	     			<th colspan="2">
	     			
	     			</th>
	     			<c:if test="${dto.writerId eq loginId }">
			     		<th colspan="2">
		     				<button>경기종료</button>
		     			</th>
		     		</c:if>
		     		
		     		<c:if test="${dto.writerId ne loginId }">
			     		<th>
		     				<button>모집종료</button>
		     			</th>
		     		</c:if>
	     		</c:if>
	     		
	     		<th colspan="4">
	     		<c:if test="${dto.writerId eq loginId }">
		     		
		     			<button onclick="location.href='update.go?matchingIdx=${dto.matchingIdx}'">수정하기</button>
		     			<button onclick="location.href='delete.do?matchingIdx=${dto.matchingIdx}'">삭제하기</button>
						<button onclick="location.href='./list.do'">목록으로</button>
		     		
	     		</c:if>
	     		
	     		
	     		<c:if test="${dto.writerId ne loginId }">
		     		<button onclick="location.href='./list.do'">목록으로</button>
	     		</c:if>
	     		</th>
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

			     <form method="post" action="commentWrite.do?categoryId=m01&comentId=${dto.matchingIdx}" >
			     		<th >
			     			<input type="text" name="userId" value="${loginId}" style= "border:none;" readonly>
			     		</th>
			     		<th colspan="5">
			     			<input type="text" name="commentContent">
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

	
    var playerListBtn = document.getElementById('playerList');
    var playerListPopup = document.getElementById('playerListPopup');
    var closePlayerListBtn = document.getElementById('closePlayerListBtn');

    playerListBtn.addEventListener('click', function() {
      playerListPopup.style.display = 'block';
    });

    closePlayerListBtn.addEventListener('click', function() {
      playerListPopup.style.display = 'none';
    });
	
    
    var gameApplyListBtn = document.getElementById('gameApplyList');
    var gameApplyListPopup = document.getElementById('gameApplyListPopup');
    var closeGameApplyListBtn = document.getElementById('closeGameApplyListBtn');

    gameApplyListBtn.addEventListener('click', function() {
    	gameApplyListPopup.style.display = 'block';
    });

    closeGameApplyListBtn.addEventListener('click', function() {
    	gameApplyListPopup.style.display = 'none';
    });
    
    var gameInviteListBtn = document.getElementById('gameInviteList');
    var gameInviteListPopup = document.getElementById('gameInviteListPopup');
    var closeGameInviteListBtn = document.getElementById('closeGameInviteListBtn');

    gameInviteListBtn.addEventListener('click', function() {
    	gameInviteListPopup.style.display = 'block';
    });

    closeGameInviteListBtn.addEventListener('click', function() {
    	gameInviteListPopup.style.display = 'none';
    });
    
function inviteUser(userId, matchingIdx) {
        
        $.ajax({
            url: 'gameInvite.ajax',
            type: 'POST',
            data: {
                userId: userId,
                matchingIdx: matchingIdx
            },
            success: function(data) {
                // 버튼 변경
                console.log(data);
                var inviteBtn = document.getElementById('inviteBtn_' + userId);
                inviteBtn.textContent = '취소';
                inviteBtn.onclick = function() {
                    cancelInvite(userId, '${dto.matchingIdx}');
                };
            }
        });
    }

    function cancelInvite(userId,matchingIdx) {
        
        $.ajax({
            url: 'cancelGameInvite.ajax',
            type: 'POST',
            data: {
                userId: userId,
                matchingIdx: matchingIdx
            },
            success: function(data) {
                // 버튼 변경
                console.log(data);
                var inviteBtn = document.getElementById('inviteBtn_' + userId);
                inviteBtn.textContent = '초대';
                inviteBtn.onclick = function() {
                    inviteUser(userId, '${dto.matchingIdx}');
                };
            }
        });
    }
    

	
	
	
	
        
    </script>
</html>