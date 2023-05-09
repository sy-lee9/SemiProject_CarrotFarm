<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8eccc3d59df46746494af9204ba90019"></script>

<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<style>

body {
	  min-width: 1200px;
	}
	

#content {
		width : 776px;
		height : 500px;
		background-color: #f8f9fa;
		vertical-align: top; /* 위쪽 정렬 */
		margin: 0 0 0 10;
   	 	padding: 0 0 0 70;
	}
	
	
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
      
   

	h2,h3 {
	text-align:center;
	}
	
	#closePlayerListBtn, #closeGameApplyListBtn, #closeGameInviteListBtn{
		margin:auto;
        display:block;
	}
	
	#LNB nav.navbar {
	    width: 200px;
	    height: 500px;
	    background-color: #f8f9fa;
	}
	#LNB  .navbar-nav {
			text-align:center;
		  	padding-left: 0px;
		}
		

	div {
	  display: inline-block;
	}
	

	
</style>
</head>
<body>

	<%@ include file="../GNB.jsp" %>
	
	</br>
	
	<div id="LNB">
	  <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-left " style="padding-bottom: 200px;">
	    <ul class="navbar-nav flex-column">
	      <li class="nav-item active">
	        <div style="width: 180px; height: 150px; border : 1px solid black; border-collapse: collapse;">프로필</div>
	      </li>
	      <li class="nav-item active">
	        <a class="nav-link" href="/cf/matching/list.do">개인 모집글</a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link" href="#">팀 모집글</a>
	      </li>
	    </ul>
	  </nav>
	</div>
	
	<div id="content">
	<table>
		<!-- 기본 글 정보 : 로그인 하지 않아도 볼 수 있어야 함 -->
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
	     			<c:if test="${loginId != 'guest' }"><button id="playerList">참가자 목록</button></c:if>
	     			
				    </br>🏀 경기 방식 : ${dto.gamePlay} : ${dto.gamePlay}
	     			</br>🏀 ${dto.content}
	     		</td>
	     	</tr>
	     	<c:if test="${loginId == 'guest' }">
	     	<tr>
	     		<th colspan="7"> 경기 참여는 로그인 후 가능 합니다.</th>
	     	</tr>
	     	</c:if>
   		
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
			     		<th colspan="2">
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
					<button id="closeGameInviteListBtn" onclick="location.href='detail.go?matchingIdx='+${dto.matchingIdx}">닫기</button>
				</div>
			
	     		
	     		<!--matchigState가 finish 상태일 시  -->
	     		<c:if test="${dto.matchigState eq 'finish'}">
	     			<th colspan="2">
	     			
	     			</th>
	     			<c:if test="${dto.writerId eq loginId }">
			     		<th colspan="2">
			     			<button onclick="location.href='matchigStateUpdate?matchingIdx=${dto.matchingIdx}&matchigState=${dto.matchigState}'">경기종료</button>
		     			</th>
		     		</c:if>
		     		
		     		<c:if test="${dto.writerId ne loginId }">
			     		
		     		</c:if>
	     		</c:if>
	     		
	     		<!--matchigState가 review 상태일 시  -->
	     		<c:if test="${dto.matchigState eq 'review'}">
	     			<th colspan="4">
	     				
	     			</th>
	     		</c:if>
	     		
	     		<th colspan="3">
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
	     	
	     	
	     	<!-- 리뷰 영역 -->
	     	<c:if test="${dto.matchigState eq 'review'}">
	     	<c:if test="${review == 'no'}">
	     		
	     		<form action="review?matchingIdx=${dto.matchingIdx}" method="post">
	     		<tr>
	     			<td colspan="7">
	     				
	     					<h2>REVIEW</h2>
	     					
	     			</td>
	     		</tr>
	     		<tr>
	     			<td colspan="3">		
	     				<c:forEach items="${playerList}" var="playerList" varStatus="status">
	     				<c:if test="${status.index % 2 == 0}"> 
	     					<input type="radio" name="receiveId" value="${playerList.userId}"> ${playerList.userId} 
	     					<c:if test="${playerList.userId ne loginId}">
		     					<input type="radio" name="manner_${playerList.userId} " value="${playerList.userId}_up"> 👍
		     					<input type="radio" name="manner_${playerList.userId} " value="${playerList.userId}_down"> 👎
	     					</c:if></br>
	     				</c:if>	
	     				</c:forEach>		
	     			</td>
	     			
	     			<td colspan="4">		
	     				<c:forEach items="${playerList}" var="playerList" varStatus="status">
	     				<c:if test="${status.index % 2 != 0}"> 
	     					<input type="radio" name="receiveId" value="${playerList.userId}"> ${playerList.userId} 
	     					<c:if test="${playerList.userId ne loginId}">
		     					<input type="radio" name="manner_${playerList.userId} " value="${playerList.userId}_up"> 👍
		     					<input type="radio" name="manner_${playerList.userId} " value="${playerList.userId}_down"> 👎
	     					</c:if></br>
	     				</c:if>	
	     				</c:forEach>		
	     			</td>
	     		</tr>
	     		<tr>
	     			<th colspan="7"><button id="review_btn">제출하기</button></th>
	     		</tr>	
	     		</form>
	     	</c:if>
	     	<c:if test="${review == 'yes'}">
	     		<tr>
	     			<td colspan="7">
	     				
	     					<h2>REVIEW</h2>
	     					
	     			</td>
	     		</tr>
	     		<tr>
	     			<th colspan="3">
	     				
	     					<h2>MVP</h2>
	     					${mvp}
	     			</th>
	     			<th colspan="4">
	     				
	     					<h2>MANNER</h2>
	     					${mannerPoint}
	     			</th>
	     		</tr>
	     	</c:if>
	     	</c:if>
	     	
	     	
	     	
	     	</br>
	     	
	     	
	     	
	     	<!-- 댓글 -->
	     	
			<c:forEach items="${commentList}" var="commentList">
				<tr>
			    	<th>${commentList.userId} </th>
			     	<td colspan="3">${commentList.commentContent}</td>
			     	<td>${commentList.commentWriteTime}</td>
			     	<td colspan="2">
			     		<c:if test="${commentList.userId eq loginId}">
			     			<a  href="commentUpdate.go?commentIdx=${commentList.commentIdx}&matchingIdx=${dto.matchingIdx}" >수정</a> 
			     			/ 
			     			<a href="commentDelete.do?commentIdx=${commentList.commentIdx}&matchingIdx=${dto.matchingIdx}">삭제</a>
			     		</c:if>
			     		<c:if test="${commentList.userId ne loginId}">
				     		<c:if test="${loginId != 'guest' }"><button id="playerList">
				     			<a href="#">신고</a>
				     		</c:if>	 
			     		</c:if>	     					
			     	</td>
			     </tr>
			</c:forEach>
		     
		     <tr>

			     <form method="post" action="commentWrite.do?categoryId=m01&comentId=${dto.matchingIdx}" >
			     		<th >
			     			<input type="text" name="userId" value="${loginId}" style= "border:none; width:40px;" readonly>
			     		</th>
			     		<c:if test="${loginId != 'guest' }">
				     		<th colspan="5">
				     			<input type="text" name="commentContent">
				     		</th>
				     		<th>
				     			<button>작성</button>
				     		</th>
			     		</c:if>
			     		<c:if test="${loginId == 'guest' }">
				     		<th colspan="6">
				     			<input type="text" name="commentContent" style= "border:none; width:400px;" placeholder="댓글 작성은 로그인 후 가능합니다. ">
				     		</th>
				     		
			     		</c:if>
			     </form>
			     			     
		     </tr>
		    </tbody>
		   </table>
		   </div>
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