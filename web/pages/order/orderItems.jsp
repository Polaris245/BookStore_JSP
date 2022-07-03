<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单详情</title>
    <%@ include file="/pages/common/head.jsp"%>
    <style>
        th, td{
            text-align: center;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<%@ include file="/pages/common/header.jsp"%>
<div id="main">
    <table class="table">
        <thead>
        <tr>
            <th scope="col">编号</th>
            <th scope="col">名称</th>
            <th scope="col">数量</th>
            <th scope="col">单价</th>
            <th scope="col">总金额</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${requestScope.page.items}" var="entry" varStatus="entryStatus">
            <tr>
                <th scope="row">${entryStatus.count}</th>
                <td>${entry.name}</td>
                <td>${entry.count}</td>
                <td>${entry.price}</td>
                <td>${entry.totalPrice}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@include file="/pages/common/page_nav.jsp"%>
<script src="static/script/index.js"></script>
</body>
</html>
