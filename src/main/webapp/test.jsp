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
	
	<% 
	session=request.getSession(false); 
	String uname = (String) session.getAttribute("user");
	if(request.getParameter("new_bid")==null)
		{
		
	
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
			<td><%out.print("Product ID");%></td>
			<td><%out.print("Brand");%></td>
			<td><%out.print("Title");%></td>
			<td><%out.print("Username");%></td>
			<td><%out.print("Highest Bid");%></td>
		</tr>
			<%
			//parse out the results
			while (result.next()) 
			{ %>
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
	
	
	
	<% 
	}
	else if(request.getParameter("new_bid")!=null && uname!=null)
	{
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		

		//Create a SQL statement
		Statement stmt = con.createStatement();
		int product_id = Integer.parseInt(request.getParameter("product_id"));
		float requested_bid_price = Float.parseFloat(request.getParameter("new_bid"));
		//out.print(bid_id);
		//out.print(new_bid_price);
		
		Statement stmt2 = con.createStatement();
		//String getMax = "SELECT highest_bid from bid_selling_offers where productID="+request.getParameter("bid_id");
		
		//grab current Value
		String getMax = "SELECT highest_bid from bid_selling_offers where productID="+request.getParameter("product_id");
		ResultSet currBid = stmt2.executeQuery(getMax);
		float currentValue = 0;
		if (currBid.next()) 
		{
			currentValue = currBid.getFloat("highest_bid");  
		}
		
		
		//grab upper limit
		String getUpperLimit = "SELECT upper_limit from bid_selling_offers where productID="+request.getParameter("product_id");
		currBid = stmt2.executeQuery(getUpperLimit);
		float upperLimit = 0;
		if (currBid.next()) 
		{
			upperLimit = currBid.getFloat("upper_limit");  
		}
		
		//grab the username with the higher bid
		String getHighestBidUsername = "SELECT username from bid_selling_offers where productID="+request.getParameter("product_id");
		currBid = stmt2.executeQuery(getHighestBidUsername);
		String highestBidder;
		if (currBid.next()) 
		{
			highestBidder = currBid.getString("username");  
		}
		
		
	
		String update;
		boolean flag = false;
		
		
	
		if(currentValue>requested_bid_price)
		{
			float validPrice = currentValue+(float)0.5;
			String output = "Please enter more than $"  + validPrice;
			out.print(output);
			//flag=true;

			
			//out.println("Please enter more than $")
		}
		else if(requested_bid_price==upperLimit)
		{
			out.print("Sorry, you have been outbid! Please enter more than $"+upperLimit);
			//float newPrice = upperLimit-(float)0.01;
			update = "UPDATE bid_selling_offers b SET b.highest_bid=? WHERE b.productID=?";
			flag=true;
			PreparedStatement ps = con.prepareStatement(update);
			ps.setFloat(1, upperLimit);
			ps.setInt(2, product_id);
			ps.executeUpdate();
			
			//set upperLimit to 0
		}
		else if(currentValue<requested_bid_price && requested_bid_price<upperLimit)
		{
			
			if(uname.equals(highestBidder))
			{
				String output = "Please enter more than $"  + upperLimit;
				out.print(output);
				//flag=true;
			}
			else
			{
				out.print("Sorry, you have been outbid!");
				float newPrice = requested_bid_price+(float)0.5;
				update = "UPDATE bid_selling_offers b SET b.highest_bid=? WHERE b.productID=?";
				flag=true;
				PreparedStatement ps = con.prepareStatement(update);
				ps.setFloat(1, newPrice);
				ps.setInt(2, product_id);
				ps.executeUpdate();
			}
			
			
		}
		else if(currentValue<requested_bid_price && requested_bid_price>upperLimit)
		{
			
			//case 1 ---- highest bidder puts a bid price
			
			if(uname.equals(highestBidder))
			{
				out.print("You are still the highest bid!");
				update = "UPDATE bid_selling_offers b SET b.upper_limit=? WHERE b.productID=?";
				PreparedStatement ps = con.prepareStatement(update);
				ps.setFloat(1, requested_bid_price);
				ps.setInt(2, product_id);
				ps.executeUpdate();
				
			}
			else
			{
				out.print("You are now the highest bid!");
				update = "UPDATE bid_selling_offers b SET b.highest_bid=? WHERE b.productID=?";
				//change user
				//flag=true;
				PreparedStatement ps = con.prepareStatement(update);
				ps.setFloat(1, requested_bid_price);
				ps.setInt(2, product_id);
				ps.executeUpdate();
				update = "UPDATE bid_selling_offers b SET b.username=? WHERE b.productID=?";
				ps = con.prepareStatement(update);
				ps.setFloat(1, requested_bid_price);
				ps.setString(2, uname);
				ps.executeUpdate();
			}
			

			
			
			
		}
		

		//out.println(currentValue);
		//out.println(upperLimit);
		
		
		
		//Make an insert statement for the Sells table:
		//update = "UPDATE bid_selling_offers b SET b.highest_bid=? WHERE b.productID=?";
		/*
		if(flag==true && update!=null)
		{
			PreparedStatement ps = con.prepareStatement(update);
			ps.setFloat(1, requested_bid_price);
			ps.setInt(2, bid_id);
			ps.executeUpdate();
		}
		*/

	

		//Get the selected radio button from the index.jsp
		//String entity = request.getParameter("command");
		//String entity = "clothing";
		
		//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
		//String str = "SELECT * FROM " + entity;
		//String str = "select c.productID, c.title, c.brand, b.highest_bid, e.username from clothing c, bid_selling_offers b, enduser_account e where c.productID=b.productID and e.username  = b.username";
		
		//Run the query against the database.
		//ResultSet result = stmt.executeQuery(str);
		out.println("Finished Updating");
		con.close();
		db.closeConnection(con);
	}
	else
	{
		out.println("Please log in to bid!");
	}
	%>
	
	

	</body>
</html>