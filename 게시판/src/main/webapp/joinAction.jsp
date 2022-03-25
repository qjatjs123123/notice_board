<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.userDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.user" scope="page" />
<jsp:setProperty name="user" property="id" />
<jsp:setProperty name="user" property="firstnum" />
<jsp:setProperty name="user" property="secondnum" />
<jsp:setProperty name="user" property="passwd" />
<jsp:setProperty name="user" property="name" />
<jsp:setProperty name="user" property="email" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	userDAO userDAO = new userDAO();
	int result = userDAO.join(user);		
	if (result == -1) // -1이면 데이터베이스 오류인데 아이디는 primarykey라 중복이 되면 데이터베이스 오류가 발생
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 존재하는 아이디입니다')");
		script.println("history.back()");
		script.println("</script>");
	}
	else 
	{
		session.setAttribute("userID", user.getId());//name, value값
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('회원가입이 완료되었습니다.')");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}
%>

</body>
</html>