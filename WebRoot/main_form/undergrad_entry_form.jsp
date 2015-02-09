<html>

<body>
<h2>Undergrad Entry Form</h2>
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
                    .prepareStatement("INSERT INTO undergrad (stu_id, col_id, major, minor, is_bms) VALUES (?, ?, ?, ?, ?)");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("stu_id")));
                    pstmt.setString(2, request.getParameter("col_id"));
                    pstmt.setString(3, request.getParameter("major"));
                    pstmt.setString(4, request.getParameter("minor"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("is_bms")));
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
                        .prepareStatement("UPDATE undergrad SET stu_id = ?, col_id = ?, major = ?, minor = ?, is_bms = ? WHERE undergrad_id = ? ");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("stu_id")));
                    pstmt.setString(2, request.getParameter("col_id"));
                    pstmt.setString(3, request.getParameter("major"));
                    pstmt.setString(4, request.getParameter("minor"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("is_bms")));
                    pstmt.setInt(6, Integer.parseInt(request.getParameter("undergrad_id")));

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
                        .prepareStatement("DELETE FROM undergrad WHERE undergrad_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("undergrad_id")));
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
                rs = statement.executeQuery("SELECT * FROM undergrad ORDER BY undergrad_id");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Student ID</th>
                <th>College Name</th>
                <th>Major</th>
                <th>Minor</th>
                <th>Is BMS</th>
            </tr>

            <tr>
                <form action="undergrad_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="stu_id" size="15"/></th>
                    <th>
                      <select name="col_id">
                        <option value="Earl_Warren">Earl_Warren</option>
                        <option value="Eleanor_Roosevelt">Eleanor_Roosevelt</option>
                        <option value="John_Muir">John_Muir</option>
                        <option value="Revelle">Revelle</option>
                        <option value="Sixth">Sixth</option>
                        <option value="Thurgood_Marshall">Thurgood_Marshall</option>
                      </select>
                    </th>
                    <th><input value="" name="major" size="15"/></th>
                    <th><input value="" name="minor" size="15"/></th>
                    <th><input value="" name="is_bms" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="undergrad_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="undergrad_id" value="<%=rs.getInt("undergrad_id")%>"/>

                <td>
                    <%=rs.getInt("undergrad_id")%>
                </td>

                <td>
                    <input value="<%=rs.getInt("stu_id")%>" name="stu_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("col_id")%>" name="col_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("major")%>" name="major" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("minor")%>" name="minor" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("is_bms")%>" name="is_bms" size="15"/>
                </td>
                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="undergrad_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="undergrad_id" value="<%=rs.getInt("undergrad_id")%>"/>
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
