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
<style>

	table, th, td{
		border : 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;
	}
	
	

</style>
</head>
<body>

	

	<select id="gamePlay">
	  <option value="default">경기방식</option>
	  <option value="1">1:1</option>
	  <option value="3">3:3</option>
	  <option value="5">5:5</option>
	</select>
	
	<select id="sort">
	  <option value="default">지역</option>
	  <option value="${userData.locationIdx}">선호지역</option>
	  <c:forEach items="${locationList}" var="locationList">
	  	<option value="${locationList.locationIdx}">${locationList.gu}</option>	
	  </c:forEach>
	</select>

	
	<input type="text" id="searchInput" placeholder="제목 또는 작성자를 입력">
	<button id="searchButton">검색</button>
	<c:if test="${loginId != 'guest' }">
		<button onclick="location.href='write.go?categoryId=m01'">글쓰기</button>
	</c:if>
	
	<hr>
	
	<table>
		<thead>
			<tr>
				<th>경기방식</th>
				<th>경기장위치</th>
				<th>모집인원수</th>
				<th>제목</th>
				<th>경기 일시</th>
				<th>글쓴이</th>
				<th>조회수</th>
			</tr>
		</thead>

		<tbody>
			
			
			<tbody id="list">			
			
			<!-- list 출력 위치 -->
			
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


			
		</tbody>		
	</table>
</body>

<script>
	
	
var showPage = 1;
var selectedGamePlay = 'default';
var selectedSort = 'default';
var categoryId = 'm01';
var searchText = 'default';
console.log(selectedGamePlay);
listCall(showPage);

//검색어에 따른 출력 
$('#searchButton').click(function(){
	//검색어 확인 
	searchText = $('#searchInput').val();
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});

// 경기 방식 선택에 따른 출력
$('#gamePlay').change(function(){
	selectedGamePlay = $(this).val();
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});

$('#sort').change(function(){
	selectedSort = $(this).val();
	console.log(selectedSort);
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});



function listCall(page){
   $.ajax({
      type:'post',
      url:'list.ajax',
      data:{
    	  'page':page,
    	  'gamePlay':selectedGamePlay,
    	  'categoryId':categoryId,
    	  'locationIdx':selectedSort,
    	  'search':searchText
      },
      dataType:'json',           
      success:function(data){
         console.log(data);
         listPrint(data.list);
         
         // 페이징 처리를 위해 필요한 데이터
         // 1. 총 페이지의 수
         // 2. 현재 페이지
         
         // Paging Plugin (j-query의 기본기능을 가지고 만들었기 때문에  plugin)
         $('#pagination').twbsPagination({
			startPage:1, // 시작 페이지
			totalPages:data.pages,// 총 페이지 수 
			visiblePages:5,// 보여줄 페이지
			onPageClick:function(event,page){ // 페이지 클릭시 동작되는 (콜백)함수
				console.log(page,showPage);
				if(page != showPage){
					showPage=page;
					listCall(page);
					
				}
			}
         });
      }
   });
}

function listPrint(list){
	var content ='';
	
	list.forEach(function(item,idx){
		
		
		content +='<tr>';
		content +='<td id="gamePlay">'+item.gamePlay+':'+item.gamePlay+'</td>';
		content +='<td>'+item.gu +'</td>';
		content +='<td id="gamePlayer"> ' + item.matchingNumforSure +'/'+ item.matchingNum+ '</td>';
		content +='<td id="subject"><a href="detail.go?matchingIdx='+ item.matchingIdx+'">'+item.subject+'</a></td>';
		content +='<td>'+item.gameDate+'</td>';
		content +='<td id="writerId">'+item.writerId+'</td>';
		content +='<td>'+item.bHit+'</td>';
		content +='</tr>';
		
	});
	$('#list').empty();
	$('#list').append(content);
}
	


	
/* //검색어에 따른 출력 
$('#searchButton').click(function(){
	//검색어 확인 
	var searchText = $('#searchInput').val();
	console.log(searchText);
	
	$('tbody tr').each(function() {
		var subject = $(this).find('#subject').text();
		var writerId = $(this).find('#writerId').text();
		
		if (subject.includes(searchText) || writerId.includes(searchText)){
			$(this).show();
		} else {
	        $(this).hide();
	    }
	});
}); */

	


</script>
</html>