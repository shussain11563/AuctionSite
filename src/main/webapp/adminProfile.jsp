<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Profile</title>
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
        Statement stmt = con.createStatement();
        int formID = Integer.parseInt(request.getParameter("id"));
        String str = "";
        ResultSet result;
        switch (formID) {
            case 0:
                str = "SELECT SUM(highest_bid) FROM bid_selling_offers WHERE winner IS NOT NULL;";
                result = stmt.executeQuery(str);
                if (result.next()) out.print("<h1>Total Earnings</h1>The total earnings are: $" + result.getString("SUM(highest_bid)"));
                break;
            case 1:
                int reportType = Integer.parseInt(request.getParameter("report type"));
                switch (reportType) {
                    case 0:
                        str = "SELECT CONCAT(c.title, ', ', c.brand) repType, SUM(highest_bid) earning " +
                                "FROM bid_selling_offers b " +
                                "JOIN clothing c ON c.productID = b.productID " +
                                "WHERE c.title IS NOT NULL AND c.brand IS NOT NULL AND b.winner IS NOT NULL " +
                                "GROUP BY c.title, c.brand;";
                        break;
                    case 1:
                        str = "SELECT c.type repType, SUM(b.highest_bid) earning " +
                                "FROM bid_selling_offers b " +
                                "JOIN clothing c ON c.productID = b.productID " +
                                "WHERE c.type IS NOT NULL AND b.winner IS NOT NULL " +
                                "GROUP BY c.type;";
                        break;
                    case 2:
                        str = "SELECT winner repType, SUM(highest_bid) earning FROM bid_selling_offers " +
                                "WHERE winner IS NOT NULL " +
                                "GROUP BY winner;";
                        break;
                    default:
                }
                result = stmt.executeQuery(str);
                switch (reportType) {
                    case 0:
                        out.print("<h1>Earnings Per Item</h1>");
                        break;
                    case 1:
                        out.print("<h1>Earnings Per Item Type</h1>");
                        break;
                    case 2:
                        out.print("<h1>Earnings Per End User</h1>");
                    default:
                }
%>
<table class="table table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th>
        <%
                switch (reportType) {
                    case 0:
                        out.print("Item");
                        break;
                    case 1:
                        out.print("Item Type");
                        break;
                    case 2:
                        out.print("End User");
                    default:
                }
        %>
        </th>
        <th>Earnings</th>
    </tr>
    </thead>
    <%
                while (result.next()) {
    %>
    <tr>
        <td><%=result.getString("repType")%></td>
        <td><%=result.getFloat("earning")%></td>
    </tr>
    <%;
                }
    %>
</table>
<%
                break;
            case 2:
            case 3:
                if (formID == 2) {
                    %>
<h1>Best Selling Items</h1>
                    <%;
                    str = "SELECT CONCAT(c.title, ', ', c.brand) cat, COUNT(b.bid_id) num " +
                            "FROM bid_selling_offers b " +
                            "JOIN clothing c ON c.productID = b.productID " +
                            "WHERE c.title IS NOT NULL AND c.brand IS NOT NULL AND b.winner IS NOT NULL " +
                            "GROUP BY c.title, c.brand " +
                            "ORDER BY num DESC;";
                } else {
                    %>
<h1>Best Buyers</h1>
                    <%;
                    str = "SELECT winner cat, COUNT(bid_id) num FROM bid_selling_offers " +
                            "WHERE winner IS NOT NULL " +
                            "GROUP BY winner " +
                            "ORDER BY num DESC;";
                }
                result = stmt.executeQuery(str);
%>
<table class="table table-bordered table-striped table-hover">
    <thead>
    <tr>
        <%
                if (formID == 2) {
                    %>
        <th>Items</th>
        <th>Number Sold</th>
                    <%;
                } else {
                    %>
        <th>Buyers</th>
        <th>Number Bought</th>
                    <%;
                }
        %>
    </tr>
    </thead>
    <%
                while (result.next()) {
    %>
    <tr>
        <td><%=result.getString("cat")%></td>
        <td><%=result.getString("num")%></td>
    </tr>
    <%;
                }
    %>
</table>
<%
                break;
            default:
        }
        con.close();
    } catch (SQLException throwable) {
        throwable.printStackTrace();
    }
%>
</body>
</html>
