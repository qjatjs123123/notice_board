<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="reply.replyDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<%
		//로그인 되어 있는 사람은 세션값을 확인해 또 다시 로그인 할 수 없도록 막아줌
		String userID = null;
		if(session.getAttribute("userID") != null)
			userID = (String) session.getAttribute("userID");
		if(userID == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		else{
			String replyContent = request.getParameter("replyContent");
			
			int bbsID = Integer.parseInt(request.getParameter("bbsID"));;

			if(replyContent == null)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('입력이 안 된 사항이 있습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else{
					replyDAO replyDAO = new replyDAO();
					int result = replyDAO.write(bbsID, userID, replyContent);		
					if (result == -1) // -1이면 데이터베이스 오류인데 아이디는 primarykey라 중복이 되면 데이터베이스 오류가 발생
					{
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('댓글 쓰기에 실패했습니다.')");
						script.println("history.back()");
						script.println("</script>");
					}
					else 
					{	
						response.sendRedirect("view.jsp?bbsID="+bbsID);
						}
				}
		}
	
	
		
		
	%>
<body>

</body>
</html>