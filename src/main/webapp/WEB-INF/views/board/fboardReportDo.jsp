<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<style></style>
</head>
<body>

	<form action = "freeboardReport.do" method="post" id="form">
		<input type = "hidden" name = "boardIdx" value = "${dto.bidx}">
		<input type = "hidden" name = "userId" value = "${loginId}">
	
		
		<h1> 게시글 신고</h1>
			<select name = "report" id = "report">
				<option value="none select">신고 사유 </option>
				<option value="부적절한 언어 사용">부적절한 언어 사용</option>
				<option value="광고">광고</option>
				<option value="중복글 게시">중복글 게시</option>
				<option value="기타">기타</option>
			</select>
			<br/>
			<br/>
			<br/>
			<br/>
			<br/>
			<br/>
			<textarea name = "content" id="content" style="width: 800px; height: 400px;"placeholder="기타 신고사유를 입력해 주세요."></textarea>
			<br/>
			<br/>
			<br/>
			<input type = "button" value = "제출" onclick = "submitclick()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type = "button" onclick = "window.close()" id= "closeButton" value = "닫기">
	</form>

</body>
<script>
	function submitclick(){
		console.log($('#report').val());
		
		if($('#report').val() == 'none select'){
			alert('신고 사유를 선택해 주세요');
			return false;
		}
		
		if($('#report').val() == '기타'){
			if($('#content').val() == ''){
				alert('신고 사유를 입력해 주세요.');
				return false;
			}			
		}
		
		$('#form').submit();	
	}
</script>
</html>