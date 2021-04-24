<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Profile</title>
</head>
<body>
<a href="loginBox.jsp">Login Page</a>|
<a href="createAccountPage.jsp">Create an Account</a>|
<a href="logout.jsp">Logout</a>|
<a href="profile.jsp">Profile</a>
<br><br>
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
                if (result.next()) out.print("The total earnings are: $" + result.getString("SUM(highest_bid)"));
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
%>
<table>
    <tr>
        <td>
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
        </td>
        <td>Earnings</td>
    </tr>
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
<table>
    <tr>
        <%
                if (formID == 2) {
                    %>
        <td>Items</td>
        <td>Number Sold</td>
                    <%;
                } else {
                    %>
        <td>Buyers</td>
        <td>Number Bought</td>
                    <%;
                }
        %>
    </tr>
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
    } catch (SQLException throwable) {
        throwable.printStackTrace();
    }
%>
</body>
</html>
