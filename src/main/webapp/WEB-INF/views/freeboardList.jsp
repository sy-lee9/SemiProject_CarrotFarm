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
	게시물 갯수 : 
	<select id="pagePerNum">
		<option value="5">5</option>
		<option value="10">10</option>
		<option value="15">15</option>
		<option value="20">20</option>
	</select>
	<button onclick="location.href='freeboardWrite.go'">등록</button>
	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>조회수</th>
				<th>작성일</th>			
			</tr>
		</thead>
		<tbody id="falist">
			<c:forEach items="${list}" var="board">
				<tr>
					<td>${board.boardIdx}</td>
					<td><a href = "freeboardDetail.do?bidx=${board.boardIdx}">${board.subject}</a></td>
					<td>${board.userId}</td>
					<td>${board.bHit}</td>
					<td>${board.writeTime}</td>
				</tr>
			</c:forEach>
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
var showPage = 1;
listCall(showPage);

$('#pagePerNum').change(function(){
	listCall(showPage);
	$('#pagination').twbsPagination('destroy');
});

function listCall(page){
	$.ajax({
		type:'post',
		url:'list.ajax',
		data:{
			'page':page,
			'cnt':$('#pagePerNum').val()	
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
		content +='<td>'+item.subject+'</td>';
		content +='<td>'+item.userId+'</td>';
		

		var date = new Date(item.writeTime);
		content +='<td>'+date.toLocaleDateString('ko-KR')+'</td>'; //기본값 en-US
		content +='<td>'+item.bHit+'</td>';
		content +='<tr>';
	});
	$('#falist').empty();
	$('#falist').append(content);
}
</script>
</html>