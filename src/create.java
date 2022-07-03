import java.sql.*;

public class create {
    public static void main(String[] args) throws Exception {
        Class.forName("org.sqlite.JDBC");
        Connection connection = DriverManager.getConnection("jdbc:sqlite://D:/bookstore.db");
        Statement statement = connection.createStatement();
//        String sql = "insert into userinfo values('admin', 'admin', 'admin@qq.com', 1)";
//        String create = "create table order_item(id integer primary key autoincrement, name varchar(40), count int, price numeric(10,2), total_price numeric(10,2), order_id varchar(20) ,FOREIGN KEY (order_id) REFERENCES order_info(order_id))";
//        statement.execute(create);
//        System.out.println(System.getProperty("user.dir"));
        String search = "select * from order_info";
//        PreparedStatement statement1 = connection.prepareStatement("");
//        statement1.setDate(1, new Date(System.currentTimeMillis()));
//        System.out.println("执行\n"+statement.executeUpdate(sql));
        ResultSet resultSet = statement.executeQuery(search);
        while (resultSet.next()) {
            System.out.print(resultSet.getString(1) + "  ");
            System.out.print(resultSet.getDate(2) + "  ");
            System.out.print(resultSet.getInt(3) + "  ");
            System.out.print(resultSet.getBigDecimal(4) + "  ");
            System.out.print(resultSet.getInt(5) + "  ");
        }
    }
}
