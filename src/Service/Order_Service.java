package Service;

import pojo.Cart;
import pojo.ItemsPage;
import pojo.OrderPage;

public interface Order_Service {
    String createOrder(Cart cart, String id);

    OrderPage page(int pageNo, int pageSize, String username);

    ItemsPage itemsPage(int pageNo, int pageSize, String order_id);

    boolean deleteOrder(String order_id);

    OrderPage managerPage(int pageNo, int pageSize);

    int updateStatus(String order_id);
}
