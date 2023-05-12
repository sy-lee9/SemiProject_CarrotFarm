<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

	<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
	
<style>
   body{
      position:relative;
      font-size:15px;
      padding : 10px;
   }
   
   #content {
      width:78%;
      background-color: #f8f9fa;
      padding: 10 30 10;
      margin : 5px;
      float:right;
      
   }
   
   #LNB {
      width:20%;
      height : 80%;
      background-color: #f8f9fa;
      float:left;
      margin : 5px;
   }

	table, th, td{
		border: 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	
	th,td{
		text-align: center;
	}
	
	table{
		width: 100%;
	}
	
	button{
		margin: 5px;
	}
	

	#inline{
		float: left;
	}

</style>
</head>
<body>
<%-- 	<div><button onclick="location.href='teamPageUpdate.go?teamIdx=${team.teamIdx}'">팀정보 수정</button></div>
	<div><button onclick="location.href='teamDisbanding.go?teamIdx=${team.teamIdx}'">팀 해체</button></div>
	<div><button onclick="location.href='teamUserList.go?teamIdx=${team.teamIdx}'">팀원</button></div>
	<div><button onclick="location.href='teamGame.go?teamIdx=${team.teamIdx}'">경기기록 보기</button></div>
	<div><button onclick="location.href='gameMatchingRequest.go?teamIdx=${team.teamIdx}'">참가신청한 경기</button></div>
	<div><button onclick="location.href='teamJoinAppAlarm.go?teamIdx=${team.teamIdx}'">알림</button></div>
	<div><button onclick="location.href='writeMatchingList.go?teamIdx=${team.teamIdx}'">모집중인 경기</button></div> --%>
	
	
	<%@ include file="../GNB.jsp" %>
	
	<div id="LNB">
       <ul>
         <li>
           <div style="width: 180px; height: 150px; border : 1px solid black; border-collapse: collapse;">프로필</div>
         </li>
         <li >
           <a href="/cf/matching/list.do">개인 모집글</a>
         </li>
         <li>
           <a href="/cf/matching/teamList.do">팀 모집글</a>
         </li>
       </ul>
   </div>
	
	<div id="content">
	<button onclick="location.href='teamList.go'">리스트로 돌아가기</button>
	<div id="inline"><p id="teamMatchState">${team.teamMatchState}</p></div> 
	<c:if test="${team.teamMatchState == '모집중' && joinAppChk eq false && joinTeam eq false}">
		<div><button type="button" id="joinApp" onclick="joinApp(${team.teamIdx})">가입신청</button></div>
	</c:if>
	<c:if test="${team.teamMatchState == '모집중' && joinAppChk eq true}">
		<div><button type="button" id="joinCancelApp" onclick="joinCancel(${team.teamIdx})">가입신청 취소</button></div>
	</c:if>
	
	<table>
		<colgroup>
	         <col width="50%"/>
	         <col width="20%"/>
	         <col width="10%"/>
	         <col width="20%"/>
	     </colgroup>
		<tr>
			<th rowspan="6">
				<c:if test="${team.photoName eq null}">
					<img width="400" src="/photo/팀이미지.png"/>
				</c:if>
				<c:if test="${team.photoName ne null}">
					<img width="400" src="/photo/${team.photoName}"/>
				</c:if>
			</th>
			<th colspan="2">${team.teamName}</th>
			<th height="15%" >팀 소개글</th>	
		</tr>
		<tr>
			<th>매너점수</th>
			<td>${team.teamManner}</td>
			<td rowspan="5" height="70%" valign="top">${team.teamIntroduce}</td>
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
		<tr>
			<th>리뷰</th>
			<c:forEach items="${list}" var="team">
				<td>${team.tagContent}</td>
			</c:forEach>
		</tr>
	</table>
		<c:if test="${teamUserChk eq true}">
			<button type="button" onclick="leaveTeam(${team.teamIdx})">팀 탈퇴</button>
		</c:if>		
	</div>		

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