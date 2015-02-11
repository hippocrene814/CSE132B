<html>

<body>
<h2>Meeting Entry Form</h2>
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
                    .prepareStatement("INSERT INTO meeting (start_time, end_time, location, type, day, section_id) VALUES (?, ?, ?, ?, ?, ?)");

                    pstmt.setString(1, request.getParameter("start_time"));
                    pstmt.setString(2, request.getParameter("end_time"));
                    pstmt.setString(3, request.getParameter("location"));
                    pstmt.setString(4, request.getParameter("type"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("day")));
                    pstmt.setInt(6, Integer.parseInt(request.getParameter("section_id")));

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
                        .prepareStatement("UPDATE meeting SET start_time = ?, end_time = ?, location = ?, type = ?, day = ?, section_id = ? WHERE meeting_id = ? ");

                    pstmt.setString(1, request.getParameter("start_time"));
                    pstmt.setString(2, request.getParameter("end_time"));
                    pstmt.setString(3, request.getParameter("location"));
                    pstmt.setString(4, request.getParameter("type"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("day")));
                    pstmt.setInt(6, Integer.parseInt(request.getParameter("section_id")));
                    pstmt.setInt(7, Integer.parseInt(request.getParameter("meeting_id")));

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
                        .prepareStatement("DELETE FROM meeting WHERE meeting_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("meeting_id")));
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
                rs = statement.executeQuery("SELECT * FROM meeting ORDER BY meeting_id");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Section Id</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Type</th>
                <th>Day</th>
                <th>Location</th>
            </tr>

            <tr>
                <form action="meeting_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="section_id" size="15"/></th>
                    <th><input type="time" value="" name="start_time" size="15"/></th>
                    <th><input type="time" value="" name="end_time" size="15"/></th>
                    <th>
                      <select name="type">
                        <option value="lecture">lecture</option>
                        <option value="discussion">discussion</option>
                        <option value="lab">lab</option>
                      </select>
                    </th>
                    <th><input value="" name="day" size="15"/></th>
                    <th><input value="" name="location" size="15"/></th>

                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="meeting_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="meeting_id" value="<%=rs.getInt("meeting_id")%>"/>

                <td>
                    <%=rs.getInt("meeting_id")%>
                </td>

                <td>
                    <input value="<%=rs.getInt("section_id")%>" name="section_id" size="15"/>
                </td>

                <td>
                    <input type="time" value="<%=rs.getString("start_time")%>" name="start_time" size="15"/>
                </td>

                <td>
                    <input type="time" value="<%=rs.getString("end_time")%>" name="end_time" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("type")%>" name="type" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("day")%>" name="day" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("location")%>" name="location" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="meeting_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="meeting_id" value="<%=rs.getInt("meeting_id")%>"/>
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
