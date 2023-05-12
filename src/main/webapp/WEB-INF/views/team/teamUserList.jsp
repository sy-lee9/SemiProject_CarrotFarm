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
	
	<select id="teamJoinDate">
	  <option value="default">가입일순</option>
	  <option value="모집중">최근순</option>
	  <option value="모집종료">오래된순</option>
	</select>
	
	<input type="text" id="searchInput" placeholder="팀원 검색">
	<button id="searchButton">검색</button>
	&nbsp;&nbsp;
	<hr>
	<table>
		<colgroup>
			<col width="20%"/>
			<col width="30%"/>
			<col width="30%"/>
			<col width="20%"/>
		</colgroup>
		<thead>
			<tr>
				<th>직급</th>
				<th>아이디</th>
				<th>가입일</th>
				<th>경고</th>
			</tr>
		</thead>
		<tbody id="list">
			<!-- list 출력 영역 -->
		</tbody>
		<tr>
			<td colspan="5" id="paging">	
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
	var teamJoinDate = 'default';
	var searchText = 'default';
	var teamIdx = $('teamIdx');
	listCall(showPage);

	// 가입일에 따른 출력
	$('#teamJoinDate').change(function(){
		teamJoinDate = $(this).val();
		// 선택한 요소 확인 okay
		console.log(teamJoinDate);
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
			url:'teamUserList.ajax',
			data:{
				'page':page,
				'teamIdx':teamIdx,
				'teamJoinDate':teamJoinDate,
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
		list.forEach(function(list){
			content +='<tr>';
			content +='<td>'+list.teamGrade+'</td>';
			content +='<td><a href="team/teamPage.go?teamIdx='+list.userId+'">'+list.userId+'</a></td>';
			content +='<td>'+list.teamJoinDate+'</td>';
			content +='<td><button onclick="location.href='#'">확인</td>';
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