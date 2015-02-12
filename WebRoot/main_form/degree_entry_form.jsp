<html>

<body>
<h2>Degree Requirements' Info Submission</h2>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="/main_menu.html" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132?" +
                    "user=postgres&password=wizard");
            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("INSERT INTO degree (name, type, total_min_unit, dep_id) VALUES (?, ?, ?, ?)");

                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("type"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("total_min_unit")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("dep_id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    pstmt = conn
                        .prepareStatement("UPDATE degree SET name = ?, type = ?, total_min_unit = ?, dep_id = ? WHERE degree_id = ? ");

                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("type"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("total_min_unit")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("dep_id")));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("degree_id")));

                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM degree WHERE degree_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("degree_id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                rs = statement.executeQuery("SELECT * FROM degree ORDER BY degree_id");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Major</th>
                <th>Type</th>
                <th>Total_Min_Unit</th>
                <th>Department Id</th>
            </tr>

            <tr>
                <form action="degree_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="name" size="15"/></th>
                    <th>
                      <select name="type">
                        <option value="ba">BA</option>
                        <option value="be">BE</option>
                        <option value="ms">MS</option>
                        <option value="ma">MA</option>
                        <option value="phd">PHD</option>
                      </select>
                    </th>
                    <th><input value="" name="total_min_unit" size="15"/></th>
                    <th><input value="" name="dep_id" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="degree_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="degree_id" value="<%=rs.getInt("degree_id")%>"/>

                <td>
                    <%=rs.getInt("degree_id")%>
                </td>

                <td>
                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("type")%>" name="type" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("total_min_unit")%>" name="total_min_unit" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("dep_id")%>" name="dep_id" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="degree_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="degree_id" value="<%=rs.getInt("degree_id")%>"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
            </tr>
            <%
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
        </table>
        </td>
    </tr>
</table>
</body>

</html>
