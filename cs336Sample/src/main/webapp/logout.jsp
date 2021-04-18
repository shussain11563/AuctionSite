<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Logged Out</title>
</head>
<body>

<a href="loginBox.jsp">Login Page</a>|  
<a href="createAccountPage.jsp">Create an Account</a>|  
<a href="logout.jsp">Logout</a>|  
<a href="profile.jsp">Profile</a> 


<%
session=request.getSession(false);  
String uname = (String) session.getAttribute("user");
if(uname!=null)
{
	session.invalidate();
	out.print("You are successfully logged out!");  
	out.close();
}
else
{
	out.print("You are not logged in!"); 
	out.close();
}

  

%>

</body>
</html>