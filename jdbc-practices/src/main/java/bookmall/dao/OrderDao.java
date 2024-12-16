package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CartVo;
import bookmall.vo.OrderBookVo;
import bookmall.vo.OrderVo;
import bookmall.vo.UserVo;

public class OrderDao {
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
	
	public int insert(OrderVo mockOrderVo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			 PreparedStatement pstmt1 = conn.prepareStatement("insert into orders values (null, ?, ?, ?, ?, ?, null)");				
			 PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");				
		) {			
			pstmt1.setString(1, mockOrderVo.getNumber());
			pstmt1.setLong(2, mockOrderVo.getUserNo());
			pstmt1.setInt(3, mockOrderVo.getPayment());
			pstmt1.setString(4, mockOrderVo.getStatus());
			pstmt1.setString(5, mockOrderVo.getShipping());
			count = pstmt1.executeUpdate();
			
			ResultSet rs = pstmt2.executeQuery();
			mockOrderVo.setNo(rs.next() ? rs.getLong(1) : null);
			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;		
	}

	public int insertBook(OrderBookVo mockOrderBookVo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			 PreparedStatement pstmt = conn.prepareStatement("insert into orders_book values (?, ?, ?, ?)");				
		) {			
			pstmt.setLong(1, mockOrderBookVo.getOrderNo());
			pstmt.setLong(2, mockOrderBookVo.getBookNo());
			pstmt.setInt(3, mockOrderBookVo.getQuantity());
			pstmt.setInt(4, mockOrderBookVo.getPrice());
			count = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;	
	}

	
	public OrderVo findByNoAndUserNo(Long orderNo, Long userNo) {	
		OrderVo vo = null;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select * from orders where no = ? and user_no = ?");	
		) {	
			pstmt.setLong(1, orderNo);
			pstmt.setLong(2, userNo);
			
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				vo = new OrderVo();

				vo.setNo(rs.getLong(1));
				vo.setNumber(rs.getString(2));
				vo.setUserNo(rs.getLong(3));
				vo.setPayment(rs.getInt(4));
				vo.setStatus(rs.getString(5));				
				vo.setShipping(rs.getString(6));
				vo.setUserName(rs.getString(7));
			}
						
			rs.close();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		} 
		
		return vo;	
	}

	public List<OrderBookVo> findBooksByNoAndUserNo(Long orderNo, Long userNo) {
		List<OrderBookVo> result = new ArrayList<>();
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select ob.orders_no, ob.book_no, ob.quantity, ob.price, b.title from orders_book ob join book b on ob.book_no = b.no  where orders_no = ?");	
		) {	
			pstmt.setLong(1, orderNo);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Long ordersNo = rs.getLong(1);
				Long booksNo = rs.getLong(2);
				int quantity = rs.getInt(3);
				int price = rs.getInt(4);
				String title = rs.getString(5);

				OrderBookVo vo = new OrderBookVo();
				vo.setOrderNo(ordersNo);
				vo.setBookNo(booksNo);
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

	public int deleteBooksByNo(Long orderNo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from orders_book where orders_no = ?");				
		) {			
			pstmt.setLong(1, orderNo);
			count = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;		
	}

	public int deleteByNo(Long orderNo) {
		int count = 0;

		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from orders where no = ?");				
		) {			
			pstmt.setLong(1, orderNo);
			count = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		
		return count;	
		
	}
	
}
