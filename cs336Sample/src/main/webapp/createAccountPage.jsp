<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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


<%
session=request.getSession(false); 
String uname = (String) session.getAttribute("user");
if(uname==null)
{
%>
	<h1>Create an Account</h1>  
<br>
		<form method="post" action="createAccount.jsp">
		<table>
		<tr>    
		<td>Username</td><td><input type="text" name="username"></td>
		</tr>
		<tr>
		<td>Password</td><td><input type="text" name="password"></td>
		</tr>
		<tr>
		<td>Email</td><td><input type="text" name="email"></td>
		</tr>
		<tr>
		<td>PhoneNumber</td><td><input type="text" name="phone"></td>
		</tr>
		</table>
		<input type="submit" value="Create Account">
		</form>
	<br>
	
<%
}
else
{
	out.print("You cannot create a new account because you are logged in already, " + uname);
}
%>


</body>
</html>