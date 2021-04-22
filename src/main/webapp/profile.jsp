<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Profile</title>
</head>
<body>
<a href="loginBox.jsp">Login Page</a>|
<a href="createAccountPage.jsp">Create an Account</a>|
<a href="logout.jsp">Logout</a>|
<a href="profile.jsp">Profile</a>

<%
    session = request.getSession(false);
    String uname = (String) session.getAttribute("user");
    if (uname == null) {
        out.println("You are not logged in!");
    } else {
        String user = (String) session.getAttribute("user");
        out.println("Hello, " + user + " Welcome to Profile");
        String accountType = (String) session.getAttribute("accountType");

        if (accountType.equals("admin_account")) {
%>
<h1>Generate Sales Report</h1>
<h2>Total Earnings</h2>
<h2>Earnings Per Figure</h2>
<form method="post" action="adminProfile.jsp">
    <table>
        <tr>
            <label for="report">Choose Report Earnings Type: </label>
            <select name="sales_report" id="report">
                <option value="item">Per Item</option>
                <option value="item_type">Per Item Type</option>
                <option value="end_user">Per End User</option>
            </select>
        </tr>
    </table>
    <input type="submit" value="Create Report">
</form>
<h2>Best-Selling Items</h2>
<h2>Best Buyers</h2>
<%
        }
    }

%>
</body>
</html>