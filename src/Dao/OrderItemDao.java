package Dao;

import pojo.ItemsPage;
import pojo.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDao {
    private Connection connection;
    private PreparedStatement statement;
    private ResultSet resultSet;

    public int insert(OrderItem orderItem) {
        try {
            connection = DBUtils.conn.get();
            if (connection == null) {
                connection = DBUtils.getConnection();
                DBUtils.conn.set(connection);
                connection.setAutoCommit(false);
            }
            statement = connection.prepareStatement("insert into order_item(name,count,price,total_price,order_id) values (?,?,?,?,?)");
            statement.setString(1, orderItem.getName());
            statement.setInt(2, orderItem.getCount());
            statement.setBigDecimal(3, orderItem.getPrice());
            statement.setBigDecimal(4, orderItem.getTotalPrice());
            statement.setString(5, orderItem.getOrderId());
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public ItemsPage page(ItemsPage itemPage, int begin, String order_id) {
        List<OrderItem> items = new ArrayList<>();
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select * from order_item where order_id = ? limit ? offset ?");
            statement.setString(1, order_id);
            statement.setInt(3, begin);
            statement.setInt(2, itemPage.getPageSize());
            resultSet = statement.executeQuery();
            while (resultSet.next())
                items.add(new OrderItem(resultSet.getInt(1), resultSet.getString(2), resultSet.getInt(3), resultSet.getBigDecimal(4), resultSet.getBigDecimal(5), resultSet.getString(6)));
            itemPage.setItems(items);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(connection, statement, resultSet);
        }
        return itemPage;
    }

    public int pageCount(String order_id) {
        try {
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("select count(*) from order_item where order_id = ?");
            statement.setString(1, order_id);
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
            statement = connection.prepareStatement("delete from order_item where order_id = ?");
            statement.setString(1, order_id);
            return statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } finally {
            DBUtils.close(null, statement, null);
        }
    }
}
