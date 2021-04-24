<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Question Search</title>
</head>
<a href="loginBox.jsp">Login Page</a>
  |  <a href="createAccountPage.jsp">Create an Account</a>
  |  <a href="logout.jsp">Logout</a>
  |  <a href="profile.jsp">Profile</a>
  |  <a href="qaPage.jsp">Questions and Answers</a>
<style>
    table {
        border: 1px solid;
    }
    td {
        border: 1px solid;
    }
    div {
        word-wrap: break-word;
        hyphens: manual;
    }
    div.q {
        width: 200px;
    }
    div.a {
        width: 400px;
    }
</style>
<body>
<h1>Questions Search Results</h1>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    try {
        String[] keywords = request.getParameter("keywords").strip().split("\\s+");
        String str = "SELECT description, answer FROM question WHERE description LIKE '%" +
                keywords[0] + "%'";
        for (int i = 1; i < keywords.length; i++) {
            str += " OR description LIKE '%" + keywords[i] + "%'";
        }
        str += ";";
        ResultSet result = con.createStatement().executeQuery(str);
%>
<table>
    <tr>
        <td><b>Questions</b></td>
        <td><b>Answers</b></td>
    </tr>
<%
        while (result.next()) {
            String ans = result.getString("answer") == null ? "" : result.getString("answer");
%>
    <tr>
        <td><div class="q"><%=result.getString("description")%></div></td>
        <td><div class="a"><%=ans%></div></td>
    </tr>
<%
        }
        con.close();
    } catch (SQLException throwable) {
        throwable.printStackTrace();
        out.print("<br><br>Could not display questions :(");
    }
%>
</body>
</html>
