<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
</head>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>
<link rel="stylesheet" href="css/emailCheckAction.css?after">
<%@ page import = "user.userDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String code = null;
	userDAO userDAO = new userDAO();
	String userID = (String)session.getAttribute("findPw");
	String passwd = request.getParameter("passwd");
	
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('세션이 종료되었습니다.');");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
		
	}
	int result = userDAO.ChangePassword(userID, passwd);
	
	if(result == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호 변경되었습니다.');");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}
	else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.');");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}
	
	
%>
<body>

</body>
</html>