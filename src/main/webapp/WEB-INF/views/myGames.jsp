<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>참여 경기 리스트</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
	<script src="resources/js/twbsPagination.js" type="text/javascript"></script>
	
	<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<style>
	table{
		width: 800;
		height: 500;
	}
	th,td{
		text-align: center;
	}
	
	body{
		position:relative;
		font-size:15px;
		padding : 10px;
		min-width: 1200px;
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
		height : 83%;
		background-color: #f8f9fa;
		float:left;
		margin : 5px;
		font-weight: bold;
        font-size: 18px;
		text-align:center;
		
		}
		
		a {
		  color : balck;
		}
		
		a:link {
		  color : balck;
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
	<jsp:include page="loginBox.jsp"></jsp:include>
</div>

<jsp:include page="GNB.jsp"></jsp:include>

	<div id="LNB">
       <br/><br/>
			<img width="200" height="200" src="/photo/${loginPhotoName}">
			<br/><br/>
           <a href="/cf/userinfo.go">회원 정보</a>
           <br/><br/>
           <a href="/cf/userprofile.go?userId=${loginId}">회원 프로필</a>
           <br/><br/>
           <a href="/cf/userNoticeAlarm">알림</a>
           <br/><br/>
           <a href="/cf/allgames">참여 경기</a>
           <br/><br/>
           <a href="/cf/mygames">리뷰</a>
           <br/><br/>
   </div>
   
   <div id="content" >
	<input type="hidden" name="myGameIdx"/>
	<select id="gameDate">
	  <option value="default">모집일순</option>
	  <option value="DESC">경기일 최신순</option>
	  <option value="ASC">경기일 오래된순</option>
	</select>
	
	<input type="text" id="searchInput" placeholder="제목 검색">
	<button class="btn btn-outline-dark" id="searchButton">검색</button>
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
			</tr>
		</thead>
		<tbody id="list">
			<!-- list 출력 영역 -->
		</tbody>
		<tr>
			<td colspan="4" id="paging">	
				<!-- 	플러그인 사용	(twbsPagination)	-->
				<div class="container">									
					<nav aria-label="Page navigation" style="text-align:center">
						<ul class="pagination justify-content-center" id="pagination"></ul>
					</nav>					
				</div>
			</td>
		</tr>
	</table>
	</div>
</body>
<script>
	var showPage = 1;
	var selectedGameDate = 'default';
	var searchText = 'default';
	console.log(selectedGameDate);
	listCall(showPage);
	
	// 게임일시 선택에 따른 출력
	$('#gameDate').change(function(){
		selectedGameDate = $(this).val();
		// 선택한 요소 확인 okay
		console.log(selectedGameDate);
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
			url:'mygameList.ajax',
			data:{
				'page':page,
				'selectedGameDate':selectedGameDate,
				'searchText':searchText,
				'userId':"${sessionScope.loginId}"
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
			content +='<td>'+list.gu+'</td>';
			content +='<td><a href="./matching/detail.go?matchingIdx='+list.matchingIdx+'">'+list.subject+'</a></td>';
			content +='<td>'+list.gameDate+'</td>';
			content +='<td>'+list.gamePlay+' : '+list.gamePlay+'</td>';
			content +='</tr>';
		});
		$('#list').empty();
		$('#list').append(content);
	}
</script>
</html>