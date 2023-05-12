<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<style>
	table{
		width: 1200;
		height: 200;
	}
	th,td{
		text-align: center;
	}
</style>
</head>
<body>
	<input type="hidden" name="teamIdx" value="${teamIdx}"/>
	<a href="teamJoinAppAlarm.go?teamIdx=${teamIdx}">팀 가입신청 알림</a>
	<a href="#">경기 참가신청 알림</a>
	<a href="gameAppAlarm.go?teamIdx=${teamIdx}">경기 변경사항 알림</a>
	<br/>
	<hr/>
	<br/>
	<table>
		<colgroup>
			<col width="15%"/>
			<col width="10%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="10%"/>
			<col width="20%"/>
		</colgroup>
		<thead>
			<tr>
				<th>신청일</th>
				<th>닉네임</th>
				<th>활동지역</th>
				<th>선호 포지션</th>
				<th>주 활동시간</th>
				<th>매너점수</th>
				<th>응답</th>
			</tr>
		</thead>
		<tbody id="list">
			<!-- list 출력 영역 -->
		</tbody>
	</table>
</body>
<script>

	var teamIdx = ${teamIdx}
	console.log(teamIdx);
	listCall();

	function accept(teamIdx,userId) {
		console.log('accept start');
	    
	    $.ajax({
	        url: 'teamJoinAccept.ajax',
	        type: 'POST',
	        data: {
	            'teamIdx': teamIdx,
	            'userId':userId
	        },
			dataType:'json',
			success: function(data) {
	        	 console.log("수락 성공");
	             alert("수락되었습니다.");
	             listCall();
	        },
			error:function(e){
				console.log(e);
			}
	    });
	}	
	
	function reject(teamIdx,userId) {
		console.log('reject start');
	    
	    $.ajax({
	        url: 'teamJoinReject.ajax',
	        type: 'POST',
	        data: {
	            'teamIdx': teamIdx,
	            'userId':userId
	        },
			dataType:'json',
			success: function(data) {
	        	 console.log("거절 성공");
	             alert("거절되었습니다.");
	             listCall();
	        },
			error:function(e){
				console.log(e);
			}
	    });
	}	
	
	function listCall(){
		$.ajax({
			type:'post',
			url:'teamJoinAppList.ajax',
			data:{
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
		list.forEach(function(list){		
			content +='<tr>';
			content +='<td>'+list.teamAppDate+'</td>';
			content +='<td><a href="회원프로필.go?userIdx='+list.userId+'">'+list.userId+'</a></td>';
			content +='<td>'+list.gu+'</td>';
			content +='<td>'+list.position+'</td>';
			content +='<td>'+list.favTime+'</td>';
			content +='<td>'+list.userManner+'</td>';
			content += '<td><button onclick="accept(' + "'" + list.teamIdx + "'" + ',' + "'" + list.userId + "'" + ')">수락</button> &nbsp; <button onclick="reject(' + "'" + list.teamIdx + "'" + ',' + "'" +  list.userId + "'" +  ')">거절</button></td>';
			content +='</tr>';
		});
		$('#list').empty();
		$('#list').append(content);
	}

			
	
			
			
			
			
			
			
			
			
			
			
			
			
</script>
</html>