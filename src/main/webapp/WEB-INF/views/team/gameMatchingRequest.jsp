<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
	<script src="../resources/js/twbsPagination.js" type="text/javascript"></script>
	
	<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<style>
	body{
		position:relative;
		font-size:15px;
		padding : 10px;
		min-width: 1200px;
	}
	
	#content {
		width:78%;
		height : 83%;
		background-color: #f8f9fa;
		padding: 10 30 10;
		margin : 5px;
		float:right;
		
	}
	
	#LNB {
		width:20%;
		height : 83%;
		background-color: #f8f9fa;
		float:left;
		margin : 5px;
		font-weight: bold;
        font-size: 18px;
		text-align:center;
		
	}
	
	table, th, td{
		margin : 5px;
	}
	
	table{
		width:100%;
		height:40%;
		text-align:center;
	}
	
	a {
	  color : black;
	}
	
	a:link {
	  color : black;
	}
	a:visited {
	  color : black;
	}
	a:hover {
	 text-decoration-line: none;
	  color : #FFA500 ;
	}
	
	.pagination .page-link {
  		color: gray; /* 기본 글자색을 검정색으로 지정 */
	}

	.pagination .page-item.active .page-link {
 		background-color: #FFA500;
 		border:none;
	}
</style>
</head>
<body>
	<div style="float: right;">
		<%@ include file="../loginBox.jsp" %>
	</div> 
	
	<%@ include file="../GNB.jsp" %>

	<div id="LNB">
		<br/><br/>
        <c:if test="${loginId eq null}">
			<img width="200" height="200" src="/photo/기본프로필.png">
		</c:if>
		<c:if test="${loginId ne null}">
			<img width="200" height="200" src="/photo/${loginPhotoName}">
		</c:if>
      <br/><br/>
        <a href="/cf/team/teamJoinAppAlarm.go?teamIdx=${teamIdx}">알림</a>
      <br/><br/>
        <a href="/cf/team/teamPageUpdate.go?teamIdx=${teamIdx}">팀정보 수정</a>
      <br/><br/>
        <a href="/cf/team/teamUserListLeader.go?teamIdx=${teamIdx}">팀원</a>
      <br/><br/>
        <a href="/cf/team/writeMatchingList.go?teamIdx=${teamIdx}">모집중인 경기</a>
      <br/><br/>
        <a href="/cf/team/gameMatchingRequest.go?teamIdx=${teamIdx}" >참가신청한 경기</a>
        <br/><br/>
        <a href="/cf/team/warningTeamUser.go?teamIdx=${teamIdx}">경고/강퇴</a>
      <br/><br/>
        <a href="/cf/team/teamDisbanding.go?teamIdx=${teamIdx}" >팀 해체</a>
	</div>
	
	
	<div id="content">
		 <br/>
		<input type="hidden" name="teamIdx" value="${teamIdx}"/>
		<select id="gameDate">
		  <option value="default">모집일순</option>
		  <option value="DESC">경기일 최신순</option>
		  <option value="ASC">경기일 오래된순</option>
		</select>
		<br/><br/>
		<table>
			<colgroup>
				<col width="10%"/>
				<col width="30%"/>
				<col width="30%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
			</colgroup>
			<thead>
				<tr>
					<th>장소</th>
					<th>제목</th>
					<th>경기일시</th>
					<th>경기방식</th>
					<th>모집상태</th>
					<th>응답상태</th>
				</tr>
			</thead>
			<tbody id="list">
				<!-- list 출력 영역 -->
			</tbody>
		</table>
	</div>
</body>
<script>
	var selectedGameDate = 'default';
	var teamIdx = "${teamIdx}";
	console.log(selectedGameDate);
	console.log(teamIdx);
	listCall();
	
	// 게임일시 선택에 따른 출력
	$('#gameDate').change(function(){
		selectedGameDate = $(this).val();
		// 선택한 요소 확인 okay
		console.log(selectedGameDate);
		listCall();
	});	
	
	function listCall(){
		$.ajax({
			type:'post',
			url:'gameMatchingRequest.ajax',
			data:{
				'selectedGameDate':selectedGameDate,
				'teamIdx':teamIdx
			},
			dataType:'json',
			success:function(data){
				console.log(data);
				listPrint(data.list);				
			},
			error:function(e){
				console.log(e);
			}
		});
	}
	
	function listPrint(list){

		var content = '';		
		
		if(list.length==0){
			content +='<tr>';
			content +='<th colspan="6"> 신청한 경기가  없습니다. </th>';
			content +='</tr>';
		}else{
		list.forEach(function(list){		
			content +='<tr>';
			content +='<td>'+list.gu+'</td>';
			content +='<td><a href="../matching/teamDetail.go?matchingIdx='+list.matchingIdx+'">'+list.subject+'</a></td>';
			content +='<td>'+list.gameDate+'</td>';
			content +='<td>'+list.gamePlay+' : '+list.gamePlay+'</td>';
			
			var matchigState = list.matchigState;
			if(matchigState == 'matching'){
				matchigState = '모집중';
			}else if(matchigState == 'finish'){
				matchigState = '모집종료';
			}
			content +='<td>'+matchigState+'</td>';
			
			var gameAppState = list.gameAppState;
			if(gameAppState == '신청'){
				gameAppState = '미응답';
			}else if(gameAppState == '확정'){
				gameAppState = '수락';
			}
			content +='<td>'+gameAppState+'</td>';
			content +='</tr>';
		});
		$('#list').empty();
		$('#list').append(content);
		}
	}
</script>
</html>