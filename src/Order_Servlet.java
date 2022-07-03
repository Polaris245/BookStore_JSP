import Dao.DBUtils;
import Service.Order_Service;
import Service.impl.Order_Service_impl;
import pojo.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

public class Order_Servlet extends Servlet {
    private Order_Service order_service = new Order_Service_impl();

    public void createOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Cart cart = (Cart) req.getSession().getAttribute("cart");
        User user = (User) req.getSession().getAttribute("user");
        String orderId = null;
        if (user == null) {
            req.getRequestDispatcher("/pages/user/login.jsp").forward(req, resp);
            return;
        }
        String userId = user.getUsername();
        try {
            orderId = order_service.createOrder(cart, userId);
            if (orderId == null)
                DBUtils.rollbackAndClose();
            else
                DBUtils.commitAndClose();
        } catch (Exception e) {
            DBUtils.rollbackAndClose();
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        req.getSession().setAttribute("orderId", orderId);
        resp.sendRedirect(req.getContextPath() + "/pages/cart/checkout.jsp");
    }

    public void orderPage(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int pageNo = 1, pageSize = OrderPage.PAGE_SIZE;
        String username = req.getParameter("username");
        String str = req.getParameter("pageNo");
        try {
            if (str != null)
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            OrderPage orderPage = order_service.page(pageNo, pageSize, username);
            orderPage.setUrl("client/order?action=orderPage&username=" + username);
            req.setAttribute("page", orderPage);
            req.getRequestDispatcher("/pages/order/order.jsp").forward(req, resp);
        }
    }

    public void viewItems(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int pageNo = 1, pageSize = ItemsPage.PAGE_SIZE;
        String order_id = req.getParameter("order_id");
        String str = req.getParameter("pageNo");
        try {
            if (str != null && !str.equals(""))
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            ItemsPage itemsPage = order_service.itemsPage(pageNo, pageSize, order_id);
            itemsPage.setUrl("client/order?action=viewItems&order_id=" + order_id);
            req.setAttribute("page", itemsPage);
            req.getRequestDispatcher("/pages/order/orderItems.jsp").forward(req, resp);
        }
    }

    public void deleteOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String order_id = req.getParameter("order_id");
        String username = req.getParameter("username");
        try {
            if (order_service.deleteOrder(order_id))
                DBUtils.commitAndClose();
            else
                DBUtils.rollbackAndClose();
        } catch (Exception e) {
            DBUtils.rollbackAndClose();
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/client/order?action=orderPage&pageNo=" + req.getParameter("pageNo") + "&username=" + username);
    }

    public void managerPage(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int pageNo = 1, pageSize = OrderPage.PAGE_SIZE;
        String str = req.getParameter("pageNo");
        try {
            if (str != null)
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            OrderPage orderPage = order_service.managerPage(pageNo, pageSize);
            orderPage.setUrl("manager/order?action=managerPage");
            req.setAttribute("page", orderPage);
            req.getRequestDispatcher("/pages/manager/order_manager.jsp").forward(req, resp);
        }
    }

    public void managerViewItems(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int pageNo = 1, pageSize = OrderPage.PAGE_SIZE;
        String order_id = req.getParameter("order_id");
        String str = req.getParameter("pageNo");
        try {
            if (str != null)
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            ItemsPage itemsPage = order_service.itemsPage(pageNo, pageSize, order_id);
            itemsPage.setUrl("manager/order?action=viewItems&order_id=" + order_id);
            req.setAttribute("page", itemsPage);
            req.getRequestDispatcher("/pages/order/orderItems.jsp").forward(req, resp);
        }
    }

    public void updateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String order_id = req.getParameter("order_id");
        order_service.updateStatus(order_id);
        resp.sendRedirect(req.getContextPath() + "/manager/order?action=managerPage&pageNo=" + req.getParameter("pageNo"));
    }

    public void managerDeleteOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String order_id = req.getParameter("order_id");
        try {
            if (order_service.deleteOrder(order_id))
                DBUtils.commitAndClose();
            else
                DBUtils.rollbackAndClose();
        } catch (Exception e) {
            DBUtils.rollbackAndClose();
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/manager/order?action=managerPage&pageNo=" + req.getParameter("pageNo"));
    }
}
