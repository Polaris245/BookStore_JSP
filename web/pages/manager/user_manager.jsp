<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <%@ include file="/pages/common/head.jsp"%>
    <style>
        th, td{
            text-align: center;
            vertical-align: middle;
        }
        .delete_btn, .change_btn{
            background-color: #d2515d;
            border-color: #d2515d;
        }
        .delete_btn:hover, .change_btn:hover{
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .modal-footer{
            justify-content: center;
        }
    </style>
    <script>
        function deleteUser(username){
            $("#delete_name").text(username);
            $("#username").val(username);
            $("#pageNo").val(${requestScope.page.pageNo});
        }
        function change(username, status)
        {
            $("#pageNo1").val(${requestScope.page.pageNo});
            $("#username1").val(username);
            $("#motive").val(status);
        }
    </script>
</head>
<body>
<div id="header">
    <img class="logo_img" alt="" src="static/img/book3.jpg" style="width: 328px; height: 100px" >
    <span class="wel_word" style="color: #58ab7f">用户管理</span>
    <div class="nav">
        <li><a href="manager/book?action=page">图书管理</a></li>
        <li><a href="manager/order?action=managerPage">订单管理</a></li>
        <li><a href="index.jsp">返回首页</a><li>
    </div>
</div>
<hr style="width: 80%; margin: 0 auto 0"/>
<div id="main">
    <table class="table">
        <thead>
        <tr>
            <th scope="col">用户名</th>
            <th scope="col">邮箱</th>
            <th scope="col">角色</th>
            <c:if test="${sessionScope.user.username == 'admin'}">
                <th scope="col" colspan="2">操作</th>
            </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${requestScope.page.items}" var="entry">
            <tr>
                <th scope="row">${entry.username}</th>
                <td>${entry.email}</td>
                <td>
                    <c:if test="${entry.isAdmin}">
                        管理员
                    </c:if>
                    <c:if test="${!entry.isAdmin}">
                       普通用户
                    </c:if>
                </td>
                <td>
                    <c:if test="${entry.isAdmin && sessionScope.user.username == 'admin'}">
                        <button type="button" class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#changeAdmin" onclick="change('${entry.username}', 1)">取消管理员</button>
                    </c:if>
                    <c:if test="${!entry.isAdmin && sessionScope.user.username == 'admin'}">
                        <button type="button" class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#changeAdmin" onclick="change('${entry.username}', 0)">设为管理员</button>
                    </c:if>
                </td>
                <td>
                    <c:if test="${sessionScope.user.username == 'admin'}">
                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#delete" onclick="deleteUser('${entry.username}')">删除</button>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<div class="modal fade" id="delete" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel2">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="manager/user">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="username" value="" id="username">
                <input type="hidden" name="pageNo" value="" id="pageNo">
                <div class="modal-body" style="text-align: center">
                    您确定要删除<span style="color: #dc3545" id="delete_name"></span>这个用户吗？
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary delete_btn">确定删除</button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="modal fade" id="changeAdmin" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel1">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="manager/user">
                <input type="hidden" name="action" value="changeAdmin">
                <input type="hidden" name="username" value="" id="username1">
                <input type="hidden" name="motive" value="" id="motive">
                <input type="hidden" name="pageNo" value="" id="pageNo1">
                <div class="modal-body" style="text-align: center">
                    您确定要改变这个用户的权限吗？
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary change_btn">确定修改</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@include file="/pages/common/page_nav.jsp"%>
<script src="static/script/index.js"></script>
</body>
</html>
