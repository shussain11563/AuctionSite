<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Profile</title>
</head>
<body>
<a href="loginBox.jsp">Login Page</a>
  |  <a href="createAccountPage.jsp">Create an Account</a>
  |  <a href="logout.jsp">Logout</a>
  |  <a href="profile.jsp">Profile</a>
  |  <a href="qaPage.jsp">Questions and Answers</a>
  |  <a href="searchPage.jsp">Search</a>
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
	<a href="checkAlerts.jsp">Check alerts </a>
</nav>
<%
    session = request.getSession(false);
    String uname = (String) session.getAttribute("user");
    if (uname == null) {
        out.println("You are not logged in!");
    } else {
        String user = (String) session.getAttribute("user");
        out.println("Hello " + user + ", welcome to your profile!");
        String accountType = (String) session.getAttribute("accountType");

        if (accountType.equals("admin_account")) {
%>
<h1>Generate Sales Report</h1>
<h2>Total Earnings</h2>
<form method="post" action="adminProfile.jsp">
    <input type="hidden" name="id" value="0">
    <input type="submit" value="Generate">
</form>
<h2>Earnings Per Figure</h2>
<form method="post" action="adminProfile.jsp">
    <label for="report">Choose Report Earnings Type: </label>
    <select name="report type" id="report">
        <option value="0">Per Item</option>
        <option value="1">Per Item Type</option>
        <option value="2">Per End User</option>
    </select>
    <br>
    <input type="hidden" name="id" value="1">
    <input type="submit" value="Generate">
</form>
<h2>Best-Selling Items</h2>
<form method="post" action="adminProfile.jsp">
    <input type="hidden" name="id" value="2">
    <input type="submit" value="Generate">
</form>
<h2>Best Buyers</h2>
<form method="post" action="adminProfile.jsp">
    <input type="hidden" name="id" value="3">
    <input type="submit" value="Generate">
</form>
<%
} else if (accountType.equals("rep_account")) {
%>
<h1>Account Information Control</h1>
<h2>Account Editing</h2>
<form method="post" action="repProfile.jsp">
    <table>
        <tr>
            <td><label for="username">Enter User:</label></td>
            <td><input id="username" type="text" name="username" required></td>
        </tr>
        <tr>
            <td><label for="password">Edit Password: </label></td>
            <td><input id="password" type="text" name="password"></td>
        </tr>
        <tr>
            <td><label for="email">Edit Email: </label></td>
            <td><input id="email" type="text" name="email"></td>
        </tr>
        <tr>
            <td><label for="phone">Edit Phone: </label></td>
            <td><input id="phone" type="text" name="phone"></td>
        </tr>
    </table>
    <br>
    <input type="hidden" name="id" value="0">
    <input type="submit" value="Confirm Edits">
</form>
<h2>Account Deletion</h2>
<form method="post" action="repProfile.jsp">
    <label>Enter User: <input type="text" name="username" required></label>
    <input type="hidden" name="id" value="1">
    <input type="submit" value="Delete">
</form>
<h2>Bid Deletion</h2>
<form method="post" action="repProfile.jsp">
    <table>
        <tr>
            <td><label for="bid type">Choose Bid Type: </label></td>
            <td>
                <select name="bid type" id="bid type">
                    <option value="manual">Manual</option>
                    <option value="auto">Automatic</option>
                </select>
            </td>
        </tr>
        <tr>
            <td><label for="username1">Enter User: </label></td>
            <td><input id="username1" type="text" name="username" required></td>
        </tr>
        <tr>
            <td><label for="bidID">Enter Bid ID: </label></td>
            <td><input id="bidID" type="text" name="bidID" required></td>
        </tr>
    </table>
    <input type="hidden" name="id" value="2">
    <input type="submit" value="Delete">
</form>
<h2>Auction Deletion</h2>
<form method="post" action="repProfile.jsp">
    <label>Enter Bid ID: <input type="text" name="bidID" required></label>
    <input type="hidden" name="id" value="3">
    <input type="submit" value="Delete">
</form>
<%
        }
    }
%>
</body>
</html>