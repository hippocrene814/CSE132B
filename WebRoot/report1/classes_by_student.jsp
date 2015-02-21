<html>

<body>
<h2>Category Entry Form</h2>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="/report_menu.html" />
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

            <%-- -------- UPDATE Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE category SET cate_name = ? WHERE cate_id = ? ");

                    pstmt.setString(1, request.getParameter("cate_name"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("cate_id")));
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
//                rs = statement.executeQuery("SELECT * FROM category ORDER BY cate_id");
                rs = statement.executeQuery("SELECT st.first_name as first, st.middle_name as middle, st.last_name as last, st.ssn as ssn FROM student st, student_enrollment se WHERE st.stu_id = se.stu_id AND se.year = 2009 AND se.quarter = 'SPRING'");
            %>

            <!-- Add an HTML table header row to format the results -->
            <select id="ssn">
            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
            <option value='<%=rs.getInt("ssn")%>'>
                    <%=rs.getInt("ssn")%>, <%=rs.getString("last")%>, <%=rs.getString("middle")%>, <%=rs.getString("first")%>
            </option>
            <%
                }
            %>
            </select>
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
        </td>
    </tr>
</table>
</body>

</html>
