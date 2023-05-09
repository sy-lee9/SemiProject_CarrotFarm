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
	body {
	  min-width: 1200px;
	}
	
	
	table, th, td{
		border : 1px solid black;
		border-collapse: collapse;
		padding : 5px 10px;
	}
	
	#content {
		width : 776px;
		height : 500px;
		background-color: #f8f9fa;
		vertical-align: top; /* 위쪽 정렬 */
		padding: 10 30 10;
	}
	
	#LNB nav.navbar {
	    width: 200px;
	    height: 500px;
	    background-color: #f8f9fa;
	}
	#LNB  .navbar-nav {
			text-align:center;
		  	padding-left: 0px;
		}
		

	div {
	  display: inline-block;
	}
</style>
</head>
<body>

	<%@ include file="../GNB.jsp" %>
	
	<div id="LNB">
	  <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-left " style="padding-bottom: 200px;">
	    <ul class="navbar-nav flex-column">
	      <li class="nav-item active">
	        <div style="width: 180px; height: 150px; border : 1px solid black; border-collapse: collapse;">프로필</div>
	      </li>
	      <li class="nav-item active">
	        <a class="nav-link" href="/cf/matching/list.do">개인 모집글</a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link" href="/cf/matching/teamList.do">팀 모집글</a>
	      </li>
	    </ul>
	  </nav>
	</div>
	
	<div id="content">
		<select id="gamePlay">
	  <option value="default">경기방식</option>
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
		<button onclick="location.href='write.go?categoryId=m02'">글쓰기</button>
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
				<th>팀명</th>
				<th>조회수</th>
			</tr>
		</thead>

		<tbody>
			
			
			<tbody id="list">			
			
			<!-- list 출력 위치 -->
			
			</tbody>
			
			
			
			
			<tr>
			  <th colspan="7" id="paging" style="text-align:center">  
			    <div class="container">                  
			      <nav aria-label="Page navigation">
			        <ul class="pagination justify-content-center" id="pagination"></ul>
			      </nav>
			    </div>
			  </th>
			</tr>



			
		</tbody>		
		
		
	</table>
	</div>
	
</body>

<script>
	
	
var showPage = 1;
var selectedGamePlay = 'default';
var selectedSort = 'default';
var categoryId = 'm02';
var searchText = 'default';
console.log(selectedGamePlay);
listCall(showPage);

//검색어에 따른 출력 
$('#searchButton').click(function(){
	//검색어 확인 
	searchText = $('#searchInput').val();
	listCall(showPage);
	searchText = 'default';
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
		content +='<td id="writerId">'+ item.teamName +'</td>';
		content +='<td>'+item.bHit+'</td>';
		content +='</tr>';
		
	});
	$('#list').empty();
	$('#list').append(content);
}
	



</script>
</html>