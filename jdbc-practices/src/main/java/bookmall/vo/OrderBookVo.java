package bookmall.vo;

public class OrderBookVo {
	private Long bookNo;
	private Long orderNo;
	private int quantity;
	private int price;
	private String bookTitle;
	
	public Long getBookNo() {
		return bookNo;
	}
	public void setBookNo(Long bookNumber) {
		this.bookNo = bookNumber;
	}
	
	public Long getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(Long ordersNo) {
		this.orderNo = ordersNo;
	}
	
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getBookTitle() {
		return bookTitle;
	}
	public void setBookTitle(String bookTitle) {
		this.bookTitle = bookTitle;
	}
	
}
