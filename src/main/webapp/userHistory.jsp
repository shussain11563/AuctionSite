<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
          crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<div id="navigation">

</div>
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script>
    $(function () {
        $("#navigation").load("navigation.html");
    });
</script>
<body>
<% String username = request.getParameter("username");
    request.setAttribute("username", username);%>
<div class="jumbotron jumbotron-fluid">
    <h1 class="display-4">User History for ${username}</h1>
</div>
<button type="button" class="btn btn-secondary btn-lg btn-block" onclick="history.back()">Back to Search</button>
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    History of Sells
</nav>
<table class="table table-bordered table-striped table-hover">
    <thread>
        <tr>
            <th>Bid Number</th>
            <th>Product Title</th>
            <th>Open Date</th>
            <th>Close Date</th>
        </tr>
    </thread>
    <tbody>
    <%
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();
        String data = "select b.bid_id, c.title from bid_selling_offers b, clothing c where b.username='" +
                username + "' and (b.productID = c.productID) order by bid_id asc";
        Statement stat = conn.createStatement();
        ResultSet res = stat.executeQuery(data);
        while (res.next()) {
    %>
    <tr>
        <td><%=res.getInt("bid_id")%>
        </td>
        <td><%=res.getString("title")%>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    History of Bids
</nav>
<table class="table table-bordered table-striped table-hover">
    <thread>
        <tr>
            <th>Bid Number</th>
            <th>Product Title</th>
            <th>Open Date</th>
            <th>Close Date</th>
        </tr>
    </thread>
    <tbody>
    <%
        Statement stat2 = conn.createStatement();
        String data2 = "select m.bid_id as bid_id, c.title from manual_bid m, clothing c where m.username='" +
                username + "' union select a.bid_number as bid_id, c.title from auto_bid a, clothing c where a.username='"
                + username + "' order by bid_id asc";
        ResultSet res2 = stat2.executeQuery(data2);
        while (res2.next()) {
    %>
    <tr>
        <td><%=res2.getInt("bid_id")%>
        </td>
        <td><%=res2.getString("title")%>
        </td>
    </tr>

    <%
        }
        conn.close();
    %>
    </tbody>
</table>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
</body>
</html>
