<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
          crossorigin="anonymous">
</head>
<body>
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    Product Details
</nav>
<br>
<button type="button" class="btn btn-secondary btn-lg btn-block" onclick="history.back()">Back to Search</button>
<%
    int productID = Integer.parseInt(request.getParameter("productID"));
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    String data = "select * from clothing c, bid_selling_offers b where c.productID=" + productID + "" +
            " and c.productID = b.productID;";
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
            <% if (type.equals("top")) { %><%=res.getString("top_size")%> <%}%>
            <% if (type.equals("bottom")) { %><%=res.getString("bottom_size")%> <%}%>
            <% if (type.equals("accessory")) { %><%=res.getString("accessory_size")%> <%}%>
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
    <thread>
        <tr>
            <th>Bid History</th>
            <th>Seller History</th>
            <th>Product Title</th>
            <th>Type</th>
            <th>Brand</th>
            <th>Open Date</th>
            <th>Close Date</th>
            <th>Highest Bid</th>
            <th>Set Alert</th>
        </tr>
    </thread>
    <tbody>
        <%
        String similar = "select * from bid_selling_offers b, clothing c where b.productID = c.productID and b.open_date " +
        ">= " + openDate + " and c.title like '%" + title + "%' union " +
        "select * from bid_selling_offers b, clothing c where b.productID = c.productID and b.open_date " +
        ">= " + openDate + " and c.brand='" + brand + "' union " +
        "select * from bid_selling_offers b, clothing c where b.productID = c.productID and b.open_date " +
        ">= " + openDate + " and c.type='" + type + "'";

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
        <td><a href="productDetails.jsp?productID=${similarProductID}"><%=res2.getString("title")%></a></td>
        <td><%=res2.getString("type")%></td>
        <td><%=res2.getString("brand")%></td>
        <td><%=res2.getDate("open_date")%></td>
        <td><%=res2.getDate("close_date")%></td>
        <td><%=res2.getFloat("highest_bid")%></td>
        <td><a href="setAlert.jsp?username=${uname}&productID=${similarProductID}">&#9745</a></td>
    </tr>
        <%
        }
        conn.close();
        %>
</table>
</tbody>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
