<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Posted Answer</title>
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
