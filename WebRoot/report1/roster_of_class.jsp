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
                    .prepareStatement("SELECT st.stu_id, st.ssn, st.citizen, st.pre_school, st.pre_degree, st.pre_major, st.first_name AS first, st.middle_name AS middle, st.last_name AS last, ss.unit, ss.letter_su FROM class cl, section se, student_section ss, student st WHERE cl.title = ? AND se.class_id = cl.class_id AND ss.section_id = se.section_id AND ss.stu_id = st.stu_id ");

                    pstmt.setString(1, request.getParameter("show_title"));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                    <th>Student Id </th>
                    <th>First Name </th>
                    <th>Middle Name </th>
                    <th>Last Name </th>
                    <th>SSN </th>
                    <th>Citizen </th>
                    <th>Pre School </th>
                    <th>Pre Degree </th>
                    <th>Pre Major </th>
                    <th>Unit </th>
                    <th>Grade Option </td>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rs2.getInt("stu_id")%>
                        </td>
                        <td>
                            <%=rs2.getString("first")%>
                        </td>
                        <td>
                            <%=rs2.getString("middle")%>
                        </td>
                        <td>
                            <%=rs2.getString("last")%>
                        </td>
                        <td>
                            <%=rs2.getInt("ssn")%>
                        </td>
                        <td>
                            <%=rs2.getString("citizen")%>
                        </td>
                        <td>
                            <%=rs2.getString("pre_school")%>
                        </td>
                        <td>
                            <%=rs2.getString("pre_degree")%>
                        </td>
                        <td>
                            <%=rs2.getString("pre_major")%>
                        </td>
                        <td>
                            <%=rs2.getInt("unit")%>
                        </td>
                        <td>
                            <%=rs2.getString("letter_su")%>
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
                rs = statement.executeQuery("SELECT cl.title AS title, cl.year AS year, cl.quarter AS quarter, co.course_number AS course_number FROM class cl, course co WHERE cl.course_id = co.course_id");
            %>
            <hr>
            <form action="roster_of_class.jsp" method="POST">
            <input type="hidden" name="action" value="show_class"/>
            <!-- Add an HTML table header row to format the results -->
            <select name="show_title">
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
                %>
                <option value='<%=rs.getString("title")%>'>
                        <%=rs.getString("title")%>, <%=rs.getInt("year")%>, <%=rs.getString("quarter")%>, <%=rs.getString("course_number")%>
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
