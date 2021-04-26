<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.*, java.util.Date"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create New Bid |BuyMe</title>
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
	try {
		
		session=request.getSession(false); 
		String uname = (String) session.getAttribute("user");
		if(uname!=null && request.getParameter("bidPrice")!=null)
		{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
	
			//grab form data
			String newID = request.getParameter("bidID");
			String bid_val = request.getParameter("bidPrice");
			
			
			
			
			Statement stmt2 = con.createStatement();
			int bid_id = Integer.parseInt(request.getParameter("bidID"));
			float requested_bid_price = Float.parseFloat(request.getParameter("bidPrice"));
	

			//grabs current maxValue
				//String getMax = "SELECT max(bid_val) as max from manual_bid where bid_id=?" +bid_id;
				String getMax = "SELECT max(bid_val) as max from manual_bid where bid_id="+bid_id;
			
				ResultSet currBid = stmt2.executeQuery(getMax);
			
				float currentValue = 0;
				if (currBid.next()) 
				{
					currentValue = currBid.getFloat("max");  
				}
				
				
				
				//grabs current upperLimit
				String getUpperLimit = "SELECT max(upper_limit) as max from manual_bid where bid_id=" + bid_id;
				currBid = stmt2.executeQuery(getUpperLimit);
				float upperLimit = 0;
				if (currBid.next()) 
				{
					upperLimit = currBid.getFloat("max");  
				}
				
				
				//grab the username with the higher bid ----
				String getHighestBidUsername = "SELECT username, max(upper_limit) as max from manual_bid where bid_id=" + bid_id;
				currBid = stmt2.executeQuery(getHighestBidUsername);
				String highestBidder="";
				if (currBid.next()) 
				{
					highestBidder = currBid.getString("username");  
				}
				
				

			String cond = "SELECT * FROM bid_selling_offers WHERE bid_id = ?";
			PreparedStatement ps2 = con.prepareStatement(cond);
			ps2.setString(1, newID);
			ResultSet rs2 = ps2.executeQuery();
			
			
			String check = "SELECT * FROM manual_bid WHERE bid_id = ? and username = ?";
			PreparedStatement ps1 = con.prepareStatement(check);
			ps1.setString(1, newID);
			ps1.setString(2, uname);
			ResultSet rs1 = ps1.executeQuery();
			int condition = 0;
			
			
			//date and time
			SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd");
			java.sql.Date tempToday = new java.sql.Date(System.currentTimeMillis());
			String todayStr = formatter1.format(tempToday);
			java.sql.Date today = java.sql.Date.valueOf(todayStr);
			
			SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
			Date tempCurrentTime = new Date(System.currentTimeMillis());
			String currentTimeStr = formatter.format(tempCurrentTime);
			java.sql.Time currentTimeTemp = java.sql.Time.valueOf(currentTimeStr);
			java.sql.Time currentTime = java.sql.Time.valueOf(currentTimeTemp.toLocalTime());
	
			
			while (rs2.next()) //checks if auction exists
			{
				if (rs2.getString("winner") != null){
					break;
				}	
				
				//asks user to enter a value greater than the current value
				if(currentValue>requested_bid_price)
				{
					float validPrice = currentValue+(float)0.5;
					out.print("Please enter more than $"  + validPrice);
					condition=-1;
					break;
				}
				String winner = rs2.getString("winner");
				String seller = rs2.getString("username");
				java.sql.Date close_date = rs2.getDate("close_date");
				Time close_time = rs2.getTime("close_time");
				if (uname.equals(seller) == false) //prevents the sellet from bidding on their own bid
				{
					//checks if auction has closed
					if (close_date.compareTo(today) == 0 && currentTime.after(close_time) == true)
					{
						condition = 4;
						break;
					}
					else
					{
						if(winner == null) //checks if theres no winner defined
						{
							//new bid from user (insert)
							if (rs1.next() == false)
							{
								
								if(currentValue<requested_bid_price && requested_bid_price>upperLimit)
								{
									out.print("You are now the highest bid!&nbsp"); //alert
									float newPrice = upperLimit + (float)0.50;
									String insertAuction = "INSERT INTO manual_bid(username, bid_id, bid_val, upper_limit)" + "VALUES (?, ?, ?, ?)";
									PreparedStatement ps3 = con.prepareStatement(insertAuction);
									
									ps3.setString(1, uname);
									ps3.setInt(2, bid_id);
									ps3.setFloat(3, newPrice);
									if(requested_bid_price>newPrice)
									{
										ps3.setFloat(4, requested_bid_price);
									}
									else
									{
										ps3.setFloat(4, newPrice);
									}
									
									ps3.executeUpdate();
									
									//insert to alerts
									String grabUsernameForAlert = "SELECT username, bid_id FROM manual_bid WHERE bid_id=1 AND bid_val<> (SELECT max(bid_val) AS max FROM manual_bid WHERE bid_id=1)";
									String insertAlerts = "INSERT IGNORE INTO alerts (username, bid_id) VALUES (?, ?)";
									ResultSet result = stmt2.executeQuery(grabUsernameForAlert);
									while(result.next())
									{
										String username = result.getString("username");
										int bid_id_bidder = Integer.parseInt(result.getString("bid_id"));
										PreparedStatement ps5 = con.prepareStatement(insertAlerts);
										ps5.setString(1, username);
										ps5.setInt(2, bid_id_bidder);
										ps5.executeUpdate();
										
									}
									
									
									
						

								}
								else if(currentValue<requested_bid_price && requested_bid_price<upperLimit)
								{
									out.print("Sorry, you have been outbid!&nbsp"); //alert
									float newPrice = requested_bid_price+(float)0.5;
									
									
									//sets automatic bid for the automatic bidder
									String update =  "UPDATE manual_bid SET bid_val = ? where bid_id = ? and username = ?";
									PreparedStatement ps = con.prepareStatement(update);
									ps.setFloat(1, newPrice);
									ps.setInt(2, bid_id);
									ps.setString(3, highestBidder);
									ps.executeUpdate();
									
									
									
									//sets the price for the current user
									String insertAuction = "INSERT INTO manual_bid(username, bid_id, bid_val, upper_limit)" + "VALUES (?, ?, ?, ?)";
									PreparedStatement ps3 = con.prepareStatement(insertAuction);
									ps3.setString(1, uname);
									ps3.setInt(2, bid_id);
									ps3.setFloat(3, requested_bid_price);
									ps3.setFloat(4, requested_bid_price);
									ps3.executeUpdate();
									
									//insert alerts
									String grabUsernameForAlert = "SELECT username, bid_id FROM manual_bid WHERE bid_id=1 AND bid_val<> (SELECT max(bid_val) AS max FROM manual_bid WHERE bid_id=1)";
									String insertAlerts = "INSERT IGNORE INTO alerts (username, bid_id) VALUES (?, ?)";
									ResultSet result = stmt2.executeQuery(grabUsernameForAlert);
									while(result.next())
									{
										String username = result.getString("username");
										int bid_id_bidder = Integer.parseInt(result.getString("bid_id"));
										PreparedStatement ps5 = con.prepareStatement(insertAlerts);
										ps5.setString(1, username);
										ps5.setInt(2, bid_id_bidder);
										ps5.executeUpdate();
										
									}
									
									
									 
								}
								else if(requested_bid_price==upperLimit)
								{
									out.print("Sorry, you have been outbid! Please enter more than $"+upperLimit + "!&nbsp");
									
									String insertAuction = "INSERT INTO manual_bid(username, bid_id, bid_val, upper_limit)" + "VALUES (?, ?, ?, ?)";
									float newPrice = upperLimit-(float)0.01;
									
									PreparedStatement ps3 = con.prepareStatement(insertAuction);
									ps3.setString(1, uname);
									ps3.setInt(2, bid_id);
									ps3.setFloat(3, newPrice);
									ps3.setFloat(4, newPrice);
									ps3.executeUpdate();
									
									
									//insert alerts
									String grabUsernameForAlert = "SELECT username, bid_id FROM manual_bid WHERE bid_id=1 AND bid_val<> (SELECT max(bid_val) AS max FROM manual_bid WHERE bid_id=1)";
									String insertAlerts = "INSERT IGNORE INTO alerts (username, bid_id) VALUES (?, ?)";
									ResultSet result = stmt2.executeQuery(grabUsernameForAlert);
									while(result.next())
									{
										String username = result.getString("username");
										int bid_id_bidder = Integer.parseInt(result.getString("bid_id"));
										PreparedStatement ps5 = con.prepareStatement(insertAlerts);
										ps5.setString(1, username);
										ps5.setInt(2, bid_id_bidder);
										ps5.executeUpdate();
										
									}

								}				
								condition = 2;
							}
							else //old bid from user (update)
							{
								
								if(currentValue<requested_bid_price && requested_bid_price>upperLimit)
								{
									if(uname.equals(highestBidder))
									{
										out.print("You are still the highest bid!&nbsp");
										String update = "UPDATE manual_bid SET upper_limit = ?  where bid_id = ? and username = ?";
										PreparedStatement ps = con.prepareStatement(update);
										ps.setFloat(1, requested_bid_price);
										ps.setInt(2, bid_id);
										ps.setString(3, highestBidder);
										ps.executeUpdate();
									}
									else
									{
										out.print("You are now the highest bid!&nbsp"); //alert
										String update =  "UPDATE manual_bid SET bid_val = ? upper_limit=? where bid_id = ? and username = ?";
										float newPrice = upperLimit + (float)0.50;
										PreparedStatement ps = con.prepareStatement(update);
										ps.setFloat(1, newPrice);
										if(newPrice<requested_bid_price)
										{
											ps.setFloat(2, requested_bid_price);
										}
										else
										{
											ps.setFloat(2, newPrice);
										}

										ps.setInt(3, bid_id);
										ps.setString(4, uname);
										ps.executeUpdate();
										
										
										//insert alerts
										String grabUsernameForAlert = "SELECT username, bid_id FROM manual_bid WHERE bid_id=1 AND bid_val<> (SELECT max(bid_val) AS max FROM manual_bid WHERE bid_id=1)";
										String insertAlerts = "INSERT IGNORE INTO alerts (username, bid_id) VALUES (?, ?)";
										ResultSet result = stmt2.executeQuery(grabUsernameForAlert);
										while(result.next())
										{
											String username = result.getString("username");
											int bid_id_bidder = Integer.parseInt(result.getString("bid_id"));
											PreparedStatement ps5 = con.prepareStatement(insertAlerts);
											ps5.setString(1, username);
											ps5.setInt(2, bid_id_bidder);
											ps5.executeUpdate();
											
										}
										
									}
								}
								else if(currentValue<requested_bid_price && requested_bid_price<upperLimit)
								{
									if(uname.equals(highestBidder))
									{
										String output = "Please enter more than $"  + upperLimit + "!&nbsp";
										out.print(output);
		
									}
									else
									{
										out.print("Sorry, you have been outbid!&nbsp");
										float newPrice = requested_bid_price+(float)0.5;
										
										
										//sets automatic bid for the automatic bidder
										String update =  "UPDATE manual_bid SET bid_val = ? where bid_id = ? and username = ?";
										PreparedStatement ps = con.prepareStatement(update);
										ps.setFloat(1, newPrice);
										ps.setInt(2, bid_id);
										ps.setString(3, highestBidder);
										ps.executeUpdate();
										
										//sets the price for the current user
										update =  "UPDATE manual_bid SET bid_val = ? where bid_id = ? and username = ?";
										ps = con.prepareStatement(update);
										ps.setFloat(1, requested_bid_price);
										ps.setInt(2, bid_id);
										ps.setString(3, uname);
										ps.executeUpdate();
										
										
										//insert alerts
										String grabUsernameForAlert = "SELECT username, bid_id FROM manual_bid WHERE bid_id=1 AND bid_val<> (SELECT max(bid_val) AS max FROM manual_bid WHERE bid_id=1)";
										String insertAlerts = "INSERT IGNORE INTO alerts (username, bid_id) VALUES (?, ?)";
										ResultSet result = stmt2.executeQuery(grabUsernameForAlert);
										while(result.next())
										{
											String username = result.getString("username");
											int bid_id_bidder = Integer.parseInt(result.getString("bid_id"));
											PreparedStatement ps5 = con.prepareStatement(insertAlerts);
											ps5.setString(1, username);
											ps5.setInt(2, bid_id_bidder);
											ps5.executeUpdate();
										
										}
									}
								}
								else if(requested_bid_price==upperLimit)
								{
									if(uname.equals(highestBidder))
									{
										String output = "Please enter more than $"  + upperLimit + "&nbsp";
										out.print(output);
		
									}
									else
									{
										out.print("Sorry, you have been outbid! Please enter more than $"+upperLimit + "!&nbsp");
										float newPrice = upperLimit-(float)0.01;
										String update =  "UPDATE manual_bid SET bid_val = ? where bid_id = ? and username = ?";
										PreparedStatement ps = con.prepareStatement(update);
										ps.setFloat(1, newPrice);
										ps.setInt(2, bid_id);
										ps.setString(3, uname);
										ps.executeUpdate();
										
										
										//insert alerts
										String grabUsernameForAlert = "SELECT username, bid_id FROM manual_bid WHERE bid_id=1 AND bid_val<> (SELECT max(bid_val) AS max FROM manual_bid WHERE bid_id=1)";
										String insertAlerts = "INSERT IGNORE INTO alerts (username, bid_id) VALUES (?, ?)";
										ResultSet result = stmt2.executeQuery(grabUsernameForAlert);
										while(result.next())
										{
											String username = result.getString("username");
											int bid_id_bidder = Integer.parseInt(result.getString("bid_id"));
											PreparedStatement ps5 = con.prepareStatement(insertAlerts);
											ps5.setString(1, username);
											ps5.setInt(2, bid_id_bidder);
											ps5.executeUpdate();
											
										}
									}
								}
								
									

							}
						}	
						else //winner is defined, thus auction is closed
						{
							out.print("Auction is closed.");
							break;
						}
					}
				}
				else
				{
					condition = 3;
					break;
				}
			} 
		
			con.close();
			if (condition == 1){
				out.print("Bid updated!");
			}
			else if (condition == 2){
				out.print("Created a new bid successfully!");
			}
			else if (condition == 3){
				out.print("Can't bid on own auction.");
			}
			else if (condition == 0){
				out.print("Bid closed.");
			}
			else if (condition == 4){
				out.print("Auction is over.");
			}
		
		}
		else
		{
			out.print("You are not logged in!");
		}

	} catch (Exception ex) {
		out.print(ex);
		out.print("Sorry, this auction doesn't exist.");
	}
%>
</body>
</html>