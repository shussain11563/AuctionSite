<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Create Account</title>
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

        //Get the database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        //Get parameters from the HTML form at the index.jsp
        String newUser = request.getParameter("username");
        String newPass = request.getParameter("password");
        String newEmail = request.getParameter("email");
        String newPhone = request.getParameter("phone");


        //Make an insert statement for the Sells table:
        String insert;
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