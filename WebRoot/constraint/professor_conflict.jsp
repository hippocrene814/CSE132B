<html>

<body>
<h2>Professor Conflict</h2>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="/view_menu.html" />
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
                    .prepareStatement("INSERT INTO section (section_limit, class_id, fac_id, section_id) VALUES (?, ?, ?, ?)");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("section_limit")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("class_id")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("fac_id")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("section_id")));

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
                        .prepareStatement("UPDATE section SET section_limit = ?, class_id = ?, fac_id = ? WHERE section_id = ? ");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("section_limit")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("class_id")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("fac_id")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("section_id")));

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
                        .prepareStatement("DELETE FROM section WHERE section_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("section_id")));
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
                rs = statement.executeQuery("SELECT * FROM section ORDER BY section_id");
                rs = statement.executeQuery("SELECT * FROM section s, class c WHERE s.class_id = c.class_id ORDER BY section_id");
            %>

            <a href="../extra_form/meeting_entry_form.jsp">Meeting Entry Form</a>
            <h4>Insert</h4>
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Class Id</th>
                <th>Faculty Id</th>
                <th>Number Limit</th>
            </tr>

            <tr>
                <form action="professor_conflict.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="section_id" size="15"/></th>
                    <th><input value="" name="class_id" size="15"/></th>
                    <th><input value="" name="fac_id" size="15"/></th>
                    <th><input value="" name="section_limit" size="15"/></th>

                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>
            </table>
            <hr>
            <h4>Modify</h4>
            <table border="1">
            <tr>
                <th>Section ID</th>
                <th>Class Id</th>
                <th>Faculty Id</th>
                <th>Number Limit</th>
                <th>Class Title</th>
                <th>Year</th>
                <th>Quarter</th>
            </tr>
            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
            <tr>
                <form action="professor_conflict.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="section_id" value="<%=rs.getInt("section_id")%>"/>

                <td>
                    <%=rs.getInt("section_id")%>
                </td>

                <td>
                    <input value="<%=rs.getInt("class_id")%>" name="class_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("fac_id")%>" name="fac_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("section_limit")%>" name="section_limit" size="15"/>
                </td>

                <td>
                    <%=rs.getString("title")%>
                </td>

                <td>
                    <%=rs.getInt("year")%>
                </td>

                <td>
                    <%=rs.getString("quarter")%>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="professor_conflict.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="section_id" value="<%=rs.getInt("section_id")%>"/>
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
