<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<html>
    <head>

        <title>
            Partlists
        </title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
        
        <style>
            .btn-secondary {
                color: #000;
                background-color: #ffc1078a!important;
                border-color: #ffc1078a!important;
            }
            .bg-light{
                background-color: #7A62CB!important  ;
            }

            .navbar-brand{
                color:aliceblue!important;
                --bs-navbar-brand-hover-color: yellow!important;
            }

            .navbar-brand .nav-item:hover{
                color: pink!important;
            }

            .nav-link{
                color:aliceblue!important;
            }

            .navbar-nav .nav-link.active, .navbar-nav .show>.nav-link {
                color:aliceblue!important;
            }

            .navbar-nav{
                --bs-nav-link-hover-color: yellow!important;
            }

            button, input, optgroup, select, textarea {
                margin: 10;
                font-family: inherit;
                font-size: inherit;
                line-height: inherit;
            }
            .btn-secondary:not(:disabled):not(.disabled).active, .btn-secondary:not(:disabled):not(.disabled):active, .show>.btn-secondary.dropdown-toggle {
                color: #000;
                background-color: #ffc1078a!important;
                border-color: #ffc1078a!important;
            }

            .btn {
                padding-top: 0.15rem!important;
                padding-right: 0.15rem!important;
                padding-bottom: 0.15rem!important;
                padding-left: 0.15rem!important;
            }

            .signOut {
                border: none;
                background: none;
                color:aliceblue!important;
            }
            .center {
                margin: 0;
                position: absolute;
                top: 40%;
                left: 50%;
                -ms-transform: translate(-50%, -50%);
                transform: translate(-50%, -50%);
                text-align:center;
            }
        </style>
        
    </head>

    <body>
        <div>
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container">
                <a class="navbar-brand" href="/CS157A-team4/home.jsp">
                    <img alt src="logo.png" width="50" height="50">
                    Mechanical Keyboard Builder
                </a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                      <button class="signOut"><a href="partlists.jsp" class="signOut">Part Lists</a></button>
                    </li>
                    <li class="nav-item">
                        <form action="login.jsp" method="post" value = "Sign Out" name="signOut">
                          <button type="submit" class="signOut" value = "Sign Out" name="signOut">Sign Out</button>
                        </form>
                      </li>
                </ul>
                </div>
              </div>
            </nav>
          </div>

        <div>
            <% 
                String user = (String) session.getAttribute("dbuser");
                String password = (String) session.getAttribute("dbpassword");
                try {
                    java.sql.Connection con; 
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mkdb?autoReconnect=true&useSSL=false",user, password);
                    Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                    String username = (String) session.getAttribute("username");
                    String pList = (String) request.getParameter("viewPartList");
                    String partListID = "";
                    if(pList != null && pList.equals("View Part List")){
                        partListID = request.getParameter("partListID");
                    }

                    // add part code
                    String add = request.getParameter("addPart");
                    String partId = "";
                    ResultSet rs = stmt.executeQuery("SELECT * FROM mkdb.partlist WHERE PartListID='" + partListID + "'");
                    
                    if (add != null && add.equals("Add Part")) {
                        partId = request.getParameter("addPartID"); // get substring of partID
                        partListID = request.getParameter("partListID");    //get current part list
                        String prefix = partId.substring(0, 2);

                        // execute insertion query
                        rs = stmt.executeQuery("SELECT * FROM mkdb.partlist WHERE PartListID='" + partListID + "'");
                        rs.beforeFirst();
                        rs.next();

                        // check prefix of string
                        Map<String, String> dict = new HashMap<String, String>();
                        dict.put("SW", "switches_id");
                        dict.put("PB", "prebuilt_id");
                        dict.put("PC", "pcb_id");
                        dict.put("SB", "stab_id");
                        dict.put("KC", "keycaps_id");
                        dict.put("CS", "case_id");
                        dict.put("AC", "accessories_id");
                        
                        // print the values
                        // out.println(partListID);
                        // out.println(dict.get(prefix));
                        // out.println(partId);

                        // update row
                        rs.updateString(dict.get(prefix), partId);
                        rs.updateRow();
                        // response.sendRedirect("partlist.jsp");
                    }

                    String remove = request.getParameter("Delete");
                    if(remove != null && remove.equals(request.getParameter("Delete"))){
                        partId = request.getParameter("partID"); // get substring of partID
                        partListID = request.getParameter("partListID");    //get current part list

                        String prefix = partId.substring(0, 2);

                        rs = stmt.executeQuery("SELECT * FROM mkdb.partlist WHERE PartListID='" + partListID + "'");
                        rs.beforeFirst();
                        rs.next();

                        // check prefix of string
                        Map<String, String> dict = new HashMap<String, String>();
                        dict.put("SW", "switches_id");
                        dict.put("PB", "prebuilt_id");
                        dict.put("PC", "pcb_id");
                        dict.put("SB", "stab_id");
                        dict.put("KC", "keycaps_id");
                        dict.put("CS", "case_id");
                        dict.put("AC", "accessories_id");

                        rs.updateString(dict.get(prefix), null);
                        rs.updateRow();
                    }

                    //use this to refer to the current partlistid and partid
                    rs = stmt.executeQuery("SELECT * FROM mkdb.partlist WHERE PartListID='" + partListID + "'");
                    rs.beforeFirst();
                    rs.next();

                    partListID = rs.getString("PartListID");
                    String prebuilt_id = rs.getString("prebuilt_id");
                    String pcb_id = rs.getString("pcb_id");
                    String accessories_id = rs.getString("accessories_id");
                    String switches_id = rs.getString("switches_id");
                    String case_id = rs.getString("case_id");
                    String stab_id = rs.getString("stab_id");
                    String keycaps_id = rs.getString("keycaps_id");

            %>
                        <h3>Prebuilt</h3>
                                    <% 
                                            ResultSet rs1 = stmt.executeQuery("SELECT  brand, URL, name, price, seller, switchName, hotSwappable FROM keyboardpart NATURAL JOIN prebuilt, partlist WHERE partlist.username = '" + username + "' AND prebuilt_id = keyboardpart.partID AND PartListID = '" + partListID + "'");
                                            rs1.beforeFirst();
                                            if (!rs1.next()) {
                                    %>
                                                <form action='prebuilts.jsp' method='post'>
                                                    <input type='submit' class="btn btn-primary" value='Add Prebuilt' name='addCase'>
                                                    <input type='hidden' value='<%=partListID%>' name="partListID">
                                                </form>
                                        <%
                                            } else {
                                                rs1.beforeFirst();
                                                rs1.next();
                                                String prebuilt_brand = rs1.getString(1);
                                                String prebuilt_url = rs1.getString(2);
                                                String prebuilt_name = rs1.getString(3);
                                                String prebuilt_price = rs1.getString(4);
                                                String prebuilt_seller = rs1.getString(5);
                                                String prebuilt_switchName = rs1.getString(6);
                                                String prebuilt_hotswappable = rs1.getString(7);
                                        %>
                                        <table width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Brand</th>
                                                    <th>Name</th>
                                                    <th>Price</th>
                                                    <th>URL</th>
                                                    <th>Seller</th>
                                                    <th>Switch Name</th>
                                                    <th>Hotswappable</th>
                                                    <th>Delete</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                <td><%out.println(prebuilt_brand);%></td>
                                                <td><%out.println(prebuilt_name);%></td>
                                                <td><%out.println(prebuilt_price);%></td>
                                                <td>
                                                    <a href=<%= prebuilt_url%> target="_blank" rel="noopener noreferrer">Buy</a>
                                                </td>
                                                <td><%out.println(prebuilt_seller);%></td>
                                                <td><%out.println(prebuilt_switchName);%></td>
                                                <td><%out.println(prebuilt_hotswappable);%></td>
                                                <td>
                                                        <form action='partlist.jsp' method='post'>
                                                            <input type='submit' class="btn btn-danger" value='Delete' name='Delete'>
                                                            <input type='hidden' value="<%=prebuilt_id%>" name='partID'>
                                                            <input type='hidden' value="<%=partListID%>" name="partListID">
                                                        </form>
                                                    </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <%
                                            }
                                    %>
                        <br></br>
                        <h3>PCB</h3>
                                    <%
                                            ResultSet rs2 = stmt.executeQuery("SELECT brand, name, url, price, seller, containsRGB, hotSwappable, size FROM keyboardpart NATURAL JOIN pcb, partlist WHERE partlist.username = '" + username + "' AND pcb_id = keyboardpart.partID AND PartListID = '" + partListID + "'");
                                            rs2.beforeFirst();
                                            if (!rs2.next()) {
                                    %>
                                                <form action='pcb.jsp' method='post'>
                                                    <input type='submit' class="btn btn-primary" value='Add PCB' name='addCase'>
                                                    <input type='hidden' value='<%=partListID%>' name="partListID">
                                                </form>
                                        <%
                                            } else {
                                                rs2.beforeFirst();
                                                rs2.next();
                                                String prebuilt_brand = rs2.getString(1);
                                                String prebuilt_name = rs2.getString(2);
                                                String prebuilt_url = rs2.getString(3);
                                                String prebuilt_price = rs2.getString(4);
                                                String prebuilt_seller = rs2.getString(5);
                                                String prebuilt_containsRGB = rs2.getString(6);
                                                String prebuilt_hotswappable = rs2.getString(7);
                                                String prebuilt_size = rs2.getString(8);
                                        %>
                                        <table width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Brand</th>
                                                    <th>Name</th>
                                                    <th>Price</th>
                                                    <th>URL</th>
                                                    <th>Seller</th>
                                                    <th>ContainsRGB</th>
                                                    <th>Hotswappable</th>
                                                    <th>Size</th>
                                                    <th>Delete</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                <td><%out.println(prebuilt_brand);%></td>
                                                <td><%out.println(prebuilt_name);%></td>
                                                <td><%out.println(prebuilt_price);%></td>
                                                <td>
                                                    <a href=<%= prebuilt_url%> target="_blank" rel="noopener noreferrer">Buy</a>
                                                </td>
                                                <td><%out.println(prebuilt_seller);%></td>
                                                <td><%out.println(prebuilt_containsRGB);%></td>
                                                <td><%out.println(prebuilt_hotswappable);%></td>
                                                <td><%out.println(prebuilt_size);%></td>
                                                <td>
                                                <form action='partlist.jsp' method='post'>
                                                    <input type='submit' class="btn btn-danger" value='Delete' name='Delete'>
                                                    <input type='hidden' value="<%=pcb_id%>" name='partID'>
                                                    <input type='hidden' value="<%=partListID%>" name="partListID">
                                                </form>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <%
                                            }
                                    %>
                        <br></br>
                        <h3>Accessories</h3>

                                    <%
                                            ResultSet rs3 = stmt.executeQuery("SELECT brand, name, price, URL, seller, type FROM keyboardpart NATURAL JOIN accessories, partlist WHERE partlist.username = '" + username + "' AND accessories_id = keyboardpart.partID AND PartListID = '" + partListID + "'");
                                            rs3.beforeFirst();
                                            if (!rs3.next()) {
                                    %>
                                                <form action='accessories.jsp' method='post'>
                                                    <input type='submit' class="btn btn-primary" value='Add Accessories' name='addCase'>
                                                    <input type='hidden' value='<%=partListID%>' name="partListID">
                                                </form>
                                        <%
                                            } else {
                                                rs3.beforeFirst();
                                                rs3.next();
                                                String prebuilt_brand = rs3.getString(1);
                                                String prebuilt_name = rs3.getString(2);
                                                String prebuilt_price = rs3.getString(3);
                                                String prebuilt_url = rs3.getString(4);
                                                String prebuilt_seller = rs3.getString(5);
                                                String prebuilt_type = rs3.getString(6);
                                        %>
                                        <table width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Brand</th>
                                                    <th>Name</th>
                                                    <th>Price</th>
                                                    <th>URL</th>
                                                    <th>Seller</th>
                                                    <th>Type</th>
                                                    <th>Delete</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><%out.println(prebuilt_brand);%></td>
                                                    <td><%out.println(prebuilt_name);%></td>
                                                    <td><%out.println(prebuilt_price);%></td>
                                                    <td>
                                                        <a href=<%= prebuilt_url%> target="_blank" rel="noopener noreferrer">Buy</a>
                                                    </td>
                                                    <td><%out.println(prebuilt_seller);%></td>
                                                    <td><%out.println(prebuilt_type);%></td>
                                                    <td><button type="button" class="btn btn-danger">Delete</button></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    <%
                                            }
                                    %>
                        <br></br>
                        <h2>Switches</h2>
                                    <%
                                            ResultSet rs4 = stmt.executeQuery("SELECT  brand, URL, name, price, seller, type, stem FROM keyboardpart NATURAL JOIN switches, partlist WHERE partlist.username = '" + username + "' AND switches_id = keyboardpart.partID AND PartListID = '" + partListID + "'");
                                            rs4.beforeFirst();
                                            if (!rs4.next()) {
                                    %>
                                                <form action='switches.jsp' method='post'>
                                                    <input type='submit' class="btn btn-primary" value='Add Switches' name='addCase'>
                                                    <input type='hidden' value='<%=partListID%>' name="partListID">
                                                </form>
                                        <%
                                            } else {
                                                rs4.beforeFirst();
                                                rs4.next();
                                                String prebuilt_brand = rs4.getString(1);
                                                String prebuilt_url = rs4.getString(2);
                                                String prebuilt_name = rs4.getString(3);
                                                String prebuilt_price = rs4.getString(4);
                                                String prebuilt_seller = rs4.getString(5);
                                                String prebuilt_type = rs4.getString(6);
                                                String prebuilt_stem = rs4.getString(7);
                                        %>
                                        <table width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Brand</th>
                                                    <th>Name</th>
                                                    <th>Price</th>
                                                    <th>URL</th>
                                                    <th>Seller</th>
                                                    <th>Type</th>
                                                    <th>Stem</th>
                                                    <th>Delete</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                <td><%out.println(prebuilt_brand);%></td>
                                                <td><%out.println(prebuilt_name);%></td>
                                                <td><%out.println(prebuilt_price);%></td>
                                                <td>
                                                    <a href=<%= prebuilt_url%> target="_blank" rel="noopener noreferrer">Buy</a>
                                                </td>
                                                <td><%out.println(prebuilt_seller);%></td>
                                                <td><%out.println(prebuilt_type);%></td>
                                                <td><%out.println(prebuilt_stem);%></td>
                                                <td>
                                                        <form action='partlist.jsp' method='post'>
                                                            <input type='submit' class="btn btn-danger" value='Delete' name='Delete'>
                                                            <input type='hidden' value="<%=switches_id%>" name='partID'>
                                                            <input type='hidden' value="<%=partListID%>" name="partListID">
                                                        </form>
                                                    </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <%
                                            }
                                    %>            
                        <br></br>
                        <h2>Case</h2>
                                    <%
                                            //out.println(partListID);
                                            ResultSet rs5 = stmt.executeQuery("SELECT  brand, URL, name, price, seller, size FROM keyboardpart NATURAL JOIN kbcase, partlist WHERE partlist.username = '" + username + "' AND case_id = keyboardpart.partID AND PartListID = '" + partListID + "'");
                                            rs5.beforeFirst();
                                            if (!rs5.next()) {
                                    %>
                                                <form action='cases.jsp' method='post'>
                                                    <input type='submit' class="btn btn-primary" value='Add Case' name='addCase'>
                                                    <input type='hidden' value='<%=partListID%>' name="partListID">
                                                </form>
                                        <%
                                            } else {
                                                rs5.beforeFirst();
                                                rs5.next();
                                                String prebuilt_brand = rs5.getString(1);
                                                String prebuilt_url = rs5.getString(2);
                                                String prebuilt_name = rs5.getString(3);
                                                String prebuilt_price = rs5.getString(4);
                                                String prebuilt_seller = rs5.getString(5);
                                                String prebuilt_size = rs5.getString(6);
                                        %>
                                        <table width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Brand</th>
                                                    <th>Name</th>
                                                    <th>Price</th>
                                                    <th>URL</th>
                                                    <th>Seller</th>
                                                    <th>Size</th>
                                                    <th>Delete</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><%out.println(prebuilt_brand);%></td>
                                                    <td><%out.println(prebuilt_name);%></td>
                                                    <td><%out.println(prebuilt_price);%></td>
                                                    <td>
                                                        <a href=<%= prebuilt_url%> target="_blank" rel="noopener noreferrer">Buy</a>
                                                    </td>
                                                    <td><%out.println(prebuilt_seller);%></td>
                                                    <td><%out.println(prebuilt_size);%></td>
                                                    <td>
                                                        <form action='partlist.jsp' method='post'>
                                                            <input type='submit' class="btn btn-danger" value='Delete' name='Delete'>
                                                            <input type='hidden' value="<%=case_id%>" name='partID'>
                                                            <input type='hidden' value="<%=partListID%>" name="partListID">
                                                        </form>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    <%
                                            }
                                    %>            
                        <br></br>
                        <h2>Stabilizer</h2>
                                    <%
                                            ResultSet rs6 = stmt.executeQuery("SELECT  brand, URL, name, price, seller, stabtype, info FROM keyboardpart NATURAL JOIN stabilizers, partlist WHERE partlist.username = '" + username + "' AND stab_id = keyboardpart.partID AND PartListID = '" + partListID + "'");
                                            rs6.beforeFirst();
                                            if (!rs6.next()) {
                                    %>
                                                <form action='stabs.jsp' method='post'>
                                                    <input type='submit' class="btn btn-primary" value='Add Stabilizers' name='addCase'>
                                                    <input type='hidden' value='<%=partListID%>' name="partListID">
                                                </form>
                                        <%
                                            } else {
                                                rs6.beforeFirst();
                                                rs6.next();
                                                String prebuilt_brand = rs6.getString(1);
                                                String prebuilt_url = rs6.getString(2);
                                                String prebuilt_name = rs6.getString(3);
                                                String prebuilt_price = rs6.getString(4);
                                                String prebuilt_seller = rs6.getString(5);
                                                String prebuilt_stabType = rs6.getString(6);
                                                String prebuilt_info = rs6.getString(7);
                                        %>
                                        <table width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Brand</th>
                                                    <th>Name</th>
                                                    <th>Price</th>
                                                    <th>URL</th>
                                                    <th>Seller</th>
                                                    <th>Stabilizer Type</th>
                                                    <th>Info</th>
                                                    <th>Delete</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                <td><%out.println(prebuilt_brand);%></td>
                                                <td><%out.println(prebuilt_name);%></td>
                                                <td><%out.println(prebuilt_price);%></td>
                                                <td>
                                                    <a href=<%= prebuilt_url%> target="_blank" rel="noopener noreferrer">Buy</a>
                                                </td>
                                                <td><%out.println(prebuilt_seller);%></td>
                                                <td><%out.println(prebuilt_stabType);%></td>
                                                <td><%out.println(prebuilt_info);%></td>
                                                <td>
                                                        <form action='partlist.jsp' method='post'>
                                                            <input type='submit' class="btn btn-danger" value='Delete' name='Delete'>
                                                            <input type='hidden' value="<%=stab_id%>" name='partID'>
                                                            <input type='hidden' value="<%=partListID%>" name="partListID">
                                                        </form>
                                                    </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <%
                                            }
                                    %>            
                        <br></br>
                        <h2>Keycaps</h2>
                                    <%
                                            ResultSet rs7 = stmt.executeQuery("SELECT  brand, URL, name, price, seller, profile, material, PartID FROM keyboardpart NATURAL JOIN keycaps, partlist WHERE partlist.username = '" + username + "' AND keycaps_id = keyboardpart.partID AND PartListID = '" + partListID + "'");
                                            rs7.beforeFirst();
                                            if (!rs7.next()) {
                                    %>
                                                <form action='keycaps.jsp' method='post'>
                                                    <input type='submit' class="btn btn-primary" value='Add Keycaps' name='addCase'>
                                                    <input type='hidden' value='<%=partListID%>' name="partListID">
                                                </form>
                                        <%
                                            } else {
                                                rs7.beforeFirst();
                                                rs7.next();
                                                String prebuilt_brand = rs7.getString(1);
                                                String prebuilt_url = rs7.getString(2);
                                                String prebuilt_name = rs7.getString(3);
                                                String prebuilt_price = rs7.getString(4);
                                                String prebuilt_seller = rs7.getString(5);
                                                String prebuilt_profile = rs7.getString(6);
                                                String prebuilt_material = rs7.getString(7);
                                        %>
                                        <table width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Brand</th>
                                                    <th>Name</th>
                                                    <th>Price</th>
                                                    <th>URL</th>
                                                    <th>Seller</th>
                                                    <th>Profile</th>
                                                    <th>Material</th>
                                                    <th>Delete</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                <td><%out.println(prebuilt_brand);%></td>
                                                <td><%out.println(prebuilt_name);%></td>
                                                <td><%out.println(prebuilt_price);%></td>
                                                <td>
                                                    <a href=<%= prebuilt_url%> target="_blank" rel="noopener noreferrer">Buy</a>
                                                </td>
                                                <td><%out.println(prebuilt_seller);%></td>
                                                <td><%out.println(prebuilt_profile);%></td>
                                                <td><%out.println(prebuilt_material);%></td>
                                                <td>
                                                        <form action='partlist.jsp' method='post'>
                                                            <input type='submit' class="btn btn-danger" value='Delete' name='Delete'>
                                                            <input type='hidden' value="<%=keycaps_id%>" name='partID'>
                                                            <input type='hidden' value="<%=partListID%>" name="partListID">
                                                        </form>
                                                    </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <%
                                            }
                                    %>            
                                
                        
            <%
                    rs.close();
                    stmt.close();
                    con.close();
                } catch(SQLException e) { 
                    out.println("SQLException caught: " + e.getMessage()); 
                }
            %>
		</div>
    </body>
</html>
