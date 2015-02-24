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
                if (action != null && action.equals("show_grad_degree")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
//                    pstmt = conn
//                    .prepareStatement("SELECT dc.cate_id, dc.min_unit - SUM(ss.unit) AS remain_cate_unit FROM student st, student_section ss, section se, class cl, course co, degree de, degree_category dc WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.grade <> 'IN' AND ss.grade <> 'na' AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.course_id = co.course_id AND de.name = ? AND de.degree_id = dc.degree_id AND dc.cate_id = co.cate_id GROUP BY dc.cate_id, dc.min_unit");

                    pstmt = conn
                    .prepareStatement("SELECT con.con_name ,dc.con_id, dc.min_unit, dc.min_grade FROM degree de, degree_concentration dc, concentration con WHERE de.name = ? AND de.degree_id = dc.degree_id AND dc.con_id = con.con_id AND dc.min_unit <= (SELECT SUM(ss.unit) AS unit FROM student st, student_section ss, section se, class cl, course_concentration cc WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.grade <> 'IN' AND ss.grade <> 'na' AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.course_id = cc.course_id AND cc.con_id = dc.con_id) AND dc.min_grade <= (SELECT SUM(ss.unit * co.grade_num) / SUM(ss.unit) AS grade FROM student st, student_section ss, section se, class cl, course_concentration cc, conversion co WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.letter_su = 'letter' AND ss.grade <> 'IN' AND ss.grade <> 'na' AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.course_id = cc.course_id AND ss.grade = co.grade_letter AND cc.con_id = dc.con_id)");

                    pstmt.setString(1, request.getParameter("show_degree"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("show_ssn")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("show_ssn")));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();

                    %>
                    <table border="1">
                    <tr>
                    <th>Concentration Name </th>
                    <th>Concentration Id </th>
                    <th>Min Unit </th>
                    <th>Min Grade </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rs2.getString("con_name")%>
                        </td>
                        <td>
                            <%=rs2.getInt("con_id")%>
                        </td>
                        <td>
                            <%=rs2.getInt("min_unit")%>
                        </td>
                        <td>
                            <%=rs2.getFloat("min_grade")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </table>
                    <%
                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT con.con_name ,dc.con_id, co.course_id, co.course_number, cl.title, cl.year, cl.quarter FROM degree de, degree_concentration dc, concentration con, course co, course_concentration cc, class cl, period pr WHERE de.name = ? AND de.degree_id = dc.degree_id AND dc.con_id = con.con_id AND con.con_id = cc.con_id AND cc.course_id = co.course_id AND cl.course_id = co.course_id AND cl.year = pr.year AND cl.quarter = pr.quarter AND co.course_id NOT IN (SELECT cl2.course_id FROM student st2, student_section ss2, section se2, class cl2 WHERE st2.ssn = ? AND st2.stu_id = ss2.stu_id AND ss2.grade <> 'IN' AND ss2.grade <> 'na' AND ss2.section_id = se2.section_id AND se2.class_id = cl2.class_id ) AND pr.period_id <= ( SELECT min(pr3.period_id) FROM class cl3, period pr3 WHERE cl3.course_id = co.course_id AND cl3.year = pr3.year AND cl3.quarter = pr3.quarter)");

                    pstmt.setString(1, request.getParameter("show_degree"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("show_ssn")));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <br>
                    <table border="1">
                    <tr>
                    <th>Concentration Name </th>
                    <th>Concentration Id </th>
                    <th>Course Id </th>
                    <th>Course Number </th>
                    <th>Class Title </th>
                    <th>Next Aval Year </th>
                    <th>Next Aval Quarter </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rs2.getString("con_name")%>
                        </td>
                        <td>
                            <%=rs2.getInt("con_id")%>
                        </td>
                        <td>
                            <%=rs2.getInt("course_id")%>
                        </td>
                        <td>
                            <%=rs2.getString("course_number")%>
                        </td>
                        <td>
                            <%=rs2.getString("title")%>
                        </td>
                        <td>
                            <%=rs2.getInt("year")%>
                        </td>
                        <td>
                            <%=rs2.getString("quarter")%>
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
                rs = statement.executeQuery("SELECT s.ssn, s.first_name AS first, s.middle_name AS middle, s.last_name AS last FROM student s, student_enrollment se WHERE s.stu_id = se.stu_id AND se.year = 2009 AND se.quarter = 'SPRING'AND NOT EXISTS ( SELECT * FROM undergrad u WHERE s.stu_id = u.stu_id )");
            %>
            <hr>
            <form action="grad_degree.jsp" method="POST">
            <input type="hidden" name="action" value="show_grad_degree"/>
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
            <select name="show_degree">
            <%
                rs = statement.executeQuery("SELECT name, type FROM degree WHERE type = 'MS'");
                // Iterate over the ResultSet
                while (rs.next()) {
                %>
                <option value='<%=rs.getString("name")%>'>
                        <%=rs.getString("name")%>, <%=rs.getString("type")%>
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
