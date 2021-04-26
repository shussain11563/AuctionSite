<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.sql.*, java.util.Date, java.text.*" %>
<html>
<head>
    <title>Bid Status</title>
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
<%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String bidID = request.getParameter("bidID");
        String uname = (String) session.getAttribute("user");

        String temp = "SELECT * FROM bid_selling_offers b, manual_bid m WHERE m.bid_id = ? and b.bid_id = ?";
        PreparedStatement ps = con.prepareStatement(temp);
        ps.setString(1, bidID);
        ps.setString(2, bidID);
        ResultSet rs = ps.executeQuery();

        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

        if (rs.next()) {
            java.sql.Date closeDate = rs.getDate("close_date");

            Time closeTime = rs.getTime("close_time");
            float reserve = rs.getFloat("min_price");
            

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

            if ((today.compareTo(closeDate) > 0 || today.compareTo(closeDate) == 0) && currentTime.toLocalTime().isAfter(closeTime.toLocalTime())) {
                String winner = "SELECT * from manual_bid where bid_val=(select max(bid_val) from manual_bid where bid_id = ?)";
                PreparedStatement ps2 = con.prepareStatement(winner);
                ps2.setString(1, bidID);
                ResultSet rs2 = ps2.executeQuery();
                while (rs2.next()) {
                    String n = rs2.getString("username");
                    float s = rs2.getFloat("bid_val");
                    String temp2 = "UPDATE bid_Selling_offers SET highest_bid = ?, winner = ? where bid_id = ?";
                    PreparedStatement ps3 = con.prepareStatement(temp2);
                    ps3.setFloat(1, s);
                    ps3.setString(2, n);
                    ps3.setString(3, bidID);

                    ps3.executeUpdate();
                }
                while (rs4.next()) {
                    String win = rs4.getString("winner");
                    float bidVal1 = rs4.getFloat("m.bid_val");
                    if (reserve > 0) {
                        if (reserve > bidVal1 && uname.equals(win)) {
                            out.print("No winner!");
                        } else if (reserve < bidVal1 && uname.equals(win)) {
                            out.print("You are the winner.");
                        } else {
                            out.print("A winner was chosen and it wasn't you! :(");
                        }
                    } else {
                        if (uname.equals(win)) {
                            out.print("You are the winner.");
                        } else {
                            out.print("A winner was chosen and it wasn't you! :(");
                        }
                    }
                }
            } else {
                boolean outbid = false;

                while (rs1.next()) {
                    String n = rs1.getString("username");
                    float s = rs1.getFloat("bid_val");
                    float max = rs1.getFloat("MAX(bid_val)");

                    if (!uname.equals(n) && s == max) {
                        outbid = true;
                        break;
                    }
                } 

                con.close();
                if (outbid) {
                    out.print("A higher bid has been placed!");
                } else {
                    out.print("To be announced.");
                }
            }
        }
        else{
        	out.print("You don't have a bid in this auction.");
        }

    } catch (SQLException ex) {
        ex.printStackTrace();
        out.print("Sorry, the auction cannot be created.");
    }
%>
</body>
</html>