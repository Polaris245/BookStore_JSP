package Service.impl;

import Dao.OrderDao;
import Dao.OrderItemDao;
import Service.Book_Service;
import Service.Order_Service;
import pojo.*;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Map;

public class Order_Service_impl implements Order_Service {
    private Book_Service book_service = new Book_Service_impl();
    private OrderDao orderDao = new OrderDao();
    private OrderItemDao orderItemDao = new OrderItemDao();

    @Override
    public String createOrder(Cart cart, String userId) {
        String orderId = System.currentTimeMillis() + "" + userId;
        Timestamp date = new Timestamp(Calendar.getInstance().getTime().getTime());
        Order order = new Order(orderId, date, cart.getTotalPrice(), 0, userId);
        orderDao.insert(order);
        for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
            CartItem cartItem = entry.getValue();
            OrderItem orderItem = new OrderItem(null, cartItem.getName(), cartItem.getCount(), cartItem.getPrice(), cartItem.getTotalPrice(), orderId);
            Book book = book_service.searchById(cartItem.getId());
            int num = book.getStock() - cartItem.getCount();
            if (num >= 0) {
                book.setSales(book.getSales() + cartItem.getCount());
                book.setStock(num);
                book_service.update(book);
                orderItemDao.insert(orderItem);
            } else
                return null;
        }
        cart.clear();
        return orderId;
    }

    @Override
    public OrderPage page(int pageNo, int pageSize, String username) {
        Integer pageTotalCount, pageTotal, begin;
        OrderPage orderPage = new OrderPage();
        orderPage.setPageSize(pageSize);
        pageTotalCount = orderDao.pageCount(username);
        orderPage.setPageTotalCount(pageTotalCount);
        pageTotal = pageTotalCount / pageSize;
        if (pageTotalCount % pageSize > 0)
            pageTotal += 1;
        orderPage.setPageTotal(pageTotal);
        if (pageNo > pageTotal)
            pageNo = pageTotal;
        orderPage.setPageNo(pageNo);
        begin = (pageNo - 1) * pageSize;
        return orderDao.page(orderPage, begin, username);
    }

    @Override
    public ItemsPage itemsPage(int pageNo, int pageSize, String order_id) {
        Integer pageTotalCount, pageTotal, begin;
        ItemsPage itemPage = new ItemsPage();
        itemPage.setPageSize(pageSize);
        pageTotalCount = orderItemDao.pageCount(order_id);
        itemPage.setPageTotalCount(pageTotalCount);
        pageTotal = pageTotalCount / pageSize;
        if (pageTotalCount % pageSize > 0)
            pageTotal += 1;
        itemPage.setPageTotal(pageTotal);
        if (pageNo > pageTotal)
            pageNo = pageTotal;
        itemPage.setPageNo(pageNo);
        begin = (pageNo - 1) * pageSize;
        return orderItemDao.page(itemPage, begin, order_id);
    }

    @Override
    public boolean deleteOrder(String order_id) {
        if (orderItemDao.delete(order_id) != 0) {
            return orderDao.delete(order_id) != 0;
        } else
            return false;
    }

    @Override
    public OrderPage managerPage(int pageNo, int pageSize) {
        Integer pageTotalCount, pageTotal, begin;
        OrderPage orderPage = new OrderPage();
        orderPage.setPageSize(pageSize);
        pageTotalCount = orderDao.managerPageCount();
        orderPage.setPageTotalCount(pageTotalCount);
        pageTotal = pageTotalCount / pageSize;
        if (pageTotalCount % pageSize > 0)
            pageTotal += 1;
        orderPage.setPageTotal(pageTotal);
        if (pageNo > pageTotal)
            pageNo = pageTotal;
        orderPage.setPageNo(pageNo);
        begin = (pageNo - 1) * pageSize;
        return orderDao.managerPage(orderPage, begin);
    }

    @Override
    public int updateStatus(String order_id) {
        return orderDao.updateStatus(order_id);
    }
}
