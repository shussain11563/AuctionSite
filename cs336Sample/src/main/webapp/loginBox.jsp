<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Log In</title>
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
		<h1>Login</h1>  
	<br>
		<form method="post" action="loginPage.jsp">
			<table>
				<tr>    
					<td>Username</td><td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td>Password</td><td><input type="text" name="password"></td>
				</tr>
			</table>
			<label for="account">Choose an Account type:</label>
			  <select name="account" id="cars">
    			<option value="enduser_account">Normal Account</option>
    			<option value="rep_account">Representative Account</option>
    			<option value="admin_account">Admin Account</option>
  			</select>
			
			
			<input type="submit" value="Login">
		</form>
	<br>
	
<%
}
else
{
	out.print("You cannot log in because you are logged in already, " + uname);
}
%>


</body>
</html>