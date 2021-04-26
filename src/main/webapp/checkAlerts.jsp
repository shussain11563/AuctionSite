<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<html>
<head>
    <title>Product Alerts</title>
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
%>
<div class="jumbotron jumbotron-fluid">
    <h1 class="display-4">View available items below:</h1>
</div>
<table class="table table-bordered table-striped table-hover">
    <thead>
        <tr>
            <th>Product Title</th>
            <th>Open Date</th>
            <th>Close Date</th>
            <th>Close Time</th>
        </tr>
    </thead>
    <tbody>
    <%
        try {
            String data = "select b.bid_id, b.username, c.title, c.productID, c.brand, c.type, open_date, close_date, close_time, highest_bid " +
                    "from clothing c, bid_selling_offers b, product_alerts p where " +
                    "c.productID = b.productID and b.productID = p.productID and p.username='" + uname + "' " +
                    "and b.winner is null order by c.productID;";
            Statement stat = conn.createStatement();
            ResultSet res = stat.executeQuery(data);
            while (res.next()) {
                if ((new java.sql.Date(System.currentTimeMillis())).compareTo(res.getDate("close_date")) >= 0) {
                    SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
                    Date tempCurrentTime = new Date(System.currentTimeMillis());
                    String currentTimeStr = formatter.format(tempCurrentTime);
                    java.sql.Time currentTime = java.sql.Time.valueOf(currentTimeStr);
                    if (!(currentTime.toLocalTime().isBefore(res.getTime("close_time").toLocalTime()))) {
                        continue;
                    }
                }
    %>
    <tr>
        <td><%=res.getString("title")%></td>
        <td><%=res.getDate("open_date")%></td>
        <td><%=res.getDate("close_date")%></td>
        <td><%=res.getTime("close_time")%></td>
    </tr>
    <%
            }
            conn.close();
        } catch (SQLException throwable) {
            throwable.printStackTrace();
            out.print("Unable to check alerts :(");
        }
    } %>
    </tbody>
</table>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>

