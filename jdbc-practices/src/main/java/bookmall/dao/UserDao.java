package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CartVo;
import bookmall.vo.UserVo;
import bookshop.vo.BookVo;

public class UserDao {
	
	private Connection getConnection() throws SQLException {
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
		

	public int insert(UserVo mockUserVo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			 PreparedStatement pstmt1 = conn.prepareStatement("insert into user values (null,?,?,?,?)");				
			 PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");				
		) {			
			pstmt1.setString(1, mockUserVo.getName());
			pstmt1.setString(2, mockUserVo.getEmail());
			pstmt1.setString(3, mockUserVo.getPassword());
			pstmt1.setString(4, mockUserVo.getPhoneNumber());
			count = pstmt1.executeUpdate();

			ResultSet rs = pstmt2.executeQuery();
			mockUserVo.setNo(rs.next() ? rs.getLong(1) : null);
			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;	
	}

	public List<UserVo> findAll() {
		List<UserVo> result = new ArrayList<>();
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select * from user");	
		) {	
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Long no = rs.getLong(1);
				String name = rs.getString(2);
				String email = rs.getString(3);
				String password = rs.getString(4);
				String phoneNumber = rs.getString(5);
				
				UserVo vo = new UserVo(name, email, password, phoneNumber);
				vo.setNo(no);
				
				result.add(vo);
			}
			
			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		} 
		
		return result;		
	}


	public int deleteByNo(Long userNo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from user where no = ?");				
		) {			
			pstmt.setLong(1, userNo);
			count = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;
	}
}