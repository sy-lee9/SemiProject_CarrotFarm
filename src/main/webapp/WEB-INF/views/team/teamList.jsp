<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
<script src="resources/js/twbsPagination.js" type="text/javascript"></script>
<style>	
	table, th, td{
		border: 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;	
	}
	th,td{
		text-align: center;
	}
	table{
		width: 800;
		height: 500;
	}
</style>
</head>
<body>
	<select id="teamMatchState">
	  <option value="default">모집여부</option>
	  <option value="모집중">모집중</option>
	  <option value="모집종료">모집종료</option>
	</select>
	
	<input type="text" id="searchInput" placeholder="팀이름 검색">
	<button id="searchButton">검색</button>
	&nbsp;&nbsp;
	<button id="teamRegist" onclick="location.href='team/teamRegist.go'">팀 개설하기</button>
	<hr>
	<table>
		<colgroup>
			<col width="15%"/>
			<col width="15%"/>
			<col width="20%"/>
			<col width="40%"/>
			<col width="10%"/>
		</colgroup>
		<thead>
			<tr>
				<th>모집상태</th>
				<th>주활동지역</th>
				<th>팀 이름</th>
				<th>팀 소개글</th>
				<th>팀원</th>
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
	var showPage = 1;
	var selectedMatchState = 'default';
	var searchText = 'default';
	listCall(showPage);

	// 경기 방식 선택에 따른 출력
	$('#teamMatchState').change(function(){
		selectedMatchState = $(this).val();
		// 선택한 요소 확인 okay
		console.log(selectedMatchState);
		listCall(showPage);
		$('#pagination').twbsPagination('destroy');
	});	
		
	// 검색어에 따른 출력 
	$('#searchButton').click(function(){
		//검색어 확인 
		searchText = $('#searchInput').val();
		console.log(searchText);
		listCall(showPage);
		$('#pagination').twbsPagination('destroy');
	});
		
	function listCall(page){
		$.ajax({
			type:'post',
			url:'team/list.ajax',
			data:{
				'page':page,
				'matchState':selectedMatchState,
				'searchText':searchText
			},
			dataType:'json',
			success:function(data){
				console.log(data);
				listPrint(data.list);			
				
				//paging plugin
				$('#pagination').twbsPagination({
					startPage:1,	//시작페이지
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
			content +='<td>'+team.gu+'</td>';
			content +='<td id="teamInfo"><a href="team/teamPage.go?teamIdx='+team.teamIdx+'">'+team.teamName+'</a></td>';
			content +='<td>'+team.teamIntroduce.substring(0, 14)+'</td>';
			content +='<td>'+team.teamUser+'</td>';
			content +='</tr>';
		});
		$('#list').empty();
		$('#list').append(content);
	}
	
	var msg = "${msg}";
	console.log(msg);
	if(msg != ''){
		alert(msg);
	}
</script>
</html>