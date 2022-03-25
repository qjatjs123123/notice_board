<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.bbs" %>
<%@ page import="bbs.bbsDAO" %>
<%@ page import="reply.reply" %>
<%@ page import="reply.replyDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/view.css?ver=1">
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
		bbs b = new bbsDAO().getBbs(bbsID);
		int index = -1;
	%>



<title>로그인</title>
</head>

<body>

    <ul class="nav_ul">  	
    	<li><a href="main.jsp" onclick="nav_a(0)">메인</a></li>
    	<li><a href="bbs.jsp" onclick="nav_a(1)">게시판</a></li>
	    <li><a href="findId.jsp" onclick="nav_a(2)">아이디 찾기</a></li>
	    <li><a href="findPw.jsp" onclick="nav_a(3)">비밀번호 찾기</a></li>	    
    </ul>
    <br>
    
    <div class="wrapper">
    <form method="post" action="writeAction.jsp">
    	<table class="table_wrapper" >
    		<thead>
				<tr>
    				<td colspan="4">  				
						게시판 글 보기
						<button class="btn"  type="button" onclick="location.href='bbs.jsp' " style="float:left; margin-right:70px;">목록</button>
						<%
							if(userID.equals(b.getUserID())){
						%>
						<button class="btn"  type="button" onclick="location.href='update.jsp?bbsID=<%= bbsID %>' " style="float:right;">수정</button>
						<button type="button" onclick="confirm_alert(<%= bbsID %>)"  class="btn" style="float:right;">삭제</button>
						
						<%
							}
						%>
					</td>
    			</tr>
    		</thead>
    		<tbody>
				<tr>
					<td style="width:20%">
						글 제목
					</td>
					<td style="width:80%">
						<%= b.getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %>
					</td>
				</tr>
				
				<tr>
					<td style="width:20%">
						작성자
					</td>
					<td style="width:80%">
						<%= b.getUserID() %>
					</td>
				</tr>
				
				<tr>
					<td style="width:20%">
						작성일자
					</td>
					<td style="width:80%">
						<%= b.getBbsDate().substring(0,11) + b.getBbsDate().substring(11,13) +"시" +b.getBbsDate().substring(14,16)+"분" %>
					</td>
				</tr>
				
				<tr>
					<td style="width:20%">
						내용
					</td>
					<td style="width:80%">
						<%= b.getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %>
					</td>
				</tr>		
    		</tbody>
    	</table>
    </form>
    <br><br>
    </div>  
    
    <div style="text-align: center; margin-top:30px">
    	<form action="replyAction.jsp" method="post">
		        <input name = "replyContent" id="text1" class="center" type="text" size="40" maxlength = "45" placeholder="댓글을 입력하세요" style="width: 700px; height:30px">
		        <input type=hidden name="userID" value="<%=userID%>">
		        <input type=hidden name="bbsID" value="<%= bbsID %>">
				<input id = "input" type="submit"  value="입력하기" style=" height:30px">
        </form>
	</div>
    
    <br><br>

	
    <div class="wrapper">
    	<table class="table_wrapper" id="reply">
    		<thead>
    			<tr >  				
    				<th>아이디</th>
					<th>댓글</th>
    			</tr>
    		</thead>
    		<tbody>
    			
				<%
					replyDAO replyDAO = new replyDAO();					
					ArrayList<reply> list = replyDAO.getList(bbsID,-1);					
					for(int i = 0; i< list.size(); i++) {
				%>
				<tr>
					<td style="width:10%"><%= list.get(i).getUserID() %></td>
					<td style="width:90%"><%= list.get(i).getReplyContent() %>
						<%
							if(userID.equals(list.get(i).getUserID())){
						%>
						
						<button  type="button" onclick="confirm_alert_reply(<%= list.get(i).getReplyID() %>, <%=bbsID %>)"  class="btn" style="float:right;">삭제</button>
						
						<%
							}
						%>
					
					</td>
				</tr>
				<%
					}
					
					index = replyDAO.getLast(bbsID);
				%>
			
    		</tbody>
    	</table>
    </div>
    
</body>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>
<script src="js/view.js?ver=1"></script> 
<script>
var index;
var arr_All = new Array();
var arr_ID = new Array();
var arr_content = new Array();
var arr_replyID = new Array();
var arr_userID = new Array();



$(document).ready(function() { index = <%=index %>; });

$(window).scroll(function() {
	   var bbsID = <%=bbsID %>;	
	   var userID = "<%=userID %>";
	   var reply_table = document.getElementById('reply');
	   
	   if(Math.abs(parseInt($(window).scrollTop()+$(window).height()) - parseInt($(document).height()))<=2 ) {
		   if (index <= 0 || isNaN(index)==true)
			   return;
		   $.ajax({
				type : "POST",
				url : "replyListAction.jsp",
				data:{
					bbsID:bbsID,
					index:index
				},
				success:function(res){
					arr_All = res.split("|");
					arr_ID = arr_All[1].split(",");
					arr_content = arr_All[0].split(",");
					arr_replyID = arr_All[2].split(",");
					arr_userID = arr_All[3].split(",");
					
					for(i = 0 ; i<arr_ID.length-1;i++){
						newRow = reply_table.insertRow();
						newCell1 = newRow.insertCell(0);
						newCell2 = newRow.insertCell(1);
						newCell1.innerHTML = arr_ID[i];
						
						if(userID == arr_userID[i]){
							html2 = arr_content[i]+'<button onclick="confirm_alert_reply('+arr_replyID[i]+','+bbsID+')" type="button"  class="btn" style="float:right;">삭제</button>';
						}
						else{
							html2 = arr_content[i];
						}
						newCell2.innerHTML =html2;
					}
					index = parseInt(arr_All[4]);
				
				}
				
			});
		   
	   }
	   
	});




function confirm_alert(bbsID)
{
	var url = "deleteAction.jsp?bbsID="+bbsID;
	if (confirm("정말로 삭제하시겠습니까?")) {
		location.href=url;
    } 
	
}
function confirm_alert_reply(replyID,bbsID)
{
	var url = "deleteReplyAction.jsp?replyID="+replyID+"&bbsID="+bbsID;
	if (confirm("정말로 삭제하시겠습니까?")) {
		location.href=url;
    } 
	
}

</script>
</html>