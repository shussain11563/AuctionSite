<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*, javax.servlet.*"%>    
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
<a href="createManualBidPage.jsp">Create Bid</a> 

 
 <%
    if (session.getAttribute("user") == null) {
        out.print("Please log in to create a bid.");
    } else {
%>


	<h1>Create a Manual Bid</h1>  
<br>
		<form method="post" action="createManualBid.jsp" id="createManualBid">
		<table>
		<tr>    
		<td>Bid Number</td><td><input type="number" name="bidID"></td>
		</tr>
		<tr>
		<td>Bid Price</td><td><input type="number" name="bidPrice" min="0.00" step=any></td>
		</tr>
		</table>
		<input type="submit" value="Submit Bid">
		</form>
	<br>
	<%} 
	%>


</body>
</html>