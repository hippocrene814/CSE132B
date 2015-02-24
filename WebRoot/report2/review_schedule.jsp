<html>

<body>
<h2>Classes Taken by Student</h2>
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
            ResultSet rs2 = null;

            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132?" +
                    "user=postgres&password=wizard");
            %>

            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("show_class")) {
                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT aval_date::date, rp.start_time AS select_start_time, rp.end_time AS select_end_time FROM review_period rp, generate_series(?::date, ?::date, '1 day'::interval) aval_date WHERE NOT EXISTS ( SELECT * FROM student_section ss1, student_section ss2, section se2, class cl2, review r2, meeting m2 WHERE ss1.section_id = ? AND ss1.stu_id = ss2.stu_id AND ss2.section_id = r2.section_id AND ss2.section_id = m2.section_id AND ss2.section_id = se2.section_id AND se2.class_id = cl2.class_id AND cl2.year = 2009 AND cl2.quarter = 'SPRING' AND (r2.review_date::date = aval_date AND (CAST(r2.start_time AS Time) < CAST(rp.end_time AS Time) AND CAST(r2.end_time AS Time) > CAST(rp.start_time AS Time)) OR m2.day = extract(dow from aval_date::timestamp) AND (CAST(m2.start_time AS Time) < CAST(rp.end_time AS Time) AND CAST(m2.end_time AS Time) > CAST(rp.start_time AS Time)))) ORDER BY aval_date::date, rp.start_time");

                    pstmt.setString(1, request.getParameter("review_start_date"));
                    pstmt.setString(2, request.getParameter("review_end_date"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("show_section")));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                    <th>Available Date </th>
                    <th>Start Time </th>
                    <th>End Time </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rs2.getString("aval_date")%>
                        </td>
                        <td>
                            <%=rs2.getString("select_start_time")%>
                        </td>
                        <td>
                            <%=rs2.getString("select_end_time")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </table>
                    <%
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                rs = statement.executeQuery("SELECT se.section_id, cl.course_id FROM section se, class cl WHERE se.class_id = cl.class_id AND cl.year = 2009 AND cl.quarter = 'SPRING'");
            %>
            <hr>
            <form action="review_schedule.jsp" method="POST">
            <input type="hidden" name="action" value="show_class"/>
            <!-- Add an HTML table header row to format the results -->
            <select name="show_section">
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
                %>
                <option value='<%=rs.getInt("section_id")%>'>
                        Section Id: <%=rs.getInt("section_id")%>, Course Id: <%=rs.getInt("course_id")%>
                </option>
                <%
                }
            %>
            </select>
            Start Date: <input type="date" value="" name="review_start_date" size="15"/>
            End Date: <input type="date" value="" name="review_end_date" size="15"/>
            <input type="submit" value="Submit"/>
            </form>

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
                if (rs2 != null) {
                    try {
                        rs2.close();
                    } catch (SQLException e) { } // Ignore
                    rs2 = null;
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
