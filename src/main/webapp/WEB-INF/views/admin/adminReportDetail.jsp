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
<form action="adminReportPro.do">
<input type="hidden" name="reportIdx" value="${reportInfo.reportIdx}"/>
<input type="hidden" name="reportId" value="${reportInfo.reportId}"/>
<input type="hidden" name="categoryId" value="${reportInfo.categoryId}"/>
<input type="hidden" name="reportUserId" value="${reportInfo.reportUserId}"/>
<table>
	<thead>
		<tr>
			<th>작성자 아이디</th>
			<th>${reportInfo.userId}</th>
			<th>신고 대상자</th>
			<th>${reportInfo.reportUserId}</th>
			<th>누적경고</th>
			<c:if test="${warningCount ne null && warningCount ne ''}">
				<th>${warningCount}</th>
			</c:if>
			<c:if test="${warningCount eq null || warningCount eq ''}">
				<th>0</th>
			</c:if>
			<th>
				<select name="reportResult" id="reportResult">
					<c:if test="${reportInfo.categoryId ne 'ru'}">
				 		<option value="블라인드">블라인드</option>
				 	</c:if>
		         	<option value="경고">경고</option>
		        	<option value="영구제한">영구제한</option>
		    	</select>
			</th>		
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="6">
				<h4>신고 내용</h4>
			</td>
			<th><button type="button" onclick="reportPro()">처리완료</button></th>
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
				<c:if test="${reportInfo.commentContent ne null }">
					댓글 내용 : ${reportInfo.commentContent}
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
		<c:if test="${recordList eq '[]'}">
			<tr>
				<td>신고 처리 내역이 없습니다.</td>
			</tr>
		</c:if>
		<c:if test="${recordList ne '[]'}">
			<c:forEach items="${recordList}" var="item">
				<tr>
					<th>${item.reportReason} ${item.reportResult} ${item.reportRecordDate} </th>
				</tr>
			</c:forEach>
		</c:if>
		<tr>
			<td colspan="5">
				<textarea  style="width: 1000px; height: 100px;" name="reportReason" required></textarea>
			</td>
		</tr>
		<tr>
			<th colspan="2"><button>확인</button></th>
			<th colspan="2"><button type="button" onclick="list()">목록</button></th>
		</tr>
	</tbody>
</table>
</form>
</body>
<script>
	function list(){
		location.href="adminReport";
	}
	
	function reportPro(){
		location.href="adminReportProcess.do?reportId=${reportInfo.reportId}&categoryId=${reportInfo.categoryId}&reportUserId=${reportInfo.reportUserId}";
	}
	
	var waringCount="${warningCount}";
	console.log(waringCount);
	var address="${reportInfo.address}";
	console.log(address);
	var recordList="${recordList}";
	console.log(recordList);
	console.log("${reportInfo.categoryId}");
</script>

</html>