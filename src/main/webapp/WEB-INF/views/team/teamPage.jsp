<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<style>
	table, th, td{
		border: 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	
	td{
		text-align: center;
	}
	
	table{
		width: 300px;
		height: 500px;
	}
	
	button{
		margin: 5px;
	}
	

	#inline{
		float: left;
	}
	
	div{
      position: relative;
      top: 100px; /*static을 기준으로 top100px / static이 없으면 가장 가까운 relative 기준*/
      left: 100px;
      right: 100px;
      bottom: 100px;
        }
	div{
		padding: 50px;
	}
</style>
</head>
<body>
	<button onclick="location.href='teamList.go'">리스트로 돌아가기</button>
	<div id="inline"><p id="teamMatchState">${team.teamMatchState}</p></div> 
	<c:if test="${team.teamMatchState == '모집중' && joinAppChk eq false && joinTeam eq false}">
		<div><button type="button" id="joinApp" onclick="joinApp(${team.teamIdx})">가입신청</button></div>
	</c:if>
	<c:if test="${team.teamMatchState == '모집중' && joinAppChk eq true}">
		<div><button type="button" id="joinCancelApp" onclick="joinCancel(${team.teamIdx})">가입신청 취소</button></div>
	</c:if>
	<div><button onclick="location.href='teamPageUpdate.go?teamIdx=${team.teamIdx}'">팀정보 수정</button></div>
	<div><button onclick="location.href='teamDisbanding.go?teamIdx=${team.teamIdx}'">팀 해체</button></div>
	<div><button onclick="location.href='teamUserList.go?teamIdx=${team.teamIdx}'">팀원</button></div>
	<div><button onclick="location.href='teamGame.go?teamIdx=${team.teamIdx}'">경기기록 보기</button></div>
	<div><button onclick="location.href='gameMatchingRequest.go?teamIdx=${team.teamIdx}'">참가신청한 경기</button></div>
	<div><button onclick="location.href='teamJoinAppAlarm.go?teamIdx=${team.teamIdx}'">알림</button></div>
	<div><button onclick="location.href='writeMatchingList.go?teamIdx=${team.teamIdx}'">모집중인 경기</button></div>
	
	<div id="inline">
		<c:if test="${team.photoName eq null}">
			<img width="400" src="/photo/팀이미지.png"/>
		</c:if>
		<c:if test="${team.photoName ne null}">
			<img width="400" src="/photo/${team.photoName}"/>
		</c:if>
	</div>
	
	<div id="inline">
		<table>
			<tr>
				<th colspan="2">${team.teamName}</th>
			</tr>
			<tr>
				<th>매너점수</th>
				<td>${team.teamManner}</td>
			</tr>
			<tr>
				<th>팀원 수</th>
				<td>${team.teamUser}</td>
			</tr>
			<tr>
				<th>활동 지역</th>
				<td>${team.gu}</td>
			</tr>
			<tr>
				<th>주 활동 시간</th>
				<td>${team.teamFavTime}</td>
			</tr>
			<tr>
				<th>선호 경기종목</th>
				<td id="teamFavNum">${team.teamFavNum}:${team.teamFavNum}</td>
			</tr>
		</table>
	</div>
	
	<div>		
		<table>
			<tr>
				<th height="15%">팀 소개글</th>				
			</tr>
			<tr>
				<td height="70%" valign="top">${team.teamIntroduce}</td>
			</tr>
		</table>
	</div>

	<div>
		<table>
			<tr>
				<th>리뷰</th>
			</tr>
				<c:forEach items="${list}" var="team">
				<tr>
					<td>${team.tagContent}</td>
				</tr>
			</c:forEach>
		</table>
	</div>
	<c:if test="${teamUserChk eq true}">
		<div><button type="button" onclick="leaveTeam(${team.teamIdx})">팀 탈퇴</button></div>
	</c:if>		
			

</body>
<script>

	function leaveTeam(teamIdx){
		console.log("팀탈퇴 시작");
		
		$.ajax({
	        url: 'leaveTeam.ajax',
	        type: 'POST',
	        data: {
	            'teamIdx': teamIdx
	        },
	        dataType:'json',
	        success: function(data) {
	        	 console.log(data);
	  
            	alert("탈퇴 되었습니다.");
	        },
			error:function(e){
				console.log(e);
			}
	    });
		
	}

	if($('#teamFavNum').val() == 0){
		$('#teamFavNum').text("상관없음");
	}

	function joinApp(teamIdx) {
		console.log('joinApp start');
	    
	    $.ajax({
	        url: 'joinApp.ajax',
	        type: 'POST',
	        data: {
	            'teamIdx': teamIdx
	        },
	        dataType:'json',
	        success: function(data) {
	        	 console.log(data);
	   
	    		if(data.joinChk == '0'){
		            // 버튼 변경	           
		            var joinAppBtn = document.getElementById('joinApp');
		            joinAppBtn.textContent = '가입신청 취소';
		            joinAppBtn.onclick = function() {
		            	joinCancel('${team.teamIdx}');	            	
		            }
		            alert("가입신청 되었습니다.");
	            }else if(data.joinChk == '1'){
	            	alert("하나의 팀에만 가입할 수 있습니다.");
	            }else if(data.joinChk == 'false'){
	            	alert("로그인 후 다시 시도해주세요.");
	            };
	        },
			error:function(e){
				console.log(e);
			}
	    });
	}

	function joinCancel(teamIdx) {
	    
	    $.ajax({
	        url: 'joinCancel.ajax',
	        type: 'POST',
	        data: {
	            'teamIdx': teamIdx
	        },
			dataType:'json',
	        success: function(data) {
	            // 버튼 변경
	            var joinCancelBtn = document.getElementById('joinApp');
	            joinCancelBtn.textContent = '가입신청';
	            joinCancelBtn.onclick = function() {
	            	joinApp('${team.teamIdx}');
	            };
	            alert("가입신청이 취소 되었습니다.");
	        },
			error:function(e){
				console.log(e);
			}
	    });
	}




	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
</script>
</html>