<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
<a href="searchPage.jsp">Search</a>
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
	<a href="checkAlerts.jsp">Check alerts </a>
</nav>

<%
session=request.getSession(false); 
String uname = (String) session.getAttribute("user");
if(uname==null)
{
	out.println("You are not logged in!");	
}
else
{
	String user=(String)session.getAttribute("user");  
    out.print("Hello, "+user+" Welcome to Profile"); 
}

%>
</body>
</html>