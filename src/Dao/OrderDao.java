package Dao;

import pojo.Order;
import pojo.OrderPage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    private Connection connection;
    private PreparedStatement statement;
    private Statement statement1;
    private ResultSet resultSet;

    public int insert(Order order) {
        try {
            connection = DBUtils.conn.get();
            if (connection == null) {
                connection = DBUtils.getConnection();
                DBUtils.conn.set(connection);
                connection.setAutoCommit(false);
            }
            statement = connection.prepareStatement("insert into order_info values (?,?,?,?,?)");
            statement.setString(1, order.getOrderId());
            statement.setTimestamp(2, (Timestamp) order.getCreateTime());
            statement.setBigDecimal(3, order.getPrice());
            statement.setInt(4, order.getStatus());
            statement.setString(5, order.getUserId());
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } finally {
            DBUtils.close(null, statement, null);
        }
    }

    public OrderPage page(OrderPage orderPage, int begin, String username) {
        List<Order> items = new ArrayList<>();
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select * from order_info where user_id = ? order by create_time DESC limit ? offset ?");
            statement.setString(1, username);
            statement.setInt(3, begin);
            statement.setInt(2, orderPage.getPageSize());
            resultSet = statement.executeQuery();
            while (resultSet.next())
                items.add(new Order(resultSet.getString(1), resultSet.getTimestamp(2), resultSet.getBigDecimal(3), resultSet.getInt(4), resultSet.getString(5)));
            orderPage.setItems(items);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, resultSet);
        }
        return orderPage;
    }

    public int pageCount(String username) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select count(*) from order_info where user_id  = ?");
            statement.setString(1, username);
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

    public int delete(String order_id) {
        try {
            connection = DBUtils.conn.get();
            if (connection == null) {
                connection = DBUtils.getConnection();
                DBUtils.conn.set(connection);
                connection.setAutoCommit(false);
            }
            statement = connection.prepareStatement("delete from order_info where order_id  = ?");
            statement.setString(1, order_id);
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } finally {
            DBUtils.close(null, statement, null);
        }
    }

    public OrderPage managerPage(OrderPage orderPage, int begin) {
        List<Order> items = new ArrayList<>();
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select * from order_info order by create_time DESC limit ? offset ?");
            statement.setInt(2, begin);
            statement.setInt(1, orderPage.getPageSize());
            resultSet = statement.executeQuery();
            while (resultSet.next())
                items.add(new Order(resultSet.getString(1), resultSet.getTimestamp(2), resultSet.getBigDecimal(3), resultSet.getInt(4), resultSet.getString(5)));
            orderPage.setItems(items);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, resultSet);
        }
        return orderPage;
    }

    public int managerPageCount() {
        try {
            connection = DBUtils.getConnection();
            statement1 = connection.createStatement();
            resultSet = statement1.executeQuery("select count(*) from order_info");
            resultSet.next();
            return resultSet.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement1, resultSet);
        }
        return 0;
    }

    public int updateStatus(String order_id) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("update order_info set status = 1 where order_id = ?");
            statement.setString(1, order_id);
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, resultSet);
        }
        return 0;
    }
}
