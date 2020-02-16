<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@ page errorPage="../error/error.jsp"
	import="java.sql.*,
javax.sql.*,
java.io.*"%>
</head>
<body>
	<h1>JDBC Test</h1>

	<%
		System.out.println("JDBC 연결 TEST");
		// localhost
		//Class.forName("org.mariadb.jdbc.Driver");
		//Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/test_morahaji", "root",
		//		"1234");
		// cafe24
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/joyrapture", "joyrapture",
				"Qlqjs0987!");
		Statement stmt = conn.createStatement();
		ResultSet rset = stmt.executeQuery("show tables");
		ArrayList<String> tables = new ArrayList<String>();
		while (rset.next()) {
			tables.add(rset.getString(1));
		}
		rset.close();
		stmt.close();
		conn.close();
	%>
	<p><%=tables%></p>
	<c:forEach var="table" items="<%=tables%>">
		<p>${table}</p>
	</c:forEach>
	<c:if test="<%=tables.size() <= 0%>">
		<p>table이 없음.</p>
	</c:if>
</body>
</html>