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

<!-- 부트스트랩 JavaScript 파일 불러오기 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">

<style>

body {
	  min-width: 1200px;
	}
	#content {
		width : 776px;
		height : 500px;
		background-color: #f8f9fa;
		vertical-align: top; /* 위쪽 정렬 */
		margin: 0 0 0 10;
   	 	padding: 50 0 0 70;
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
	
	</br>
	
	
	<div id="LNB">
	  <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-left" style="padding-bottom: 200px;">
	    <ul class="navbar-nav flex-column">
	      <li class="nav-item active">
	        <div style="width: 180px; height: 150px; border : 1px solid black; border-collapse: collapse;">프로필</div>
	      </li>
	      <li class="nav-item active">
	        <a class="nav-link" href="/cf/matching/list.do">개인 모집글</a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link" href="#">팀 모집글</a>
	      </li>
	    </ul>
	  </nav>
	</div>
	
	<div id="content">
	<form method="post" action="write.do?categoryId=m01">
				
		<input type="text" name="subject" id="subject" placeholder="제목을 입력해주세요">
		<input type="datetime" name="gameDate" id="date" placeholder="경기 일시">
		<input type="text" name="writerId" value="${writerId}" style="border:none;" readonly>

		<br>

		<select name="gamePlay" id="gamePlay">
			<option value="none">경기방식</option>
			<option value="1">1:1</option>
			<option value="3">3:3</option>
			<option value="5">5:5</option>
		</select>
		
		
		<select name="courtListType" id="courtListType">
		  <option value="none">경기장</option>
		  <option value="loc">선호지역</option>
		  <option value="searchLoc">위치 선택</option>
		  <option value="listAll">전체보기</option>
		</select>
		
		<select name="locationIdx" id="locationIdx">
		  <option value="none">지역구</option>
		</select>
		
		
		
		<select name="courtIdx" id="courtIdx">
			<option value="none">경기장</option>
			<c:forEach items="${courtList}" var="court">
				<c:if test="${court.locationIdx == writerData.locationIdx}">
					<option value="${court.courtIdx}">${court.courtName}</option>
				</c:if>
			</c:forEach>
		</select>
		

		👤<input type="text" name="matchingNum" id="matchingNum" placeholder="모집인원" style="border:none;" readonly><br>
		<textarea name="content" id ="content" rows="10" cols="50" style="width: 555px; height: 228px;" placeholder="경기모집에 관련된 설명을 작성해주세요"></textarea><br>
		<input type="button" value="작성" onclick="subChk()">

	</form>
	</div>
</body>




<script>
	
	
	
	/* 경기장 선택 방법 선택(선호위치, 선택, 전체 보기) */
	
	var content='';
	var listType = '';
	
	$('#courtListType').on('change', function() {
		
	    listType = $(this).val();
	    
	    if(listType=='loc'){
	    	content += '<select name="locationList" id="locationIdx">';
    		content += '<option value="${writerData.locationIdx}">${writerData.gu}</option>';
	    	content += '</select>';	    	
	    	$('#locationIdx').replaceWith(content);
	    	content='';
	    	
	    	
	    }else if(listType=='searchLoc'){
	    	content += '<select name="locationList" id="locationIdx">';
	    	content += '<option value="none">지역구</option>';
	    	content += '<c:forEach items="${locationList}" var="list">';
    		content += '<option value="${list.locationIdx}">${list.gu}</option>';
    		content +=	'</c:forEach>';
	    	
    		$('#locationIdx').replaceWith(content);
	    	content='';
	    	
	    	
	    	
	    }else if(listType=='listAll'){
	    	content += '<select name="locationList" id="locationIdx">';
    		content += '<option value="none">전체</option>';
    		content += '</select>';	
    		$('#locationIdx').replaceWith(content);
	    	content='';
	    	
	    	content += '<select name="courtIdx" id="courtIdx">';
	        content += '<option value="none">경기장</option>';
	        content += '<c:forEach items="${courtList}" var="court">';
	        content += '<option value="${court.courtIdx}">${court.courtName}</option>';
	        content += '</c:forEach>';
	        content += '</select>';
	        $('#courtIdx').replaceWith(content);
	    	content='';
	    	
	    }
	    
	    $('#locationIdx').on('change', function(){
	    	
	    	var locIdx = $(this).val();
	       console.log(locIdx);

	       for(var i = 1; i<26; i++){
	    	    if(locIdx==i){
		    	content += '<select name="courtIdx" id="courtIdx">';
		        content += '<option value="none">경기장</option>';
		        content += '<c:forEach items="${courtList}" var="court">';
		        var locIdxchk = '${court.locationIdx}';
		        if(locIdx==locIdxchk){ 
		        	content += '<option value="${court.courtIdx}">${court.courtName}</option>';
		        }
		        content += '</c:forEach>';
		        content += '</select>';
		        $('#courtIdx').replaceWith(content);
		    	content='';
		       }
	    	}
	           
	    });
	    
	});

	function subChk(){
		console.log($('#subject').val());
		console.log($('#date').val());
		console.log($('#gamePlay').val());
		console.log($('#courtIdx').val());
	if($('#subject').val()==''){
		alert('제목을 입력해주세요.');
		return false;
	}else if($('#date').val()==''){
		alert('경기 날짜와 시간을 선택해주세요.');
		return false;
	}else if($('#gamePlay').val()=='none'){
		alert('경기 방식을 선택 해주세요.');
		return false;
	}else if($('#courtIdx').val()=='none'){
		alert('경기장을 선택해주세요.');
		return false;
	}else{
		$('form').submit();
	}

}
	
	
		var gamePlaySelected = document.getElementById("gamePlay");
		var matchingNum = document.getElementById("matchingNum");

		gamePlaySelected.addEventListener("change", function() {
			var selectedOption = gamePlaySelected.options[gamePlaySelected.selectedIndex];
			var recruitNum = selectedOption.value * 2;
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
		
		 
		 
		 

		
	</script>
</html>