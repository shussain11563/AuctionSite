<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Search</title>
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
<br>
<div class="row">
    <div class="col-md-4">
        <form action="search.jsp" method="get">
            <label>
                <input type="text" class="form-control" name="q" placeholder="Search">
            </label>
            <button class="btn btn-outline-success" type="submit"><i class="fa fa-search"></i></button>
        </form>
    </div>
</div>
<br>
<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    Search By Clothing Type
</nav>
<form action="searchByClothingType.jsp">
    <div class="form-check">
        <input class="form-check-input" type="checkbox" value="top" id="top" name="clothing type">
        <label class="form-check-label" for="top">
            Top
        </label>
        <br>
        <input class="form-check-input" type="checkbox" value="bottom" id="bottom" name="clothing type">
        <label class="form-check-label" for="bottom">
            Bottom
        </label>
        <br>
        <input class="form-check-input" type="checkbox" value="accessory" id="accessory" name="clothing type">
        <label class="form-check-label" for="accessory">
            Accessory
        </label>
    </div>
    <button class="btn btn-outline-success" type="submit">
        <i class="fa fa-search"></i></button>
</form>
<br>
<div class="btn-group" role="group" aria-label="Button group with nested dropdown">
    <div class="btn-group" role="group">
        <button id="btnGroupDrop1" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Sort By
        </button>
        <div class="dropdown-menu" aria-labelledby="btnGroupDrop1">
            <a class="dropdown-item" href="sortByClothingType.jsp">Clothing Type</a>
            <a class="dropdown-item" href="sortByPriceDesc.jsp">Bidding Price Descending</a>
            <a class="dropdown-item" href="sortByPriceAsc.jsp">Bidding Price Ascending</a>
        </div>
    </div>
</div>
<p></p>
<table class="table table-bordered table-striped table-hover">
    <thead>
        <tr>
            <th>Bid ID</th>
            <th>Seller (User)</th>
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
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();
        String data = "";
        String[] types = request.getParameterValues("clothing type");
        if (types == null || types.length == 3) {
            data = "select b.bid_id, b.productID, b.username, c.title, c.brand, c.type, b.open_date, b.close_date, b.highest_bid from " +
                "bid_selling_offers b, clothing c where b.productID = c.productID order by b.highest_bid;";
        } else {
            for (int i = 0; i < types.length - 1; i++) {
                data += "select b.bid_id, b.productID, b.username, c.title, c.brand, c.type, b.open_date, b.close_date, b.highest_bid from " +
                 "bid_selling_offers b, clothing c where b.productID = c.productID and c.type='" +
                    types[i] + "' union ";
            }
            data += "select b.bid_id, b.productID, b.username, c.title, c.brand, c.type, b.open_date, b.close_date, b.highest_bid from " +
                "bid_selling_offers b, clothing c where b.productID = c.productID and c.type='" +
                types[types.length - 1] + "' order by b.highest bid;";
        }

        try{
            Statement stat = conn.createStatement();
            ResultSet res = stat.executeQuery(data);
            while (res.next()) {
                if (request.getParameter("q") != null) {
                    if (!res.getString("title").contains(request.getParameter("q"))) continue;
                }
        %>
    <tr>
        <% int bidID = res.getInt("bid_id");
            request.setAttribute("bidID", bidID);%>
        <td><a href="bidHistory.jsp?bidID=${bidID}">${bidID}</a></td>
        <%
            String username = res.getString("username");
            int productID = res.getInt("productID");
            request.setAttribute("username", username);
            request.setAttribute("productID",productID);
        %>
        <td><a href="userHistory.jsp?username=${username}">${username}</a></td>
        <td><a href="productDetails.jsp?productID=${productID}"><%=res.getString("title")%></a></td>
        <td><%=res.getString("type")%></td>
        <td><%=res.getString("brand")%></td>
        <td><%=res.getDate("open_date")%></td>
        <td><%=res.getDate("close_date")%></td>
        <td><%=res.getFloat("highest_bid")%></td>
        <%
            if (uname != null) {
        %>
        <td><a href="setAlert.jsp?username=<%=uname%>&productID=${productID}">&#9745</a></td>
        <%
            }
        %>

    </tr>
        <%
            }
            request.setAttribute("q", null);
            conn.close();
        } catch (SQLException throwable) {
            throwable.printStackTrace();
            out.print("Unable to sort by price desc :(");
        }
        %>
</table>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
