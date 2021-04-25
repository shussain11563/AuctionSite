<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Your Bids</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
          crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<div id="navigation">

</div>
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script>
    $(function () {
        $("#navigation").load("navigation.html");
    });
</script>
<body>
<h1>Your Bids</h1>
<%

    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    String uname = (String) session.getAttribute("user");
    String temp = "SELECT * FROM manual_bid WHERE username =?";

    try {
        PreparedStatement ps = con.prepareStatement(temp);
        ps.setString(1, uname);
        ResultSet rs = ps.executeQuery();

        out.println("bidID &nbsp Bid Price <br>");

        while (rs.next()) {
            int nm = rs.getInt("bid_id");
            float s = rs.getFloat("bid_val");
            out.println("</td><td>" + nm + "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td>" + s + "</td></tr>");
            out.println("<br>");
        }

        out.println("</table>");
        out.println("</html></body>");
        con.close();
    } catch (SQLException throwable) {
        throwable.printStackTrace();
        out.print("Unable to load bids :(");
    }

%>
<br>
<form method="post" action="bidsPage.jsp" id="bidsPage">
    <table>
        <tr>
            <td>Bid Number</td>
            <td><label>
                <input type="number" min="0" name="bidID">
            </label></td>
        </tr>
    </table>
    <br/>
    <input type="submit" value="Check Status">
</form>
<br>
</body>
</html>