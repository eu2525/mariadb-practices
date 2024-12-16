package bookmall.vo;

public class CategoryVo {
	private Long no;
	private String category;

	public CategoryVo(String category) {
		this.category = category;
	}
	public Long getNo() {
		return no;
	}
	public void setNo(Long no) {
		this.no = no;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	
	@Override
	public String toString() {
		return "CategoryVo [no=" + no + ", category=" + category + "]";
	}
}
