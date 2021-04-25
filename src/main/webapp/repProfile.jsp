<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Customer Representative Profile</title>
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
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    try {
        Statement stmt = con.createStatement();
        int formID = Integer.parseInt(request.getParameter("id"));
        String str;
        switch (formID) {
            case 0:
                if (request.getParameter("password").isBlank() && request.getParameter("email").isBlank() && request.getParameter("phone").isBlank()) {
                    out.print("No changes made to account " + request.getParameter("username") + ".");
                    break;
                }
                if (!request.getParameter("password").isBlank()) {
                    str = "UPDATE enduser_account SET password = '" + request.getParameter("password") +
                            "' WHERE username = '" + request.getParameter("username") + "';";
                    stmt.executeUpdate(str);
                }
                if (!request.getParameter("email").isBlank()) {
                    str = "UPDATE enduser_account SET email = '" + request.getParameter("email") +
                            "' WHERE username = '" + request.getParameter("username") + "';";
                    stmt.executeUpdate(str);
                }
                if (!request.getParameter("phone").isBlank()) {
                    str = "UPDATE enduser_account SET phone = '" + request.getParameter("phone") +
                            "' WHERE username = '" + request.getParameter("username") + "';";
                    stmt.executeUpdate(str);
                }

                out.print("Edited account " + request.getParameter("username") + " successfully!");
                break;
            case 1:
                str = "DELETE FROM enduser_account WHERE username = '" + request.getParameter("username") + "';";
                stmt.executeUpdate(str);
                out.print("Deleted account " + request.getParameter("username") + " successfully!");
                break;
            case 2:
                if (request.getParameter("bid type").equals("manual")) {
                    str = "DELETE FROM manual_bid WHERE username = '" +
                            request.getParameter("username") + "' AND bid_id = '" +
                            request.getParameter("bidID") + "';";
                } else {
                    str = "DELETE FROM auto_bid WHERE username = '" +
                            request.getParameter("username") + "' AND bid_number = '" +
                            request.getParameter("bidID") + "';";
                }
                stmt.executeUpdate(str);
                out.print("Deleted bid successfully!");
                break;
            case 3:
                str = "DELETE FROM bid_selling_offers WHERE bid_id = '" +
                        request.getParameter("bidID") + "';";
                stmt.executeUpdate(str);
                out.print("Deleted auction successfully!");
                break;
            default:
        }
        con.close();
    } catch (SQLException throwable) {
        throwable.printStackTrace();
        out.print("Unable to make changes :(");
    }
%>

</body>
</html>
