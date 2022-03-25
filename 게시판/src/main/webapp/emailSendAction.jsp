<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="java.util.Properties" %>
<%@ page import="user.userDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="util.Gmail" %>
<%@ page import = "user.user" %>
<%@ page import="java.io.PrintWriter" %>

<%
   request.setCharacterEncoding("UTF-8");
   userDAO userDAO = new userDAO();
   String id = request.getParameter("id");
   String firstnum = request.getParameter("firstnum");
   String secondnum = request.getParameter("secondnum");
   String email = request.getParameter("email");
   
   user user = new user();
  
   user.setFirstnum(firstnum);
   user.setSecondnum(secondnum);
   user.setEmail(email);
   
   String result = userDAO.getUserEmail(id, firstnum, secondnum, email);
   
   if (result == "0"){
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('해당하는 정보가 없습니다.')");
      script.println("location.href = 'findPw.jsp'");
      script.println("</script>");
   }
   else if(result == "-1"){
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('데이터베이스 오류입니다.')");
      script.println("location.href = 'findPw.jsp'");
      script.println("</script>");
   }
   else{
      String host = "http://localhost:8050/게시판/";
      String from = "qjatjs123123@gmail.com";
      String to = result;
      String subject = "비밀번호 변경을 위한 이메일 인증 메일입니다.";
      String content = "다음 링크에 접속하여 이메일 확인을 진행하세요." +
            "<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";
            
      Properties p = new Properties();
      p.put("mail.smtp.user", from);
      p.put("mail.smtp.host", "smtp.googlemail.com");
      p.put("mail.smtp.port", "456");
      p.put("mail.smtp.starttls.enable", "true");
      p.put("mail.smtp.auth", "true");
      p.put("mail.smtp.debug", "true");
      p.put("mail.smtp.socketFactory.port", "465");
      p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
      p.put("mail.smtp.socketFactory.fallback", "false");
      p.put("mail.smtp.ssl.protocols", "TLSv1.2"); 
      
      try{
         Authenticator auth = new Gmail();
         Session ses = Session.getInstance(p, auth);
         ses.setDebug(true);
         MimeMessage msg = new MimeMessage(ses);
         msg.setSubject(subject);
         Address fromAddr = new InternetAddress(from);
         msg.setFrom(fromAddr);
         Address toAddr = new InternetAddress(to);
         msg.addRecipient(Message.RecipientType.TO, toAddr);
         msg.setContent(content, "text/html;charset=UTF8");
         Transport.send(msg);
         session.setAttribute("findPw",id);  
         session.setMaxInactiveInterval(1*60);
      }catch(Exception e){
         e.printStackTrace();
         PrintWriter script = response.getWriter();
         script.println("<script>");
         script.println("alert('오류가 발생했습니다.')");
         script.println("location.href = 'findPw.jsp'");
         script.println("</script>");
      }
   }
      
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/emailSendAction.css?after">
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>
<script src="js/main.js?ver=1"></script> 

<title>로그인</title>
</head>
<script>

</script>
<body>
    <ul class="nav_ul">  	
    	<li><a href="main.jsp" onclick="nav_a(0)">메인</a></li>
    	<li><a href="bbs.jsp" onclick="nav_a(1)">게시판</a></li>
	    <li><a href="findId.jsp" onclick="nav_a(2)">아이디 찾기</a></li>
	    <li><a href="findPw.jsp" onclick="nav_a(3)">비밀번호 찾기</a></li>	    
    </ul>
    
    <div class="wrapper">
    	
    	<div class="container">
                이메일 주소 인증 메일이 전송되었습니다. <br>비밀번호 변경시 입력했던 이메일에 들어가셔서 인증해주세요.

       </div>
    </div>
    
    
</body>
</html>
