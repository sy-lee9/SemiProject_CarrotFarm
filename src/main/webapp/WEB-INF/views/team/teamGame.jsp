<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<style>
	table{
		width: 800;
		height: 500;
	}
	td{
		text-align: center;
	}
</style>
</head>
<body>
	<select id="gameDate">
	  <option value="DESC">경기일 최신순</option>
	  <option value="ASC">경기일 오래된순</option>
	</select>
	
	<input type="text" id="searchInput" placeholder="제목 검색">
	<button id="searchButton">검색</button>
	<table>
		<colgroup>
			<col width="5%"/>
			<col width="15%"/>
			<col width="40%"/>
			<col width="30%"/>
			<col width="10%"/>
		</colgroup>
		<thead>
			<tr>
				<th>NO</th>
				<th>장소</th>
				<th>제목</th>
				<th>경기일시</th>
				<th>경기방식</th>
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
	var selectedGameDate = 'default';
	var searchText = 'default';
	listCall(showPage);
	
	function listCall(page){
		$.ajax({
			type:'post',
			url:'team/gameList.ajax',
			data:{
				'page':page,
				'selectedGameDate':selectedGameDate,
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
		
		list.forEach(function(list, idx){
			content +='<tr>';
			content +='<td>'+1+'</td>';
			content +='<td>'+list.gu+'</td>';
			content +='<td>'+list.subject+'</a></td>';
			content +='<td>'+list.gameDate+'</td>';
			content +='<td>'+list.gamePlay+' : '+list.gamePlay+'</td>';
			content +='</tr>';
		});
		$('#list').empty();
		$('#list').append(content);
	}
</script>
</html>