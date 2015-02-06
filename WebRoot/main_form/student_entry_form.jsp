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
                    .prepareStatement("INSERT INTO student (first_name, middle_name, last_name, citizen, ssn, pre_school, pre_degree, pre_major) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

                    pstmt.setString(1, request.getParameter("first"));
                    pstmt.setString(2, request.getParameter("middle"));
                    pstmt.setString(3, request.getParameter("last"));
                    pstmt.setString(4, request.getParameter("citizen"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("ssn")));
                    pstmt.setString(6, request.getParameter("pre_school"));
                    pstmt.setString(7, request.getParameter("pre_degree"));
                    pstmt.setString(8, request.getParameter("pre_major"));
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
                        .prepareStatement("UPDATE student SET first_name = ?, middle_name = ?, last_name = ?, citizen = ?, ssn = ?, pre_school = ?, pre_degree = ?, pre_major = ? WHERE stu_id = ? ");

                    pstmt.setString(1, request.getParameter("first"));
                    pstmt.setString(2, request.getParameter("middle"));
                    pstmt.setString(3, request.getParameter("last"));
                    pstmt.setString(4, request.getParameter("citizen"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("ssn")));
                    pstmt.setString(6, request.getParameter("pre_school"));
                    pstmt.setString(7, request.getParameter("pre_degree"));
                    pstmt.setString(8, request.getParameter("pre_major"));
                    pstmt.setInt(9, Integer.parseInt(request.getParameter("stu_id")));

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
                        .prepareStatement("DELETE FROM student WHERE stu_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("stu_id")));
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
                rs = statement.executeQuery("SELECT * FROM student");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>First Name</th>
                <th>Middle Name</th>
                <th>Last Name</th>
                <th>citizen</th>
                <th>ssn</th>
                <th>Pre School</th>
                <th>Pre Degree</th>
                <th>Pre Major</th>
            </tr>

            <tr>
                <form action="student_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="first" size="15"/></th>
                    <th><input value="" name="middle" size="15"/></th>
                    <th><input value="" name="last" size="15"/></th>
                    <th><input value="" name="citizen" size="15"/></th>
                    <th><input value="" name="ssn" size="15"/></th>
                    <th><input value="" name="pre_school" size="15"/></th>
                    <th><input value="" name="pre_degree" size="15"/></th>
                    <th><input value="" name="pre_major" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="student_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="stu_id" value="<%=rs.getInt("stu_id")%>"/>

                <td>
                    <%=rs.getInt("stu_id")%>
                </td>

                <td>
                    <input value="<%=rs.getString("first_name")%>" name="first" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("middle_name")%>" name="middle" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("last_name")%>" name="last" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("citizen")%>" name="citizen" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("ssn")%>" name="ssn" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("pre_school")%>" name="pre_school" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("pre_degree")%>" name="pre_degree" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("pre_major")%>" name="pre_major" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="student_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="stu_id" value="<%=rs.getInt("stu_id")%>"/>
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
