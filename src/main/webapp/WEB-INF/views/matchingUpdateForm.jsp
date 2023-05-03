<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>🏀 당근농장</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<!-- Datetimepicker 라이브러리 불러오기 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-datetimepicker/2.5.20/jquery.datetimepicker.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-datetimepicker/2.5.20/jquery.datetimepicker.full.min.js"></script>

<style>

</style>
</head>
<body>
	<form method="post" action="update.do?matchingIdx=${dto.matchingIdx}">
		
		<input type="text" name="subject" placeholder="제목을 입력해주세요" value="${dto.subject}">
		<input type="datetime" name="gameDate" id="date" placeholder="경기 일시" value="${dto.gameDate}">
		<input type="text" name="writerId" value="${session.loginId}" style="border:none;" readonly>

		<br>

		<select name="gamePlay" id="gamePlay">
			<option value="">경기방식</option>
			<option id="1" value="1">1:1</option>
			<option id="3" value="3">3:3</option>
			<option id="5" value="5">5:5</option>
		</select>
		<select name="courtListType" id="courtListType">
			<option value="none">경기장</option>
		</select>
		<input type="text" name="courtName" id="location" value="${dto.courtName}" style="border:none;" readonly>
		👤<input type="text" name="matchingNum" id="matchingNum" placeholder="모집인원" value ="${dto.matchingNum}" readonly><br>
		<textarea name="content" rows="10" cols="50" style="width: 555px; height: 228px;" placeholder="경기모집에 관련된 설명을 작성해주세요">${dto.content}</textarea><br>
		<input type="submit" value="수정">
	</form>
	
</body>




<script>

		var gamePlaySelected = document.getElementById("gamePlay");
		var matchingNum = document.getElementById("matchingNum");

		gamePlaySelected.addEventListener("change", function() {
			var selectedOption = gamePlaySelected.options[gamePlaySelected.selectedIndex];
			var recruitNum = parseInt(selectedOption.value.split(":")[0]) * 2;
			matchingNum.value = recruitNum.toString();
		});
		
		 $(function() {
			    $('#date').datetimepicker({
			      format: 'Y-m-d H:i',  // 입력값의 형식을 지정
			      lang: 'ko',  // 언어 설정
			      step: 30,  // 분 단위로 선택 가능한 간격을 지정
			      dayOfWeekStart: 1,  // 주의 시작일을 월요일로 설정
			      minDate: 0,  // 오늘 이후의 날짜만 선택 가능하도록 설정
			      allowTimes: [
			        '09:00', '10:00', '11:00', '12:00', '13:00',
			        '14:00', '15:00', '16:00', '17:00', '18:00',
			        '19:00', '20:00', '21:00', '22:00', '23:00'
			      ]  // 선택 가능한 시간을 지정
		    });
		});
		
		 function gps(){
			var dto = '${dto.gamePlay}';
		 	console.log(dto);
		 	
		 	if(dto=='1'){
		 		$('#1').prop('selected',true);
		 	} else if(dto=='3'){
		 		$('#3').prop('selected',true);
		 	} else if(dto=='5'){
		 		$('#5').prop('selected',true);
		 	} else {
		 		
		 	}
		 };
		 
		 $(document).ready(function() {
				gps();
		});
		 
		
	</script>
</html>