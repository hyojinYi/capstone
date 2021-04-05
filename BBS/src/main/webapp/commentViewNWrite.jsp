<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/header.jsp" %>
<jsp:useBean id="comment" class="comment.Comment" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name= "viewport" content="width=device-width", initial-scale="1"><!-- 반응형 웹에 사용되는 메타태그 -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}	
		int commentBoard = 0;
		if(request.getParameter("bbsID") == null){
		}
		if(request.getParameter("bbsID") != null){
			commentBoard = Integer.parseInt(request.getParameter("bbsID")); 
			
		}
	%>
	<a href="view.jsp?bbsID=<%=commentBoard %>" class="btn btn-success btn-arraw-left">본문보기</a>
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border:1px solid #dddddd"> 
				<thead>
					
				</thead>
				<tbody>
				<%
					CommentDAO commentDAO = new CommentDAO();
					ArrayList<Comment> list = commentDAO.getList(pageNumber);
					for(int i=0; i<list.size(); i++){
				%>
					<tr>
						<td><%= list.get(i).getUserID()%></td>
						<td><%= list.get(i).getCommentDate().substring(0, 11) + list.get(i).getCommentDate().substring(11, 13) + "시 " + list.get(i).getCommentDate().substring(14, 16) + "분 " %></td>
					</tr>
					<tr>
						<td colspan="2" style="min-height:20px; text-align:left;"><%= list.get(i).getCommentContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
					<%
						if(userID != null && userID.equals(comment.getUserID())){
					%>
					<a href="update.jsp?bbsID=<%=comment.getCommentNum() %>" class="btn btn-primary">수정</a>
					<%
						}
					%>
				<%
					}
				%>
				</tbody>
			</table>
			<%
				if(pageNumber!= 1){
			%>
				<a href="commentViewNWrite.jsp?pageNumber=<%=pageNumber-1 %>" class="btn btn-success btn-arraw-left">이전</a>
			<%
				} if(commentDAO.nextPage(pageNumber + 1)){
			%>
				<a href="commentViewNWrite.jsp?pageNumber=<%=pageNumber+1 %>" class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>
		</div>
	</div>		
			

	<div class="container">
		<div class="row">
		<form method="post" action="commentAction.jsp">
		<table class="table table-striped" style="text-align: center; border:1px solid #dddddd"> 
				<thead>
					<tr>
						<th colspan="2" style="background-color:#eeeeee; text-align: center;">댓글 쓰기 양식</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><textarea class="form-control" placeholder="댓글 내용" name="commentContent" maxlength="200" style="height: 100px;"></textarea></td>
					</tr>
				</tbody>
		</table>
		<input type="submit" class="btn btn-primary pull-right" value="댓글쓰기">
		</form>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>