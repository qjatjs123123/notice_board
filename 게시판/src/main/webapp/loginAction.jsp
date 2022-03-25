<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.userDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.user" scope="page" />
<jsp:setProperty name="user" property="id" />
<jsp:setProperty name="user" property="passwd" />

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
	<%		
		userDAO userDAO = new userDAO();
		int result = userDAO.login(user.getId(),user.getPasswd());
		
		if(result == 1){
			/*세션: 현재 접속한 회원에게 할당된 고유의 ID 우리의 웹서버는 한명의 회원을 세션으로 구분
			로그인을 했을 떄 세션을 부여*/
			session.setAttribute("userID", user.getId());//name, value값
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		else if (result == 0)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (result == -1)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('아이디가 존재하지 않습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (result == -2)                         
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>

</body>
</html>