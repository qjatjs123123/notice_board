<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.userDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.user" scope="page" />
<jsp:setProperty name="user" property="id" />
<jsp:setProperty name="user" property="firstnum" />
<jsp:setProperty name="user" property="secondnum" />
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	userDAO userDAO = new userDAO();
	String name = request.getParameter("name");
	String firstnum = request.getParameter("firstnum");
	String secondnum = request.getParameter("secondnum");
	String result = userDAO.findId(name,firstnum,secondnum);		
	if (result == "0") // -1이면 데이터베이스 오류인데 아이디는 primarykey라 중복이 되면 데이터베이스 오류가 발생
		out.print("주민등록 오류");
	else if(result == "-1")
		out.print("해당하는 아이디가 없습니다.");
	else if(result == "-2")
		out.print("데이터베이스 오류");
	else
		out.print(result);
%>
</body>
</html>