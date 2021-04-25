<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<html>
<head>
    <title>Create Auction</title>
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
<h1>Create an Auction</h1>
<br>
<%
    if (session.getAttribute("user") == null) {
        out.print("Please log in to create an auction.");
    } else {
%>
<form method="post" action="createAuction.jsp" id="createAuction">
    <table>
        <tr>
            <td>Title</td>
            <td><label>
                <input type="text" name="title" required>
            </label></td>
        </tr>
        <tr>
            <td>Brand</td>
            <td><label>
                <input type="text" name="brand" required>
            </label></td>
        </tr>
        <tr>
            <td>
                <label>Choose a type:
                    <select name="type">
                        <option value="Top">Top</option>
                        <option value="Bottom">Bottom</option>
                        <option value="Accessory">Accessory</option>
                    </select>
                </label>
            </td>
        </tr>
        <tr>
            <td><label for="size">Size</label></td>
            <td><input type="text" name="size" id="size" required></td>
        </tr>
        <tr>
            <td><label for="openDate">Start Date</label></td>
            <td><input type="date" name="open_date" id="openDate" required
                       value=<%= new java.sql.Date(System.currentTimeMillis()) %> min= <%=new java.sql.Date(System.currentTimeMillis()).toString() %>>
            </td>
        </tr>
        <tr>
            <td><label for="close_date">Close Date</label></td>
            <td><input type="date" name="close_date" id="close_date"
                       min=<%= new java.sql.Date(System.currentTimeMillis()) %> required></td>
        </tr>
        <tr>
            <td><label for="close_time">Close Time</label></td>
            <td><input type="time" name="close_time" id="close_time" step="1" required></td>
        </tr>
        <tr>
            <td title="Only visible to buyers."><label for="min_price">Minimum Price</label></td>
            <td><input type="number" min="0.00" value=0 step=any name="min_price" id="min_price" required></td>
        </tr>
    </table>
    <label for="description"> Description: </label>
    <br/>
    <textarea rows="8" cols="50" name="description" id="description" form="createAuction"
              style="resize:none"> </textarea>
    <input type="submit" value="Create Auction">
</form>
<%
    }
%>
</body>
</html>