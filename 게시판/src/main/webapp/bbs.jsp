<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.bbs" %>
<%@ page import="bbs.bbsDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/bbs.css?ver=1">
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>
<script src="js/main.js?ver=1"></script> 



<title>로그인</title>
</head>
<script>
	function change_page(page,IsRight){
		$.ajax({
			type : "POST",
			url : "bbs.jsp",
			data:{
				pageNumber:page,IsRight:IsRight
			},
			success:function(){
				location.href="bbs.jsp";
				}
			
		});
	}
</script>
<body>
	<%
		//로그인 한 사람이라면 userID에 세션값인 아이디값이 담기게 될 것
		String userID = null;
		if(session.getAttribute("userID") != null)
			userID = (String) session.getAttribute("userID");
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		int pageNumber = 1;
		
		if(request.getParameter("pageNumber") != null)
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));

		
	%>
    <ul class="nav_ul">  	
    	<li><a href="main.jsp" onclick="nav_a(0)">메인</a></li>
    	<li><a href="bbs.jsp" onclick="nav_a(1)">게시판</a></li>
	    <li><a href="findId.jsp" onclick="nav_a(2)">아이디 찾기</a></li>
	    <li><a href="findPw.jsp" onclick="nav_a(3)">비밀번호 찾기</a></li>	    
    </ul>
    <br>
    <h2 style="text-align:center;">게시판</h2>
    <div class="wrapper">
    	<table class="table_wrapper">
    		<thead>
    			<tr >  				
    				<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
    			</tr>
    		</thead>
    		<tbody>
    			
				<%
					bbsDAO bDAO = new bbsDAO();
					int MaxPageNumber = bDAO.MaxPageCount();
					ArrayList<bbs> list = bDAO.getList(pageNumber);
					
					for(int i = 0; i< list.size(); i++) {
				%>
				<tr>
					<td ><%= list.get(i).getBbsID() %></td>
					<td><a href = "view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td>
					<td><%= list.get(i).getUserID() %>
					<%
						if(list.get(i).getUserID().equals(userID)){
					%>
						<span style="color:red">(나)</span>
					<%
						}
					%>
					</td>
					<td><%= list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13) +"시" +list.get(i).getBbsDate().substring(14,16)+"분"%></td>
				</tr>
				<%
					}
				%>
				<tr>
					<td colspan="4">
						<%
							if(pageNumber != 1){
						%>	
							<button class="btn" type="button" onclick="location.href='bbs.jsp?pageNumber=<%=pageNumber - 1 %>' " style="float:left;">이전</button>
						<%
							}else{
						%>
							<button class="btn" disabled='disabled' type="button" onclick="location.href='bbs.jsp?pageNumber=<%=pageNumber - 1 %>' " style="float:left;">이전</button>
						<%							
							}
						%>
						<%= pageNumber %>/<%= MaxPageNumber %>

						<%
							if(pageNumber <MaxPageNumber){
						%>
							<button class="btn" type="button" onclick="location.href='bbs.jsp?pageNumber=<%=pageNumber + 1 %>' " style="float:left;">다음</button>
						<%
							}else{
						%>
						
						
							<button class="btn" disabled='disabled' type="button" onclick="location.href='bbs.jsp?pageNumber=<%=pageNumber + 1 %>' " style="float:left;">다음</button>
						
						<%
							}
						%>

						<button class="btn" type="button" onclick="location.href='write.jsp' "  style="float:right;">글쓰기</button>
					</td>
				</tr>
				
    		</tbody>
    	</table>
    </div>
    
    
</body>
</html>