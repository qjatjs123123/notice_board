<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.userDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<%
		userDAO userDAO = new userDAO();
		String id = request.getParameter("id");
		boolean result = userDAO.id_check(id);
		
		if(result == true){
			PrintWriter script = response.getWriter();
			script.print("사용 가능한 아이디 입니다.");
			
		}
		else
			out.print("중복된 아이디 입니다.");
		
	%>
</body>
</html>