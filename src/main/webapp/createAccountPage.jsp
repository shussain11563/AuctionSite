<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
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
    String accountType = (String) session.getAttribute("accountType");
    if (uname == null) {
%>
<h1>Create an Account</h1>
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
<%
    } else if (accountType.equals("admin_account")) {
%>
<h1>Create Customer Representative Account</h1>
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
<%
    } else {
        out.print("You cannot create a new account because you are logged in already, " + uname);
    }
%>
</body>
</html>