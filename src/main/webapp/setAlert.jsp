<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
        integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
        crossorigin="anonymous">
</head>
<body>
<%
    session=request.getSession(false);
    String uname = (String) session.getAttribute("user");
    if(uname==null)
    {
        out.println("You are not logged in!");
    }
    else {
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();

        int productID = Integer.parseInt(request.getParameter("productID"));

        String insert = "insert into alerts(username, productID) "
                + "values (?, ?)";

        PreparedStatement ps = conn.prepareStatement(insert);

        ps.setString(1, uname);
        ps.setInt(2, productID);

        ps.executeUpdate();
%>
<div class="jumbotron jumbotron-fluid">
    <h1 class="display-4">Alert Created! View your current alerts below:</h1>
</div>
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    <a href="checkAlerts.jsp">Check alerts </a>
</nav>
<table class="table table-bordered table-striped table-hover">
    <thread>
        <tr>
            <th>Product Title</th>
            <th>Open Date</th>
            <th>Close Date</th>
        </tr>
    </thread>
    <tbody>
    <%
    String data = "select c.title, b.open_date, b.close_date from clothing c, bid_selling_offers b, alerts a where " +
    "c.productID = b.productID and b.productID = a.productID and a.username='" + uname + "' order by c.productID asc";
    Statement stat = conn.createStatement();
    ResultSet res = stat.executeQuery(data);
    while (res.next()) {
    %>
    <tr>
        <td><%=res.getString("title")%></td>
        <td><%=res.getDate("open_date")%></td>
        <td><%=res.getDate("close_date")%></td>
    </tr>
<% }
    conn.close();
} %>
</tbody>
</table>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
