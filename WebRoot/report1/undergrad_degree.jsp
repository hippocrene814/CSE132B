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
                if (action != null && action.equals("show_undergrad_degree")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT dc.cate_id, dc.min_unit - SUM(ss.unit) AS remain_cate_unit FROM student st, student_section ss, degree de, degree_category dc, section_category sc WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.grade <> 'IN' AND ss.grade <> 'na' AND ss.section_id = sc.section_id AND de.name = ? AND de.degree_id = dc.degree_id GROUP BY dc.cate_id, dc.min_unit");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("show_ssn")));
                    pstmt.setString(2, request.getParameter("show_degree"));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();

                    %>
                    <table border="1">
                    <tr>
                    <th>Category Id </th>
                    <th>Remain Unit </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rs2.getInt("cate_id")%>
                        </td>
                        <td>
                            <%=rs2.getInt("remain_cate_unit")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </table>
                    <%
                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT de.total_min_unit - SUM(ss.unit) AS remain_unit FROM student st, student_section ss, degree de WHERE st.ssn = ? AND de.name = ? AND st.stu_id = ss.stu_id AND ss.grade <> 'IN' AND ss.grade <> 'na' GROUP BY de.total_min_unit");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("show_ssn")));
                    pstmt.setString(2, request.getParameter("show_degree"));
                    rs2 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    Remain Unit:
                    <%
                        // Iterate over the ResultSet
                        while (rs2.next()) {
                            System.out.println("unit : " + rs2.getInt("remain_unit"));
                    %>
                        <%=rs2.getInt("remain_unit")%>
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
                rs = statement.executeQuery("SELECT s.ssn, s.first_name AS first, s.middle_name AS middle, s.last_name AS last FROM student s, student_enrollment se WHERE s.stu_id = se.stu_id AND se.year = 2009 AND se.quarter = 'SPRING'AND NOT EXISTS ( SELECT * FROM grad g WHERE s.stu_id = g.stu_id )");
            %>
            <hr>
            <form action="undergrad_degree.jsp" method="POST">
            <input type="hidden" name="action" value="show_undergrad_degree"/>
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
                rs = statement.executeQuery("SELECT name, type FROM degree WHERE type = 'bs'");
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
