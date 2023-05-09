<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>  
<script src="resources/js/jquery.twbsPagination.js" type="text/javascript"></script>
<style>
	table, th, td{
      border : 1px solid black;
      border-collapse: collapse;
      padding : 5px 10px;
   }
</style>
</head>
<body>
	<table>
		<tr>
			<th>
				<a href="adminCourt">
					<h3>경기장 리스트</h3>
				</a>
			</th>
			<th>
				<a href="adminCourtTipOff">
					<h3>경기장 제보</h3>
				</a>
			</th>
		</tr>
	</table>
	<table>
		<tr>
			<th>경기장 이름</th>
			<th>경기장 주소</th>
			<th>제보자 닉네임</th>
			<th>등록</th>
			<th>삭제</th>			
		</tr>
	<tbody id="courtTipOffList">
		
	</tbody>
	</table>
	<table>
		<tr>
				<td colspan="6" id="paging">	
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
listCall(showPage);


function listCall(page){
	$.ajax({
		type:'post',
		url:'adminCourtTipOff.ajax',
		data:{
			'page':page
		},
		dataType:'json',
		success:function(data){
			console.log(data);
			console.log(data.courtTipOffList);
			courtListDraw(data.courtTipOffList);
			//paging plugin
			$('#pagination').twbsPagination({
				startPage:page,	//시작페이지
				totalPages:Math.ceil(data.courtTipOffCnt/10),//총 페이지 수
				visiblePages:5, //보여줄 페이지 [1][2][3][4][5]
				onPageClick:function(event,page){// 페이지 클릭시 동작되는 함수(콜백)
					console.log(page, showPage);
					if(page != showPage){
						showPage = page;
						listCall(showPage,);
						
					}				
				}
			});	
			
		},
		error:function(e){
			console.log(e);
		}
	});
}
function courtListDraw(list){
	var content = '';
	$('#courtTipOffList').empty();
	list.forEach(function(item,index){
		content += '<tr>';
		content += '<th>'+item.courtName+'</th>';
		content+='<th>'+item.courtAddress+'</th>';
		content+='<th>'+item.userId+'</th>';
		content +='<th><button onclick=location.href="adminCourtTIpOffRegist.go?courtTipOffIdx='+item.courtTipOffIdx+'">등록</button></th>';
		content +='<th><button onclick=location.href="adminCourtTipOffDelete.do?courtTipOffIdx='+item.courtTipOffIdx+'">삭제</button></th>';
		
	});
	
	$('#courtTipOffList').append(content);
}



</script>
</html>