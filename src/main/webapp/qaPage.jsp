<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Questions and Answers</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
          crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<div id="navigation">

</div>
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script>
    $(function() {
        $("#navigation").load("navigation.html");
    });
</script>
<body>
<%
    session = request.getSession(false);
    String uname = (String) session.getAttribute("user");
    if (uname == null) {
        out.print("You are not logged in!");
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
<table class="table table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th>Questions</th>
        <th>Answers</th>
    </tr>
    </thead>
<%
            Statement stmt = con.createStatement();
            ResultSet result = stmt.executeQuery("SELECT description, answer FROM question ORDER BY question_number DESC LIMIT 10;");
            while (result.next()) {
                String ans = result.getString("answer") == null ? "" : result.getString("answer");
%>
    <tr>
        <td><%=result.getString("description")%></td>
        <td><%=ans%></td>
    </tr>
<%
            }
            con.close();
        } catch (SQLException throwable) {
            throwable.printStackTrace();
            out.print("An SQL error occurred when trying to open this page :(");
        }
    }
%>
</table>
</body>
</html>
