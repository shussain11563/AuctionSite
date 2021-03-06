<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Bid History</title>
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
<% String bidID = request.getParameter("bidID");
    request.setAttribute("bidID", bidID);%>
<div class="jumbotron jumbotron-fluid">
    <h1 class="display-4">Bid History for Bid${bidID}</h1>
</div>
<br>
<table class="table table-bordered table-striped table-hover">
    <thead>
        <tr>
            <th>Bidder</th>
            <th>Bid Value</th>
        </tr>
    </thead>
    <tbody>
<%
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    String data = "select m.username, m.bid_val from manual_bid m"
         + " where m.bid_id=" + bidID + " order by bid_val;";
    try{
        Statement stat = conn.createStatement();
        ResultSet res = stat.executeQuery(data);
        while (res.next()) {
    %>
    <tr>
        <% String username = res.getString("username");
            request.setAttribute("username", username);%>
        <td><a href="userHistory.jsp?username=${username}">${username}</a></td>
        <td><%=res.getFloat("bid_val")%></td>
    </tr>
        <%
        }
        conn.close();
    } catch (SQLException throwable) {
        throwable.printStackTrace();
        out.print("Unable to view history :(");
    }
%>
</table>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
