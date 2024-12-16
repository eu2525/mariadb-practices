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

public class CartDao {
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


	public int insert(CartVo mockCartVo01) {
		int count = 0;

		try (
			Connection conn = getConnection();
			 PreparedStatement pstmt1 = conn.prepareStatement("insert into cart values (?, ?, ?, ?)");				
			 PreparedStatement pstmt2 = conn.prepareStatement("select price from book where no = ?");				
		) {			
			pstmt1.setLong(1, mockCartVo01.getUserNo());
			pstmt1.setLong(2, mockCartVo01.getBookNo());
			// 상품 가격 가져오기;
			int price = 0;
			pstmt2.setLong(1, mockCartVo01.getBookNo());
			ResultSet rs = pstmt2.executeQuery();
			if(rs.next()) {
				price = rs.getInt(1);
			}
			mockCartVo01.setPrice(price * mockCartVo01.getQuantity());

			// 다시 query 완성
			pstmt1.setInt(3, mockCartVo01.getQuantity());
			pstmt1.setInt(4, mockCartVo01.getPrice());
			count = pstmt1.executeUpdate();

			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;	
	}

	public List<CartVo> findByUserNo(Long no) {
		List<CartVo> result = new ArrayList<>();
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select c.user_no, c.book_no, c.quantity, c.price, b.title from book b join cart c on b.no = c.book_no where user_no = ?");	
		) {	
			pstmt.setLong(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Long userNo = rs.getLong(1);
				Long bookNo = rs.getLong(2);
				int quantity = rs.getInt(3);
				int price = rs.getInt(4);
				String title = rs.getString(5);
				
				CartVo vo = new CartVo();
				vo.setUserNo(userNo);
				vo.setBookNo(bookNo);
				vo.setQuantity(quantity);
				vo.setPrice(price);
				vo.setBookTitle(title);
				
				result.add(vo);
			}
			
			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		} 
		
		return result;	
	}


	public int deleteByUserNoAndBookNo(Long userNo, Long bookNo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from cart where user_no = ? and book_no = ?");				
		) {			
			pstmt.setLong(1, userNo);
			pstmt.setLong(2, bookNo);
			count = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;
	}
}
