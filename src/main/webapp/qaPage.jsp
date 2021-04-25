<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Questions and Answers</title>
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
<%
    session = request.getSession(false);
    String uname = (String) session.getAttribute("user");
    if (uname == null) {
        out.print("<br><br>You are not logged in!");
    } else {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String accountType = (String) session.getAttribute("accountType");
%>
<h1>Questions and Answers</h1>
<%
            if (!accountType.equals("rep_account")) {
%>
<h2>Post a Question</h2>
<form method="post" action="postQuestion.jsp">
    <label for="question">Enter Question: </label>
    <br>
    <textarea name="question" id="question" required></textarea>
    <br><br>
    <input type="submit" value="Submit Question">
</form>
<%
            } else {
%>
<h2>Answer a Question</h2>
<form method="post" action="postAnswer.jsp">
    <label>Enter Question Number: <input type="number" name="question number" min="0" oninput="validity.valid||(value='');" required></label>
    <br>
    <label for="answer">Enter Answer: </label>
    <br>
    <textarea name="answer" id="answer" required></textarea>
    <br><br>
    <input type="submit" value="Submit Answer">
</form>
<%
            }
%>
<h2>Search for Questions</h2>
<form method="post" action="questionSearch.jsp">
    <label>Keywords: <input type="text" name="keywords" required></label>
    <input type="submit" value="Search">
</form>
<h2>10 Recently Asked Questions</h2>
<table>
    <tr>
        <td><b>Questions</b></td>
        <td><b>Answers</b></td>
    </tr>
<%
            Statement stmt = con.createStatement();
            ResultSet result = stmt.executeQuery("SELECT description, answer FROM question ORDER BY question_number DESC LIMIT 10;");
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
            out.print("<br><br>An SQL error occurred when trying to open this page :(");
        }
    }
%>
</table>
</body>
</html>
