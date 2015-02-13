<html>

<body>
<h2>Degree Category Entry Form</h2>
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
                    .prepareStatement("INSERT INTO degree_category (degree_id, cate_id, min_unit, min_grade) VALUES (?, ?, ?, ?)");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("degree_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("cate_id")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("min_unit")));
                    pstmt.setFloat(4, Float.parseFloat(request.getParameter("min_grade")));
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
                        .prepareStatement("UPDATE degree_category SET degree_id = ?, cate_id = ?, min_unit = ?, min_grade = ? WHERE dc_id = ? ");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("degree_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("cate_id")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("min_unit")));
                    pstmt.setFloat(4, Float.parseFloat(request.getParameter("min_grade")));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("dc_id")));
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
                        .prepareStatement("DELETE FROM degree_category WHERE dc_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("dc_id")));
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
                rs = statement.executeQuery("SELECT * FROM degree_category dc, category c, degree d WHERE dc.cate_id = c.cate_id AND d.degree_id = dc.degree_id ORDER BY dc_id");
            %>

            <h4>Insert</h4>
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Degree Id</th>
                <th>Category Id</th>
                <th>Min Unit</th>
                <th>Min Grade</th>
            </tr>

            <tr>
                <form action="degree_category_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="degree_id" size="10"/></th>
                    <th><input value="" name="cate_id" size="10"/></th>
                    <th><input value="" name="min_unit" size="10"/></th>
                    <th><input value="" name="min_grade" size="10"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            </table>
            <hr>
            <h4>Modify</h4>
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Degree Id</th>
                <th>Major</th>
                <th>Type</th>
                <th>Category Id</th>
                <th>Category</th>
                <th>Min Unit</th>
                <th>Min Grade</th>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="degree_category_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="dc_id" value="<%=rs.getInt("dc_id")%>"/>

                <td>
                    <%=rs.getInt("dc_id")%>
                </td>

                <td>
                    <input value="<%=rs.getInt("degree_id")%>" name="degree_id" size="15"/>
                </td>

                <td>
                    <%=rs.getString("name")%>
                </td>

                <td>
                    <%=rs.getString("type")%>
                </td>

                <td>
                    <input value="<%=rs.getInt("cate_id")%>" name="cate_id" size="15"/>
                </td>

                <td>
                    <%=rs.getString("cate_name")%>
                </td>

                <td>
                    <input value="<%=rs.getInt("min_unit")%>" name="min_unit" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getFloat("min_grade")%>" name="min_grade" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="degree_category_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="dc_id" value="<%=rs.getInt("dc_id")%>"/>
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
