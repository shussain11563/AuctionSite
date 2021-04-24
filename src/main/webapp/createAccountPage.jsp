<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Create Account</title>
</head>
<body>

<a href="loginBox.jsp">Login Page</a>|
<a href="createAccountPage.jsp">Create an Account</a>|
<a href="logout.jsp">Logout</a>|
<a href="profile.jsp">Profile</a>
<br><br>
<%
    session = request.getSession(false);
    String uname = (String) session.getAttribute("user");
    String accountType = (String) session.getAttribute("accountType");
    if (uname == null) {
%>
<h1>Create an Account</h1>
<br>
<form method="post" action="createAccount.jsp">
    <table>
        <tr>
            <td><label for="username">Username: </label></td>
            <td><input id="username" type="text" name="username"></td>
        </tr>
        <tr>
            <td><label for="password">Password: </label></td>
            <td><input id="password" type="text" name="password"></td>
        </tr>
        <tr>
            <td><label for="email">Email: </label></td>
            <td><input id="email" type="text" name="email"></td>
        </tr>
        <tr>
            <td><label for="phone">Phone: </label></td>
            <td><input id="phone" type="text" name="phone"></td>
        </tr>
    </table>
    <br>
    <input type="hidden" name="id" value="0">
    <input type="submit" value="Create Account">
</form>
<br>
<%
} else if (accountType.equals("admin_account")) {
%>
<h1>Create Customer Representative Account</h1>
<br>
<form method="post" action="createAccount.jsp">
    <table>
        <tr>
            <td><label for="usernameC">Username: </label></td>
            <td><input id="usernameC" type="text" name="username"></td>
        </tr>
        <tr>
            <td><label for="passwordC">Password: </label></td>
            <td><input id="passwordC" type="text" name="password"></td>
        </tr>
    </table>
    <br>
    <input type="hidden" name="id" value="1">
    <input type="submit" value="Create Account">
</form>
<br>
<%
    } else {
        out.print("You cannot create a new account because you are logged in already, " + uname);
    }
%>


</body>
</html>