<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<style>
	th {
		padding: 10px;
		width:200px;
	}
	tbody td{
		height:100px;
	}
</style>
</head>
<body>
<h3>신고 처리</h3>
</hr>
<table>
	<thead>
		<tr>
			<th>작성자 아이디</th>
			<th>${reportInfo.userId}</th>
			<th>신고 대상자</th>
			<th>${reportInfo.reportUserId}</th>	
			<th>누적경고 </th>
			<c:if test="${warningCount ne null && warningCount ne ''}">
				<th>${warningCount}</th>
			</c:if>
			<c:if test="${warningCount eq null || warningCount eq ''}">
				<th>0</th>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<h4>신고 내용</h4>
			</td>
		</tr>
		<tr>
			<td colspan="4">
				${reportInfo.reportContent}
			</td>
		</tr>
		<tr>
			<td>
				<c:if test="${reportInfo.address ne null && reportInfo.address ne ''}">
    				<a href="${reportInfo.address}">신고 내용</a>
				</c:if>

				<c:if test="${reportInfo.msg ne null }">
					${reportInfo.msg}
				</c:if>
			</td>
		</tr>
		<tr>
			<td>
				<h4>신고 처리</h4>
			</td>
		</tr>
			<c:forEach items="${recordList}" var="item">
				<tr>
					<td colspan="2">${item.reportReason}</td> 
					<td>${item.reportResult}</td>
					<td>${item.reportRecordDate}</td>
				</tr>
			</c:forEach>
		<tr>
			<th colspan="2"><button onclick="reportCancel()">처리 취소</button></th>
			<th colsapn="2"><button type="button" onclick="list()">목록</button></th>
		</tr>
	</tbody>
</table>
</body>
<script>
	function reportCancel(){
		location.href="adminReportCancel.go?reportIdx=${reportInfo.reportIdx}&reportId=${reportInfo.reportId}&categoryId=${reportInfo.categoryId}&reportUserId=${reportInfo.reportUserId}";
	}
	
	function list(){
		location.href="adminReport";
	}
	var address="${reportInfo.address}";
	console.log(address);
	var recordList="${recordList}";
	console.log(recordList);
	
</script>
</html>