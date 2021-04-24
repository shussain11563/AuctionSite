<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Create Account</title>
</head>
<body>
<a href="loginBox.jsp">Login Page</a>
  |  <a href="createAccountPage.jsp">Create an Account</a>
  |  <a href="logout.jsp">Logout</a>
  |  <a href="profile.jsp">Profile</a>
  |  <a href="qaPage.jsp">Questions and Answers</a>
<br><br>
<%
    try {

        //Get the database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        //Create a SQL statement
        Statement stmt = con.createStatement();

        //Get parameters from the HTML form at the index.jsp
        String newUser = request.getParameter("username");
        String newPass = request.getParameter("password");
        String newEmail = request.getParameter("email");
        String newPhone = request.getParameter("phone");


        //Make an insert statement for the Sells table:
        String insert = "";
        if (request.getParameter("id").equals("0")) {
            insert = "INSERT INTO enduser_account(username, password, email, phone)"
                    + "VALUES (?, ?, ?, ?)";
        } else {
            insert = "INSERT INTO rep_account(username, password)"
                    + "VALUES (?, ?)";
        }

        //Create a Prepared SQL statement allowing you to introduce the parameters of the query
        PreparedStatement ps = con.prepareStatement(insert);

        //Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
        ps.setString(1, newUser);
        ps.setString(2, newPass);
        if (request.getParameter("id").equals("0")) {
            ps.setString(3, newEmail);
            ps.setString(4, newPhone);
        }

        //Run the query against the DB
        ps.executeUpdate();
        //Run the query against the DB

        //Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
        con.close();
        out.print("Created a new account successfully!");

    } catch (Exception ex) {
        out.print(ex);
        out.print("Sorry, the account cannot be created. Try again with a different username!");
    }
%>
</body>
</html>