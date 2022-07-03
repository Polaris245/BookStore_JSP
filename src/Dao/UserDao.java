package Dao;

import pojo.User;
import pojo.UserPage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    private Connection connection;
    private PreparedStatement statement;
    private ResultSet resultSet;

    /**
     * @return true表示登录成功，false表示登陆失败
     */
    public User login(String username, String pwd) {
        User user = null;
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select * from userinfo where username = ?");
            statement.setString(1, username);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                if (username.equals(resultSet.getString(1)) && pwd.equals(resultSet.getString(2))) {
                    user = new User();
                    statement = connection.prepareStatement("select email, isadmin from userinfo where username = ?");
                    statement.setString(1, username);
                    resultSet = statement.executeQuery();
                    resultSet.next();
                    user.setUsername(username);
                    user.setPassword(pwd);
                    user.setEmail(resultSet.getString(1));
                    user.setIsAdmin(resultSet.getBoolean(2));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, resultSet);
        }
        return user;
    }

    /**
     * @return 1表示注册成功，0表示注册失败
     */
    public int insert(String username, String pwd, String email, Boolean isAdmin) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("insert into userinfo values (?,?,?,?)");
            statement.setString(1, username);
            statement.setString(2, pwd);
            statement.setString(3, email);
            statement.setBoolean(4, isAdmin);
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, null);
        }
        return 0;
    }

    /**
     * @return true表示用户名已存在
     */
    public boolean existUser(String username) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select username from userinfo where username = ?");
            statement.setString(1, username);
            resultSet = statement.executeQuery();
            return resultSet.next();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, resultSet);
        }
        return false;
    }

    public UserPage page(UserPage page, int begin) {
        List<User> items = new ArrayList<>();
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select * from userinfo where username != 'admin' limit ? offset ?");
            statement.setInt(2, begin);
            statement.setInt(1, page.getPageSize());
            resultSet = statement.executeQuery();
            while (resultSet.next())
                items.add(new User(resultSet.getString(1), null, resultSet.getString(3), resultSet.getBoolean(4)));
            page.setItems(items);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, resultSet);
        }
        return page;
    }

    public int pageCount() {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select count(*) from userinfo where username != 'admin'");
            resultSet = statement.executeQuery();
            resultSet.next();
            return resultSet.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, resultSet);
        }
        return 0;
    }

    public int setAdmin(String username) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("update userinfo set isadmin = 1 where username = ?");
            statement.setString(1, username);
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, null);
        }
        return 0;
    }

    public int cancelAdmin(String username) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("update userinfo set isadmin = 0 where username = ?");
            statement.setString(1, username);
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, null);
        }
        return 0;
    }

    public int delete(String username) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("delete from userinfo where username = ?");
            statement.setString(1, username);
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, null);
        }
        return 0;
    }

    public int update(User user) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("update userinfo set password = ?, email = ? where username = ?");
            statement.setString(1, user.getPassword());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getUsername());
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, null);
        }
        return 0;
    }

    /*public User searchByName(String username)
    {
        try
        {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select * userinfo where username = ?");
            statement.setString(1, username);
            resultSet = statement.executeQuery();
            resultSet.next();
            return new User(resultSet.getString(1), null, resultSet.getString(3), resultSet.getBoolean(4));
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection,statement,resultSet);
        }
        return null;
    }*/
}
