package Service;

import pojo.User;
import pojo.UserPage;

public interface User_Service {
    void register(String username, String password, String email, Boolean isAdmin);

    User login(String username, String password);

    boolean existUser(String username);

    UserPage userpage(int pageNo, int pageSize);

    int setAdmin(String username);

    int delete(String username);

    int cancelAdmin(String username);

    int update(User user);

//    User search(String username);
}
