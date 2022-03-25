<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
</head>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>
<script src="js/emailCheckAction.js?ver=1"></script> 
<link rel="stylesheet" href="css/emailCheckAction.css?after">
<%@ page import = "user.userDAO" %>
<%@ page import = "util.SHA256" %>
<%@ page import = "java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String code = null;
	userDAO userDAO = new userDAO();
	String userID = (String)session.getAttribute("findPw");
	
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('세션이 종료되었습니다.');");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
		
	}
	
	if(request.getParameter("code") != null)
		code = request.getParameter("code");
	
	String userEmail = userDAO.getUserEmail(userID);
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true : false;
	
	if(isRight == true) {
		   PrintWriter script = response.getWriter();
		   script.println("<script>");
		   script.println("alert('인증에 성공했습니다.');");		 
		   script.println("</script>");

	   } else {
		   PrintWriter script = response.getWriter();
		   script.println("<script>");
		   script.println("alert('유효하지 않은 코드입니다.');");
		   script.println("location.href = 'main.jsp'");
		   script.println("</script>");
	   }
%>


<body>
	<ul class="nav_ul">  	
    	<li><a href="main.jsp" onclick="nav_a(0)">메인</a></li>
    	<li><a href="bbs.jsp" onclick="nav_a(1)">게시판</a></li>
	    <li><a href="findId.jsp" onclick="nav_a(2)">아이디 찾기</a></li>
	    <li><a href="findPw.jsp" onclick="nav_a(3)">비밀번호 찾기</a></li>	 
    </ul>
      <section id="infor_text">
         <br>
         <span style="font-weight:bolder;">
            	비밀번호 변경
            	<hr>
         </span>
         <span style="font-size:13px;">
            	변경 하고자 하는 비밀번호를 입력해주세요. 
         </span>
      </section>
      
      <section class="id_find">
         <article>
            <form action="FindPasswdAction.jsp" method = "post" onsubmit="return pw_check();">
               <input class="name" id="pw" name="passwd" type="password" placeholder="변경할 비밀번호를 입력해주세요." ><br>
               <input class="name" id="re_pw" name="re_passwd" type="password" placeholder="변경할 비밀번호를 다시 입력해주세요"><br><br>
               <input type="submit" value="비밀번호 변경" style="width:100px; height:30px;">
            </form>
            <p id="result"></p>
         </article>
      </section>
      <section class="go_main">
      	<a href="main.jsp">메인 화면</a>
      </section>

</body>
</html>