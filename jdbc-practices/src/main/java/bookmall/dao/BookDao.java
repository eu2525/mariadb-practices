package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import bookmall.vo.BookVo;

public class BookDao {

	private Connection getConnection() throws SQLException{
		Connection conn = null;
		
		try {
			Class.forName("org.mariadb.jdbc.Driver");
		
			String url = "jdbc:mariadb://192.168.0.10:3306/bookmall";
			conn = DriverManager.getConnection(url, "bookmall", "bookmall");
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패:" + e);
		} 
		
		return conn;
	}

	
	public int insert(BookVo vo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			 PreparedStatement pstmt1 = conn.prepareStatement("insert into book values (null, ?, ?, ?)");				
			 PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");				
		) {			
			pstmt1.setLong(1, vo.getCategoryNo());
			pstmt1.setString(2, vo.getTitle());
			pstmt1.setInt(3, vo.getPrice());
			count = pstmt1.executeUpdate();

			ResultSet rs = pstmt2.executeQuery();
			vo.setNo(rs.next() ? rs.getLong(1) : null);
			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;		
	}


	public int deleteByNo(Long bookNo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from book where no = ?");				
		) {			
			pstmt.setLong(1, bookNo);
			count = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;
	}	

}
