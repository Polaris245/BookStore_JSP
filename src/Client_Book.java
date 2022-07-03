import Service.Book_Service;
import Service.impl.Book_Service_impl;
import pojo.Book;
import pojo.Page;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class Client_Book extends Servlet {
    private Book_Service book_service = new Book_Service_impl();

    public void page(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pageNo = 1, pageSize = 9;
        String str = req.getParameter("pageNo");
        try {
            if (str != null && !str.equals(""))
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            Page page = book_service.page(pageNo, pageSize);
            page.setUrl("client/book?action=page");
            req.setAttribute("page", page);
            req.getRequestDispatcher("/pages/client/index.jsp").forward(req, resp);
        }
    }

    public void pageByPrice(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        double a = 0, b = Double.MAX_VALUE;
        Page page;
        int pageNo = 1, pageSize = 9;
        String str = req.getParameter("pageNo");
        try {
            if (str != null && !str.equals(""))
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
            str = req.getParameter("min");
            if (!str.equals(""))
                a = Double.parseDouble(str);
            str = req.getParameter("max");
            if (!str.equals(""))
                b = Double.parseDouble(str);
            if (a > b) {
                req.setAttribute("msg_info", "是不是输反了？帮你纠正了哦！");
                double temp = b;
                b = a;
                a = temp;
            }
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            page = book_service.pageByPrice(pageNo, pageSize, a, b);
            if (page.getPageTotal() == 0)
                req.setAttribute("msg_info", "没有找到任何结果哦");
            page.setUrl("client/book?action=pageByPrice&min=" + a + "&max=" + b);
            req.setAttribute("page", page);
            req.getRequestDispatcher("/pages/client/index.jsp").forward(req, resp);
        }
    }

    public void pageByName(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pageNo = 1, pageSize = 9;
        String str = req.getParameter("pageNo");
        String name = req.getParameter("name");
        try {
            if (str != null && !str.equals(""))
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            Page page = book_service.pageByName(pageNo, pageSize, name);
            if (page.getPageTotal() == 0)
                req.setAttribute("msg_info", "没有找到任何结果哦");
            page.setUrl("client/book?action=pageByName&name=" + name);
            req.setAttribute("page", page);
            req.getRequestDispatcher("/pages/client/index.jsp").forward(req, resp);
        }
    }

    public void bookDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Book book = book_service.searchById(id);
            req.setAttribute("book", book);
            req.getRequestDispatcher("/pages/client/detail.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath());
        }
    }
}
