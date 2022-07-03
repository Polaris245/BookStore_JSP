<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()
            + "://"
            + request.getServerName()
            + ":"
            + request.getServerPort()
            + request.getContextPath()
            + "/";
%>

<base href="<%=basePath%>">
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <link rel="stylesheet" href="static/css/login.css">
    <link rel="shortcut icon" href="static/img/book.svg">
    <script type="text/javascript" src="static/script/jquery-1.7.2.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#username").blur(function (){
                var usernameText = this.value;
                var usernamePatt = /^\w{5,12}$/;
                if (usernameText == "")
                {
                    $(".error_msg").text("用户名不能为空");
                }
                else if (!usernamePatt.test(usernameText)) {
                    $(".error_msg").text("请输入5-12位字母或数字");
                }
                else
                {	//使用ajax动态判断用户名是否存在
                    $.getJSON("user","action=existUser&username="+usernameText,function (data){
                        if (data.exist)
                            $(".error_msg").text("用户名已存在");
                        else
                            $(".error_msg").text("用户名可用");
                    });
                }
            });
            $("#code_img").click(function (){
                this.src = "kaptcha.jpg?d="+new Date().getTime();//加时间戳防止缓存导致验证码不变
            });
            $("#password").blur(function (){
                var passwordText = $("#password").val();
                var passwordPatt = /^\w{5,12}$/;
                if (passwordText != "" && !passwordPatt.test(passwordText)) {
                    $(".error_msg").text("请输入5-12位字母或数字");
                }
            });
            $("#repwd").blur(function (){
                var repwdText = $("#repwd").val();
                var passwordText = $("#password").val();
                if (repwdText != passwordText) {
                    $(".error_msg").text("确认密码和密码不一致！");
                }
                else
                    $(".error_msg").text("");
            });

            $("#sub_btn").click(function () {
                var usernameText = $("#username").val();
                var usernamePatt = /^\w{5,12}$/;
                if (!usernamePatt.test(usernameText)) {
                    $(".error_msg").text("用户名不合法！");
                    return false;
                }
                else
                {
                    var flag = false;
                    $.ajaxSettings.async = false;
                    $.getJSON("user","action=existUser&username="+usernameText,function (data){
                        if (data.exist)
                        {
                            $(".error_msg").text("用户名已存在");
                            flag = true;
                        }
                    });
                    $.ajaxSettings.async = true;
                    if (flag)
                    {
                        return false;
                    }
                }

                var passwordText = $("#password").val();
                var passwordPatt = /^\w{5,12}$/;
                if (!passwordPatt.test(passwordText)) {
                    $(".error_msg").text("密码不合法！");
                    return false;
                }

                var repwdText = $("#repwd").val();
                if (repwdText != passwordText) {
                    $(".error_msg").text("确认密码和密码不一致！");
                    return false;
                }

                var emailText = $("#email").val();
                var emailPatt = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
                if (!emailPatt.test(emailText)) {
                    $(".error_msg").text("邮箱格式不合法！");
                    return false;
                }

                var codeText = $("#code").val();
                if (codeText == "")
                {
                    $(".error_msg").text("验证码不能为空！");
                    return false;
                }
                else
                {
                    var flag2 = false;
                    $.ajaxSettings.async = false;
                    $.getJSON("user","action=codeVerify&code="+codeText,function (data){
                        if (!data.codeVerify)
                        {
                            $(".error_msg").text("验证码错误");
                            flag2 = true;
                        }
                    });
                    $.ajaxSettings.async = true;
                    if (flag2)
                        return false;
                }
                $(".error_msg").text("");
            });
        });
    </script>
</head>
<body>
<div class="container">
    <div class="login-box">
        <h2 class="login-title">
            <span>已有账号，去</span>登录
        </h2>
        <div class="error_msg">
            ${requestScope.msg }
        </div>
        <form action="user" method="post">
            <input type="hidden" name="action" value="login">
            <div class="input-box">
                <input type="text" placeholder="用户名" name="username">
                <input type="password" placeholder="密码" name="password">
            </div>
            <button type="submit" >登录</button>
        </form>
    </div>
    <div class="register-box slide-up">
        <div class="center">
            <h2 class="register-title">
                <span>没有账号，去</span>注册
            </h2>
            <div class="error_msg">
                ${ requestScope.msg }
            </div>
            <form action="user" method="post">
                <input type="hidden" name="action" value="register" />
                <div class="input-box">
                    <input type="text" placeholder="用户名" name="username" id="username">
                    <input type="password" placeholder="密码" name="password" id="password">
                    <input type="password" placeholder="确认密码" id="repwd">
                    <input type="text" placeholder="邮箱" name="email" id="email">
                    <input type="text" placeholder="验证码" name="code" style="width: 140px;border:0" id="code">
                    <img id="code_img" alt="" src="kaptcha.jpg" style="float: right; margin-right: 20px; width: 80px; height: 30px; padding-top: 8px; padding-bottom: 8px">
                </div>
                <button type="submit" id="sub_btn">注册</button>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript" src="static/script/login.js"></script>
</body>
</html>