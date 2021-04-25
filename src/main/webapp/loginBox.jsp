<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Log In</title>
</head>
<body>
<a href="loginBox.jsp">Login Page</a>
| <a href="createAccountPage.jsp">Create an Account</a>
| <a href="logout.jsp">Logout</a>
| <a href="profile.jsp">Profile</a>
| <a href="qaPage.jsp">Questions and Answers</a>
<%
    session = request.getSession(false);
    String uname = (String) session.getAttribute("user");
    if (uname == null) {
%>
<h1>Login</h1>
<form method="post" action="loginPage.jsp">
    <table>
        <tr>
			<td><label for="username">Username: </label></td>
            <td><input type="text" id="username" name="username"></td>
        </tr>
        <tr>
			<td><label for="password">Password: </label></td>
            <td><input type="text" id="password" name="password"></td>
        </tr>
    </table>
	<br>
    <label for="cars">Choose an Account type:</label>
    <select name="account" id="cars">
        <option value="enduser_account">Normal Account</option>
        <option value="rep_account">Representative Account</option>
        <option value="admin_account">Admin Account</option>
    </select>
	<br><br>
    <input type="submit" value="Login">
</form>
<%
    } else {
        out.print("<br><br>You cannot log in because you are logged in already, " + uname);
    }
%>


</body>
</html>