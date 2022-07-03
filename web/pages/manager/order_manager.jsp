<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>订单管理</title>
	<%@ include file="/pages/common/head.jsp"%>
	<style>
		th, td{
			text-align: center;
			vertical-align: middle;
		}
		.delete_btn, .deliver_btn{
			background-color: #d2515d;
			border-color: #d2515d;
		}
		.delete_btn:hover, .deliver_btn:hover{
			background-color: #dc3545;
			border-color: #dc3545;
		}
		.modal-footer{
			justify-content: center;
		}
	</style>
	<script>
		function viewItems(id){
			$(location).attr("href", "manager/order?action=viewItems&order_id=" + id);
		}
		function deliver(id){
			$("#order_id1").val(id);
			$("#pageNo1").val(${requestScope.page.pageNo});
		}
		function deleteOrder(id){
			$("#order_id2").val(id);
			$("#pageNo2").val(${requestScope.page.pageNo});
		}
	</script>
</head>
<body>
	<div id="header">
		<img class="logo_img" alt="" src="static/img/book3.jpg" style="width: 328px; height: 100px" >
		<span class="wel_word" style="color: #58ab7f">订单管理</span>
		<div class="nav">
			<li><a href="manager/user?action=userPage">用户管理</a></li>
			<li><a href="manager/book?action=page">图书管理</a></li>
<%--			<li><a href="pages/manager/order_manager.jsp">订单管理</a></li>--%>
			<li><a href="index.jsp">返回首页</a><li>
		</div>
	</div>
	<hr style="width: 80%; margin: 0 auto 0"/>
	<div id="main">
		<table class="table">
			<thead>
			<tr>
				<th scope="col">订单号</th>
				<th scope="col">订单日期</th>
				<th scope="col">所属用户</th>
				<th scope="col">金额</th>
				<th scope="col" colspan="3">操作</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${requestScope.page.items}" var="entry">
				<tr>
					<th scope="row">${entry.orderId}</th>
					<td>${entry.createTime}</td>
					<td>${entry.userId}</td>
					<td>${entry.price}</td>
					<td><button type="button" class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#search" onclick="viewItems('${entry.orderId}')">查看详情</button></td>
					<td>
						<c:if test="${entry.status == 1}">
							已发货
						</c:if>
						<c:if test="${entry.status == 0}">
							<button type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#deliver" onclick="deliver('${entry.orderId}')">发货</button>
						</c:if>
					</td>
					<td><button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#delete" onclick="deleteOrder('${entry.orderId}')">删除</button></td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
	<div class="modal fade" id="deliver" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel1">提示</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<form method="get" action="manager/order">
					<input type="hidden" name="action" value="updateStatus">
					<input type="hidden" name="order_id" value="" id="order_id1">
					<input type="hidden" name="pageNo" value="" id="pageNo1">
					<div class="modal-body" style="text-align: center">
						您确定要将这个订单状态修改为已发货吗？
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
						<button type="submit" class="btn btn-primary deliver_btn">确定发货</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="modal fade" id="delete" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel2">提示</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<form method="get" action="manager/order">
					<input type="hidden" name="action" value="managerDeleteOrder">
					<input type="hidden" name="order_id" value="" id="order_id2">
					<input type="hidden" name="pageNo" value="" id="pageNo2">
					<div class="modal-body" style="text-align: center">
						您确定要删除这个订单吗？
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
						<button type="submit" class="btn btn-primary delete_btn">确定删除</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<%@include file="/pages/common/page_nav.jsp"%>
	<script src="static/script/index.js"></script>
</body>
</html>