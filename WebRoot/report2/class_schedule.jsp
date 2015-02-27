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
                    .prepareStatement("SELECT cl1.title AS not_class_title, cl1.course_id AS not_course_id, m1.day AS no_day, m1.start_time AS no_start, m1.end_time AS no_end, cl2.title AS conflict_class_title, cl2.course_id AS conflict_course_id, m2.start_time AS conflict_start, m2.end_time AS conflict_end FROM student st, section se1, class cl1, meeting m1, section se2, class cl2, meeting m2, student_section ss2 WHERE st.ssn = ? AND st.stu_id = ss2.stu_id AND ss2.section_id = se2.section_id AND se2.class_id = cl2.class_id AND m2.section_id = se2.section_id AND cl2.year = 2009 AND cl2.quarter = 'SPRING' AND se1.class_id = cl1.class_id AND m1.section_id = se1.section_id AND cl1.year = 2009 AND cl1.quarter = 'SPRING' AND CAST(m2.start_time AS Time) <= CAST(m1.end_time AS Time) AND CAST(m2.end_time AS Time) >= CAST(m1.start_time AS Time) AND m2.day = m1.day AND m2.section_id <> m1.section_id");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("show_ssn")));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                    <th>No Class Title </th>
                    <th>No Course Id </th>
                    <th>No Start Time </th>
                    <th>No End Time </th>
                    <th>No Day </th>
                    <th>Conflict Class Title </th>
                    <th>Conflict Course Id </th>
                    <th>Conflict Start Time </th>
                    <th>Conflict End Time </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rs2.getString("not_class_title")%>
                        </td>
                        <td>
                            <%=rs2.getInt("not_course_id")%>
                        </td>
                        <td>
                            <%=rs2.getString("no_start")%>
                        </td>
                        <td>
                            <%=rs2.getString("no_end")%>
                        </td>
                        <td>
                            <%=rs2.getInt("no_day")%>
                        </td>
                        <td>
                            <%=rs2.getString("conflict_class_title")%>
                        </td>
                        <td>
                            <%=rs2.getInt("conflict_course_id")%>
                        </td>
                        <td>
                            <%=rs2.getString("conflict_start")%>
                        </td>
                        <td>
                            <%=rs2.getString("conflict_end")%>
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
                rs = statement.executeQuery("SELECT st.first_name as first, st.middle_name as middle, st.last_name as last, st.ssn as ssn FROM student st, student_enrollment se WHERE st.stu_id = se.stu_id AND se.year = 2009 AND se.quarter = 'SPRING'");
            %>
            <hr>
            <form action="class_schedule.jsp" method="POST">
            <input type="hidden" name="action" value="show_class"/>
            <!-- Add an HTML table header row to format the results -->
            <select name="show_ssn">
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
