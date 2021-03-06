<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Question Search</title>
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
<h1>Questions Search Results</h1>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    try {
        String[] keywords = request.getParameter("keywords").strip().split("\\s+");
        StringBuilder str = new StringBuilder("SELECT description, answer FROM question WHERE description LIKE '%" +
                keywords[0] + "%'");
        for (int i = 1; i < keywords.length; i++) {
            str.append(" OR description LIKE '%").append(keywords[i]).append("%'");
        }
        str.append(";");
        ResultSet result = con.createStatement().executeQuery(str.toString());
%>
<table class="table table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th>Questions</th>
        <th>Answers</th>
    </tr>
    </thead>
<%
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
        out.print("<br><br>Could not display questions :(");
    }
%>
</body>
</html>
