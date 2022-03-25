<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="reply.replyDAO" %>
<%@ page import="reply.reply" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<html>
<head>
<meta charset="UTF-8">
<%--부트스트랩은 핸드폰, 컴퓨터 어떠한 환경이 와도 해상도 맞게 설정 --%>
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
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
		
		
		int replyID = 0;
		int bbsID = 0;
		if(request.getParameter("replyID") != null)
			replyID = Integer.parseInt(request.getParameter("replyID"));
		if(request.getParameter("bbsID") != null)
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		if(bbsID == 0)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않는 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
		
		replyDAO replyDAO = new replyDAO();
		if(!userID.equals(replyDAO.getUserID(replyID))){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'view.jsp'");
			script.println("</script>");
		}
		
		
		
		
		else{
					
					int result = replyDAO.delete(replyID);	
					if (result == -1) // -1이면 데이터베이스 오류인데 아이디는 primarykey라 중복이 되면 데이터베이스 오류가 발생
					{
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글 삭제에 실패했습니다.')");
						script.println("history.back()");
						script.println("</script>");
					}
					else 
					{	
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.print("location.href = 'view.jsp?bbsID=");
						script.print(bbsID+"'");
						script.println("</script>");
					}
				}
		
	
	
		
		
	%>
</body>
<script>

</script>
</html>