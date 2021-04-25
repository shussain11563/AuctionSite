<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
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
        ResultSet result = con.createStatement().executeQuery("SELECT MAX(question_number) qNum FROM question;");
        int qNum;
        if (result.next()) {
            qNum = result.getInt("qNum")+1;
        } else {
            qNum = 1;
        }

        con.createStatement().executeUpdate(
                "INSERT INTO question (question_number, description) VALUES (" +
                        qNum + ", '" + request.getParameter("question") + "');"
        );

        out.print("Posted question successfully!");
        con.close();
    } catch (SQLException throwable) {
        throwable.printStackTrace();
        out.print("Failed to post question :(");
    }
%>
</body>
</html>
