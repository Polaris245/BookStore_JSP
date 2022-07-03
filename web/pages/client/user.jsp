<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人中心</title>
    <%@ include file="/pages/common/head.jsp"%>
    <style>
        #main{
            width: 500px;
            text-align: center;
        }
        .modal-footer{
            justify-content: center;
        }
    </style>
    <script>
        function check(){
            var pwd = $("#inputPassword").val();
            var email = $("#inputEmail").val();
            var passwordPatt = /^\w{5,12}$/;
            var emailPatt = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
            if (!passwordPatt.test(pwd))
            {
                $(".modal-body").text("密码不合法哦，请输入5-12位字母或数字");
                $("#check_false").modal("toggle");
                return false;
            }
            else if (!emailPatt.test(email))
            {
                $(".modal-body").text("邮箱格式不正确哦，请检查输入");
                $("#check_false").modal("toggle");
                return false;
            }
            else
                return true;
        }
        function logout(){
            $(location).attr("href", "${basePath}client/user?action=logout");
        }
        <c:if test="${not empty requestScope.msg}">
        window.onload = function (){
            $("#msg").modal("toggle");
        }
        </c:if>
    </script>
</head>
<body>
<%@ include file="/pages/common/header.jsp"%>
<div id="main">
    <form method="post" action="client/user" onsubmit="return check()">
        <input name="action" value="update" type="hidden">
        <div class="mb-3 row">
            <label for="username" class="col-sm-2 col-form-label">用户名</label>
            <div class="col-sm-10">
                <input type="text" readonly class="form-control-plaintext" id="username" name="username" value="${sessionScope.user.username}">
            </div>
        </div>
        <div class="mb-3 row">
            <label for="inputPassword" class="col-sm-2 col-form-label">Password</label>
            <div class="col-sm-10">
                <input type="password" name="password" class="form-control" id="inputPassword" value="${sessionScope.user.password}">
            </div>
        </div>
        <div class="mb-3 row">
            <label for="inputEmail" class="col-sm-2 col-form-label">Email</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" name="email" id="inputEmail" value="${sessionScope.user.email}">
            </div>
        </div>
        <div class="mb-3 row">
            <label for="identity" class="col-sm-2 col-form-label">身份</label>
            <div class="col-sm-10">
                <c:if test="${sessionScope.user.isAdmin}">
                    <input type="text" readonly class="form-control-plaintext" name="isAdmin" id="identity" value="管理员">
                </c:if>
                <c:if test="${!sessionScope.user.isAdmin}">
                    <input type="text" readonly class="form-control-plaintext" name="isAdmin" id="identity" value="普通用户">
                </c:if>
            </div>
        </div>
        <button type="submit" class="btn btn-outline-warning">提交更改</button>
    </form>
</div>
<div class="modal fade" id="check_false" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel4">提示</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="text-align: center">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="msg" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">提示</h5>
            </div>
            <div class="modal-body" style="text-align: center">
                ${requestScope.msg}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="logout()">好的</button>
            </div>
        </div>
    </div>
</div>
<script src="static/script/index.js"></script>
</body>
</html>
