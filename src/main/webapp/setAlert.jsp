<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Set Alert</title>
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

        String insert = "insert into product_alerts(username, productID) "
                + "values (?, ?)";

        try {
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
    <thead>
        <tr>
            <th>Product Title</th>
            <th>Open Date</th>
            <th>Close Date</th>
        </tr>
    </thead>
    <tbody>
    <%
            String data = "select c.title, b.open_date, b.close_date from clothing c, bid_selling_offers b, product_alerts p where " +
            "c.productID = b.productID and b.productID = p.productID and p.username='" + uname + "' order by c.productID;";
            Statement stat = conn.createStatement();
            ResultSet res = stat.executeQuery(data);
            while (res.next()) {
    %>
    <tr>
        <td><%=res.getString("title")%></td>
        <td><%=res.getDate("open_date")%></td>
        <td><%=res.getDate("close_date")%></td>
    </tr>
<%
            }
            conn.close();
        } catch (SQLException throwable) {
            throwable.printStackTrace();
%>
    <div class="jumbotron jumbotron-fluid">
        <h1 class="display-4">Unable to create alert :(</h1>
    </div>
<%
        }
    }
%>
    </tbody>
</table>
</body>
</html>
