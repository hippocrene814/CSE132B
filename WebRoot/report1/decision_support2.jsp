<html>

<body>
<h2>Decision Support</h2>
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

            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && (action.equals("show_decision1") || action.equals("show_decision2") || action.equals("show_decision3"))) {
                if (action.equals("show_decision1")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT ss.grade, count(*) as cnt FROM class cl, section se, student_section ss WHERE cl.course_id = ? AND cl.year = ? AND cl.quarter = ? AND cl.class_id = se.class_id AND se.fac_id = ? AND se.section_id = ss.section_id AND ss.grade <> 'IN' GROUP BY ss.grade");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("year")));
                    pstmt.setString(3, request.getParameter("quarter"));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("fac_id")));

                    rs = pstmt.executeQuery();
                    System.out.println("haha");

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
                else if (action.equals("show_decision2")) {
                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT ss.grade, count(*) as cnt FROM class cl, section se, student_section ss WHERE cl.course_id = ? AND cl.class_id = se.class_id AND se.fac_id = ? AND se.section_id = ss.section_id AND ss.grade <> 'IN' GROUP BY ss.grade");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("fac_id")));

                    rs = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
                else if (action.equals("show_decision3")) {
                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT ss.grade, count(*) as cnt FROM class cl, section se, student_section ss WHERE cl.course_id = ? AND cl.class_id = se.class_id AND se.section_id = ss.section_id AND ss.grade <> 'IN' GROUP BY ss.grade");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    rs = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
                    %>
                    <table border="1">
                        <tr>
                        <th>Grade </th>
                        <th>Count </th>
                        </tr>
                        <%-- -------- Iteration Code2 -------- --%>
                        <%
                            // Iterate over the ResultSet
                            while (rs.next()) {
                            System.out.println("grade : " + rs.getString("grade"));
                        %>
                        <tr>
                            <td>
                                <%=rs.getString("grade")%>
                            </td>
                            <td>
                                <%=rs.getInt("cnt")%>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </table>
            <%
                }
                else if (action != null && action.equals("show_decision4")) {
                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    pstmt = conn
                    .prepareStatement("SELECT SUM(con.grade_num) / count(*) AS grade FROM class cl, section se, student_section ss, conversion con WHERE cl.course_id = ? AND cl.class_id = se.class_id AND se.fac_id = ? AND se.section_id = ss.section_id AND ss.grade <> 'IN' AND ss.grade = con.grade_letter");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("fac_id")));
                    rs = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <%
                        // Iterate over the ResultSet
                        while (rs.next()) {
                    %>
                    <p>Avg GPA: <%=rs.getFloat("grade")%></p>
                <%
                }
                }
                %>

            <hr>
            <form action="decision_support.jsp" method="POST">
            <table border="1">
            <tr>
            <th>Course Id</th>
            <th>Faculty Id</th>
            <th>Year</th>
            <th>Quarter</th>
            <th></th>
            </tr>
            <tr>
            <input type="hidden" name="action" value="show_decision1"/>
            <!-- Add an HTML table header row to format the results -->
            <td><input value="" name="course_id" size="10"/></td>
            <td><input value="" name="fac_id" size="10"/></td>
            <td><input value="" name="year" size="10"/></td>
            <td><select name="quarter">
                <option value="WINTER">WINTER</option>
                <option value="SPRING">SPRING</option>
                <option value="SUMMER">SUMMER</option>
                <option value="FALL">FALL</option>
            </select></td>
            <td><input type="submit" value="Submit"/></td>
            </tr>
            </table>
            </form>

            <hr>
            <form action="decision_support.jsp" method="POST">
            <table border="1">
            <tr>
            <th>Course Id</th>
            <th>Faculty Id</th>
            <th></th>
            </tr>
            <tr>
            <input type="hidden" name="action" value="show_decision2"/>
            <!-- Add an HTML table header row to format the results -->
            <td><input value="" name="course_id" size="10"/></td>
            <td><input value="" name="fac_id" size="10"/></td>
            <td><input type="submit" value="Submit"/></td>
            </tr>
            </table>
            </form>

            <hr>
            <form action="decision_support.jsp" method="POST">
            <table border="1">
            <tr>
            <th>Course Id</th>
            <th></th>
            </tr>
            <tr>
            <input type="hidden" name="action" value="show_decision3"/>
            <!-- Add an HTML table header row to format the results -->
            <td><input value="" name="course_id" size="10"/></td>
            <td><input type="submit" value="Submit"/></td>
            </tr>
            </table>
            </form>

            <hr>
            <form action="decision_support.jsp" method="POST">
            <table border="1">
            <tr>
            <th>Course Id</th>
            <th>Faculty Id</th>
            <th></th>
            </tr>
            <tr>
            <input type="hidden" name="action" value="show_decision4"/>
            <!-- Add an HTML table header row to format the results -->
            <td><input value="" name="course_id" size="10"/></td>
            <td><input value="" name="fac_id" size="10"/></td>
            <td><input type="submit" value="Submit"/></td>
            </tr>
            </table>
            </form>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                if (rs != null) {
                    rs.close();
                }

                // Close the Statement
//                statement.close();

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
