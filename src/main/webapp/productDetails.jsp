<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Product Details</title>
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
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    Product Details
</nav>
<br>
<%
    int productID = Integer.parseInt(request.getParameter("productID"));
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    String data = "select b.bid_id, b.username, c.title, c.productID, c.brand, c.type, open_date, close_date, highest_bid " +
            "from clothing c, bid_selling_offers b where c.productID=" + productID +
            " and c.productID = b.productID;";
    try {
        Statement stat = conn.createStatement();
        ResultSet res = stat.executeQuery(data);
        String title = "";
        String brand = "";
        String type = "";
        String openDate = "";
        while (res.next()) {
            openDate = res.getString("open_date");
            request.setAttribute("open_date", openDate);
%>
<div class="container">
    <div class="row" style="border: 1px solid #e5e5e5;">
        <div class="col" style="border: 1px solid #e5e5e5;">
            Title
        </div>
        <div class="col-6" style="border: 1px solid #e5e5e5;">
            <% title = res.getString("title");
                request.setAttribute("title", title);%>
            ${title}
        </div>
    </div>
    <div class="row" style="border: 1px solid #e5e5e5;">
        <div class="col" style="border: 1px solid #e5e5e5;">
            Brand
        </div>
        <div class="col-6" style="border: 1px solid #e5e5e5;">
            <% brand = res.getString("brand");
                request.setAttribute("brand", brand);%>
            ${brand}
        </div>
    </div>
    <div class="row" style="border: 1px solid #e5e5e5;">
        <div class="col" style="border: 1px solid #e5e5e5;">
            Type
        </div>
        <div class="col-6" style="border: 1px solid #e5e5e5;">
            <% type = res.getString("type");
                request.setAttribute("type", type);%>
            ${type}
        </div>
    </div>
    <div class="row" style="border: 1px solid #e5e5e5;">
        <div class="col" style="border: 1px solid #e5e5e5;">
            Size
        </div>
        <div class="col-6" style="border: 1px solid #e5e5e5;">
            <%=res.getString("size")%>
        </div>
    </div>
    <div class="row" style="border: 1px solid #e5e5e5;">
        <div class="col" style="border: 1px solid #e5e5e5;">
            Type of ${type}
        </div>
        <div class="col-6" style="border: 1px solid #e5e5e5;">
            <% if (type.equals("top")) { %><%=res.getString("top_type")%> <%}%>
            <% if (type.equals("bottom")) { %><%=res.getString("bottom_type")%> <%}%>
            <% if (type.equals("accessory")) { %><%=res.getString("accessory_type")%> <%}%>
        </div>
    </div>
</div>
<br>
<% } %>
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    Similar Items
</nav>
<table class="table table-bordered table-striped table-hover">
    <thead>
        <tr>
            <th>Bid History</th>
            <th>Seller History</th>
            <th>Product Title</th>
            <th>Type</th>
            <th>Brand</th>
            <th>Open Date</th>
            <th>Close Date</th>
            <th>Highest Bid</th>
            <%
                session = request.getSession(false);
                String uname = (String) session.getAttribute("user");
                if(uname != null) {
            %>
            <th>Set Alert</th>
            <%
                }
            %>
        </tr>
    </thead>
    <tbody>
        <%
            String similar = "select b.bid_id, b.username, c.title, c.productID, c.brand, c.type, open_date, close_date, highest_bid " +
                    "from bid_selling_offers b, clothing c where b.productID = c.productID and b.open_date >='" +
                    openDate + "' and c.title like '%" + title + "%' union " +
                    "select b.bid_id, b.username, c.title, c.productID, c.brand, c.type, open_date, close_date, highest_bid " +
                    "from bid_selling_offers b, clothing c where b.productID = c.productID and b.open_date >='" +
                    openDate + "' and c.brand='" + brand + "' union " +
                    "select b.bid_id, b.username, c.title, c.productID, c.brand, c.type, open_date, close_date, highest_bid " +
                    "from bid_selling_offers b, clothing c where b.productID = c.productID and b.open_date >='" +
                    openDate + "' and c.type='" + type + "'";

            Statement stat2 = conn.createStatement();
            ResultSet res2 = stat2.executeQuery(similar);
            while (res2.next()) {
        %>
    <tr>
        <% int bidID = res2.getInt("bid_id");
            request.setAttribute("bidID", bidID);%>
        <td><a href="bidHistory.jsp?bidID=${bidID}">${bidID}</a></td>
        <% String username = res2.getString("username");
            request.setAttribute("username", username);%>
        <td><a href="userHistory.jsp?username=${username}">${username}</a></td>
        <% int similarProductID = res2.getInt("productID");
            request.setAttribute("productID", similarProductID);%>
        <td><a href="productDetails.jsp?productID=${productID}"><%=res2.getString("title")%></a></td>
        <td><%=res2.getString("type")%></td>
        <td><%=res2.getString("brand")%></td>
        <td><%=res2.getDate("open_date")%></td>
        <td><%=res2.getDate("close_date")%></td>
        <td><%=res2.getFloat("highest_bid")%></td>
        <%
            if(uname != null) {
        %>
        <td><a href="setAlert.jsp?username=<%=uname%>&productID=${productID}">&#9745</a></td>
        <%
            }
        %>
    </tr>
        <%
            }
            conn.close();
        } catch (SQLException throwable) {
            throwable.printStackTrace();
            out.print("Unable to view products :(");
        }
        %>
    </tbody>
</table>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
