<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.Date, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
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
		Statement stmt1 = con.createStatement();


		String bidID = request.getParameter("bidID");
		String uname = (String) session.getAttribute("user");
		
		
		String temp = "SELECT * FROM bid_selling_offers b, manual_bid m WHERE m.bid_id = ? and b.bid_id = ?";
		PreparedStatement ps = con.prepareStatement(temp);
		ps.setString(1, bidID);
		ps.setString(2, bidID);
		ResultSet rs = ps.executeQuery();	
		
		
		java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
		
		
		while (rs.next()){
			java.sql.Date closeDate = rs.getDate("close_date");
			
			Time closeTime = rs.getTime("close_time");
			float reserve = rs.getFloat("min_price");
			float bidVal = rs.getFloat("bid_val");
			String currentUser = rs.getString("m.username");
			
			SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
			Date tempCurrentTime = new Date(System.currentTimeMillis());
			String currentTimeStr = formatter.format(tempCurrentTime);
			java.sql.Time currentTime = java.sql.Time.valueOf(currentTimeStr);
			
			String temp1 = "SELECT * FROM manual_bid join (SELECT MAX(bid_val) FROM manual_bid WHERE bid_id = ?)t1 ON bid_id = ? AND username != ?";
			PreparedStatement ps1 = con.prepareStatement(temp1);
			ps1.setString(1, bidID);
			ps1.setString(2, bidID);
			ps1.setString(3, uname);
			ResultSet rs1 = ps1.executeQuery();
			
			//Current user check
			String temp3 = "SELECT * FROM bid_selling_offers b, manual_bid m where m.bid_id = b.bid_id and b.bid_id = ? and m.username = ?";
			PreparedStatement ps4 = con.prepareStatement(temp3);
			ps4.setString(1, bidID);
			ps4.setString(2, uname);
			ResultSet rs4 = ps4.executeQuery();



			
			


			if ((today.compareTo(closeDate) > 0 || today.compareTo(closeDate) == 0) && currentTime.toLocalTime().isAfter(closeTime.toLocalTime())){
				String winner = "SELECT * from manual_bid where bid_val=(select max(bid_val) from manual_bid where bid_id = ?)";
				PreparedStatement ps2 = con.prepareStatement(winner);
				ps2.setString(1, bidID);
				ResultSet rs2 = ps2.executeQuery();
				while (rs2.next()){
					String n = rs2.getString("username");
				    int nm = rs2.getInt("bid_id");
				    float s = rs2.getFloat("bid_val");
					String temp2 = "UPDATE bid_Selling_offers SET highest_bid = ?, winner = ?, status = ? where bid_id = ?";
					PreparedStatement ps3 = con.prepareStatement(temp2);
					ps3.setFloat(1, s);
					ps3.setString(2, n);
					ps3.setInt(3, 1);
					ps3.setString(4, bidID);
					

					ps3.executeUpdate();
					
				}
				while (rs4.next()){
					String win = rs4.getString("winner");
					String current = rs4.getString("m.username");
					float bidVal1 = rs4.getFloat("m.bid_val");
					if (reserve > 0){ 
						if (reserve > bidVal1 && uname.equals(win)){
							out.print("No winner!");
						}
						else if (reserve < bidVal1 && uname.equals(win)){
							out.print("You are the winner.");
						}
						else{
							out.print("A winner was chosen and it wasn't you! :(");
						}
					}
					else{
						if (uname.equals(win)){
							out.print("You are the winner.");
						}
						else{
							out.print("A winner was chosen and it wasn't you! :(");
						}
				
					}
				}
			}
			else{
				boolean outbid = false;
						
				while (rs1.next())
				{
				    String n = rs1.getString("username");
				    int nm = rs1.getInt("bid_id");
				    float s = rs1.getFloat("bid_val");
				    float max = rs1.getFloat("MAX(bid_val)");
				    
				    if (uname.equals(n) == false && s == max){
				    	outbid = true;
				    	break;
				    }
				}

				
				con.close();
				if (outbid == true){
					out.print("A higher bid has been placed!");
				}
				else{
				out.print("To be announced.");
				}
			}
			break;
		}
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("Sorry, the auction cannot be created.");
	}
%>
</body>
</html>