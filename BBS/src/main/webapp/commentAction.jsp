<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="comment" class="comment.Comment" scope="page" />
<jsp:setProperty name="comment" property="commentContent"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID= null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href = 'login.jsp'");//이전(로그인) 페이지로 돌려보냄
			script.println("</script>");
		}else{
			if(comment.getCommentContent() == null){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('내용을 입력하세요')");
					script.println("history.back()");
					script.println("</script>");
			}else{
				CommentDAO commentDAO = new CommentDAO();
				int commentBoard = Integer.parseInt(request.getParameter("hiddenvalue"));
				int result = commentDAO.write(commentBoard, userID, comment.getCommentContent());
				if(result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글쓰기에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else{
					response.sendRedirect("commentViewNWrite.jsp?bbsID="+String.valueOf(commentBoard));
				}
			}
		}
		%>
</body>
</html>