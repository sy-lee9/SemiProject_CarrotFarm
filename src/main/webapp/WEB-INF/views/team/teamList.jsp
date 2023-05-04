<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
<script src="./resources/js/twbsPagination.js" type="text/javascript"></script>
<style>	
	table, th, td{
		border: 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	th,td{
		text-align: center;
	}
</style>
</head>
<body>
	<select id="teamMatchState">
	  <option value="">모집여부</option>
	  <option value="모집중">모집중</option>
	  <option value="모집종료">모집종료</option>
	</select>
	
	<input type="text" id="searchInput" placeholder="팀이름 검색">
	<button id="searchButton">검색</button>
	&nbsp;&nbsp;
	<button id="teamRegist" onclick="location.href='team/teamRegist.go'">팀 개설하기</button>
	<hr>
	<table>
		<thead>
			<tr>
				<th>모집상태</th>
				<th>주활동지역</th>
				<th>팀 이름</th>
				<th>팀 소개글</th>
				<th>팀원</th>
				<th>매너점수</th>
			</tr>
		</thead>
		<tbody id="list">
			<!-- list 출력 영역 -->
		</tbody>
		<tr>
			<td colspan="7" id="paging">	
				<!-- 	플러그인 사용	(twbsPagination)	-->
				<div class="container">									
					<nav aria-label="Page navigation" style="text-align:center">
						<ul class="pagination" id="pagination"></ul>
					</nav>					
				</div>
			</td>
		</tr>
	</table>
</body>
<script>
	// 경기 방식 선택에 따른 출력
	$('#teamMatchState').change(function(){
		var selectedMatchState = $(this).val();
		// 선택한 요소 확인 okay
		console.log(selectedMatchState);

		if (selectedMatchState == '') {
		    $('tbody tr').show();
		    return;
		  }		
		// 각각의 데이터 행마다 선택한 요소와 다음 값이 일치 해야만 보여 줄 것 
		$('tbody tr').each(function(){
			var checkMatchState = $(this).find('#teamMatchState').text();
			console.log(checkMatchState);

			if (selectedMatchState == checkMatchState){
				$(this).show();
		      } else {
		    	  $(this).hide();
		      }	
		})
	});
	
	// 검색어에 따른 출력 
	$('#searchButton').click(function(){
		//검색어 확인 
		var searchText = $('#searchInput').val();
		console.log(searchText);
		
		$('tbody tr').each(function() {
			var teamName = $(this).find('#teamName').text();
			
			if (teamName.includes(searchText)){
				$(this).show();
			} else {
		        $(this).hide();
		    }
		});
	});
	
	var showPage = 1;
	listCall(showPage);
	
	function listCall(page){
		$.ajax({
			type:'post',
			url:'team/list.ajax',
			data:{
				'page':page,
				'cnt':10
			},
			dataType:'json',
			success:function(data){
				console.log(data);
				listPrint(data.list);			
				
				//paging plugin
				$('#pagination').twbsPagination({
					startPage:data.currPage,	//시작페이지
					totalPages:data.pages,//총 페이지 수
					visiblePages:5, //보여줄 페이지 [1][2][3][4][5]
					onPageClick:function(event,page){// 페이지 클릭시 동작되는 함수(콜백)
						console.log(page, showPage);
						if(page != showPage){
							showPage = page;	
							listCall(page);							
						}				
					}
				});					
			},
			error:function(e){
				console.log(e);
			}
		});
	}
	
	function listPrint(list){
		var content = '';
		list.forEach(function(team, teamIdx){
			content +='<tr>';
			content +='<td id="teamMatchState">'+team.teamMatchState+'</td>';
			content +='<td>'+team.locationIdx+'</td>';
			content +='<td><a href="team/teamPage.go?teamIdx='+team.teamIdx+'">'+team.teamName+'</a></td>';
			content +='<td>'+team.teamIntroduce+'</td>';
			content +='<td>'+team.teamUser+'</td>';
			content +='<td>'+team.teamManner+'</td>';
			content +='</tr>';
		});
		$('#list').empty();
		$('#list').append(content);
	}

/*	
	<c:if test="${list eq null}">
	<tr>
		<th colspan="7">등록된 팀이 없습니다.</th>
	</tr>
</c:if>
<c:forEach items="${list}" var="team">
	<tr>
		<td id="teamMatchState">${team.teamMatchState}</td>
		<td>${team.locationIdx}</td>
		<td>
			<a href="team/detail.do?idx=${team.teamIdx}"><img width="50" src="./t01/${team.photoName}"/></a>
		</td>
		<td id="teamName">${team.teamName}</td>
		<td>${team.teamIntroduce}</td>
		<td>${team.teamUser}</td>
		<td>${team.teamManner}</td>
	</tr>
</c:forEach>
*/
</script>
</html>