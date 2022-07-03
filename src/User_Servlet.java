import Service.User_Service;
import Service.impl.User_Service_impl;
import com.google.gson.Gson;
import org.apache.commons.beanutils.BeanUtils;
import pojo.OrderPage;
import pojo.User;
import pojo.UserPage;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import static com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY;

public class User_Servlet extends Servlet {
    private User_Service user_service = new User_Service_impl();

    public void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        User user = user_service.login(username, password);
        if (user != null) {
            req.getSession().setAttribute("user", user);
            resp.sendRedirect(req.getContextPath());
        } else {
            req.setAttribute("msg", "用户名或密码错误");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/pages/user/login.jsp").forward(req, resp);
        }
    }

    public void register(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String code = req.getParameter("code");
        String token = (String) req.getSession().getAttribute(KAPTCHA_SESSION_KEY);
        req.getSession().removeAttribute(KAPTCHA_SESSION_KEY);
        if (token.equals(code) && !user_service.existUser(username)) {
            user_service.register(username, password, email, false);
            User user = user_service.login(username, password);
            req.getSession().setAttribute("user", user);
            resp.sendRedirect(req.getContextPath());
        } else
            req.getRequestDispatcher("/pages/user/login.jsp").forward(req, resp);
    }

    public void logout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().invalidate();
        resp.sendRedirect(req.getContextPath());
    }

    public void existUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        boolean exist = user_service.existUser(username);
        Map<String, Object> result = new HashMap<>();
        result.put("exist", exist);
        Gson gson = new Gson();
        resp.getWriter().write(gson.toJson(result));
    }

    public void codeVerify(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code = req.getParameter("code");
        String token = (String) req.getSession().getAttribute(KAPTCHA_SESSION_KEY);
        Map<String, Object> result = new HashMap<>();
        if (code.equals(token))
            result.put("codeVerify", true);
        else
            result.put("codeVerify", false);
        Gson gson = new Gson();
        resp.getWriter().write(gson.toJson(result));
    }

    public void userPage(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int pageNo = 1, pageSize = OrderPage.PAGE_SIZE;
        String str = req.getParameter("pageNo");
        try {
            if (str != null && !str.equals(""))
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            UserPage userPage = user_service.userpage(pageNo, pageSize);
            userPage.setUrl("manager/user?action=userPage");
            req.setAttribute("page", userPage);
            req.getRequestDispatcher("/pages/manager/user_manager.jsp").forward(req, resp);
        }
    }

    public void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            int pageNo = Integer.parseInt(req.getParameter("pageNo"));
            String username = req.getParameter("username");
            user_service.delete(username);
            resp.sendRedirect(req.getContextPath() + "/manager/user?action=userPage&pageNo=" + pageNo);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/manager/user?action=userPage");
        }
    }

    public void changeAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int pageNo = Integer.parseInt(req.getParameter("pageNo"));
            String username = req.getParameter("username");
            int id = Integer.parseInt(req.getParameter("motive"));
            if (id == 0)
                user_service.setAdmin(username);
            else if (id == 1)
                user_service.cancelAdmin(username);
            resp.sendRedirect(req.getContextPath() + "/manager/user?action=userPage&pageNo=" + pageNo);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/manager/user?action=userPage");
        }
    }

    public void update(HttpServletRequest req, HttpServletResponse resp) throws InvocationTargetException, IllegalAccessException, IOException, ServletException {
        User user = new User();
        BeanUtils.populate(user, req.getParameterMap());
        user_service.update(user);
        req.setAttribute("msg", "更新成功，请重新登录哦");
        req.getRequestDispatcher("/pages/client/user.jsp").forward(req, resp);
    }

    /*public void userinfo(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException
    {
        String username = req.getParameter("username");
        User user = user_service.search(username);
        req.setAttribute("userinfo", user);
        req.getRequestDispatcher("/pages/client/user.jsp").forward(req, resp);
    }*/
}
