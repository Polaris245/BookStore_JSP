<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="path" value="order" scope="page"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>我的订单</title>
	<%@ include file="/pages/common/head.jsp"%>
	<style>
		th, td{
			text-align: center;
			vertical-align: middle;
		}
		.delete_btn{
			background-color: #d2515d;
			border-color: #d2515d;
		}
		.delete_btn:hover{
			background-color: #dc3545;
			border-color: #dc3545;
		}
		.modal-footer{
			justify-content: center;
		}
	</style>
	<script>
		function viewItems(id){
			$(location).attr("href", "client/order?action=viewItems&order_id=" + id);
		}
		function deleteOrder(id, pageNo, username){
			$("#order_id").val(id);
			$("#pageNo").val(${requestScope.page.pageNo})
			$("#username").val('${param.username}')
		}
	</script>
</head>
<body>
<%@ include file="/pages/common/header.jsp"%>
	<div id="main">
		<table class="table">
			<thead>
			<tr>
				<th scope="col">订单编号</th>
				<th scope="col">创建时间</th>
				<th scope="col">金额</th>
				<th scope="col">状态</th>
				<th scope="col" colspan="2">操作</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${requestScope.page.items}" var="entry">
				<tr>
					<th scope="row">${entry.orderId}</th>
					<td>${entry.createTime}</td>
					<td>${entry.price}</td>
					<td>
						<c:if test="${entry.status == 0}">
							未发货
						</c:if>
						<c:if test="${entry.status == 1}">
							已发货
						</c:if>
					</td>
					<td><button type="button" class="btn btn-outline-warning" onclick="viewItems('${entry.orderId}')">查看详情</button></td>
					<td><button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#delete" onclick="deleteOrder('${entry.orderId}')">删除</button></td>
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
			<form method="get" action="client/order">
				<input type="hidden" name="action" value="deleteOrder">
				<input type="hidden" name="order_id" value="" id="order_id">
				<input type="hidden" name="pageNo" value="" id="pageNo">
				<input type="hidden" name="username" value="" id="username">
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