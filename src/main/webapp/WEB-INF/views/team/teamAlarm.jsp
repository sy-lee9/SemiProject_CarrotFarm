<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<style>
	table{
		width: 800;
		height: 500;
	}
	th,td{
		text-align: center;
	}
</style>
</head>
<body>
	<input type="hidden" name="teamIdx" value="${teamIdx}"/>
	<a href="teamAlarm.go?teamIdx=${teamIdx}">팀 가입신청 알림</a>
	<a href="#">경기 참가신청 알림</a>
	<a href="gameAppAlarm.go?teamIdx=${teamIdx}">경기 변경사항 알림</a>
	<br/>
	<hr/>
	<br/>
	<table>
		<colgroup>
			<col width="15%"/>
			<col width="40%"/>
			<col width="30%"/>
			<col width="15%"/>
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
</body>
<script>
	var teamIdx = ${teamIdx}
	
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
		list.forEach(function(list){		
			content +='<tr>';
			content +='<td>'+list.gu+'</td>';
			content +='<td>'+list.subject+'</a></td>';
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
</script>
</html>