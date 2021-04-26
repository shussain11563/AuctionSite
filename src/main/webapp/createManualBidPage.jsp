<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*, javax.servlet.*"%>    
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create Auction</title>
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