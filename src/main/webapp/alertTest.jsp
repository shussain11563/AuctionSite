<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>BuyMe</title>


<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
.alert {
  padding: 20px;
  background-color: #f44336;
  color: white;
  opacity: 1;
  transition: opacity 0.6s;
  margin-bottom: 15px;
}

.alert.success {background-color: #4CAF50;}


.closebtn {
  margin-left: 15px;
  color: white;
  font-weight: bold;
  float: right;
  font-size: 22px;
  line-height: 20px;
  cursor: pointer;
  transition: 0.3s;
}

.closebtn:hover {
  color: black;
}
</style>
</head>
<body>
<a href="loginBox.jsp">Login Page</a>|  
<a href="createAccountPage.jsp">Create an Account</a>|  
<a href="logout.jsp">Logout</a>|  
<a href="profile.jsp">Profile</a> 




<%
	session=request.getSession(false); 
	String uname = (String) session.getAttribute("user");
	if(uname==null)
	{
		out.println("You are not logged in!");	
	}
	else
	{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		//Statement stmt = con.preap();
		
		//Get the selected radio button from the index.jsp
		//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
		//String str = "select productID from alerts where username=" + uname;
		String str = "select bid_id from alerts where username=?";
		
		PreparedStatement ps = con.prepareStatement(str);
		
		ps.setString(1, uname);

		//ps.executeUpdate();
		//Run the query against the database.
		ResultSet result = ps.executeQuery();
		
		while (result.next()) 
		{
			String getTitle = "select title from bid_selling_offers where bid_id=" + result.getInt("bid_id");
			ResultSet grabTitle = stmt.executeQuery(getTitle);
			String title = "";
			if(grabTitle.next())
			{
				title = grabTitle.getString("title");
			}
			
			%>
			
	

				<div class="alert">
  				<span class="closebtn">&times;</span>  
  				<strong>You have been outbid!</strong> You have lost the bid for <% out.print(title); %>
			</div>
		
			
				
			<%
			
			String deleteAlert = "DELETE FROM alerts WHERE username=? and bid_id=?";
  			PreparedStatement ps2 = con.prepareStatement(deleteAlert);
  			ps2.setString(1,uname);
  			ps2.setInt(2,result.getInt("bid_id"));
  			ps2.executeUpdate();
  			
  			
  			
		}
			//close the connection.

		db.closeConnection(con);
    	//out.print("Hello, "+user+" Welcome to Profile"); 
	}

%>
<!--
<h2>Alert Messages</h2>
<p>Click on the "x" symbol to close the alert message.</p>
<div class="alert">
  <span class="closebtn">&times;</span>  
  <strong>Danger!</strong> Indicates a dangerous or potentially negative action.
</div>

<div class="alert success">
  <span class="closebtn">&times;</span>  
  <strong>Success!</strong> Indicates a successful or positive action.
</div> -->


<script>
var close = document.getElementsByClassName("closebtn");
var i;

for (i = 0; i < close.length; i++) {
  close[i].onclick = function(){
    var div = this.parentElement;
    div.style.opacity = "0";
    setTimeout(function(){ div.style.display = "none"; }, 600);
  }
}
</script>



</body>
</html>