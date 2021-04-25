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

		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();


		String newID = request.getParameter("bidID");
		String bid_val = request.getParameter("bidPrice");
		String uname = (String) session.getAttribute("user");
		
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
		
		
		SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd");
		java.sql.Date tempToday = new java.sql.Date(System.currentTimeMillis());
		String todayStr = formatter1.format(tempToday);
		java.sql.Date today = java.sql.Date.valueOf(todayStr);
		
		SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
		Date tempCurrentTime = new Date(System.currentTimeMillis());
		String currentTimeStr = formatter.format(tempCurrentTime);
		java.sql.Time currentTimeTemp = java.sql.Time.valueOf(currentTimeStr);
		java.sql.Time currentTime = java.sql.Time.valueOf(currentTimeTemp.toLocalTime());

		
		while (rs2.next()){
			String winner = rs2.getString("winner");
			String seller = rs2.getString("username");
			java.sql.Date close_date = rs2.getDate("close_date");
			Time close_time = rs2.getTime("close_time");
			if (uname.equals(seller) == false){
				if (close_date.compareTo(today) == 0 && currentTime.after(close_time) == true){
					condition = 4;
					break;
				}
				else{
					if(winner == null){
						if (rs1.next() == false){
							String insertAuction = "INSERT INTO manual_bid(username, bid_id, bid_val)" + "VALUES (?, ?, ?)";
							PreparedStatement ps = con.prepareStatement(insertAuction);
							ps.setString(1, uname);
							ps.setString(2, newID);
							ps.setString(3, bid_val);
							ps.executeUpdate();						
							condition = 2;
						}
						else{
							String updateBid = "UPDATE manual_bid SET bid_val = ? where bid_id = ? and username = ?";
							PreparedStatement ps3 = con.prepareStatement(updateBid);
							ps3.setString(1, bid_val);
							ps3.setString(2, newID);
							ps3.setString(3, uname);
							ps3.executeUpdate();
							condition = 1;
						}
					}	
					else{
						out.print("Bid closed.");
						break;
					}
				}
			}
			else{
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
			out.print("Bid is over.");
		}

	} catch (Exception ex) {
		out.print(ex);
		out.print("Sorry, this auction doesn't exist.");
	}
%>
</body>
</html>