<html>

<body>
<h2>Attempt 2</h2>
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
                    .prepareStatement("INSERT INTO student_section (is_enroll, unit, letter_su, grade, period_id, stu_id, section_id) VALUES (?, ?, ?, ?, ?, ?, ?)");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("is_enroll")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("unit")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("letter_su")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("grade")));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("period_id")));
                    pstmt.setInt(6, Integer.parseInt(request.getParameter("stu_id")));
                    pstmt.setInt(7, Integer.parseInt(request.getParameter("section_id")));
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
                        .prepareStatement("UPDATE student_section SET is_enroll = ?, unit = ?, letter_su = ?, grade = ?, period_id = ?, stu_id = ?, section_id = ? WHERE ss_id = ? ");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("is_enroll")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("unit")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("letter_su")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("grade")));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("period_id")));
                    pstmt.setInt(6, Integer.parseInt(request.getParameter("stu_id")));
                    pstmt.setInt(7, Integer.parseInt(request.getParameter("section_id")));
                    pstmt.setInt(8, Integer.parseInt(request.getParameter("ss_id")));
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
                        .prepareStatement("DELETE FROM student_section WHERE ss_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("ss_id")));
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
                rs = statement.executeQuery("SELECT * FROM student_section WHERE period_id <> 5");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>is_enroll</th>
                <th>unit</th>
                <th>letter_su</th>
                <th>grade</th>
                <th>period_id</th>
                <th>stu_id</th>
                <th>section_id</th>
            </tr>

            <tr>
                <form action="classes_past_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="is_enroll" size="10"/></th>
                    <th><input value="" name="unit" size="10"/></th>
                    <th><input value="" name="letter_su" size="10"/></th>
                    <th><input value="" name="grade" size="10"/></th>
                    <th><input value="" name="period_id" size="10"/></th>
                    <th><input value="" name="stu_id" size="10"/></th>
                    <th><input value="" name="section_id" size="10"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="classes_past_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="ss_id" value="<%=rs.getInt("ss_id")%>"/>

                <td>
                    <%=rs.getInt("ss_id")%>
                </td>

                <td>
                    <input value="<%=rs.getInt("is_enroll")%>" name="is_enroll" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("unit")%>" name="unit" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("letter_su")%>" name="letter_su" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("grade")%>" name="grade" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("period_id")%>" name="period_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("stu_id")%>" name="stu_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("section_id")%>" name="section_id" size="15"/>
                </td>
                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="classes_past_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="ss_id" value="<%=rs.getInt("ss_id")%>"/>
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
