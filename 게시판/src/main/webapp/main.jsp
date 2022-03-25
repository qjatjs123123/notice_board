<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/main.css?after">
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
                <h2>게시판</h2>
                <form action ="loginAction.jsp" method = "post">
                    <input type='text' name = 'id' id='id' placeholder="ID" ><br> 
                    <input type='password' name = 'passwd' id='passwd' placeholder="PASSWORD"><br>
                    <input type='submit' value="로그인" >
                </form>
                <a class = "main_link" href="join.jsp">회원가입</a>
                <a class = "main_link" href="findId.jsp">아이디 찾기</a>
                <a class = "main_link" href="findPw.jsp">비밀번호 찾기</a>
       </div>
    </div>
    
    
</body>
</html>