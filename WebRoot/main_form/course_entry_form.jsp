<html>

<body>
<h2>Course Entry Form</h2>
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
                    .prepareStatement("INSERT INTO course (course_number, min_unit, max_unit, grade_option, need_lab, need_consent, cate_id, pre_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

                    pstmt.setString(1, request.getParameter("course_number"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("min_unit")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("max_unit")));
                    pstmt.setString(4, request.getParameter("grade_option"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("need_lab")));
                    pstmt.setInt(6, Integer.parseInt(request.getParameter("need_consent")));
                    pstmt.setInt(7, Integer.parseInt(request.getParameter("cate_id")));
                    pstmt.setInt(8, Integer.parseInt(request.getParameter("pre_id")));

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
                        .prepareStatement("UPDATE course SET course_number = ?, min_unit = ?, max_unit = ?, grade_option = ?, need_lab = ?, need_consent = ?, cate_id = ?, pre_id = ? WHERE course_id = ? ");

                    pstmt.setString(1, request.getParameter("course_number"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("min_unit")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("max_unit")));
                    pstmt.setString(4, request.getParameter("grade_option"));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("need_lab")));
                    pstmt.setInt(6, Integer.parseInt(request.getParameter("need_consent")));
                    pstmt.setInt(7, Integer.parseInt(request.getParameter("cate_id")));
                    pstmt.setInt(8, Integer.parseInt(request.getParameter("pre_id")));
                    pstmt.setInt(9, Integer.parseInt(request.getParameter("course_id")));

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
                        .prepareStatement("DELETE FROM course WHERE course_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
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
                rs = statement.executeQuery("SELECT * FROM course ORDER BY course_id");
            %>

            <h4>Insert</h4>
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Course Number</th>
                <th>Min Unit</th>
                <th>Max Unit</th>
                <th>Grade Option</th>
                <th>Need Lab</th>
                <th>Need Consent</th>
                <th>Category</th>
                <th>Prerequisite</th>
            </tr>

            <tr>
                <form action="course_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="course_number" size="15"/></th>
                    <th><input value="" name="min_unit" size="15"/></th>
                    <th><input value="" name="max_unit" size="15"/></th>
                    <th>
                      <select name="grade_option">
                        <option value="letter">letter</option>
                        <option value="su">su</option>
                        <option value="both">both</option>
                      </select>
                    </th>
                    <th>
                      <select name="need_lab">
                        <option value="0">0</option>
                        <option value="1">1</option>
                      </select>
                    </th>
                    <th>
                      <select name="need_consent">
                        <option value="0">0</option>
                        <option value="1">1</option>
                      </select>
                    </th>
                    <th><input value="" name="cate_id" size="15"/></th>
                    <th><input value="" name="pre_id" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>
            </table>

            <h4>Modify</h4>
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Course Number</th>
                <th>Min Unit</th>
                <th>Max Unit</th>
                <th>Grade Option</th>
                <th>Need Lab</th>
                <th>Need Consent</th>
                <th>Category</th>
                <th>Prerequisite</th>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="course_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="course_id" value="<%=rs.getInt("course_id")%>"/>

                <td>
                    <%=rs.getInt("course_id")%>
                </td>

                <td>
                    <input value="<%=rs.getString("course_number")%>" name="course_number" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("min_unit")%>" name="min_unit" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("max_unit")%>" name="max_unit" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("grade_option")%>" name="grade_option" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("need_lab")%>" name="need_lab" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("need_consent")%>" name="need_consent" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("cate_id")%>" name="cate_id" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getInt("pre_id")%>" name="pre_id" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="course_entry_form.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="course_id" value="<%=rs.getInt("course_id")%>"/>
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
