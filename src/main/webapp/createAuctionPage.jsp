<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, java.util.Date.*"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create Auction</title>
</head>
<body>

<a href="logout.jsp">Logout</a>|  
<a href="profile.jsp">Profile</a> 
<a href="createAuctionPage.jsp">Create Auction</a> 


	<h1>Create an Auction</h1>  
<br>
		<form method="post" action="createAuction.jsp" id="createAuction">
		<table>
		<tr>    
		<td>Title</td><td><input type="text" name="title" required></td>
		</tr>
		<tr>    
		<td>Brand</td><td><input type="text" name="brand" required></td>
		</tr>
		<tr>    
		<td>Choose a type:
 		<select name = "type">
    	<option value="Top">Top</option>
    	<option value="Bottom">Bottom</option>
    	<option value="Accessory">Accessory</option>
 		 </select>
 		</td>
		</tr>
		<tr>
		<td>Start Date</td><td><input type="date" name="open_date" id = "openDate" required value=<%= new java.sql.Date(System.currentTimeMillis()) %> min= <%=new java.sql.Date(System.currentTimeMillis()).toString() %>></td>
		</tr>
		<tr>
		<td>Close Date</td><td><input type="date" name="close_date" min=<%= new java.sql.Date(System.currentTimeMillis()) %> required></td>
		</tr>
		<tr>
		<td>Close Time</td><td><input type="time" name="close_time" step="1" required></td>
		</tr>
		<tr>
		<td title= "Only visible to buyers.">Minimum Price</td><td><input type="number" min="0.00" step=any name="min_price" ></td>
		</tr>
		</table>
		<label for="createAuction"> Description: </label> 
		<br/>
		<textarea rows="8" cols="50" name="description" form="createAuction" style="resize:none"> </textarea>
		<input type="submit" value="Create Auction">
		</form>
	<br>
	
</body>
</html>