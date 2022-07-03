package pojo;

import java.util.List;

public class UserPage {
    public static final Integer PAGE_SIZE = 8;
    private Integer pageNo;
    private Integer pageTotal;
    private Integer pageSize = PAGE_SIZE;
    private Integer pageTotalCount;
    private List<User> items;
    private String url;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public UserPage() {
    }

    public UserPage(Integer pageNo, Integer pageTotal, Integer pageSize, Integer pageTotalCount, List<User> items) {
        this.pageNo = pageNo;
        this.pageTotal = pageTotal;
        this.pageSize = pageSize;
        this.pageTotalCount = pageTotalCount;
        this.items = items;
    }

    public Integer getPageNo() {
        return pageNo;
    }

    public void setPageNo(Integer pageNo) {
        this.pageNo = pageNo;
    }

    public Integer getPageTotal() {
        return pageTotal;
    }

    public void setPageTotal(Integer pageTotal) {
        this.pageTotal = pageTotal;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public Integer getPageTotalCount() {
        return pageTotalCount;
    }

    public void setPageTotalCount(Integer pageTotalCount) {
        this.pageTotalCount = pageTotalCount;
    }

    public List<User> getItems() {
        return items;
    }

    public void setItems(List<User> items) {
        this.items = items;
    }
}
