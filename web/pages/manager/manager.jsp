<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>后台管理</title>
	<%@ include file="/pages/common/head.jsp"%>
</head>
<body>
	<div id="header">
		<img class="logo_img" alt="" src="static/img/book3.jpg" style="width: 328px; height: 100px" >
		<span class="wel_word" style="color: #58ab7f">后台管理系统</span>
		<div class="nav">
			<li><a href="manager/user?action=userPage">用户管理</a></li>
			<li><a href="manager/book?action=page">图书管理</a></li>
			<li><a href="manager/order?action=managerPage">订单管理</a></li>
			<li><a href="index.jsp">返回首页</a><li>
		</div>
	</div>
	<hr style="width: 80%; margin: 0 auto 0"/>
	<div id="main" style="height: 600px; display: flex; justify-content: center; align-items: center">
		<div class="alert alert-success" role="alert" style="font-size: 20px">
			欢迎管理员进入后台管理系统
		</div>
	</div>
	<script src="static/script/index.js"></script>
</body>
</html>