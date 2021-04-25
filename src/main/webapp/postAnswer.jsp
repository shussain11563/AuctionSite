<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Posted Answer</title>
</head>
<a href="loginBox.jsp">Login Page</a>
  |  <a href="createAccountPage.jsp">Create an Account</a>
  |  <a href="logout.jsp">Logout</a>
  |  <a href="profile.jsp">Profile</a>
  |  <a href="qaPage.jsp">Questions and Answers</a>
<body>
<br><br>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    try {
        con.createStatement().executeUpdate(
                "UPDATE question SET answer = '" +
                        request.getParameter("answer") + "' WHERE question_number = " +
                        request.getParameter("question number") + ";"
        );

        out.print("Posted answer to question #" + request.getParameter("question number") +" successfully!");
        con.close();
    } catch (SQLException throwable) {
        throwable.printStackTrace();
        out.print("Failed to post answer :(");
    }
%>
</body>
</html>
