package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CartVo;
import bookmall.vo.CategoryVo;
import bookmall.vo.UserVo;

public class CategoryDao {
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
	
	public int insert(CategoryVo mockCategoryVo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			 PreparedStatement pstmt1 = conn.prepareStatement("insert into category values (null, ?)");				
			 PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");				
		) {			
			pstmt1.setString(1, mockCategoryVo.getCategory());
			count = pstmt1.executeUpdate();

			ResultSet rs = pstmt2.executeQuery();
			mockCategoryVo.setNo(rs.next() ? rs.getLong(1) : null);
			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;		
	}

	public List<CategoryVo> findAll() {
		List<CategoryVo> result = new ArrayList<>();
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select * from category");	
		) {	
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Long no = rs.getLong(1);
				String category = rs.getString(2);

				CategoryVo vo = new CategoryVo(category);
				vo.setNo(no);
				
				result.add(vo);
			}
			
			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		} 
		
		return result;	
	}

	public int deleteByNo(Long categoryNo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from category where no = ?");				
		) {			
			pstmt.setLong(1, categoryNo);
			count = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;
	}
}
