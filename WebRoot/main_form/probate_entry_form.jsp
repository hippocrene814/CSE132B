<html>

<body>
<h2>Probation Info Submission</h2>
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
                    .prepareStatement("INSERT INTO probate (stu_id, year, quarter, reason) VALUES (?, ?, ?, ?)");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("stu_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("year")));
                    pstmt.setString(3, request.getParameter("quarter"));
                    pstmt.setString(4, request.getParameter("reason"));
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
                        .prepareStatement("UPDATE probate SET stu_id = ?, year = ?, quarter = ?, reason = ? WHERE prob_id = ? ");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("stu_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("year")));
                    pstmt.setString(3, request.getParameter("quarter"));
                    pstmt.setString(4, request.getParameter("reason"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("prob_id")));
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
                        .prepareStatement("DELETE FROM probate WHERE prob_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("prob_id")));
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
                rs = statement.executeQuery("SELECT * FROM probate ORDER BY prob_id");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Student Id</th>
                <th>Year</th>
                <th>Quarter</th>
                <th>Reason</th>
            </tr>

            <tr>
                <form action="probate_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="stu_id" size="10"/></th>
                    <th><input value="" name="year" size="10"/></th>
                    <th>
                      <select name="quarter">
                        <option value="SPRING">SPRING</option>
                        <option value="SUMMER">SUMMER</option>
                        <option value="FALL">FALL</option>
                        <option value="WINTER">WINTER</option>
                      </select>
                    </th>
                    <th><input value="" name="reason" size="10"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="probate_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="prob_id" value="<%=rs.getInt("prob_id")%>"/>

                <td>
                    <%=rs.getInt("prob_id")%>
                </td>

                <td>
                    <input value="<%=rs.getInt("stu_id")%>" name="stu_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("year")%>" name="year" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("quarter")%>" name="quarter" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("reason")%>" name="reason" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="probate_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="prob_id" value="<%=rs.getInt("prob_id")%>"/>
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
