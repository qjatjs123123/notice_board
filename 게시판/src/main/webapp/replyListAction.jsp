<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.userDAO" %>
<%@ page import="reply.reply" %>
<%@ page import="reply.replyDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<%
		int bbsID = 0;
		int index = 0;
		String data = "";
		if(request.getParameter("bbsID") != null)
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		if(request.getParameter("bbsID") != null )
			index = Integer.parseInt(request.getParameter("index"));
		replyDAO replyDAO = new replyDAO();
		ArrayList<reply> list = replyDAO.getList(bbsID,index);
		for(int i = 0 ;i<list.size();i++)
			data = data + list.get(i).getReplyContent()+ ",";
		data = data+"|";
		for(int i = 0 ;i<list.size();i++)
			data = data + list.get(i).getUserID()+ ",";
		data = data+"|";
		for(int i = 0 ;i<list.size();i++)
			data = data + list.get(i).getReplyID()+ ",";	
		data = data+"|";
		for(int i = 0 ;i<list.size();i++)
			data = data + list.get(i).getUserID()+ ",";
		
		if(list.size() != 0)
			data = data+"|"+list.get(list.size()-1).getReplyID();
		out.print(data);
	%>
	
		
</body>
</html>