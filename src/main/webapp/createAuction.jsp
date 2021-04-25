<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*, java.text.*, java.util.Date"%>

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

 

<%
	try {

		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();

		
		String newTitle = request.getParameter("title");
		String openDate = request.getParameter("open_date");
		String closeDate = request.getParameter("close_date");
		String newDescrip = request.getParameter("description");
		String closeTime = request.getParameter("close_time");
		String minPrice = request.getParameter("min_price");
		String brandName = request.getParameter("brand");
		String type = request.getParameter("type");
		String size = request.getParameter("size");
		
		Date open_date = java.sql.Date.valueOf(openDate);
		java.sql.Date close_date = java.sql.Date.valueOf(closeDate);
		
		SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
		Date tempCurrentTime = new Date(System.currentTimeMillis());
		String currentTimeStr = formatter.format(tempCurrentTime);
		java.sql.Time currentTimeTemp = java.sql.Time.valueOf(currentTimeStr);
		java.sql.Time currentTime = java.sql.Time.valueOf(currentTimeTemp.toLocalTime());
		java.sql.Time close_time = java.sql.Time.valueOf(closeTime);
		
		SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd");
		java.sql.Date tempToday = new java.sql.Date(System.currentTimeMillis());
		String todayStr = formatter1.format(tempToday);
		java.sql.Date today = java.sql.Date.valueOf(todayStr);

		
		
		if ((close_date.before(open_date) == true) || (close_date.compareTo(today) == 0 && close_time.before(currentTime) == true)){
			out.print("Invalid date input.");
		}
		else{
		
		String uname = (String) session.getAttribute("user");


		String insertAuction = "INSERT INTO bid_selling_offers(title, productID, username, open_date, close_date, close_time, min_price, highest_bid, winner, description)"
				+ "VALUES (?, LAST_INSERT_ID(), ?, ?, ?, ?, ?, ?, ?, ?)";
		String insertProduct = "INSERT INTO clothing(title, brand, type, size)"
				+ "VALUES (?, ?, ?, ?)";
		
		PreparedStatement ps = con.prepareStatement(insertAuction);
		PreparedStatement ps1 = con.prepareStatement(insertProduct);


		
		ps1.setString(1, newTitle);
		ps1.setString(2, brandName);
		ps1.setString(3, type);
		ps1.setString(4, size);
		
		
		
		ps.setString(1, newTitle);
		ps.setString(2, uname);
		ps.setString(3, openDate);
		ps.setString(4, closeDate);
		ps.setString(5, closeTime);
		if (minPrice == null){
			ps.setFloat(6, 0);

		}else{ 
			ps.setString(6, minPrice);
		}
		ps.setInt(7, 0);
		ps.setString(8, null);
		ps.setString(9, newDescrip);
		
		
		ps1.executeUpdate();
		ps.executeUpdate();
		
		
		con.close();
		out.print("Created a new auction successfully!");
		}
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("Sorry, the auction cannot be created.");
	}
%>
</body>
</html>