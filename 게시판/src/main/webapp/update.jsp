<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.bbs" %>
<%@ page import="bbs.bbsDAO" %>
<%@ page import="java.util.ArrayList" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/write.css?ver=1">
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>
<script src="js/main.js?ver=1"></script> 



<title>로그인</title>
</head>
<style>

</style>
<body>
	<%
		//로그인 한 사람이라면 userID에 세션값인 아이디값이 담기게 될 것
		String userID = null;
		if(session.getAttribute("userID") != null)
			userID = (String) session.getAttribute("userID");
		/*else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}*/

		
		int bbsID = 0;
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
		
		bbs bbs = new bbsDAO().getBbs(bbsID);
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
	%>
    <ul class="nav_ul">  	
    	<li><a href="main.jsp" onclick="nav_a(0)">메인</a></li>
    	<li><a href="bbs.jsp" onclick="nav_a(1)">게시판</a></li>
	    <li><a href="findId.jsp" onclick="nav_a(2)">아이디 찾기</a></li>
	    <li><a href="findPw.jsp" onclick="nav_a(3)">비밀번호 찾기</a></li>	    
    </ul>
    <br>
    
    <div class="wrapper">
    <form method="post" action="updateAction.jsp?bbsID=<%=bbsID %>">
    	<table class="table_wrapper">
    		<thead>
    			<tr>
    				<td colspan="4">  				
						게시판 글쓰기 수정
					</td>
    			</tr>
    		</thead>
    		<tbody>
    			<tr>
    				<td colspan="4" >
    					<input style="width:100%; height:30px;" type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50">
    				</td>	
    			</tr>
    			<tr>	
					<td colspan="4">
						<textarea  class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height : 350px; width:100%; resize: none;"></textarea>
						<button class="btn" type="submit" style="float:right;">수정하기</button>
						<button class="btn" type="button" style="float:left;" onclick="location.href='bbs.jsp' ">뒤로</button>
					</td>
					
				</tr>		
    		</tbody>
    	</table>
    </form>
    </div>
    
	
    
    
</body>
</html>