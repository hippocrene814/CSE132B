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
                    .prepareStatement("SELECT cl.year, cl.quarter, cl.class_id, cl.title, cl.course_id, ss.grade, ss.unit, ss.letter_su FROM student st, student_section ss, section se, class cl WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.section_id = se.section_id AND se.class_id = cl.class_id ORDER BY cl.year, cl.quarter");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("show_ssn")));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
//                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                    <th>Year </th>
                    <th>Quarter </th>
                    <th>Class Id </th>
                    <th>Title </th>
                    <th>Course Id </th>
                    <th>Grade </th>
                    <th>Unit </th>
                    <th>Grade Option </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rs2.getInt("year")%>
                        </td>
                        <td>
                            <%=rs2.getString("quarter")%>
                        </td>
                        <td>
                            <%=rs2.getInt("class_id")%>
                        </td>
                        <td>
                            <%=rs2.getString("title")%>
                        </td>
                        <td>
                            <%=rs2.getInt("course_id")%>
                        </td>
                        <td>
                            <%=rs2.getString("grade")%>
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

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT cl.year, cl.quarter, SUM(ss.unit * co.grade_num) / SUM(ss.unit) AS grade FROM student st, student_section ss, section se, class cl, conversion co WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND ss.letter_su = 'letter' AND ss.grade <> 'IN' AND ss.grade = co.grade_letter GROUP BY cl.year, cl.quarter");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("show_ssn")));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    %>
                    <hr>
                    <table border="1">
                    <tr>
                    <th>Year </th>
                    <th>Quarter </th>
                    <th>Grade </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rs2.getInt("year")%>
                        </td>
                        <td>
                            <%=rs2.getString("quarter")%>
                        </td>
                        <td>
                            <%=rs2.getFloat("grade")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </table>
                    <%
                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT SUM(ss.unit * co.grade_num) / SUM(ss.unit) AS grade FROM student st, student_section ss, section se, class cl, conversion co WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND ss.letter_su = 'letter' AND ss.grade <> 'IN' AND ss.grade = co.grade_letter ");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("show_ssn")));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <hr>
                    Overall GPA:
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                            <%=rs2.getFloat("grade")%>
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
                rs = statement.executeQuery("SELECT st.first_name AS first, st.middle_name AS middle, st.last_name AS last, st.ssn AS ssn FROM student st WHERE EXISTS ( SELECT se.stu_id FROM student_enrollment se WHERE st.stu_id = se.stu_id)");
            %>
            <hr>
            <form action="grade_report_of_student.jsp" method="POST">
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
