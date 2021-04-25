<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
  <title>Search</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
        integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
        crossorigin="anonymous">
</head>
<body>
<p></p>
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
        String[] sizes = request.getParameterValues("size");
        %>
    <div class="jumbotron jumbotron-fluid">
        <h1 class="display-4">Search Results For Selected Types</h1>
    </div>
    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="history.back()">Back to Search</button>
    <%
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();
        String data = "";
        for (int i = 0; i < sizes.length - 1; i++) {
          data += "select * from bid_selling_offers b, clothing c where b.productID = c.productID and c.type='" +
                  sizes[i] + "' union ";
        }
        data += "select * from bid_selling_offers b, clothing c where b.productID = c.productID and c.type='" +
                sizes[sizes.length - 1] + "'";
        Statement stat = conn.createStatement();
        ResultSet res = stat.executeQuery(data);
        while (res.next()) {
        %>
  <tr>
    <% int bidID = res.getInt("bid_id");
      request.setAttribute("bidID", bidID);%>
    <td><a href="bidHistory.jsp?bidID=${bidID}">${bidID}</a></td>
    <% String username = res.getString("username");
      request.setAttribute("username", username);%>
    <td><a href="userHistory.jsp?username=${username}">${username}</a></td>
      <% int productID = res.getInt("productID");
          request.setAttribute("productID", productID);%>
    <td><a href="productDetails.jsp?productID=${productID}"><%=res.getString("title")%></a></td>
    <td><%=res.getString("type")%></td>
    <td><%=res.getString("brand")%></td>
    <td><%=res.getDate("open_date")%></td>
    <td><%=res.getDate("close_date")%></td>
    <td><%=res.getFloat("highest_bid")%></td>
    <td>&#9745</td>
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
