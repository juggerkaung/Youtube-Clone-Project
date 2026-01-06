package JDBCConnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
public static Connection getConnection() throws ClassNotFoundException {

	    Connection con = null;
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        try {
			con = DriverManager.getConnection("jdbc:mysql://localhost:3307/youtube_simple","root","root");
			System.out.println("Connection Successful!");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("Connection not found!!");
			e.printStackTrace();
		}
        return con;
		
	}

}
