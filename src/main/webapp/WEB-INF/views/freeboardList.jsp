<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>    
<script src="resources/js/jquery.twbsPagination.js" type="text/javascript"></script>
<style>
	b{
		color:red;
	}

	table{
		width:100%;
	}

	table, td, th{
		border : 3px solid orange;
		border-collapse : collapse;
		padding: 5px;
	}
	#paging{
		text-align: center;
	}
</style>
</head>
<body>

	<br><br/>
	<input type ="text" id="freeboardSearchInput" placeholder="제목 또는 닉네임을 입력">
	<button id ="freeboardSearchButton">검색</button>

	<br><br/>
	<c:if test="${loginId != 'guest' }">
	<button onclick="location.href='freeboardWrite.go'">글쓰기 등록</button>
	</c:if>
	
	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>조회수</th>			
			</tr>
		</thead>
		<tbody id="list">
			
		</tbody>
		<tr>
			<td colspan="5" id="paging">	
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
var searchText = 'default';
var showPage = 1;
listCall(showPage);

$('#freeboardSearchButton').click(function(){
	searchText = $('#freeboardSearchInput').val();
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});

function listCall(page){
	$.ajax({
		type:'post',
		url:'flist.ajax',
		data:{
			'page':page,
			'search':searchText
		},
		dataType:'json',
		success:function(data){
			console.log(data);
			console.log(data.freeboardList);
			listPrint(data.freeboardList);
			
			$('#pagination').twbsPagination({
				startPage:data.currPage, 
				totalPages:data.pages, 
				visiblePages:5,
				onPageClick:function(event,page){
					console.log(page,showPage);
					if (page != showPage) {
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

function listPrint(falist){
	var content = '';

	falist.forEach(function(item,idx){
		content +='<tr>';
		content +='<td>'+item.boardIdx+'</td>';
		content +='<td><a href="freeboardDetail.do?bidx='+item.boardIdx+'">'+item.subject+'</a></td>';
		content +='<td>'+item.userId+'</td>';
		

		var date = new Date(item.writeTime);
		content +='<td>'+date.toLocaleDateString('ko-KR')+'</td>';
		content +='<td>'+item.bHit+'</td>';
		content +='<tr>';
	});
	$('#list').empty();
	$('#list').append(content);
}
</script>
</html>