<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>

	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
		
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
	  <option value="">경기방식</option>
	  <option value="1">1:1</option>
	  <option value="3">3:3</option>
	  <option value="5">5:5</option>
	</select>
	
	<select id="sort">
	  <option value="" disabled selected hidden>정렬방식</option>
	  <option value="거리순">거리순</option>
	  <option value="매너점수순">매너점수 순</option>
	</select>
	
	<input type="text" id="searchInput" placeholder="제목 또는 작성자를 입력">
	<button id="searchButton">검색</button>
	
	<button onclick="location.href='write.go?categoryId=m01'">글쓰기</button>
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
			<c:forEach items="${list}" var="list">
				<c:if test="${list.categoryId == 'm01'}">
					<tr>
						<td id="gamePlay">${list.gamePlay}:${list.gamePlay}</td>
						<td>${list.gu}</td>
						<td id="gamePlayer">&#128100 ${list.matchingNumforSure}/${list.matchingNum}</td>
						<td id="subject"><a href="detail.go?matchingIdx=${list.matchingIdx}">${list.subject}</a></td>
						<td>${list.gameDate}</td>
						<td id="writerId">${list.writerId}</td>
						<td>${list.bHit}</td>
					</tr>
				</c:if>
			</c:forEach>
			</tbody>
			<tr>
			
		
	</table>
</body>

<script>
	
	// 경기 방식 선택에 따른 출력
	$('#gamePlay').change(function(){
		var selectedGamePlay = $(this).val();
		// 선택한 요소 확인 okay
		console.log(selectedGamePlay);
		
		if (selectedGamePlay === '') {
		    $('tbody tr').show();
		    return;
		  }
		// 각각의 데이터 행마다 선택한 요소와 다음 값이 일치 해야만 보여 줄 것 
		$('tbody tr').each(function(){
			var checkGamePlay = $(this).find('#gamePlay').text();
			var one = checkGamePlay.split(":")[0];
			console.log(one);
			
			if (selectedGamePlay == one){
				$(this).show();
		      } else {
		        $(this).hide();
		      }			
		});
	});
	
	
	// 검색어에 따른 출력 
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
	});

	


</script>
</html>