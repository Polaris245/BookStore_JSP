package Service.impl;

import Dao.UserDao;
import Service.User_Service;
import pojo.Page;
import pojo.User;
import pojo.UserPage;

public class User_Service_impl implements User_Service {
    private UserDao userDao = new UserDao();

    @Override
    public void register(String username, String password, String email, Boolean isAdmin) {
        userDao.insert(username, password, email, isAdmin);
    }

    @Override
    public User login(String username, String password) {
        return userDao.login(username, password);
    }

    @Override
    public boolean existUser(String username) {
        return userDao.existUser(username);
    }

    @Override
    public UserPage userpage(int pageNo, int pageSize) {
        Integer pageTotalCount, pageTotal, begin;
        UserPage userPage = new UserPage();
        userPage.setPageSize(pageSize);
        pageTotalCount = userDao.pageCount();
        userPage.setPageTotalCount(pageTotalCount);
        pageTotal = pageTotalCount / pageSize;
        if (pageTotalCount % pageSize > 0)
            pageTotal += 1;
        userPage.setPageTotal(pageTotal);
        if (pageNo > pageTotal)
            pageNo = pageTotal;
        userPage.setPageNo(pageNo);
        begin = (pageNo - 1) * pageSize;
        return userDao.page(userPage, begin);
    }

    @Override
    public int setAdmin(String username) {
        return userDao.setAdmin(username);
    }

    @Override
    public int delete(String username) {
        return userDao.delete(username);
    }

    @Override
    public int cancelAdmin(String username) {
        return userDao.cancelAdmin(username);
    }

    @Override
    public int update(User user) {
        return userDao.update(user);
    }

    /*@Override
    public User search(String username) {
        return userDao.searchByName(username);
    }*/
}
