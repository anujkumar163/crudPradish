<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<table>
	<tr>
		<th>ID</th>
		<th>UserName</th>
		<th>PassWord</th>
		<th>Mobile</th>
		<th>Email</th>
		<th>City</th>
		<th>Delete</th>
		<th>Update</th>
	</tr>
	<c:forEach var="login" items="${login}">
	<tr>
		<td>${login.id}</td>
		<td>${login.username}</td>
		<td>${login.password}</td>
		<td>${login.mobile}</td>
		<td>${login.email}</td>
		<td>${login.city}</td>
		<td><a href="delete?id=${login.id}">Delete</a></td>
		<td><a href="updateData?mobile=${login.mobile}">Update</a></td>
		
				
		
		
	</tr>
	</c:forEach>
	</table>
	
	
</body>
</html>