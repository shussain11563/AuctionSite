<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<!DOCTYPE html>



<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Your Bids</title>
</head>
<body>

<a href="logout.jsp">Logout</a>|  
<a href="profile.jsp">Profile</a> 
<a href="createAuctionPage.jsp">Create Auction</a> 
<a href="bids.jsp">Your Bids</a> 

 


	<h1>Your Bids</h1>  
<%		

ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();
Statement stmt = con.createStatement();

String uname = (String) session.getAttribute("user");
String temp = "SELECT * FROM manual_bid WHERE username =?";

PreparedStatement ps = con.prepareStatement(temp);
ps.setString(1, uname);
ResultSet rs = ps.executeQuery();

out.println("bidID &nbsp Bid Price <br>");

while (rs.next()) 
{  
    String n = rs.getString("username");  
    int nm = rs.getInt("bid_id");  
    float s = rs.getFloat("bid_val");   
    out.println("</td><td>" + nm + "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td>" + s + "</td></tr>");  
    out.println("<br>");
}  

out.println("</table>");  
out.println("</html></body>");  
con.close();  

%>

	<br>
		<form method="post" action="bidsPage.jsp" id="bidsPage">
		<table>
		<tr>    
		<td>Bid Number</td><td><input type="number"  min = "0" name="bidID"></td>
		</tr>
		</table>
		<br/>
		<input type="submit" value="Check Status">
		</form>
	<br>
	

</body>
</html>