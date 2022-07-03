<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String s = request.getRequestURI();
    int a = s.lastIndexOf("/");
    String path = s.substring(a+1);
%>
<c:set var="path" value="<%=path%>" scope="page"></c:set>
<div id="header">
    <img class="logo_img" alt="" src="static/img/book3.jpg" style="width: 328px; height: 100px" >
<%--    <span class="wel_word" style="color: #79bd9a">网上书城</span>--%>
    <div class="nav">
        <c:if test="${empty sessionScope.user}">
            <li><a href="pages/user/login.jsp">登录</a></li>
        </c:if>
        <c:if test="${not empty sessionScope.user}">
            <c:if test= "${pageScope.path != 'user.jsp'}">
                <li><a href="pages/client/user.jsp">${sessionScope.user.username}</a> </li>
            </c:if>
        </c:if>
        <c:if test= "${pageScope.path != 'cart.jsp'}">
            <li><a href="pages/cart/cart.jsp">购物车</a></li>
        </c:if>
        <c:if test="${not empty sessionScope.user}">
            <c:if test="${pageScope.path != 'order.jsp'}">
                <li><a href="client/order?action=orderPage&username=${sessionScope.user.username}">我的订单</a></li>
            </c:if>
            <c:if test="${sessionScope.user.isAdmin}">
                <li><a href="pages/manager/manager.jsp">后台管理</a></li>
            </c:if>
            <li><a href="user?action=logout">注销</a></li>
        </c:if>
        <li><a href="index.jsp">首页</a><li>
    </div>
</div>
<hr style="width: 80%; margin: 0 auto 0"/>
