<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Login</title>
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

        //Get parameters from the HTML form at the HelloWorld.jsp
        String newUser = request.getParameter("username");
        String newPass = request.getParameter("password");
        String accountType = request.getParameter("account");

        String login = "";

        if (accountType.equals("enduser_account")) {
            login = "select username, password, email from enduser_account where username=? and password=?";
        } else if (accountType.equals("rep_account")) {
            login = "select username, password from rep_account where username=? and password=?";
        } else if (accountType.equals("admin_account")) {
            login = "select username, password from admin_account where username=? and password =?";
        }

        //Make an insert statement for the Sells table:
        //Create a Prepared SQL statement allowing you to introduce the parameters of the query
        PreparedStatement ps = con.prepareStatement(login);

        //Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
        ps.setString(1, newUser);
        ps.setString(2, newPass);

        ResultSet rs = ps.executeQuery();
        int count = 0;
        while (rs.next()) {
            count++;
        }
        if (count == 0) {
            out.println("No Account found");
            out.println("");
        } else {
            out.println("Welcome " + newUser);
            session = request.getSession(false);
            session.setAttribute("user", newUser);
            session.setAttribute("pass", newPass);
            session.setAttribute("accountType", accountType);
        }

        //Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
        con.close();
    } catch (Exception ex) {
        out.print(ex);
        out.print("Login Failed :(");
    }
%>
</body>
</html>