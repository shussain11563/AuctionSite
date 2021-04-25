<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Log In</title>
</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//String entity = request.getParameter("command");
			//String entity = "clothing";
			
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			//String str = "SELECT * FROM " + entity;
			String str = "select c.productID, c.title, c.brand, b.highest_bid, e.username from clothing c, bid_selling_offers b, enduser_account e where c.productID=b.productID and e.username  = b.username";
			
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>    
			<td>				<%
					out.print("Product ID");
				%></td>
			<td>
				<%
					out.print("Brand");
				%>
			</td>
				<td><%out.print("Title");%></td>
				<td><%out.print("Username");%></td>
				<td><%out.print("Highest Bid");%></td>
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td><%= result.getString("productID") %></td>
					<td>
						<%= result.getString("brand") %>
					</td>
					<td>
						<%= result.getString("title") %>
					</td>
					<td><%= result.getString("username") %></td>
					<td><%= result.getString("highest_bid") %></td>
				</tr>
				

			<% }
			//close the connection.
			db.closeConnection(con);
			%>
		</table>

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
		
		<h1>Create an Account</h1>  
<br>
		<form method="post" action="test.jsp">
		<table>
		<tr>    
		<td>Product ID</td><td><input type="text" name="product_id"></td>
		</tr>
		<tr><td>Values</td><td><input type="text" name="new_bid"></td></tr>
		</table>
		<input type="submit" value="New Bid">
		</form>
	<br>
	

	</body>
</html>