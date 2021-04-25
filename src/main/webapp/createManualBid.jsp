<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.*, java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<a href="logout.jsp">Logout</a>|  
<a href="profile.jsp">Profile</a> 
<a href="createAuctionPage.jsp">Create Auction</a> 
<a href="bids.jsp">Your Bids</a>
<a href="createAuctionPage.jsp">Create Auction</a> 
<a href="bids.jsp">Your Bids</a> 
<a href="createManualBidPage.jsp">Create Bid</a> 

	<%
	try {
		
		session=request.getSession(false); 
		String uname = (String) session.getAttribute("user");
		if(uname!=null && request.getParameter("bidPrice"))
		{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
	
			//grab form data
			String newID = request.getParameter("bidID");
			String bid_val = request.getParameter("bidPrice");
			
			
			/*
			
			Statement stmt2 = con.createStatement();
				int bid_id = Integer.parseInt(request.getParameter("bid_id"));
				float requested_bid_price = Float.parseFloat(request.getParameter("new_bid"));
			
			
			//grabs current maxValue
				String getMax = "SELECT max(bid_val) as max from manual_bid where bid_id=?" + request.getParameter("bidID");
				ResultSet currBid = stmt2.executeQuery(getMax);
				float currentValue = 0;
				if (currBid.next()) 
				{
					currentValue = currBid.getFloat("max");  
				}
				
				
				
				//grabs current upperLimit
				
				String getUpperLimit = "SELECT max(upper_limit) as max from manual_bid where bid_id=?" + request.getParameter("bidID");
				currBid = stmt2.executeQuery(getUpperLimit);
				float upperLimit = 0;
				if (currBid.next()) 
				{
					upperLimit = currBid.getFloat("max");  
				}
				
				//grab the username with the higher bid ----
				String getUpperLimit = "SELECT username, max(upper_limit) as max from manual_bid where bid_id=?" + request.getParameter("bidID");
				currBid = stmt2.executeQuery(getHighestBidUsername);
				String highestBidder="";
				if (currBid.next()) 
				{
					highestBidder = currBid.getString("username");  
				}
				
				
				
			
			*/
			
			
	
			//
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
				/*
				//asks user to enter a value greater than the current value
				if(currentValue>requested_bid_price)
				{
					float validPrice = currentValue+(float)0.5;
					out.print(Please enter more than $"  + validPrice);
					condition=-1;
					break;
				}
				
				
					*/
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
								/*
								if(currentValue<requested_bid_price && requested_bid_price>upperLimit)
								{
									out.print("You are now the highest bid!"); //alert
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

								}
								else if(currentValue<requested_bid_price && requested_bid_price<upperLimit)
								{
									out.print("Sorry, you have been outbid!");
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
								}
								else if(requested_bid_price==upperLimit)
								{
									out.print("Sorry, you have been outbid! Please enter more than $"+upperLimit);
									
									String insertAuction = "INSERT INTO manual_bid(username, bid_id, bid_val, upper_limit)" + "VALUES (?, ?, ?, ?)";
									float newPrice = upperLimit-(float)0.01;
									
									PreparedStatement ps3 = con.prepareStatement(insertAuction);
									ps3.setString(1, uname);
									ps3.setInt(2, bid_id);
									ps3.setFloat(3, newPrice);
									ps3.setFloat(4, newPrice);
									ps3.executeUpdate();

								}				
								condition = 2;
							}
							else //old bid from user (update)
							{
								/*
								if(currentValue<requested_bid_price && requested_bid_price>upperLimit)
								{
									if(uname.equals(highestBidder))
									{
										out.print("You are still the highest bid!");
										String update = "UPDATE manual_bid SET upper_limit = ?  where bid_id = ? and username = ?";
										PreparedStatement ps = con.prepareStatement(update);
										ps.setFloat(1, requested_bid_price);
										ps.setInt(2, bid_id);
										ps.setString(3, highestBidder);
										ps.executeUpdate();
									}
									else
									{
										out.print("You are now the highest bid!"); //alert
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

										ps.setInt(3, newID);
										ps.setString(4, uname);
										ps.executeUpdate();
										
									}
								}
								else if(currentValue<requested_bid_price && requested_bid_price<upperLimit)
								{
									if(uname.equals(highestBidder))
									{
										String output = "Please enter more than $"  + upperLimit;
										out.print(output);
		
									}
									else
									{
										out.print("Sorry, you have been outbid!");
										float newPrice = requested_bid_price+(float)0.5;
										
										
										//sets automatic bid for the automatic bidder
										String update =  "UPDATE manual_bid SET bid_val = ? where bid_id = ? and username = ?";
										PreparedStatement ps = con.prepareStatement(update);
										ps.setFloat(1, newPrice);
										ps.setInt(2, bid_id);
										ps.setString(3, highestBidder);
										ps.executeUpdate();
										
										//sets the price for the current user
										String update =  "UPDATE manual_bid SET bid_val = ? where bid_id = ? and username = ?";
										PreparedStatement ps = con.prepareStatement(update);
										ps.setFloat(1, requested_bid_price);
										ps.setInt(2, bid_id);
										ps.setString(3, uname);
										ps.executeUpdate();
									}
								}
								else if(requested_bid_price==upperLimit)
								{
									if(uname.equals(highestBidder))
									{
										String output = "Please enter more than $"  + upperLimit;
										out.print(output);
		
									}
									else
									{
										out.print("Sorry, you have been outbid! Please enter more than $"+upperLimit);
										float newPrice = upperLimit-(float)0.01;
										String update =  "UPDATE manual_bid SET bid_val = ? where bid_id = ? and username = ?";
										PreparedStatement ps = con.prepareStatement(update);
										ps.setFloat(1, newPrice);
										ps.setInt(2, bid_id);
										ps.setString(3, uname);
										ps.executeUpdate();
									}
								}
								
									*/

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