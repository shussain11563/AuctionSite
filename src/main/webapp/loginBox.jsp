<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
    <title>Log In</title>
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